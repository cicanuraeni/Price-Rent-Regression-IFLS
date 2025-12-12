# Price-Rent-Regression-IFLS: Prediksi Harga Sewa Urban dengan Log-Linear Model

Proyek ini menganalisis faktor-faktor yang memengaruhi **harga sewa rumah urban** menggunakan data IFLS (Indonesia Family Life Survey).

Analisis ini menggunakan **Regresi Linier Berganda**, Transformasi **Log–Log**, dan **Backward Elimination** sebagai metode seleksi variabel, dengan fokus kuat pada validasi asumsi klasik.

Proyek ini disusun untuk menunjukkan kemampuan dalam:
- Model regresi berbasis matriks (Manual OLS)
- Pengujian asumsi klasik (VIF, Breusch–Pagan, RESET)
- **Transformasi Model** untuk memenuhi asumsi (Log-Log)
- Seleksi variabel yang efisien (Backward Elimination)
- **Interpretasi Elastisitas** dan dampak *dummy* variabel.

---

## Struktur Repository
- [`data/`](./data) — berisi dataset mentah & dataset hasil transformasi  
  - [`awal.xlsx`](./data/awal.xlsx)  
  - [`akhir.xlsx`](./data/akhir.xlsx)  
  - [`readme.txt`](./data/readme.txt)

- [`script/`](./script) — berisi seluruh script analisis R  
  - [`full_pipeline_analysis.R`](./script/full_pipeline_analysis.R)  
  - [`readme.txt`](./script/readme.txt)

- [`output/`](./output) — berisi hasil akhir & laporan  
  - [`anreg.pdf`](./output/anreg.pdf)  
  - [`readme.txt`](./output/readme.txt)

- [`README.md`](./README.md) — dokumentasi utama proyek

---

## Tujuan Analisis

1.  Mengidentifikasi variabel-variabel yang memengaruhi harga sewa rumah.
2.  Memeriksa dan **memperbaiki** pemenuhan asumsi klasik regresi linier.
3.  Menyusun model akhir menggunakan metode **Backward Elimination**.
4.  Menghasilkan model prediksi harga sewa yang lebih stabil dan signifikan.

---

## Metodologi Statistik

### **1. Estimasi Model Awal**
Model dihitung menggunakan formula OLS (Ordinary Least Squares) secara manual dalam R:

$$
\hat{\beta} = (X'X)^{-1}X'Y
$$

### **2. Uji Asumsi Klasik & Solusi**

| Uji Diagnostik | Masalah Ditemukan | Solusi |
| :--- | :--- | :--- |
| **Heteroskedastisitas** (Breusch–Pagan Test) | **Gagal** (Varian residual tidak konstan). | Transformasi **Log-Log**. |
| **Linearitas** (Ramsey RESET Test) | **Gagal** (Hubungan non-linear). | Transformasi **Log-Log** untuk membentuk model Log-Linear. |
| **Multikolinearitas** (VIF) | Lulus. | Variabel dipertahankan. |

### **3. Transformasi Log–Log**
Variabel Y, X12 (Luas Lantai), dan X13 (Jumlah Ruangan) ditransformasi ke log untuk menstabilkan varians dan membuat hubungan fungsional lebih linear.

*Hasil:* Model transformasi **memenuhi asumsi homoskedastisitas dan linearitas**.

### **4. Backward Elimination**
Metode eliminasi mundur diterapkan pada model Log-Linear untuk menghapus variabel yang tidak signifikan (p-value $\ge 0.05$).

## Model Akhir (Log-Linear Regression)

Model akhir terdiri dari variabel-variabel yang memberikan kontribusi signifikan, dengan $R^2 = 0.1906$.

$$
\log(Y) = 4.6296 - 0.0669X_{4.2} + 0.1021X_{5.1} + 0.0605X_{6.1} + 0.1293X_{6.2} + 0.1932X_{7} + 0.0492X_{10} + 0.1581\log(X_{12}) + 0.3376\log(X_{13}) - 0.1113X_{14.1} - 0.1536X_{14.3} + 0.0632X_{15.1} - 0.0864X_{16.3}
$$


## Insight Utama (Interpretasi Koefisien)

### 1. **Dampak Elastisitas (Log-Log)**
Koefisien pada variabel Log-Log diinterpretasikan sebagai Elastisitas—yaitu, **persentase perubahan harga sewa akibat $1\%$ perubahan variabel independen.**

* **$\log(X_{13})$ (Jumlah Ruangan):** Dengan koefisien **$0.3376$**, peningkatan 1% pada jumlah ruangan memprediksi peningkatan harga sewa sebesar $\mathbf{0.3376\%}$. Ini adalah pendorong harga terkuat.
* **$\log(X_{12})$ (Luas Lantai):** Dengan koefisien **$0.1581$**, peningkatan 1% pada luas lantai memprediksi peningkatan harga sewa sebesar $\mathbf{0.1581\%}$.

***Insight:*** Sensitivitas harga terhadap **jumlah ruangan** hampir dua kali lipat lebih tinggi daripada luas lantai.

### 2. **Dampak Fasilitas (Log-Level/Dummy)**
Koefisien pada variabel *dummy* diinterpretasikan sebagai **persentase perubahan harga sewa rata-rata** ketika variabel tersebut aktif ($\text{X}=1$).

* **$X_{7}$ (Sampah Diangkut Petugas):** Dengan koefisien **$0.1932$**, rumah dengan fasilitas ini diprediksi memiliki harga sewa rata-rata $\mathbf{21.3\%}$ **lebih tinggi** $\left(100 \times (e^{0.1932} - 1)\right)$, menunjukkan premi harga yang signifikan untuk layanan publik yang baik.
* **$X_{5.1}$ (Tempat BAB Septic Tank):** Keberadaan septic tank diperkirakan meningkatkan harga sewa rata-rata $\mathbf{10.7\%}$.

---

## Cara Menjalankan Script
Pastikan file berada sesuai struktur folder di atas, lalu jalankan dalam konsol R:

```r
source("script/full_pipeline_analysis.R")
```
---

## Penyusun

Proyek ini disusun oleh:

- **Tansya Putri Rizkya Zakaria**  – Program Studi Statistika, Universitas Padjadjaran 
- **Naira Aqila**  – Program Studi Statistika, Universitas Padjadjaran 
- **Cica Nuraeni** – Program Studi Statistika, Universitas Padjadjaran  

---

## Referensi

1. Kutner, Nachtsheim & Neter — *Applied Linear Regression Models*  
2. Wooldridge — *Introductory Econometrics*  
3. RAND Corporation – Indonesia Family Life Survey (IFLS) Documentation  
4. Materi kuliah Analisis Regresi (FMIPA UNPAD)  

---
