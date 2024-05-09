1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @author Emil Dudnyk
7  */
8 contract ETHPriceWatcher {
9   address public ethPriceProvider;
10 
11   modifier onlyEthPriceProvider() {
12     require(msg.sender == ethPriceProvider);
13     _;
14   }
15 
16   function receiveEthPrice(uint ethUsdPrice) external;
17 
18   function setEthPriceProvider(address provider) external;
19 }
20 
21 // <ORACLIZE_API>
22 /*
23 Copyright (c) 2015-2016 Oraclize SRL
24 Copyright (c) 2016 Oraclize LTD
25 
26 
27 
28 Permission is hereby granted, free of charge, to any person obtaining a copy
29 of this software and associated documentation files (the "Software"), to deal
30 in the Software without restriction, including without limitation the rights
31 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
32 copies of the Software, and to permit persons to whom the Software is
33 furnished to do so, subject to the following conditions:
34 
35 
36 
37 The above copyright notice and this permission notice shall be included in
38 all copies or substantial portions of the Software.
39 
40 
41 
42 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
43 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
44 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
45 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
46 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
47 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
48 THE SOFTWARE.
49 */
50 
51 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
52 
53 contract OraclizeI {
54   address public cbAddress;
55   function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
56   function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
57   function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
58   function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
59   function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
60   function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
61   function getPrice(string _datasource) public returns (uint _dsprice);
62   function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
63   function setProofType(byte _proofType) external;
64   function setCustomGasPrice(uint _gasPrice) external;
65   function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
66 }
67 contract OraclizeAddrResolverI {
68   function getAddress() public returns (address _addr);
69 }
70 contract usingOraclize {
71   uint constant day = 60*60*24;
72   uint constant week = 60*60*24*7;
73   uint constant month = 60*60*24*30;
74   byte constant proofType_NONE = 0x00;
75   byte constant proofType_TLSNotary = 0x10;
76   byte constant proofType_Android = 0x20;
77   byte constant proofType_Ledger = 0x30;
78   byte constant proofType_Native = 0xF0;
79   byte constant proofStorage_IPFS = 0x01;
80   uint8 constant networkID_auto = 0;
81   uint8 constant networkID_mainnet = 1;
82   uint8 constant networkID_testnet = 2;
83   uint8 constant networkID_morden = 2;
84   uint8 constant networkID_consensys = 161;
85 
86   OraclizeAddrResolverI OAR;
87 
88   OraclizeI oraclize;
89   modifier oraclizeAPI {
90     if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
91       oraclize_setNetwork(networkID_auto);
92 
93     if(address(oraclize) != OAR.getAddress())
94       oraclize = OraclizeI(OAR.getAddress());
95 
96     _;
97   }
98   modifier coupon(string code){
99     oraclize = OraclizeI(OAR.getAddress());
100     _;
101   }
102 
103   function oraclize_setNetwork(uint8 networkID) internal returns(bool){
104     return oraclize_setNetwork();
105     networkID; // silence the warning and remain backwards compatible
106   }
107   function oraclize_setNetwork() internal returns(bool){
108     if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
109       OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
110       oraclize_setNetworkName("eth_mainnet");
111       return true;
112     }
113     if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
114       OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
115       oraclize_setNetworkName("eth_ropsten3");
116       return true;
117     }
118     if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
119       OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
120       oraclize_setNetworkName("eth_kovan");
121       return true;
122     }
123     if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
124       OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
125       oraclize_setNetworkName("eth_rinkeby");
126       return true;
127     }
128     if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
129       OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
130       return true;
131     }
132     if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
133       OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
134       return true;
135     }
136     if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
137       OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
138       return true;
139     }
140     return false;
141   }
142 
143   function __callback(bytes32 myid, string result) public {
144     __callback(myid, result);
145   }
146 
147   function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
148     return oraclize.getPrice(datasource);
149   }
150 
151   function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
152     return oraclize.getPrice(datasource, gaslimit);
153   }
154 
155   function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
156     uint price = oraclize.getPrice(datasource);
157     if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
158     return oraclize.query.value(price)(timestamp, datasource, arg);
159   }
160   function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
161     uint price = oraclize.getPrice(datasource, gaslimit);
162     if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
163     return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
164   }
165 
166   function oraclize_cbAddress() oraclizeAPI internal returns (address){
167     return oraclize.cbAddress();
168   }
169   function oraclize_setProof(byte proofP) oraclizeAPI internal {
170     return oraclize.setProofType(proofP);
171   }
172   function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
173     return oraclize.setCustomGasPrice(gasPrice);
174   }
175 
176   function getCodeSize(address _addr) constant internal returns(uint _size) {
177     assembly {
178       _size := extcodesize(_addr)
179     }
180   }
181 
182   // parseInt
183   function parseInt(string _a) internal pure returns (uint) {
184     return parseInt(_a, 0);
185   }
186 
187   // parseInt(parseFloat*10^_b)
188   function parseInt(string _a, uint _b) internal pure returns (uint) {
189     bytes memory bresult = bytes(_a);
190     uint mint = 0;
191     bool decimals = false;
192     for (uint i=0; i<bresult.length; i++){
193       if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
194         if (decimals){
195           if (_b == 0) break;
196           else _b--;
197         }
198         mint *= 10;
199         mint += uint(bresult[i]) - 48;
200       } else if (bresult[i] == 46) decimals = true;
201     }
202     if (_b > 0) mint *= 10**_b;
203     return mint;
204   }
205 
206   string oraclize_network_name;
207   function oraclize_setNetworkName(string _network_name) internal {
208     oraclize_network_name = _network_name;
209   }
210 
211   function oraclize_getNetworkName() internal view returns (string) {
212     return oraclize_network_name;
213   }
214 
215 }
216 // </ORACLIZE_API>
217 
218 /**
219  * @title Ownable
220  * @dev The Ownable contract has an owner address, and provides basic authorization control
221  * functions, this simplifies the implementation of "user permissions".
222  */
223 contract Ownable {
224   address public owner;
225 
226 
227   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229   /**
230    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
231    * account.
232    */
233   function Ownable() public {
234     owner = msg.sender;
235   }
236 
237   /**
238    * @dev Throws if called by any account other than the owner.
239    */
240   modifier onlyOwner() {
241     require(msg.sender == owner);
242     _;
243   }
244 
245   /**
246    * @dev Allows the current owner to transfer control of the contract to a newOwner.
247    * @param newOwner The address to transfer ownership to.
248    */
249   function transferOwnership(address newOwner) public onlyOwner {
250     require(newOwner != address(0));
251     OwnershipTransferred(owner, newOwner);
252     owner = newOwner;
253   }
254 
255 }
256 
257 contract BuildingStatus is Ownable {
258   /* Observer contract  */
259   address public observer;
260 
261   /* Crowdsale contract */
262   address public crowdsale;
263 
264   enum statusEnum {
265       crowdsale,
266       refund,
267       preparation_works,
268       building_permit,
269       design_technical_documentation,
270       utilities_outsite,
271       construction_residential,
272       frame20,
273       frame40,
274       frame60,
275       frame80,
276       frame100,
277       stage1,
278       stage2,
279       stage3,
280       stage4,
281       stage5,
282       facades20,
283       facades40,
284       facades60,
285       facades80,
286       facades100,
287       engineering,
288       finishing,
289       construction_parking,
290       civil_works,
291       engineering_further,
292       commisioning_project,
293       completed
294   }
295 
296   modifier notCompleted() {
297       require(status != statusEnum.completed);
298       _;
299   }
300 
301   modifier onlyObserver() {
302     require(msg.sender == observer || msg.sender == owner || msg.sender == address(this));
303     _;
304   }
305 
306   modifier onlyCrowdsale() {
307     require(msg.sender == crowdsale || msg.sender == owner || msg.sender == address(this));
308     _;
309   }
310 
311   statusEnum public status;
312 
313   event StatusChanged(statusEnum newStatus);
314 
315   function setStatus(statusEnum newStatus) onlyCrowdsale  public {
316       status = newStatus;
317       StatusChanged(newStatus);
318   }
319 
320   function changeStage(uint8 stage) public onlyObserver {
321       if (stage==1) status = statusEnum.stage1;
322       if (stage==2) status = statusEnum.stage2;
323       if (stage==3) status = statusEnum.stage3;
324       if (stage==4) status = statusEnum.stage4;
325       if (stage==5) status = statusEnum.stage5;
326   }
327  
328 }
329 
330 /*
331  * Manager that stores permitted addresses 
332  */
333 contract PermissionManager is Ownable {
334     mapping (address => bool) permittedAddresses;
335 
336     function addAddress(address newAddress) public onlyOwner {
337         permittedAddresses[newAddress] = true;
338     }
339 
340     function removeAddress(address remAddress) public onlyOwner {
341         permittedAddresses[remAddress] = false;
342     }
343 
344     function isPermitted(address pAddress) public view returns(bool) {
345         if (permittedAddresses[pAddress]) {
346             return true;
347         }
348         return false;
349     }
350 }
351 
352 contract Registry is Ownable {
353 
354   struct ContributorData {
355     bool isActive;
356     uint contributionETH;
357     uint contributionUSD;
358     uint tokensIssued;
359     uint quoteUSD;
360     uint contributionRNTB;
361   }
362   mapping(address => ContributorData) public contributorList;
363   mapping(uint => address) private contributorIndexes;
364 
365   uint private nextContributorIndex;
366 
367   /* Permission manager contract */
368   PermissionManager public permissionManager;
369 
370   bool public completed;
371 
372   modifier onlyPermitted() {
373     require(permissionManager.isPermitted(msg.sender));
374     _;
375   }
376 
377   event ContributionAdded(address _contributor, uint overallEth, uint overallUSD, uint overallToken, uint quote);
378   event ContributionEdited(address _contributor, uint overallEth, uint overallUSD,  uint overallToken, uint quote);
379   function Registry(address pManager) public {
380     permissionManager = PermissionManager(pManager); 
381     completed = false;
382   }
383 
384   function setPermissionManager(address _permadr) public onlyOwner {
385     require(_permadr != 0x0);
386     permissionManager = PermissionManager(_permadr);
387   }
388 
389   function isActiveContributor(address contributor) public view returns(bool) {
390     return contributorList[contributor].isActive;
391   }
392 
393   function removeContribution(address contributor) public onlyPermitted {
394     contributorList[contributor].isActive = false;
395   }
396 
397   function setCompleted(bool compl) public onlyPermitted {
398     completed = compl;
399   }
400 
401   function addContribution(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote ) public onlyPermitted {
402     
403     if (contributorList[_contributor].isActive == false) {
404         contributorList[_contributor].isActive = true;
405         contributorList[_contributor].contributionETH = _amount;
406         contributorList[_contributor].contributionUSD = _amusd;
407         contributorList[_contributor].tokensIssued = _tokens;
408         contributorList[_contributor].quoteUSD = _quote;
409 
410         contributorIndexes[nextContributorIndex] = _contributor;
411         nextContributorIndex++;
412     } else {
413       contributorList[_contributor].contributionETH += _amount;
414       contributorList[_contributor].contributionUSD += _amusd;
415       contributorList[_contributor].tokensIssued += _tokens;
416       contributorList[_contributor].quoteUSD = _quote;
417     }
418     ContributionAdded(_contributor, contributorList[_contributor].contributionETH, contributorList[_contributor].contributionUSD, contributorList[_contributor].tokensIssued, contributorList[_contributor].quoteUSD);
419   }
420 
421   function editContribution(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote) public onlyPermitted {
422     if (contributorList[_contributor].isActive == true) {
423         contributorList[_contributor].contributionETH = _amount;
424         contributorList[_contributor].contributionUSD = _amusd;
425         contributorList[_contributor].tokensIssued = _tokens;
426         contributorList[_contributor].quoteUSD = _quote;
427     }
428      ContributionEdited(_contributor, contributorList[_contributor].contributionETH, contributorList[_contributor].contributionUSD, contributorList[_contributor].tokensIssued, contributorList[_contributor].quoteUSD);
429   }
430 
431   function addContributor(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote) public onlyPermitted {
432     contributorList[_contributor].isActive = true;
433     contributorList[_contributor].contributionETH = _amount;
434     contributorList[_contributor].contributionUSD = _amusd;
435     contributorList[_contributor].tokensIssued = _tokens;
436     contributorList[_contributor].quoteUSD = _quote;
437     contributorIndexes[nextContributorIndex] = _contributor;
438     nextContributorIndex++;
439     ContributionAdded(_contributor, contributorList[_contributor].contributionETH, contributorList[_contributor].contributionUSD, contributorList[_contributor].tokensIssued, contributorList[_contributor].quoteUSD);
440  
441   }
442 
443   function getContributionETH(address _contributor) public view returns (uint) {
444       return contributorList[_contributor].contributionETH;
445   }
446 
447   function getContributionUSD(address _contributor) public view returns (uint) {
448       return contributorList[_contributor].contributionUSD;
449   }
450 
451   function getContributionRNTB(address _contributor) public view returns (uint) {
452       return contributorList[_contributor].contributionRNTB;
453   }
454 
455   function getContributionTokens(address _contributor) public view returns (uint) {
456       return contributorList[_contributor].tokensIssued;
457   }
458 
459   function addRNTBContribution(address _contributor, uint _amount) public onlyPermitted {
460     if (contributorList[_contributor].isActive == false) {
461         contributorList[_contributor].isActive = true;
462         contributorList[_contributor].contributionRNTB = _amount;
463         contributorIndexes[nextContributorIndex] = _contributor;
464         nextContributorIndex++;
465     } else {
466       contributorList[_contributor].contributionETH += _amount;
467     }
468   }
469 
470   function getContributorByIndex(uint index) public view  returns (address) {
471       return contributorIndexes[index];
472   }
473 
474   function getContributorAmount() public view returns(uint) {
475       return nextContributorIndex;
476   }
477 
478 }
479 
480 /**
481  * @author Emil Dudnyk
482  */
483 contract OraclizeC is Ownable, usingOraclize {
484   uint public updateInterval = 300; //5 minutes by default
485   uint public gasLimit = 200000; // Oraclize Gas Limit
486   mapping (bytes32 => bool) validIds;
487   string public url;
488 
489   enum State { New, Stopped, Active }
490 
491   State public state = State.New;
492 
493   event LogOraclizeQuery(string description, uint balance, uint blockTimestamp);
494   event LogOraclizeAddrResolverI(address oar);
495 
496   modifier inActiveState() {
497     require(state == State.Active);
498     _;
499   }
500 
501   modifier inStoppedState() {
502     require(state == State.Stopped);
503     _;
504   }
505 
506   modifier inNewState() {
507     require(state == State.New);
508     _;
509   }
510 
511   function setUpdateInterval(uint newInterval) external onlyOwner {
512     require(newInterval > 0);
513     updateInterval = newInterval;
514   }
515 
516   function setUrl(string newUrl) external onlyOwner {
517     require(bytes(newUrl).length > 0);
518     url = newUrl;
519   }
520 
521   function setGasLimit(uint _gasLimit) external onlyOwner {
522     require(_gasLimit > 50000);
523     gasLimit = _gasLimit;
524   }
525 
526   function setGasPrice(uint gasPrice) external onlyOwner {
527     require(gasPrice >= 1000000000); // 1 Gwei
528     oraclize_setCustomGasPrice(gasPrice);
529   }
530 
531   //local development
532   function setOraclizeAddrResolverI(address __oar) public onlyOwner {
533     require(__oar != 0x0);
534     OAR = OraclizeAddrResolverI(__oar);
535     LogOraclizeAddrResolverI(__oar);
536   }
537 
538   //we need to get back our funds if we don't need this oracle anymore
539   function withdraw(address receiver) external onlyOwner inStoppedState {
540     require(receiver != 0x0);
541     receiver.transfer(this.balance);
542   }
543 }
544 
545 /**
546  * @title Pausable
547  * @dev Base contract which allows children to implement an emergency stop mechanism.
548  */
549 contract Pausable is Ownable {
550   event Pause();
551   event Unpause();
552 
553   bool public paused = false;
554 
555 
556   /**
557    * @dev Modifier to make a function callable only when the contract is not paused.
558    */
559   modifier whenNotPaused() {
560     require(!paused);
561     _;
562   }
563 
564   /**
565    * @dev Modifier to make a function callable only when the contract is paused.
566    */
567   modifier whenPaused() {
568     require(paused);
569     _;
570   }
571 
572   /**
573    * @dev called by the owner to pause, triggers stopped state
574    */
575   function pause() onlyOwner whenNotPaused public {
576     paused = true;
577     Pause();
578   }
579 
580   /**
581    * @dev called by the owner to unpause, returns to normal state
582    */
583   function unpause() onlyOwner whenPaused public {
584     paused = false;
585     Unpause();
586   }
587 }
588 
589 /**
590  * @title SafeMath
591  * @dev Math operations with safety checks that throw on error
592  */
593 library SafeMath {
594 
595   /**
596   * @dev Multiplies two numbers, throws on overflow.
597   */
598   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
599     if (a == 0) {
600       return 0;
601     }
602     uint256 c = a * b;
603     assert(c / a == b);
604     return c;
605   }
606 
607   /**
608   * @dev Integer division of two numbers, truncating the quotient.
609   */
610   function div(uint256 a, uint256 b) internal pure returns (uint256) {
611     // assert(b > 0); // Solidity automatically throws when dividing by 0
612     uint256 c = a / b;
613     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
614     return c;
615   }
616 
617   /**
618   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
619   */
620   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
621     assert(b <= a);
622     return a - b;
623   }
624 
625   /**
626   * @dev Adds two numbers, throws on overflow.
627   */
628   function add(uint256 a, uint256 b) internal pure returns (uint256) {
629     uint256 c = a + b;
630     assert(c >= a);
631     return c;
632   }
633 }
634 
635 /**
636  * @author Emil Dudnyk
637  */
638 contract ETHPriceProvider is OraclizeC {
639   using SafeMath for uint;
640 
641   uint public currentPrice;
642 
643   ETHPriceWatcher public watcher;
644 
645   event LogPriceUpdated(string getPrice, uint setPrice, uint blockTimestamp);
646   event LogStartUpdate(uint startingPrice, uint updateInterval, uint blockTimestamp);
647 
648   function notifyWatcher() internal;
649 
650   function ETHPriceProvider(string _url) payable public {
651     url = _url;
652 
653     //update immediately first time to be sure everything is working - first oraclize request is free.
654     //update(0);
655   }
656 
657   //send some funds along with the call to cover oraclize fees
658   function startUpdate(uint startingPrice) payable onlyOwner inNewState public {
659     state = State.Active;
660 
661     currentPrice = startingPrice;
662     update(updateInterval);
663     notifyWatcher();
664     LogStartUpdate(startingPrice, updateInterval, block.timestamp);
665   }
666 
667   function stopUpdate() external onlyOwner inActiveState {
668     state = State.Stopped;
669   }
670 
671   function setWatcher(address newWatcher) external onlyOwner {
672     require(newWatcher != 0x0);
673     watcher = ETHPriceWatcher(newWatcher);
674   }
675 
676   function __callback(bytes32 myid, string result) public {
677     require(msg.sender == oraclize_cbAddress() && validIds[myid]);
678     delete validIds[myid];
679 
680     uint newPrice = parseInt(result, 2);
681 
682     if (state == State.Active) {
683       update(updateInterval);
684     }
685 
686     require(newPrice > 0);
687 
688     currentPrice = newPrice;
689 
690     notifyWatcher();
691     LogPriceUpdated(result,newPrice,block.timestamp);
692   }
693 
694   function update(uint delay) private {
695     if (oraclize_getPrice("URL") > this.balance) {
696       //stop if we don't have enough funds anymore
697       state = State.Stopped;
698       LogOraclizeQuery("Oraclize query was NOT sent", this.balance,block.timestamp);
699     } else {
700       bytes32 queryId = oraclize_query(delay, "URL", url, gasLimit);
701       validIds[queryId] = true;
702     }
703   }
704 
705   function getQuote() public constant returns (uint) {
706     return currentPrice;
707   }
708 
709 }
710 
711 contract ConvertQuote is ETHPriceProvider {
712   //Encrypted Query
713   function ConvertQuote(uint _currentPrice) ETHPriceProvider("BIa/Nnj1+ipZBrrLIgpTsI6ukQTlTJMd1c0iC7zvxx+nZzq9ODgBSmCLo3Zc0sYZwD8mlruAi5DblQvt2cGsfVeCyqaxu+1lWD325kgN6o0LxrOUW9OQWn2COB3TzcRL51Q+ZLBsT955S1OJbOqsfQ4gg/l2awe2EFVuO3WTprvwKhAa8tjl2iPYU/AJ83TVP9Kpz+ugTJumlz2Y6SPBGMNcvBoRq3MlnrR2h/XdqPbh3S2bxjbSTLwyZzu2DAgVtybPO1oJETY=") payable public {
714     currentPrice = _currentPrice;
715   }
716 
717   function notifyWatcher() internal {
718     if(address(watcher) != 0x0) {
719       watcher.receiveEthPrice(currentPrice);
720     }
721   }
722 }
723 
724 /**
725  * @title Contract that will work with ERC223 tokens.
726  */
727  
728 contract ERC223ReceivingContract {
729 
730   struct TKN {
731     address sender;
732     uint value;
733     bytes data;
734     bytes4 sig;
735   }
736 
737   /**
738    * @dev Standard ERC223 function that will handle incoming token transfers.
739    *
740    * @param _from  Token sender address.
741    * @param _value Amount of tokens.
742    * @param _data  Transaction metadata.
743    */
744   function tokenFallback(address _from, uint _value, bytes _data) public pure {
745     TKN memory tkn;
746     tkn.sender = _from;
747     tkn.value = _value;
748     tkn.data = _data;
749     if(_data.length > 0) {
750       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
751       tkn.sig = bytes4(u);
752     }
753 
754     /* tkn variable is analogue of msg variable of Ether transaction
755     *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
756     *  tkn.value the number of tokens that were sent   (analogue of msg.value)
757     *  tkn.data is data of token transaction   (analogue of msg.data)
758     *  tkn.sig is 4 bytes signature of function
759     *  if data of token transaction is a function execution
760     */
761   }
762 
763 }
764 
765 contract ERC223Interface {
766   uint public totalSupply;
767   function balanceOf(address who) public view returns (uint);
768   function allowedAddressesOf(address who) public view returns (bool);
769   function getTotalSupply() public view returns (uint);
770 
771   function transfer(address to, uint value) public returns (bool ok);
772   function transfer(address to, uint value, bytes data) public returns (bool ok);
773   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
774 
775   event Transfer(address indexed from, address indexed to, uint value, bytes data);
776   event TransferContract(address indexed from, address indexed to, uint value, bytes data);
777 }
778 
779 /**
780  * @title Unity Token is ERC223 token.
781  * @author Vladimir Kovalchuk
782  */
783 
784 contract UnityToken is ERC223Interface {
785   using SafeMath for uint;
786 
787   string public constant name = "Unity Token";
788   string public constant symbol = "UNT";
789   uint8 public constant decimals = 18;
790 
791 
792   /* The supply is initially 100UNT to the precision of 18 decimals */
793   uint public constant INITIAL_SUPPLY = 100000 * (10 ** uint(decimals));
794 
795   mapping(address => uint) balances; // List of user balances.
796   mapping(address => bool) allowedAddresses;
797 
798   modifier onlyOwner() {
799     require(msg.sender == owner);
800     _;
801   }
802 
803   function addAllowed(address newAddress) public onlyOwner {
804     allowedAddresses[newAddress] = true;
805   }
806 
807   function removeAllowed(address remAddress) public onlyOwner {
808     allowedAddresses[remAddress] = false;
809   }
810 
811 
812   address public owner;
813 
814   /* Constructor initializes the owner's balance and the supply  */
815   function UnityToken() public {
816     owner = msg.sender;
817     totalSupply = INITIAL_SUPPLY;
818     balances[owner] = INITIAL_SUPPLY;
819   }
820 
821   function getTotalSupply() public view returns (uint) {
822     return totalSupply;
823   }
824 
825   // Function that is called when a user or another contract wants to transfer funds .
826   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
827     if (isContract(_to)) {
828       require(allowedAddresses[_to]);
829       if (balanceOf(msg.sender) < _value)
830         revert();
831 
832       balances[msg.sender] = balances[msg.sender].sub(_value);
833       balances[_to] = balances[_to].add(_value);
834       assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
835       TransferContract(msg.sender, _to, _value, _data);
836       return true;
837     }
838     else {
839       return transferToAddress(_to, _value, _data);
840     }
841   }
842 
843 
844   // Function that is called when a user or another contract wants to transfer funds .
845   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
846 
847     if (isContract(_to)) {
848       return transferToContract(_to, _value, _data);
849     } else {
850       return transferToAddress(_to, _value, _data);
851     }
852   }
853 
854   // Standard function transfer similar to ERC20 transfer with no _data .
855   // Added due to backwards compatibility reasons .
856   function transfer(address _to, uint _value) public returns (bool success) {
857     //standard function transfer similar to ERC20 transfer with no _data
858     //added due to backwards compatibility reasons
859     bytes memory empty;
860     if (isContract(_to)) {
861       return transferToContract(_to, _value, empty);
862     }
863     else {
864       return transferToAddress(_to, _value, empty);
865     }
866   }
867 
868   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
869   function isContract(address _addr) private view returns (bool is_contract) {
870     uint length;
871     assembly {
872     //retrieve the size of the code on target address, this needs assembly
873       length := extcodesize(_addr)
874     }
875     return (length > 0);
876   }
877 
878   //function that is called when transaction target is an address
879   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
880     if (balanceOf(msg.sender) < _value)
881       revert();
882     balances[msg.sender] = balances[msg.sender].sub(_value);
883     balances[_to] = balances[_to].add(_value);
884     Transfer(msg.sender, _to, _value, _data);
885     return true;
886   }
887 
888   //function that is called when transaction target is a contract
889   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
890     require(allowedAddresses[_to]);
891     if (balanceOf(msg.sender) < _value)
892       revert();
893     balances[msg.sender] = balances[msg.sender].sub(_value);
894     balances[_to] = balances[_to].add(_value);
895     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
896     receiver.tokenFallback(msg.sender, _value, _data);
897     TransferContract(msg.sender, _to, _value, _data);
898     return true;
899   }
900 
901 
902   function balanceOf(address _owner) public view returns (uint balance) {
903     return balances[_owner];
904   }
905 
906   function allowedAddressesOf(address _owner) public view returns (bool allowed) {
907     return allowedAddresses[_owner];
908   }
909 }
910 
911 /**
912  * @title Hold  contract.
913  * @author Vladimir Kovalchuk
914  */
915 contract Hold is Ownable {
916 
917     uint8 stages = 5;
918     uint8 public percentage;
919     uint8 public currentStage;
920     uint public initialBalance;
921     uint public withdrawed;
922     
923     address public multisig;
924     Registry registry;
925 
926     PermissionManager public permissionManager;
927     uint nextContributorToTransferEth;
928     address public observer;
929     uint dateDeployed;
930     mapping(address => bool) private hasWithdrawedEth;
931 
932     event InitialBalanceChanged(uint balance);
933     event EthReleased(uint ethreleased);
934     event EthRefunded(address contributor, uint ethrefunded);
935     event StageChanged(uint8 newStage);
936     event EthReturnedToOwner(address owner, uint balance);
937 
938     modifier onlyPermitted() {
939         require(permissionManager.isPermitted(msg.sender) || msg.sender == owner);
940         _;
941     }
942 
943     modifier onlyObserver() {
944         require(msg.sender == observer || msg.sender == owner);
945         _;
946     }
947 
948     function Hold(address _multisig, uint cap, address pm, address registryAddress, address observerAddr) public {
949         percentage = 100 / stages;
950         currentStage = 0;
951         multisig = _multisig;
952         initialBalance = cap;
953         dateDeployed = now;
954         permissionManager = PermissionManager(pm);
955         registry = Registry(registryAddress);
956         observer = observerAddr;
957     }
958 
959     function setPermissionManager(address _permadr) public onlyOwner {
960         require(_permadr != 0x0);
961         permissionManager = PermissionManager(_permadr);
962     }
963 
964     function setObserver(address observerAddr) public onlyOwner {
965         require(observerAddr != 0x0);
966         observer = observerAddr;
967     }
968 
969     function setInitialBalance(uint inBal) public {
970         initialBalance = inBal;
971         InitialBalanceChanged(inBal);
972     }
973 
974     function releaseAllETH() onlyPermitted public {
975         uint balReleased = getBalanceReleased();
976         require(balReleased > 0);
977         require(this.balance >= balReleased);
978         multisig.transfer(balReleased);
979         withdrawed += balReleased;
980         EthReleased(balReleased);
981     }
982 
983     function releaseETH(uint n) onlyPermitted public {
984         require(this.balance >= n);
985         require(getBalanceReleased() >= n);
986         multisig.transfer(n);
987         withdrawed += n;
988         EthReleased(n);
989     } 
990 
991     function getBalance() public view returns (uint) {
992         return this.balance;
993     }
994 
995     function changeStageAndReleaseETH() public onlyObserver {
996         uint8 newStage = currentStage + 1;
997         require(newStage <= stages);
998         currentStage = newStage;
999         StageChanged(newStage);
1000         releaseAllETH();
1001     }
1002 
1003     function changeStage() public onlyObserver {
1004         uint8 newStage = currentStage + 1;
1005         require(newStage <= stages);
1006         currentStage = newStage;
1007         StageChanged(newStage);
1008     }
1009 
1010     function getBalanceReleased() public view returns (uint) {
1011         return initialBalance * percentage * currentStage / 100 - withdrawed ;
1012     }
1013 
1014     function returnETHByOwner() public onlyOwner {
1015         require(now > dateDeployed + 183 days);
1016         uint balance = getBalance();
1017         owner.transfer(getBalance());
1018         EthReturnedToOwner(owner, balance);
1019     }
1020 
1021     function refund(uint _numberOfReturns) public onlyOwner {
1022         require(_numberOfReturns > 0);
1023         address currentParticipantAddress;
1024 
1025         for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
1026             currentParticipantAddress = registry.getContributorByIndex(nextContributorToTransferEth);
1027             if (currentParticipantAddress == 0x0) 
1028                 return;
1029 
1030             if (!hasWithdrawedEth[currentParticipantAddress]) {
1031                 uint EthAmount = registry.getContributionETH(currentParticipantAddress);
1032                 EthAmount -=  EthAmount * (percentage / 100 * currentStage);
1033 
1034                 currentParticipantAddress.transfer(EthAmount);
1035                 EthRefunded(currentParticipantAddress, EthAmount);
1036                 hasWithdrawedEth[currentParticipantAddress] = true;
1037             }
1038             nextContributorToTransferEth += 1;
1039         }
1040         
1041     }  
1042 
1043     function() public payable {
1044 
1045     }
1046 
1047   function getWithdrawed(address contrib) public onlyPermitted view returns (bool) {
1048     return hasWithdrawedEth[contrib];
1049   }
1050 }
1051 
1052 contract Crowdsale is Pausable, ETHPriceWatcher, ERC223ReceivingContract {
1053   using SafeMath for uint256;
1054 
1055   UnityToken public token;
1056 
1057   Hold hold;
1058   ConvertQuote convert;
1059   Registry registry;
1060 
1061   enum SaleState  {NEW, SALE, ENDED, REFUND}
1062 
1063   // minimum goal USD
1064   uint public softCap;
1065   // maximum goal USD
1066   uint public hardCap;
1067   // maximum goal UNT
1068   uint public hardCapToken;
1069 
1070   // start and end timestamps where investments are allowed
1071   uint public startDate;
1072   uint public endDate;
1073 
1074   uint public ethUsdPrice; // in cents
1075   uint public tokenUSDRate; // in cents
1076 
1077   // total ETH collected
1078   uint private ethRaised;
1079   // total USD collected
1080   uint private usdRaised;
1081 
1082   // total token sales
1083   uint private totalTokens;
1084   // how many tokens sent to investors
1085   uint public withdrawedTokens;
1086   // minimum ETH investment amount
1087   uint public minimalContribution;
1088 
1089   bool releasedTokens;
1090   BuildingStatus public statusI;
1091 
1092   PermissionManager public permissionManager;
1093 
1094   //minimum of tokens that must be on the contract for the start
1095   uint private minimumTokensToStart;
1096   SaleState public state;
1097 
1098   uint private nextContributorToClaim;
1099   uint private nextContributorToTransferTokens;
1100 
1101   mapping(address => bool) private hasWithdrawedTokens; //address who got a tokens
1102   mapping(address => bool) private hasRefunded; //address who got a tokens
1103 
1104   /* Events */
1105   event CrowdsaleStarted(uint blockNumber);
1106   event CrowdsaleEnded(uint blockNumber);
1107   event SoftCapReached(uint blockNumber);
1108   event HardCapReached(uint blockNumber);
1109   event ContributionAdded(address contrib, uint amount, uint amusd, uint tokens, uint ethusdrate);
1110   event ContributionAddedManual(address contrib, uint amount, uint amusd, uint tokens, uint ethusdrate);
1111   event ContributionEdit(address contrib, uint amount, uint amusd, uint tokens, uint ethusdrate);
1112   event ContributionRemoved(address contrib, uint amount, uint amusd, uint tokens);
1113   event TokensTransfered(address contributor, uint amount);
1114   event Refunded(address ref, uint amount);
1115   event ErrorSendingETH(address to, uint amount);
1116   event WithdrawedEthToHold(uint amount);
1117   event ManualChangeStartDate(uint beforeDate, uint afterDate);
1118   event ManualChangeEndDate(uint beforeDate, uint afterDate);
1119   event TokensTransferedToHold(address hold, uint amount);
1120   event TokensTransferedToOwner(address hold, uint amount);
1121   event ChangeMinAmount(uint oldMinAmount, uint minAmount);
1122   event ChangePreSale(address preSale);
1123   event ChangeTokenUSDRate(uint oldTokenUSDRate, uint tokenUSDRate);
1124   event ChangeHardCapToken(uint oldHardCapToken, uint newHardCapToken);
1125   event SoftCapChanged();
1126   event HardCapChanged();
1127 
1128   modifier onlyPermitted() {
1129     require(permissionManager.isPermitted(msg.sender) || msg.sender == owner);
1130     _;
1131   }
1132 
1133   function Crowdsale(
1134     address tokenAddress,
1135     address registryAddress,
1136     address _permissionManager,
1137     uint start,
1138     uint end,
1139     uint _softCap,
1140     uint _hardCap,
1141     address holdCont,
1142     uint _ethUsdPrice) public
1143   {
1144     token = UnityToken(tokenAddress);
1145     permissionManager = PermissionManager(_permissionManager);
1146     state = SaleState.NEW;
1147 
1148     startDate = start;
1149     endDate = end;
1150     minimalContribution = 0.3 * 1 ether;
1151     tokenUSDRate = 44500; //445.00$ in cents
1152     releasedTokens = false;
1153 
1154     softCap = _softCap * 1 ether;
1155     hardCap = _hardCap * 1 ether;
1156     hardCapToken = 100000 * 1 ether;
1157 
1158     ethUsdPrice = _ethUsdPrice;
1159 
1160     hold = Hold(holdCont);
1161     registry = Registry(registryAddress);
1162   }
1163 
1164 
1165   function setPermissionManager(address _permadr) public onlyOwner {
1166     require(_permadr != 0x0);
1167     permissionManager = PermissionManager(_permadr);
1168   }
1169 
1170 
1171   function setRegistry(address _regadr) public onlyOwner {
1172     require(_regadr != 0x0);
1173     registry = Registry(_regadr);
1174   }
1175 
1176   function setTokenUSDRate(uint _tokenUSDRate) public onlyOwner {
1177     require(_tokenUSDRate > 0);
1178     uint oldTokenUSDRate = tokenUSDRate;
1179     tokenUSDRate = _tokenUSDRate;
1180     ChangeTokenUSDRate(oldTokenUSDRate, _tokenUSDRate);
1181   }
1182 
1183   function getTokenUSDRate() public view returns (uint) {
1184     return tokenUSDRate;
1185   }
1186 
1187   function receiveEthPrice(uint _ethUsdPrice) external onlyEthPriceProvider {
1188     require(_ethUsdPrice > 0);
1189     ethUsdPrice = _ethUsdPrice;
1190   }
1191 
1192   function setEthPriceProvider(address provider) external onlyOwner {
1193     require(provider != 0x0);
1194     ethPriceProvider = provider;
1195   }
1196 
1197   /* Setters */
1198   function setHold(address holdCont) public onlyOwner {
1199     require(holdCont != 0x0);
1200     hold = Hold(holdCont);
1201   }
1202 
1203   function setToken(address tokCont) public onlyOwner {
1204     require(tokCont != 0x0);
1205     token = UnityToken(tokCont);
1206   }
1207 
1208   function setStatusI(address statI) public onlyOwner {
1209     require(statI != 0x0);
1210     statusI = BuildingStatus(statI);
1211   }
1212 
1213   function setStartDate(uint date) public onlyOwner {
1214     uint oldStartDate = startDate;
1215     startDate = date;
1216     ManualChangeStartDate(oldStartDate, date);
1217   }
1218 
1219   function setEndDate(uint date) public onlyOwner {
1220     uint oldEndDate = endDate;
1221     endDate = date;
1222     ManualChangeEndDate(oldEndDate, date);
1223   }
1224 
1225   function setSoftCap(uint _softCap) public onlyOwner {
1226     softCap = _softCap * 1 ether;
1227     SoftCapChanged();
1228   }
1229 
1230   function setHardCap(uint _hardCap) public onlyOwner {
1231     hardCap = _hardCap * 1 ether;
1232     HardCapChanged();
1233   }
1234 
1235   function setMinimalContribution(uint minimumAmount) public onlyOwner {
1236     uint oldMinAmount = minimalContribution;
1237     minimalContribution = minimumAmount;
1238     ChangeMinAmount(oldMinAmount, minimalContribution);
1239   }
1240 
1241   function setHardCapToken(uint _hardCapToken) public onlyOwner {
1242     require(_hardCapToken > 1 ether); // > 1 UNT
1243     uint oldHardCapToken = _hardCapToken;
1244     hardCapToken = _hardCapToken;
1245     ChangeHardCapToken(oldHardCapToken, hardCapToken);
1246   }
1247 
1248   /* The function without name is the default function that is called whenever anyone sends funds to a contract */
1249   function() whenNotPaused public payable {
1250     require(state == SaleState.SALE);
1251     require(now >= startDate);
1252     require(msg.value >= minimalContribution);
1253 
1254     bool ckeck = checkCrowdsaleState(msg.value);
1255 
1256     if(ckeck) {
1257       processTransaction(msg.sender, msg.value);
1258     } else {
1259       msg.sender.transfer(msg.value);
1260     }
1261   }
1262 
1263   /**
1264    * @dev Checks if the goal or time limit has been reached and ends the campaign
1265    * @return false when contract does not accept tokens
1266    */
1267   function checkCrowdsaleState(uint _amount) internal returns (bool) {
1268     uint usd = _amount.mul(ethUsdPrice);
1269     if (usdRaised.add(usd) >= hardCap) {
1270       state = SaleState.ENDED;
1271       statusI.setStatus(BuildingStatus.statusEnum.preparation_works);
1272       HardCapReached(block.number);
1273       CrowdsaleEnded(block.number);
1274       return true;
1275     }
1276 
1277     if (now > endDate) {
1278       if (usdRaised.add(usd) >= softCap) {
1279         state = SaleState.ENDED;
1280         statusI.setStatus(BuildingStatus.statusEnum.preparation_works);
1281         CrowdsaleEnded(block.number);
1282         return false;
1283       } else {
1284         state = SaleState.REFUND;
1285         statusI.setStatus(BuildingStatus.statusEnum.refund);
1286         CrowdsaleEnded(block.number);
1287         return false;
1288       }
1289     }
1290     return true;
1291   }
1292 
1293   /**
1294  * @dev Token purchase
1295  */
1296   function processTransaction(address _contributor, uint _amount) internal {
1297 
1298     require(msg.value >= minimalContribution);
1299 
1300     uint maxContribution = calculateMaxContributionUsd();
1301     uint contributionAmountUsd = _amount.mul(ethUsdPrice);
1302     uint contributionAmountETH = _amount;
1303 
1304     uint returnAmountETH = 0;
1305 
1306     if (maxContribution < contributionAmountUsd) {
1307       contributionAmountUsd = maxContribution;
1308       uint returnAmountUsd = _amount.mul(ethUsdPrice) - maxContribution;
1309       returnAmountETH = contributionAmountETH - returnAmountUsd.div(ethUsdPrice);
1310       contributionAmountETH = contributionAmountETH.sub(returnAmountETH);
1311     }
1312 
1313     if (usdRaised + contributionAmountUsd >= softCap && softCap > usdRaised) {
1314       SoftCapReached(block.number);
1315     }
1316 
1317     // get tokens from eth Usd msg.value * ethUsdPrice / tokenUSDRate
1318     // 1 ETH * 860 $ / 445 $ = 193258426966292160 wei = 1.93 UNT
1319     uint tokens = contributionAmountUsd.div(tokenUSDRate);
1320 
1321     if(totalTokens + tokens > hardCapToken) {
1322       _contributor.transfer(_amount);
1323     } else {
1324       if (tokens > 0) {
1325         registry.addContribution(_contributor, contributionAmountETH, contributionAmountUsd, tokens, ethUsdPrice);
1326         ethRaised += contributionAmountETH;
1327         totalTokens += tokens;
1328         usdRaised += contributionAmountUsd;
1329         ContributionAdded(_contributor, contributionAmountETH, contributionAmountUsd, tokens, ethUsdPrice);
1330       }
1331     }
1332 
1333     if (returnAmountETH != 0) {
1334       _contributor.transfer(returnAmountETH);
1335     }
1336   }
1337 
1338   /**
1339    * @dev It is necessary for a correct change of status in the event of completion of the campaign.
1340    * @param _stateChanged if true transfer ETH back
1341    */
1342   function refundTransaction(bool _stateChanged) internal {
1343     if (_stateChanged) {
1344       msg.sender.transfer(msg.value);
1345     } else{
1346       revert();
1347     }
1348   }
1349 
1350   function getTokensIssued() public view returns (uint) {
1351     return totalTokens;
1352   }
1353 
1354   function getTotalUSDInTokens() public view returns (uint) {
1355     return totalTokens.mul(tokenUSDRate);
1356   }
1357 
1358   function getUSDRaised() public view returns (uint) {
1359     return usdRaised;
1360   }
1361 
1362   function calculateMaxContributionUsd() public constant returns (uint) {
1363     return hardCap - usdRaised;
1364   }
1365 
1366   function calculateMaxTokensIssued() public constant returns (uint) {
1367     return hardCapToken - totalTokens;
1368   }
1369 
1370   function calculateMaxEthIssued() public constant returns (uint) {
1371     return hardCap.mul(ethUsdPrice) - usdRaised.mul(ethUsdPrice);
1372   }
1373 
1374   function getEthRaised() public view returns (uint) {
1375     return ethRaised;
1376   }
1377 
1378   function checkBalanceContract() internal view returns (uint) {
1379     return token.balanceOf(this);
1380   }
1381 
1382   function getContributorTokens(address contrib) public view returns (uint) {
1383     return registry.getContributionTokens(contrib);
1384   }
1385 
1386   function getContributorETH(address contrib) public view returns (uint) {
1387     return registry.getContributionETH(contrib);
1388   }
1389 
1390   function getContributorUSD(address contrib) public view returns (uint) {
1391     return registry.getContributionUSD(contrib);
1392   }
1393 
1394   function batchReturnUNT(uint _numberOfReturns) public onlyOwner whenNotPaused {
1395     require((now > endDate && usdRaised >= softCap )  || ( usdRaised >= hardCap)  );
1396     require(state == SaleState.ENDED);
1397     require(_numberOfReturns > 0);
1398 
1399     address currentParticipantAddress;
1400 
1401     for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
1402       currentParticipantAddress = registry.getContributorByIndex(nextContributorToTransferTokens);
1403       if (currentParticipantAddress == 0x0)
1404         return;
1405 
1406       if (!hasWithdrawedTokens[currentParticipantAddress] && registry.isActiveContributor(currentParticipantAddress)) {
1407 
1408         uint numberOfUNT = registry.getContributionTokens(currentParticipantAddress);
1409 
1410         if(token.transfer(currentParticipantAddress, numberOfUNT)) {
1411           TokensTransfered(currentParticipantAddress, numberOfUNT);
1412           withdrawedTokens += numberOfUNT;
1413           hasWithdrawedTokens[currentParticipantAddress] = true;
1414         }
1415       }
1416 
1417       nextContributorToTransferTokens += 1;
1418     }
1419 
1420   }
1421 
1422   function getTokens() public whenNotPaused {
1423     require((now > endDate && usdRaised >= softCap )  || ( usdRaised >= hardCap)  );
1424     require(state == SaleState.ENDED);
1425     require(!hasWithdrawedTokens[msg.sender] && registry.isActiveContributor(msg.sender));
1426     require(getTokenBalance() >= registry.getContributionTokens(msg.sender));
1427 
1428     uint numberOfUNT = registry.getContributionTokens(msg.sender);
1429 
1430     if(token.transfer(msg.sender, numberOfUNT)) {
1431       TokensTransfered(msg.sender, numberOfUNT);
1432       withdrawedTokens += numberOfUNT;
1433       hasWithdrawedTokens[msg.sender] = true;
1434     }
1435 
1436   }
1437 
1438   function getOverTokens() public onlyOwner {
1439     require(checkBalanceContract() > (totalTokens - withdrawedTokens));
1440     uint balance = checkBalanceContract() - (totalTokens - withdrawedTokens);
1441     if(balance > 0) {
1442       if(token.transfer(msg.sender, balance)) {
1443         TokensTransfered(msg.sender,  balance);
1444       }
1445     }
1446   }
1447 
1448   /**
1449    * @dev if crowdsale is unsuccessful, investors can claim refunds here
1450    */
1451   function refund() public whenNotPaused {
1452     require(state == SaleState.REFUND);
1453     require(registry.getContributionETH(msg.sender) > 0);
1454     require(!hasRefunded[msg.sender]);
1455 
1456     uint ethContributed = registry.getContributionETH(msg.sender);
1457     if (!msg.sender.send(ethContributed)) {
1458       ErrorSendingETH(msg.sender, ethContributed);
1459     } else {
1460       hasRefunded[msg.sender] = true;
1461       Refunded(msg.sender, ethContributed);
1462     }
1463   }
1464 
1465   /**
1466    * @dev transfer funds ETH to multisig wallet if reached minimum goal
1467    */
1468   function withdrawEth() public onlyOwner {
1469     require(state == SaleState.ENDED);
1470     uint bal = this.balance;
1471     hold.transfer(bal);
1472     hold.setInitialBalance(bal);
1473     WithdrawedEthToHold(bal);
1474   }
1475 
1476   function newCrowdsale() public onlyOwner {
1477     state = SaleState.NEW;
1478   }
1479 
1480   /**
1481    * @dev Manual start crowdsale.
1482    */
1483   function startCrowdsale() public onlyOwner {
1484     require(now > startDate && now <= endDate);
1485     require(state == SaleState.NEW);
1486 
1487     statusI.setStatus(BuildingStatus.statusEnum.crowdsale);
1488     state = SaleState.SALE;
1489     CrowdsaleStarted(block.number);
1490   }
1491 
1492   // @return true if crowdsale event has ended
1493   function hasEnded() public constant returns (bool) {
1494     return now > endDate || state == SaleState.ENDED;
1495   }
1496 
1497   function getTokenBalance() public constant returns (uint) {
1498     return token.balanceOf(this);
1499   }
1500 
1501   function getSoftCap() public view returns (uint) {
1502     return softCap;
1503   }
1504 
1505   function getHardCap() public view returns (uint) {
1506     return hardCap;
1507   }
1508 
1509   function getStartDate() public view returns (uint) {
1510     return startDate;
1511   }
1512 
1513   function getEndDate() public view returns (uint) {
1514     return endDate;
1515   }
1516 
1517   function getContributorAmount() public view returns (uint) {
1518     return registry.getContributorAmount();
1519   }
1520 
1521   function getWithdrawed(address contrib) public view returns (bool) {
1522     return hasWithdrawedTokens[contrib];
1523   }
1524 
1525   function getRefunded(address contrib) public view returns (bool) {
1526     return hasRefunded[contrib];
1527   }
1528 
1529   function addContributor(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote) public onlyPermitted {
1530     registry.addContributor(_contributor, _amount, _amusd, _tokens, _quote);
1531     ethRaised += _amount;
1532     usdRaised += _amusd;
1533     totalTokens += _tokens;
1534     ContributionAddedManual(_contributor, ethRaised, usdRaised, totalTokens, _quote);
1535 
1536   }
1537 
1538   function editContribution(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote) public onlyPermitted {
1539     ethRaised -= registry.getContributionETH(_contributor);
1540     usdRaised -= registry.getContributionUSD(_contributor);
1541     totalTokens -= registry.getContributionTokens(_contributor);
1542 
1543     registry.editContribution(_contributor, _amount, _amusd, _tokens, _quote);
1544     ethRaised += _amount;
1545     usdRaised += _amusd;
1546     totalTokens += _tokens;
1547     ContributionAdded(_contributor, ethRaised, usdRaised, totalTokens, _quote);
1548 
1549   }
1550 
1551   function removeContributor(address _contributor) public onlyPermitted {
1552     registry.removeContribution(_contributor);
1553     ethRaised -= registry.getContributionETH(_contributor);
1554     usdRaised -= registry.getContributionUSD(_contributor);
1555     totalTokens -= registry.getContributionTokens(_contributor);
1556     ContributionRemoved(_contributor, ethRaised, usdRaised, totalTokens);
1557   }
1558 
1559 }