// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*  Gestoria de pagos de empleo empresa:
    - Dependancias:
        PUESTO :
        * Peon
            - 7000 wei/hora
            - 100000 wei/hora extra
        * Supervisor
            - 1000 wei/hora
            - 12000 wei/hora extra
        * Direccion
            - 9000 wei/hora
            - 11000 wei/hora extra
        HORAS TRABAJADAS
        HORAS EXTRA
*/


contract correspondenciaEmpleo {
    address private empleado;            // Direccion del empleado.
    uint cobro;

    address private owner;          // Dueño del contrato    --> NO SE SI HACE FALTA
    uint balance;

    event Numero(string, string puesto, string, int horas_trabajadas, string, int horas_extra, string, int cobro);

    // event: Almacena los argumentos recibidos en los registros de transacciones
    // que se almacenan dentro de la blockchain.
    // Para acceder: Utilizando direccion del contrato cuando este presente en la blockchain. (nos servira para ver su estado)



    // Para conseguir que el contrato se despliegue rapidamente por la red ethereum ofrecemos 0'1 Ether a los mineros.
    // Por CONCEPTO de Smart Contract en una red de BlockChaine, se debe pagar a los mineros para desplegar el contrato.

    constructor(){
        owner = msg.sender;
        balance=0       ; 
    }
    
    event Deposit(string, uint balance);


    function getDeposit() public{
        if (msg.sender == owner){
            emit Deposit("Fondo actual: ", balance);
        }
    }
    
    function deposit() public payable {
        if (msg.sender == owner) {
            balance += msg.value;
        }
    }
     function withdraw(uint quantity) public payable {
        if (msg.sender == owner && quantity <= balance) {
            address payable newOwner;
            balance -= quantity;
            newOwner = payable(owner);
            newOwner.transfer(quantity);
        }
    }

    event Payed(string, string puesto, string, int horas_trabajadas, string, int horas_extra, string, uint cobro);
    
    function correspondencia(address person, string memory puesto, int horas_trabajadas, int horas_extra) public payable {      
        // memory: hemos de definir de donde sacamos el dato 'puesto'(Necesario a partir de la actualizacion)
          balance+=msg.value;
          address payable worker = payable(person);
        if ( keccak256(bytes(puesto)) == keccak256(bytes("peon")) ){        // Comparamos las palabras pasandolo a Bytes
            cobro = uint(horas_trabajadas*7000 + horas_extra*10000);
            worker.transfer(cobro);
            balance-=cobro;
            
        }
        else if ( keccak256(bytes(puesto)) == keccak256(bytes("supervisor")) ){
            cobro = uint(horas_trabajadas*10000 + horas_extra*12000);
            worker.transfer(cobro);
            balance-=cobro;
        }
        else{
            cobro = uint(horas_trabajadas*9000 + horas_extra*11000);
            worker.transfer(cobro);
            balance-=cobro;

        }
        emit Payed("Cargo : ", puesto, "Horas_trabajadas: ", horas_trabajadas, "Horas_extra: ", horas_extra, "Cobro: ", uint(cobro));     // Verificar el estado de este contrato.

    }
}
