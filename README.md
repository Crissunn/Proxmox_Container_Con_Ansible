# Crear un contenedor en Proxmox usando Ansible desde cero

El objetivo de esta guía, es poder instalar y configurar Ansible, crear nuestro inventario agregando nuestro servidor Proxmox, ejecutar un Playbook para crear el contenedor, y configurar dicho contenedor en nuestro inventario.

Requisitos:

- Tener Proxmo instalado en un servidor dedicado al cual llamaré "Proxmox"
- Saber la ip de nuestro servidor Proxmox
- Tener una segunda máquina donde instalar Ansbile la cual llamaré "controlador" con OS Centos
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
ansible -i inventory.txt pve -m ping
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
