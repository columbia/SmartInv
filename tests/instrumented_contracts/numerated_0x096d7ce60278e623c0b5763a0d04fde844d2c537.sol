1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43  
44 contract Ownable {
45   address public owner;
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70    
71   function transferOwnership(address newOwner) onlyOwner public{
72     if (newOwner != address(0)) {
73       owner = newOwner;
74     }
75   }
76 
77 }
78 
79 
80 
81 
82 /**
83  * Interface for required functionality in the ERC721 standard
84  * for non-fungible tokens.
85  * Borrowed from Token Standard discussion board
86  *
87  * 
88  */
89  
90 contract ERC721 {
91     // Function
92     function totalSupply() public view returns (uint256 _totalSupply);
93     function balanceOf(address _owner) public view returns (uint256 _balance);
94     function ownerOf(uint _tokenId) public view returns (address _owner);
95     function transfer(address _to, uint _tokenId) internal;
96     function implementsERC721() public view returns (bool _implementsERC721);
97 
98   
99     function approve(address _to, uint _tokenId) internal;
100     function transferFrom(address _from, address _to, uint _tokenId) internal;
101 
102    
103     // Events
104     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
105     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
106 }
107 
108 /**
109  * Interface for optional functionality in the ERC721 standard
110  * for non-fungible tokens.
111  *
112  *  
113  * Borrowed in part from Token Standard discussion board
114  */
115  
116 contract DetailedERC721 is ERC721 {
117     function name() public view returns (string _name);
118     function symbol() public view returns (string _symbol);
119    // function tokenMetadata(uint _tokenId) public view returns (string _infoUrl);
120     function tokenOfOwnerByIndex(address _owner, uint _index) public view returns (uint _tokenId);
121 }
122 
123 /**
124  * @title NonFungibleToken
125  *
126  * Generic implementation for both required and optional functionality in
127  * the ERC721 standard for non-fungible tokens.
128  *
129  * Borrowed in part from Token Standard discussion board
130  */
131  
132 contract NonFungibleToken is DetailedERC721 {
133     string public name;
134     string public symbol;
135 
136     uint public numTokensTotal;
137     uint public currentTokenIdNumber;
138 
139     mapping(uint => address) internal tokenIdToOwner;
140     mapping(uint => address) internal tokenIdNumber;
141     mapping(uint => address) internal tokenIdToApprovedAddress;
142    // mapping(uint => string) internal tokenIdToMetadata;
143     mapping(address => uint[]) internal ownerToTokensOwned;
144     mapping(uint => uint) internal tokenIdToOwnerArrayIndex;
145 
146     event Transfer(
147         address indexed _from,
148         address indexed _to,
149         uint256 _tokenId
150     );
151 
152     event Approval(
153         address indexed _owner,
154         address indexed _approved,
155         uint256 _tokenId
156     );
157 
158     modifier onlyExtantToken(uint _tokenId) {
159         require(ownerOf(_tokenId) != address(0));
160         _;
161     }
162 
163     function name()
164         public
165         view
166         returns (string _name)
167     {
168         return name;
169     }
170 
171     function symbol()
172         public
173         view
174         returns (string _symbol)
175     {
176         return symbol;
177     }
178 
179     function totalSupply()
180         public
181         view
182         returns (uint256 _totalSupply)
183     {
184         return numTokensTotal;
185     }
186     
187     function currentIDnumber()
188         public
189         view
190         returns (uint256 _tokenId)
191     {
192         return currentTokenIdNumber;
193     }
194 
195     function balanceOf(address _owner)
196         public
197         view
198         returns (uint _balance)
199     {
200         return ownerToTokensOwned[_owner].length;
201     }
202 
203     function ownerOf(uint _tokenId)
204         public
205         view
206         returns (address _owner)
207     {
208         return _ownerOf(_tokenId);
209     }
210     
211    /*  NOT USED
212     function tokenMetadata(uint _tokenId)
213         public
214         view
215         returns (string _infoUrl)
216     {
217         return tokenIdToMetadata[_tokenId];
218     }
219  */
220     function approve(address _to, uint _tokenId)
221         internal
222         onlyExtantToken(_tokenId)
223     {
224         require(msg.sender == ownerOf(_tokenId));
225         require(msg.sender != _to);
226 
227         if (_getApproved(_tokenId) != address(0) ||
228                 _to != address(0)) {
229             _approve(_to, _tokenId);
230             Approval(msg.sender, _to, _tokenId);
231         }
232     }
233 
234   
235     function transferFrom(address _from, address _to, uint _tokenId)
236         internal
237         onlyExtantToken(_tokenId)
238     {
239         require(getApproved(_tokenId) == msg.sender);
240         require(ownerOf(_tokenId) == _from);
241         require(_to != address(0));
242 
243         _clearApprovalAndTransfer(_from, _to, _tokenId);
244 
245         Approval(_from, 0, _tokenId);
246         Transfer(_from, _to, _tokenId);
247     }
248 
249     function auctiontransfer(address _currentowner, address _to, uint _tokenId)
250         internal
251         onlyExtantToken(_tokenId)
252     {
253         require(ownerOf(_tokenId) == _currentowner);
254         require(_to != address(0));
255 
256         _clearApprovalAndTransfer(_currentowner, _to, _tokenId);
257 
258         Approval(_currentowner, 0, _tokenId);
259         Transfer(_currentowner, _to, _tokenId);
260     }
261    
262 
263     function transfer(address _to, uint _tokenId)
264         internal 
265         onlyExtantToken(_tokenId)
266     {
267         require(ownerOf(_tokenId) == msg.sender);
268         require(_to != address(0));
269 
270         _clearApprovalAndTransfer(msg.sender, _to, _tokenId);
271 
272         Approval(msg.sender, 0, _tokenId);
273         Transfer(msg.sender, _to, _tokenId);
274     }
275 
276     function tokenOfOwnerByIndex(address _owner, uint _index)
277         public
278         view
279         returns (uint _tokenId)
280     {
281         return _getOwnerTokenByIndex(_owner, _index);
282     }
283 
284     function getOwnerTokens(address _owner)
285         public
286         view
287         returns (uint[] _tokenIds)
288     {
289         return _getOwnerTokens(_owner);
290     }
291 
292     function implementsERC721()
293         public
294         view
295         returns (bool _implementsERC721)
296     {
297         return true;
298     }
299 
300     function getApproved(uint _tokenId)
301         public
302         view
303         returns (address _approved)
304     {
305         return _getApproved(_tokenId);
306     }
307 
308     function _clearApprovalAndTransfer(address _from, address _to, uint _tokenId)
309         internal
310     {
311         _clearTokenApproval(_tokenId);
312         _removeTokenFromOwnersList(_from, _tokenId);
313         _setTokenOwner(_tokenId, _to);
314         _addTokenToOwnersList(_to, _tokenId);
315     }
316 
317     function _ownerOf(uint _tokenId)
318         internal
319         view
320         returns (address _owner)
321     {
322         return tokenIdToOwner[_tokenId];
323     }
324 
325    
326     function _approve(address _to, uint _tokenId)
327         internal
328     {
329         tokenIdToApprovedAddress[_tokenId] = _to;
330     }
331 
332     function _getApproved(uint _tokenId)
333         internal
334         view
335         returns (address _approved)
336     {
337         return tokenIdToApprovedAddress[_tokenId];
338     }
339 
340     function _getOwnerTokens(address _owner)
341         internal
342         view
343         returns (uint[] _tokens)
344     {
345         return ownerToTokensOwned[_owner];
346     }
347 
348     function _getOwnerTokenByIndex(address _owner, uint _index)
349         internal
350         view
351         returns (uint _tokens)
352     {
353         return ownerToTokensOwned[_owner][_index];
354     }
355 
356 
357     function _clearTokenApproval(uint _tokenId)
358         internal
359     {
360         tokenIdToApprovedAddress[_tokenId] = address(0);
361     }
362 
363 
364     function _setTokenOwner(uint _tokenId, address _owner)
365         internal
366     {
367         tokenIdToOwner[_tokenId] = _owner;
368     }
369 
370     function _addTokenToOwnersList(address _owner, uint _tokenId)
371         internal
372     {
373         ownerToTokensOwned[_owner].push(_tokenId);
374         tokenIdToOwnerArrayIndex[_tokenId] =
375             ownerToTokensOwned[_owner].length - 1;
376     }
377 
378     function _removeTokenFromOwnersList(address _owner, uint _tokenId)
379         internal
380     {
381         uint length = ownerToTokensOwned[_owner].length;
382         uint index = tokenIdToOwnerArrayIndex[_tokenId];
383         uint swapToken = ownerToTokensOwned[_owner][length - 1];
384 
385         ownerToTokensOwned[_owner][index] = swapToken;
386         tokenIdToOwnerArrayIndex[swapToken] = index;
387 
388         delete ownerToTokensOwned[_owner][length - 1];
389         ownerToTokensOwned[_owner].length--;
390     }
391 
392 /* Not Used
393     function _insertTokenMetadata(uint _tokenId, string _metadata)
394         internal
395     {
396         tokenIdToMetadata[_tokenId] = _metadata;
397     }
398    
399  */  
400 }
401 
402 /**
403  * @title MintableNonFungibleToken
404  *
405  * Superset of the ERC721 standard that allows for the minting
406  * of non-fungible tokens.
407  * Borrowed from Token Standard discussion board
408  */
409  
410 contract MintableNonFungibleToken is NonFungibleToken {
411     using SafeMath for uint;
412 
413     event Mint(address indexed _to, uint256 indexed _tokenId);
414 
415     modifier onlyNonexistentToken(uint _tokenId) {
416         require(tokenIdToOwner[_tokenId] == address(0));
417         _;
418     }
419 
420     function mint(address _owner, uint256 _tokenId)
421         internal
422         onlyNonexistentToken(_tokenId)
423     {
424         _setTokenOwner(_tokenId, _owner);
425         _addTokenToOwnersList(_owner, _tokenId);
426         //_insertTokenMetadata(_tokenId, _metadata);
427 
428         numTokensTotal = numTokensTotal.add(1);
429 
430         Mint(_owner, _tokenId);
431     }
432    
433     
434 }
435 
436 /**
437  * @title Auction
438  *
439  * BillionTix proprietary Auction 
440  * of BillionTix
441  * Developed Exclusively for and by BillionTix Jan 31 2018
442  */
443  
444 contract Auction is NonFungibleToken, Ownable {
445             using SafeMath for uint256;
446 
447     
448     struct ActiveAuctionsStruct {
449     address auctionOwner;
450     uint isBeingAuctioned; 
451     //1=Being Auctioned 0=Not Being Auctioned
452     uint startingPrice;
453     uint buynowPrice;
454     uint highestBid;
455     uint numberofBids;
456     uint auctionEnd;
457     uint lastSellingPrice;
458     address winningBidder;
459     
460   }
461   
462   struct ActiveAuctionsByAddressStruct {
463       
464       uint tixNumberforSale;
465       
466   }
467   
468  
469     mapping(uint => ActiveAuctionsStruct) private activeAuctionsStructs;
470     mapping(address => uint[]) private activeAuctionsByAddressStructs;
471 
472     event LiveAuctionEvent (address auctionowner, uint indexed tixNumberforSale, uint indexed startingPrice, uint indexed buynowPrice, uint auctionLength);
473     event RunningAuctionsEvent (address auctionowner, uint indexed tixNumberforSale, uint indexed isBeingAuctioned, uint auctionLength);
474     event SuccessAuctionEvent (address auctionowner, address auctionwinner, uint indexed tixNumberforSale, uint indexed winningPrice);
475     event CanceledAuctionEvent (address auctionowner, address highestbidder, uint indexed tixNumberforSale, uint indexed highestbid);
476     event BuyNowEvent (address auctionowner, address ticketbuyer, uint indexed tixNumberforSale, uint indexed purchaseprice);
477     event LogBid (address auctionowner, address highestbidder, uint indexed tixNumberforSale, uint indexed highestbid, uint indexed bidnumber);
478     event LogRefund (address losingbidder, uint indexed tixNumberforSale, uint indexed refundedamount);
479     event CreationFailedEvent (address auctionrequestedby, uint indexed tixNumberforSale, string approvalstatus);
480     event BidFailedEvent (address bidder, uint tixNumberforSale, string bidfailure);
481 
482     
483     address ticketownwer;
484     address public auctionleader;
485 
486     string public approval = "Auction Approved";
487     string public notapproved = "You Do Not Own This Ticket or Ticket is Already For Sale";
488     string public bidfailure ="Bid Failure";
489    
490     uint public tixNumberforSale;
491     uint public leadingBid;
492     uint public startingPrice;
493     uint public winningPrice;
494     uint public buynowPrice;
495     uint public auctionLength;
496     uint256 public ownerCut;
497     uint256 public cancelCost;
498     
499     uint[] public runningauctions;
500  
501     function Auction() public {
502         //Only called once when contract created.  Put initialization constructs here if needed
503     }
504     
505 
506     function createAuction (uint _startprice, uint _buynowprice, uint _tixforsale, uint _auctiontime) public  {
507         
508         require (_startprice >= 0);
509         require (_buynowprice >= 0);
510         require (_tixforsale > 0);
511         require (_auctiontime > 0);
512         
513         address auctionowner = msg.sender;
514         tixNumberforSale = _tixforsale;
515         ticketownwer = ownerOf(tixNumberforSale);
516         auctionLength = _auctiontime;
517          
518         var auctionDetails = activeAuctionsStructs[tixNumberforSale];
519 
520         uint auctionstatus = auctionDetails.isBeingAuctioned;
521 
522 
523         if (auctionowner == ticketownwer && auctionstatus != 1) {
524          
525          startingPrice = _startprice;
526          buynowPrice = _buynowprice;
527          auctionDetails.auctionOwner = auctionowner;
528          auctionDetails.startingPrice = startingPrice;
529          auctionDetails.buynowPrice = buynowPrice;
530          auctionDetails.highestBid = startingPrice;
531          auctionDetails.isBeingAuctioned = 1;
532          auctionDetails.numberofBids = 0;
533          auctionDetails.auctionEnd = now + auctionLength;
534          runningauctions.push(tixNumberforSale);
535 
536      
537          activeAuctionsByAddressStructs[auctionowner].push(tixNumberforSale);
538          LiveAuctionEvent(auctionowner, tixNumberforSale, startingPrice, buynowPrice, auctionDetails.auctionEnd);
539 
540        
541         } else {
542             
543         CreationFailedEvent(msg.sender, tixNumberforSale, notapproved);
544         revert();
545 
546         }
547     
548     }
549    
550     function placeBid(uint _tixforsale) payable public{
551        
552 
553       var auctionDetails = activeAuctionsStructs[_tixforsale];
554       uint auctionavailable = auctionDetails.isBeingAuctioned;
555       uint leadbid = auctionDetails.highestBid;
556       uint bidtotal = auctionDetails.numberofBids;
557       address auctionowner = auctionDetails.auctionOwner;
558       address leadingbidder = auctionDetails.winningBidder;
559       uint endofauction = auctionDetails.auctionEnd;
560       
561       require (now <= endofauction);
562       require (auctionavailable == 1);
563       require (msg.value > leadbid);
564       
565         if (msg.value > leadbid) {
566            
567             auctionDetails.winningBidder = msg.sender;
568             auctionDetails.highestBid = msg.value;
569             auctionDetails.numberofBids++;
570             uint bidnumber = auctionDetails.numberofBids;
571             
572              if (bidtotal > 0) {
573             returnPrevBid(leadingbidder, leadbid, _tixforsale);
574            }
575             LogBid(auctionowner, auctionDetails.winningBidder, _tixforsale, auctionDetails.highestBid, bidnumber);
576         }
577         else {
578             
579             BidFailedEvent(msg.sender, _tixforsale, bidfailure);
580             revert();
581             
582         }
583     
584     
585         
586     }
587    
588     function returnPrevBid(address _highestbidder, uint _leadbid, uint _tixnumberforsale) internal {
589       
590         if (_highestbidder != 0 && _leadbid > 0) {
591            
592             _highestbidder.transfer(_leadbid);
593             
594             LogRefund(_highestbidder, _tixnumberforsale, _leadbid);
595         
596         }
597     }
598     
599     function setOwnerCut(uint256 _ownercut) onlyOwner public {
600        
601        ownerCut = _ownercut;
602        
603        
604    }
605    
606    function setCostToCancel(uint256 _cancelcost) onlyOwner public {
607        
608        cancelCost = _cancelcost;
609        
610        
611    }
612    
613     function getCostToCancel() view public returns (uint256) {
614        
615        return cancelCost;
616        
617        
618    }
619     
620 
621     //END AUCTION FUNCTION CAN BE CALLED AFTER AUCTION TIME IS UP BY EITHER SELLER OR WINNING PARTY
622     
623     function endAuction(uint _tixnumberforsale) public {
624         
625 
626       var auctionDetails = activeAuctionsStructs[_tixnumberforsale];
627       uint auctionEnd = auctionDetails.auctionEnd;
628       address auctionowner = auctionDetails.auctionOwner;
629       address auctionwinner = auctionDetails.winningBidder;
630       uint256 winningBid = auctionDetails.highestBid;
631       uint numberofBids = auctionDetails.numberofBids;
632 
633         require (now > auctionEnd);
634 
635        if ((msg.sender == auctionowner || msg.sender == auctionwinner) && numberofBids > 0 && winningBid > 0) {
636           
637 
638            uint256 ownersCut = winningBid * ownerCut / 10000;
639         
640            owner.transfer(ownersCut);
641            auctionowner.transfer(auctionDetails.highestBid - ownersCut);
642            auctiontransfer(auctionowner, auctionwinner, _tixnumberforsale);
643            auctionDetails.isBeingAuctioned = 0;
644            auctionDetails.auctionEnd = 0;
645            auctionDetails.numberofBids = 0;
646            auctionDetails.highestBid = 0;
647            auctionDetails.buynowPrice = 0;
648            auctionDetails.startingPrice = 0;
649            removeByValue(_tixnumberforsale);
650            SuccessAuctionEvent(auctionowner, auctionwinner, _tixnumberforsale, winningBid);
651            
652        }
653        
654        if (msg.sender == auctionowner && numberofBids == 0) {
655           
656 
657            auctionDetails.isBeingAuctioned = 0;
658            auctionDetails.auctionEnd = 0;
659            auctionDetails.numberofBids = 0;
660            auctionDetails.highestBid = 0;
661            auctionDetails.buynowPrice = 0;
662            auctionDetails.startingPrice = 0;
663 
664            removeByValue(_tixnumberforsale);
665 
666            SuccessAuctionEvent(auctionowner, auctionwinner, _tixnumberforsale, winningBid);
667            
668        }
669        
670        
671        
672        
673    }
674    
675    
676   
677 
678    //CANCEL AUCTION CAN ONLY BE CALLED BY AUCTION OWNER - ALL MONEY RETURNED TO HIGHEST BIDDER. COSTS ETHER
679    
680    function cancelAuction(uint _tixnumberforsale) payable public {
681        
682             
683         var auctionDetails = activeAuctionsStructs[_tixnumberforsale];
684         uint auctionEnd = auctionDetails.auctionEnd;
685         uint numberofBids = auctionDetails.numberofBids;
686 
687         require (now < auctionEnd);
688         
689         
690         
691          uint256 highestBid = auctionDetails.highestBid;
692          address auctionwinner = auctionDetails.winningBidder;
693          address auctionowner = auctionDetails.auctionOwner;
694          
695                 if (msg.sender == auctionowner && msg.value >= cancelCost && numberofBids > 0) {
696 
697         
698                         auctionwinner.transfer(highestBid);
699                         LogRefund(auctionwinner, _tixnumberforsale, highestBid);
700 
701                         owner.transfer(cancelCost);
702                         
703                         auctionDetails.isBeingAuctioned = 0;
704                         auctionDetails.auctionEnd = 0;
705                         auctionDetails.numberofBids = 0;
706                         auctionDetails.highestBid = 0;
707                         auctionDetails.buynowPrice = 0;
708                         auctionDetails.startingPrice = 0;
709 
710                         removeByValue(_tixnumberforsale);
711 
712 
713               CanceledAuctionEvent(auctionowner, auctionwinner, _tixnumberforsale, highestBid);
714 
715                 } 
716                 
717                 if (msg.sender == auctionowner && msg.value >= cancelCost && numberofBids == 0) {
718 
719                         owner.transfer(cancelCost);
720                         
721                         auctionDetails.isBeingAuctioned = 0;
722                         auctionDetails.auctionEnd = 0;
723                         auctionDetails.numberofBids = 0;
724                         auctionDetails.highestBid = 0;
725                         auctionDetails.buynowPrice = 0;
726                         auctionDetails.startingPrice = 0;
727 
728                         removeByValue(_tixnumberforsale);
729 
730 
731               CanceledAuctionEvent(auctionowner, auctionwinner, _tixnumberforsale, highestBid);
732 
733                 }
734 
735        
736    }
737    
738 
739    //Buy Now Cancels Auction with no Penalty and returns all placed bids.  Contract takes cut of buy now price
740 
741    function buyNow(uint _tixnumberforsale) payable public {
742        
743 
744      var auctionDetails = activeAuctionsStructs[_tixnumberforsale];
745       uint auctionEnd = auctionDetails.auctionEnd;
746       address auctionowner = auctionDetails.auctionOwner;
747       address auctionlead = auctionDetails.winningBidder;
748       uint256 highestBid = auctionDetails.highestBid;
749       uint256 buynowprice = auctionDetails.buynowPrice;
750       
751       uint256 buynowcut = ownerCut;
752     
753       uint256 buynowownersCut = buynowPrice * buynowcut / 10000;
754 
755 
756       require(buynowprice > 0);
757       require(now < auctionEnd);
758         
759       if (msg.value == buynowPrice) {
760           
761 
762           auctionowner.transfer(buynowPrice - buynowownersCut);
763           owner.transfer(buynowownersCut);
764          
765          
766           auctiontransfer(auctionowner, msg.sender, _tixnumberforsale);
767           auctionDetails.isBeingAuctioned = 0;
768           auctionDetails.auctionEnd = 0;
769           auctionDetails.numberofBids = 0;
770           auctionDetails.highestBid = 0;
771           auctionDetails.buynowPrice = 0;
772           auctionDetails.startingPrice = 0;
773 
774           removeByValue(_tixnumberforsale);
775 
776 
777           BuyNowEvent(auctionowner, msg.sender, _tixnumberforsale, msg.value);
778           
779            if (auctionDetails.numberofBids > 0) {
780          
781           returnPrevBid(auctionlead, highestBid, _tixnumberforsale);
782 
783          }
784           
785           
786       } else {
787           
788           revert();
789       }
790        
791    }
792    
793     function withdraw(address forwardAddress, uint amount) public onlyOwner {
794 
795         forwardAddress.transfer(amount);
796 
797 }
798    
799  
800     function getAuctionDetails(uint tixnumberforsale)
801         public
802         view
803         returns (uint _startingprice, uint _buynowprice, uint _numberofBids, uint _highestBid, uint _auctionEnd, address winningBidder, address _auctionOwner)
804     {
805         return (
806          activeAuctionsStructs[tixnumberforsale].startingPrice,
807          activeAuctionsStructs[tixnumberforsale].buynowPrice,
808          activeAuctionsStructs[tixnumberforsale].numberofBids,
809          activeAuctionsStructs[tixnumberforsale].highestBid,
810          activeAuctionsStructs[tixnumberforsale].auctionEnd,
811          activeAuctionsStructs[tixnumberforsale].winningBidder,
812          activeAuctionsStructs[tixnumberforsale].auctionOwner);
813          
814 
815     }
816     
817     //Had to split due to stack limitations of Solidity - Pull back together in UI
818     
819     function getMoreAuctionDetails(uint tixnumberforsale) public view returns (uint _auctionstatus, uint _auctionEnd, address _auctionOwner) {
820         
821      return (
822                     
823                     activeAuctionsStructs[tixnumberforsale].isBeingAuctioned,
824                     activeAuctionsStructs[tixnumberforsale].auctionEnd,
825                     activeAuctionsStructs[tixnumberforsale].auctionOwner);
826         
827     }
828    
829     
830      function getOwnerAuctions(address _auctionowner)
831         public
832         view
833         returns (uint[] _auctions)
834     {
835        
836         return activeAuctionsByAddressStructs[_auctionowner];
837     }
838   
839     
840   //FUNCTIONS USED TO KEEP ACCURATE ARRAY OF LIVE AUCTIONS
841   
842   function find(uint value) view public returns(uint) {
843         uint i = 0;
844         while (runningauctions[i] != value) {
845             i++;
846         }
847         return i;
848     }
849 
850     function removeByValue(uint value) internal {
851         uint i = find(value);
852         removeByIndex(i);
853     }
854 
855     function removeByIndex(uint i) internal {
856         while (i<runningauctions.length-1) {
857             runningauctions[i] = runningauctions[i+1];
858             i++;
859         }
860         runningauctions.length--;
861     }
862 
863     function getRunningAuctions() constant public returns(uint[]) {
864         return runningauctions;
865     }
866 
867 
868      function() payable public {}
869 
870    
871 }
872 
873 
874 /**
875  * @title BillionTix
876  *
877  * Main BillionTix Contract. Controls creation of BillionTix and  
878  * selecting and Paying Giveaway Winners
879  * Developed Exclusively for and by BillionTix Jan 31 2018
880  */
881  
882 contract Billiontix is MintableNonFungibleToken, Auction {
883    address owner;
884 
885     string public name = 'BillionTix';
886     string public symbol = 'BTIX';
887    
888     string internal TenTimesEther = "0.005 Ether";
889     string internal OneHundredTimesEther = "0.05 Ether";
890     string internal OneThousandTimesEther = "0.5 Ether";
891     string internal TenThousandTimesEther = "5 Ether";
892     string internal OneHundredThousandTimesEther = "50 Ether";
893     string internal OneMillionTimesEther = "500 Ether";
894     string internal TenMillionTimesEther = "5,000 Ether";
895     string internal OneHundredMillionTimesEther = "50,000 Ether";
896     string internal OneBillionTimesEther = "500,000 Ether";
897    
898    
899     //SET THESE PRICES IN WEI
900     
901     uint256 public buyPrice =      500000000000000;
902     uint256 public buy5Price =    2500000000000000;
903     uint256 public buy10Price =   5000000000000000;
904     uint256 public buy20Price =  10000000000000000;
905     uint256 public buy50Price =  25000000000000000;
906     uint256 public buy100Price = 50000000000000000;
907 
908     address public winner;
909   
910    //These are the supertix numbers. They will NOT CHANGE
911    
912     uint[] supertixarray = [10000,100000,500000,1000000,5000000,10000000,50000000,100000000,500000000,750000000];
913 
914  
915     mapping(address => uint256) public balanceOf; 
916     
917     event PayoutEvent (uint indexed WinningNumber, address indexed _to, uint indexed value);
918     event WinningNumbersEvent (uint256 indexed WinningNumber, string AmountWon); 
919     event WinnerPaidEvent (address indexed Winner, string AmountWon);
920     
921 
922 
923   function buy () payable public 
924    onlyNonexistentToken(_tokenId)
925     {
926        
927        if ((msg.value) == buyPrice) {
928            
929            
930         uint256 _tokenId = numTokensTotal +1;
931         _setTokenOwner(_tokenId, msg.sender);
932         _addTokenToOwnersList(msg.sender, _tokenId);
933        // _insertTokenMetadata(_tokenId, _metadata);
934 
935        numTokensTotal = numTokensTotal.add(1);
936 
937         Mint(msg.sender, _tokenId);          
938 
939        if (numTokensTotal > 1 && numTokensTotal < 10000000002) {
940        playDraw();
941        playDraw2();
942        supertixdraw();
943        } else { }
944 
945 
946        }
947        else {
948           
949        }
950        
951    }
952    
953    
954      function buy5 () payable public 
955    onlyNonexistentToken(_tokenId)
956     {
957        for (uint i = 0; i < 5; i++) {
958        if ((msg.value) == buy5Price) {
959            
960         uint256 _tokenId = numTokensTotal +1;
961         _setTokenOwner(_tokenId, msg.sender);
962         _addTokenToOwnersList(msg.sender, _tokenId);
963        // _insertTokenMetadata(_tokenId, _metadata);
964 
965        numTokensTotal = numTokensTotal.add(1);
966 
967         Mint(msg.sender, _tokenId);          
968 
969        if (numTokensTotal > 1 && numTokensTotal < 10000000002) {
970        playDraw();
971        playDraw2();
972        supertixdraw();
973 
974        } else { 
975        }
976        
977        }
978        else {
979        }
980        }
981    }
982 
983 
984   function buy10 () payable public 
985    onlyNonexistentToken(_tokenId)
986     {
987        for (uint i = 0; i < 10; i++) {
988        if ((msg.value) == buy10Price) {
989            
990         uint256 _tokenId = numTokensTotal +1;
991         _setTokenOwner(_tokenId, msg.sender);
992         _addTokenToOwnersList(msg.sender, _tokenId);
993        // _insertTokenMetadata(_tokenId, _metadata);
994 
995        numTokensTotal = numTokensTotal.add(1);
996 
997         Mint(msg.sender, _tokenId);          
998 
999        if (numTokensTotal > 1 && numTokensTotal < 10000000002) {
1000        playDraw();
1001        playDraw2();
1002        supertixdraw();
1003 
1004        } else { }
1005        }
1006        else {
1007           
1008        }
1009        }
1010    }
1011       
1012     function buy20 () payable public 
1013    onlyNonexistentToken(_tokenId)
1014     {
1015        for (uint i = 0; i < 20; i++) {
1016        if ((msg.value) == buy20Price) {
1017            
1018         uint256 _tokenId = numTokensTotal +1;
1019         _setTokenOwner(_tokenId, msg.sender);
1020         _addTokenToOwnersList(msg.sender, _tokenId);
1021        // _insertTokenMetadata(_tokenId, _metadata);
1022 
1023        numTokensTotal = numTokensTotal.add(1);
1024 
1025         Mint(msg.sender, _tokenId);          
1026 
1027        if (numTokensTotal > 1 && numTokensTotal < 10000000002) {
1028        playDraw();
1029        playDraw2();
1030         supertixdraw();
1031         
1032       } else { }
1033        }
1034        else {
1035           
1036        }
1037        }
1038    }
1039    
1040     function buy50 () payable public 
1041    onlyNonexistentToken(_tokenId)
1042     {
1043        for (uint i = 0; i < 50; i++) {
1044        if ((msg.value) == buy50Price) {
1045            
1046          uint256 _tokenId = numTokensTotal +1;
1047         _setTokenOwner(_tokenId, msg.sender);
1048         _addTokenToOwnersList(msg.sender, _tokenId);
1049        // _insertTokenMetadata(_tokenId, _metadata);
1050 
1051        numTokensTotal = numTokensTotal.add(1);
1052 
1053         Mint(msg.sender, _tokenId);          
1054 
1055        if (numTokensTotal > 1 && numTokensTotal < 10000000002) {
1056        playDraw();
1057        playDraw2();
1058         supertixdraw();
1059    
1060        } else { }
1061        }
1062        else {
1063           
1064        }
1065        }
1066    }
1067    
1068     function buy100 () payable public 
1069    onlyNonexistentToken(_tokenId)
1070     {
1071        for (uint i = 0; i < 100; i++) {
1072        if ((msg.value) == buy100Price) {
1073            
1074         uint256 _tokenId = numTokensTotal +1;
1075         _setTokenOwner(_tokenId, msg.sender);
1076         _addTokenToOwnersList(msg.sender, _tokenId);
1077        // _insertTokenMetadata(_tokenId, _metadata);
1078 
1079        numTokensTotal = numTokensTotal.add(1);
1080 
1081         Mint(msg.sender, _tokenId);          
1082 
1083        if (numTokensTotal > 1 && numTokensTotal < 10000000002) {
1084        playDraw();
1085        playDraw2();
1086        supertixdraw();
1087 
1088        } else { }
1089        }
1090        else {
1091           
1092        }
1093        }
1094    }
1095 
1096    
1097  function playDraw() internal returns (uint winningrandomNumber1, 
1098  uint winningrandomNumber2, 
1099  uint winningrandomNumber3, 
1100  uint winningrandomNumber4, 
1101  uint winningrandomNumber5)  {
1102      
1103 
1104      uint A = ((numTokensTotal / 1) % 10);
1105      uint B = ((numTokensTotal / 10) % 10);
1106      uint C = ((numTokensTotal / 100) % 10);
1107      uint D = ((numTokensTotal / 1000) % 10);
1108      uint E = ((numTokensTotal / 10000) % 10);
1109      uint F = ((numTokensTotal / 100000) % 10);
1110      uint G = ((numTokensTotal / 1000000) % 10);
1111      uint H = ((numTokensTotal / 10000000) % 10);
1112      uint I = ((numTokensTotal / 100000000) % 10);
1113      uint J = ((numTokensTotal / 1000000000) % 10);
1114 
1115   
1116      
1117        if (A == 1 && B == 0) {
1118          
1119          winningrandomNumber1 = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 1))%100 + (1000000000 * J) + (100000000 * I) + (10000000 * H) + (1000000 * G) + (100000 * F) + (10000 * E) + (1000 * D) + (100 * (C - 1)));
1120         
1121          WinningNumbersEvent(winningrandomNumber1, TenTimesEther);
1122          
1123 
1124         // PAY OUT THE WINNER HERE AFTER LOGGING WINNING NUMBER IN EVENT Pays 10x Ether - 0.005
1125 
1126          winner = ownerOf(winningrandomNumber1);
1127          payWinner(winner, 5000000000000000); 
1128          
1129          WinnerPaidEvent(winner, TenTimesEther);
1130 
1131         
1132      } else {
1133          //Do stuff here with non winning ticket if needed
1134      }
1135 
1136  if (A == 1 && B == 0 && C == 0) {
1137          
1138          winningrandomNumber2 = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 2))%1000 + (1000000000 * J) + (100000000 * I) + (10000000 * H) + (1000000 * G) + (100000 * F) + (10000 * E) + (1000 * (D - 1)));
1139              
1140          WinningNumbersEvent(winningrandomNumber2, OneHundredTimesEther);
1141 
1142 
1143         // PAY OUT THE WINNER HERE AFTER LOGGING WINNING NUMBER IN EVENT
1144         // PAYS 100x Ether
1145 
1146          winner = ownerOf(winningrandomNumber2);
1147          payWinner(winner, 50000000000000000); 
1148          payBilliontixOwner();
1149 
1150          WinnerPaidEvent(winner, OneHundredTimesEther);
1151   
1152      
1153      } else {
1154          //Do stuff here with non winning ticket if needed
1155      }
1156  
1157  if (A == 1 && B == 0 && C == 0 && D == 0) {
1158          
1159           winningrandomNumber3 = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 3))%10000 + (1000000000 * J) + (100000000 * I) + (10000000 * H) + (1000000 * G) + (100000 * F) + (10000 * (E - 1)));
1160           WinningNumbersEvent(winningrandomNumber3, OneThousandTimesEther);
1161 
1162 
1163       // PAY OUT THE WINNER HERE AFTER LOGGING WINNING NUMBER IN EVENT
1164       // PAYS 1,000x Ether   
1165       
1166         winner = ownerOf(winningrandomNumber3);
1167         payWinner(winner, 500000000000000000); 
1168         WinnerPaidEvent(winner, OneThousandTimesEther);
1169 
1170 
1171      } else {
1172          //Do stuff here with non winning ticket if needed
1173      }
1174 
1175      if (A == 1 && B == 0 && C == 0 && D == 0 && E == 0) {
1176          
1177           winningrandomNumber4 = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 4))%100000 + (1000000000 * J) + (100000000 * I) + (10000000 * H) + (1000000 * G) + (100000 * (F - 1)));
1178           WinningNumbersEvent(winningrandomNumber4, TenThousandTimesEther);
1179 
1180 
1181       // PAY OUT THE WINNER HERE AFTER LOGGING WINNING NUMBER IN EVENT
1182       // PAYS 10,000x Ether
1183          
1184          winner = ownerOf(winningrandomNumber4);
1185          payWinner(winner, 5000000000000000000); 
1186          
1187          WinnerPaidEvent(winner, TenThousandTimesEther);
1188 
1189          
1190      } else {
1191          //Do stuff here with non winning ticket if needed
1192      }
1193      
1194   if (A == 1 && B == 0 && C == 0 && D == 0 && E == 0 && F == 0) {
1195          
1196           winningrandomNumber5 = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 5))%1000000 + (1000000000 * J) + (100000000 * I) + (10000000 * H) + (1000000 * (G - 1)));
1197           WinningNumbersEvent(winningrandomNumber5, OneHundredThousandTimesEther);
1198 
1199         // PAY OUT THE WINNER HERE AFTER LOGGING WINNING NUMBER IN EVENT
1200         // PAYS 100,000x Ether
1201 
1202          winner = ownerOf(winningrandomNumber5);
1203          payWinner(winner, 50000000000000000000); 
1204          
1205         WinnerPaidEvent(winner, OneHundredThousandTimesEther);
1206 
1207          
1208      } else {
1209          //Do stuff here with non winning ticket if needed
1210      }
1211   
1212      
1213  }
1214  
1215  function playDraw2() internal returns (
1216  uint winningrandomNumber6,
1217  uint winningrandomNumber7,
1218  uint winningrandomNumber8,
1219  uint billiondollarwinningNumber) {
1220      
1221 
1222      uint A = ((numTokensTotal / 1) % 10);
1223      uint B = ((numTokensTotal / 10) % 10);
1224      uint C = ((numTokensTotal / 100) % 10);
1225      uint D = ((numTokensTotal / 1000) % 10);
1226      uint E = ((numTokensTotal / 10000) % 10);
1227      uint F = ((numTokensTotal / 100000) % 10);
1228      uint G = ((numTokensTotal / 1000000) % 10);
1229      uint H = ((numTokensTotal / 10000000) % 10);
1230      uint I = ((numTokensTotal / 100000000) % 10);
1231      uint J = ((numTokensTotal / 1000000000) % 10);
1232      uint K = ((numTokensTotal / 10000000000) % 10);
1233 
1234    
1235   
1236   if (A == 1 && B == 0 && C == 0 && D == 0 && E == 0 && F == 0 && G == 0) {
1237          
1238           winningrandomNumber6 = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 6))%10000000 + (1000000000 * J) + (100000000 * I) + (10000000 * (H - 1)));
1239           WinningNumbersEvent(winningrandomNumber6, OneMillionTimesEther);
1240 
1241 
1242         // PAY OUT THE WINNER HERE AFTER LOGGING WINNING NUMBER IN EVENT
1243         // PAYS 1,000,000x Ether
1244 
1245          winner = ownerOf(winningrandomNumber6);
1246          payWinner(winner, 500000000000000000000); 
1247          
1248          WinnerPaidEvent(winner, OneMillionTimesEther);
1249 
1250 
1251      } else {
1252          //Do stuff here with non winning ticket if needed
1253      }
1254      
1255       if (A == 1 && B == 0 && C == 0 && D == 0 && E == 0 && F == 0 && G == 0 && H == 0) {
1256          
1257          winningrandomNumber7 = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 7))%100000000 + (1000000000 * J) + (100000000 * (I - 1)));
1258          WinningNumbersEvent(winningrandomNumber7, TenMillionTimesEther);
1259 
1260 
1261        // PAY OUT THE WINNER HERE AFTER LOGGING WINNING NUMBER IN EVENT
1262        // PAYS 10,000,000x Ether
1263         
1264          winner = ownerOf(winningrandomNumber7);
1265          payWinner(winner, 5000000000000000000000);
1266          
1267          WinnerPaidEvent(winner, TenMillionTimesEther);
1268 
1269 
1270      
1271      } else {
1272          //Do stuff here with non winning ticket if needed
1273      }
1274  
1275      if (A == 1 && B == 0 && C == 0 && D == 0 && E == 0 && F == 0 && G == 0 && H == 0 && I == 0) {
1276          
1277           winningrandomNumber8 = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 8))%1000000000 + (1000000000 * (J - 1)));
1278           WinningNumbersEvent(winningrandomNumber8, OneHundredMillionTimesEther);
1279 
1280         // PAY OUT THE WINNER HERE AFTER LOGGING WINNING NUMBER IN ARRAY
1281         // PAYS 100,000,000x Ether
1282         
1283          winner = ownerOf(winningrandomNumber8);
1284          payWinner(winner, 50000000000000000000000);
1285          
1286          WinnerPaidEvent(winner, OneHundredMillionTimesEther);
1287 
1288         
1289      } else {
1290          //Do stuff here with non winning ticket if needed
1291      }
1292      
1293      if (A == 1 && B == 0 && C == 0 && D == 0 && E == 0 && F == 0 && G == 0 && H == 0 && I == 0 && J == 0 && K == 1) {
1294          
1295          billiondollarwinningNumber = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 9))%10000000000);
1296          WinningNumbersEvent(billiondollarwinningNumber, OneBillionTimesEther);
1297 
1298 
1299         //PAY OUT THE WINNER HERE AFTER LOGGING WINNING NUMBER IN EVENT
1300         // PAYS 1,000,000,000x Ether
1301     
1302          winner = ownerOf(billiondollarwinningNumber);
1303          payWinner(winner, 500000000000000000000000);
1304          
1305          WinnerPaidEvent(winner, OneBillionTimesEther);
1306 
1307 
1308      } else {
1309          //Do stuff here with non winning ticket if needed
1310      }
1311 
1312    
1313      
1314  }
1315  
1316  function supertixdraw()  internal returns (uint winningsupertixnumber) {
1317 
1318      uint A = ((numTokensTotal / 1) % 10);
1319      uint B = ((numTokensTotal / 10) % 10);
1320      uint C = ((numTokensTotal / 100) % 10);
1321      uint D = ((numTokensTotal / 1000) % 10);
1322      uint E = ((numTokensTotal / 10000) % 10);
1323      uint F = ((numTokensTotal / 100000) % 10);
1324      uint G = ((numTokensTotal / 1000000) % 10);
1325      uint H = ((numTokensTotal / 10000000) % 10);
1326      uint I = ((numTokensTotal / 100000000) % 10);
1327      uint J = ((numTokensTotal / 1000000000) % 10);
1328      
1329    
1330      
1331       if (A == 1 && B == 0 && C == 0 && D == 0 && E == 0 && F == 0 && G == 0 && H == 0 && I == 0 && J==1) {
1332           
1333           //AT TICKET 1Billion and 1 Sold - Give Away 10Million times Ether to SuperTix holder
1334           
1335            uint randomsupertixnumber = (uint(keccak256(block.blockhash(block.number-1), numTokensTotal + 2))%10);
1336 
1337            winningsupertixnumber = supertixarray[randomsupertixnumber];
1338        
1339            WinningNumbersEvent(winningsupertixnumber, TenMillionTimesEther);
1340 
1341          winner = ownerOf(winningsupertixnumber);
1342          payWinner(winner, 5000000000000000000000);
1343          
1344          WinnerPaidEvent(winner, TenMillionTimesEther);
1345 
1346         
1347      } else {
1348          //Do stuff here with non winning ticket if needed
1349      }
1350      
1351      
1352  }
1353 
1354  function Billiontix() public {
1355       owner = msg.sender;
1356    }
1357   
1358  function transferEther(address forwardAddress, uint amount) public onlyOwner {
1359 
1360         forwardAddress.transfer(amount);
1361 
1362 }
1363  
1364 
1365   function payWinner(address winnerAddress, uint amount) internal {
1366       
1367         winnerAddress.transfer(amount);
1368 
1369 }
1370  
1371  function payBilliontixOwner () internal {
1372      
1373      //This is Called at Every 1000 Level Giveaway to Give BillionTix Their Cut in Wei
1374      
1375       owner.transfer(50000000000000000);
1376      
1377  }
1378  
1379 
1380    function kill() public onlyOwner {
1381       if(msg.sender == owner)
1382          selfdestruct(owner);
1383    }
1384    
1385       function() payable public {}
1386       
1387 }