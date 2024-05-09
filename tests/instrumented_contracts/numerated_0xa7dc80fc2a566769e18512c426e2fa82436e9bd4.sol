1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title SafeMath32
51  * @dev SafeMath library implemented for uint32
52  */
53 library SafeMath32 {
54 
55   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
56     if (a == 0) {
57       return 0;
58     }
59     uint32 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint32 a, uint32 b) internal pure returns (uint32) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint32 c = a / b;
67     assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint32 a, uint32 b) internal pure returns (uint32) {
77     uint32 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 /**
84  * @title SafeMath8
85  * @dev SafeMath library implemented for uint8
86  */
87 library SafeMath8 {
88 
89   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
90     if (a == 0) {
91       return 0;
92     }
93     uint8 c = a * b;
94     assert(c / a == b);
95     return c;
96   }
97 
98   function div(uint8 a, uint8 b) internal pure returns (uint8) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     uint8 c = a / b;
101     assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return c;
103   }
104 
105   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
106     assert(b <= a);
107     return a - b;
108   }
109 
110   function add(uint8 a, uint8 b) internal pure returns (uint8) {
111     uint8 c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 
117 contract Ownable {
118 
119 	using SafeMath for uint256;
120 	using SafeMath32 for uint32;
121 	using SafeMath8 for uint8;
122 
123   address internal owner;
124   address public admin;
125 
126   event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
127 
128 
129   constructor() public {
130     owner = msg.sender;
131   }
132 
133 
134 
135   modifier onlyOwner() {
136     require(msg.sender == owner);
137     _;
138   }
139   
140   modifier onlyAdmin() {
141     require(msg.sender == admin);
142     _;
143   }
144 
145 
146   function transferAdminship(address newAdmin) public onlyOwner {
147     require(newAdmin != address(0));
148     emit AdminshipTransferred(admin, newAdmin);
149     admin = newAdmin;
150   }
151 
152 }
153 
154 contract Terminable is Ownable {
155 
156 
157 		function terminate() external onlyOwner {
158 			selfdestruct(owner);
159 		}
160 		
161 		
162 }
163 
164 contract ERC721 is Terminable {
165 
166   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
167   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
168   event ApprovalToAll(address indexed _owner, uint256 _tokenId);
169 
170 
171   
172 }
173 
174 contract AssFactory is ERC721 {
175 
176 	
177     
178     struct Ass {
179 		string name;
180 		uint32 id;
181 		string class;
182 		uint cardNumber;
183 		uint cardType;
184 		uint256 priceInSzabo;
185     }
186 	
187 	Ass[] public asses;
188 	
189 	
190 	mapping (uint => address) public assToOwner;
191 	mapping (address => uint) public ownerAssCount;
192 	
193 	
194 	modifier onlyOwnerOf(uint _id) {
195     require(msg.sender == assToOwner[_id]);
196     _;
197     }
198     
199     event Withdrawal(uint256 balance);
200     event AssCreated(bool done);
201     
202     event FeeChanged(uint _newFee);
203 	
204     function getAssTotal() public constant returns(uint) {
205     return asses.length;
206     }
207     
208     function getAssData(uint index) public view returns(string, uint, string, uint, uint, uint) {
209     return (asses[index].name, asses[index].id, asses[index].class, asses[index].cardNumber, asses[index].cardType, asses[index].priceInSzabo);
210     }
211 
212     
213       function getAssesByOwner(address _owner) external view returns(uint[]) {
214     uint[] memory result = new uint[](ownerAssCount[_owner]);
215     uint counter = 0;
216     for (uint i = 0; i < asses.length; i++) {
217       if (assToOwner[i.add(2536)] == _owner) {
218         result[counter] = i;
219         counter++;
220       }
221     }
222     return result;
223   }
224 
225 
226     function _createAss(string _name, uint32 _id, string _class, uint _cardNumber, uint _cardType, uint256 _priceInSzabo) private {
227 		asses.push(Ass(_name, _id, _class, _cardNumber, _cardType, _priceInSzabo));
228 		assToOwner[_id] = msg.sender;
229 		ownerAssCount[msg.sender] = ownerAssCount[msg.sender].add(1);
230 		bool done = true;
231 		emit AssCreated(done);
232     }
233 	
234 	function _getId() internal view returns(uint32){
235 		uint32 newId = uint32(asses.length.add(2536));
236 		return newId;
237 	}
238 	
239 	function startCreatingAss(string _name, string _class, uint _cardNumber, uint _cardType, uint256 _priceInSzabo) public onlyAdmin {
240 		uint32 newId = _getId();
241 		_createAss(_name, newId, _class, _cardNumber, _cardType, _priceInSzabo);
242 	}
243 	
244 
245     
246 
247 
248 	
249 	
250 }
251 
252 
253 
254 contract AssMarket is AssFactory {
255 
256 //---------Auction Variables------------------------------------------------------   
257     uint public NumberOfAuctions = 0;
258     uint public totalSzaboInBids = 0;
259     uint public bidFeePercents = 3;
260     uint public everyBidFee = 1800;
261     uint public startAuctionFee = 1800;
262     uint public maxDuration = 10;
263     uint public minBidDifferenceInSzabo = 1000;
264     
265     
266     
267     mapping(uint => uint) public auctionEndTime;
268     mapping(uint => uint) public auctionedAssId;
269     mapping(uint => address) public auctionOwner;
270     mapping(uint => bool) public auctionEnded;
271     mapping(uint => address) public highestBidderOf;
272     mapping(uint => uint) public highestBidOf;
273     mapping(uint => uint) public startingBidOf;
274     
275     mapping(uint => uint) public assInAuction;
276 //---------------------------------------------------------------------------------   
277 
278     	uint256 public approveFee = 1800;
279     	uint256 public takeOwnershipFeePercents = 3;
280     	uint256 public cancelApproveFee = 1800;
281     	
282     	mapping (uint => address) public assApprovals;
283     	mapping (uint => bool) public assToAllApprovals;
284     	
285         event PriceChanged(uint newPrice, uint assId);
286         event ApprovalCancelled(uint assId);
287         event AuctionReverted(uint auctionId);
288     	
289     	function setTakeOwnershipFeePercents(uint _newFee) public onlyAdmin {
290 		    takeOwnershipFeePercents = _newFee;	
291 		    emit FeeChanged(_newFee);
292 	    }
293     	
294 
295 	    
296 	    function setApproveFee(uint _newFee) public onlyAdmin {
297 		    approveFee = _newFee;	
298 		    emit FeeChanged(_newFee);
299 	    }
300 	    
301 	    function setCancelApproveFee(uint _newFee) public onlyAdmin {
302 		    cancelApproveFee = _newFee;	
303 		    emit FeeChanged(_newFee);
304 	    }
305 	    
306     
307 
308 	 function setPriceOfAss(uint256 _newPrice, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
309 		asses[_tokenId.sub(2536)].priceInSzabo = _newPrice;
310 		emit PriceChanged(_newPrice, _tokenId);
311 	 }
312 	 
313 	 function balanceOf(address _owner) public view returns (uint256 _balance) {
314 		return ownerAssCount[_owner];
315 	 }
316 	
317 	 function ownerOf(uint256 _tokenId) public view returns (address _owner) {
318 		return assToOwner[_tokenId];
319 	 }
320 	 
321     function _transfer(address _from, address _to, uint256 _tokenId) internal {
322 		ownerAssCount[_to] = ownerAssCount[_to].add(1);
323 		ownerAssCount[_from] = ownerAssCount[_from].sub(1);
324 		assToOwner[_tokenId] = _to;
325 		emit Transfer(_from, _to, _tokenId);
326 	}
327 	
328 	function transfer(address _to, uint256 _tokenId) public onlyAdmin onlyOwnerOf(_tokenId){
329 		_transfer(msg.sender, _to, _tokenId);
330 	}
331 
332 	function approve(address _to, uint256 _tokenId) public payable onlyOwnerOf(_tokenId) {
333 		require(msg.value == approveFee * 1 szabo && assInAuction[ _tokenId] == 0);
334 		uint transferingAss = _tokenId.sub(2536);
335 		assApprovals[transferingAss] = _to;
336 		emit Approval(msg.sender, _to, _tokenId);
337 	}
338 	
339 	 function approveForAll(uint256 _tokenId) public payable onlyOwnerOf(_tokenId) {
340 
341 	    require(msg.value == approveFee * 1 szabo && assInAuction[ _tokenId] == 0);
342 		uint transferingAss = _tokenId.sub(2536);
343 		assToAllApprovals[transferingAss] = true;
344 		emit ApprovalToAll(msg.sender, _tokenId);
345 	 }
346 	 
347 	 function cancelApproveForAll(uint256 _tokenId) public payable onlyOwnerOf(_tokenId) {
348 	    uint transferingAss = _tokenId.sub(2536);
349 	    require(msg.value == cancelApproveFee * 1 szabo && assToAllApprovals[transferingAss] == true);
350 		assToAllApprovals[transferingAss] = false;
351 		emit ApprovalCancelled(_tokenId);
352 	 }
353 	 
354 	 function cancelApproveForAddress(uint256 _tokenId) public payable onlyOwnerOf(_tokenId) {
355 		require(msg.value == cancelApproveFee * 1 szabo && assApprovals[transferingAss] != 0x0000000000000000000000000000000000000000);
356 		uint transferingAss = _tokenId.sub(2536);
357 		assApprovals[transferingAss] = 0x0000000000000000000000000000000000000000;
358 		emit ApprovalCancelled(_tokenId);
359 	 }
360 	 
361 	function getTakeOwnershipFee(uint _price) public view returns(uint) {
362         uint takeOwnershipFee = (_price.div(100)).mul(takeOwnershipFeePercents);
363         return(takeOwnershipFee);
364     }
365 	 
366 	function takeOwnership(uint256 _tokenId) public payable {
367 	    uint idOfTransferingAss = _tokenId.sub(2536);
368 	    uint assPrice = asses[idOfTransferingAss].priceInSzabo;
369 	    address ownerOfAss = ownerOf(_tokenId);
370 	    uint sendAmount = assPrice.sub(getTakeOwnershipFee(assPrice));
371 	    
372 		require(msg.value == assPrice * 1 szabo);
373 		require(assApprovals[idOfTransferingAss] == msg.sender || assToAllApprovals[idOfTransferingAss] == true);
374 		
375 
376 		
377 		assToAllApprovals[idOfTransferingAss] = false;
378 		assApprovals[idOfTransferingAss] = 0;
379 		_transfer(ownerOfAss, msg.sender, _tokenId);
380 		
381 
382 		ownerOfAss.transfer(sendAmount * 1 szabo);
383 
384 	}
385 	
386 	function _getPrice(uint256 _tokenId) view public returns(uint){
387 	      uint tokenPrice = asses[_tokenId.sub(2536)].priceInSzabo;
388 		  return (tokenPrice) * 1 szabo;
389 	}
390 	
391 	
392 }
393 
394 
395 
396 contract AssFunctions is AssMarket {
397     
398     uint256 functionOnePrice = 1800;
399     uint256 functionTwoPrice = 1800;
400     uint256 functionThreePrice = 1800;
401     uint256 functionFourPrice = 1800;
402     uint256 functionFivePrice = 1800;
403     uint256 functionSixPrice = 1800;
404     uint256 functionSevenPrice = 1800;
405     uint256 functionEightPrice = 1800;
406     
407     uint256 galleryOnePrice = 1800;
408     uint256 galleryTwoPrice = 1800;
409     uint256 galleryThreePrice = 1800;
410     uint256 galleryFourPrice = 1800;
411     uint256 galleryFivePrice = 1800;
412     uint256 gallerySixPrice = 1800;
413     uint256 gallerySevenPrice = 1800;
414     
415     event OneOfMassFunctionsLaunched(bool launched);
416     event OneOfGalleryFunctionsLaunched(bool launched);
417 //---------------------------------------------------------------------------------   
418     
419             function setFunctionOnePrice(uint _newFee) public onlyAdmin {
420 		        functionOnePrice = _newFee;
421 		        emit FeeChanged(_newFee);
422             }
423             
424             function setFunctionTwoPrice(uint _newFee) public onlyAdmin {
425 		        functionTwoPrice = _newFee;	
426 		        emit FeeChanged(_newFee);
427             }
428             
429             function setFunctionThreePrice(uint _newFee) public onlyAdmin {
430 		        functionThreePrice = _newFee;
431 		        emit FeeChanged(_newFee);
432             }
433             
434             function setFunctionFourPrice(uint _newFee) public onlyAdmin {
435 		        functionFourPrice = _newFee;
436 		        emit FeeChanged(_newFee);
437             }
438             
439             function setFunctionFivePrice(uint _newFee) public onlyAdmin {
440 		        functionFivePrice = _newFee;	
441 		        emit FeeChanged(_newFee);
442             }
443             
444             function setFunctionSixPrice(uint _newFee) public onlyAdmin {
445 		        functionSixPrice = _newFee;	
446 		        emit FeeChanged(_newFee);
447             }
448             
449             function setFunctionSevenPrice(uint _newFee) public onlyAdmin {
450 		        functionSevenPrice = _newFee;	
451 		        emit FeeChanged(_newFee);
452             }
453             
454             function setFunctionEightPrice(uint _newFee) public onlyAdmin {
455 		        functionEightPrice = _newFee;	
456 		        emit FeeChanged(_newFee);
457             }
458             
459 //---------------------------------------------------------------------------------       
460             
461             
462             function setGalleryOnePrice(uint _newFee) public onlyAdmin {
463 		        galleryOnePrice = _newFee;	
464             }
465             
466             function setGalleryTwoPrice(uint _newFee) public onlyAdmin {
467 		        galleryTwoPrice = _newFee;	
468 		        emit FeeChanged(_newFee);
469             }
470             
471             function setGalleryThreePrice(uint _newFee) public onlyAdmin {
472 		        galleryThreePrice = _newFee;	
473 		        emit FeeChanged(_newFee);
474             }
475             
476             function setGalleryFourPrice(uint _newFee) public onlyAdmin {
477 		        galleryFourPrice = _newFee;	
478 		        emit FeeChanged(_newFee);
479             }
480             
481             function setGalleryFivePrice(uint _newFee) public onlyAdmin {
482 		        galleryFivePrice = _newFee;	
483 		        emit FeeChanged(_newFee);
484             }
485             
486             function setGallerySixPrice(uint _newFee) public onlyAdmin {
487 		        gallerySixPrice = _newFee;	
488 		        emit FeeChanged(_newFee);
489             }
490             
491             function setGallerySevenPrice(uint _newFee) public onlyAdmin {
492 		        gallerySevenPrice = _newFee;
493 		        emit FeeChanged(_newFee);
494             }
495             
496 //-------------------------------------------------------       
497             
498  
499  function functionOne() public payable returns(bool) {
500      require( msg.value == functionOnePrice * 1 szabo);
501      return(true);
502      emit OneOfMassFunctionsLaunched(true);
503  }
504  
505   function functionTwo() public payable returns(bool) {
506      require( msg.value == functionTwoPrice * 1 szabo);
507      return(true);
508      emit OneOfMassFunctionsLaunched(true);
509  }
510  
511   function functionThree() public payable returns(bool) {
512      require( msg.value == functionThreePrice * 1 szabo);
513      return(true);
514      emit OneOfMassFunctionsLaunched(true);
515  }
516  
517   function functionFour() public payable returns(bool) {
518      require( msg.value == functionFourPrice * 1 szabo);
519      return(true);
520      emit OneOfMassFunctionsLaunched(true);
521  }
522  
523   function functionFive() public payable returns(bool) {
524      require( msg.value == functionFivePrice * 1 szabo);
525      return(true);
526      emit OneOfMassFunctionsLaunched(true);
527  }
528  
529   function functionSix() public payable returns(bool) {
530      require( msg.value == functionSixPrice * 1 szabo);
531      return(true);
532      emit OneOfMassFunctionsLaunched(true);
533  }
534  
535   function functionSeven() public payable returns(bool) {
536      require( msg.value == functionSevenPrice * 1 szabo);
537      return(true);
538      emit OneOfMassFunctionsLaunched(true);
539  }
540  
541   function functionEight() public payable returns(bool) {
542      require( msg.value == functionEightPrice * 1 szabo);
543      return(true);
544      emit OneOfMassFunctionsLaunched(true);
545  }
546  
547  
548 //-------------------------------------------------------       
549  
550  
551   function galleryOne() public payable returns(bool) {
552      require( msg.value == galleryOnePrice * 1 szabo);
553      return(true);
554      emit OneOfGalleryFunctionsLaunched(true);
555  }
556  
557   function galleryTwo() public payable returns(bool) {
558      require( msg.value == galleryTwoPrice * 1 szabo);
559      return(true);
560      emit OneOfGalleryFunctionsLaunched(true);
561  }
562  
563   function galleryThree() public payable returns(bool) {
564      require( msg.value == galleryThreePrice * 1 szabo);
565      return(true);
566      emit OneOfGalleryFunctionsLaunched(true);
567  }
568  
569   function galleryFour() public payable returns(bool) {
570      require( msg.value == galleryFourPrice * 1 szabo);
571      return(true);
572      emit OneOfGalleryFunctionsLaunched(true);
573  }
574  
575   function galleryFive() public payable returns(bool) {
576      require( msg.value == galleryFivePrice * 1 szabo);
577      return(true);
578      emit OneOfGalleryFunctionsLaunched(true);
579  }
580  
581   function gallerySix() public payable returns(bool) {
582      require( msg.value == gallerySixPrice * 1 szabo);
583      return(true);
584      emit OneOfGalleryFunctionsLaunched(true);
585  }
586  
587   function gallerySeven() public payable returns(bool) {
588      require( msg.value == gallerySevenPrice * 1 szabo);
589      return(true);
590      emit OneOfGalleryFunctionsLaunched(true);
591  }
592  
593  
594  
595  
596     
597 }
598 
599 
600 
601 contract AssAuction is AssFunctions {
602     
603 
604     
605   modifier onlyOwnerOfAuction(uint _auctionId) {
606     require(msg.sender == auctionOwner[_auctionId]);
607     _;
608   }
609     
610     event HighestBidIncreased(address bidder, uint amount, uint auctionId);
611     event AuctionCreated(address creator, uint auctionedAss, uint auctionId);
612     event AuctionEnded(address winner, uint amount, uint auctionId, uint auctionedAss);
613     
614     function getRemainingTimeOf(uint _auctionId) public view returns(uint){
615         uint remainingTime = auctionEndTime[_auctionId].sub(now);
616         return(remainingTime);
617     }
618     
619     function setMinBidDifferenceInSzabo(uint _newDifference) public onlyAdmin {
620         minBidDifferenceInSzabo = _newDifference;
621         emit FeeChanged(_newDifference);
622     }
623     
624     function setBidFeePercents(uint _newFee) public onlyAdmin {
625 		    bidFeePercents = _newFee;
626 		    emit FeeChanged(_newFee);
627 	}
628 	
629 	function setEveryBidFee(uint _newFee) public onlyAdmin {
630 		    everyBidFee = _newFee;	
631 		    emit FeeChanged(_newFee);
632 	}
633     
634     function setStartAuctionFee(uint _newFee) public onlyAdmin{
635         startAuctionFee = _newFee;
636         emit FeeChanged(_newFee);
637     }
638     
639 
640     
641     function setMaxDuration(uint _newMaxDuration) public onlyAdmin{
642         maxDuration = _newMaxDuration;
643         emit FeeChanged(_newMaxDuration);
644     }
645     
646     function getAuctionData(uint _auctionId) public view returns(uint _endTime, uint _auctionedAssId, address _auctionOwner, bool _ended, address _highestBidder, uint _highestBid, uint _startingBid) {
647     return (auctionEndTime[_auctionId], auctionedAssId[_auctionId], auctionOwner[_auctionId], auctionEnded[_auctionId], highestBidderOf[_auctionId], highestBidOf[_auctionId], startingBidOf[_auctionId]);
648     }
649     
650     function startAuction(uint _assId, uint _duration, uint _startingBidInSzabo) public payable onlyOwnerOf(_assId){
651 
652         require(assInAuction[_assId] == 0 && assToAllApprovals[_assId.sub(2536)] != true);
653         require(assApprovals[_assId.sub(2536)] == 0x0000000000000000000000000000000000000000);
654         require(msg.value == startAuctionFee * 1 szabo);
655         require(_duration <= maxDuration);
656         
657         uint auctionId = NumberOfAuctions.add(1);
658         
659         startingBidOf[auctionId] = _startingBidInSzabo;
660         auctionEndTime[auctionId] = now + (_duration * 1 days);
661         auctionedAssId[auctionId] = _assId;
662         auctionOwner[auctionId] = msg.sender;
663         NumberOfAuctions = NumberOfAuctions.add(1);
664         assInAuction[_assId] = auctionId;
665         emit AuctionCreated(msg.sender, _assId, auctionId);
666     }
667     
668     function getBidFee(uint _bid) public view returns(uint) {
669         uint bidFee = (_bid.div(100)).mul(bidFeePercents);
670         return(bidFee);
671     }
672     
673     function bid(uint _auctionId) public payable {
674         require(now <= auctionEndTime[_auctionId]);
675         require(msg.value >= (highestBidOf[_auctionId] * 1 szabo) + ((minBidDifferenceInSzabo + everyBidFee) * 1 szabo) && msg.value >= (startingBidOf[_auctionId] + minBidDifferenceInSzabo + everyBidFee) * 1 szabo);
676         require(msg.sender != auctionOwner[_auctionId]);
677         
678         uint msgvalueInSzabo = (msg.value / 1000000000000);
679         uint newBid = (msgvalueInSzabo).sub(everyBidFee);
680 
681         if (highestBidOf[_auctionId] != 0) {
682             withdraw(_auctionId);
683         }
684         totalSzaboInBids = totalSzaboInBids + newBid;
685         totalSzaboInBids = totalSzaboInBids - highestBidOf[_auctionId];
686         
687         highestBidderOf[_auctionId] = msg.sender;
688         highestBidOf[_auctionId] = newBid;
689         
690         emit HighestBidIncreased(msg.sender, newBid, _auctionId);
691     }
692 
693     /// Withdraw a bid that was overbid.
694     function withdraw(uint _auctionId) internal {
695         
696         uint amount = highestBidOf[_auctionId];
697         address highestManBidder = highestBidderOf[_auctionId];
698         if (amount > 0) {
699              highestManBidder.transfer(amount * 1 szabo);
700             }
701     }
702     
703         function auctionEnd(uint _auctionId) public {
704 
705         address ownerOfAuction = auctionOwner[_auctionId];
706         address highestAuctionBidder = highestBidderOf[_auctionId];
707         uint amount = highestBidOf[_auctionId].sub(getBidFee(highestBidOf[_auctionId]));
708         uint idOfAuctionedAss = auctionedAssId[_auctionId];
709         
710         // 1. Conditions
711         require(now >= auctionEndTime[_auctionId]);
712         require(auctionEnded[_auctionId] == false);
713 
714         // 2. Effects
715         highestBidOf[_auctionId] = 0;
716         highestBidderOf[_auctionId] = 0x0000000000000000000000000000000000000000;
717         
718         auctionEnded[_auctionId] = true;
719         emit AuctionEnded(highestAuctionBidder, amount, _auctionId, idOfAuctionedAss);
720 
721         // 3. Interaction
722         if (highestAuctionBidder != 0x0000000000000000000000000000000000000000) {
723             _transfer(ownerOfAuction, highestAuctionBidder, idOfAuctionedAss);
724             assInAuction[idOfAuctionedAss] = 0;
725             totalSzaboInBids = totalSzaboInBids.sub(amount);
726             ownerOfAuction.transfer(amount * 1 szabo);
727             }
728         }
729         
730 
731 
732        
733        
734        function revertAuction(uint _auctionId) public onlyAdmin {
735         
736         address highestAuctionBidder = highestBidderOf[_auctionId];
737         uint amount = highestBidOf[_auctionId];
738         uint idOfAuctionedAss = auctionedAssId[_auctionId];
739         
740         totalSzaboInBids = totalSzaboInBids.sub(amount);        
741         assInAuction[idOfAuctionedAss] = 0;
742         
743         auctionEndTime[_auctionId] = 0;
744         auctionedAssId[_auctionId] = 0;
745         auctionOwner[_auctionId] = 0x0000000000000000000000000000000000000000;
746         startingBidOf[_auctionId] = 0;
747         
748         highestBidOf[_auctionId] = 0;
749         highestBidderOf[_auctionId] = 0x0000000000000000000000000000000000000000;
750                 
751         auctionEnded[_auctionId] = true;
752                 
753         if (amount > 0) {
754              highestAuctionBidder.transfer(amount  * 1 szabo);
755             }
756             
757         emit AuctionReverted(_auctionId);
758         }
759         
760         
761     function getBalanceOfContractInSzabo() external view onlyOwner returns(uint256) {
762     uint contractBalance = address(this).balance * 1000000;
763     return (contractBalance);
764     }
765 
766 
767     function withdraw() external onlyOwner {
768 	    uint amountToWithdraw = address(this).balance.sub(totalSzaboInBids * 1 szabo);
769         owner.transfer(amountToWithdraw);
770         emit Withdrawal(amountToWithdraw);
771     }
772     
773     
774     
775 }