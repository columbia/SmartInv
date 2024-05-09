1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * Utility library of inline functions on addresses
50  */
51 library AddressUtils {
52 
53   /**
54    * Returns whether the target address is a contract
55    * @dev This function will return false if invoked during the constructor of a contract,
56    *  as the code is not actually created until after the constructor finishes.
57    * @param addr address to check
58    * @return whether the target address is a contract
59    */
60   function isContract(address addr) internal view returns (bool) {
61     uint256 size;
62     // XXX Currently there is no better way to check if there is a contract in an address
63     // than to check the size of the code at that address.
64     // See https://ethereum.stackexchange.com/a/14016/36603
65     // for more details about how this works.
66     // TODO Check this again before the Serenity release, because all addresses will be
67     // contracts then.
68     // solium-disable-next-line security/no-inline-assembly
69     assembly { size := extcodesize(addr) }
70     return size > 0;
71   }
72 
73 }
74 /**
75  * @title ERC721 Non-Fungible Token Standard basic interface
76  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
77  */
78 contract ERC721 {
79   event Transfer(
80     address indexed _from,
81     address indexed _to,
82     uint256 _tokenId
83   );
84   event Approval(
85     address indexed _owner,
86     address indexed _approved,
87     uint256 _tokenId
88   );
89   event ApprovalForAll(
90     address indexed _owner,
91     address indexed _operator,
92     bool _approved
93   );
94 
95   function balanceOf(address _owner) public view returns (uint256 _balance);
96   function ownerOf(uint256 _tokenId) public view returns (address _owner);
97   function exists(uint256 _tokenId) public view returns (bool _exists);
98 
99   function approve(address _to, uint256 _tokenId) public;
100   function getApproved(uint256 _tokenId)
101     public view returns (address _operator);
102 
103   function setApprovalForAll(address _operator, bool _approved) public;
104   function isApprovedForAll(address _owner, address _operator)
105     public view returns (bool);
106 
107   function transferFrom(address _from, address _to, uint256 _tokenId) public;
108   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
109     public;
110 
111   function safeTransferFrom(
112     address _from,
113     address _to,
114     uint256 _tokenId,
115     bytes _data
116   )
117     public;
118 }
119 contract ERC721Receiver {
120   /**
121    * @dev Magic value to be returned upon successful reception of an NFT
122    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
123    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
124    */
125   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
126 
127   /**
128    * @notice Handle the receipt of an NFT
129    * @dev The ERC721 smart contract calls this function on the recipient
130    *  after a `safetransfer`. This function MAY throw to revert and reject the
131    *  transfer. This function MUST use 50,000 gas or less. Return of other
132    *  than the magic value MUST result in the transaction being reverted.
133    *  Note: the contract address is always the message sender.
134    * @param _from The sending address
135    * @param _tokenId The NFT identifier which is being transfered
136    * @param _data Additional data with no specified format
137    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
138    */
139   function onERC721Received(
140     address _from,
141     uint256 _tokenId,
142     bytes _data
143   )
144     public
145     returns(bytes4);
146 }
147 
148 contract etherdoodleToken is ERC721 {
149 
150     using AddressUtils for address;
151     //@dev ERC-721 compliance
152     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
153 
154 
155 //EVENTS
156 // @dev fired when a pixel's colour is changed
157     event ColourChanged(uint pixelId, uint8 colourR, uint8 colourG, uint8 colourB);
158 
159 // @dev fired when a pixel's price is changed
160     event PriceChanged(uint pixelId, uint oldPrice, uint newPrice);
161 
162 // @dev fired when a pixel's text is changed
163     event TextChanged(uint pixelId, string textChanged);
164 
165 //@dev name for ERC-721
166     string constant public name = "etherdoodle";
167 
168 //@dev symbol for ERC-721
169     string constant public symbol = "etherdoodle";
170 
171 //@dev Starting pixel price
172     uint constant public startingPrice = 0.001 ether;
173 
174 
175 //@dev Switch from 3x to 1.5x per transaction
176     uint private constant stepAt = 0.09944 ether;
177 
178 //@dev The addresses of the accounts 
179     address public ceoAddress;
180 
181 
182 //DATA STRUCTURES
183 //@dev struct representation of a pixel
184     struct Pixel {
185         uint32 id;
186         uint8 colourR;
187         uint8 colourG;
188         uint8 colourB;
189         string pixelText;
190     }
191 
192 //@dev array holding all pixels
193     Pixel[1000000] public pixels;
194 
195 //MAPPINGS
196 //@dev mapping from a pixel to its owner
197     mapping (uint => address) private pixelToOwner;
198 
199 //@dev mapping from owner to all of their pixels;
200     mapping (address => uint[]) private ownerToPixel;
201 
202 //@dev mapping from an address to the count of pixels
203     mapping (address => uint) private ownerPixelCount;
204 
205 //@dev mapping from a pixelId to the price of that pixel
206     mapping (uint => uint ) private pixelToPrice;
207 
208 //@dev mapping from a pixel to an approved account for transfer
209     mapping(uint => address) public pixelToApproved;
210 
211 //@dev mapping from an address to another mapping that determines if an operator is approved
212     mapping(address => mapping(address=>bool)) internal operatorApprovals;
213 
214 //MODIFIERS
215 //@dev access modifiers for ceo
216     modifier onlyCEO() {
217         require(msg.sender == ceoAddress);
218         _;
219     }
220 
221 //@dev used to verify ownership
222     modifier onlyOwnerOf(uint _pixelId) {
223         require(msg.sender == ownerOf(_pixelId));
224         _;
225     }
226 
227 //@dev used to allow operators to transfer and to manage the pixels
228     modifier canManageAndTransfer(uint _pixelId) {
229         require(isApprovedOrOwner(msg.sender, _pixelId));
230         _;
231     }
232 
233 //@dev make sure that the recipient address is notNull
234     modifier notNull(address _to) {
235         require(_to != address(0));
236         _;
237     }
238 
239 //Constructor
240     constructor () public {
241         ceoAddress = msg.sender;
242     }
243 ///////
244 // External functions
245 /////
246 //@dev function to assign a new CEO
247     function assignCEO(address _newCEO) external onlyCEO {
248         require(_newCEO != address(0));
249         ceoAddress = _newCEO;
250     }
251 
252 //@Update All a selected pixels details, can be done by the operator, or the owner
253     function updateAllPixelDetails(uint _pixelId, uint8 _colourR, uint8 _colourG, uint8 _colourB,uint _price,string _text) 
254     external canManageAndTransfer(_pixelId) {
255         require(_price <= pixelToPrice[_pixelId]);
256         require(_price >= 0.0001 ether);
257         require(bytes(_text).length < 101);
258         bool colourChangedBool = false;
259         if(pixelToPrice[_pixelId] != _price){
260             pixelToPrice[_pixelId] = _price;
261             emit PriceChanged(_pixelId,pixelToPrice[_pixelId],_price);
262         }
263         if(pixels[_pixelId].colourR != _colourR){
264             pixels[_pixelId].colourR = _colourR;
265             colourChangedBool = true;
266         }
267         if(pixels[_pixelId].colourG != _colourG){
268             pixels[_pixelId].colourG = _colourG;
269             colourChangedBool = true;
270         }
271         if(pixels[_pixelId].colourB != _colourB){
272             pixels[_pixelId].colourB = _colourB;
273             colourChangedBool = true;
274         }
275         if (colourChangedBool){
276             emit ColourChanged(_pixelId, _colourR, _colourG, _colourB);
277         }
278         
279         if(keccak256(getPixelText(_pixelId)) != keccak256(_text) ){
280             pixels[_pixelId].pixelText = _text;
281             emit TextChanged(_pixelId,_text);
282         }
283     }
284 
285 //@dev add an address to a pixel's approved list
286     function approve(address _to, uint _pixelId) public  {
287         address owner = ownerOf(_pixelId);
288         require(_to != owner);
289         require(msg.sender == owner || isApprovedForAll(owner,msg.sender));
290         if(getApproved(_pixelId) != address(0) || _to != address(0)) {
291             pixelToApproved[_pixelId] = _to;
292             emit Approval(msg.sender, _to, _pixelId);
293         }
294         
295     }
296 
297 //@dev returns approved Addresses
298     function getApproved(uint _pixelId) public view returns(address){
299         return pixelToApproved[_pixelId];
300     }
301 
302 //@dev approve all an owner's pixels to be managed by an address
303     function setApprovalForAll(address _to,bool _approved) public{
304         require(_to != msg.sender);
305         operatorApprovals[msg.sender][_to] = _approved;
306         emit ApprovalForAll(msg.sender, _to, _approved);
307     }
308  
309 
310 ///////////////////
311 ///Public functions
312 ///////////////////
313 
314 //@dev returns if a pixel has already been purchased
315     function exists(uint256 _pixelId) public view returns (bool) {
316         address owner = pixelToOwner[_pixelId];
317         return owner != address(0);
318     }
319 
320 //@dev returns if an address is approved to manage all another address' pixels
321     function isApprovedForAll(address _owner, address _operator) public view returns(bool) {
322         return operatorApprovals[_owner][_operator];
323     }
324 
325 //@dev returns the number of pixels an address owns
326     function balanceOf(address _owner) public view returns (uint) {
327         return ownerPixelCount[_owner];
328     }
329 
330 
331 //@dev returns the owner of a pixel
332     function ownerOf(uint _pixelId)  public view returns (address) {
333         address owner = pixelToOwner[_pixelId];
334         return owner;
335     }
336 
337 //@dev internal function to determine if its approved or an owner
338     function isApprovedOrOwner(address _spender, uint _pixelId)internal view returns (bool) {
339         address owner = ownerOf(_pixelId);
340         return(_spender == owner || getApproved(_pixelId) == _spender || isApprovedForAll(owner,_spender));
341     }
342 
343 //@dev internal function to remove approval on a pixel
344     function clearApproval(address _owner, uint256 _pixelId) internal {
345         require(ownerOf(_pixelId) == _owner);
346         if(pixelToApproved[_pixelId] != address(0)) {
347             pixelToApproved[_pixelId] = address(0);
348             emit Approval(_owner,address(0),_pixelId);
349         }
350     }
351 
352 //@dev returns the total number of pixels generated
353     function totalSupply() public view returns (uint) {
354         return pixels.length;
355     }
356 
357 //@dev ERC 721 transfer from
358     function transferFrom(address _from, address _to, uint _pixelId) public 
359     canManageAndTransfer(_pixelId) {
360         require(_from != address(0));
361         require(_to != address(0));
362         clearApproval(_from,_pixelId);
363         _transfer(_from, _to, _pixelId);
364     }
365 //@dev ERC 721 safeTransfer from functions
366     function safeTransferFrom(address _from, address _to, uint _pixelId) public canManageAndTransfer(_pixelId){
367         safeTransferFrom(_from,_to,_pixelId,"");
368     }
369 
370 //@dev ERC 721 safeTransferFrom functions
371     function safeTransferFrom(address _from, address _to, uint _pixelId,bytes _data) public canManageAndTransfer(_pixelId){
372         transferFrom(_from,_to,_pixelId);
373         require(checkAndCallSafeTransfer(_from,_to,_pixelId,_data));
374     }
375 
376 //@dev TRANSFER
377     function transfer(address _to, uint _pixelId) public canManageAndTransfer(_pixelId) notNull(_to) {
378         _transfer(msg.sender, _to, _pixelId);
379     }
380 
381 //@dev returns all pixel's data
382     function getPixelData(uint _pixelId) public view returns 
383     (uint32 _id, address _owner, uint8 _colourR, uint8 _colourG, uint8 _colourB, uint _price,string _text) {
384         Pixel storage pixel = pixels[_pixelId];
385         _id = pixel.id;
386         _price = getPixelPrice(_pixelId);
387         _owner = pixelToOwner[_pixelId];
388         _colourR = pixel.colourR;
389         _colourG = pixel.colourG;
390         _colourB = pixel.colourB;
391         _text = pixel.pixelText;
392     }
393 
394 //@dev Returns only Text
395     function getPixelText(uint _pixelId)public view returns(string) {
396         return pixels[_pixelId].pixelText;
397     }
398 
399 //@dev Returns the priceof a pixel
400     function getPixelPrice(uint _pixelId) public view returns(uint) {
401         uint price = pixelToPrice[_pixelId];
402         if (price != 0) {
403             return price;
404         } else {
405             return startingPrice;
406             }
407         
408     } 
409 
410     //@dev return the pixels owned by an address
411     function getPixelsOwned(address _owner) public view returns(uint[]) {
412         return ownerToPixel[_owner];
413     }
414 
415     //@dev return number of pixels owned by an address
416     function getOwnerPixelCount(address _owner) public view returns(uint) {
417         return ownerPixelCount[_owner];
418     }
419 
420     //@dev  return colour
421     function getPixelColour(uint _pixelId) public view returns (uint _colourR, uint _colourG, uint _colourB) {
422         _colourR = pixels[_pixelId].colourR;
423         _colourG = pixels[_pixelId].colourG;
424         _colourB = pixels[_pixelId].colourB;
425     }
426 
427     //@dev payout function to dev
428     function payout(address _to) public onlyCEO {
429         if (_to == address(0)) {
430             ceoAddress.transfer(address(this).balance);
431         } else {
432             _to.transfer(address(this).balance);
433         }  
434     }
435 
436     //@dev purchase multiple pixels at the same time
437     function multiPurchase(uint32[] _Id, uint8[] _R,uint8[] _G,uint8[] _B,string _text) public payable {
438         require(_Id.length == _R.length && _Id.length == _G.length && _Id.length == _B.length);
439         require(bytes(_text).length < 101);
440         address newOwner = msg.sender;
441         uint totalPrice = 0;
442         uint excessValue = msg.value;
443         
444         for(uint i = 0; i < _Id.length; i++){
445             address oldOwner = ownerOf(_Id[i]);
446             require(ownerOf(_Id[i]) != newOwner);
447             require(!isInvulnerableByArea(_Id[i]));
448             
449             uint tempPrice = getPixelPrice(_Id[i]);
450             totalPrice = SafeMath.add(totalPrice,tempPrice);
451             excessValue = processMultiPurchase(_Id[i],_R[i],_G[i],_B[i],_text,oldOwner,newOwner,excessValue);
452            
453             if(i == _Id.length-1) {
454                 require(msg.value >= totalPrice);
455                 msg.sender.transfer(excessValue);
456             }   
457         }
458         
459     } 
460 
461     //@dev helper function for processing multiple purchases
462     function processMultiPurchase(uint32 _pixelId,uint8 _colourR,uint8 _colourG,uint8 _colourB,string _text, // solium-disable-line
463         address _oldOwner,address _newOwner,uint value) private returns (uint excess) {
464         uint payment; // payment to previous owner
465         uint purchaseExcess; // excess purchase value
466         uint sellingPrice = getPixelPrice(_pixelId);
467         if(_oldOwner == address(0)) {
468             purchaseExcess = uint(SafeMath.sub(value,startingPrice));
469             _createPixel((_pixelId), _colourR, _colourG, _colourB,_text);
470         } else {
471             payment = uint(SafeMath.div(SafeMath.mul(sellingPrice,95), 100));
472             purchaseExcess = SafeMath.sub(value,sellingPrice);
473             if(pixels[_pixelId].colourR != _colourR || pixels[_pixelId].colourG != _colourG || pixels[_pixelId].colourB != _colourB)
474                 _changeColour(_pixelId,_colourR,_colourG,_colourB);
475             if(keccak256(getPixelText(_pixelId)) != keccak256(_text))
476                 _changeText(_pixelId,_text);
477             clearApproval(_oldOwner,_pixelId);
478         }
479         if(sellingPrice < stepAt) {
480             pixelToPrice[_pixelId] = SafeMath.div(SafeMath.mul(sellingPrice,300),95);
481         } else {
482             pixelToPrice[_pixelId] = SafeMath.div(SafeMath.mul(sellingPrice,150),95);
483         }
484         _transfer(_oldOwner, _newOwner,_pixelId);
485      
486         if(_oldOwner != address(this)) {
487             _oldOwner.transfer(payment); 
488         }
489         return purchaseExcess;
490     }
491     
492     function _changeColour(uint _pixelId,uint8 _colourR,uint8 _colourG, uint8 _colourB) private {
493         pixels[_pixelId].colourR = _colourR;
494         pixels[_pixelId].colourG = _colourG;
495         pixels[_pixelId].colourB = _colourB;
496         emit ColourChanged(_pixelId, _colourR, _colourG, _colourB);
497     }
498     function _changeText(uint _pixelId, string _text) private{
499         require(bytes(_text).length < 101);
500         pixels[_pixelId].pixelText = _text;
501         emit TextChanged(_pixelId,_text);
502     }
503     
504 
505 //@dev Invulnerability logic check 
506     function isInvulnerableByArea(uint _pixelId) public view returns (bool) {
507         require(_pixelId >= 0 && _pixelId <= 999999);
508         if (ownerOf(_pixelId) == address(0)) {
509             return false;
510         }
511         uint256 counter = 0;
512  
513         if (_pixelId == 0 || _pixelId == 999 || _pixelId == 999000 || _pixelId == 999999) {
514             return false;
515         }
516 
517         if (_pixelId < 1000) {
518             if (_checkPixelRight(_pixelId)) {
519                 counter = SafeMath.add(counter, 1);
520             }
521             if (_checkPixelLeft(_pixelId)) {
522                 counter = SafeMath.add(counter, 1);
523             }
524             if (_checkPixelUnder(_pixelId)) {
525                 counter = SafeMath.add(counter, 1);
526             }
527             if (_checkPixelUnderRight(_pixelId)) {
528                 counter = SafeMath.add(counter, 1); 
529             }
530             if (_checkPixelUnderLeft(_pixelId)) {
531                 counter = SafeMath.add(counter, 1);
532             }
533         }
534 
535         if (_pixelId > 999000) {
536             if (_checkPixelRight(_pixelId)) {
537                 counter = SafeMath.add(counter, 1);
538             }
539             if (_checkPixelLeft(_pixelId)) {
540                 counter = SafeMath.add(counter, 1);
541             }
542             if (_checkPixelAbove(_pixelId)) {
543                 counter = SafeMath.add(counter, 1);
544             }
545             if (_checkPixelAboveRight(_pixelId)) {
546                 counter = SafeMath.add(counter, 1);
547             }
548             if (_checkPixelAboveLeft(_pixelId)) {
549                 counter = SafeMath.add(counter, 1);
550             }
551         }
552 
553         if (_pixelId > 999 && _pixelId < 999000) {
554             if (_pixelId%1000 == 0 || _pixelId%1000 == 999) {
555                 if (_pixelId%1000 == 0) {
556                     if (_checkPixelAbove(_pixelId)) {
557                         counter = SafeMath.add(counter, 1);
558                     }
559                     if (_checkPixelAboveRight(_pixelId)) {
560                         counter = SafeMath.add(counter, 1);
561                     }
562                     if (_checkPixelRight(_pixelId)) {
563                         counter = SafeMath.add(counter, 1);
564                     }
565                     if (_checkPixelUnder(_pixelId)) {
566                         counter = SafeMath.add(counter, 1);
567                     }
568                     if (_checkPixelUnderRight(_pixelId)) {
569                         counter = SafeMath.add(counter, 1);
570                     }
571                 } else {
572                     if (_checkPixelAbove(_pixelId)) {
573                         counter = SafeMath.add(counter, 1);
574                     }
575                     if (_checkPixelAboveLeft(_pixelId)) {
576                         counter = SafeMath.add(counter, 1);
577                     }
578                     if (_checkPixelLeft(_pixelId)) {
579                         counter = SafeMath.add(counter, 1);
580                     }
581                     if (_checkPixelUnder(_pixelId)) {
582                         counter = SafeMath.add(counter, 1);
583                     }
584                     if (_checkPixelUnderLeft(_pixelId)) {
585                         counter = SafeMath.add(counter, 1);
586                     }
587                 }
588             } else {
589                 if (_checkPixelAbove(_pixelId)) {
590                     counter = SafeMath.add(counter, 1);
591                 }
592                 if (_checkPixelAboveLeft(_pixelId)) {
593                     counter = SafeMath.add(counter, 1);
594                 }
595                 if (_checkPixelAboveRight(_pixelId)) {
596                     counter = SafeMath.add(counter, 1);
597                 }
598                 if (_checkPixelUnder(_pixelId)) {
599                     counter = SafeMath.add(counter, 1);
600                 }
601                 if (_checkPixelUnderRight(_pixelId)) {
602                     counter = SafeMath.add(counter, 1);
603                 }
604                 if (_checkPixelUnderLeft(_pixelId)) {
605                     counter = SafeMath.add(counter, 1);
606                 }
607                 if (_checkPixelRight(_pixelId)) {
608                     counter = SafeMath.add(counter, 1);
609                 }
610                 if (_checkPixelLeft(_pixelId)) {
611                     counter = SafeMath.add(counter, 1);
612                 }
613             }
614         }
615         return counter >= 5;
616     }
617 
618    
619 
620    
621 
622 ////////////////////
623 ///Private functions
624 ////////////////////
625 //@dev create a pixel
626     function _createPixel (uint32 _id, uint8 _colourR, uint8 _colourG, uint8 _colourB, string _pixelText) private returns(uint) {
627         pixels[_id] = Pixel(_id, _colourR, _colourG, _colourB, _pixelText);
628         pixelToPrice[_id] = startingPrice;
629         emit ColourChanged(_id, _colourR, _colourG, _colourB);
630         return _id;
631     }
632 
633 //@dev private function to transfer a pixel from an old address to a new one
634     function _transfer(address _from, address _to, uint _pixelId) private {
635   //increment new owner pixel count and decrement old owner count and add a pixel to the owners array
636         ownerPixelCount[_to] = SafeMath.add(ownerPixelCount[_to], 1);
637         ownerToPixel[_to].push(_pixelId);
638         if (_from != address(0)) {
639             for (uint i = 0; i < ownerToPixel[_from].length; i++) {
640                 if (ownerToPixel[_from][i] == _pixelId) {
641                     ownerToPixel[_from][i] = ownerToPixel[_from][ownerToPixel[_from].length-1];
642                     delete ownerToPixel[_from][ownerToPixel[_from].length-1];
643                 }
644             }
645             ownerPixelCount[_from] = SafeMath.sub(ownerPixelCount[_from], 1);
646         }
647         pixelToOwner[_pixelId] = _to;
648         emit Transfer(_from, _to, _pixelId);
649     }
650 
651 //@dev helper functions to check for if a pixel purchase is valid
652     function _checkPixelAbove(uint _pixelId) private view returns (bool) {
653         if (ownerOf(_pixelId) == ownerOf(_pixelId-1000)) {
654             return true;
655         } else {
656             return false;
657         }
658     }
659     
660     function _checkPixelUnder(uint _pixelId) private view returns (bool) {
661         if (ownerOf(_pixelId) == ownerOf(_pixelId+1000)) {
662             return true;
663         } else {
664             return false;
665         }
666     }
667 
668     function _checkPixelRight(uint _pixelId) private view returns (bool) {
669         if (ownerOf(_pixelId) == ownerOf(_pixelId+1)) {
670             return true;
671         } else {
672             return false;
673         }
674     }
675 
676     function _checkPixelLeft(uint _pixelId) private view returns (bool) {
677         if (ownerOf(_pixelId) == ownerOf(_pixelId-1)) {
678             return true;
679         } else {
680             return false;
681         }
682     }
683 
684     function _checkPixelAboveLeft(uint _pixelId) private view returns (bool) {
685         if (ownerOf(_pixelId) == ownerOf(_pixelId-1001)) {
686             return true;
687         } else {
688             return false;
689         }
690     }
691 
692     function _checkPixelUnderLeft(uint _pixelId) private view returns (bool) {
693         if (ownerOf(_pixelId) == ownerOf(_pixelId+999)) {
694             return true;
695         } else {
696             return false;
697         }
698     }
699 
700     function _checkPixelAboveRight(uint _pixelId) private view returns (bool) {
701         if (ownerOf(_pixelId) == ownerOf(_pixelId-999)) {
702             return true;
703         } else { 
704             return false;
705         }
706     }
707     
708     function _checkPixelUnderRight(uint _pixelId) private view returns (bool) {
709         if (ownerOf(_pixelId) == ownerOf(_pixelId+1001)) {
710             return true;
711         } else {  
712             return false; 
713         }
714     }
715 
716 //@dev ERC721 compliance to check what address it is being sent to
717     function checkAndCallSafeTransfer(address _from, address _to, uint256 _pixelId, bytes _data)
718     internal
719     returns (bool)
720     {
721         if (!_to.isContract()) {
722             return true;
723         }
724         bytes4 retval = ERC721Receiver(_to).onERC721Received(
725         _from, _pixelId, _data);
726         return (retval == ERC721_RECEIVED);
727     }
728 }