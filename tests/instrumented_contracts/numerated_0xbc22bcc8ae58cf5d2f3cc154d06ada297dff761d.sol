1 contract Americo {
2   /* Variables públicas del token */
3     string public standard = 'Token 0.1';
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public initialSupply;
8     uint256 public totalSupply;
9 
10     /* Esto crea una matriz con todos los saldos */
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14   
15     /* Inicializa el contrato con los tokens de suministro inicial al creador del contrato */
16     function Americo() {
17 
18          initialSupply=160000000;
19          name="Americo";
20         decimals=6;
21          symbol="AME";
22         
23         balanceOf[msg.sender] = initialSupply;              // Americo recibe todas las fichas iniciales
24         totalSupply = initialSupply;                        // Actualizar la oferta total
25                                    
26     }
27 
28     /* Send coins */
29     function transfer(address _to, uint256 _value) {
30         if (balanceOf[msg.sender] < _value) throw;           // Compruebe si el remitente tiene suficiente
31         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Verificar desbordamientos
32         balanceOf[msg.sender] -= _value;                     // Reste del remitente
33         balanceOf[_to] += _value;                            // Agregue lo mismo al destinatario
34       
35     }
36 
37     /* Esta función sin nombre se llama cada vez que alguien intenta enviar éter a ella */
38     function () {
39         throw;     // Evita el envío accidental de éter
40     }
41 }