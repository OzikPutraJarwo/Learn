import openpyxl

# Buka file Excel
file_path = 'C:/Users/User/Downloads/Data for python.xlsx'
wb = openpyxl.load_workbook(file_path)

# Akses sheet tertentu (misalnya sheet pertama)
sheet = wb.active

# Loop untuk membersihkan data di range C3:U14
for row in sheet.iter_rows(min_row=3, max_row=14, min_col=3, max_col=21):  # C3:U14 -> 3rd to 21st column
    for cell in row:
        if isinstance(cell.value, str) and cell.value.startswith(', ') and cell.value.endswith(', '):
            cleaned_value = cell.value[2:-2]  # Hapus koma di depan dan belakang
            cell.value = cleaned_value

# Simpan perubahan ke dalam file Excel
wb.save(file_path)