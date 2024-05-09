1 // File: contracts/ownership/Ownable.sol
2 
3 pragma solidity 0.4.25;
4 
5 /// @title Ownable
6 /// @dev Provide a simple access control with a single authority: the owner
7 contract Ownable {
8 
9     // Ethereum address of current owner
10     address public owner;
11 
12     // Ethereum address of the next owner
13     // (has to claim ownership first to become effective owner)
14     address public newOwner;
15 
16     // @dev Log event on ownership transferred
17     // @param previousOwner Ethereum address of previous owner
18     // @param newOwner Ethereum address of new owner
19     event OwnershipTransferred(
20         address indexed previousOwner,
21         address indexed newOwner
22     );
23 
24     /// @dev Forbid call by anyone but owner
25     modifier onlyOwner() {
26         require(msg.sender == owner, "Restricted to owner");
27         _;
28     }
29 
30     /// @dev Deployer account becomes initial owner
31     constructor() public {
32         owner = msg.sender;
33     }
34 
35     /// @dev  Transfer ownership to a new Ethereum account (safe method)
36     ///       Note: the new owner has to claim his ownership to become effective owner.
37     /// @param _newOwner  Ethereum address to transfer ownership to
38     function transferOwnership(address _newOwner) public onlyOwner {
39         require(_newOwner != address(0x0), "New owner is zero");
40 
41         newOwner = _newOwner;
42     }
43 
44     /// @dev  Transfer ownership to a new Ethereum account (unsafe method)
45     ///       Note: It's strongly recommended to use the safe variant via transferOwnership
46     ///             and claimOwnership, to prevent accidental transfers to a wrong address.
47     /// @param _newOwner  Ethereum address to transfer ownership to
48     function transferOwnershipUnsafe(address _newOwner) public onlyOwner {
49         require(_newOwner != address(0x0), "New owner is zero");
50 
51         _transferOwnership(_newOwner);
52     }
53 
54     /// @dev  Become effective owner (if dedicated so by previous owner)
55     function claimOwnership() public {
56         require(msg.sender == newOwner, "Restricted to new owner");
57 
58         _transferOwnership(msg.sender);
59     }
60 
61     /// @dev  Transfer ownership (internal method)
62     /// @param _newOwner  Ethereum address to transfer ownership to
63     function _transferOwnership(address _newOwner) private {
64         if (_newOwner != owner) {
65             emit OwnershipTransferred(owner, _newOwner);
66 
67             owner = _newOwner;
68         }
69     }
70 
71 }
72 
73 // File: contracts/whitelist/Whitelist.sol
74 
75 pragma solidity 0.4.25;
76 
77 
78 
79 /// @title Whitelist
80 /// @author STOKR
81 contract Whitelist is Ownable {
82 
83     // Set of admins
84     mapping(address => bool) public admins;
85 
86     // Set of Whitelisted addresses
87     mapping(address => bool) public isWhitelisted;
88 
89     /// @dev Log entry on admin added to set
90     /// @param admin An Ethereum address
91     event AdminAdded(address indexed admin);
92 
93     /// @dev Log entry on admin removed from set
94     /// @param admin An Ethereum address
95     event AdminRemoved(address indexed admin);
96 
97     /// @dev Log entry on investor added set
98     /// @param admin An Ethereum address
99     /// @param investor An Ethereum address
100     event InvestorAdded(address indexed admin, address indexed investor);
101 
102     /// @dev Log entry on investor removed from set
103     /// @param admin An Ethereum address
104     /// @param investor An Ethereum address
105     event InvestorRemoved(address indexed admin, address indexed investor);
106 
107     /// @dev Only admin
108     modifier onlyAdmin() {
109         require(admins[msg.sender], "Restricted to whitelist admin");
110         _;
111     }
112 
113     /// @dev Add admin to set
114     /// @param _admin An Ethereum address
115     function addAdmin(address _admin) public onlyOwner {
116         require(_admin != address(0x0), "Whitelist admin is zero");
117 
118         if (!admins[_admin]) {
119             admins[_admin] = true;
120 
121             emit AdminAdded(_admin);
122         }
123     }
124 
125     /// @dev Remove admin from set
126     /// @param _admin An Ethereum address
127     function removeAdmin(address _admin) public onlyOwner {
128         require(_admin != address(0x0), "Whitelist admin is zero");  // Necessary?
129 
130         if (admins[_admin]) {
131             admins[_admin] = false;
132 
133             emit AdminRemoved(_admin);
134         }
135     }
136 
137     /// @dev Add investor to set of whitelisted addresses
138     /// @param _investors A list where each entry is an Ethereum address
139     function addToWhitelist(address[] _investors) external onlyAdmin {
140         for (uint256 i = 0; i < _investors.length; i++) {
141             if (!isWhitelisted[_investors[i]]) {
142                 isWhitelisted[_investors[i]] = true;
143 
144                 emit InvestorAdded(msg.sender, _investors[i]);
145             }
146         }
147     }
148 
149     /// @dev Remove investor from set of whitelisted addresses
150     /// @param _investors A list where each entry is an Ethereum address
151     function removeFromWhitelist(address[] _investors) external onlyAdmin {
152         for (uint256 i = 0; i < _investors.length; i++) {
153             if (isWhitelisted[_investors[i]]) {
154                 isWhitelisted[_investors[i]] = false;
155 
156                 emit InvestorRemoved(msg.sender, _investors[i]);
157             }
158         }
159     }
160 
161 }
162 
163 // File: contracts/whitelist/Whitelisted.sol
164 
165 pragma solidity 0.4.25;
166 
167 
168 
169 
170 /// @title Whitelisted
171 /// @author STOKR
172 contract Whitelisted is Ownable {
173 
174     Whitelist public whitelist;
175 
176     /// @dev  Log entry on change of whitelist contract instance
177     /// @param previous  Ethereum address of previous whitelist
178     /// @param current   Ethereum address of new whitelist
179     event WhitelistChange(address indexed previous, address indexed current);
180 
181     /// @dev Ensure only whitelisted addresses can call
182     modifier onlyWhitelisted(address _address) {
183         require(whitelist.isWhitelisted(_address), "Address is not whitelisted");
184         _;
185     }
186 
187     /// @dev Constructor
188     /// @param _whitelist address of whitelist contract
189     constructor(Whitelist _whitelist) public {
190         setWhitelist(_whitelist);
191     }
192 
193     /// @dev Set the address of whitelist
194     /// @param _newWhitelist An Ethereum address
195     function setWhitelist(Whitelist _newWhitelist) public onlyOwner {
196         require(address(_newWhitelist) != address(0x0), "Whitelist address is zero");
197 
198         if (address(_newWhitelist) != address(whitelist)) {
199             emit WhitelistChange(address(whitelist), address(_newWhitelist));
200 
201             whitelist = Whitelist(_newWhitelist);
202         }
203     }
204 
205 }
206 
207 // File: contracts/token/TokenRecoverable.sol
208 
209 pragma solidity 0.4.25;
210 
211 
212 
213 /// @title TokenRecoverable
214 /// @author STOKR
215 contract TokenRecoverable is Ownable {
216 
217     // Address that can do the TokenRecovery
218     address public tokenRecoverer;
219 
220     /// @dev  Event emitted when the TokenRecoverer changes
221     /// @param previous  Ethereum address of previous token recoverer
222     /// @param current   Ethereum address of new token recoverer
223     event TokenRecovererChange(address indexed previous, address indexed current);
224 
225     /// @dev Event emitted in case of a TokenRecovery
226     /// @param oldAddress Ethereum address of old account
227     /// @param newAddress Ethereum address of new account
228     event TokenRecovery(address indexed oldAddress, address indexed newAddress);
229 
230     /// @dev Restrict operation to token recoverer
231     modifier onlyTokenRecoverer() {
232         require(msg.sender == tokenRecoverer, "Restricted to token recoverer");
233         _;
234     }
235 
236     /// @dev Constructor
237     /// @param _tokenRecoverer Ethereum address of token recoverer
238     constructor(address _tokenRecoverer) public {
239         setTokenRecoverer(_tokenRecoverer);
240     }
241 
242     /// @dev Set token recoverer
243     /// @param _newTokenRecoverer Ethereum address of new token recoverer
244     function setTokenRecoverer(address _newTokenRecoverer) public onlyOwner {
245         require(_newTokenRecoverer != address(0x0), "New token recoverer is zero");
246 
247         if (_newTokenRecoverer != tokenRecoverer) {
248             emit TokenRecovererChange(tokenRecoverer, _newTokenRecoverer);
249 
250             tokenRecoverer = _newTokenRecoverer;
251         }
252     }
253 
254     /// @dev Recover token
255     /// @param _oldAddress address
256     /// @param _newAddress address
257     function recoverToken(address _oldAddress, address _newAddress) public;
258 
259 }
260 
261 // File: contracts/token/ERC20.sol
262 
263 pragma solidity 0.4.25;
264 
265 
266 /// @title ERC20 interface
267 /// @dev see https://github.com/ethereum/EIPs/issues/20
268 interface ERC20 {
269 
270     event Transfer(address indexed from, address indexed to, uint value);
271     event Approval(address indexed owner, address indexed spender, uint value);
272 
273     function totalSupply() external view returns (uint);
274     function balanceOf(address _owner) external view returns (uint);
275     function allowance(address _owner, address _spender) external view returns (uint);
276     function approve(address _spender, uint _value) external returns (bool);
277     function transfer(address _to, uint _value) external returns (bool);
278     function transferFrom(address _from, address _to, uint _value) external returns (bool);
279 
280 }
281 
282 // File: contracts/math/SafeMath.sol
283 
284 pragma solidity 0.4.25;
285 
286 
287 /// @title SafeMath
288 /// @dev Math operations with safety checks that throw on error
289 library SafeMath {
290 
291     /// @dev Add two integers
292     function add(uint a, uint b) internal pure returns (uint) {
293         uint c = a + b;
294 
295         assert(c >= a);
296 
297         return c;
298     }
299 
300     /// @dev Subtract two integers
301     function sub(uint a, uint b) internal pure returns (uint) {
302         assert(b <= a);
303 
304         return a - b;
305     }
306 
307     /// @dev Multiply tow integers
308     function mul(uint a, uint b) internal pure returns (uint) {
309         if (a == 0) {
310             return 0;
311         }
312 
313         uint c = a * b;
314 
315         assert(c / a == b);
316 
317         return c;
318     }
319 
320     /// @dev Floor divide two integers
321     function div(uint a, uint b) internal pure returns (uint) {
322         return a / b;
323     }
324 
325 }
326 
327 // File: contracts/token/ProfitSharing.sol
328 
329 pragma solidity 0.4.25;
330 
331 
332 
333 
334 /// @title ProfitSharing
335 /// @author STOKR
336 contract ProfitSharing is Ownable {
337 
338     using SafeMath for uint;
339 
340 
341     // An InvestorAccount object keeps track of the investor's
342     // - balance: amount of tokens he/she holds (always up-to-date)
343     // - profitShare: amount of wei this token owed him/her at the last update
344     // - lastTotalProfits: determines when his/her profitShare was updated
345     // Note, this construction requires:
346     // - totalProfits to never decrease
347     // - totalSupply to be fixed
348     // - profitShare of all involved parties to get updated prior to any token transfer
349     // - lastTotalProfits to be set to current totalProfits upon profitShare update
350     struct InvestorAccount {
351         uint balance;           // token balance
352         uint lastTotalProfits;  // totalProfits [wei] at the time of last profit share update
353         uint profitShare;       // profit share [wei] of last update
354     }
355 
356 
357     // Investor account database
358     mapping(address => InvestorAccount) public accounts;
359 
360     // Authority who is allowed to deposit profits [wei] on this
361     address public profitDepositor;
362 
363     // Authority who is allowed to distribute profit shares [wei] to investors
364     // (so, that they don't need to withdraw it by themselves)
365     address public profitDistributor;
366 
367     // Amount of total profits [wei] stored to this token
368     // In contrast to the wei balance (which may be reduced due to profit share withdrawal)
369     // this value will never decrease
370     uint public totalProfits;
371 
372     // As long as the total supply isn't fixed, i.e. new tokens can appear out of thin air,
373     // the investors' profit shares aren't determined
374     bool public totalSupplyIsFixed;
375 
376     // Total amount of tokens
377     uint internal totalSupply_;
378 
379 
380     /// @dev  Log entry on change of profit deposit authority
381     /// @param previous  Ethereum address of previous profit depositor
382     /// @param current   Ethereum address of new profit depositor
383     event ProfitDepositorChange(address indexed previous, address indexed current);
384 
385     /// @dev  Log entry on change of profit distribution authority
386     /// @param previous  Ethereum address of previous profit distributor
387     /// @param current   Ethereum address of new profit distributor
388     event ProfitDistributorChange(address indexed previous, address indexed current);
389 
390     /// @dev Log entry on profit deposit
391     /// @param depositor Profit depositor's address
392     /// @param amount Deposited profits in wei
393     event ProfitDeposit(address indexed depositor, uint amount);
394 
395     /// @dev Log entry on profit share update
396     /// @param investor Investor's address
397     /// @param amount New wei amount the token owes the investor
398     event ProfitShareUpdate(address indexed investor, uint amount);
399 
400     /// @dev Log entry on profit withdrawal
401     /// @param investor Investor's address
402     /// @param amount Wei amount the investor withdrew from this token
403     event ProfitShareWithdrawal(address indexed investor, address indexed beneficiary, uint amount);
404 
405 
406     /// @dev Restrict operation to profit deposit authority only
407     modifier onlyProfitDepositor() {
408         require(msg.sender == profitDepositor, "Restricted to profit depositor");
409         _;
410     }
411 
412     /// @dev Restrict operation to profit distribution authority only
413     modifier onlyProfitDistributor() {
414         require(msg.sender == profitDistributor, "Restricted to profit distributor");
415         _;
416     }
417 
418     /// @dev Restrict operation to when total supply doesn't change anymore
419     modifier onlyWhenTotalSupplyIsFixed() {
420         require(totalSupplyIsFixed, "Total supply may change");
421         _;
422     }
423 
424     /// @dev Constructor
425     /// @param _profitDepositor Profit deposit authority
426     constructor(address _profitDepositor, address _profitDistributor) public {
427         setProfitDepositor(_profitDepositor);
428         setProfitDistributor(_profitDistributor);
429     }
430 
431     /// @dev Profit deposit if possible via fallback function
432     function () public payable {
433         require(msg.data.length == 0, "Fallback call with data");
434 
435         depositProfit();
436     }
437 
438     /// @dev Change profit depositor
439     /// @param _newProfitDepositor An Ethereum address
440     function setProfitDepositor(address _newProfitDepositor) public onlyOwner {
441         require(_newProfitDepositor != address(0x0), "New profit depositor is zero");
442 
443         if (_newProfitDepositor != profitDepositor) {
444             emit ProfitDepositorChange(profitDepositor, _newProfitDepositor);
445 
446             profitDepositor = _newProfitDepositor;
447         }
448     }
449 
450     /// @dev Change profit distributor
451     /// @param _newProfitDistributor An Ethereum address
452     function setProfitDistributor(address _newProfitDistributor) public onlyOwner {
453         require(_newProfitDistributor != address(0x0), "New profit distributor is zero");
454 
455         if (_newProfitDistributor != profitDistributor) {
456             emit ProfitDistributorChange(profitDistributor, _newProfitDistributor);
457 
458             profitDistributor = _newProfitDistributor;
459         }
460     }
461 
462     /// @dev Deposit profit
463     function depositProfit() public payable onlyProfitDepositor onlyWhenTotalSupplyIsFixed {
464         require(totalSupply_ > 0, "Total supply is zero");
465 
466         totalProfits = totalProfits.add(msg.value);
467 
468         emit ProfitDeposit(msg.sender, msg.value);
469     }
470 
471     /// @dev Profit share owing
472     /// @param _investor An Ethereum address
473     /// @return A positive number
474     function profitShareOwing(address _investor) public view returns (uint) {
475         if (!totalSupplyIsFixed || totalSupply_ == 0) {
476             return 0;
477         }
478 
479         InvestorAccount memory account = accounts[_investor];
480 
481         return totalProfits.sub(account.lastTotalProfits)
482                            .mul(account.balance)
483                            .div(totalSupply_)
484                            .add(account.profitShare);
485     }
486 
487     /// @dev Update profit share
488     /// @param _investor An Ethereum address
489     function updateProfitShare(address _investor) public onlyWhenTotalSupplyIsFixed {
490         uint newProfitShare = profitShareOwing(_investor);
491 
492         accounts[_investor].lastTotalProfits = totalProfits;
493         accounts[_investor].profitShare = newProfitShare;
494 
495         emit ProfitShareUpdate(_investor, newProfitShare);
496     }
497 
498     /// @dev Withdraw profit share
499     function withdrawProfitShare() public {
500         _withdrawProfitShare(msg.sender, msg.sender);
501     }
502 
503     function withdrawProfitShareTo(address _beneficiary) public {
504         _withdrawProfitShare(msg.sender, _beneficiary);
505     }
506 
507     /// @dev Withdraw profit share
508     function withdrawProfitShares(address[] _investors) external onlyProfitDistributor {
509         for (uint i = 0; i < _investors.length; ++i) {
510             _withdrawProfitShare(_investors[i], _investors[i]);
511         }
512     }
513 
514     /// @dev Withdraw profit share
515     function _withdrawProfitShare(address _investor, address _beneficiary) internal {
516         updateProfitShare(_investor);
517 
518         uint withdrawnProfitShare = accounts[_investor].profitShare;
519 
520         accounts[_investor].profitShare = 0;
521         _beneficiary.transfer(withdrawnProfitShare);
522 
523         emit ProfitShareWithdrawal(_investor, _beneficiary, withdrawnProfitShare);
524     }
525 
526 }
527 
528 // File: contracts/token/MintableToken.sol
529 
530 pragma solidity 0.4.25;
531 
532 
533 
534 
535 
536 /// @title MintableToken
537 /// @author STOKR
538 /// @dev Extension of the ERC20 compliant ProfitSharing Token
539 ///      that allows the creation of tokens via minting for a
540 ///      limited time period (until minting gets finished).
541 contract MintableToken is ERC20, ProfitSharing, Whitelisted {
542 
543     address public minter;
544     uint public numberOfInvestors = 0;
545 
546     /// @dev Log entry on mint
547     /// @param to Beneficiary who received the newly minted tokens
548     /// @param amount The amount of minted token units
549     event Minted(address indexed to, uint amount);
550 
551     /// @dev Log entry on mint finished
552     event MintFinished();
553 
554     /// @dev Restrict an operation to be callable only by the minter
555     modifier onlyMinter() {
556         require(msg.sender == minter, "Restricted to minter");
557         _;
558     }
559 
560     /// @dev Restrict an operation to be executable only while minting was not finished
561     modifier canMint() {
562         require(!totalSupplyIsFixed, "Total supply has been fixed");
563         _;
564     }
565 
566     /// @dev Set minter authority
567     /// @param _minter Ethereum address of minter authority
568     function setMinter(address _minter) public onlyOwner {
569         require(minter == address(0x0), "Minter has already been set");
570         require(_minter != address(0x0), "Minter is zero");
571 
572         minter = _minter;
573     }
574 
575     /// @dev Mint tokens, i.e. create tokens out of thin air
576     /// @param _to Beneficiary who will receive the newly minted tokens
577     /// @param _amount The amount of minted token units
578     function mint(address _to, uint _amount) public onlyMinter canMint onlyWhitelisted(_to) {
579         if (accounts[_to].balance == 0) {
580             numberOfInvestors++;
581         }
582 
583         totalSupply_ = totalSupply_.add(_amount);
584         accounts[_to].balance = accounts[_to].balance.add(_amount);
585 
586         emit Minted(_to, _amount);
587         emit Transfer(address(0x0), _to, _amount);
588     }
589 
590     /// @dev Finish minting -- this should be irreversible
591     function finishMinting() public onlyMinter canMint {
592         totalSupplyIsFixed = true;
593 
594         emit MintFinished();
595     }
596 
597 }
598 
599 // File: contracts/token/StokrToken.sol
600 
601 pragma solidity 0.4.25;
602 
603 
604 
605 
606 
607 /// @title StokrToken
608 /// @author Stokr
609 contract StokrToken is MintableToken, TokenRecoverable {
610 
611     string public name;
612     string public symbol;
613     uint8 public constant decimals = 18;
614 
615     mapping(address => mapping(address => uint)) internal allowance_;
616 
617     /// @dev Log entry on self destruction of the token
618     event TokenDestroyed();
619 
620     /// @dev Constructor
621     /// @param _whitelist       Ethereum address of whitelist contract
622     /// @param _tokenRecoverer  Ethereum address of token recoverer
623     constructor(
624         string _name,
625         string _symbol,
626         Whitelist _whitelist,
627         address _profitDepositor,
628         address _profitDistributor,
629         address _tokenRecoverer
630     )
631         public
632         Whitelisted(_whitelist)
633         ProfitSharing(_profitDepositor, _profitDistributor)
634         TokenRecoverable(_tokenRecoverer)
635     {
636         name = _name;
637         symbol = _symbol;
638     }
639 
640     /// @dev  Self destruct can only be called by crowdsale contract in case the goal wasn't reached
641     function destruct() public onlyMinter {
642         emit TokenDestroyed();
643         selfdestruct(owner);
644     }
645 
646     /// @dev Recover token
647     /// @param _oldAddress  address of old account
648     /// @param _newAddress  address of new account
649     function recoverToken(address _oldAddress, address _newAddress)
650         public
651         onlyTokenRecoverer
652         onlyWhitelisted(_newAddress)
653     {
654         // Ensure that new address is *not* an existing account.
655         // Check for account.profitShare is not needed because of following implication:
656         //   (account.lastTotalProfits == 0) ==> (account.profitShare == 0)
657         require(accounts[_newAddress].balance == 0 && accounts[_newAddress].lastTotalProfits == 0,
658                 "New address exists already");
659 
660         updateProfitShare(_oldAddress);
661 
662         accounts[_newAddress] = accounts[_oldAddress];
663         delete accounts[_oldAddress];
664 
665         emit TokenRecovery(_oldAddress, _newAddress);
666         emit Transfer(_oldAddress, _newAddress, accounts[_newAddress].balance);
667     }
668 
669     /// @dev  Total supply of this token
670     /// @return  Token amount
671     function totalSupply() public view returns (uint) {
672         return totalSupply_;
673     }
674 
675     /// @dev  Token balance
676     /// @param _investor  Ethereum address of token holder
677     /// @return           Token amount
678     function balanceOf(address _investor) public view returns (uint) {
679         return accounts[_investor].balance;
680     }
681 
682     /// @dev  Allowed token amount a third party trustee may transfer
683     /// @param _investor  Ethereum address of token holder
684     /// @param _spender   Ethereum address of third party
685     /// @return           Allowed token amount
686     function allowance(address _investor, address _spender) public view returns (uint) {
687         return allowance_[_investor][_spender];
688     }
689 
690     /// @dev  Approve a third party trustee to transfer tokens
691     ///       Note: additional requirements are enforced within internal function.
692     /// @param _spender  Ethereum address of third party
693     /// @param _value    Maximum token amount that is allowed to get transferred
694     /// @return          Always true
695     function approve(address _spender, uint _value) public returns (bool) {
696         return _approve(msg.sender, _spender, _value);
697     }
698 
699     /// @dev  Increase the amount of tokens a third party trustee may transfer
700     ///       Note: additional requirements are enforces within internal function.
701     /// @param _spender  Ethereum address of third party
702     /// @param _amount   Additional token amount that is allowed to get transferred
703     /// @return          Always true
704     function increaseAllowance(address _spender, uint _amount) public returns (bool) {
705         require(allowance_[msg.sender][_spender] + _amount >= _amount, "Allowance overflow");
706 
707         return _approve(msg.sender, _spender, allowance_[msg.sender][_spender].add(_amount));
708     }
709 
710     /// @dev  Decrease the amount of tokens a third party trustee may transfer
711     ///       Note: additional requirements are enforces within internal function.
712     /// @param _spender  Ethereum address of third party
713     /// @param _amount   Reduced token amount that is allowed to get transferred
714     /// @return          Always true
715     function decreaseAllowance(address _spender, uint _amount) public returns (bool) {
716         require(_amount <= allowance_[msg.sender][_spender], "Amount exceeds allowance");
717 
718         return _approve(msg.sender, _spender, allowance_[msg.sender][_spender].sub(_amount));
719     }
720 
721     /// @dev  Check if a token transfer is possible
722     /// @param _from   Ethereum address of token sender
723     /// @param _to     Ethereum address of token recipient
724     /// @param _value  Token amount to transfer
725     /// @return        True iff a transfer with given pramaters would succeed
726     function canTransfer(address _from, address _to, uint _value)
727         public view returns (bool)
728     {
729         return totalSupplyIsFixed
730             && _from != address(0x0)
731             && _to != address(0x0)
732             && _value <= accounts[_from].balance
733             && whitelist.isWhitelisted(_from)
734             && whitelist.isWhitelisted(_to);
735     }
736 
737     /// @dev  Check if a token transfer by third party is possible
738     /// @param _spender  Ethereum address of third party trustee
739     /// @param _from     Ethereum address of token holder
740     /// @param _to       Ethereum address of token recipient
741     /// @param _value    Token amount to transfer
742     /// @return          True iff a transfer with given pramaters would succeed
743     function canTransferFrom(address _spender, address _from, address _to, uint _value)
744         public view returns (bool)
745     {
746         return canTransfer(_from, _to, _value) && _value <= allowance_[_from][_spender];
747     }
748 
749     /// @dev  Token transfer
750     ///       Note: additional requirements are enforces within internal function.
751     /// @param _to     Ethereum address of token recipient
752     /// @param _value  Token amount to transfer
753     /// @return        Always true
754     function transfer(address _to, uint _value) public returns (bool) {
755         return _transfer(msg.sender, _to, _value);
756     }
757 
758     /// @dev  Token transfer by a third party
759     ///       Note: additional requirements are enforces within internal function.
760     /// @param _from   Ethereum address of token holder
761     /// @param _to     Ethereum address of token recipient
762     /// @param _value  Token amount to transfer
763     /// @return        Always true
764     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
765         require(_value <= allowance_[_from][msg.sender], "Amount exceeds allowance");
766 
767         return _approve(_from, msg.sender, allowance_[_from][msg.sender].sub(_value))
768             && _transfer(_from, _to, _value);
769     }
770 
771     /// @dev  Approve a third party trustee to transfer tokens (internal implementation)
772     /// @param _from     Ethereum address of token holder
773     /// @param _spender  Ethereum address of third party
774     /// @param _value    Maximum token amount the trustee is allowed to transfer
775     /// @return          Always true
776     function _approve(address _from, address _spender, uint _value)
777         internal
778         onlyWhitelisted(_from)
779         onlyWhenTotalSupplyIsFixed
780         returns (bool)
781     {
782         allowance_[_from][_spender] = _value;
783 
784         emit Approval(_from, _spender, _value);
785 
786         return true;
787     }
788 
789     /// @dev  Token transfer (internal implementation)
790     /// @param _from   Ethereum address of token sender
791     /// @param _to     Ethereum address of token recipient
792     /// @param _value  Token amount to transfer
793     /// @return        Always true
794     function _transfer(address _from, address _to, uint _value)
795         internal
796         onlyWhitelisted(_from)
797         onlyWhitelisted(_to)
798         onlyWhenTotalSupplyIsFixed
799         returns (bool)
800     {
801         require(_to != address(0x0), "Recipient is zero");
802         require(_value <= accounts[_from].balance, "Amount exceeds balance");
803 
804         updateProfitShare(_from);
805         updateProfitShare(_to);
806 
807         accounts[_from].balance = accounts[_from].balance.sub(_value);
808         accounts[_to].balance = accounts[_to].balance.add(_value);
809 
810         emit Transfer(_from, _to, _value);
811 
812         return true;
813     }
814 
815 }
816 
817 // File: contracts/token/StokrTokenFactory.sol
818 
819 pragma solidity 0.4.25;
820 
821 
822 
823 // Helper contract to deploy a new StokrToken contract
824 
825 contract StokrTokenFactory {
826 
827     function createNewToken(
828         string name,
829         string symbol,
830         Whitelist whitelist,
831         address profitDepositor,
832         address profitDistributor,
833         address tokenRecoverer
834     )
835         public
836         returns (StokrToken)
837     {
838         StokrToken token = new StokrToken(
839             name,
840             symbol,
841             whitelist,
842             profitDepositor,
843             profitDistributor,
844             tokenRecoverer);
845 
846         token.transferOwnershipUnsafe(msg.sender);
847 
848         return token;
849     }
850 
851 }
852 
853 // File: contracts/crowdsale/RateSourceInterface.sol
854 
855 pragma solidity 0.4.25;
856 
857 
858 /// @title RateSource
859 /// @author STOKR
860 interface RateSource {
861 
862     /// @dev The current price of an Ether in EUR cents
863     /// @return Current ether rate
864     function etherRate() external returns(uint);
865 
866 }
867 
868 // File: contracts/crowdsale/MintingCrowdsale.sol
869 
870 pragma solidity 0.4.25;
871 
872 
873 
874 
875 
876 
877 /// @title MintingCrowdsale
878 /// @author STOKR
879 contract MintingCrowdsale is Ownable {
880     using SafeMath for uint;
881 
882     // Maximum Time of offering period after extension
883     uint constant MAXOFFERINGPERIOD = 80 days;
884 
885     // Ether rate oracle contract providing the price of an Ether in EUR cents
886     RateSource public rateSource;
887 
888     // The token to be sold
889     // In the following, the term "token unit" always refers to the smallest
890     // and non-divisible quantum. Thus, token unit amounts are always integers.
891     // One token is expected to consist of 10^18 token units.
892     MintableToken public token;
893 
894     // Token amounts in token units
895     // The public and the private sale are both capped (i.e. two distinct token pools)
896     // The tokenRemaining variables keep track of how many token units are available
897     // for the respective type of sale
898     uint public tokenCapOfPublicSale;
899     uint public tokenCapOfPrivateSale;
900     uint public tokenRemainingForPublicSale;
901     uint public tokenRemainingForPrivateSale;
902 
903     // Prices are in Euro cents (i.e. 1/100 EUR)
904     uint public tokenPrice;
905 
906     // The minimum amount of tokens a purchaser has to buy via one transaction
907     uint public tokenPurchaseMinimum;
908 
909     // The maximum total amount of tokens a purchaser may buy during start phase
910     uint public tokenPurchaseLimit;
911 
912     // Total token purchased by investor (while purchase amount is limited)
913     mapping(address => uint) public tokenPurchased;
914 
915     // Public sale period
916     uint public openingTime;
917     uint public closingTime;
918     uint public limitEndTime;
919 
920     // Ethereum address where invested funds will be transferred to
921     address public companyWallet;
922 
923     // Amount and receiver of reserved tokens
924     uint public tokenReservePerMill;
925     address public reserveAccount;
926 
927     // Wether this crowdsale was finalized or not
928     bool public isFinalized = false;
929 
930 
931     /// @dev Log entry upon token distribution event
932     /// @param beneficiary Ethereum address of token recipient
933     /// @param amount Number of token units
934     /// @param isPublicSale Whether the distribution was via public sale
935     event TokenDistribution(address indexed beneficiary, uint amount, bool isPublicSale);
936 
937     /// @dev Log entry upon token purchase event
938     /// @param buyer Ethereum address of token purchaser
939     /// @param value Worth in wei of purchased token amount
940     /// @param amount Number of token units
941     event TokenPurchase(address indexed buyer, uint value, uint amount);
942 
943     /// @dev Log entry upon rate change event
944     /// @param previous Previous closing time of sale
945     /// @param current Current closing time of sale
946     event ClosingTimeChange(uint previous, uint current);
947 
948     /// @dev Log entry upon finalization event
949     event Finalization();
950 
951 
952     /// @dev Constructor
953     /// @param _rateSource Ether rate oracle contract
954     /// @param _token The token to be sold
955     /// @param _tokenCapOfPublicSale Maximum number of token units to mint in public sale
956     /// @param _tokenCapOfPrivateSale Maximum number of token units to mint in private sale
957     /// @param _tokenPurchaseMinimum Minimum amount of tokens an investor has to buy at once
958     /// @param _tokenPurchaseLimit Maximum total token amounts individually buyable in limit phase
959     /// @param _tokenPrice Price of a token in EUR cent
960     /// @param _openingTime Block (Unix) timestamp of sale opening time
961     /// @param _closingTime Block (Unix) timestamp of sale closing time
962     /// @param _limitEndTime Block (Unix) timestamp until token purchases are limited
963     /// @param _companyWallet Ethereum account who will receive sent ether
964     /// @param _tokenReservePerMill Per mill amount of sold tokens to mint for reserve account
965     /// @param _reserveAccount Ethereum address of reserve tokens recipient
966     constructor(
967         RateSource _rateSource,
968         MintableToken _token,
969         uint _tokenCapOfPublicSale,
970         uint _tokenCapOfPrivateSale,
971         uint _tokenPurchaseMinimum,
972         uint _tokenPurchaseLimit,
973         uint _tokenReservePerMill,
974         uint _tokenPrice,
975         uint _openingTime,
976         uint _closingTime,
977         uint _limitEndTime,
978         address _companyWallet,
979         address _reserveAccount
980     )
981         public
982     {
983         require(address(_rateSource) != address(0x0), "Rate source is zero");
984         require(address(_token) != address(0x0), "Token address is zero");
985         require(_token.minter() == address(0x0), "Token has another minter");
986         require(_tokenCapOfPublicSale > 0, "Cap of public sale is zero");
987         require(_tokenCapOfPrivateSale > 0, "Cap of private sale is zero");
988         require(_tokenPurchaseMinimum <= _tokenCapOfPublicSale
989                 && _tokenPurchaseMinimum <= _tokenCapOfPrivateSale,
990                 "Purchase minimum exceeds cap");
991         require(_tokenPrice > 0, "Token price is zero");
992         require(_openingTime >= now, "Opening lies in the past");
993         require(_closingTime >= _openingTime, "Closing lies before opening");
994         require(_companyWallet != address(0x0), "Company wallet is zero");
995         require(_reserveAccount != address(0x0), "Reserve account is zero");
996 
997 
998         // Note: There are no time related requirements regarding limitEndTime.
999         //       If it's below openingTime, token purchases will never be limited.
1000         //       If it's above closingTime, token purchases will always be limited.
1001         if (_limitEndTime > _openingTime) {
1002             // But, if there's a purchase limitation phase, the limit must be at
1003             // least the purchase minimum or above to make purchases possible.
1004             require(_tokenPurchaseLimit >= _tokenPurchaseMinimum,
1005                     "Purchase limit is below minimum");
1006         }
1007 
1008         // Utilize safe math to ensure the sum of three token pools does't overflow
1009         _tokenCapOfPublicSale.add(_tokenCapOfPrivateSale).mul(_tokenReservePerMill);
1010 
1011         rateSource = _rateSource;
1012         token = _token;
1013         tokenCapOfPublicSale = _tokenCapOfPublicSale;
1014         tokenCapOfPrivateSale = _tokenCapOfPrivateSale;
1015         tokenPurchaseMinimum = _tokenPurchaseMinimum;
1016         tokenPurchaseLimit= _tokenPurchaseLimit;
1017         tokenReservePerMill = _tokenReservePerMill;
1018         tokenPrice = _tokenPrice;
1019         openingTime = _openingTime;
1020         closingTime = _closingTime;
1021         limitEndTime = _limitEndTime;
1022         companyWallet = _companyWallet;
1023         reserveAccount = _reserveAccount;
1024 
1025         tokenRemainingForPublicSale = _tokenCapOfPublicSale;
1026         tokenRemainingForPrivateSale = _tokenCapOfPrivateSale;
1027     }
1028 
1029 
1030 
1031     /// @dev Fallback function: buys tokens
1032     function () public payable {
1033         require(msg.data.length == 0, "Fallback call with data");
1034 
1035         buyTokens();
1036     }
1037 
1038     /// @dev Distribute tokens purchased off-chain via public sale
1039     ///      Note: additional requirements are enforced in internal function.
1040     /// @param beneficiaries List of recipients' Ethereum addresses
1041     /// @param amounts List of token units each recipient will receive
1042     function distributeTokensViaPublicSale(address[] beneficiaries, uint[] amounts) external {
1043         tokenRemainingForPublicSale =
1044             distributeTokens(tokenRemainingForPublicSale, beneficiaries, amounts, true);
1045     }
1046 
1047     /// @dev Distribute tokens purchased off-chain via private sale
1048     ///      Note: additional requirements are enforced in internal function.
1049     /// @param beneficiaries List of recipients' Ethereum addresses
1050     /// @param amounts List of token units each recipient will receive
1051     function distributeTokensViaPrivateSale(address[] beneficiaries, uint[] amounts) external {
1052         tokenRemainingForPrivateSale =
1053             distributeTokens(tokenRemainingForPrivateSale, beneficiaries, amounts, false);
1054     }
1055 
1056     /// @dev Check whether the sale has closed
1057     /// @return True iff sale closing time has passed
1058     function hasClosed() public view returns (bool) {
1059         return now >= closingTime;
1060     }
1061 
1062     /// @dev Check wether the sale is open
1063     /// @return True iff sale opening time has passed and sale is not closed yet
1064     function isOpen() public view returns (bool) {
1065         return now >= openingTime && !hasClosed();
1066     }
1067 
1068     /// @dev Determine the remaining open time of sale
1069     /// @return Time in seconds until sale gets closed, or 0 if sale was closed
1070     function timeRemaining() public view returns (uint) {
1071         if (hasClosed()) {
1072             return 0;
1073         }
1074 
1075         return closingTime - now;
1076     }
1077 
1078     /// @dev Determine the amount of sold tokens (off-chain and on-chain)
1079     /// @return Token units amount
1080     function tokenSold() public view returns (uint) {
1081         return (tokenCapOfPublicSale - tokenRemainingForPublicSale)
1082              + (tokenCapOfPrivateSale - tokenRemainingForPrivateSale);
1083     }
1084 
1085     /// @dev Purchase tokens
1086     function buyTokens() public payable {
1087         require(isOpen(), "Sale is not open");
1088 
1089         uint etherRate = rateSource.etherRate();
1090 
1091         require(etherRate > 0, "Ether rate is zero");
1092 
1093         // Units:  [1e-18*ether] * [cent/ether] / [cent/token] => [1e-18*token]
1094         uint amount = msg.value.mul(etherRate).div(tokenPrice);
1095 
1096         require(amount <= tokenRemainingForPublicSale, "Not enough tokens available");
1097         require(amount >= tokenPurchaseMinimum, "Investment is too low");
1098 
1099         // Is the total amount an investor can purchase with Ether limited?
1100         if (now < limitEndTime) {
1101             uint purchased = tokenPurchased[msg.sender].add(amount);
1102 
1103             require(purchased <= tokenPurchaseLimit, "Purchase limit reached");
1104 
1105             tokenPurchased[msg.sender] = purchased;
1106         }
1107 
1108         tokenRemainingForPublicSale = tokenRemainingForPublicSale.sub(amount);
1109 
1110         token.mint(msg.sender, amount);
1111         forwardFunds();
1112 
1113         emit TokenPurchase(msg.sender, msg.value, amount);
1114     }
1115 
1116     /// @dev Extend the offering period of the crowd sale.
1117     /// @param _newClosingTime new closingTime of the crowdsale
1118     function changeClosingTime(uint _newClosingTime) public onlyOwner {
1119         require(!hasClosed(), "Sale has already ended");
1120         require(_newClosingTime > now, "ClosingTime not in the future");
1121         require(_newClosingTime > openingTime, "New offering is zero");
1122         require(_newClosingTime - openingTime <= MAXOFFERINGPERIOD, "New offering too long");
1123 
1124         emit ClosingTimeChange(closingTime, _newClosingTime);
1125 
1126         closingTime = _newClosingTime;
1127     }
1128 
1129     /// @dev Finalize, i.e. end token minting phase and enable token transfers
1130     function finalize() public onlyOwner {
1131         require(!isFinalized, "Sale has already been finalized");
1132         require(hasClosed(), "Sale has not closed");
1133 
1134         if (tokenReservePerMill > 0) {
1135             token.mint(reserveAccount, tokenSold().mul(tokenReservePerMill).div(1000));
1136         }
1137         token.finishMinting();
1138         isFinalized = true;
1139 
1140         emit Finalization();
1141     }
1142 
1143     /// @dev Distribute tokens purchased off-chain (in Euro) to investors
1144     /// @param tokenRemaining Token units available for sale
1145     /// @param beneficiaries Ethereum addresses of purchasers
1146     /// @param amounts Token unit amounts to deliver to each investor
1147     /// @return Token units available for sale after distribution
1148     function distributeTokens(uint tokenRemaining, address[] beneficiaries, uint[] amounts, bool isPublicSale)
1149         internal
1150         onlyOwner
1151         returns (uint)
1152     {
1153         require(!isFinalized, "Sale has been finalized");
1154         require(beneficiaries.length == amounts.length, "Lengths are different");
1155 
1156         for (uint i = 0; i < beneficiaries.length; ++i) {
1157             address beneficiary = beneficiaries[i];
1158             uint amount = amounts[i];
1159 
1160             require(amount <= tokenRemaining, "Not enough tokens available");
1161 
1162             tokenRemaining = tokenRemaining.sub(amount);
1163             token.mint(beneficiary, amount);
1164 
1165             emit TokenDistribution(beneficiary, amount, isPublicSale);
1166         }
1167 
1168         return tokenRemaining;
1169     }
1170 
1171     /// @dev Forward invested ether to company wallet
1172     function forwardFunds() internal {
1173         companyWallet.transfer(address(this).balance);
1174     }
1175 
1176 }
1177 
1178 // File: contracts/crowdsale/StokrCrowdsale.sol
1179 
1180 pragma solidity 0.4.25;
1181 
1182 
1183 
1184 
1185 /// @title StokrCrowdsale
1186 /// @author STOKR
1187 contract StokrCrowdsale is MintingCrowdsale {
1188 
1189     // Soft cap in token units
1190     uint public tokenGoal;
1191 
1192     // As long as the goal is not reached funds of purchases are held back
1193     // and investments are assigned to investors here to enable a refunding
1194     // if the goal is missed upon finalization
1195     mapping(address => uint) public investments;
1196 
1197 
1198     // Log entry upon investor refund event
1199     event InvestorRefund(address indexed investor, uint value);
1200 
1201 
1202     /// @dev Constructor
1203     /// @param _token The token
1204     /// @param _tokenCapOfPublicSale Available token units for public sale
1205     /// @param _tokenCapOfPrivateSale Available token units for private sale
1206     /// @param _tokenGoal Minimum number of sold token units to be successful
1207     /// @param _tokenPurchaseMinimum Minimum amount of tokens an investor has to buy at once
1208     /// @param _tokenPurchaseLimit Maximum total token amounts individually buyable in limit phase
1209     /// @param _tokenReservePerMill Additional reserve tokens in per mill of sold tokens
1210     /// @param _tokenPrice Price of a token in EUR cent
1211     /// @param _rateSource Ethereum address of ether rate setting authority
1212     /// @param _openingTime Block (Unix) timestamp of sale opening time
1213     /// @param _closingTime Block (Unix) timestamp of sale closing time
1214     /// @param _limitEndTime Block (Unix) timestamp until token purchases are limited
1215     /// @param _companyWallet Ethereum account who will receive sent ether
1216     /// @param _reserveAccount An address
1217     constructor(
1218         RateSource _rateSource,
1219         StokrToken _token,
1220         uint _tokenCapOfPublicSale,
1221         uint _tokenCapOfPrivateSale,
1222         uint _tokenGoal,
1223         uint _tokenPurchaseMinimum,
1224         uint _tokenPurchaseLimit,
1225         uint _tokenReservePerMill,
1226         uint _tokenPrice,
1227         uint _openingTime,
1228         uint _closingTime,
1229         uint _limitEndTime,
1230         address _companyWallet,
1231         address _reserveAccount
1232     )
1233         public
1234         MintingCrowdsale(
1235             _rateSource,
1236             _token,
1237             _tokenCapOfPublicSale,
1238             _tokenCapOfPrivateSale,
1239             _tokenPurchaseMinimum,
1240             _tokenPurchaseLimit,
1241             _tokenReservePerMill,
1242             _tokenPrice,
1243             _openingTime,
1244             _closingTime,
1245             _limitEndTime,
1246             _companyWallet,
1247             _reserveAccount
1248         )
1249     {
1250         require(_tokenGoal <= _tokenCapOfPublicSale + _tokenCapOfPrivateSale, "Goal is not attainable");
1251 
1252         tokenGoal = _tokenGoal;
1253     }
1254 
1255     /// @dev Wether the goal of sold tokens was reached or not
1256     /// @return True if the sale can be considered successful
1257     function goalReached() public view returns (bool) {
1258         return tokenSold() >= tokenGoal;
1259     }
1260 
1261     /// @dev Investors can claim refunds here if crowdsale was unsuccessful
1262     function distributeRefunds(address[] _investors) external {
1263         for (uint i = 0; i < _investors.length; ++i) {
1264             refundInvestor(_investors[i]);
1265         }
1266     }
1267 
1268     /// @dev Investors can claim refunds here if crowdsale was unsuccessful
1269     function claimRefund() public {
1270         refundInvestor(msg.sender);
1271     }
1272 
1273     /// @dev Overwritten. Kill the token if goal was missed
1274     function finalize() public onlyOwner {
1275         super.finalize();
1276 
1277         if (!goalReached()) {
1278             StokrToken(token).destruct();
1279         }
1280     }
1281 
1282     /// @dev Overwritten. Funds are held back until goal was reached
1283     function forwardFunds() internal {
1284         if (goalReached()) {
1285             super.forwardFunds();
1286         }
1287         else {
1288             investments[msg.sender] = investments[msg.sender].add(msg.value);
1289         }
1290     }
1291 
1292     /// @dev Refund an investor if the sale was not successful
1293     /// @param _investor Ethereum address of investor
1294     function refundInvestor(address _investor) internal {
1295         require(isFinalized, "Sale has not been finalized");
1296         require(!goalReached(), "Goal was reached");
1297 
1298         uint investment = investments[_investor];
1299 
1300         if (investment > 0) {
1301             investments[_investor] = 0;
1302             _investor.transfer(investment);
1303 
1304             emit InvestorRefund(_investor, investment);
1305         }
1306     }
1307 
1308 }
1309 
1310 // File: contracts/crowdsale/StokrCrowdsaleFactory.sol
1311 
1312 pragma solidity 0.4.25;
1313 
1314 
1315 
1316 
1317 // Helper contract to deploy a new StokrCrowdsale contract
1318 
1319 contract StokrCrowdsaleFactory {
1320 
1321     function createNewCrowdsale(
1322         StokrToken token,
1323         uint tokenPrice,
1324         uint[6] amounts,  // [tokenCapOfPublicSale, tokenCapOfPrivateSale, tokenGoal,
1325                           //  tokenPurchaseMinimum, tokenPurchaseLimit, tokenReservePerMill]
1326         uint[3] period,   // [openingTime, closingTime, limitEndTime]
1327         address[2] wallets  // [companyWallet, reserveAccount]
1328     )
1329         external
1330         returns (StokrCrowdsale)
1331     {
1332         StokrCrowdsale crowdsale = new StokrCrowdsale(
1333             RateSource(msg.sender),  // rateSource
1334             token,
1335             amounts[0],   // tokenCapOfPublicSale
1336             amounts[1],   // tokenCapOfPrivateSale
1337             amounts[2],   // tokenGoal
1338             amounts[3],   // tokenPurchaseMinimum
1339             amounts[4],   // tokenPurchaseLimit
1340             amounts[5],   // tokenReservePerMill
1341             tokenPrice,   // tokenPrice
1342             period[0],    // openingTime
1343             period[1],    // closingTime
1344             period[2],    // limitEndTime
1345             wallets[0],   // companyWallet
1346             wallets[1]);  // reserveAccount
1347 
1348         crowdsale.transferOwnershipUnsafe(msg.sender);
1349 
1350         return crowdsale;
1351     }
1352 
1353 }
1354 
1355 // File: contracts/StokrProjectManager.sol
1356 
1357 pragma solidity 0.4.25;
1358 
1359 
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 contract StokrProjectManager is Ownable, RateSource {
1368 
1369     // Project structure
1370     struct StokrProject {
1371         string name;
1372         Whitelist whitelist;
1373         StokrToken token;
1374         StokrCrowdsale crowdsale;
1375     }
1376 
1377     // Rate must be below this limit: floor(2**256 / 10)
1378     uint public constant RATE_LIMIT = uint(-1) / 10;
1379 
1380     // Block number where this contract instance was deployed
1381     uint public deploymentBlockNumber;
1382 
1383     // Ethereum address of the Ether prize setting authority
1384     address public rateAdmin;
1385 
1386     // Current price of an Ether in EUR cents
1387     uint private rate;
1388 
1389     // Current whitelist and token factory and crowdsale factory instances
1390     Whitelist public currentWhitelist;
1391     StokrTokenFactory public tokenFactory;
1392     StokrCrowdsaleFactory public crowdsaleFactory;
1393 
1394     // List of projects
1395     StokrProject[] public projects;
1396 
1397 
1398     /// @dev Log entry upon rate change event
1399     /// @param previous Previous rate in EUR cent per Ether
1400     /// @param current Current rate in EUR cent per Ether
1401     event RateChange(uint previous, uint current);
1402 
1403     /// @dev Log entry upon rate admin change event
1404     /// @param previous Ethereum address of previous rate admin
1405     /// @param current Ethereum address of current rate admin
1406     event RateAdminChange(address indexed previous, address indexed current);
1407 
1408     /// @dev Log entry upon project creation event
1409     /// @param whitelist  Ethereum address of Whitelist contract
1410     /// @param token  Ethereum address of StokrToken contract
1411     /// @param crowdsale  Ethereum address of StokrCrowdsale contract
1412     /// @param index  Index of the project within projects list
1413     event ProjectCreation(
1414         uint indexed index,
1415         address whitelist,
1416         address indexed token,
1417         address indexed crowdsale
1418     );
1419 
1420 
1421     /// @dev Restrict operation to rate admin role
1422     modifier onlyRateAdmin() {
1423         require(msg.sender == rateAdmin, "Restricted to rate admin");
1424         _;
1425     }
1426 
1427 
1428     /// @dev Constructor
1429     /// @param etherRate Initial price of an Ether in EUR cents
1430     constructor(uint etherRate) public {
1431         require(etherRate > 0, "Ether rate is zero");
1432         require(etherRate < RATE_LIMIT, "Ether rate reaches limit");
1433 
1434         deploymentBlockNumber = block.number;
1435         rate = etherRate;
1436     }
1437 
1438 
1439     /// @dev Set the current whitelist contract instance
1440     /// @param newWhitelist Whitelist instance
1441     function setWhitelist(Whitelist newWhitelist) public onlyOwner {
1442         require(address(newWhitelist) != address(0x0), "Whitelist is zero");
1443 
1444         currentWhitelist = newWhitelist;
1445     }
1446 
1447     /// @dev Set the current token factory contract instance
1448     /// @param newTokenFactory StokrTokenFactory instance
1449     function setTokenFactory(StokrTokenFactory newTokenFactory) public onlyOwner {
1450         require(address(newTokenFactory) != address(0x0), "Token factory is zero");
1451 
1452         tokenFactory = newTokenFactory;
1453     }
1454 
1455     /// @dev Set the current crowdsale factory contract instance
1456     /// @param newCrowdsaleFactory StokrCrowdsaleFactory instance
1457     function setCrowdsaleFactory(StokrCrowdsaleFactory newCrowdsaleFactory) public onlyOwner {
1458         require(address(newCrowdsaleFactory) != address(0x0), "Crowdsale factory is zero");
1459 
1460         crowdsaleFactory = newCrowdsaleFactory;
1461     }
1462 
1463     /// @dev Set rate admin, i.e. the ether rate setting authority
1464     /// @param newRateAdmin Ethereum address of rate admin
1465     function setRateAdmin(address newRateAdmin) public onlyOwner {
1466         require(newRateAdmin != address(0x0), "New rate admin is zero");
1467 
1468         if (newRateAdmin != rateAdmin) {
1469             emit RateAdminChange(rateAdmin, newRateAdmin);
1470 
1471             rateAdmin = newRateAdmin;
1472         }
1473     }
1474 
1475     /// @dev Set rate, i.e. adjust to changes of EUR/ether exchange rate
1476     /// @param newRate Rate in Euro cent per ether
1477     function setRate(uint newRate) public onlyRateAdmin {
1478         // Rate changes beyond an order of magnitude are likely just typos
1479         require(rate / 10 < newRate && newRate < 10 * rate, "Rate change too big");
1480         require(newRate < RATE_LIMIT, "New rate reaches limit");
1481 
1482         if (newRate != rate) {
1483             emit RateChange(rate, newRate);
1484 
1485             rate = newRate;
1486         }
1487     }
1488 
1489     /// @dev Return the current price of an Ether in EUR cents
1490     /// @return Current Ether rate
1491     function etherRate() public view returns (uint) {
1492         return rate;
1493     }
1494 
1495     /// @dev Return the number of projects deployed by this instance
1496     /// @return Projects count
1497     function projectsCount() public view returns (uint) {
1498         return projects.length;
1499     }
1500 
1501     /// @dev Create a new project,
1502     ///      i.e. deploy a new token and crowdsale and store their address into projects
1503     function createNewProject(
1504         string name,
1505         string symbol,
1506         uint tokenPrice,
1507         address[3] roles,  // [profitDepositor, profitDistributor, tokenRecoverer]
1508         uint[6] amounts,   // [tokenCapOfPublicSale, tokenCapOfPrivateSale, tokenGoal,
1509                            //  tokenPurchaseMinimum, tokenPurchaseLimit, tokenReservePerMill]
1510         uint[3] period,    // [openingTime, closingTime, limitEndTime]
1511         address[2] wallets  // [companyWallet, reserveAccount]
1512     )
1513         external onlyOwner
1514     {
1515         require(address(currentWhitelist) != address(0x0), "Whitelist is zero");
1516         require(address(tokenFactory) != address(0x0), "Token factory is zero");
1517         require(address(crowdsaleFactory) != address(0x0), "Crowdsale factory is zero");
1518 
1519         // Parameters are given as arrays to avoid the "stack too deep" complaints of the
1520         // Solidity compiler.
1521         // Furthermore the deployment of the tokens and the crowdsale contract is done via
1522         // factory contracts whose only purpose is to deploy an instance of the respective
1523         // contract. This construction avoids the problem of limited bytecode length when
1524         // deploying contracts (see EIP170). As a side effect, it also enables the change
1525         // of one of the factories by an updated version.
1526 
1527         // Utilize the token factory to deploy a new token contract instance
1528         StokrToken token = tokenFactory.createNewToken(
1529             name,
1530             symbol,
1531             currentWhitelist,
1532             roles[0],   // profitDepositor
1533             roles[1],   // profitDistributor
1534             roles[2]);  // tokenRecoverer
1535 
1536         // Utilize the crowdsale factory to deploy a new crowdsale contract instance
1537         StokrCrowdsale crowdsale = crowdsaleFactory.createNewCrowdsale(
1538             token,
1539             tokenPrice,
1540             amounts,
1541             period,
1542             wallets);
1543 
1544         token.setMinter(crowdsale);  // The crowdsale should be the minter of the token
1545         token.transferOwnershipUnsafe(msg.sender);  // to tokenOwner
1546         crowdsale.transferOwnershipUnsafe(msg.sender);  // to crowdsaleOwner
1547 
1548         // Store the created project into the projects array state variable
1549         projects.push(StokrProject(name, currentWhitelist, token, crowdsale));
1550 
1551         emit ProjectCreation(projects.length - 1, currentWhitelist, token, crowdsale);
1552     }
1553 
1554 }