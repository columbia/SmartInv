1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract FootCoin {
23     // Variáveis públicas do token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 8;
27     // 8 casas decimais
28     uint256 public totalSupply;
29 
30     // Criação de uma matriz com todos os saldos
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // Geração de um evento público no blockchain que notificará os clientes
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // Notificação aos clientes sobre a quantidade queimada
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Função Constrctor
42      *
43      * Inicializa o contrato com número inicial dos tokens para o criador do contrato
44      */
45     function FootCoin(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Atualiza a oferta total com os valores decimais
51         balanceOf[msg.sender] = totalSupply;                // Envia ao criador todos os tokens iniciais
52         name = tokenName;                                   // Define o nome para fins de exibição
53         symbol = tokenSymbol;                               //  Definir o símbolo para fins de exibição
54     }
55 
56     /**
57      * Transferência interna, só pode ser chamada por este contrato
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Impede a transferência para o endereço 0x0
61         require(_to != 0x0);
62         // Verifica o saldo do remetente
63         require(balanceOf[_from] >= _value);
64         // Verifica overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Guarda para conferência futura
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtrai do remetente
69         balanceOf[_from] -= _value;
70         // Adiciona o mesmo valor ao destinatário
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73         // Verificação usada para usar a análise estática do contrato, elas nunca devem falhar
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transferência dos tokens
79      *
80      * Envio `_value` tokens para `_to` da sua conta
81      *
82      * @param _to O endereço do destinatário
83      * @param _value O valor a enviar
84      */
85     function transfer(address _to, uint256 _value) public {
86         _transfer(msg.sender, _to, _value);
87     }
88     /**
89      * Destruição dos Tokens
90      *
91      * Remove `_value` tokens do sistema irreversivelmente
92      *
93      * @param _value O valor a ser queimado
94      */
95     function burn(uint256 _value) public returns (bool success) {
96         require(balanceOf[msg.sender] >= _value);   // Verifique se tem o suficiente
97         balanceOf[msg.sender] -= _value;            // Subtrair do remetente
98         totalSupply -= _value;                      // Atualiza o totalSupply
99         Burn(msg.sender, _value);
100         return true;
101     }
102 }