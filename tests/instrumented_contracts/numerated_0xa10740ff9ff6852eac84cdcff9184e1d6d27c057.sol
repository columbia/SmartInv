1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-18
3 */
4 
5 
6 pragma solidity ^0.5.8;
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 interface IERC20 {
13     function transfer(address to, uint256 value) external returns (bool);
14 
15     function approve(address spender, uint256 value) external returns (bool);
16 
17     function transferFrom(address from, address to, uint256 value) external returns (bool);
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address who) external view returns (uint256);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
101  * Originally based on code by FirstBlood:
102  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  *
104  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
105  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
106  * compliant implementations may not do it.
107  */
108 contract ERC20 is IERC20 {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112 
113     mapping (address => mapping (address => uint256)) private _allowed;
114 
115     uint256 private _totalSupply;
116 
117     /**
118     * @dev Total number of tokens in existence
119     */
120     function totalSupply() public view returns (uint256) {
121         return _totalSupply;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param owner The address to query the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address owner) public view returns (uint256) {
130         return _balances[owner];
131     }
132 
133     /**
134      * @dev Function to check the amount of tokens that an owner allowed to a spender.
135      * @param owner address The address which owns the funds.
136      * @param spender address The address which will spend the funds.
137      * @return A uint256 specifying the amount of tokens still available for the spender.
138      */
139     function allowance(address owner, address spender) public view returns (uint256) {
140         return _allowed[owner][spender];
141     }
142 
143     /**
144     * @dev Transfer token for a specified address
145     * @param to The address to transfer to.
146     * @param value The amount to be transferred.
147     */
148     function transfer(address to, uint256 value) public returns (bool) {
149         _transfer(msg.sender, to, value);
150         return true;
151     }
152 
153     /**
154      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155      * Beware that changing an allowance with this method brings the risk that someone may use both the old
156      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      * @param spender The address which will spend the funds.
160      * @param value The amount of tokens to be spent.
161      */
162     function approve(address spender, uint256 value) public returns (bool) {
163         require(spender != address(0));
164 
165         _allowed[msg.sender][spender] = value;
166         emit Approval(msg.sender, spender, value);
167         return true;
168     }
169 
170     /**
171      * @dev Transfer tokens from one address to another.
172      * Note that while this function emits an Approval event, this is not required as per the specification,
173      * and other compliant implementations may not emit the event.
174      * @param from address The address which you want to send tokens from
175      * @param to address The address which you want to transfer to
176      * @param value uint256 the amount of tokens to be transferred
177      */
178     function transferFrom(address from, address to, uint256 value) public returns (bool) {
179         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
180         _transfer(from, to, value);
181         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
182         return true;
183     }
184 
185     /**
186      * @dev Increase the amount of tokens that an owner allowed to a spender.
187      * approve should be called when allowed_[_spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      * Emits an Approval event.
192      * @param spender The address which will spend the funds.
193      * @param addedValue The amount of tokens to increase the allowance by.
194      */
195     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
196         require(spender != address(0));
197 
198         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
199         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
200         return true;
201     }
202 
203     /**
204      * @dev Decrease the amount of tokens that an owner allowed to a spender.
205      * approve should be called when allowed_[_spender] == 0. To decrement
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * Emits an Approval event.
210      * @param spender The address which will spend the funds.
211      * @param subtractedValue The amount of tokens to decrease the allowance by.
212      */
213     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
214         require(spender != address(0));
215 
216         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
217         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218         return true;
219     }
220 
221     /**
222     * @dev Transfer token for a specified addresses
223     * @param from The address to transfer from.
224     * @param to The address to transfer to.
225     * @param value The amount to be transferred.
226     */
227     function _transfer(address from, address to, uint256 value) internal {
228         require(to != address(0));
229 
230         _balances[from] = _balances[from].sub(value);
231         _balances[to] = _balances[to].add(value);
232         emit Transfer(from, to, value);
233     }
234 
235     /**
236      * @dev Internal function that mints an amount of the token and assigns it to
237      * an account. This encapsulates the modification of balances such that the
238      * proper events are emitted.
239      * @param account The account that will receive the created tokens.
240      * @param value The amount that will be created.
241      */
242     function _mint(address account, uint256 value) internal {
243         require(account != address(0));
244 
245         _totalSupply = _totalSupply.add(value);
246         _balances[account] = _balances[account].add(value);
247         emit Transfer(address(0), account, value);
248     }
249 
250     /**
251      * @dev Internal function that burns an amount of the token of a given
252      * account.
253      * @param account The account whose tokens will be burnt.
254      * @param value The amount that will be burnt.
255      */
256     function _burn(address account, uint256 value) internal {
257         require(account != address(0));
258 
259         _totalSupply = _totalSupply.sub(value);
260         _balances[account] = _balances[account].sub(value);
261         emit Transfer(account, address(0), value);
262     }
263 
264     /**
265      * @dev Internal function that burns an amount of the token of a given
266      * account, deducting from the sender's allowance for said account. Uses the
267      * internal burn function.
268      * Emits an Approval event (reflecting the reduced allowance).
269      * @param account The account whose tokens will be burnt.
270      * @param value The amount that will be burnt.
271      */
272     function _burnFrom(address account, uint256 value) internal {
273         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
274         _burn(account, value);
275         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
276     }
277 }
278 
279 
280 /**
281  * @title Helps contracts guard against reentrancy attacks.
282  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
283  * @dev If you mark a function `nonReentrant`, you should also
284  * mark it `external`.
285  */
286 contract ReentrancyGuard {
287     /// @dev counter to allow mutex lock with only one SSTORE operation
288     uint256 private _guardCounter;
289 
290     constructor() public {
291         // The counter starts at one to prevent changing it from zero to a non-zero
292         // value, which is a more expensive operation.
293         _guardCounter = 1;
294     }
295 
296     /**
297      * @dev Prevents a contract from calling itself, directly or indirectly.
298      * Calling a `nonReentrant` function from another `nonReentrant`
299      * function is not supported. It is possible to prevent this from happening
300      * by making the `nonReentrant` function external, and make it call a
301      * `private` function that does the actual work.
302      */
303     modifier nonReentrant() {
304         _guardCounter += 1;
305         uint256 localCounter = _guardCounter;
306         _;
307         require(localCounter == _guardCounter);
308     }
309 }
310 
311 
312 /// @title Main contract for Wrapped G0. This contract converts Gen 0 Cryptokitties between the ERC721 standard 
313 ///  and the ERC20 standard by locking cryptokitties into the contract and minting 1:1 backed ERC20 tokens, that
314 ///  can then be redeemed for cryptokitties when desired. This concept originated with WCK (Wrapped Cryptokitties).
315 ///  This code is only a very slight modification of the original contract; It simply adds the Gen 0 requirement 
316 ///	 as well the getKitty interfacing.
317 ///
318 /// @notice When wrapping a cryptokitty, you get a generic WG0 token. Since the WG0 token is generic, it has no
319 ///  no information about what cryptokitty you submitted, so you will most likely not receive the same kitty
320 ///  back when redeeming the token unless you specify that kitty's ID. The token only entitles you to receive 
321 ///  *a* cryptokitty in return, not necessarily the *same* cryptokitty in return. A different user can submit
322 ///  their own WG0 tokens to the contract and withdraw the kitty that you originally deposited. WG0 tokens have
323 ///  no information about which kitty was originally deposited to mint WG0 - this is due to the very nature of 
324 ///  the ERC20 standard being fungible, and the ERC721 standard being nonfungible.
325 contract WrappedG0 is ERC20, ReentrancyGuard {
326 
327     // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.
328     using SafeMath for uint256;
329 
330     /* ****** */
331     /* EVENTS */
332     /* ****** */
333 
334     /// @dev This event is fired when a user deposits cryptokitties into the contract in exchange
335     ///  for an equal number of WG0 ERC20 tokens.
336     /// @param kittyId  The cryptokitty id of the kitty that was deposited into the contract.
337     event DepositKittyAndMintToken(
338         uint256 kittyId
339     );
340 
341     /// @dev This event is fired when a user deposits WG0 ERC20 tokens into the contract in exchange
342     ///  for an equal number of locked cryptokitties.
343     /// @param kittyId  The cryptokitty id of the kitty that was withdrawn from the contract.
344     event BurnTokenAndWithdrawKitty(
345         uint256 kittyId
346     );
347 
348     /* ******* */
349     /* STORAGE */
350     /* ******* */
351 
352     /// @dev An Array containing all of the cryptokitties that are locked in the contract, backing
353     ///  WG0 ERC20 tokens 1:1
354     /// @notice Some of the kitties in this array were indeed deposited to the contract, but they
355     ///  are no longer held by the contract. This is because withdrawSpecificKitty() allows a 
356     ///  user to withdraw a kitty "out of order". Since it would be prohibitively expensive to 
357     ///  shift the entire array once we've withdrawn a single element, we instead maintain this 
358     ///  mapping to determine whether an element is still contained in the contract or not. 
359     uint256[] private depositedKittiesArray;
360 
361     /// @dev A mapping keeping track of which kittyIDs are currently contained within the contract.
362     /// @notice We cannot rely on depositedKittiesArray as the source of truth as to which cats are
363     ///  deposited in the contract. This is because burnTokensAndWithdrawKitties() allows a user to 
364     ///  withdraw a kitty "out of order" of the order that they are stored in the array. Since it 
365     ///  would be prohibitively expensive to shift the entire array once we've withdrawn a single 
366     ///  element, we instead maintain this mapping to determine whether an element is still contained 
367     ///  in the contract or not. 
368     mapping (uint256 => bool) private kittyIsDepositedInContract;
369 
370     /* ********* */
371     /* CONSTANTS */
372     /* ********* */
373 
374     /// @dev The metadata details about the "Wrapped CryptoKitties" WG0 ERC20 token.
375     uint8 constant public decimals = 18;
376     string constant public name = "Wrapped Gen 0";
377     string constant public symbol = "WG0";
378 
379     /// @dev The address of official CryptoKitties contract that stores the metadata about each cat.
380     /// @notice The owner is not capable of changing the address of the CryptoKitties Core contract
381     ///  once the contract has been deployed.
382     address public kittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
383     KittyCore kittyCore;
384 
385     /* ********* */
386     /* FUNCTIONS */
387     /* ********* */
388 
389     /// @notice Allows a user to lock cryptokitties in the contract in exchange for an equal number
390     ///  of WG0 ERC20 tokens.
391     /// @param _kittyIds  The ids of the cryptokitties that will be locked into the contract.
392     /// @notice The user must first call approve() in the Cryptokitties Core contract on each kitty
393     ///  that thye wish to deposit before calling depositKittiesAndMintTokens(). There is no danger 
394     ///  of this contract overreaching its approval, since the CryptoKitties Core contract's approve() 
395     ///  function only approves this contract for a single Cryptokitty. Calling approve() allows this 
396     ///  contract to transfer the specified kitty in the depositKittiesAndMintTokens() function.
397     function depositKittiesAndMintTokens(uint256[] calldata _kittyIds) external nonReentrant {
398 
399         
400         require(_kittyIds.length > 0, 'you must submit an array with at least one element');
401         for(uint i = 0; i < _kittyIds.length; i++){
402             uint256 kittyToDeposit = _kittyIds[i];
403 
404             uint256 kittyCooldown;
405             uint256 kittyGen;
406             
407             (,,kittyCooldown,,,,,,kittyGen,) = kittyCore.getKitty(kittyToDeposit);
408 
409             require(msg.sender == kittyCore.ownerOf(kittyToDeposit), 'you do not own this cat');
410             require(kittyCore.kittyIndexToApproved(kittyToDeposit) == address(this), 'you must approve() this contract before you can deposit a cat');
411             require(kittyGen == 0, 'this cat must be generation 0');
412 
413             kittyCore.transferFrom(msg.sender, address(this), kittyToDeposit);
414             _pushKitty(kittyToDeposit);
415             emit DepositKittyAndMintToken(kittyToDeposit);
416         }
417         _mint(msg.sender, (_kittyIds.length).mul(10**18));
418     }
419 
420     /// @notice Allows a user to burn WG0 ERC20 tokens in exchange for an equal number of locked 
421     ///  cryptokitties.
422     /// @param _kittyIds  The IDs of the kitties that the user wishes to withdraw. If the user submits 0 
423     ///  as the ID for any kitty, the contract uses the last kitty in the array for that kitty.
424     /// @param _destinationAddresses  The addresses that the withdrawn kitties will be sent to (this allows 
425     ///  anyone to "airdrop" kitties to addresses that they do not own in a single transaction).
426     function burnTokensAndWithdrawKitties(uint256[] calldata _kittyIds, address[] calldata _destinationAddresses) external nonReentrant {
427         require(_kittyIds.length == _destinationAddresses.length, 'you did not provide a destination address for each of the cats you wish to withdraw');
428         require(_kittyIds.length > 0, 'you must submit an array with at least one element');
429 
430         uint256 numTokensToBurn = _kittyIds.length;
431         require(balanceOf(msg.sender) >= numTokensToBurn.mul(10**18), 'you do not own enough tokens to withdraw this many ERC721 cats');
432         _burn(msg.sender, numTokensToBurn.mul(10**18));
433         
434         for(uint i = 0; i < numTokensToBurn; i++){
435             uint256 kittyToWithdraw = _kittyIds[i];
436             if(kittyToWithdraw == 0){
437                 kittyToWithdraw = _popKitty();
438             } else {
439                 require(kittyIsDepositedInContract[kittyToWithdraw] == true, 'this kitty has already been withdrawn');
440                 require(address(this) == kittyCore.ownerOf(kittyToWithdraw), 'the contract does not own this cat');
441                 kittyIsDepositedInContract[kittyToWithdraw] = false;
442             }
443             kittyCore.transfer(_destinationAddresses[i], kittyToWithdraw);
444             emit BurnTokenAndWithdrawKitty(kittyToWithdraw);
445         }
446     }
447 
448     /// @notice Adds a locked cryptokitty to the end of the array
449     /// @param _kittyId  The id of the cryptokitty that will be locked into the contract.
450     function _pushKitty(uint256 _kittyId) internal {
451         depositedKittiesArray.push(_kittyId);
452         kittyIsDepositedInContract[_kittyId] = true;
453     }
454 
455     /// @notice Removes an unlocked cryptokitty from the end of the array
456     /// @notice The reason that this function must check if the kittyIsDepositedInContract
457     ///  is that the withdrawSpecificKitty() function allows a user to withdraw a kitty
458     ///  from the array out of order.
459     /// @return  The id of the cryptokitty that will be unlocked from the contract.
460     function _popKitty() internal returns(uint256){
461         require(depositedKittiesArray.length > 0, 'there are no cats in the array');
462         uint256 kittyId = depositedKittiesArray[depositedKittiesArray.length - 1];
463         depositedKittiesArray.length--;
464         while(kittyIsDepositedInContract[kittyId] == false){
465             kittyId = depositedKittiesArray[depositedKittiesArray.length - 1];
466             depositedKittiesArray.length--;
467         }
468         kittyIsDepositedInContract[kittyId] = false;
469         return kittyId;
470     }
471 
472     /// @notice Removes any kitties that exist in the array but are no longer held in the
473     ///  contract, which happens if the first few kitties have previously been withdrawn 
474     ///  out of order using the withdrawSpecificKitty() function.
475     /// @notice This function exists to prevent a griefing attack where a malicious attacker
476     ///  could call withdrawSpecificKitty() on a large number of kitties at the front of the
477     ///  array, causing the while-loop in _popKitty to always run out of gas.
478     /// @param _numSlotsToCheck  The number of slots to check in the array.
479     function batchRemoveWithdrawnKittiesFromStorage(uint256 _numSlotsToCheck) external {
480         require(_numSlotsToCheck <= depositedKittiesArray.length, 'you are trying to batch remove more slots than exist in the array');
481         uint256 arrayIndex = depositedKittiesArray.length;
482         for(uint i = 0; i < _numSlotsToCheck; i++){
483             arrayIndex = arrayIndex.sub(1);
484             uint256 kittyId = depositedKittiesArray[arrayIndex];
485             if(kittyIsDepositedInContract[kittyId] == false){
486                 depositedKittiesArray.length--;
487             } else {
488                 return;
489             }
490         }
491     }
492 
493     /// @notice The owner is not capable of changing the address of the CryptoKitties Core
494     ///  contract once the contract has been deployed.
495     constructor() public {
496         kittyCore = KittyCore(kittyCoreAddress);
497     }
498 
499     /// @dev We leave the fallback function payable in case the current State Rent proposals require
500     ///  us to send funds to this contract to keep it alive on mainnet.
501     /// @notice There is no function that allows the contract creator to withdraw any funds sent
502     ///  to this contract, so any funds sent directly to the fallback function that are not used for 
503     ///  State Rent are lost forever.
504     function() external payable {}
505 }
506 
507 /// @title Interface for interacting with the CryptoKitties Core contract created by Dapper Labs Inc.
508 contract KittyCore {
509     function ownerOf(uint256 _tokenId) public view returns (address owner);
510     function transferFrom(address _from, address _to, uint256 _tokenId) external;
511     function transfer(address _to, uint256 _tokenId) external;
512     function getKitty(uint256 _id) public view returns (bool,bool,uint256 _cooldownIndex,uint256,uint256,uint256,uint256,uint256,uint256 _generation,uint256);
513     mapping (uint256 => address) public kittyIndexToApproved;
514 }