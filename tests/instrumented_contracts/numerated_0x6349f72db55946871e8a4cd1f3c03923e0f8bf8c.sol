1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 
69 
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, throws on overflow.
78   */
79   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
80     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
81     // benefit is lost if 'b' is also tested.
82     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
83     if (_a == 0) {
84       return 0;
85     }
86 
87     c = _a * _b;
88     assert(c / _a == _b);
89     return c;
90   }
91 
92   /**
93   * @dev Integer division of two numbers, truncating the quotient.
94   */
95   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     // assert(_b > 0); // Solidity automatically throws when dividing by 0
97     // uint256 c = _a / _b;
98     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
99     return _a / _b;
100   }
101 
102   /**
103   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
104   */
105   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
106     assert(_b <= _a);
107     return _a - _b;
108   }
109 
110   /**
111   * @dev Adds two numbers, throws on overflow.
112   */
113   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
114     c = _a + _b;
115     assert(c >= _a);
116     return c;
117   }
118 }
119 
120 
121 
122 
123 
124 
125 
126 
127 
128 
129 /**
130  * @title Claimable
131  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
132  * This allows the new owner to accept the transfer.
133  */
134 contract Claimable is Ownable {
135   address public pendingOwner;
136 
137   /**
138    * @dev Modifier throws if called by any account other than the pendingOwner.
139    */
140   modifier onlyPendingOwner() {
141     require(msg.sender == pendingOwner);
142     _;
143   }
144 
145   /**
146    * @dev Allows the current owner to set the pendingOwner address.
147    * @param newOwner The address to transfer ownership to.
148    */
149   function transferOwnership(address newOwner) public onlyOwner {
150     pendingOwner = newOwner;
151   }
152 
153   /**
154    * @dev Allows the pendingOwner address to finalize the transfer.
155    */
156   function claimOwnership() public onlyPendingOwner {
157     emit OwnershipTransferred(owner, pendingOwner);
158     owner = pendingOwner;
159     pendingOwner = address(0);
160   }
161 }
162 
163 
164 
165 /**
166  * @title Claimable Ex
167  * @dev Extension for the Claimable contract, where the ownership transfer can be canceled.
168  */
169 contract ClaimableEx is Claimable {
170   /*
171    * @dev Cancels the ownership transfer.
172    */
173   function cancelOwnershipTransfer() onlyOwner public {
174     pendingOwner = owner;
175   }
176 }
177 
178 
179 
180 
181 
182 
183 /**
184  * @title Address Set.
185  * @dev This contract allows to store addresses in a set and
186  * owner can run a loop through all elements.
187  **/
188 contract AddressSet is Ownable {
189   mapping(address => bool) exist;
190   address[] elements;
191 
192   /**
193    * @dev Adds a new address to the set.
194    * @param _addr Address to add.
195    * @return True if succeed, otherwise false.
196    */
197   function add(address _addr) onlyOwner public returns (bool) {
198     if (contains(_addr)) {
199       return false;
200     }
201 
202     exist[_addr] = true;
203     elements.push(_addr);
204     return true;
205   }
206 
207   /**
208    * @dev Checks whether the set contains a specified address or not.
209    * @param _addr Address to check.
210    * @return True if the address exists in the set, otherwise false.
211    */
212   function contains(address _addr) public view returns (bool) {
213     return exist[_addr];
214   }
215 
216   /**
217    * @dev Gets an element at a specified index in the set.
218    * @param _index Index.
219    * @return A relevant address.
220    */
221   function elementAt(uint256 _index) onlyOwner public view returns (address) {
222     require(_index < elements.length);
223 
224     return elements[_index];
225   }
226 
227   /**
228    * @dev Gets the number of elements in the set.
229    * @return The number of elements.
230    */
231   function getTheNumberOfElements() onlyOwner public view returns (uint256) {
232     return elements.length;
233   }
234 }
235 
236 
237 
238 // A wrapper around the balances mapping.
239 contract BalanceSheet is ClaimableEx {
240   using SafeMath for uint256;
241 
242   mapping (address => uint256) private balances;
243 
244   AddressSet private holderSet;
245 
246   constructor() public {
247     holderSet = new AddressSet();
248   }
249 
250   /**
251   * @dev Gets the balance of the specified address.
252   * @param _owner The address to query the the balance of.
253   * @return An uint256 representing the amount owned by the passed address.
254   */
255   function balanceOf(address _owner) public view returns (uint256) {
256     return balances[_owner];
257   }
258 
259   function addBalance(address _addr, uint256 _value) public onlyOwner {
260     balances[_addr] = balances[_addr].add(_value);
261 
262     _checkHolderSet(_addr);
263   }
264 
265   function subBalance(address _addr, uint256 _value) public onlyOwner {
266     balances[_addr] = balances[_addr].sub(_value);
267   }
268 
269   function setBalance(address _addr, uint256 _value) public onlyOwner {
270     balances[_addr] = _value;
271 
272     _checkHolderSet(_addr);
273   }
274 
275   function setBalanceBatch(
276     address[] _addrs,
277     uint256[] _values
278   )
279     public
280     onlyOwner
281   {
282     uint256 _count = _addrs.length;
283     require(_count == _values.length);
284 
285     for(uint256 _i = 0; _i < _count; _i++) {
286       setBalance(_addrs[_i], _values[_i]);
287     }
288   }
289 
290   function getTheNumberOfHolders() public view returns (uint256) {
291     return holderSet.getTheNumberOfElements();
292   }
293 
294   function getHolder(uint256 _index) public view returns (address) {
295     return holderSet.elementAt(_index);
296   }
297 
298   function _checkHolderSet(address _addr) internal {
299     if (!holderSet.contains(_addr)) {
300       holderSet.add(_addr);
301     }
302   }
303 }