# Crear un contenedor en Proxmox usando Ansible desde cero

El objetivo de esta guía, es poder instalar y configurar Ansible, crear nuestro inventario agregando nuestro servidor Proxmox, ejecutar un Playbook para crear el contenedor, y configurar dicho contenedor en nuestro inventario.

Requisitos:

- Tener Proxmo instalado en un servidor dedicado al cual llamaré "Proxmox"
- Saber la ip de nuestro servidor Proxmox
- Tener una segunda máquina donde instalar Ansbile la cual llamaré "controlador"
- Accesso al usuario root en ambas máquinas
- Poder acceder al GUI de Proxmox desde cualquier navegador

### Git clone

Abrimos una terminal y corremos el siguiente comando:
```
git clone https://github.com/Crissassun/Proxmox_Container_Con_Ansible.git
```
Dentro de la carpeta donde lonamos el repositorio corremos los siguientes comandos:
```
su root
chmod 755 anprox.sh
bash anprox.sh
```

Una vez terminada la ejecución del script, tendremos que validar que las configuraciones se hicieron de manera correcta para poder correr playbooks desde el controlador en Proxmox. Para eso corremos el siguiente comando.

```
ansible pve -m ping
```

Si la ejecución es exitosa veremos un output como el siguiente:

```
pve | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

```

### Crear Proxmox Container con Ansible

Primeramente debemos editar el archivo que tiene el host, usuario y contraseña de Proxmox, el mismo se enceuntra en /roles/vars/main.yml

```
pmx_api_host: 'ip'  ### La ip de tu servidor Proxmox comunmente es: 192.168.100.2
pmx_api_user: 'root@pam' ### Usuario root de Proxmox
pmx_api_password: 'Password' ### Contraseña root de Proxmox
```

En el archivo tenemos información sensible que debemos proteger, vamos a encriptarla usando Ansible vault, para eso primeramente nos movemos al directory /roles/vars/ y corremos el siguiente comando:

```
ansible-vault encrypt main.yml
```
Ingresa la contraseña de su agrado para encriptar nuestro archivo. Ahora nos regresamos el directorio Proxmox_Container_Con_Ansible.


Antes de correr nuestro playbook que creara un contenedor en Proxmox, dicho contenedor contará con:

- ID 204
- 'container1' como nombre de contenedor
- 1 cpu
- 1024 de RAM
- 512 SWAP
- 16 GB 

Ahora para crear nuestro contenedor corremos el siguiente comando:

```
ansible-playbook main.yml --ask-vault-pass 
```

El output que obtendremos sera similar a:

```
TASK [Show current status of container] **************************************************************************************************************************************************************************************************************************************************************************************
ok: [pve] => {
    "container_info": {
        "changed": true,
        "deprecations": [
            {
                "collection_name": "community.general",
                "msg": "The default value `false` for the parameter \"unprivileged\" is deprecated and it will be replaced with `true`",
                "version": "7.0.0"
            }
        ],
        "failed": false,
        "msg": "Deployed VM 204 from template local:vztmpl/centos-8-stream-default_20220327_amd64.tar.xz"
    }
}

PLAY RECAP *******************************************************************************************************************************************************************************************************************************************************************************************************************
pve                        : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```


### Configurar Proxmox contenedor con Ansible

Ya que tenemos nuestro contenedor corriendo y para validar que es así, nos conectaremos a Proxmox mediante ssh:

```
ssh root@ip_proxmox
```

Ya conectados en la terminal de Proxmox corremos el siguiente comando:

```
pct list
```

El output será similar a:

```
204        running                 container1
```



### Felicitaciones ahora ya tienes Ansible configurado para correr playbooks en tu servidor Proxmox y en el contenedor recién creado en Proxmox
