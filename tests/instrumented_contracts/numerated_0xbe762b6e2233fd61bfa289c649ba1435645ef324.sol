1 pragma solidity ^0.5.0;
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
26 
27 
28 
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
280 
281 
282 
283 /**
284  * @title ERC20Detailed token
285  * @dev The decimals are only for visualization purposes.
286  * All the operations are done using the smallest and indivisible token unit,
287  * just as on Ethereum all the operations are done in wei.
288  */
289 contract ERC20Detailed is IERC20 {
290     string private _name;
291     string private _symbol;
292     uint8 private _decimals;
293 
294     constructor (string memory name, string memory symbol, uint8 decimals) public {
295         _name = name;
296         _symbol = symbol;
297         _decimals = decimals;
298     }
299 
300     /**
301      * @return the name of the token.
302      */
303     function name() public view returns (string memory) {
304         return _name;
305     }
306 
307     /**
308      * @return the symbol of the token.
309      */
310     function symbol() public view returns (string memory) {
311         return _symbol;
312     }
313 
314     /**
315      * @return the number of decimals of the token.
316      */
317     function decimals() public view returns (uint8) {
318         return _decimals;
319     }
320 }
321 
322 
323 
324 
325 contract Multiownable {
326 
327     // VARIABLES
328 
329     uint256 public ownersGeneration;
330     uint256 public howManyOwnersDecide;
331     address[] public owners;
332     bytes32[] public allOperations;
333     address internal insideCallSender;
334     uint256 internal insideCallCount;
335 
336     // Reverse lookup tables for owners and allOperations
337     mapping(address => uint) public ownersIndices; // Starts from 1
338     mapping(bytes32 => uint) public allOperationsIndicies;
339 
340     // Owners voting mask per operations
341     mapping(bytes32 => uint256) public votesMaskByOperation;
342     mapping(bytes32 => uint256) public votesCountByOperation;
343 
344     // EVENTS
345     event OperationCreated(bytes32 operation, uint howMany, uint ownersCount, address proposer);
346     event OperationUpvoted(bytes32 operation, uint votes, uint howMany, uint ownersCount, address upvoter);
347     event OperationPerformed(bytes32 operation, uint howMany, uint ownersCount, address performer);
348     event OperationDownvoted(bytes32 operation, uint votes, uint ownersCount,  address downvoter);
349     event OperationCancelled(bytes32 operation, address lastCanceller);
350     
351     // ACCESSORS
352 
353     function isOwner(address wallet) public view returns(bool) {
354         return ownersIndices[wallet] > 0;
355     }
356 
357     function ownersCount() public view returns(uint) {
358         return owners.length;
359     }
360 
361     function allOperationsCount() public view returns(uint) {
362         return allOperations.length;
363     }
364 
365     // MODIFIERS
366 
367     /**
368     * @dev Allows to perform method by any of the owners
369     */
370     modifier onlyAnyOwner {
371         if (checkHowManyOwners(1)) {
372             bool update = (insideCallSender == address(0));
373             if (update) {
374                 insideCallSender = msg.sender;
375                 insideCallCount = 1;
376             }
377             _;
378             if (update) {
379                 insideCallSender = address(0);
380                 insideCallCount = 0;
381             }
382         }
383     }
384 
385     /**
386     * @dev Allows to perform method only after many owners call it with the same arguments
387     */
388     modifier onlyManyOwners {
389         if (checkHowManyOwners(howManyOwnersDecide)) {
390             bool update = (insideCallSender == address(0));
391             if (update) {
392                 insideCallSender = msg.sender;
393                 insideCallCount = howManyOwnersDecide;
394             }
395             _;
396             if (update) {
397                 insideCallSender = address(0);
398                 insideCallCount = 0;
399             }
400         }
401     }
402 
403     /**
404     * @dev Allows to perform method only after all owners call it with the same arguments
405     */
406     modifier onlyAllOwners {
407         if (checkHowManyOwners(owners.length)) {
408             bool update = (insideCallSender == address(0));
409             if (update) {
410                 insideCallSender = msg.sender;
411                 insideCallCount = owners.length;
412             }
413             _;
414             if (update) {
415                 insideCallSender = address(0);
416                 insideCallCount = 0;
417             }
418         }
419     }
420 
421     /**
422     * @dev Allows to perform method only after some owners call it with the same arguments
423     */
424     modifier onlySomeOwners(uint howMany) {
425         require(howMany > 0, "onlySomeOwners: howMany argument is zero");
426         require(howMany <= owners.length, "onlySomeOwners: howMany argument exceeds the number of owners");
427         
428         if (checkHowManyOwners(howMany)) {
429             bool update = (insideCallSender == address(0));
430             if (update) {
431                 insideCallSender = msg.sender;
432                 insideCallCount = howMany;
433             }
434             _;
435             if (update) {
436                 insideCallSender = address(0);
437                 insideCallCount = 0;
438             }
439         }
440     }
441 
442     // Will be initialized from inherited contract
443     // CONSTRUCTOR
444     constructor (address[] memory _owners, uint threshold) public {
445         require(_owners.length > 0, "Owners list is empty");
446         require(threshold > 0 && threshold <= _owners.length, "Incorrect threshold");
447 
448         for (uint n = 0; n < _owners.length; n++) {
449             owners.push(_owners[n]);
450             ownersIndices[_owners[n]] = n + 1;
451         }
452 
453         howManyOwnersDecide = threshold;
454     }
455 
456     // INTERNAL METHODS
457 
458     /**
459      * @dev onlyManyOwners modifier helper
460      */    
461     function checkHowManyOwners(uint howMany) internal returns(bool) {
462         if (insideCallSender == msg.sender) {
463             require(howMany <= insideCallCount, "checkHowManyOwners: nested owners modifier check require more owners");
464             return true;
465         }
466 
467         uint ownerIndex = ownersIndices[msg.sender] - 1;
468         require(ownerIndex < owners.length, "checkHowManyOwners: msg.sender is not an owner");
469         bytes32 operation = keccak256(abi.encodePacked(msg.data, ownersGeneration));
470 
471         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0, "checkHowManyOwners: owner already voted for the operation");
472         votesMaskByOperation[operation] |= (2 ** ownerIndex);
473         uint operationVotesCount = votesCountByOperation[operation] + 1;
474         votesCountByOperation[operation] = operationVotesCount;
475         if (operationVotesCount == 1) {
476             allOperationsIndicies[operation] = allOperations.length;
477             allOperations.push(operation);
478             emit OperationCreated(operation, howMany, owners.length, msg.sender);
479         }
480         emit OperationUpvoted(operation, operationVotesCount, howMany, owners.length, msg.sender);
481 
482         // If enough owners confirmed the same operation
483         if (votesCountByOperation[operation] == howMany) {
484             deleteOperation(operation);
485             emit OperationPerformed(operation, howMany, owners.length, msg.sender);
486             return true;
487         }
488 
489         return false;
490     }
491 
492     /**
493     * @dev Used to delete cancelled or performed operation
494     * @param operation defines which operation to delete
495     */
496     function deleteOperation(bytes32 operation) internal {
497         uint index = allOperationsIndicies[operation];
498         if (index < allOperations.length - 1) { // Not last
499             allOperations[index] = allOperations[allOperations.length - 1];
500             allOperationsIndicies[allOperations[index]] = index;
501         }
502         allOperations.length--;
503 
504         delete votesMaskByOperation[operation];
505         delete votesCountByOperation[operation];
506         delete allOperationsIndicies[operation];
507     }
508 
509     // PUBLIC METHODS
510 
511     /**
512     * @dev Allows owners to change their mind by cacnelling votesMaskByOperation operations
513     * @param operation defines which operation to delete
514     */
515     function cancelPending(bytes32 operation) public onlyAnyOwner {
516         uint ownerIndex = ownersIndices[msg.sender] - 1;
517         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) != 0, "cancelPending: operation not found for this user");
518         votesMaskByOperation[operation] &= ~(2 ** ownerIndex);
519         uint operationVotesCount = votesCountByOperation[operation] - 1;
520         votesCountByOperation[operation] = operationVotesCount;
521         emit OperationDownvoted(operation, operationVotesCount, owners.length, msg.sender);
522         if (operationVotesCount == 0) {
523             deleteOperation(operation);
524             emit OperationCancelled(operation, msg.sender);
525         }
526     }
527 
528 }
529 
530 contract vUSD is ERC20, ERC20Detailed, Multiownable {    
531     address public operator;
532     uint256 public availableForMinting = 0;
533 
534     event OperatorSet(address _address);
535     event OperatorDisabled();
536 
537     constructor (string memory name, string memory symbol, uint8 decimals, address[] memory _owners, uint8 threshold) public 
538         ERC20Detailed(name, symbol, decimals) 
539         Multiownable(_owners, threshold) {     
540     }
541 
542     modifier onlyOperator() {
543         require(operator != address(0) && msg.sender == operator, "Forbidden");
544         _;
545     }
546     
547     function setOperator(address _address) public onlyManyOwners {            
548         operator = _address;
549         emit OperatorSet(_address);
550     }
551 
552     function disableOperator() public onlyOperator {
553         operator = address(0);
554         emit OperatorDisabled();
555     }
556 
557     function allowMint(uint256 amount) public onlyManyOwners { 
558         require(amount > 0, "Amount below zero");
559         availableForMinting = availableForMinting.add(amount);
560     }
561 
562     function burn (uint256 amount) public {
563         _burn(msg.sender, amount);
564     }
565 
566     function burnFrom(address _address, uint256 amount) public {
567         _burnFrom(_address, amount);
568     }
569 
570     function mint(address _address, uint256 amount) public onlyOperator returns (bool) {
571         require(availableForMinting >= amount, "Insufficient available for minting");    
572         _mint(_address, amount);
573         availableForMinting = availableForMinting.sub(amount);
574         return true;
575     }        
576 }