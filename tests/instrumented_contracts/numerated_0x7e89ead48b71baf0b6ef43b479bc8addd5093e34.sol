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
199 contract TokenVesting is Ownable {
200   using SafeMath for uint256;
201   using SafeERC20 for ERC20Basic;
202 
203   event Released(uint256 amount);
204   event Revoked();
205 
206   // beneficiary of tokens after they are released
207   address public beneficiary;
208 
209   uint256 public cliff;
210   uint256 public start;
211   uint256 public duration;
212 
213   bool public revocable;
214 
215   mapping (address => uint256) public released;
216   mapping (address => bool) public revoked;
217 
218   /**
219    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
220    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
221    * of the balance will have vested.
222    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
223    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
224    * @param _start the time (as Unix time) at which point vesting starts
225    * @param _duration duration in seconds of the period in which the tokens will vest
226    * @param _revocable whether the vesting is revocable or not
227    */
228   constructor(
229     address _beneficiary,
230     uint256 _start,
231     uint256 _cliff,
232     uint256 _duration,
233     bool _revocable
234   )
235     public
236   {
237     require(_beneficiary != address(0));
238     require(_cliff <= _duration);
239 
240     beneficiary = _beneficiary;
241     revocable = _revocable;
242     duration = _duration;
243     cliff = _start.add(_cliff);
244     start = _start;
245   }
246 
247   /**
248    * @notice Transfers vested tokens to beneficiary.
249    * @param _token ERC20 token which is being vested
250    */
251   function release(ERC20Basic _token) public {
252     uint256 unreleased = releasableAmount(_token);
253 
254     require(unreleased > 0);
255 
256     released[_token] = released[_token].add(unreleased);
257 
258     _token.safeTransfer(beneficiary, unreleased);
259 
260     emit Released(unreleased);
261   }
262 
263   /**
264    * @notice Allows the owner to revoke the vesting. Tokens already vested
265    * remain in the contract, the rest are returned to the owner.
266    * @param _token ERC20 token which is being vested
267    */
268   function revoke(ERC20Basic _token) public onlyOwner {
269     require(revocable);
270     require(!revoked[_token]);
271 
272     uint256 balance = _token.balanceOf(address(this));
273 
274     uint256 unreleased = releasableAmount(_token);
275     uint256 refund = balance.sub(unreleased);
276 
277     revoked[_token] = true;
278 
279     _token.safeTransfer(owner, refund);
280 
281     emit Revoked();
282   }
283 
284   /**
285    * @dev Calculates the amount that has already vested but hasn't been released yet.
286    * @param _token ERC20 token which is being vested
287    */
288   function releasableAmount(ERC20Basic _token) public view returns (uint256) {
289     return vestedAmount(_token).sub(released[_token]);
290   }
291 
292   /**
293    * @dev Calculates the amount that has already vested.
294    * @param _token ERC20 token which is being vested
295    */
296   function vestedAmount(ERC20Basic _token) public view returns (uint256) {
297     uint256 currentBalance = _token.balanceOf(address(this));
298     uint256 totalBalance = currentBalance.add(released[_token]);
299 
300     if (block.timestamp < cliff) {
301       return 0;
302     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
303       return totalBalance;
304     } else {
305       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
306     }
307   }
308 }
309 
310 contract TokenVestingPool is Claimable {
311   using SafeERC20 for ERC20Basic;
312   using SafeMath for uint256;
313 
314   // ERC20 token being held
315   ERC20Basic public token;
316 
317   // Maximum amount of tokens to be distributed
318   uint256 public totalFunds;
319 
320   // Tokens already distributed
321   uint256 public distributedTokens;
322 
323   // List of beneficiaries added to the pool
324   address[] public beneficiaries;
325 
326   // Mapping of beneficiary to TokenVesting contracts addresses
327   mapping(address => address[]) public beneficiaryDistributionContracts;
328 
329   // Tracks the distribution contracts created by this contract.
330   mapping(address => bool) private distributionContracts;
331 
332   event BeneficiaryAdded(
333     address indexed beneficiary,
334     address vesting,
335     uint256 amount
336   );
337 
338   modifier validAddress(address _addr) {
339     require(_addr != address(0));
340     require(_addr != address(this));
341     _;
342   }
343 
344   /**
345    * @notice Contract constructor.
346    * @param _token instance of an ERC20 token.
347    * @param _totalFunds Maximum amount of tokens to be distributed among
348    *        beneficiaries.
349    */
350   constructor(
351     ERC20Basic _token,
352     uint256 _totalFunds
353   ) public validAddress(_token) {
354     require(_totalFunds > 0);
355 
356     token = _token;
357     totalFunds = _totalFunds;
358     distributedTokens = 0;
359   }
360 
361   /**
362    * @notice Assigns a token release point to a beneficiary. A beneficiary can have
363    *         many token release points.
364    *         Example 1 - Lock-up mode:
365    *           contract.addBeneficiary(
366    *             `0x123..`,  // Beneficiary
367    *             1533847025, // The vesting period starts this day
368    *             604800,     // Tokens are released after one week
369    *             604800,     // Duration of the release period. In this case, once the cliff
370    *                         // period is finished, the beneficiary will receive the tokens.
371    *             100         // Amount of tokens to be released
372    *           )
373    *         Example 2 - Vesting mode:
374    *           contract.addBeneficiary(
375    *             `0x123..`,  // Beneficiary
376    *             1533847025, // The vesting period starts this day
377    *             172800,     // Tokens are released after two weeks
378    *             345600,     // The release period will start after the cliff period and
379    *                         // it will last for two weeks. Tokens will be released uniformly
380    *                         // during this period.
381    *             100         // Amount of tokens to be released
382    *           )
383    *
384    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
385    * @param _start the time (as Unix time) at which point vesting starts
386    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
387    * @param _duration duration in seconds of the period in which the tokens will vest
388    * @param _amount amount of tokens to be released
389    * @return address for the new TokenVesting contract instance.
390    */
391   function addBeneficiary(
392     address _beneficiary,
393     uint256 _start,
394     uint256 _cliff,
395     uint256 _duration,
396     uint256 _amount
397   ) public onlyOwner validAddress(_beneficiary) returns (address) {
398     require(_beneficiary != owner);
399     require(_amount > 0);
400     require(_duration >= _cliff);
401 
402     // Check there are sufficient funds and actual token balance.
403     require(SafeMath.sub(totalFunds, distributedTokens) >= _amount);
404     require(token.balanceOf(address(this)) >= _amount);
405 
406     if (!beneficiaryExists(_beneficiary)) {
407       beneficiaries.push(_beneficiary);
408     }
409 
410     // Bookkepping of distributed tokens
411     distributedTokens = distributedTokens.add(_amount);
412 
413     address tokenVesting = new TokenVesting(
414       _beneficiary,
415       _start,
416       _cliff,
417       _duration,
418       false // TokenVesting cannot be revoked
419     );
420 
421     // Bookkeeping of distributions contracts per beneficiary
422     beneficiaryDistributionContracts[_beneficiary].push(tokenVesting);
423     distributionContracts[tokenVesting] = true;
424 
425     // Assign the tokens to the beneficiary
426     token.safeTransfer(tokenVesting, _amount);
427 
428     emit BeneficiaryAdded(_beneficiary, tokenVesting, _amount);
429     return tokenVesting;
430   }
431 
432   /**
433    * @notice Gets an array of all the distribution contracts for a given beneficiary.
434    * @param _beneficiary address of the beneficiary to whom tokens will be transferred.
435    * @return List of TokenVesting addresses.
436    */
437   function getDistributionContracts(
438     address _beneficiary
439   ) public view validAddress(_beneficiary) returns (address[]) {
440     return beneficiaryDistributionContracts[_beneficiary];
441   }
442 
443   /**
444    * @notice Checks if a beneficiary was added to the pool at least once.
445    * @param _beneficiary address of the beneficiary to whom tokens will be transferred.
446    * @return true if beneficiary exists, false otherwise.
447    */
448   function beneficiaryExists(
449     address _beneficiary
450   ) internal view returns (bool) {
451     return beneficiaryDistributionContracts[_beneficiary].length > 0;
452   }
453 }