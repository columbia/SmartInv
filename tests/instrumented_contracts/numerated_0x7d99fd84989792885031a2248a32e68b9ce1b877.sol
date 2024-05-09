1 // Here's the contract code btw, might as well drop it as it's all that's needed now besides compiler version:
2 pragma solidity ^0.4.16;
3 
4 // ---------------------------------------------
5 // The specification of the token
6 // ---------------------------------------------
7 // Name   : bitgrit
8 // Symbol : GRIT
9 // 18 digits of decimal point
10 // The issue upper limit: 1,000,000,000
11 // ---------------------------------------------
12 
13 /* https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Interface.sol */
14 contract ERC223 {
15     uint256 public totalSupply;
16 
17     function balanceOf(address who) public view returns (uint256);
18 
19     function name() public view returns (string _name);
20     function symbol() public view returns (string _symbol);
21     function decimals() public view returns (uint8 _decimals);
22     function totalSupply() public view returns (uint256 _supply);
23 
24     function transfer(address to, uint256 value) public returns (bool ok);
25     function transfer(address to, uint256 value, bytes data) public returns (bool ok);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
29 }
30 
31 
32 /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
33 contract SafeMath {
34     uint256 constant MAX_UINT256 =
35     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
36 
37     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
38         if (x > MAX_UINT256 - y) revert();
39         return x + y;
40     }
41 
42     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
43         if (x < y) revert();
44         return x - y;
45     }
46 
47     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
48         if (y == 0) return 0;
49         if (x > MAX_UINT256 / y) revert();
50         return x * y;
51     }
52 }
53 
54 
55 /* https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol */
56 contract ERC223Token is ERC223, SafeMath {
57 
58     mapping (address => uint256) balances;
59 
60     string public name;
61     string public symbol;
62     uint8 public decimals;
63     uint256 public totalSupply;
64 
65     // Function to access name of token .
66     function name() public view returns (string _name) {
67         return name;
68     }
69 
70     // Function to access symbol of token .
71     function symbol() public view returns (string _symbol) {
72         return symbol;
73     }
74 
75     // Function to access decimals of token .
76     function decimals() public view returns (uint8 _decimals) {
77         return decimals;
78     }
79 
80     // Function to access total supply of tokens .
81     function totalSupply() public view returns (uint256 _totalSupply) {
82         return totalSupply;
83     }
84 
85     // Function that is called when a user or another contract wants to transfer funds .
86     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
87 
88         if (isContract(_to)) {
89             return transferToContract(_to, _value, _data);
90         }
91         else {
92             return transferToAddress(_to, _value, _data);
93         }
94     }
95 
96     // Standard function transfer similar to ERC20 transfer with no _data .
97     // Added due to backwards compatibility reasons .
98     function transfer(address _to, uint256 _value) public returns (bool success) {
99 
100         //standard function transfer similar to ERC20 transfer with no _data
101         //added due to backwards compatibility reasons
102         bytes memory empty;
103         if (isContract(_to)) {
104             return transferToContract(_to, _value, empty);
105         }
106         else {
107             return transferToAddress(_to, _value, empty);
108         }
109     }
110 
111     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
112     function isContract(address _addr) private view returns (bool is_contract) {
113         uint256 length;
114         assembly {
115         //retrieve the size of the code on target address, this needs assembly
116             length := extcodesize(_addr)
117         }
118         return (length > 0);
119     }
120 
121     //function that is called when transaction target is an address
122     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
123         if (balanceOf(msg.sender) < _value) revert();
124         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
125         balances[_to] = safeAdd(balanceOf(_to), _value);
126         emit Transfer(msg.sender, _to, _value);
127         emit Transfer(msg.sender, _to, _value, _data);
128         return true;
129     }
130 
131     //function that is called when transaction target is a contract
132     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
133         if (balanceOf(msg.sender) < _value) revert();
134         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
135         balances[_to] = safeAdd(balanceOf(_to), _value);
136         ContractReceiver receiver = ContractReceiver(_to);
137         receiver.tokenFallback(msg.sender, _value, _data);
138         emit Transfer(msg.sender, _to, _value);
139         emit Transfer(msg.sender, _to, _value, _data);
140         return true;
141     }
142 
143     function balanceOf(address _owner) public view returns (uint256 balance) {
144         return balances[_owner];
145     }
146 }
147 
148 
149 /* https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/Receiver_Interface.sol */
150 contract ContractReceiver {
151 
152     struct TKN {
153         address sender;
154         uint256 value;
155         bytes data;
156         bytes4 sig;
157     }
158 
159     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
160         TKN memory tkn;
161         tkn.sender = _from;
162         tkn.value = _value;
163         tkn.data = _data;
164         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
165         tkn.sig = bytes4(u);
166 
167         /* tkn variable is analogue of msg variable of Ether transaction
168         *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
169         *  tkn.value the number of tokens that were sent   (analogue of msg.value)
170         *  tkn.data is data of token transaction   (analogue of msg.data)
171         *  tkn.sig is 4 bytes signature of function
172         *  if data of token transaction is a function execution
173         */
174     }
175 }
176 
177 
178 contract bitgrit is ERC223Token {
179 
180     string public name = "bitgrit";
181 
182     string public symbol = "GRIT";
183 
184     uint8 public decimals = 18;
185 
186     uint256 public totalSupply = 1000000000 * (10 ** uint256(decimals));
187 
188     address public owner;
189 
190     // ---------------------------------------------
191     // Modification : Only an owner can carry out.
192     // ---------------------------------------------
193     modifier onlyOwner() {
194         require(msg.sender == owner);
195         _;
196     }
197 
198     // ---------------------------------------------
199     // Constructor
200     // ---------------------------------------------
201     function bitgrit() public {
202         // The owner address is maintained.
203         owner = msg.sender;
204 
205         // All tokens are allocated to an owner.
206         balances[owner] = totalSupply;
207     }
208 
209     // ---------------------------------------------
210     // Destruction of a contract (only owner)
211     // ---------------------------------------------
212     function destory() public onlyOwner {
213         selfdestruct(owner);
214     }
215 
216 }