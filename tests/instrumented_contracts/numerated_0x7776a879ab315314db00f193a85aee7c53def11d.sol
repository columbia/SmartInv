1 pragma solidity ^0.4.17;
2 
3 /* ERC20 contract interface */
4 /* With ERC23/ERC223 Extensions */
5 /* Fully backward compatible with ERC20 */
6 /* Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended */
7 contract ERC20 {
8     uint public totalSupply;
9 
10     // ERC223 and ERC20 functions and events
11     function balanceOf(address who) public constant returns (uint);
12     function totalSupply() constant public returns (uint256 _supply);
13     function transfer(address to, uint value) public returns (bool ok);
14     function transfer(address to, uint value, bytes data) public returns (bool ok);
15     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
16     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
17 
18     // ERC223 functions
19     function name() constant public returns (string _name);
20     function symbol() constant public returns (string _symbol);
21     function decimals() constant public returns (uint8 _decimals);
22 
23     // ERC20 functions and events
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
25     function approve(address _spender, uint256 _value) returns (bool success);
26     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint _value);
29 }
30 
31 /**
32  * Include SafeMath Lib
33  */
34 contract SafeMath {
35     uint256 constant public MAX_UINT256 =
36     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
37 
38     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
39         if (x > MAX_UINT256 - y)
40             revert();
41         return x + y;
42     }
43 
44     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
45         if (x < y) {
46             revert();
47         }
48         return x - y;
49     }
50 
51     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
52         if (y == 0) {
53             return 0;
54         }
55         if (x > MAX_UINT256 / y) {
56             revert();
57         }
58         return x * y;
59     }
60 }
61 
62 /*
63  * Contract that is working with ERC223 tokens
64  */
65  contract ContractReceiver {
66 
67     struct TKN {
68         address sender;
69         uint value;
70         bytes data;
71         bytes4 sig;
72     }
73 
74     function tokenFallback(address _from, uint _value, bytes _data) public {
75       TKN memory tkn;
76       tkn.sender = _from;
77       tkn.value = _value;
78       tkn.data = _data;
79       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
80       tkn.sig = bytes4(u);
81 
82       /* tkn variable is analogue of msg variable of Ether transaction
83       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
84       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
85       *  tkn.data is data of token transaction   (analogue of msg.data)
86       *  tkn.sig is 4 bytes signature of function
87       *  if data of token transaction is a function execution
88       */
89     }
90 }
91 
92 /*
93  * EDOGE is an ERC20 token with ERC223 Extensions
94  */
95 contract ETHERCREDIT is ERC20, SafeMath {
96 
97     string public name = "EtherCREDIT";
98 
99     string public symbol = "ERC";
100 
101     uint8 public decimals = 8;
102 
103     uint256 public totalSupply = 300000000 * 10**8;
104 
105     address public owner;
106 
107 
108     bool public tokenCreated = false;
109 
110     mapping(address => uint256) balances;
111 
112     mapping(address => mapping (address => uint256)) allowed;
113 
114     function ETHERCREDIT() public {
115 
116         // Security check in case EVM has future flaw or exploit to call constructor multiple times
117         // Ensure token gets created once only
118         require(tokenCreated == false);
119         tokenCreated = true;
120 
121         owner = msg.sender;
122         balances[owner] = totalSupply;
123 
124         // Final sanity check to ensure owner balance is greater than zero
125         require(balances[owner] > 0);
126     }
127 
128     modifier onlyOwner() {
129         require(msg.sender == owner);
130         _;
131     }
132 
133 
134     // Function to access name of token .sha
135     function name() constant public returns (string _name) {
136         return name;
137     }
138     // Function to access symbol of token .
139     function symbol() constant public returns (string _symbol) {
140         return symbol;
141     }
142     // Function to access decimals of token .
143     function decimals() constant public returns (uint8 _decimals) {
144         return decimals;
145     }
146     // Function to access total supply of tokens .
147     function totalSupply() constant public returns (uint256 _totalSupply) {
148         return totalSupply;
149     }
150 
151     // Function that is called when a user or another contract wants to transfer funds .
152     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
153 
154         if (isContract(_to)) {
155             if (balanceOf(msg.sender) < _value) {
156                 revert();
157             }
158             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
159             balances[_to] = safeAdd(balanceOf(_to), _value);
160             ContractReceiver receiver = ContractReceiver(_to);
161             receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);
162             Transfer(msg.sender, _to, _value, _data);
163             return true;
164         } else {
165             return transferToAddress(_to, _value, _data);
166         }
167     }
168 
169     // Function that is called when a user or another contract wants to transfer funds .
170     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
171 
172         if (isContract(_to)) {
173             return transferToContract(_to, _value, _data);
174         } else {
175             return transferToAddress(_to, _value, _data);
176         }
177     }
178 
179     // Standard function transfer similar to ERC20 transfer with no _data .
180     // Added due to backwards compatibility reasons .
181     function transfer(address _to, uint _value) public returns (bool success) {
182         //standard function transfer similar to ERC20 transfer with no _data
183         //added due to backwards compatibility reasons
184         bytes memory empty;
185         if (isContract(_to)) {
186             return transferToContract(_to, _value, empty);
187         } else {
188             return transferToAddress(_to, _value, empty);
189         }
190     }
191 
192     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
193     function isContract(address _addr) private returns (bool is_contract) {
194         uint length;
195         assembly {
196             //retrieve the size of the code on target address, this needs assembly
197             length := extcodesize(_addr)
198         }
199         return (length > 0);
200     }
201 
202     // function that is called when transaction target is an address
203     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
204         if (balanceOf(msg.sender) < _value) {
205             revert();
206         }
207         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
208         balances[_to] = safeAdd(balanceOf(_to), _value);
209         Transfer(msg.sender, _to, _value);
210         return true;
211     }
212 
213     // function that is called when transaction target is a contract
214     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
215         if (balanceOf(msg.sender) < _value) {
216             revert();
217         }
218         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
219         balances[_to] = safeAdd(balanceOf(_to), _value);
220         ContractReceiver receiver = ContractReceiver(_to);
221         receiver.tokenFallback(msg.sender, _value, _data);
222         Transfer(msg.sender, _to, _value);
223         return true;
224     }
225 
226     // Get balance of the address provided
227     function balanceOf(address _owner) constant public returns (uint256 balance) {
228         return balances[_owner];
229     }
230 
231     // Allow transfers if the owner provided an allowance
232     // Prevent from any transfers if token is not yet unlocked
233     // Use SafeMath for the main logic
234     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
235         // Protect against wrapping uints.
236         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
237         uint256 allowance = allowed[_from][msg.sender];
238         require(balances[_from] >= _value && allowance >= _value);
239         balances[_to] = safeAdd(balanceOf(_to), _value);
240         balances[_from] = safeSub(balanceOf(_from), _value);
241         if (allowance < MAX_UINT256) {
242             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
243         }
244         Transfer(_from, _to, _value);
245         return true;
246     }
247 
248     function approve(address _spender, uint256 _value) public returns (bool success) {
249         allowed[msg.sender][_spender] = _value;
250         Approval(msg.sender, _spender, _value);
251         return true;
252     }
253 
254     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
255       return allowed[_owner][_spender];
256     }
257 }