1 pragma solidity ^0.4.24;
2 
3 contract J8TTokenInterface {
4   function balanceOf(address who) public constant returns (uint256);
5   function transferFrom(address from, address to, uint256 value) public returns (bool);
6   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
7   function approve(address spender, uint256 value) public returns (bool);
8 }
9 
10 contract FeeInterface {
11   function getFee(uint _base, uint _amount) external view returns (uint256 fee);
12 }
13 
14 
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22   address private _owner;
23   address private _admin;
24 
25   event OwnershipTransferred(
26     address indexed previousOwner,
27     address indexed newOwner
28   );
29 
30   event AdministrationTransferred(
31     address indexed previousAdmin,
32     address indexed newAdmin
33   );
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   constructor() public {
41     _owner = msg.sender;
42   }
43 
44   /**
45    * @return the address of the owner.
46    */
47   function owner() public view returns(address) {
48     return _owner;
49   }
50 
51   /**
52    * @return the address of the admin.
53    */
54   function admin() public view returns(address) {
55     return _admin;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(isOwner());
63     _;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyAdmin() {
70     require(isAdmin());
71     _;
72   }
73 
74   /**
75    * @return true if `msg.sender` is the owner of the contract.
76    */
77   function isOwner() public view returns(bool) {
78     return msg.sender == _owner;
79   }
80 
81   /**
82    * @return true if `msg.sender` is the admin of the contract.
83    */
84   function isAdmin() public view returns(bool) {
85     return msg.sender == _admin;
86   }
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address newOwner) public onlyOwner {
93     _transferOwnership(newOwner);
94   }
95 
96 
97   /**
98    * @dev Transfers control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function _transferOwnership(address newOwner) internal {
102     require(newOwner != address(0));
103     emit OwnershipTransferred(_owner, newOwner);
104     _owner = newOwner;
105   }
106 
107   /**
108    * @dev Allows the current owner to transfer admin control of the contract to a newAdmin.
109    * @param newAdmin The address to transfer admin powers to.
110    */
111   function transferAdministration(address newAdmin) public onlyOwner {
112     _transferAdministration(newAdmin);
113   }
114 
115   /**
116    * @dev Transfers admin control of the contract to a newAdmin.
117    * @param newAdmin The address to transfer admin power to.
118    */
119   function _transferAdministration(address newAdmin) internal {
120     require(newAdmin != address(0));
121     require(newAdmin != address(this));
122     emit AdministrationTransferred(_admin, newAdmin);
123     _admin = newAdmin;
124   }
125 
126 }
127 
128 /**
129  * @title Pausable
130  * @dev Base contract which allows children to implement an emergency stop mechanism.
131  */
132 
133 contract Pausable is Ownable {
134 
135   event Paused();
136   event Unpaused();
137 
138   bool private _paused = false;
139 
140   /**
141    * @return true if the contract is paused, false otherwise.
142    */
143   function paused() public view returns(bool) {
144     return _paused;
145   }
146 
147   /**
148    * @dev Modifier to make a function callable only when the contract is not paused.
149    */
150   modifier whenNotPaused() {
151     require(!_paused, "Contract is paused");
152     _;
153   }
154 
155   /**
156    * @dev Modifier to make a function callable only when the contract is paused.
157    */
158   modifier whenPaused() {
159     require(_paused, "Contract is not paused");
160     _;
161   }
162 
163   /**
164    * @dev called by the owner to pause, triggers stopped state
165    */
166   function pause() public onlyOwner whenNotPaused {
167     _paused = true;
168     emit Paused();
169   }
170 
171   /**
172    * @dev called by the owner to unpause, returns to normal state
173    */
174   function unpause() public onlyOwner whenPaused {
175     _paused = false;
176     emit Unpaused();
177   }
178 }
179 
180 
181 /**
182  * @title SafeMath
183  * @dev Math operations with safety checks that revert on error
184  */
185 library SafeMath {
186 
187   /**
188   * @dev Multiplies two numbers, reverts on overflow.
189   */
190   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192     // benefit is lost if 'b' is also tested.
193     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
194     if (a == 0) {
195       return 0;
196     }
197 
198     uint256 c = a * b;
199     require(c / a == b);
200 
201     return c;
202   }
203 
204   /**
205   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
206   */
207   function div(uint256 a, uint256 b) internal pure returns (uint256) {
208     require(b > 0); // Solidity only automatically asserts when dividing by 0
209     uint256 c = a / b;
210     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212     return c;
213   }
214 
215   /**
216   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
217   */
218   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219     require(b <= a);
220     uint256 c = a - b;
221 
222     return c;
223   }
224 
225   /**
226   * @dev Adds two numbers, reverts on overflow.
227   */
228   function add(uint256 a, uint256 b) internal pure returns (uint256) {
229     uint256 c = a + b;
230     require(c >= a);
231 
232     return c;
233   }
234 
235   /**
236   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
237   * reverts when dividing by zero.
238   */
239   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240     require(b != 0);
241     return a % b;
242   }
243 }
244 
245 contract WalletCoordinator is Pausable {
246 
247   using SafeMath for uint256;
248 
249   J8TTokenInterface public tokenContract;
250   FeeInterface public feeContract;
251   address public custodian;
252 
253   event TransferSuccess(
254     address indexed fromAddress,
255     address indexed toAddress,
256     uint amount,
257     uint networkFee
258   );
259 
260   event TokenAddressUpdated(
261     address indexed oldAddress,
262     address indexed newAddress
263   );
264 
265   event FeeContractAddressUpdated(
266     address indexed oldAddress,
267     address indexed newAddress
268   );
269 
270   event CustodianAddressUpdated(
271     address indexed oldAddress,
272     address indexed newAddress
273   );
274 
275   /**
276    * @dev Allows the current smart contract to transfer amount of tokens from fromAddress to toAddress
277    */
278   function transfer(address _fromAddress, address _toAddress, uint _amount, uint _baseFee) public onlyAdmin whenNotPaused {
279     require(_amount > 0, "Amount must be greater than zero");
280     require(_fromAddress != _toAddress,  "Addresses _fromAddress and _toAddress are equal");
281     require(_fromAddress != address(0), "Address _fromAddress is 0x0");
282     require(_fromAddress != address(this), "Address _fromAddress is smart contract address");
283     require(_toAddress != address(0), "Address _toAddress is 0x0");
284     require(_toAddress != address(this), "Address _toAddress is smart contract address");
285 
286     uint networkFee = feeContract.getFee(_baseFee, _amount);
287     uint fromBalance = tokenContract.balanceOf(_fromAddress);
288 
289     require(_amount <= fromBalance, "Insufficient account balance");
290 
291     require(tokenContract.transferFrom(_fromAddress, _toAddress, _amount.sub(networkFee)), "transferFrom did not succeed");
292     require(tokenContract.transferFrom(_fromAddress, custodian, networkFee), "transferFrom fee did not succeed");
293 
294     emit TransferSuccess(_fromAddress, _toAddress, _amount, networkFee);
295   }
296 
297   function getFee(uint _base, uint _amount) public view returns (uint256) {
298     return feeContract.getFee(_base, _amount);
299   }
300 
301   function setTokenInterfaceAddress(address _newAddress) external onlyOwner whenPaused returns (bool) {
302     require(_newAddress != address(this), "The new token address is equal to the smart contract address");
303     require(_newAddress != address(0), "The new token address is equal to 0x0");
304     require(_newAddress != address(tokenContract), "The new token address is equal to the old token address");
305 
306     address _oldAddress = tokenContract;
307     tokenContract = J8TTokenInterface(_newAddress);
308 
309     emit TokenAddressUpdated(_oldAddress, _newAddress);
310 
311     return true;
312   }
313 
314   function setFeeContractAddress(address _newAddress) external onlyOwner whenPaused returns (bool) {
315     require(_newAddress != address(this), "The new fee contract address is equal to the smart contract address");
316     require(_newAddress != address(0), "The new fee contract address is equal to 0x0");
317 
318     address _oldAddress = feeContract;
319     feeContract = FeeInterface(_newAddress);
320 
321     emit FeeContractAddressUpdated(_oldAddress, _newAddress);
322 
323     return true;
324   }
325 
326   function setCustodianAddress(address _newAddress) external onlyOwner returns (bool) {
327     require(_newAddress != address(this), "The new custodian address is equal to the smart contract address");
328     require(_newAddress != address(0), "The new custodian address is equal to 0x0");
329 
330     address _oldAddress = custodian;
331     custodian = _newAddress;
332 
333     emit CustodianAddressUpdated(_oldAddress, _newAddress);
334 
335     return true;
336   }
337 }