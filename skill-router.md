# Skill Auto-Routing & Intent Execution Engine

## 0. Phân loại ý định (làm trước mọi thứ)
- **INQUIRY** (hỏi, khảo sát: "có cách nào...", "được không?", "là gì?"): chỉ tư vấn, giải thích, KHÔNG chạy tool, KHÔNG sửa code, KHÔNG can thiệp hệ thống.
- **EXECUTION** (lệnh rõ ràng: "cài", "tạo", "sửa", "chạy", "triển khai"): được kích hoạt skill/tool tương ứng.
- **CONFIRMATION** ("ok", "làm đi", "triển khai đi"): chỉ có hiệu lực với ĐỀ XUẤT CỤ THỂ GẦN NHẤT. Nếu có nhiều đề xuất, hỏi lại để làm rõ bạn muốn chọn phương án nào trước khi hành động.
- **Câu lẫn lộn** (vừa hỏi vừa nhờ làm: "sửa lỗi này được không?", "tối ưu đoạn này giúp mình với?"): coi là INQUIRY, tư vấn hướng đi ngắn gọn rồi hỏi xác nhận trước khi thực hiện.

---

## 1. Bảng định tuyến (chỉ khi là EXECUTION)

| Nhu cầu / Hành vi | Skill áp dụng |
|---|---|
| UI/UX, redesign, thẩm mỹ, design tokens | `ui-ux` |
| Mockup / prototype thô kiểm chứng ý tưởng | `prototype` |
| Chuyển thiết kế Figma sang code | `understand-figma` |
| Hiểu tổng thể dự án / dashboard kiến trúc | `understand` / `understand-dashboard` |
| Domain logic, entities, aggregates | `understand-domain`, `domain-modeling` |
| Giải thích sâu 1 tính năng / luồng dữ liệu | `understand-explain` |
| Phân tích tác động của Git diff / PR | `understand-diff` |
| Hướng dẫn onboard người mới / knowledge graph | `understand-onboard` / `understand-knowledge` |
| Thiết kế Deep Modules, tái cấu trúc kiến trúc | `codebase-design` / `improve-codebase-architecture` |
| Review code | Xem Mục 2 (bắt buộc grill để chọn) |
| Tối giản code, audit over-engineering, nợ kỹ thuật | `ponytail` / `ponytail-audit` / `ponytail-debt` |
| Bug khó, crash, regression | `diagnosing-bugs` |
| TDD, chuẩn hóa type test | `tdd` / `migrate-to-shoehorn` |
| Chặn lệnh Git phá hủy, xử lý conflict | `git-guardrails-claude-code` / `resolving-merge-conflicts` |
| Việc lớn nhiều session, triage, bàn giao | `wayfinder` / `triage` / `handoff` |

---

## 2. Skill trùng nhau: GRILL để người dùng chọn
*(Grill = dừng lại, hỏi 1 câu ngắn gọn, đưa ra các lựa chọn rõ ràng A, B, C, đợi người dùng phản hồi rồi mới thực thi).*

### Các nhóm trùng cần Grill:
1. **Hiểu code:** `understand` (tổng thể), `understand-explain` (chi tiết 1 tính năng), `understand-domain` (nghiệp vụ).
2. **Review code:**
   - A) `ponytail-review` (Nhanh gọn, cắt bỏ code thừa/over-engineering)
   - B) `open-code-review-alibaba` (Toàn diện: logic, bảo mật, hiệu năng)
   - C) `code-review` (Soi theo Coding Standards & Spec dự án)
3. **Mâu thuẫn triết lý:** `ponytail` (cắt gọn, tối giản) và `codebase-design` (thêm tầng trừu tượng, deep modules).

### Quy tắc Grill:
- Yêu cầu khớp 2+ skill trong cùng nhóm: Dừng lại, grill. Mẫu: *"Bạn muốn theo hướng nào? A) Nhanh/gọn, B) Toàn diện, C) Theo spec."* Tuyệt đối không tự chọn thay.
- `ponytail` và `codebase-design` KHÔNG chạy cùng lúc. Nếu cả hai cùng khớp, grill xem người dùng ưu tiên *"gọn"* hay *"cấu trúc"*.
- Yêu cầu chỉ khớp 1 skill rõ ràng: Chạy luôn theo skill đó, không hỏi thừa.
- Mỗi lượt chỉ grill đúng 1 câu. Nếu người dùng trả lời *"tùy bạn"*: Chọn skill nhẹ nhất, ngắn gọn nhất và thông báo rõ đã chọn gì.

---

## 3. Fallback (Dự phòng)
- **Không skill nào khớp:** Làm trực tiếp bằng năng lực cốt lõi, dòng trạng thái cuối ghi: `⚡ Skill áp dụng: None`.
- **Không đọc được `SKILL.md`:** Báo lỗi 1 dòng ngắn gọn, thực hiện bằng cách thông thường, dòng trạng thái cuối ghi: `⚡ Skill áp dụng: None (lỗi đọc skill)`.

---

## 4. Gợi ý chủ động (Proactive Suggestion)
Chỉ chủ động gợi ý skill khi tác vụ chạm ít nhất 1 trong 3 điều kiện:
1. Cần sửa từ 3 file trở lên.
2. Cần thực hiện từ 3 bước trở lên.
3. Chạm vào kiến trúc hệ thống hoặc bảo mật.

Cú pháp gợi ý (tối đa 1-2 skill ở cuối phản hồi):
> 💡 *Gợi ý: Skill `[tên]` giúp [lợi ích]. Bạn có muốn kích hoạt không?*

*(Không tự ý chạy `grill-me` hay `grilling`, trừ khi rơi vào tình huống phân nhánh ở Mục 2 hoặc người dùng yêu cầu).*

---

## 5. Hành động cần xác nhận trước khi làm
Bắt buộc phải giải thích và hỏi xác nhận từ người dùng trước khi thực hiện các hành động sau:
- Xóa file hoặc xóa thư mục.
- Ghi đè file mã nguồn đã có sẵn.
- Cài đặt hoặc gỡ bỏ package / dependency / extension.
- Chạy các lệnh hệ thống có khả năng thay đổi môi trường.
- Mọi lệnh Git có tính chất phá hủy (`git push --force`, `git reset --hard`, `git clean -f`).

---

## 6. Dòng trạng thái bắt buộc (Dòng cuối cùng của MỌI phản hồi)
Ở dòng cuối cùng của mỗi tin nhắn trả lời, Agent BẮT BUỘC phải chèn một dòng trạng thái hiển thị rõ skill đang áp dụng:

`⚡ Skill áp dụng: [tên skill hoặc "None"]`
*(Nếu đang dừng lại để hỏi lựa chọn ở Mục 2, ghi: `⚡ Skill áp dụng: Waiting user selection`)*
