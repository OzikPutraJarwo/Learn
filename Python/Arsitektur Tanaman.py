import matplotlib.pyplot as plt

judul_grafik = 'Arsitektur G12 UB 2 × AGP'
panjang_batang = 73
jumlah_cabang = 12
ruas_batang = [2, 2.5, 3, 4, 4, 5, 6, 7, 8, 7, 8, 7, 4, 3, 3]
ruas_cabang = {
    1: [12, 6, 7],
    2: [5, 10, 11],
    3: [12, 9, 4],
    6: [16, 7, 4, 5]
}
jarak_cabang = 0.1

print(judul_grafik)

posisi_ruas_batang = [sum(ruas_batang[:i+1]) for i in range(len(ruas_batang))]
bawah_batas = panjang_batang / 3
tengah_batas = 2 * panjang_batang / 3

posisi_cabang = {}
for i in range(1, jumlah_cabang + 1):
    if i <= jumlah_cabang // 3:
        posisi_cabang[i] = 'bawah'
    elif i <= 2 * jumlah_cabang // 3:
        posisi_cabang[i] = 'tengah'
    else:
        posisi_cabang[i] = 'atas'

plt.figure(figsize=(10, 8))

plt.plot([0] * len(posisi_ruas_batang), posisi_ruas_batang, 'o-', label='Batang Utama', color='blue')

for i in range(1, jumlah_cabang + 1):
    if posisi_cabang[i] == 'bawah':
        posisi_y_cabang = bawah_batas * (i / sum(1 for k in posisi_cabang if posisi_cabang[k] == 'bawah'))
    elif posisi_cabang[i] == 'tengah':
        posisi_y_cabang = bawah_batas + (tengah_batas - bawah_batas) * ((i - sum(1 for k in posisi_cabang if posisi_cabang[k] == 'bawah')) / sum(1 for k in posisi_cabang if posisi_cabang[k] == 'tengah'))
    elif posisi_cabang[i] == 'atas':
        posisi_y_cabang = tengah_batas + (panjang_batang - tengah_batas) * ((i - sum(1 for k in posisi_cabang if posisi_cabang[k] in ['bawah', 'tengah'])) / sum(1 for k in posisi_cabang if posisi_cabang[k] == 'atas'))

    if i in ruas_cabang:
        jarak_antar_ruas = ruas_cabang[i]
        posisi_ruas_cabang = [posisi_y_cabang + sum(jarak_antar_ruas[:j+1]) for j in range(len(jarak_antar_ruas))]
        jarak_cabang = jarak_cabang + 0.05
        if i % 2 == 1:  # odd - left side
            plt.plot([-jarak_cabang] * len(posisi_ruas_cabang), posisi_ruas_cabang, 'o--', label=f'Cabang {i}')
            plt.plot([0, -jarak_cabang], [posisi_y_cabang, posisi_ruas_cabang[0]], 'k--')
        else:  # even - right side
            plt.plot([jarak_cabang] * len(posisi_ruas_cabang), posisi_ruas_cabang, 'o--', label=f'Cabang {i}')
            plt.plot([0, jarak_cabang], [posisi_y_cabang, posisi_ruas_cabang[0]], 'k--')
    else:
        if i % 2 == 1:  # odd - left side
            plt.plot([-jarak_cabang], [posisi_y_cabang], 'o', label=f'Cabang {i} (non produktif)')
        else:  # even - right side
            plt.plot([jarak_cabang], [posisi_y_cabang], 'o', label=f'Cabang {i} (non produktif)')

plt.ylabel('Tinggi Tanaman (cm)')
plt.title(judul_grafik)
plt.legend(loc='center right',fontsize='x-small')
plt.xlim(-1, 1)
plt.show()