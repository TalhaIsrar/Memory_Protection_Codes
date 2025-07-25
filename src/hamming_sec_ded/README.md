# 🧠 Hamming SEC DED-Protected Memory System

This project implements a **Hamming SEC DED (Single Error Correction, Double Error Detection)** scheme for protecting memory from 1-bit & 2-bit faults in hardware using Verilog. It features:

* Hamming(13,8) encoding and decoding logic
* A simple memory model that stores encoded data
* A fault injector to simulate bit-flips
* A decoder that can **detect and correct** single-bit errors
* A decoder that can **detect** double-bit errors
* A comprehensive testbench for functional verification

---

## 📘 Hamming SEC DED Code: Overview


### Parity Bit Positions (Hamming(13,8)):


## 🧮 Syndrome Table

---

## 📂 Project Structure

```
.
├── src/
│   └── hamming_sec_ded/
│       ├── hamming_secded_encoder.v           # 8-bit to 13-bit Hamming encoder
│       ├── hamming_secded_decoder.v           # Decoder with single-bit correction & double-bit detection
│       ├── mem_secded.v                       # Simple 13-bit memory model
│       ├── two_bit_fault_injector.v           # Fault injector for single and double-bit flip
│       ├── ecc_hamming_secded_memory.v        # ECC memory (normal)
│       └── ecc_hamming_secded_faulty_memory.v # ECC memory with fault injection
│
├── tb/
│   └── hamming_secded_tb.v                    # Testbench with functional scenarios
│
├── images/
│   ├── ecc_hamming_secded_diagram.png         # Diagram of normal ECC memory
│   └── ecc_hamming_secded_faulty_diagram.png  # Diagram with fault injection
│
└── README.md
```

---

## 🧠 Architecture Diagrams


## 🔩 Key Modules


## ✅ Features Tested


## 🚀 Future Extensions

## 🛠️ Usage (Vivado)

1. Open Vivado and create a new project
2. Add all files from `src/hamming_sec_ded/` as sources
3. Add `hamming_secded_tb.v` from `tb/` as simulation source
4. Run simulation to observe correction behavior
5. Optionally, use waveform viewer to inspect correction

---

## 📜 License

Licensed under the **MIT License** – free to use, modify, and distribute.

---

## 🤝 Contributions

Pull requests, feature additions, and bug reports are welcome.
Let us know if you'd like to contribute diagrams, testbenches, or extensions!

