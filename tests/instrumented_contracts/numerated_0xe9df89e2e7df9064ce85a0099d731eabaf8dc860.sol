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
132     uint8 public constant TIMEOUTBLOCKS = 180;
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
178     function mintBatch(bytes32 _image1,bytes32 _image2,bytes32 _image3,bytes32 _image4,bytes32 _image5,address _owner) public onlyOwner returns (bool){
179       uint256 newId = _mint(_image1);
180       _transfer(0, _owner, newId);
181       Mint(_image1,tokenIndexToOwner[newId],newId);
182       newId=_mint(_image2);
183       _transfer(0, _owner, newId);
184       Mint(_image2,tokenIndexToOwner[newId],newId);
185       newId=_mint(_image3);
186       _transfer(0, _owner, newId);
187       Mint(_image3,tokenIndexToOwner[newId],newId);
188       newId=_mint(_image4);
189       _transfer(0, _owner, newId);
190       Mint(_image4,tokenIndexToOwner[newId],newId);
191       newId=_mint(_image5);
192       _transfer(0, _owner, newId);
193       Mint(_image5,tokenIndexToOwner[newId],newId);
194       return true;
195     }
196 
197     function _mint(bytes32 _image) internal returns (uint){
198       Item memory _item = Item({
199         image: _image
200       });
201       uint256 newId = items.push(_item) - 1;
202       tokensOfImage[items[newId].image]++;
203       return newId;
204     }
205 
206     Pack[] private packs;
207     struct Pack{
208       uint256[10] tokens;
209       uint256 price;
210     }
211     function mintPack(uint256 _price,bytes32 _image1,bytes32 _image2,bytes32 _image3,bytes32 _image4,bytes32 _image5,bytes32 _image6,bytes32 _image7,bytes32 _image8,bytes32 _image9,bytes32 _image10) public onlyOwner returns (bool){
212       uint256[10] memory tokens;
213       tokens[0] = _mint(_image1);
214       tokens[1] = _mint(_image2);
215       tokens[2] = _mint(_image3);
216       tokens[3] = _mint(_image4);
217       tokens[4] = _mint(_image5);
218       tokens[5] = _mint(_image6);
219       tokens[6] = _mint(_image7);
220       tokens[7] = _mint(_image8);
221       tokens[8] = _mint(_image9);
222       tokens[9] = _mint(_image10);
223       Pack memory _pack = Pack({
224         tokens: tokens,
225         price: _price
226       });
227       MintPack(packs.push(_pack) - 1, _price,tokens[0],tokens[1],tokens[2],tokens[3],tokens[4],tokens[5],tokens[6],tokens[7],tokens[8],tokens[9]);
228       return true;
229     }
230     event MintPack(uint256 packId,uint256 price,uint256 token1,uint256 token2,uint256 token3,uint256 token4,uint256 token5,uint256 token6,uint256 token7,uint256 token8,uint256 token9,uint256 token10);
231 
232     function buyPack(uint256 packId) public payable returns (bool) {
233       //make sure pack is for sale
234       require( packs[packId].price > 0 );
235       //make sure they sent in enough value
236       require( msg.value >= packs[packId].price );
237       //right away set price to 0 to avoid some sort of reentrance
238       packs[packId].price=0;
239       //give tokens to owner
240       for(uint8 i=0;i<10;i++){
241         tokenIndexToOwner[packs[packId].tokens[i]]=msg.sender;
242         _transfer(0, msg.sender, packs[packId].tokens[i]);
243       }
244       //clear the price so it is no longer for sale
245       delete packs[packId];
246       BuyPack(msg.sender,packId,msg.value);
247     }
248     event BuyPack(address sender, uint256 packId, uint256 price);
249 
250     //lets keep a count of how many of a specific image is created too
251     //that will allow us to calculate rarity on-chain if we want
252     mapping (bytes32 => uint256) public tokensOfImage;
253 
254     function getToken(uint256 _id) public view returns (address owner,bytes32 image,uint256 copies) {
255       image = items[_id].image;
256       copies = tokensOfImage[image];
257       return (
258         tokenIndexToOwner[_id],
259         image,
260         copies
261       );
262     }
263 
264     uint256 nonce = 0;
265 
266     struct Stack{
267       //this will be an array of ids but for now just doing one for simplicity
268       uint256[5] ids;
269       address owner;
270       uint32 block;
271 
272     }
273 
274     mapping (bytes32 => Stack) public stacks;
275     mapping (bytes32 => bytes32) public stackCounter;
276 
277     function stackOwner(bytes32 _stack) public constant returns (address owner) {
278       return stacks[_stack].owner;
279     }
280 
281     function getStack(bytes32 _stack) public constant returns (address owner,uint32 block,uint256 token1,uint256 token2,uint256 token3,uint256 token4,uint256 token5) {
282       return (stacks[_stack].owner,stacks[_stack].block,stacks[_stack].ids[0],stacks[_stack].ids[1],stacks[_stack].ids[2],stacks[_stack].ids[3],stacks[_stack].ids[4]);
283     }
284 
285     //tx 1: of a game, player one approves the SlammerTime contract to take their tokens
286     //this triggers an event to broadcast to other players that there is an open challenge
287     function submitStack(uint256 _id,uint256 _id2,uint256 _id3,uint256 _id4,uint256 _id5, bool _public) public returns (bool) {
288       //make sure slammerTime was set at deploy
289       require(slammerTime!=address(0));
290       //the sender must own the token
291       require(tokenIndexToOwner[_id]==msg.sender);
292       require(tokenIndexToOwner[_id2]==msg.sender);
293       require(tokenIndexToOwner[_id3]==msg.sender);
294       require(tokenIndexToOwner[_id4]==msg.sender);
295       require(tokenIndexToOwner[_id5]==msg.sender);
296       //they approve the slammertime contract to take the token away from them
297       require(approve(slammerTime,_id));
298       require(approve(slammerTime,_id2));
299       require(approve(slammerTime,_id3));
300       require(approve(slammerTime,_id4));
301       require(approve(slammerTime,_id5));
302 
303       bytes32 stack = keccak256(nonce++,msg.sender);
304       uint256[5] memory ids = [_id,_id2,_id3,_id4,_id5];
305       stacks[stack] = Stack(ids,msg.sender,uint32(block.number));
306 
307       //the event is triggered to the frontend to display the stack
308       //the frontend will check if they want it public or not
309       SubmitStack(msg.sender,now,stack,_id,_id2,_id3,_id4,_id5,_public);
310     }
311     event SubmitStack(address indexed _sender,uint256 indexed timestamp,bytes32 indexed _stack,uint256 _token1,uint256 _token2,uint256 _token3,uint256 _token4,uint256 _token5,bool _public);
312 
313     //tx 2: of a game, player two approves the SlammerTime contract to take their tokens
314     //this triggers an event to broadcast to player one that this player wants to rumble
315     function submitCounterStack(bytes32 _stack, uint256 _id, uint256 _id2, uint256 _id3, uint256 _id4, uint256 _id5) public returns (bool) {
316       //make sure slammerTime was set at deploy
317       require(slammerTime!=address(0));
318       //the sender must own the token
319       require(tokenIndexToOwner[_id]==msg.sender);
320       require(tokenIndexToOwner[_id2]==msg.sender);
321       require(tokenIndexToOwner[_id3]==msg.sender);
322       require(tokenIndexToOwner[_id4]==msg.sender);
323       require(tokenIndexToOwner[_id5]==msg.sender);
324       //they approve the slammertime contract to take the token away from them
325       require(approve(slammerTime,_id));
326       require(approve(slammerTime,_id2));
327       require(approve(slammerTime,_id3));
328       require(approve(slammerTime,_id4));
329       require(approve(slammerTime,_id5));
330       //stop playing with yourself
331       require(msg.sender!=stacks[_stack].owner);
332 
333       bytes32 counterstack = keccak256(nonce++,msg.sender,_id);
334       uint256[5] memory ids = [_id,_id2,_id3,_id4,_id5];
335       stacks[counterstack] = Stack(ids,msg.sender,uint32(block.number));
336       stackCounter[counterstack] = _stack;
337 
338       //the event is triggered to the frontend to display the stack
339       //the frontend will check if they want it public or not
340       CounterStack(msg.sender,now,_stack,counterstack,_id,_id2,_id3,_id4,_id5);
341     }
342     event CounterStack(address indexed _sender,uint256 indexed timestamp,bytes32 indexed _stack, bytes32 _counterStack, uint256 _token1, uint256 _token2, uint256 _token3, uint256 _token4, uint256 _token5);
343 
344     // if someone creates a stack they should be able to clean it up
345     // its not really that big of a deal because we will have a timeout
346     // in the frontent, but still...
347     function cancelStack(bytes32 _stack) public returns (bool) {
348       //it must be your stack
349       require(msg.sender==stacks[_stack].owner);
350       //make sure there is no mode set yet
351       require(mode[_stack]==0);
352       //make sure they aren't trying to cancel a counterstack using this function
353       require(stackCounter[_stack]==0x00000000000000000000000000000000);
354 
355       delete stacks[_stack];
356 
357       CancelStack(msg.sender,now,_stack);
358     }
359     event CancelStack(address indexed _sender,uint256 indexed timestamp,bytes32 indexed _stack);
360 
361     function cancelCounterStack(bytes32 _stack,bytes32 _counterstack) public returns (bool) {
362       //it must be your stack
363       require(msg.sender==stacks[_counterstack].owner);
364       //the counter must be a counter of stack 1
365       require(stackCounter[_counterstack]==_stack);
366       //make sure there is no mode set yet
367       require(mode[_stack]==0);
368 
369       delete stacks[_counterstack];
370       delete stackCounter[_counterstack];
371 
372       CancelCounterStack(msg.sender,now,_stack,_counterstack);
373     }
374     event CancelCounterStack(address indexed _sender,uint256 indexed timestamp,bytes32 indexed _stack,bytes32 _counterstack);
375 
376     mapping (bytes32 => bytes32) public counterOfStack;
377     mapping (bytes32 => uint8) public mode;
378     mapping (bytes32 => uint8) public round;
379     mapping (bytes32 => uint32) public lastBlock;
380     mapping (bytes32 => uint32) public commitBlock;
381     mapping (bytes32 => address) public lastActor;
382     mapping (bytes32 => uint256[10]) public mixedStack;
383 
384     //tx 3: of a game, player one approves counter stack and transfers everything in
385     function acceptCounterStack(bytes32 _stack, bytes32 _counterStack) public returns (bool) {
386       //sender must be owner of stack 1
387       require(msg.sender==stacks[_stack].owner);
388       //the counter must be a counter of stack 1
389       require(stackCounter[_counterStack]==_stack);
390       //make sure there is no mode set yet
391       require(mode[_stack]==0);
392 
393       //do the transfer
394       SlammerTime slammerTimeContract = SlammerTime(slammerTime);
395       require( slammerTimeContract.startSlammerTime(msg.sender,stacks[_stack].ids,stacks[_counterStack].owner,stacks[_counterStack].ids) );
396 
397       //save the block for a timeout
398       lastBlock[_stack]=uint32(block.number);
399       lastActor[_stack]=stacks[_counterStack].owner;
400       mode[_stack]=1;
401       counterOfStack[_stack]=_counterStack;
402 
403       //// LOL @
404       mixedStack[_stack][0] = stacks[_stack].ids[0];
405       mixedStack[_stack][1] = stacks[_counterStack].ids[0];
406       mixedStack[_stack][2] = stacks[_stack].ids[1];
407       mixedStack[_stack][3] = stacks[_counterStack].ids[1];
408       mixedStack[_stack][4] = stacks[_stack].ids[2];
409       mixedStack[_stack][5] = stacks[_counterStack].ids[2];
410       mixedStack[_stack][6] = stacks[_stack].ids[3];
411       mixedStack[_stack][7] = stacks[_counterStack].ids[3];
412       mixedStack[_stack][8] = stacks[_stack].ids[4];
413       mixedStack[_stack][9] = stacks[_counterStack].ids[4];
414 
415       //let the front end know that the transfer is good and we are ready for the coin flip
416       AcceptCounterStack(msg.sender,_stack,_counterStack);
417     }
418     event AcceptCounterStack(address indexed _sender,bytes32 indexed _stack, bytes32 indexed _counterStack);
419 
420     mapping (bytes32 => bytes32) public commit;
421 
422     function getMixedStack(bytes32 _stack) external view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){
423       uint256[10] thisStack = mixedStack[_stack];
424       return (thisStack[0],thisStack[1],thisStack[2],thisStack[3],thisStack[4],thisStack[5],thisStack[6],thisStack[7],thisStack[8],thisStack[9]);
425     }
426 
427     //tx 4: player one commits and flips coin up
428     //at this point, the timeout goes into effect and if any transaction including
429     //the coin flip don't come back in time, we need to allow the other party
430     //to withdraw all tokens... this keeps either player from refusing to
431     //reveal their commit. (every tx from here on out needs to update the lastBlock and lastActor)
432     //and in the withdraw function you check currentblock-lastBlock > timeout = refund to lastActor
433     //and by refund I mean let them withdraw if they want
434     //we could even have a little timer on the front end that tells you how long your opponnet has
435     //before they will forfet
436     function startCoinFlip(bytes32 _stack, bytes32 _counterStack, bytes32 _commit) public returns (bool) {
437       //make sure it's the owner of the first stack (player one) doing the flip
438       require(stacks[_stack].owner==msg.sender);
439       //the counter must be a counter of stack 1
440       require(stackCounter[_counterStack]==_stack);
441       require(counterOfStack[_stack]==_counterStack);
442       //make sure that we are in mode 1
443       require(mode[_stack]==1);
444       //store the commit for the next tx
445       commit[_stack]=_commit;
446       commitBlock[_stack]=uint32(block.number);
447       //inc the mode to 2
448       mode[_stack]=2;
449       StartCoinFlip(_stack,_commit);
450     }
451     event StartCoinFlip(bytes32 stack, bytes32 commit);
452 
453     //tx5: player one ends coin flip with reveal
454     function endCoinFlip(bytes32 _stack, bytes32 _counterStack, bytes32 _reveal) public returns (bool) {
455       //make sure it's the owner of the first stack (player one) doing the flip
456       require(stacks[_stack].owner==msg.sender);
457       //the counter must be a counter of stack 1
458       require(stackCounter[_counterStack]==_stack);
459       require(counterOfStack[_stack]==_counterStack);
460       //make sure that we are in mode 2
461       require(mode[_stack]==2);
462 
463       //make sure that we are on a later block than the commit block
464       // (added 3/5/2018)
465       require(uint32(block.number)>commitBlock[_stack]);
466 
467       //make sure hash of reveal == commit
468       if(keccak256(_reveal)!=commit[_stack]){
469         //commit/reveal failed.. this can happen if they
470         //reload, so don't punish, just go back to the
471         //start of the coin flip stage
472         mode[_stack]=1;
473         CoinFlipFail(_stack);
474         return false;
475       }else{
476         //successful coin flip, ready to get random
477         mode[_stack]=3;
478         round[_stack]=1;
479         bytes32 pseudoRandomHash = keccak256(_reveal,block.blockhash(commitBlock[_stack]));
480         if(uint256(pseudoRandomHash)%2==0){
481           //player1 goes first
482           lastBlock[_stack]=uint32(block.number);
483           lastActor[_stack]=stacks[_counterStack].owner;
484           CoinFlipSuccess(_stack,stacks[_stack].owner,true);
485         }else{
486           //player2 goes first
487           lastBlock[_stack]=uint32(block.number);
488           lastActor[_stack]=stacks[_stack].owner;
489           CoinFlipSuccess(_stack,stacks[_counterStack].owner,false);
490         }
491         return true;
492       }
493 
494     }
495     event CoinFlipSuccess(bytes32 indexed stack,address whosTurn,bool heads);
496     event CoinFlipFail(bytes32 stack);
497 
498 
499     //tx6 next player raises slammer
500     function raiseSlammer(bytes32 _stack, bytes32 _counterStack, bytes32 _commit) public returns (bool) {
501       if(lastActor[_stack]==stacks[_stack].owner){
502         //it is player2's turn
503         require(stacks[_counterStack].owner==msg.sender);
504       }else{
505         //it is player1's turn
506         require(stacks[_stack].owner==msg.sender);
507       }
508       //the counter must be a counter of stack 1
509       require(stackCounter[_counterStack]==_stack);
510       require(counterOfStack[_stack]==_counterStack);
511       //make sure that we are in mode 3
512       require(mode[_stack]==3);
513       //store the commit for the next tx
514       commit[_stack]=_commit;
515       commitBlock[_stack]=uint32(block.number);
516       //inc the mode to 2
517       mode[_stack]=4;
518       RaiseSlammer(_stack,_commit);
519     }
520     event RaiseSlammer(bytes32 stack, bytes32 commit);
521 
522 
523     //tx7 player throws slammer
524     function throwSlammer(bytes32 _stack, bytes32 _counterStack, bytes32 _reveal) public returns (bool) {
525       if(lastActor[_stack]==stacks[_stack].owner){
526         //it is player2's turn
527         require(stacks[_counterStack].owner==msg.sender);
528       }else{
529         //it is player1's turn
530         require(stacks[_stack].owner==msg.sender);
531       }
532       //the counter must be a counter of stack 1
533       require(stackCounter[_counterStack]==_stack);
534       require(counterOfStack[_stack]==_counterStack);
535       //make sure that we are in mode 4
536       require(mode[_stack]==4);
537 
538       //make sure that we are on a later block than the commit block
539       // (added 3/5/2018)
540       require(uint32(block.number)>commitBlock[_stack]);
541 
542       uint256[10] memory flipped;
543       if(keccak256(_reveal)!=commit[_stack]){
544         //commit/reveal failed.. this can happen if they
545         //reload, so don't punish, just go back to the
546         //start of the slammer raise
547         mode[_stack]=3;
548         throwSlammerEvent(_stack,msg.sender,address(0),flipped);
549         return false;
550       }else{
551         //successful slam!!!!!!!!!!!! At this point I have officially been awake for 24 hours !!!!!!!!!!
552         mode[_stack]=3;
553 
554         address previousLastActor = lastActor[_stack];
555 
556         bytes32 pseudoRandomHash = keccak256(_reveal,block.blockhash(commitBlock[_stack]));
557         //Debug(_reveal,block.blockhash(block.number-1),pseudoRandomHash);
558         if(lastActor[_stack]==stacks[_stack].owner){
559           //player1 goes next
560           lastBlock[_stack]=uint32(block.number);
561           lastActor[_stack]=stacks[_counterStack].owner;
562         }else{
563           //player2 goes next
564           lastBlock[_stack]=uint32(block.number);
565           lastActor[_stack]=stacks[_stack].owner;
566         }
567 
568         //look through the stack of remaining pogs and compare to byte to see if less than FLIPPINESS and transfer back to correct owner
569         // oh man, that smells like reentrance --  I think the mode would actually break that right?
570         bool done=true;
571         uint8 randIndex = 0;
572         for(uint8 i=0;i<10;i++){
573           if(mixedStack[_stack][i]>0){
574             //there is still a pog here, check for flip
575             uint8 thisFlipper = uint8(pseudoRandomHash[randIndex++]);
576             //DebugFlip(pseudoRandomHash,i,randIndex,thisFlipper,FLIPPINESS);
577             if(thisFlipper<(FLIPPINESS+round[_stack]*FLIPPINESSROUNDBONUS)){
578               //ITS A FLIP!
579                uint256 tempId = mixedStack[_stack][i];
580                flipped[i]=tempId;
581                mixedStack[_stack][i]=0;
582                SlammerTime slammerTimeContract = SlammerTime(slammerTime);
583                //require( slammerTimeContract.transferBack(msg.sender,tempId) );
584                slammerTimeContract.transferBack(msg.sender,tempId);
585             }else{
586               done=false;
587             }
588           }
589         }
590 
591         throwSlammerEvent(_stack,msg.sender,previousLastActor,flipped);
592 
593         if(done){
594           FinishGame(_stack);
595           mode[_stack]=9;
596           delete mixedStack[_stack];
597           delete stacks[_stack];
598           delete stackCounter[_counterStack];
599           delete stacks[_counterStack];
600           delete lastBlock[_stack];
601           delete lastActor[_stack];
602           delete counterOfStack[_stack];
603           delete round[_stack];
604           delete commitBlock[_stack];
605           delete commit[_stack];
606         }else{
607           round[_stack]++;
608         }
609 
610         return true;
611       }
612     }
613     event ThrowSlammer(bytes32 indexed stack, address indexed whoDoneIt, address indexed otherPlayer, uint256 token1Flipped, uint256 token2Flipped, uint256 token3Flipped, uint256 token4Flipped, uint256 token5Flipped, uint256 token6Flipped, uint256 token7Flipped, uint256 token8Flipped, uint256 token9Flipped, uint256 token10Flipped);
614     event FinishGame(bytes32 stack);
615 
616     function throwSlammerEvent(bytes32 stack,address whoDoneIt,address otherAccount, uint256[10] flipArray) internal {
617       ThrowSlammer(stack,whoDoneIt,otherAccount,flipArray[0],flipArray[1],flipArray[2],flipArray[3],flipArray[4],flipArray[5],flipArray[6],flipArray[7],flipArray[8],flipArray[9]);
618     }
619 
620 
621     function drainStack(bytes32 _stack, bytes32 _counterStack) public returns (bool) {
622       //this function is for the case of a timeout in the commit / reveal
623       // if a player realizes they are going to lose, they can refuse to reveal
624       // therefore we must have a timeout of TIMEOUTBLOCKS and if that time is reached
625       // the other player can get in and drain the remaining tokens from the game
626       require( stacks[_stack].owner==msg.sender || stacks[_counterStack].owner==msg.sender );
627       //the counter must be a counter of stack 1
628       require( stackCounter[_counterStack]==_stack );
629       require( counterOfStack[_stack]==_counterStack );
630       //the bad guy shouldn't be able to drain
631       require( lastActor[_stack]==msg.sender );
632       //must be after timeout period
633       require( block.number - lastBlock[_stack] >= TIMEOUTBLOCKS);
634       //game must still be going
635       require( mode[_stack]<9 );
636 
637       for(uint8 i=0;i<10;i++){
638         if(mixedStack[_stack][i]>0){
639           uint256 tempId = mixedStack[_stack][i];
640           mixedStack[_stack][i]=0;
641           SlammerTime slammerTimeContract = SlammerTime(slammerTime);
642           slammerTimeContract.transferBack(msg.sender,tempId);
643         }
644       }
645 
646       FinishGame(_stack);
647       mode[_stack]=9;
648 
649       delete mixedStack[_stack];
650       delete stacks[_stack];
651       delete stackCounter[_counterStack];
652       delete stacks[_counterStack];
653       delete lastBlock[_stack];
654       delete lastActor[_stack];
655       delete counterOfStack[_stack];
656       delete round[_stack];
657       delete commitBlock[_stack];
658       delete commit[_stack];
659 
660       DrainStack(_stack,_counterStack,msg.sender);
661     }
662     event DrainStack(bytes32 stack,bytes32 counterStack,address sender);
663 
664     function totalSupply() public view returns (uint) {
665         return items.length - 1;
666     }
667 
668     function tokensOfOwner(address _owner) external view returns(uint256[]) {
669         uint256 tokenCount = balanceOf(_owner);
670         if (tokenCount == 0) {
671             return new uint256[](0);
672         } else {
673             uint256[] memory result = new uint256[](tokenCount);
674             uint256 total = totalSupply();
675             uint256 resultIndex = 0;
676             uint256 id;
677             for (id = 1; id <= total; id++) {
678                 if (tokenIndexToOwner[id] == _owner) {
679                     result[resultIndex] = id;
680                     resultIndex++;
681                 }
682             }
683             return result;
684         }
685     }
686 
687     function withdraw(uint256 _amount) public onlyOwner returns (bool) {
688       require(this.balance >= _amount);
689       assert(owner.send(_amount));
690       return true;
691     }
692 
693     function withdrawToken(address _token,uint256 _amount) public onlyOwner returns (bool) {
694       StandardToken token = StandardToken(_token);
695       token.transfer(msg.sender,_amount);
696       return true;
697     }
698 }
699 
700 contract StandardToken {
701   function transfer(address _to, uint256 _value) public returns (bool) { }
702 }
703 
704 contract SlammerTime {
705   function startSlammerTime(address _player1,uint256[5] _id1,address _player2,uint256[5] _id2) public returns (bool) { }
706   function transferBack(address _toWhom, uint256 _id) public returns (bool) { }
707 }