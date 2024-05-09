1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor () internal {
86         _owner = msg.sender;
87         emit OwnershipTransferred(address(0), _owner);
88     }
89 
90     /**
91      * @return the address of the owner.
92      */
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(isOwner());
102         _;
103     }
104 
105     /**
106      * @return true if `msg.sender` is the owner of the contract.
107      */
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     /**
113      * @dev Allows the current owner to relinquish control of the contract.
114      * @notice Renouncing to ownership will leave the contract without an owner.
115      * It will not be possible to call the functions with the `onlyOwner`
116      * modifier anymore.
117      */
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123     /**
124      * @dev Allows the current owner to transfer control of the contract to a newOwner.
125      * @param newOwner The address to transfer ownership to.
126      */
127     function transferOwnership(address newOwner) public onlyOwner {
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers control of the contract to a newOwner.
133      * @param newOwner The address to transfer ownership to.
134      */
135     function _transferOwnership(address newOwner) internal {
136         require(newOwner != address(0));
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140 }
141 
142 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 interface IERC20 {
149     function transfer(address to, uint256 value) external returns (bool);
150 
151     function approve(address spender, uint256 value) external returns (bool);
152 
153     function transferFrom(address from, address to, uint256 value) external returns (bool);
154 
155     function totalSupply() external view returns (uint256);
156 
157     function balanceOf(address who) external view returns (uint256);
158 
159     function allowance(address owner, address spender) external view returns (uint256);
160 
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
173  * Originally based on code by FirstBlood:
174  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  *
176  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
177  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
178  * compliant implementations may not do it.
179  */
180 contract ERC20 is IERC20 {
181     using SafeMath for uint256;
182 
183     mapping (address => uint256) private _balances;
184 
185     mapping (address => mapping (address => uint256)) private _allowed;
186 
187     uint256 private _totalSupply;
188 
189     /**
190     * @dev Total number of tokens in existence
191     */
192     function totalSupply() public view returns (uint256) {
193         return _totalSupply;
194     }
195 
196     /**
197     * @dev Gets the balance of the specified address.
198     * @param owner The address to query the balance of.
199     * @return An uint256 representing the amount owned by the passed address.
200     */
201     function balanceOf(address owner) public view returns (uint256) {
202         return _balances[owner];
203     }
204 
205     /**
206      * @dev Function to check the amount of tokens that an owner allowed to a spender.
207      * @param owner address The address which owns the funds.
208      * @param spender address The address which will spend the funds.
209      * @return A uint256 specifying the amount of tokens still available for the spender.
210      */
211     function allowance(address owner, address spender) public view returns (uint256) {
212         return _allowed[owner][spender];
213     }
214 
215     /**
216     * @dev Transfer token for a specified address
217     * @param to The address to transfer to.
218     * @param value The amount to be transferred.
219     */
220     function transfer(address to, uint256 value) public returns (bool) {
221         _transfer(msg.sender, to, value);
222         return true;
223     }
224 
225     /**
226      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227      * Beware that changing an allowance with this method brings the risk that someone may use both the old
228      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      * @param spender The address which will spend the funds.
232      * @param value The amount of tokens to be spent.
233      */
234     function approve(address spender, uint256 value) public returns (bool) {
235         require(spender != address(0));
236 
237         _allowed[msg.sender][spender] = value;
238         emit Approval(msg.sender, spender, value);
239         return true;
240     }
241 
242     /**
243      * @dev Transfer tokens from one address to another.
244      * Note that while this function emits an Approval event, this is not required as per the specification,
245      * and other compliant implementations may not emit the event.
246      * @param from address The address which you want to send tokens from
247      * @param to address The address which you want to transfer to
248      * @param value uint256 the amount of tokens to be transferred
249      */
250     function transferFrom(address from, address to, uint256 value) public returns (bool) {
251         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
252         _transfer(from, to, value);
253         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
254         return true;
255     }
256 
257     /**
258      * @dev Increase the amount of tokens that an owner allowed to a spender.
259      * approve should be called when allowed_[_spender] == 0. To increment
260      * allowed value is better to use this function to avoid 2 calls (and wait until
261      * the first transaction is mined)
262      * From MonolithDAO Token.sol
263      * Emits an Approval event.
264      * @param spender The address which will spend the funds.
265      * @param addedValue The amount of tokens to increase the allowance by.
266      */
267     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
268         require(spender != address(0));
269 
270         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
271         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
272         return true;
273     }
274 
275     /**
276      * @dev Decrease the amount of tokens that an owner allowed to a spender.
277      * approve should be called when allowed_[_spender] == 0. To decrement
278      * allowed value is better to use this function to avoid 2 calls (and wait until
279      * the first transaction is mined)
280      * From MonolithDAO Token.sol
281      * Emits an Approval event.
282      * @param spender The address which will spend the funds.
283      * @param subtractedValue The amount of tokens to decrease the allowance by.
284      */
285     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
286         require(spender != address(0));
287 
288         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
289         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
290         return true;
291     }
292 
293     /**
294     * @dev Transfer token for a specified addresses
295     * @param from The address to transfer from.
296     * @param to The address to transfer to.
297     * @param value The amount to be transferred.
298     */
299     function _transfer(address from, address to, uint256 value) internal {
300         require(to != address(0));
301 
302         _balances[from] = _balances[from].sub(value);
303         _balances[to] = _balances[to].add(value);
304         emit Transfer(from, to, value);
305     }
306 
307     /**
308      * @dev Internal function that mints an amount of the token and assigns it to
309      * an account. This encapsulates the modification of balances such that the
310      * proper events are emitted.
311      * @param account The account that will receive the created tokens.
312      * @param value The amount that will be created.
313      */
314     function _mint(address account, uint256 value) internal {
315         require(account != address(0));
316 
317         _totalSupply = _totalSupply.add(value);
318         _balances[account] = _balances[account].add(value);
319         emit Transfer(address(0), account, value);
320     }
321 
322     /**
323      * @dev Internal function that burns an amount of the token of a given
324      * account.
325      * @param account The account whose tokens will be burnt.
326      * @param value The amount that will be burnt.
327      */
328     function _burn(address account, uint256 value) internal {
329         require(account != address(0));
330 
331         _totalSupply = _totalSupply.sub(value);
332         _balances[account] = _balances[account].sub(value);
333         emit Transfer(account, address(0), value);
334     }
335 
336     /**
337      * @dev Internal function that burns an amount of the token of a given
338      * account, deducting from the sender's allowance for said account. Uses the
339      * internal burn function.
340      * Emits an Approval event (reflecting the reduced allowance).
341      * @param account The account whose tokens will be burnt.
342      * @param value The amount that will be burnt.
343      */
344     function _burnFrom(address account, uint256 value) internal {
345         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
346         _burn(account, value);
347         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
348     }
349 }
350 
351 // File: contracts/assettoken/library/AssetTokenL.sol
352 
353 /*
354     Copyright 2018, CONDA
355 
356     This program is free software: you can redistribute it and/or modify
357     it under the terms of the GNU General Public License as published by
358     the Free Software Foundation, either version 3 of the License, or
359     (at your option) any later version.
360 
361     This program is distributed in the hope that it will be useful,
362     but WITHOUT ANY WARRANTY; without even the implied warranty of
363     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
364     GNU General Public License for more details.
365 
366     You should have received a copy of the GNU General Public License
367     along with this program.  If not, see <http://www.gnu.org/licenses/>.
368 */
369 
370 
371 
372 /** @title AssetTokenL library. */
373 library AssetTokenL {
374     using SafeMath for uint256;
375 
376 ///////////////////
377 // Struct Parameters (passed as parameter to library)
378 ///////////////////
379 
380     struct Supply {
381         // `balances` is the map that tracks the balance of each address, in this
382         // contract when the balance changes. TransfersAndMints-index when the change
383         // occurred is also included
384         mapping (address => Checkpoint[]) balances;
385 
386         // Tracks the history of the `totalSupply` of the token
387         Checkpoint[] totalSupplyHistory;
388 
389         // `allowed` tracks any extra transfer rights as in all ERC20 tokens
390         mapping (address => mapping (address => uint256)) allowed;
391 
392         // Minting cap max amount of tokens
393         uint256 cap;
394 
395         // When successfully funded
396         uint256 goal;
397 
398         //crowdsale start
399         uint256 startTime;
400 
401         //crowdsale end
402         uint256 endTime;
403 
404         //crowdsale dividends
405         Dividend[] dividends;
406 
407         //counter per address how much was claimed in continuous way
408         //note: counter also increases when recycled and tried to claim in continous way
409         mapping (address => uint256) dividendsClaimed;
410 
411         uint256 tokenActionIndex; //only modify within library
412     }
413 
414     struct Availability {
415         // Flag that determines if the token is yet alive.
416         // Meta data cannot be changed anymore (except capitalControl)
417         bool tokenAlive;
418 
419         // Flag that determines if the token is transferable or not.
420         bool transfersEnabled;
421 
422         // Flag that minting is finished
423         bool mintingPhaseFinished;
424 
425         // Flag that minting is paused
426         bool mintingPaused;
427     }
428 
429     struct Roles {
430         // role that can pause/resume
431         address pauseControl;
432 
433         // role that can rescue accidentally sent tokens
434         address tokenRescueControl;
435 
436         // role that can mint during crowdsale (usually controller)
437         address mintControl;
438     }
439 
440 ///////////////////
441 // Structs (saved to blockchain)
442 ///////////////////
443 
444     /// @dev `Dividend` is the structure that saves the status of a dividend distribution
445     struct Dividend {
446         uint256 currentTokenActionIndex;
447         uint256 timestamp;
448         DividendType dividendType;
449         address dividendToken;
450         uint256 amount;
451         uint256 claimedAmount;
452         uint256 totalSupply;
453         bool recycled;
454         mapping (address => bool) claimed;
455     }
456 
457     /// @dev Dividends can be of those types.
458     enum DividendType { Ether, ERC20 }
459 
460     /** @dev Checkpoint` is the structure that attaches a history index to a given value
461       * @notice That uint128 is used instead of uint/uint256. That's to save space. Should be big enough (feedback from audit)
462       */
463     struct Checkpoint {
464 
465         // `currentTokenActionIndex` is the index when the value was generated. It's uint128 to save storage space
466         uint128 currentTokenActionIndex;
467 
468         // `value` is the amount of tokens at a specific index. It's uint128 to save storage space
469         uint128 value;
470     }
471 
472 ///////////////////
473 // Functions
474 ///////////////////
475 
476     /// @dev This is the actual transfer function in the token contract, it can
477     ///  only be called by other functions in this contract. Check for availability must be done before.
478     /// @param _from The address holding the tokens being transferred
479     /// @param _to The address of the recipient
480     /// @param _amount The amount of tokens to be transferred
481     /// @return True if the transfer was successful
482     function doTransfer(Supply storage _self, Availability storage /*_availability*/, address _from, address _to, uint256 _amount) public {
483         // Do not allow transfer to 0x0 or the token contract itself
484         require(_to != address(0), "addr0");
485         require(_to != address(this), "target self");
486 
487         // If the amount being transfered is more than the balance of the
488         //  account the transfer throws
489         uint256 previousBalanceFrom = balanceOfNow(_self, _from);
490         require(previousBalanceFrom >= _amount, "not enough");
491 
492         // First update the balance array with the new value for the address
493         //  sending the tokens
494         updateValueAtNow(_self, _self.balances[_from], previousBalanceFrom.sub(_amount));
495 
496         // Then update the balance array with the new value for the address
497         //  receiving the tokens
498         uint256 previousBalanceTo = balanceOfNow(_self, _to);
499         
500         updateValueAtNow(_self, _self.balances[_to], previousBalanceTo.add(_amount));
501 
502         //info: don't move this line inside updateValueAtNow (because transfer is 2 actions)
503         increaseTokenActionIndex(_self);
504 
505         // An event to make the transfer easy to find on the blockchain
506         emit Transfer(_from, _to, _amount);
507     }
508 
509     function increaseTokenActionIndex(Supply storage _self) private {
510         _self.tokenActionIndex = _self.tokenActionIndex.add(1);
511 
512         emit TokenActionIndexIncreased(_self.tokenActionIndex, block.number);
513     }
514 
515     /// @notice `msg.sender` approves `_spender` to spend `_amount` of his tokens
516     /// @param _spender The address of the account able to transfer the tokens
517     /// @param _amount The amount of tokens to be approved for transfer
518     /// @return True if the approval was successful
519     function approve(Supply storage _self, address _spender, uint256 _amount) public returns (bool success) {
520         // To change the approve amount you first have to reduce the addresses`
521         //  allowance to zero by calling `approve(_spender,0)` if it is not
522         //  already 0 to mitigate the race condition described here:
523         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
524         require((_amount == 0) || (_self.allowed[msg.sender][_spender] == 0), "amount");
525 
526         _self.allowed[msg.sender][_spender] = _amount;
527         emit Approval(msg.sender, _spender, _amount);
528         return true;
529     }
530 
531     /// @notice Increase the amount of tokens that an owner allowed to a spender.
532     /// @dev approve should be called when allowed[_spender] == 0. To increment
533     ///  allowed value is better to use this function to avoid 2 calls (and wait until
534     ///  the first transaction is mined)
535     ///  From MonolithDAO Token.sol
536     /// @param _spender The address which will spend the funds.
537     /// @param _addedValue The amount of tokens to increase the allowance by.
538     /// @return True if the approval was successful
539     function increaseApproval(Supply storage _self, address _spender, uint256 _addedValue) public returns (bool) {
540         _self.allowed[msg.sender][_spender] = _self.allowed[msg.sender][_spender].add(_addedValue);
541         emit Approval(msg.sender, _spender, _self.allowed[msg.sender][_spender]);
542         return true;
543     }
544 
545     /// @notice Decrease the amount of tokens that an owner allowed to a spender.
546     /// @dev approve should be called when allowed[_spender] == 0. To decrement
547     ///  allowed value is better to use this function to avoid 2 calls (and wait until
548     ///  the first transaction is mined)
549     ///  From MonolithDAO Token.sol
550     /// @param _spender The address which will spend the funds.
551     /// @param _subtractedValue The amount of tokens to decrease the allowance by.
552     /// @return True if the approval was successful
553     function decreaseApproval(Supply storage _self, address _spender, uint256 _subtractedValue) public returns (bool) {
554         uint256 oldValue = _self.allowed[msg.sender][_spender];
555         if (_subtractedValue > oldValue) {
556             _self.allowed[msg.sender][_spender] = 0;
557         } else {
558             _self.allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
559         }
560         emit Approval(msg.sender, _spender, _self.allowed[msg.sender][_spender]);
561         return true;
562     }
563 
564     /// @notice Send `_amount` tokens to `_to` from `_from` if it is approved by `_from`
565     /// @param _from The address holding the tokens being transferred
566     /// @param _to The address of the recipient
567     /// @param _amount The amount of tokens to be transferred
568     /// @return True if the transfer was successful
569     function transferFrom(Supply storage _supply, Availability storage _availability, address _from, address _to, uint256 _amount) 
570     public 
571     returns (bool success) 
572     {
573         // The standard ERC 20 transferFrom functionality
574         require(_supply.allowed[_from][msg.sender] >= _amount, "allowance");
575         _supply.allowed[_from][msg.sender] = _supply.allowed[_from][msg.sender].sub(_amount);
576 
577         doTransfer(_supply, _availability, _from, _to, _amount);
578         return true;
579     }
580 
581     /// @notice Send `_amount` tokens to `_to` from `_from` WITHOUT approval. UseCase: notar transfers from lost wallet
582     /// @param _from The address holding the tokens being transferred
583     /// @param _to The address of the recipient
584     /// @param _amount The amount of tokens to be transferred
585     /// @param _fullAmountRequired Full amount required (causes revert if not).
586     /// @return True if the transfer was successful
587     function enforcedTransferFrom(
588         Supply storage _self, 
589         Availability storage _availability, 
590         address _from, 
591         address _to, 
592         uint256 _amount, 
593         bool _fullAmountRequired) 
594     public 
595     returns (bool success) 
596     {
597         if(_fullAmountRequired && _amount != balanceOfNow(_self, _from))
598         {
599             revert("Only full amount in case of lost wallet is allowed");
600         }
601 
602         doTransfer(_self, _availability, _from, _to, _amount);
603 
604         emit SelfApprovedTransfer(msg.sender, _from, _to, _amount);
605 
606         return true;
607     }
608 
609 ////////////////
610 // Miniting 
611 ////////////////
612 
613     /// @notice Function to mint tokens
614     /// @param _to The address that will receive the minted tokens.
615     /// @param _amount The amount of tokens to mint.
616     /// @return A boolean that indicates if the operation was successful.
617     function mint(Supply storage _self, address _to, uint256 _amount) public returns (bool) {
618         uint256 curTotalSupply = totalSupplyNow(_self);
619         uint256 previousBalanceTo = balanceOfNow(_self, _to);
620 
621         // Check cap
622         require(curTotalSupply.add(_amount) <= _self.cap, "cap"); //leave inside library to never go over cap
623 
624         // Check timeframe
625         require(_self.startTime <= now, "too soon");
626         require(_self.endTime >= now, "too late");
627 
628         updateValueAtNow(_self, _self.totalSupplyHistory, curTotalSupply.add(_amount));
629         updateValueAtNow(_self, _self.balances[_to], previousBalanceTo.add(_amount));
630 
631         //info: don't move this line inside updateValueAtNow (because transfer is 2 actions)
632         increaseTokenActionIndex(_self);
633 
634         emit MintDetailed(msg.sender, _to, _amount);
635         emit Transfer(address(0), _to, _amount);
636 
637         return true;
638     }
639 
640 ////////////////
641 // Query balance and totalSupply in History
642 ////////////////
643 
644     /// @dev Queries the balance of `_owner` at `_specificTransfersAndMintsIndex`
645     /// @param _owner The address from which the balance will be retrieved
646     /// @param _specificTransfersAndMintsIndex The balance at index
647     /// @return The balance at `_specificTransfersAndMintsIndex`
648     function balanceOfAt(Supply storage _self, address _owner, uint256 _specificTransfersAndMintsIndex) public view returns (uint256) {
649         return getValueAt(_self.balances[_owner], _specificTransfersAndMintsIndex);
650     }
651 
652     function balanceOfNow(Supply storage _self, address _owner) public view returns (uint256) {
653         return getValueAt(_self.balances[_owner], _self.tokenActionIndex);
654     }
655 
656     /// @dev Total amount of tokens at `_specificTransfersAndMintsIndex`.
657     /// @param _specificTransfersAndMintsIndex The totalSupply at index
658     /// @return The total amount of tokens at `_specificTransfersAndMintsIndex`
659     function totalSupplyAt(Supply storage _self, uint256 _specificTransfersAndMintsIndex) public view returns(uint256) {
660         return getValueAt(_self.totalSupplyHistory, _specificTransfersAndMintsIndex);
661     }
662 
663     function totalSupplyNow(Supply storage _self) public view returns(uint256) {
664         return getValueAt(_self.totalSupplyHistory, _self.tokenActionIndex);
665     }
666 
667 ////////////////
668 // Internal helper functions to query and set a value in a snapshot array
669 ////////////////
670 
671     /// @dev `getValueAt` retrieves the number of tokens at a given index
672     /// @param checkpoints The history of values being queried
673     /// @param _specificTransfersAndMintsIndex The index to retrieve the history checkpoint value at
674     /// @return The number of tokens being queried
675     function getValueAt(Checkpoint[] storage checkpoints, uint256 _specificTransfersAndMintsIndex) private view returns (uint256) { 
676         
677         //  requested before a check point was ever created for this token
678         if (checkpoints.length == 0 || checkpoints[0].currentTokenActionIndex > _specificTransfersAndMintsIndex) {
679             return 0;
680         }
681 
682         // Shortcut for the actual value
683         if (_specificTransfersAndMintsIndex >= checkpoints[checkpoints.length-1].currentTokenActionIndex) {
684             return checkpoints[checkpoints.length-1].value;
685         }
686 
687         // Binary search of the value in the array
688         uint256 min = 0;
689         uint256 max = checkpoints.length-1;
690         while (max > min) {
691             uint256 mid = (max + min + 1)/2;
692             if (checkpoints[mid].currentTokenActionIndex<=_specificTransfersAndMintsIndex) {
693                 min = mid;
694             } else {
695                 max = mid-1;
696             }
697         }
698         return checkpoints[min].value;
699     }
700 
701     /// @dev `updateValueAtNow` used to update the `balances` map and the `totalSupplyHistory`
702     /// @param checkpoints The history of data being updated
703     /// @param _value The new number of tokens
704     function updateValueAtNow(Supply storage _self, Checkpoint[] storage checkpoints, uint256 _value) private {
705         require(_value == uint128(_value), "invalid cast1");
706         require(_self.tokenActionIndex == uint128(_self.tokenActionIndex), "invalid cast2");
707 
708         checkpoints.push(Checkpoint(
709             uint128(_self.tokenActionIndex),
710             uint128(_value)
711         ));
712     }
713 
714     /// @dev Function to stop minting new tokens.
715     /// @return True if the operation was successful.
716     function finishMinting(Availability storage _self) public returns (bool) {
717         if(_self.mintingPhaseFinished) {
718             return false;
719         }
720 
721         _self.mintingPhaseFinished = true;
722         emit MintFinished(msg.sender);
723         return true;
724     }
725 
726     /// @notice Reopening crowdsale means minting is again possible. UseCase: notary approves and does that.
727     /// @return True if the operation was successful.
728     function reopenCrowdsale(Availability storage _self) public returns (bool) {
729         if(_self.mintingPhaseFinished == false) {
730             return false;
731         }
732 
733         _self.mintingPhaseFinished = false;
734         emit Reopened(msg.sender);
735         return true;
736     }
737 
738     /// @notice Set roles/operators.
739     /// @param _pauseControl pause control.
740     /// @param _tokenRescueControl token rescue control (accidentally assigned tokens).
741     function setRoles(Roles storage _self, address _pauseControl, address _tokenRescueControl) public {
742         require(_pauseControl != address(0), "addr0");
743         require(_tokenRescueControl != address(0), "addr0");
744         
745         _self.pauseControl = _pauseControl;
746         _self.tokenRescueControl = _tokenRescueControl;
747 
748         emit RolesChanged(msg.sender, _pauseControl, _tokenRescueControl);
749     }
750 
751     /// @notice Set mint control.
752     function setMintControl(Roles storage _self, address _mintControl) public {
753         require(_mintControl != address(0), "addr0");
754 
755         _self.mintControl = _mintControl;
756 
757         emit MintControlChanged(msg.sender, _mintControl);
758     }
759 
760     /// @notice Set token alive which can be seen as not in draft state anymore.
761     function setTokenAlive(Availability storage _self) public {
762         _self.tokenAlive = true;
763     }
764 
765 ////////////////
766 // Pausing token for unforeseen reasons
767 ////////////////
768 
769     /// @notice pause transfer.
770     /// @param _transfersEnabled True if transfers are allowed.
771     function pauseTransfer(Availability storage _self, bool _transfersEnabled) public
772     {
773         _self.transfersEnabled = _transfersEnabled;
774 
775         if(_transfersEnabled) {
776             emit TransferResumed(msg.sender);
777         } else {
778             emit TransferPaused(msg.sender);
779         }
780     }
781 
782     /// @notice calling this can enable/disable capital increase/decrease flag
783     /// @param _mintingEnabled True if minting is allowed
784     function pauseCapitalIncreaseOrDecrease(Availability storage _self, bool _mintingEnabled) public
785     {
786         _self.mintingPaused = (_mintingEnabled == false);
787 
788         if(_mintingEnabled) {
789             emit MintingResumed(msg.sender);
790         } else {
791             emit MintingPaused(msg.sender);
792         }
793     }
794 
795     /// @notice Receives ether to be distriubted to all token owners
796     function depositDividend(Supply storage _self, uint256 msgValue)
797     public 
798     {
799         require(msgValue > 0, "amount0");
800 
801         // gets the current number of total token distributed
802         uint256 currentSupply = totalSupplyNow(_self);
803 
804         // a deposit without investment would end up in unclaimable deposit for token holders
805         require(currentSupply > 0, "0investors");
806 
807         // creates a new index for the dividends
808         uint256 dividendIndex = _self.dividends.length;
809 
810         // Stores the current meta data for the dividend payout
811         _self.dividends.push(
812             Dividend(
813                 _self.tokenActionIndex, // current index used for claiming
814                 block.timestamp, // Timestamp of the distribution
815                 DividendType.Ether, // Type of dividends
816                 address(0),
817                 msgValue, // Total amount that has been distributed
818                 0, // amount that has been claimed
819                 currentSupply, // Total supply now
820                 false // Already recylced
821             )
822         );
823         emit DividendDeposited(msg.sender, _self.tokenActionIndex, msgValue, currentSupply, dividendIndex);
824     }
825 
826     /// @notice Receives ERC20 to be distriubted to all token owners
827     function depositERC20Dividend(Supply storage _self, address _dividendToken, uint256 _amount, address baseCurrency)
828     public
829     {
830         require(_amount > 0, "amount0");
831         require(_dividendToken == baseCurrency, "not baseCurrency");
832 
833         // gets the current number of total token distributed
834         uint256 currentSupply = totalSupplyNow(_self);
835 
836         // a deposit without investment would end up in unclaimable deposit for token holders
837         require(currentSupply > 0, "0investors");
838 
839         // creates a new index for the dividends
840         uint256 dividendIndex = _self.dividends.length;
841 
842         // Stores the current meta data for the dividend payout
843         _self.dividends.push(
844             Dividend(
845                 _self.tokenActionIndex, // index that counts up on transfers and mints
846                 block.timestamp, // Timestamp of the distribution
847                 DividendType.ERC20, 
848                 _dividendToken, 
849                 _amount, // Total amount that has been distributed
850                 0, // amount that has been claimed
851                 currentSupply, // Total supply now
852                 false // Already recylced
853             )
854         );
855 
856         // it shouldn't return anything but according to ERC20 standard it could if badly implemented
857         // IMPORTANT: potentially a call with reentrance -> do at the end
858         require(ERC20(_dividendToken).transferFrom(msg.sender, address(this), _amount), "transferFrom");
859 
860         emit DividendDeposited(msg.sender, _self.tokenActionIndex, _amount, currentSupply, dividendIndex);
861     }
862 
863     /// @notice Function to claim dividends for msg.sender
864     /// @dev dividendsClaimed should not be handled here.
865     function claimDividend(Supply storage _self, uint256 _dividendIndex) public {
866         // Loads the details for the specific Dividend payment
867         Dividend storage dividend = _self.dividends[_dividendIndex];
868 
869         // Devidends should not have been claimed already
870         require(dividend.claimed[msg.sender] == false, "claimed");
871 
872          // Devidends should not have been recycled already
873         require(dividend.recycled == false, "recycled");
874 
875         // get the token balance at the time of the dividend distribution
876         uint256 balance = balanceOfAt(_self, msg.sender, dividend.currentTokenActionIndex.sub(1));
877 
878         // calculates the amount of dividends that can be claimed
879         uint256 claim = balance.mul(dividend.amount).div(dividend.totalSupply);
880 
881         // flag that dividends have been claimed
882         dividend.claimed[msg.sender] = true;
883         dividend.claimedAmount = SafeMath.add(dividend.claimedAmount, claim);
884 
885         claimThis(dividend.dividendType, _dividendIndex, msg.sender, claim, dividend.dividendToken);
886     }
887 
888     /// @notice Claim all dividends.
889     /// @dev dividendsClaimed counter should only increase when claimed in hole-free way.
890     function claimDividendAll(Supply storage _self) public {
891         claimLoopInternal(_self, _self.dividendsClaimed[msg.sender], (_self.dividends.length-1));
892     }
893 
894     /// @notice Claim dividends in batches. In case claimDividendAll runs out of gas.
895     /// @dev dividendsClaimed counter should only increase when claimed in hole-free way.
896     /// @param _startIndex start index (inclusive number).
897     /// @param _endIndex end index (inclusive number).
898     function claimInBatches(Supply storage _self, uint256 _startIndex, uint256 _endIndex) public {
899         claimLoopInternal(_self, _startIndex, _endIndex);
900     }
901 
902     /// @notice Claim loop of batch claim and claim all.
903     /// @dev dividendsClaimed counter should only increase when claimed in hole-free way.
904     /// @param _startIndex start index (inclusive number).
905     /// @param _endIndex end index (inclusive number).
906     function claimLoopInternal(Supply storage _self, uint256 _startIndex, uint256 _endIndex) private {
907         require(_startIndex <= _endIndex, "start after end");
908 
909         //early exit if already claimed
910         require(_self.dividendsClaimed[msg.sender] < _self.dividends.length, "all claimed");
911 
912         uint256 dividendsClaimedTemp = _self.dividendsClaimed[msg.sender];
913 
914         // Cycle through all dividend distributions and make the payout
915         for (uint256 i = _startIndex; i <= _endIndex; i++) {
916             if (_self.dividends[i].recycled == true) {
917                 //recycled and tried to claim in continuous way internally counts as claimed
918                 dividendsClaimedTemp = SafeMath.add(i, 1);
919             }
920             else if (_self.dividends[i].claimed[msg.sender] == false) {
921                 dividendsClaimedTemp = SafeMath.add(i, 1);
922                 claimDividend(_self, i);
923             }
924         }
925 
926         // This is done after the loop to reduce writes.
927         // Remembers what has been claimed after hole-free claiming procedure.
928         // IMPORTANT: do only if batch claim docks on previous claim to avoid unexpected claim all behaviour.
929         if(_startIndex <= _self.dividendsClaimed[msg.sender]) {
930             _self.dividendsClaimed[msg.sender] = dividendsClaimedTemp;
931         }
932     }
933 
934     /// @notice Dividends which have not been claimed can be claimed by owner after timelock (to avoid loss)
935     /// @param _dividendIndex index of dividend to recycle.
936     /// @param _recycleLockedTimespan timespan required until possible.
937     /// @param _currentSupply current supply.
938     function recycleDividend(Supply storage _self, uint256 _dividendIndex, uint256 _recycleLockedTimespan, uint256 _currentSupply) public {
939         // Get the dividend distribution
940         Dividend storage dividend = _self.dividends[_dividendIndex];
941 
942         // should not have been recycled already
943         require(dividend.recycled == false, "recycled");
944 
945         // The recycle time has to be over
946         require(dividend.timestamp < SafeMath.sub(block.timestamp, _recycleLockedTimespan), "timeUp");
947 
948         // Devidends should not have been claimed already
949         require(dividend.claimed[msg.sender] == false, "claimed");
950 
951         //
952         //refund
953         //
954 
955         // The amount, which has not been claimed is distributed to token owner
956         _self.dividends[_dividendIndex].recycled = true;
957 
958         // calculates the amount of dividends that can be claimed
959         uint256 claim = SafeMath.sub(dividend.amount, dividend.claimedAmount);
960 
961         // flag that dividends have been claimed
962         dividend.claimed[msg.sender] = true;
963         dividend.claimedAmount = SafeMath.add(dividend.claimedAmount, claim);
964 
965         claimThis(dividend.dividendType, _dividendIndex, msg.sender, claim, dividend.dividendToken);
966 
967         emit DividendRecycled(msg.sender, _self.tokenActionIndex, claim, _currentSupply, _dividendIndex);
968     }
969 
970     /// @dev the core claim function of single dividend.
971     function claimThis(DividendType _dividendType, uint256 _dividendIndex, address payable _beneficiary, uint256 _claim, address _dividendToken) 
972     private 
973     {
974         // transfer the dividends to the token holder
975         if (_claim > 0) {
976             if (_dividendType == DividendType.Ether) { 
977                 _beneficiary.transfer(_claim);
978             } 
979             else if (_dividendType == DividendType.ERC20) { 
980                 require(ERC20(_dividendToken).transfer(_beneficiary, _claim), "transfer");
981             }
982             else {
983                 revert("unknown type");
984             }
985 
986             emit DividendClaimed(_beneficiary, _dividendIndex, _claim);
987         }
988     }
989 
990     /// @notice If this contract gets a balance in some other ERC20 contract - or even iself - then we can rescue it.
991     /// @param _foreignTokenAddress token where contract has balance.
992     /// @param _to the beneficiary.
993     function rescueToken(Availability storage _self, address _foreignTokenAddress, address _to) public
994     {
995         require(_self.mintingPhaseFinished, "unfinished");
996         ERC20(_foreignTokenAddress).transfer(_to, ERC20(_foreignTokenAddress).balanceOf(address(this)));
997     }
998 
999 ///////////////////
1000 // Events (must be redundant in calling contract to work!)
1001 ///////////////////
1002 
1003     event Transfer(address indexed from, address indexed to, uint256 value);
1004     event SelfApprovedTransfer(address indexed initiator, address indexed from, address indexed to, uint256 value);
1005     event MintDetailed(address indexed initiator, address indexed to, uint256 amount);
1006     event MintFinished(address indexed initiator);
1007     event Approval(address indexed owner, address indexed spender, uint256 value);
1008     event TransferPaused(address indexed initiator);
1009     event TransferResumed(address indexed initiator);
1010     event MintingPaused(address indexed initiator);
1011     event MintingResumed(address indexed initiator);
1012     event Reopened(address indexed initiator);
1013     event DividendDeposited(address indexed depositor, uint256 transferAndMintIndex, uint256 amount, uint256 totalSupply, uint256 dividendIndex);
1014     event DividendClaimed(address indexed claimer, uint256 dividendIndex, uint256 claim);
1015     event DividendRecycled(address indexed recycler, uint256 transferAndMintIndex, uint256 amount, uint256 totalSupply, uint256 dividendIndex);
1016     event RolesChanged(address indexed initiator, address pauseControl, address tokenRescueControl);
1017     event MintControlChanged(address indexed initiator, address mintControl);
1018     event TokenActionIndexIncreased(uint256 tokenActionIndex, uint256 blocknumber);
1019 }
1020 
1021 // File: contracts/assettoken/abstract/IBasicAssetTokenFull.sol
1022 
1023 contract IBasicAssetTokenFull {
1024     function checkCanSetMetadata() internal returns (bool);
1025 
1026     function getCap() public view returns (uint256);
1027     function getGoal() public view returns (uint256);
1028     function getStart() public view returns (uint256);
1029     function getEnd() public view returns (uint256);
1030     function getLimits() public view returns (uint256, uint256, uint256, uint256);
1031     function setMetaData(
1032         string calldata _name, 
1033         string calldata _symbol, 
1034         address _tokenBaseCurrency, 
1035         uint256 _cap, 
1036         uint256 _goal, 
1037         uint256 _startTime, 
1038         uint256 _endTime) 
1039         external;
1040     
1041     function getTokenRescueControl() public view returns (address);
1042     function getPauseControl() public view returns (address);
1043     function isTransfersPaused() public view returns (bool);
1044 
1045     function setMintControl(address _mintControl) public;
1046     function setRoles(address _pauseControl, address _tokenRescueControl) public;
1047 
1048     function setTokenAlive() public;
1049     function isTokenAlive() public view returns (bool);
1050 
1051     function balanceOf(address _owner) public view returns (uint256 balance);
1052 
1053     function approve(address _spender, uint256 _amount) public returns (bool success);
1054 
1055     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
1056 
1057     function totalSupply() public view returns (uint256);
1058 
1059     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool);
1060 
1061     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool);
1062 
1063     function finishMinting() public returns (bool);
1064 
1065     function rescueToken(address _foreignTokenAddress, address _to) public;
1066 
1067     function balanceOfAt(address _owner, uint256 _specificTransfersAndMintsIndex) public view returns (uint256);
1068 
1069     function totalSupplyAt(uint256 _specificTransfersAndMintsIndex) public view returns(uint256);
1070 
1071     function enableTransfers(bool _transfersEnabled) public;
1072 
1073     function pauseTransfer(bool _transfersEnabled) public;
1074 
1075     function pauseCapitalIncreaseOrDecrease(bool _mintingEnabled) public;    
1076 
1077     function isMintingPaused() public view returns (bool);
1078 
1079     function mint(address _to, uint256 _amount) public returns (bool);
1080 
1081     function transfer(address _to, uint256 _amount) public returns (bool success);
1082 
1083     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
1084 
1085     function enableTransferInternal(bool _transfersEnabled) internal;
1086 
1087     function reopenCrowdsaleInternal() internal returns (bool);
1088 
1089     function transferFromInternal(address _from, address _to, uint256 _amount) internal returns (bool success);
1090     function enforcedTransferFromInternal(address _from, address _to, uint256 _value, bool _fullAmountRequired) internal returns (bool);
1091 
1092     event Approval(address indexed owner, address indexed spender, uint256 value);
1093     event Transfer(address indexed from, address indexed to, uint256 value);
1094     event MintDetailed(address indexed initiator, address indexed to, uint256 amount);
1095     event MintFinished(address indexed initiator);
1096     event TransferPaused(address indexed initiator);
1097     event TransferResumed(address indexed initiator);
1098     event Reopened(address indexed initiator);
1099     event MetaDataChanged(address indexed initiator, string name, string symbol, address baseCurrency, uint256 cap, uint256 goal, uint256 startTime, uint256 endTime);
1100     event RolesChanged(address indexed initiator, address _pauseControl, address _tokenRescueControl);
1101     event MintControlChanged(address indexed initiator, address mintControl);
1102 }
1103 
1104 // File: contracts/assettoken/BasicAssetToken.sol
1105 
1106 /*
1107     Copyright 2018, CONDA
1108 
1109     This program is free software: you can redistribute it and/or modify
1110     it under the terms of the GNU General Public License as published by
1111     the Free Software Foundation, either version 3 of the License, or
1112     (at your option) any later version.
1113 
1114     This program is distributed in the hope that it will be useful,
1115     but WITHOUT ANY WARRANTY; without even the implied warranty of
1116     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1117     GNU General Public License for more details.
1118 
1119     You should have received a copy of the GNU General Public License
1120     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1121 */
1122 
1123 
1124 
1125 
1126 
1127 /** @title Basic AssetToken. This contract includes the basic AssetToken features */
1128 contract BasicAssetToken is IBasicAssetTokenFull, Ownable {
1129 
1130     using SafeMath for uint256;
1131     using AssetTokenL for AssetTokenL.Supply;
1132     using AssetTokenL for AssetTokenL.Availability;
1133     using AssetTokenL for AssetTokenL.Roles;
1134 
1135 ///////////////////
1136 // Variables
1137 ///////////////////
1138 
1139     string private _name;
1140     string private _symbol;
1141 
1142     // The token's name
1143     function name() public view returns (string memory) {
1144         return _name;
1145     }
1146 
1147     // Fixed number of 0 decimals like real world equity
1148     function decimals() public pure returns (uint8) {
1149         return 0;
1150     }
1151 
1152     // An identifier
1153     function symbol() public view returns (string memory) {
1154         return _symbol;
1155     }
1156 
1157     // 1000 is version 1
1158     uint16 public constant version = 2000;
1159 
1160     // Defines the baseCurrency of the token
1161     address public baseCurrency;
1162 
1163     // Supply: balance, checkpoints etc.
1164     AssetTokenL.Supply supply;
1165 
1166     // Availability: what's paused
1167     AssetTokenL.Availability availability;
1168 
1169     // Roles: who is entitled
1170     AssetTokenL.Roles roles;
1171 
1172 ///////////////////
1173 // Simple state getters
1174 ///////////////////
1175 
1176     function isMintingPaused() public view returns (bool) {
1177         return availability.mintingPaused;
1178     }
1179 
1180     function isMintingPhaseFinished() public view returns (bool) {
1181         return availability.mintingPhaseFinished;
1182     }
1183 
1184     function getPauseControl() public view returns (address) {
1185         return roles.pauseControl;
1186     }
1187 
1188     function getTokenRescueControl() public view returns (address) {
1189         return roles.tokenRescueControl;
1190     }
1191 
1192     function getMintControl() public view returns (address) {
1193         return roles.mintControl;
1194     }
1195 
1196     function isTransfersPaused() public view returns (bool) {
1197         return !availability.transfersEnabled;
1198     }
1199 
1200     function isTokenAlive() public view returns (bool) {
1201         return availability.tokenAlive;
1202     }
1203 
1204     function getCap() public view returns (uint256) {
1205         return supply.cap;
1206     }
1207 
1208     function getGoal() public view returns (uint256) {
1209         return supply.goal;
1210     }
1211 
1212     function getStart() public view returns (uint256) {
1213         return supply.startTime;
1214     }
1215 
1216     function getEnd() public view returns (uint256) {
1217         return supply.endTime;
1218     }
1219 
1220     function getLimits() public view returns (uint256, uint256, uint256, uint256) {
1221         return (supply.cap, supply.goal, supply.startTime, supply.endTime);
1222     }
1223 
1224     function getCurrentHistoryIndex() public view returns (uint256) {
1225         return supply.tokenActionIndex;
1226     }
1227 
1228 ///////////////////
1229 // Events
1230 ///////////////////
1231 
1232     event Approval(address indexed owner, address indexed spender, uint256 value);
1233     event Transfer(address indexed from, address indexed to, uint256 value);
1234     event MintDetailed(address indexed initiator, address indexed to, uint256 amount);
1235     event MintFinished(address indexed initiator);
1236     event TransferPaused(address indexed initiator);
1237     event TransferResumed(address indexed initiator);
1238     event MintingPaused(address indexed initiator);
1239     event MintingResumed(address indexed initiator);
1240     event Reopened(address indexed initiator);
1241     event MetaDataChanged(address indexed initiator, string name, string symbol, address baseCurrency, uint256 cap, uint256 goal, uint256 startTime, uint256 endTime);
1242     event RolesChanged(address indexed initiator, address pauseControl, address tokenRescueControl);
1243     event MintControlChanged(address indexed initiator, address mintControl);
1244     event TokenActionIndexIncreased(uint256 tokenActionIndex, uint256 blocknumber);
1245 
1246 ///////////////////
1247 // Modifiers
1248 ///////////////////
1249     modifier onlyPauseControl() {
1250         require(msg.sender == roles.pauseControl, "pauseCtrl");
1251         _;
1252     }
1253 
1254     //can be overwritten in inherited contracts...
1255     function _canDoAnytime() internal view returns (bool) {
1256         return false;
1257     }
1258 
1259     modifier onlyOwnerOrOverruled() {
1260         if(_canDoAnytime() == false) { 
1261             require(isOwner(), "only owner");
1262         }
1263         _;
1264     }
1265 
1266     modifier canMint() {
1267         if(_canDoAnytime() == false) { 
1268             require(canMintLogic(), "canMint");
1269         }
1270         _;
1271     }
1272 
1273     function canMintLogic() private view returns (bool) {
1274         return msg.sender == roles.mintControl && availability.tokenAlive && !availability.mintingPhaseFinished && !availability.mintingPaused;
1275     }
1276 
1277     //can be overwritten in inherited contracts...
1278     function checkCanSetMetadata() internal returns (bool) {
1279         if(_canDoAnytime() == false) {
1280             require(isOwner(), "owner only");
1281             require(!availability.tokenAlive, "alive");
1282             require(!availability.mintingPhaseFinished, "finished");
1283         }
1284 
1285         return true;
1286     }
1287 
1288     modifier canSetMetadata() {
1289         checkCanSetMetadata();
1290         _;
1291     }
1292 
1293     modifier onlyTokenAlive() {
1294         require(availability.tokenAlive, "not alive");
1295         _;
1296     }
1297 
1298     modifier onlyTokenRescueControl() {
1299         require(msg.sender == roles.tokenRescueControl, "rescueCtrl");
1300         _;
1301     }
1302 
1303     modifier canTransfer() {
1304         require(availability.transfersEnabled, "paused");
1305         _;
1306     }
1307 
1308 ///////////////////
1309 // Set / Get Metadata
1310 ///////////////////
1311 
1312     /// @notice Change the token's metadata.
1313     /// @dev Time is via block.timestamp (check crowdsale contract)
1314     /// @param _nameParam The name of the token.
1315     /// @param _symbolParam The symbol of the token.
1316     /// @param _tokenBaseCurrency The base currency.
1317     /// @param _cap The max amount of tokens that can be minted.
1318     /// @param _goal The goal of tokens that should be sold.
1319     /// @param _startTime Time when crowdsale should start.
1320     /// @param _endTime Time when crowdsale should end.
1321     function setMetaData(
1322         string calldata _nameParam, 
1323         string calldata _symbolParam, 
1324         address _tokenBaseCurrency, 
1325         uint256 _cap, 
1326         uint256 _goal, 
1327         uint256 _startTime, 
1328         uint256 _endTime) 
1329         external 
1330     canSetMetadata 
1331     {
1332         require(_cap >= _goal, "cap higher goal");
1333 
1334         _name = _nameParam;
1335         _symbol = _symbolParam;
1336 
1337         baseCurrency = _tokenBaseCurrency;
1338         supply.cap = _cap;
1339         supply.goal = _goal;
1340         supply.startTime = _startTime;
1341         supply.endTime = _endTime;
1342 
1343         emit MetaDataChanged(msg.sender, _nameParam, _symbolParam, _tokenBaseCurrency, _cap, _goal, _startTime, _endTime);
1344     }
1345 
1346     /// @notice Set mint control role. Usually this is CONDA's controller.
1347     /// @param _mintControl Contract address or wallet that should be allowed to mint.
1348     function setMintControl(address _mintControl) public canSetMetadata {
1349         roles.setMintControl(_mintControl);
1350     }
1351 
1352     /// @notice Set roles.
1353     /// @param _pauseControl address that is allowed to pause.
1354     /// @param _tokenRescueControl address that is allowed rescue tokens.
1355     function setRoles(address _pauseControl, address _tokenRescueControl) public 
1356     canSetMetadata
1357     {
1358         roles.setRoles(_pauseControl, _tokenRescueControl);
1359     }
1360 
1361     function setTokenAlive() public 
1362     onlyOwnerOrOverruled
1363     {
1364         availability.setTokenAlive();
1365     }
1366 
1367 ///////////////////
1368 // ERC20 Methods
1369 ///////////////////
1370 
1371     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
1372     /// @param _to The address of the recipient
1373     /// @param _amount The amount of tokens to be transferred
1374     /// @return Whether the transfer was successful or not
1375     function transfer(address _to, uint256 _amount) public canTransfer returns (bool success) {
1376         supply.doTransfer(availability, msg.sender, _to, _amount);
1377         return true;
1378     }
1379 
1380     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition (requires allowance/approval)
1381     /// @param _from The address holding the tokens being transferred
1382     /// @param _to The address of the recipient
1383     /// @param _amount The amount of tokens to be transferred
1384     /// @return True if the transfer was successful
1385     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
1386         return transferFromInternal(_from, _to, _amount);
1387     }
1388 
1389     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition (requires allowance/approval)
1390     /// @dev modifiers in this internal method because also used by features.
1391     /// @param _from The address holding the tokens being transferred
1392     /// @param _to The address of the recipient
1393     /// @param _amount The amount of tokens to be transferred
1394     /// @return True if the transfer was successful
1395     function transferFromInternal(address _from, address _to, uint256 _amount) internal canTransfer returns (bool success) {
1396         return supply.transferFrom(availability, _from, _to, _amount);
1397     }
1398 
1399     /// @notice balance of `_owner` for this token
1400     /// @param _owner The address that's balance is being requested
1401     /// @return The balance of `_owner` now (at the current index)
1402     function balanceOf(address _owner) public view returns (uint256 balance) {
1403         return supply.balanceOfNow(_owner);
1404     }
1405 
1406     /// @notice `msg.sender` approves `_spender` to spend `_amount` of his tokens
1407     /// @dev This is a modified version of the ERC20 approve function to be a bit safer
1408     /// @param _spender The address of the account able to transfer the tokens
1409     /// @param _amount The amount of tokens to be approved for transfer
1410     /// @return True if the approval was successful
1411     function approve(address _spender, uint256 _amount) public returns (bool success) {
1412         return supply.approve(_spender, _amount);
1413     }
1414 
1415     /// @notice This method can check how much is approved by `_owner` for `_spender`
1416     /// @dev This function makes it easy to read the `allowed[]` map
1417     /// @param _owner The address of the account that owns the token
1418     /// @param _spender The address of the account able to transfer the tokens
1419     /// @return Amount of remaining tokens of _owner that _spender is allowed to spend
1420     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
1421         return supply.allowed[_owner][_spender];
1422     }
1423 
1424     /// @notice This function makes it easy to get the total number of tokens
1425     /// @return The total number of tokens now (at current index)
1426     function totalSupply() public view returns (uint256) {
1427         return supply.totalSupplyNow();
1428     }
1429 
1430 
1431     /// @notice Increase the amount of tokens that an owner allowed to a spender.
1432     /// @dev approve should be called when allowed[_spender] == 0. To increment
1433     /// allowed value is better to use this function to avoid 2 calls (and wait until
1434     /// the first transaction is mined)
1435     /// From MonolithDAO Token.sol
1436     /// @param _spender The address which will spend the funds.
1437     /// @param _addedValue The amount of tokens to increase the allowance by.
1438     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
1439         return supply.increaseApproval(_spender, _addedValue);
1440     }
1441 
1442     /// @dev Decrease the amount of tokens that an owner allowed to a spender.
1443     /// approve should be called when allowed[_spender] == 0. To decrement
1444     /// allowed value is better to use this function to avoid 2 calls (and wait until
1445     /// the first transaction is mined)
1446     /// From MonolithDAO Token.sol
1447     /// @param _spender The address which will spend the funds.
1448     /// @param _subtractedValue The amount of tokens to decrease the allowance by.
1449     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
1450         return supply.decreaseApproval(_spender, _subtractedValue);
1451     }
1452 
1453 ////////////////
1454 // Miniting 
1455 ////////////////
1456 
1457     /// @dev Can rescue tokens accidentally assigned to this contract
1458     /// @param _to The beneficiary who receives increased balance.
1459     /// @param _amount The amount of balance increase.
1460     function mint(address _to, uint256 _amount) public canMint returns (bool) {
1461         return supply.mint(_to, _amount);
1462     }
1463 
1464     /// @notice Function to stop minting new tokens
1465     /// @return True if the operation was successful.
1466     function finishMinting() public onlyOwnerOrOverruled returns (bool) {
1467         return availability.finishMinting();
1468     }
1469 
1470 ////////////////
1471 // Rescue Tokens 
1472 ////////////////
1473 
1474     /// @dev Can rescue tokens accidentally assigned to this contract
1475     /// @param _foreignTokenAddress The address from which the balance will be retrieved
1476     /// @param _to beneficiary
1477     function rescueToken(address _foreignTokenAddress, address _to)
1478     public
1479     onlyTokenRescueControl
1480     {
1481         availability.rescueToken(_foreignTokenAddress, _to);
1482     }
1483 
1484 ////////////////
1485 // Query balance and totalSupply in History
1486 ////////////////
1487 
1488     /// @notice Someone's token balance of this token
1489     /// @dev Queries the balance of `_owner` at `_specificTransfersAndMintsIndex`
1490     /// @param _owner The address from which the balance will be retrieved
1491     /// @param _specificTransfersAndMintsIndex The balance at index
1492     /// @return The balance at `_specificTransfersAndMintsIndex`
1493     function balanceOfAt(address _owner, uint256 _specificTransfersAndMintsIndex) public view returns (uint256) {
1494         return supply.balanceOfAt(_owner, _specificTransfersAndMintsIndex);
1495     }
1496 
1497     /// @notice Total amount of tokens at `_specificTransfersAndMintsIndex`.
1498     /// @param _specificTransfersAndMintsIndex The totalSupply at index
1499     /// @return The total amount of tokens at `_specificTransfersAndMintsIndex`
1500     function totalSupplyAt(uint256 _specificTransfersAndMintsIndex) public view returns(uint256) {
1501         return supply.totalSupplyAt(_specificTransfersAndMintsIndex);
1502     }
1503 
1504 ////////////////
1505 // Enable tokens transfers
1506 ////////////////
1507 
1508     /// @dev this function is not public and can be overwritten
1509     function enableTransferInternal(bool _transfersEnabled) internal {
1510         availability.pauseTransfer(_transfersEnabled);
1511     }
1512 
1513     /// @notice Enables token holders to transfer their tokens freely if true
1514     /// @param _transfersEnabled True if transfers are allowed
1515     function enableTransfers(bool _transfersEnabled) public 
1516     onlyOwnerOrOverruled 
1517     {
1518         enableTransferInternal(_transfersEnabled);
1519     }
1520 
1521 ////////////////
1522 // Pausing token for unforeseen reasons
1523 ////////////////
1524 
1525     /// @dev `pauseTransfer` is an alias for `enableTransfers` using the pauseControl modifier
1526     /// @param _transfersEnabled False if transfers are allowed
1527     function pauseTransfer(bool _transfersEnabled) public
1528     onlyPauseControl
1529     {
1530         enableTransferInternal(_transfersEnabled);
1531     }
1532 
1533     /// @dev `pauseCapitalIncreaseOrDecrease` can pause mint
1534     /// @param _mintingEnabled False if minting is allowed
1535     function pauseCapitalIncreaseOrDecrease(bool _mintingEnabled) public
1536     onlyPauseControl
1537     {
1538         availability.pauseCapitalIncreaseOrDecrease(_mintingEnabled);
1539     }
1540 
1541     /// @dev capitalControl (if exists) can reopen the crowdsale.
1542     /// this function is not public and can be overwritten
1543     function reopenCrowdsaleInternal() internal returns (bool) {
1544         return availability.reopenCrowdsale();
1545     }
1546 
1547     /// @dev capitalControl (if exists) can enforce a transferFrom e.g. in case of lost wallet.
1548     /// this function is not public and can be overwritten
1549     function enforcedTransferFromInternal(address _from, address _to, uint256 _value, bool _fullAmountRequired) internal returns (bool) {
1550         return supply.enforcedTransferFrom(availability, _from, _to, _value, _fullAmountRequired);
1551     }
1552 }
1553 
1554 // File: contracts/assettoken/interfaces/ICRWDControllerTransfer.sol
1555 
1556 interface ICRWDControllerTransfer {
1557     function transferParticipantsVerification(address _underlyingCurrency, address _from, address _to, uint256 _amount) external returns (bool);
1558 }
1559 
1560 // File: contracts/assettoken/interfaces/IGlobalIndexControllerLocation.sol
1561 
1562 interface IGlobalIndexControllerLocation {
1563     function getControllerAddress() external view returns (address);
1564 }
1565 
1566 // File: contracts/assettoken/abstract/ICRWDAssetToken.sol
1567 
1568 contract ICRWDAssetToken is IBasicAssetTokenFull {
1569     function setGlobalIndexAddress(address _globalIndexAddress) public;
1570 }
1571 
1572 // File: contracts/assettoken/CRWDAssetToken.sol
1573 
1574 /*
1575     Copyright 2018, CONDA
1576 
1577     This program is free software: you can redistribute it and/or modify
1578     it under the terms of the GNU General Public License as published by
1579     the Free Software Foundation, either version 3 of the License, or
1580     (at your option) any later version.
1581 
1582     This program is distributed in the hope that it will be useful,
1583     but WITHOUT ANY WARRANTY; without even the implied warranty of
1584     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1585     GNU General Public License for more details.
1586 
1587     You should have received a copy of the GNU General Public License
1588     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1589 */
1590 
1591 
1592 
1593 
1594 
1595 
1596 /** @title CRWD AssetToken. This contract inherits basic functionality and extends calls to controller. */
1597 contract CRWDAssetToken is BasicAssetToken, ICRWDAssetToken {
1598 
1599     using SafeMath for uint256;
1600 
1601     IGlobalIndexControllerLocation public globalIndex;
1602 
1603     function getControllerAddress() public view returns (address) {
1604         return globalIndex.getControllerAddress();
1605     }
1606 
1607     /** @dev ERC20 transfer function overlay to transfer tokens and call controller.
1608       * @param _to The recipient address.
1609       * @param _amount The amount.
1610       * @return A boolean that indicates if the operation was successful.
1611       */
1612     function transfer(address _to, uint256 _amount) public returns (bool success) {
1613         ICRWDControllerTransfer(getControllerAddress()).transferParticipantsVerification(baseCurrency, msg.sender, _to, _amount);
1614         return super.transfer(_to, _amount);
1615     }
1616 
1617     /** @dev ERC20 transferFrom function overlay to transfer tokens and call controller.
1618       * @param _from The sender address (requires approval).
1619       * @param _to The recipient address.
1620       * @param _amount The amount.
1621       * @return A boolean that indicates if the operation was successful.
1622       */
1623     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
1624         ICRWDControllerTransfer(getControllerAddress()).transferParticipantsVerification(baseCurrency, _from, _to, _amount);
1625         return super.transferFrom(_from, _to, _amount);
1626     }
1627 
1628     /** @dev Mint function overlay to mint/create tokens.
1629       * @param _to The address that will receive the minted tokens.
1630       * @param _amount The amount of tokens to mint.
1631       * @return A boolean that indicates if the operation was successful.
1632       */
1633     function mint(address _to, uint256 _amount) public canMint returns (bool) {
1634         return super.mint(_to,_amount);
1635     }
1636 
1637     /** @dev Set address of GlobalIndex.
1638       * @param _globalIndexAddress Address to be used for current destination e.g. controller lookup.
1639       */
1640     function setGlobalIndexAddress(address _globalIndexAddress) public onlyOwner {
1641         globalIndex = IGlobalIndexControllerLocation(_globalIndexAddress);
1642     }
1643 }
1644 
1645 // File: contracts/assettoken/feature/FeatureCapitalControl.sol
1646 
1647 /*
1648     Copyright 2018, CONDA
1649 
1650     This program is free software: you can redistribute it and/or modify
1651     it under the terms of the GNU General Public License as published by
1652     the Free Software Foundation, either version 3 of the License, or
1653     (at your option) any later version.
1654 
1655     This program is distributed in the hope that it will be useful,
1656     but WITHOUT ANY WARRANTY; without even the implied warranty of
1657     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1658     GNU General Public License for more details.
1659 
1660     You should have received a copy of the GNU General Public License
1661     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1662 */
1663 
1664 
1665 /** @title FeatureCapitalControl. */
1666 contract FeatureCapitalControl is ICRWDAssetToken {
1667     
1668 ////////////////
1669 // Variables
1670 ////////////////
1671 
1672     //if set can mint after finished. E.g. a notary.
1673     address public capitalControl;
1674 
1675 ////////////////
1676 // Constructor
1677 ////////////////
1678 
1679     constructor(address _capitalControl) public {
1680         capitalControl = _capitalControl;
1681         enableTransferInternal(false); //disable transfer as default
1682     }
1683 
1684 ////////////////
1685 // Modifiers
1686 ////////////////
1687 
1688     //override: skip certain modifier checks as capitalControl
1689     function _canDoAnytime() internal view returns (bool) {
1690         return msg.sender == capitalControl;
1691     }
1692 
1693     modifier onlyCapitalControl() {
1694         require(msg.sender == capitalControl, "permission");
1695         _;
1696     }
1697 
1698 ////////////////
1699 // Functions
1700 ////////////////
1701 
1702     /// @notice set capitalControl
1703     /// @dev this looks unprotected but has a checkCanSetMetadata check.
1704     ///  depending on inheritance this can be done 
1705     ///  before alive and any time by capitalControl
1706     function setCapitalControl(address _capitalControl) public {
1707         require(checkCanSetMetadata(), "forbidden");
1708 
1709         capitalControl = _capitalControl;
1710     }
1711 
1712     /// @notice as capital control I can pass my ownership to a new address (e.g. private key leaked).
1713     /// @param _capitalControl new capitalControl address
1714     function updateCapitalControl(address _capitalControl) public onlyCapitalControl {
1715         capitalControl = _capitalControl;
1716     }
1717 
1718 ////////////////
1719 // Reopen crowdsale (by capitalControl e.g. notary)
1720 ////////////////
1721 
1722     /// @notice capitalControl can reopen the crowdsale.
1723     function reopenCrowdsale() public onlyCapitalControl returns (bool) {        
1724         return reopenCrowdsaleInternal();
1725     }
1726 }
1727 
1728 // File: contracts/assettoken/feature/FeatureCapitalControlWithForcedTransferFrom.sol
1729 
1730 /*
1731     Copyright 2018, CONDA
1732 
1733     This program is free software: you can redistribute it and/or modify
1734     it under the terms of the GNU General Public License as published by
1735     the Free Software Foundation, either version 3 of the License, or
1736     (at your option) any later version.
1737 
1738     This program is distributed in the hope that it will be useful,
1739     but WITHOUT ANY WARRANTY; without even the implied warranty of
1740     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1741     GNU General Public License for more details.
1742 
1743     You should have received a copy of the GNU General Public License
1744     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1745 */
1746 
1747 
1748 
1749 /** @title FeatureCapitalControlWithForcedTransferFrom. */
1750 contract FeatureCapitalControlWithForcedTransferFrom is FeatureCapitalControl {
1751 
1752 ///////////////////
1753 // Constructor
1754 ///////////////////
1755 
1756     constructor(address _capitalControl) FeatureCapitalControl(_capitalControl) public { }
1757 
1758 ///////////////////
1759 // Events
1760 ///////////////////
1761 
1762     event SelfApprovedTransfer(address indexed initiator, address indexed from, address indexed to, uint256 value);
1763 
1764 
1765 ///////////////////
1766 // Overrides
1767 ///////////////////
1768 
1769     //override: transferFrom that has special self-approve behaviour when executed as capitalControl
1770     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
1771     {
1772         if (msg.sender == capitalControl) {
1773             return enforcedTransferFromInternal(_from, _to, _value, true);
1774         } else {
1775             return transferFromInternal(_from, _to, _value);
1776         }
1777     }
1778 
1779 }
1780 
1781 // File: contracts/assettoken/STOs/AssetTokenT001.sol
1782 
1783 /** @title AssetTokenT001 Token. A CRWDAssetToken with CapitalControl and LostWallet feature */
1784 contract AssetTokenT001 is CRWDAssetToken, FeatureCapitalControlWithForcedTransferFrom
1785 {    
1786     constructor(address _capitalControl) FeatureCapitalControlWithForcedTransferFrom(_capitalControl) public {}
1787 }