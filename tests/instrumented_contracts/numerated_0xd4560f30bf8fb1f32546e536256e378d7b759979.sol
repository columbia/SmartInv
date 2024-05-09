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
63   event Transfer(address indexed from, address indexed to, uint value);
64   event Transfer(address indexed from, address indexed to, uint value, bytes data);
65 }
66 
67 // File: contracts/ERC223/ERC223_Token.sol
68 
69 /**
70  * ERC223 token by Dexaran
71  *
72  * https://github.com/Dexaran/ERC223-token-standard
73  */
74 
75 
76  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
77 contract SafeMath {
78     uint256 constant public MAX_UINT256 =
79     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
80 
81     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
82         if (x > MAX_UINT256 - y) revert();
83         return x + y;
84     }
85 
86     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
87         if (x < y) revert();
88         return x - y;
89     }
90 
91     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
92         if (y == 0) return 0;
93         if (x > MAX_UINT256 / y) revert();
94         return x * y;
95     }
96 }
97 
98 contract ERC223Token is ERC223, SafeMath {
99 
100   mapping(address => uint) balances;
101 
102   string public name;
103   string public symbol;
104   uint8 public decimals;
105   uint256 public totalSupply;
106 
107 
108   // Function to access name of token .
109   function name() public view returns (string _name) {
110       return name;
111   }
112   // Function to access symbol of token .
113   function symbol() public view returns (string _symbol) {
114       return symbol;
115   }
116   // Function to access decimals of token .
117   function decimals() public view returns (uint8 _decimals) {
118       return decimals;
119   }
120   // Function to access total supply of tokens .
121   function totalSupply() public view returns (uint256 _totalSupply) {
122       return totalSupply;
123   }
124 
125 
126   // Function that is called when a user or another contract wants to transfer funds .
127   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
128 
129     if(isContract(_to)) {
130         if (balanceOf(msg.sender) < _value) revert();
131         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
132         balances[_to] = safeAdd(balanceOf(_to), _value);
133         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
134         emit Transfer(msg.sender, _to, _value);
135         emit Transfer(msg.sender, _to, _value, _data);
136         return true;
137     }
138     else {
139         return transferToAddress(_to, _value, _data);
140     }
141 }
142 
143 
144   // Function that is called when a user or another contract wants to transfer funds .
145   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
146 
147     if(isContract(_to)) {
148         return transferToContract(_to, _value, _data);
149     }
150     else {
151         return transferToAddress(_to, _value, _data);
152     }
153 }
154 
155   // Standard function transfer similar to ERC20 transfer with no _data .
156   // Added due to backwards compatibility reasons .
157   function transfer(address _to, uint _value) public returns (bool success) {
158 
159     //standard function transfer similar to ERC20 transfer with no _data
160     //added due to backwards compatibility reasons
161     bytes memory empty;
162     if(isContract(_to)) {
163         return transferToContract(_to, _value, empty);
164     }
165     else {
166         return transferToAddress(_to, _value, empty);
167     }
168 }
169 
170   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
171   function isContract(address _addr) private view returns (bool is_contract) {
172       uint length;
173       assembly {
174             //retrieve the size of the code on target address, this needs assembly
175             length := extcodesize(_addr)
176       }
177       return (length>0);
178     }
179 
180   //function that is called when transaction target is an address
181   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
182     if (balanceOf(msg.sender) < _value) revert();
183     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
184     balances[_to] = safeAdd(balanceOf(_to), _value);
185     emit Transfer(msg.sender, _to, _value);
186     emit Transfer(msg.sender, _to, _value, _data);
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
197     emit Transfer(msg.sender, _to, _value);
198     emit Transfer(msg.sender, _to, _value, _data);
199     return true;
200 }
201 
202 
203   function balanceOf(address _owner) public view returns (uint balance) {
204     return balances[_owner];
205   }
206 }
207 
208 // File: contracts\ERC223\TokenMintERC223Token.sol
209 
210 /**
211  * @title TokenMintERC223Token
212  * @author TokenMint.io
213  *
214  * @dev Standard ERC223 token implementation. For full specification see:
215  * https://github.com/Dexaran/ERC223-token-standard
216  */
217 contract TokenMintERC223Token is ERC223Token {
218 
219   constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address feeReceiver, address tokenOwnerAddress) public payable {
220     name = _name;
221     symbol = _symbol;
222     decimals = _decimals;
223     totalSupply = _totalSupply;
224 
225     // set tokenOwnerAddress as owner of all tokens
226     balances[tokenOwnerAddress] = totalSupply;
227     emit Transfer(address(0), tokenOwnerAddress, totalSupply);
228     emit Transfer(address(0), tokenOwnerAddress, totalSupply, "");
229 
230     // pay the service fee for contract deployment
231     feeReceiver.transfer(msg.value);
232   }
233 }