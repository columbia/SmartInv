1 pragma solidity ^0.4.23;
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
85   uint256 public totalSupply = 0;
86   uint256 exchange = 1000000;
87   uint256 endICO = 0;
88   address admin;
89   
90   constructor() public {
91       balances[msg.sender]=1000000000000000000000000;
92       admin = msg.sender;
93       
94       endICO=block.timestamp+(60*60*24*31); // 31 days
95   }
96   
97   // Function to access name of token .
98   function name() public view returns (string _name) {
99       return name;
100   }
101   // Function to access symbol of token .
102   function symbol() public view returns (string _symbol) {
103       return symbol;
104   }
105   // Function to access decimals of token .
106   function decimals() public view returns (uint8 _decimals) {
107       return decimals;
108   }
109   // Function to access total supply of tokens .
110   function totalSupply() public view returns (uint256 _totalSupply) {
111       return totalSupply;
112   }
113   
114   function () public payable{
115       
116       if(block.timestamp>endICO)revert("ICO OVER");
117       balances[msg.sender]=safeAdd(balances[msg.sender],safeMul(msg.value,exchange));
118       totalSupply=safeAdd(totalSupply,safeMul(msg.value,exchange)); // increase the supply
119       admin.transfer(address(this).balance);
120   }
121   
122   function getEndICO() public constant returns (uint256){
123       return endICO;
124   }
125   
126   function getCurrentTime() public constant returns (uint256){
127       return block.timestamp;
128   }
129   
130   // Function that is called when a user or another contract wants to transfer funds .
131   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
132       
133     if(isContract(_to)) {
134         if (balanceOf(msg.sender) < _value) revert();
135         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
136         balances[_to] = safeAdd(balanceOf(_to), _value);
137         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
138         Transfer(msg.sender, _to, _value, _data);
139         return true;
140     }
141     else {
142         return transferToAddress(_to, _value, _data);
143     }
144 }
145   
146 
147   // Function that is called when a user or another contract wants to transfer funds .
148   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
149       
150     if(isContract(_to)) {
151         return transferToContract(_to, _value, _data);
152     }
153     else {
154         return transferToAddress(_to, _value, _data);
155     }
156 }
157   
158   // Standard function transfer similar to ERC20 transfer with no _data .
159   // Added due to backwards compatibility reasons .
160   function transfer(address _to, uint _value) public returns (bool success) {
161       
162     //standard function transfer similar to ERC20 transfer with no _data
163     //added due to backwards compatibility reasons
164     bytes memory empty;
165     if(isContract(_to)) {
166         return transferToContract(_to, _value, empty);
167     }
168     else {
169         return transferToAddress(_to, _value, empty);
170     }
171 }
172 
173   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
174   function isContract(address _addr) private view returns (bool is_contract) {
175       uint length;
176       assembly {
177             //retrieve the size of the code on target address, this needs assembly
178             length := extcodesize(_addr)
179       }
180       return (length>0);
181     }
182 
183   //function that is called when transaction target is an address
184   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
185     if (balanceOf(msg.sender) < _value) revert();
186     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
187     balances[_to] = safeAdd(balanceOf(_to), _value);
188     Transfer(msg.sender, _to, _value, _data);
189     return true;
190   }
191   
192   //function that is called when transaction target is a contract
193   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
194     if (balanceOf(msg.sender) < _value) revert();
195     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
196     balances[_to] = safeAdd(balanceOf(_to), _value);
197     ContractReceiver receiver = ContractReceiver(_to);
198     receiver.tokenFallback(msg.sender, _value, _data);
199     Transfer(msg.sender, _to, _value, _data);
200     return true;
201 }
202 
203 
204   function balanceOf(address _owner) public view returns (uint balance) {
205     return balances[_owner];
206   }
207 }