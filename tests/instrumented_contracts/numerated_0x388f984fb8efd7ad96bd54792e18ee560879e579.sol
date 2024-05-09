1 pragma solidity ^0.4.13;
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
192 contract Pausable is Ownable {
193   event Pause();
194   event Unpause();
195 
196   bool public paused = false;
197 
198 
199   /**
200    * @dev Modifier to make a function callable only when the contract is not paused.
201    */
202   modifier whenNotPaused() {
203     require(!paused);
204     _;
205   }
206 
207   /**
208    * @dev Modifier to make a function callable only when the contract is paused.
209    */
210   modifier whenPaused() {
211     require(paused);
212     _;
213   }
214 
215   /**
216    * @dev called by the owner to pause, triggers stopped state
217    */
218   function pause() onlyOwner whenNotPaused public {
219     paused = true;
220     emit Pause();
221   }
222 
223   /**
224    * @dev called by the owner to unpause, returns to normal state
225    */
226   function unpause() onlyOwner whenPaused public {
227     paused = false;
228     emit Unpause();
229   }
230 }
231 
232 contract TokenDestructible is Ownable {
233 
234   function TokenDestructible() public payable { }
235 
236   /**
237    * @notice Terminate contract and refund to owner
238    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
239    refund.
240    * @notice The called token contracts could try to re-enter this contract. Only
241    supply token contracts you trust.
242    */
243   function destroy(address[] tokens) onlyOwner public {
244 
245     // Transfer tokens to owner
246     for (uint256 i = 0; i < tokens.length; i++) {
247       ERC20Basic token = ERC20Basic(tokens[i]);
248       uint256 balance = token.balanceOf(this);
249       token.transfer(owner, balance);
250     }
251 
252     // Transfer Eth to owner and terminate contract
253     selfdestruct(owner);
254   }
255 }
256 
257 contract Claimable is Ownable {
258   address public pendingOwner;
259 
260   /**
261    * @dev Modifier throws if called by any account other than the pendingOwner.
262    */
263   modifier onlyPendingOwner() {
264     require(msg.sender == pendingOwner);
265     _;
266   }
267 
268   /**
269    * @dev Allows the current owner to set the pendingOwner address.
270    * @param newOwner The address to transfer ownership to.
271    */
272   function transferOwnership(address newOwner) onlyOwner public {
273     pendingOwner = newOwner;
274   }
275 
276   /**
277    * @dev Allows the pendingOwner address to finalize the transfer.
278    */
279   function claimOwnership() onlyPendingOwner public {
280     emit OwnershipTransferred(owner, pendingOwner);
281     owner = pendingOwner;
282     pendingOwner = address(0);
283   }
284 }
285 
286 contract OwnerContract is Claimable {
287     Claimable public ownedContract;
288     address internal origOwner;
289 
290     /**
291      * @dev bind a contract as its owner
292      *
293      * @param _contract the contract address that will be binded by this Owner Contract
294      */
295     function bindContract(address _contract) onlyOwner public returns (bool) {
296         require(_contract != address(0));
297         ownedContract = Claimable(_contract);
298         origOwner = ownedContract.owner();
299 
300         // take ownership of the owned contract
301         ownedContract.claimOwnership();
302 
303         return true;
304     }
305 
306     /**
307      * @dev change the owner of the contract from this contract address to the original one. 
308      *
309      */
310     function transferOwnershipBack() onlyOwner public {
311         ownedContract.transferOwnership(origOwner);
312         ownedContract = Claimable(address(0));
313         origOwner = address(0);
314     }
315 
316     /**
317      * @dev change the owner of the contract from this contract address to another one. 
318      *
319      * @param _nextOwner the contract address that will be next Owner of the original Contract
320      */
321     function changeOwnershipto(address _nextOwner)  onlyOwner public {
322         ownedContract.transferOwnership(_nextOwner);
323         ownedContract = Claimable(address(0));
324         origOwner = address(0);
325     }
326 }
327 
328 contract DepositWithdraw is Claimable, Pausable, withdrawable {
329     using SafeMath for uint256;
330 
331     /**
332      * transaction record
333      */
334     struct TransferRecord {
335         uint256 timeStamp;
336         address account;
337         uint256 value;
338     }
339     
340     /**
341      * accumulated transferring amount record
342      */
343     struct accumulatedRecord {
344         uint256 mul;
345         uint256 count;
346         uint256 value;
347     }
348 
349     TransferRecord[] deposRecs; // record all the deposit tx data
350     TransferRecord[] withdrRecs; // record all the withdraw tx data
351 
352     accumulatedRecord dayWithdrawRec; // accumulated amount record for one day
353     accumulatedRecord monthWithdrawRec; // accumulated amount record for one month
354 
355     address wallet; // the binded withdraw address
356 
357     event ReceiveDeposit(address _from, uint256 _value, address _token, bytes _extraData);
358     
359     /**
360      * @dev constructor of the DepositWithdraw contract
361      * @param _wallet the binded wallet address to this depositwithdraw contract
362      */
363     constructor(address _wallet) public {
364         require(_wallet != address(0));
365         wallet = _wallet;
366     }
367 
368     /**
369 	 * @dev set the default wallet address
370 	 * @param _wallet the default wallet address binded to this deposit contract
371 	 */
372     function setWithdrawWallet(address _wallet) onlyOwner public returns (bool) {
373         require(_wallet != address(0));
374         wallet = _wallet;
375 
376         return true;
377     }
378 
379     /**
380 	 * @dev util function to change bytes data to bytes32 data
381 	 * @param _data the bytes data to be converted
382 	 */
383     function bytesToBytes32(bytes _data) public pure returns (bytes32 result) {
384         assembly {
385             result := mload(add(_data, 32))
386         }
387     }
388 
389     /**
390      * @dev receive approval from an ERC20 token contract, take a record
391      *
392      * @param _from address The address which you want to send tokens from
393      * @param _value uint256 the amounts of tokens to be sent
394      * @param _token address the ERC20 token address
395      * @param _extraData bytes the extra data for the record
396      */
397     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) onlyOwner whenNotPaused public {
398         require(_token != address(0));
399         require(_from != address(0));
400         
401         ERC20 tk = ERC20(_token);
402         require(tk.transferFrom(_from, this, _value));
403         bytes32 timestamp = bytesToBytes32(_extraData);
404         deposRecs.push(TransferRecord(uint256(timestamp), _from, _value));
405         emit ReceiveDeposit(_from, _value, _token, _extraData);
406     }
407 
408     /**
409 	 * @dev withdraw tokens, send tokens to target
410      *
411      * @param _token the token address that will be withdraw
412      * @param _params the limitation parameters for withdraw
413      * @param _time the timstamp of the withdraw time
414 	 * @param _to is where the tokens will be sent to
415 	 *        _value is the number of the token
416      *        _fee is the amount of the transferring costs
417      *        _tokenReturn is the address that return back the tokens of the _fee
418 	 */
419     function withdrawToken(address _token, address _params, uint256 _time, address _to, uint256 _value, uint256 _fee, address _tokenReturn) public onlyOwner whenNotPaused returns (bool) {
420         require(_to != address(0));
421         require(_token != address(0));
422         require(_value > _fee);
423         // require(_tokenReturn != address(0));
424 
425         DRCWalletMgrParams params = DRCWalletMgrParams(_params);
426         require(_value <= params.singleWithdraw());
427 
428         uint256 daysCount = _time.div(86400);
429         if (daysCount <= dayWithdrawRec.mul) {
430             dayWithdrawRec.count = dayWithdrawRec.count.add(1);
431             dayWithdrawRec.value = dayWithdrawRec.value.add(_value);
432             require(dayWithdrawRec.count <= params.dayWithdrawCount());
433             require(dayWithdrawRec.value <= params.dayWithdraw());
434         } else {
435             dayWithdrawRec.mul = daysCount;
436             dayWithdrawRec.count = 1;
437             dayWithdrawRec.value = _value;
438         }
439         
440         uint256 monthsCount = _time.div(86400 * 30);
441         if (monthsCount <= monthWithdrawRec.mul) {
442             monthWithdrawRec.count = monthWithdrawRec.count.add(1);
443             monthWithdrawRec.value = monthWithdrawRec.value.add(_value);
444             require(monthWithdrawRec.value <= params.monthWithdraw());
445         } else {            
446             monthWithdrawRec.mul = monthsCount;
447             monthWithdrawRec.count = 1;
448             monthWithdrawRec.value = _value;
449         }
450 
451         ERC20 tk = ERC20(_token);
452         uint256 realAmount = _value.sub(_fee);
453         require(tk.transfer(_to, realAmount));
454         if (_tokenReturn != address(0) && _fee > 0) {
455             require(tk.transfer(_tokenReturn, _fee));
456         }
457 
458         withdrRecs.push(TransferRecord(_time, _to, realAmount));
459         emit WithdrawToken(_token, _to, realAmount);
460 
461         return true;
462     }
463 
464     /**
465 	 * @dev withdraw tokens, send tokens to target default wallet
466      *
467      * @param _token the token address that will be withdraw
468      * @param _params the limitation parameters for withdraw
469      * @param _time the timestamp occur the withdraw record
470 	 * @param _value is the number of the token
471      *        _fee is the amount of the transferring costs
472      *        —tokenReturn is the address that return back the tokens of the _fee
473 	 */
474     function withdrawTokenToDefault(address _token, address _params, uint256 _time, uint256 _value, uint256 _fee, address _tokenReturn) public onlyOwner whenNotPaused returns (bool) {
475         return withdrawToken(_token, _params, _time, wallet, _value, _fee, _tokenReturn);
476     }
477 
478     /**
479 	 * @dev get the Deposit records number
480      *
481      */
482     function getDepositNum() public view returns (uint256) {
483         return deposRecs.length;
484     }
485 
486     /**
487 	 * @dev get the one of the Deposit records
488      *
489      * @param _ind the deposit record index
490      */
491     function getOneDepositRec(uint256 _ind) public view returns (uint256, address, uint256) {
492         require(_ind < deposRecs.length);
493 
494         return (deposRecs[_ind].timeStamp, deposRecs[_ind].account, deposRecs[_ind].value);
495     }
496 
497     /**
498 	 * @dev get the withdraw records number
499      *
500      */
501     function getWithdrawNum() public view returns (uint256) {
502         return withdrRecs.length;
503     }
504     
505     /**
506 	 * @dev get the one of the withdraw records
507      *
508      * @param _ind the withdraw record index
509      */
510     function getOneWithdrawRec(uint256 _ind) public view returns (uint256, address, uint256) {
511         require(_ind < withdrRecs.length);
512 
513         return (withdrRecs[_ind].timeStamp, withdrRecs[_ind].account, withdrRecs[_ind].value);
514     }
515 }
516 
517 contract DRCWalletManager is OwnerContract, withdrawable, Destructible, TokenDestructible {
518     using SafeMath for uint256;
519     
520     /**
521      * withdraw wallet description
522      */
523     struct WithdrawWallet {
524         bytes32 name;
525         address walletAddr;
526     }
527 
528     /**
529      * Deposit data storage
530      */
531     struct DepositRepository {
532         // uint256 balance;
533         uint256 frozen;
534         WithdrawWallet[] withdrawWallets;
535         // mapping (bytes32 => address) withdrawWallets;
536     }
537 
538     mapping (address => DepositRepository) depositRepos;
539     mapping (address => address) walletDeposits;
540     mapping (address => bool) public frozenDeposits;
541 
542     ERC20 public tk; // the token will be managed
543     DRCWalletMgrParams params; // the parameters that the management needs
544     
545     event CreateDepositAddress(address indexed _wallet, address _deposit);
546     event FrozenTokens(address indexed _deposit, uint256 _value);
547     event ChangeDefaultWallet(address indexed _oldWallet, address _newWallet);
548 
549     /**
550 	 * @dev withdraw tokens, send tokens to target default wallet
551      *
552      * @param _token the token address that will be withdraw
553      * @param _walletParams the wallet management parameters
554 	 */
555     function bindToken(address _token, address _walletParams) onlyOwner public returns (bool) {
556         require(_token != address(0));
557         require(_walletParams != address(0));
558 
559         tk = ERC20(_token);
560         params = DRCWalletMgrParams(_walletParams);
561         return true;
562     }
563     
564     /**
565 	 * @dev create deposit contract address for the default withdraw wallet
566      *
567      * @param _wallet the binded default withdraw wallet address
568 	 */
569     function createDepositContract(address _wallet) onlyOwner public returns (address) {
570         require(_wallet != address(0));
571 
572         DepositWithdraw deposWithdr = new DepositWithdraw(_wallet); // new contract for deposit
573         address _deposit = address(deposWithdr);
574         walletDeposits[_wallet] = _deposit;
575         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
576         withdrawWalletList.push(WithdrawWallet("default wallet", _wallet));
577         // depositRepos[_deposit].balance = 0;
578         depositRepos[_deposit].frozen = 0;
579 
580         emit CreateDepositAddress(_wallet, address(deposWithdr));
581         return deposWithdr;
582     }
583     
584     /**
585 	 * @dev get deposit contract address by using the default withdraw wallet
586      *
587      * @param _wallet the binded default withdraw wallet address
588 	 */
589     function getDepositAddress(address _wallet) onlyOwner public view returns (address) {
590         require(_wallet != address(0));
591         address deposit = walletDeposits[_wallet];
592 
593         return deposit;
594     }
595     
596     /**
597 	 * @dev get deposit balance and frozen amount by using the deposit address
598      *
599      * @param _deposit the deposit contract address
600 	 */
601     function getDepositInfo(address _deposit) onlyOwner public view returns (uint256, uint256) {
602         require(_deposit != address(0));
603         uint256 _balance = tk.balanceOf(_deposit);
604         uint256 frozenAmount = depositRepos[_deposit].frozen;
605         // depositRepos[_deposit].balance = _balance;
606 
607         return (_balance, frozenAmount);
608     }
609     
610     /**
611 	 * @dev get the number of withdraw wallet addresses bindig to the deposit contract address
612      *
613      * @param _deposit the deposit contract address
614 	 */
615     function getDepositWithdrawCount(address _deposit) onlyOwner public view returns (uint) {
616         require(_deposit != address(0));
617 
618         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
619         uint len = withdrawWalletList.length;
620 
621         return len;
622     }
623     
624     /**
625 	 * @dev get the withdraw wallet addresses list binding to the deposit contract address
626      *
627      * @param _deposit the deposit contract address
628      * @param _indices the array of indices of the withdraw wallets
629 	 */
630     function getDepositWithdrawList(address _deposit, uint[] _indices) onlyOwner public view returns (bytes32[], address[]) {
631         require(_indices.length != 0);
632 
633         bytes32[] memory names = new bytes32[](_indices.length);
634         address[] memory wallets = new address[](_indices.length);
635         
636         for (uint i = 0; i < _indices.length; i = i.add(1)) {
637             WithdrawWallet storage wallet = depositRepos[_deposit].withdrawWallets[_indices[i]];
638             names[i] = wallet.name;
639             wallets[i] = wallet.walletAddr;
640         }
641         
642         return (names, wallets);
643     }
644     
645     /**
646 	 * @dev change the default withdraw wallet address binding to the deposit contract address
647      *
648      * @param _oldWallet the previous default withdraw wallet
649      * @param _newWallet the new default withdraw wallet
650 	 */
651     function changeDefaultWithdraw(address _oldWallet, address _newWallet) onlyOwner public returns (bool) {
652         require(_newWallet != address(0));
653         
654         address deposit = walletDeposits[_oldWallet];
655         DepositWithdraw deposWithdr = DepositWithdraw(deposit);
656         require(deposWithdr.setWithdrawWallet(_newWallet));
657 
658         WithdrawWallet[] storage withdrawWalletList = depositRepos[deposit].withdrawWallets;
659         withdrawWalletList[0].walletAddr = _newWallet;
660         emit ChangeDefaultWallet(_oldWallet, _newWallet);
661 
662         return true;
663     }
664     
665     /**
666 	 * @dev freeze the tokens in the deposit address
667      *
668      * @param _deposit the deposit address
669      * @param _value the amount of tokens need to be frozen
670 	 */
671     function freezeTokens(address _deposit, uint256 _value) onlyOwner public returns (bool) {
672         require(_deposit != address(0));
673         
674         frozenDeposits[_deposit] = true;
675         depositRepos[_deposit].frozen = _value;
676 
677         emit FrozenTokens(_deposit, _value);
678         return true;
679     }
680     
681     /**
682 	 * @dev withdraw the tokens from the deposit address with charge fee
683      *
684      * @param _deposit the deposit address
685      * @param _time the timestamp the withdraw occurs
686      * @param _value the amount of tokens need to be frozen
687 	 */
688     function withdrawWithFee(address _deposit, uint256 _time, uint256 _value) onlyOwner public returns (bool) {
689         require(_deposit != address(0));
690 
691         uint256 _balance = tk.balanceOf(_deposit);
692         require(_value <= _balance);
693 
694         // depositRepos[_deposit].balance = _balance;
695         uint256 frozenAmount = depositRepos[_deposit].frozen;
696         require(_value <= _balance.sub(frozenAmount));
697 
698         DepositWithdraw deposWithdr = DepositWithdraw(_deposit);
699         return (deposWithdr.withdrawTokenToDefault(address(tk), address(params), _time, _value, params.chargeFee(), params.chargeFeePool()));
700     }
701     
702     /**
703 	 * @dev check if the wallet name is not matching the expected wallet address
704      *
705      * @param _deposit the deposit address
706      * @param _name the withdraw wallet name
707      * @param _to the withdraw wallet address
708 	 */
709     function checkWithdrawAddress(address _deposit, bytes32 _name, address _to) public view returns (bool, bool) {
710         uint len = depositRepos[_deposit].withdrawWallets.length;
711         for (uint i = 0; i < len; i = i.add(1)) {
712             WithdrawWallet storage wallet = depositRepos[_deposit].withdrawWallets[i];
713             if (_name == wallet.name) {
714                 return(true, (_to == wallet.walletAddr));
715             }
716         }
717 
718         return (false, true);
719     }
720 
721     /**
722 	 * @dev withdraw tokens, send tokens to target withdraw wallet
723      *
724      * @param _deposit the deposit address that will be withdraw from
725      * @param _time the timestamp occur the withdraw record
726 	 * @param _name the withdraw address alias name to verify
727      * @param _to the address the token will be transfer to 
728      * @param _value the token transferred value
729      * @param _check if we will check the value is valid or meet the limit condition
730 	 */
731     function withdrawWithFee(address _deposit, 
732                              uint256 _time, 
733                              bytes32 _name, 
734                              address _to, 
735                              uint256 _value, 
736                              bool _check) onlyOwner public returns (bool) {
737         require(_deposit != address(0));
738         require(_to != address(0));
739 
740         uint256 _balance = tk.balanceOf(_deposit);
741         if (_check) {
742             require(_value <= _balance);
743         }
744 
745         uint256 available = _balance.sub(depositRepos[_deposit].frozen);
746         if (_check) {
747             require(_value <= available);
748         }
749 
750         bool exist;
751         bool correct;
752         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
753         (exist, correct) = checkWithdrawAddress(_deposit, _name, _to);
754         if(!exist) {
755             withdrawWalletList.push(WithdrawWallet(_name, _to));
756         } else if(!correct) {
757             return false;
758         }
759 
760         if (!_check && _value > available) {
761             tk.transfer(_deposit, _value.sub(available));
762             _value = _value.sub(available);
763         }
764 
765         DepositWithdraw deposWithdr = DepositWithdraw(_deposit);
766         return (deposWithdr.withdrawToken(address(tk), address(params), _time, _to, _value, params.chargeFee(), params.chargeFeePool()));        
767     }
768 
769 }
770 
771 contract DRCWalletMgrParams is Claimable, Autonomy, Destructible {
772     uint256 public singleWithdraw; // Max value of single withdraw
773     uint256 public dayWithdraw; // Max value of one day of withdraw
774     uint256 public monthWithdraw; // Max value of one month of withdraw
775     uint256 public dayWithdrawCount; // Max number of withdraw counting
776 
777     uint256 public chargeFee; // the charge fee for withdraw
778     address public chargeFeePool; // the address that will get the returned charge fees.
779 
780 
781     function initialSingleWithdraw(uint256 _value) onlyOwner public {
782         require(!init);
783 
784         singleWithdraw = _value;
785     }
786 
787     function initialDayWithdraw(uint256 _value) onlyOwner public {
788         require(!init);
789 
790         dayWithdraw = _value;
791     }
792 
793     function initialDayWithdrawCount(uint256 _count) onlyOwner public {
794         require(!init);
795 
796         dayWithdrawCount = _count;
797     }
798 
799     function initialMonthWithdraw(uint256 _value) onlyOwner public {
800         require(!init);
801 
802         monthWithdraw = _value;
803     }
804 
805     function initialChargeFee(uint256 _value) onlyOwner public {
806         require(!init);
807 
808         singleWithdraw = _value;
809     }
810 
811     function initialChargeFeePool(address _pool) onlyOwner public {
812         require(!init);
813 
814         chargeFeePool = _pool;
815     }    
816 
817     function setSingleWithdraw(uint256 _value) onlyCongress public {
818         singleWithdraw = _value;
819     }
820 
821     function setDayWithdraw(uint256 _value) onlyCongress public {
822         dayWithdraw = _value;
823     }
824 
825     function setDayWithdrawCount(uint256 _count) onlyCongress public {
826         dayWithdrawCount = _count;
827     }
828 
829     function setMonthWithdraw(uint256 _value) onlyCongress public {
830         monthWithdraw = _value;
831     }
832 
833     function setChargeFee(uint256 _value) onlyCongress public {
834         singleWithdraw = _value;
835     }
836 
837     function setChargeFeePool(address _pool) onlyOwner public {
838         chargeFeePool = _pool;
839     }
840 }
841 
842 contract ERC20Basic {
843   function totalSupply() public view returns (uint256);
844   function balanceOf(address who) public view returns (uint256);
845   function transfer(address to, uint256 value) public returns (bool);
846   event Transfer(address indexed from, address indexed to, uint256 value);
847 }
848 
849 contract ERC20 is ERC20Basic {
850   function allowance(address owner, address spender) public view returns (uint256);
851   function transferFrom(address from, address to, uint256 value) public returns (bool);
852   function approve(address spender, uint256 value) public returns (bool);
853   event Approval(address indexed owner, address indexed spender, uint256 value);
854 }