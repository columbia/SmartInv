1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-31
3 */
4 
5 pragma solidity ^0.5.8;
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 interface IERC20 {
12     function transfer(address to, uint256 value) external returns (bool);
13 
14     function approve(address spender, uint256 value) external returns (bool);
15 
16     function transferFrom(address from, address to, uint256 value) external returns (bool);
17 
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address who) external view returns (uint256);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Unsigned math operations with safety checks that revert on error
33  */
34 library SafeMath {
35     /**
36     * @dev Multiplies two unsigned integers, reverts on overflow.
37     */
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40         // benefit is lost if 'b' is also tested.
41         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42         if (a == 0) {
43             return 0;
44         }
45 
46         uint256 c = a * b;
47         require(c / a == b);
48 
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // Solidity only automatically asserts when dividing by 0
57         require(b > 0);
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     /**
65     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
66     */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b <= a);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75     * @dev Adds two unsigned integers, reverts on overflow.
76     */
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a);
80 
81         return c;
82     }
83 
84     /**
85     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
86     * reverts when dividing by zero.
87     */
88     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b != 0);
90         return a % b;
91     }
92 }
93 
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
100  * Originally based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  *
103  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
104  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
105  * compliant implementations may not do it.
106  */
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) private _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowed;
113 
114     uint256 private _totalSupply;
115 
116     /**
117     * @dev Total number of tokens in existence
118     */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param owner The address to query the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens that an owner allowed to a spender.
134      * @param owner address The address which owns the funds.
135      * @param spender address The address which will spend the funds.
136      * @return A uint256 specifying the amount of tokens still available for the spender.
137      */
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     /**
143     * @dev Transfer token for a specified address
144     * @param to The address to transfer to.
145     * @param value The amount to be transferred.
146     */
147     function transfer(address to, uint256 value) public returns (bool) {
148         _transfer(msg.sender, to, value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param spender The address which will spend the funds.
159      * @param value The amount of tokens to be spent.
160      */
161     function approve(address spender, uint256 value) public returns (bool) {
162         require(spender != address(0));
163 
164         _allowed[msg.sender][spender] = value;
165         emit Approval(msg.sender, spender, value);
166         return true;
167     }
168 
169     /**
170      * @dev Transfer tokens from one address to another.
171      * Note that while this function emits an Approval event, this is not required as per the specification,
172      * and other compliant implementations may not emit the event.
173      * @param from address The address which you want to send tokens from
174      * @param to address The address which you want to transfer to
175      * @param value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address from, address to, uint256 value) public returns (bool) {
178         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
179         _transfer(from, to, value);
180         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
198         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when allowed_[_spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         require(spender != address(0));
214 
215         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
216         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /**
221     * @dev Transfer token for a specified addresses
222     * @param from The address to transfer from.
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228 
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         emit Transfer(from, to, value);
232     }
233 
234     /**
235      * @dev Internal function that mints an amount of the token and assigns it to
236      * an account. This encapsulates the modification of balances such that the
237      * proper events are emitted.
238      * @param account The account that will receive the created tokens.
239      * @param value The amount that will be created.
240      */
241     function _mint(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.add(value);
245         _balances[account] = _balances[account].add(value);
246         emit Transfer(address(0), account, value);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burn(address account, uint256 value) internal {
256         require(account != address(0));
257 
258         _totalSupply = _totalSupply.sub(value);
259         _balances[account] = _balances[account].sub(value);
260         emit Transfer(account, address(0), value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account, deducting from the sender's allowance for said account. Uses the
266      * internal burn function.
267      * Emits an Approval event (reflecting the reduced allowance).
268      * @param account The account whose tokens will be burnt.
269      * @param value The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 value) internal {
272         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
273         _burn(account, value);
274         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
275     }
276 }
277 
278 
279 /**
280  * @title Helps contracts guard against reentrancy attacks.
281  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
282  * @dev If you mark a function `nonReentrant`, you should also
283  * mark it `external`.
284  */
285 contract ReentrancyGuard {
286     /// @dev counter to allow mutex lock with only one SSTORE operation
287     uint256 private _guardCounter;
288 
289     constructor() public {
290         // The counter starts at one to prevent changing it from zero to a non-zero
291         // value, which is a more expensive operation.
292         _guardCounter = 1;
293     }
294 
295     /**
296      * @dev Prevents a contract from calling itself, directly or indirectly.
297      * Calling a `nonReentrant` function from another `nonReentrant`
298      * function is not supported. It is possible to prevent this from happening
299      * by making the `nonReentrant` function external, and make it call a
300      * `private` function that does the actual work.
301      */
302     modifier nonReentrant() {
303         _guardCounter += 1;
304         uint256 localCounter = _guardCounter;
305         _;
306         require(localCounter == _guardCounter);
307     }
308 }
309 
310 
311 /// @title Main contract for WrappedCK. This contract converts Cryptokitties between the ERC721 standard and the
312 ///  ERC20 standard by locking cryptokitties into the contract and minting 1:1 backed ERC20 tokens, that
313 ///  can then be redeemed for cryptokitties when desired.
314 /// @notice When wrapping a cryptokitty, you get a generic WG0 token. Since the WG0 token is generic, it has no
315 ///  no information about what cryptokitty you submitted, so you will most likely not receive the same kitty
316 ///  back when redeeming the token unless you specify that kitty's ID. The token only entitles you to receive 
317 ///  *a* cryptokitty in return, not necessarily the *same* cryptokitty in return. A different user can submit
318 ///  their own WG0 tokens to the contract and withdraw the kitty that you originally deposited. WG0 tokens have
319 ///  no information about which kitty was originally deposited to mint WG0 - this is due to the very nature of 
320 ///  the ERC20 standard being fungible, and the ERC721 standard being nonfungible.
321 contract WrappedCKG0 is ERC20, ReentrancyGuard {
322 
323     // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.
324     using SafeMath for uint256;
325 
326     /* ****** */
327     /* EVENTS */
328     /* ****** */
329 
330     /// @dev This event is fired when a user deposits cryptokitties into the contract in exchange
331     ///  for an equal number of WG0 ERC20 tokens.
332     /// @param kittyId  The cryptokitty id of the kitty that was deposited into the contract.
333     event DepositKittyAndMintToken(
334         uint256 kittyId
335     );
336 
337     /// @dev This event is fired when a user deposits WG0 ERC20 tokens into the contract in exchange
338     ///  for an equal number of locked cryptokitties.
339     /// @param kittyId  The cryptokitty id of the kitty that was withdrawn from the contract.
340     event BurnTokenAndWithdrawKitty(
341         uint256 kittyId
342     );
343 
344     /* ******* */
345     /* STORAGE */
346     /* ******* */
347 
348     /// @dev An Array containing all of the cryptokitties that are locked in the contract, backing
349     ///  WG0 ERC20 tokens 1:1
350     /// @notice Some of the kitties in this array were indeed deposited to the contract, but they
351     ///  are no longer held by the contract. This is because withdrawSpecificKitty() allows a 
352     ///  user to withdraw a kitty "out of order". Since it would be prohibitively expensive to 
353     ///  shift the entire array once we've withdrawn a single element, we instead maintain this 
354     ///  mapping to determine whether an element is still contained in the contract or not. 
355     uint256[] private depositedKittiesArray;
356 
357     /// @dev A mapping keeping track of which kittyIDs are currently contained within the contract.
358     /// @notice We cannot rely on depositedKittiesArray as the source of truth as to which cats are
359     ///  deposited in the contract. This is because burnTokensAndWithdrawKitties() allows a user to 
360     ///  withdraw a kitty "out of order" of the order that they are stored in the array. Since it 
361     ///  would be prohibitively expensive to shift the entire array once we've withdrawn a single 
362     ///  element, we instead maintain this mapping to determine whether an element is still contained 
363     ///  in the contract or not. 
364     mapping (uint256 => bool) private kittyIsDepositedInContract;
365 
366     /* ********* */
367     /* CONSTANTS */
368     /* ********* */
369 
370     /// @dev The metadata details about the "Wrapped CryptoKitties" WG0 ERC20 token.
371     uint8 constant public decimals = 18;
372     string constant public name = "Wrapped Gen0 CK";
373     string constant public symbol = "WG0";
374 
375     /// @dev The address of official CryptoKitties contract that stores the metadata about each cat.
376     /// @notice The owner is not capable of changing the address of the CryptoKitties Core contract
377     ///  once the contract has been deployed.
378     address public kittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
379     KittyCore kittyCore;
380 
381     /* ********* */
382     /* FUNCTIONS */
383     /* ********* */
384 
385     /// @notice Allows a user to lock cryptokitties in the contract in exchange for an equal number
386     ///  of WG0 ERC20 tokens.
387     /// @param _kittyIds  The ids of the cryptokitties that will be locked into the contract.
388     /// @notice The user must first call approve() in the Cryptokitties Core contract on each kitty
389     ///  that thye wish to deposit before calling depositKittiesAndMintTokens(). There is no danger 
390     ///  of this contract overreaching its approval, since the CryptoKitties Core contract's approve() 
391     ///  function only approves this contract for a single Cryptokitty. Calling approve() allows this 
392     ///  contract to transfer the specified kitty in the depositKittiesAndMintTokens() function.
393     
394     function depositKittiesAndMintTokens(uint256[] calldata _kittyIds) external nonReentrant {
395         require(_kittyIds.length > 0, 'you must submit an array with at least one element');
396         for(uint i = 0; i < _kittyIds.length; i++){
397             uint256 kittyToDeposit = _kittyIds[i];
398             require(msg.sender == kittyCore.ownerOf(kittyToDeposit), 'you do not own this cat');
399             require(kittyCore.kittyIndexToApproved(kittyToDeposit) == address(this), 'you must approve() this contract to give it permission to withdraw this cat before you can deposit a cat');
400             require(kittyCore.getKitty(kittyToDeposit) == 1, 'this cat must be gen1');
401             kittyCore.transferFrom(msg.sender, address(this), kittyToDeposit);
402             _pushKitty(kittyToDeposit);
403             emit DepositKittyAndMintToken(kittyToDeposit);
404         }
405         _mint(msg.sender, (_kittyIds.length).mul(10**18));
406     }
407 
408     /// @notice Allows a user to burn WG0 ERC20 tokens in exchange for an equal number of locked 
409     ///  cryptokitties.
410     /// @param _kittyIds  The IDs of the kitties that the user wishes to withdraw. If the user submits 0 
411     ///  as the ID for any kitty, the contract uses the last kitty in the array for that kitty.
412     /// @param _destinationAddresses  The addresses that the withdrawn kitties will be sent to (this allows 
413     ///  anyone to "airdrop" kitties to addresses that they do not own in a single transaction).
414     function burnTokensAndWithdrawKitties(uint256[] calldata _kittyIds, address[] calldata _destinationAddresses) external nonReentrant {
415         require(_kittyIds.length == _destinationAddresses.length, 'you did not provide a destination address for each of the cats you wish to withdraw');
416         require(_kittyIds.length > 0, 'you must submit an array with at least one element');
417         uint256 numTokensToBurn = _kittyIds.length;
418         require(balanceOf(msg.sender) >= numTokensToBurn.mul(10**18), 'you do not own enough tokens to withdraw this many ERC721 cats');
419         _burn(msg.sender, numTokensToBurn.mul(10**18));
420         
421         for(uint i = 0; i < numTokensToBurn; i++){
422             uint256 kittyToWithdraw = _kittyIds[i];
423             if(kittyToWithdraw == 0){
424                 kittyToWithdraw = _popKitty();
425             } else {
426                 require(kittyIsDepositedInContract[kittyToWithdraw] == true, 'this kitty has already been withdrawn');
427                 require(address(this) == kittyCore.ownerOf(kittyToWithdraw), 'the contract does not own this cat');
428                 kittyIsDepositedInContract[kittyToWithdraw] = false;
429             }
430             kittyCore.transfer(_destinationAddresses[i], kittyToWithdraw);
431             emit BurnTokenAndWithdrawKitty(kittyToWithdraw);
432         }
433     }
434 
435     /// @notice Adds a locked cryptokitty to the end of the array
436     /// @param _kittyId  The id of the cryptokitty that will be locked into the contract.
437     function _pushKitty(uint256 _kittyId) internal {
438         depositedKittiesArray.push(_kittyId);
439         kittyIsDepositedInContract[_kittyId] = true;
440     }
441 
442     /// @notice Removes an unlocked cryptokitty from the end of the array
443     /// @notice The reason that this function must check if the kittyIsDepositedInContract
444     ///  is that the withdrawSpecificKitty() function allows a user to withdraw a kitty
445     ///  from the array out of order.
446     /// @return  The id of the cryptokitty that will be unlocked from the contract.
447     function _popKitty() internal returns(uint256){
448         require(depositedKittiesArray.length > 0, 'there are no cats in the array');
449         uint256 kittyId = depositedKittiesArray[depositedKittiesArray.length - 1];
450         depositedKittiesArray.length--;
451         while(kittyIsDepositedInContract[kittyId] == false){
452             kittyId = depositedKittiesArray[depositedKittiesArray.length - 1];
453             depositedKittiesArray.length--;
454         }
455         kittyIsDepositedInContract[kittyId] = false;
456         return kittyId;
457     }
458 
459     /// @notice Removes any kitties that exist in the array but are no longer held in the
460     ///  contract, which happens if the first few kitties have previously been withdrawn 
461     ///  out of order using the withdrawSpecificKitty() function.
462     /// @notice This function exists to prevent a griefing attack where a malicious attacker
463     ///  could call withdrawSpecificKitty() on a large number of kitties at the front of the
464     ///  array, causing the while-loop in _popKitty to always run out of gas.
465     /// @param _numSlotsToCheck  The number of slots to check in the array.
466     function batchRemoveWithdrawnKittiesFromStorage(uint256 _numSlotsToCheck) external {
467         require(_numSlotsToCheck <= depositedKittiesArray.length, 'you are trying to batch remove more slots than exist in the array');
468         uint256 arrayIndex = depositedKittiesArray.length;
469         for(uint i = 0; i < _numSlotsToCheck; i++){
470             arrayIndex = arrayIndex.sub(1);
471             uint256 kittyId = depositedKittiesArray[arrayIndex];
472             if(kittyIsDepositedInContract[kittyId] == false){
473                 depositedKittiesArray.length--;
474             } else {
475                 return;
476             }
477         }
478     }
479 
480     /// @notice The owner is not capable of changing the address of the CryptoKitties Core
481     ///  contract once the contract has been deployed.
482     constructor() public {
483         kittyCore = KittyCore(kittyCoreAddress);
484     }
485 
486     /// @dev We leave the fallback function payable in case the current State Rent proposals require
487     ///  us to send funds to this contract to keep it alive on mainnet.
488     /// @notice There is no function that allows the contract creator to withdraw any funds sent
489     ///  to this contract, so any funds sent directly to the fallback function that are not used for 
490     ///  State Rent are lost forever.
491     function() external payable {}
492 }
493 
494 /// @title Interface for interacting with the CryptoKitties Core contract created by Dapper Labs Inc.
495 contract KittyCore {
496     function ownerOf(uint256 _tokenId) public view returns (address owner);
497     function transferFrom(address _from, address _to, uint256 _tokenId) external;
498     function transfer(address _to, uint256 _tokenId) external;
499     function getKitty(uint256 _id) public view returns (uint256 _generation);
500     mapping (uint256 => address) public kittyIndexToApproved;
501 }