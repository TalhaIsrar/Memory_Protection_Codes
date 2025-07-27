# 🧠 Hamming SEC-Protected Memory System

This project implements a **Hamming SEC (Single Error Correction)** scheme for protecting memory from single-bit faults in hardware using Verilog. It features:

* Hamming(12,8) encoding and decoding logic
* A simple memory model that stores encoded data
* A fault injector to simulate bit-flips
* A decoder that can **detect and correct** single-bit errors
* A comprehensive testbench for functional verification

---

## 📘 Hamming SEC Code: Overview

Hamming codes are linear error-correcting codes that add redundant bits (parity bits) to data bits to allow detection and correction of single-bit errors.

We use the **Hamming(12,8)** configuration:

### Parity Bit Positions (Hamming(12,8)):

| Bit Index | 11 | 10 | 9  | 8  | 7  | 6  | 5  | 4  | 3  | 2  | 1  | 0  |
| --------- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |
| Contents  | D7 | D6 | D5 | P8 | D4 | D3 | D2 | P4 | D1 | D0 | P2 | P1 |

* `D0–D7`: Data bits
* `P1, P2, P4, P8`: Parity bits calculated from subsets of data bits

---

## 🧮 Syndrome Table

During decoding, the syndrome is calculated using the parity-check matrix. The value of the syndrome corresponds to the index of the flipped bit (if any):

| Syndrome | Error Bit Index | Description           |
| -------- | --------------- | --------------------- |
| `0000`   | –               | No error              |
| `0001`   | 0               | Bit 0 (P1) corrupted  |
| `0010`   | 1               | Bit 1 (P2) corrupted  |
| `0011`   | 2               | Bit 2 (D0) corrupted  |
| `0100`   | 3               | Bit 3 (P4) corrupted  |
| `0101`   | 4               | Bit 4 (D1) corrupted  |
| `0110`   | 5               | Bit 5 (D2) corrupted  |
| `0111`   | 6               | Bit 6 (D3) corrupted  |
| `1000`   | 7               | Bit 7 (P8) corrupted  |
| `1001`   | 8               | Bit 8 (D4) corrupted  |
| `1010`   | 9               | Bit 9 (D5) corrupted  |
| `1011`   | 10              | Bit 10 (D6) corrupted |
| `1100`   | 11              | Bit 11 (D7) corrupted |

If the syndrome is non-zero, the decoder corrects the bit at the specified index.

---

## 📂 Project Structure

```
.
├── src/
│   └── hamming_sec/
│       ├── hamming_sec_encoder.v           # 8-bit to 12-bit Hamming encoder
│       ├── hamming_sec_decoder.v           # Decoder with single-bit correction
│       ├── mem.v                           # Simple 12-bit memory model
│       ├── one_bit_flip_simulator.v        # Fault injector for single-bit flip
│       ├── ecc_hamming_memory.v            # ECC memory (normal)
│       └── ecc_hamming_faulty_memory.v     # ECC memory with fault injection
│
├── tb/
│   └── hamming_sec_tb.v                    # Testbench with functional scenarios
│
├── images/
│   ├── ecc_hamming_memory_diagram.png      # Diagram of normal ECC memory
│   └── ecc_hamming_faulty_memory_diagram.png # Diagram with fault injection
│
└── README.md
```

---

## 🧠 Architecture Diagrams

### ✅ ECC Hamming Memory

![ECC Hamming Memory](../../images/hamming_sec_mem.png)

### ✅ ECC Hamming Faulty Memory

![ECC Hamming Faulty Memory](../../images/hamming_sec_faulty_mem.png)

---

## 🔩 Key Modules

### 🔹 `hamming_sec_encoder`

* Inputs: `input_data [7:0]`
* Output: `output_code [11:0]`
* Encodes data using Hamming logic and generates 4 parity bits.

### 🔹 `hamming_sec_decoder`

* Inputs: `in_code [11:0]`
* Outputs: `out_data [7:0]`, `error_corrected`
* Computes syndrome and corrects a single-bit error if detected.

### 🔹 `mem`

* Synchronous memory storing 12-bit Hamming codewords.

### 🔹 `one_bit_flip_simulator`

* Injects a single-bit error at the specified position when `fault_en` is high.

### 🔹 `ecc_hamming_memory`

* Top-level wrapper for encoder, memory, and decoder (no fault injection).

### 🔹 `ecc_hamming_faulty_memory`

* Includes fault injector before passing to decoder.
---

## 🔧 Optimization

When choosing or generating Hamming codes, it is beneficial to **minimize the number of 1s in the parity equations**, especially in hardware:

* XOR gates are used to calculate parity
* More 1s in an equation → more XORs → more logic and delay

### Tip:

Prefer code values with **fewer 1s** for simpler hardware.

---

## ✅ Features Tested

* Store and retrieve 8-bit values
* Simulate faults on any bit in the 12-bit codeword
* Verify correction logic works as expected
* Waveform-based verification
* Latch-free and synthesizable logic

---

## 🚀 Future Extensions

* Implement SECDED (Hamming(13,8))
* Add CRC, BCH, or Berger code alternatives
* Formal verification with SystemVerilog Assertions
* Use parameterized width memory for generality

---

## 🛠️ Usage (Vivado)

1. Open Vivado and create a new project
2. Add all files from `src/hamming_sec/` as sources
3. Add `hamming_sec_tb.v` from `tb/` as simulation source
4. Run simulation to observe correction behavior
5. Optionally, use waveform viewer to inspect correction

---

## 📜 License

Licensed under the **MIT License** – free to use, modify, and distribute.

---

## 🤝 Contributions

Pull requests, feature additions, and bug reports are welcome.
Let me know if you'd like to contribute diagrams, testbenches, or extensions!

