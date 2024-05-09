1 pragma solidity 0.6.0;
2 
3 /**
4  * @title Offering contract
5  * @dev Offering + take order + NEST allocation
6  */
7 contract Nest_3_OfferMain {
8     using SafeMath for uint256;
9     using address_make_payable for address;
10     using SafeERC20 for ERC20;
11     
12     struct Nest_3_OfferPriceData {
13         // The unique identifier is determined by the position of the offer in the array, and is converted to each other through a fixed algorithm (toindex(), toaddress())
14         
15         address owner;                                  //  Offering owner
16         bool deviate;                                   //  Whether it deviates 
17         address tokenAddress;                           //  The erc20 contract address of the target offer token
18         
19         uint256 ethAmount;                              //  The ETH amount in the offer list
20         uint256 tokenAmount;                            //  The token amount in the offer list
21         
22         uint256 dealEthAmount;                          //  The remaining number of tradable ETH
23         uint256 dealTokenAmount;                        //  The remaining number of tradable tokens
24         
25         uint256 blockNum;                               //  The block number where the offer is located
26         uint256 serviceCharge;                          //  The fee for mining
27         
28         // Determine whether the asset has been collected by judging that ethamount, tokenamount, and servicecharge are all 0
29     }
30     
31     Nest_3_OfferPriceData [] _prices;                   //  Array used to save offers
32 
33     mapping(address => bool) _tokenAllow;               //  List of allowed mining token
34     Nest_3_VoteFactory _voteFactory;                    //  Vote contract
35     Nest_3_OfferPrice _offerPrice;                      //  Price contract
36     Nest_3_MiningContract _miningContract;              //  Mining contract
37     Nest_NodeAssignment _NNcontract;                    //  NestNode contract
38     ERC20 _nestToken;                                   //  NestToken
39     Nest_3_Abonus _abonus;                              //  Bonus pool
40     address _coderAddress;                              //  Developer address
41     uint256 _miningETH = 10;                            //  Offering mining fee ratio
42     uint256 _tranEth = 1;                               //  Taker fee ratio
43     uint256 _tranAddition = 2;                          //  Additional transaction multiple
44     uint256 _coderAmount = 5;                           //  Developer ratio
45     uint256 _NNAmount = 15;                             //  NestNode ratio
46     uint256 _leastEth = 10 ether;                       //  Minimum offer of ETH
47     uint256 _offerSpan = 10 ether;                      //  ETH Offering span
48     uint256 _deviate = 10;                              //  Price deviation - 10%
49     uint256 _deviationFromScale = 10;                   //  Deviation from asset scale
50     uint32 _blockLimit = 25;                            //  Block interval upper limit
51     mapping(uint256 => uint256) _offerBlockEth;         //  Block offer fee
52     mapping(uint256 => uint256) _offerBlockMining;      //  Block mining amount
53     
54     //  Log offering contract, token address, number of eth, number of erc20, number of continuous blocks, number of fees
55     event OfferContractAddress(address contractAddress, address tokenAddress, uint256 ethAmount, uint256 erc20Amount, uint256 continued, uint256 serviceCharge);
56     //  Log transaction, transaction initiator, transaction token address, number of transaction token, token address, number of token, traded offering contract address, traded user address
57     event OfferTran(address tranSender, address tranToken, uint256 tranAmount,address otherToken, uint256 otherAmount, address tradedContract, address tradedOwner);        
58     
59      /**
60     * @dev Initialization method
61     * @param voteFactory Voting contract address
62     */
63     constructor (address voteFactory) public {
64         Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
65         _voteFactory = voteFactoryMap; 
66         _offerPrice = Nest_3_OfferPrice(address(voteFactoryMap.checkAddress("nest.v3.offerPrice")));            
67         _miningContract = Nest_3_MiningContract(address(voteFactoryMap.checkAddress("nest.v3.miningSave")));
68         _abonus = Nest_3_Abonus(voteFactoryMap.checkAddress("nest.v3.abonus"));
69         _nestToken = ERC20(voteFactoryMap.checkAddress("nest"));                                         
70         _NNcontract = Nest_NodeAssignment(address(voteFactoryMap.checkAddress("nodeAssignment")));      
71         _coderAddress = voteFactoryMap.checkAddress("nest.v3.coder");
72         require(_nestToken.approve(address(_NNcontract), uint256(10000000000 ether)), "Authorization failed");
73     }
74     
75      /**
76     * @dev Reset voting contract
77     * @param voteFactory Voting contract address
78     */
79     function changeMapping(address voteFactory) public onlyOwner {
80         Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
81         _voteFactory = voteFactoryMap; 
82         _offerPrice = Nest_3_OfferPrice(address(voteFactoryMap.checkAddress("nest.v3.offerPrice")));            
83         _miningContract = Nest_3_MiningContract(address(voteFactoryMap.checkAddress("nest.v3.miningSave")));
84         _abonus = Nest_3_Abonus(voteFactoryMap.checkAddress("nest.v3.abonus"));
85         _nestToken = ERC20(voteFactoryMap.checkAddress("nest"));                                           
86         _NNcontract = Nest_NodeAssignment(address(voteFactoryMap.checkAddress("nodeAssignment")));      
87         _coderAddress = voteFactoryMap.checkAddress("nest.v3.coder");
88         require(_nestToken.approve(address(_NNcontract), uint256(10000000000 ether)), "Authorization failed");
89     }
90     
91     /**
92     * @dev Offering mining
93     * @param ethAmount Offering ETH amount 
94     * @param erc20Amount Offering erc20 token amount
95     * @param erc20Address Offering erc20 token address
96     */
97     function offer(uint256 ethAmount, uint256 erc20Amount, address erc20Address) public payable {
98         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
99         require(_tokenAllow[erc20Address], "Token not allow");
100         //  Judge whether the price deviates
101         uint256 ethMining;
102         bool isDeviate = comparativePrice(ethAmount,erc20Amount,erc20Address);
103         if (isDeviate) {
104             require(ethAmount >= _leastEth.mul(_deviationFromScale), "EthAmount needs to be no less than 10 times of the minimum scale");
105             ethMining = _leastEth.mul(_miningETH).div(1000);
106         } else {
107             ethMining = ethAmount.mul(_miningETH).div(1000);
108         }
109         require(msg.value >= ethAmount.add(ethMining), "msg.value needs to be equal to the quoted eth quantity plus Mining handling fee");
110         uint256 subValue = msg.value.sub(ethAmount.add(ethMining));
111         if (subValue > 0) {
112             repayEth(address(msg.sender), subValue);
113         }
114         //  Create an offer
115         createOffer(ethAmount, erc20Amount, erc20Address, ethMining, isDeviate);
116         //  Transfer in offer asset - erc20 to this contract
117         ERC20(erc20Address).safeTransferFrom(address(msg.sender), address(this), erc20Amount);
118         //  Mining
119         uint256 miningAmount = _miningContract.oreDrawing();
120         _abonus.switchToEth.value(ethMining)(address(_nestToken));
121         if (miningAmount > 0) {
122             uint256 coder = miningAmount.mul(_coderAmount).div(100);
123             uint256 NN = miningAmount.mul(_NNAmount).div(100);
124             uint256 other = miningAmount.sub(coder).sub(NN);
125             _offerBlockMining[block.number] = other;
126             _NNcontract.bookKeeping(NN);   
127             if (coder > 0) {
128                 _nestToken.safeTransfer(_coderAddress, coder);  
129             }
130         }
131         _offerBlockEth[block.number] = _offerBlockEth[block.number].add(ethMining);
132     }
133     
134     /**
135     * @dev Create offer
136     * @param ethAmount Offering ETH amount
137     * @param erc20Amount Offering erc20 amount
138     * @param erc20Address Offering erc20 address
139     * @param mining Offering mining fee (0 for takers)
140     * @param isDeviate Whether the current price chain deviates
141     */
142     function createOffer(uint256 ethAmount, uint256 erc20Amount, address erc20Address, uint256 mining, bool isDeviate) private {
143         // Check offer conditions
144         require(ethAmount >= _leastEth, "Eth scale is smaller than the minimum scale");
145         require(ethAmount % _offerSpan == 0, "Non compliant asset span");
146         require(erc20Amount % (ethAmount.div(_offerSpan)) == 0, "Asset quantity is not divided");
147         require(erc20Amount > 0);
148         // Create offering contract
149         emit OfferContractAddress(toAddress(_prices.length), address(erc20Address), ethAmount, erc20Amount,_blockLimit,mining);
150         _prices.push(Nest_3_OfferPriceData(
151             
152             msg.sender,
153             isDeviate,
154             erc20Address,
155             
156             ethAmount,
157             erc20Amount,
158                            
159             ethAmount, 
160             erc20Amount, 
161               
162             block.number, 
163             mining
164             
165         )); 
166         // Record price
167         _offerPrice.addPrice(ethAmount, erc20Amount, block.number.add(_blockLimit), erc20Address, address(msg.sender));
168     }
169     
170     /**
171     * @dev Taker order - pay ETH and buy erc20
172     * @param ethAmount The amount of ETH of this offer
173     * @param tokenAmount The amount of erc20 of this offer
174     * @param contractAddress The target offer address
175     * @param tranEthAmount The amount of ETH of taker order
176     * @param tranTokenAmount The amount of erc20 of taker order
177     * @param tranTokenAddress The erc20 address of taker order
178     */
179     function sendEthBuyErc(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {
180         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
181         // Get the offer data structure
182         uint256 index = toIndex(contractAddress);
183         Nest_3_OfferPriceData memory offerPriceData = _prices[index]; 
184         //  Check the price, compare the current offer to the last effective price
185         bool thisDeviate = comparativePrice(ethAmount,tokenAmount,tranTokenAddress);
186         bool isDeviate;
187         if (offerPriceData.deviate == true) {
188             isDeviate = true;
189         } else {
190             isDeviate = thisDeviate;
191         }
192         // Limit the taker order only be twice the amount of the offer to prevent large-amount attacks
193         if (offerPriceData.deviate) {
194             //  The taker order deviates  x2
195             require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
196         } else {
197             if (isDeviate) {
198                 //  If the taken offer is normal and the taker order deviates x10
199                 require(ethAmount >= tranEthAmount.mul(_deviationFromScale), "EthAmount needs to be no less than 10 times of transaction scale");
200             } else {
201                 //  If the taken offer is normal and the taker order is normal x2
202                 require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
203             }
204         }
205         
206         uint256 serviceCharge = tranEthAmount.mul(_tranEth).div(1000);
207         require(msg.value == ethAmount.add(tranEthAmount).add(serviceCharge), "msg.value needs to be equal to the quotation eth quantity plus transaction eth plus transaction handling fee");
208         require(tranEthAmount % _offerSpan == 0, "Transaction size does not meet asset span");
209         
210         // Check whether the conditions for taker order are satisfied
211         require(checkContractState(offerPriceData.blockNum) == 0, "Offer status error");
212         require(offerPriceData.dealEthAmount >= tranEthAmount, "Insufficient trading eth");
213         require(offerPriceData.dealTokenAmount >= tranTokenAmount, "Insufficient trading token");
214         require(offerPriceData.tokenAddress == tranTokenAddress, "Wrong token address");
215         require(tranTokenAmount == offerPriceData.dealTokenAmount * tranEthAmount / offerPriceData.dealEthAmount, "Wrong token amount");
216         
217         // Update the offer information
218         offerPriceData.ethAmount = offerPriceData.ethAmount.add(tranEthAmount);
219         offerPriceData.tokenAmount = offerPriceData.tokenAmount.sub(tranTokenAmount);
220         offerPriceData.dealEthAmount = offerPriceData.dealEthAmount.sub(tranEthAmount);
221         offerPriceData.dealTokenAmount = offerPriceData.dealTokenAmount.sub(tranTokenAmount);
222         _prices[index] = offerPriceData;
223         // Create a new offer
224         createOffer(ethAmount, tokenAmount, tranTokenAddress, 0, isDeviate);
225         // Transfer in erc20 + offer asset to this contract
226         if (tokenAmount > tranTokenAmount) {
227             ERC20(tranTokenAddress).safeTransferFrom(address(msg.sender), address(this), tokenAmount.sub(tranTokenAmount));
228         } else {
229             ERC20(tranTokenAddress).safeTransfer(address(msg.sender), tranTokenAmount.sub(tokenAmount));
230         }
231         // Modify price
232         _offerPrice.changePrice(tranEthAmount, tranTokenAmount, tranTokenAddress, offerPriceData.blockNum.add(_blockLimit));
233         emit OfferTran(address(msg.sender), address(0x0), tranEthAmount, address(tranTokenAddress), tranTokenAmount, contractAddress, offerPriceData.owner);
234         // Transfer fee
235         if (serviceCharge > 0) {
236             _abonus.switchToEth.value(serviceCharge)(address(_nestToken));
237         }
238     }
239     
240     /**
241     * @dev Taker order - pay erc20 and buy ETH
242     * @param ethAmount The amount of ETH of this offer
243     * @param tokenAmount The amount of erc20 of this offer
244     * @param contractAddress The target offer address
245     * @param tranEthAmount The amount of ETH of taker order
246     * @param tranTokenAmount The amount of erc20 of taker order
247     * @param tranTokenAddress The erc20 address of taker order
248     */
249     function sendErcBuyEth(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {
250         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
251         // Get the offer data structure
252         uint256 index = toIndex(contractAddress);
253         Nest_3_OfferPriceData memory offerPriceData = _prices[index]; 
254         // Check the price, compare the current offer to the last effective price
255         bool thisDeviate = comparativePrice(ethAmount,tokenAmount,tranTokenAddress);
256         bool isDeviate;
257         if (offerPriceData.deviate == true) {
258             isDeviate = true;
259         } else {
260             isDeviate = thisDeviate;
261         }
262         // Limit the taker order only be twice the amount of the offer to prevent large-amount attacks
263         if (offerPriceData.deviate) {
264             //  The taker order deviates  x2
265             require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
266         } else {
267             if (isDeviate) {
268                 //  If the taken offer is normal and the taker order deviates x10
269                 require(ethAmount >= tranEthAmount.mul(_deviationFromScale), "EthAmount needs to be no less than 10 times of transaction scale");
270             } else {
271                 //  If the taken offer is normal and the taker order is normal x2 
272                 require(ethAmount >= tranEthAmount.mul(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
273             }
274         }
275         uint256 serviceCharge = tranEthAmount.mul(_tranEth).div(1000);
276         require(msg.value == ethAmount.sub(tranEthAmount).add(serviceCharge), "msg.value needs to be equal to the quoted eth quantity plus transaction handling fee");
277         require(tranEthAmount % _offerSpan == 0, "Transaction size does not meet asset span");
278         
279         // Check whether the conditions for taker order are satisfied
280         require(checkContractState(offerPriceData.blockNum) == 0, "Offer status error");
281         require(offerPriceData.dealEthAmount >= tranEthAmount, "Insufficient trading eth");
282         require(offerPriceData.dealTokenAmount >= tranTokenAmount, "Insufficient trading token");
283         require(offerPriceData.tokenAddress == tranTokenAddress, "Wrong token address");
284         require(tranTokenAmount == offerPriceData.dealTokenAmount * tranEthAmount / offerPriceData.dealEthAmount, "Wrong token amount");
285         
286         // Update the offer information
287         offerPriceData.ethAmount = offerPriceData.ethAmount.sub(tranEthAmount);
288         offerPriceData.tokenAmount = offerPriceData.tokenAmount.add(tranTokenAmount);
289         offerPriceData.dealEthAmount = offerPriceData.dealEthAmount.sub(tranEthAmount);
290         offerPriceData.dealTokenAmount = offerPriceData.dealTokenAmount.sub(tranTokenAmount);
291         _prices[index] = offerPriceData;
292         // Create a new offer
293         createOffer(ethAmount, tokenAmount, tranTokenAddress, 0, isDeviate);
294         // Transfer in erc20 + offer asset to this contract
295         ERC20(tranTokenAddress).safeTransferFrom(address(msg.sender), address(this), tranTokenAmount.add(tokenAmount));
296         // Modify price
297         _offerPrice.changePrice(tranEthAmount, tranTokenAmount, tranTokenAddress, offerPriceData.blockNum.add(_blockLimit));
298         emit OfferTran(address(msg.sender), address(tranTokenAddress), tranTokenAmount, address(0x0), tranEthAmount, contractAddress, offerPriceData.owner);
299         // Transfer fee
300         if (serviceCharge > 0) {
301             _abonus.switchToEth.value(serviceCharge)(address(_nestToken));
302         }
303     }
304     
305     /**
306     * @dev Withdraw the assets, and settle the mining
307     * @param contractAddress The offer address to withdraw
308     */
309     function turnOut(address contractAddress) public {
310         require(address(msg.sender) == address(tx.origin), "It can't be a contract");
311         uint256 index = toIndex(contractAddress);
312         Nest_3_OfferPriceData storage offerPriceData = _prices[index]; 
313         require(checkContractState(offerPriceData.blockNum) == 1, "Offer status error");
314         
315         // Withdraw ETH
316         if (offerPriceData.ethAmount > 0) {
317             uint256 payEth = offerPriceData.ethAmount;
318             offerPriceData.ethAmount = 0;
319             repayEth(offerPriceData.owner, payEth);
320         }
321         
322         // Withdraw erc20
323         if (offerPriceData.tokenAmount > 0) {
324             uint256 payErc = offerPriceData.tokenAmount;
325             offerPriceData.tokenAmount = 0;
326             ERC20(address(offerPriceData.tokenAddress)).safeTransfer(offerPriceData.owner, payErc);
327             
328         }
329         // Mining settlement
330         if (offerPriceData.serviceCharge > 0) {
331             uint256 myMiningAmount = offerPriceData.serviceCharge.mul(_offerBlockMining[offerPriceData.blockNum]).div(_offerBlockEth[offerPriceData.blockNum]);
332             _nestToken.safeTransfer(offerPriceData.owner, myMiningAmount);
333             offerPriceData.serviceCharge = 0;
334         }
335         
336     }
337     
338     // Convert offer address into index in offer array
339     function toIndex(address contractAddress) public pure returns(uint256) {
340         return uint256(contractAddress);
341     }
342     
343     // Convert index in offer array into offer address 
344     function toAddress(uint256 index) public pure returns(address) {
345         return address(index);
346     }
347     
348     // View contract state
349     function checkContractState(uint256 createBlock) public view returns (uint256) {
350         if (block.number.sub(createBlock) > _blockLimit) {
351             return 1;
352         }
353         return 0;
354     }
355 
356     // Compare the order price
357     function comparativePrice(uint256 myEthValue, uint256 myTokenValue, address token) private view returns(bool) {
358         (uint256 frontEthValue, uint256 frontTokenValue) = _offerPrice.updateAndCheckPricePrivate(token);
359         if (frontEthValue == 0 || frontTokenValue == 0) {
360             return false;
361         }
362         uint256 maxTokenAmount = myEthValue.mul(frontTokenValue).mul(uint256(100).add(_deviate)).div(frontEthValue.mul(100));
363         if (myTokenValue <= maxTokenAmount) {
364             uint256 minTokenAmount = myEthValue.mul(frontTokenValue).mul(uint256(100).sub(_deviate)).div(frontEthValue.mul(100));
365             if (myTokenValue >= minTokenAmount) {
366                 return false;
367             }
368         }
369         return true;
370     }
371     
372     // Transfer ETH
373     function repayEth(address accountAddress, uint256 asset) private {
374         address payable addr = accountAddress.make_payable();
375         addr.transfer(asset);
376     }
377     
378     // View the upper limit of the block interval
379     function checkBlockLimit() public view returns(uint32) {
380         return _blockLimit;
381     }
382     
383     // View offering mining fee ratio
384     function checkMiningETH() public view returns (uint256) {
385         return _miningETH;
386     }
387     
388     // View whether the token is allowed to mine
389     function checkTokenAllow(address token) public view returns(bool) {
390         return _tokenAllow[token];
391     }
392     
393     // View additional transaction multiple
394     function checkTranAddition() public view returns(uint256) {
395         return _tranAddition;
396     }
397     
398     // View the development allocation ratio
399     function checkCoderAmount() public view returns(uint256) {
400         return _coderAmount;
401     }
402     
403     // View the NestNode allocation ratio
404     function checkNNAmount() public view returns(uint256) {
405         return _NNAmount;
406     }
407     
408     // View the least offering ETH 
409     function checkleastEth() public view returns(uint256) {
410         return _leastEth;
411     }
412     
413     // View offering ETH span
414     function checkOfferSpan() public view returns(uint256) {
415         return _offerSpan;
416     }
417     
418     // View the price deviation
419     function checkDeviate() public view returns(uint256){
420         return _deviate;
421     }
422     
423     // View deviation from scale
424     function checkDeviationFromScale() public view returns(uint256) {
425         return _deviationFromScale;
426     }
427     
428     // View block offer fee
429     function checkOfferBlockEth(uint256 blockNum) public view returns(uint256) {
430         return _offerBlockEth[blockNum];
431     }
432     
433     // View taker order fee ratio
434     function checkTranEth() public view returns (uint256) {
435         return _tranEth;
436     }
437     
438     // View block mining amount of user
439     function checkOfferBlockMining(uint256 blockNum) public view returns(uint256) {
440         return _offerBlockMining[blockNum];
441     }
442 
443     // View offer mining amount
444     function checkOfferMining(uint256 blockNum, uint256 serviceCharge) public view returns (uint256) {
445         if (serviceCharge == 0) {
446             return 0;
447         } else {
448             return _offerBlockMining[blockNum].mul(serviceCharge).div(_offerBlockEth[blockNum]);
449         }
450     }
451     
452     // Change offering mining fee ratio
453     function changeMiningETH(uint256 num) public onlyOwner {
454         _miningETH = num;
455     }
456     
457     // Modify taker fee ratio
458     function changeTranEth(uint256 num) public onlyOwner {
459         _tranEth = num;
460     }
461     
462     // Modify the upper limit of the block interval
463     function changeBlockLimit(uint32 num) public onlyOwner {
464         _blockLimit = num;
465     }
466     
467     // Modify whether the token allows mining
468     function changeTokenAllow(address token, bool allow) public onlyOwner {
469         _tokenAllow[token] = allow;
470     }
471     
472     // Modify additional transaction multiple
473     function changeTranAddition(uint256 num) public onlyOwner {
474         require(num > 0, "Parameter needs to be greater than 0");
475         _tranAddition = num;
476     }
477     
478     // Modify the initial allocation ratio
479     function changeInitialRatio(uint256 coderNum, uint256 NNNum) public onlyOwner {
480         require(coderNum.add(NNNum) <= 100, "User allocation ratio error");
481         _coderAmount = coderNum;
482         _NNAmount = NNNum;
483     }
484     
485     // Modify the minimum offering ETH
486     function changeLeastEth(uint256 num) public onlyOwner {
487         require(num > 0);
488         _leastEth = num;
489     }
490     
491     //  Modify the offering ETH span
492     function changeOfferSpan(uint256 num) public onlyOwner {
493         require(num > 0);
494         _offerSpan = num;
495     }
496     
497     // Modify the price deviation
498     function changekDeviate(uint256 num) public onlyOwner {
499         _deviate = num;
500     }
501     
502     // Modify the deviation from scale 
503     function changeDeviationFromScale(uint256 num) public onlyOwner {
504         _deviationFromScale = num;
505     }
506     
507     /**
508      * Get the number of offers stored in the offer array
509      * @return The number of offers stored in the offer array
510      **/
511     function getPriceCount() view public returns (uint256) {
512         return _prices.length;
513     }
514     
515     /**
516      * Get offer information according to the index
517      * @param priceIndex Offer index
518      * @return Offer information
519      **/
520     function getPrice(uint256 priceIndex) view public returns (string memory) {
521         // The buffer array used to generate the result string
522         bytes memory buf = new bytes(500000);
523         uint256 index = 0;
524         
525         index = writeOfferPriceData(priceIndex, _prices[priceIndex], buf, index);
526         
527         //  Generate the result string and return
528         bytes memory str = new bytes(index);
529         while(index-- > 0) {
530             str[index] = buf[index];
531         }
532         return string(str);
533     }
534     
535     /**
536      * Search the contract address list of the target account (reverse order)
537      * @param start Search forward from the index corresponding to the given contract address (not including the record corresponding to start address)
538      * @param count Maximum number of records to return
539      * @param maxFindCount The max index to search
540      * @param owner Target account address
541      * @return Separate the offer records with symbols. use , to divide fields: 
542      * uuid,owner,tokenAddress,ethAmount,tokenAmount,dealEthAmount,dealTokenAmount,blockNum,serviceCharge
543      **/
544     function find(address start, uint256 count, uint256 maxFindCount, address owner) view public returns (string memory) {
545         
546         // Buffer array used to generate result string
547         bytes memory buf = new bytes(500000);
548         uint256 index = 0;
549         
550         // Calculate search interval i and end
551         uint256 i = _prices.length;
552         uint256 end = 0;
553         if (start != address(0)) {
554             i = toIndex(start);
555         }
556         if (i > maxFindCount) {
557             end = i - maxFindCount;
558         }
559         
560         // Loop search, write qualified records into buffer
561         while (count > 0 && i-- > end) {
562             Nest_3_OfferPriceData memory price = _prices[i];
563             if (price.owner == owner) {
564                 --count;
565                 index = writeOfferPriceData(i, price, buf, index);
566             }
567         }
568         
569         // Generate result string and return
570         bytes memory str = new bytes(index);
571         while(index-- > 0) {
572             str[index] = buf[index];
573         }
574         return string(str);
575     }
576     
577     /**
578      * Get the list of offers by page
579      * @param offset Skip the first offset records
580      * @param count Maximum number of records to return
581      * @param order Sort rules. 0 means reverse order, non-zero means positive order
582      * @return Separate the offer records with symbols. use , to divide fields: 
583      * uuid,owner,tokenAddress,ethAmount,tokenAmount,dealEthAmount,dealTokenAmount,blockNum,serviceCharge
584      **/
585     function list(uint256 offset, uint256 count, uint256 order) view public returns (string memory) {
586         
587         // Buffer array used to generate result string
588         bytes memory buf = new bytes(500000);
589         uint256 index = 0;
590         
591         // Find search interval i and end
592         uint256 i = 0;
593         uint256 end = 0;
594         
595         if (order == 0) {
596             // Reverse order, in default 
597             // Calculate search interval i and end
598             if (offset < _prices.length) {
599                 i = _prices.length - offset;
600             } 
601             if (count < i) {
602                 end = i - count;
603             }
604             
605             // Write records in the target interval into the buffer
606             while (i-- > end) {
607                 index = writeOfferPriceData(i, _prices[i], buf, index);
608             }
609         } else {
610             // Ascending order
611             // Calculate the search interval i and end
612             if (offset < _prices.length) {
613                 i = offset;
614             } else {
615                 i = _prices.length;
616             }
617             end = i + count;
618             if(end > _prices.length) {
619                 end = _prices.length;
620             }
621             
622             // Write the records in the target interval into the buffer
623             while (i < end) {
624                 index = writeOfferPriceData(i, _prices[i], buf, index);
625                 ++i;
626             }
627         }
628         
629         // Generate the result string and return
630         bytes memory str = new bytes(index);
631         while(index-- > 0) {
632             str[index] = buf[index];
633         }
634         return string(str);
635     }   
636      
637     // Write the offer data into the buffer and return the buffer index
638     function writeOfferPriceData(uint256 priceIndex, Nest_3_OfferPriceData memory price, bytes memory buf, uint256 index) pure private returns (uint256) {
639         index = writeAddress(toAddress(priceIndex), buf, index);
640         buf[index++] = byte(uint8(44));
641         
642         index = writeAddress(price.owner, buf, index);
643         buf[index++] = byte(uint8(44));
644         
645         index = writeAddress(price.tokenAddress, buf, index);
646         buf[index++] = byte(uint8(44));
647         
648         index = writeUInt(price.ethAmount, buf, index);
649         buf[index++] = byte(uint8(44));
650         
651         index = writeUInt(price.tokenAmount, buf, index);
652         buf[index++] = byte(uint8(44));
653        
654         index = writeUInt(price.dealEthAmount, buf, index);
655         buf[index++] = byte(uint8(44));
656         
657         index = writeUInt(price.dealTokenAmount, buf, index);
658         buf[index++] = byte(uint8(44));
659         
660         index = writeUInt(price.blockNum, buf, index);
661         buf[index++] = byte(uint8(44));
662         
663         index = writeUInt(price.serviceCharge, buf, index);
664         buf[index++] = byte(uint8(44));
665         
666         return index;
667     }
668      
669     // Convert integer to string in decimal form and write it into the buffer, and return the buffer index
670     function writeUInt(uint256 iv, bytes memory buf, uint256 index) pure public returns (uint256) {
671         uint256 i = index;
672         do {
673             buf[index++] = byte(uint8(iv % 10 +48));
674             iv /= 10;
675         } while (iv > 0);
676         
677         for (uint256 j = index; j > i; ++i) {
678             byte t = buf[i];
679             buf[i] = buf[--j];
680             buf[j] = t;
681         }
682         
683         return index;
684     }
685 
686     // Convert the address to a hexadecimal string and write it into the buffer, and return the buffer index
687     function writeAddress(address addr, bytes memory buf, uint256 index) pure private returns (uint256) {
688         
689         uint256 iv = uint256(addr);
690         uint256 i = index + 40;
691         do {
692             uint256 w = iv % 16;
693             if(w < 10) {
694                 buf[index++] = byte(uint8(w +48));
695             } else {
696                 buf[index++] = byte(uint8(w +87));
697             }
698             
699             iv /= 16;
700         } while (index < i);
701         
702         i -= 40;
703         for (uint256 j = index; j > i; ++i) {
704             byte t = buf[i];
705             buf[i] = buf[--j];
706             buf[j] = t;
707         }
708         
709         return index;
710     }
711     
712     // Vote administrator only
713     modifier onlyOwner(){
714         require(_voteFactory.checkOwners(msg.sender), "No authority");
715         _;
716     }
717 }
718 
719 // NestNode assignment contract
720 interface Nest_NodeAssignment {
721     function bookKeeping(uint256 amount) external;
722 }
723 
724 // Mining pool logic
725 interface Nest_3_MiningContract {
726     // Offering mining
727     function oreDrawing() external returns (uint256);
728 }
729 
730 // Voting contract
731 interface Nest_3_VoteFactory {
732     // Check address
733 	function checkAddress(string calldata name) external view returns (address contractAddress);
734 	// Check whether administrator
735 	function checkOwners(address man) external view returns (bool);
736 }
737 
738 // Price contract
739 interface Nest_3_OfferPrice {
740     function addPrice(uint256 ethAmount, uint256 tokenAmount, uint256 endBlock, address tokenAddress, address offerOwner) external;
741     function changePrice(uint256 ethAmount, uint256 tokenAmount, address tokenAddress, uint256 endBlock) external;
742     function updateAndCheckPricePrivate(address tokenAddress) external view returns(uint256 ethAmount, uint256 erc20Amount);
743 }
744 
745 // Bonus pool contract
746 interface Nest_3_Abonus {
747     function switchToEth(address token) external payable;
748 }
749 
750 
751 library SafeMath {
752     function add(uint256 a, uint256 b) internal pure returns (uint256) {
753         uint256 c = a + b;
754         require(c >= a, "SafeMath: addition overflow");
755 
756         return c;
757     }
758     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
759         return sub(a, b, "SafeMath: subtraction overflow");
760     }
761     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
762         require(b <= a, errorMessage);
763         uint256 c = a - b;
764 
765         return c;
766     }
767     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
768         if (a == 0) {
769             return 0;
770         }
771         uint256 c = a * b;
772         require(c / a == b, "SafeMath: multiplication overflow");
773 
774         return c;
775     }
776     function div(uint256 a, uint256 b) internal pure returns (uint256) {
777         return div(a, b, "SafeMath: division by zero");
778     }
779     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
780         require(b > 0, errorMessage);
781         uint256 c = a / b;
782         return c;
783     }
784     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
785         return mod(a, b, "SafeMath: modulo by zero");
786     }
787     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
788         require(b != 0, errorMessage);
789         return a % b;
790     }
791 }
792 
793 library address_make_payable {
794    function make_payable(address x) internal pure returns (address payable) {
795       return address(uint160(x));
796    }
797 }
798 
799 library SafeERC20 {
800     using SafeMath for uint256;
801     using Address for address;
802 
803     function safeTransfer(ERC20 token, address to, uint256 value) internal {
804         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
805     }
806 
807     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
808         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
809     }
810 
811     function safeApprove(ERC20 token, address spender, uint256 value) internal {
812         require((value == 0) || (token.allowance(address(this), spender) == 0),
813             "SafeERC20: approve from non-zero to non-zero allowance"
814         );
815         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
816     }
817 
818     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
819         uint256 newAllowance = token.allowance(address(this), spender).add(value);
820         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
821     }
822 
823     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
824         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
825         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
826     }
827     function callOptionalReturn(ERC20 token, bytes memory data) private {
828         require(address(token).isContract(), "SafeERC20: call to non-contract");
829         (bool success, bytes memory returndata) = address(token).call(data);
830         require(success, "SafeERC20: low-level call failed");
831         if (returndata.length > 0) {
832             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
833         }
834     }
835 }
836 
837 interface ERC20 {
838     function totalSupply() external view returns (uint256);
839     function balanceOf(address account) external view returns (uint256);
840     function transfer(address recipient, uint256 amount) external returns (bool);
841     function allowance(address owner, address spender) external view returns (uint256);
842     function approve(address spender, uint256 amount) external returns (bool);
843     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
844     event Transfer(address indexed from, address indexed to, uint256 value);
845     event Approval(address indexed owner, address indexed spender, uint256 value);
846 }
847 
848 library Address {
849     function isContract(address account) internal view returns (bool) {
850         bytes32 codehash;
851         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
852         assembly { codehash := extcodehash(account) }
853         return (codehash != accountHash && codehash != 0x0);
854     }
855     function sendValue(address payable recipient, uint256 amount) internal {
856         require(address(this).balance >= amount, "Address: insufficient balance");
857         (bool success, ) = recipient.call.value(amount)("");
858         require(success, "Address: unable to send value, recipient may have reverted");
859     }
860 }