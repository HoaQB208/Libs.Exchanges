// Vẽ đường thẳng đứng: ObjectCreate(0, "MaxRange", OBJ_VLINE, 0, GetTime(startIndex), 0);
// Màu: ObjectSetInteger(0, "SubRange", OBJPROP_COLOR, clrGray);


void CreateLabel(string name, int x, int y, string text, color clr, int fontSize = 8)
{
   // Nếu đã tồn tại label cùng tên, xóa đi trước
   if (ObjectFind(0, name) >= 0) ObjectDelete(0, name);
   // Tạo label mới
   ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);  // góc trên bên trái
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);               // khoảng cách theo trục X
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);               // khoảng cách theo trục Y
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);                 // màu chữ
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);         // cỡ chữ
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);          // không cho chọn
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);               // ẩn khỏi danh sách đối tượng
   ObjectSetString(0, name, OBJPROP_TEXT, text);                  // nội dung văn bản
}


void CreateRectangle(string name, int x, int y, int width, int height)
{
   if (ObjectFind(0, name) >= 0) ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);   // chiều rộng
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);  // chiều cao
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
}
