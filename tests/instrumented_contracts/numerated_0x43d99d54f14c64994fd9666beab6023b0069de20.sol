1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-09
3 */
4 
5 pragma solidity ^0.5.12;
6 
7 /**
8  * @title Quotation data contract
9  * @dev Verification of quotation contract
10  */
11 contract NEST_3_OfferData {
12 
13     mapping (address => bool) addressMapping;       //  Deployed quote contracts
14     NEST_2_Mapping mappingContract;                 //  Mapping contract
15     
16     /**
17     * @dev Initialization method
18     * @param map Mapping contract address
19     */
20     constructor(address map) public{
21         mappingContract = NEST_2_Mapping(map);                                                      
22     }
23     
24     /**
25     * @dev Initialization method
26     * @param map Mapping contract address
27     */
28     function changeMapping(address map) public onlyOwner {
29         mappingContract = NEST_2_Mapping(map);                                                    
30     }
31     
32     /**
33     * @dev Initialization method
34     * @param contractAddress Address of quotation contract
35     * @return existence of quotation contract
36     */
37     function checkContract(address contractAddress) public view returns (bool){
38         require(contractAddress != address(0x0));
39         return addressMapping[contractAddress];
40     }
41     
42     /**
43     * @dev Add quote contract address
44     * @param contractAddress Address of quotation contract
45     */
46     function addContractAddress(address contractAddress) public {
47         require(address(mappingContract.checkAddress("offerFactory")) == msg.sender);
48         addressMapping[contractAddress] = true;
49     }
50     
51     modifier onlyOwner(){
52         require(mappingContract.checkOwners(msg.sender) == true);
53         _;
54     }
55 }
56 
57 /**
58  * @title Quotation factory
59  * @dev Quotation mining
60  */
61 contract NEST_3_OfferFactory {
62     using SafeMath for uint256;
63     using address_make_payable for address;
64     mapping(address => bool) tokenAllow;                //  Insured mining token
65     NEST_2_Mapping mappingContract;                     //  Mapping contract
66     NEST_3_OfferData dataContract;                      //  Data contract
67     NEST_2_OfferPrice offerPrice;                       //  Price contract
68     NEST_3_OrePoolLogic orePoolLogic;                   //  Mining contract
69     NEST_NodeAssignment NNcontract;                     //  NestNode contract
70     ERC20 nestToken;                                    //  nestToken
71     address abonusAddress;                              //  Dividend pool
72     address coderAddress;                               //  Developer address
73     uint256 miningETH = 10;                             //  Quotation mining service charge mining proportion, 10 thousandths
74     uint256 tranEth = 2;                                //  Service charge proportion of the bill of lading, 2 ‰
75     uint256 blockLimit = 25;                            //  Block interval upper limit
76     uint256 tranAddition = 2;                           //  Transaction bonus
77     uint256 coderAmount = 5;                            //  Developer ratio
78     uint256 NNAmount = 15;                              //  Guardian node proportion
79     uint256 otherAmount = 80;                           //  Distributable proportion
80     uint256 leastEth = 10 ether;                        //  Minimum offer eth
81     uint256 offerSpan = 10 ether;                       //  Quotation eth span
82     
83     //  log Personal asset contract
84     event offerTokenContractAddress(address contractAddress);    
85     //  log Quotation contract, token address, ETH quantity, erc20 quantity     
86     event offerContractAddress(address contractAddress, address tokenAddress, uint256 ethAmount, uint256 erc20Amount); 
87     //  log Transaction, transaction initiator, transaction token address, transaction token quantity, purchase token address, purchase token quantity, traded quotation contract address, traded user address  
88     event offerTran(address tranSender, address tranToken, uint256 tranAmount,address otherToken, uint256 otherAmount, address tradedContract, address tradedOwner);        
89     
90     /**
91     * @dev Initialization method
92     * @param map Mapping contract address
93     */
94     constructor (address map) public {
95         mappingContract = NEST_2_Mapping(map);                                                      
96         offerPrice = NEST_2_OfferPrice(address(mappingContract.checkAddress("offerPrice")));        
97         orePoolLogic = NEST_3_OrePoolLogic(address(mappingContract.checkAddress("miningCalculation")));
98         abonusAddress = mappingContract.checkAddress("abonus");
99         nestToken = ERC20(mappingContract.checkAddress("nest"));                                        
100         NNcontract = NEST_NodeAssignment(address(mappingContract.checkAddress("nodeAssignment")));      
101         coderAddress = mappingContract.checkAddress("coder");
102         dataContract = NEST_3_OfferData(address(mappingContract.checkAddress("offerData")));
103     }
104     
105     /**
106     * @dev Change mapping contract
107     * @param map Mapping contract address
108     */
109     function changeMapping(address map) public onlyOwner {
110         mappingContract = NEST_2_Mapping(map);                                                          
111         offerPrice = NEST_2_OfferPrice(address(mappingContract.checkAddress("offerPrice")));            
112         orePoolLogic = NEST_3_OrePoolLogic(address(mappingContract.checkAddress("miningCalculation")));
113         abonusAddress = mappingContract.checkAddress("abonus");
114         nestToken = ERC20(mappingContract.checkAddress("nest"));                                         
115         NNcontract = NEST_NodeAssignment(address(mappingContract.checkAddress("nodeAssignment")));      
116         coderAddress = mappingContract.checkAddress("coder");
117         dataContract = NEST_3_OfferData(address(mappingContract.checkAddress("offerData")));
118     }
119     
120     /**
121     * @dev Quotation mining
122     * @param ethAmount ETH amount
123     * @param erc20Amount erc20 amount
124     * @param erc20Address erc20Token address
125     */
126     function offer(uint256 ethAmount, uint256 erc20Amount, address erc20Address) public payable {
127         require(address(msg.sender) == address(tx.origin));
128         uint256 ethMining = ethAmount.mul(miningETH).div(1000);
129         require(msg.value == ethAmount.add(ethMining));
130         require(tokenAllow[erc20Address]);
131         createOffer(ethAmount,erc20Amount,erc20Address,ethMining);
132         orePoolLogic.oreDrawing.value(ethMining)(erc20Address);
133     }
134     
135     /**
136     * @dev Generate quote
137     * @param ethAmount ETH amount
138     * @param erc20Amount erc20 amount
139     * @param erc20Address erc20Token address
140     * @param mining Mining Commission
141     */
142     function createOffer(uint256 ethAmount, uint256 erc20Amount, address erc20Address, uint256 mining) private {
143         require(ethAmount >= leastEth);
144         require(ethAmount % offerSpan == 0);
145         require(erc20Amount % (ethAmount.div(offerSpan)) == 0);
146         require(erc20Amount > 0);
147         ERC20 token = ERC20(erc20Address);
148         require(token.balanceOf(address(msg.sender)) >= erc20Amount);
149         require(token.allowance(address(msg.sender), address(this)) >= erc20Amount);
150         NEST_3_OfferContract newContract = new NEST_3_OfferContract(ethAmount,erc20Amount,erc20Address,mining,address(mappingContract));
151         dataContract.addContractAddress(address(newContract));
152         emit offerContractAddress(address(newContract), address(erc20Address), ethAmount, erc20Amount);
153         token.transferFrom(address(msg.sender), address(newContract), erc20Amount);
154         newContract.offerAssets.value(ethAmount)();
155         offerPrice.addPrice(ethAmount,erc20Amount,erc20Address);
156     }
157     
158     /**
159     * @dev Take out quoted assets
160     * @param contractAddress Address of quotation contract
161     */
162     function turnOut(address contractAddress) public {
163         require(address(msg.sender) == address(tx.origin));
164         require(dataContract.checkContract(contractAddress));
165         NEST_3_OfferContract offerContract = NEST_3_OfferContract(contractAddress);
166         offerContract.turnOut();
167         uint256 miningEth = offerContract.checkServiceCharge();
168         uint256 blockNum = offerContract.checkBlockNum();
169         address tokenAddress = offerContract.checkTokenAddress();
170         if (miningEth > 0) {
171             uint256 miningAmount = orePoolLogic.mining(miningEth, blockNum, address(this),tokenAddress);
172             uint256 coder = miningAmount.mul(coderAmount).div(100);
173             uint256 NN = miningAmount.mul(NNAmount).div(100);
174             uint256 other = miningAmount.mul(otherAmount).div(100);
175             nestToken.transfer(address(tx.origin), other);
176             require(nestToken.approve(address(NNcontract), NN));
177             NNcontract.bookKeeping(NN);                                               
178             nestToken.transfer(coderAddress, coder);
179         }
180     }
181     
182     /**
183     * @dev Transfer erc20 to buy eth
184     * @param ethAmount Offer ETH amount
185     * @param tokenAmount Offer erc20 amount
186     * @param contractAddress Address of quotation contract
187     * @param tranEthAmount ETH amount of transaction
188     * @param tranTokenAmount erc20 amount of transaction
189     * @param tranTokenAddress erc20Token address
190     */
191     function ethTran(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {
192         require(address(msg.sender) == address(tx.origin));
193         require(dataContract.checkContract(contractAddress));
194         require(ethAmount >= tranEthAmount.mul(tranAddition));
195         uint256 serviceCharge = tranEthAmount.mul(tranEth).div(1000);
196         require(msg.value == ethAmount.add(tranEthAmount).add(serviceCharge));
197         require(tranEthAmount % offerSpan == 0);
198         createOffer(ethAmount,tokenAmount,tranTokenAddress,0);
199         NEST_3_OfferContract offerContract = NEST_3_OfferContract(contractAddress);
200         offerContract.changeOfferEth.value(tranEthAmount)(tranTokenAmount, tranTokenAddress);
201         offerPrice.changePrice(tranEthAmount,tranTokenAmount,tranTokenAddress,offerContract.checkBlockNum());
202         emit offerTran(address(tx.origin), address(0x0), tranEthAmount,address(tranTokenAddress),tranTokenAmount,contractAddress,offerContract.checkOwner());
203         repayEth(abonusAddress,serviceCharge);
204     }
205     
206     /**
207     * @dev Transfer eth to buy erc20
208     * @param ethAmount Offer ETH amount
209     * @param tokenAmount Offer erc20 amount
210     * @param contractAddress Address of quotation contract
211     * @param tranEthAmount ETH amount of transaction
212     * @param tranTokenAmount erc20 amount of transaction
213     * @param tranTokenAddress erc20Token address
214     */
215     function ercTran(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {
216         require(address(msg.sender) == address(tx.origin));
217         require(dataContract.checkContract(contractAddress));
218         require(ethAmount >= tranEthAmount.mul(tranAddition));
219         uint256 serviceCharge = tranEthAmount.mul(tranEth).div(1000);
220         require(msg.value == ethAmount.add(serviceCharge));
221         require(tranEthAmount % offerSpan == 0);
222         createOffer(ethAmount,tokenAmount,tranTokenAddress,0);
223         NEST_3_OfferContract offerContract = NEST_3_OfferContract(contractAddress);
224         ERC20 token = ERC20(tranTokenAddress);
225         require(token.balanceOf(address(msg.sender)) >= tranTokenAmount);
226         require(token.allowance(address(msg.sender), address(this)) >= tranTokenAmount);
227         token.transferFrom(address(msg.sender), address(offerContract), tranTokenAmount);
228         offerContract.changeOfferErc(tranEthAmount,tranTokenAmount, tranTokenAddress);
229         offerPrice.changePrice(tranEthAmount,tranTokenAmount,tranTokenAddress,offerContract.checkBlockNum());
230         emit offerTran(address(tx.origin),address(tranTokenAddress),tranTokenAmount, address(0x0), tranEthAmount,contractAddress,offerContract.checkOwner());
231         repayEth(abonusAddress,serviceCharge);
232     }
233     
234     function repayEth(address accountAddress, uint256 asset) private {
235         address payable addr = accountAddress.make_payable();
236         addr.transfer(asset);
237     }
238 
239     //  View block interval upper limit
240     function checkBlockLimit() public view returns(uint256) {
241         return blockLimit;
242     }
243 
244     //  View quotation handling fee
245     function checkMiningETH() public view returns (uint256) {
246         return miningETH;
247     }
248 
249     //  View transaction charges
250     function checkTranEth() public view returns (uint256) {
251         return tranEth;
252     }
253 
254     //  View whether token allows mining
255     function checkTokenAllow(address token) public view returns(bool) {
256         return tokenAllow[token];
257     }
258 
259     //  View transaction bonus
260     function checkTranAddition() public view returns(uint256) {
261         return tranAddition;
262     }
263 
264     //  View development allocation proportion
265     function checkCoderAmount() public view returns(uint256) {
266         return coderAmount;
267     }
268 
269     //  View the allocation proportion of guardian nodes
270     function checkNNAmount() public view returns(uint256) {
271         return NNAmount;
272     }
273 
274     //  View user assignable proportion
275     function checkOtherAmount() public view returns(uint256) {
276         return otherAmount;
277     }
278 
279     //  View minimum quote eth
280     function checkleastEth() public view returns(uint256) {
281         return leastEth;
282     }
283 
284     //  View quote eth span
285     function checkOfferSpan() public view returns(uint256) {
286         return offerSpan;
287     }
288 
289     function changeMiningETH(uint256 num) public onlyOwner {
290         miningETH = num;
291     }
292 
293     function changeTranEth(uint256 num) public onlyOwner {
294         tranEth = num;
295     }
296 
297     function changeBlockLimit(uint256 num) public onlyOwner {
298         blockLimit = num;
299     }
300 
301     function changeTokenAllow(address token, bool allow) public onlyOwner {
302         tokenAllow[token] = allow;
303     }
304 
305     function changeTranAddition(uint256 num) public onlyOwner {
306         require(num > 0);
307         tranAddition = num;
308     }
309 
310     function changeInitialRatio(uint256 coderNum, uint256 NNNum, uint256 otherNum) public onlyOwner {
311         require(coderNum > 0 && coderNum <= 5);
312         require(NNNum > 0 && coderNum <= 15);
313         require(coderNum.add(NNNum).add(otherNum) == 100);
314         coderAmount = coderNum;
315         NNAmount = NNNum;
316         otherAmount = otherNum;
317     }
318 
319     function changeLeastEth(uint256 num) public onlyOwner {
320         require(num > 0);
321         leastEth = num;
322     }
323 
324     function changeOfferSpan(uint256 num) public onlyOwner {
325         require(num > 0);
326         offerSpan = num;
327     }
328 
329     modifier onlyOwner(){
330         require(mappingContract.checkOwners(msg.sender) == true);
331         _;
332     }
333 }
334 
335 
336 /**
337  * @title Quotation contract
338  */
339 contract NEST_3_OfferContract {
340     using SafeMath for uint256;
341     using address_make_payable for address;
342     address owner;                              //  Owner
343     uint256 ethAmount;                          //  ETH amount
344     uint256 tokenAmount;                        //  Token amount
345     address tokenAddress;                       //  Token address
346     uint256 dealEthAmount;                      //  Transaction eth quantity
347     uint256 dealTokenAmount;                    //  Transaction token quantity
348     uint256 blockNum;                           //  This quotation block
349     uint256 serviceCharge;                      //  Service Charge
350     bool hadReceive = false;                    //  Received
351     NEST_2_Mapping mappingContract;             //  Mapping contract
352     NEST_3_OfferFactory offerFactory;           //  Quotation factory
353     
354     /**
355     * @dev initialization
356     * @param _ethAmount Offer ETH amount
357     * @param _tokenAmount Offer erc20 amount
358     * @param _tokenAddress Token address
359     * @param miningEth Service Charge
360     * @param map Mapping contract
361     */
362     constructor (uint256 _ethAmount, uint256 _tokenAmount, address _tokenAddress, uint256 miningEth,address map) public {
363         mappingContract = NEST_2_Mapping(address(map));
364         offerFactory = NEST_3_OfferFactory(address(mappingContract.checkAddress("offerFactory")));
365         require(msg.sender == address(offerFactory));
366         owner = address(tx.origin);
367         ethAmount = _ethAmount;
368         tokenAmount = _tokenAmount;
369         tokenAddress = _tokenAddress;
370         dealEthAmount = _ethAmount;
371         dealTokenAmount = _tokenAmount;
372         serviceCharge = miningEth;
373         blockNum = block.number;
374     }
375     
376     function offerAssets() public payable onlyFactory {
377         require(ERC20(tokenAddress).balanceOf(address(this)) >= tokenAmount);
378     }
379     
380     function changeOfferEth(uint256 _tokenAmount, address _tokenAddress) public payable onlyFactory {
381        require(checkContractState() == 0);
382        require(dealEthAmount >= msg.value);
383        require(dealTokenAmount >= _tokenAmount);
384        require(_tokenAddress == tokenAddress);
385        require(_tokenAmount == dealTokenAmount.mul(msg.value).div(dealEthAmount));
386        ERC20(tokenAddress).transfer(address(tx.origin), _tokenAmount);
387        dealEthAmount = dealEthAmount.sub(msg.value);
388        dealTokenAmount = dealTokenAmount.sub(_tokenAmount);
389     }
390     
391     function changeOfferErc(uint256 _ethAmount, uint256 _tokenAmount, address _tokenAddress) public onlyFactory {
392        require(checkContractState() == 0);
393        require(dealEthAmount >= _ethAmount);
394        require(dealTokenAmount >= _tokenAmount);
395        require(_tokenAddress == tokenAddress);
396        require(_tokenAmount == dealTokenAmount.mul(_ethAmount).div(dealEthAmount));
397        repayEth(address(tx.origin), _ethAmount);
398        dealEthAmount = dealEthAmount.sub(_ethAmount);
399        dealTokenAmount = dealTokenAmount.sub(_tokenAmount);
400     }
401    
402     function repayEth(address accountAddress, uint256 asset) private {
403         address payable addr = accountAddress.make_payable();
404         addr.transfer(asset);
405     }
406 
407     function turnOut() public onlyFactory {
408         require(address(tx.origin) == owner);
409         require(checkContractState() == 1);
410         require(hadReceive == false);
411         uint256 ethAssets;
412         uint256 tokenAssets;
413         (ethAssets, tokenAssets,) = checkAssets();
414         repayEth(owner, ethAssets);
415         ERC20(address(tokenAddress)).transfer(owner, tokenAssets);
416         hadReceive = true;
417     }
418     
419     function checkContractState() public view returns (uint256) {
420         if (block.number.sub(blockNum) > offerFactory.checkBlockLimit()) {
421             return 1;
422         }
423         return 0;
424     }
425 
426     function checkDealAmount() public view returns(uint256 leftEth, uint256 leftErc20, address erc20Address) {
427         return (dealEthAmount, dealTokenAmount, tokenAddress);
428     }
429 
430     function checkPrice() public view returns(uint256 _ethAmount, uint256 _tokenAmount, address _tokenAddress) {
431         return (ethAmount, tokenAmount, tokenAddress);
432     }
433 
434     function checkAssets() public view returns(uint256 _ethAmount, uint256 _tokenAmount, address _tokenAddress) {
435         return (address(this).balance, ERC20(address(tokenAddress)).balanceOf(address(this)), address(tokenAddress));
436     }
437 
438     function checkTokenAddress() public view returns(address){
439         return tokenAddress;
440     }
441 
442     function checkOwner() public view returns(address) {
443         return owner;
444     }
445 
446     function checkBlockNum() public view returns (uint256) {
447         return blockNum;
448     }
449 
450     function checkServiceCharge() public view returns(uint256) {
451         return serviceCharge;
452     }
453 
454     function checkHadReceive() public view returns(bool) {
455         return hadReceive;
456     }
457     
458     modifier onlyFactory(){
459         require(msg.sender == address(mappingContract.checkAddress("offerFactory")));
460         _;
461     }
462 }
463 
464 
465 /**
466  * @title Price contract
467  */
468 contract NEST_2_OfferPrice{
469     using SafeMath for uint256;
470     using address_make_payable for address;
471     NEST_2_Mapping mappingContract;                                 //  Mapping contract
472     NEST_3_OfferFactory offerFactory;                               //  Quotation factory contract
473     struct Price {                                                  //  Price structure
474         uint256 ethAmount;                                          //  ETH amount
475         uint256 erc20Amount;                                        //  erc20 amount
476         uint256 blockNum;                                           //  Last quotation block number, current price block
477     }
478     struct addressPrice {                                           //  Token price information structure
479         mapping(uint256 => Price) tokenPrice;                       //  Token price, Block number = > price
480         Price latestPrice;                                          //  Latest price
481     }
482     mapping(address => addressPrice) tokenInfo;                     //  Token price information
483     uint256 priceCost = 0.01 ether;                                 //  Price charge
484     uint256 priceCostUser = 2;                                      //  Price expense user proportion
485     uint256 priceCostAbonus = 8;                                    //  Proportion of price expense dividend pool
486     mapping(uint256 => mapping(address => address)) blockAddress;   //  Last person of block quotation
487     address abonusAddress;                                          //  Dividend pool
488     
489     //  Real time price toekn, ETH quantity, erc20 quantity
490     event nowTokenPrice(address a, uint256 b, uint256 c);
491 
492     /**
493     * @dev Initialization method
494     * @param map Mapping contract address
495     */
496     constructor (address map) public {
497         mappingContract = NEST_2_Mapping(address(map));
498         offerFactory = NEST_3_OfferFactory(address(mappingContract.checkAddress("offerFactory")));
499         abonusAddress = address(mappingContract.checkAddress("abonus"));
500     }
501     
502     /**
503     * @dev Initialization method
504     * @param map Mapping contract address
505     */
506     function changeMapping(address map) public onlyOwner {
507         mappingContract = NEST_2_Mapping(map);                                                      
508         offerFactory = NEST_3_OfferFactory(address(mappingContract.checkAddress("offerFactory")));
509         abonusAddress = address(mappingContract.checkAddress("abonus"));
510     }
511     
512     /**
513     * @dev Increase price
514     * @param _ethAmount ETH amount
515     * @param _tokenAmount Token amount
516     * @param _tokenAddress Token address
517     */
518     function addPrice(uint256 _ethAmount, uint256 _tokenAmount, address _tokenAddress) public onlyFactory {
519         uint256 blockLimit = offerFactory.checkBlockLimit();                                        
520         uint256 middleBlock = block.number.sub(blockLimit);                                         
521         
522         uint256 priceBlock = tokenInfo[_tokenAddress].latestPrice.blockNum;                         
523         while(priceBlock >= middleBlock || tokenInfo[_tokenAddress].tokenPrice[priceBlock].ethAmount == 0){                         
524             priceBlock = tokenInfo[_tokenAddress].tokenPrice[priceBlock].blockNum;
525             if (priceBlock == 0) {
526                 break;
527             }
528         }
529         tokenInfo[_tokenAddress].latestPrice.ethAmount = tokenInfo[_tokenAddress].tokenPrice[priceBlock].ethAmount;
530         tokenInfo[_tokenAddress].latestPrice.erc20Amount = tokenInfo[_tokenAddress].tokenPrice[priceBlock].erc20Amount;
531         tokenInfo[_tokenAddress].tokenPrice[block.number].ethAmount = tokenInfo[_tokenAddress].tokenPrice[block.number].ethAmount.add(_ethAmount);                  //  增加eth数
532         tokenInfo[_tokenAddress].tokenPrice[block.number].erc20Amount = tokenInfo[_tokenAddress].tokenPrice[block.number].erc20Amount.add(_tokenAmount);            //  增加ercrc20数
533         if (tokenInfo[_tokenAddress].latestPrice.blockNum != block.number) {
534             tokenInfo[_tokenAddress].tokenPrice[block.number].blockNum = tokenInfo[_tokenAddress].latestPrice.blockNum;                                                 //  记录上一次报价区块号
535             tokenInfo[_tokenAddress].latestPrice.blockNum = block.number;                                                                                               //  记录本次报价区块号
536         }
537 
538         blockAddress[block.number][_tokenAddress] = address(tx.origin);
539         
540         emit nowTokenPrice(_tokenAddress,tokenInfo[_tokenAddress].latestPrice.ethAmount, tokenInfo[_tokenAddress].latestPrice.erc20Amount);
541     }
542     
543     /**
544     * @dev Update price
545     * @param _tokenAddress Token address
546     * @return ethAmount ETH amount
547     * @return erc20Amount Token amount
548     * @return token Token address
549     */
550     function updateAndCheckPriceNow(address _tokenAddress) public payable returns(uint256 ethAmount, uint256 erc20Amount, address token) {
551         if (msg.sender != tx.origin && msg.sender != address(offerFactory)) {
552             require(msg.value == priceCost);
553         }
554         uint256 blockLimit = offerFactory.checkBlockLimit();                                       
555         uint256 middleBlock = block.number.sub(blockLimit);                                   
556         
557         uint256 priceBlock = tokenInfo[_tokenAddress].latestPrice.blockNum;                     
558         while(priceBlock >= middleBlock || tokenInfo[_tokenAddress].tokenPrice[priceBlock].ethAmount == 0){                         
559             priceBlock = tokenInfo[_tokenAddress].tokenPrice[priceBlock].blockNum;
560             if (priceBlock == 0) {
561                 break;
562             }
563         }
564         tokenInfo[_tokenAddress].latestPrice.ethAmount = tokenInfo[_tokenAddress].tokenPrice[priceBlock].ethAmount;
565         tokenInfo[_tokenAddress].latestPrice.erc20Amount = tokenInfo[_tokenAddress].tokenPrice[priceBlock].erc20Amount;
566         if (msg.value > 0) {
567             repayEth(abonusAddress, msg.value.mul(priceCostAbonus).div(10));
568             repayEth(blockAddress[priceBlock][_tokenAddress], msg.value.mul(priceCostUser).div(10));
569         }
570         return (tokenInfo[_tokenAddress].latestPrice.ethAmount,tokenInfo[_tokenAddress].latestPrice.erc20Amount, _tokenAddress);
571     }
572     
573     function repayEth(address accountAddress, uint256 asset) private {
574         address payable addr = accountAddress.make_payable();
575         addr.transfer(asset);
576     }
577     
578     /**
579     * @dev Change price
580     * @param _ethAmount ETH amount
581     * @param _tokenAmount Token amount
582     * @param _tokenAddress Token address
583     * @param blockNum Block number
584     */
585     function changePrice(uint256 _ethAmount, uint256 _tokenAmount, address _tokenAddress, uint256 blockNum) public onlyFactory {
586         tokenInfo[_tokenAddress].tokenPrice[blockNum].ethAmount = tokenInfo[_tokenAddress].tokenPrice[blockNum].ethAmount.sub(_ethAmount);
587         tokenInfo[_tokenAddress].tokenPrice[blockNum].erc20Amount = tokenInfo[_tokenAddress].tokenPrice[blockNum].erc20Amount.sub(_tokenAmount);
588     }
589     
590     function checkPriceForBlock(address tokenAddress, uint256 blockNum) public view returns (uint256 ethAmount, uint256 erc20Amount, uint256 frontBlock) {
591         require(msg.sender == tx.origin);
592         return (tokenInfo[tokenAddress].tokenPrice[blockNum].ethAmount, tokenInfo[tokenAddress].tokenPrice[blockNum].erc20Amount,tokenInfo[tokenAddress].tokenPrice[blockNum].blockNum);
593     }    
594 
595     function checkPriceNow(address tokenAddress) public view returns (uint256 ethAmount, uint256 erc20Amount,uint256 frontBlock) {
596         require(msg.sender == tx.origin);
597         return (tokenInfo[tokenAddress].latestPrice.ethAmount,tokenInfo[tokenAddress].latestPrice.erc20Amount,tokenInfo[tokenAddress].latestPrice.blockNum);
598     }
599 
600     function checkPriceHistoricalAverage(address tokenAddress, uint256 blockNum) public view returns (uint256) {
601         require(msg.sender == tx.origin);
602         uint256 blockLimit = offerFactory.checkBlockLimit();                                       
603         uint256 middleBlock = block.number.sub(blockLimit);                                         
604         uint256 priceBlock = tokenInfo[tokenAddress].latestPrice.blockNum;                         
605         while(priceBlock >= middleBlock){                         
606             priceBlock = tokenInfo[tokenAddress].tokenPrice[priceBlock].blockNum;
607             if (priceBlock == 0) {
608                 break;
609             }
610         }
611         uint256 frontBlock = priceBlock;
612         uint256 price = 0;
613         uint256 priceTimes = 0;
614         while(frontBlock >= blockNum){   
615             uint256 erc20Amount = tokenInfo[tokenAddress].tokenPrice[frontBlock].erc20Amount;
616             uint256 ethAmount = tokenInfo[tokenAddress].tokenPrice[frontBlock].ethAmount;
617             price = price.add(erc20Amount.mul(1 ether).div(ethAmount));
618             priceTimes = priceTimes.add(1);
619             frontBlock = tokenInfo[tokenAddress].tokenPrice[frontBlock].blockNum;
620             if (frontBlock == 0) {
621                 break;
622             }
623         }
624         return price.div(priceTimes);
625     }
626     
627     function checkPriceForBlockPay(address tokenAddress, uint256 blockNum) public payable returns (uint256 ethAmount, uint256 erc20Amount, uint256 frontBlock) {
628         require(msg.value == priceCost);
629         require(tokenInfo[tokenAddress].tokenPrice[blockNum].ethAmount != 0);
630         repayEth(abonusAddress, msg.value.mul(priceCostAbonus).div(10));
631         repayEth(blockAddress[blockNum][tokenAddress], msg.value.mul(priceCostUser).div(10));
632         return (tokenInfo[tokenAddress].tokenPrice[blockNum].ethAmount, tokenInfo[tokenAddress].tokenPrice[blockNum].erc20Amount,tokenInfo[tokenAddress].tokenPrice[blockNum].blockNum);
633     }
634     
635     function checkPriceHistoricalAveragePay(address tokenAddress, uint256 blockNum) public payable returns (uint256) {
636         require(msg.value == priceCost);
637         uint256 blockLimit = offerFactory.checkBlockLimit();                                        
638         uint256 middleBlock = block.number.sub(blockLimit);                                         
639         uint256 priceBlock = tokenInfo[tokenAddress].latestPrice.blockNum;                          
640         while(priceBlock >= middleBlock){                         
641             priceBlock = tokenInfo[tokenAddress].tokenPrice[priceBlock].blockNum;
642             if (priceBlock == 0) {
643                 break;
644             }
645         }
646         repayEth(abonusAddress, msg.value.mul(priceCostAbonus).div(10));
647         repayEth(blockAddress[priceBlock][tokenAddress], msg.value.mul(priceCostUser).div(10));
648         uint256 frontBlock = priceBlock;
649         uint256 price = 0;
650         uint256 priceTimes = 0;
651         while(frontBlock >= blockNum){   
652             uint256 erc20Amount = tokenInfo[tokenAddress].tokenPrice[frontBlock].erc20Amount;
653             uint256 ethAmount = tokenInfo[tokenAddress].tokenPrice[frontBlock].ethAmount;
654             price = price.add(erc20Amount.mul(1 ether).div(ethAmount));
655             priceTimes = priceTimes.add(1);
656             frontBlock = tokenInfo[tokenAddress].tokenPrice[frontBlock].blockNum;
657             if (frontBlock == 0) {
658                 break;
659             }
660         }
661         return price.div(priceTimes);
662     }
663 
664     
665     function checkLatestBlock(address token) public view returns(uint256) {
666         return tokenInfo[token].latestPrice.blockNum;
667     }
668     
669     function changePriceCost(uint256 amount) public onlyOwner {
670         require(amount > 0);
671         priceCost = amount;
672     }
673      
674     function checkPriceCost() public view returns(uint256) {
675         return priceCost;
676     }
677     
678     function changePriceCostProportion(uint256 user, uint256 abonus) public onlyOwner {
679         require(user.add(abonus) == 10);
680         priceCostUser = user;
681         priceCostAbonus = abonus;
682     }
683     
684     function checkPriceCostProportion() public view returns(uint256 user, uint256 abonus) {
685         return (priceCostUser, priceCostAbonus);
686     }
687     
688     modifier onlyFactory(){
689         require(msg.sender == address(mappingContract.checkAddress("offerFactory")));
690         _;
691     }
692     
693     modifier onlyOwner(){
694         require(mappingContract.checkOwners(msg.sender) == true);
695         _;
696     }
697 }
698 
699 contract NEST_NodeAssignment {
700     function bookKeeping(uint256 amount) public;
701 }
702 
703 contract NEST_3_OrePoolLogic {
704     function oreDrawing(address token) public payable;
705     function mining(uint256 amount, uint256 blockNum, address target, address token) public returns(uint256);
706 }
707 
708 contract NEST_2_Mapping {
709     function checkAddress(string memory name) public view returns (address contractAddress);
710     function checkOwners(address man) public view returns (bool);
711 }
712 
713 library address_make_payable {
714    function make_payable(address x) internal pure returns (address payable) {
715       return address(uint160(x));
716    }
717 }
718 
719 contract ERC20 {
720     function totalSupply() public view returns (uint supply);
721     function balanceOf( address who ) public view returns (uint value);
722     function allowance( address owner, address spender ) public view returns (uint _allowance);
723 
724     function transfer( address to, uint256 value) external;
725     function transferFrom( address from, address to, uint value) public;
726     function approve( address spender, uint value ) public returns (bool ok);
727 
728     event Transfer( address indexed from, address indexed to, uint value);
729     event Approval( address indexed owner, address indexed spender, uint value);
730 }
731 
732 /**
733  * @title SafeMath
734  * @dev Math operations with safety checks that revert on error
735  */
736 library SafeMath {
737     int256 constant private INT256_MIN = -2**255;
738 
739     /**
740     * @dev Multiplies two unsigned integers, reverts on overflow.
741     */
742     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
743         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
744         // benefit is lost if 'b' is also tested.
745         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
746         if (a == 0) {
747             return 0;
748         }
749 
750         uint256 c = a * b;
751         require(c / a == b);
752 
753         return c;
754     }
755 
756     /**
757     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
758     */
759     function div(uint256 a, uint256 b) internal pure returns (uint256) {
760         // Solidity only automatically asserts when dividing by 0
761         require(b > 0);
762         uint256 c = a / b;
763         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
764 
765         return c;
766     }
767 
768     /**
769     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
770     */
771     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
772         require(b <= a);
773         uint256 c = a - b;
774 
775         return c;
776     }
777 
778     /**
779     * @dev Adds two unsigned integers, reverts on overflow.
780     */
781     function add(uint256 a, uint256 b) internal pure returns (uint256) {
782         uint256 c = a + b;
783         require(c >= a);
784 
785         return c;
786     }
787 
788     /**
789     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
790     * reverts when dividing by zero.
791     */
792     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
793         require(b != 0);
794         return a % b;
795     }
796 }