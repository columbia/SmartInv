1 pragma solidity ^0.4.13;
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
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20     if (a == 0) {
21       return 0;
22     }
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 contract Withdrawable is Ownable {
92     event ReceiveEther(address _from, uint256 _value);
93     event WithdrawEther(address _to, uint256 _value);
94     event WithdrawToken(address _token, address _to, uint256 _value);
95 
96     /**
97 	 * @dev recording receiving ether from msn.sender
98 	 */
99     function () payable public {
100         emit ReceiveEther(msg.sender, msg.value);
101     }
102 
103     /**
104 	 * @dev withdraw,send ether to target
105 	 * @param _to is where the ether will be sent to
106 	 *        _amount is the number of the ether
107 	 */
108     function withdraw(address _to, uint _amount) public onlyOwner returns (bool) {
109         require(_to != address(0));
110         _to.transfer(_amount);
111         emit WithdrawEther(_to, _amount);
112 
113         return true;
114     }
115 
116     /**
117 	 * @dev withdraw tokens, send tokens to target
118      *
119      * @param _token the token address that will be withdraw
120 	 * @param _to is where the tokens will be sent to
121 	 *        _value is the number of the token
122 	 */
123     function withdrawToken(address _token, address _to, uint256 _value) public onlyOwner returns (bool) {
124         require(_to != address(0));
125         require(_token != address(0));
126 
127         ERC20 tk = ERC20(_token);
128         tk.transfer(_to, _value);
129         emit WithdrawToken(_token, _to, _value);
130 
131         return true;
132     }
133 
134     /**
135      * @dev receive approval from an ERC20 token contract, and then gain the tokens, 
136      *      then take a record
137      *
138      * @param _from address The address which you want to send tokens from
139      * @param _value uint256 the amounts of tokens to be sent
140      * @param _token address the ERC20 token address
141      * @param _extraData bytes the extra data for the record
142      */
143     // function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
144     //     require(_token != address(0));
145     //     require(_from != address(0));
146         
147     //     ERC20 tk = ERC20(_token);
148     //     require(tk.transferFrom(_from, this, _value));
149         
150     //     emit ReceiveDeposit(_from, _value, _token, _extraData);
151     // }
152 }
153 
154 contract TokenDestructible is Ownable {
155 
156   function TokenDestructible() public payable { }
157 
158   /**
159    * @notice Terminate contract and refund to owner
160    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
161    refund.
162    * @notice The called token contracts could try to re-enter this contract. Only
163    supply token contracts you trust.
164    */
165   function destroy(address[] tokens) onlyOwner public {
166 
167     // Transfer tokens to owner
168     for (uint256 i = 0; i < tokens.length; i++) {
169       ERC20Basic token = ERC20Basic(tokens[i]);
170       uint256 balance = token.balanceOf(this);
171       token.transfer(owner, balance);
172     }
173 
174     // Transfer Eth to owner and terminate contract
175     selfdestruct(owner);
176   }
177 }
178 
179 contract Claimable is Ownable {
180   address public pendingOwner;
181 
182   /**
183    * @dev Modifier throws if called by any account other than the pendingOwner.
184    */
185   modifier onlyPendingOwner() {
186     require(msg.sender == pendingOwner);
187     _;
188   }
189 
190   /**
191    * @dev Allows the current owner to set the pendingOwner address.
192    * @param newOwner The address to transfer ownership to.
193    */
194   function transferOwnership(address newOwner) onlyOwner public {
195     pendingOwner = newOwner;
196   }
197 
198   /**
199    * @dev Allows the pendingOwner address to finalize the transfer.
200    */
201   function claimOwnership() onlyPendingOwner public {
202     emit OwnershipTransferred(owner, pendingOwner);
203     owner = pendingOwner;
204     pendingOwner = address(0);
205   }
206 }
207 
208 contract DepositWithdraw is Claimable, Withdrawable {
209     using SafeMath for uint256;
210 
211     /**
212      * transaction record
213      */
214     struct TransferRecord {
215         uint256 timeStamp;
216         address account;
217         uint256 value;
218     }
219     
220     /**
221      * accumulated transferring amount record
222      */
223     struct accumulatedRecord {
224         uint256 mul;
225         uint256 count;
226         uint256 value;
227     }
228 
229     TransferRecord[] deposRecs; // record all the deposit tx data
230     TransferRecord[] withdrRecs; // record all the withdraw tx data
231 
232     accumulatedRecord dayWithdrawRec; // accumulated amount record for one day
233     accumulatedRecord monthWithdrawRec; // accumulated amount record for one month
234 
235     address wallet; // the binded withdraw address
236 
237     event ReceiveDeposit(address _from, uint256 _value, address _token, bytes _extraData);
238     
239     /**
240      * @dev constructor of the DepositWithdraw contract
241      * @param _wallet the binded wallet address to this depositwithdraw contract
242      */
243     constructor(address _wallet) public {
244         require(_wallet != address(0));
245         wallet = _wallet;
246     }
247 
248     /**
249 	 * @dev set the default wallet address
250 	 * @param _wallet the default wallet address binded to this deposit contract
251 	 */
252     function setWithdrawWallet(address _wallet) onlyOwner public returns (bool) {
253         require(_wallet != address(0));
254         wallet = _wallet;
255 
256         return true;
257     }
258 
259     /**
260 	 * @dev util function to change bytes data to bytes32 data
261 	 * @param _data the bytes data to be converted
262 	 */
263     function bytesToBytes32(bytes _data) public pure returns (bytes32 result) {
264         assembly {
265             result := mload(add(_data, 32))
266         }
267     }
268 
269     /**
270      * @dev receive approval from an ERC20 token contract, take a record
271      *
272      * @param _from address The address which you want to send tokens from
273      * @param _value uint256 the amounts of tokens to be sent
274      * @param _token address the ERC20 token address
275      * @param _extraData bytes the extra data for the record
276      */
277     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) onlyOwner public {
278         require(_token != address(0));
279         require(_from != address(0));
280         
281         ERC20 tk = ERC20(_token);
282         require(tk.transferFrom(_from, this, _value));
283         bytes32 timestamp = bytesToBytes32(_extraData);
284         deposRecs.push(TransferRecord(uint256(timestamp), _from, _value));
285         emit ReceiveDeposit(_from, _value, _token, _extraData);
286     }
287 
288     // function authorize(address _token, address _spender, uint256 _value) onlyOwner public returns (bool) {
289     //     ERC20 tk = ERC20(_token);
290     //     require(tk.approve(_spender, _value));
291 
292     //     return true;
293     // }
294 
295     /**
296      * @dev record withdraw into this contract
297      *
298      * @param _time the timstamp of the withdraw time
299      * @param _to is where the tokens will be sent to
300      * @param _value is the number of the token
301      */
302     function recordWithdraw(uint256 _time, address _to, uint256 _value) onlyOwner public {    
303         withdrRecs.push(TransferRecord(_time, _to, _value));
304     }
305 
306     /**
307      * @dev check if withdraw amount is not valid
308      *
309      * @param _params the limitation parameters for withdraw
310      * @param _value is the number of the token
311      * @param _time the timstamp of the withdraw time
312      */
313     function checkWithdrawAmount(address _params, uint256 _value, uint256 _time) public returns (bool) {
314         IDRCWalletMgrParams params = IDRCWalletMgrParams(_params);
315         require(_value <= params.singleWithdrawMax());
316         require(_value >= params.singleWithdrawMin());
317 
318         uint256 daysCount = _time.div(86400); // one day of seconds
319         if (daysCount <= dayWithdrawRec.mul) {
320             dayWithdrawRec.count = dayWithdrawRec.count.add(1);
321             dayWithdrawRec.value = dayWithdrawRec.value.add(_value);
322             require(dayWithdrawRec.count <= params.dayWithdrawCount());
323             require(dayWithdrawRec.value <= params.dayWithdraw());
324         } else {
325             dayWithdrawRec.mul = daysCount;
326             dayWithdrawRec.count = 1;
327             dayWithdrawRec.value = _value;
328         }
329         
330         uint256 monthsCount = _time.div(86400 * 30);
331         if (monthsCount <= monthWithdrawRec.mul) {
332             monthWithdrawRec.count = monthWithdrawRec.count.add(1);
333             monthWithdrawRec.value = monthWithdrawRec.value.add(_value);
334             require(monthWithdrawRec.value <= params.monthWithdraw());
335         } else {            
336             monthWithdrawRec.mul = monthsCount;
337             monthWithdrawRec.count = 1;
338             monthWithdrawRec.value = _value;
339         }
340 
341         return true;
342     }
343 
344     /**
345 	 * @dev withdraw tokens, send tokens to target
346      *
347      * @param _token the token address that will be withdraw
348      * @param _params the limitation parameters for withdraw
349      * @param _time the timstamp of the withdraw time
350 	 * @param _to is where the tokens will be sent to
351 	 *        _value is the number of the token
352      *        _fee is the amount of the transferring costs
353      *        _tokenReturn is the address that return back the tokens of the _fee
354 	 */
355     function withdrawToken(address _token, address _params, uint256 _time, address _to, uint256 _value, uint256 _fee, address _tokenReturn) public onlyOwner returns (bool) {
356         require(_to != address(0));
357         require(_token != address(0));
358         require(_value > _fee);
359         // require(_tokenReturn != address(0));
360 
361         require(checkWithdrawAmount(_params, _value, _time));
362 
363         ERC20 tk = ERC20(_token);
364         uint256 realAmount = _value.sub(_fee);
365         require(tk.transfer(_to, realAmount));
366         if (_tokenReturn != address(0) && _fee > 0) {
367             require(tk.transfer(_tokenReturn, _fee));
368         }
369 
370         recordWithdraw(_time, _to, realAmount);
371         emit WithdrawToken(_token, _to, realAmount);
372 
373         return true;
374     }
375 
376     /**
377 	 * @dev withdraw tokens, send tokens to target default wallet
378      *
379      * @param _token the token address that will be withdraw
380      * @param _params the limitation parameters for withdraw
381      * @param _time the timestamp occur the withdraw record
382 	 * @param _value is the number of the token
383      *        _fee is the amount of the transferring costs
384      *        —tokenReturn is the address that return back the tokens of the _fee
385 	 */
386     function withdrawTokenToDefault(address _token, address _params, uint256 _time, uint256 _value, uint256 _fee, address _tokenReturn) public onlyOwner returns (bool) {
387         return withdrawToken(_token, _params, _time, wallet, _value, _fee, _tokenReturn);
388     }
389 
390     /**
391 	 * @dev get the Deposit records number
392      *
393      */
394     function getDepositNum() public view returns (uint256) {
395         return deposRecs.length;
396     }
397 
398     /**
399 	 * @dev get the one of the Deposit records
400      *
401      * @param _ind the deposit record index
402      */
403     function getOneDepositRec(uint256 _ind) public view returns (uint256, address, uint256) {
404         require(_ind < deposRecs.length);
405 
406         return (deposRecs[_ind].timeStamp, deposRecs[_ind].account, deposRecs[_ind].value);
407     }
408 
409     /**
410 	 * @dev get the withdraw records number
411      *
412      */
413     function getWithdrawNum() public view returns (uint256) {
414         return withdrRecs.length;
415     }
416     
417     /**
418 	 * @dev get the one of the withdraw records
419      *
420      * @param _ind the withdraw record index
421      */
422     function getOneWithdrawRec(uint256 _ind) public view returns (uint256, address, uint256) {
423         require(_ind < withdrRecs.length);
424 
425         return (withdrRecs[_ind].timeStamp, withdrRecs[_ind].account, withdrRecs[_ind].value);
426     }
427 }
428 
429 contract OwnerContract is Claimable {
430     Claimable public ownedContract;
431     address internal origOwner;
432 
433     /**
434      * @dev bind a contract as its owner
435      *
436      * @param _contract the contract address that will be binded by this Owner Contract
437      */
438     function bindContract(address _contract) onlyOwner public returns (bool) {
439         require(_contract != address(0));
440         ownedContract = Claimable(_contract);
441         origOwner = ownedContract.owner();
442 
443         // take ownership of the owned contract
444         ownedContract.claimOwnership();
445 
446         return true;
447     }
448 
449     /**
450      * @dev change the owner of the contract from this contract address to the original one. 
451      *
452      */
453     function transferOwnershipBack() onlyOwner public {
454         ownedContract.transferOwnership(origOwner);
455         ownedContract = Claimable(address(0));
456         origOwner = address(0);
457     }
458 
459     /**
460      * @dev change the owner of the contract from this contract address to another one. 
461      *
462      * @param _nextOwner the contract address that will be next Owner of the original Contract
463      */
464     function changeOwnershipto(address _nextOwner)  onlyOwner public {
465         ownedContract.transferOwnership(_nextOwner);
466         ownedContract = Claimable(address(0));
467         origOwner = address(0);
468     }
469 }
470 
471 contract DRCWalletManager is OwnerContract, Withdrawable, TokenDestructible {
472     using SafeMath for uint256;
473     
474     /**
475      * withdraw wallet description
476      */
477     struct WithdrawWallet {
478         bytes32 name;
479         address walletAddr;
480     }
481 
482     /**
483      * Deposit data storage
484      */
485     struct DepositRepository {
486         // uint256 balance;
487         uint256 frozen;
488         WithdrawWallet[] withdrawWallets;
489         // mapping (bytes32 => address) withdrawWallets;
490     }
491 
492     mapping (address => DepositRepository) depositRepos;
493     mapping (address => address) public walletDeposits;
494     mapping (address => bool) public frozenDeposits;
495 
496     ERC20 public tk; // the token will be managed
497     IDRCWalletMgrParams public params; // the parameters that the management needs
498     
499     event CreateDepositAddress(address indexed _wallet, address _deposit);
500     event FrozenTokens(address indexed _deposit, bool _freeze, uint256 _value);
501     // event ChangeDefaultWallet(address indexed _oldWallet, address _newWallet);
502 
503     /**
504 	 * @dev withdraw tokens, send tokens to target default wallet
505      *
506      * @param _token the token address that will be withdraw
507      * @param _walletParams the wallet management parameters
508 	 */
509     function bindToken(address _token, address _walletParams) onlyOwner public returns (bool) {
510         require(_token != address(0));
511         require(_walletParams != address(0));
512 
513         tk = ERC20(_token);
514         params = IDRCWalletMgrParams(_walletParams);
515         return true;
516     }
517     
518     /**
519 	 * @dev create deposit contract address for the default withdraw wallet
520      *
521      * @param _wallet the binded default withdraw wallet address
522 	 */
523     function createDepositContract(address _wallet) onlyOwner public returns (address) {
524         require(_wallet != address(0));
525 
526         DepositWithdraw deposWithdr = new DepositWithdraw(_wallet); // new contract for deposit
527         address _deposit = address(deposWithdr);
528         walletDeposits[_wallet] = _deposit;
529         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
530         withdrawWalletList.push(WithdrawWallet("default wallet", _wallet));
531         // depositRepos[_deposit].balance = 0;
532         depositRepos[_deposit].frozen = 0;
533 
534         // deposWithdr.authorize(address(tk), this, 1e27); // give authorization to owner contract
535 
536         emit CreateDepositAddress(_wallet, address(deposWithdr));
537         return deposWithdr;
538     }
539     
540     /**
541 	 * @dev get deposit contract address by using the default withdraw wallet
542      *
543      * @param _wallet the binded default withdraw wallet address
544 	 */
545     // function getDepositAddress(address _wallet) onlyOwner public view returns (address) {
546     //     require(_wallet != address(0));
547     //     address deposit = walletDeposits[_wallet];
548 
549     //     return deposit;
550     // }
551     
552     /**
553 	 * @dev get deposit balance and frozen amount by using the deposit address
554      *
555      * @param _deposit the deposit contract address
556 	 */
557     function getDepositInfo(address _deposit) onlyOwner public view returns (uint256, uint256) {
558         require(_deposit != address(0));
559         uint256 _balance = tk.balanceOf(_deposit);
560         uint256 frozenAmount = depositRepos[_deposit].frozen;
561         // depositRepos[_deposit].balance = _balance;
562 
563         return (_balance, frozenAmount);
564     }
565     
566     /**
567 	 * @dev get the number of withdraw wallet addresses bindig to the deposit contract address
568      *
569      * @param _deposit the deposit contract address
570 	 */
571     function getDepositWithdrawCount(address _deposit) onlyOwner public view returns (uint) {
572         require(_deposit != address(0));
573 
574         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
575         uint len = withdrawWalletList.length;
576 
577         return len;
578     }
579     
580     /**
581 	 * @dev get the withdraw wallet addresses list binding to the deposit contract address
582      *
583      * @param _deposit the deposit contract address
584      * @param _indices the array of indices of the withdraw wallets
585 	 */
586     function getDepositWithdrawList(address _deposit, uint[] _indices) onlyOwner public view returns (bytes32[], address[]) {
587         require(_indices.length != 0);
588 
589         bytes32[] memory names = new bytes32[](_indices.length);
590         address[] memory wallets = new address[](_indices.length);
591         
592         for (uint i = 0; i < _indices.length; i = i.add(1)) {
593             WithdrawWallet storage wallet = depositRepos[_deposit].withdrawWallets[_indices[i]];
594             names[i] = wallet.name;
595             wallets[i] = wallet.walletAddr;
596         }
597         
598         return (names, wallets);
599     }
600     
601     /**
602 	 * @dev change the default withdraw wallet address binding to the deposit contract address
603      *
604      * @param _oldWallet the previous default withdraw wallet
605      * @param _newWallet the new default withdraw wallet
606 	 */
607     function changeDefaultWithdraw(address _oldWallet, address _newWallet) onlyOwner public returns (bool) {
608         require(_newWallet != address(0));
609         
610         address deposit = walletDeposits[_oldWallet];
611         DepositWithdraw deposWithdr = DepositWithdraw(deposit);
612         require(deposWithdr.setWithdrawWallet(_newWallet));
613 
614         WithdrawWallet[] storage withdrawWalletList = depositRepos[deposit].withdrawWallets;
615         withdrawWalletList[0].walletAddr = _newWallet;
616         // emit ChangeDefaultWallet(_oldWallet, _newWallet);
617 
618         return true;
619     }
620     
621     /**
622 	 * @dev freeze the tokens in the deposit address
623      *
624      * @param _deposit the deposit address
625      * @param _freeze to freeze or release
626      * @param _value the amount of tokens need to be frozen
627 	 */
628     function freezeTokens(address _deposit, bool _freeze, uint256 _value) onlyOwner public returns (bool) {
629         require(_deposit != address(0));
630         
631         frozenDeposits[_deposit] = _freeze;
632         if (_freeze) {
633             depositRepos[_deposit].frozen = depositRepos[_deposit].frozen.add(_value);
634         } else {
635             require(_value <= depositRepos[_deposit].frozen);
636             depositRepos[_deposit].frozen = depositRepos[_deposit].frozen.sub(_value);
637         }
638 
639         emit FrozenTokens(_deposit, _freeze, _value);
640         return true;
641     }
642     
643     /**
644 	 * @dev withdraw the tokens from the deposit address to default wallet with charge fee
645      *
646      * @param _deposit the deposit address
647      * @param _time the timestamp the withdraw occurs
648      * @param _value the amount of tokens need to be frozen
649 	 */
650     function withdrawWithFee(address _deposit, uint256 _time, uint256 _value, bool _check) onlyOwner public returns (bool) {    
651         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
652         return withdrawWithFee(_deposit, _time, withdrawWalletList[0].name, withdrawWalletList[0].walletAddr, _value, _check);
653     }
654     
655     /**
656 	 * @dev check if the wallet name is not matching the expected wallet address
657      *
658      * @param _deposit the deposit address
659      * @param _name the withdraw wallet name
660      * @param _to the withdraw wallet address
661 	 */
662     function checkWithdrawAddress(address _deposit, bytes32 _name, address _to) public view returns (bool, bool) {
663         uint len = depositRepos[_deposit].withdrawWallets.length;
664         for (uint i = 0; i < len; i = i.add(1)) {
665             WithdrawWallet memory wallet = depositRepos[_deposit].withdrawWallets[i];
666             if (_name == wallet.name) {
667                 return(true, (_to == wallet.walletAddr));
668             }
669             if (_to == wallet.walletAddr) {
670                 return(true, true);
671             }
672         }
673 
674         return (false, true);
675     }
676     
677     /**
678 	 * @dev withdraw tokens from this contract, send tokens to target withdraw wallet
679      *
680      * @param _deposWithdr the deposit contract that will record withdrawing
681      * @param _time the timestamp occur the withdraw record
682      * @param _to the address the token will be transfer to 
683      * @param _value the token transferred value
684 	 */
685     function withdrawFromThis(DepositWithdraw _deposWithdr, uint256 _time, address _to, uint256 _value) private returns (bool) {
686         uint256 fee = params.chargeFee();
687         uint256 realAmount = _value.sub(fee);
688         address tokenReturn = params.chargeFeePool();
689         if (tokenReturn != address(0) && fee > 0) {
690             require(tk.transfer(tokenReturn, fee));
691         }
692 
693         require (tk.transfer(_to, realAmount));
694         _deposWithdr.recordWithdraw(_time, _to, realAmount);
695 
696         return true;
697     }
698 
699     /**
700 	 * @dev withdraw tokens, send tokens to target withdraw wallet
701      *
702      * @param _deposit the deposit address that will be withdraw from
703      * @param _time the timestamp occur the withdraw record
704 	 * @param _name the withdraw address alias name to verify
705      * @param _to the address the token will be transfer to 
706      * @param _value the token transferred value
707      * @param _check if we will check the value is valid or meet the limit condition
708 	 */
709     function withdrawWithFee(address _deposit, 
710                              uint256 _time, 
711                              bytes32 _name, 
712                              address _to, 
713                              uint256 _value, 
714                              bool _check) onlyOwner public returns (bool) {
715         require(_deposit != address(0));
716         require(_to != address(0));
717 
718         uint256 _balance = tk.balanceOf(_deposit);
719         if (_check) {
720             require(_value <= _balance);
721         }
722 
723         uint256 available = _balance.sub(depositRepos[_deposit].frozen);
724         if (_check) {
725             require(_value <= available);
726         }
727 
728         bool exist;
729         bool correct;
730         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
731         (exist, correct) = checkWithdrawAddress(_deposit, _name, _to);
732         if(!exist) {
733             withdrawWalletList.push(WithdrawWallet(_name, _to));
734         } else if(!correct) {
735             return false;
736         }
737 
738         DepositWithdraw deposWithdr = DepositWithdraw(_deposit);
739         /**
740          * if deposit address doesn't have enough tokens to withdraw, 
741          * then withdraw from this contract. Record in deposit contract.
742          */
743         if (_value > available) {
744             require(deposWithdr.checkWithdrawAmount(address(params), _value, _time));
745             require(deposWithdr.withdrawToken(address(tk), this, available));
746             
747             require(withdrawFromThis(deposWithdr, _time, _to, _value));
748             return true;
749         }
750         
751         return (deposWithdr.withdrawToken(address(tk), address(params), _time, _to, _value, params.chargeFee(), params.chargeFeePool()));        
752     }
753 
754 }
755 
756 contract ERC20Basic {
757   function totalSupply() public view returns (uint256);
758   function balanceOf(address who) public view returns (uint256);
759   function transfer(address to, uint256 value) public returns (bool);
760   event Transfer(address indexed from, address indexed to, uint256 value);
761 }
762 
763 contract ERC20 is ERC20Basic {
764   function allowance(address owner, address spender) public view returns (uint256);
765   function transferFrom(address from, address to, uint256 value) public returns (bool);
766   function approve(address spender, uint256 value) public returns (bool);
767   event Approval(address indexed owner, address indexed spender, uint256 value);
768 }