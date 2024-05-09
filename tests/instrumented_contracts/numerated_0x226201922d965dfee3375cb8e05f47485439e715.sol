1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title Contrato padrão para definição do proprietário do contrato detentor do token
5  * @author Alaor Jr.
6  */
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 /**
25  * @title Contrato para criação do token utilizado no projeto "MaisPetro"
26  * @author Alaor Jr.
27  */
28 contract Igni is owned {
29     /// Informações do token
30     string public name;
31     string public symbol;
32     uint8 public decimals = 1;
33     uint256 public totalSupply;
34 
35     /// Array associativo de saldos das carteiras
36     mapping (address => uint256) public balanceOf;
37 
38     /// Evento que notifica a aplicação cliente Etherum da transferência de tokens
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     /// Evento que notifica a aplicação cliente Etherum da aprovação de saldo de um proprietário para um "gastador"
42     event Approval(address indexed holder, address indexed spender, uint256 value);
43 
44     /// Evento que notifica a aplicação cliente Etherum da "queima" de tokens
45     event Burn(address indexed from, uint256 value);
46 
47     /**
48      * @notice Inicializa o contrato com as informações do token passadas por parâmetro
49      * @dev É executado uma única vez no momento do deploy na Ethereum Virtual Machine (EVM)
50      */
51     constructor(
52         uint256 initialSupply,
53         string tokenName,
54         string tokenSymbol
55     ) public {
56         totalSupply = initialSupply * 10 ** uint256(decimals);
57         balanceOf[msg.sender] = totalSupply;
58         name = tokenName;
59         symbol = tokenSymbol;
60     }
61 
62     /**
63      * @notice Transfere tokens de uma carteira para outra
64      * @dev Função interna que pode apenas ser chamada pelo contrato
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         require(_to != 0x0);                                            // Previne de enviar tokens para o endereço 0x0
68         require(balanceOf[_from] >= _value);                            // Verifica se o saldo na carteira de origem é suficiente
69         require(balanceOf[_to] + _value > balanceOf[_to]);              // Previne overflow na carteira de destino
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         balanceOf[_from] -= _value;
72         balanceOf[_to] += _value;
73         emit Transfer(_from, _to, _value);
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // Verificação adicional para um caso de overflow não detectado
75     }
76 
77     /**
78      * @notice Transfere tokens para uma carteira
79      *
80      * @param _to    Endereço da carteira que receberá os tokens
81      * @param _value Quantidade de tokens a ser enviado
82      *
83      * @return bool
84      */
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         _transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     /**
91      * @notice Transfere tokens de para uma carteira em nome de outra carteira
92      *
93      * @param _from  Endereço da carteira que enviará os tokens
94      * @param _to    Endereço da carteira que receberá os tokens
95      * @param _value Quantidade de tokens a ser enviado
96      * @param _value Quantidade de tokens que serão debitados do valor a receber por "_to", como forma de taxa da transação
97      *
98      * @return bool
99      */
100     function transferFrom(address _from, address _to, uint256 _value, uint256 _fee) onlyOwner public returns (bool success) {
101         _transfer(_from, owner, _fee);
102         _transfer(_from, _to, _value - _fee);
103         return true;
104     }
105 }