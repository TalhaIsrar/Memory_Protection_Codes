# Memory Protection Codes

This repository contains various **memory protection code** implementations designed for digital systems to provide **error detection** and/or **error correction** capabilities.  
These codes help improve reliability by identifying or correcting faults in data stored or transmitted.

---

## 📚 About Memory Protection Codes

Memory protection codes include both **error detecting** and **error correcting** codes. Some codes only detect errors (e.g., parity, Berger codes), while others also correct single-bit or multiple-bit errors (e.g., Hamming codes).

This repository focuses on such codes implemented in Verilog for hardware design and verification.

---

## 🗂️ Project Structure

```
.
├── src/ # Source code for all memory protection code implementations
│    ├── hamming_sec     / # Hamming Single Error Correction code project
│    ├── hamming_sec_ded / # Hamming Single Error Correction & Double Error Detection code project
│    ├── hsiao_code      / # Hsiao Single Error Correction & Double Error Detection code project
│    ├── berger_code     / # Berger Code Detection for Unidirectional Errors
│    └── ... # OTHERS TO BE ADDED
│
├── tb/ # Testbenches corresponding to different projects
│
├── images/ # Architecture diagrams and related visuals
│
└── README.md # This master README file
```

---

## 🚀 How to Use the Code

1. Open Vivado or your preferred Verilog simulation tool.
2. Create a new project and add all source files from the desired project folder under `src/` (e.g., `src/hamming_sec/`).
3. Add the corresponding testbench file from the `tb/` directory.
4. Run simulations to verify the memory protection code’s functionality, including write/read operations and error detection or correction.
5. Analyze waveform outputs or console messages to observe the behavior and correctness.

---

## 📂 Available Codes in this Repo

- [Hamming SEC (Single Error Correction)](src/hamming_sec/README.md)  
  Implements Hamming(12,8) code that **detects and corrects single-bit errors** for 8-bit data. Supports fault injection to test error correction in memory modules.

- [Hamming SEC DED (Single Error Correction, Double Error Detection)](src/hamming_sec_ded/README.md)  
  Implements Hamming(13,8) code that **detects 1-bit & 2-bit errors & corrects 1-bit errors** for 8-bit data. Supports fault injection to test error correction in memory modules.

- [Hsiao SEC DED (Single Error Correction, Double Error Detection)](src/hsiao_code/README.md)  
  Implements Hsiao(13,8) code that **detects 1-bit & 2-bit errors & corrects 1-bit errors** for 8-bit data. Supports fault injection to test error correction in memory modules.

- [Berger Code (Unidirectional Error Detection)](src/berger_code/README.md)  
  Implements Berger(12,8) code that **detects all unidirectional errors** for 8-bit data. Supports fault injection to test error correction in memory modules.

---

## 🛠️ Future Work

- Optimize existing codes
- Extend testbenches for comprehensive coverage.  
- Integrate formal verification techniques.

---

## 📄 License

This project is released under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributions

Contributions, suggestions, and issue reports are welcome! Feel free to fork and open pull requests.

---

*Created by Talha Israr*  
