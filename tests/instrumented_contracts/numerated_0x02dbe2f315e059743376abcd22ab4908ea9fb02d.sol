1 pragma solidity ^0.4.17;
2 
3 /* New ERC23 contract interface */
4 /* Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended */
5 /* Fully backward compatible with ERC20 */
6 contract ERC223 {
7     uint public totalSupply;
8     function balanceOf(address who) public constant returns (uint);
9 
10     function name() constant public returns (string _name);
11     function symbol() constant public returns (string _symbol);
12     function decimals() constant public returns (uint8 _decimals);
13     function totalSupply() constant public returns (uint256 _supply);
14 
15     function transfer(address to, uint value) public returns (bool ok);
16     function transfer(address to, uint value, bytes data) public returns (bool ok);
17     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
18     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
19 }
20 
21 /**
22  * Include SafeMath Lib
23  */
24 contract SafeMath {
25     uint256 constant public MAX_UINT256 =
26     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
27 
28     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
29         if (x > MAX_UINT256 - y)
30             revert();
31         return x + y;
32     }
33 
34     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
35         if (x < y) {
36             revert();
37         }
38         return x - y;
39     }
40 
41     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
42         if (y == 0) {
43             return 0;
44         }
45         if (x > MAX_UINT256 / y) {
46             revert();
47         }
48         return x * y;
49     }
50 }
51 
52 
53 /*
54  * Contract that is working with ERC223 tokens
55  */
56  contract ContractReceiver {
57 
58     struct TKN {
59         address sender;
60         uint value;
61         bytes data;
62         bytes4 sig;
63     }
64 
65     function tokenFallback(address _from, uint _value, bytes _data) public {
66       TKN memory tkn;
67       tkn.sender = _from;
68       tkn.value = _value;
69       tkn.data = _data;
70       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
71       tkn.sig = bytes4(u);
72 
73       /* tkn variable is analogue of msg variable of Ether transaction
74       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
75       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
76       *  tkn.data is data of token transaction   (analogue of msg.data)
77       *  tkn.sig is 4 bytes signature of function
78       *  if data of token transaction is a function execution
79       */
80     }
81 }
82 
83 contract EDOGE is ERC223, SafeMath {
84 
85     string public name = "eDogecoin";
86 
87     string public symbol = "EDOGE";
88 
89     uint8 public decimals = 8;
90 
91     uint256 public totalSupply = 100000000000 * 10**8;
92 
93     address public owner;
94 
95     bool public unlocked = false;
96 
97     bool public tokenCreated = false;
98 
99     mapping(address => uint256) balances;
100 
101     mapping(address => mapping (address => uint256)) allowed;
102 
103     // Initialize to have owner have 100,000,000,000 EDOGE on contract creation
104     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
105     function EDOGE() public {
106 
107         // Security check in case EVM has future flaw or exploit to call constructor multiple times
108         // Ensure token gets created once only
109         require(tokenCreated == false);
110         tokenCreated = true;
111 
112         owner = msg.sender;
113         balances[owner] = totalSupply;
114 
115         // Final sanity check to ensure owner balance is greater than zero
116         require(balances[owner] > 0);
117     }
118 
119     modifier onlyOwner() {
120         require(msg.sender == owner);
121         _;
122     }
123 
124     // Function to distribute tokens to list of addresses by the provided amount
125     // Verify and require that:
126     // - Balance of owner cannot be negative
127     // - All transfers can be fulfilled with remaining owner balance
128     // - No new tokens can ever be minted except originally created 100,000,000,000
129     function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public{
130         // Only proceed if there are enough tokens to be distributed to all addresses
131         // Never allow balance of owner to become negative
132         require(balances[owner] >= safeMul(addresses.length, amount));
133         for (uint i = 0; i < addresses.length; i++) {
134             balances[owner] = safeSub(balanceOf(owner), amount);
135             // Another sanity check to make sure owner balance can never be negative
136             require(balances[owner] >= 0);
137             balances[addresses[i]] = safeAdd(balanceOf(addresses[i]), amount);
138             transfer(addresses[i], amount);
139         }
140     }
141 
142     // Function to access name of token .sha
143     function name() constant public returns (string _name) {
144         return name;
145     }
146     // Function to access symbol of token .
147     function symbol() constant public returns (string _symbol) {
148         return symbol;
149     }
150     // Function to access decimals of token .
151     function decimals() constant public returns (uint8 _decimals) {
152         return decimals;
153     }
154     // Function to access total supply of tokens .
155     function totalSupply() constant public returns (uint256 _totalSupply) {
156         return totalSupply;
157     }
158 
159     // Function that is called when a user or another contract wants to transfer funds .
160     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
161 
162         // Only allow transfer once unlocked
163         // Once it is unlocked, it is unlocked forever and no one can lock again
164         require(unlocked);
165 
166         if (isContract(_to)) {
167             if (balanceOf(msg.sender) < _value) {
168                 revert();
169             }
170             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
171             balances[_to] = safeAdd(balanceOf(_to), _value);
172             ContractReceiver receiver = ContractReceiver(_to);
173             receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);
174             Transfer(msg.sender, _to, _value, _data);
175             return true;
176         } else {
177             return transferToAddress(_to, _value, _data);
178         }
179     }
180 
181     // Function that is called when a user or another contract wants to transfer funds .
182     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
183 
184         // Only allow transfer once unlocked
185         // Once it is unlocked, it is unlocked forever and no one can lock again
186         require(unlocked);
187 
188         if (isContract(_to)) {
189             return transferToContract(_to, _value, _data);
190         } else {
191             return transferToAddress(_to, _value, _data);
192         }
193     }
194 
195     // Standard function transfer similar to ERC20 transfer with no _data .
196     // Added due to backwards compatibility reasons .
197     function transfer(address _to, uint _value) public returns (bool success) {
198 
199         // Only allow transfer once unlocked
200         // Once it is unlocked, it is unlocked forever and no one can lock again
201         require(unlocked);
202 
203         //standard function transfer similar to ERC20 transfer with no _data
204         //added due to backwards compatibility reasons
205         bytes memory empty;
206         if (isContract(_to)) {
207             return transferToContract(_to, _value, empty);
208         } else {
209             return transferToAddress(_to, _value, empty);
210         }
211     }
212 
213     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
214     function isContract(address _addr) private returns (bool is_contract) {
215         uint length;
216         assembly {
217             //retrieve the size of the code on target address, this needs assembly
218             length := extcodesize(_addr)
219         }
220         return (length > 0);
221     }
222 
223     // function that is called when transaction target is an address
224     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
225         if (balanceOf(msg.sender) < _value) {
226             revert();
227         }
228         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
229         balances[_to] = safeAdd(balanceOf(_to), _value);
230         Transfer(msg.sender, _to, _value, _data);
231         return true;
232     }
233 
234     //function that is called when transaction target is a contract
235     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
236         if (balanceOf(msg.sender) < _value) {
237             revert();
238         }
239         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
240         balances[_to] = safeAdd(balanceOf(_to), _value);
241         ContractReceiver receiver = ContractReceiver(_to);
242         receiver.tokenFallback(msg.sender, _value, _data);
243         Transfer(msg.sender, _to, _value, _data);
244         return true;
245     }
246 
247     // Get balance of the address provided
248     function balanceOf(address _owner) constant public returns (uint256 balance) {
249         return balances[_owner];
250     }
251 
252      // Creator/Owner can unlocked it once and it can never be locked again
253      // Use after airdrop is complete
254     function unlockForever() onlyOwner public {
255         unlocked = true;
256     }
257 }