1 pragma solidity 0.6.2;
2 
3 
4 
5 /**
6  * @dev The contract has an owner address, and provides basic authorization control whitch
7  * simplifies the implementation of user permissions. This contract is based on the source code at:
8  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
9  */
10 contract Ownable
11 {
12 
13   /**
14    * @dev Error constants.
15    */
16   string public constant NOT_CURRENT_OWNER = "018001";
17   string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
18 
19   /**
20    * @dev Current owner address.
21    */
22   address public owner;
23 
24   /**
25    * @dev An event which is triggered when the owner is changed.
26    * @param previousOwner The address of the previous owner.
27    * @param newOwner The address of the new owner.
28    */
29   event OwnershipTransferred(
30     address indexed previousOwner,
31     address indexed newOwner
32   );
33 
34   /**
35    * @dev The constructor sets the original `owner` of the contract to the sender account.
36    */
37   constructor()
38     public
39   {
40     owner = msg.sender;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner()
47   {
48     require(msg.sender == owner, NOT_CURRENT_OWNER);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(
57     address _newOwner
58   )
59     public
60     onlyOwner
61   {
62     require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 
67 }
68 
69 
70 
71 /**
72  * @dev Math operations with safety checks that throw on error. This contract is based on the
73  * source code at:
74  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
75  */
76 library SafeMath
77 {
78   /**
79    * List of revert message codes. Implementing dApp should handle showing the correct message.
80    * Based on 0xcert framework error codes.
81    */
82   string constant OVERFLOW = "008001";
83   string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
84   string constant DIVISION_BY_ZERO = "008003";
85 
86   /**
87    * @dev Multiplies two numbers, reverts on overflow.
88    * @param _factor1 Factor number.
89    * @param _factor2 Factor number.
90    * @return product The product of the two factors.
91    */
92   function mul(
93     uint256 _factor1,
94     uint256 _factor2
95   )
96     internal
97     pure
98     returns (uint256 product)
99   {
100     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101     // benefit is lost if 'b' is also tested.
102     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
103     if (_factor1 == 0)
104     {
105       return 0;
106     }
107 
108     product = _factor1 * _factor2;
109     require(product / _factor1 == _factor2, OVERFLOW);
110   }
111 
112   /**
113    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
114    * @param _dividend Dividend number.
115    * @param _divisor Divisor number.
116    * @return quotient The quotient.
117    */
118   function div(
119     uint256 _dividend,
120     uint256 _divisor
121   )
122     internal
123     pure
124     returns (uint256 quotient)
125   {
126     // Solidity automatically asserts when dividing by 0, using all gas.
127     require(_divisor > 0, DIVISION_BY_ZERO);
128     quotient = _dividend / _divisor;
129     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
130   }
131 
132   /**
133    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
134    * @param _minuend Minuend number.
135    * @param _subtrahend Subtrahend number.
136    * @return difference Difference.
137    */
138   function sub(
139     uint256 _minuend,
140     uint256 _subtrahend
141   )
142     internal
143     pure
144     returns (uint256 difference)
145   {
146     require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
147     difference = _minuend - _subtrahend;
148   }
149 
150   /**
151    * @dev Adds two numbers, reverts on overflow.
152    * @param _addend1 Number.
153    * @param _addend2 Number.
154    * @return sum Sum.
155    */
156   function add(
157     uint256 _addend1,
158     uint256 _addend2
159   )
160     internal
161     pure
162     returns (uint256 sum)
163   {
164     sum = _addend1 + _addend2;
165     require(sum >= _addend1, OVERFLOW);
166   }
167 
168   /**
169     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
170     * dividing by zero.
171     * @param _dividend Number.
172     * @param _divisor Number.
173     * @return remainder Remainder.
174     */
175   function mod(
176     uint256 _dividend,
177     uint256 _divisor
178   )
179     internal
180     pure
181     returns (uint256 remainder)
182   {
183     require(_divisor != 0, DIVISION_BY_ZERO);
184     remainder = _dividend % _divisor;
185   }
186 
187 }
188 
189 
190 /**
191  * @dev signature of external (deployed) contract (ERC20 token)
192  * only methods we will use, needed for us to communicate with CYTR token (which is ERC20)
193  */
194 contract ERC20Token {
195  
196     function totalSupply() external view returns (uint256){}
197     function balanceOf(address account) external view returns (uint256){}
198     function allowance(address owner, address spender) external view returns (uint256){}
199     function transfer(address recipient, uint256 amount) external returns (bool){}
200     function approve(address spender, uint256 amount) external returns (bool){}
201     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){}
202     function decimals()  external view returns (uint8){}
203   
204 }
205 
206 
207 
208 /**
209  * @dev signature of external (deployed) contract for NFT publishing (ERC721)
210  * only methods we will use, needed for us to communicate with Cyclops token (which is ERC721)
211  */
212 contract CyclopsTokens {
213     
214  
215  
216  function mint(address _to, uint256 _tokenId, string calldata _uri) external {}
217  
218  function ownerOf(uint256 _tokenId) external view returns (address) {}
219  function burn(uint256 _tokenId) external {}
220  
221  function tokenURI(uint256 _tokenId) external  view returns(string memory) {}
222     
223 }
224 
225 contract NFTMarketplace is
226   Ownable
227 {
228     using SafeMath for uint256;    
229     
230      modifier onlyPriceManager() {
231       require(
232           msg.sender == price_manager,
233           "only price manager can call this function"
234           );
235           _;
236     }
237     
238     modifier onlyOwnerOrPriceManager() {
239       require(
240           msg.sender == price_manager || msg.sender == owner,
241           "only price manager or owner can call this function"
242           );
243           _;
244     }
245  
246     /**
247     * @dev not bullet-proof check, but additional measure, actually we require specific (contract) address,
248     * which is key (see onlyBankContract)
249     */
250     function isContract(address _addr) internal view returns (bool){
251       uint32 size;
252       assembly {
253           size := extcodesize(_addr)
254       }
255     
256       return (size > 0);
257     }
258 
259     modifier notContract(){
260       require(
261           (!isContract(msg.sender)),
262           "external contracts are not allowed"
263           );
264           _;
265     }
266 
267  
268     
269   //external NFT publishing contract
270   CyclopsTokens nftContract;
271   ERC20Token token; //CYTR
272   
273   //hard code address of external contract (NFT), as it can't be redeployed in production
274   //what could be redeployed - NFTBank contract -  and we can link new NFT bank 
275   //with special method in CyclopsTokens
276   address nftContractAddress = 0xd6d778d86Ddf225e3c02C45D6C6e8Eb3497B452A; //NFT contract (Cyclops)
277   address paymentTokenAddress = 0xBD05CeE8741100010D8E93048a80Ed77645ac7bf; //payment token (ERC20, CYTR)
278   
279   address price_manager = 0x0000000000000000000000000000000000000000;
280   
281   bool internal_prices = true;
282   uint256 price_curve = 5; //5%
283   
284   uint32 constant BAD_NFT_PROFILE_ID = 9999999;
285   uint256 constant BAD_PRICE = 0;
286   string constant BAD_URL = '';
287   uint32 constant UNLIMITED = 9999999;
288   
289   /**
290    * @dev 'database' to store profiles of NFTs
291    */
292   struct NFTProfile{
293       uint32 id;
294       uint256 price; //in CYTR, i.e. 1,678 CYTR last 18 digits are decimals
295       uint256 sell_price; //in CYTR i.e. 1,678 CYTR last 18 digits are decimals
296       string url;
297       uint32 limit;
298   }
299   
300   NFTProfile[] public nftProfiles;
301   
302   uint256 next_token_id = 10;
303 
304    /**
305    * @dev Events
306    */
307     //buy from us
308     event Minted(uint32 profileID, uint256 tokenId, address wallet, uint256 cytrAmount, uint256 priceAtMoment);
309     
310     //intermediate event for support of broken buy (CYTR transferred but NFT was not minted) 
311     // - for manual resolution from admin panel
312     event GotCYTRForNFT(uint32 profileID, address wallet, uint256 cytrAmount, uint256 priceAtMoment);
313     
314     //intermediate event for support of broken sell (CYTR transferred back NFT was not burned) 
315     // - for manual resolution from admin panel
316     event SendCYTRForNFT(uint32 profileID, address wallet, uint256 cytrAmount, uint256 buybackPriceAtMoment);
317     
318     //buy back from user
319     event Burned(uint32 profileID, uint256 tokenId, address wallet, uint256 cytrAmount, uint256 buybackPriceAtMoment);
320     
321     //admin events - CYTR tokens/ether deposit/withdrawal
322     event TokensDeposited(uint256 amount, address wallet);
323     event FinneyDeposited(uint256 amount, address wallet);
324     event Withdrawn(uint256 amount, address wallet);
325     event TokensWithdrawn(uint256 amount, address wallet);
326     event AdminMinted(uint32 profileID, uint256 tokenId, address wallet, uint256 curPrice); 
327     event AdminBurned(uint256 _tokenId,uint32 tokenProfileId, uint256 curSellPrice); 
328 
329   /**
330    * @dev Contract constructor.
331    */
332   constructor()
333     public
334   {
335      price_manager = owner;
336      nftContract = CyclopsTokens(nftContractAddress);   //NFT minting interface
337      token = ERC20Token(paymentTokenAddress);           //CYTR interface
338   }
339     
340     function setPriceManagerRight(address newPriceManager) external onlyOwner{
341           price_manager = newPriceManager;
342     }
343       
344     
345     function getPriceManager() public view returns(address){
346         return price_manager;
347     }
348 
349     function setInternalPriceCurve() external onlyOwnerOrPriceManager{
350           internal_prices = true;
351     }
352     
353     function setExternalPriceCurve() external onlyOwnerOrPriceManager{
354           internal_prices = false;
355     }
356       
357     function isPriceCurveInternal() public view returns(bool){
358         return internal_prices;
359     }
360       
361     function setPriceCurve(uint256 new_curve) external onlyOwnerOrPriceManager{
362           price_curve = new_curve;
363     }
364       
365     
366     function getPriceCurve() public view returns(uint256){
367         return price_curve;
368     }
369     
370     
371     /**
372     * @dev setter/getter for ERC20 linked to exchange (current) smartcontract
373     */
374     function setPaymentToken(address newERC20Contract) external onlyOwner returns(bool){
375     
376         paymentTokenAddress = newERC20Contract;
377         token = ERC20Token(paymentTokenAddress);
378     }
379     
380     
381     function getPaymentToken() external view returns(address){
382         return paymentTokenAddress;
383     }
384     
385     
386     
387     /**
388     * @dev setter/getter for NFT publisher linked to 'marketplace' smartcontract
389     */
390     function setNFTContract(address newNFTContract) external onlyOwner returns(bool){
391     
392         nftContractAddress = newNFTContract;
393         nftContract = CyclopsTokens(nftContractAddress);
394     }
395     
396     
397     function getNFTContract() external view returns(address){
398         return nftContractAddress;
399     }
400 
401 
402 
403   /**
404    * @dev getter for next_token_id
405    */
406   function getNextTokenId() external  view returns (uint256){
407       return next_token_id;
408   }
409   
410    /**
411    * @dev setter for next_token_id
412    */
413   function setNextTokenId(uint32 setId) external onlyOwnerOrPriceManager (){
414       next_token_id = setId;
415   }
416   
417   /**
418    * @dev adds 'record' to 'database'
419    * @param id, unique id of profiles
420    * @param price, price of NFT assets which will be generated based on profile
421    * @param sell_price, when we will buy out from owner (burn)
422    * @param url, url of NFT assets which will be generated based on profile
423    */
424   function addNFTProfile(uint32 id, uint256 price, uint256 sell_price, string calldata url, uint32 limit) external onlyOwnerOrPriceManager {
425       NFTProfile memory temp = NFTProfile(id,price,sell_price,url, limit);
426       nftProfiles.push(temp);
427   }
428   
429   
430   
431   /**
432    * @dev removes 'record' to 'database'
433    * @param id (profile id)
434    *
435    */
436   function removeNFTProfileAtId(uint32 id) external onlyOwnerOrPriceManager {
437      for (uint32 i = 0; i < nftProfiles.length; i++){
438           if (nftProfiles[i].id == id){
439               removeNFTProfileAtIndex(i);      
440               return;
441           }
442      }
443   }
444   
445   
446   
447   /**
448    * @dev removes 'record' to 'database'
449    * @param index, record number (from 0)
450    *
451    */
452   function removeNFTProfileAtIndex(uint32 index) internal {
453      if (index >= nftProfiles.length) return;
454      if (index == nftProfiles.length -1){
455          nftProfiles.pop();
456      } else {
457          for (uint i = index; i < nftProfiles.length-1; i++){
458              nftProfiles[i] = nftProfiles[i+1];
459          }
460          nftProfiles.pop();
461      }
462   }
463   
464   
465   
466   /**
467    * @dev replaces 'record' in the 'database'
468    * @param id, unique id of profile
469    * @param price, price of NFT assets which will be generated based on profile
470    * @param sell_price, sell price (back to owner) of NFT assets when owner sell to us (and we burn)
471    * @param url, url of NFT assets which will be generated based on profile
472    */
473   function replaceNFTProfileAtId(uint32 id, uint256 price, uint256 sell_price, string calldata url, uint32 limit) external onlyOwnerOrPriceManager {
474      for (uint i = 0; i < nftProfiles.length; i++){
475           if (nftProfiles[i].id == id){
476               nftProfiles[i].price = price;
477               nftProfiles[i].sell_price = sell_price;
478               nftProfiles[i].url = url;
479               nftProfiles[i].limit = limit;
480               return;
481           }
482      }
483   }
484   
485   
486   /**
487    * @dev replaces 'record' in the 'database'
488    * @param atIndex, at which row of array to make replacement
489    * @param id, unique id of profiles
490    * @param price, price of NFT assets which will be generated based on profile
491    * @param sell_price, sell price (back to owner) of NFT assets when owner sell to us (and we burn)
492    * @param url, url of NFT assets which will be generated based on profile
493    */
494   function replaceNFTProfileAtIndex(uint32 atIndex, uint32 id, uint256 price, uint256 sell_price, string calldata url, uint32 limit) external onlyOwnerOrPriceManager  {
495      nftProfiles[atIndex].id = id;
496      nftProfiles[atIndex].price = price;
497      nftProfiles[atIndex].sell_price = sell_price;
498      nftProfiles[atIndex].url = url;
499      nftProfiles[atIndex].limit = limit;
500   }
501   
502     /**
503    * @dev return array of strings is not supported by solidity, we return ids & prices
504    */
505   function viewNFTProfilesPrices() external view returns( uint32[] memory, uint256[] memory, uint256[] memory){
506       uint32[] memory ids = new uint32[](nftProfiles.length);
507       uint256[] memory prices = new uint256[](nftProfiles.length);
508       uint256[] memory sell_prices = new uint256[](nftProfiles.length);
509       for (uint i = 0; i < nftProfiles.length; i++){
510           ids[i] = nftProfiles[i].id;
511           prices[i] = nftProfiles[i].price;
512           sell_prices[i] = nftProfiles[i].sell_price;
513       }
514       return (ids, prices, sell_prices);
515   }
516   
517   
518    /**
519    * @dev return price, sell_price & url for profile by id
520    */
521   function viewNFTProfileDetails(uint32 id) external view returns(uint256, uint256, string memory, uint32){
522      for (uint i = 0; i < nftProfiles.length; i++){
523           if (nftProfiles[i].id == id){
524               return (nftProfiles[i].price, nftProfiles[i].sell_price, nftProfiles[i].url, nftProfiles[i].limit);     
525           }
526      }
527      return (BAD_PRICE, BAD_PRICE, BAD_URL, UNLIMITED);
528   }
529   
530   /**
531    * @dev get price by id from 'database'
532    * @param id, unique id of profiles
533    */
534   function getPriceById(uint32 id) public  view returns (uint256){
535       for (uint i = 0; i < nftProfiles.length; i++){
536           if (nftProfiles[i].id == id){
537               return nftProfiles[i].price;
538           }
539       }
540       return BAD_PRICE;
541   }
542   
543   
544  
545   
546   /**
547    * @dev get sell price by id from 'database'
548    * @param id, unique id of profiles
549    */
550   function getSellPriceById(uint32 id) public  view returns (uint256){
551       for (uint i = 0; i < nftProfiles.length; i++){
552           if (nftProfiles[i].id == id){
553               return nftProfiles[i].sell_price;
554           }
555       }
556       return BAD_PRICE;
557   }
558   
559    /**
560    * @dev set new price for asset (profile of NFT), price for which customer can buy
561    * @param id, unique id of profiles
562    */
563   function setPriceById(uint32 id, uint256 new_price) external onlyOwnerOrPriceManager{
564       for (uint i = 0; i < nftProfiles.length; i++){
565           if (nftProfiles[i].id == id){
566               nftProfiles[i].price = new_price;
567               return;
568           }
569       }
570   }
571   
572    /**
573    * @dev set new sell (buy back) price for asset (profile of NFT), 
574    * price for which customer can sell to us
575    * @param id, unique id of profiles
576    */
577   function setSellPriceById(uint32 id, uint256 new_price) external onlyOwnerOrPriceManager{
578       for (uint i = 0; i < nftProfiles.length; i++){
579           if (nftProfiles[i].id == id){
580               nftProfiles[i].sell_price = new_price;
581               return;
582           }
583       }
584   }
585   
586   // for optimization, funciton to update both prices
587   function updatePricesById(uint32 id, uint256 new_price, uint256 new_sell_price) external onlyOwnerOrPriceManager{
588       for (uint i = 0; i < nftProfiles.length; i++){
589           if (nftProfiles[i].id == id){
590               nftProfiles[i].price = new_price;
591               nftProfiles[i].sell_price = new_sell_price;
592               return;
593           }
594       }
595   }
596   
597  
598   
599   /**
600    * @dev get url by id from 'database'
601    * @param id, unique id of profiles
602    */ 
603   function  getUrlById(uint32 id) public view returns (string memory){
604       for (uint i = 0; i < nftProfiles.length; i++){
605           if (nftProfiles[i].id == id){
606               return nftProfiles[i].url;
607           }
608       }
609       return BAD_URL;
610   }
611   
612   function  getLimitById(uint32 id) public view returns (uint32){
613       for (uint i = 0; i < nftProfiles.length; i++){
614           if (nftProfiles[i].id == id){
615              return nftProfiles[i].limit;
616           }
617       }
618       return UNLIMITED;
619   }
620   
621    
622   /**
623    * @dev accepts payment only in CYTR(!) for mint NFT & calls external contract
624    * it is public function, i.e called by buyer via dApp
625    * buyer selects profile (profileID), provides own wallet address (_to)
626    * and dApp provides available _tokenId (for flexibility its calculation is not automatic on 
627    * smart contract level, but it is possible to implement) - > nftContract.totalSupply()+1
628    * why not recommended: outsite of smart contract with multiple simultaneous customers we can 
629    * instanteneusly on level of backend determinte next free id.
630    * on CyclopsTokens smartcontract level it can be only calculated correctly after mint transaction is confirmed
631    * here utility function is implemented which is used by backend ,getNextTokenId()
632    * it is also possible to use setNextTokenId function (by owner) to reset token id if needed
633    * normal use is dApp requests next token id (tid = getNextTokenId()) and after that
634    * calls publicMint(profile, to, tid)
635    * it allows different dApps use different token ids areas
636    * like   dapp1: tid = getNextTokenId() + 10000
637    *        dapp2: tid = getNextTokenId() + 20000
638    */
639   function buyNFT(          //'buy' == mint NFT token function, provides NFT token in exchange of CYTR    
640     uint32 profileID,       //id of NFT profile
641     uint256 cytrAmount,     //amount of CYTR we check it is equal to price, amount in real form i.e. 18 decimals
642     address _to,            //where to deliver 
643     uint256 _tokenId        //with which id NFT will be generated
644   ) 
645     external 
646     notContract 
647     returns (uint256)
648   {
649     require (getLimitById(profileID) > 0,"limit is over");
650     
651     uint256 curPrice = getPriceById(profileID);
652     require(curPrice != BAD_PRICE, "price for NFT profile not found");
653     require(cytrAmount > 0, "You need to provide some CYTR"); //it is already in 'real' form, i.e. with decimals
654     
655     require(cytrAmount == curPrice); //correct work (i.e. dApp calculated price correctly)
656     
657     uint256 token_bal = token.balanceOf(msg.sender); //how much CYTR buyer has
658     
659     require(token_bal >= cytrAmount, "Check the CYTR balance on your wallet"); //is it enough
660     
661     uint256 allowance = token.allowance(msg.sender, address(this));
662     
663     require(allowance >= cytrAmount, "Check the CYTR allowance"); //is allowance provided
664     
665     require(isFreeTokenId(_tokenId), "token id is is occupied"); //adjust on calling party
666 
667     //ensure we revert in case of failure
668     try token.transferFrom(msg.sender, address(this), cytrAmount) { // get CYTR from buyer
669         emit GotCYTRForNFT(profileID, msg.sender, cytrAmount, curPrice);
670     } catch {
671         require(false,"CYTR transfer failed");
672         return 0; 
673     }
674   
675    
676     //external contract mint
677     try nftContract.mint(_to,_tokenId, getUrlById(profileID)){
678         next_token_id++;
679         //we should have event pairs GotCYTRForNFT - Minted if all good
680         emit Minted(profileID, _tokenId, msg.sender, cytrAmount, curPrice); 
681     } catch {
682         //return payment by using require..it should revert transaction 
683         require(false,"mint failed");
684     }
685     
686     for (uint i = 0; i < nftProfiles.length; i++){
687       if (nftProfiles[i].id == profileID){
688           if (nftProfiles[i].limit != UNLIMITED) nftProfiles[i].limit--;
689       }
690     }
691     
692     if (internal_prices){ //if we manage price curve internally
693         for (uint i = 0; i < nftProfiles.length; i++){
694           if (nftProfiles[i].id == profileID){
695               uint256 change = nftProfiles[i].price.div(100).mul(price_curve);
696               nftProfiles[i].price = nftProfiles[i].price.add(change);
697               change = nftProfiles[i].sell_price.div(100).mul(price_curve);
698               nftProfiles[i].sell_price = nftProfiles[i].sell_price.add(change);
699           }
700       }
701     }
702  
703     //return _tokenId; //success, return generated tokenId, works only if called by contract, i.e. not our case
704   }
705 
706  /**
707    * @dev method allows collectible owner to sell it back for sell price
708    * collectible is burned, amount of sell price returned to owner of collectible
709    * tokenId -> tokenProfileId -> sell price
710    */
711   function sellNFTBack(uint256 _tokenId) external notContract returns(uint256){ //'sell' == burn, burns and returns CYTR to user
712         require(nftContract.ownerOf(_tokenId) == msg.sender, "it is not your NFT");
713         uint32 tokenProfileId = getProfileIdByTokenId(_tokenId);
714         require(tokenProfileId != BAD_NFT_PROFILE_ID, "NFT profile ID not found");
715         uint256 sellPrice = getSellPriceById(tokenProfileId); 
716         require(sellPrice != BAD_PRICE, "NFT price not found");
717         
718         require(token.balanceOf(msg.sender) > sellPrice, "unsufficient CYTR on contract");
719         
720         try nftContract.burn(_tokenId) {
721             emit Burned(tokenProfileId, _tokenId, msg.sender, sellPrice, sellPrice); 
722         } catch {
723         //ensure error will be send (false, i.e. require is never fulfilled, error send)
724             require (false, "NFT burn failed");
725         }
726       
727         //ensure we revert in case of failure
728         try token.transfer(msg.sender,  sellPrice) { // send CYTR to seller
729             //just continue if all good..
730             emit SendCYTRForNFT(tokenProfileId, msg.sender, sellPrice, sellPrice);
731         } catch {
732             require(false,"CYTR transfer failed");
733             return 0; 
734         }
735         
736         for (uint i = 0; i < nftProfiles.length; i++){
737           if (nftProfiles[i].id == tokenProfileId){
738               if (nftProfiles[i].limit != UNLIMITED) nftProfiles[i].limit++;
739           }
740         }
741        
742         if (internal_prices){ //if we manage price curve internally
743             for (uint i = 0; i < nftProfiles.length; i++){
744               if (nftProfiles[i].id == tokenProfileId){
745                   uint256 change = nftProfiles[i].price.div(100).mul(price_curve);
746                   nftProfiles[i].price = nftProfiles[i].price.sub(change);
747                   change = nftProfiles[i].sell_price.div(100).mul(price_curve);
748                   nftProfiles[i].sell_price = nftProfiles[i].sell_price.sub(change);
749               }
750             }
751         }
752   }
753   
754   
755   function adminMint(       //mint for free as admin
756     uint32 profileID,       //id of NFT profile
757     address _to,            //where to deliver 
758     uint256 _tokenId        //with which id NFT will be generated
759   ) 
760     external 
761     onlyOwnerOrPriceManager
762     returns (uint256)
763   {
764     uint256 curPrice = getPriceById(profileID);
765     require(curPrice != BAD_PRICE, "price for NFT profile not found");
766     require(isFreeTokenId(_tokenId), "token id is is occupied");
767   
768 
769     
770     //external contract mint
771     try nftContract.mint(_to,_tokenId, getUrlById(profileID)){
772         next_token_id++;
773         //we should have event pairs GotCYTRForNFT - Minted if all good
774         emit AdminMinted(profileID, _tokenId, _to, curPrice); 
775     } catch {
776         //return payment by using require..it should revert transaction 
777         require(false,"mint failed");
778     }
779     
780     return _tokenId; //success, return generated tokenId (works if called by another contract)
781   }
782 
783   
784   
785   function adminBurn(uint256 _tokenId) external  onlyOwnerOrPriceManager returns(uint256){  //burn as admin, without CYTR move
786 
787         uint32 tokenProfileId = getProfileIdByTokenId(_tokenId);
788         //require(tokenProfileId != BAD_NFT_PROFILE_ID, "NFT profile ID not found");
789         //in admin mode we do not require it
790         uint256 sellPrice = getSellPriceById(tokenProfileId); 
791         //require(sellPrice != BAD_PRICE, "NFT price not found");
792         //in admin mode we do not require it
793         
794         try nftContract.burn(_tokenId) {
795             emit AdminBurned(_tokenId, tokenProfileId, sellPrice); 
796         } catch {
797         //ensure error will be send (false, i.e. require is never fulfilled, error send)
798             require (false, "NFT burn failed");
799         }
800       
801   }
802   
803   
804   function getProfileIdByTokenId(uint256 tokenId) public view returns(uint32){
805       string memory url = BAD_URL;
806       try nftContract.tokenURI(tokenId) {
807         url = nftContract.tokenURI(tokenId);
808         return getProfileIdbyUrl(url);
809       } catch {
810         return BAD_NFT_PROFILE_ID;
811       }
812      
813   }
814   
815   function getProfileIdbyUrl(string memory url) public  view returns (uint32){
816       for (uint i = 0; i < nftProfiles.length; i++){
817           if (keccak256(bytes(nftProfiles[i].url)) == keccak256(bytes(url))){
818               return nftProfiles[i].id;
819           }
820       }
821       return BAD_NFT_PROFILE_ID;
822   }
823   
824  
825   
826   function isFreeTokenId(uint256 tokenId) public view returns (bool){
827       try nftContract.tokenURI(tokenId) { 
828           //if we can run this successfully it means token id is not free -> false
829           return false;
830       } catch {
831           return true; //if we errored getting url by tokenId, it is free -> true
832       }
833   }
834   
835   
836   function getTokenPriceByTokenId(uint256 tokenId) public view returns(uint256){
837       string memory url = BAD_URL;
838       try nftContract.tokenURI(tokenId) {
839         url = nftContract.tokenURI(tokenId);
840         uint32 profileId = getProfileIdbyUrl(url);
841         if (profileId == BAD_NFT_PROFILE_ID){
842             return BAD_NFT_PROFILE_ID;
843         } else {
844             return getSellPriceById(profileId);
845         }
846       } catch {
847         return BAD_NFT_PROFILE_ID;
848       }
849      
850   }
851   
852   
853     /**
854     * @dev - six functions below are for owner to check balance and
855     * deposit/withdraw eth/tokens to exchange contract
856     */
857     /**
858     * @dev returns contract balance, in wei
859     */
860     
861     function getContractBalance() external view returns (uint256) {
862         return address(this).balance;
863     }
864 
865     /**
866     * @dev returns contract tokens balance
867     */
868     function getContractTokensBalance() external view returns (uint256) {
869         return token.balanceOf(address(this));
870     }
871     
872     
873     function withdraw(address payable sendTo, uint256 amount) external onlyOwner {
874         require(address(this).balance >= amount, "unsufficient funds");
875         bool success = false;
876         // ** sendTo.transfer(amount);**
877         (success, ) = sendTo.call.value(amount)("");
878         require(success, "Transfer failed.");
879         // ** end **
880         emit Withdrawn(amount, sendTo); //in wei
881     }
882     
883     
884     //deposit ether (amount in finney for control is provided as input paramenter)
885     function deposit(uint256 amount) payable external onlyOwner { 
886         require(amount*(1 finney) == msg.value,"please provide value in finney");
887         emit FinneyDeposited(amount, owner); //in finney
888     }
889     
890     
891     // tokens with decimals, already converted on frontend
892     function depositTokens(uint256 amount) external onlyOwner {
893         require(amount > 0, "You need to deposit at least some tokens");
894         uint256 allowance = token.allowance(msg.sender, address(this));
895         require(allowance >= amount, "Check the token allowance");
896         token.transferFrom(msg.sender, address(this), amount);
897     
898         emit TokensDeposited(amount, owner);
899     }
900     
901     
902     // tokens with decimals, already converted on frontend
903     function withdrawTokens(address to_wallet, uint256 realAmountTokens) external onlyOwner {
904             
905         require(realAmountTokens > 0, "You need to withdraw at least some tokens");
906       
907         uint256 contractTokenBalance = token.balanceOf(address(this));
908     
909         require(contractTokenBalance > realAmountTokens, "unsufficient funds");
910     
911          //ensure we revert in case of failure
912         try token.transfer(to_wallet, realAmountTokens) {
913             emit TokensWithdrawn(realAmountTokens, to_wallet); //in real representation
914         } catch {
915             require(false,"tokens transfer failed");
916     
917         }
918     
919     }
920         
921     
922     
923 }