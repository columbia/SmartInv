1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18      return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40 	address public owner;
41 	address public newOwner;
42 
43 	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
44 
45 	constructor() public {
46 		owner = msg.sender;
47 		newOwner = address(0);
48 	}
49 
50 	modifier onlyOwner() {
51 		require(msg.sender == owner, "msg.sender == owner");
52 		_;
53 	}
54 
55 	function transferOwnership(address _newOwner) public onlyOwner {
56 		require(address(0) != _newOwner, "address(0) != _newOwner");
57 		newOwner = _newOwner;
58 	}
59 
60 	function acceptOwnership() public {
61 		require(msg.sender == newOwner, "msg.sender == newOwner");
62 		emit OwnershipTransferred(owner, msg.sender);
63 		owner = msg.sender;
64 		newOwner = address(0);
65 	}
66 }
67 
68 contract tokenInterface {
69 	function balanceOf(address _owner) public constant returns (uint256 balance);
70 	function transfer(address _to, uint256 _value) public returns (bool);
71 	function burn(uint256 _value) public returns(bool);
72 	uint256 public totalSupply;
73 	uint256 public decimals;
74 }
75 
76 contract rateInterface {
77     function readRate(string _currency) public view returns (uint256 oneEtherValue);
78 }
79 
80 contract RC {
81     using SafeMath for uint256;
82     DaicoCoinCrowd tokenSaleContract;
83     uint256 public startTime;
84     uint256 public endTime;
85     
86     uint256 public etherMinimum;
87     uint256 public soldTokens;
88     uint256 public remainingTokens;
89     
90     uint256 public oneTokenInFiatWei;
91 
92     constructor(address _tokenSaleContract, uint256 _oneTokenInFiatWei, uint256 _remainingTokens, uint256 _etherMinimum, uint256 _startTime , uint256 _endTime) public {
93         require ( _tokenSaleContract != 0, "Token Sale Contract can not be 0" );
94         require ( _oneTokenInFiatWei != 0, "Token price can no be 0" );
95         require( _remainingTokens != 0, "Remaining tokens can no be 0");
96        
97         
98         
99         tokenSaleContract = DaicoCoinCrowd(_tokenSaleContract);
100         
101         soldTokens = 0;
102         remainingTokens = _remainingTokens;
103         oneTokenInFiatWei = _oneTokenInFiatWei;
104         etherMinimum = _etherMinimum;
105         
106         setTimeRC( _startTime, _endTime );
107     }
108     
109     function setTimeRC(uint256 _startTime, uint256 _endTime ) internal {
110         if( _startTime == 0 ) {
111             startTime = tokenSaleContract.startTime();
112         } else {
113             startTime = _startTime;
114         }
115         if( _endTime == 0 ) {
116             endTime = tokenSaleContract.endTime();
117         } else {
118             endTime = _endTime;
119         }
120     }
121     
122     modifier onlyTokenSaleOwner() {
123         require(msg.sender == tokenSaleContract.owner(), "msg.sender == tokenSaleContract.owner()" );
124         _;
125     }
126     
127     function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {
128         if ( _newStart != 0 ) startTime = _newStart;
129         if ( _newEnd != 0 ) endTime = _newEnd;
130     }
131     
132     function changeMinimum(uint256 _newEtherMinimum) public onlyTokenSaleOwner {
133         etherMinimum = _newEtherMinimum;
134     }
135     
136     function started() public view returns(bool) {
137         return now > startTime || remainingTokens == 0;
138     }
139     
140     function ended() public view returns(bool) {
141         return now > endTime || remainingTokens == 0;
142     }
143     
144     function startTime() public view returns(uint) {
145         return startTime;
146     }
147     
148     function endTime() public view returns(uint) {
149         return endTime;
150     }
151     
152     function totalTokens() public view returns(uint) {
153         return remainingTokens.add(soldTokens);
154     }
155     
156     function remainingTokens() public view returns(uint) {
157         return remainingTokens;
158     }
159     
160     function price() public view returns(uint) {
161         uint256 oneEther = 1 ether;
162         return oneEther.mul(10**18).div( tokenSaleContract.tokenValueInEther(oneTokenInFiatWei) );
163     }
164     
165     event BuyRC(address indexed buyer, bytes trackID, uint256 value, uint256 soldToken, uint256 valueTokenInUsdWei );
166 	
167     function () public payable {
168         require( now > startTime, "now > startTime" );
169         require( now < endTime, "now < endTime" );
170         require( msg.value >= etherMinimum, "msg.value >= etherMinimum"); 
171         require( remainingTokens > 0, "remainingTokens > 0" );
172         
173         uint256 tokenAmount = tokenSaleContract.buyFromRC.value(msg.value)(msg.sender, oneTokenInFiatWei, remainingTokens);
174         
175         remainingTokens = remainingTokens.sub(tokenAmount);
176         soldTokens = soldTokens.add(tokenAmount);
177         
178         emit BuyRC( msg.sender, msg.data, msg.value, tokenAmount, oneTokenInFiatWei );
179     }
180 }
181 
182 contract DaicoCoinCrowd is Ownable {
183     using SafeMath for uint256;
184     tokenInterface public tokenContract;
185     rateInterface public rateContract;
186     
187     address public wallet;
188     
189 	uint256 public decimals;
190     
191     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
192     uint256 public startTime;  // seconds from 1970-01-01T00:00:00Z
193     
194     uint256 public oneTokenInEur;
195 
196     mapping(address => bool) public rc;
197 
198     constructor(address _tokenAddress, address _rateAddress, uint256 _startTime, uint256 _endTime, uint256[] _time, uint256[] _funds, uint256 _oneTokenInEur, uint256 _activeSupply) public {
199         tokenContract = tokenInterface(_tokenAddress);
200         rateContract = rateInterface(_rateAddress);
201         setTime(_startTime, _endTime); 
202         decimals = tokenContract.decimals();
203         oneTokenInEur = _oneTokenInEur;
204         wallet = new MilestoneSystem(_tokenAddress, _time, _funds, _oneTokenInEur, _activeSupply);
205     }
206     
207     function tokenValueInEther(uint256 _oneTokenInFiatWei) public view returns(uint256 tknValue) {
208         uint256 oneEtherPrice = rateContract.readRate("eur");
209         tknValue = _oneTokenInFiatWei.mul(10 ** uint256(decimals)).div(oneEtherPrice);
210         return tknValue;
211     } 
212     
213     modifier isBuyable() {
214         require( wallet != address(0), "wallet != address(0)" );
215         require( now > startTime, "now > startTime" ); // check if started
216         require( now < endTime, "now < endTime"); // check if ended
217         require( msg.value > 0, "msg.value > 0" );
218 		
219 		uint256 remainingTokens = tokenContract.balanceOf(this);
220         require( remainingTokens > 0, "remainingTokens > 0" ); // Check if there are any remaining tokens 
221         _;
222     }
223     
224     event Buy(address buyer, uint256 value, address indexed ambassador);
225     
226     modifier onlyRC() {
227         require( rc[msg.sender], "rc[msg.sender]" ); //check if is an authorized rcContract
228         _;
229     }
230     
231     function buyFromRC(address _buyer, uint256 _rcTokenValue, uint256 _remainingTokens) onlyRC isBuyable public payable returns(uint256) {
232         uint256 oneToken = 10 ** uint256(decimals);
233         uint256 tokenValue = tokenValueInEther(_rcTokenValue);
234         uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);
235         address _ambassador = msg.sender;
236         
237         uint256 remainingTokens = tokenContract.balanceOf(this);
238         if ( _remainingTokens < remainingTokens ) {
239             remainingTokens = _remainingTokens;
240         }
241         
242         if ( remainingTokens < tokenAmount ) {
243             uint256 refund = tokenAmount.sub(remainingTokens).mul(tokenValue).div(oneToken);
244             tokenAmount = remainingTokens;
245             forward(msg.value.sub(refund));
246 			remainingTokens = 0; // set remaining token to 0
247              _buyer.transfer(refund);
248         } else {
249 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
250             forward(msg.value);
251         }
252         
253         tokenContract.transfer(_buyer, tokenAmount);
254         emit Buy(_buyer, tokenAmount, _ambassador);
255 		
256         return tokenAmount; 
257     }
258     
259     function forward(uint256 _amount) internal {
260         wallet.transfer(_amount);
261     }
262 
263     event NewRC(address contr);
264     
265     function addRC(address _rc) onlyOwner public {
266         rc[ _rc ]  = true;
267         emit NewRC(_rc);
268     }
269     
270     function setTime(uint256 _newStart, uint256 _newEnd) public onlyOwner {
271         if ( _newStart != 0 ) startTime = _newStart;
272         if ( _newEnd != 0 ) endTime = _newEnd;
273     }
274     
275     function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
276         return tokenContract.transfer(to, value);
277     }
278     
279     function setTokenContract(address _tokenContract) public onlyOwner {
280         tokenContract = tokenInterface(_tokenContract);
281     }
282     
283     function setRateContract(address _rateAddress) public onlyOwner {
284         rateContract = rateInterface(_rateAddress);
285     }
286 	
287 	function claim(address _buyer, uint256 _amount) onlyRC public returns(bool) {
288         return tokenContract.transfer(_buyer, _amount);
289     }
290 
291     function () public payable {
292         revert();
293     }
294 }
295 
296 contract MilestoneSystem {
297     using SafeMath for uint256;
298     tokenInterface public tokenContract;
299     DaicoCoinCrowd public tokenSaleContract;
300     
301     uint256[] public time;
302     uint256[] public funds;
303     
304     bool public locked = false; 
305     uint256 public endTimeToReturnTokens; 
306     
307     uint8 public step = 0;
308     
309     uint256 public constant timeframeMilestone = 3 days; 
310     uint256 public constant timeframeDeath = 30 days; 
311     
312     uint256 public activeSupply;
313     
314     uint256 public oneTokenInEur;
315     
316     mapping(address => mapping(uint8 => uint256) ) public balance;
317     mapping(uint8 => uint256) public tokenDistrusted;
318     
319     constructor(address _tokenAddress, uint256[] _time, uint256[] _funds, uint256 _oneTokenInEur, uint256 _activeSupply) public {
320         require( _time.length != 0, "_time.length != 0" );
321         require( _time.length == _funds.length, "_time.length == _funds.length" );
322         
323         tokenContract = tokenInterface(_tokenAddress);
324         tokenSaleContract = DaicoCoinCrowd(msg.sender);
325         
326         time = _time;
327         funds = _funds;
328         
329         activeSupply = _activeSupply;
330         oneTokenInEur = _oneTokenInEur;
331     }
332     
333     modifier onlyTokenSaleOwner() {
334         require(msg.sender == tokenSaleContract.owner(), "msg.sender == tokenSaleContract.owner()" );
335         _;
336     }
337     
338     event Distrust(address sender, uint256 amount);
339     event Locked();
340     
341     function distrust(address _from, uint _value, bytes _data) public {
342         require(msg.sender == address(tokenContract), "msg.sender == address(tokenContract)");
343         
344         if ( !locked ) {
345             
346             uint256 startTimeMilestone = time[step].sub(timeframeMilestone);
347             uint256 endTimeMilestone = time[step];
348             uint256 startTimeProjectDeath = time[step].add(timeframeDeath);
349             bool unclaimedFunds = funds[step] > 0;
350             
351             require( 
352                 ( now > startTimeMilestone && now < endTimeMilestone ) || 
353                 ( now > startTimeProjectDeath && unclaimedFunds ), 
354                 "( now > startTimeMilestone && now < endTimeMilestone ) || ( now > startTimeProjectDeath && unclaimedFunds )" 
355             );
356         } else {
357             require( locked && now < endTimeToReturnTokens ); //a timeframePost to deposit all tokens and then claim the refundMe method
358         }
359         
360         balance[_from][step] = balance[_from][step].add(_value);
361         tokenDistrusted[step] = tokenDistrusted[step].add(_value);
362         
363         emit Distrust(msg.sender, _value);
364         
365         if( tokenDistrusted[step] > activeSupply && !locked ) {
366             locked = true;
367             endTimeToReturnTokens = now.add(timeframeDeath);
368             emit Locked();
369         }
370     }
371     
372     function tokenFallback(address _from, uint _value, bytes _data) public {
373         distrust( _from, _value, _data);
374     }
375 	
376 	function receiveApproval( address _from, uint _value, bytes _data) public {
377 	    require(msg.sender == address(tokenContract), "msg.sender == address(tokenContract)");
378 		require(msg.sender.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, this, _value));
379         distrust( _from, _value, _data);
380     }
381     
382     event Trust(address sender, uint256 amount);
383     event Unlocked();
384     
385     function trust(uint8 _step) public {
386         require( balance[msg.sender][_step] > 0 , "balance[msg.sender] > 0");
387         
388         uint256 amount = balance[msg.sender][_step];
389         balance[msg.sender][_step] = 0;
390         
391         tokenDistrusted[_step] = tokenDistrusted[_step].sub(amount);
392         tokenContract.transfer(msg.sender, amount);
393         
394         emit Trust(msg.sender, amount);
395         
396         if( tokenDistrusted[step] <= activeSupply && locked ) {
397             locked = false;
398             endTimeToReturnTokens = 0;
399             emit Unlocked();
400         }
401     }
402     
403     event Refund(address sender, uint256 money);
404     
405     function refundMe() public {
406         require(locked, "locked");
407         require( now > endTimeToReturnTokens, "now > endTimeToReturnTokens" );
408         
409         uint256 ethTot = address(this).balance;
410         require( ethTot > 0 , "ethTot > 0");
411         
412         uint256 tknAmount = balance[msg.sender][step];
413         require( tknAmount > 0 , "tknAmount > 0");
414         
415         balance[msg.sender][step] = 0;
416         
417         tokenContract.burn(tknAmount);
418         
419         uint256 tknTot = tokenDistrusted[step];
420         uint256 rate = tknAmount.mul(1 ether).div(tknTot);
421         uint256 money = ethTot.mul(rate).div(1 ether);
422         
423         uint256 moneyMax = tknAmount.mul( tokenSaleContract.tokenValueInEther( oneTokenInEur )).div(1 ether) ;
424         
425         if ( money > moneyMax) { //This protects the project from the overvaluation of ether
426             money = moneyMax;
427         }
428         
429         if( money > address(this).balance ) {
430 		    money = address(this).balance;
431 		}
432         msg.sender.transfer(money);
433         
434         emit Refund(msg.sender, money);
435     }
436     
437     function OwnerWithdraw() public onlyTokenSaleOwner {
438         require(!locked, "!locked");
439         
440         require(now > time[step], "now > time[step]");
441         require(funds[step] > 0, "funds[step] > 0");
442         
443         uint256 amountApplied = funds[step];
444         funds[step] = 0;
445 		step = step+1;
446 		
447 		uint256 value;
448 		if( amountApplied > address(this).balance || time.length == step+1)
449 		    value = address(this).balance;
450 		else {
451 		    value = amountApplied;
452 		}
453 		
454         msg.sender.transfer(value);
455     }
456     
457     function OwnerWithdrawTokens(address _tokenContract, address to, uint256 value) public onlyTokenSaleOwner returns (bool) { //for airdrop reason to distribute to CoinCrowd Token Holder
458         require( _tokenContract != address(tokenContract), "_tokenContract != address(tokenContract)"); // the owner can withdraw tokens except CoinCrowd Tokens
459         return tokenInterface(_tokenContract).transfer(to, value);
460     }
461     
462     function () public payable {
463         require(msg.sender == address(tokenSaleContract), "msg.sender == address(tokenSaleContract)");
464     }
465 }