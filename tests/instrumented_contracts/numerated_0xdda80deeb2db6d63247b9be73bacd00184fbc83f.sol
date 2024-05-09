1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Autonomy is Ownable {
81     address public congress;
82     bool init = false;
83 
84     modifier onlyCongress() {
85         require(msg.sender == congress);
86         _;
87     }
88 
89     /**
90      * @dev initialize a Congress contract address for this token 
91      *
92      * @param _congress address the congress contract address
93      */
94     function initialCongress(address _congress) onlyOwner public {
95         require(!init);
96         require(_congress != address(0));
97         congress = _congress;
98         init = true;
99     }
100 
101     /**
102      * @dev set a Congress contract address for this token
103      * must change this address by the last congress contract 
104      *
105      * @param _congress address the congress contract address
106      */
107     function changeCongress(address _congress) onlyCongress public {
108         require(_congress != address(0));
109         congress = _congress;
110     }
111 }
112 
113 contract withdrawable is Ownable {
114     event ReceiveEther(address _from, uint256 _value);
115     event WithdrawEther(address _to, uint256 _value);
116     event WithdrawToken(address _token, address _to, uint256 _value);
117 
118     /**
119 	 * @dev recording receiving ether from msn.sender
120 	 */
121     function () payable public {
122         emit ReceiveEther(msg.sender, msg.value);
123     }
124 
125     /**
126 	 * @dev withdraw,send ether to target
127 	 * @param _to is where the ether will be sent to
128 	 *        _amount is the number of the ether
129 	 */
130     function withdraw(address _to, uint _amount) public onlyOwner returns (bool) {
131         require(_to != address(0));
132         _to.transfer(_amount);
133         emit WithdrawEther(_to, _amount);
134 
135         return true;
136     }
137 
138     /**
139 	 * @dev withdraw tokens, send tokens to target
140      *
141      * @param _token the token address that will be withdraw
142 	 * @param _to is where the tokens will be sent to
143 	 *        _value is the number of the token
144 	 */
145     function withdrawToken(address _token, address _to, uint256 _value) public onlyOwner returns (bool) {
146         require(_to != address(0));
147         require(_token != address(0));
148 
149         ERC20 tk = ERC20(_token);
150         tk.transfer(_to, _value);
151         emit WithdrawToken(_token, _to, _value);
152 
153         return true;
154     }
155 
156     /**
157      * @dev receive approval from an ERC20 token contract, and then gain the tokens, 
158      *      then take a record
159      *
160      * @param _from address The address which you want to send tokens from
161      * @param _value uint256 the amounts of tokens to be sent
162      * @param _token address the ERC20 token address
163      * @param _extraData bytes the extra data for the record
164      */
165     // function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
166     //     require(_token != address(0));
167     //     require(_from != address(0));
168         
169     //     ERC20 tk = ERC20(_token);
170     //     require(tk.transferFrom(_from, this, _value));
171         
172     //     emit ReceiveDeposit(_from, _value, _token, _extraData);
173     // }
174 }
175 
176 contract Destructible is Ownable {
177 
178   function Destructible() public payable { }
179 
180   /**
181    * @dev Transfers the current balance to the owner and terminates the contract.
182    */
183   function destroy() onlyOwner public {
184     selfdestruct(owner);
185   }
186 
187   function destroyAndSend(address _recipient) onlyOwner public {
188     selfdestruct(_recipient);
189   }
190 }
191 
192 contract TokenDestructible is Ownable {
193 
194   function TokenDestructible() public payable { }
195 
196   /**
197    * @notice Terminate contract and refund to owner
198    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
199    refund.
200    * @notice The called token contracts could try to re-enter this contract. Only
201    supply token contracts you trust.
202    */
203   function destroy(address[] tokens) onlyOwner public {
204 
205     // Transfer tokens to owner
206     for (uint256 i = 0; i < tokens.length; i++) {
207       ERC20Basic token = ERC20Basic(tokens[i]);
208       uint256 balance = token.balanceOf(this);
209       token.transfer(owner, balance);
210     }
211 
212     // Transfer Eth to owner and terminate contract
213     selfdestruct(owner);
214   }
215 }
216 
217 contract Claimable is Ownable {
218   address public pendingOwner;
219 
220   /**
221    * @dev Modifier throws if called by any account other than the pendingOwner.
222    */
223   modifier onlyPendingOwner() {
224     require(msg.sender == pendingOwner);
225     _;
226   }
227 
228   /**
229    * @dev Allows the current owner to set the pendingOwner address.
230    * @param newOwner The address to transfer ownership to.
231    */
232   function transferOwnership(address newOwner) onlyOwner public {
233     pendingOwner = newOwner;
234   }
235 
236   /**
237    * @dev Allows the pendingOwner address to finalize the transfer.
238    */
239   function claimOwnership() onlyPendingOwner public {
240     emit OwnershipTransferred(owner, pendingOwner);
241     owner = pendingOwner;
242     pendingOwner = address(0);
243   }
244 }
245 
246 contract OwnerContract is Claimable {
247     Claimable public ownedContract;
248     address internal origOwner;
249 
250     /**
251      * @dev bind a contract as its owner
252      *
253      * @param _contract the contract address that will be binded by this Owner Contract
254      */
255     function bindContract(address _contract) onlyOwner public returns (bool) {
256         require(_contract != address(0));
257         ownedContract = Claimable(_contract);
258         origOwner = ownedContract.owner();
259 
260         // take ownership of the owned contract
261         ownedContract.claimOwnership();
262 
263         return true;
264     }
265 
266     /**
267      * @dev change the owner of the contract from this contract address to the original one. 
268      *
269      */
270     function transferOwnershipBack() onlyOwner public {
271         ownedContract.transferOwnership(origOwner);
272         ownedContract = Claimable(address(0));
273         origOwner = address(0);
274     }
275 
276     /**
277      * @dev change the owner of the contract from this contract address to another one. 
278      *
279      * @param _nextOwner the contract address that will be next Owner of the original Contract
280      */
281     function changeOwnershipto(address _nextOwner)  onlyOwner public {
282         ownedContract.transferOwnership(_nextOwner);
283         ownedContract = Claimable(address(0));
284         origOwner = address(0);
285     }
286 }
287 
288 contract DepositWithdraw is Claimable, withdrawable {
289     using SafeMath for uint256;
290 
291     /**
292      * transaction record
293      */
294     struct TransferRecord {
295         uint256 timeStamp;
296         address account;
297         uint256 value;
298     }
299     
300     /**
301      * accumulated transferring amount record
302      */
303     struct accumulatedRecord {
304         uint256 mul;
305         uint256 count;
306         uint256 value;
307     }
308 
309     TransferRecord[] deposRecs; // record all the deposit tx data
310     TransferRecord[] withdrRecs; // record all the withdraw tx data
311 
312     accumulatedRecord dayWithdrawRec; // accumulated amount record for one day
313     accumulatedRecord monthWithdrawRec; // accumulated amount record for one month
314 
315     address wallet; // the binded withdraw address
316 
317     event ReceiveDeposit(address _from, uint256 _value, address _token, bytes _extraData);
318     
319     /**
320      * @dev constructor of the DepositWithdraw contract
321      * @param _wallet the binded wallet address to this depositwithdraw contract
322      */
323     constructor(address _wallet) public {
324         require(_wallet != address(0));
325         wallet = _wallet;
326     }
327 
328     /**
329 	 * @dev set the default wallet address
330 	 * @param _wallet the default wallet address binded to this deposit contract
331 	 */
332     function setWithdrawWallet(address _wallet) onlyOwner public returns (bool) {
333         require(_wallet != address(0));
334         wallet = _wallet;
335 
336         return true;
337     }
338 
339     /**
340 	 * @dev util function to change bytes data to bytes32 data
341 	 * @param _data the bytes data to be converted
342 	 */
343     function bytesToBytes32(bytes _data) public pure returns (bytes32 result) {
344         assembly {
345             result := mload(add(_data, 32))
346         }
347     }
348 
349     /**
350      * @dev receive approval from an ERC20 token contract, take a record
351      *
352      * @param _from address The address which you want to send tokens from
353      * @param _value uint256 the amounts of tokens to be sent
354      * @param _token address the ERC20 token address
355      * @param _extraData bytes the extra data for the record
356      */
357     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) onlyOwner public {
358         require(_token != address(0));
359         require(_from != address(0));
360         
361         ERC20 tk = ERC20(_token);
362         require(tk.transferFrom(_from, this, _value));
363         bytes32 timestamp = bytesToBytes32(_extraData);
364         deposRecs.push(TransferRecord(uint256(timestamp), _from, _value));
365         emit ReceiveDeposit(_from, _value, _token, _extraData);
366     }
367 
368     /**
369 	 * @dev withdraw tokens, send tokens to target
370      *
371      * @param _token the token address that will be withdraw
372      * @param _params the limitation parameters for withdraw
373      * @param _time the timstamp of the withdraw time
374 	 * @param _to is where the tokens will be sent to
375 	 *        _value is the number of the token
376      *        _fee is the amount of the transferring costs
377      *        _tokenReturn is the address that return back the tokens of the _fee
378 	 */
379     function withdrawToken(address _token, address _params, uint256 _time, address _to, uint256 _value, uint256 _fee, address _tokenReturn) public onlyOwner returns (bool) {
380         require(_to != address(0));
381         require(_token != address(0));
382         require(_value > _fee);
383         // require(_tokenReturn != address(0));
384 
385         DRCWalletMgrParams params = DRCWalletMgrParams(_params);
386         require(_value <= params.singleWithdrawMax());
387         require(_value >= params.singleWithdrawMin());
388 
389         uint256 daysCount = _time.div(86400); // one day of seconds
390         if (daysCount <= dayWithdrawRec.mul) {
391             dayWithdrawRec.count = dayWithdrawRec.count.add(1);
392             dayWithdrawRec.value = dayWithdrawRec.value.add(_value);
393             require(dayWithdrawRec.count <= params.dayWithdrawCount());
394             require(dayWithdrawRec.value <= params.dayWithdraw());
395         } else {
396             dayWithdrawRec.mul = daysCount;
397             dayWithdrawRec.count = 1;
398             dayWithdrawRec.value = _value;
399         }
400         
401         uint256 monthsCount = _time.div(86400 * 30);
402         if (monthsCount <= monthWithdrawRec.mul) {
403             monthWithdrawRec.count = monthWithdrawRec.count.add(1);
404             monthWithdrawRec.value = monthWithdrawRec.value.add(_value);
405             require(monthWithdrawRec.value <= params.monthWithdraw());
406         } else {            
407             monthWithdrawRec.mul = monthsCount;
408             monthWithdrawRec.count = 1;
409             monthWithdrawRec.value = _value;
410         }
411 
412         ERC20 tk = ERC20(_token);
413         uint256 realAmount = _value.sub(_fee);
414         require(tk.transfer(_to, realAmount));
415         if (_tokenReturn != address(0) && _fee > 0) {
416             require(tk.transfer(_tokenReturn, _fee));
417         }
418 
419         withdrRecs.push(TransferRecord(_time, _to, realAmount));
420         emit WithdrawToken(_token, _to, realAmount);
421 
422         return true;
423     }
424 
425     /**
426 	 * @dev withdraw tokens, send tokens to target default wallet
427      *
428      * @param _token the token address that will be withdraw
429      * @param _params the limitation parameters for withdraw
430      * @param _time the timestamp occur the withdraw record
431 	 * @param _value is the number of the token
432      *        _fee is the amount of the transferring costs
433      *        —tokenReturn is the address that return back the tokens of the _fee
434 	 */
435     function withdrawTokenToDefault(address _token, address _params, uint256 _time, uint256 _value, uint256 _fee, address _tokenReturn) public onlyOwner returns (bool) {
436         return withdrawToken(_token, _params, _time, wallet, _value, _fee, _tokenReturn);
437     }
438 
439     /**
440 	 * @dev get the Deposit records number
441      *
442      */
443     function getDepositNum() public view returns (uint256) {
444         return deposRecs.length;
445     }
446 
447     /**
448 	 * @dev get the one of the Deposit records
449      *
450      * @param _ind the deposit record index
451      */
452     function getOneDepositRec(uint256 _ind) public view returns (uint256, address, uint256) {
453         require(_ind < deposRecs.length);
454 
455         return (deposRecs[_ind].timeStamp, deposRecs[_ind].account, deposRecs[_ind].value);
456     }
457 
458     /**
459 	 * @dev get the withdraw records number
460      *
461      */
462     function getWithdrawNum() public view returns (uint256) {
463         return withdrRecs.length;
464     }
465     
466     /**
467 	 * @dev get the one of the withdraw records
468      *
469      * @param _ind the withdraw record index
470      */
471     function getOneWithdrawRec(uint256 _ind) public view returns (uint256, address, uint256) {
472         require(_ind < withdrRecs.length);
473 
474         return (withdrRecs[_ind].timeStamp, withdrRecs[_ind].account, withdrRecs[_ind].value);
475     }
476 }
477 
478 contract DRCWalletManager is OwnerContract, withdrawable, Destructible, TokenDestructible {
479     using SafeMath for uint256;
480     
481     /**
482      * withdraw wallet description
483      */
484     struct WithdrawWallet {
485         bytes32 name;
486         address walletAddr;
487     }
488 
489     /**
490      * Deposit data storage
491      */
492     struct DepositRepository {
493         // uint256 balance;
494         uint256 frozen;
495         WithdrawWallet[] withdrawWallets;
496         // mapping (bytes32 => address) withdrawWallets;
497     }
498 
499     mapping (address => DepositRepository) depositRepos;
500     mapping (address => address) walletDeposits;
501     mapping (address => bool) public frozenDeposits;
502 
503     ERC20 public tk; // the token will be managed
504     DRCWalletMgrParams params; // the parameters that the management needs
505     
506     event CreateDepositAddress(address indexed _wallet, address _deposit);
507     event FrozenTokens(address indexed _deposit, uint256 _value);
508     event ChangeDefaultWallet(address indexed _oldWallet, address _newWallet);
509 
510     /**
511 	 * @dev withdraw tokens, send tokens to target default wallet
512      *
513      * @param _token the token address that will be withdraw
514      * @param _walletParams the wallet management parameters
515 	 */
516     function bindToken(address _token, address _walletParams) onlyOwner public returns (bool) {
517         require(_token != address(0));
518         require(_walletParams != address(0));
519 
520         tk = ERC20(_token);
521         params = DRCWalletMgrParams(_walletParams);
522         return true;
523     }
524     
525     /**
526 	 * @dev create deposit contract address for the default withdraw wallet
527      *
528      * @param _wallet the binded default withdraw wallet address
529 	 */
530     function createDepositContract(address _wallet) onlyOwner public returns (address) {
531         require(_wallet != address(0));
532 
533         DepositWithdraw deposWithdr = new DepositWithdraw(_wallet); // new contract for deposit
534         address _deposit = address(deposWithdr);
535         walletDeposits[_wallet] = _deposit;
536         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
537         withdrawWalletList.push(WithdrawWallet("default wallet", _wallet));
538         // depositRepos[_deposit].balance = 0;
539         depositRepos[_deposit].frozen = 0;
540 
541         emit CreateDepositAddress(_wallet, address(deposWithdr));
542         return deposWithdr;
543     }
544     
545     /**
546 	 * @dev get deposit contract address by using the default withdraw wallet
547      *
548      * @param _wallet the binded default withdraw wallet address
549 	 */
550     function getDepositAddress(address _wallet) onlyOwner public view returns (address) {
551         require(_wallet != address(0));
552         address deposit = walletDeposits[_wallet];
553 
554         return deposit;
555     }
556     
557     /**
558 	 * @dev get deposit balance and frozen amount by using the deposit address
559      *
560      * @param _deposit the deposit contract address
561 	 */
562     function getDepositInfo(address _deposit) onlyOwner public view returns (uint256, uint256) {
563         require(_deposit != address(0));
564         uint256 _balance = tk.balanceOf(_deposit);
565         uint256 frozenAmount = depositRepos[_deposit].frozen;
566         // depositRepos[_deposit].balance = _balance;
567 
568         return (_balance, frozenAmount);
569     }
570     
571     /**
572 	 * @dev get the number of withdraw wallet addresses bindig to the deposit contract address
573      *
574      * @param _deposit the deposit contract address
575 	 */
576     function getDepositWithdrawCount(address _deposit) onlyOwner public view returns (uint) {
577         require(_deposit != address(0));
578 
579         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
580         uint len = withdrawWalletList.length;
581 
582         return len;
583     }
584     
585     /**
586 	 * @dev get the withdraw wallet addresses list binding to the deposit contract address
587      *
588      * @param _deposit the deposit contract address
589      * @param _indices the array of indices of the withdraw wallets
590 	 */
591     function getDepositWithdrawList(address _deposit, uint[] _indices) onlyOwner public view returns (bytes32[], address[]) {
592         require(_indices.length != 0);
593 
594         bytes32[] memory names = new bytes32[](_indices.length);
595         address[] memory wallets = new address[](_indices.length);
596         
597         for (uint i = 0; i < _indices.length; i = i.add(1)) {
598             WithdrawWallet storage wallet = depositRepos[_deposit].withdrawWallets[_indices[i]];
599             names[i] = wallet.name;
600             wallets[i] = wallet.walletAddr;
601         }
602         
603         return (names, wallets);
604     }
605     
606     /**
607 	 * @dev change the default withdraw wallet address binding to the deposit contract address
608      *
609      * @param _oldWallet the previous default withdraw wallet
610      * @param _newWallet the new default withdraw wallet
611 	 */
612     function changeDefaultWithdraw(address _oldWallet, address _newWallet) onlyOwner public returns (bool) {
613         require(_newWallet != address(0));
614         
615         address deposit = walletDeposits[_oldWallet];
616         DepositWithdraw deposWithdr = DepositWithdraw(deposit);
617         require(deposWithdr.setWithdrawWallet(_newWallet));
618 
619         WithdrawWallet[] storage withdrawWalletList = depositRepos[deposit].withdrawWallets;
620         withdrawWalletList[0].walletAddr = _newWallet;
621         emit ChangeDefaultWallet(_oldWallet, _newWallet);
622 
623         return true;
624     }
625     
626     /**
627 	 * @dev freeze the tokens in the deposit address
628      *
629      * @param _deposit the deposit address
630      * @param _value the amount of tokens need to be frozen
631 	 */
632     function freezeTokens(address _deposit, uint256 _value) onlyOwner public returns (bool) {
633         require(_deposit != address(0));
634         
635         frozenDeposits[_deposit] = true;
636         depositRepos[_deposit].frozen = _value;
637 
638         emit FrozenTokens(_deposit, _value);
639         return true;
640     }
641     
642     /**
643 	 * @dev withdraw the tokens from the deposit address with charge fee
644      *
645      * @param _deposit the deposit address
646      * @param _time the timestamp the withdraw occurs
647      * @param _value the amount of tokens need to be frozen
648 	 */
649     function withdrawWithFee(address _deposit, uint256 _time, uint256 _value) onlyOwner public returns (bool) {
650         require(_deposit != address(0));
651 
652         uint256 _balance = tk.balanceOf(_deposit);
653         require(_value <= _balance);
654 
655         // depositRepos[_deposit].balance = _balance;
656         uint256 frozenAmount = depositRepos[_deposit].frozen;
657         require(_value <= _balance.sub(frozenAmount));
658 
659         DepositWithdraw deposWithdr = DepositWithdraw(_deposit);
660         return (deposWithdr.withdrawTokenToDefault(address(tk), address(params), _time, _value, params.chargeFee(), params.chargeFeePool()));
661     }
662     
663     /**
664 	 * @dev check if the wallet name is not matching the expected wallet address
665      *
666      * @param _deposit the deposit address
667      * @param _name the withdraw wallet name
668      * @param _to the withdraw wallet address
669 	 */
670     function checkWithdrawAddress(address _deposit, bytes32 _name, address _to) public view returns (bool, bool) {
671         uint len = depositRepos[_deposit].withdrawWallets.length;
672         for (uint i = 0; i < len; i = i.add(1)) {
673             WithdrawWallet storage wallet = depositRepos[_deposit].withdrawWallets[i];
674             if (_name == wallet.name) {
675                 return(true, (_to == wallet.walletAddr));
676             }
677         }
678 
679         return (false, true);
680     }
681 
682     /**
683 	 * @dev withdraw tokens, send tokens to target withdraw wallet
684      *
685      * @param _deposit the deposit address that will be withdraw from
686      * @param _time the timestamp occur the withdraw record
687 	 * @param _name the withdraw address alias name to verify
688      * @param _to the address the token will be transfer to 
689      * @param _value the token transferred value
690      * @param _check if we will check the value is valid or meet the limit condition
691 	 */
692     function withdrawWithFee(address _deposit, 
693                              uint256 _time, 
694                              bytes32 _name, 
695                              address _to, 
696                              uint256 _value, 
697                              bool _check) onlyOwner public returns (bool) {
698         require(_deposit != address(0));
699         require(_to != address(0));
700 
701         uint256 _balance = tk.balanceOf(_deposit);
702         if (_check) {
703             require(_value <= _balance);
704         }
705 
706         uint256 available = _balance.sub(depositRepos[_deposit].frozen);
707         if (_check) {
708             require(_value <= available);
709         }
710 
711         bool exist;
712         bool correct;
713         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
714         (exist, correct) = checkWithdrawAddress(_deposit, _name, _to);
715         if(!exist) {
716             withdrawWalletList.push(WithdrawWallet(_name, _to));
717         } else if(!correct) {
718             return false;
719         }
720 
721         if (!_check && _value > available) {
722             tk.transfer(_deposit, _value.sub(available));
723             // _value = _value.sub(available);
724         }
725 
726         DepositWithdraw deposWithdr = DepositWithdraw(_deposit);
727         return (deposWithdr.withdrawToken(address(tk), address(params), _time, _to, _value, params.chargeFee(), params.chargeFeePool()));        
728     }
729 
730 }
731 
732 contract DRCWalletMgrParams is Claimable, Autonomy, Destructible {
733     uint256 public singleWithdrawMin; // min value of single withdraw
734     uint256 public singleWithdrawMax; // Max value of single withdraw
735     uint256 public dayWithdraw; // Max value of one day of withdraw
736     uint256 public monthWithdraw; // Max value of one month of withdraw
737     uint256 public dayWithdrawCount; // Max number of withdraw counting
738 
739     uint256 public chargeFee; // the charge fee for withdraw
740     address public chargeFeePool; // the address that will get the returned charge fees.
741 
742 
743     function initialSingleWithdrawMax(uint256 _value) onlyOwner public {
744         require(!init);
745 
746         singleWithdrawMax = _value;
747     }
748 
749     function initialSingleWithdrawMin(uint256 _value) onlyOwner public {
750         require(!init);
751 
752         singleWithdrawMin = _value;
753     }
754 
755     function initialDayWithdraw(uint256 _value) onlyOwner public {
756         require(!init);
757 
758         dayWithdraw = _value;
759     }
760 
761     function initialDayWithdrawCount(uint256 _count) onlyOwner public {
762         require(!init);
763 
764         dayWithdrawCount = _count;
765     }
766 
767     function initialMonthWithdraw(uint256 _value) onlyOwner public {
768         require(!init);
769 
770         monthWithdraw = _value;
771     }
772 
773     function initialChargeFee(uint256 _value) onlyOwner public {
774         require(!init);
775 
776         chargeFee = _value;
777     }
778 
779     function initialChargeFeePool(address _pool) onlyOwner public {
780         require(!init);
781 
782         chargeFeePool = _pool;
783     }    
784 
785     function setSingleWithdrawMax(uint256 _value) onlyCongress public {
786         singleWithdrawMax = _value;
787     }   
788 
789     function setSingleWithdrawMin(uint256 _value) onlyCongress public {
790         singleWithdrawMin = _value;
791     }
792 
793     function setDayWithdraw(uint256 _value) onlyCongress public {
794         dayWithdraw = _value;
795     }
796 
797     function setDayWithdrawCount(uint256 _count) onlyCongress public {
798         dayWithdrawCount = _count;
799     }
800 
801     function setMonthWithdraw(uint256 _value) onlyCongress public {
802         monthWithdraw = _value;
803     }
804 
805     function setChargeFee(uint256 _value) onlyCongress public {
806         chargeFee = _value;
807     }
808 
809     function setChargeFeePool(address _pool) onlyCongress public {
810         chargeFeePool = _pool;
811     }
812 }
813 
814 contract ERC20Basic {
815   function totalSupply() public view returns (uint256);
816   function balanceOf(address who) public view returns (uint256);
817   function transfer(address to, uint256 value) public returns (bool);
818   event Transfer(address indexed from, address indexed to, uint256 value);
819 }
820 
821 contract ERC20 is ERC20Basic {
822   function allowance(address owner, address spender) public view returns (uint256);
823   function transferFrom(address from, address to, uint256 value) public returns (bool);
824   function approve(address spender, uint256 value) public returns (bool);
825   event Approval(address indexed owner, address indexed spender, uint256 value);
826 }