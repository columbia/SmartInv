1 pragma solidity ^0.4.24;
2 
3 interface IDRCWalletMgrParams {
4     function singleWithdrawMin() external returns (uint256); // min value of single withdraw
5     function singleWithdrawMax() external returns (uint256); // Max value of single withdraw
6     function dayWithdraw() external returns (uint256); // Max value of one day of withdraw
7     function monthWithdraw() external returns (uint256); // Max value of one month of withdraw
8     function dayWithdrawCount() external returns (uint256); // Max number of withdraw counting
9 
10     function chargeFee() external returns (uint256); // the charge fee for withdraw
11     function chargeFeePool() external returns (address); // the address that will get the returned charge fees.
12 }
13 
14 interface IDRCWalletStorage {
15     // get the deposit address for this _wallet address
16     function walletDeposits(address _wallet) external view returns (address);
17 
18     // get frozen status for the deposit address
19     function frozenDeposits(address _deposit) external view returns (bool);
20 
21     // get a wallet address by the deposit address and the index
22     function wallet(address _deposit, uint256 _ind) external view returns (address);
23 
24     // get a wallet name by the deposit address and the index
25     function walletName(address _deposit, uint256 _ind) external view returns (bytes32);
26 
27     // get the wallets number of a deposit address
28     function walletsNumber(address _deposit) external view returns (uint256);
29 
30     // get the frozen amount of the deposit address
31     function frozenAmount(address _deposit) external view returns (uint256);
32 
33     // get the balance of the deposit address
34     function balanceOf(address _deposit) external view returns (uint256);
35 
36     // get the deposit address by index
37     function depositAddressByIndex(uint256 _ind) external view returns (address);
38 
39     // get the frozen amount of the deposit address
40     function size() external view returns (uint256);
41 
42     // judge if the _deposit address exsisted.
43     function isExisted(address _deposit) external view returns (bool);
44 
45     // add one deposit address for that wallet
46     function addDeposit(address _wallet, address _depositAddr) external returns (bool);
47 
48     // change the default wallet address for the deposit address
49     function changeDefaultWallet(address _oldWallet, address _newWallet) external returns (bool);
50 
51     // freeze or release the tokens that has been deposited in the deposit address.
52     function freezeTokens(address _deposit, bool _freeze, uint256 _value) external returns (bool);
53 
54     // increase balance of this deposit address
55     function increaseBalance(address _deposit, uint256 _value) external returns (bool);
56 
57     // decrease balance of this deposit address
58     function decreaseBalance(address _deposit, uint256 _value) external returns (bool);
59 
60     // add withdraw address for one deposit addresss
61     function addWithdraw(address _deposit, bytes32 _name, address _withdraw) external returns (bool);
62 
63     // change the withdraw wallet name
64     function changeWalletName(address _deposit, bytes32 _newName, address _wallet) external returns (bool);
65 
66     // remove deposit contract address from storage
67     function removeDeposit(address _depositAddr) external returns (bool);
68 
69     // withdraw tokens from this contract
70     function withdrawToken(address _token, address _to, uint256 _value) external returns (bool);
71 }
72 
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     c = _a * _b;
87     assert(c / _a == _b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     // assert(_b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = _a / _b;
97     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
98     return _a / _b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     assert(_b <= _a);
106     return _a - _b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
113     c = _a + _b;
114     assert(c >= _a);
115     return c;
116   }
117 }
118 
119 contract Ownable {
120   address public owner;
121 
122 
123   event OwnershipRenounced(address indexed previousOwner);
124   event OwnershipTransferred(
125     address indexed previousOwner,
126     address indexed newOwner
127   );
128 
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   constructor() public {
135     owner = msg.sender;
136   }
137 
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146   /**
147    * @dev Allows the current owner to relinquish control of the contract.
148    * @notice Renouncing to ownership will leave the contract without an owner.
149    * It will not be possible to call the functions with the `onlyOwner`
150    * modifier anymore.
151    */
152   function renounceOwnership() public onlyOwner {
153     emit OwnershipRenounced(owner);
154     owner = address(0);
155   }
156 
157   /**
158    * @dev Allows the current owner to transfer control of the contract to a newOwner.
159    * @param _newOwner The address to transfer ownership to.
160    */
161   function transferOwnership(address _newOwner) public onlyOwner {
162     _transferOwnership(_newOwner);
163   }
164 
165   /**
166    * @dev Transfers control of the contract to a newOwner.
167    * @param _newOwner The address to transfer ownership to.
168    */
169   function _transferOwnership(address _newOwner) internal {
170     require(_newOwner != address(0));
171     emit OwnershipTransferred(owner, _newOwner);
172     owner = _newOwner;
173   }
174 }
175 
176 contract Withdrawable is Ownable {
177     event ReceiveEther(address _from, uint256 _value);
178     event WithdrawEther(address _to, uint256 _value);
179     event WithdrawToken(address _token, address _to, uint256 _value);
180 
181     /**
182          * @dev recording receiving ether from msn.sender
183          */
184     function () payable public {
185         emit ReceiveEther(msg.sender, msg.value);
186     }
187 
188     /**
189          * @dev withdraw,send ether to target
190          * @param _to is where the ether will be sent to
191          *        _amount is the number of the ether
192          */
193     function withdraw(address _to, uint _amount) public onlyOwner returns (bool) {
194         require(_to != address(0));
195         _to.transfer(_amount);
196         emit WithdrawEther(_to, _amount);
197 
198         return true;
199     }
200 
201     /**
202          * @dev withdraw tokens, send tokens to target
203      *
204      * @param _token the token address that will be withdraw
205          * @param _to is where the tokens will be sent to
206          *        _value is the number of the token
207          */
208     function withdrawToken(address _token, address _to, uint256 _value) public onlyOwner returns (bool) {
209         require(_to != address(0));
210         require(_token != address(0));
211 
212         ERC20 tk = ERC20(_token);
213         tk.transfer(_to, _value);
214         emit WithdrawToken(_token, _to, _value);
215 
216         return true;
217     }
218 
219     /**
220      * @dev receive approval from an ERC20 token contract, and then gain the tokens,
221      *      then take a record
222      *
223      * @param _from address The address which you want to send tokens from
224      * @param _value uint256 the amounts of tokens to be sent
225      * @param _token address the ERC20 token address
226      * @param _extraData bytes the extra data for the record
227      */
228     // function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
229     //     require(_token != address(0));
230     //     require(_from != address(0));
231 
232     //     ERC20 tk = ERC20(_token);
233     //     require(tk.transferFrom(_from, this, _value));
234 
235     //     emit ReceiveDeposit(_from, _value, _token, _extraData);
236     // }
237 }
238 
239 contract TokenDestructible is Ownable {
240 
241   constructor() public payable { }
242 
243   /**
244    * @notice Terminate contract and refund to owner
245    * @param _tokens List of addresses of ERC20 or ERC20Basic token contracts to
246    refund.
247    * @notice The called token contracts could try to re-enter this contract. Only
248    supply token contracts you trust.
249    */
250   function destroy(address[] _tokens) public onlyOwner {
251 
252     // Transfer tokens to owner
253     for (uint256 i = 0; i < _tokens.length; i++) {
254       ERC20Basic token = ERC20Basic(_tokens[i]);
255       uint256 balance = token.balanceOf(this);
256       token.transfer(owner, balance);
257     }
258 
259     // Transfer Eth to owner and terminate contract
260     selfdestruct(owner);
261   }
262 }
263 
264 contract Claimable is Ownable {
265   address public pendingOwner;
266 
267   /**
268    * @dev Modifier throws if called by any account other than the pendingOwner.
269    */
270   modifier onlyPendingOwner() {
271     require(msg.sender == pendingOwner);
272     _;
273   }
274 
275   /**
276    * @dev Allows the current owner to set the pendingOwner address.
277    * @param newOwner The address to transfer ownership to.
278    */
279   function transferOwnership(address newOwner) public onlyOwner {
280     pendingOwner = newOwner;
281   }
282 
283   /**
284    * @dev Allows the pendingOwner address to finalize the transfer.
285    */
286   function claimOwnership() public onlyPendingOwner {
287     emit OwnershipTransferred(owner, pendingOwner);
288     owner = pendingOwner;
289     pendingOwner = address(0);
290   }
291 }
292 
293 contract DepositWithdraw is Claimable, Withdrawable, TokenDestructible {
294     using SafeMath for uint256;
295 
296     /**
297      * transaction record
298      */
299     struct TransferRecord {
300         uint256 timeStamp;
301         address account;
302         uint256 value;
303     }
304 
305     /**
306      * accumulated transferring amount record
307      */
308     struct accumulatedRecord {
309         uint256 mul;
310         uint256 count;
311         uint256 value;
312     }
313 
314     TransferRecord[] deposRecs; // record all the deposit tx data
315     TransferRecord[] withdrRecs; // record all the withdraw tx data
316 
317     accumulatedRecord dayWithdrawRec; // accumulated amount record for one day
318     accumulatedRecord monthWithdrawRec; // accumulated amount record for one month
319 
320     address wallet; // the binded withdraw address
321 
322     event ReceiveDeposit(address _from, uint256 _value, address _token, bytes _extraData);
323 
324     /**
325      * @dev constructor of the DepositWithdraw contract
326      * @param _wallet the binded wallet address to this depositwithdraw contract
327      */
328     constructor(address _wallet) public {
329         require(_wallet != address(0));
330         wallet = _wallet;
331     }
332 
333     /**
334          * @dev set the default wallet address
335          * @param _wallet the default wallet address binded to this deposit contract
336          */
337     function setWithdrawWallet(address _wallet) onlyOwner public returns (bool) {
338         require(_wallet != address(0));
339         wallet = _wallet;
340 
341         return true;
342     }
343 
344     /**
345          * @dev util function to change bytes data to bytes32 data
346          * @param _data the bytes data to be converted
347          */
348     function bytesToBytes32(bytes _data) public pure returns (bytes32 result) {
349         assembly {
350             result := mload(add(_data, 32))
351         }
352     }
353 
354     /**
355      * @dev receive approval from an ERC20 token contract, take a record
356      *
357      * @param _from address The address which you want to send tokens from
358      * @param _value uint256 the amounts of tokens to be sent
359      * @param _token address the ERC20 token address
360      * @param _extraData bytes the extra data for the record
361      */
362     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) onlyOwner public {
363         require(_token != address(0));
364         require(_from != address(0));
365 
366         ERC20 tk = ERC20(_token);
367         require(tk.transferFrom(_from, this, _value));
368         bytes32 timestamp = bytesToBytes32(_extraData);
369         deposRecs.push(TransferRecord(uint256(timestamp), _from, _value));
370         emit ReceiveDeposit(_from, _value, _token, _extraData);
371     }
372 
373     // function authorize(address _token, address _spender, uint256 _value) onlyOwner public returns (bool) {
374     //     ERC20 tk = ERC20(_token);
375     //     require(tk.approve(_spender, _value));
376 
377     //     return true;
378     // }
379 
380     /**
381      * @dev record withdraw into this contract
382      *
383      * @param _time the timstamp of the withdraw time
384      * @param _to is where the tokens will be sent to
385      * @param _value is the number of the token
386      */
387     function recordWithdraw(uint256 _time, address _to, uint256 _value) onlyOwner public {
388         withdrRecs.push(TransferRecord(_time, _to, _value));
389     }
390 
391     /**
392      * @dev check if withdraw amount is not valid
393      *
394      * @param _params the limitation parameters for withdraw
395      * @param _value is the number of the token
396      * @param _time the timstamp of the withdraw time
397      */
398     function checkWithdrawAmount(address _params, uint256 _value, uint256 _time) public returns (bool) {
399         IDRCWalletMgrParams params = IDRCWalletMgrParams(_params);
400         require(_value <= params.singleWithdrawMax());
401         require(_value >= params.singleWithdrawMin());
402 
403         uint256 daysCount = _time.div(86400); // one day of seconds
404         if (daysCount <= dayWithdrawRec.mul) {
405             dayWithdrawRec.count = dayWithdrawRec.count.add(1);
406             dayWithdrawRec.value = dayWithdrawRec.value.add(_value);
407             require(dayWithdrawRec.count <= params.dayWithdrawCount());
408             require(dayWithdrawRec.value <= params.dayWithdraw());
409         } else {
410             dayWithdrawRec.mul = daysCount;
411             dayWithdrawRec.count = 1;
412             dayWithdrawRec.value = _value;
413         }
414 
415         uint256 monthsCount = _time.div(86400 * 30);
416         if (monthsCount <= monthWithdrawRec.mul) {
417             monthWithdrawRec.count = monthWithdrawRec.count.add(1);
418             monthWithdrawRec.value = monthWithdrawRec.value.add(_value);
419             require(monthWithdrawRec.value <= params.monthWithdraw());
420         } else {
421             monthWithdrawRec.mul = monthsCount;
422             monthWithdrawRec.count = 1;
423             monthWithdrawRec.value = _value;
424         }
425 
426         return true;
427     }
428 
429     /**
430          * @dev withdraw tokens, send tokens to target
431      *
432      * @param _token the token address that will be withdraw
433      * @param _params the limitation parameters for withdraw
434      * @param _time the timstamp of the withdraw time
435          * @param _to is where the tokens will be sent to
436          *        _value is the number of the token
437      *        _fee is the amount of the transferring costs
438      *        _tokenReturn is the address that return back the tokens of the _fee
439          */
440     function withdrawToken(address _token, address _params, uint256 _time, address _to, uint256 _value, uint256 _fee, address _tokenReturn) public onlyOwner returns (bool) {
441         require(_to != address(0));
442         require(_token != address(0));
443         require(_value > _fee);
444         // require(_tokenReturn != address(0));
445 
446         require(checkWithdrawAmount(_params, _value, _time));
447 
448         ERC20 tk = ERC20(_token);
449         uint256 realAmount = _value.sub(_fee);
450         require(tk.transfer(_to, realAmount));
451         if (_tokenReturn != address(0) && _fee > 0) {
452             require(tk.transfer(_tokenReturn, _fee));
453         }
454 
455         recordWithdraw(_time, _to, realAmount);
456         emit WithdrawToken(_token, _to, realAmount);
457 
458         return true;
459     }
460 
461     /**
462          * @dev withdraw tokens, send tokens to target default wallet
463      *
464      * @param _token the token address that will be withdraw
465      * @param _params the limitation parameters for withdraw
466      * @param _time the timestamp occur the withdraw record
467          * @param _value is the number of the token
468      *        _fee is the amount of the transferring costs
469      *        —tokenReturn is the address that return back the tokens of the _fee
470          */
471     function withdrawTokenToDefault(address _token, address _params, uint256 _time, uint256 _value, uint256 _fee, address _tokenReturn) public onlyOwner returns (bool) {
472         return withdrawToken(_token, _params, _time, wallet, _value, _fee, _tokenReturn);
473     }
474 
475     /**
476          * @dev get the Deposit records number
477      *
478      */
479     function getDepositNum() public view returns (uint256) {
480         return deposRecs.length;
481     }
482 
483     /**
484          * @dev get the one of the Deposit records
485      *
486      * @param _ind the deposit record index
487      */
488     function getOneDepositRec(uint256 _ind) public view returns (uint256, address, uint256) {
489         require(_ind < deposRecs.length);
490 
491         return (deposRecs[_ind].timeStamp, deposRecs[_ind].account, deposRecs[_ind].value);
492     }
493 
494     /**
495          * @dev get the withdraw records number
496      *
497      */
498     function getWithdrawNum() public view returns (uint256) {
499         return withdrRecs.length;
500     }
501 
502     /**
503          * @dev get the one of the withdraw records
504      *
505      * @param _ind the withdraw record index
506      */
507     function getOneWithdrawRec(uint256 _ind) public view returns (uint256, address, uint256) {
508         require(_ind < withdrRecs.length);
509 
510         return (withdrRecs[_ind].timeStamp, withdrRecs[_ind].account, withdrRecs[_ind].value);
511     }
512 }
513 
514 contract DelayedClaimable is Claimable {
515 
516   uint256 public end;
517   uint256 public start;
518 
519   /**
520    * @dev Used to specify the time period during which a pending
521    * owner can claim ownership.
522    * @param _start The earliest time ownership can be claimed.
523    * @param _end The latest time ownership can be claimed.
524    */
525   function setLimits(uint256 _start, uint256 _end) public onlyOwner {
526     require(_start <= _end);
527     end = _end;
528     start = _start;
529   }
530 
531   /**
532    * @dev Allows the pendingOwner address to finalize the transfer, as long as it is called within
533    * the specified start and end time.
534    */
535   function claimOwnership() public onlyPendingOwner {
536     require((block.number <= end) && (block.number >= start));
537     emit OwnershipTransferred(owner, pendingOwner);
538     owner = pendingOwner;
539     pendingOwner = address(0);
540     end = 0;
541   }
542 
543 }
544 
545 contract OwnerContract is DelayedClaimable {
546     Claimable public ownedContract;
547     address public pendingOwnedOwner;
548     // address internal origOwner;
549 
550     /**
551      * @dev bind a contract as its owner
552      *
553      * @param _contract the contract address that will be binded by this Owner Contract
554      */
555     function bindContract(address _contract) onlyOwner public returns (bool) {
556         require(_contract != address(0));
557         ownedContract = Claimable(_contract);
558         // origOwner = ownedContract.owner();
559 
560         // take ownership of the owned contract
561         if (ownedContract.owner() != address(this)) {
562             ownedContract.claimOwnership();
563         }
564 
565         return true;
566     }
567 
568     /**
569      * @dev change the owner of the contract from this contract address to the original one.
570      *
571      */
572     // function transferOwnershipBack() onlyOwner public {
573     //     ownedContract.transferOwnership(origOwner);
574     //     ownedContract = Claimable(address(0));
575     //     origOwner = address(0);
576     // }
577 
578     /**
579      * @dev change the owner of the contract from this contract address to another one.
580      *
581      * @param _nextOwner the contract address that will be next Owner of the original Contract
582      */
583     function changeOwnershipto(address _nextOwner)  onlyOwner public {
584         require(ownedContract != address(0));
585 
586         if (ownedContract.owner() != pendingOwnedOwner) {
587             ownedContract.transferOwnership(_nextOwner);
588             pendingOwnedOwner = _nextOwner;
589             // ownedContract = Claimable(address(0));
590             // origOwner = address(0);
591         } else {
592             // the pending owner has already taken the ownership
593             ownedContract = Claimable(address(0));
594             pendingOwnedOwner = address(0);
595         }
596     }
597 
598     /**
599      * @dev to confirm the owner of the owned contract has already been transferred.
600      *
601      */
602     function ownedOwnershipTransferred() onlyOwner public returns (bool) {
603         require(ownedContract != address(0));
604         if (ownedContract.owner() == pendingOwnedOwner) {
605             // the pending owner has already taken the ownership
606             ownedContract = Claimable(address(0));
607             pendingOwnedOwner = address(0);
608             return true;
609         } else {
610             return false;
611         }
612     }
613 }
614 
615 contract DRCWalletManager is OwnerContract, Withdrawable, TokenDestructible {
616     using SafeMath for uint256;
617 
618     /**
619      * withdraw wallet description
620      */
621     // struct WithdrawWallet {
622     //     bytes32 name;
623     //     address walletAddr;
624     // }
625 
626     /**
627      * Deposit data storage
628      */
629     // struct DepositRepository {
630     //     // uint256 balance;
631     //     uint256 frozen;
632     //     WithdrawWallet[] withdrawWallets;
633     //     // mapping (bytes32 => address) withdrawWallets;
634     // }
635 
636     // mapping (address => DepositRepository) depositRepos;
637     // mapping (address => address) public walletDeposits;
638     // mapping (address => bool) public frozenDeposits;
639 
640     ERC20 public tk; // the token will be managed
641     IDRCWalletMgrParams public params; // the parameters that the management needs
642     IDRCWalletStorage public walletStorage; // the deposits and wallets data stored in a contract
643 
644     event CreateDepositAddress(address indexed _wallet, address _deposit);
645     event FrozenTokens(address indexed _deposit, bool _freeze, uint256 _value);
646     event ChangeDefaultWallet(address indexed _oldWallet, address _newWallet);
647 
648     /**
649          * @dev initialize this contract with token, parameters and storage address
650      *
651      * @param _token the token address that will be withdraw
652      * @param _walletParams the wallet management parameters
653          */
654     function initialize(address _token, address _walletParams, address _walletStorage) onlyOwner public returns (bool) {
655         require(_token != address(0));
656         require(_walletParams != address(0));
657 
658         tk = ERC20(_token);
659         params = IDRCWalletMgrParams(_walletParams);
660         walletStorage = IDRCWalletStorage(_walletStorage);
661 
662         return true;
663     }
664 
665     /**
666          * @dev create deposit contract address for the default withdraw wallet
667      *
668      * @param _wallet the binded default withdraw wallet address
669          */
670     function createDepositContract(address _wallet) onlyOwner public returns (address) {
671         require(_wallet != address(0));
672 
673         DepositWithdraw deposWithdr = new DepositWithdraw(_wallet); // new contract for deposit
674         address _deposit = address(deposWithdr);
675         // walletDeposits[_wallet] = _deposit;
676         // WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
677         // withdrawWalletList.push(WithdrawWallet("default wallet", _wallet));
678         // // depositRepos[_deposit].balance = 0;
679         // depositRepos[_deposit].frozen = 0;
680 
681         walletStorage.addDeposit(_wallet, _deposit);
682 
683         // deposWithdr.authorize(address(tk), this, 1e27); // give authorization to owner contract
684 
685         emit CreateDepositAddress(_wallet, _deposit);
686         return _deposit;
687     }
688 
689     /**
690          * @dev deposit a value of funds to the deposit address
691      *
692      * @param _deposit the deposit address
693      * @param _increase increase or decrease the value
694      * @param _value the deposit funds value
695          */
696     function doDeposit(address _deposit, bool _increase, uint256 _value) onlyOwner public returns (bool) {
697         return (_increase
698                 ? walletStorage.increaseBalance(_deposit, _value)
699                 : walletStorage.decreaseBalance(_deposit, _value));
700     }
701 
702     /**
703          * @dev get deposit contract address by using the default withdraw wallet
704      *
705      * @param _wallet the binded default withdraw wallet address
706          */
707     function getDepositAddress(address _wallet) onlyOwner public view returns (address) {
708         require(_wallet != address(0));
709         // address deposit = walletDeposits[_wallet];
710 
711         // return deposit;
712         return walletStorage.walletDeposits(_wallet);
713     }
714 
715     /**
716          * @dev get deposit balance and frozen amount by using the deposit address
717      *
718      * @param _deposit the deposit contract address
719          */
720     function getDepositInfo(address _deposit) onlyOwner public view returns (uint256, uint256) {
721         require(_deposit != address(0));
722         uint256 _balance = walletStorage.balanceOf(_deposit);
723         // uint256 frozenAmount = depositRepos[_deposit].frozen;
724         uint256 frozenAmount = walletStorage.frozenAmount(_deposit);
725         // depositRepos[_deposit].balance = _balance;
726 
727         return (_balance, frozenAmount);
728     }
729 
730     /**
731          * @dev get the number of withdraw wallet addresses bindig to the deposit contract address
732      *
733      * @param _deposit the deposit contract address
734          */
735     function getDepositWithdrawCount(address _deposit) onlyOwner public view returns (uint) {
736         require(_deposit != address(0));
737 
738         // WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
739         // uint len = withdrawWalletList.length;
740         uint len = walletStorage.walletsNumber(_deposit);
741 
742         return len;
743     }
744 
745     /**
746          * @dev get the withdraw wallet addresses list binding to the deposit contract address
747      *
748      * @param _deposit the deposit contract address
749      * @param _indices the array of indices of the withdraw wallets
750          */
751     function getDepositWithdrawList(address _deposit, uint[] _indices) onlyOwner public view returns (bytes32[], address[]) {
752         require(_indices.length != 0);
753 
754         bytes32[] memory names = new bytes32[](_indices.length);
755         address[] memory wallets = new address[](_indices.length);
756 
757         for (uint i = 0; i < _indices.length; i = i.add(1)) {
758             // WithdrawWallet storage wallet = depositRepos[_deposit].withdrawWallets[_indices[i]];
759             // names[i] = wallet.name;
760             // wallets[i] = wallet.walletAddr;
761             names[i] = walletStorage.walletName(_deposit, i);
762             wallets[i] = walletStorage.wallet(_deposit, i);
763         }
764 
765         return (names, wallets);
766     }
767 
768     /**
769          * @dev change the default withdraw wallet address binding to the deposit contract address
770      *
771      * @param _oldWallet the previous default withdraw wallet
772      * @param _newWallet the new default withdraw wallet
773          */
774     function changeDefaultWithdraw(address _oldWallet, address _newWallet) onlyOwner public returns (bool) {
775         require(_oldWallet != address(0));
776         require(_newWallet != address(0));
777 
778         address deposit = walletStorage.walletDeposits(_oldWallet);
779         DepositWithdraw deposWithdr = DepositWithdraw(deposit);
780         require(deposWithdr.setWithdrawWallet(_newWallet));
781 
782         // WithdrawWallet[] storage withdrawWalletList = depositRepos[deposit].withdrawWallets;
783         // withdrawWalletList[0].walletAddr = _newWallet;
784         bool res = walletStorage.changeDefaultWallet(_oldWallet, _newWallet);
785         emit ChangeDefaultWallet(_oldWallet, _newWallet);
786 
787         return res;
788     }
789 
790     /**
791          * @dev freeze the tokens in the deposit address
792      *
793      * @param _deposit the deposit address
794      * @param _freeze to freeze or release
795      * @param _value the amount of tokens need to be frozen
796          */
797     function freezeTokens(address _deposit, bool _freeze, uint256 _value) onlyOwner public returns (bool) {
798         // require(_deposit != address(0));
799 
800         // frozenDeposits[_deposit] = _freeze;
801         // if (_freeze) {
802         //     depositRepos[_deposit].frozen = depositRepos[_deposit].frozen.add(_value);
803         // } else {
804         //     require(_value <= depositRepos[_deposit].frozen);
805         //     depositRepos[_deposit].frozen = depositRepos[_deposit].frozen.sub(_value);
806         // }
807 
808         bool res = walletStorage.freezeTokens(_deposit, _freeze, _value);
809 
810         emit FrozenTokens(_deposit, _freeze, _value);
811         return res;
812     }
813 
814     /**
815          * @dev withdraw the tokens from the deposit address to default wallet with charge fee
816      *
817      * @param _deposit the deposit address
818      * @param _time the timestamp the withdraw occurs
819      * @param _value the amount of tokens need to be frozen
820      * @param _check if we will check the value is valid or meet the limit condition
821          */
822     function withdrawWithFee(address _deposit, uint256 _time, uint256 _value, bool _check) onlyOwner public returns (bool) {
823         // WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
824         // return withdrawWithFee(_deposit, _time, withdrawWalletList[0].name, withdrawWalletList[0].walletAddr, _value, _check);
825         bytes32 defaultWalletName = walletStorage.walletName(_deposit, 0);
826         address defaultWallet = walletStorage.wallet(_deposit, 0);
827         return withdrawWithFee(_deposit, _time, defaultWalletName, defaultWallet, _value, _check);
828     }
829 
830     /**
831          * @dev check if the wallet name is not matching the expected wallet address
832      *
833      * @param _deposit the deposit address
834      * @param _name the withdraw wallet name
835      * @param _to the withdraw wallet address
836          */
837     function checkWithdrawAddress(address _deposit, bytes32 _name, address _to) public view returns (bool, bool) {
838         // uint len = depositRepos[_deposit].withdrawWallets.length;
839         uint len = walletStorage.walletsNumber(_deposit);
840         for (uint i = 0; i < len; i = i.add(1)) {
841             // WithdrawWallet memory wallet = depositRepos[_deposit].withdrawWallets[i];
842             // if (_name == wallet.name) {
843             //     return(true, (_to == wallet.walletAddr));
844             // }
845             // if (_to == wallet.walletAddr) {
846             //     return(true, true);
847             // }
848             bytes32 walletName = walletStorage.walletName(_deposit, i);
849             address walletAddr = walletStorage.wallet(_deposit, i);
850             if (_name == walletName) {
851                 return(true, (_to == walletAddr));
852             }
853             if (_to == walletAddr) {
854                 return(false, true);
855             }
856         }
857 
858         return (false, false);
859     }
860 
861     /**
862          * @dev withdraw tokens from this contract, send tokens to target withdraw wallet
863      *
864      * @param _deposWithdr the deposit contract that will record withdrawing
865      * @param _time the timestamp occur the withdraw record
866      * @param _to the address the token will be transfer to
867      * @param _value the token transferred value
868          */
869     function withdrawFromThis(DepositWithdraw _deposWithdr, uint256 _time, address _to, uint256 _value) private returns (bool) {
870         uint256 fee = params.chargeFee();
871         uint256 realAmount = _value.sub(fee);
872         address tokenReturn = params.chargeFeePool();
873         if (tokenReturn != address(0) && fee > 0) {
874             // require(tk.transfer(tokenReturn, fee));
875             require(walletStorage.withdrawToken(tk, tokenReturn, fee));
876         }
877 
878         // require (tk.transfer(_to, realAmount));
879         require(walletStorage.withdrawToken(tk, _to, realAmount));
880         _deposWithdr.recordWithdraw(_time, _to, realAmount);
881 
882         return true;
883     }
884 
885     /**
886          * @dev withdraw tokens, send tokens to target withdraw wallet
887      *
888      * @param _deposit the deposit address that will be withdraw from
889      * @param _time the timestamp occur the withdraw record
890          * @param _name the withdraw address alias name to verify
891      * @param _to the address the token will be transfer to
892      * @param _value the token transferred value
893      * @param _check if we will check the value is valid or meet the limit condition
894          */
895     function withdrawWithFee(address _deposit,
896                              uint256 _time,
897                              bytes32 _name,
898                              address _to,
899                              uint256 _value,
900                              bool _check) onlyOwner public returns (bool) {
901         require(_deposit != address(0));
902         require(_to != address(0));
903 
904         uint256 totalBalance = walletStorage.balanceOf(_deposit);
905         uint256 frozen = walletStorage.frozenAmount(_deposit);
906         // uint256 available = totalBalance.sub(frozen);
907         // require(_value <= available);
908         if (_check) {
909             require(_value <= totalBalance.sub(frozen));
910         }
911 
912         uint256 _balance = tk.balanceOf(_deposit);
913 
914         bool exist;
915         bool correct;
916         // WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
917         (exist, correct) = checkWithdrawAddress(_deposit, _name, _to);
918         if(!exist) {
919             // withdrawWalletList.push(WithdrawWallet(_name, _to));
920             if (!correct) {
921                 walletStorage.addWithdraw(_deposit, _name, _to);
922             } else {
923                 walletStorage.changeWalletName(_deposit, _name, _to);
924             }
925         } else {
926             require(correct, "wallet address must be correct with wallet name!");
927         }
928 
929         DepositWithdraw deposWithdr = DepositWithdraw(_deposit);
930         /**
931          * if deposit address doesn't have enough tokens to withdraw,
932          * then withdraw from this contract. Record this in the independent deposit contract.
933          */
934         if (_value > _balance) {
935             require(deposWithdr.checkWithdrawAmount(address(params), _value, _time));
936             if(_balance > 0) {
937                 require(deposWithdr.withdrawToken(address(tk), address(walletStorage), _balance));
938             }
939 
940             require(withdrawFromThis(deposWithdr, _time, _to, _value));
941             // return true;
942         } else {
943             require(deposWithdr.withdrawToken(address(tk), address(params), _time, _to, _value, params.chargeFee(), params.chargeFeePool()));
944         }
945 
946         return walletStorage.decreaseBalance(_deposit, _value);
947     }
948 
949     /**
950          * @dev destory the old depoist contract and take back the tokens
951      *
952      * @param _deposit the deposit address
953          */
954     function destroyDepositContract(address _deposit) onlyOwner public returns (bool) {
955         require(_deposit != address(0));
956 
957         DepositWithdraw deposWithdr = DepositWithdraw(_deposit);
958         address[] memory tokens = new address[](1);
959         tokens[0] = address(tk);
960         deposWithdr.destroy(tokens);
961 
962         return walletStorage.removeDeposit(_deposit);
963     }
964 
965 }
966 
967 contract ERC20Basic {
968   function totalSupply() public view returns (uint256);
969   function balanceOf(address _who) public view returns (uint256);
970   function transfer(address _to, uint256 _value) public returns (bool);
971   event Transfer(address indexed from, address indexed to, uint256 value);
972 }
973 
974 contract ERC20 is ERC20Basic {
975   function allowance(address _owner, address _spender)
976     public view returns (uint256);
977 
978   function transferFrom(address _from, address _to, uint256 _value)
979     public returns (bool);
980 
981   function approve(address _spender, uint256 _value) public returns (bool);
982   event Approval(
983     address indexed owner,
984     address indexed spender,
985     uint256 value
986   );
987 }