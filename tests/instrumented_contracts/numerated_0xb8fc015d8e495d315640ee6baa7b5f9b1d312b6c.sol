1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address _who) public view returns (uint256);
52   function transfer(address _to, uint256 _value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address _owner, address _spender)
62     public view returns (uint256);
63 
64   function transferFrom(address _from, address _to, uint256 _value)
65     public returns (bool);
66 
67   function approve(address _spender, uint256 _value) public returns (bool);
68   event Approval(
69     address indexed owner,
70     address indexed spender,
71     uint256 value
72   );
73 }
74 
75 library SafeERC20 {
76   function safeTransfer(
77     ERC20Basic _token,
78     address _to,
79     uint256 _value
80   )
81     internal
82   {
83     require(_token.transfer(_to, _value));
84   }
85 
86   function safeTransferFrom(
87     ERC20 _token,
88     address _from,
89     address _to,
90     uint256 _value
91   )
92     internal
93   {
94     require(_token.transferFrom(_from, _to, _value));
95   }
96 
97   function safeApprove(
98     ERC20 _token,
99     address _spender,
100     uint256 _value
101   )
102     internal
103   {
104     require(_token.approve(_spender, _value));
105   }
106 }
107 
108 contract Ownable {
109   address public owner;
110 
111 
112   event OwnershipRenounced(address indexed previousOwner);
113   event OwnershipTransferred(
114     address indexed previousOwner,
115     address indexed newOwner
116   );
117 
118 
119   /**
120    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
121    * account.
122    */
123   constructor() public {
124     owner = msg.sender;
125   }
126 
127   /**
128    * @dev Throws if called by any account other than the owner.
129    */
130   modifier onlyOwner() {
131     require(msg.sender == owner);
132     _;
133   }
134 
135   /**
136    * @dev Allows the current owner to relinquish control of the contract.
137    * @notice Renouncing to ownership will leave the contract without an owner.
138    * It will not be possible to call the functions with the `onlyOwner`
139    * modifier anymore.
140    */
141   function renounceOwnership() public onlyOwner {
142     emit OwnershipRenounced(owner);
143     owner = address(0);
144   }
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param _newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address _newOwner) public onlyOwner {
151     _transferOwnership(_newOwner);
152   }
153 
154   /**
155    * @dev Transfers control of the contract to a newOwner.
156    * @param _newOwner The address to transfer ownership to.
157    */
158   function _transferOwnership(address _newOwner) internal {
159     require(_newOwner != address(0));
160     emit OwnershipTransferred(owner, _newOwner);
161     owner = _newOwner;
162   }
163 }
164 
165 /**
166  * @title Claimable
167  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
168  * This allows the new owner to accept the transfer.
169  */
170 contract Claimable is Ownable {
171   address public pendingOwner;
172 
173   /**
174    * @dev Modifier throws if called by any account other than the pendingOwner.
175    */
176   modifier onlyPendingOwner() {
177     require(msg.sender == pendingOwner);
178     _;
179   }
180 
181   /**
182    * @dev Allows the current owner to set the pendingOwner address.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) public onlyOwner {
186     pendingOwner = newOwner;
187   }
188 
189   /**
190    * @dev Allows the pendingOwner address to finalize the transfer.
191    */
192   function claimOwnership() public onlyPendingOwner {
193     emit OwnershipTransferred(owner, pendingOwner);
194     owner = pendingOwner;
195     pendingOwner = address(0);
196   }
197 }
198 
199 contract TokenTimelock {
200   using SafeERC20 for ERC20Basic;
201 
202   // ERC20 basic token contract being held
203   ERC20Basic public token;
204 
205   // beneficiary of tokens after they are released
206   address public beneficiary;
207 
208   // timestamp when token release is enabled
209   uint256 public releaseTime;
210 
211   constructor(
212     ERC20Basic _token,
213     address _beneficiary,
214     uint256 _releaseTime
215   )
216     public
217   {
218     // solium-disable-next-line security/no-block-members
219     require(_releaseTime > block.timestamp);
220     token = _token;
221     beneficiary = _beneficiary;
222     releaseTime = _releaseTime;
223   }
224 
225   /**
226    * @notice Transfers tokens held by timelock to beneficiary.
227    */
228   function release() public {
229     // solium-disable-next-line security/no-block-members
230     require(block.timestamp >= releaseTime);
231 
232     uint256 amount = token.balanceOf(address(this));
233     require(amount > 0);
234 
235     token.safeTransfer(beneficiary, amount);
236   }
237 }
238 
239 contract TokenTimelockPool is Claimable {
240   using SafeERC20 for ERC20Basic;
241   using SafeMath for uint256;
242 
243   // ERC20 token being held
244   ERC20Basic public token;
245 
246   // Timestamp (in seconds) when tokens can be released
247   uint256 public releaseDate;
248 
249   // Maximum amount of tokens to be distributed
250   uint256 public totalFunds;
251 
252   // Tokens already distributed
253   uint256 public distributedTokens;
254 
255   // List of beneficiaries added to the pool
256   address[] public beneficiaries;
257 
258   // Mapping of beneficiary to TokenTimelock contracts addresses
259   mapping(address => address[]) public beneficiaryDistributionContracts;
260 
261   event BeneficiaryAdded(
262     address indexed beneficiary,
263     address timelock,
264     uint256 amount
265   );
266   event Reclaim(uint256 amount);
267 
268   modifier validAddress(address _addr) {
269     require(_addr != address(0));
270     require(_addr != address(this));
271     _;
272   }
273 
274   /**
275    * @notice Contract constructor.
276    * @param _token instance of an ERC20 token.
277    * @param _totalFunds Maximum amount of tokens to be distributed among
278    *        beneficiaries.
279    * @param _releaseDate Timestamp (in seconds) when tokens can be released.
280    */
281   constructor(
282     ERC20Basic _token,
283     uint256 _totalFunds,
284     uint256 _releaseDate
285   ) public validAddress(_token) {
286     require(_totalFunds > 0);
287     // solium-disable-next-line security/no-block-members
288     require(_releaseDate > block.timestamp);
289 
290     token = _token;
291     totalFunds = _totalFunds;
292     distributedTokens = 0;
293     releaseDate = _releaseDate;
294   }
295 
296   /**
297    * @notice Adds a beneficiary that will be allowed to extract the tokens after
298    *         the release date.
299    * @notice Example:
300              addBeneficiary(`0x123..`, 100)
301              Will create a TokenTimelock instance on which if the `release()` method
302              is called after the release date (specified in this contract constructor),
303              the amount of tokens (100) will be transferred to the
304              beneficiary (`0x123..`).
305    * @dev The `msg.sender` must be the owner of the contract.
306    * @param _beneficiary Beneficiary that will receive the tokens after the
307    * release date.
308    * @param _amount of tokens to be released.
309    * @return address for the new TokenTimelock contract instance.
310    */
311   function addBeneficiary(
312     address _beneficiary,
313     uint256 _amount
314   ) public onlyOwner validAddress(_beneficiary) returns (address) {
315     require(_beneficiary != owner);
316     require(_amount > 0);
317     // solium-disable-next-line security/no-block-members
318     require(block.timestamp < releaseDate);
319 
320     // Check there are sufficient funds and actual token balance.
321     require(SafeMath.sub(totalFunds, distributedTokens) >= _amount);
322     require(token.balanceOf(address(this)) >= _amount);
323 
324     if (!beneficiaryExists(_beneficiary)) {
325       beneficiaries.push(_beneficiary);
326     }
327 
328     // Bookkepping of distributed tokens
329     distributedTokens = distributedTokens.add(_amount);
330 
331     address tokenTimelock = new TokenTimelock(
332       token,
333       _beneficiary,
334       releaseDate
335     );
336 
337     // Bookkeeping of distributions contracts per beneficiary
338     beneficiaryDistributionContracts[_beneficiary].push(tokenTimelock);
339 
340     // Assign the tokens to the beneficiary
341     token.safeTransfer(tokenTimelock, _amount);
342 
343     emit BeneficiaryAdded(_beneficiary, tokenTimelock, _amount);
344     return tokenTimelock;
345   }
346 
347   /**
348    * @notice Transfers the remaining tokens that were not locked for any
349    *         beneficiary to the owner of this contract.
350    * @dev The `msg.sender` must be the owner of the contract.
351    * @return true if tokens were reclaimed successfully, reverts otherwise.
352    */
353   function reclaim() public onlyOwner returns (bool) {
354     // solium-disable-next-line security/no-block-members
355     require(block.timestamp > releaseDate);
356     uint256 reclaimableAmount = token.balanceOf(address(this));
357 
358     token.safeTransfer(owner, reclaimableAmount);
359     emit Reclaim(reclaimableAmount);
360     return true;
361   }
362 
363   /**
364    * @notice Gets an array of all the distribution contracts for a given beneficiary.
365    * @param _beneficiary address of the beneficiary to whom tokens will be transferred.
366    * @return List of TokenTimelock addresses.
367    */
368   function getDistributionContracts(
369     address _beneficiary
370   ) public view validAddress(_beneficiary) returns (address[]) {
371     return beneficiaryDistributionContracts[_beneficiary];
372   }
373 
374   /**
375    * @notice Checks if a beneficiary was added to the pool at least once.
376    * @param _beneficiary address of the beneficiary to whom tokens will be transferred.
377    * @return true if beneficiary exists, false otherwise.
378    */
379   function beneficiaryExists(
380     address _beneficiary
381   ) internal view returns (bool) {
382     return beneficiaryDistributionContracts[_beneficiary].length > 0;
383   }
384 }