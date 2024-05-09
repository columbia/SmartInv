1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract ERC20 is IERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private _balances;
117 
118   mapping (address => mapping (address => uint256)) private _allowed;
119 
120   uint256 private _totalSupply;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return _totalSupply;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param owner The address to query the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address owner) public view returns (uint256) {
135     return _balances[owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param owner address The address which owns the funds.
141    * @param spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address owner,
146     address spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return _allowed[owner][spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param to The address to transfer to.
158   * @param value The amount to be transferred.
159   */
160   function transfer(address to, uint256 value) public returns (bool) {
161     _transfer(msg.sender, to, value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param spender The address which will spend the funds.
172    * @param value The amount of tokens to be spent.
173    */
174   function approve(address spender, uint256 value) public returns (bool) {
175     require(spender != address(0));
176 
177     _allowed[msg.sender][spender] = value;
178     emit Approval(msg.sender, spender, value);
179     return true;
180   }
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param from address The address which you want to send tokens from
185    * @param to address The address which you want to transfer to
186    * @param value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address from,
190     address to,
191     uint256 value
192   )
193     public
194     returns (bool)
195   {
196     require(value <= _allowed[from][msg.sender]);
197 
198     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
199     _transfer(from, to, value);
200     return true;
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    * approve should be called when allowed_[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param spender The address which will spend the funds.
210    * @param addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseAllowance(
213     address spender,
214     uint256 addedValue
215   )
216     public
217     returns (bool)
218   {
219     require(spender != address(0));
220 
221     _allowed[msg.sender][spender] = (
222       _allowed[msg.sender][spender].add(addedValue));
223     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed_[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param spender The address which will spend the funds.
234    * @param subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseAllowance(
237     address spender,
238     uint256 subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = (
246       _allowed[msg.sender][spender].sub(subtractedValue));
247     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248     return true;
249   }
250 
251   /**
252   * @dev Transfer token for a specified addresses
253   * @param from The address to transfer from.
254   * @param to The address to transfer to.
255   * @param value The amount to be transferred.
256   */
257   function _transfer(address from, address to, uint256 value) internal {
258     require(value <= _balances[from]);
259     require(to != address(0));
260 
261     _balances[from] = _balances[from].sub(value);
262     _balances[to] = _balances[to].add(value);
263     emit Transfer(from, to, value);
264   }
265 
266   /**
267    * @dev Internal function that mints an amount of the token and assigns it to
268    * an account. This encapsulates the modification of balances such that the
269    * proper events are emitted.
270    * @param account The account that will receive the created tokens.
271    * @param value The amount that will be created.
272    */
273   function _mint(address account, uint256 value) internal {
274     require(account != 0);
275     _totalSupply = _totalSupply.add(value);
276     _balances[account] = _balances[account].add(value);
277     emit Transfer(address(0), account, value);
278   }
279 
280   /**
281    * @dev Internal function that burns an amount of the token of a given
282    * account.
283    * @param account The account whose tokens will be burnt.
284    * @param value The amount that will be burnt.
285    */
286   function _burn(address account, uint256 value) internal {
287     require(account != 0);
288     require(value <= _balances[account]);
289 
290     _totalSupply = _totalSupply.sub(value);
291     _balances[account] = _balances[account].sub(value);
292     emit Transfer(account, address(0), value);
293   }
294 
295   /**
296    * @dev Internal function that burns an amount of the token of a given
297    * account, deducting from the sender's allowance for said account. Uses the
298    * internal burn function.
299    * @param account The account whose tokens will be burnt.
300    * @param value The amount that will be burnt.
301    */
302   function _burnFrom(address account, uint256 value) internal {
303     require(value <= _allowed[account][msg.sender]);
304 
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
308       value);
309     _burn(account, value);
310   }
311 }
312 
313 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
314 
315 /**
316  * @title ERC20Detailed token
317  * @dev The decimals are only for visualization purposes.
318  * All the operations are done using the smallest and indivisible token unit,
319  * just as on Ethereum all the operations are done in wei.
320  */
321 contract ERC20Detailed is IERC20 {
322   string private _name;
323   string private _symbol;
324   uint8 private _decimals;
325 
326   constructor(string name, string symbol, uint8 decimals) public {
327     _name = name;
328     _symbol = symbol;
329     _decimals = decimals;
330   }
331 
332   /**
333    * @return the name of the token.
334    */
335   function name() public view returns(string) {
336     return _name;
337   }
338 
339   /**
340    * @return the symbol of the token.
341    */
342   function symbol() public view returns(string) {
343     return _symbol;
344   }
345 
346   /**
347    * @return the number of decimals of the token.
348    */
349   function decimals() public view returns(uint8) {
350     return _decimals;
351   }
352 }
353 
354 // File: openzeppelin-solidity/contracts/access/Roles.sol
355 
356 /**
357  * @title Roles
358  * @dev Library for managing addresses assigned to a Role.
359  */
360 library Roles {
361   struct Role {
362     mapping (address => bool) bearer;
363   }
364 
365   /**
366    * @dev give an account access to this role
367    */
368   function add(Role storage role, address account) internal {
369     require(account != address(0));
370     require(!has(role, account));
371 
372     role.bearer[account] = true;
373   }
374 
375   /**
376    * @dev remove an account's access to this role
377    */
378   function remove(Role storage role, address account) internal {
379     require(account != address(0));
380     require(has(role, account));
381 
382     role.bearer[account] = false;
383   }
384 
385   /**
386    * @dev check if an account has this role
387    * @return bool
388    */
389   function has(Role storage role, address account)
390     internal
391     view
392     returns (bool)
393   {
394     require(account != address(0));
395     return role.bearer[account];
396   }
397 }
398 
399 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
400 
401 contract MinterRole {
402   using Roles for Roles.Role;
403 
404   event MinterAdded(address indexed account);
405   event MinterRemoved(address indexed account);
406 
407   Roles.Role private minters;
408 
409   constructor() internal {
410     _addMinter(msg.sender);
411   }
412 
413   modifier onlyMinter() {
414     require(isMinter(msg.sender));
415     _;
416   }
417 
418   function isMinter(address account) public view returns (bool) {
419     return minters.has(account);
420   }
421 
422   function addMinter(address account) public onlyMinter {
423     _addMinter(account);
424   }
425 
426   function renounceMinter() public {
427     _removeMinter(msg.sender);
428   }
429 
430   function _addMinter(address account) internal {
431     minters.add(account);
432     emit MinterAdded(account);
433   }
434 
435   function _removeMinter(address account) internal {
436     minters.remove(account);
437     emit MinterRemoved(account);
438   }
439 }
440 
441 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
442 
443 /**
444  * @title ERC20Mintable
445  * @dev ERC20 minting logic
446  */
447 contract ERC20Mintable is ERC20, MinterRole {
448   /**
449    * @dev Function to mint tokens
450    * @param to The address that will receive the minted tokens.
451    * @param value The amount of tokens to mint.
452    * @return A boolean that indicates if the operation was successful.
453    */
454   function mint(
455     address to,
456     uint256 value
457   )
458     public
459     onlyMinter
460     returns (bool)
461   {
462     _mint(to, value);
463     return true;
464   }
465 }
466 
467 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
468 
469 /**
470  * @title Capped token
471  * @dev Mintable token with a token cap.
472  */
473 contract ERC20Capped is ERC20Mintable {
474 
475   uint256 private _cap;
476 
477   constructor(uint256 cap)
478     public
479   {
480     require(cap > 0);
481     _cap = cap;
482   }
483 
484   /**
485    * @return the cap for the token minting.
486    */
487   function cap() public view returns(uint256) {
488     return _cap;
489   }
490 
491   function _mint(address account, uint256 value) internal {
492     require(totalSupply().add(value) <= _cap);
493     super._mint(account, value);
494   }
495 }
496 
497 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
498 
499 /**
500  * @title Burnable Token
501  * @dev Token that can be irreversibly burned (destroyed).
502  */
503 contract ERC20Burnable is ERC20 {
504 
505   /**
506    * @dev Burns a specific amount of tokens.
507    * @param value The amount of token to be burned.
508    */
509   function burn(uint256 value) public {
510     _burn(msg.sender, value);
511   }
512 
513   /**
514    * @dev Burns a specific amount of tokens from the target address and decrements allowance
515    * @param from address The address which you want to send tokens from
516    * @param value uint256 The amount of token to be burned
517    */
518   function burnFrom(address from, uint256 value) public {
519     _burnFrom(from, value);
520   }
521 }
522 
523 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
524 
525 contract PauserRole {
526   using Roles for Roles.Role;
527 
528   event PauserAdded(address indexed account);
529   event PauserRemoved(address indexed account);
530 
531   Roles.Role private pausers;
532 
533   constructor() internal {
534     _addPauser(msg.sender);
535   }
536 
537   modifier onlyPauser() {
538     require(isPauser(msg.sender));
539     _;
540   }
541 
542   function isPauser(address account) public view returns (bool) {
543     return pausers.has(account);
544   }
545 
546   function addPauser(address account) public onlyPauser {
547     _addPauser(account);
548   }
549 
550   function renouncePauser() public {
551     _removePauser(msg.sender);
552   }
553 
554   function _addPauser(address account) internal {
555     pausers.add(account);
556     emit PauserAdded(account);
557   }
558 
559   function _removePauser(address account) internal {
560     pausers.remove(account);
561     emit PauserRemoved(account);
562   }
563 }
564 
565 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
566 
567 /**
568  * @title Pausable
569  * @dev Base contract which allows children to implement an emergency stop mechanism.
570  */
571 contract Pausable is PauserRole {
572   event Paused(address account);
573   event Unpaused(address account);
574 
575   bool private _paused;
576 
577   constructor() internal {
578     _paused = false;
579   }
580 
581   /**
582    * @return true if the contract is paused, false otherwise.
583    */
584   function paused() public view returns(bool) {
585     return _paused;
586   }
587 
588   /**
589    * @dev Modifier to make a function callable only when the contract is not paused.
590    */
591   modifier whenNotPaused() {
592     require(!_paused);
593     _;
594   }
595 
596   /**
597    * @dev Modifier to make a function callable only when the contract is paused.
598    */
599   modifier whenPaused() {
600     require(_paused);
601     _;
602   }
603 
604   /**
605    * @dev called by the owner to pause, triggers stopped state
606    */
607   function pause() public onlyPauser whenNotPaused {
608     _paused = true;
609     emit Paused(msg.sender);
610   }
611 
612   /**
613    * @dev called by the owner to unpause, returns to normal state
614    */
615   function unpause() public onlyPauser whenPaused {
616     _paused = false;
617     emit Unpaused(msg.sender);
618   }
619 }
620 
621 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
622 
623 /**
624  * @title Pausable token
625  * @dev ERC20 modified with pausable transfers.
626  **/
627 contract ERC20Pausable is ERC20, Pausable {
628 
629   function transfer(
630     address to,
631     uint256 value
632   )
633     public
634     whenNotPaused
635     returns (bool)
636   {
637     return super.transfer(to, value);
638   }
639 
640   function transferFrom(
641     address from,
642     address to,
643     uint256 value
644   )
645     public
646     whenNotPaused
647     returns (bool)
648   {
649     return super.transferFrom(from, to, value);
650   }
651 
652   function approve(
653     address spender,
654     uint256 value
655   )
656     public
657     whenNotPaused
658     returns (bool)
659   {
660     return super.approve(spender, value);
661   }
662 
663   function increaseAllowance(
664     address spender,
665     uint addedValue
666   )
667     public
668     whenNotPaused
669     returns (bool success)
670   {
671     return super.increaseAllowance(spender, addedValue);
672   }
673 
674   function decreaseAllowance(
675     address spender,
676     uint subtractedValue
677   )
678     public
679     whenNotPaused
680     returns (bool success)
681   {
682     return super.decreaseAllowance(spender, subtractedValue);
683   }
684 }
685 
686 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
687 
688 /**
689  * @title SafeERC20
690  * @dev Wrappers around ERC20 operations that throw on failure.
691  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
692  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
693  */
694 library SafeERC20 {
695 
696   using SafeMath for uint256;
697 
698   function safeTransfer(
699     IERC20 token,
700     address to,
701     uint256 value
702   )
703     internal
704   {
705     require(token.transfer(to, value));
706   }
707 
708   function safeTransferFrom(
709     IERC20 token,
710     address from,
711     address to,
712     uint256 value
713   )
714     internal
715   {
716     require(token.transferFrom(from, to, value));
717   }
718 
719   function safeApprove(
720     IERC20 token,
721     address spender,
722     uint256 value
723   )
724     internal
725   {
726     // safeApprove should only be called when setting an initial allowance, 
727     // or when resetting it to zero. To increase and decrease it, use 
728     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
729     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
730     require(token.approve(spender, value));
731   }
732 
733   function safeIncreaseAllowance(
734     IERC20 token,
735     address spender,
736     uint256 value
737   )
738     internal
739   {
740     uint256 newAllowance = token.allowance(address(this), spender).add(value);
741     require(token.approve(spender, newAllowance));
742   }
743 
744   function safeDecreaseAllowance(
745     IERC20 token,
746     address spender,
747     uint256 value
748   )
749     internal
750   {
751     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
752     require(token.approve(spender, newAllowance));
753   }
754 }
755 
756 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
757 
758 /**
759  * @title IERC165
760  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
761  */
762 interface IERC165 {
763 
764   /**
765    * @notice Query if a contract implements an interface
766    * @param interfaceId The interface identifier, as specified in ERC-165
767    * @dev Interface identification is specified in ERC-165. This function
768    * uses less than 30,000 gas.
769    */
770   function supportsInterface(bytes4 interfaceId)
771     external
772     view
773     returns (bool);
774 }
775 
776 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
777 
778 /**
779  * @title ERC721 Non-Fungible Token Standard basic interface
780  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
781  */
782 contract IERC721 is IERC165 {
783 
784   event Transfer(
785     address indexed from,
786     address indexed to,
787     uint256 indexed tokenId
788   );
789   event Approval(
790     address indexed owner,
791     address indexed approved,
792     uint256 indexed tokenId
793   );
794   event ApprovalForAll(
795     address indexed owner,
796     address indexed operator,
797     bool approved
798   );
799 
800   function balanceOf(address owner) public view returns (uint256 balance);
801   function ownerOf(uint256 tokenId) public view returns (address owner);
802 
803   function approve(address to, uint256 tokenId) public;
804   function getApproved(uint256 tokenId)
805     public view returns (address operator);
806 
807   function setApprovalForAll(address operator, bool _approved) public;
808   function isApprovedForAll(address owner, address operator)
809     public view returns (bool);
810 
811   function transferFrom(address from, address to, uint256 tokenId) public;
812   function safeTransferFrom(address from, address to, uint256 tokenId)
813     public;
814 
815   function safeTransferFrom(
816     address from,
817     address to,
818     uint256 tokenId,
819     bytes data
820   )
821     public;
822 }
823 
824 // File: contracts/AdminRole.sol
825 
826 contract AdminRole {
827     using Roles for Roles.Role;
828 
829     event AdminAdded(address indexed account);
830     event AdminRemoved(address indexed account);
831 
832     Roles.Role private admins;
833 
834     modifier onlyAdmin() {
835         require(isAdmin(msg.sender));
836         _;
837     }
838 
839     function isAdmin(address account) public view returns (bool) {
840         return admins.has(account);
841     }
842 
843     function renounceAdmin() public {
844         _removeAdmin(msg.sender);
845     }
846 
847     function _addAdmin(address account) internal {
848         admins.add(account);
849         emit AdminAdded(account);
850     }
851 
852     function _removeAdmin(address account) internal {
853         admins.remove(account);
854         emit AdminRemoved(account);
855     }
856 }
857 
858 // File: contracts/SpenderRole.sol
859 
860 contract SpenderRole {
861     using Roles for Roles.Role;
862 
863     event SpenderAdded(address indexed account);
864     event SpenderRemoved(address indexed account);
865 
866     Roles.Role private spenders;
867 
868     modifier onlySpender() {
869         require(isSpender(msg.sender));
870         _;
871     }
872 
873     function isSpender(address account) public view returns (bool) {
874         return spenders.has(account);
875     }
876 
877     function renounceSpender() public {
878         _removeSpender(msg.sender);
879     }
880 
881     function _addSpender(address account) internal {
882         spenders.add(account);
883         emit SpenderAdded(account);
884     }
885 
886     function _removeSpender(address account) internal {
887         spenders.remove(account);
888         emit SpenderRemoved(account);
889     }
890 }
891 
892 // File: contracts/RecipientRole.sol
893 
894 contract RecipientRole {
895     using Roles for Roles.Role;
896 
897     event RecipientAdded(address indexed account);
898     event RecipientRemoved(address indexed account);
899 
900     Roles.Role private recipients;
901 
902     modifier onlyRecipient() {
903         require(isRecipient(msg.sender));
904         _;
905     }
906 
907     function isRecipient(address account) public view returns (bool) {
908         return recipients.has(account);
909     }
910 
911     function renounceRecipient() public {
912         _removeRecipient(msg.sender);
913     }
914 
915     function _addRecipient(address account) internal {
916         recipients.add(account);
917         emit RecipientAdded(account);
918     }
919 
920     function _removeRecipient(address account) internal {
921         recipients.remove(account);
922         emit RecipientRemoved(account);
923     }
924 }
925 
926 // File: contracts/Fider.sol
927 
928 contract Fider is ERC20Detailed, ERC20Burnable, ERC20Capped, ERC20Pausable, AdminRole, SpenderRole, RecipientRole {
929     using SafeERC20 for IERC20;
930 
931     address private root;
932 
933     modifier onlyRoot() {
934         require(msg.sender == root, "This operation can only be performed by root account");
935         _;
936     }
937 
938     constructor(string name, string symbol, uint8 decimals, uint256 cap)
939     ERC20Detailed(name, symbol, decimals) ERC20Capped(cap) ERC20Mintable()  ERC20() public {
940         // Contract deployer (root) is automatically added as a minter in the MinterRole constructor
941         // We revert this in here in order to separate the responsibilities of Root and Minter
942         _removeMinter(msg.sender);
943 
944         // Contract deployer (root) is automatically added as a pauser in the PauserRole constructor
945         // We revert this in here in order to separate the responsibilities of Root and Pauser
946         _removePauser(msg.sender);
947 
948         root = msg.sender;
949     }
950 
951     /*** ACCESS CONTROL MANAGEMENT ***/
952 
953     /**
954     * This is particularly for the cases where there is a chance that the keys are compromised
955     * but no one has attacked/abused them yet, this function gives company the option to be on
956     * the safe side and start using another address.
957     * @dev Transfers control of the contract to a newRoot.
958     * @param _newRoot The address to transfer ownership to.
959     */
960     function transferRoot(address _newRoot) external onlyRoot {
961         require(_newRoot != address(0));
962         root = _newRoot;
963     }
964 
965     /**
966     * Designates a given account as an authorized Minter, where minter are the only ones who
967     * can call the mint function to create new tokens.
968     * This function can only be called by Root, which is the account who deployed the contract.
969     * @param account address The account who will be able to mint
970     */
971     function addMinter(address account) public onlyRoot {
972         _addMinter(account);
973     }
974 
975     /**
976     * Revokes a given account as an authorized Minter, where minter are the only ones who
977     * can call the mint function to create new tokens.
978     * This function can only be called by Root, which is the account who deployed the contract.
979     * @param account address The account who will not be able to mint anymore
980     */
981     function removeMinter(address account) external onlyRoot {
982         _removeMinter(account);
983     }
984 
985     /**
986     * Designates a given account as an authorized Pauser, where pausers are the only ones who
987     * can call the pause and unpause functions to freeze or unfreeze the transfer functions.
988     * This function can only be called by Root, which is the account who deployed the contract.
989     * @param account address The account who will be able to pause/unpause the token
990     */
991     function addPauser(address account) public onlyRoot {
992         _addPauser(account);
993     }
994 
995     /**
996     * Revokes a given account as an authorized Pauser, where pausers are the only ones who
997     * can call the pause and unpause functions to freeze or unfreeze the transfer functions.
998     * This function can only be called by Root, which is the account who deployed the contract.
999     * @param account address The account who will not be able to pause/unpause the token anymore
1000     */
1001     function removePauser(address account) external onlyRoot {
1002         _removePauser(account);
1003     }
1004 
1005     /**
1006     * Designates a given account as an authorized Admin, where admins are the only ones who
1007     * can call the addRecipient, removeRecipient, addSpender and removeSpender functions
1008     * to authorize or revoke spenders and recipients
1009     * This function can only be called by Root, which is the account who deployed the contract.
1010     * @param account address The account who will be able to administer spenders and recipients
1011     */
1012     function addAdmin(address account) external onlyRoot {
1013         _addAdmin(account);
1014     }
1015 
1016     /**
1017     * Revokes a given account as an authorized Admin, where admins are the only ones who
1018     * can call the addRecipient, removeRecipient, addSpender and removeSpender functions
1019     * to authorize or revoke spenders and recipients
1020     * This function can only be called by Root, which is the account who deployed the contract.
1021     * @param account address The account who will not be able to administer spenders and recipients anymore
1022     */
1023     function removeAdmin(address account) external onlyRoot {
1024         _removeAdmin(account);
1025     }
1026 
1027     /**
1028     * Designates a given account as an authorized Spender, where spenders are the only ones who
1029     * can call the transfer, approve, increaseAllowance, decreaseAllowance and transferFrom functions
1030     * to send tokens to other accounts
1031     * This function can only be called by an authorized admin
1032     * @param account address The account who will be able to send tokens
1033     */
1034     function addSpender(address account) external onlyAdmin {
1035         _addSpender(account);
1036     }
1037 
1038     /**
1039     * Revokes a given account as an authorized Spender, where spenders are the only ones who
1040     * can call the transfer, approve, increaseAllowance, decreaseAllowance and transferFrom functions
1041     * to send tokens to other accounts
1042     * This function can only be called by an authorized admin
1043     * @param account address The account who will not be able to send tokens anymore
1044     */
1045     function removeSpender(address account) external onlyAdmin {
1046         _removeSpender(account);
1047     }
1048 
1049     /**
1050     * Designates a given account as an authorized Recipient, where recipients are the only ones who
1051     * can be on the receiving end of a transfer, either through a normal transfer, or through a third
1052     * party payment process (approve/transferFrom or increaseAllowance/transferFrom)
1053     * This function can only be called by an authorized admin
1054     * @param account address The account who will be able to receive tokens
1055     */
1056     function addRecipient(address account) external onlyAdmin {
1057         _addRecipient(account);
1058     }
1059 
1060     /**
1061     * Revokes a given account as an authorized Recipient, where recipients are the only ones who
1062     * can be on the receiving end of a transfer, either through a normal transfer, or through a third
1063     * party payment process (approve/transferFrom or increaseAllowance/transferFrom)
1064     * This function can only be called by an authorized admin
1065     * @param account address The account who will not be able to receive tokens anymore
1066     */
1067     function removeRecipient(address account) external onlyAdmin {
1068         _removeRecipient(account);
1069     }
1070 
1071     /*** MINTING ***/
1072 
1073     /**
1074     * @dev Function to mint tokens
1075     * @param to The address that will receive the minted tokens. Must be an authorized spender.
1076     * @param value The amount of tokens to mint.
1077     * @return A boolean that indicates if the operation was successful.
1078     */
1079     function mint(address to, uint256 value) public onlyMinter returns (bool) {
1080         require(isSpender(to), "To must be an authorized spender");
1081         return super.mint(to, value);
1082     }
1083 
1084     /*** BURNING ***/
1085 
1086     /**
1087     * @dev Burns a specific amount of tokens from the target address and decrements allowance
1088     * This function can only be called by an authorized minter.
1089     * @param from address The address which you want to burn tokens from
1090     * @param value uint256 The amount of tokens to be burned
1091     */
1092     function burnFrom(address from, uint256 value) public onlyMinter {
1093         _burnFrom(from, value);
1094     }
1095 
1096     /*** TRANSFER ***/
1097 
1098     /**
1099     * @dev Transfer token for a specified address
1100     * This function can only be called by an authorized spender.
1101     * @param to The address to transfer to. Must be an authorized recipient.
1102     * @param value The amount to be transferred.
1103     */
1104     function transfer(address to, uint256 value) public onlySpender returns (bool) {
1105         require(isRecipient(to), "To must be an authorized recipient");
1106         return super.transfer(to, value);
1107     }
1108 
1109     /**
1110     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1111     * Beware that changing an allowance with this method brings the risk that someone may use both the old
1112     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1113     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1114     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1115     * This function can only be called by an authorized spender
1116     * @param spender The address which will spend the funds. Must be an authorized spender or minter.
1117     * @param value The amount of tokens to be spent.
1118     */
1119     function approve(address spender, uint256 value) public onlySpender returns (bool) {
1120         require(isSpender(spender) || isMinter(spender), "Spender must be an authorized spender or a minter");
1121         return super.approve(spender, value);
1122     }
1123 
1124     /**
1125     * @dev Transfer tokens from one address to another
1126     * This function can only be called by an authorized spender.
1127     * @param from address The address which you want to send tokens from. Must be an authorized spender.
1128     * @param to address The address which you want to transfer to. Must be an authorized recipient.
1129     * @param value uint256 the amount of tokens to be transferred
1130     */
1131     function transferFrom(address from, address to, uint256 value) public onlySpender returns (bool) {
1132         require(isSpender(from), "From must be an authorized spender");
1133         require(isRecipient(to), "To must be an authorized recipient");
1134         return super.transferFrom(from, to, value);
1135     }
1136 
1137     /**
1138     * @dev Increase the amount of tokens that an owner allowed to a spender.
1139     * approve should be called when allowed_[_spender] == 0. To increment
1140     * allowed value is better to use this function to avoid 2 calls (and wait until
1141     * the first transaction is mined)
1142     * From MonolithDAO Token.sol
1143     * This function can only be called by an authorized spender.
1144     * @param spender The address which will spend the funds. Must be an authorized spender or minter.
1145     * @param addedValue The amount of tokens to increase the allowance by.
1146     */
1147     function increaseAllowance(address spender, uint256 addedValue) public onlySpender returns (bool) {
1148         require(isSpender(spender) || isMinter(spender), "Spender must be an authorized spender or a minter");
1149         return super.increaseAllowance(spender, addedValue);
1150     }
1151 
1152     /**
1153      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1154      * approve should be called when allowed_[_spender] == 0. To decrement
1155      * allowed value is better to use this function to avoid 2 calls (and wait until
1156      * the first transaction is mined)
1157      * From MonolithDAO Token.sol
1158      * This function can only be called by an authorized spender.
1159      * @param spender The address which will spend the funds. Must be an authorized spender or minter.
1160      * @param subtractedValue The amount of tokens to decrease the allowance by.
1161      */
1162     function decreaseAllowance(address spender, uint256 subtractedValue) public onlySpender returns (bool) {
1163         require(isSpender(spender) || isMinter(spender), "Spender must be an authorized spender or a minter");
1164         return super.decreaseAllowance(spender, subtractedValue);
1165     }
1166 
1167     /** RECOVERING ASSETS MISTAKENLY SENT TO CONTRACT **/
1168 
1169     /**
1170     * @dev Disallows direct send by setting a default function without the `payable` flag.
1171     */
1172     function() external {
1173     }
1174 
1175     /**
1176     * @dev Transfer all Ether held by the contract to the root.
1177     */
1178     function reclaimEther() external onlyRoot {
1179         root.transfer(address(this).balance);
1180     }
1181 
1182     /**
1183     * @dev Reclaim all IERC20 compatible tokens
1184     * @param _token IERC20 The address of the token contract
1185     */
1186     function reclaimERC20Token(IERC20 _token) external onlyRoot {
1187         uint256 balance = _token.balanceOf(this);
1188         _token.safeTransfer(root, balance);
1189     }
1190 }