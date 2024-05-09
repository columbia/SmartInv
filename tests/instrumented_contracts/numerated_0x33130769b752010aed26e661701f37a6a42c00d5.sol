1 pragma solidity ^0.4.13;
2 
3 interface IERC20 {
4   function totalSupply() constant returns (uint totalSupply);
5   function balanceOf(address _owner) constant returns (uint balance);
6   function transfer(address _to, uint _value) returns (bool success);
7   function transferFrom(address _from, address _to, uint _value) returns (bool success);
8   function approve(address _spender, uint _value) returns (bool success);
9   function allowance(address _owner, address _spender) constant returns (uint remaining);
10   event Transfer(address indexed _from, address indexed _to, uint _value);
11   event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 /**
15 * @title SafeMath
16 * @dev Math operations with safety checks that throw on error
17 */
18 library SafeMath {
19 function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20   uint256 c = a * b;
21   assert(a == 0 || c / a == b);
22   return c;
23 }
24 
25 function div(uint256 a, uint256 b) internal constant returns (uint256) {
26   // assert(b > 0); // Solidity automatically throws when dividing by 0
27   uint256 c = a / b;
28   // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29   return c;
30 }
31 
32 function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33   assert(b <= a);
34   return a - b;
35 }
36 
37 function add(uint256 a, uint256 b) internal constant returns (uint256) {
38   uint256 c = a + b;
39   assert(c >= a);
40   return c;
41 }
42 }
43 
44 contract BitClemm is IERC20{
45  using SafeMath for uint256;
46  
47  uint256 public _totalSupply = 0;
48  
49  
50  string public symbol = "BCM";//Simbolo del token es. ETH
51  string public constant name = "BitClemm"; //Nome del token es. Ethereum
52  uint256 public constant decimals = 3; //Numero di decimali del token, il bitcoin ne ha 8, ethereum 18
53  
54  uint256 public MAX_SUPPLY = 180000000 * 10**decimals; //Numero massimo di token da emettere ( 1000 )
55  uint256 public TOKEN_TO_CREATOR = 9000000 * 10**decimals; //Token da inviare al creatore del contratto
56 
57  uint256 public constant RATE = 1000; //Quanti token inviare per ogni ether ricevuto
58  address public owner;
59  
60  mapping(address => uint256) balances;
61  mapping(address => mapping(address => uint256)) allowed;
62  
63  //Funzione che permette di ricevere token solo specificando l'indirizzo
64  function() payable{
65      createTokens();
66  }
67  
68  //Salviamo l'indirizzo del creatore del contratto per inviare gli ether ricevuti
69  function BitClemm(){
70      owner = msg.sender;
71      balances[msg.sender] = TOKEN_TO_CREATOR;
72      _totalSupply = _totalSupply.add(TOKEN_TO_CREATOR);
73  }
74  
75  //Creazione dei token
76  function createTokens() payable{
77      //Controlliamo che gli ether ricevuti siano maggiori di 0
78      require(msg.value >= 0);
79      
80      //Creiamo una variabile che contiene gli ether ricevuti moltiplicati per il RATE
81      uint256 tokens = msg.value.mul(10 ** decimals);
82      tokens = tokens.mul(RATE);
83      tokens = tokens.div(10 ** 18);
84 
85      uint256 sum = _totalSupply.add(tokens);
86      require(sum <= MAX_SUPPLY);
87      //Aggiungiamo i token al bilancio di chi ci ha inviato gli ether ed aumentiamo la variabile totalSupply
88      balances[msg.sender] = balances[msg.sender].add(tokens);
89      _totalSupply = sum;
90      
91      //Inviamo gli ether a chi ha creato il contratto
92      owner.transfer(msg.value);
93  }
94 
95  
96  //Ritorna il numero totale di token
97  function totalSupply() constant returns (uint totalSupply){
98      return _totalSupply;
99  }
100  
101  //Ritorna il bilancio dell'utente di un indirizzo
102  function balanceOf(address _owner) constant returns (uint balance){
103      return balances[_owner];
104  }
105  
106  //Per inviare i Token
107  function transfer(address _to, uint256 _value) returns (bool success){
108      //Controlliamo che chi voglia inviare i token ne abbia a sufficienza e che ne voglia inviare più di 0
109      require(
110          balances[msg.sender] >= _value
111          && _value > 0
112      );
113      //Togliamo i token inviati dal suo bilancio
114      balances[msg.sender] = balances[msg.sender].sub(_value);
115      //Li aggiungiamo al bilancio del ricevente
116      balances[_to] = balances[_to].add(_value);
117      //Chiamiamo l evento transfer
118      Transfer(msg.sender, _to, _value);
119      return true;
120  }
121  
122  //Invio dei token con delega
123  function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
124      //Controlliamo che chi voglia inviare token da un indirizzo non suo abbia la delega per farlo, che
125      //l'account da dove vngono inviati i token abbia token a sufficienza e
126      //che i token inviati siano maggiori di 0
127      require(
128          allowed[_from][msg.sender] >= _value
129          && balances[msg.sender] >= _value
130          && _value > 0
131      );
132      //togliamo i token da chi li invia
133      balances[_from] = balances[_from].sub(_value);
134      //Aggiungiamoli al rcevente
135      balances[_to] = balances[_to].add(_value);
136      //Diminuiamo il valore dei token che il delegato può inviare in favore del delegante
137      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138      //Chiamaiamo l'evento transfer
139      Transfer(_from, _to, _value);
140      return true;
141  }
142  
143  //Delegare qualcuno all'invio di token
144  function approve(address _spender, uint256 _value) returns (bool success){
145      //Inseriamo l'indirizzo del delegato e il massimo che può inviare
146      allowed[msg.sender][_spender] = _value;
147      //Chiamiamo l'evento approval
148      Approval(msg.sender, _spender, _value);
149      return true;
150  }
151  
152  //Ritorna il numero di token che un delegato può ancora inviare
153  function allowance(address _owner, address _spender) constant returns (uint remaining){
154      return allowed[_owner][_spender];
155  }
156 
157  event Transfer(address indexed _from, address indexed _to, uint _value);
158  event Approval(address indexed _owner, address indexed _spender, uint _value);
159  
160 }