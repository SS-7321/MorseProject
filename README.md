# Microprocessors
Repository for Physics Year 3 microprocessors lab

A simple assembly program for PIC18 microprocessor for communicating between two devices using morse code.

---

# Introduction
<!-- Provide an overview or background of the product. -->
IN the 1830s, Samuel Morse devised Morse code [1], assigning sequences of dots (•) or dashes (-) (see Table 1).
Morse code has historically played a crucial role in military, maritime, and aviation  communication until the mid-20th century and still retains its importance in scenarios where conventional communication infrastructures are unreliable. Encryption is a critical process in safeguarding data [3]. One common encryption technique involves the use of ‘exclusive or’ (XOR) - a logical operation that outputs 1 when comparing two differing bits (for example, 1 XOR 0 = 1 and 1 XOR 1 = 0) [4]. The data byte is encrypted by performing an XOR with a key byte. The XOR operation is reversible — therefore applying the same key a second time will decrypt the data. The project modernises Morse code through a PIC microcontroller-based translator. This device captures button inputs, converts them to binary, encrypts the data, and then communicates it to another microcontroller via UART. There, it’s decrypted, decoded, and displayed on an LCD. 


**Table 1: Morse Code Reference**
| Char | Morse | Char | Morse | Char | Morse  |
|-----:|:-----:|-----:|:-----:|-----:|:------:|
| **A** | `.-`    | **N** | `-.`    | **0** | `-----`  |
| **B** | `-...`  | **O** | `---`   | **1** | `.----`  |
| **C** | `-.-.`  | **P** | `.--.`  | **2** | `..---`  |
| **D** | `-..`   | **Q** | `--.-`  | **3** | `...--`  |
| **E** | `.`     | **R** | `.-.`   | **4** | `....-`  |
| **F** | `..-.`  | **S** | `...`   | **5** | `.....`  |
| **G** | `--.`   | **T** | `-`     | **6** | `-....`  |
| **H** | `....`  | **U** | `..-`   | **7** | `--...`  |
| **I** | `..`    | **V** | `...-`  | **8** | `---..`  |
| **J** | `.---`  | **W** | `.--`   | **9** | `----.`  |
| **K** | `-.-`   | **X** | `-..-`  | **?** | `..--..` |
| **L** | `.-..`  | **Y** | `-.--`  | **!** | `-.-.--` |
| **M** | `--`    | **Z** | `--..`  | **/** | `-..-.`  |
| **,** | `--..--`| **+** | `.-.-.` |      |          |

---

# Product Design
<!-- Describe the product's form factor, materials, or other design aspects. -->



## High Level Design
<!-- Summarize the core architecture or conceptual blueprint of the product. -->

<figure>
  <img src="./img/process.png" alt="Process Diagram">
  <figcaption>Figure 1: Block diagram of Morse Communication Device, showing complexity gradient from left to right and temporal progression from top to bottom. Coloured outlines indicate  various modules’ files. The diagram includes the main loop (dashed box) for repetitive execution
and the interrupt service routine (ISR) for UART Rx interrupts (dotted box).</figcaption>
</figure>

## Hardware

## Software

### Setup
<!-- Outline steps or instructions needed to initialize or configure the software. -->

### Read cycles
<!-- Detail how the software reads inputs or processes data in cycles. -->

### Encoding to binary
<!-- Explain the method or algorithm used to convert data into binary form. -->

### Encryption
<!-- Describe any security measures or encryption techniques applied. -->

### Receiving bytes
<!-- Detail the process for handling incoming data. -->

---

# Product Modifications

## Software Updates

### Connecting sequence
<!-- Explain how the device/software connects for updates. -->

### Adding space
<!-- Outline how memory or storage space is increased or allocated. -->

### Alternate ISR
<!-- Describe the alternative Interrupt Service Routine or similar mechanism. -->

## Hardware Modifications
<!-- List and explain any physical or electronic changes to the product. -->

---

# Performance

## Button bouncing
<!-- Discuss how the software/hardware handles or mitigates switch/button bounce. -->

## Dash cycle length
<!-- Provide information on timing cycles and how they affect performance. -->

## Latency of processes
<!-- Detail any observed delays and potential optimizations. -->

## Operational bugs
<!-- Document known bugs or issues and their status. -->

---

# Product Improvements

### Calibration

### Form factor
<!-- Outline proposed or potential changes to the product's physical design. -->

### Multi-channel tactile button
<!-- Describe improvements or design changes for multi-channel input. -->

### Wireless transmission
<!-- Explain integration or enhancement of wireless capabilities. -->

---

# Conclusion
<!-- Summarize the document and provide closing remarks or next steps. -->

---

# Product Specification
<!-- Provide detailed specifications (dimensions, technical parameters, etc.). -->

---

# References
<!-- Cite all sources, documents, or external references used. -->
