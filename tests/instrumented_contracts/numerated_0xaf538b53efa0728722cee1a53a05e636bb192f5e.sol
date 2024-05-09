1 pragma solidity ^0.4.11;
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
32 
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
44 }
45 
46  /**
47  * ERC223 token by Dexaran
48  *
49  * https://github.com/Dexaran/ERC223-token-standard
50  */
51  
52  
53  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
54 contract SafeMath {
55     uint256 constant public MAX_UINT256 =
56     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
57 
58     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
59         if (x > MAX_UINT256 - y) revert();
60         return x + y;
61     }
62 
63     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
64         if (x < y) revert();
65         return x - y;
66     }
67 
68     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
69         if (y == 0) return 0;
70         if (x > MAX_UINT256 / y) revert();
71         return x * y;
72     }
73 }
74  
75 contract ERC223Token is ERC223, SafeMath {
76 
77   mapping(address => uint) balances;
78   
79   string public name;
80   string public symbol;
81   uint8 public decimals;
82   uint256 public totalSupply;
83   address public owner;
84   
85   event TransferEvent(address indexed from, address indexed to, uint value, bytes indexed data);
86   
87     constructor (address addr) public  {
88         uint256 initialSupply = 1000000000;
89         name = "BlockMobaToken";                                   // Set the name for display purposes
90         symbol = "MOBA";
91         decimals = 6;
92         totalSupply = initialSupply * 10 ** uint256(decimals);
93         balances[addr] = totalSupply;
94         owner = msg.sender;
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
114   
115   // Function that is called when a user or another contract wants to transfer funds .
116   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
117       
118     if(isContract(_to)) {
119         if (balanceOf(msg.sender) < _value) revert();
120         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
121         balances[_to] = safeAdd(balanceOf(_to), _value);
122         assert(_to.call.value(0)(bytes4(keccak256(abi.encodePacked(_custom_fallback))), msg.sender, _value, _data));
123         emit TransferEvent(msg.sender, _to, _value, _data);
124         return true;
125         
126       
127     }
128     else {
129         return transferToAddress(_to, _value, _data);
130     }
131 }
132   
133 
134   // Function that is called when a user or another contract wants to transfer funds .
135   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
136       
137     if(isContract(_to)) {
138         return transferToContract(_to, _value, _data);
139     }
140     else {
141         return transferToAddress(_to, _value, _data);
142     }
143 }
144   
145   // Standard function transfer similar to ERC20 transfer with no _data .
146   // Added due to backwards compatibility reasons .
147   function transfer(address _to, uint _value) public returns (bool success) {
148       
149     //standard function transfer similar to ERC20 transfer with no _data
150     //added due to backwards compatibility reasons
151     bytes memory empty;
152     if(isContract(_to)) {
153         return transferToContract(_to, _value, empty);
154     }
155     else {
156         return transferToAddress(_to, _value, empty);
157     }
158 }
159 
160   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
161   function isContract(address _addr) private view returns (bool is_contract) {
162       uint length;
163       assembly {
164             //retrieve the size of the code on target address, this needs assembly
165             length := extcodesize(_addr)
166       }
167       return (length>0);
168     }
169 
170   //function that is called when transaction target is an address
171   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
172     if (balanceOf(msg.sender) < _value) revert();
173     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
174     balances[_to] = safeAdd(balanceOf(_to), _value);
175     emit TransferEvent(msg.sender, _to, _value, _data);
176     return true;
177   }
178   
179   //function that is called when transaction target is a contract
180   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
181     if (balanceOf(msg.sender) < _value) revert();
182     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
183     balances[_to] = safeAdd(balanceOf(_to), _value);
184     ContractReceiver receiver = ContractReceiver(_to);
185     receiver.tokenFallback(msg.sender, _value, _data);
186     emit TransferEvent(msg.sender, _to, _value, _data);
187     return true;
188  }
189 
190 
191   function balanceOf(address _owner) public view returns (uint balance) {
192     return balances[_owner];
193   }
194 }