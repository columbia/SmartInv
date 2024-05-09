1 pragma solidity ^0.4.9;
2 
3  contract ContractReceiver {
4      
5     struct TKN {
6         address sender;
7         uint value;
8         bytes data;
9         bytes4 sig;
10     }
11     
12     
13     function tokenFallback(address _from, uint _value, bytes _data) public pure {
14       TKN memory tkn;
15       tkn.sender = _from;
16       tkn.value = _value;
17       tkn.data = _data;
18       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
19       tkn.sig = bytes4(u);
20       
21       /* tkn variable is analogue of msg variable of Ether transaction
22       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
23       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
24       *  tkn.data is data of token transaction   (analogue of msg.data)
25       *  tkn.sig is 4 bytes signature of function
26       *  if data of token transaction is a function execution
27       */
28     }
29 }
30 
31 contract ERC223 {
32   uint public totalSupply;
33   function balanceOf(address who) public view returns (uint);
34   
35   function name() public view returns (string _name);
36   function symbol() public view returns (string _symbol);
37   function decimals() public view returns (uint8 _decimals);
38   function totalSupply() public view returns (uint256 _supply);
39 
40   function transfer(address to, uint value) public returns (bool ok);
41   function transfer(address to, uint value, bytes data) public returns (bool ok);
42   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
43   
44   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
45 }
46 
47  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
48 contract SafeMath {
49     uint256 constant public MAX_UINT256 =
50     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
51 
52     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
53         if (x > MAX_UINT256 - y) revert();
54         return x + y;
55     }
56 
57     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
58         if (x < y) revert();
59         return x - y;
60     }
61 
62     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
63         if (y == 0) return 0;
64         if (x > MAX_UINT256 / y) revert();
65         return x * y;
66     }
67 }
68  
69 contract ERC223Token is ERC223, SafeMath {
70 
71   mapping(address => uint) balances;
72   
73   string public name;
74   string public symbol;
75   uint8 public decimals;
76   uint256 public totalSupply;
77   
78   
79   // Function to access name of token .
80   function name() public view returns (string _name) {
81       return name;
82   }
83   // Function to access symbol of token .
84   function symbol() public view returns (string _symbol) {
85       return symbol;
86   }
87   // Function to access decimals of token .
88   function decimals() public view returns (uint8 _decimals) {
89       return decimals;
90   }
91   // Function to access total supply of tokens .
92   function totalSupply() public view returns (uint256 _totalSupply) {
93       return totalSupply;
94   }
95   
96   
97   // Function that is called when a user or another contract wants to transfer funds .
98   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
99       
100     if(isContract(_to)) {
101         if (balanceOf(msg.sender) < _value) revert();
102         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
103         balances[_to] = safeAdd(balanceOf(_to), _value);
104         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
105         emit Transfer(msg.sender, _to, _value, _data);
106         return true;
107     }
108     else {
109         return transferToAddress(_to, _value, _data);
110     }
111 }
112   
113 
114   // Function that is called when a user or another contract wants to transfer funds .
115   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
116       
117     if(isContract(_to)) {
118         return transferToContract(_to, _value, _data);
119     }
120     else {
121         return transferToAddress(_to, _value, _data);
122     }
123 }
124   
125   // Standard function transfer similar to ERC20 transfer with no _data .
126   // Added due to backwards compatibility reasons .
127   function transfer(address _to, uint _value) public returns (bool success) {
128       
129     //standard function transfer similar to ERC20 transfer with no _data
130     //added due to backwards compatibility reasons
131     bytes memory empty;
132     if(isContract(_to)) {
133         return transferToContract(_to, _value, empty);
134     }
135     else {
136         return transferToAddress(_to, _value, empty);
137     }
138 }
139 
140   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
141   function isContract(address _addr) private view returns (bool is_contract) {
142       uint length;
143       assembly {
144             //retrieve the size of the code on target address, this needs assembly
145             length := extcodesize(_addr)
146       }
147       return (length>0);
148     }
149 
150   //function that is called when transaction target is an address
151   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
152     if (balanceOf(msg.sender) < _value) revert();
153     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
154     balances[_to] = safeAdd(balanceOf(_to), _value);
155     emit Transfer(msg.sender, _to, _value, _data);
156     return true;
157   }
158   
159   //function that is called when transaction target is a contract
160   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
161     if (balanceOf(msg.sender) < _value) revert();
162     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
163     balances[_to] = safeAdd(balanceOf(_to), _value);
164     ContractReceiver receiver = ContractReceiver(_to);
165     receiver.tokenFallback(msg.sender, _value, _data);
166     emit Transfer(msg.sender, _to, _value, _data);
167     return true;
168 }
169 
170 
171   function balanceOf(address _owner) public view returns (uint balance) {
172     return balances[_owner];
173   }
174 }
175 
176 
177 contract BlockMobaToken is ERC223Token {
178     
179   constructor () public  {
180     uint256 initialSupply = 1000000000;
181     name = "BlockMobaToken";                                   // Set the name for display purposes
182     symbol = "MOBA";
183     decimals = 6;
184     totalSupply = initialSupply * 10 ** uint256(decimals);
185     balances[msg.sender] = totalSupply;
186   }
187 }