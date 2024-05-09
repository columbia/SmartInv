1 pragma solidity ^0.4.9;
2 
3 //import "./Receiver_Interface.sol";
4  contract ContractReceiver {
5      
6     struct TKN {
7         address sender;
8         uint value;
9         bytes data;
10         bytes4 sig;
11     }
12     
13     
14     function tokenFallback(address _from, uint _value, bytes _data) public pure {
15       TKN memory tkn;
16       tkn.sender = _from;
17       tkn.value = _value;
18       tkn.data = _data;
19       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
20       tkn.sig = bytes4(u);
21       
22       /* tkn variable is analogue of msg variable of Ether transaction
23       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
24       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
25       *  tkn.data is data of token transaction   (analogue of msg.data)
26       *  tkn.sig is 4 bytes signature of function
27       *  if data of token transaction is a function execution
28       */
29     }
30 }
31 
32 //import "./ERC223_Interface.sol";
33 contract ERC223 {
34   uint public totalSupply;
35   function balanceOf(address who) public view returns (uint);
36   
37   function name() public view returns (string _name);
38   function symbol() public view returns (string _symbol);
39   function decimals() public view returns (uint8 _decimals);
40   function totalSupply() public view returns (uint256 _supply);
41 
42   function transfer(address to, uint value) public returns (bool ok);
43   function transfer(address to, uint value, bytes data) public returns (bool ok);
44   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
45   
46   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
47 }
48 
49  /**
50  * ERC223 token by Dexaran
51  *
52  * https://github.com/Dexaran/ERC223-token-standard
53  */
54  
55  
56  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
57 contract SafeMath {
58     uint256 constant public MAX_UINT256 =
59     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
60 
61     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
62         if (x > MAX_UINT256 - y) revert();
63         return x + y;
64     }
65 
66     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
67         if (x < y) revert();
68         return x - y;
69     }
70 
71     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
72         if (y == 0) return 0;
73         if (x > MAX_UINT256 / y) revert();
74         return x * y;
75     }
76 }
77  
78 contract PiperToken is ERC223, SafeMath {
79 
80   mapping(address => uint) balances;
81   
82   string public name = "Peid Piper Token";
83   string public symbol = "PIP";
84   uint8 public decimals = 18;
85   uint256 public totalSupply = 1000000000000000000000000;
86   uint256 exchange = 1000000;
87   uint256 endICO = 1527812056;
88   address admin;
89   
90   function PiperToken() public {
91       balances[msg.sender]=1000000000000000000000000;
92       admin = msg.sender;
93   }
94   
95   // Function to access name of token .
96   function name() public view returns (string _name) {
97       return name;
98   }
99   // Function to access symbol of token .
100   function symbol() public view returns (string _symbol) {
101       return symbol;
102   }
103   // Function to access decimals of token .
104   function decimals() public view returns (uint8 _decimals) {
105       return decimals;
106   }
107   // Function to access total supply of tokens .
108   function totalSupply() public view returns (uint256 _totalSupply) {
109       return totalSupply;
110   }
111   
112   function () public payable{
113       
114       if(block.timestamp>endICO)revert();
115       balances[msg.sender]=safeAdd(balances[msg.sender],safeMul(msg.value,exchange));
116       totalSupply=safeAdd(totalSupply,safeMul(msg.value,exchange)); // increase the supply
117       admin.transfer(address(this).balance);
118   }
119   
120   function getEndICO() public constant returns (uint256){
121       return endICO;
122   }
123   
124   function getCurrentTime() public constant returns (uint256){
125       return block.timestamp;
126   }
127   
128   // Function that is called when a user or another contract wants to transfer funds .
129   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
130       
131     if(isContract(_to)) {
132         if (balanceOf(msg.sender) < _value) revert();
133         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
134         balances[_to] = safeAdd(balanceOf(_to), _value);
135         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
136         Transfer(msg.sender, _to, _value, _data);
137         return true;
138     }
139     else {
140         return transferToAddress(_to, _value, _data);
141     }
142 }
143   
144 
145   // Function that is called when a user or another contract wants to transfer funds .
146   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
147       
148     if(isContract(_to)) {
149         return transferToContract(_to, _value, _data);
150     }
151     else {
152         return transferToAddress(_to, _value, _data);
153     }
154 }
155   
156   // Standard function transfer similar to ERC20 transfer with no _data .
157   // Added due to backwards compatibility reasons .
158   function transfer(address _to, uint _value) public returns (bool success) {
159       
160     //standard function transfer similar to ERC20 transfer with no _data
161     //added due to backwards compatibility reasons
162     bytes memory empty;
163     if(isContract(_to)) {
164         return transferToContract(_to, _value, empty);
165     }
166     else {
167         return transferToAddress(_to, _value, empty);
168     }
169 }
170 
171   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
172   function isContract(address _addr) private view returns (bool is_contract) {
173       uint length;
174       assembly {
175             //retrieve the size of the code on target address, this needs assembly
176             length := extcodesize(_addr)
177       }
178       return (length>0);
179     }
180 
181   //function that is called when transaction target is an address
182   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
183     if (balanceOf(msg.sender) < _value) revert();
184     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
185     balances[_to] = safeAdd(balanceOf(_to), _value);
186     Transfer(msg.sender, _to, _value, _data);
187     return true;
188   }
189   
190   //function that is called when transaction target is a contract
191   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
192     if (balanceOf(msg.sender) < _value) revert();
193     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
194     balances[_to] = safeAdd(balanceOf(_to), _value);
195     ContractReceiver receiver = ContractReceiver(_to);
196     receiver.tokenFallback(msg.sender, _value, _data);
197     Transfer(msg.sender, _to, _value, _data);
198     return true;
199 }
200 
201 
202   function balanceOf(address _owner) public view returns (uint balance) {
203     return balances[_owner];
204   }
205 }