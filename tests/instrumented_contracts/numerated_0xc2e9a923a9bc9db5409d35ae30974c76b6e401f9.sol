1 pragma solidity ^0.4.15;
2 
3 /*
4   https://cryptogs.io
5   --Austin Thomas Griffith for ETHDenver
6   ( PS this gas guzzling beast is still unaudited )
7 */
8 
9 
10 //adapted from https://github.com/ethereum/EIPs/issues/721
11 // thanks to Dieter Shirley && http://axiomzen.co
12 
13 contract NFT {
14 
15   function NFT() public { }
16 
17   mapping (uint256 => address) public tokenIndexToOwner;
18   mapping (address => uint256) ownershipTokenCount;
19   mapping (uint256 => address) public tokenIndexToApproved;
20 
21   function transfer(address _to,uint256 _tokenId) external {
22       require(_to != address(0));
23       require(_to != address(this));
24       require(_owns(msg.sender, _tokenId));
25       _transfer(msg.sender, _to, _tokenId);
26   }
27   function _transfer(address _from, address _to, uint256 _tokenId) internal {
28       ownershipTokenCount[_to]++;
29       tokenIndexToOwner[_tokenId] = _to;
30       if (_from != address(0)) {
31           ownershipTokenCount[_from]--;
32           delete tokenIndexToApproved[_tokenId];
33       }
34       Transfer(_from, _to, _tokenId);
35   }
36   event Transfer(address from, address to, uint256 tokenId);
37 
38   function transferFrom(address _from,address _to,uint256 _tokenId) external {
39       require(_to != address(0));
40       require(_to != address(this));
41       require(_approvedFor(msg.sender, _tokenId));
42       require(_owns(_from, _tokenId));
43       _transfer(_from, _to, _tokenId);
44   }
45 
46   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
47       return tokenIndexToOwner[_tokenId] == _claimant;
48   }
49   function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
50       return tokenIndexToApproved[_tokenId] == _claimant;
51   }
52   function _approve(uint256 _tokenId, address _approved) internal {
53       tokenIndexToApproved[_tokenId] = _approved;
54   }
55 
56   function approve(address _to,uint256 _tokenId) public returns (bool) {
57       require(_owns(msg.sender, _tokenId));
58       _approve(_tokenId, _to);
59       Approval(msg.sender, _to, _tokenId);
60       return true;
61   }
62   event Approval(address owner, address approved, uint256 tokenId);
63 
64   function balanceOf(address _owner) public view returns (uint256 count) {
65       return ownershipTokenCount[_owner];
66   }
67 
68   function ownerOf(uint256 _tokenId) external view returns (address owner) {
69       owner = tokenIndexToOwner[_tokenId];
70       require(owner != address(0));
71   }
72 
73   function allowance(address _claimant, uint256 _tokenId) public view returns (bool) {
74       return _approvedFor(_claimant,_tokenId);
75   }
76 }
77 
78 
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86   address public owner;
87 
88 
89   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91 
92   /**
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94    * account.
95    */
96   function Ownable() public {
97     owner = msg.sender;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108   /**
109    * @dev Allows the current owner to transfer control of the contract to a newOwner.
110    * @param newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address newOwner) public onlyOwner {
113     require(newOwner != address(0));
114     OwnershipTransferred(owner, newOwner);
115     owner = newOwner;
116   }
117 
118 }
119 
120 
121 contract Cryptogs is NFT, Ownable {
122 
123     string public constant name = "Cryptogs";
124     string public constant symbol = "POGS";
125 
126     string public constant purpose = "ETHDenver";
127     string public constant contact = "https://cryptogs.io";
128     string public constant author = "Austin Thomas Griffith";
129 
130     uint8 public constant FLIPPINESS = 64;
131     uint8 public constant FLIPPINESSROUNDBONUS = 16;
132     uint8 public constant TIMEOUTBLOCKS = 60;
133     uint8 public constant BLOCKSUNTILCLEANUPSTACK=1;
134 
135     string public ipfs;
136     function setIpfs(string _ipfs) public onlyOwner returns (bool){
137       ipfs=_ipfs;
138       IPFS(ipfs);
139       return true;
140     }
141     event IPFS(string ipfs);
142 
143     function Cryptogs() public {
144       //0 index should be a blank item owned by no one
145       Item memory _item = Item({
146         image: ""
147       });
148       items.push(_item);
149     }
150 
151     address public slammerTime;
152     function setSlammerTime(address _slammerTime) public onlyOwner returns (bool){
153       //in order to trust that this contract isn't sending a players tokens
154       // to a different contract, the slammertime contract is set once and
155       // only once -- at deploy
156       require(slammerTime==address(0));
157       slammerTime=_slammerTime;
158       return true;
159     }
160 
161     struct Item{
162       bytes32 image;
163       //perhaps some are harder to flip over?
164       //perhaps some have magical metadata?
165       //I don't know, it's late and I'm weird
166     }
167 
168     Item[] private items;
169 
170     function mint(bytes32 _image,address _owner) public onlyOwner returns (uint){
171       uint256 newId = _mint(_image);
172       _transfer(0, _owner, newId);
173       Mint(items[newId].image,tokenIndexToOwner[newId],newId);
174       return newId;
175     }
176     event Mint(bytes32 _image,address _owner,uint256 _id);
177 
178     function _mint(bytes32 _image) internal returns (uint){
179       Item memory _item = Item({
180         image: _image
181       });
182       uint256 newId = items.push(_item) - 1;
183       tokensOfImage[items[newId].image]++;
184       return newId;
185     }
186 
187     Pack[] private packs;
188     struct Pack{
189       uint256[10] tokens;
190       uint256 price;
191     }
192     function mintPack(uint256 _price,bytes32 _image1,bytes32 _image2,bytes32 _image3,bytes32 _image4,bytes32 _image5,bytes32 _image6,bytes32 _image7,bytes32 _image8,bytes32 _image9,bytes32 _image10) public onlyOwner returns (bool){
193       uint256[10] memory tokens;
194       tokens[0] = _mint(_image1);
195       tokens[1] = _mint(_image2);
196       tokens[2] = _mint(_image3);
197       tokens[3] = _mint(_image4);
198       tokens[4] = _mint(_image5);
199       tokens[5] = _mint(_image6);
200       tokens[6] = _mint(_image7);
201       tokens[7] = _mint(_image8);
202       tokens[8] = _mint(_image9);
203       tokens[9] = _mint(_image10);
204       Pack memory _pack = Pack({
205         tokens: tokens,
206         price: _price
207       });
208       MintPack(packs.push(_pack) - 1, _price,tokens[0],tokens[1],tokens[2],tokens[3],tokens[4],tokens[5],tokens[6],tokens[7],tokens[8],tokens[9]);
209       return true;
210     }
211     event MintPack(uint256 packId,uint256 price,uint256 token1,uint256 token2,uint256 token3,uint256 token4,uint256 token5,uint256 token6,uint256 token7,uint256 token8,uint256 token9,uint256 token10);
212 
213     function buyPack(uint256 packId) public payable returns (bool) {
214       //make sure pack is for sale
215       require( packs[packId].price > 0 );
216       //make sure they sent in enough value
217       require( msg.value >= packs[packId].price );
218       //right away set price to 0 to avoid some sort of reentrance
219       packs[packId].price=0;
220       //give tokens to owner
221       for(uint8 i=0;i<10;i++){
222         tokenIndexToOwner[packs[packId].tokens[i]]=msg.sender;
223         _transfer(0, msg.sender, packs[packId].tokens[i]);
224       }
225       //clear the price so it is no longer for sale
226       delete packs[packId];
227       BuyPack(msg.sender,packId,msg.value);
228     }
229     event BuyPack(address sender, uint256 packId, uint256 price);
230 
231     //lets keep a count of how many of a specific image is created too
232     //that will allow us to calculate rarity on-chain if we want
233     mapping (bytes32 => uint256) public tokensOfImage;
234 
235     function getToken(uint256 _id) public view returns (address owner,bytes32 image,uint256 copies) {
236       image = items[_id].image;
237       copies = tokensOfImage[image];
238       return (
239         tokenIndexToOwner[_id],
240         image,
241         copies
242       );
243     }
244 
245     uint256 nonce = 0;
246 
247     struct Stack{
248       //this will be an array of ids but for now just doing one for simplicity
249       uint256[5] ids;
250       address owner;
251       uint32 block;
252 
253     }
254 
255     mapping (bytes32 => Stack) public stacks;
256     mapping (bytes32 => bytes32) public stackCounter;
257 
258     function stackOwner(bytes32 _stack) public constant returns (address owner) {
259       return stacks[_stack].owner;
260     }
261 
262     function getStack(bytes32 _stack) public constant returns (address owner,uint32 block,uint256 token1,uint256 token2,uint256 token3,uint256 token4,uint256 token5) {
263       return (stacks[_stack].owner,stacks[_stack].block,stacks[_stack].ids[0],stacks[_stack].ids[1],stacks[_stack].ids[2],stacks[_stack].ids[3],stacks[_stack].ids[4]);
264     }
265 
266     //tx 1: of a game, player one approves the SlammerTime contract to take their tokens
267     //this triggers an event to broadcast to other players that there is an open challenge
268     function submitStack(uint256 _id,uint256 _id2,uint256 _id3,uint256 _id4,uint256 _id5, bool _public) public returns (bool) {
269       //make sure slammerTime was set at deploy
270       require(slammerTime!=address(0));
271       //the sender must own the token
272       require(tokenIndexToOwner[_id]==msg.sender);
273       require(tokenIndexToOwner[_id2]==msg.sender);
274       require(tokenIndexToOwner[_id3]==msg.sender);
275       require(tokenIndexToOwner[_id4]==msg.sender);
276       require(tokenIndexToOwner[_id5]==msg.sender);
277       //they approve the slammertime contract to take the token away from them
278       require(approve(slammerTime,_id));
279       require(approve(slammerTime,_id2));
280       require(approve(slammerTime,_id3));
281       require(approve(slammerTime,_id4));
282       require(approve(slammerTime,_id5));
283 
284       bytes32 stack = keccak256(nonce++,msg.sender);
285       uint256[5] memory ids = [_id,_id2,_id3,_id4,_id5];
286       stacks[stack] = Stack(ids,msg.sender,uint32(block.number));
287 
288       //the event is triggered to the frontend to display the stack
289       //the frontend will check if they want it public or not
290       SubmitStack(msg.sender,now,stack,_id,_id2,_id3,_id4,_id5,_public);
291     }
292     event SubmitStack(address indexed _sender,uint256 indexed timestamp,bytes32 indexed _stack,uint256 _token1,uint256 _token2,uint256 _token3,uint256 _token4,uint256 _token5,bool _public);
293 
294     //tx 2: of a game, player two approves the SlammerTime contract to take their tokens
295     //this triggers an event to broadcast to player one that this player wants to rumble
296     function submitCounterStack(bytes32 _stack, uint256 _id, uint256 _id2, uint256 _id3, uint256 _id4, uint256 _id5) public returns (bool) {
297       //make sure slammerTime was set at deploy
298       require(slammerTime!=address(0));
299       //the sender must own the token
300       require(tokenIndexToOwner[_id]==msg.sender);
301       require(tokenIndexToOwner[_id2]==msg.sender);
302       require(tokenIndexToOwner[_id3]==msg.sender);
303       require(tokenIndexToOwner[_id4]==msg.sender);
304       require(tokenIndexToOwner[_id5]==msg.sender);
305       //they approve the slammertime contract to take the token away from them
306       require(approve(slammerTime,_id));
307       require(approve(slammerTime,_id2));
308       require(approve(slammerTime,_id3));
309       require(approve(slammerTime,_id4));
310       require(approve(slammerTime,_id5));
311       //stop playing with yourself
312       require(msg.sender!=stacks[_stack].owner);
313 
314       bytes32 counterstack = keccak256(nonce++,msg.sender,_id);
315       uint256[5] memory ids = [_id,_id2,_id3,_id4,_id5];
316       stacks[counterstack] = Stack(ids,msg.sender,uint32(block.number));
317       stackCounter[counterstack] = _stack;
318 
319       //the event is triggered to the frontend to display the stack
320       //the frontend will check if they want it public or not
321       CounterStack(msg.sender,now,_stack,counterstack,_id,_id2,_id3,_id4,_id5);
322     }
323     event CounterStack(address indexed _sender,uint256 indexed timestamp,bytes32 indexed _stack, bytes32 _counterStack, uint256 _token1, uint256 _token2, uint256 _token3, uint256 _token4, uint256 _token5);
324 
325     // if someone creates a stack they should be able to clean it up
326     // its not really that big of a deal because we will have a timeout
327     // in the frontent, but still...
328     function cancelStack(bytes32 _stack) public returns (bool) {
329       //it must be your stack
330       require(msg.sender==stacks[_stack].owner);
331       //make sure there is no mode set yet
332       require(mode[_stack]==0);
333       //make sure they aren't trying to cancel a counterstack using this function
334       require(stackCounter[_stack]==0x00000000000000000000000000000000);
335 
336       delete stacks[_stack];
337 
338       CancelStack(msg.sender,now,_stack);
339     }
340     event CancelStack(address indexed _sender,uint256 indexed timestamp,bytes32 indexed _stack);
341 
342     function cancelCounterStack(bytes32 _stack,bytes32 _counterstack) public returns (bool) {
343       //it must be your stack
344       require(msg.sender==stacks[_counterstack].owner);
345       //the counter must be a counter of stack 1
346       require(stackCounter[_counterstack]==_stack);
347       //make sure there is no mode set yet
348       require(mode[_stack]==0);
349 
350       delete stacks[_counterstack];
351       delete stackCounter[_counterstack];
352 
353       CancelCounterStack(msg.sender,now,_stack,_counterstack);
354     }
355     event CancelCounterStack(address indexed _sender,uint256 indexed timestamp,bytes32 indexed _stack,bytes32 _counterstack);
356 
357     mapping (bytes32 => bytes32) public counterOfStack;
358     mapping (bytes32 => uint8) public mode;
359     mapping (bytes32 => uint8) public round;
360     mapping (bytes32 => uint32) public lastBlock;
361     mapping (bytes32 => uint32) public commitBlock;
362     mapping (bytes32 => address) public lastActor;
363     mapping (bytes32 => uint256[10]) public mixedStack;
364 
365     //tx 3: of a game, player one approves counter stack and transfers everything in
366     function acceptCounterStack(bytes32 _stack, bytes32 _counterStack) public returns (bool) {
367       //sender must be owner of stack 1
368       require(msg.sender==stacks[_stack].owner);
369       //the counter must be a counter of stack 1
370       require(stackCounter[_counterStack]==_stack);
371       //make sure there is no mode set yet
372       require(mode[_stack]==0);
373 
374       //do the transfer
375       SlammerTime slammerTimeContract = SlammerTime(slammerTime);
376       require( slammerTimeContract.startSlammerTime(msg.sender,stacks[_stack].ids,stacks[_counterStack].owner,stacks[_counterStack].ids) );
377 
378       //save the block for a timeout
379       lastBlock[_stack]=uint32(block.number);
380       lastActor[_stack]=stacks[_counterStack].owner;
381       mode[_stack]=1;
382       counterOfStack[_stack]=_counterStack;
383 
384       //// LOL @
385       mixedStack[_stack][0] = stacks[_stack].ids[0];
386       mixedStack[_stack][1] = stacks[_counterStack].ids[0];
387       mixedStack[_stack][2] = stacks[_stack].ids[1];
388       mixedStack[_stack][3] = stacks[_counterStack].ids[1];
389       mixedStack[_stack][4] = stacks[_stack].ids[2];
390       mixedStack[_stack][5] = stacks[_counterStack].ids[2];
391       mixedStack[_stack][6] = stacks[_stack].ids[3];
392       mixedStack[_stack][7] = stacks[_counterStack].ids[3];
393       mixedStack[_stack][8] = stacks[_stack].ids[4];
394       mixedStack[_stack][9] = stacks[_counterStack].ids[4];
395 
396       //let the front end know that the transfer is good and we are ready for the coin flip
397       AcceptCounterStack(msg.sender,_stack,_counterStack);
398     }
399     event AcceptCounterStack(address indexed _sender,bytes32 indexed _stack, bytes32 indexed _counterStack);
400 
401     mapping (bytes32 => bytes32) public commit;
402 
403     function getMixedStack(bytes32 _stack) external view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){
404       uint256[10] thisStack = mixedStack[_stack];
405       return (thisStack[0],thisStack[1],thisStack[2],thisStack[3],thisStack[4],thisStack[5],thisStack[6],thisStack[7],thisStack[8],thisStack[9]);
406     }
407 
408     //tx 4: player one commits and flips coin up
409     //at this point, the timeout goes into effect and if any transaction including
410     //the coin flip don't come back in time, we need to allow the other party
411     //to withdraw all tokens... this keeps either player from refusing to
412     //reveal their commit. (every tx from here on out needs to update the lastBlock and lastActor)
413     //and in the withdraw function you check currentblock-lastBlock > timeout = refund to lastActor
414     //and by refund I mean let them withdraw if they want
415     //we could even have a little timer on the front end that tells you how long your opponnet has
416     //before they will forfet
417     function startCoinFlip(bytes32 _stack, bytes32 _counterStack, bytes32 _commit) public returns (bool) {
418       //make sure it's the owner of the first stack (player one) doing the flip
419       require(stacks[_stack].owner==msg.sender);
420       //the counter must be a counter of stack 1
421       require(stackCounter[_counterStack]==_stack);
422       require(counterOfStack[_stack]==_counterStack);
423       //make sure that we are in mode 1
424       require(mode[_stack]==1);
425       //store the commit for the next tx
426       commit[_stack]=_commit;
427       commitBlock[_stack]=uint32(block.number);
428       //inc the mode to 2
429       mode[_stack]=2;
430       StartCoinFlip(_stack,_commit);
431     }
432     event StartCoinFlip(bytes32 stack, bytes32 commit);
433 
434     //tx5: player one ends coin flip with reveal
435     function endCoinFlip(bytes32 _stack, bytes32 _counterStack, bytes32 _reveal) public returns (bool) {
436       //make sure it's the owner of the first stack (player one) doing the flip
437       require(stacks[_stack].owner==msg.sender);
438       //the counter must be a counter of stack 1
439       require(stackCounter[_counterStack]==_stack);
440       require(counterOfStack[_stack]==_counterStack);
441       //make sure that we are in mode 2
442       require(mode[_stack]==2);
443 
444       //make sure hash of reveal == commit
445       if(keccak256(_reveal)!=commit[_stack]){
446         //commit/reveal failed.. this can happen if they
447         //reload, so don't punish, just go back to the
448         //start of the coin flip stage
449         mode[_stack]=1;
450         CoinFlipFail(_stack);
451         return false;
452       }else{
453         //successful coin flip, ready to get random
454         mode[_stack]=3;
455         round[_stack]=1;
456         bytes32 pseudoRandomHash = keccak256(_reveal,block.blockhash(commitBlock[_stack]));
457         if(uint256(pseudoRandomHash)%2==0){
458           //player1 goes first
459           lastBlock[_stack]=uint32(block.number);
460           lastActor[_stack]=stacks[_counterStack].owner;
461           CoinFlipSuccess(_stack,stacks[_stack].owner,true);
462         }else{
463           //player2 goes first
464           lastBlock[_stack]=uint32(block.number);
465           lastActor[_stack]=stacks[_stack].owner;
466           CoinFlipSuccess(_stack,stacks[_counterStack].owner,false);
467         }
468         return true;
469       }
470 
471     }
472     event CoinFlipSuccess(bytes32 indexed stack,address whosTurn,bool heads);
473     event CoinFlipFail(bytes32 stack);
474 
475 
476     //tx6 next player raises slammer
477     function raiseSlammer(bytes32 _stack, bytes32 _counterStack, bytes32 _commit) public returns (bool) {
478       if(lastActor[_stack]==stacks[_stack].owner){
479         //it is player2's turn
480         require(stacks[_counterStack].owner==msg.sender);
481       }else{
482         //it is player1's turn
483         require(stacks[_stack].owner==msg.sender);
484       }
485       //the counter must be a counter of stack 1
486       require(stackCounter[_counterStack]==_stack);
487       require(counterOfStack[_stack]==_counterStack);
488       //make sure that we are in mode 3
489       require(mode[_stack]==3);
490       //store the commit for the next tx
491       commit[_stack]=_commit;
492       commitBlock[_stack]=uint32(block.number);
493       //inc the mode to 2
494       mode[_stack]=4;
495       RaiseSlammer(_stack,_commit);
496     }
497     event RaiseSlammer(bytes32 stack, bytes32 commit);
498 
499 
500     //tx7 player throws slammer
501     function throwSlammer(bytes32 _stack, bytes32 _counterStack, bytes32 _reveal) public returns (bool) {
502       if(lastActor[_stack]==stacks[_stack].owner){
503         //it is player2's turn
504         require(stacks[_counterStack].owner==msg.sender);
505       }else{
506         //it is player1's turn
507         require(stacks[_stack].owner==msg.sender);
508       }
509       //the counter must be a counter of stack 1
510       require(stackCounter[_counterStack]==_stack);
511       require(counterOfStack[_stack]==_counterStack);
512       //make sure that we are in mode 4
513       require(mode[_stack]==4);
514 
515       uint256[10] memory flipped;
516       if(keccak256(_reveal)!=commit[_stack]){
517         //commit/reveal failed.. this can happen if they
518         //reload, so don't punish, just go back to the
519         //start of the slammer raise
520         mode[_stack]=3;
521         throwSlammerEvent(_stack,msg.sender,address(0),flipped);
522         return false;
523       }else{
524         //successful slam!!!!!!!!!!!! At this point I have officially been awake for 24 hours !!!!!!!!!!
525         mode[_stack]=3;
526 
527         address previousLastActor = lastActor[_stack];
528 
529         bytes32 pseudoRandomHash = keccak256(_reveal,block.blockhash(commitBlock[_stack]));
530         //Debug(_reveal,block.blockhash(block.number-1),pseudoRandomHash);
531         if(lastActor[_stack]==stacks[_stack].owner){
532           //player1 goes next
533           lastBlock[_stack]=uint32(block.number);
534           lastActor[_stack]=stacks[_counterStack].owner;
535         }else{
536           //player2 goes next
537           lastBlock[_stack]=uint32(block.number);
538           lastActor[_stack]=stacks[_stack].owner;
539         }
540 
541         //look through the stack of remaining pogs and compare to byte to see if less than FLIPPINESS and transfer back to correct owner
542         // oh man, that smells like reentrance --  I think the mode would actually break that right?
543         bool done=true;
544         uint8 randIndex = 0;
545         for(uint8 i=0;i<10;i++){
546           if(mixedStack[_stack][i]>0){
547             //there is still a pog here, check for flip
548             uint8 thisFlipper = uint8(pseudoRandomHash[randIndex++]);
549             //DebugFlip(pseudoRandomHash,i,randIndex,thisFlipper,FLIPPINESS);
550             if(thisFlipper<(FLIPPINESS+round[_stack]*FLIPPINESSROUNDBONUS)){
551               //ITS A FLIP!
552                uint256 tempId = mixedStack[_stack][i];
553                flipped[i]=tempId;
554                mixedStack[_stack][i]=0;
555                SlammerTime slammerTimeContract = SlammerTime(slammerTime);
556                //require( slammerTimeContract.transferBack(msg.sender,tempId) );
557                slammerTimeContract.transferBack(msg.sender,tempId);
558             }else{
559               done=false;
560             }
561           }
562         }
563 
564         throwSlammerEvent(_stack,msg.sender,previousLastActor,flipped);
565 
566         if(done){
567           FinishGame(_stack);
568           mode[_stack]=9;
569           delete mixedStack[_stack];
570           delete stacks[_stack];
571           delete stackCounter[_counterStack];
572           delete stacks[_counterStack];
573           delete lastBlock[_stack];
574           delete lastActor[_stack];
575           delete counterOfStack[_stack];
576           delete round[_stack];
577           delete commitBlock[_stack];
578           delete commit[_stack];
579         }else{
580           round[_stack]++;
581         }
582 
583         return true;
584       }
585     }
586     event ThrowSlammer(bytes32 indexed stack, address indexed whoDoneIt, address indexed otherPlayer, uint256 token1Flipped, uint256 token2Flipped, uint256 token3Flipped, uint256 token4Flipped, uint256 token5Flipped, uint256 token6Flipped, uint256 token7Flipped, uint256 token8Flipped, uint256 token9Flipped, uint256 token10Flipped);
587     event FinishGame(bytes32 stack);
588 
589     function throwSlammerEvent(bytes32 stack,address whoDoneIt,address otherAccount, uint256[10] flipArray) internal {
590       ThrowSlammer(stack,whoDoneIt,otherAccount,flipArray[0],flipArray[1],flipArray[2],flipArray[3],flipArray[4],flipArray[5],flipArray[6],flipArray[7],flipArray[8],flipArray[9]);
591     }
592 
593 
594     function drainStack(bytes32 _stack, bytes32 _counterStack) public returns (bool) {
595       //this function is for the case of a timeout in the commit / reveal
596       // if a player realizes they are going to lose, they can refuse to reveal
597       // therefore we must have a timeout of TIMEOUTBLOCKS and if that time is reached
598       // the other player can get in and drain the remaining tokens from the game
599       require( stacks[_stack].owner==msg.sender || stacks[_counterStack].owner==msg.sender );
600       //the counter must be a counter of stack 1
601       require( stackCounter[_counterStack]==_stack );
602       require( counterOfStack[_stack]==_counterStack );
603       //the bad guy shouldn't be able to drain
604       require( lastActor[_stack]==msg.sender );
605       //must be after timeout period
606       require( block.number - lastBlock[_stack] >= TIMEOUTBLOCKS);
607       //game must still be going
608       require( mode[_stack]<9 );
609 
610       for(uint8 i=0;i<10;i++){
611         if(mixedStack[_stack][i]>0){
612           uint256 tempId = mixedStack[_stack][i];
613           mixedStack[_stack][i]=0;
614           SlammerTime slammerTimeContract = SlammerTime(slammerTime);
615           slammerTimeContract.transferBack(msg.sender,tempId);
616         }
617       }
618 
619       FinishGame(_stack);
620       mode[_stack]=9;
621 
622       delete mixedStack[_stack];
623       delete stacks[_stack];
624       delete stackCounter[_counterStack];
625       delete stacks[_counterStack];
626       delete lastBlock[_stack];
627       delete lastActor[_stack];
628       delete counterOfStack[_stack];
629       delete round[_stack];
630       delete commitBlock[_stack];
631       delete commit[_stack];
632 
633       DrainStack(_stack,_counterStack,msg.sender);
634     }
635     event DrainStack(bytes32 stack,bytes32 counterStack,address sender);
636 
637     function totalSupply() public view returns (uint) {
638         return items.length - 1;
639     }
640 
641     function tokensOfOwner(address _owner) external view returns(uint256[]) {
642         uint256 tokenCount = balanceOf(_owner);
643         if (tokenCount == 0) {
644             return new uint256[](0);
645         } else {
646             uint256[] memory result = new uint256[](tokenCount);
647             uint256 total = totalSupply();
648             uint256 resultIndex = 0;
649             uint256 id;
650             for (id = 1; id <= total; id++) {
651                 if (tokenIndexToOwner[id] == _owner) {
652                     result[resultIndex] = id;
653                     resultIndex++;
654                 }
655             }
656             return result;
657         }
658     }
659 
660     function withdraw(uint256 _amount) public onlyOwner returns (bool) {
661       require(this.balance >= _amount);
662       assert(owner.send(_amount));
663       return true;
664     }
665 
666     function withdrawToken(address _token,uint256 _amount) public onlyOwner returns (bool) {
667       StandardToken token = StandardToken(_token);
668       token.transfer(msg.sender,_amount);
669       return true;
670     }
671 }
672 
673 contract StandardToken {
674   function transfer(address _to, uint256 _value) public returns (bool) { }
675 }
676 
677 contract SlammerTime {
678   function startSlammerTime(address _player1,uint256[5] _id1,address _player2,uint256[5] _id2) public returns (bool) { }
679   function transferBack(address _toWhom, uint256 _id) public returns (bool) { }
680 }