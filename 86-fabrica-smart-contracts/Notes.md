# FACTORY
    Creacion de un Smart Contract a partir de una funcion de otro Smart Contract.
    Nota Personal: Creo que tiene que ver con el patron Factory, desde el cual podemos crear diferentes tipos de objetos desde un llamador.
## Codigo
    ```sol
        contract <nombre_contrato_1> {
            function Factory() public {
                address direccion_nuevo_contrato = address (new <nombre_contrato_2>(<parametros>));
            }

            contract <nombre_contrato_2> {
                constructor (<parametros>) public {....}
            }
        }
    ```
