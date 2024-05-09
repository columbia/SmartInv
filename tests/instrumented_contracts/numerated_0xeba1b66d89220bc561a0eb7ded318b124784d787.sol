1 pragma solidity 0.4.18;
2 
3 // File: contracts/FeeBurnerInterface.sol
4 
5 interface FeeBurnerInterface {
6     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
7 }
8 
9 // File: contracts/ERC20Interface.sol
10 
11 // https://github.com/ethereum/EIPs/issues/20
12 interface ERC20 {
13     function totalSupply() public view returns (uint supply);
14     function balanceOf(address _owner) public view returns (uint balance);
15     function transfer(address _to, uint _value) public returns (bool success);
16     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
17     function approve(address _spender, uint _value) public returns (bool success);
18     function allowance(address _owner, address _spender) public view returns (uint remaining);
19     function decimals() public view returns(uint digits);
20     event Approval(address indexed _owner, address indexed _spender, uint _value);
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
385         address[] approveSignatureArray;
386         uint lastSetNonce;
387     }
388 
389     DataTracker[] internal dataInstances;
390 
391     function WrapperBase(PermissionGroups _wrappedContract, address _admin, uint _numDataInstances) public
392         Withdrawable()
393     {
394         require(_wrappedContract != address(0));
395         require(_admin != address(0));
396         wrappedContract = _wrappedContract;
397         admin = _admin;
398 
399         for (uint i = 0; i < _numDataInstances; i++){
400             addDataInstance();
401         }
402     }
403 
404     function claimWrappedContractAdmin() public onlyOperator {
405         wrappedContract.claimAdmin();
406     }
407 
408     function transferWrappedContractAdmin (address newAdmin) public onlyAdmin {
409         wrappedContract.transferAdmin(newAdmin);
410     }
411 
412     function addDataInstance() internal {
413         address[] memory add = new address[](0);
414         dataInstances.push(DataTracker(add, 0));
415     }
416 
417     function setNewData(uint dataIndex) internal {
418         require(dataIndex < dataInstances.length);
419         dataInstances[dataIndex].lastSetNonce++;
420         dataInstances[dataIndex].approveSignatureArray.length = 0;
421     }
422 
423     function addSignature(uint dataIndex, uint signedNonce, address signer) internal returns(bool allSigned) {
424         require(dataIndex < dataInstances.length);
425         require(dataInstances[dataIndex].lastSetNonce == signedNonce);
426 
427         for (uint i = 0; i < dataInstances[dataIndex].approveSignatureArray.length; i++) {
428             if (signer == dataInstances[dataIndex].approveSignatureArray[i]) revert();
429         }
430         dataInstances[dataIndex].approveSignatureArray.push(signer);
431 
432         if (dataInstances[dataIndex].approveSignatureArray.length == operatorsGroup.length) {
433             allSigned = true;
434         } else {
435             allSigned = false;
436         }
437     }
438 
439     function getDataTrackingParameters(uint index) internal view returns (address[], uint) {
440         require(index < dataInstances.length);
441         return(dataInstances[index].approveSignatureArray, dataInstances[index].lastSetNonce);
442     }
443 }
444 
445 // File: contracts/wrapperContracts/WrapFeeBurner.sol
446 
447 contract WrapFeeBurner is WrapperBase {
448 
449     FeeBurner public feeBurnerContract;
450     address[] internal feeSharingWallets;
451     uint public feeSharingBps = 3000; // out of 10000 = 30%
452 
453     //knc rate range
454     struct KncPerEth {
455         uint minRate;
456         uint maxRate;
457         uint pendingMinRate;
458         uint pendingMaxRate;
459     }
460 
461     KncPerEth internal kncPerEth;
462 
463     //add reserve pending data
464     struct AddReserveData {
465         address reserve;
466         uint    feeBps;
467         address kncWallet;
468     }
469 
470     AddReserveData internal addReserve;
471 
472     //wallet fee pending parameters
473     struct WalletFee {
474         address walletAddress;
475         uint    feeBps;
476     }
477 
478     WalletFee internal walletFee;
479 
480     //tax pending parameters
481     struct TaxData {
482         address wallet;
483         uint    feeBps;
484     }
485 
486     TaxData internal taxData;
487     
488     //data indexes
489     uint internal constant KNC_RATE_RANGE_INDEX = 0;
490     uint internal constant ADD_RESERVE_INDEX = 1;
491     uint internal constant WALLET_FEE_INDEX = 2;
492     uint internal constant TAX_DATA_INDEX = 3;
493     uint internal constant LAST_DATA_INDEX = 4;
494 
495     //general functions
496     function WrapFeeBurner(FeeBurner feeBurner, address _admin) public
497         WrapperBase(PermissionGroups(address(feeBurner)), _admin, LAST_DATA_INDEX)
498     {
499         require(feeBurner != address(0));
500         feeBurnerContract = feeBurner;
501     }
502 
503     //register wallets for fee sharing
504     /////////////////////////////////
505     function setFeeSharingValue(uint feeBps) public onlyAdmin {
506         require(feeBps < 10000);
507         feeSharingBps = feeBps;
508     }
509 
510     function getFeeSharingWallets() public view returns(address[]) {
511         return feeSharingWallets;
512     }
513 
514     event WalletRegisteredForFeeSharing(address sender, address walletAddress);
515     function registerWalletForFeeSharing(address walletAddress) public {
516         require(feeBurnerContract.walletFeesInBps(walletAddress) == 0);
517 
518         // if fee sharing value is 0. means the wallet wasn't added.
519         feeBurnerContract.setWalletFees(walletAddress, feeSharingBps);
520         feeSharingWallets.push(walletAddress);
521         WalletRegisteredForFeeSharing(msg.sender, walletAddress);
522     }
523 
524     // knc rate handling
525     //////////////////////
526     function setPendingKNCRateRange(uint minRate, uint maxRate) public onlyOperator {
527         require(minRate < maxRate);
528         require(minRate > 0);
529 
530         //update data tracking
531         setNewData(KNC_RATE_RANGE_INDEX);
532 
533         kncPerEth.pendingMinRate = minRate;
534         kncPerEth.pendingMaxRate = maxRate;
535     }
536 
537     function getPendingKNCRateRange() public view returns(uint minRate, uint maxRate, uint nonce) {
538         address[] memory signatures;
539         minRate = kncPerEth.pendingMinRate;
540         maxRate = kncPerEth.pendingMaxRate;
541         (signatures, nonce) = getDataTrackingParameters(KNC_RATE_RANGE_INDEX);
542 
543         return(minRate, maxRate, nonce);
544     }
545 
546     function getKNCRateRangeSignatures() public view returns (address[] signatures) {
547         uint nonce;
548         (signatures, nonce) = getDataTrackingParameters(KNC_RATE_RANGE_INDEX);
549         return(signatures);
550     }
551 
552     function approveKNCRateRange(uint nonce) public onlyOperator {
553         if (addSignature(KNC_RATE_RANGE_INDEX, nonce, msg.sender)) {
554             // can perform operation.
555             kncPerEth.minRate = kncPerEth.pendingMinRate;
556             kncPerEth.maxRate = kncPerEth.pendingMaxRate;
557         }
558     }
559 
560     function getKNCRateRange() public view returns(uint minRate, uint maxRate) {
561         minRate = kncPerEth.minRate;
562         maxRate = kncPerEth.maxRate;
563         return(minRate, maxRate);
564     }
565 
566     ///@dev here the operator can set rate without other operators validation. It has to be inside range.
567     function setKNCPerEthRate(uint kncPerEther) public onlyOperator {
568         require(kncPerEther >= kncPerEth.minRate);
569         require(kncPerEther <= kncPerEth.maxRate);
570         feeBurnerContract.setKNCRate(kncPerEther);
571     }
572 
573     //set reserve data
574     //////////////////
575     function setPendingReserveData(address reserve, uint feeBps, address kncWallet) public onlyOperator {
576         require(reserve != address(0));
577         require(kncWallet != address(0));
578         require(feeBps > 0);
579         require(feeBps < 10000);
580 
581         addReserve.reserve = reserve;
582         addReserve.feeBps = feeBps;
583         addReserve.kncWallet = kncWallet;
584         setNewData(ADD_RESERVE_INDEX);
585     }
586 
587     function getPendingAddReserveData() public view
588         returns(address reserve, uint feeBps, address kncWallet, uint nonce)
589     {
590         address[] memory signatures;
591         (signatures, nonce) = getDataTrackingParameters(ADD_RESERVE_INDEX);
592         return(addReserve.reserve, addReserve.feeBps, addReserve.kncWallet, nonce);
593     }
594 
595     function getAddReserveSignatures() public view returns (address[] signatures) {
596         uint nonce;
597         (signatures, nonce) = getDataTrackingParameters(ADD_RESERVE_INDEX);
598         return(signatures);
599     }
600 
601     function approveAddReserveData(uint nonce) public onlyOperator {
602         if (addSignature(ADD_RESERVE_INDEX, nonce, msg.sender)) {
603             // can perform operation.
604             feeBurnerContract.setReserveData(addReserve.reserve, addReserve.feeBps, addReserve.kncWallet);
605         }
606     }
607 
608     //wallet fee
609     /////////////
610     function setPendingWalletFee(address wallet, uint feeBps) public onlyOperator {
611         require(wallet != address(0));
612         require(feeBps > 0);
613         require(feeBps < 10000);
614 
615         walletFee.walletAddress = wallet;
616         walletFee.feeBps = feeBps;
617         setNewData(WALLET_FEE_INDEX);
618     }
619 
620     function getPendingWalletFeeData() public view returns(address wallet, uint feeBps, uint nonce) {
621         address[] memory signatures;
622         (signatures, nonce) = getDataTrackingParameters(WALLET_FEE_INDEX);
623         return(walletFee.walletAddress, walletFee.feeBps, nonce);
624     }
625 
626     function getWalletFeeSignatures() public view returns (address[] signatures) {
627         uint nonce;
628         (signatures, nonce) = getDataTrackingParameters(WALLET_FEE_INDEX);
629         return(signatures);
630     }
631 
632     function approveWalletFeeData(uint nonce) public onlyOperator {
633         if (addSignature(WALLET_FEE_INDEX, nonce, msg.sender)) {
634             // can perform operation.
635             feeBurnerContract.setWalletFees(walletFee.walletAddress, walletFee.feeBps);
636         }
637     }
638 
639     //tax parameters
640     ////////////////
641     function setPendingTaxParameters(address taxWallet, uint feeBps) public onlyOperator {
642         require(taxWallet != address(0));
643         require(feeBps > 0);
644         require(feeBps < 10000);
645 
646         taxData.wallet = taxWallet;
647         taxData.feeBps = feeBps;
648         setNewData(TAX_DATA_INDEX);
649     }
650 
651     function getPendingTaxData() public view returns(address wallet, uint feeBps, uint nonce) {
652         address[] memory signatures;
653         (signatures, nonce) = getDataTrackingParameters(TAX_DATA_INDEX);
654         return(taxData.wallet, taxData.feeBps, nonce);
655     }
656 
657     function getTaxDataSignatures() public view returns (address[] signatures) {
658         uint nonce;
659         (signatures, nonce) = getDataTrackingParameters(TAX_DATA_INDEX);
660         return(signatures);
661     }
662 
663     function approveTaxData(uint nonce) public onlyOperator {
664         if (addSignature(TAX_DATA_INDEX, nonce, msg.sender)) {
665             // can perform operation.
666             feeBurnerContract.setTaxInBps(taxData.feeBps);
667             feeBurnerContract.setTaxWallet(taxData.wallet);
668         }
669     }
670 }