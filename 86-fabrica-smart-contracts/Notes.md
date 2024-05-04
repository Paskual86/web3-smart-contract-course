# FACTORY
    Creacion de un Smart Contract a partir de una funcion de otro Smart Contract.
    Nota Personal: Creo que tiene que ver con el patron Factory, desde el cual podemos crear diferentes tipos de objetos desde un llamador.
## Codigo
    ```solidity
        contract <nombre_contrato_1> {
            function Factory() public {
                address direccion_nuevo_contrato = address (new <nombre_contrato_2>(<parametros>));
            }

            contract <nombre_contrato_2> {
                constructor (<parametros>) public {....}
            }
        }
    ```

## NOTA
    Para ejecutar correctamente esta funcionalidad desde REMIX 
    1 ) hay que deployar el contrato padre 
    2) Presionar el boton Factory
    3) Ubicar la seleccion del contrato hijo mediante el adress del owner.
    4) DEployar el contrato del hijo pero esta vez utilizando la direccion del punto 3 (RECORDAR CAMBIAR EL SELECTOR DE CONTRATOS A HIJOS)
    5) Usar el nuevo contrato.

