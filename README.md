# TransferGO 

## Setup Instructions

### Prerequisites
* Xcode 15.0 or later
* Swift 6+
* CocoaPods or Swift Package Manager (depending on your dependency setup)

### Installation
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/marekwala/tranfergo.git](https://github.com/marekwala/tranfergo.git)
   cd tranfergo
2. **For unit tests use TransferGoTests scheme:**
<img width="320" height="302" alt="Zrzut ekranu 2026-07-15 o 10 16 11" src="https://github.com/user-attachments/assets/fe5ec9b9-5d4d-4abd-9c72-c94d0562dee4" />

### About implementation
Contains two modules:
* Core - business logic and data models
* Networking - API requests

Main view is TransferView and has it's own TransferViewModel. Localizable should track automaticly strings.
