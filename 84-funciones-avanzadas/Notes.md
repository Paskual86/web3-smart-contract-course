# Modificadores
## Internal o External
    Existen modificadores *internal* y *external*
    **Internal**: Similar al private. Solo es posible ser llamado desde el contrato actual o de contratos que deriven de el.
    *Extrernal*: Unicamente pueden ser llamadas desde fuera del contrato.
### codigo
    ```solidity
        function <nombre_funcion>(<parametros>) [public | private | internal | external] [view | pure | payable]* [returns (<return_type>)]* { }
    ```
## Require
    Lanza un error y para la ejecucion de una funcion si la condicion no es verdadera.
### codigo
    ```solidity
        function <nombre_funcion>(<parametros>) [public | private | internal | external] [view | pure | payable]* [returns (<return_type>)]* { 
            require(<condicion>, [<mensaje_condicion_falsa>]);
        }
    ```

## Modifier
    Permite cambiar el comportamiento de una funcion de manera agil.
### codigo
    ```solidity
        modifier <nombre_modificador> (<parametros>)*{
            require (<condicion>)
            _; // Siempre termina con esta sentencia
        }

        function <nombre_funcion>(<parametros>) [public | private | internal | external] [view | pure | payable]* [returns (<return_type>)]* [<nombre_modificador>]{ 
            
        }
    ```