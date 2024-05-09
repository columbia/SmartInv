1 pragma solidity ^0.4.13;
2 
3 contract ERC223 {
4     mapping(address => uint) balances;
5     
6   uint public totalSupply;
7   function balanceOf(address who) public view returns (uint);
8   
9   
10   function ERC223() {
11     balances[0x1b6c2e31744dce7577109e05E7C54f6F96191804] = totalSupply;    
12   }
13   
14   function name() public view returns (string _name);
15   function symbol() public view returns (string _symbol);
16   function decimals() public view returns (uint8 _decimals);
17   function totalSupply() public view returns (uint256 _supply);
18 
19   function transfer(address to, uint value) public returns (bool ok);
20   function transfer(address to, uint value, bytes data) public returns (bool ok);
21   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
22   
23   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
24 }
25 
26 contract SafeMath {
27     uint256 constant public MAX_UINT256 =
28     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
29 
30     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
31         if (x > MAX_UINT256 - y) revert();
32         return x + y;
33     }
34 
35     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
36         if (x < y) revert();
37         return x - y;
38     }
39 
40     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
41         if (y == 0) return 0;
42         if (x > MAX_UINT256 / y) revert();
43         return x * y;
44     }
45 }
46 
47 contract ERC223Token is ERC223, SafeMath {
48 
49   mapping(address => uint) balances;
50   
51   string public name = "ServerCube Coin";
52   string public symbol = "SCC";
53   uint8 public decimals = 0;
54   uint256 public totalSupply = 80000000;
55   
56   function ERC223Token() { 
57       balances[0xC193DbDeD670C425301FCB0dA5BAaBdeC8A1819d] = totalSupply;
58   }
59   
60   // Function to access name of token .
61   function name() public view returns (string _name) {
62       return name;
63   }
64   // Function to access symbol of token .
65   function symbol() public view returns (string _symbol) {
66       return symbol;
67   }
68   // Function to access decimals of token .
69   function decimals() public view returns (uint8 _decimals) {
70       return decimals;
71   }
72   // Function to access total supply of tokens .
73   function totalSupply() public view returns (uint256 _totalSupply) {
74       return totalSupply;
75   }
76   
77   
78   // Function that is called when a user or another contract wants to transfer funds .
79   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
80       
81     if(isContract(_to)) {
82         if (balanceOf(msg.sender) < _value) revert();
83         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
84         balances[_to] = safeAdd(balanceOf(_to), _value);
85         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
86         Transfer(msg.sender, _to, _value, _data);
87         return true;
88     }
89     else {
90         return transferToAddress(_to, _value, _data);
91     }
92 }
93   
94 
95   // Function that is called when a user or another contract wants to transfer funds .
96   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
97       
98     if(isContract(_to)) {
99         return transferToContract(_to, _value, _data);
100     }
101     else {
102         return transferToAddress(_to, _value, _data);
103     }
104 }
105   
106   // Standard function transfer similar to ERC20 transfer with no _data .
107   // Added due to backwards compatibility reasons .
108   function transfer(address _to, uint _value) public returns (bool success) {
109       
110     //standard function transfer similar to ERC20 transfer with no _data
111     //added due to backwards compatibility reasons
112     bytes memory empty;
113     if(isContract(_to)) {
114         return transferToContract(_to, _value, empty);
115     }
116     else {
117         return transferToAddress(_to, _value, empty);
118     }
119 }
120 
121   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
122   function isContract(address _addr) private view returns (bool is_contract) {
123       uint length;
124       assembly {
125             //retrieve the size of the code on target address, this needs assembly
126             length := extcodesize(_addr)
127       }
128       return (length>0);
129     }
130 
131   //function that is called when transaction target is an address
132   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
133     if (balanceOf(msg.sender) < _value) revert();
134     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
135     balances[_to] = safeAdd(balanceOf(_to), _value);
136     Transfer(msg.sender, _to, _value, _data);
137     return true;
138   }
139   
140   //function that is called when transaction target is a contract
141   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
142     if (balanceOf(msg.sender) < _value) revert();
143     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
144     balances[_to] = safeAdd(balanceOf(_to), _value);
145     ContractReceiver receiver = ContractReceiver(_to);
146     receiver.tokenFallback(msg.sender, _value, _data);
147     Transfer(msg.sender, _to, _value, _data);
148     return true;
149 }
150 
151 
152   function balanceOf(address _owner) public view returns (uint balance) {
153     return balances[_owner];
154   }
155 }
156 
157 contract ContractReceiver {
158      
159     struct TKN {
160         address sender;
161         uint value;
162         bytes data;
163         bytes4 sig;
164     }
165     
166     
167     function tokenFallback(address _from, uint _value, bytes _data) public pure {
168       TKN memory tkn;
169       tkn.sender = _from;
170       tkn.value = _value;
171       tkn.data = _data;
172       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
173       tkn.sig = bytes4(u);
174       
175       /* tkn variable is analogue of msg variable of Ether transaction
176       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
177       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
178       *  tkn.data is data of token transaction   (analogue of msg.data)
179       *  tkn.sig is 4 bytes signature of function
180       *  if data of token transaction is a function execution
181       */
182     }
183 }