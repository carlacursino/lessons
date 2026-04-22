# Setup Fortran

## Linux

```sh
sudo apt update
sudo apt install gfortran build-essential gdb python3-pip
```

## VSCode

### Install Modern Fortran VSCode Extension

### Install CodeLLDB Extension

### Install Fortran Type Language Server (fortls)

```sh
python3 -m pip install --user fpm --break-system-packages 
```

### Install Fortran Package Manager (fpm)

```sh
python3 -m pip install --user fpm --break-system-packages 
```

### Atualizar `$PATH`

Adicionar em `.bashrc`
```ini
export PATH="$HOME/.local/bin:$PATH"
```

Re-iniciar shell/VSCode

## Test

`hello.f90` --
```
program hello
  implicit none
  print *, "Olá, Fortran no Debian ARM64!"
end program hello
```

## Compilar na linha de comando

```sh
gfortran hello.f90 -o hello
``` 

Execute o resultante `./hello`

## Projeto integrado

### Criar projeto

```sh
fpm new lessons
cd lessons
fpm run
```

### VSCode integrado

Em `Settings` adicionar:
```json
    "fortran.fortls.path": "~/.local/bin/fortls",
    "fortran.fortls.directories": [ 
        "src/**",
        "app/**",
        "build/**"
    ]
```

Em `.vscode/launch.json` colocar:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug 'lessons'",
            "request": "launch",
            "type": "lldb",
            "program": "${workspaceFolder}/build/debug_bin",
            "args": [],
            "cwd": "${workspaceFolder}",
            "preLaunchTask": "fpm-build-debug",
            "terminal": "integrated"
        }
    ]
}
```
_Será chamada a tarefa `fpm-build-debug` que irá gerar o binário `build/debug_bin` para a execução_.

Adicione a tarefa em `.vscode/tasks.json`:
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "fpm-build-debug",
            "type": "shell",
            "command": "fpm build --profile debug && (cd build && ln -sf $(find . -type f -name lessons -printf '%T@ %p\\n' | sort -n | tail -1 | awk '{print $2}') debug_bin)",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": {
                "owner": "fortran",
                "fileLocation": [
                    "relative",
                    "${workspaceFolder}"
                ],
                "pattern": {
                    "regexp": "^(.*):(\\d+):(\\d+):\\s+(.*):\\s+(.*)$",
                    "file": 1,
                    "line": 2,
                    "column": 3,
                    "severity": 4,
                    "message": 5
                }
            }
        }
    ]
}
```
_A tarefa compila os fontes e gera um binário em `build/debug_bin` para ser acionado pelo *CodeLLDB*_.
