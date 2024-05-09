1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ERC223/Receiver_Interface.sol
4 
5 /*
6  * Contract that is working with ERC223 tokens
7  */
8  
9  contract ContractReceiver {
10      
11     struct TKN {
12         address sender;
13         uint value;
14         bytes data;
15         bytes4 sig;
16     }
17     
18     
19     function tokenFallback(address _from, uint _value, bytes _data) public pure {
20       TKN memory tkn;
21       tkn.sender = _from;
22       tkn.value = _value;
23       tkn.data = _data;
24       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
25       tkn.sig = bytes4(u);
26       
27       /* tkn variable is analogue of msg variable of Ether transaction
28       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
29       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
30       *  tkn.data is data of token transaction   (analogue of msg.data)
31       *  tkn.sig is 4 bytes signature of function
32       *  if data of token transaction is a function execution
33       */
34     }
35 }
36 
37 // File: contracts/ERC223/ERC223_Interface.sol
38 
39 /**
40  * ERC223 token by Dexaran
41  *
42  * https://github.com/Dexaran/ERC223-token-standard
43  *
44  * NOTE: original event was:
45  *    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
46  * however 'bytes indexed data' was replaced with 'bytes data' because of this issue with truffle tests:
47  * https://github.com/trufflesuite/truffle/issues/405
48  *
49  */
50 contract ERC223 {
51   uint public totalSupply;
52   function balanceOf(address who) public view returns (uint);
53 
54   function name() public view returns (string _name);
55   function symbol() public view returns (string _symbol);
56   function decimals() public view returns (uint8 _decimals);
57   function totalSupply() public view returns (uint256 _supply);
58 
59   function transfer(address to, uint value) public returns (bool ok);
60   function transfer(address to, uint value, bytes data) public returns (bool ok);
61   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
62 
63   event Transfer(address indexed from, address indexed to, uint value, bytes data);
64 }
65 
66 // File: contracts/ERC223/ERC223_Token.sol
67 
68 /**
69  * ERC223 token by Dexaran
70  *
71  * https://github.com/Dexaran/ERC223-token-standard
72  */
73 
74 
75  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
76 contract SafeMath {
77     uint256 constant public MAX_UINT256 =
78     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
79 
80     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
81         if (x > MAX_UINT256 - y) revert();
82         return x + y;
83     }
84 
85     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
86         if (x < y) revert();
87         return x - y;
88     }
89 
90     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
91         if (y == 0) return 0;
92         if (x > MAX_UINT256 / y) revert();
93         return x * y;
94     }
95 }
96 
97 contract ERC223Token is ERC223, SafeMath {
98 
99   mapping(address => uint) balances;
100 
101   string public name;
102   string public symbol;
103   uint8 public decimals;
104   uint256 public totalSupply;
105 
106 
107   // Function to access name of token .
108   function name() public view returns (string _name) {
109       return name;
110   }
111   // Function to access symbol of token .
112   function symbol() public view returns (string _symbol) {
113       return symbol;
114   }
115   // Function to access decimals of token .
116   function decimals() public view returns (uint8 _decimals) {
117       return decimals;
118   }
119   // Function to access total supply of tokens .
120   function totalSupply() public view returns (uint256 _totalSupply) {
121       return totalSupply;
122   }
123 
124 
125   // Function that is called when a user or another contract wants to transfer funds .
126   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
127 
128     if(isContract(_to)) {
129         if (balanceOf(msg.sender) < _value) revert();
130         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
131         balances[_to] = safeAdd(balanceOf(_to), _value);
132         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
133         emit Transfer(msg.sender, _to, _value, _data);
134         return true;
135     }
136     else {
137         return transferToAddress(_to, _value, _data);
138     }
139 }
140 
141 
142   // Function that is called when a user or another contract wants to transfer funds .
143   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
144 
145     if(isContract(_to)) {
146         return transferToContract(_to, _value, _data);
147     }
148     else {
149         return transferToAddress(_to, _value, _data);
150     }
151 }
152 
153   // Standard function transfer similar to ERC20 transfer with no _data .
154   // Added due to backwards compatibility reasons .
155   function transfer(address _to, uint _value) public returns (bool success) {
156 
157     //standard function transfer similar to ERC20 transfer with no _data
158     //added due to backwards compatibility reasons
159     bytes memory empty;
160     if(isContract(_to)) {
161         return transferToContract(_to, _value, empty);
162     }
163     else {
164         return transferToAddress(_to, _value, empty);
165     }
166 }
167 
168   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
169   function isContract(address _addr) private view returns (bool is_contract) {
170       uint length;
171       assembly {
172             //retrieve the size of the code on target address, this needs assembly
173             length := extcodesize(_addr)
174       }
175       return (length>0);
176     }
177 
178   //function that is called when transaction target is an address
179   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
180     if (balanceOf(msg.sender) < _value) revert();
181     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
182     balances[_to] = safeAdd(balanceOf(_to), _value);
183     emit Transfer(msg.sender, _to, _value, _data);
184     return true;
185   }
186 
187   //function that is called when transaction target is a contract
188   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
189     if (balanceOf(msg.sender) < _value) revert();
190     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
191     balances[_to] = safeAdd(balanceOf(_to), _value);
192     ContractReceiver receiver = ContractReceiver(_to);
193     receiver.tokenFallback(msg.sender, _value, _data);
194     emit Transfer(msg.sender, _to, _value, _data);
195     return true;
196 }
197 
198 
199   function balanceOf(address _owner) public view returns (uint balance) {
200     return balances[_owner];
201   }
202 }
203 
204 // File: contracts\ERC223\TokenMintERC223Token.sol
205 
206 /**
207  * @title TokenMintERC223Token
208  * @author TokenMint.io
209  *
210  * @dev Standard ERC223 token implementation. For full specification see:
211  * https://github.com/Dexaran/ERC223-token-standard
212  */
213 contract TokenMintERC223Token is ERC223Token {
214 
215   constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address feeReceiver, address tokenOwnerAddress) public payable {
216     name = _name;
217     symbol = _symbol;
218     decimals = _decimals;
219     totalSupply = _totalSupply;
220 
221     // set tokenOwnerAddress as owner of all tokens
222     balances[tokenOwnerAddress] = totalSupply;
223     emit Transfer(address(0), tokenOwnerAddress, totalSupply, "");
224 
225     // pay the service fee for contract deployment
226     feeReceiver.transfer(msg.value);
227   }
228 }