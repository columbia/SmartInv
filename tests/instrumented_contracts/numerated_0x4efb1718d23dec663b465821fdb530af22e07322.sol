1 pragma solidity ^0.4.24;
2 /**
3 * @notice Block Coin Bit Token Contract
4 * @dev ERC-223 Token Standar Compliant
5 * Contact: aaronwalterfraser@gmail.com
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15       uint256 c = a * b;
16       assert(a == 0 || c / a == b);
17       return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21       uint256 c = a / b;
22       return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26       assert(b <= a);
27       return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31       uint256 c = a + b;
32       assert(c >= a);
33       return c;
34     }
35 }
36 
37 /**
38  * @title ERC223 Token interface
39  * @dev Code based on Dexaran's one on github as recommended on ERC223 discussion
40  */
41 
42 contract ERC223Interface {
43 
44   function balanceOf(address who) constant public returns (uint256);
45 
46   function name() constant public returns (string _name);
47   function symbol() constant public returns (string _symbol);
48   function decimals() constant public returns (uint8 _decimals);
49   function totalSupply() constant public returns (uint256 _supply);
50 
51   function mintToken(address _target, uint256 _mintedAmount) public returns (bool success);
52   function burnToken(uint256 _burnedAmount) public returns (bool success);
53 
54   function transfer(address to, uint256 value) public returns (bool ok);
55   function transfer(address to, uint256 value, bytes data) public returns (bool ok);
56   function transfer(address to, uint256 value, bytes data, bytes custom_fallback) public returns (bool ok);
57 
58   event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
59   event Burned(address indexed _target, uint256 _value);
60 }
61 
62  contract ContractReceiver {
63     function tokenFallback(address _from, uint256 _value, bytes _data) public;
64 }
65 
66 /**
67 * @title Admin parameters
68 * @dev Define administration parameters for this contract
69 */
70 contract admined { //This token contract is administered
71     address public admin; //Admin address is public
72     bool public lockSupply; //Mint and Burn Lock flag
73 
74     /**
75     * @dev Contract constructor
76     * define initial administrator
77     */
78     constructor() internal {
79         admin = msg.sender; //Set initial admin to contract creator
80         emit Admined(admin);
81     }
82 
83     modifier onlyAdmin() { //A modifier to define admin-only functions
84         require(msg.sender == admin);
85         _;
86     }
87 
88     modifier supplyLock() { //A modifier to lock mint and burn transactions
89         require(lockSupply == false);
90         _;
91     }
92 
93    /**
94     * @dev Function to set new admin address
95     * @param _newAdmin The address to transfer administration to
96     */
97     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
98         require(_newAdmin != 0);
99         admin = _newAdmin;
100         emit TransferAdminship(admin);
101     }
102 
103    /**
104     * @dev Function to set mint and burn locks
105     * @param _set boolean flag (true | false)
106     */
107     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
108         lockSupply = _set;
109         emit SetSupplyLock(_set);
110     }
111 
112     //All admin actions have a log for public review
113     event SetSupplyLock(bool _set);
114     event TransferAdminship(address newAdminister);
115     event Admined(address administer);
116 
117 }
118 
119 /**
120  * @title ERC223 Token definition
121  * @dev Code based on Dexaran's one on github as recommended on ERC223 discussion
122  */
123 
124 contract ERC223Token is admined,ERC223Interface {
125 
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   string public name    = "Block Coin Bit";
131   string public symbol  = "BLCB";
132   uint8 public decimals = 8;
133   uint256 public totalSupply;
134   address initialOwner = 0x0D77002Affd96A22635bB46EC98F23EB99e12253;
135 
136   constructor() public
137   {
138     bytes memory empty;
139     totalSupply = 12000000000 * (10 ** uint256(decimals));
140     balances[initialOwner] = totalSupply;
141     emit Transfer(0, this, totalSupply, empty);
142     emit Transfer(this, initialOwner, balances[initialOwner], empty);
143   }
144 
145 
146   // Function to access name of token .
147   function name() constant public returns (string _name) {
148       return name;
149   }
150   // Function to access symbol of token .
151   function symbol() constant public returns (string _symbol) {
152       return symbol;
153   }
154   // Function to access decimals of token .
155   function decimals() constant public returns (uint8 _decimals) {
156       return decimals;
157   }
158   // Function to access total supply of tokens .
159   function totalSupply() constant public returns (uint256 _totalSupply) {
160       return totalSupply;
161   }
162 
163   function balanceOf(address _owner) constant public returns (uint256 balance) {
164     return balances[_owner];
165   }
166 
167   // Standard function transfer similar to ERC20 transfer with no _data .
168   // Added due to backwards compatibility reasons .
169   function transfer(address _to, uint256 _value) public returns (bool success) {
170 
171     //standard function transfer similar to ERC20 transfer with no _data
172     //added due to backwards compatibility reasons
173     bytes memory empty;
174     if(isContract(_to)) {
175         return transferToContract(_to, _value, empty);
176     }
177     else {
178         return transferToAddress(_to, _value, empty);
179     }
180   }
181 
182   // Function that is called when a user or another contract wants to transfer funds .
183   function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
184 
185     if(isContract(_to)) {
186         return transferToContract(_to, _value, _data);
187     }
188     else {
189         return transferToAddress(_to, _value, _data);
190     }
191   }
192 
193   // Function that is called when a user or another contract wants to transfer funds .
194   function transfer(address _to, uint256 _value, bytes _data, bytes _custom_fallback) public returns (bool success) {
195 
196     if(isContract(_to)) {
197         require(balanceOf(msg.sender) >= _value);
198         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
199         balances[_to] = balanceOf(_to).add(_value);
200         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
201         emit Transfer(msg.sender, _to, _value, _data);
202         return true;
203     }
204     else {
205         return transferToAddress(_to, _value, _data);
206     }
207   }
208 
209   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
210   function isContract(address _addr) private view returns (bool is_contract) {
211       uint256 length;
212       assembly {
213             //retrieve the size of the code on target address, this needs assembly
214             length := extcodesize(_addr)
215       }
216       return (length>0);
217     }
218 
219   //function that is called when transaction target is an address
220   function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
221     require(balanceOf(msg.sender) >= _value);
222     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
223     balances[_to] = balanceOf(_to).add(_value);
224     emit Transfer(msg.sender, _to, _value, _data);
225     return true;
226   }
227 
228   //function that is called when transaction target is a contract
229   function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
230     require(balanceOf(msg.sender) >= _value);
231     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
232     balances[_to] = balanceOf(_to).add(_value);
233     ContractReceiver receiver = ContractReceiver(_to);
234     receiver.tokenFallback(msg.sender, _value, _data);
235     emit Transfer(msg.sender, _to, _value, _data);
236     return true;
237   }
238 
239   function mintToken(address _target, uint256 _mintedAmount) onlyAdmin supplyLock public returns (bool success) {
240     bytes memory empty;
241     balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
242     totalSupply = SafeMath.add(totalSupply, _mintedAmount);
243     emit Transfer(0, this, _mintedAmount,empty);
244     emit Transfer(this, _target, _mintedAmount,empty);
245     return true;
246   }
247 
248   function burnToken(uint256 _burnedAmount) onlyAdmin supplyLock public returns (bool success) {
249     balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
250     totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
251     emit Burned(msg.sender, _burnedAmount);
252     return true;
253   }
254 
255 }