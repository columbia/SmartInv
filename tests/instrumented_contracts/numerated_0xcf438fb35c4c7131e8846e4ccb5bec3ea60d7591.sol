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
148 
149 contract etherdoodleToken is ERC721 {
150 
151     using AddressUtils for address;
152     //@dev ERC-721 compliance
153     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
154 
155 
156 //EVENTS
157 // @dev fired when a pixel's colour is changed
158     event ColourChanged(uint pixelId, uint8 colourR, uint8 colourG, uint8 colourB);
159 
160 // @dev fired when a pixel's price is changed
161     event PriceChanged(uint pixelId, uint oldPrice, uint newPrice);
162 
163 // @dev fired when a pixel's text is changed
164     event TextChanged(uint pixelId, string textChanged);
165 
166 //@dev name for ERC-721
167     string constant public name = "etherdoodle";
168 
169 //@dev symbol for ERC-721
170     string constant public symbol = "etherdoodle";
171 
172 //@dev Starting pixel price
173     uint constant public startingPrice = 0.0025 ether;
174 
175 //@dev Total number of promo pixels
176     uint private constant PROMO_LIMIT = 1000;
177 
178 //@dev Switch from 3x to 1.5x per transaction
179     uint private constant stepAt = 0.24862 ether;
180 
181 //@dev The addresses of the accounts 
182     address public ceoAddress;
183 
184 //@dev number of promo pixels purchased
185     uint public promoCount;
186 
187 //DATA STRUCTURES
188 //@dev struct representation of a pixel
189     struct Pixel {
190         uint32 id;
191         uint8 colourR;
192         uint8 colourG;
193         uint8 colourB;
194         string pixelText;
195     }
196 
197 //@dev array holding all pixels
198     Pixel[1000000] public pixels;
199 
200 //MAPPINGS
201 //@dev mapping from a pixel to its owner
202     mapping (uint => address) private pixelToOwner;
203 
204 //@dev mapping from owner to all of their pixels;
205     mapping (address => uint[]) private ownerToPixel;
206 
207 //@dev mapping from an address to the count of pixels
208     mapping (address => uint) private ownerPixelCount;
209 
210 //@dev mapping from a pixelId to the price of that pixel
211     mapping (uint => uint ) private pixelToPrice;
212 
213 //@dev mapping from a pixel to an approved account for transfer
214     mapping(uint => address) public pixelToApproved;
215 
216 //@dev mapping from an address to another mapping that determines if an operator is approved
217     mapping(address => mapping(address=>bool)) internal operatorApprovals;
218 
219 //MODIFIERS
220 //@dev access modifiers for ceo
221     modifier onlyCEO() {
222         require(msg.sender == ceoAddress);
223         _;
224     }
225 
226 //@dev used to verify ownership
227     modifier onlyOwnerOf(uint _pixelId) {
228         require(msg.sender == ownerOf(_pixelId));
229         _;
230     }
231 
232 //@dev used to allow operators to transfer and to manage the pixels
233     modifier canManageAndTransfer(uint _pixelId) {
234         require(isApprovedOrOwner(msg.sender, _pixelId));
235         _;
236     }
237 
238 //@dev make sure that the recipient address is notNull
239     modifier notNull(address _to) {
240         require(_to != address(0));
241         _;
242     }
243 
244 //Constructor
245     constructor () public {
246         ceoAddress = msg.sender;
247     }
248 ///////
249 // External functions
250 /////
251 //@dev function to assign a new CEO
252     function assignCEO(address _newCEO) external onlyCEO {
253         require(_newCEO != address(0));
254         ceoAddress = _newCEO;
255     }
256 
257 //@Update All a selected pixels details, can be done by the operator, or the owner
258     function updateAllPixelDetails(uint _pixelId, uint8 _colourR, uint8 _colourG, uint8 _colourB,uint _price,string _text) 
259     external canManageAndTransfer(_pixelId) {
260         require(_price <= pixelToPrice[_pixelId]);
261         require(_price >= 0.0025 ether);
262         require(bytes(_text).length < 101);
263         bool colourChangedBool = false;
264         if(pixelToPrice[_pixelId] != _price){
265             pixelToPrice[_pixelId] = _price;
266             emit PriceChanged(_pixelId,pixelToPrice[_pixelId],_price);
267         }
268         if(pixels[_pixelId].colourR != _colourR){
269             pixels[_pixelId].colourR = _colourR;
270             colourChangedBool = true;
271         }
272         if(pixels[_pixelId].colourG != _colourG){
273             pixels[_pixelId].colourG = _colourG;
274             colourChangedBool = true;
275         }
276         if(pixels[_pixelId].colourB != _colourB){
277             pixels[_pixelId].colourB = _colourB;
278             colourChangedBool = true;
279         }
280         if (colourChangedBool){
281             emit ColourChanged(_pixelId, _colourR, _colourG, _colourB);
282         }
283         
284         if(keccak256(getPixelText(_pixelId)) != keccak256(_text) ){
285             pixels[_pixelId].pixelText = _text;
286             emit TextChanged(_pixelId,_text);
287         }
288     }
289 
290 //@dev add an address to a pixel's approved list
291     function approve(address _to, uint _pixelId) public  {
292         address owner = ownerOf(_pixelId);
293         require(_to != owner);
294         require(msg.sender == owner || isApprovedForAll(owner,msg.sender));
295         if(getApproved(_pixelId) != address(0) || _to != address(0)) {
296             pixelToApproved[_pixelId] = _to;
297             emit Approval(msg.sender, _to, _pixelId);
298         }
299         
300     }
301 
302 //@dev returns approved Addresses
303     function getApproved(uint _pixelId) public view returns(address){
304         return pixelToApproved[_pixelId];
305     }
306 
307 //@dev approve all an owner's pixels to be managed by an address
308     function setApprovalForAll(address _to,bool _approved) public{
309         require(_to != msg.sender);
310         operatorApprovals[msg.sender][_to] = _approved;
311         emit ApprovalForAll(msg.sender, _to, _approved);
312     }
313  
314 
315 ///////////////////
316 ///Public functions
317 ///////////////////
318 
319 //@dev returns if a pixel has already been purchased
320     function exists(uint256 _pixelId) public view returns (bool) {
321         address owner = pixelToOwner[_pixelId];
322         return owner != address(0);
323     }
324 
325 //@dev returns if an address is approved to manage all another address' pixels
326     function isApprovedForAll(address _owner, address _operator) public view returns(bool) {
327         return operatorApprovals[_owner][_operator];
328     }
329 
330 //@dev returns the number of pixels an address owns
331     function balanceOf(address _owner) public view returns (uint) {
332         return ownerPixelCount[_owner];
333     }
334 
335 
336 //@dev returns the owner of a pixel
337     function ownerOf(uint _pixelId)  public view returns (address) {
338         address owner = pixelToOwner[_pixelId];
339         return owner;
340     }
341 
342 //@dev internal function to determine if its approved or an owner
343     function isApprovedOrOwner(address _spender, uint _pixelId)internal view returns (bool) {
344         address owner = ownerOf(_pixelId);
345         return(_spender == owner || getApproved(_pixelId) == _spender || isApprovedForAll(owner,_spender));
346     }
347 
348 //@dev internal function to remove approval on a pixel
349     function clearApproval(address _owner, uint256 _pixelId) internal {
350         require(ownerOf(_pixelId) == _owner);
351         if(pixelToApproved[_pixelId] != address(0)) {
352             pixelToApproved[_pixelId] = address(0);
353             emit Approval(_owner,address(0),_pixelId);
354         }
355     }
356 
357 //@dev returns the total number of pixels generated
358     function totalSupply() public view returns (uint) {
359         return pixels.length;
360     }
361 
362 //@dev ERC 721 transfer from
363     function transferFrom(address _from, address _to, uint _pixelId) public 
364     canManageAndTransfer(_pixelId) {
365         require(_from != address(0));
366         require(_to != address(0));
367         clearApproval(_from,_pixelId);
368         _transfer(_from, _to, _pixelId);
369     }
370 //@dev ERC 721 safeTransfer from functions
371     function safeTransferFrom(address _from, address _to, uint _pixelId) public canManageAndTransfer(_pixelId){
372         safeTransferFrom(_from,_to,_pixelId,"");
373     }
374 
375 //@dev ERC 721 safeTransferFrom functions
376     function safeTransferFrom(address _from, address _to, uint _pixelId,bytes _data) public canManageAndTransfer(_pixelId){
377         transferFrom(_from,_to,_pixelId);
378         require(checkAndCallSafeTransfer(_from,_to,_pixelId,_data));
379     }
380 
381 //@dev TRANSFER
382     function transfer(address _to, uint _pixelId) public canManageAndTransfer(_pixelId) notNull(_to) {
383         _transfer(msg.sender, _to, _pixelId);
384     }
385 
386 //@dev returns all pixel's data
387     function getPixelData(uint _pixelId) public view returns 
388     (uint32 _id, address _owner, uint8 _colourR, uint8 _colourG, uint8 _colourB, uint _price,string _text) {
389         Pixel storage pixel = pixels[_pixelId];
390         _id = pixel.id;
391         _price = getPixelPrice(_pixelId);
392         _owner = pixelToOwner[_pixelId];
393         _colourR = pixel.colourR;
394         _colourG = pixel.colourG;
395         _colourB = pixel.colourB;
396         _text = pixel.pixelText;
397     }
398 
399 //@dev Returns only Text
400     function getPixelText(uint _pixelId)public view returns(string) {
401         return pixels[_pixelId].pixelText;
402     }
403 
404 //@dev Returns the priceof a pixel
405     function getPixelPrice(uint _pixelId) public view returns(uint) {
406         uint price = pixelToPrice[_pixelId];
407         if (price != 0) {
408             return price;
409         } else {
410             return 1000000000000000;
411             }
412         
413     } 
414 
415     //@dev return the pixels owned by an address
416     function getPixelsOwned(address _owner) public view returns(uint[]) {
417         return ownerToPixel[_owner];
418     }
419 
420     //@dev return number of pixels owned by an address
421     function getOwnerPixelCount(address _owner) public view returns(uint) {
422         return ownerPixelCount[_owner];
423     }
424 
425     //@dev  return colour
426     function getPixelColour(uint _pixelId) public view returns (uint _colourR, uint _colourG, uint _colourB) {
427         _colourR = pixels[_pixelId].colourR;
428         _colourG = pixels[_pixelId].colourG;
429         _colourB = pixels[_pixelId].colourB;
430     }
431 
432     //@dev payout function to dev
433     function payout(address _to) public onlyCEO {
434         if (_to == address(0)) {
435             ceoAddress.transfer(address(this).balance);
436         } else {
437             _to.transfer(address(this).balance);
438         }  
439     }
440 
441     //@dev purchase promo pixels that cost nothing at start
442     function promoPurchase(uint32 _pixelId,uint8 _colourR,uint8 _colourG,uint8 _colourB,string _text) public {
443         require(ownerOf(_pixelId) == (address(0)));
444         require(promoCount<PROMO_LIMIT);
445         require(bytes(_text).length < 101);
446         _createPixel((_pixelId), _colourR, _colourG, _colourB,_text);
447         _transfer(address(0),msg.sender,_pixelId);      
448         promoCount++;
449     }
450         
451     //@dev purchase multiple pixels at the same time
452     function multiPurchase(uint32[] _Id, uint8[] _R,uint8[] _G,uint8[] _B,string _text) public payable {
453         require(_Id.length == _R.length && _Id.length == _G.length && _Id.length == _B.length);
454         require(bytes(_text).length < 101);
455         address newOwner = msg.sender;
456         uint totalPrice = 0;
457         uint excessValue = msg.value;
458         
459         for(uint i = 0; i < _Id.length; i++){
460             address oldOwner = ownerOf(_Id[i]);
461             require(ownerOf(_Id[i]) != newOwner);
462             require(!isInvulnerableByArea(_Id[i]));
463             
464             uint tempPrice = getPixelPrice(_Id[i]);
465             totalPrice = SafeMath.add(totalPrice,tempPrice);
466             excessValue = processMultiPurchase(_Id[i],_R[i],_G[i],_B[i],_text,oldOwner,newOwner,excessValue);
467            
468             if(i == _Id.length-1) {
469                 require(msg.value >= totalPrice);
470                 msg.sender.transfer(excessValue);
471                 }   
472         }
473         
474     } 
475 
476     //@dev helper function for processing multiple purchases
477     function processMultiPurchase(uint32 _pixelId,uint8 _colourR,uint8 _colourG,uint8 _colourB,string _text, // solium-disable-line
478         address _oldOwner,address _newOwner,uint value) private returns (uint excess) {
479         uint payment; // payment to previous owner
480         uint purchaseExcess; // excess purchase value
481         uint sellingPrice = getPixelPrice(_pixelId);
482         if(_oldOwner == address(0)) {
483             purchaseExcess = uint(SafeMath.sub(value,startingPrice));
484             _createPixel((_pixelId), _colourR, _colourG, _colourB,_text);
485         } else {
486             payment = uint(SafeMath.div(SafeMath.mul(sellingPrice,95), 100));
487             purchaseExcess = SafeMath.sub(value,sellingPrice);
488             if(pixels[_pixelId].colourR != _colourR || pixels[_pixelId].colourG != _colourG || pixels[_pixelId].colourB != _colourB)
489                 _changeColour(_pixelId,_colourR,_colourG,_colourB);
490             if(keccak256(getPixelText(_pixelId)) != keccak256(_text))
491                 _changeText(_pixelId,_text);
492             clearApproval(_oldOwner,_pixelId);
493         }
494         if(sellingPrice < stepAt) {
495             pixelToPrice[_pixelId] = SafeMath.div(SafeMath.mul(sellingPrice,300),95);
496         } else {
497             pixelToPrice[_pixelId] = SafeMath.div(SafeMath.mul(sellingPrice,150),95);
498         }
499         _transfer(_oldOwner, _newOwner,_pixelId);
500      
501         if(_oldOwner != address(this)) {
502             _oldOwner.transfer(payment); 
503         }
504         return purchaseExcess;
505     }
506     
507     function _changeColour(uint _pixelId,uint8 _colourR,uint8 _colourG, uint8 _colourB) private {
508         pixels[_pixelId].colourR = _colourR;
509         pixels[_pixelId].colourG = _colourG;
510         pixels[_pixelId].colourB = _colourB;
511         emit ColourChanged(_pixelId, _colourR, _colourG, _colourB);
512     }
513     function _changeText(uint _pixelId, string _text) private{
514         require(bytes(_text).length < 101);
515         pixels[_pixelId].pixelText = _text;
516         emit TextChanged(_pixelId,_text);
517     }
518     
519 
520 //@dev Invulnerability logic check 
521     function isInvulnerableByArea(uint _pixelId) public view returns (bool) {
522         require(_pixelId >= 0 && _pixelId <= 999999);
523         if (ownerOf(_pixelId) == address(0)) {
524             return false;
525         }
526         uint256 counter = 0;
527  
528         if (_pixelId == 0 || _pixelId == 999 || _pixelId == 999000 || _pixelId == 999999) {
529             return false;
530         }
531 
532         if (_pixelId < 1000) {
533             if (_checkPixelRight(_pixelId)) {
534                 counter = SafeMath.add(counter, 1);
535             }
536             if (_checkPixelLeft(_pixelId)) {
537                 counter = SafeMath.add(counter, 1);
538             }
539             if (_checkPixelUnder(_pixelId)) {
540                 counter = SafeMath.add(counter, 1);
541             }
542             if (_checkPixelUnderRight(_pixelId)) {
543                 counter = SafeMath.add(counter, 1); 
544             }
545             if (_checkPixelUnderLeft(_pixelId)) {
546                 counter = SafeMath.add(counter, 1);
547             }
548         }
549 
550         if (_pixelId > 999000) {
551             if (_checkPixelRight(_pixelId)) {
552                 counter = SafeMath.add(counter, 1);
553             }
554             if (_checkPixelLeft(_pixelId)) {
555                 counter = SafeMath.add(counter, 1);
556             }
557             if (_checkPixelAbove(_pixelId)) {
558                 counter = SafeMath.add(counter, 1);
559             }
560             if (_checkPixelAboveRight(_pixelId)) {
561                 counter = SafeMath.add(counter, 1);
562             }
563             if (_checkPixelAboveLeft(_pixelId)) {
564                 counter = SafeMath.add(counter, 1);
565             }
566         }
567 
568         if (_pixelId > 999 && _pixelId < 999000) {
569             if (_pixelId%1000 == 0 || _pixelId%1000 == 999) {
570                 if (_pixelId%1000 == 0) {
571                     if (_checkPixelAbove(_pixelId)) {
572                         counter = SafeMath.add(counter, 1);
573                     }
574                     if (_checkPixelAboveRight(_pixelId)) {
575                         counter = SafeMath.add(counter, 1);
576                     }
577                     if (_checkPixelRight(_pixelId)) {
578                         counter = SafeMath.add(counter, 1);
579                     }
580                     if (_checkPixelUnder(_pixelId)) {
581                         counter = SafeMath.add(counter, 1);
582                     }
583                     if (_checkPixelUnderRight(_pixelId)) {
584                         counter = SafeMath.add(counter, 1);
585                     }
586                 } else {
587                     if (_checkPixelAbove(_pixelId)) {
588                         counter = SafeMath.add(counter, 1);
589                     }
590                     if (_checkPixelAboveLeft(_pixelId)) {
591                         counter = SafeMath.add(counter, 1);
592                     }
593                     if (_checkPixelLeft(_pixelId)) {
594                         counter = SafeMath.add(counter, 1);
595                     }
596                     if (_checkPixelUnder(_pixelId)) {
597                         counter = SafeMath.add(counter, 1);
598                     }
599                     if (_checkPixelUnderLeft(_pixelId)) {
600                         counter = SafeMath.add(counter, 1);
601                     }
602                 }
603             } else {
604                 if (_checkPixelAbove(_pixelId)) {
605                     counter = SafeMath.add(counter, 1);
606                 }
607                 if (_checkPixelAboveLeft(_pixelId)) {
608                     counter = SafeMath.add(counter, 1);
609                 }
610                 if (_checkPixelAboveRight(_pixelId)) {
611                     counter = SafeMath.add(counter, 1);
612                 }
613                 if (_checkPixelUnder(_pixelId)) {
614                     counter = SafeMath.add(counter, 1);
615                 }
616                 if (_checkPixelUnderRight(_pixelId)) {
617                     counter = SafeMath.add(counter, 1);
618                 }
619                 if (_checkPixelUnderLeft(_pixelId)) {
620                     counter = SafeMath.add(counter, 1);
621                 }
622                 if (_checkPixelRight(_pixelId)) {
623                     counter = SafeMath.add(counter, 1);
624                 }
625                 if (_checkPixelLeft(_pixelId)) {
626                     counter = SafeMath.add(counter, 1);
627                 }
628             }
629         }
630         return counter >= 5;
631     }
632 
633    
634 
635    
636 
637 ////////////////////
638 ///Private functions
639 ////////////////////
640 //@dev create a pixel
641     function _createPixel (uint32 _id, uint8 _colourR, uint8 _colourG, uint8 _colourB, string _pixelText) private returns(uint) {
642         pixels[_id] = Pixel(_id, _colourR, _colourG, _colourB, _pixelText);
643         pixelToPrice[_id] = startingPrice;
644         emit ColourChanged(_id, _colourR, _colourG, _colourB);
645         return _id;
646     }
647 
648 //@dev private function to transfer a pixel from an old address to a new one
649     function _transfer(address _from, address _to, uint _pixelId) private {
650   //increment new owner pixel count and decrement old owner count and add a pixel to the owners array
651         ownerPixelCount[_to] = SafeMath.add(ownerPixelCount[_to], 1);
652         ownerToPixel[_to].push(_pixelId);
653         if (_from != address(0)) {
654             for (uint i = 0; i < ownerToPixel[_from].length; i++) {
655                 if (ownerToPixel[_from][i] == _pixelId) {
656                     ownerToPixel[_from][i] = ownerToPixel[_from][ownerToPixel[_from].length-1];
657                     delete ownerToPixel[_from][ownerToPixel[_from].length-1];
658                 }
659             }
660             ownerPixelCount[_from] = SafeMath.sub(ownerPixelCount[_from], 1);
661         }
662         pixelToOwner[_pixelId] = _to;
663         emit Transfer(_from, _to, _pixelId);
664     }
665 
666 //@dev helper functions to check for if a pixel purchase is valid
667     function _checkPixelAbove(uint _pixelId) private view returns (bool) {
668         if (ownerOf(_pixelId) == ownerOf(_pixelId-1000)) {
669             return true;
670         } else {
671             return false;
672         }
673     }
674     
675     function _checkPixelUnder(uint _pixelId) private view returns (bool) {
676         if (ownerOf(_pixelId) == ownerOf(_pixelId+1000)) {
677             return true;
678         } else {
679             return false;
680         }
681     }
682 
683     function _checkPixelRight(uint _pixelId) private view returns (bool) {
684         if (ownerOf(_pixelId) == ownerOf(_pixelId+1)) {
685             return true;
686         } else {
687             return false;
688         }
689     }
690 
691     function _checkPixelLeft(uint _pixelId) private view returns (bool) {
692         if (ownerOf(_pixelId) == ownerOf(_pixelId-1)) {
693             return true;
694         } else {
695             return false;
696         }
697     }
698 
699     function _checkPixelAboveLeft(uint _pixelId) private view returns (bool) {
700         if (ownerOf(_pixelId) == ownerOf(_pixelId-1001)) {
701             return true;
702         } else {
703             return false;
704         }
705     }
706 
707     function _checkPixelUnderLeft(uint _pixelId) private view returns (bool) {
708         if (ownerOf(_pixelId) == ownerOf(_pixelId+999)) {
709             return true;
710         } else {
711             return false;
712         }
713     }
714 
715     function _checkPixelAboveRight(uint _pixelId) private view returns (bool) {
716         if (ownerOf(_pixelId) == ownerOf(_pixelId-999)) {
717             return true;
718         } else { 
719             return false;
720         }
721     }
722     
723     function _checkPixelUnderRight(uint _pixelId) private view returns (bool) {
724         if (ownerOf(_pixelId) == ownerOf(_pixelId+1001)) {
725             return true;
726         } else {  
727             return false; 
728         }
729     }
730 
731 //@dev ERC721 compliance to check what address it is being sent to
732     function checkAndCallSafeTransfer(address _from, address _to, uint256 _pixelId, bytes _data)
733     internal
734     returns (bool)
735     {
736         if (!_to.isContract()) {
737             return true;
738         }
739         bytes4 retval = ERC721Receiver(_to).onERC721Received(
740         _from, _pixelId, _data);
741         return (retval == ERC721_RECEIVED);
742     }
743 }