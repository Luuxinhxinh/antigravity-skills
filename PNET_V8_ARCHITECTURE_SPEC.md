# PNETLab v8 System Architecture Specification & Comparative Benchmark
> **Tài liệu đặc tả kiến trúc dành cho AI Agent phân tích & đối chiếu giữa PNETLab v6 và PNETLab v8.**

Tài liệu này cung cấp bản giải phẫu toàn diện về kiến trúc lõi ảo hóa (Virtualization Core), mô hình điều phối đặc quyền (Privilege Broker), hệ thống mạng cục bộ & phân tán (Networking & Cluster Fabric), cùng tầng giám sát gói tin (In-Kernel Telemetry) của **PNETLab v8 (Release 27H1 / Ubuntu Noble / Linux Kernel 6.8+)**. 

Agent trên môi trường PNETLab v6 hãy đối chiếu các thành phần, cấu trúc thư mục, luồng thực thi (execution pipeline) và API calls được mô tả dưới đây với mã nguồn thực tế tại hệ thống v6 của bạn.

---

## 1. Bản đồ tổng quan kiến trúc (High-Level Architecture Matrix)

| Tiêu chí | PNETLab v8 (Target Specification) | Điểm đối chiếu trên PNETLab v6 |
| :--- | :--- | :--- |
| **Mô hình Đặc quyền (Privilege Model)** | **B1 Privilege Broker Daemon (`pnetlab-brokerd`)** chạy root độc lập qua UNIX Domain Socket `/run/pnetlab/broker.sock`. Web server gọi JSON-RPC. Loại bỏ hoàn toàn việc gọi `sudo` tùy tiện. | Kiểm tra xem PHP/Web server có gọi trực tiếp `exec("sudo ...")` hoặc quyền `sudoers` của `www-data` hay không. |
| **Tối ưu hóa Bộ nhớ (Memory Overcommit)** | **Syscall `prctl(PR_SET_MEMORY_MERGE, 1)`** thông qua binary wrapper `ksm_merge_exec`. Tự động nén cả heap/JIT của QEMU bên cạnh guest RAM. | Kiểm tra xem KSM chỉ dựa vào UKSM/KSM daemon truyền thống hoặc cgroup hay đã có cờ `PR_SET_MEMORY_MERGE`. |
| **Console & Quản lý Phiên (Console Subsystem)** | QEMU xuất console ra UNIX socket (`console.sock`, `monitor.sock`). `qemu_wrapper_telnet` hook `nc -U`. Tích hợp WebConsole với WebSocket bridge bất đồng bộ (`telnet_ws_bridge.py` & `guacamole-lite-server.js`). | Kiểm tra xem QEMU có dùng cờ `-serial telnet:0.0.0.0:<port>` hoặc binary `qemu_wrapper` biên dịch C cũ hay không. |
| **Cơ chế Cụm Phân tán (Multi-Host Clustering)** | **TLS Agent daemon (`pnetlab-satd.py`)** chạy cổng 9050, xác thực HMAC-SHA256 chống replay bằng nonce. Đồng bộ Lab bằng rrsync SSH. | Kiểm tra xem tính năng cluster có tồn tại hay phụ thuộc vào NFS/SSH thủ công hoặc không hỗ trợ vệ tinh phân tán. |
| **Mạng Phân tán (Distributed Overlay Fabric)** | **VXLAN Head-End Replication (HER)** tự động cấu hình qua `verb_vxlan_attach`. Bơm FDB entry `00:00:00:00:00:00` vào thiết bị VXLAN nhân Linux. | Kiểm tra xem v6 kết nối cross-host bằng GRE/UDP tunnel cũ hay chỉ chạy độc lập đơn node. |
| **Giám sát & Telemetry (Packet Inspection)** | **cBPF (Classical BPF)** trong kernel (`pnetlab-linkwatchd.py` & `pnetlab-prototracer.py`) bắt gói BGP, OSPF, EIGRP, STP... Lưu telemetry counter vào RAM Disk (`/dev/shm/pnet-watch/`). | Kiểm tra xem v6 có tính năng live traffic watcher không, hay phải phụ thuộc vào lệnh `tcpdump` độc lập. |
| **Internal Lab Router** | **Linux Network Namespaces (`netns`)** tự động sinh gateway (`verb_router_create`), tích hợp `dnsmasq` và IP Masquerade cô lập. | Kiểm tra cách tạo Cloud/NAT network trên v6. |

---

## 2. Giải phẫu chi tiết từng tầng (Component Deep Dive)

### Tầng 1: Lõi điều phối Đặc quyền (B1 Privilege Broker)

* **Tệp nguồn chính:** 
  - Backend Daemon: `/opt/unetlab/scripts/pnetlab-brokerd.py`
  - Web Client: `/opt/unetlab/html/includes/broker.php`
  - Systemd Service: `pnetlab-brokerd.service`
* **Giao thức liên lạc:**
  - Socket: `unix:///run/pnetlab/broker.sock` (Quyền: `0660 root:www-data`).
  - Giao thức: JSON-RPC một request/response mỗi kết nối kết thúc bằng ký tự newline `\n`.
  - Định dạng gửi: `{"verb": "<action_name>", "args": { ... }}`
  - Định dạng nhận: `{"ok": true|false, "rc": 0, "out": [...], "err": "..."}`
* **Xác thực danh tính trong nhân (SO_PEERCRED):**
  ```python
  creds = self.connection.getsockopt(socket.SOL_SOCKET, socket.SO_PEERCRED, struct.calcsize("iii"))
  pid, uid, gid = struct.unpack("iii", creds)
  if uid not in (0, WWW_DATA_UID):
      raise Reject("DENY uid (not root/www-data)")
  ```
* **Danh mục hơn 60 Allowlisted Verbs (Không cho phép chạy lệnh tùy ý):**
  - Quản lý node: `wrapper`, `node_kill_workspace`, `node_unlock`, `config_reset`.
  - Mạng & VLAN: `net_create`, `net_delete`, `tap_delete`, `iface_vlan`, `iface_linkstate`, `netem_set`, `netem_del`.
  - Router ảo: `router_create`, `router_apply`, `router_get`, `router_delete`.
  - Cluster: `cluster_join`, `cluster_call`, `cluster_sync_lab`, `cluster_deploy`, `vxlan_attach`, `vxlan_detach`.
  - Telemetry: `linkwatch_start`, `linkwatch_snapshot`, `prototrace_start`, `prototrace_snapshot`.

---

### Tầng 2: Lõi Ảo hóa (Virtualization Hypervisor Core)

* **Tệp nguồn chính:** 
  - Lớp cơ sở: `/opt/unetlab/html/devices/device.php`
  - QEMU Hypervisor: `/opt/unetlab/html/devices/qemu/device_qemu.php`
  - KSM Optimization Wrapper: `/opt/unetlab/wrappers/ksm_merge_exec`
  - IOL Wrapper: `/opt/unetlab/wrappers/iol_wrapper`
  - Docker Wrapper: `/opt/unetlab/wrappers/docker_wrapper` & `nsenter`

#### A. QEMU Storage & Linked Clones
* Sử dụng cơ chế Copy-on-Write (COW) vi sai thông qua lệnh:
  ```bash
  /opt/qemu/bin/qemu-img create -b "<image_base_dir>/<file>.qcow2" -F qcow2 -f qcow2 "<node_runtime_dir>/<file>.qcow2"
  ```
* Các file đĩa tĩnh / ISO được gắn kết qua hardlink (`link`) thay vì sao chép toàn phần.

#### B. KSM Whole-Process Deduplication (`ksm_merge_exec`)
* Nhằm tối ưu dung lượng RAM khi chạy cùng lúc nhiều máy ảo nặng (Cisco IOS-XR, Arista vEOS, Nexus 9000v), mã nguồn v8 bổ sung wrapper `ksm_merge_exec`:
  ```python
  PR_SET_MEMORY_MERGE = 67 # linux/prctl.h
  libc = ctypes.CDLL("libc.so.6", use_errno=True)
  libc.prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0)
  os.execvp(sys.argv[1], sys.argv[1:])
  ```
* Syscall này kích hoạt cờ KSM trực tiếp trên tiến trình gọi và được kế thừa qua `execve()`, biến toàn bộ heap/anon memory của QEMU thành đối tượng được nhân Linux gộp bộ nhớ tự động.

#### C. QEMU Management & Monitor Socket
* Không chạy telnet trực tiếp trong cờ QEMU mà xuất ra Unix Domain Sockets:
  - `console.sock`: Console điều khiển của máy ảo.
  - `monitor.sock` / `monitor2.sock`: Điều khiển vòng đời phần cứng máy ảo.
* **Các trạng thái hỗ trợ:**
  - `freeze()`: Gửi `stop` hoặc `cont` vào `monitor2.sock` để dừng/chạy CPU tức thời.
  - `hibernate()`: Gửi `savevm pnet-snapshot` vào `monitor2.sock`. Khi khởi động lại tự động thêm cờ `-loadvm pnet-snapshot`.
  - `shutdown()`: Gửi tín hiệu ACPI `system_powerdown` an toàn vào `monitor.sock`.

---

### Tầng 3: Tầng Mạng & Fabric Phân tán (Networking & Cluster Fabric)

* **Tệp nguồn chính:**
  - Broker Verbs: `verb_net_create`, `verb_vxlan_attach`, `verb_router_create` trong `/opt/unetlab/scripts/pnetlab-brokerd.py`.
  - Cụm Vệ tinh Agent: `/opt/unetlab/scripts/pnetlab-satd.py`.

#### A. Datapath Cục bộ (Local L2 Datapath)
1. Card mạng của mỗi router là một giao diện Linux TAP: `vunl<session>_<interface_id>`.
2. Mạng kết nối trong lab là một Linux Bridge: `vnet<session>_<network_id>`.
3. Nhập card mạng vào bridge: `brctl addif vnet... vunl...` và kích hoạt `ip link set dev up`.

#### B. Datapath Đa Cụm (Multi-Host VXLAN Overlay Fabric)
1. Khi một mạng trải dài qua các máy chủ Master và Satellite:
   - Backend sinh thiết bị VXLAN độc lập: `vxlan<vni>`.
   - Cổng giao tiếp UDP: `4789`.
   - Gắn cờ Head-End Replication (HER) trực tiếp vào Forwarding Database (FDB) của nhân Linux:
     ```bash
     bridge fdb append 00:00:00:00:00:00 dev vxlan<vni> dst <remote_host_ip>
     ```
   - Nối interface `vxlan<vni>` vào Linux Bridge `vnet...`.
2. Giao thức điều phối Satellite (`pnetlab-satd`):
   - Chạy trên cổng TCP `9050` với mã hóa TLS.
   - Xác thực: Master gửi challenge nonce, tính `HMAC_SHA256(cluster_psk, nonce + "\n" + canonical_json(body))`. Không bao giờ truyền PSK qua mạng.

---

### Tầng 4: Tầng Giám sát Gói tin & Telemetry Trong Nhân (cBPF Telemetry)

* **Tệp nguồn chính:**
  - `/opt/unetlab/scripts/pnetlab-linkwatchd.py` (Network Watcher)
  - `/opt/unetlab/scripts/pnetlab-prototracer.py` (Protocol Inspector)
* **Cơ chế hoạt động:**
  1. Thay vì sử dụng các công cụ bên ngoài nặng nề, PNET v8 đưa trực tiếp bộ lọc bytecode cBPF (Classical Berkeley Packet Filter) vào các interface TAP thông qua RAW Socket.
  2. Bắt trực tiếp các cờ giao thức tầng sâu:
     - **BGP**: TCP 179 + kiểm tra byte Type tại offset của TCP payload (Open, Update, Notification, Keepalive).
     - **OSPF**: IP proto 89 + kiểm tra byte Type (Hello=1, DBD=2, LSR=3, LSU=4, LSAck=5).
     - **EIGRP**: IP proto 88 (Update, Query, Reply, Hello-Ack).
     - **STP / RSTP**: Phân tích BPDU Config, TCN, RSTP qua DST-MAC `01:80:c2:00:00:00` hoặc cisco PVST `01:00:0c:cc:cc:cd`.
  3. Ghi kết quả counter vào RAM Disk (`/dev/shm/pnet-watch/` hoặc `/dev/shm/pnet-trace/`) để API PHP đọc trực tiếp mà không chạm đến đĩa cứng.

---

## 3. Hướng dẫn Dành Cho Agent PNETLab v6 Tự Đối Chiếu

Khi AI Agent tại máy PNETLab v6 nhận tài liệu này, hãy thực hiện lần lượt các bước điều tra sau trong mã nguồn v6:

### Bước 1: Kiểm tra mô hình ủy quyền (Privilege Execution)
* Chạy tìm kiếm trong mã nguồn v6:
  ```bash
  grep -rn "sudo " /opt/unetlab/html/
  grep -rn "unl_wrapper" /opt/unetlab/html/
  ```
* **Câu hỏi tự đánh giá:** Mã nguồn v6 có file `/run/pnetlab/broker.sock` hoặc `/opt/unetlab/scripts/pnetlab-brokerd.py` không? Hay v6 vẫn dùng `exec("sudo /opt/unetlab/wrappers/unl_wrapper ...")`?

### Bước 2: Kiểm tra tối ưu RAM (Memory Management)
* Kiểm tra thư mục `/opt/unetlab/wrappers/`:
  ```bash
  ls -la /opt/unetlab/wrappers/ksm_merge_exec
  ```
* **Câu hỏi tự đánh giá:** Có tồn tại wrapper `ksm_merge_exec` gọi `PR_SET_MEMORY_MERGE` không, hay v6 dùng script `/opt/unetlab/scripts/pnetlab-ksm-tune.sh` truyền thống?

### Bước 3: Kiểm tra cơ chế cụm (Cluster Capabilities)
* Kiểm tra tiến trình và cấu hình:
  ```bash
  ps aux | grep satd
  find /opt/unetlab/ -name "*cluster*" -o -name "*satd*"
  ```
* **Câu hỏi tự đánh giá:** v6 có hỗ trợ cụm phân tán qua VXLAN và daemon vệ tinh `pnetlab-satd` không?

### Bước 4: Kiểm tra Telemetry và WebConsole
* Kiểm tra các thư mục:
  ```bash
  ls -la /dev/shm/pnet*
  ls -la /opt/pnet-webconsole/backend/
  ```
* **Câu hỏi tự đánh giá:** v6 có các daemon theo dõi BPF `pnetlab-linkwatchd.py` và backend web console Node.js / Python WebSocket không?
