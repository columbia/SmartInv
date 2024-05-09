1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipRenounced(address indexed previousOwner);
14     event OwnershipTransferred(
15         address indexed previousOwner,
16         address indexed newOwner
17     );
18 
19 
20     /**
21      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22      * account.
23      */
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     /**
37      * @dev Allows the current owner to relinquish control of the contract.
38      * @notice Renouncing to ownership will leave the contract without an owner.
39      * It will not be possible to call the functions with the `onlyOwner`
40      * modifier anymore.
41      */
42     function renounceOwnership() public onlyOwner {
43         emit OwnershipRenounced(owner);
44         owner = address(0);
45     }
46 
47     /**
48      * @dev Allows the current owner to transfer control of the contract to a newOwner.
49      * @param _newOwner The address to transfer ownership to.
50      */
51     function transferOwnership(address _newOwner) public onlyOwner {
52         _transferOwnership(_newOwner);
53     }
54 
55     /**
56      * @dev Transfers control of the contract to a newOwner.
57      * @param _newOwner The address to transfer ownership to.
58      */
59     function _transferOwnership(address _newOwner) internal {
60         require(_newOwner != address(0));
61         emit OwnershipTransferred(owner, _newOwner);
62         owner = _newOwner;
63     }
64 }
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * See https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72     function totalSupply() public view returns (uint256);
73     function balanceOf(address _who) public view returns (uint256);
74     function transfer(address _to, uint256 _value) public returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83     function allowance(address _owner, address _spender)
84     public view returns (uint256);
85 
86     function transferFrom(address _from, address _to, uint256 _value)
87     public returns (bool);
88 
89     function approve(address _spender, uint256 _value) public returns (bool);
90     event Approval(
91         address indexed owner,
92         address indexed spender,
93         uint256 value
94     );
95 }
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102     using SafeMath for uint256;
103 
104     mapping(address => uint256) internal balances;
105 
106     uint256 internal totalSupply_;
107 
108     /**
109     * @dev Total number of tokens in existence
110     */
111     function totalSupply() public view returns (uint256) {
112         return totalSupply_;
113     }
114 
115     /**
116     * @dev Transfer token for a specified address
117     * @param _to The address to transfer to.
118     * @param _value The amount to be transferred.
119     */
120     function transfer(address _to, uint256 _value) public returns (bool) {
121         require(_value <= balances[msg.sender]);
122         require(_to != address(0));
123 
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         emit Transfer(msg.sender, _to, _value);
127         return true;
128     }
129 
130     /**
131     * @dev Gets the balance of the specified address.
132     * @param _owner The address to query the the balance of.
133     * @return An uint256 representing the amount owned by the passed address.
134     */
135     function balanceOf(address _owner) public view returns (uint256) {
136         return balances[_owner];
137     }
138 
139 }
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * https://github.com/ethereum/EIPs/issues/20
146  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150     mapping (address => mapping (address => uint256)) internal allowed;
151 
152 
153     /**
154      * @dev Transfer tokens from one address to another
155      * @param _from address The address which you want to send tokens from
156      * @param _to address The address which you want to transfer to
157      * @param _value uint256 the amount of tokens to be transferred
158      */
159     function transferFrom(
160         address _from,
161         address _to,
162         uint256 _value
163     )
164         public
165         returns (bool)
166     {
167         require(_value <= balances[_from]);
168         require(_value <= allowed[_from][msg.sender]);
169         require(_to != address(0));
170 
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         emit Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180      * Beware that changing an allowance with this method brings the risk that someone may use both the old
181      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184      * @param _spender The address which will spend the funds.
185      * @param _value The amount of tokens to be spent.
186      */
187     function approve(address _spender, uint256 _value) public returns (bool) {
188         allowed[msg.sender][_spender] = _value;
189         emit Approval(msg.sender, _spender, _value);
190         return true;
191     }
192 
193     /**
194      * @dev Function to check the amount of tokens that an owner allowed to a spender.
195      * @param _owner address The address which owns the funds.
196      * @param _spender address The address which will spend the funds.
197      * @return A uint256 specifying the amount of tokens still available for the spender.
198      */
199     function allowance(
200         address _owner,
201         address _spender
202     )
203         public
204         view
205         returns (uint256)
206     {
207         return allowed[_owner][_spender];
208     }
209 
210     /**
211      * @dev Increase the amount of tokens that an owner allowed to a spender.
212      * approve should be called when allowed[_spender] == 0. To increment
213      * allowed value is better to use this function to avoid 2 calls (and wait until
214      * the first transaction is mined)
215      * From MonolithDAO Token.sol
216      * @param _spender The address which will spend the funds.
217      * @param _addedValue The amount of tokens to increase the allowance by.
218      */
219     function increaseApproval(
220         address _spender,
221         uint256 _addedValue
222     )
223         public
224         returns (bool)
225     {
226         allowed[msg.sender][_spender] = (
227         allowed[msg.sender][_spender].add(_addedValue));
228         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232     /**
233      * @dev Decrease the amount of tokens that an owner allowed to a spender.
234      * approve should be called when allowed[_spender] == 0. To decrement
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      * @param _spender The address which will spend the funds.
239      * @param _subtractedValue The amount of tokens to decrease the allowance by.
240      */
241     function decreaseApproval(
242         address _spender,
243         uint256 _subtractedValue
244     )
245         public
246         returns (bool)
247     {
248         uint256 oldValue = allowed[msg.sender][_spender];
249         if (_subtractedValue >= oldValue) {
250             allowed[msg.sender][_spender] = 0;
251         } else {
252             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253         }
254         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258 }
259 
260 /**
261  * @title SafeMath
262  * @dev Math operations with safety checks that throw on error
263  */
264 library SafeMath {
265 
266     /**
267     * @dev Multiplies two numbers, throws on overflow.
268     */
269     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
270         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
271         // benefit is lost if 'b' is also tested.
272         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
273         if (_a == 0) {
274             return 0;
275         }
276 
277         c = _a * _b;
278         assert(c / _a == _b);
279         return c;
280     }
281 
282     /**
283     * @dev Integer division of two numbers, truncating the quotient.
284     */
285     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
286         // assert(_b > 0); // Solidity automatically throws when dividing by 0
287         // uint256 c = _a / _b;
288         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
289         return _a / _b;
290     }
291 
292     /**
293     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
294     */
295     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
296         assert(_b <= _a);
297         return _a - _b;
298     }
299 
300     /**
301     * @dev Adds two numbers, throws on overflow.
302     */
303     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
304         c = _a + _b;
305         assert(c >= _a);
306         return c;
307     }
308 }
309 
310 /**
311  * @title Burnable Token
312  * @dev Token that can be irreversibly burned (destroyed).
313  */
314 contract BurnableToken is BasicToken {
315 
316     event Burn(address indexed burner, uint256 value);
317 
318     /**
319      * @dev Burns a specific amount of tokens.
320      * @param _value The amount of token to be burned.
321      */
322     function burn(uint256 _value) public {
323         _burn(msg.sender, _value);
324     }
325 
326     function _burn(address _who, uint256 _value) internal {
327         require(_value <= balances[_who]);
328         // no need to require value <= totalSupply, since that would imply the
329         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
330 
331         balances[_who] = balances[_who].sub(_value);
332         totalSupply_ = totalSupply_.sub(_value);
333         emit Burn(_who, _value);
334         emit Transfer(_who, address(0), _value);
335     }
336 }
337 
338 /**
339  * @title Pausable
340  * @dev Base contract which allows children to implement an emergency stop mechanism.
341  */
342 contract Pausable is Ownable {
343     event Pause();
344     event Unpause();
345 
346     bool public paused = false;
347 
348 
349     /**
350      * @dev Modifier to make a function callable only when the contract is not paused.
351      */
352     modifier whenNotPaused() {
353         require(!paused);
354         _;
355     }
356 
357     /**
358      * @dev Modifier to make a function callable only when the contract is paused.
359      */
360     modifier whenPaused() {
361         require(paused);
362         _;
363     }
364 
365     /**
366      * @dev called by the owner to pause, triggers stopped state
367      */
368     function pause() public onlyOwner whenNotPaused {
369         paused = true;
370         emit Pause();
371     }
372 
373     /**
374      * @dev called by the owner to unpause, returns to normal state
375      */
376     function unpause() public onlyOwner whenPaused {
377         paused = false;
378         emit Unpause();
379     }
380 }
381 
382 /**
383  * @title Pausable token
384  * @dev StandardToken modified with pausable transfers.
385  **/
386 contract PausableToken is StandardToken, Pausable {
387 
388     function transfer(
389         address _to,
390         uint256 _value
391     )
392         public
393         whenNotPaused
394         returns (bool)
395     {
396         return super.transfer(_to, _value);
397     }
398 
399     function transferFrom(
400         address _from,
401         address _to,
402         uint256 _value
403     )
404         public
405         whenNotPaused
406         returns (bool)
407     {
408         return super.transferFrom(_from, _to, _value);
409     }
410 
411     function approve(
412         address _spender,
413         uint256 _value
414     )
415         public
416         whenNotPaused
417         returns (bool)
418     {
419         return super.approve(_spender, _value);
420     }
421 
422     function increaseApproval(
423         address _spender,
424         uint _addedValue
425     )
426         public
427         whenNotPaused
428         returns (bool success)
429     {
430         return super.increaseApproval(_spender, _addedValue);
431     }
432 
433     function decreaseApproval(
434         address _spender,
435         uint _subtractedValue
436     )
437         public
438         whenNotPaused
439         returns (bool success)
440     {
441         return super.decreaseApproval(_spender, _subtractedValue);
442     }
443 }
444 
445 /**
446  * @title Math
447  * @dev Assorted math operations
448  */
449 library Math {
450     function average(uint256 a, uint256 b) internal pure returns (uint256) {
451         // (a + b) / 2 can overflow, so we distribute
452         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
453     }
454 }
455 
456 library ArrayUtils {
457     function findUpperBound(uint256[] storage _array, uint256 _element) internal view returns (uint256) {
458         uint256 low = 0;
459         uint256 high = _array.length;
460 
461         while (low < high) {
462             uint256 mid = Math.average(low, high);
463 
464             if (_array[mid] > _element) {
465                 high = mid;
466             } else {
467                 low = mid + 1;
468             }
469         }
470 
471         // At this point at `low` is the exclusive upper bound. We will return the inclusive upper bound.
472 
473         if (low > 0 && _array[low - 1] == _element) {
474             return low - 1;
475         } else {
476             return low;
477         }
478     }
479 }
480 
481 contract Whitelist is Ownable {
482     struct WhitelistInfo {
483         bool inWhitelist;
484         uint256 index;  //index in whitelistAddress
485         uint256 time;   //timestamp when added to whitelist
486     }
487 
488     mapping (address => WhitelistInfo) public whitelist;
489     address[] public whitelistAddresses;
490 
491     event AddWhitelist(address indexed operator, uint256 indexInWhitelist);
492     event RemoveWhitelist(address indexed operator, uint256 indexInWhitelist);
493 
494     /**
495     * @dev Throws if operator is not whitelisted.
496     * @param _operator address
497     */
498     modifier onlyIfWhitelisted(address _operator) {
499         require(inWhitelist(_operator) == true, "not whitelisted.");
500         _;
501     }
502 
503     /**
504      * @dev add an address to the whitelist
505      * @param _operator address
506      * @return true if the address was added to the whitelist, false if the address was already in the whitelist
507      */
508     function addAddressToWhitelist(address _operator)
509         public
510         onlyOwner
511         returns(bool)
512     {
513         WhitelistInfo storage whitelistInfo_ = whitelist[_operator];
514 
515         if (inWhitelist(_operator) == false) {
516             whitelistAddresses.push(_operator);
517 
518             whitelistInfo_.inWhitelist = true;
519             whitelistInfo_.time = block.timestamp;
520             whitelistInfo_.index = whitelistAddresses.length-1;
521 
522             emit AddWhitelist(_operator, whitelistAddresses.length-1);
523             return true;
524         } else {
525             return false;
526         }
527     }
528 
529     /**
530      * @dev add addresses to the whitelist
531      * @param _operators addresses
532      */
533     function addAddressesToWhitelist(address[] _operators)
534         public
535         onlyOwner
536     {
537         for (uint256 i = 0; i < _operators.length; i++) {
538             addAddressToWhitelist(_operators[i]);
539         }
540     }
541 
542     /**
543     * @dev remove an address from the whitelist
544     * @param _operator address
545     * @return true if the address was removed from the whitelist,
546     * false if the address wasn't in the whitelist in the first place
547     */
548     function removeAddressFromWhitelist(address _operator)
549         public
550         onlyOwner
551         returns(bool)
552     {
553         if (inWhitelist(_operator) == true) {
554             uint256 whitelistIndex_ = whitelist[_operator].index;
555             removeItemFromWhitelistAddresses(whitelistIndex_);
556             whitelist[_operator] = WhitelistInfo(false, 0, 0);
557 
558             emit RemoveWhitelist(_operator, whitelistIndex_);
559             return true;
560         } else {
561             return false;
562         }
563     }
564 
565     function removeItemFromWhitelistAddresses(uint256 _index) private {
566         address lastWhitelistAddr = whitelistAddresses[whitelistAddresses.length-1];
567         WhitelistInfo storage lastWhitelistInfo = whitelist[lastWhitelistAddr];
568 
569         //move last whitelist to the deleted slot
570         whitelistAddresses[_index] = whitelistAddresses[whitelistAddresses.length-1];
571         lastWhitelistInfo.index = _index;
572         delete whitelistAddresses[whitelistAddresses.length-1];
573         whitelistAddresses.length--;
574     }
575 
576     /**
577      * @dev remove addresses from the whitelist
578      * @param _operators addresses
579      */
580     function removeAddressesFromWhitelist(address[] _operators)
581         public
582         onlyOwner
583     {
584         for (uint256 i = 0; i < _operators.length; i++) {
585             removeAddressFromWhitelist(_operators[i]);
586         }
587     }
588 
589     /**
590     * @dev check if the given address already in whitelist.
591     * @return return true if in whitelist.
592     */
593     function inWhitelist(address _operator)
594         public
595         view
596         returns(bool)
597     {
598         return whitelist[_operator].inWhitelist;
599     }
600 
601     function getWhitelistCount() public view returns(uint256) {
602         return whitelistAddresses.length;
603     }
604 
605     function getAllWhitelist() public view returns(address[]) {
606         address[] memory allWhitelist = new address[](whitelistAddresses.length);
607         for (uint256 i = 0; i < whitelistAddresses.length; i++) {
608             allWhitelist[i] = whitelistAddresses[i];
609         }
610         return allWhitelist;
611     }
612 }
613 
614 /**
615  * @title SnapshotToken
616  *
617  * @dev An ERC20 token which enables taking snapshots of accounts' balances.
618  * @dev This can be useful to safely implement voting weighed by balance.
619  */
620 contract SnapshotToken is StandardToken {
621     using ArrayUtils for uint256[];
622 
623     // The 0 id represents no snapshot was taken yet.
624     uint256 public currSnapshotId;
625 
626     mapping (address => uint256[]) internal snapshotIds;
627     mapping (address => uint256[]) internal snapshotBalances;
628 
629     event Snapshot(uint256 id);
630 
631     function transfer(address _to, uint256 _value) public returns (bool) {
632         _updateSnapshot(msg.sender);
633         _updateSnapshot(_to);
634         return super.transfer(_to, _value);
635     }
636 
637     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
638         _updateSnapshot(_from);
639         _updateSnapshot(_to);
640         return super.transferFrom(_from, _to, _value);
641     }
642 
643     function snapshot() public returns (uint256) {
644         currSnapshotId += 1;
645         emit Snapshot(currSnapshotId);
646         return currSnapshotId;
647     }
648 
649     function balanceOfAt(address _account, uint256 _snapshotId) public view returns (uint256) {
650         require(_snapshotId > 0 && _snapshotId <= currSnapshotId);
651 
652         uint256 idx = snapshotIds[_account].findUpperBound(_snapshotId);
653 
654         if (idx == snapshotIds[_account].length) {
655             return balanceOf(_account);
656         } else {
657             return snapshotBalances[_account][idx];
658         }
659     }
660 
661     function _updateSnapshot(address _account) internal {
662         if (_lastSnapshotId(_account) < currSnapshotId) {
663             snapshotIds[_account].push(currSnapshotId);
664             snapshotBalances[_account].push(balanceOf(_account));
665         }
666     }
667 
668     function _lastSnapshotId(address _account) internal view returns (uint256) {
669         uint256[] storage snapshots = snapshotIds[_account];
670 
671         if (snapshots.length == 0) {
672             return 0;
673         } else {
674             return snapshots[snapshots.length - 1];
675         }
676     }
677 }
678 
679 
680 contract BBT is BurnableToken, PausableToken, SnapshotToken, Whitelist {
681     string public constant symbol = "BBT";
682     string public constant name = "BonBon Token";
683     uint8 public constant decimals = 18;
684     uint256 private overrideTotalSupply_ = 10 * 1e9 * 1e18; //10 billion
685 
686     uint256 public circulation;
687     uint256 public minedAmount;
688     address public teamWallet;
689     uint256 public constant gameDistributionRatio = 35; //35%
690     uint256 public constant teamReservedRatio = 15;     //15%
691 
692     mapping (uint256 => uint256) private snapshotCirculations_;   //snapshotId => circulation
693 
694     event Mine(address indexed from, address indexed to, uint256 amount);
695     event Release(address indexed from, address indexed to, uint256 amount);
696     event SetTeamWallet(address indexed from, address indexed teamWallet);
697     event UnlockTeamBBT(address indexed teamWallet, uint256 amount, string source);
698 
699     /**
700      * @dev make sure unreleased BBT is enough.
701      */
702     modifier hasEnoughUnreleasedBBT(uint256 _amount) {
703         require(circulation.add(_amount) <= totalSupply_, "Unreleased BBT not enough.");
704         _;
705     }
706 
707     /**
708      * @dev make sure dev team wallet is set.
709      */
710     modifier hasTeamWallet() {
711         require(teamWallet != address(0), "Team wallet not set.");
712         _;
713     }
714 
715     constructor() public {
716         totalSupply_ = overrideTotalSupply_;
717     }
718 
719     /**
720      * @dev make snapshot.
721      */
722     function snapshot()
723         onlyIfWhitelisted(msg.sender)
724         whenNotPaused
725         public
726         returns(uint256)
727     {
728         currSnapshotId += 1;
729         snapshotCirculations_[currSnapshotId] = circulation;
730         emit Snapshot(currSnapshotId);
731         return currSnapshotId;
732     }
733 
734     /**
735      * @dev get BBT circulation by snapshot id.
736      * @param _snapshotId snapshot id.
737      */
738     function circulationAt(uint256 _snapshotId)
739         public
740         view
741         returns(uint256)
742     {
743         require(_snapshotId > 0 && _snapshotId <= currSnapshotId, "invalid snapshot id.");
744         return snapshotCirculations_[_snapshotId];
745     }
746 
747     /**
748      * @dev setup team wallet.
749      * @param _address address of team wallet.
750      */
751     function setTeamWallet(address _address)
752         onlyOwner
753         whenNotPaused
754         public
755         returns (bool)
756     {
757         teamWallet = _address;
758         emit SetTeamWallet(msg.sender, _address);
759         return true;
760     }
761 
762     /**
763      * @dev for authorized dapp mining BBT.
764      * @param _to to which address BBT send to.
765      * @param _amount how many BBT send.
766      */
767     function mine(address _to, uint256 _amount)
768         onlyIfWhitelisted(msg.sender)
769         whenNotPaused
770         public
771         returns (bool)
772     {
773         //use return instead of require. avoid blocking game
774         if (circulation.add(_amount) > totalSupply_)
775             return true;
776 
777         if (minedAmount.add(_amount) > (totalSupply_.mul(gameDistributionRatio)).div(100))
778             return true;
779 
780         releaseBBT(_to, _amount);
781         minedAmount = minedAmount.add(_amount);
782 
783         //unlock dev team bbt
784         unlockTeamBBT(getTeamUnlockAmountHelper(_amount), 'mine');
785 
786         emit Mine(msg.sender, _to, _amount);
787         return true;
788     }
789 
790     /**
791      * @dev owner release BBT to specified address.
792      * @param _to which address release to.
793      * @param _amount how many BBT release to.
794      */
795     function release(address _to, uint256 _amount)
796         onlyOwner
797         hasEnoughUnreleasedBBT(_amount)
798         whenNotPaused
799         public
800         returns(bool)
801     {
802         releaseBBT(_to, _amount);
803         emit Release(msg.sender, _to, _amount);
804         return true;
805     }
806 
807     /**
808      * @dev owner release BBT and unlock corresponding ratio to dev team wallet.
809      * @param _to which address release to.
810      * @param _amount how many BBT release to.
811      */
812     function releaseAndUnlock(address _to, uint256 _amount)
813         onlyOwner
814         hasEnoughUnreleasedBBT(_amount)
815         whenNotPaused
816         public
817         returns(bool)
818     {
819         release(_to, _amount);
820 
821         //unlock dev team bbt
822         unlockTeamBBT(getTeamUnlockAmountHelper(_amount), 'release');
823 
824         return true;
825     }
826 
827     function getTeamUnlockAmountHelper(uint256 _amount)
828         private
829         pure
830         returns(uint256)
831     {
832         return _amount.mul(teamReservedRatio).div(100 - teamReservedRatio);
833     }
834 
835     function unlockTeamBBT(uint256 _unlockAmount, string _source)
836         hasTeamWallet
837         hasEnoughUnreleasedBBT(_unlockAmount)
838         private
839         returns(bool)
840     {
841         releaseBBT(teamWallet, _unlockAmount);
842         emit UnlockTeamBBT(teamWallet, _unlockAmount, _source);
843         return true;
844     }
845 
846     /**
847      * @dev update balance and circulation.
848      */
849     function releaseBBT(address _to, uint256 _amount)
850         hasEnoughUnreleasedBBT(_amount)
851         private
852         returns(bool)
853     {
854         super._updateSnapshot(msg.sender);
855         super._updateSnapshot(_to);
856 
857         balances[_to] = balances[_to].add(_amount);
858         circulation = circulation.add(_amount);
859     }
860 }