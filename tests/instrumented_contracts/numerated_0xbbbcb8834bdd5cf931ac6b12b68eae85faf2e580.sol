1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender)
138     public view returns (uint256);
139 
140   function transferFrom(address from, address to, uint256 value)
141     public returns (bool);
142 
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(
145     address indexed owner,
146     address indexed spender,
147     uint256 value
148   );
149 }
150 
151 // File: contracts/grapevine/crowdsale/TokenTimelockController.sol
152 
153 /**
154  * @title TokenTimelock Controller
155  * @dev This contract allows to create/read/revoke TokenTimelock contracts and to claim the amounts vested.
156  **/
157 contract TokenTimelockController is Ownable {
158   using SafeMath for uint;
159 
160   struct TokenTimelock {
161     uint256 amount;
162     uint256 releaseTime;
163     bool released;
164     bool revocable;
165     bool revoked;
166   }
167 
168   event TokenTimelockCreated(
169     address indexed beneficiary, 
170     uint256 releaseTime, 
171     bool revocable, 
172     uint256 amount
173   );
174 
175   event TokenTimelockRevoked(
176     address indexed beneficiary
177   );
178 
179   event TokenTimelockBeneficiaryChanged(
180     address indexed previousBeneficiary, 
181     address indexed newBeneficiary
182   );
183   
184   event TokenTimelockReleased(
185     address indexed beneficiary,
186     uint256 amount
187   );
188 
189   uint256 public constant TEAM_LOCK_DURATION_PART1 = 1 * 365 days;
190   uint256 public constant TEAM_LOCK_DURATION_PART2 = 2 * 365 days;
191   uint256 public constant INVESTOR_LOCK_DURATION = 6 * 30 days;
192 
193   mapping (address => TokenTimelock[]) tokenTimeLocks;
194   
195   ERC20 public token;
196   address public crowdsale;
197   bool public activated;
198 
199   /// @notice Constructor for TokenTimelock Controller
200   constructor(ERC20 _token) public {
201     token = _token;
202   }
203 
204   modifier onlyCrowdsale() {
205     require(msg.sender == crowdsale);
206     _;
207   }
208   
209   modifier onlyWhenActivated() {
210     require(activated);
211     _;
212   }
213 
214   modifier onlyValidTokenTimelock(address _beneficiary, uint256 _id) {
215     require(_beneficiary != address(0));
216     require(_id < tokenTimeLocks[_beneficiary].length);
217     require(!tokenTimeLocks[_beneficiary][_id].revoked);
218     _;
219   }
220 
221   /**
222    * @dev Function to set the crowdsale address
223    * @param _crowdsale address The address of the crowdsale.
224    */
225   function setCrowdsale(address _crowdsale) external onlyOwner {
226     require(_crowdsale != address(0));
227     crowdsale = _crowdsale;
228   }
229 
230   /**
231    * @dev Function to activate the controller.
232    * It can be called only by the crowdsale address.
233    */
234   function activate() external onlyCrowdsale {
235     activated = true;
236   }
237 
238   /**
239    * @dev Creates a lock for the provided _beneficiary with the provided amount
240    * The creation can be peformed only if:
241    * - the sender is the address of the crowdsale;
242    * - the _beneficiary and _tokenHolder are valid addresses;
243    * - the _amount is greater than 0 and was appoved by the _tokenHolder prior to the transaction.
244    * The investors will have a lock with a lock period of 6 months.
245    * @param _beneficiary Address that will own the lock.
246    * @param _amount the amount of the locked tokens.
247    * @param _start when the lock should start.
248    * @param _tokenHolder the account that approved the amount for this contract.
249    */
250   function createInvestorTokenTimeLock(
251     address _beneficiary,
252     uint256 _amount, 
253     uint256 _start,
254     address _tokenHolder
255   ) external onlyCrowdsale returns (bool)
256     {
257     require(_beneficiary != address(0) && _amount > 0);
258     require(_tokenHolder != address(0));
259 
260     TokenTimelock memory tokenLock = TokenTimelock(
261       _amount,
262       _start.add(INVESTOR_LOCK_DURATION),
263       false,
264       false,
265       false
266     );
267     tokenTimeLocks[_beneficiary].push(tokenLock);
268     require(token.transferFrom(_tokenHolder, this, _amount));
269     
270     emit TokenTimelockCreated(
271       _beneficiary,
272       tokenLock.releaseTime,
273       false,
274       _amount);
275     return true;
276   }
277 
278   /**
279    * @dev Creates locks for the provided _beneficiary with the provided amount
280    * The creation can be peformed only if:
281    * - the sender is the owner of the contract;
282    * - the _beneficiary and _tokenHolder are valid addresses;
283    * - the _amount is greater than 0 and was appoved by the _tokenHolder prior to the transaction.
284    * The team members will have two locks with 1 and 2 years lock period, each having half of the amount.
285    * @param _beneficiary Address that will own the lock.
286    * @param _amount the amount of the locked tokens.
287    * @param _start when the lock should start.
288    * @param _tokenHolder the account that approved the amount for this contract.
289    */
290   function createTeamTokenTimeLock(
291     address _beneficiary,
292     uint256 _amount, 
293     uint256 _start,
294     address _tokenHolder
295   ) external onlyOwner returns (bool)
296     {
297     require(_beneficiary != address(0) && _amount > 0);
298     require(_tokenHolder != address(0));
299 
300     uint256 amount = _amount.div(2);
301     TokenTimelock memory tokenLock1 = TokenTimelock(
302       amount,
303       _start.add(TEAM_LOCK_DURATION_PART1),
304       false,
305       true,
306       false
307     );
308     tokenTimeLocks[_beneficiary].push(tokenLock1);
309 
310     TokenTimelock memory tokenLock2 = TokenTimelock(
311       amount,
312       _start.add(TEAM_LOCK_DURATION_PART2),
313       false,
314       true,
315       false
316     );
317     tokenTimeLocks[_beneficiary].push(tokenLock2);
318 
319     require(token.transferFrom(_tokenHolder, this, _amount));
320     
321     emit TokenTimelockCreated(
322       _beneficiary,
323       tokenLock1.releaseTime,
324       true,
325       amount);
326     emit TokenTimelockCreated(
327       _beneficiary,
328       tokenLock2.releaseTime,
329       true,
330       amount);
331     return true;
332   }
333 
334   /**
335    * @dev Revokes the lock for the provided _beneficiary and _id.
336    * The revoke can be peformed only if:
337    * - the sender is the owner of the contract;
338    * - the controller was activated by the crowdsale contract;
339    * - the _beneficiary and _id reference a valid lock;
340    * - the lock was not revoked;
341    * - the lock is revokable;
342    * - the lock was not released.
343    * @param _beneficiary Address owning the lock.
344    * @param _id id of the lock.
345    */
346   function revokeTokenTimelock(
347     address _beneficiary,
348     uint256 _id) 
349     external onlyWhenActivated onlyOwner onlyValidTokenTimelock(_beneficiary, _id)
350   {
351     require(tokenTimeLocks[_beneficiary][_id].revocable);
352     require(!tokenTimeLocks[_beneficiary][_id].released);
353     TokenTimelock storage tokenLock = tokenTimeLocks[_beneficiary][_id];
354     tokenLock.revoked = true;
355     require(token.transfer(owner, tokenLock.amount));
356     emit TokenTimelockRevoked(_beneficiary);
357   }
358 
359   /**
360    * @dev Returns the number locks of the provided _beneficiary.
361    * @param _beneficiary Address owning the locks.
362    */
363   function getTokenTimelockCount(address _beneficiary) view external returns (uint) {
364     return tokenTimeLocks[_beneficiary].length;
365   }
366 
367   /**
368    * @dev Returns the details of the lock referenced by the provided _beneficiary and _id.
369    * @param _beneficiary Address owning the lock.
370    * @param _id id of the lock.
371    */
372   function getTokenTimelockDetails(address _beneficiary, uint256 _id) view external returns (
373     uint256 _amount,
374     uint256 _releaseTime,
375     bool _released,
376     bool _revocable,
377     bool _revoked) 
378     {
379     require(_id < tokenTimeLocks[_beneficiary].length);
380     _amount = tokenTimeLocks[_beneficiary][_id].amount;
381     _releaseTime = tokenTimeLocks[_beneficiary][_id].releaseTime;
382     _released = tokenTimeLocks[_beneficiary][_id].released;
383     _revocable = tokenTimeLocks[_beneficiary][_id].revocable;
384     _revoked = tokenTimeLocks[_beneficiary][_id].revoked;
385   }
386 
387   /**
388    * @dev Changes the beneficiary of the _id'th lock of the sender with the provided newBeneficiary.
389    * The release can be peformed only if:
390    * - the controller was activated by the crowdsale contract;
391    * - the sender and _id reference a valid lock;
392    * - the lock was not revoked;
393    * @param _id id of the lock.
394    * @param _newBeneficiary Address of the new beneficiary.
395    */
396   function changeBeneficiary(uint256 _id, address _newBeneficiary) external onlyWhenActivated onlyValidTokenTimelock(msg.sender, _id) {
397     tokenTimeLocks[_newBeneficiary].push(tokenTimeLocks[msg.sender][_id]);
398     if (tokenTimeLocks[msg.sender].length > 1) {
399       tokenTimeLocks[msg.sender][_id] = tokenTimeLocks[msg.sender][tokenTimeLocks[msg.sender].length.sub(1)];
400       delete(tokenTimeLocks[msg.sender][tokenTimeLocks[msg.sender].length.sub(1)]);
401     }
402     tokenTimeLocks[msg.sender].length--;
403     emit TokenTimelockBeneficiaryChanged(msg.sender, _newBeneficiary);
404   }
405 
406   /**
407    * @dev Releases the tokens for the calling sender and _id.
408    * The release can be peformed only if:
409    * - the controller was activated by the crowdsale contract;
410    * - the sender and _id reference a valid lock;
411    * - the lock was not revoked;
412    * - the lock was not released before;
413    * - the lock period has passed.
414    * @param _id id of the lock.
415    */
416   function release(uint256 _id) external {
417     releaseFor(msg.sender, _id);
418   }
419 
420    /**
421    * @dev Releases the tokens for the provided _beneficiary and _id.
422    * The release can be peformed only if:
423    * - the controller was activated by the crowdsale contract;
424    * - the _beneficiary and _id reference a valid lock;
425    * - the lock was not revoked;
426    * - the lock was not released before;
427    * - the lock period has passed.
428    * @param _beneficiary Address owning the lock.
429    * @param _id id of the lock.
430    */
431   function releaseFor(address _beneficiary, uint256 _id) public onlyWhenActivated onlyValidTokenTimelock(_beneficiary, _id) {
432     TokenTimelock storage tokenLock = tokenTimeLocks[_beneficiary][_id];
433     require(!tokenLock.released);
434     // solium-disable-next-line security/no-block-members
435     require(block.timestamp >= tokenLock.releaseTime);
436     tokenLock.released = true;
437     require(token.transfer(_beneficiary, tokenLock.amount));
438     emit TokenTimelockReleased(_beneficiary, tokenLock.amount);
439   }
440 }