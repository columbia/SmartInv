1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-11
3 */
4 
5 pragma solidity 0.6.0;
6 
7 /**
8  * @title Offering contract
9  * @dev Offering logic and mining logic
10  */
11 contract Nest_NToken_OfferMain {
12     
13     using SafeMath for uint256;
14     using address_make_payable for address;
15     using SafeERC20 for ERC20;
16     
17     // Offering data structure
18     struct Nest_NToken_OfferPriceData {
19         // The unique identifier is determined by the position of the offer in the array, and is converted to each other through a fixed algorithm (toindex(), toaddress())
20         address owner;                                  //  Offering owner
21         bool deviate;                                   //  Whether it deviates 
22         address tokenAddress;                           //  The erc20 contract address of the target offer token
23         
24         uint256 ethAmount;                              //  The ETH amount in the offer list
25         uint256 tokenAmount;                            //  The token amount in the offer list
26         
27         uint256 dealEthAmount;                          //  The remaining number of tradable ETH
28         uint256 dealTokenAmount;                        //  The remaining number of tradable tokens
29         
30         uint256 blockNum;                               //  The block number where the offer is located
31         uint256 serviceCharge;                          //  The fee for mining
32         // Determine whether the asset has been collected by judging that ethamount, tokenamount, and servicecharge are all 0
33     }
34     
35     Nest_NToken_OfferPriceData [] _prices;                              //  Array used to save offers
36     Nest_3_VoteFactory _voteFactory;                                    //  Voting contract
37     Nest_3_OfferPrice _offerPrice;                                      //  Price contract
38     Nest_NToken_TokenMapping _tokenMapping;                             //  NToken mapping contract
39     ERC20 _nestToken;                                                   //  nestToken
40     Nest_3_Abonus _abonus;                                              //  Bonus pool
41     uint256 _miningETH = 10;                                            //  Offering mining fee ratio
42     uint256 _tranEth = 1;                                               //  Taker fee ratio
43     uint256 _tranAddition = 2;                                          //  Additional transaction multiple
44     uint256 _leastEth = 10 ether;                                       //  Minimum offer of ETH
45     uint256 _offerSpan = 10 ether;                                      //  ETH Offering span
46     uint256 _deviate = 10;                                              //  Price deviation - 10%
47     uint256 _deviationFromScale = 10;                                   //  Deviation from asset scale
48     uint256 _ownerMining = 5;                                           //  Creator ratio
49     uint256 _afterMiningAmount = 0.4 ether;                             //  Stable period mining amount
50     uint32 _blockLimit = 25;                                            //  Block interval upper limit
51     
52     uint256 _blockAttenuation = 2400000;                                //  Block decay interval
53     mapping(uint256 => mapping(address => uint256)) _blockOfferAmount;  //  Block offer times - block number=>token address=>offer fee
54     mapping(uint256 => mapping(address => uint256)) _blockMining;       //  Offering block mining amount - block number=>token address=>mining amount
55     uint256[10] _attenuationAmount;                                     //  Mining decay list
56     
57     //  Log token contract address
58     event OfferTokenContractAddress(address contractAddress);           
59     //  Log offering contract, token address, amount of ETH, amount of ERC20, delayed block, mining fee
60     event OfferContractAddress(address contractAddress, address tokenAddress, uint256 ethAmount, uint256 erc20Amount, uint256 continued,uint256 mining);         
61     //  Log transaction sender, transaction token, transaction amount, purchase token address, purchase token amount, transaction offering contract address, transaction user address
62     event OfferTran(address tranSender, address tranToken, uint256 tranAmount,address otherToken, uint256 otherAmount, address tradedContract, address tradedOwner);        
63     //  Log current block, current block mined amount, token address
64     event OreDrawingLog(uint256 nowBlock, uint256 blockAmount, address tokenAddress);
65     //  Log offering block, token address, token offered times
66     event MiningLog(uint256 blockNum, address tokenAddress, uint256 offerTimes);
67     
68     /**
69      * Initialization method
70      * @param voteFactory Voting contract address
71      **/
72     constructor (address voteFactory) public {
73         Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
74         _voteFactory = voteFactoryMap;                                                                 
75         _offerPrice = Nest_3_OfferPrice(address(voteFactoryMap.checkAddress("nest.v3.offerPrice")));            
76         _nestToken = ERC20(voteFactoryMap.checkAddress("nest"));                                                          
77         _abonus = Nest_3_Abonus(voteFactoryMap.checkAddress("nest.v3.abonus"));
78         _tokenMapping = Nest_NToken_TokenMapping(address(voteFactoryMap.checkAddress("nest.nToken.tokenMapping")));
79         
80         uint256 blockAmount = 4 ether;
81         for (uint256 i = 0; i < 10; i ++) {
82             _attenuationAmount[i] = blockAmount;
83             blockAmount = blockAmount.mul(8).div(10);
84         }
85     }
86     
87     /**
88      * Reset voting contract method
89      * @param voteFactory Voting contract address
90      **/
91     function changeMapping(address voteFactory) public onlyOwner {
92         Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
93         _voteFactory = voteFactoryMap;                                                          
94         _offerPrice = Nest_3_OfferPrice(address(voteFactoryMap.checkAddress("nest.v3.offerPrice")));      
95         _nestToken = ERC20(voteFactoryMap.checkAddress("nest"));                                                   
96         _abonus = Nest_3_Abonus(voteFactoryMap.checkAddress("nest.v3.abonus"));
97         _tokenMapping = Nest_NToken_TokenMapping(address(voteFactoryMap.checkAddress("nest.nToken.tokenMapping")));
98     }
99     
100     /**
101      * Offering method
102      * @param ethAmount ETH amount
103      * @param erc20Amount Erc20 token amount
104      * @param erc20Address Erc20 token address
105      **/
106     function offer(uint256 ethAmount, uint256 erc20Amount, address erc20Address) public payable {
107         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
108         address nTokenAddress = _tokenMapping.checkTokenMapping(erc20Address);
109         require(nTokenAddress != address(0x0));
110         //  Judge whether the price deviates
111         uint256 ethMining;
112         bool isDeviate = comparativePrice(ethAmount,erc20Amount,erc20Address);
113         if (isDeviate) {
114             require(ethAmount >= _leastEth.mul(_deviationFromScale), "EthAmount needs to be no less than 10 times of the minimum scale");
115             ethMining = _leastEth.mul(_miningETH).div(1000);
116         } else {
117             ethMining = ethAmount.mul(_miningETH).div(1000);
118         }
119         require(msg.value >= ethAmount.add(ethMining), "msg.value needs to be equal to the quoted eth quantity plus Mining handling fee");
120         uint256 subValue = msg.value.sub(ethAmount.add(ethMining));
121         if (subValue > 0) {
122             repayEth(address(msg.sender), subValue);
123         }
124         //  Create an offer
125         createOffer(ethAmount, erc20Amount, erc20Address,isDeviate, ethMining);
126         //  Transfer in offer asset - erc20 to this contract
127         ERC20(erc20Address).safeTransferFrom(address(msg.sender), address(this), erc20Amount);
128         _abonus.switchToEthForNTokenOffer.value(ethMining)(nTokenAddress);
129         //  Mining
130         if (_blockOfferAmount[block.number][erc20Address] == 0) {
131             uint256 miningAmount = oreDrawing(nTokenAddress);
132             Nest_NToken nToken = Nest_NToken(nTokenAddress);
133             nToken.transfer(nToken.checkBidder(), miningAmount.mul(_ownerMining).div(100));
134             _blockMining[block.number][erc20Address] = miningAmount.sub(miningAmount.mul(_ownerMining).div(100));
135         }
136         _blockOfferAmount[block.number][erc20Address] = _blockOfferAmount[block.number][erc20Address].add(ethMining);
137     }
138     
139     /**
140      * @dev Create offer
141      * @param ethAmount Offering ETH amount
142      * @param erc20Amount Offering erc20 amount
143      * @param erc20Address Offering erc20 address
144      **/
145     function createOffer(uint256 ethAmount, uint256 erc20Amount, address erc20Address, bool isDeviate, uint256 mining) private {
146         // Check offer conditions
147         require(ethAmount >= _leastEth, "Eth scale is smaller than the minimum scale");                                                 
148         require(ethAmount % _offerSpan == 0, "Non compliant asset span");
149         require(erc20Amount % (ethAmount.div(_offerSpan)) == 0, "Asset quantity is not divided");
150         require(erc20Amount > 0);
151         // Create offering contract
152         emit OfferContractAddress(toAddress(_prices.length), address(erc20Address), ethAmount, erc20Amount,_blockLimit,mining);
153         _prices.push(Nest_NToken_OfferPriceData(
154             msg.sender,
155             isDeviate,
156             erc20Address,
157             
158             ethAmount,
159             erc20Amount,
160             
161             ethAmount, 
162             erc20Amount, 
163             
164             block.number,
165             mining
166         ));
167         // Record price
168         _offerPrice.addPrice(ethAmount, erc20Amount, block.number.add(_blockLimit), erc20Address, address(msg.sender));
169     }
170     
171     // Convert offer address into index in offer array
172     function toIndex(address contractAddress) public pure returns(uint256) {
173         return uint256(contractAddress);
174     }
175     
176     // Convert index in offer array into offer address 
177     function toAddress(uint256 index) public pure returns(address) {
178         return address(index);
179     }
180     
181     /**
182      * Withdraw offer assets
183      * @param contractAddress Offer address
184      **/
185     function turnOut(address contractAddress) public {
186         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
187         uint256 index = toIndex(contractAddress);
188         Nest_NToken_OfferPriceData storage offerPriceData = _prices[index];
189         require(checkContractState(offerPriceData.blockNum) == 1, "Offer status error");
190         // Withdraw ETH
191         if (offerPriceData.ethAmount > 0) {
192             uint256 payEth = offerPriceData.ethAmount;
193             offerPriceData.ethAmount = 0;
194             repayEth(offerPriceData.owner, payEth);
195         }
196         // Withdraw erc20
197         if (offerPriceData.tokenAmount > 0) {
198             uint256 payErc = offerPriceData.tokenAmount;
199             offerPriceData.tokenAmount = 0;
200             ERC20(address(offerPriceData.tokenAddress)).safeTransfer(address(offerPriceData.owner), payErc);
201             
202         }
203         // Mining settlement
204         if (offerPriceData.serviceCharge > 0) {
205             mining(offerPriceData.blockNum, offerPriceData.tokenAddress, offerPriceData.serviceCharge, offerPriceData.owner);
206             offerPriceData.serviceCharge = 0;
207         }
208     }
209     
210     /**
211     * @dev Taker order - pay ETH and buy erc20
212     * @param ethAmount The amount of ETH of this offer
213     * @param tokenAmount The amount of erc20 of this offer
214     * @param contractAddress The target offer address
215     * @param tranEthAmount The amount of ETH of taker order
216     * @param tranTokenAmount The amount of erc20 of taker order
217     * @param tranTokenAddress The erc20 address of taker order
218     */
219     function sendEthBuyErc(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {
220         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
221         uint256 serviceCharge = tranEthAmount.mul(_tranEth).div(1000);
222         require(msg.value == ethAmount.add(tranEthAmount).add(serviceCharge), "msg.value needs to be equal to the quotation eth quantity plus transaction eth plus");
223         require(tranEthAmount % _offerSpan == 0, "Transaction size does not meet asset span");
224         
225         //  Get the offer data structure
226         uint256 index = toIndex(contractAddress);
227         Nest_NToken_OfferPriceData memory offerPriceData = _prices[index]; 
228         //  Check the price, compare the current offer to the last effective price
229         bool thisDeviate = comparativePrice(ethAmount,tokenAmount,tranTokenAddress);
230         bool isDeviate;
231         if (offerPriceData.deviate == true) {
232             isDeviate = true;
233         } else {
234             isDeviate = thisDeviate;
235         }
236         //  Limit the taker order only be twice the amount of the offer to prevent large-amount attacks
237         if (offerPriceData.deviate) {
238             //  The taker order deviates  x2
239             require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
240         } else {
241             if (isDeviate) {
242                 //  If the taken offer is normal and the taker order deviates x10
243                 require(ethAmount >= tranEthAmount.mul(_deviationFromScale), "EthAmount needs to be no less than 10 times of transaction scale");
244             } else {
245                 //  If the taken offer is normal and the taker order is normal x2
246                 require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
247             }
248         }
249         
250         // Check whether the conditions for taker order are satisfied
251         require(checkContractState(offerPriceData.blockNum) == 0, "Offer status error");
252         require(offerPriceData.dealEthAmount >= tranEthAmount, "Insufficient trading eth");
253         require(offerPriceData.dealTokenAmount >= tranTokenAmount, "Insufficient trading token");
254         require(offerPriceData.tokenAddress == tranTokenAddress, "Wrong token address");
255         require(tranTokenAmount == offerPriceData.dealTokenAmount * tranEthAmount / offerPriceData.dealEthAmount, "Wrong token amount");
256         
257         // Update the offer information
258         offerPriceData.ethAmount = offerPriceData.ethAmount.add(tranEthAmount);
259         offerPriceData.tokenAmount = offerPriceData.tokenAmount.sub(tranTokenAmount);
260         offerPriceData.dealEthAmount = offerPriceData.dealEthAmount.sub(tranEthAmount);
261         offerPriceData.dealTokenAmount = offerPriceData.dealTokenAmount.sub(tranTokenAmount);
262         _prices[index] = offerPriceData;
263         // Create a new offer
264         createOffer(ethAmount, tokenAmount, tranTokenAddress, isDeviate, 0);
265         // Transfer in erc20 + offer asset to this contract
266         if (tokenAmount > tranTokenAmount) {
267             ERC20(tranTokenAddress).safeTransferFrom(address(msg.sender), address(this), tokenAmount.sub(tranTokenAmount));
268         } else {
269             ERC20(tranTokenAddress).safeTransfer(address(msg.sender), tranTokenAmount.sub(tokenAmount));
270         }
271 
272         // Modify price
273         _offerPrice.changePrice(tranEthAmount, tranTokenAmount, tranTokenAddress, offerPriceData.blockNum.add(_blockLimit));
274         emit OfferTran(address(msg.sender), address(0x0), tranEthAmount, address(tranTokenAddress), tranTokenAmount, contractAddress, offerPriceData.owner);
275         
276         // Transfer fee
277         if (serviceCharge > 0) {
278             address nTokenAddress = _tokenMapping.checkTokenMapping(tranTokenAddress);
279             _abonus.switchToEth.value(serviceCharge)(nTokenAddress);
280         }
281     }
282     
283     /**
284     * @dev Taker order - pay erc20 and buy ETH
285     * @param ethAmount The amount of ETH of this offer
286     * @param tokenAmount The amount of erc20 of this offer
287     * @param contractAddress The target offer address
288     * @param tranEthAmount The amount of ETH of taker order
289     * @param tranTokenAmount The amount of erc20 of taker order
290     * @param tranTokenAddress The erc20 address of taker order
291     */
292     function sendErcBuyEth(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {
293         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
294         uint256 serviceCharge = tranEthAmount.mul(_tranEth).div(1000);
295         require(msg.value == ethAmount.sub(tranEthAmount).add(serviceCharge), "msg.value needs to be equal to the quoted eth quantity plus transaction handling fee");
296         require(tranEthAmount % _offerSpan == 0, "Transaction size does not meet asset span");
297         //  Get the offer data structure
298         uint256 index = toIndex(contractAddress);
299         Nest_NToken_OfferPriceData memory offerPriceData = _prices[index]; 
300         //  Check the price, compare the current offer to the last effective price
301         bool thisDeviate = comparativePrice(ethAmount,tokenAmount,tranTokenAddress);
302         bool isDeviate;
303         if (offerPriceData.deviate == true) {
304             isDeviate = true;
305         } else {
306             isDeviate = thisDeviate;
307         }
308         //  Limit the taker order only be twice the amount of the offer to prevent large-amount attacks
309         if (offerPriceData.deviate) {
310             //  The taker order deviates  x2
311             require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
312         } else {
313             if (isDeviate) {
314                 //  If the taken offer is normal and the taker order deviates x10
315                 require(ethAmount >= tranEthAmount.mul(_deviationFromScale), "EthAmount needs to be no less than 10 times of transaction scale");
316             } else {
317                 //  If the taken offer is normal and the taker order is normal x2
318                 require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
319             }
320         }
321         // Check whether the conditions for taker order are satisfied
322         require(checkContractState(offerPriceData.blockNum) == 0, "Offer status error");
323         require(offerPriceData.dealEthAmount >= tranEthAmount, "Insufficient trading eth");
324         require(offerPriceData.dealTokenAmount >= tranTokenAmount, "Insufficient trading token");
325         require(offerPriceData.tokenAddress == tranTokenAddress, "Wrong token address");
326         require(tranTokenAmount == offerPriceData.dealTokenAmount * tranEthAmount / offerPriceData.dealEthAmount, "Wrong token amount");
327         // Update the offer information
328         offerPriceData.ethAmount = offerPriceData.ethAmount.sub(tranEthAmount);
329         offerPriceData.tokenAmount = offerPriceData.tokenAmount.add(tranTokenAmount);
330         offerPriceData.dealEthAmount = offerPriceData.dealEthAmount.sub(tranEthAmount);
331         offerPriceData.dealTokenAmount = offerPriceData.dealTokenAmount.sub(tranTokenAmount);
332         _prices[index] = offerPriceData;
333         // Create a new offer
334         createOffer(ethAmount, tokenAmount, tranTokenAddress, isDeviate, 0);
335         // Transfer in erc20 + offer asset to this contract
336         ERC20(tranTokenAddress).safeTransferFrom(address(msg.sender), address(this), tranTokenAmount.add(tokenAmount));
337         // Modify price
338         _offerPrice.changePrice(tranEthAmount, tranTokenAmount, tranTokenAddress, offerPriceData.blockNum.add(_blockLimit));
339         emit OfferTran(address(msg.sender), address(tranTokenAddress), tranTokenAmount, address(0x0), tranEthAmount, contractAddress, offerPriceData.owner);
340         // Transfer fee
341         if (serviceCharge > 0) {
342             address nTokenAddress = _tokenMapping.checkTokenMapping(tranTokenAddress);
343             _abonus.switchToEth.value(serviceCharge)(nTokenAddress);
344         }
345     }
346     
347     /**
348      * Offering mining
349      * @param ntoken NToken address
350      **/
351     function oreDrawing(address ntoken) private returns(uint256) {
352         Nest_NToken miningToken = Nest_NToken(ntoken);
353         (uint256 createBlock, uint256 recentlyUsedBlock) = miningToken.checkBlockInfo();
354         uint256 attenuationPointNow = block.number.sub(createBlock).div(_blockAttenuation);
355         uint256 miningAmount = 0;
356         uint256 attenuation;
357         if (attenuationPointNow > 9) {
358             attenuation = _afterMiningAmount;
359         } else {
360             attenuation = _attenuationAmount[attenuationPointNow];
361         }
362         miningAmount = attenuation.mul(block.number.sub(recentlyUsedBlock));
363         miningToken.increaseTotal(miningAmount);
364         emit OreDrawingLog(block.number, miningAmount, ntoken);
365         return miningAmount;
366     }
367     
368     /**
369      * Retrieve mining
370      * @param token Token address
371      **/
372     function mining(uint256 blockNum, address token, uint256 serviceCharge, address owner) private returns(uint256) {
373         //  Block mining amount*offer fee/block offer fee
374         uint256 miningAmount = _blockMining[blockNum][token].mul(serviceCharge).div(_blockOfferAmount[blockNum][token]);        
375         //  Transfer NToken 
376         Nest_NToken nToken = Nest_NToken(address(_tokenMapping.checkTokenMapping(token)));
377         require(nToken.transfer(address(owner), miningAmount), "Transfer failure");
378         
379         emit MiningLog(blockNum, token,_blockOfferAmount[blockNum][token]);
380         return miningAmount;
381     }
382     
383     // Compare order prices
384     function comparativePrice(uint256 myEthValue, uint256 myTokenValue, address token) private view returns(bool) {
385         (uint256 frontEthValue, uint256 frontTokenValue) = _offerPrice.updateAndCheckPricePrivate(token);
386         if (frontEthValue == 0 || frontTokenValue == 0) {
387             return false;
388         }
389         uint256 maxTokenAmount = myEthValue.mul(frontTokenValue).mul(uint256(100).add(_deviate)).div(frontEthValue.mul(100));
390         if (myTokenValue <= maxTokenAmount) {
391             uint256 minTokenAmount = myEthValue.mul(frontTokenValue).mul(uint256(100).sub(_deviate)).div(frontEthValue.mul(100));
392             if (myTokenValue >= minTokenAmount) {
393                 return false;
394             }
395         }
396         return true;
397     }
398     
399     // Check contract status
400     function checkContractState(uint256 createBlock) public view returns (uint256) {
401         if (block.number.sub(createBlock) > _blockLimit) {
402             return 1;
403         }
404         return 0;
405     }
406     
407     // Transfer ETH
408     function repayEth(address accountAddress, uint256 asset) private {
409         address payable addr = accountAddress.make_payable();
410         addr.transfer(asset);
411     }
412     
413     // View the upper limit of the block interval
414     function checkBlockLimit() public view returns(uint256) {
415         return _blockLimit;
416     }
417     
418     // View taker fee ratio
419     function checkTranEth() public view returns (uint256) {
420         return _tranEth;
421     }
422     
423     // View additional transaction multiple
424     function checkTranAddition() public view returns(uint256) {
425         return _tranAddition;
426     }
427     
428     // View minimum offering ETH
429     function checkleastEth() public view returns(uint256) {
430         return _leastEth;
431     }
432     
433     // View offering ETH span
434     function checkOfferSpan() public view returns(uint256) {
435         return _offerSpan;
436     }
437 
438     // View block offering amount
439     function checkBlockOfferAmount(uint256 blockNum, address token) public view returns (uint256) {
440         return _blockOfferAmount[blockNum][token];
441     }
442     
443     // View offering block mining amount
444     function checkBlockMining(uint256 blockNum, address token) public view returns (uint256) {
445         return _blockMining[blockNum][token];
446     }
447     
448     // View offering mining amount
449     function checkOfferMining(uint256 blockNum, address token, uint256 serviceCharge) public view returns (uint256) {
450         if (serviceCharge == 0) {
451             return 0;
452         } else {
453             return _blockMining[blockNum][token].mul(serviceCharge).div(_blockOfferAmount[blockNum][token]);
454         }
455     }
456     
457     //  View the owner allocation ratio
458     function checkOwnerMining() public view returns(uint256) {
459         return _ownerMining;
460     }
461     
462     // View the mining decay
463     function checkAttenuationAmount(uint256 num) public view returns(uint256) {
464         return _attenuationAmount[num];
465     }
466     
467     // Modify taker order fee ratio
468     function changeTranEth(uint256 num) public onlyOwner {
469         _tranEth = num;
470     }
471     
472     // Modify block interval upper limit
473     function changeBlockLimit(uint32 num) public onlyOwner {
474         _blockLimit = num;
475     }
476     
477     // Modify additional transaction multiple
478     function changeTranAddition(uint256 num) public onlyOwner {
479         require(num > 0, "Parameter needs to be greater than 0");
480         _tranAddition = num;
481     }
482     
483     // Modify minimum offering ETH
484     function changeLeastEth(uint256 num) public onlyOwner {
485         require(num > 0, "Parameter needs to be greater than 0");
486         _leastEth = num;
487     }
488     
489     // Modify offering ETH span
490     function changeOfferSpan(uint256 num) public onlyOwner {
491         require(num > 0, "Parameter needs to be greater than 0");
492         _offerSpan = num;
493     }
494     
495     // Modify price deviation
496     function changekDeviate(uint256 num) public onlyOwner {
497         _deviate = num;
498     }
499     
500     // Modify the deviation from scale 
501     function changeDeviationFromScale(uint256 num) public onlyOwner {
502         _deviationFromScale = num;
503     }
504     
505     // Modify the owner allocation ratio
506     function changeOwnerMining(uint256 num) public onlyOwner {
507         _ownerMining = num;
508     }
509     
510     // Modify the mining decay
511     function changeAttenuationAmount(uint256 firstAmount, uint256 top, uint256 bottom) public onlyOwner {
512         uint256 blockAmount = firstAmount;
513         for (uint256 i = 0; i < 10; i ++) {
514             _attenuationAmount[i] = blockAmount;
515             blockAmount = blockAmount.mul(top).div(bottom);
516         }
517     }
518     
519     // Vote administrators only
520     modifier onlyOwner(){
521         require(_voteFactory.checkOwners(msg.sender), "No authority");
522         _;
523     }
524     
525     /**
526      * Get the number of offers stored in the offer array
527      * @return The number of offers stored in the offer array
528      **/
529     function getPriceCount() view public returns (uint256) {
530         return _prices.length;
531     }
532     
533     /**
534      * Get offer information according to the index
535      * @param priceIndex Offer index
536      * @return Offer information
537      **/
538     function getPrice(uint256 priceIndex) view public returns (string memory) {
539         //  The buffer array used to generate the result string
540         bytes memory buf = new bytes(500000);
541         uint256 index = 0;
542         index = writeOfferPriceData(priceIndex, _prices[priceIndex], buf, index);
543         // Generate the result string and return
544         bytes memory str = new bytes(index);
545         while(index-- > 0) {
546             str[index] = buf[index];
547         }
548         return string(str);
549     }
550     
551     /**
552      * Search the contract address list of the target account (reverse order)
553      * @param start Search forward from the index corresponding to the given contract address (not including the record corresponding to start address)
554      * @param count Maximum number of records to return
555      * @param maxFindCount The max index to search
556      * @param owner Target account address
557      * @return Separate the offer records with symbols. use , to divide fields:  
558      * uuid,owner,tokenAddress,ethAmount,tokenAmount,dealEthAmount,dealTokenAmount,blockNum,serviceCharge
559      **/
560     function find(address start, uint256 count, uint256 maxFindCount, address owner) view public returns (string memory) {
561         // Buffer array used to generate result string
562         bytes memory buf = new bytes(500000);
563         uint256 index = 0;
564         // Calculate search interval i and end
565         uint256 i = _prices.length;
566         uint256 end = 0;
567         if (start != address(0)) {
568             i = toIndex(start);
569         }
570         if (i > maxFindCount) {
571             end = i - maxFindCount;
572         }
573         // Loop search, write qualified records into buffer
574         while (count > 0 && i-- > end) {
575             Nest_NToken_OfferPriceData memory price = _prices[i];
576             if (price.owner == owner) {
577                 --count;
578                 index = writeOfferPriceData(i, price, buf, index);
579             }
580         }
581         // Generate result string and return
582         bytes memory str = new bytes(index);
583         while(index-- > 0) {
584             str[index] = buf[index];
585         }
586         return string(str);
587     }
588     
589     /**
590      * Get the list of offers by page
591      * @param offset Skip the first offset records
592      * @param count Maximum number of records to return
593      * @param order Sort rules. 0 means reverse order, non-zero means positive order
594      * @return Separate the offer records with symbols. use , to divide fields: 
595      * uuid,owner,tokenAddress,ethAmount,tokenAmount,dealEthAmount,dealTokenAmount,blockNum,serviceCharge
596      **/
597     function list(uint256 offset, uint256 count, uint256 order) view public returns (string memory) {
598         
599         // Buffer array used to generate result string 
600         bytes memory buf = new bytes(500000);
601         uint256 index = 0;
602         
603         // Find search interval i and end
604         uint256 i = 0;
605         uint256 end = 0;
606         
607         if (order == 0) {
608             // Reverse order, in default 
609             // Calculate search interval i and end
610             if (offset < _prices.length) {
611                 i = _prices.length - offset;
612             } 
613             if (count < i) {
614                 end = i - count;
615             }
616             
617             // Write records in the target interval into the buffer
618             while (i-- > end) {
619                 index = writeOfferPriceData(i, _prices[i], buf, index);
620             }
621         } else {
622             // Ascending order
623             // Calculate the search interval i and end
624             if (offset < _prices.length) {
625                 i = offset;
626             } else {
627                 i = _prices.length;
628             }
629             end = i + count;
630             if(end > _prices.length) {
631                 end = _prices.length;
632             }
633             
634             // Write the records in the target interval into the buffer
635             while (i < end) {
636                 index = writeOfferPriceData(i, _prices[i], buf, index);
637                 ++i;
638             }
639         }
640         
641         // Generate the result string and return
642         bytes memory str = new bytes(index);
643         while(index-- > 0) {
644             str[index] = buf[index];
645         }
646         return string(str);
647     }   
648      
649     // Write the offer data into the buffer and return the buffer index
650     function writeOfferPriceData(uint256 priceIndex, Nest_NToken_OfferPriceData memory price, bytes memory buf, uint256 index) pure private returns (uint256) {
651         
652         index = writeAddress(toAddress(priceIndex), buf, index);
653         buf[index++] = byte(uint8(44));
654         
655         index = writeAddress(price.owner, buf, index);
656         buf[index++] = byte(uint8(44));
657         
658         index = writeAddress(price.tokenAddress, buf, index);
659         buf[index++] = byte(uint8(44));
660         
661         index = writeUInt(price.ethAmount, buf, index);
662         buf[index++] = byte(uint8(44));
663         
664         index = writeUInt(price.tokenAmount, buf, index);
665         buf[index++] = byte(uint8(44));
666        
667         index = writeUInt(price.dealEthAmount, buf, index);
668         buf[index++] = byte(uint8(44));
669         
670         index = writeUInt(price.dealTokenAmount, buf, index);
671         buf[index++] = byte(uint8(44));
672         
673         index = writeUInt(price.blockNum, buf, index);
674         buf[index++] = byte(uint8(44));
675         
676         index = writeUInt(price.serviceCharge, buf, index);
677         buf[index++] = byte(uint8(44));
678         
679         return index;
680     }
681      
682     // Convert integer to string in decimal form, write the string into the buffer, and return the buffer index
683     function writeUInt(uint256 iv, bytes memory buf, uint256 index) pure public returns (uint256) {
684         uint256 i = index;
685         do {
686             buf[index++] = byte(uint8(iv % 10 +48));
687             iv /= 10;
688         } while (iv > 0);
689         
690         for (uint256 j = index; j > i; ++i) {
691             byte t = buf[i];
692             buf[i] = buf[--j];
693             buf[j] = t;
694         }
695         
696         return index;
697     }
698 
699     // Convert the address to a hexadecimal string and write it into the buffer, and return the buffer index
700     function writeAddress(address addr, bytes memory buf, uint256 index) pure private returns (uint256) {
701         
702         uint256 iv = uint256(addr);
703         uint256 i = index + 40;
704         do {
705             uint256 w = iv % 16;
706             if(w < 10) {
707                 buf[index++] = byte(uint8(w +48));
708             } else {
709                 buf[index++] = byte(uint8(w +87));
710             }
711             
712             iv /= 16;
713         } while (index < i);
714         
715         i -= 40;
716         for (uint256 j = index; j > i; ++i) {
717             byte t = buf[i];
718             buf[i] = buf[--j];
719             buf[j] = t;
720         }
721         
722         return index;
723     }
724 }
725 
726 // Price contract
727 interface Nest_3_OfferPrice {
728     // Add price data
729     function addPrice(uint256 ethAmount, uint256 tokenAmount, uint256 endBlock, address tokenAddress, address offerOwner) external;
730     // Modify price
731     function changePrice(uint256 ethAmount, uint256 tokenAmount, address tokenAddress, uint256 endBlock) external;
732     function updateAndCheckPricePrivate(address tokenAddress) external view returns(uint256 ethAmount, uint256 erc20Amount);
733 }
734 
735 // Voting contract
736 interface Nest_3_VoteFactory {
737     //  Check address
738 	function checkAddress(string calldata name) external view returns (address contractAddress);
739 	// Check whether an administrator
740 	function checkOwners(address man) external view returns (bool);
741 }
742 
743 // NToken contract
744 interface Nest_NToken {
745     // Additional issuance
746     function increaseTotal(uint256 value) external;
747     // Check mining information
748     function checkBlockInfo() external view returns(uint256 createBlock, uint256 recentlyUsedBlock);
749     // Check creator
750     function checkBidder() external view returns(address);
751     function totalSupply() external view returns (uint256);
752     function balanceOf(address account) external view returns (uint256);
753     function transfer(address recipient, uint256 amount) external returns (bool);
754     function allowance(address owner, address spender) external view returns (uint256);
755     function approve(address spender, uint256 amount) external returns (bool);
756     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
757     event Transfer(address indexed from, address indexed to, uint256 value);
758     event Approval(address indexed owner, address indexed spender, uint256 value);
759 }
760 
761 // NToken mapping contract
762 interface Nest_NToken_TokenMapping {
763     // Check token mapping
764     function checkTokenMapping(address token) external view returns (address);
765 }
766 
767 // Bonus pool contract
768 interface Nest_3_Abonus {
769     function switchToEth(address token) external payable;
770     function switchToEthForNTokenOffer(address token) external payable;
771 }
772 
773 library SafeMath {
774     function add(uint256 a, uint256 b) internal pure returns (uint256) {
775         uint256 c = a + b;
776         require(c >= a, "SafeMath: addition overflow");
777 
778         return c;
779     }
780     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
781         return sub(a, b, "SafeMath: subtraction overflow");
782     }
783     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
784         require(b <= a, errorMessage);
785         uint256 c = a - b;
786 
787         return c;
788     }
789     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
790         if (a == 0) {
791             return 0;
792         }
793         uint256 c = a * b;
794         require(c / a == b, "SafeMath: multiplication overflow");
795 
796         return c;
797     }
798     function div(uint256 a, uint256 b) internal pure returns (uint256) {
799         return div(a, b, "SafeMath: division by zero");
800     }
801     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
802         require(b > 0, errorMessage);
803         uint256 c = a / b;
804         return c;
805     }
806     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
807         return mod(a, b, "SafeMath: modulo by zero");
808     }
809     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
810         require(b != 0, errorMessage);
811         return a % b;
812     }
813 }
814 
815 library address_make_payable {
816    function make_payable(address x) internal pure returns (address payable) {
817       return address(uint160(x));
818    }
819 }
820 
821 library SafeERC20 {
822     using SafeMath for uint256;
823     using Address for address;
824 
825     function safeTransfer(ERC20 token, address to, uint256 value) internal {
826         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
827     }
828 
829     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
830         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
831     }
832 
833     function safeApprove(ERC20 token, address spender, uint256 value) internal {
834         require((value == 0) || (token.allowance(address(this), spender) == 0),
835             "SafeERC20: approve from non-zero to non-zero allowance"
836         );
837         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
838     }
839 
840     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
841         uint256 newAllowance = token.allowance(address(this), spender).add(value);
842         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
843     }
844 
845     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
846         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
847         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
848     }
849     function callOptionalReturn(ERC20 token, bytes memory data) private {
850         require(address(token).isContract(), "SafeERC20: call to non-contract");
851         (bool success, bytes memory returndata) = address(token).call(data);
852         require(success, "SafeERC20: low-level call failed");
853         if (returndata.length > 0) {
854             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
855         }
856     }
857 }
858 
859 interface ERC20 {
860     function totalSupply() external view returns (uint256);
861     function balanceOf(address account) external view returns (uint256);
862     function transfer(address recipient, uint256 amount) external returns (bool);
863     function allowance(address owner, address spender) external view returns (uint256);
864     function approve(address spender, uint256 amount) external returns (bool);
865     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
866     event Transfer(address indexed from, address indexed to, uint256 value);
867     event Approval(address indexed owner, address indexed spender, uint256 value);
868 }
869 
870 library Address {
871     function isContract(address account) internal view returns (bool) {
872         bytes32 codehash;
873         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
874         assembly { codehash := extcodehash(account) }
875         return (codehash != accountHash && codehash != 0x0);
876     }
877     function sendValue(address payable recipient, uint256 amount) internal {
878         require(address(this).balance >= amount, "Address: insufficient balance");
879         (bool success, ) = recipient.call.value(amount)("");
880         require(success, "Address: unable to send value, recipient may have reverted");
881     }
882 }