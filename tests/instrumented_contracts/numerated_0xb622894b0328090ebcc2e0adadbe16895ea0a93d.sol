1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount)
47         external
48         returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender)
58         external
59         view
60         returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(
106         address indexed owner,
107         address indexed spender,
108         uint256 value
109     );
110 }
111 
112 /**
113  * @dev Interface for the optional metadata functions from the ERC20 standard.
114  *
115  * _Available since v4.1._
116  */
117 interface IERC20Metadata is IERC20 {
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() external view returns (string memory);
122 
123     /**
124      * @dev Returns the symbol of the token.
125      */
126     function symbol() external view returns (string memory);
127 
128     /**
129      * @dev Returns the decimals places of the token.
130      */
131     function decimals() external view returns (uint8);
132 }
133 
134 /**
135  * @dev Contract module which provides a basic access control mechanism, where
136  * there is an account (an owner) that can be granted exclusive access to
137  * specific functions.
138  *
139  * By default, the owner account will be the one that deploys the contract. This
140  * can later be changed with {transferOwnership}.
141  *
142  * This module is used through inheritance. It will make available the modifier
143  * `onlyOwner`, which can be applied to your functions to restrict their use to
144  * the owner.
145  */
146 abstract contract Ownable is Context {
147     address private _owner;
148 
149     event OwnershipTransferred(
150         address indexed previousOwner,
151         address indexed newOwner
152     );
153 
154     /**
155      * @dev Initializes the contract setting the deployer as the initial owner.
156      */
157     constructor() {
158         _setOwner(_msgSender());
159     }
160 
161     /**
162      * @dev Returns the address of the current owner.
163      */
164     function owner() public view virtual returns (address) {
165         return _owner;
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(owner() == _msgSender(), "Ownable: caller is not the owner");
173         _;
174     }
175 
176     /**
177      * @dev Leaves the contract without owner. It will not be possible to call
178      * `onlyOwner` functions anymore. Can only be called by the current owner.
179      *
180      * NOTE: Renouncing ownership will leave the contract without an owner,
181      * thereby removing any functionality that is only available to the owner.
182      */
183     function renounceOwnership() public virtual onlyOwner {
184         _setOwner(address(0));
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Can only be called by the current owner.
190      */
191     function transferOwnership(address newOwner) public virtual onlyOwner {
192         require(
193             newOwner != address(0),
194             "Ownable: new owner is the zero address"
195         );
196         _setOwner(newOwner);
197     }
198 
199     function _setOwner(address newOwner) private {
200         address oldOwner = _owner;
201         _owner = newOwner;
202         emit OwnershipTransferred(oldOwner, newOwner);
203     }
204 }
205 
206 /**
207  * @dev Implementation of Vegion Token.
208  * @author Vegion Team
209  */
210 contract VegionToken is Context, IERC20, IERC20Metadata, Ownable {
211     mapping(address => uint256) private _balances;
212     mapping(address => uint256) private _freezes;
213     mapping(address => bool) private _addressExists;
214     mapping(uint256 => address) private _addresses;
215     uint256 private _addressCount = 0;
216     address private _addressDev;
217     address private _addressAd;
218 
219     mapping(address => mapping(address => uint256)) private _allowances;
220 
221     uint256 private _totalSupply;
222     uint256 private _totalBurn;
223     uint256 private _burnStop;
224 
225     string private _name = "VegionToken";
226     string private _symbol = "VT";
227 
228     mapping(address => bool) private _addressNoAirdrop;
229     mapping(address => uint256) private _addressAirdrop;
230     uint256 private _totalAirdrop = 0;
231     uint256 private _totalVt = 0;
232 
233     uint256 private _adBatchEnd = 0;
234     uint256 private _adBatchLast = 0;
235     uint256 private _adBatchTotal = 0;
236     uint256 private _adBatchVtTotal = 0;
237 
238     mapping(address => bool) private _admins;
239 
240     /**
241      * @dev constructor
242      */
243     constructor(address addressDev, address addressAd) {
244         require(addressDev != address(0), "constructor: dev address error");
245         require(addressAd != address(0), "constructor: airdrop address error");
246         require(
247             addressDev != addressAd,
248             "constructor: dev and airdrop not same"
249         );
250         _totalSupply = 100_000_000 * 10**decimals();
251         _totalBurn = 0;
252         _burnStop = 2_100_000 * 10**decimals();
253         // owner
254         _addressExists[_msgSender()] = true;
255         _addresses[_addressCount++] = _msgSender();
256         // dev
257         if (!_addressExists[addressDev]) {
258             _addressExists[addressDev] = true;
259             _addresses[_addressCount++] = addressDev;
260         }
261         _addressDev = addressDev;
262         // airdrop
263         if (!_addressExists[addressAd]) {
264             _addressExists[addressAd] = true;
265             _addresses[_addressCount++] = addressAd;
266         }
267         _addressAd = addressAd;
268 
269         _admins[_msgSender()] = true;
270     }
271 
272     /**
273      * @dev Returns the name of the token.
274      */
275     function name() public view virtual override returns (string memory) {
276         return _name;
277     }
278 
279     /**
280      * @dev Returns the symbol of the token, usually a shorter version of the
281      * name.
282      */
283     function symbol() public view virtual override returns (string memory) {
284         return _symbol;
285     }
286 
287     /**
288      * @dev Returns the number of decimals used to get its user representation.
289      */
290     function decimals() public view virtual override returns (uint8) {
291         return 8;
292     }
293 
294     /**
295      * @dev See {IERC20-totalSupply}.
296      */
297     function totalSupply() public view virtual override returns (uint256) {
298         return _totalSupply;
299     }
300 
301     /**
302      * @dev totalBurn.
303      */
304     function totalBurn() public view virtual returns (uint256) {
305         return _totalBurn;
306     }
307 
308     /**
309      * @dev See {IERC20-balanceOf}.
310      */
311     function balanceOf(address account)
312         public
313         view
314         virtual
315         override
316         returns (uint256)
317     {
318         return _balances[account];
319     }
320 
321     /**
322      * @dev See {IERC20-transfer}.
323      */
324     function transfer(address recipient, uint256 amount)
325         public
326         virtual
327         override
328         returns (bool)
329     {
330         _transferBurn(_msgSender(), recipient, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See {IERC20-allowance}.
336      */
337     function allowance(address owner, address spender)
338         public
339         view
340         virtual
341         override
342         returns (uint256)
343     {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      */
350     function approve(address spender, uint256 amount)
351         public
352         virtual
353         override
354         returns (bool)
355     {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-transferFrom}.
362      */
363     function transferFrom(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) public virtual override returns (bool) {
368         uint256 currentAllowance = _allowances[sender][_msgSender()];
369         require(
370             currentAllowance >= amount,
371             "transferFrom: transfer amount exceeds allowance"
372         );
373         unchecked {
374             _approve(sender, _msgSender(), currentAllowance - amount);
375         }
376 
377         _transfer(sender, recipient, amount);
378 
379         return true;
380     }
381 
382     /**
383      * @dev Atomically increases the allowance granted to `spender` by the caller.
384      */
385     function increaseAllowance(address spender, uint256 addedValue)
386         public
387         virtual
388         returns (bool)
389     {
390         _approve(
391             _msgSender(),
392             spender,
393             _allowances[_msgSender()][spender] + addedValue
394         );
395         return true;
396     }
397 
398     /**
399      * @dev Atomically decreases the allowance granted to `spender` by the caller.
400      */
401     function decreaseAllowance(address spender, uint256 subtractedValue)
402         public
403         virtual
404         returns (bool)
405     {
406         uint256 currentAllowance = _allowances[_msgSender()][spender];
407         require(
408             currentAllowance >= subtractedValue,
409             "decreaseAllowance: decreased allowance below zero"
410         );
411         unchecked {
412             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
413         }
414 
415         return true;
416     }
417 
418     /**
419      * @dev burn
420      */
421     function burn(uint256 amount) public virtual returns (bool) {
422         _burn(_msgSender(), amount);
423         return true;
424     }
425 
426     /**
427      * @dev get address count
428      */
429     function addressCount() public view onlyAdmin returns (uint256) {
430         return _addressCount;
431     }
432 
433     /**
434      * @dev check if address exist
435      */
436     function isAddressExist(address target)
437         public
438         view
439         onlyAdmin
440         returns (bool)
441     {
442         return _addressExists[target];
443     }
444 
445     /**
446      * @dev total airdrop vt
447      */
448     function totalAirdrop() public view onlyAdmin returns (uint256) {
449         return _totalAirdrop;
450     }
451 
452     /**
453      * @dev total address vt
454      */
455     function totalVt() public view onlyAdmin returns (uint256) {
456         return _totalVt;
457     }
458 
459     /**
460      * airdrop
461      */
462     function airdrop(address recipient, uint256 amount)
463         public
464         onlyAdmin
465         returns (bool)
466     {
467         require(
468             recipient != address(0),
469             "airdrop: airdrop to the zero address"
470         );
471 
472         // if recipient not exist
473         if (!_addressExists[recipient]) {
474             _addressExists[recipient] = true;
475             _addresses[_addressCount++] = recipient;
476         }
477         _balances[recipient] += amount;
478         _totalVt += amount;
479         emit Transfer(address(0), recipient, amount);
480 
481         return true;
482     }
483 
484     /**
485      * airdrops
486      */
487     function airdrops(address[] memory recipients, uint256[] memory amounts)
488         public
489         onlyAdmin
490         returns (bool)
491     {
492         require(
493             recipients.length == amounts.length,
494             "airdrops: length not equal"
495         );
496 
497         for (uint256 i = 0; i < recipients.length; i++) {
498             if (recipients[i] != address(0)) {
499                 airdrop(recipients[i], amounts[i]);
500             }
501         }
502         return true;
503     }
504 
505     /**
506      * airdropAll
507      */
508     function airdropAll() public onlyAdmin returns (bool) {
509         _airdrop(0, _addressCount, _totalAirdrop, _totalVt);
510         _totalAirdrop = 0;
511         return true;
512     }
513 
514     /**
515      * airdrop batch
516      */
517     function airdropBatch(uint256 count) public onlyAdmin returns (bool) {
518         if (_adBatchTotal <= 0) {
519             require(
520                 _totalAirdrop > 0,
521                 "airdropBatch: airdrop total should bigger than zero"
522             );
523             _adBatchTotal = _totalAirdrop;
524             _adBatchVtTotal = _totalVt;
525             _adBatchEnd = _addressCount;
526             _adBatchLast = 0;
527 
528             _totalAirdrop = 0;
529         }
530 
531         uint256 end = _adBatchLast + count >= _adBatchEnd
532             ? _adBatchEnd
533             : _adBatchLast + count;
534 
535         _airdrop(_adBatchLast, end, _adBatchTotal, _adBatchVtTotal);
536 
537         if (end >= _adBatchEnd) {
538             _adBatchTotal = 0;
539             _adBatchVtTotal = 0;
540             _adBatchEnd = 0;
541             _adBatchLast = 0;
542         } else {
543             _adBatchLast = end;
544         }
545 
546         return true;
547     }
548 
549     /**
550      * address can get airdrop or not
551      */
552     function isAddressNoAirdrop(address target)
553         public
554         view
555         onlyAdmin
556         returns (bool)
557     {
558         return _addressNoAirdrop[target];
559     }
560 
561     /**
562      * address airdrop
563      */
564     function addressAirdrop() public view returns (uint256) {
565         return _addressAirdrop[_msgSender()];
566     }
567 
568     /**
569      * receive airdrop
570      */
571     function receiveAirdrop() public returns (bool) {
572         require(
573             _addressAirdrop[_msgSender()] > 0,
574             "receiveAirdrop: no wait receive airdrop vt"
575         );
576         uint256 waitReceive = _addressAirdrop[_msgSender()];
577         require(
578             _balances[_addressAd] >= waitReceive,
579             "receiveAirdrop: not enough airdrop vt"
580         );
581         _balances[_msgSender()] += waitReceive;
582         _addressAirdrop[_msgSender()] = 0;
583         _balances[_addressAd] -= waitReceive;
584         _totalVt += waitReceive;
585         emit Transfer(_addressAd, _msgSender(), waitReceive);
586 
587         return true;
588     }
589 
590     /**
591      * setNoAirdrop for target address
592      */
593     function setNoAirdrop(address target, bool noAirdrop)
594         public
595         onlyAdmin
596         returns (bool)
597     {
598         require(
599             _addressNoAirdrop[target] != noAirdrop,
600             "setNoAirdrop: same setting."
601         );
602         _addressNoAirdrop[target] = noAirdrop;
603         return true;
604     }
605 
606     /**
607      * freeze
608      */
609     function freeze(address target, uint256 amount)
610         public
611         onlyAdmin
612         returns (bool)
613     {
614         require(_balances[target] >= amount, "freeze: freeze amount error");
615 
616         _balances[target] -= amount;
617         _freezes[target] += amount;
618         _totalVt -= amount;
619         emit Freeze(target, amount);
620         return true;
621     }
622 
623     /**
624      * unfreeze
625      */
626     function unfreeze(address target, uint256 amount)
627         public
628         onlyAdmin
629         returns (bool)
630     {
631         require(_freezes[target] >= amount, "unfreeze: unfreeze amount error");
632 
633         _balances[target] += amount;
634         _freezes[target] -= amount;
635         _totalVt += amount;
636         emit Unfreeze(target, amount);
637         return true;
638     }
639 
640     /**
641      * @dev See {IERC20-freezeOf}.
642      */
643     function freezeOf(address account) public view returns (uint256) {
644         return _freezes[account];
645     }
646 
647     /**
648      * @dev get dev
649      */
650     function getAddressDev() public view onlyAdmin returns (address) {
651         return _addressDev;
652     }
653 
654     /**
655      * @dev set new dev
656      */
657     function transferDev(address newDev) public onlyAdmin returns (bool) {
658         require(newDev != address(0), "transferDev: new address zero");
659         if (!_addressExists[newDev]) {
660             _addressExists[newDev] = true;
661             _addresses[_addressCount++] = newDev;
662         }
663         uint256 amount = _balances[_addressDev];
664         address oldDev = _addressDev;
665         _balances[newDev] = amount;
666         _balances[oldDev] = 0;
667         _addressDev = newDev;
668 
669         emit Transfer(oldDev, newDev, amount);
670 
671         return true;
672     }
673 
674     /**
675      * @dev get ad
676      */
677     function getAddressAd() public view onlyAdmin returns (address) {
678         return _addressAd;
679     }
680 
681     /**
682      * @dev set new ad
683      */
684     function transferAd(address newAd) public onlyAdmin returns (bool) {
685         require(newAd != address(0), "transferAd: new address zero");
686         if (!_addressExists[newAd]) {
687             _addressExists[newAd] = true;
688             _addresses[_addressCount++] = newAd;
689         }
690         uint256 amount = _balances[_addressAd];
691         address oldAd = _addressAd;
692         _balances[newAd] = amount;
693         _balances[oldAd] = 0;
694         _addressAd = newAd;
695 
696         emit Transfer(oldAd, newAd, amount);
697         return true;
698     }
699 
700     /**
701      * @dev admin modifier
702      */
703     modifier onlyAdmin() {
704         require(_admins[_msgSender()], "onlyAdmin: caller is not the admin");
705         _;
706     }
707 
708     function addAdmin(address admin) public onlyOwner {
709         require(admin != address(0), "addAdmin: admin is not zero");
710         require(!_admins[admin], "addAdmin: admin is already admin");
711         _admins[admin] = true;
712     }
713 
714     function removeAdmin(address admin) public onlyOwner {
715         require(admin != address(0), "removeAdmin: admin is not zero");
716         require(_admins[admin], "removeAdmin: admin is not admin");
717         _admins[admin] = false;
718     }
719 
720     function isAdmin(address admin) public view onlyOwner returns (bool) {
721         return _admins[admin];
722     }
723 
724     function _airdrop(
725         uint256 start,
726         uint256 end,
727         uint256 adTotal,
728         uint256 vtTotal
729     ) internal {
730         require(end > start, "_airdrop: end should bigger than start");
731         require(adTotal > 0, "_airdrop: airdrop total should bigger than zero");
732         require(vtTotal > 0, "_airdrop: vt total should bigger than zero");
733 
734         for (uint256 i = start; i < end; i++) {
735             address addr = _addresses[i];
736             uint256 balance = _balances[addr];
737             if (balance > 0 && addr != _addressAd) {
738                 uint256 airdropVt = (adTotal * balance) / vtTotal;
739                 if (_addressNoAirdrop[addr]) {
740                     _totalSupply -= airdropVt;
741                     _totalBurn += airdropVt;
742                     emit Transfer(_addressAd, address(0), airdropVt);
743                 } else {
744                     _addressAirdrop[addr] += airdropVt;
745                 }
746             }
747         }
748     }
749 
750     /**
751      * @dev Moves `amount` of tokens from `sender` to `recipient`.
752      */
753     function _transfer(
754         address sender,
755         address recipient,
756         uint256 amount
757     ) internal virtual {
758         require(
759             sender != address(0),
760             "_transfer: transfer from the zero address"
761         );
762         require(
763             recipient != address(0),
764             "_transfer: transfer to the zero address"
765         );
766 
767         uint256 senderBalance = _balances[sender];
768         require(
769             senderBalance >= amount,
770             "_transfer: transfer amount exceeds balance"
771         );
772         unchecked {
773             _balances[sender] = senderBalance - amount;
774         }
775 
776         // if recipient not exist
777         if (!_addressExists[recipient]) {
778             _addressExists[recipient] = true;
779             _addresses[_addressCount++] = recipient;
780         }
781 
782         _balances[recipient] += amount;
783         emit Transfer(sender, recipient, amount);
784     }
785 
786     /**
787      * @dev Moves `amount` of tokens from `sender` to `recipient`.
788      */
789     function _transferBurn(
790         address sender,
791         address recipient,
792         uint256 amount
793     ) internal virtual {
794         require(
795             sender != address(0),
796             "_transferBurn: transfer from the zero address"
797         );
798         require(
799             recipient != address(0),
800             "_transferBurn: transfer to the zero address"
801         );
802 
803         uint256 senderBalance = _balances[sender];
804         require(
805             senderBalance >= amount,
806             "_transferBurn: transfer amount exceeds balance"
807         );
808         unchecked {
809             _balances[sender] = senderBalance - amount;
810         }
811         // if recipient not exist
812         if (!_addressExists[recipient]) {
813             _addressExists[recipient] = true;
814             _addresses[_addressCount++] = recipient;
815         }
816 
817         if (_totalBurn < _burnStop) {
818             // 50% decrease
819             uint256 toRecipient = amount / 2;
820             _balances[recipient] += toRecipient;
821             emit Transfer(sender, recipient, toRecipient);
822             // 30% airdrop
823             uint256 toAirdrop = (amount * 3) / 10;
824             _balances[_addressAd] += toAirdrop;
825             _totalAirdrop += toAirdrop;
826             _totalVt -= toAirdrop;
827             emit Transfer(sender, _addressAd, toAirdrop);
828             // 5% developer
829             uint256 toDev = (amount * 5) / 100;
830             _balances[_addressDev] += toDev;
831             emit Transfer(sender, _addressDev, toDev);
832             // 15% burn
833             uint256 toBurn = (amount * 15) / 100;
834             _totalSupply -= toBurn;
835             _totalBurn += toBurn;
836             _totalVt -= toBurn;
837             emit Transfer(sender, address(0), toBurn);
838         } else {
839             _balances[recipient] += amount;
840             emit Transfer(sender, recipient, amount);
841         }
842     }
843 
844     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
845      * the total supply.
846      */
847     function _mint(address account, uint256 amount) internal virtual {
848         require(account != address(0), "VegionToken: mint to the zero address");
849 
850         _totalSupply += amount;
851         _balances[account] += amount;
852         emit Transfer(address(0), account, amount);
853     }
854 
855     /**
856      * @dev Destroys `amount` tokens from `account`, reducing the
857      * total supply.
858      */
859     function _burn(address account, uint256 amount) internal virtual {
860         require(account != address(0), "_burn: burn from the zero address");
861 
862         uint256 accountBalance = _balances[account];
863         require(accountBalance >= amount, "_burn: burn amount exceeds balance");
864         unchecked {
865             _balances[account] = accountBalance - amount;
866         }
867         _totalSupply -= amount;
868         _totalBurn += amount;
869         _totalVt -= amount;
870         emit Transfer(account, address(0), amount);
871     }
872 
873     /**
874      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
875      */
876     function _approve(
877         address owner,
878         address spender,
879         uint256 amount
880     ) internal virtual {
881         require(owner != address(0), "_approve: approve from the zero address");
882         require(spender != address(0), "_approve: approve to the zero address");
883 
884         _allowances[owner][spender] = amount;
885         emit Approval(owner, spender, amount);
886     }
887 
888     /**
889      * transfer balance to owner
890      */
891     function withdrawEther(uint256 amount) public onlyOwner {
892         require(
893             address(this).balance >= amount,
894             "withdrawEther: not enough ether balance."
895         );
896         payable(owner()).transfer(amount);
897     }
898 
899     /**
900      * can accept ether
901      */
902     receive() external payable {}
903 
904     /**
905      * @dev Emitted when `value` tokens are freezed.
906      */
907     event Freeze(address indexed target, uint256 value);
908 
909     /**
910      * @dev Emitted when `value` tokens are unfreezed.
911      */
912     event Unfreeze(address indexed target, uint256 value);
913 }