1 pragma solidity 0.4.18;
2 
3 // File: contracts/FeeBurnerInterface.sol
4 
5 interface FeeBurnerInterface {
6     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
7     function setReserveData(address reserve, uint feesInBps, address kncWallet) public;
8 }
9 
10 // File: contracts/ERC20Interface.sol
11 
12 // https://github.com/ethereum/EIPs/issues/20
13 interface ERC20 {
14     function totalSupply() public view returns (uint supply);
15     function balanceOf(address _owner) public view returns (uint balance);
16     function transfer(address _to, uint _value) public returns (bool success);
17     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
18     function approve(address _spender, uint _value) public returns (bool success);
19     function allowance(address _owner, address _spender) public view returns (uint remaining);
20     function decimals() public view returns(uint digits);
21     event Approval(address indexed _owner, address indexed _spender, uint _value);
22 }
23 
24 // File: contracts/KyberNetworkInterface.sol
25 
26 /// @title Kyber Network interface
27 interface KyberNetworkInterface {
28     function maxGasPrice() public view returns(uint);
29     function getUserCapInWei(address user) public view returns(uint);
30     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
31     function enabled() public view returns(bool);
32     function info(bytes32 id) public view returns(uint);
33 
34     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
35         returns (uint expectedRate, uint slippageRate);
36 
37     function tradeWithHint(address trader, ERC20 src, uint srcAmount, ERC20 dest, address destAddress,
38         uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
39 }
40 
41 // File: contracts/Utils.sol
42 
43 /// @title Kyber constants contract
44 contract Utils {
45 
46     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
47     uint  constant internal PRECISION = (10**18);
48     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
49     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
50     uint  constant internal MAX_DECIMALS = 18;
51     uint  constant internal ETH_DECIMALS = 18;
52     mapping(address=>uint) internal decimals;
53 
54     function setDecimals(ERC20 token) internal {
55         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
56         else decimals[token] = token.decimals();
57     }
58 
59     function getDecimals(ERC20 token) internal view returns(uint) {
60         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
61         uint tokenDecimals = decimals[token];
62         // technically, there might be token with decimals 0
63         // moreover, very possible that old tokens have decimals 0
64         // these tokens will just have higher gas fees.
65         if(tokenDecimals == 0) return token.decimals();
66 
67         return tokenDecimals;
68     }
69 
70     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
71         require(srcQty <= MAX_QTY);
72         require(rate <= MAX_RATE);
73 
74         if (dstDecimals >= srcDecimals) {
75             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
76             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
77         } else {
78             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
79             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
80         }
81     }
82 
83     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
84         require(dstQty <= MAX_QTY);
85         require(rate <= MAX_RATE);
86         
87         //source quantity is rounded up. to avoid dest quantity being too low.
88         uint numerator;
89         uint denominator;
90         if (srcDecimals >= dstDecimals) {
91             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
92             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
93             denominator = rate;
94         } else {
95             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
96             numerator = (PRECISION * dstQty);
97             denominator = (rate * (10**(dstDecimals - srcDecimals)));
98         }
99         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
100     }
101 }
102 
103 // File: contracts/Utils2.sol
104 
105 contract Utils2 is Utils {
106 
107     /// @dev get the balance of a user.
108     /// @param token The token type
109     /// @return The balance
110     function getBalance(ERC20 token, address user) public view returns(uint) {
111         if (token == ETH_TOKEN_ADDRESS)
112             return user.balance;
113         else
114             return token.balanceOf(user);
115     }
116 
117     function getDecimalsSafe(ERC20 token) internal returns(uint) {
118 
119         if (decimals[token] == 0) {
120             setDecimals(token);
121         }
122 
123         return decimals[token];
124     }
125 
126     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
127         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
128     }
129 
130     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
131         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
132     }
133 
134     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
135         internal pure returns(uint)
136     {
137         require(srcAmount <= MAX_QTY);
138         require(destAmount <= MAX_QTY);
139 
140         if (dstDecimals >= srcDecimals) {
141             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
142             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
143         } else {
144             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
145             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
146         }
147     }
148 }
149 
150 // File: contracts/PermissionGroups.sol
151 
152 contract PermissionGroups {
153 
154     address public admin;
155     address public pendingAdmin;
156     mapping(address=>bool) internal operators;
157     mapping(address=>bool) internal alerters;
158     address[] internal operatorsGroup;
159     address[] internal alertersGroup;
160     uint constant internal MAX_GROUP_SIZE = 50;
161 
162     function PermissionGroups() public {
163         admin = msg.sender;
164     }
165 
166     modifier onlyAdmin() {
167         require(msg.sender == admin);
168         _;
169     }
170 
171     modifier onlyOperator() {
172         require(operators[msg.sender]);
173         _;
174     }
175 
176     modifier onlyAlerter() {
177         require(alerters[msg.sender]);
178         _;
179     }
180 
181     function getOperators () external view returns(address[]) {
182         return operatorsGroup;
183     }
184 
185     function getAlerters () external view returns(address[]) {
186         return alertersGroup;
187     }
188 
189     event TransferAdminPending(address pendingAdmin);
190 
191     /**
192      * @dev Allows the current admin to set the pendingAdmin address.
193      * @param newAdmin The address to transfer ownership to.
194      */
195     function transferAdmin(address newAdmin) public onlyAdmin {
196         require(newAdmin != address(0));
197         TransferAdminPending(pendingAdmin);
198         pendingAdmin = newAdmin;
199     }
200 
201     /**
202      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
203      * @param newAdmin The address to transfer ownership to.
204      */
205     function transferAdminQuickly(address newAdmin) public onlyAdmin {
206         require(newAdmin != address(0));
207         TransferAdminPending(newAdmin);
208         AdminClaimed(newAdmin, admin);
209         admin = newAdmin;
210     }
211 
212     event AdminClaimed( address newAdmin, address previousAdmin);
213 
214     /**
215      * @dev Allows the pendingAdmin address to finalize the change admin process.
216      */
217     function claimAdmin() public {
218         require(pendingAdmin == msg.sender);
219         AdminClaimed(pendingAdmin, admin);
220         admin = pendingAdmin;
221         pendingAdmin = address(0);
222     }
223 
224     event AlerterAdded (address newAlerter, bool isAdd);
225 
226     function addAlerter(address newAlerter) public onlyAdmin {
227         require(!alerters[newAlerter]); // prevent duplicates.
228         require(alertersGroup.length < MAX_GROUP_SIZE);
229 
230         AlerterAdded(newAlerter, true);
231         alerters[newAlerter] = true;
232         alertersGroup.push(newAlerter);
233     }
234 
235     function removeAlerter (address alerter) public onlyAdmin {
236         require(alerters[alerter]);
237         alerters[alerter] = false;
238 
239         for (uint i = 0; i < alertersGroup.length; ++i) {
240             if (alertersGroup[i] == alerter) {
241                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
242                 alertersGroup.length--;
243                 AlerterAdded(alerter, false);
244                 break;
245             }
246         }
247     }
248 
249     event OperatorAdded(address newOperator, bool isAdd);
250 
251     function addOperator(address newOperator) public onlyAdmin {
252         require(!operators[newOperator]); // prevent duplicates.
253         require(operatorsGroup.length < MAX_GROUP_SIZE);
254 
255         OperatorAdded(newOperator, true);
256         operators[newOperator] = true;
257         operatorsGroup.push(newOperator);
258     }
259 
260     function removeOperator (address operator) public onlyAdmin {
261         require(operators[operator]);
262         operators[operator] = false;
263 
264         for (uint i = 0; i < operatorsGroup.length; ++i) {
265             if (operatorsGroup[i] == operator) {
266                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
267                 operatorsGroup.length -= 1;
268                 OperatorAdded(operator, false);
269                 break;
270             }
271         }
272     }
273 }
274 
275 // File: contracts/Withdrawable.sol
276 
277 /**
278  * @title Contracts that should be able to recover tokens or ethers
279  * @author Ilan Doron
280  * @dev This allows to recover any tokens or Ethers received in a contract.
281  * This will prevent any accidental loss of tokens.
282  */
283 contract Withdrawable is PermissionGroups {
284 
285     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
286 
287     /**
288      * @dev Withdraw all ERC20 compatible tokens
289      * @param token ERC20 The address of the token contract
290      */
291     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
292         require(token.transfer(sendTo, amount));
293         TokenWithdraw(token, amount, sendTo);
294     }
295 
296     event EtherWithdraw(uint amount, address sendTo);
297 
298     /**
299      * @dev Withdraw Ethers
300      */
301     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
302         sendTo.transfer(amount);
303         EtherWithdraw(amount, sendTo);
304     }
305 }
306 
307 // File: contracts/FeeBurner.sol
308 
309 interface BurnableToken {
310     function transferFrom(address _from, address _to, uint _value) public returns (bool);
311     function burnFrom(address _from, uint256 _value) public returns (bool);
312 }
313 
314 
315 contract FeeBurner is Withdrawable, FeeBurnerInterface, Utils2 {
316 
317     mapping(address=>uint) public reserveFeesInBps;
318     mapping(address=>address) public reserveKNCWallet; //wallet holding knc per reserve. from here burn and send fees.
319     mapping(address=>uint) public walletFeesInBps; // wallet that is the source of tx is entitled so some fees.
320     mapping(address=>uint) public reserveFeeToBurn;
321     mapping(address=>uint) public feePayedPerReserve; // track burned fees and sent wallet fees per reserve.
322     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
323     address public taxWallet;
324     uint public taxFeeBps = 0; // burned fees are taxed. % out of burned fees.
325 
326     BurnableToken public knc;
327     KyberNetworkInterface public kyberNetwork;
328     uint public kncPerEthRatePrecision = 600 * PRECISION; //--> 1 ether = 600 knc tokens
329 
330     function FeeBurner(
331         address _admin,
332         BurnableToken _kncToken,
333         KyberNetworkInterface _kyberNetwork,
334         uint _initialKncToEthRatePrecision
335     )
336         public
337     {
338         require(_admin != address(0));
339         require(_kncToken != address(0));
340         require(_kyberNetwork != address(0));
341         require(_initialKncToEthRatePrecision != 0);
342 
343         kyberNetwork = _kyberNetwork;
344         admin = _admin;
345         knc = _kncToken;
346         kncPerEthRatePrecision = _initialKncToEthRatePrecision;
347     }
348 
349     event ReserveDataSet(address reserve, uint feeInBps, address kncWallet);
350 
351     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyOperator {
352         require(feesInBps < 100); // make sure it is always < 1%
353         require(kncWallet != address(0));
354         reserveFeesInBps[reserve] = feesInBps;
355         reserveKNCWallet[reserve] = kncWallet;
356         ReserveDataSet(reserve, feesInBps, kncWallet);
357     }
358 
359     event WalletFeesSet(address wallet, uint feesInBps);
360 
361     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
362         require(feesInBps < 10000); // under 100%
363         walletFeesInBps[wallet] = feesInBps;
364         WalletFeesSet(wallet, feesInBps);
365     }
366 
367     event TaxFeesSet(uint feesInBps);
368 
369     function setTaxInBps(uint _taxFeeBps) public onlyAdmin {
370         require(_taxFeeBps < 10000); // under 100%
371         taxFeeBps = _taxFeeBps;
372         TaxFeesSet(_taxFeeBps);
373     }
374 
375     event TaxWalletSet(address taxWallet);
376 
377     function setTaxWallet(address _taxWallet) public onlyAdmin {
378         require(_taxWallet != address(0));
379         taxWallet = _taxWallet;
380         TaxWalletSet(_taxWallet);
381     }
382 
383     event KNCRateSet(uint ethToKncRatePrecision, uint kyberEthKnc, uint kyberKncEth, address updater);
384 
385     function setKNCRate() public {
386         //query kyber for knc rate sell and buy
387         uint kyberEthKncRate;
388         uint kyberKncEthRate;
389         (kyberEthKncRate, ) = kyberNetwork.getExpectedRate(ETH_TOKEN_ADDRESS, ERC20(knc), (10 ** 18));
390         (kyberKncEthRate, ) = kyberNetwork.getExpectedRate(ERC20(knc), ETH_TOKEN_ADDRESS, (10 ** 18));
391 
392         //check "reasonable" spread == diff not too big. rate wasn't tampered.
393         require(kyberEthKncRate * kyberKncEthRate < PRECISION ** 2 * 2);
394         require(kyberEthKncRate * kyberKncEthRate > PRECISION ** 2 / 2);
395 
396         require(kyberEthKncRate <= MAX_RATE);
397         kncPerEthRatePrecision = kyberEthKncRate;
398         KNCRateSet(kncPerEthRatePrecision, kyberEthKncRate, kyberKncEthRate, msg.sender);
399     }
400 
401     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
402     event AssignBurnFees(address reserve, uint burnFee);
403 
404     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
405         require(msg.sender == address(kyberNetwork));
406         require(tradeWeiAmount <= MAX_QTY);
407 
408         uint kncAmount = calcDestAmount(ETH_TOKEN_ADDRESS, ERC20(knc), tradeWeiAmount, kncPerEthRatePrecision);
409         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
410 
411         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
412         require(fee >= walletFee);
413         uint feeToBurn = fee - walletFee;
414 
415         if (walletFee > 0) {
416             reserveFeeToWallet[reserve][wallet] += walletFee;
417             AssignFeeToWallet(reserve, wallet, walletFee);
418         }
419 
420         if (feeToBurn > 0) {
421             AssignBurnFees(reserve, feeToBurn);
422             reserveFeeToBurn[reserve] += feeToBurn;
423         }
424 
425         return true;
426     }
427 
428     event BurnAssignedFees(address indexed reserve, address sender, uint quantity);
429 
430     event SendTaxFee(address indexed reserve, address sender, address taxWallet, uint quantity);
431 
432     // this function is callable by anyone
433     function burnReserveFees(address reserve) public {
434         uint burnAmount = reserveFeeToBurn[reserve];
435         uint taxToSend = 0;
436         require(burnAmount > 2);
437         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
438         if (taxWallet != address(0) && taxFeeBps != 0) {
439             taxToSend = (burnAmount - 1) * taxFeeBps / 10000;
440             require(burnAmount - 1 > taxToSend);
441             burnAmount -= taxToSend;
442             if (taxToSend > 0) {
443                 require(knc.transferFrom(reserveKNCWallet[reserve], taxWallet, taxToSend));
444                 SendTaxFee(reserve, msg.sender, taxWallet, taxToSend);
445             }
446         }
447         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
448 
449         //update reserve "payments" so far
450         feePayedPerReserve[reserve] += (taxToSend + burnAmount - 1);
451 
452         BurnAssignedFees(reserve, msg.sender, (burnAmount - 1));
453     }
454 
455     event SendWalletFees(address indexed wallet, address reserve, address sender);
456 
457     // this function is callable by anyone
458     function sendFeeToWallet(address wallet, address reserve) public {
459         uint feeAmount = reserveFeeToWallet[reserve][wallet];
460         require(feeAmount > 1);
461         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
462         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
463 
464         feePayedPerReserve[reserve] += (feeAmount - 1);
465         SendWalletFees(wallet, reserve, msg.sender);
466     }
467 }
468 
469 // File: contracts/wrapperContracts/WrapperBase.sol
470 
471 contract WrapperBase is Withdrawable {
472 
473     PermissionGroups public wrappedContract;
474 
475     struct DataTracker {
476         address [] approveSignatureArray;
477         uint lastSetNonce;
478     }
479 
480     DataTracker[] internal dataInstances;
481 
482     function WrapperBase(PermissionGroups _wrappedContract, address _admin, uint _numDataInstances) public {
483         require(_wrappedContract != address(0));
484         require(_admin != address(0));
485         wrappedContract = _wrappedContract;
486         admin = _admin;
487 
488         for (uint i = 0; i < _numDataInstances; i++){
489             addDataInstance();
490         }
491     }
492 
493     function claimWrappedContractAdmin() public onlyOperator {
494         wrappedContract.claimAdmin();
495     }
496 
497     function transferWrappedContractAdmin (address newAdmin) public onlyAdmin {
498         wrappedContract.transferAdmin(newAdmin);
499     }
500 
501     function addDataInstance() internal {
502         address[] memory add = new address[](0);
503         dataInstances.push(DataTracker(add, 0));
504     }
505 
506     function setNewData(uint dataIndex) internal {
507         require(dataIndex < dataInstances.length);
508         dataInstances[dataIndex].lastSetNonce++;
509         dataInstances[dataIndex].approveSignatureArray.length = 0;
510     }
511 
512     function addSignature(uint dataIndex, uint signedNonce, address signer) internal returns(bool allSigned) {
513         require(dataIndex < dataInstances.length);
514         require(dataInstances[dataIndex].lastSetNonce == signedNonce);
515 
516         for(uint i = 0; i < dataInstances[dataIndex].approveSignatureArray.length; i++) {
517             if (signer == dataInstances[dataIndex].approveSignatureArray[i]) revert();
518         }
519         dataInstances[dataIndex].approveSignatureArray.push(signer);
520 
521         if (dataInstances[dataIndex].approveSignatureArray.length == operatorsGroup.length) {
522             allSigned = true;
523         } else {
524             allSigned = false;
525         }
526     }
527 
528     function getDataTrackingParameters(uint index) internal view returns (address[], uint) {
529         require(index < dataInstances.length);
530         return(dataInstances[index].approveSignatureArray, dataInstances[index].lastSetNonce);
531     }
532 }
533 
534 // File: contracts/wrapperContracts/WrapFeeBurner.sol
535 
536 contract WrapFeeBurner is WrapperBase {
537 
538     FeeBurner public feeBurnerContract;
539     address[] internal feeSharingWallets;
540     uint public feeSharingBps = 3000; // out of 10000 = 30%
541 
542     //add reserve pending data
543     struct AddReserveData {
544         address reserve;
545         uint    feeBps;
546         address kncWallet;
547     }
548 
549     AddReserveData internal addReserve;
550 
551     //wallet fee pending parameters
552     struct WalletFee {
553         address walletAddress;
554         uint    feeBps;
555     }
556 
557     WalletFee internal walletFee;
558 
559     //tax pending parameters
560     struct TaxData {
561         address wallet;
562         uint    feeBps;
563     }
564 
565     TaxData internal taxData;
566     
567     //data indexes
568     uint internal constant ADD_RESERVE_INDEX = 1;
569     uint internal constant WALLET_FEE_INDEX = 2;
570     uint internal constant TAX_DATA_INDEX = 3;
571     uint internal constant LAST_DATA_INDEX = 4;
572 
573     //general functions
574     function WrapFeeBurner(FeeBurner feeBurner, address _admin) public
575         WrapperBase(PermissionGroups(address(feeBurner)), _admin, LAST_DATA_INDEX)
576     {
577         require(feeBurner != address(0));
578         feeBurnerContract = feeBurner;
579     }
580 
581     //register wallets for fee sharing
582     /////////////////////////////////
583     function setFeeSharingValue(uint feeBps) public onlyAdmin {
584         require(feeBps < 10000);
585         feeSharingBps = feeBps;
586     }
587 
588     function getFeeSharingWallets() public view returns(address[]) {
589         return feeSharingWallets;
590     }
591 
592     event WalletRegisteredForFeeSharing(address sender, address walletAddress);
593     function registerWalletForFeeSharing(address walletAddress) public {
594         require(feeBurnerContract.walletFeesInBps(walletAddress) == 0);
595 
596         // if fee sharing value is 0. means the wallet wasn't added.
597         feeBurnerContract.setWalletFees(walletAddress, feeSharingBps);
598         feeSharingWallets.push(walletAddress);
599         WalletRegisteredForFeeSharing(msg.sender, walletAddress);
600     }
601 
602     //set reserve data
603     //////////////////
604     function setPendingReserveData(address reserve, uint feeBps, address kncWallet) public onlyOperator {
605         require(reserve != address(0));
606         require(kncWallet != address(0));
607         require(feeBps > 0);
608         require(feeBps < 10000);
609 
610         addReserve.reserve = reserve;
611         addReserve.feeBps = feeBps;
612         addReserve.kncWallet = kncWallet;
613         setNewData(ADD_RESERVE_INDEX);
614     }
615 
616     function getPendingAddReserveData() public view
617         returns(address reserve, uint feeBps, address kncWallet, uint nonce)
618     {
619         address[] memory signatures;
620         (signatures, nonce) = getDataTrackingParameters(ADD_RESERVE_INDEX);
621         return(addReserve.reserve, addReserve.feeBps, addReserve.kncWallet, nonce);
622     }
623 
624     function getAddReserveSignatures() public view returns (address[] signatures) {
625         uint nonce;
626         (signatures, nonce) = getDataTrackingParameters(ADD_RESERVE_INDEX);
627         return(signatures);
628     }
629 
630     function approveAddReserveData(uint nonce) public onlyOperator {
631         if (addSignature(ADD_RESERVE_INDEX, nonce, msg.sender)) {
632             // can perform operation.
633             feeBurnerContract.setReserveData(addReserve.reserve, addReserve.feeBps, addReserve.kncWallet);
634         }
635     }
636 
637     //wallet fee
638     /////////////
639     function setPendingWalletFee(address wallet, uint feeBps) public onlyOperator {
640         require(wallet != address(0));
641         require(feeBps > 0);
642         require(feeBps < 10000);
643 
644         walletFee.walletAddress = wallet;
645         walletFee.feeBps = feeBps;
646         setNewData(WALLET_FEE_INDEX);
647     }
648 
649     function getPendingWalletFeeData() public view returns(address wallet, uint feeBps, uint nonce) {
650         address[] memory signatures;
651         (signatures, nonce) = getDataTrackingParameters(WALLET_FEE_INDEX);
652         return(walletFee.walletAddress, walletFee.feeBps, nonce);
653     }
654 
655     function getWalletFeeSignatures() public view returns (address[] signatures) {
656         uint nonce;
657         (signatures, nonce) = getDataTrackingParameters(WALLET_FEE_INDEX);
658         return(signatures);
659     }
660 
661     function approveWalletFeeData(uint nonce) public onlyOperator {
662         if (addSignature(WALLET_FEE_INDEX, nonce, msg.sender)) {
663             // can perform operation.
664             feeBurnerContract.setWalletFees(walletFee.walletAddress, walletFee.feeBps);
665         }
666     }
667 
668     //tax parameters
669     ////////////////
670     function setPendingTaxParameters(address taxWallet, uint feeBps) public onlyOperator {
671         require(taxWallet != address(0));
672         require(feeBps > 0);
673         require(feeBps < 10000);
674 
675         taxData.wallet = taxWallet;
676         taxData.feeBps = feeBps;
677         setNewData(TAX_DATA_INDEX);
678     }
679 
680     function getPendingTaxData() public view returns(address wallet, uint feeBps, uint nonce) {
681         address[] memory signatures;
682         (signatures, nonce) = getDataTrackingParameters(TAX_DATA_INDEX);
683         return(taxData.wallet, taxData.feeBps, nonce);
684     }
685 
686     function getTaxDataSignatures() public view returns (address[] signatures) {
687         uint nonce;
688         (signatures, nonce) = getDataTrackingParameters(TAX_DATA_INDEX);
689         return(signatures);
690     }
691 
692     function approveTaxData(uint nonce) public onlyOperator {
693         if (addSignature(TAX_DATA_INDEX, nonce, msg.sender)) {
694             // can perform operation.
695             feeBurnerContract.setTaxInBps(taxData.feeBps);
696             feeBurnerContract.setTaxWallet(taxData.wallet);
697         }
698     }
699 }