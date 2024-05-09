1 pragma solidity ^0.4.18;
2 
3 // File: contracts/EtherDeltaI.sol
4 
5 contract EtherDeltaI {
6 
7   uint public feeMake; //percentage times (1 ether)
8   uint public feeTake; //percentage times (1 ether)
9 
10   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
11   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
12   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
13 
14   function deposit() payable;
15 
16   function withdraw(uint amount);
17 
18   function depositToken(address token, uint amount);
19 
20   function withdrawToken(address token, uint amount);
21 
22   function balanceOf(address token, address user) constant returns (uint);
23 
24   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce);
25 
26   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount);
27 
28   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool);
29 
30   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint);
31 
32   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint);
33 
34   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s);
35 
36 }
37 
38 // File: contracts/KindMath.sol
39 
40 /**
41  * @title KindMath
42  * @dev Math operations with safety checks that fail
43  */
44 library KindMath {
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a * b;
47     require(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     require(c >= a);
66     return c;
67   }
68 }
69 
70 // File: contracts/KeyValueStorage.sol
71 
72 contract KeyValueStorage {
73 
74   mapping(address => mapping(bytes32 => uint256)) _uintStorage;
75   mapping(address => mapping(bytes32 => address)) _addressStorage;
76   mapping(address => mapping(bytes32 => bool)) _boolStorage;
77   mapping(address => mapping(bytes32 => bytes32)) _bytes32Storage;
78 
79   /**** Get Methods ***********/
80 
81   function getAddress(bytes32 key) public view returns (address) {
82       return _addressStorage[msg.sender][key];
83   }
84 
85   function getUint(bytes32 key) public view returns (uint) {
86       return _uintStorage[msg.sender][key];
87   }
88 
89   function getBool(bytes32 key) public view returns (bool) {
90       return _boolStorage[msg.sender][key];
91   }
92 
93   function getBytes32(bytes32 key) public view returns (bytes32) {
94       return _bytes32Storage[msg.sender][key];
95   }
96 
97   /**** Set Methods ***********/
98 
99   function setAddress(bytes32 key, address value) public {
100       _addressStorage[msg.sender][key] = value;
101   }
102 
103   function setUint(bytes32 key, uint value) public {
104       _uintStorage[msg.sender][key] = value;
105   }
106 
107   function setBool(bytes32 key, bool value) public {
108       _boolStorage[msg.sender][key] = value;
109   }
110 
111   function setBytes32(bytes32 key, bytes32 value) public {
112       _bytes32Storage[msg.sender][key] = value;
113   }
114 
115   /**** Delete Methods ***********/
116 
117   function deleteAddress(bytes32 key) public {
118       delete _addressStorage[msg.sender][key];
119   }
120 
121   function deleteUint(bytes32 key) public {
122       delete _uintStorage[msg.sender][key];
123   }
124 
125   function deleteBool(bytes32 key) public {
126       delete _boolStorage[msg.sender][key];
127   }
128 
129   function deleteBytes32(bytes32 key) public {
130       delete _bytes32Storage[msg.sender][key];
131   }
132 
133 }
134 
135 // File: contracts/StorageStateful.sol
136 
137 contract StorageStateful {
138   KeyValueStorage public keyValueStorage;
139 }
140 
141 // File: contracts/StorageConsumer.sol
142 
143 contract StorageConsumer is StorageStateful {
144   function StorageConsumer(address _storageAddress) public {
145     require(_storageAddress != address(0));
146     keyValueStorage = KeyValueStorage(_storageAddress);
147   }
148 }
149 
150 // File: contracts/TokenI.sol
151 
152 contract Token {
153   /// @return total amount of tokens
154   function totalSupply() public returns (uint256);
155 
156   /// @param _owner The address from which the balance will be retrieved
157   /// @return The balance
158   function balanceOf(address _owner) public returns (uint256);
159 
160   /// @notice send `_value` token to `_to` from `msg.sender`
161   /// @param _to The address of the recipient
162   /// @param _value The amount of token to be transferred
163   /// @return Whether the transfer was successful or not
164   function transfer(address _to, uint256 _value) public returns (bool);
165 
166   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
167   /// @param _from The address of the sender
168   /// @param _to The address of the recipient
169   /// @param _value The amount of token to be transferred
170   /// @return Whether the transfer was successful or not
171   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
172 
173   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
174   /// @param _spender The address of the account able to transfer the tokens
175   /// @param _value The amount of wei to be approved for transfer
176   /// @return Whether the approval was successful or not
177   function approve(address _spender, uint256 _value) public returns (bool);
178 
179   /// @param _owner The address of the account owning tokens
180   /// @param _spender The address of the account able to transfer the tokens
181   /// @return Amount of remaining tokens allowed to spent
182   function allowance(address _owner, address _spender) public returns (uint256);
183 
184   event Transfer(address indexed _from, address indexed _to, uint256 _value);
185   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
186 
187   uint256 public decimals;
188   string public name;
189 }
190 
191 // File: contracts/EnclavesDEXProxy.sol
192 
193 contract EnclavesDEXProxy is StorageConsumer {
194   using KindMath for uint256;
195 
196   address public admin; //the admin address
197   address public feeAccount; //the account that will receive fees
198 
199   struct EtherDeltaInfo {
200     uint256 feeMake;
201     uint256 feeTake;
202   }
203 
204   EtherDeltaInfo public etherDeltaInfo;
205 
206   uint256 public feeTake; //percentage times 1 ether
207   uint256 public feeAmountThreshold; //gasPrice amount under which no fees are charged
208 
209   address public etherDelta;
210 
211   bool public useEIP712 = true;
212   bytes32 public tradeABIHash;
213   bytes32 public withdrawABIHash;
214 
215   bool freezeTrading;
216   bool depositTokenLock;
217 
218   mapping (address => mapping (uint256 => bool)) nonceCheck;
219 
220   mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
221   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
222   mapping (address => mapping (bytes32 => uint256)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
223 
224   address internal implementation;
225   address public proposedImplementation;
226   uint256 public proposedTimestamp;
227 
228   event Upgraded(address _implementation);
229   event UpgradedProposed(address _proposedImplementation, uint256 _proposedTimestamp);
230 
231   modifier onlyAdmin {
232     require(msg.sender == admin);
233     _;
234   }
235 
236   function EnclavesDEXProxy(address _storageAddress, address _implementation, address _admin, address _feeAccount, uint256 _feeTake, uint256 _feeAmountThreshold, address _etherDelta, bytes32 _tradeABIHash, bytes32 _withdrawABIHash) public
237     StorageConsumer(_storageAddress)
238   {
239     require(_implementation != address(0));
240     implementation = _implementation;
241     admin = _admin;
242     feeAccount = _feeAccount;
243     feeTake = _feeTake;
244     feeAmountThreshold = _feeAmountThreshold;
245     etherDelta = _etherDelta;
246     tradeABIHash = _tradeABIHash;
247     withdrawABIHash = _withdrawABIHash;
248     etherDeltaInfo.feeMake = EtherDeltaI(etherDelta).feeMake();
249     etherDeltaInfo.feeTake = EtherDeltaI(etherDelta).feeTake();
250   }
251 
252   function getImplementation() public view returns(address) {
253     return implementation;
254   }
255 
256   function proposeUpgrade(address _proposedImplementation) public onlyAdmin {
257     require(implementation != _proposedImplementation);
258     require(_proposedImplementation != address(0));
259     proposedImplementation = _proposedImplementation;
260     proposedTimestamp = now + 2 weeks;
261     UpgradedProposed(proposedImplementation, now);
262   }
263 
264   function upgrade() public onlyAdmin {
265     require(proposedImplementation != address(0));
266     require(proposedTimestamp < now);
267     implementation = proposedImplementation;
268     Upgraded(implementation);
269   }
270 
271   function () payable public {
272     bytes memory data = msg.data;
273     address impl = getImplementation();
274 
275     assembly {
276       let result := delegatecall(gas, impl, add(data, 0x20), mload(data), 0, 0)
277       let size := returndatasize
278       let ptr := mload(0x40)
279       returndatacopy(ptr, 0, size)
280       switch result
281       case 0 { revert(ptr, size) }
282       default { return(ptr, size) }
283     }
284   }
285 
286 }