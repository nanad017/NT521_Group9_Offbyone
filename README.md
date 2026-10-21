# Oversight

`Oversight` is a 100-point Pwn challenge from DownUnderCTF 2021. It combines
an off-by-one overwrite with a stack pivot and a short ROP chain.

## Run

```bash
cd /home/nad/UIT/Major/Malware/Seminar/oversight-lab
docker compose up -d --build
nc localhost 31909
```

The flag and public port can be changed with `OVERSIGHT_FLAG` and
`OVERSIGHT_HOST_PORT`.

## Intended solution

1. The program accepts a length of 256 and reads 256 bytes into a 256-byte
   buffer.
2. It then writes a null terminator at offset 256, which overwrites the least
   significant byte of the saved `RBP`.
3. The function epilogue uses the corrupted `RBP` to pivot the stack into the
   input buffer.
4. A built-in format-string bug leaks `__libc_start_main`.
5. The ROP chain calls `system("/bin/sh")` using `pop rdi; ret` and the
   `/bin/sh` string from libc.

Run the included exploit with pwntools:

```bash
python3 -m pip install pwntools
python3 exploit.py HOST=127.0.0.1 PORT=31909
```

After the shell opens:

```sh
cat flag.txt
```

## Attribution

- Original challenge and files: [DownUnderCTF 2021 Oversight](https://ctftime.org/writeup/30862)
- Original write-up: [datajerk/ctf-write-ups](https://github.com/datajerk/ctf-write-ups/tree/master/downunderctf2021/oversight)
