1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32     * @dev Multiplies two unsigned integers, reverts on overflow.
33     */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two unsigned integers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
96  * Originally based on code by FirstBlood:
97  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  *
99  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
100  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
101  * compliant implementations may not do it.
102  */
103 contract ERC20 is IERC20 {
104     using SafeMath for uint256;
105 
106     mapping (address => uint256) private _balances;
107 
108     mapping (address => mapping (address => uint256)) private _allowed;
109 
110     uint256 private _totalSupply;
111 
112     /**
113     * @dev Total number of tokens in existence
114     */
115     function totalSupply() public view returns (uint256) {
116         return _totalSupply;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param owner The address to query the balance of.
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124     function balanceOf(address owner) public view returns (uint256) {
125         return _balances[owner];
126     }
127 
128     /**
129      * @dev Function to check the amount of tokens that an owner allowed to a spender.
130      * @param owner address The address which owns the funds.
131      * @param spender address The address which will spend the funds.
132      * @return A uint256 specifying the amount of tokens still available for the spender.
133      */
134     function allowance(address owner, address spender) public view returns (uint256) {
135         return _allowed[owner][spender];
136     }
137 
138     /**
139     * @dev Transfer token for a specified address
140     * @param to The address to transfer to.
141     * @param value The amount to be transferred.
142     */
143     function transfer(address to, uint256 value) public returns (bool) {
144         _transfer(msg.sender, to, value);
145         return true;
146     }
147 
148     /**
149      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150      * Beware that changing an allowance with this method brings the risk that someone may use both the old
151      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      * @param spender The address which will spend the funds.
155      * @param value The amount of tokens to be spent.
156      */
157     function approve(address spender, uint256 value) public returns (bool) {
158         require(spender != address(0));
159 
160         _allowed[msg.sender][spender] = value;
161         emit Approval(msg.sender, spender, value);
162         return true;
163     }
164 
165     /**
166      * @dev Transfer tokens from one address to another.
167      * Note that while this function emits an Approval event, this is not required as per the specification,
168      * and other compliant implementations may not emit the event.
169      * @param from address The address which you want to send tokens from
170      * @param to address The address which you want to transfer to
171      * @param value uint256 the amount of tokens to be transferred
172      */
173     function transferFrom(address from, address to, uint256 value) public returns (bool) {
174         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
175         _transfer(from, to, value);
176         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
177         return true;
178     }
179 
180     /**
181      * @dev Increase the amount of tokens that an owner allowed to a spender.
182      * approve should be called when allowed_[_spender] == 0. To increment
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * Emits an Approval event.
187      * @param spender The address which will spend the funds.
188      * @param addedValue The amount of tokens to increase the allowance by.
189      */
190     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
191         require(spender != address(0));
192 
193         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
194         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
195         return true;
196     }
197 
198     /**
199      * @dev Decrease the amount of tokens that an owner allowed to a spender.
200      * approve should be called when allowed_[_spender] == 0. To decrement
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * From MonolithDAO Token.sol
204      * Emits an Approval event.
205      * @param spender The address which will spend the funds.
206      * @param subtractedValue The amount of tokens to decrease the allowance by.
207      */
208     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
209         require(spender != address(0));
210 
211         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
212         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
213         return true;
214     }
215 
216     /**
217     * @dev Transfer token for a specified addresses
218     * @param from The address to transfer from.
219     * @param to The address to transfer to.
220     * @param value The amount to be transferred.
221     */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Internal function that burns an amount of the token of a given
261      * account, deducting from the sender's allowance for said account. Uses the
262      * internal burn function.
263      * Emits an Approval event (reflecting the reduced allowance).
264      * @param account The account whose tokens will be burnt.
265      * @param value The amount that will be burnt.
266      */
267     function _burnFrom(address account, uint256 value) internal {
268         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
269         _burn(account, value);
270         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
271     }
272 }
273 
274 
275 /**
276  * @title Helps contracts guard against reentrancy attacks.
277  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
278  * @dev If you mark a function `nonReentrant`, you should also
279  * mark it `external`.
280  */
281 contract ReentrancyGuard {
282     /// @dev counter to allow mutex lock with only one SSTORE operation
283     uint256 private _guardCounter;
284 
285     constructor() public {
286         // The counter starts at one to prevent changing it from zero to a non-zero
287         // value, which is a more expensive operation.
288         _guardCounter = 1;
289     }
290 
291     /**
292      * @dev Prevents a contract from calling itself, directly or indirectly.
293      * Calling a `nonReentrant` function from another `nonReentrant`
294      * function is not supported. It is possible to prevent this from happening
295      * by making the `nonReentrant` function external, and make it call a
296      * `private` function that does the actual work.
297      */
298     modifier nonReentrant() {
299         _guardCounter += 1;
300         uint256 localCounter = _guardCounter;
301         _;
302         require(localCounter == _guardCounter);
303     }
304 }
305 
306 
307 /// @title Main contract for WrappedCK. This contract converts Cryptokitties between the ERC721 standard and the 
308 ///  ERC20 standard by locking cryptokitties into the contract and minting 1:1 backed ERC20 tokens, that
309 ///  can then be redeemed for cryptokitties when desired.
310 /// @notice When wrapping a cryptokitty, you get a generic WCK token. Since the WCK token is generic, it has no
311 ///  no information about what cryptokitty you submitted, so you will most likely not receive the same kitty
312 ///  back when redeeming the token. The token only entitles you to receive *a* cryptokitty in return, not 
313 ///  necessarily the *same* cryptokitty in return. This is due to the very nature of the ERC20 standard being
314 ///  fungible, and the ERC721 standard being nonfungible.
315 contract WrappedCK is ERC20, ReentrancyGuard {
316 
317     // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.
318     using SafeMath for uint256;
319 
320     /* ****** */
321     /* EVENTS */
322     /* ****** */
323 
324     /// @dev This event is fired when a user deposits cryptokitties into the contract in exchange
325     ///  for an equal number of WCK ERC20 tokens.
326     /// @param kittyId  The cryptokitty id of the kitty that was deposited into the contract.
327     /// @param tokensMinted  The number of WCK ERC20 tokens that were minted (measured in 10^18 times
328     ///  the number of tokens minted, due to 18 decimal places).
329     event DepositKittyAndMintToken(
330         uint256 kittyId,
331         uint256 tokensMinted
332     );
333 
334     /// @dev This event is fired when a user deposits WCK ERC20 tokens into the contract in exchange
335     ///  for an equal number of locked cryptokitties.
336     /// @param kittyId  The cryptokitty id of the kitty that was withdrawn from the contract.
337     /// @param tokensBurned  The number of WCK ERC20 tokens that were burned (measured in 10^18 times
338     ///  the number of tokens minted, due to 18 decimal places).
339     event BurnTokenAndWithdrawKitty(
340         uint256 kittyId,
341         uint256 tokensBurned
342     );
343 
344     /* ******* */
345     /* STORAGE */
346     /* ******* */
347 
348     /// @dev A queue containing all of the cryptokitties that are locked in the contract, backing
349     ///  WCK ERC20 tokens 1:1
350     /// @notice We use a queue rather than a stack since many users in the community requested the
351     ///  ability to deposit and withdraw a kitty in order to "reroll" its appearance.
352     uint256[] private depositedKittiesQueue;
353     uint256 private queueStartIndex;
354     uint256 private queueEndIndex;
355     
356     /* ********* */
357     /* CONSTANTS */
358     /* ********* */
359 
360     /// @dev The metadata details about the "Wrapped CryptoKitties" WCK ERC20 token.
361     uint8 constant public decimals = 18;
362     string constant public name = "Wrapped CryptoKitties";
363     string constant public symbol = "WCK";
364 
365     /// @dev The address of official CryptoKitties contract that stores the metadata about each cat.
366     /// @notice The owner is not capable of changing the address of the CryptoKitties Core contract 
367     ///  once the contract has been deployed.
368     address public kittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
369     KittyCore kittyCore;
370 
371     /* ********* */
372     /* FUNCTIONS */
373     /* ********* */
374 
375     /// @notice Allows a user to lock one cryptokitty in the contract in exchange for one WCK ERC20 
376     ///  token.
377     /// @param _kittyId  The id of the cryptokitty that will be locked into the contract.
378     /// @notice The user must first call approve() in the Cryptokitties Core contract before calling 
379     ///  depositAndMint(). There is no danger of this contract overreaching its approval, since the 
380     ///  CryptoKitties Core contract's approve() function only approves this contract for a single 
381     ///  Cryptokitty. Calling approve() allows this contract to transfer the specified kitty in the 
382     ///  depositAndMint() function.
383     function depositKittyAndMintToken(uint256 _kittyId) external nonReentrant {
384         require(msg.sender == kittyCore.ownerOf(_kittyId), 'you do not own this cat');
385         require(kittyCore.kittyIndexToApproved(_kittyId) == address(this), 'you must approve() this contract to give it permission to withdraw this cat before you can deposit a cat');
386         kittyCore.transferFrom(msg.sender, address(this), _kittyId);
387         _enqueueKitty(_kittyId);
388         _mint(msg.sender, 10**18);
389         emit DepositKittyAndMintToken(_kittyId, 10**18);
390     }
391 
392     /// @notice Convenience function for calling depositAndMint() multiple times in a single transaction.
393     /// @param _kittyIds  The ids of the cryptokitties that will be locked into the contract.
394     function multiDepositKittyAndMintToken(uint256[] calldata _kittyIds) external nonReentrant {
395         for(uint i = 0; i < _kittyIds.length; i++){
396             uint256 kittyToDeposit = _kittyIds[i];
397             require(msg.sender == kittyCore.ownerOf(kittyToDeposit), 'you do not own this cat');
398             require(kittyCore.kittyIndexToApproved(kittyToDeposit) == address(this), 'you must approve() this contract to give it permission to withdraw this cat before you can deposit a cat');
399             kittyCore.transferFrom(msg.sender, address(this), kittyToDeposit);
400             _enqueueKitty(kittyToDeposit);
401             emit DepositKittyAndMintToken(kittyToDeposit, 10**18);
402         }
403         _mint(msg.sender, (_kittyIds.length).mul(10**18));
404     }
405 
406     /// @notice Allows a user to burn one WCK ERC20 token in exchange for one locked cryptokitty.
407     /// @notice Due to the nature of WCK ERC20 being fungible and interchangeable, the contract is
408     ///  not able to coordinate that you receive the same crypokitty that you originally locked into
409     ///  the contract.
410     function burnTokenAndWithdrawKitty() external nonReentrant {
411         require(balanceOf(msg.sender) >= 10**18, 'you do not own enough tokens to withdraw an ERC721 cat');
412         uint256 kittyId = _dequeueKitty();
413         _burn(msg.sender, 10**18);
414         kittyCore.transferFrom(address(this), msg.sender, kittyId);
415         emit BurnTokenAndWithdrawKitty(kittyId, 10**18);
416     }
417 
418     /// @notice Convenience function for calling burnAndWithdraw() multiple times in a single transaction.
419     /// @param _numTokens  The number of WCK ERC20 tokens that will be burned in exchange for cryptokitties.
420     function multiBurnTokenAndWithdrawKitty(uint256 _numTokens) external nonReentrant {
421         require(balanceOf(msg.sender) >= _numTokens.mul(10**18), 'you do not own enough tokens to withdraw this many ERC721 cats');
422         _burn(msg.sender, _numTokens.mul(10**18));
423         for(uint i = 0; i < _numTokens; i++){
424             uint256 kittyToWithdraw = _dequeueKitty();
425             kittyCore.transfer(msg.sender, kittyToWithdraw);
426             emit BurnTokenAndWithdrawKitty(kittyToWithdraw, 10**18);
427         }
428     }
429 
430     /// @notice Allows a user to lock one cryptokitty in the contract in exchange for unlocking a 
431     ///  different cryptokitty that was previously locked in the contract.
432     /// @param _kittyId  The id of the cryptokitty that will be locked into the contract.
433     /// @notice The user must first call approve() in the Cryptokitties Core contract before calling 
434     ///  depositAndMint(). There is no danger of this contract overreaching its approval, since the 
435     ///  CryptoKitties Core contract's approve() function only approves this contract for a single 
436     ///  Cryptokitty. Calling approve() allows this contract to transfer the specified kitty in the 
437     ///  depositAndMint() function.
438     /// @notice This is a convenience function so that users do not need to call both depositAndMint()
439     ///  and burnAndWithdraw() in succession. Many users in the community requested the ability to 
440     ///  deposit and withdraw a kitty in order to "reroll" its appearance, which this function 
441     ///  accomplishes.
442     function depositKittyAndWithdrawDifferentKitty(uint256 _kittyId) external nonReentrant {
443         require(msg.sender == kittyCore.ownerOf(_kittyId), 'you do not own this cat');
444         require(kittyCore.kittyIndexToApproved(_kittyId) == address(this), 'you must approve() this contract to give it permission to withdraw this cat before you can deposit a cat');
445         kittyCore.transferFrom(msg.sender, address(this), _kittyId);
446         _enqueueKitty(_kittyId);
447         uint256 kittyToWithdraw = _dequeueKitty();
448         kittyCore.transferFrom(address(this), msg.sender, kittyToWithdraw);
449         emit DepositKittyAndMintToken(_kittyId, 10**18);
450         emit BurnTokenAndWithdrawKitty(kittyToWithdraw, 10**18);
451     }
452 
453     /// @notice Convenience function for calling depositAndWithdraw() multiple times in a single transaction.
454     /// @param _kittyIds  The ids of the cryptokitties that will be locked into the contract.
455     function multiDepositKittyAndWithdrawDifferentKitty(uint256[] calldata _kittyIds) external nonReentrant {
456         for(uint i = 0; i < _kittyIds.length; i++){
457             uint256 kittyToDeposit = _kittyIds[i];
458             require(msg.sender == kittyCore.ownerOf(kittyToDeposit), 'you do not own this cat');
459             require(kittyCore.kittyIndexToApproved(kittyToDeposit) == address(this), 'you must approve() this contract to give it permission to withdraw this cat before you can deposit a cat');
460             kittyCore.transferFrom(msg.sender, address(this), kittyToDeposit);
461             _enqueueKitty(kittyToDeposit);
462             uint256 kittyToWithdraw = _dequeueKitty();
463             kittyCore.transferFrom(address(this), msg.sender, kittyToWithdraw);
464             emit DepositKittyAndMintToken(kittyToDeposit, 10**18);
465             emit BurnTokenAndWithdrawKitty(kittyToWithdraw, 10**18);
466         }
467     }
468     
469     /// @notice Adds a locked cryptokitty to the end of the queue
470     /// @param _kittyId  The id of the cryptokitty that will be locked into the contract.
471     function _enqueueKitty(uint256 _kittyId) internal {
472         depositedKittiesQueue.push(_kittyId);
473         queueEndIndex = queueEndIndex.add(1);
474     }
475 
476     /// @notice Adds a locked cryptokitty to the end of the queue
477     /// @return  The id of the cryptokitty that will be unlocked from the contract.
478     function _dequeueKitty() internal returns(uint256){
479         require(queueStartIndex < queueEndIndex, 'there are no cats in the queue');
480         uint256 kittyId = depositedKittiesQueue[queueStartIndex];
481         queueStartIndex = queueStartIndex.add(1);
482         return kittyId;
483     }
484 
485     /// @return The number of cryptokitties locked in the contract that back outstanding
486     ///  WCK tokens.
487     function totalCatsLockedInContract() public view returns(uint256){
488         return queueEndIndex.sub(queueStartIndex);
489     }
490 
491     /// @notice The owner is not capable of changing the address of the CryptoKitties Core 
492     ///  contract once the contract has been deployed.
493     constructor() public {
494         kittyCore = KittyCore(kittyCoreAddress);
495     }
496 
497     /// @dev We leave the fallback function payable in case the current State Rent proposals require
498     ///  us to send funds to this contract to keep it alive on mainnet.
499     /// @notice There is no function that allows the contract creator to withdraw any funds sent
500     ///  to this contract, so any funds sent directly to the fallback fucntion that are not used for 
501     ///  State Rent are lost forever.
502     function() external payable {}
503 }
504 
505 /// @title Interface for interacting with the CryptoKitties Core contract created by Dapper Labs Inc.
506 contract KittyCore {
507     function ownerOf(uint256 _tokenId) public view returns (address owner);
508     function transferFrom(address _from, address _to, uint256 _tokenId) external;
509     function transfer(address _to, uint256 _tokenId) external;
510     mapping (uint256 => address) public kittyIndexToApproved;
511 }