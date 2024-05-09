1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev give an account access to this role
14      */
15     function add(Role storage role, address account) internal {
16         require(account != address(0));
17         require(!has(role, account));
18 
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev remove an account's access to this role
24      */
25     function remove(Role storage role, address account) internal {
26         require(account != address(0));
27         require(has(role, account));
28 
29         role.bearer[account] = false;
30     }
31 
32     /**
33      * @dev check if an account has this role
34      * @return bool
35      */
36     function has(Role storage role, address account) internal view returns (bool) {
37         require(account != address(0));
38         return role.bearer[account];
39     }
40 }
41 
42 
43 /**
44  * @title ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/20
46  */
47 interface IERC20 {
48     function transfer(address to, uint256 value) external returns (bool);
49 
50     function approve(address spender, uint256 value) external returns (bool);
51 
52     function transferFrom(address from, address to, uint256 value) external returns (bool);
53 
54     function totalSupply() external view returns (uint256);
55 
56     function balanceOf(address who) external view returns (uint256);
57 
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 
66 
67 
68 contract PauserRole {
69     using Roles for Roles.Role;
70 
71     event PauserAdded(address indexed account);
72     event PauserRemoved(address indexed account);
73 
74     Roles.Role private _pausers;
75 
76     constructor () internal {
77         _addPauser(msg.sender);
78     }
79 
80     modifier onlyPauser() {
81         require(isPauser(msg.sender));
82         _;
83     }
84 
85     function isPauser(address account) public view returns (bool) {
86         return _pausers.has(account);
87     }
88 
89     function addPauser(address account) public onlyPauser {
90         _addPauser(account);
91     }
92 
93     function renouncePauser() public {
94         _removePauser(msg.sender);
95     }
96 
97     function _addPauser(address account) internal {
98         _pausers.add(account);
99         emit PauserAdded(account);
100     }
101 
102     function _removePauser(address account) internal {
103         _pausers.remove(account);
104         emit PauserRemoved(account);
105     }
106 }
107 
108 
109 
110 
111 
112 
113 
114 
115 
116 /**
117  * @title SafeMath
118  * @dev Unsigned math operations with safety checks that revert on error
119  */
120 library SafeMath {
121     /**
122     * @dev Multiplies two unsigned integers, reverts on overflow.
123     */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
126         // benefit is lost if 'b' is also tested.
127         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
128         if (a == 0) {
129             return 0;
130         }
131 
132         uint256 c = a * b;
133         require(c / a == b);
134 
135         return c;
136     }
137 
138     /**
139     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
140     */
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         // Solidity only automatically asserts when dividing by 0
143         require(b > 0);
144         uint256 c = a / b;
145         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147         return c;
148     }
149 
150     /**
151     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152     */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         require(b <= a);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161     * @dev Adds two unsigned integers, reverts on overflow.
162     */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a);
166 
167         return c;
168     }
169 
170     /**
171     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
172     * reverts when dividing by zero.
173     */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         require(b != 0);
176         return a % b;
177     }
178 }
179 
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
186  * Originally based on code by FirstBlood:
187  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  *
189  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
190  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
191  * compliant implementations may not do it.
192  */
193 contract ERC20 is IERC20 {
194     using SafeMath for uint256;
195 
196     mapping (address => uint256) private _balances;
197 
198     mapping (address => mapping (address => uint256)) private _allowed;
199 
200     uint256 private _totalSupply;
201 
202     /**
203     * @dev Total number of tokens in existence
204     */
205     function totalSupply() public view returns (uint256) {
206         return _totalSupply;
207     }
208 
209     /**
210     * @dev Gets the balance of the specified address.
211     * @param owner The address to query the balance of.
212     * @return An uint256 representing the amount owned by the passed address.
213     */
214     function balanceOf(address owner) public view returns (uint256) {
215         return _balances[owner];
216     }
217 
218     /**
219      * @dev Function to check the amount of tokens that an owner allowed to a spender.
220      * @param owner address The address which owns the funds.
221      * @param spender address The address which will spend the funds.
222      * @return A uint256 specifying the amount of tokens still available for the spender.
223      */
224     function allowance(address owner, address spender) public view returns (uint256) {
225         return _allowed[owner][spender];
226     }
227 
228     /**
229     * @dev Transfer token for a specified address
230     * @param to The address to transfer to.
231     * @param value The amount to be transferred.
232     */
233     function transfer(address to, uint256 value) public returns (bool) {
234         _transfer(msg.sender, to, value);
235         return true;
236     }
237 
238     /**
239      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240      * Beware that changing an allowance with this method brings the risk that someone may use both the old
241      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      * @param spender The address which will spend the funds.
245      * @param value The amount of tokens to be spent.
246      */
247     function approve(address spender, uint256 value) public returns (bool) {
248         require(spender != address(0));
249 
250         _allowed[msg.sender][spender] = value;
251         emit Approval(msg.sender, spender, value);
252         return true;
253     }
254 
255     /**
256      * @dev Transfer tokens from one address to another.
257      * Note that while this function emits an Approval event, this is not required as per the specification,
258      * and other compliant implementations may not emit the event.
259      * @param from address The address which you want to send tokens from
260      * @param to address The address which you want to transfer to
261      * @param value uint256 the amount of tokens to be transferred
262      */
263     function transferFrom(address from, address to, uint256 value) public returns (bool) {
264         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
265         _transfer(from, to, value);
266         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
267         return true;
268     }
269 
270     /**
271      * @dev Increase the amount of tokens that an owner allowed to a spender.
272      * approve should be called when allowed_[_spender] == 0. To increment
273      * allowed value is better to use this function to avoid 2 calls (and wait until
274      * the first transaction is mined)
275      * From MonolithDAO Token.sol
276      * Emits an Approval event.
277      * @param spender The address which will spend the funds.
278      * @param addedValue The amount of tokens to increase the allowance by.
279      */
280     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
281         require(spender != address(0));
282 
283         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
284         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
285         return true;
286     }
287 
288     /**
289      * @dev Decrease the amount of tokens that an owner allowed to a spender.
290      * approve should be called when allowed_[_spender] == 0. To decrement
291      * allowed value is better to use this function to avoid 2 calls (and wait until
292      * the first transaction is mined)
293      * From MonolithDAO Token.sol
294      * Emits an Approval event.
295      * @param spender The address which will spend the funds.
296      * @param subtractedValue The amount of tokens to decrease the allowance by.
297      */
298     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
299         require(spender != address(0));
300 
301         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
302         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
303         return true;
304     }
305 
306     /**
307     * @dev Transfer token for a specified addresses
308     * @param from The address to transfer from.
309     * @param to The address to transfer to.
310     * @param value The amount to be transferred.
311     */
312     function _transfer(address from, address to, uint256 value) internal {
313         require(to != address(0));
314 
315         _balances[from] = _balances[from].sub(value);
316         _balances[to] = _balances[to].add(value);
317         emit Transfer(from, to, value);
318     }
319 
320     /**
321      * @dev Internal function that mints an amount of the token and assigns it to
322      * an account. This encapsulates the modification of balances such that the
323      * proper events are emitted.
324      * @param account The account that will receive the created tokens.
325      * @param value The amount that will be created.
326      */
327     function _mint(address account, uint256 value) internal {
328         require(account != address(0));
329 
330         _totalSupply = _totalSupply.add(value);
331         _balances[account] = _balances[account].add(value);
332         emit Transfer(address(0), account, value);
333     }
334 
335     /**
336      * @dev Internal function that burns an amount of the token of a given
337      * account.
338      * @param account The account whose tokens will be burnt.
339      * @param value The amount that will be burnt.
340      */
341     function _burn(address account, uint256 value) internal {
342         require(account != address(0));
343 
344         _totalSupply = _totalSupply.sub(value);
345         _balances[account] = _balances[account].sub(value);
346         emit Transfer(account, address(0), value);
347     }
348 
349     /**
350      * @dev Internal function that burns an amount of the token of a given
351      * account, deducting from the sender's allowance for said account. Uses the
352      * internal burn function.
353      * Emits an Approval event (reflecting the reduced allowance).
354      * @param account The account whose tokens will be burnt.
355      * @param value The amount that will be burnt.
356      */
357     function _burnFrom(address account, uint256 value) internal {
358         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
359         _burn(account, value);
360         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
361     }
362 }
363 
364 
365 
366 
367 
368 /**
369  * @title Pausable
370  * @dev Base contract which allows children to implement an emergency stop mechanism.
371  */
372 contract Pausable is PauserRole {
373     event Paused(address account);
374     event Unpaused(address account);
375 
376     bool private _paused;
377 
378     constructor () internal {
379         _paused = false;
380     }
381 
382     /**
383      * @return true if the contract is paused, false otherwise.
384      */
385     function paused() public view returns (bool) {
386         return _paused;
387     }
388 
389     /**
390      * @dev Modifier to make a function callable only when the contract is not paused.
391      */
392     modifier whenNotPaused() {
393         require(!_paused);
394         _;
395     }
396 
397     /**
398      * @dev Modifier to make a function callable only when the contract is paused.
399      */
400     modifier whenPaused() {
401         require(_paused);
402         _;
403     }
404 
405     /**
406      * @dev called by the owner to pause, triggers stopped state
407      */
408     function pause() public onlyPauser whenNotPaused {
409         _paused = true;
410         emit Paused(msg.sender);
411     }
412 
413     /**
414      * @dev called by the owner to unpause, returns to normal state
415      */
416     function unpause() public onlyPauser whenPaused {
417         _paused = false;
418         emit Unpaused(msg.sender);
419     }
420 }
421 
422 
423 /**
424  * @title Pausable token
425  * @dev ERC20 modified with pausable transfers.
426  **/
427 contract ERC20Pausable is ERC20, Pausable {
428     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
429         return super.transfer(to, value);
430     }
431 
432     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
433         return super.transferFrom(from, to, value);
434     }
435 
436     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
437         return super.approve(spender, value);
438     }
439 
440     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
441         return super.increaseAllowance(spender, addedValue);
442     }
443 
444     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
445         return super.decreaseAllowance(spender, subtractedValue);
446     }
447 }
448 
449 
450 
451 
452 
453 /**
454  * @title ERC20Detailed token
455  * @dev The decimals are only for visualization purposes.
456  * All the operations are done using the smallest and indivisible token unit,
457  * just as on Ethereum all the operations are done in wei.
458  */
459 contract ERC20Detailed is IERC20 {
460     string private _name;
461     string private _symbol;
462     uint8 private _decimals;
463 
464     constructor (string memory name, string memory symbol, uint8 decimals) public {
465         _name = name;
466         _symbol = symbol;
467         _decimals = decimals;
468     }
469 
470     /**
471      * @return the name of the token.
472      */
473     function name() public view returns (string memory) {
474         return _name;
475     }
476 
477     /**
478      * @return the symbol of the token.
479      */
480     function symbol() public view returns (string memory) {
481         return _symbol;
482     }
483 
484     /**
485      * @return the number of decimals of the token.
486      */
487     function decimals() public view returns (uint8) {
488         return _decimals;
489     }
490 }
491 
492 
493 
494 
495 
496 /**
497  * @title Ownable
498  * @dev The Ownable contract has an owner address, and provides basic authorization control
499  * functions, this simplifies the implementation of "user permissions".
500  */
501 contract Ownable {
502     address private _owner;
503 
504     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
505 
506     /**
507      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
508      * account.
509      */
510     constructor () internal {
511         _owner = msg.sender;
512         emit OwnershipTransferred(address(0), _owner);
513     }
514 
515     /**
516      * @return the address of the owner.
517      */
518     function owner() public view returns (address) {
519         return _owner;
520     }
521 
522     /**
523      * @dev Throws if called by any account other than the owner.
524      */
525     modifier onlyOwner() {
526         require(isOwner());
527         _;
528     }
529 
530     /**
531      * @return true if `msg.sender` is the owner of the contract.
532      */
533     function isOwner() public view returns (bool) {
534         return msg.sender == _owner;
535     }
536 
537     /**
538      * @dev Allows the current owner to relinquish control of the contract.
539      * @notice Renouncing to ownership will leave the contract without an owner.
540      * It will not be possible to call the functions with the `onlyOwner`
541      * modifier anymore.
542      */
543     function renounceOwnership() public onlyOwner {
544         emit OwnershipTransferred(_owner, address(0));
545         _owner = address(0);
546     }
547 
548     /**
549      * @dev Allows the current owner to transfer control of the contract to a newOwner.
550      * @param newOwner The address to transfer ownership to.
551      */
552     function transferOwnership(address newOwner) public onlyOwner {
553         _transferOwnership(newOwner);
554     }
555 
556     /**
557      * @dev Transfers control of the contract to a newOwner.
558      * @param newOwner The address to transfer ownership to.
559      */
560     function _transferOwnership(address newOwner) internal {
561         require(newOwner != address(0));
562         emit OwnershipTransferred(_owner, newOwner);
563         _owner = newOwner;
564     }
565 }
566 
567 
568 contract BNDESRegistry is Ownable() {
569 
570     /**
571         The account of clients and suppliers are assigned to states. 
572         Reserved accounts (e.g. from BNDES and ANCINE) do not have state.
573         AVAILABLE - The account is not yet assigned any role (any of them - client, supplier or any reserved addresses).
574         WAITING_VALIDATION - The account was linked to a legal entity but it still needs to be validated
575         VALIDATED - The account was validated
576         INVALIDATED_BY_VALIDATOR - The account was invalidated
577         INVALIDATED_BY_CHANGE - The client or supplier changed the ethereum account so the original one must be invalidated.
578      */
579     enum BlockchainAccountState {AVAILABLE,WAITING_VALIDATION,VALIDATED,INVALIDATED_BY_VALIDATOR,INVALIDATED_BY_CHANGE} 
580     BlockchainAccountState blockchainState; //Not used. Defined to create the enum type.
581 
582     address responsibleForSettlement;
583     address responsibleForRegistryValidation;
584     address responsibleForDisbursement;
585     address redemptionAddress;
586     address tokenAddress;
587 
588     /**
589         Describes the Legal Entity - clients or suppliers
590      */
591     struct LegalEntityInfo {
592         uint64 cnpj; //Brazilian identification of legal entity
593         uint64 idFinancialSupportAgreement; //SCC contract
594         uint32 salic; //ANCINE identifier
595         string idProofHash; //hash of declaration
596         BlockchainAccountState state;
597     } 
598 
599     /**
600         Links Ethereum addresses to LegalEntityInfo        
601      */
602     mapping(address => LegalEntityInfo) public legalEntitiesInfo;
603 
604     /**
605         Links Legal Entity to Ethereum address. 
606         cnpj => (idFinancialSupportAgreement => address)
607      */
608     mapping(uint64 => mapping(uint64 => address)) cnpjFSAddr; 
609 
610 
611     /**
612         Links Ethereum addresses to the possibility to change the account
613         Since the Ethereum account can be changed once, it is not necessary to put the bool to false.
614         TODO: Discuss later what is the best data structure
615      */
616     mapping(address => bool) public legalEntitiesChangeAccount;
617 
618 
619     event AccountRegistration(address addr, uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, string idProofHash);
620     event AccountChange(address oldAddr, address newAddr, uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, string idProofHash);
621     event AccountValidation(address addr, uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic);
622     event AccountInvalidation(address addr, uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic);
623 
624     /**
625      * @dev Throws if called by any account other than the token address.
626      */
627     modifier onlyTokenAddress() {
628         require(isTokenAddress());
629         _;
630     }
631 
632     constructor () public {
633         responsibleForSettlement = msg.sender;
634         responsibleForRegistryValidation = msg.sender;
635         responsibleForDisbursement = msg.sender;
636         redemptionAddress = msg.sender;
637     }
638 
639 
640    /**
641     * Link blockchain address with CNPJ - It can be a cliente or a supplier
642     * The link still needs to be validated by BNDES
643     * This method can only be called by BNDESToken contract because BNDESToken can pause.
644     * @param cnpj Brazilian identifier to legal entities
645     * @param idFinancialSupportAgreement contract number of financial contract with BNDES. It assumes 0 if it is a supplier.
646     * @param salic contract number of financial contract with ANCINE. It assumes 0 if it is a supplier.
647     * @param addr the address to be associated with the legal entity.
648     * @param idProofHash The legal entities have to send BNDES a PDF where it assumes as responsible for an Ethereum account. 
649     *                   This PDF is signed with eCNPJ and send to BNDES. 
650     */
651     function registryLegalEntity(uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, 
652         address addr, string memory idProofHash) onlyTokenAddress public { 
653 
654         // Endereço não pode ter sido cadastrado anteriormente
655         require (isAvailableAccount(addr), "Endereço não pode ter sido cadastrado anteriormente");
656 
657         require (isValidHash(idProofHash), "O hash da declaração é inválido");
658 
659         legalEntitiesInfo[addr] = LegalEntityInfo(cnpj, idFinancialSupportAgreement, salic, idProofHash, BlockchainAccountState.WAITING_VALIDATION);
660         
661         // Não pode haver outro endereço cadastrado para esse mesmo subcrédito
662         if (idFinancialSupportAgreement > 0) {
663             address account = getBlockchainAccount(cnpj,idFinancialSupportAgreement);
664             require (isAvailableAccount(account), "Cliente já está associado a outro endereço. Use a função Troca.");
665         }
666         else {
667             address account = getBlockchainAccount(cnpj,0);
668             require (isAvailableAccount(account), "Fornecedor já está associado a outro endereço. Use a função Troca.");
669         }
670         
671         cnpjFSAddr[cnpj][idFinancialSupportAgreement] = addr;
672 
673         emit AccountRegistration(addr, cnpj, idFinancialSupportAgreement, salic, idProofHash);
674     }
675 
676    /**
677     * Changes the original link between CNPJ and Ethereum account. 
678     * The new link still needs to be validated by BNDES.
679     * This method can only be called by BNDESToken contract because BNDESToken can pause and because there are 
680     * additional instructions there.
681     * @param cnpj Brazilian identifier to legal entities
682     * @param idFinancialSupportAgreement contract number of financial contract with BNDES. It assumes 0 if it is a supplier.
683     * @param salic contract number of financial contract with ANCINE. It assumes 0 if it is a supplier.
684     * @param newAddr the new address to be associated with the legal entity
685     * @param idProofHash The legal entities have to send BNDES a PDF where it assumes as responsible for an Ethereum account. 
686     *                   This PDF is signed with eCNPJ and send to BNDES. 
687     */
688     function changeAccountLegalEntity(uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, 
689         address newAddr, string memory idProofHash) onlyTokenAddress public {
690 
691         address oldAddr = getBlockchainAccount(cnpj, idFinancialSupportAgreement);
692     
693         // Tem que haver um endereço associado a esse cnpj/subcrédito
694         require(!isReservedAccount(oldAddr), "Não pode trocar endereço de conta reservada");
695 
696         require(!isAvailableAccount(oldAddr), "Tem que haver um endereço associado a esse cnpj/subcrédito");
697 
698         require(isAvailableAccount(newAddr), "Novo endereço não está disponível");
699 
700         require (isChangeAccountEnabled(oldAddr), "A conta atual não está habilitada para troca");
701 
702         require (isValidHash(idProofHash), "O hash da declaração é inválido");        
703 
704         require(legalEntitiesInfo[oldAddr].cnpj==cnpj 
705                     && legalEntitiesInfo[oldAddr].idFinancialSupportAgreement ==idFinancialSupportAgreement, 
706                     "Dados inconsistentes de cnpj ou subcrédito");
707 
708         // Aponta o novo endereço para o novo LegalEntityInfo
709         legalEntitiesInfo[newAddr] = LegalEntityInfo(cnpj, idFinancialSupportAgreement, salic, idProofHash, BlockchainAccountState.WAITING_VALIDATION);
710 
711         // Apaga o mapping do endereço antigo
712         legalEntitiesInfo[oldAddr].state = BlockchainAccountState.INVALIDATED_BY_CHANGE;
713 
714         // Aponta mapping CNPJ e Subcredito para newAddr
715         cnpjFSAddr[cnpj][idFinancialSupportAgreement] = newAddr;
716 
717         emit AccountChange(oldAddr, newAddr, cnpj, idFinancialSupportAgreement, salic, idProofHash); 
718 
719     }
720 
721    /**
722     * Validates the initial registry of a legal entity or the change of its registry
723     * @param addr Ethereum address that needs to be validated
724     * @param idProofHash The legal entities have to send BNDES a PDF where it assumes as responsible for an Ethereum account. 
725     *                   This PDF is signed with eCNPJ and send to BNDES. 
726     */
727     function validateRegistryLegalEntity(address addr, string memory idProofHash) public {
728 
729         require(isResponsibleForRegistryValidation(msg.sender), "Somente o responsável pela validação pode validar contas");
730 
731         require(legalEntitiesInfo[addr].state == BlockchainAccountState.WAITING_VALIDATION, "A conta precisa estar no estado Aguardando Validação");
732 
733         require(keccak256(abi.encodePacked(legalEntitiesInfo[addr].idProofHash)) == keccak256(abi.encodePacked(idProofHash)), "O hash recebido é diferente do esperado");
734 
735         legalEntitiesInfo[addr].state = BlockchainAccountState.VALIDATED;
736 
737         emit AccountValidation(addr, legalEntitiesInfo[addr].cnpj, 
738             legalEntitiesInfo[addr].idFinancialSupportAgreement,
739             legalEntitiesInfo[addr].salic);
740     }
741 
742    /**
743     * Invalidates the initial registry of a legal entity or the change of its registry
744     * The invalidation can be called at any time in the lifecycle of the address (not only when it is WAITING_VALIDATION)
745     * @param addr Ethereum address that needs to be validated
746     */
747     function invalidateRegistryLegalEntity(address addr) public {
748 
749         require(isResponsibleForRegistryValidation(msg.sender), "Somente o responsável pela validação pode invalidar contas");
750 
751         require(!isReservedAccount(addr), "Não é possível invalidar conta reservada");
752 
753         legalEntitiesInfo[addr].state = BlockchainAccountState.INVALIDATED_BY_VALIDATOR;
754         
755         emit AccountInvalidation(addr, legalEntitiesInfo[addr].cnpj, 
756             legalEntitiesInfo[addr].idFinancialSupportAgreement,
757             legalEntitiesInfo[addr].salic);
758     }
759 
760 
761    /**
762     * By default, the owner is also the Responsible for Settlement. 
763     * The owner can assign other address to be the Responsible for Settlement. 
764     * @param rs Ethereum address to be assigned as Responsible for Settlement.
765     */
766     function setResponsibleForSettlement(address rs) onlyOwner public {
767         responsibleForSettlement = rs;
768     }
769 
770    /**
771     * By default, the owner is also the Responsible for Validation. 
772     * The owner can assign other address to be the Responsible for Validation. 
773     * @param rs Ethereum address to be assigned as Responsible for Validation.
774     */
775     function setResponsibleForRegistryValidation(address rs) onlyOwner public {
776         responsibleForRegistryValidation = rs;
777     }
778 
779    /**
780     * By default, the owner is also the Responsible for Disbursment. 
781     * The owner can assign other address to be the Responsible for Disbursment. 
782     * @param rs Ethereum address to be assigned as Responsible for Disbursment.
783     */
784     function setResponsibleForDisbursement(address rs) onlyOwner public {
785         responsibleForDisbursement = rs;
786     }
787 
788    /**
789     * The supplier reedems the BNDESToken by transfering the tokens to a specific address, 
790     * called Redemption address. 
791     * By default, the redemption address is the address of the owner. 
792     * The owner can change the redemption address using this function. 
793     * @param rs new Redemption address
794     */
795     function setRedemptionAddress(address rs) onlyOwner public {
796         redemptionAddress = rs;
797     }
798 
799    /**
800     * @param rs Ethereum address to be assigned to the token address.
801     */
802     function setTokenAddress(address rs) onlyOwner public {
803         tokenAddress = rs;
804     }
805 
806    /**
807     * Enable the legal entity to change the account
808     * @param rs account that can be changed.
809     */
810     function enableChangeAccount (address rs) public {
811         require(isResponsibleForRegistryValidation(msg.sender), "Somente o responsável pela validação pode habilitar a troca de conta");
812         legalEntitiesChangeAccount[rs] = true;
813     }
814 
815     function isChangeAccountEnabled (address rs) view public returns (bool) {
816         return legalEntitiesChangeAccount[rs] == true;
817     }    
818 
819     function isTokenAddress() public view returns (bool) {
820         return tokenAddress == msg.sender;
821     } 
822     function isResponsibleForSettlement(address addr) view public returns (bool) {
823         return (addr == responsibleForSettlement);
824     }
825     function isResponsibleForRegistryValidation(address addr) view public returns (bool) {
826         return (addr == responsibleForRegistryValidation);
827     }
828     function isResponsibleForDisbursement(address addr) view public returns (bool) {
829         return (addr == responsibleForDisbursement);
830     }
831     function isRedemptionAddress(address addr) view public returns (bool) {
832         return (addr == redemptionAddress);
833     }
834 
835     function isReservedAccount(address addr) view public returns (bool) {
836 
837         if (isOwner(addr) || isResponsibleForSettlement(addr) 
838                            || isResponsibleForRegistryValidation(addr)
839                            || isResponsibleForDisbursement(addr)
840                            || isRedemptionAddress(addr) ) {
841             return true;
842         }
843         return false;
844     }
845     function isOwner(address addr) view public returns (bool) {
846         return owner()==addr;
847     }
848 
849     function isSupplier(address addr) view public returns (bool) {
850 
851         if (isReservedAccount(addr))
852             return false;
853 
854         if (isAvailableAccount(addr))
855             return false;
856 
857         return legalEntitiesInfo[addr].idFinancialSupportAgreement == 0;
858     }
859 
860     function isValidatedSupplier (address addr) view public returns (bool) {
861         return isSupplier(addr) && (legalEntitiesInfo[addr].state == BlockchainAccountState.VALIDATED);
862     }
863 
864     function isClient (address addr) view public returns (bool) {
865         if (isReservedAccount(addr)) {
866             return false;
867         }
868         return legalEntitiesInfo[addr].idFinancialSupportAgreement != 0;
869     }
870 
871     function isValidatedClient (address addr) view public returns (bool) {
872         return isClient(addr) && (legalEntitiesInfo[addr].state == BlockchainAccountState.VALIDATED);
873     }
874 
875     function isAvailableAccount(address addr) view public returns (bool) {
876         if ( isReservedAccount(addr) ) {
877             return false;
878         } 
879         return legalEntitiesInfo[addr].state == BlockchainAccountState.AVAILABLE;
880     }
881 
882     function isWaitingValidationAccount(address addr) view public returns (bool) {
883         return legalEntitiesInfo[addr].state == BlockchainAccountState.WAITING_VALIDATION;
884     }
885 
886     function isValidatedAccount(address addr) view public returns (bool) {
887         return legalEntitiesInfo[addr].state == BlockchainAccountState.VALIDATED;
888     }
889 
890     function isInvalidatedByValidatorAccount(address addr) view public returns (bool) {
891         return legalEntitiesInfo[addr].state == BlockchainAccountState.INVALIDATED_BY_VALIDATOR;
892     }
893 
894     function isInvalidatedByChangeAccount(address addr) view public returns (bool) {
895         return legalEntitiesInfo[addr].state == BlockchainAccountState.INVALIDATED_BY_CHANGE;
896     }
897 
898     function getResponsibleForSettlement() view public returns (address) {
899         return responsibleForSettlement;
900     }
901     function getResponsibleForRegistryValidation() view public returns (address) {
902         return responsibleForRegistryValidation;
903     }
904     function getResponsibleForDisbursement() view public returns (address) {
905         return responsibleForDisbursement;
906     }
907     function getRedemptionAddress() view public returns (address) {
908         return redemptionAddress;
909     }
910     function getCNPJ(address addr) view public returns (uint64) {
911         return legalEntitiesInfo[addr].cnpj;
912     }
913 
914     function getIdLegalFinancialAgreement(address addr) view public returns (uint64) {
915         return legalEntitiesInfo[addr].idFinancialSupportAgreement;
916     }
917 
918     function getLegalEntityInfo (address addr) view public returns (uint64, uint64, uint32, string memory, uint, address) {
919         return (legalEntitiesInfo[addr].cnpj, legalEntitiesInfo[addr].idFinancialSupportAgreement, 
920              legalEntitiesInfo[addr].salic, legalEntitiesInfo[addr].idProofHash, (uint) (legalEntitiesInfo[addr].state),
921              addr);
922     }
923 
924     function getBlockchainAccount(uint64 cnpj, uint64 idFinancialSupportAgreement) view public returns (address) {
925         return cnpjFSAddr[cnpj][idFinancialSupportAgreement];
926     }
927 
928     function getLegalEntityInfoByCNPJ (uint64 cnpj, uint64 idFinancialSupportAgreement) 
929         view public returns (uint64, uint64, uint32, string memory, uint, address) {
930         
931         address addr = getBlockchainAccount(cnpj,idFinancialSupportAgreement);
932         return getLegalEntityInfo (addr);
933     }
934 
935     function getAccountState(address addr) view public returns (int) {
936 
937         if ( isReservedAccount(addr) ) {
938             return 100;
939         } 
940         else {
941             return ((int) (legalEntitiesInfo[addr].state));
942         }
943 
944     }
945 
946 
947   function isValidHash(string memory str) pure public returns (bool)  {
948 
949     bytes memory b = bytes(str);
950     if(b.length != 64) return false;
951 
952     for (uint i=0; i<64; i++) {
953         if (b[i] < "0") return false;
954         if (b[i] > "9" && b[i] <"a") return false;
955         if (b[i] > "f") return false;
956     }
957         
958     return true;
959  }
960 
961 
962 }
963 
964 
965 contract BNDESToken is ERC20Pausable, ERC20Detailed("BNDESToken", "BND", 2) {
966 
967     uint private version = 20190517;
968 
969     BNDESRegistry registry;
970 
971     event BNDESTokenDisbursement(uint64 cnpj, uint64 idFinancialSupportAgreement, uint256 value);
972     event BNDESTokenTransfer(uint64 fromCnpj, uint64 fromIdFinancialSupportAgreement, uint64 toCnpj, uint256 value);
973     event BNDESTokenRedemption(uint64 cnpj, uint256 value);
974     event BNDESTokenRedemptionSettlement(string redemptionTransactionHash, string receiptHash);
975     event BNDESManualIntervention(string description);
976 
977     /**
978      * @dev Throws if called by any account other than the owner.
979      */
980     modifier onlyOwner() {
981         require(isOwner());
982         _;
983     }
984 
985     constructor (address newRegistryAddr) public {
986         registry = BNDESRegistry(newRegistryAddr);
987     }
988 
989 
990     function getVersion() view public returns (uint) {
991         return version;
992     }
993 
994 
995    /**
996     * The transfer funcion follows ERC20 token signature. 
997     * Using them, it is possible to disburse money to the client, transfer from client to supplier and redeem.
998     * @param to the Ethereum address to where the money should be sent
999     * @param value how much BNDESToken the supplier wants to redeem
1000     */
1001     function transfer (address to, uint256 value) public whenNotPaused returns (bool) {
1002 
1003         address from = msg.sender;
1004 
1005         require(from != to, "Não pode transferir token para si mesmo");
1006 
1007         if (registry.isResponsibleForDisbursement(from)) {
1008 
1009             require(registry.isValidatedClient(to), "O endereço não pertence a um cliente ou não está validada");
1010 
1011             _mint(to, value);
1012 
1013             emit BNDESTokenDisbursement(registry.getCNPJ(to), registry.getIdLegalFinancialAgreement(to), value);
1014 
1015         } else { 
1016 
1017             if (registry.isRedemptionAddress(to)) { 
1018 
1019                 require(registry.isValidatedSupplier(from), "A conta do endereço não pertence a um fornecedor ou não está validada");
1020 
1021                 _burn(from, value);
1022 
1023                 emit BNDESTokenRedemption(registry.getCNPJ(from), value);
1024 
1025             } else {
1026 
1027                 // Se nem from nem to são o Banco, eh transferencia normal
1028 
1029                 require(registry.isValidatedClient(from), "O endereço não pertence a um cliente ou não está validada");
1030                 require(registry.isValidatedSupplier(to), "A conta do endereço não pertence a um fornecedor ou não está validada");
1031 
1032                 _transfer(msg.sender, to, value);
1033 
1034                 emit BNDESTokenTransfer(registry.getCNPJ(from), registry.getIdLegalFinancialAgreement(from), 
1035                                 registry.getCNPJ(to), value);
1036   
1037             }
1038         }
1039 
1040         return true;
1041     }
1042 
1043    /**
1044     * When redeeming, the supplier indicated to the Resposible for Settlement that he wants to receive 
1045     * the FIAT money.
1046     * @param value - how much BNDESToken the supplier wants to redeem
1047     */
1048     function redeem (uint256 value) public whenNotPaused returns (bool) {
1049         return transfer(registry.getRedemptionAddress(), value);
1050     }
1051 
1052    /**
1053     * Using this function, the Responsible for Settlement indicates that he has made the FIAT money transfer.
1054     * @param redemptionTransactionHash hash of the redeem transaction in which the FIAT money settlement occurred.
1055     * @param receiptHash hash that proof the FIAT money transfer
1056     */
1057     function notifyRedemptionSettlement(string memory redemptionTransactionHash, string memory receiptHash) 
1058         public whenNotPaused {
1059         require (registry.isResponsibleForSettlement(msg.sender), "A liquidação só não pode ser realizada pelo endereço que submeteu a transação"); 
1060         require (registry.isValidHash(receiptHash), "O hash do recibo é inválido");
1061         emit BNDESTokenRedemptionSettlement(redemptionTransactionHash, receiptHash);
1062     }
1063 
1064 
1065     function registryLegalEntity(uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, string memory idProofHash) 
1066         public whenNotPaused { 
1067         registry.registryLegalEntity(cnpj,  idFinancialSupportAgreement, salic, msg.sender, idProofHash);
1068     }
1069 
1070    /**
1071     * Changes the original link between CNPJ and Ethereum account. 
1072     * The new link still needs to be validated by BNDES.
1073     * IMPORTANT: The BNDESTOKENs are transfered from the original to the new Ethereum address 
1074     * @param cnpj Brazilian identifier to legal entities
1075     * @param idFinancialSupportAgreement contract number of financial contract with BNDES. It assumes 0 if it is a supplier.
1076     * @param salic contract number of financial contract with ANCINE. It assumes 0 if it is a supplier.
1077     * @param idProofHash The legal entities have to send BNDES a PDF where it assumes as responsible for an Ethereum account. 
1078     *                   This PDF is signed with eCNPJ and send to BNDES. 
1079     */
1080     function changeAccountLegalEntity(uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, string memory idProofHash) 
1081         public whenNotPaused {
1082         
1083         address oldAddr = registry.getBlockchainAccount(cnpj, idFinancialSupportAgreement);
1084         address newAddr = msg.sender;
1085         
1086         registry.changeAccountLegalEntity(cnpj, idFinancialSupportAgreement, salic, msg.sender, idProofHash);
1087 
1088         // Se há saldo no enderecoAntigo, precisa transferir
1089         if (balanceOf(oldAddr) > 0) {
1090             _transfer(oldAddr, newAddr, balanceOf(oldAddr));
1091         }
1092 
1093     }
1094 
1095     //These methods may be necessary to solve incidents.
1096     function burn(address from, uint256 value, string memory description) public onlyOwner {
1097         _burn(from, value);
1098         emit BNDESManualIntervention(description);        
1099     }
1100 
1101     //These methods may be necessary to solve incidents.
1102     function mint(address to, uint256 value, string memory description) public onlyOwner {
1103         _mint(to, value);
1104         emit BNDESManualIntervention(description);        
1105     }
1106 
1107     function isOwner() public view returns (bool) {
1108         return registry.owner() == msg.sender;
1109     } 
1110 
1111     //Unsupported methods - created to avoid call the lib functions by overriding them
1112     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
1113         require(false, "Unsupported method - transferFrom");
1114     }
1115 
1116     //Unsupported methods - created to avoid call the lib functions by overriding them
1117     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
1118         require(false, "Unsupported method - approve");
1119     }
1120 
1121     //Unsupported methods - created to avoid call the lib functions by overriding them
1122     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
1123         require(false, "Unsupported method - increaseAllowance");
1124     }
1125 
1126     //Unsupported methods - created to avoid call the lib functions by overriding them
1127     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
1128         require(false, "Unsupported method - decreaseAllowance");
1129     }
1130 
1131 
1132 
1133 }