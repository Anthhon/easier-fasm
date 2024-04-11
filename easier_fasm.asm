; Defines

define sys_write        1
define sys_exit         60

define sys_stderr       2
define sys_stdout       1
define sys_stdin        0

; Macros

macro ef_new_string name_str*, content_str* {
    #name_str db #content_str, 0
    #name_str_l = $ - #name_str - 1
}

macro ef_sys_write_it buf* {
    xor esp, esp                    ; Initialize string index counter

    @@:
        mov al, byte[buf + esp]     ; Move next character into 'al'

        cmp al, 0                   ; Compare character to '\0'
        je @f                       ; End loop when reaches '\0'

        mov eax, sys_write          ; Set 'write' syscall
        mov edi, sys_stdout         ; Set output file
        lea esi, [buf + esp]        ; Load character address to print
        mov edx, 1
        syscall

        inc esp                     ; Increment character index
        jmp @b                      ; Restarts loop
    @@:
}

macro ef_sys_write_ct buf* {
    xor edx, edx                    ; Initialize string index counter

    @@:
        mov al, byte[buf + edx]     ; Move next character into 'al'

        cmp al, 0                   ; Compare character to '\0'
        je @f                       ; End loop when reaches '\0'

        inc edx                     ; Increment character index
        jmp @b                      ; Restarts loop
    @@:
        mov esi, buf                ; Load character address to print
        mov eax, sys_write          ; Set 'write' syscall
        mov edi, sys_stdout         ; Set output file
        syscall
}

macro ef_sys_exit status* {
    mov eax, sys_exit
    mov edi, status
    syscall
}
