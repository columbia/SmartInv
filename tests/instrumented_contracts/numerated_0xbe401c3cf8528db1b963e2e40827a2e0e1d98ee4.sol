1 pragma solidity 0.4.18;
2 
3 // File: contracts/ERC20Interface.sol
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 interface ERC20 {
7     function totalSupply() public view returns (uint supply);
8     function balanceOf(address _owner) public view returns (uint balance);
9     function transfer(address _to, uint _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
11     function approve(address _spender, uint _value) public returns (bool success);
12     function allowance(address _owner, address _spender) public view returns (uint remaining);
13     function decimals() public view returns(uint digits);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 // File: contracts/FeeBurnerInterface.sol
18 
19 interface FeeBurnerInterface {
20     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
21 }
22 
23 // File: contracts/Utils.sol
24 
25 /// @title Kyber constants contract
26 contract Utils {
27 
28     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
29     uint  constant internal PRECISION = (10**18);
30     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
31     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
32     uint  constant internal MAX_DECIMALS = 18;
33     uint  constant internal ETH_DECIMALS = 18;
34     mapping(address=>uint) internal decimals;
35 
36     function setDecimals(ERC20 token) internal {
37         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
38         else decimals[token] = token.decimals();
39     }
40 
41     function getDecimals(ERC20 token) internal view returns(uint) {
42         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
43         uint tokenDecimals = decimals[token];
44         // technically, there might be token with decimals 0
45         // moreover, very possible that old tokens have decimals 0
46         // these tokens will just have higher gas fees.
47         if(tokenDecimals == 0) return token.decimals();
48 
49         return tokenDecimals;
50     }
51 
52     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
53         require(srcQty <= MAX_QTY);
54         require(rate <= MAX_RATE);
55 
56         if (dstDecimals >= srcDecimals) {
57             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
58             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
59         } else {
60             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
61             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
62         }
63     }
64 
65     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
66         require(dstQty <= MAX_QTY);
67         require(rate <= MAX_RATE);
68         
69         //source quantity is rounded up. to avoid dest quantity being too low.
70         uint numerator;
71         uint denominator;
72         if (srcDecimals >= dstDecimals) {
73             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
74             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
75             denominator = rate;
76         } else {
77             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
78             numerator = (PRECISION * dstQty);
79             denominator = (rate * (10**(dstDecimals - srcDecimals)));
80         }
81         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
82     }
83 }
84 
85 // File: contracts/PermissionGroups.sol
86 
87 contract PermissionGroups {
88 
89     address public admin;
90     address public pendingAdmin;
91     mapping(address=>bool) internal operators;
92     mapping(address=>bool) internal alerters;
93     address[] internal operatorsGroup;
94     address[] internal alertersGroup;
95     uint constant internal MAX_GROUP_SIZE = 50;
96 
97     function PermissionGroups() public {
98         admin = msg.sender;
99     }
100 
101     modifier onlyAdmin() {
102         require(msg.sender == admin);
103         _;
104     }
105 
106     modifier onlyOperator() {
107         require(operators[msg.sender]);
108         _;
109     }
110 
111     modifier onlyAlerter() {
112         require(alerters[msg.sender]);
113         _;
114     }
115 
116     function getOperators () external view returns(address[]) {
117         return operatorsGroup;
118     }
119 
120     function getAlerters () external view returns(address[]) {
121         return alertersGroup;
122     }
123 
124     event TransferAdminPending(address pendingAdmin);
125 
126     /**
127      * @dev Allows the current admin to set the pendingAdmin address.
128      * @param newAdmin The address to transfer ownership to.
129      */
130     function transferAdmin(address newAdmin) public onlyAdmin {
131         require(newAdmin != address(0));
132         TransferAdminPending(pendingAdmin);
133         pendingAdmin = newAdmin;
134     }
135 
136     /**
137      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
138      * @param newAdmin The address to transfer ownership to.
139      */
140     function transferAdminQuickly(address newAdmin) public onlyAdmin {
141         require(newAdmin != address(0));
142         TransferAdminPending(newAdmin);
143         AdminClaimed(newAdmin, admin);
144         admin = newAdmin;
145     }
146 
147     event AdminClaimed( address newAdmin, address previousAdmin);
148 
149     /**
150      * @dev Allows the pendingAdmin address to finalize the change admin process.
151      */
152     function claimAdmin() public {
153         require(pendingAdmin == msg.sender);
154         AdminClaimed(pendingAdmin, admin);
155         admin = pendingAdmin;
156         pendingAdmin = address(0);
157     }
158 
159     event AlerterAdded (address newAlerter, bool isAdd);
160 
161     function addAlerter(address newAlerter) public onlyAdmin {
162         require(!alerters[newAlerter]); // prevent duplicates.
163         require(alertersGroup.length < MAX_GROUP_SIZE);
164 
165         AlerterAdded(newAlerter, true);
166         alerters[newAlerter] = true;
167         alertersGroup.push(newAlerter);
168     }
169 
170     function removeAlerter (address alerter) public onlyAdmin {
171         require(alerters[alerter]);
172         alerters[alerter] = false;
173 
174         for (uint i = 0; i < alertersGroup.length; ++i) {
175             if (alertersGroup[i] == alerter) {
176                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
177                 alertersGroup.length--;
178                 AlerterAdded(alerter, false);
179                 break;
180             }
181         }
182     }
183 
184     event OperatorAdded(address newOperator, bool isAdd);
185 
186     function addOperator(address newOperator) public onlyAdmin {
187         require(!operators[newOperator]); // prevent duplicates.
188         require(operatorsGroup.length < MAX_GROUP_SIZE);
189 
190         OperatorAdded(newOperator, true);
191         operators[newOperator] = true;
192         operatorsGroup.push(newOperator);
193     }
194 
195     function removeOperator (address operator) public onlyAdmin {
196         require(operators[operator]);
197         operators[operator] = false;
198 
199         for (uint i = 0; i < operatorsGroup.length; ++i) {
200             if (operatorsGroup[i] == operator) {
201                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
202                 operatorsGroup.length -= 1;
203                 OperatorAdded(operator, false);
204                 break;
205             }
206         }
207     }
208 }
209 
210 // File: contracts/Withdrawable.sol
211 
212 /**
213  * @title Contracts that should be able to recover tokens or ethers
214  * @author Ilan Doron
215  * @dev This allows to recover any tokens or Ethers received in a contract.
216  * This will prevent any accidental loss of tokens.
217  */
218 contract Withdrawable is PermissionGroups {
219 
220     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
221 
222     /**
223      * @dev Withdraw all ERC20 compatible tokens
224      * @param token ERC20 The address of the token contract
225      */
226     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
227         require(token.transfer(sendTo, amount));
228         TokenWithdraw(token, amount, sendTo);
229     }
230 
231     event EtherWithdraw(uint amount, address sendTo);
232 
233     /**
234      * @dev Withdraw Ethers
235      */
236     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
237         sendTo.transfer(amount);
238         EtherWithdraw(amount, sendTo);
239     }
240 }
241 
242 // File: contracts/FeeBurner.sol
243 
244 interface BurnableToken {
245     function transferFrom(address _from, address _to, uint _value) public returns (bool);
246     function burnFrom(address _from, uint256 _value) public returns (bool);
247 }
248 
249 
250 contract FeeBurner is Withdrawable, FeeBurnerInterface, Utils {
251 
252     mapping(address=>uint) public reserveFeesInBps;
253     mapping(address=>address) public reserveKNCWallet; //wallet holding knc per reserve. from here burn and send fees.
254     mapping(address=>uint) public walletFeesInBps; // wallet that is the source of tx is entitled so some fees.
255     mapping(address=>uint) public reserveFeeToBurn;
256     mapping(address=>uint) public feePayedPerReserve; // track burned fees and sent wallet fees per reserve.
257     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
258     address public taxWallet;
259     uint public taxFeeBps = 0; // burned fees are taxed. % out of burned fees.
260 
261     BurnableToken public knc;
262     address public kyberNetwork;
263     uint public kncPerETHRate = 300;
264 
265     function FeeBurner(address _admin, BurnableToken kncToken, address _kyberNetwork) public {
266         require(_admin != address(0));
267         require(kncToken != address(0));
268         require(_kyberNetwork != address(0));
269         kyberNetwork = _kyberNetwork;
270         admin = _admin;
271         knc = kncToken;
272     }
273 
274     event ReserveDataSet(address reserve, uint feeInBps, address kncWallet);
275     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyAdmin {
276         require(feesInBps < 100); // make sure it is always < 1%
277         require(kncWallet != address(0));
278         reserveFeesInBps[reserve] = feesInBps;
279         reserveKNCWallet[reserve] = kncWallet;
280         ReserveDataSet(reserve, feesInBps, kncWallet);
281     }
282 
283     event WalletFeesSet(address wallet, uint feesInBps);
284     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
285         require(feesInBps < 10000); // under 100%
286         walletFeesInBps[wallet] = feesInBps;
287         WalletFeesSet(wallet, feesInBps);
288     }
289 
290     event TaxFeesSet(uint feesInBps);
291     function setTaxInBps(uint _taxFeeBps) public onlyAdmin {
292         require(_taxFeeBps < 10000); // under 100%
293         taxFeeBps = _taxFeeBps;
294         TaxFeesSet(_taxFeeBps);
295     }
296 
297     event TaxWalletSet(address taxWallet);
298     function setTaxWallet(address _taxWallet) public onlyAdmin {
299         require(_taxWallet != address(0));
300         taxWallet = _taxWallet;
301         TaxWalletSet(_taxWallet);
302     }
303 
304     function setKNCRate(uint rate) public onlyAdmin {
305         require(rate <= MAX_RATE);
306         kncPerETHRate = rate;
307     }
308 
309     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
310     event AssignBurnFees(address reserve, uint burnFee);
311 
312     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
313         require(msg.sender == kyberNetwork);
314         require(tradeWeiAmount <= MAX_QTY);
315         require(kncPerETHRate <= MAX_RATE);
316 
317         uint kncAmount = tradeWeiAmount * kncPerETHRate;
318         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
319 
320         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
321         require(fee >= walletFee);
322         uint feeToBurn = fee - walletFee;
323 
324         if (walletFee > 0) {
325             reserveFeeToWallet[reserve][wallet] += walletFee;
326             AssignFeeToWallet(reserve, wallet, walletFee);
327         }
328 
329         if (feeToBurn > 0) {
330             AssignBurnFees(reserve, feeToBurn);
331             reserveFeeToBurn[reserve] += feeToBurn;
332         }
333 
334         return true;
335     }
336 
337     event BurnAssignedFees(address indexed reserve, address sender, uint quantity);
338 
339     event SendTaxFee(address indexed reserve, address sender, address taxWallet, uint quantity);
340 
341     // this function is callable by anyone
342     function burnReserveFees(address reserve) public {
343         uint burnAmount = reserveFeeToBurn[reserve];
344         uint taxToSend = 0;
345         require(burnAmount > 2);
346         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
347         if (taxWallet != address(0) && taxFeeBps != 0) {
348             taxToSend = (burnAmount - 1) * taxFeeBps / 10000;
349             require(burnAmount - 1 > taxToSend);
350             burnAmount -= taxToSend;
351             if (taxToSend > 0) {
352                 require(knc.transferFrom(reserveKNCWallet[reserve], taxWallet, taxToSend));
353                 SendTaxFee(reserve, msg.sender, taxWallet, taxToSend);
354             }
355         }
356         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
357 
358         //update reserve "payments" so far
359         feePayedPerReserve[reserve] += (taxToSend + burnAmount - 1);
360 
361         BurnAssignedFees(reserve, msg.sender, (burnAmount - 1));
362     }
363 
364     event SendWalletFees(address indexed wallet, address reserve, address sender);
365 
366     // this function is callable by anyone
367     function sendFeeToWallet(address wallet, address reserve) public {
368         uint feeAmount = reserveFeeToWallet[reserve][wallet];
369         require(feeAmount > 1);
370         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
371         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
372 
373         feePayedPerReserve[reserve] += (feeAmount - 1);
374         SendWalletFees(wallet, reserve, msg.sender);
375     }
376 }
377 
378 // File: contracts/wrapperContracts/WrapperBase.sol
379 
380 contract WrapperBase is Withdrawable {
381 
382     PermissionGroups public wrappedContract;
383 
384     struct DataTracker {
385         address [] approveSignatureArray;
386         uint lastSetNonce;
387     }
388 
389     DataTracker[] internal dataInstances;
390 
391     function WrapperBase(PermissionGroups _wrappedContract, address _admin, uint _numDataInstances) public {
392         require(_wrappedContract != address(0));
393         require(_admin != address(0));
394         wrappedContract = _wrappedContract;
395         admin = _admin;
396 
397         for (uint i = 0; i < _numDataInstances; i++){
398             addDataInstance();
399         }
400     }
401 
402     function claimWrappedContractAdmin() public onlyOperator {
403         wrappedContract.claimAdmin();
404     }
405 
406     function transferWrappedContractAdmin (address newAdmin) public onlyAdmin {
407         wrappedContract.transferAdmin(newAdmin);
408     }
409 
410     function addDataInstance() internal {
411         address[] memory add = new address[](0);
412         dataInstances.push(DataTracker(add, 0));
413     }
414 
415     function setNewData(uint dataIndex) internal {
416         require(dataIndex < dataInstances.length);
417         dataInstances[dataIndex].lastSetNonce++;
418         dataInstances[dataIndex].approveSignatureArray.length = 0;
419     }
420 
421     function addSignature(uint dataIndex, uint signedNonce, address signer) internal returns(bool allSigned) {
422         require(dataIndex < dataInstances.length);
423         require(dataInstances[dataIndex].lastSetNonce == signedNonce);
424 
425         for(uint i = 0; i < dataInstances[dataIndex].approveSignatureArray.length; i++) {
426             if (signer == dataInstances[dataIndex].approveSignatureArray[i]) revert();
427         }
428         dataInstances[dataIndex].approveSignatureArray.push(signer);
429 
430         if (dataInstances[dataIndex].approveSignatureArray.length == operatorsGroup.length) {
431             allSigned = true;
432         } else {
433             allSigned = false;
434         }
435     }
436 
437     function getDataTrackingParameters(uint index) internal view returns (address[], uint) {
438         require(index < dataInstances.length);
439         return(dataInstances[index].approveSignatureArray, dataInstances[index].lastSetNonce);
440     }
441 }
442 
443 // File: contracts/wrapperContracts/WrapFeeBurner.sol
444 
445 contract WrapFeeBurner is WrapperBase {
446 
447     FeeBurner public feeBurnerContract;
448     address[] internal feeSharingWallets;
449     uint public feeSharingBps = 3000;
450 
451     //knc rate range
452     struct KncPerEth {
453         uint minRate;
454         uint maxRate;
455         uint pendingMinRate;
456         uint pendingMaxRate;
457     }
458 
459     KncPerEth private kncPerEth;
460 
461     //add reserve pending data
462     struct AddReserveData {
463         address reserve;
464         uint    feeBps;
465         address kncWallet;
466     }
467 
468     AddReserveData private addReserve;
469 
470     //wallet fee parameters
471     struct WalletFee {
472         address walletAddress;
473         uint feeBps;
474     }
475 
476     WalletFee private walletFee;
477 
478     //tax pending parameters
479     struct TaxData {
480         address wallet;
481         uint    feeBps;
482     }
483 
484     TaxData private taxData;
485     
486     //data indexes
487     uint private constant KNC_RATE_RANGE_INDEX = 0;
488     uint private constant ADD_RESERVE_INDEX = 1;
489     uint private constant WALLET_FEE_INDEX = 2;
490     uint private constant TAX_DATA_INDEX = 3;
491     uint private constant LAST_DATA_INDEX = 4;
492 
493     //general functions
494     function WrapFeeBurner(FeeBurner _feeBurner, address _admin) public
495         WrapperBase(PermissionGroups(address(_feeBurner)), _admin, LAST_DATA_INDEX)
496     {
497         require(_feeBurner != address(0));
498         feeBurnerContract = _feeBurner;
499     }
500 
501     //register wallets for fee sharing
502     /////////////////////////////////
503     function setFeeSharingValue(uint feeBps) public onlyAdmin {
504         require(feeBps < 10000);
505         feeSharingBps = feeBps;
506     }
507 
508     event WalletRegisteredForFeeSharing(address sender, address walletAddress);
509     function registerWalletForFeeSharing(address walletAddress) public {
510         require(feeBurnerContract.walletFeesInBps(walletAddress) == 0);
511 
512         // if fee sharing value is 0. means the wallet wasn't added.
513         feeBurnerContract.setWalletFees(walletAddress, feeSharingBps);
514         feeSharingWallets.push(walletAddress);
515         WalletRegisteredForFeeSharing(msg.sender, walletAddress);
516     }
517 
518     function getFeeSharingWallets() public view returns(address[]) {
519         return feeSharingWallets;
520     }
521 
522     // knc rate handling
523     //////////////////////
524     function setPendingKNCRateRange(uint minRate, uint maxRate) public onlyOperator {
525         require(minRate < maxRate);
526         require(minRate > 0);
527 
528         //update data tracking
529         setNewData(KNC_RATE_RANGE_INDEX);
530 
531         kncPerEth.pendingMinRate = minRate;
532         kncPerEth.pendingMaxRate = maxRate;
533     }
534 
535     function approveKNCRateRange(uint nonce) public onlyOperator {
536         if (addSignature(KNC_RATE_RANGE_INDEX, nonce, msg.sender)) {
537             // can perform operation.
538             kncPerEth.minRate = kncPerEth.pendingMinRate;
539             kncPerEth.maxRate = kncPerEth.pendingMaxRate;
540         }
541     }
542 
543     function getPendingKNCRateRange() public view returns(uint minRate, uint maxRate, uint nonce) {
544         address[] memory signatures;
545         minRate = kncPerEth.pendingMinRate;
546         maxRate = kncPerEth.pendingMaxRate;
547         (signatures, nonce) = getDataTrackingParameters(KNC_RATE_RANGE_INDEX);
548 
549         return(minRate, maxRate, nonce);
550     }
551 
552     function getKNCRateRange() public view returns(uint minRate, uint maxRate) {
553         minRate = kncPerEth.minRate;
554         maxRate = kncPerEth.maxRate;
555         return(minRate, maxRate);
556     }
557 
558     function setKNCPerEthRate(uint kncPerEther) public onlyOperator {
559         require(kncPerEther >= kncPerEth.minRate);
560         require(kncPerEther <= kncPerEth.maxRate);
561         feeBurnerContract.setKNCRate(kncPerEther);
562     }
563 
564     function getKNCRateRangeSignatures() public view returns (address[] signatures) {
565         uint nonce;
566         (signatures, nonce) = getDataTrackingParameters(KNC_RATE_RANGE_INDEX);
567         return(signatures);
568     }
569 
570     //set reserve data
571     //////////////////
572     function setPendingReserveData(address _reserve, uint feeBps, address kncWallet) public onlyOperator {
573         require(_reserve != address(0));
574         require(kncWallet != address(0));
575         require(feeBps > 0);
576 
577         addReserve.reserve = _reserve;
578         addReserve.feeBps = feeBps;
579         addReserve.kncWallet = kncWallet;
580         setNewData(ADD_RESERVE_INDEX);
581     }
582     
583     function approveAddReserveData(uint nonce) public onlyOperator {
584         if (addSignature(ADD_RESERVE_INDEX, nonce, msg.sender)) {
585             // can perform operation.
586             feeBurnerContract.setReserveData(addReserve.reserve, addReserve.feeBps, addReserve.kncWallet);
587         }
588     }
589 
590     function getPendingAddReserveData() public view
591         returns(address _reserve, uint feeBps, address kncWallet, uint nonce)
592     {
593         address[] memory signatures;
594         (signatures, nonce) = getDataTrackingParameters(ADD_RESERVE_INDEX);
595         return(addReserve.reserve, addReserve.feeBps, addReserve.kncWallet, nonce);
596     }
597 
598     function getAddReserveSignatures() public view returns (address[] signatures) {
599         uint nonce;
600         (signatures, nonce) = getDataTrackingParameters(ADD_RESERVE_INDEX);
601         return(signatures);
602     }
603 
604     //wallet fee
605     /////////////
606     function setPendingWalletFee(address wallet, uint feeInBps) public onlyOperator {
607         require(wallet != address(0));
608         require(feeInBps > 0);
609         walletFee.walletAddress = wallet;
610         walletFee.feeBps = feeInBps;
611         setNewData(WALLET_FEE_INDEX);
612     }
613 
614     function approveWalletFeeData(uint nonce) public onlyOperator {
615         if (addSignature(WALLET_FEE_INDEX, nonce, msg.sender)) {
616             // can perform operation.
617             feeBurnerContract.setWalletFees(walletFee.walletAddress, walletFee.feeBps);
618         }
619     }
620 
621     function getPendingWalletFeeData() public view returns(address wallet, uint feeBps, uint nonce) {
622         address[] memory signatures;
623         (signatures, nonce) = getDataTrackingParameters(WALLET_FEE_INDEX);
624         return(walletFee.walletAddress, walletFee.feeBps, nonce);
625     }
626 
627     function getWalletFeeSignatures() public view returns (address[] signatures) {
628         uint nonce;
629         (signatures, nonce) = getDataTrackingParameters(WALLET_FEE_INDEX);
630         return(signatures);
631     }
632 
633     //tax parameters
634     ////////////////
635     function setPendingTaxParameters(address _taxWallet, uint _taxFeeBps) public onlyOperator {
636         require(_taxWallet != address(0));
637         require(_taxFeeBps > 0);
638 
639         taxData.wallet = _taxWallet;
640         taxData.feeBps = _taxFeeBps;
641         setNewData(TAX_DATA_INDEX);
642     }
643 
644     function approveTaxData(uint nonce) public onlyOperator {
645         if (addSignature(TAX_DATA_INDEX, nonce, msg.sender)) {
646             // can perform operation.
647             feeBurnerContract.setTaxInBps(taxData.feeBps);
648             feeBurnerContract.setTaxWallet(taxData.wallet);
649         }
650     }
651 
652     function getPendingTaxData() public view returns(address wallet, uint feeBps, uint nonce) {
653         address[] memory signatures;
654         (signatures, nonce) = getDataTrackingParameters(TAX_DATA_INDEX);
655         return(taxData.wallet, taxData.feeBps, nonce);
656     }
657 
658     function getTaxDataSignatures() public view returns (address[] signatures) {
659         uint nonce;
660         (signatures, nonce) = getDataTrackingParameters(TAX_DATA_INDEX);
661         return(signatures);
662     }
663 }