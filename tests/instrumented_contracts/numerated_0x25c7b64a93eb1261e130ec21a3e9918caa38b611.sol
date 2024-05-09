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
307 /// @title Main contract for Wrapped VG0. This contract converts Virgin Gen 0 Cryptokitties between the ERC721 standard 
308 ///  and the ERC20 standard by locking cryptokitties into the contract and minting 1:1 backed ERC20 tokens, that
309 ///  can then be redeemed for cryptokitties when desired. This concept originated with WCK (Wrapped Cryptokitties).
310 ///  This code is only a very slight modification of the original contract; It simply adds the Gen 0 requirement, 
311 ///	 the fast cooldown requirement, and the getKitty interfacing.
312 ///
313 /// @notice When wrapping a cryptokitty, you get a generic WVG0 token. Since the WVG0 token is generic, it has no
314 ///  no information about what cryptokitty you submitted, so you will most likely not receive the same kitty
315 ///  back when redeeming the token unless you specify that kitty's ID. The token only entitles you to receive 
316 ///  *a* cryptokitty in return, not necessarily the *same* cryptokitty in return. A different user can submit
317 ///  their own WVG0 tokens to the contract and withdraw the kitty that you originally deposited. WVG0 tokens have
318 ///  no information about which kitty was originally deposited to mint WVG0 - this is due to the very nature of 
319 ///  the ERC20 standard being fungible, and the ERC721 standard being nonfungible.
320 contract WrappedVG0 is ERC20, ReentrancyGuard {
321 
322     // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.
323     using SafeMath for uint256;
324 
325     /* ****** */
326     /* EVENTS */
327     /* ****** */
328 
329     /// @dev This event is fired when a user deposits cryptokitties into the contract in exchange
330     ///  for an equal number of WVG0 ERC20 tokens.
331     /// @param kittyId  The cryptokitty id of the kitty that was deposited into the contract.
332     event DepositKittyAndMintToken(
333         uint256 kittyId
334     );
335 
336     /// @dev This event is fired when a user deposits WVG0 ERC20 tokens into the contract in exchange
337     ///  for an equal number of locked cryptokitties.
338     /// @param kittyId  The cryptokitty id of the kitty that was withdrawn from the contract.
339     event BurnTokenAndWithdrawKitty(
340         uint256 kittyId
341     );
342 
343     /* ******* */
344     /* STORAGE */
345     /* ******* */
346 
347     /// @dev An Array containing all of the cryptokitties that are locked in the contract, backing
348     ///  WVG0 ERC20 tokens 1:1
349     /// @notice Some of the kitties in this array were indeed deposited to the contract, but they
350     ///  are no longer held by the contract. This is because withdrawSpecificKitty() allows a 
351     ///  user to withdraw a kitty "out of order". Since it would be prohibitively expensive to 
352     ///  shift the entire array once we've withdrawn a single element, we instead maintain this 
353     ///  mapping to determine whether an element is still contained in the contract or not. 
354     uint256[] private depositedKittiesArray;
355 
356     /// @dev A mapping keeping track of which kittyIDs are currently contained within the contract.
357     /// @notice We cannot rely on depositedKittiesArray as the source of truth as to which cats are
358     ///  deposited in the contract. This is because burnTokensAndWithdrawKitties() allows a user to 
359     ///  withdraw a kitty "out of order" of the order that they are stored in the array. Since it 
360     ///  would be prohibitively expensive to shift the entire array once we've withdrawn a single 
361     ///  element, we instead maintain this mapping to determine whether an element is still contained 
362     ///  in the contract or not. 
363     mapping (uint256 => bool) private kittyIsDepositedInContract;
364 
365     /* ********* */
366     /* CONSTANTS */
367     /* ********* */
368 
369     /// @dev The metadata details about the "Wrapped Virgin Gen0" WVG0 ERC20 token.
370     uint8 constant public decimals = 18;
371     string constant public name = "Wrapped Virgin Gen 0";
372     string constant public symbol = "WVG0";
373 
374     /// @dev The address of official CryptoKitties contract that stores the metadata about each cat.
375     /// @notice The owner is not capable of changing the address of the CryptoKitties Core contract
376     ///  once the contract has been deployed.
377     address public kittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
378     KittyCore kittyCore;
379 
380     /* ********* */
381     /* FUNCTIONS */
382     /* ********* */
383 
384     /// @notice Allows a user to lock cryptokitties in the contract in exchange for an equal number
385     ///  of WVG0 ERC20 tokens.
386     /// @param _kittyIds  The ids of the cryptokitties that will be locked into the contract.
387     /// @notice The user must first call approve() in the Cryptokitties Core contract on each kitty
388     ///  that thye wish to deposit before calling depositKittiesAndMintTokens(). There is no danger 
389     ///  of this contract overreaching its approval, since the CryptoKitties Core contract's approve() 
390     ///  function only approves this contract for a single Cryptokitty. Calling approve() allows this 
391     ///  contract to transfer the specified kitty in the depositKittiesAndMintTokens() function.
392     function depositKittiesAndMintTokens(uint256[] calldata _kittyIds) external nonReentrant {
393 
394         
395         require(_kittyIds.length > 0, 'you must submit an array with at least one element');
396         for(uint i = 0; i < _kittyIds.length; i++){
397             uint256 kittyToDeposit = _kittyIds[i];
398 
399             uint256 kittyCooldown;
400             uint256 kittyGen;
401             
402             (,,kittyCooldown,,,,,,kittyGen,) = kittyCore.getKitty(kittyToDeposit);
403 
404             require(msg.sender == kittyCore.ownerOf(kittyToDeposit), 'you do not own this cat');
405             require(kittyCore.kittyIndexToApproved(kittyToDeposit) == address(this), 'you must approve() this contract before you can deposit a cat');
406             require(kittyGen == 0, 'this cat must be generation 0');
407             require(kittyCooldown == 0, 'cooldown must be fast');
408             kittyCore.transferFrom(msg.sender, address(this), kittyToDeposit);
409             _pushKitty(kittyToDeposit);
410             emit DepositKittyAndMintToken(kittyToDeposit);
411         }
412         _mint(msg.sender, (_kittyIds.length).mul(10**18));
413     }
414 
415     /// @notice Allows a user to burn WVG0 ERC20 tokens in exchange for an equal number of locked 
416     ///  cryptokitties.
417     /// @param _kittyIds  The IDs of the kitties that the user wishes to withdraw. If the user submits 0 
418     ///  as the ID for any kitty, the contract uses the last kitty in the array for that kitty.
419     /// @param _destinationAddresses  The addresses that the withdrawn kitties will be sent to (this allows 
420     ///  anyone to "airdrop" kitties to addresses that they do not own in a single transaction).
421     function burnTokensAndWithdrawKitties(uint256[] calldata _kittyIds, address[] calldata _destinationAddresses) external nonReentrant {
422         require(_kittyIds.length == _destinationAddresses.length, 'you did not provide a destination address for each of the cats you wish to withdraw');
423         require(_kittyIds.length > 0, 'you must submit an array with at least one element');
424 
425         uint256 numTokensToBurn = _kittyIds.length;
426         require(balanceOf(msg.sender) >= numTokensToBurn.mul(10**18), 'you do not own enough tokens to withdraw this many ERC721 cats');
427         _burn(msg.sender, numTokensToBurn.mul(10**18));
428         
429         for(uint i = 0; i < numTokensToBurn; i++){
430             uint256 kittyToWithdraw = _kittyIds[i];
431             if(kittyToWithdraw == 0){
432                 kittyToWithdraw = _popKitty();
433             } else {
434                 require(kittyIsDepositedInContract[kittyToWithdraw] == true, 'this kitty has already been withdrawn');
435                 require(address(this) == kittyCore.ownerOf(kittyToWithdraw), 'the contract does not own this cat');
436                 kittyIsDepositedInContract[kittyToWithdraw] = false;
437             }
438             kittyCore.transfer(_destinationAddresses[i], kittyToWithdraw);
439             emit BurnTokenAndWithdrawKitty(kittyToWithdraw);
440         }
441     }
442 
443     /// @notice Adds a locked cryptokitty to the end of the array
444     /// @param _kittyId  The id of the cryptokitty that will be locked into the contract.
445     function _pushKitty(uint256 _kittyId) internal {
446         depositedKittiesArray.push(_kittyId);
447         kittyIsDepositedInContract[_kittyId] = true;
448     }
449 
450     /// @notice Removes an unlocked cryptokitty from the end of the array
451     /// @notice The reason that this function must check if the kittyIsDepositedInContract
452     ///  is that the withdrawSpecificKitty() function allows a user to withdraw a kitty
453     ///  from the array out of order.
454     /// @return  The id of the cryptokitty that will be unlocked from the contract.
455     function _popKitty() internal returns(uint256){
456         require(depositedKittiesArray.length > 0, 'there are no cats in the array');
457         uint256 kittyId = depositedKittiesArray[depositedKittiesArray.length - 1];
458         depositedKittiesArray.length--;
459         while(kittyIsDepositedInContract[kittyId] == false){
460             kittyId = depositedKittiesArray[depositedKittiesArray.length - 1];
461             depositedKittiesArray.length--;
462         }
463         kittyIsDepositedInContract[kittyId] = false;
464         return kittyId;
465     }
466 
467     /// @notice Removes any kitties that exist in the array but are no longer held in the
468     ///  contract, which happens if the first few kitties have previously been withdrawn 
469     ///  out of order using the withdrawSpecificKitty() function.
470     /// @notice This function exists to prevent a griefing attack where a malicious attacker
471     ///  could call withdrawSpecificKitty() on a large number of kitties at the front of the
472     ///  array, causing the while-loop in _popKitty to always run out of gas.
473     /// @param _numSlotsToCheck  The number of slots to check in the array.
474     function batchRemoveWithdrawnKittiesFromStorage(uint256 _numSlotsToCheck) external {
475         require(_numSlotsToCheck <= depositedKittiesArray.length, 'you are trying to batch remove more slots than exist in the array');
476         uint256 arrayIndex = depositedKittiesArray.length;
477         for(uint i = 0; i < _numSlotsToCheck; i++){
478             arrayIndex = arrayIndex.sub(1);
479             uint256 kittyId = depositedKittiesArray[arrayIndex];
480             if(kittyIsDepositedInContract[kittyId] == false){
481                 depositedKittiesArray.length--;
482             } else {
483                 return;
484             }
485         }
486     }
487 
488     /// @notice The owner is not capable of changing the address of the CryptoKitties Core
489     ///  contract once the contract has been deployed.
490     constructor() public {
491         kittyCore = KittyCore(kittyCoreAddress);
492     }
493 
494     /// @dev We leave the fallback function payable in case the current State Rent proposals require
495     ///  us to send funds to this contract to keep it alive on mainnet.
496     /// @notice There is no function that allows the contract creator to withdraw any funds sent
497     ///  to this contract, so any funds sent directly to the fallback function that are not used for 
498     ///  State Rent are lost forever.
499     function() external payable {}
500 }
501 
502 /// @title Interface for interacting with the CryptoKitties Core contract created by Dapper Labs Inc.
503 contract KittyCore {
504     function ownerOf(uint256 _tokenId) public view returns (address owner);
505     function transferFrom(address _from, address _to, uint256 _tokenId) external;
506     function transfer(address _to, uint256 _tokenId) external;
507     function getKitty(uint256 _id) public view returns (bool,bool,uint256 _cooldownIndex,uint256,uint256,uint256,uint256,uint256,uint256 _generation,uint256);
508     mapping (uint256 => address) public kittyIndexToApproved;
509 }