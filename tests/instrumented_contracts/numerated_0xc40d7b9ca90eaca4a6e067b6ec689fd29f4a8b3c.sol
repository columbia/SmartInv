1 pragma solidity 0.6.0;
2 
3 /**
4  * @title Offering contract
5  * @dev Offering logic and mining logic
6  */
7 contract Nest_NToken_OfferMain {
8     
9     using SafeMath for uint256;
10     using address_make_payable for address;
11     using SafeERC20 for ERC20;
12     
13     // Offering data structure
14     struct Nest_NToken_OfferPriceData {
15         // The unique identifier is determined by the position of the offer in the array, and is converted to each other through a fixed algorithm (toindex(), toaddress())
16         address owner;                                  //  Offering owner
17         bool deviate;                                   //  Whether it deviates 
18         address tokenAddress;                           //  The erc20 contract address of the target offer token
19         
20         uint256 ethAmount;                              //  The ETH amount in the offer list
21         uint256 tokenAmount;                            //  The token amount in the offer list
22         
23         uint256 dealEthAmount;                          //  The remaining number of tradable ETH
24         uint256 dealTokenAmount;                        //  The remaining number of tradable tokens
25         
26         uint256 blockNum;                               //  The block number where the offer is located
27         uint256 serviceCharge;                          //  The fee for mining
28         // Determine whether the asset has been collected by judging that ethamount, tokenamount, and servicecharge are all 0
29     }
30     
31     Nest_NToken_OfferPriceData [] _prices;                              //  Array used to save offers
32     Nest_3_VoteFactory _voteFactory;                                    //  Voting contract
33     Nest_3_OfferPrice _offerPrice;                                      //  Price contract
34     Nest_NToken_TokenMapping _tokenMapping;                             //  NToken mapping contract
35     ERC20 _nestToken;                                                   //  nestToken
36     Nest_3_Abonus _abonus;                                              //  Bonus pool
37     uint256 _miningETH = 10;                                            //  Offering mining fee ratio
38     uint256 _tranEth = 1;                                               //  Taker fee ratio
39     uint256 _tranAddition = 2;                                          //  Additional transaction multiple
40     uint256 _leastEth = 10 ether;                                       //  Minimum offer of ETH
41     uint256 _offerSpan = 10 ether;                                      //  ETH Offering span
42     uint256 _deviate = 10;                                              //  Price deviation - 10%
43     uint256 _deviationFromScale = 10;                                   //  Deviation from asset scale
44     uint256 _ownerMining = 5;                                           //  Creator ratio
45     uint256 _afterMiningAmount = 0.4 ether;                             //  Stable period mining amount
46     uint32 _blockLimit = 25;                                            //  Block interval upper limit
47     
48     uint256 _blockAttenuation = 2400000;                                //  Block decay interval
49     mapping(uint256 => mapping(address => uint256)) _blockOfferAmount;  //  Block offer times - block number=>token address=>offer fee
50     mapping(uint256 => mapping(address => uint256)) _blockMining;       //  Offering block mining amount - block number=>token address=>mining amount
51     uint256[10] _attenuationAmount;                                     //  Mining decay list
52     
53     //  Log token contract address
54     event OfferTokenContractAddress(address contractAddress);           
55     //  Log offering contract, token address, amount of ETH, amount of ERC20, delayed block, mining fee
56     event OfferContractAddress(address contractAddress, address tokenAddress, uint256 ethAmount, uint256 erc20Amount, uint256 continued,uint256 mining);         
57     //  Log transaction sender, transaction token, transaction amount, purchase token address, purchase token amount, transaction offering contract address, transaction user address
58     event OfferTran(address tranSender, address tranToken, uint256 tranAmount,address otherToken, uint256 otherAmount, address tradedContract, address tradedOwner);        
59     //  Log current block, current block mined amount, token address
60     event OreDrawingLog(uint256 nowBlock, uint256 blockAmount, address tokenAddress);
61     //  Log offering block, token address, token offered times
62     event MiningLog(uint256 blockNum, address tokenAddress, uint256 offerTimes);
63     
64     /**
65      * Initialization method
66      * @param voteFactory Voting contract address
67      **/
68     constructor (address voteFactory) public {
69         Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
70         _voteFactory = voteFactoryMap;                                                                 
71         _offerPrice = Nest_3_OfferPrice(address(voteFactoryMap.checkAddress("nest.v3.offerPrice")));            
72         _nestToken = ERC20(voteFactoryMap.checkAddress("nest"));                                                          
73         _abonus = Nest_3_Abonus(voteFactoryMap.checkAddress("nest.v3.abonus"));
74         _tokenMapping = Nest_NToken_TokenMapping(address(voteFactoryMap.checkAddress("nest.nToken.tokenMapping")));
75         
76         uint256 blockAmount = 4 ether;
77         for (uint256 i = 0; i < 10; i ++) {
78             _attenuationAmount[i] = blockAmount;
79             blockAmount = blockAmount.mul(8).div(10);
80         }
81     }
82     
83     /**
84      * Reset voting contract method
85      * @param voteFactory Voting contract address
86      **/
87     function changeMapping(address voteFactory) public onlyOwner {
88         Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
89         _voteFactory = voteFactoryMap;                                                          
90         _offerPrice = Nest_3_OfferPrice(address(voteFactoryMap.checkAddress("nest.v3.offerPrice")));      
91         _nestToken = ERC20(voteFactoryMap.checkAddress("nest"));                                                   
92         _abonus = Nest_3_Abonus(voteFactoryMap.checkAddress("nest.v3.abonus"));
93         _tokenMapping = Nest_NToken_TokenMapping(address(voteFactoryMap.checkAddress("nest.nToken.tokenMapping")));
94     }
95     
96     /**
97      * Offering method
98      * @param ethAmount ETH amount
99      * @param erc20Amount Erc20 token amount
100      * @param erc20Address Erc20 token address
101      **/
102     function offer(uint256 ethAmount, uint256 erc20Amount, address erc20Address) public payable {
103         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
104         address nTokenAddress = _tokenMapping.checkTokenMapping(erc20Address);
105         require(nTokenAddress != address(0x0));
106         //  Judge whether the price deviates
107         uint256 ethMining;
108         bool isDeviate = comparativePrice(ethAmount,erc20Amount,erc20Address);
109         if (isDeviate) {
110             require(ethAmount >= _leastEth.mul(_deviationFromScale), "EthAmount needs to be no less than 10 times of the minimum scale");
111             ethMining = _leastEth.mul(_miningETH).div(1000);
112         } else {
113             ethMining = ethAmount.mul(_miningETH).div(1000);
114         }
115         require(msg.value >= ethAmount.add(ethMining), "msg.value needs to be equal to the quoted eth quantity plus Mining handling fee");
116         uint256 subValue = msg.value.sub(ethAmount.add(ethMining));
117         if (subValue > 0) {
118             repayEth(address(msg.sender), subValue);
119         }
120         //  Create an offer
121         createOffer(ethAmount, erc20Amount, erc20Address,isDeviate, ethMining);
122         //  Transfer in offer asset - erc20 to this contract
123         ERC20(erc20Address).safeTransferFrom(address(msg.sender), address(this), erc20Amount);
124         _abonus.switchToEthForNTokenOffer.value(ethMining)(nTokenAddress);
125         //  Mining
126         if (_blockOfferAmount[block.number][erc20Address] == 0) {
127             uint256 miningAmount = oreDrawing(nTokenAddress);
128             Nest_NToken nToken = Nest_NToken(nTokenAddress);
129             nToken.transfer(nToken.checkBidder(), miningAmount.mul(_ownerMining).div(100));
130             _blockMining[block.number][erc20Address] = miningAmount.sub(miningAmount.mul(_ownerMining).div(100));
131         }
132         _blockOfferAmount[block.number][erc20Address] = _blockOfferAmount[block.number][erc20Address].add(ethMining);
133     }
134     
135     /**
136      * @dev Create offer
137      * @param ethAmount Offering ETH amount
138      * @param erc20Amount Offering erc20 amount
139      * @param erc20Address Offering erc20 address
140      **/
141     function createOffer(uint256 ethAmount, uint256 erc20Amount, address erc20Address, bool isDeviate, uint256 mining) private {
142         // Check offer conditions
143         require(ethAmount >= _leastEth, "Eth scale is smaller than the minimum scale");                                                 
144         require(ethAmount % _offerSpan == 0, "Non compliant asset span");
145         require(erc20Amount % (ethAmount.div(_offerSpan)) == 0, "Asset quantity is not divided");
146         require(erc20Amount > 0);
147         // Create offering contract
148         emit OfferContractAddress(toAddress(_prices.length), address(erc20Address), ethAmount, erc20Amount,_blockLimit,mining);
149         _prices.push(Nest_NToken_OfferPriceData(
150             msg.sender,
151             isDeviate,
152             erc20Address,
153             
154             ethAmount,
155             erc20Amount,
156             
157             ethAmount, 
158             erc20Amount, 
159             
160             block.number,
161             mining
162         ));
163         // Record price
164         _offerPrice.addPrice(ethAmount, erc20Amount, block.number.add(_blockLimit), erc20Address, address(msg.sender));
165     }
166     
167     // Convert offer address into index in offer array
168     function toIndex(address contractAddress) public pure returns(uint256) {
169         return uint256(contractAddress);
170     }
171     
172     // Convert index in offer array into offer address 
173     function toAddress(uint256 index) public pure returns(address) {
174         return address(index);
175     }
176     
177     /**
178      * Withdraw offer assets
179      * @param contractAddress Offer address
180      **/
181     function turnOut(address contractAddress) public {
182         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
183         uint256 index = toIndex(contractAddress);
184         Nest_NToken_OfferPriceData storage offerPriceData = _prices[index];
185         require(checkContractState(offerPriceData.blockNum) == 1, "Offer status error");
186         // Withdraw ETH
187         if (offerPriceData.ethAmount > 0) {
188             uint256 payEth = offerPriceData.ethAmount;
189             offerPriceData.ethAmount = 0;
190             repayEth(offerPriceData.owner, payEth);
191         }
192         // Withdraw erc20
193         if (offerPriceData.tokenAmount > 0) {
194             uint256 payErc = offerPriceData.tokenAmount;
195             offerPriceData.tokenAmount = 0;
196             ERC20(address(offerPriceData.tokenAddress)).transfer(offerPriceData.owner, payErc);
197             
198         }
199         // Mining settlement
200         if (offerPriceData.serviceCharge > 0) {
201             mining(offerPriceData.blockNum, offerPriceData.tokenAddress, offerPriceData.serviceCharge, offerPriceData.owner);
202             offerPriceData.serviceCharge = 0;
203         }
204     }
205     
206     /**
207     * @dev Taker order - pay ETH and buy erc20
208     * @param ethAmount The amount of ETH of this offer
209     * @param tokenAmount The amount of erc20 of this offer
210     * @param contractAddress The target offer address
211     * @param tranEthAmount The amount of ETH of taker order
212     * @param tranTokenAmount The amount of erc20 of taker order
213     * @param tranTokenAddress The erc20 address of taker order
214     */
215     function sendEthBuyErc(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {
216         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
217         uint256 serviceCharge = tranEthAmount.mul(_tranEth).div(1000);
218         require(msg.value == ethAmount.add(tranEthAmount).add(serviceCharge), "msg.value needs to be equal to the quotation eth quantity plus transaction eth plus");
219         require(tranEthAmount % _offerSpan == 0, "Transaction size does not meet asset span");
220         
221         //  Get the offer data structure
222         uint256 index = toIndex(contractAddress);
223         Nest_NToken_OfferPriceData memory offerPriceData = _prices[index]; 
224         //  Check the price, compare the current offer to the last effective price
225         bool thisDeviate = comparativePrice(ethAmount,tokenAmount,tranTokenAddress);
226         bool isDeviate;
227         if (offerPriceData.deviate == true) {
228             isDeviate = true;
229         } else {
230             isDeviate = thisDeviate;
231         }
232         //  Limit the taker order only be twice the amount of the offer to prevent large-amount attacks
233         if (offerPriceData.deviate) {
234             //  The taker order deviates  x2
235             require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
236         } else {
237             if (isDeviate) {
238                 //  If the taken offer is normal and the taker order deviates x10
239                 require(ethAmount >= tranEthAmount.mul(_deviationFromScale), "EthAmount needs to be no less than 10 times of transaction scale");
240             } else {
241                 //  If the taken offer is normal and the taker order is normal x2
242                 require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
243             }
244         }
245         
246         // Check whether the conditions for taker order are satisfied
247         require(checkContractState(offerPriceData.blockNum) == 0, "Offer status error");
248         require(offerPriceData.dealEthAmount >= tranEthAmount, "Insufficient trading eth");
249         require(offerPriceData.dealTokenAmount >= tranTokenAmount, "Insufficient trading token");
250         require(offerPriceData.tokenAddress == tranTokenAddress, "Wrong token address");
251         require(tranTokenAmount == offerPriceData.dealTokenAmount * tranEthAmount / offerPriceData.dealEthAmount, "Wrong token amount");
252         
253         // Update the offer information
254         offerPriceData.ethAmount = offerPriceData.ethAmount.add(tranEthAmount);
255         offerPriceData.tokenAmount = offerPriceData.tokenAmount.sub(tranTokenAmount);
256         offerPriceData.dealEthAmount = offerPriceData.dealEthAmount.sub(tranEthAmount);
257         offerPriceData.dealTokenAmount = offerPriceData.dealTokenAmount.sub(tranTokenAmount);
258         _prices[index] = offerPriceData;
259         // Create a new offer
260         createOffer(ethAmount, tokenAmount, tranTokenAddress, isDeviate, 0);
261         // Transfer in erc20 + offer asset to this contract
262         if (tokenAmount > tranTokenAmount) {
263             ERC20(tranTokenAddress).safeTransferFrom(address(msg.sender), address(this), tokenAmount.sub(tranTokenAmount));
264         } else {
265             ERC20(tranTokenAddress).safeTransfer(address(msg.sender), tranTokenAmount.sub(tokenAmount));
266         }
267 
268         // Modify price
269         _offerPrice.changePrice(tranEthAmount, tranTokenAmount, tranTokenAddress, offerPriceData.blockNum.add(_blockLimit));
270         emit OfferTran(address(msg.sender), address(0x0), tranEthAmount, address(tranTokenAddress), tranTokenAmount, contractAddress, offerPriceData.owner);
271         
272         // Transfer fee
273         if (serviceCharge > 0) {
274             address nTokenAddress = _tokenMapping.checkTokenMapping(tranTokenAddress);
275             _abonus.switchToEth.value(serviceCharge)(nTokenAddress);
276         }
277     }
278     
279     /**
280     * @dev Taker order - pay erc20 and buy ETH
281     * @param ethAmount The amount of ETH of this offer
282     * @param tokenAmount The amount of erc20 of this offer
283     * @param contractAddress The target offer address
284     * @param tranEthAmount The amount of ETH of taker order
285     * @param tranTokenAmount The amount of erc20 of taker order
286     * @param tranTokenAddress The erc20 address of taker order
287     */
288     function sendErcBuyEth(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {
289         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
290         uint256 serviceCharge = tranEthAmount.mul(_tranEth).div(1000);
291         require(msg.value == ethAmount.sub(tranEthAmount).add(serviceCharge), "msg.value needs to be equal to the quoted eth quantity plus transaction handling fee");
292         require(tranEthAmount % _offerSpan == 0, "Transaction size does not meet asset span");
293         //  Get the offer data structure
294         uint256 index = toIndex(contractAddress);
295         Nest_NToken_OfferPriceData memory offerPriceData = _prices[index]; 
296         //  Check the price, compare the current offer to the last effective price
297         bool thisDeviate = comparativePrice(ethAmount,tokenAmount,tranTokenAddress);
298         bool isDeviate;
299         if (offerPriceData.deviate == true) {
300             isDeviate = true;
301         } else {
302             isDeviate = thisDeviate;
303         }
304         //  Limit the taker order only be twice the amount of the offer to prevent large-amount attacks
305         if (offerPriceData.deviate) {
306             //  The taker order deviates  x2
307             require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
308         } else {
309             if (isDeviate) {
310                 //  If the taken offer is normal and the taker order deviates x10
311                 require(ethAmount >= tranEthAmount.mul(_deviationFromScale), "EthAmount needs to be no less than 10 times of transaction scale");
312             } else {
313                 //  If the taken offer is normal and the taker order is normal x2
314                 require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
315             }
316         }
317         // Check whether the conditions for taker order are satisfied
318         require(checkContractState(offerPriceData.blockNum) == 0, "Offer status error");
319         require(offerPriceData.dealEthAmount >= tranEthAmount, "Insufficient trading eth");
320         require(offerPriceData.dealTokenAmount >= tranTokenAmount, "Insufficient trading token");
321         require(offerPriceData.tokenAddress == tranTokenAddress, "Wrong token address");
322         require(tranTokenAmount == offerPriceData.dealTokenAmount * tranEthAmount / offerPriceData.dealEthAmount, "Wrong token amount");
323         // Update the offer information
324         offerPriceData.ethAmount = offerPriceData.ethAmount.sub(tranEthAmount);
325         offerPriceData.tokenAmount = offerPriceData.tokenAmount.add(tranTokenAmount);
326         offerPriceData.dealEthAmount = offerPriceData.dealEthAmount.sub(tranEthAmount);
327         offerPriceData.dealTokenAmount = offerPriceData.dealTokenAmount.sub(tranTokenAmount);
328         _prices[index] = offerPriceData;
329         // Create a new offer
330         createOffer(ethAmount, tokenAmount, tranTokenAddress, isDeviate, 0);
331         // Transfer in erc20 + offer asset to this contract
332         ERC20(tranTokenAddress).safeTransferFrom(address(msg.sender), address(this), tranTokenAmount.add(tokenAmount));
333         // Modify price
334         _offerPrice.changePrice(tranEthAmount, tranTokenAmount, tranTokenAddress, offerPriceData.blockNum.add(_blockLimit));
335         emit OfferTran(address(msg.sender), address(tranTokenAddress), tranTokenAmount, address(0x0), tranEthAmount, contractAddress, offerPriceData.owner);
336         // Transfer fee
337         if (serviceCharge > 0) {
338             address nTokenAddress = _tokenMapping.checkTokenMapping(tranTokenAddress);
339             _abonus.switchToEth.value(serviceCharge)(nTokenAddress);
340         }
341     }
342     
343     /**
344      * Offering mining
345      * @param ntoken NToken address
346      **/
347     function oreDrawing(address ntoken) private returns(uint256) {
348         Nest_NToken miningToken = Nest_NToken(ntoken);
349         (uint256 createBlock, uint256 recentlyUsedBlock) = miningToken.checkBlockInfo();
350         uint256 attenuationPointNow = block.number.sub(createBlock).div(_blockAttenuation);
351         uint256 miningAmount = 0;
352         uint256 attenuation;
353         if (attenuationPointNow > 9) {
354             attenuation = _afterMiningAmount;
355         } else {
356             attenuation = _attenuationAmount[attenuationPointNow];
357         }
358         miningAmount = attenuation.mul(block.number.sub(recentlyUsedBlock));
359         miningToken.increaseTotal(miningAmount);
360         emit OreDrawingLog(block.number, miningAmount, ntoken);
361         return miningAmount;
362     }
363     
364     /**
365      * Retrieve mining
366      * @param token Token address
367      **/
368     function mining(uint256 blockNum, address token, uint256 serviceCharge, address owner) private returns(uint256) {
369         //  Block mining amount*offer fee/block offer fee
370         uint256 miningAmount = _blockMining[blockNum][token].mul(serviceCharge).div(_blockOfferAmount[blockNum][token]);        
371         //  Transfer NToken 
372         Nest_NToken nToken = Nest_NToken(address(_tokenMapping.checkTokenMapping(token)));
373         require(nToken.transfer(address(owner), miningAmount), "Transfer failure");
374         
375         emit MiningLog(blockNum, token,_blockOfferAmount[blockNum][token]);
376         return miningAmount;
377     }
378     
379     // Compare order prices
380     function comparativePrice(uint256 myEthValue, uint256 myTokenValue, address token) private view returns(bool) {
381         (uint256 frontEthValue, uint256 frontTokenValue) = _offerPrice.updateAndCheckPricePrivate(token);
382         if (frontEthValue == 0 || frontTokenValue == 0) {
383             return false;
384         }
385         uint256 maxTokenAmount = myEthValue.mul(frontTokenValue).mul(uint256(100).add(_deviate)).div(frontEthValue.mul(100));
386         if (myTokenValue <= maxTokenAmount) {
387             uint256 minTokenAmount = myEthValue.mul(frontTokenValue).mul(uint256(100).sub(_deviate)).div(frontEthValue.mul(100));
388             if (myTokenValue >= minTokenAmount) {
389                 return false;
390             }
391         }
392         return true;
393     }
394     
395     // Check contract status
396     function checkContractState(uint256 createBlock) public view returns (uint256) {
397         if (block.number.sub(createBlock) > _blockLimit) {
398             return 1;
399         }
400         return 0;
401     }
402     
403     // Transfer ETH
404     function repayEth(address accountAddress, uint256 asset) private {
405         address payable addr = accountAddress.make_payable();
406         addr.transfer(asset);
407     }
408     
409     // View the upper limit of the block interval
410     function checkBlockLimit() public view returns(uint256) {
411         return _blockLimit;
412     }
413     
414     // View taker fee ratio
415     function checkTranEth() public view returns (uint256) {
416         return _tranEth;
417     }
418     
419     // View additional transaction multiple
420     function checkTranAddition() public view returns(uint256) {
421         return _tranAddition;
422     }
423     
424     // View minimum offering ETH
425     function checkleastEth() public view returns(uint256) {
426         return _leastEth;
427     }
428     
429     // View offering ETH span
430     function checkOfferSpan() public view returns(uint256) {
431         return _offerSpan;
432     }
433 
434     // View block offering amount
435     function checkBlockOfferAmount(uint256 blockNum, address token) public view returns (uint256) {
436         return _blockOfferAmount[blockNum][token];
437     }
438     
439     // View offering block mining amount
440     function checkBlockMining(uint256 blockNum, address token) public view returns (uint256) {
441         return _blockMining[blockNum][token];
442     }
443     
444     // View offering mining amount
445     function checkOfferMining(uint256 blockNum, address token, uint256 serviceCharge) public view returns (uint256) {
446         if (serviceCharge == 0) {
447             return 0;
448         } else {
449             return _blockMining[blockNum][token].mul(serviceCharge).div(_blockOfferAmount[blockNum][token]);
450         }
451     }
452     
453     //  View the owner allocation ratio
454     function checkOwnerMining() public view returns(uint256) {
455         return _ownerMining;
456     }
457     
458     // View the mining decay
459     function checkAttenuationAmount(uint256 num) public view returns(uint256) {
460         return _attenuationAmount[num];
461     }
462     
463     // Modify taker order fee ratio
464     function changeTranEth(uint256 num) public onlyOwner {
465         _tranEth = num;
466     }
467     
468     // Modify block interval upper limit
469     function changeBlockLimit(uint32 num) public onlyOwner {
470         _blockLimit = num;
471     }
472     
473     // Modify additional transaction multiple
474     function changeTranAddition(uint256 num) public onlyOwner {
475         require(num > 0, "Parameter needs to be greater than 0");
476         _tranAddition = num;
477     }
478     
479     // Modify minimum offering ETH
480     function changeLeastEth(uint256 num) public onlyOwner {
481         require(num > 0, "Parameter needs to be greater than 0");
482         _leastEth = num;
483     }
484     
485     // Modify offering ETH span
486     function changeOfferSpan(uint256 num) public onlyOwner {
487         require(num > 0, "Parameter needs to be greater than 0");
488         _offerSpan = num;
489     }
490     
491     // Modify price deviation
492     function changekDeviate(uint256 num) public onlyOwner {
493         _deviate = num;
494     }
495     
496     // Modify the deviation from scale 
497     function changeDeviationFromScale(uint256 num) public onlyOwner {
498         _deviationFromScale = num;
499     }
500     
501     // Modify the owner allocation ratio
502     function changeOwnerMining(uint256 num) public onlyOwner {
503         _ownerMining = num;
504     }
505     
506     // Modify the mining decay
507     function changeAttenuationAmount(uint256 firstAmount, uint256 top, uint256 bottom) public onlyOwner {
508         uint256 blockAmount = firstAmount;
509         for (uint256 i = 0; i < 10; i ++) {
510             _attenuationAmount[i] = blockAmount;
511             blockAmount = blockAmount.mul(top).div(bottom);
512         }
513     }
514     
515     // Vote administrators only
516     modifier onlyOwner(){
517         require(_voteFactory.checkOwners(msg.sender), "No authority");
518         _;
519     }
520     
521     /**
522      * Get the number of offers stored in the offer array
523      * @return The number of offers stored in the offer array
524      **/
525     function getPriceCount() view public returns (uint256) {
526         return _prices.length;
527     }
528     
529     /**
530      * Get offer information according to the index
531      * @param priceIndex Offer index
532      * @return Offer information
533      **/
534     function getPrice(uint256 priceIndex) view public returns (string memory) {
535         //  The buffer array used to generate the result string
536         bytes memory buf = new bytes(500000);
537         uint256 index = 0;
538         index = writeOfferPriceData(priceIndex, _prices[priceIndex], buf, index);
539         // Generate the result string and return
540         bytes memory str = new bytes(index);
541         while(index-- > 0) {
542             str[index] = buf[index];
543         }
544         return string(str);
545     }
546     
547     /**
548      * Search the contract address list of the target account (reverse order)
549      * @param start Search forward from the index corresponding to the given contract address (not including the record corresponding to start address)
550      * @param count Maximum number of records to return
551      * @param maxFindCount The max index to search
552      * @param owner Target account address
553      * @return Separate the offer records with symbols. use , to divide fields:  
554      * uuid,owner,tokenAddress,ethAmount,tokenAmount,dealEthAmount,dealTokenAmount,blockNum,serviceCharge
555      **/
556     function find(address start, uint256 count, uint256 maxFindCount, address owner) view public returns (string memory) {
557         // Buffer array used to generate result string
558         bytes memory buf = new bytes(500000);
559         uint256 index = 0;
560         // Calculate search interval i and end
561         uint256 i = _prices.length;
562         uint256 end = 0;
563         if (start != address(0)) {
564             i = toIndex(start);
565         }
566         if (i > maxFindCount) {
567             end = i - maxFindCount;
568         }
569         // Loop search, write qualified records into buffer
570         while (count > 0 && i-- > end) {
571             Nest_NToken_OfferPriceData memory price = _prices[i];
572             if (price.owner == owner) {
573                 --count;
574                 index = writeOfferPriceData(i, price, buf, index);
575             }
576         }
577         // Generate result string and return
578         bytes memory str = new bytes(index);
579         while(index-- > 0) {
580             str[index] = buf[index];
581         }
582         return string(str);
583     }
584     
585     /**
586      * Get the list of offers by page
587      * @param offset Skip the first offset records
588      * @param count Maximum number of records to return
589      * @param order Sort rules. 0 means reverse order, non-zero means positive order
590      * @return Separate the offer records with symbols. use , to divide fields: 
591      * uuid,owner,tokenAddress,ethAmount,tokenAmount,dealEthAmount,dealTokenAmount,blockNum,serviceCharge
592      **/
593     function list(uint256 offset, uint256 count, uint256 order) view public returns (string memory) {
594         
595         // Buffer array used to generate result string 
596         bytes memory buf = new bytes(500000);
597         uint256 index = 0;
598         
599         // Find search interval i and end
600         uint256 i = 0;
601         uint256 end = 0;
602         
603         if (order == 0) {
604             // Reverse order, in default 
605             // Calculate search interval i and end
606             if (offset < _prices.length) {
607                 i = _prices.length - offset;
608             } 
609             if (count < i) {
610                 end = i - count;
611             }
612             
613             // Write records in the target interval into the buffer
614             while (i-- > end) {
615                 index = writeOfferPriceData(i, _prices[i], buf, index);
616             }
617         } else {
618             // Ascending order
619             // Calculate the search interval i and end
620             if (offset < _prices.length) {
621                 i = offset;
622             } else {
623                 i = _prices.length;
624             }
625             end = i + count;
626             if(end > _prices.length) {
627                 end = _prices.length;
628             }
629             
630             // Write the records in the target interval into the buffer
631             while (i < end) {
632                 index = writeOfferPriceData(i, _prices[i], buf, index);
633                 ++i;
634             }
635         }
636         
637         // Generate the result string and return
638         bytes memory str = new bytes(index);
639         while(index-- > 0) {
640             str[index] = buf[index];
641         }
642         return string(str);
643     }   
644      
645     // Write the offer data into the buffer and return the buffer index
646     function writeOfferPriceData(uint256 priceIndex, Nest_NToken_OfferPriceData memory price, bytes memory buf, uint256 index) pure private returns (uint256) {
647         
648         index = writeAddress(toAddress(priceIndex), buf, index);
649         buf[index++] = byte(uint8(44));
650         
651         index = writeAddress(price.owner, buf, index);
652         buf[index++] = byte(uint8(44));
653         
654         index = writeAddress(price.tokenAddress, buf, index);
655         buf[index++] = byte(uint8(44));
656         
657         index = writeUInt(price.ethAmount, buf, index);
658         buf[index++] = byte(uint8(44));
659         
660         index = writeUInt(price.tokenAmount, buf, index);
661         buf[index++] = byte(uint8(44));
662        
663         index = writeUInt(price.dealEthAmount, buf, index);
664         buf[index++] = byte(uint8(44));
665         
666         index = writeUInt(price.dealTokenAmount, buf, index);
667         buf[index++] = byte(uint8(44));
668         
669         index = writeUInt(price.blockNum, buf, index);
670         buf[index++] = byte(uint8(44));
671         
672         index = writeUInt(price.serviceCharge, buf, index);
673         buf[index++] = byte(uint8(44));
674         
675         return index;
676     }
677      
678     // Convert integer to string in decimal form, write the string into the buffer, and return the buffer index
679     function writeUInt(uint256 iv, bytes memory buf, uint256 index) pure public returns (uint256) {
680         uint256 i = index;
681         do {
682             buf[index++] = byte(uint8(iv % 10 +48));
683             iv /= 10;
684         } while (iv > 0);
685         
686         for (uint256 j = index; j > i; ++i) {
687             byte t = buf[i];
688             buf[i] = buf[--j];
689             buf[j] = t;
690         }
691         
692         return index;
693     }
694 
695     // Convert the address to a hexadecimal string and write it into the buffer, and return the buffer index
696     function writeAddress(address addr, bytes memory buf, uint256 index) pure private returns (uint256) {
697         
698         uint256 iv = uint256(addr);
699         uint256 i = index + 40;
700         do {
701             uint256 w = iv % 16;
702             if(w < 10) {
703                 buf[index++] = byte(uint8(w +48));
704             } else {
705                 buf[index++] = byte(uint8(w +87));
706             }
707             
708             iv /= 16;
709         } while (index < i);
710         
711         i -= 40;
712         for (uint256 j = index; j > i; ++i) {
713             byte t = buf[i];
714             buf[i] = buf[--j];
715             buf[j] = t;
716         }
717         
718         return index;
719     }
720 }
721 
722 // Price contract
723 interface Nest_3_OfferPrice {
724     // Add price data
725     function addPrice(uint256 ethAmount, uint256 tokenAmount, uint256 endBlock, address tokenAddress, address offerOwner) external;
726     // Modify price
727     function changePrice(uint256 ethAmount, uint256 tokenAmount, address tokenAddress, uint256 endBlock) external;
728     function updateAndCheckPricePrivate(address tokenAddress) external view returns(uint256 ethAmount, uint256 erc20Amount);
729 }
730 
731 // Voting contract
732 interface Nest_3_VoteFactory {
733     //  Check address
734 	function checkAddress(string calldata name) external view returns (address contractAddress);
735 	// Check whether an administrator
736 	function checkOwners(address man) external view returns (bool);
737 }
738 
739 // NToken contract
740 interface Nest_NToken {
741     // Additional issuance
742     function increaseTotal(uint256 value) external;
743     // Check mining information
744     function checkBlockInfo() external view returns(uint256 createBlock, uint256 recentlyUsedBlock);
745     // Check creator
746     function checkBidder() external view returns(address);
747     function totalSupply() external view returns (uint256);
748     function balanceOf(address account) external view returns (uint256);
749     function transfer(address recipient, uint256 amount) external returns (bool);
750     function allowance(address owner, address spender) external view returns (uint256);
751     function approve(address spender, uint256 amount) external returns (bool);
752     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
753     event Transfer(address indexed from, address indexed to, uint256 value);
754     event Approval(address indexed owner, address indexed spender, uint256 value);
755 }
756 
757 // NToken mapping contract
758 interface Nest_NToken_TokenMapping {
759     // Check token mapping
760     function checkTokenMapping(address token) external view returns (address);
761 }
762 
763 // Bonus pool contract
764 interface Nest_3_Abonus {
765     function switchToEth(address token) external payable;
766     function switchToEthForNTokenOffer(address token) external payable;
767 }
768 
769 library SafeMath {
770     function add(uint256 a, uint256 b) internal pure returns (uint256) {
771         uint256 c = a + b;
772         require(c >= a, "SafeMath: addition overflow");
773 
774         return c;
775     }
776     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
777         return sub(a, b, "SafeMath: subtraction overflow");
778     }
779     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
780         require(b <= a, errorMessage);
781         uint256 c = a - b;
782 
783         return c;
784     }
785     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
786         if (a == 0) {
787             return 0;
788         }
789         uint256 c = a * b;
790         require(c / a == b, "SafeMath: multiplication overflow");
791 
792         return c;
793     }
794     function div(uint256 a, uint256 b) internal pure returns (uint256) {
795         return div(a, b, "SafeMath: division by zero");
796     }
797     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
798         require(b > 0, errorMessage);
799         uint256 c = a / b;
800         return c;
801     }
802     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
803         return mod(a, b, "SafeMath: modulo by zero");
804     }
805     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
806         require(b != 0, errorMessage);
807         return a % b;
808     }
809 }
810 
811 library address_make_payable {
812    function make_payable(address x) internal pure returns (address payable) {
813       return address(uint160(x));
814    }
815 }
816 
817 library SafeERC20 {
818     using SafeMath for uint256;
819     using Address for address;
820 
821     function safeTransfer(ERC20 token, address to, uint256 value) internal {
822         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
823     }
824 
825     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
826         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
827     }
828 
829     function safeApprove(ERC20 token, address spender, uint256 value) internal {
830         require((value == 0) || (token.allowance(address(this), spender) == 0),
831             "SafeERC20: approve from non-zero to non-zero allowance"
832         );
833         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
834     }
835 
836     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
837         uint256 newAllowance = token.allowance(address(this), spender).add(value);
838         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
839     }
840 
841     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
842         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
843         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
844     }
845     function callOptionalReturn(ERC20 token, bytes memory data) private {
846         require(address(token).isContract(), "SafeERC20: call to non-contract");
847         (bool success, bytes memory returndata) = address(token).call(data);
848         require(success, "SafeERC20: low-level call failed");
849         if (returndata.length > 0) {
850             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
851         }
852     }
853 }
854 
855 interface ERC20 {
856     function totalSupply() external view returns (uint256);
857     function balanceOf(address account) external view returns (uint256);
858     function transfer(address recipient, uint256 amount) external returns (bool);
859     function allowance(address owner, address spender) external view returns (uint256);
860     function approve(address spender, uint256 amount) external returns (bool);
861     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
862     event Transfer(address indexed from, address indexed to, uint256 value);
863     event Approval(address indexed owner, address indexed spender, uint256 value);
864 }
865 
866 library Address {
867     function isContract(address account) internal view returns (bool) {
868         bytes32 codehash;
869         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
870         assembly { codehash := extcodehash(account) }
871         return (codehash != accountHash && codehash != 0x0);
872     }
873     function sendValue(address payable recipient, uint256 amount) internal {
874         require(address(this).balance >= amount, "Address: insufficient balance");
875         (bool success, ) = recipient.call.value(amount)("");
876         require(success, "Address: unable to send value, recipient may have reverted");
877     }
878 }