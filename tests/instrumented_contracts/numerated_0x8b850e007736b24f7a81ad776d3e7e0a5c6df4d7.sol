1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14      return a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30 	address public owner;
31 	address public newOwner;
32 
33 	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
34 
35 	constructor() public {
36 		owner = msg.sender;
37 		newOwner = address(0);
38 	}
39 
40 	modifier onlyOwner() {
41 		require(msg.sender == owner, "msg.sender == owner");
42 		_;
43 	}
44 
45 	function transferOwnership(address _newOwner) public onlyOwner {
46 		require(address(0) != _newOwner, "address(0) != _newOwner");
47 		newOwner = _newOwner;
48 	}
49 
50 	function acceptOwnership() public {
51 		require(msg.sender == newOwner, "msg.sender == newOwner");
52 		emit OwnershipTransferred(owner, msg.sender);
53 		owner = msg.sender;
54 		newOwner = address(0);
55 	}
56 }
57 
58 contract tokenInterface {
59 	function balanceOf(address _owner) public constant returns (uint256 balance);
60 	function transfer(address _to, uint256 _value) public returns (bool);
61 	function burn(uint256 _value) public returns(bool);
62 	uint256 public totalSupply;
63 	uint256 public decimals;
64 }
65 
66 contract AtomaxKycInterface {
67 
68     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
69     function started() public view returns(bool);
70 
71     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
72     function ended() public view returns(bool);
73 
74     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
75     function startTime() public view returns(uint256);
76 
77     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
78     function endTime() public view returns(uint256);
79 
80     // returns the total number of the tokens available for the sale, must not change when the ico is started
81     function totalTokens() public view returns(uint256);
82 
83     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
84     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
85     function remainingTokens() public view returns(uint256);
86 
87     // return the price as number of tokens released for each ether
88     function price() public view returns(uint256);
89 }
90 
91 contract AtomaxKyc {
92     using SafeMath for uint256;
93 
94     mapping (address => bool) public isKycSigner;
95     mapping (bytes32 => uint256) public alreadyPayed;
96 
97     event KycVerified(address indexed signer, address buyerAddress, bytes32 buyerId, uint maxAmount);
98 
99     constructor() internal {
100         isKycSigner[0x9787295cdAb28b6640bc7e7db52b447B56b1b1f0] = true; //ATOMAX KYC 1 SIGNER
101         isKycSigner[0x3b3f379e49cD95937121567EE696dB6657861FB0] = true; //ATOMAX KYC 2 SIGNER
102     }
103 
104     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
105     function releaseTokensTo(address buyer) internal returns(bool);
106 
107     
108     function buyTokensFor(address _buyerAddress, bytes32 _buyerId, uint _maxAmount, uint8 _v, bytes32 _r, bytes32 _s, uint8 _bv, bytes32 _br, bytes32 _bs) public payable returns (bool) {
109         bytes32 hash = hasher ( _buyerAddress,  _buyerId,  _maxAmount );
110         address signer = ecrecover(hash, _bv, _br, _bs);
111         require ( signer == _buyerAddress, "signer == _buyerAddress " );
112         
113         return buyImplementation(_buyerAddress, _buyerId, _maxAmount, _v, _r, _s);
114     }
115     
116     function buyTokens(bytes32 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s) public payable returns (bool) {
117         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
118     }
119 
120     function buyImplementation(address _buyerAddress, bytes32 _buyerId, uint256 _maxAmount, uint8 _v, bytes32 _r, bytes32 _s) private returns (bool) {
121         // check the signature
122         bytes32 hash = hasher ( _buyerAddress,  _buyerId,  _maxAmount );
123         address signer = ecrecover(hash, _v, _r, _s);
124 		
125 		require( isKycSigner[signer], "isKycSigner[signer]");
126         
127 		uint256 totalPayed = alreadyPayed[_buyerId].add(msg.value);
128 		require(totalPayed <= _maxAmount);
129 		alreadyPayed[_buyerId] = totalPayed;
130 		
131 		emit KycVerified(signer, _buyerAddress, _buyerId, _maxAmount);
132 		return releaseTokensTo(_buyerAddress);
133 
134     }
135     
136     function hasher (address _buyerAddress, bytes32 _buyerId, uint256 _maxAmount) public view returns ( bytes32 hash ) {
137         hash = keccak256(abi.encodePacked("Atomax authorization:", this, _buyerAddress, _buyerId, _maxAmount));
138     }
139 }
140 
141 contract RC_KYC is AtomaxKycInterface, AtomaxKyc {
142     using SafeMath for uint256;
143     
144     TokedoDaico tokenSaleContract;
145     
146     uint256 public startTime;
147     uint256 public endTime;
148     
149     uint256 public etherMinimum;
150     uint256 public soldTokens;
151     uint256 public remainingTokens;
152     uint256 public tokenPrice;
153 	
154 	mapping(address => uint256) public etherUser; // address => ether amount
155 	mapping(address => uint256) public pendingTokenUser; // address => token amount that will be claimed after KYC
156 	mapping(address => uint256) public tokenUser; // address => token amount owned
157 	
158     constructor(address _tokenSaleContract, uint256 _tokenPrice, uint256 _remainingTokens, uint256 _etherMinimum, uint256 _startTime , uint256 _endTime) public {
159         require ( _tokenSaleContract != address(0), "_tokenSaleContract != address(0)" );
160         require ( _tokenPrice != 0, "_tokenPrice != 0" );
161         require ( _remainingTokens != 0, "_remainingTokens != 0" );  
162         require ( _startTime != 0, "_startTime != 0" );
163         require ( _endTime != 0, "_endTime != 0" );
164         
165         tokenSaleContract = TokedoDaico(_tokenSaleContract);
166         
167         soldTokens = 0;
168         remainingTokens = _remainingTokens;
169         tokenPrice = _tokenPrice;
170         etherMinimum = _etherMinimum;
171         
172         startTime = _startTime;
173         endTime = _endTime;
174     }
175     
176     modifier onlyTokenSaleOwner() {
177         require(msg.sender == tokenSaleContract.owner() );
178         _;
179     }
180     
181     function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {
182         if ( _newStart != 0 ) startTime = _newStart;
183         if ( _newEnd != 0 ) endTime = _newEnd;
184     }
185     
186     function changeMinimum(uint256 _newEtherMinimum) public onlyTokenSaleOwner {
187         etherMinimum = _newEtherMinimum;
188     }
189     
190     function releaseTokensTo(address buyer) internal returns(bool) {
191         if( msg.value > 0 ) takeEther(buyer);
192         giveToken(buyer);
193         return true;
194     }
195     
196     function started() public view returns(bool) {
197         return now > startTime || remainingTokens == 0;
198     }
199     
200     function ended() public view returns(bool) {
201         return now > endTime || remainingTokens == 0;
202     }
203     
204     function startTime() public view returns(uint) {
205         return startTime;
206     }
207     
208     function endTime() public view returns(uint) {
209         return endTime;
210     }
211     
212     function totalTokens() public view returns(uint) {
213         return remainingTokens.add(soldTokens);
214     }
215     
216     function remainingTokens() public view returns(uint) {
217         return remainingTokens;
218     }
219     
220     function price() public view returns(uint) {
221         return uint256(1 ether).div( tokenPrice ).mul( 10 ** uint256(tokenSaleContract.decimals()) );
222     }
223 	
224 	function () public payable{
225 	    takeEther(msg.sender);
226 	}
227 	
228 	event TakeEther(address buyer, uint256 value, uint256 soldToken, uint256 tokenPrice );
229 	
230 	function takeEther(address _buyer) internal {
231 	    require( now > startTime, "now > startTime" );
232 		require( now < endTime, "now < endTime");
233         require( msg.value >= etherMinimum, "msg.value >= etherMinimum"); 
234         require( remainingTokens > 0, "remainingTokens > 0" );
235         
236         uint256 oneToken = 10 ** uint256(tokenSaleContract.decimals());
237         uint256 tokenAmount = msg.value.mul( oneToken ).div( tokenPrice );
238         
239         uint256 remainingTokensGlobal = tokenInterface( tokenSaleContract.tokenContract() ).balanceOf( address(tokenSaleContract) );
240         
241         uint256 remainingTokensApplied;
242         if ( remainingTokensGlobal > remainingTokens ) { 
243             remainingTokensApplied = remainingTokens;
244         } else {
245             remainingTokensApplied = remainingTokensGlobal;
246         }
247         
248         uint256 refund = 0;
249         if ( remainingTokensApplied < tokenAmount ) {
250             refund = (tokenAmount - remainingTokensApplied).mul(tokenPrice).div(oneToken);
251             tokenAmount = remainingTokensApplied;
252 			remainingTokens = 0; // set remaining token to 0
253             _buyer.transfer(refund);
254         } else {
255 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
256         }
257         
258         etherUser[_buyer] = etherUser[_buyer].add(msg.value.sub(refund));
259         pendingTokenUser[_buyer] = pendingTokenUser[_buyer].add(tokenAmount);	
260         
261         emit TakeEther( _buyer, msg.value, tokenAmount, tokenPrice );
262 	}
263 	
264 	function giveToken(address _buyer) internal {
265 	    require( pendingTokenUser[_buyer] > 0, "pendingTokenUser[_buyer] > 0" );
266 
267 		tokenUser[_buyer] = tokenUser[_buyer].add(pendingTokenUser[_buyer]);
268 	
269 		tokenSaleContract.sendTokens(_buyer, pendingTokenUser[_buyer]);
270 		soldTokens = soldTokens.add(pendingTokenUser[_buyer]);
271 		pendingTokenUser[_buyer] = 0;
272 		
273 		require( address(tokenSaleContract).call.value( etherUser[_buyer] )( bytes4( keccak256("forwardEther()") ) ) );
274 		etherUser[_buyer] = 0;
275 	}
276 
277     function refundEther(address to) public onlyTokenSaleOwner {
278         to.transfer(etherUser[to]);
279         etherUser[to] = 0;
280         pendingTokenUser[to] = 0;
281     }
282     
283     function withdraw(address to, uint256 value) public onlyTokenSaleOwner { 
284         to.transfer(value);
285     }
286 	
287 	function userBalance(address _user) public view returns( uint256 _pendingTokenUser, uint256 _tokenUser, uint256 _etherUser ) {
288 		return (pendingTokenUser[_user], tokenUser[_user], etherUser[_user]);
289 	}
290 }
291 
292 contract TokedoDaico is Ownable {
293     using SafeMath for uint256;
294     
295     tokenInterface public tokenContract;
296     
297     address public milestoneSystem;
298 	uint256 public decimals;
299     uint256 public tokenPrice;
300 
301     mapping(address => bool) public rc;
302 
303     constructor(address _wallet, address _tokenAddress, uint256[] _time, uint256[] _funds, uint256 _tokenPrice, uint256 _activeSupply) public {
304         tokenContract = tokenInterface(_tokenAddress);
305         decimals = tokenContract.decimals();
306         tokenPrice = _tokenPrice;
307         milestoneSystem = new MilestoneSystem(_wallet,_tokenAddress, _time, _funds, _tokenPrice, _activeSupply);
308     }
309     
310     modifier onlyRC() {
311         require( rc[msg.sender], "rc[msg.sender]" ); //check if is an authorized rcContract
312         _;
313     }
314     
315     function forwardEther() onlyRC payable public returns(bool) {
316         require(milestoneSystem.call.value(msg.value)(), "wallet.call.value(msg.value)()");
317         return true;
318     }
319     
320 	function sendTokens(address _buyer, uint256 _amount) onlyRC public returns(bool) {
321         return tokenContract.transfer(_buyer, _amount);
322     }
323 
324     event NewRC(address contr);
325     
326     function addRC(address _rc) onlyOwner public {
327         rc[ _rc ]  = true;
328         emit NewRC(_rc);
329     }
330     
331     function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
332         return tokenContract.transfer(to, value);
333     }
334     
335     function setTokenContract(address _tokenContract) public onlyOwner {
336         tokenContract = tokenInterface(_tokenContract);
337     }
338 }
339 
340 contract MilestoneSystem {
341     using SafeMath for uint256;
342     
343     tokenInterface public tokenContract;
344     TokedoDaico public tokenSaleContract;
345     
346     uint256[] public time;
347     uint256[] public funds;
348     
349     bool public locked = false; 
350     uint256 public endTimeToReturnTokens; 
351     
352     uint8 public step = 0;
353     
354     uint256 public constant timeframeMilestone = 3 days; 
355     uint256 public constant timeframeDeath = 30 days; 
356     
357     uint256 public activeSupply;
358     
359     uint256 public tokenPrice;
360     
361     uint256 public etherReceived;
362     address public wallet;
363     
364     mapping(address => mapping(uint8 => uint256) ) public balance;
365     mapping(uint8 => uint256) public tokenDistrusted;
366     
367     constructor(address _wallet, address _tokenAddress, uint256[] _time, uint256[] _funds, uint256 _tokenPrice, uint256 _activeSupply) public {
368         require( _wallet != address(0), "_wallet != address(0)" );
369         require( _time.length != 0, "_time.length != 0" );
370         require( _time.length == _funds.length, "_time.length == _funds.length" );
371         
372         wallet = _wallet;
373         
374         tokenContract = tokenInterface(_tokenAddress);
375         tokenSaleContract = TokedoDaico(msg.sender);
376         
377         time = _time;
378         funds = _funds;
379         
380         activeSupply = _activeSupply;
381         tokenPrice = _tokenPrice;
382     }
383     
384     modifier onlyTokenSaleOwner() {
385         require(msg.sender == tokenSaleContract.owner(), "msg.sender == tokenSaleContract.owner()" );
386         _;
387     }
388     
389     event Distrust(address sender, uint256 amount);
390     event Locked();
391     
392     function distrust(address _from, uint _value, bytes _data) public {
393         require(msg.sender == address(tokenContract), "msg.sender == address(tokenContract)");
394         
395         if ( !locked ) {
396             
397             uint256 startTimeMilestone = time[step].sub(timeframeMilestone);
398             uint256 endTimeMilestone = time[step];
399             uint256 startTimeProjectDeath = time[step].add(timeframeDeath);
400             bool unclaimedFunds = funds[step] > 0;
401             
402             require( 
403                 ( now > startTimeMilestone && now < endTimeMilestone ) || 
404                 ( now > startTimeProjectDeath && unclaimedFunds ), 
405                 "( now > startTimeMilestone && now < endTimeMilestone ) || ( now > startTimeProjectDeath && unclaimedFunds )" 
406             );
407         } else {
408             require( locked && now < endTimeToReturnTokens ); //a timeframePost to deposit all tokens and then claim the refundMe method
409         }
410         
411         balance[_from][step] = balance[_from][step].add(_value);
412         tokenDistrusted[step] = tokenDistrusted[step].add(_value);
413         
414         emit Distrust(msg.sender, _value);
415         
416         if( tokenDistrusted[step] > activeSupply && !locked ) {
417             locked = true;
418             endTimeToReturnTokens = now.add(timeframeDeath);
419             emit Locked();
420         }
421     }
422     
423     function tokenFallback(address _from, uint _value, bytes _data) public {
424         distrust( _from, _value, _data);
425     }
426 	
427 	function receiveApproval( address _from, uint _value, bytes _data) public {
428 	    require(msg.sender == address(tokenContract), "msg.sender == address(tokenContract)");
429 		require(msg.sender.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, this, _value));
430         distrust( _from, _value, _data);
431     }
432     
433     event Trust(address sender, uint256 amount);
434     event Unlocked();
435     
436     function trust(uint8 _step) public {
437         require( balance[msg.sender][_step] > 0 , "balance[msg.sender] > 0");
438         
439         uint256 amount = balance[msg.sender][_step];
440         balance[msg.sender][_step] = 0;
441         
442         tokenDistrusted[_step] = tokenDistrusted[_step].sub(amount);
443         tokenContract.transfer(msg.sender, amount);
444         
445         emit Trust(msg.sender, amount);
446         
447         if( tokenDistrusted[step] <= activeSupply && locked ) {
448             locked = false;
449             endTimeToReturnTokens = 0;
450             emit Unlocked();
451         }
452     }
453     
454     event Refund(address sender, uint256 money);
455     
456     function refundMe() public {
457         require(locked, "locked");
458         require( now > endTimeToReturnTokens, "now > endTimeToReturnTokens" );
459         
460         uint256 ethTot = address(this).balance;
461         require( ethTot > 0 , "ethTot > 0");
462         
463         uint256 tknAmount = balance[msg.sender][step];
464         require( tknAmount > 0 , "tknAmount > 0");
465         
466         balance[msg.sender][step] = 0;
467         
468         tokenContract.burn(tknAmount);
469         
470         uint256 tknTot = tokenDistrusted[step];
471         uint256 rate = tknAmount.mul(1e18).div(tknTot);
472         uint256 money = ethTot.mul(rate).div(1e18);
473         
474         if( money > address(this).balance ) {
475 		    money = address(this).balance;
476 		}
477         msg.sender.transfer(money);
478         
479         emit Refund(msg.sender, money);
480     }
481     
482     function ownerWithdraw() public onlyTokenSaleOwner {
483         require(!locked, "!locked");
484         
485         require(now > time[step], "now > time[step]");
486         require(funds[step] > 0, "funds[step] > 0");
487         
488         uint256 amountApplied = funds[step];
489         funds[step] = 0;
490 		step = step+1;
491 		
492 		uint256 value;
493 		if( amountApplied > address(this).balance || time.length == step+1)
494 		    value = address(this).balance;
495 		else {
496 		    value = amountApplied;
497 		}
498 		
499         msg.sender.transfer(value);
500     }
501     
502     function ownerWithdrawTokens(address _tokenContract, address to, uint256 value) public onlyTokenSaleOwner returns (bool) { //for airdrop reason to distribute to Tokedo Token Holder
503         require( _tokenContract != address(tokenContract), "_tokenContract != address(tokenContract)"); // the owner can withdraw tokens except Tokedo Tokens
504         return tokenInterface(_tokenContract).transfer(to, value);
505     }
506     
507     function setWallet(address _wallet) public onlyTokenSaleOwner returns(bool) {
508         require( _wallet != address(0), "_wallet != address(0)" );
509         wallet = _wallet;
510 		return true;
511     }
512     
513     function () public payable {
514         require(msg.sender == address(tokenSaleContract), "msg.sender == address(tokenSaleContract)");
515         
516         if( etherReceived < funds[0]  ) {
517             require( wallet != address(0), "wallet != address(0)" );
518             wallet.transfer(msg.value);
519         }
520         
521         etherReceived = etherReceived.add(msg.value);
522     }
523 }