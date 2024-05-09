1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
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
40   address public owner;
41   
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() internal {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public {
65     require(newOwner != address(0));
66     emit OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 }
70 
71 contract tokenInterface {
72 	function balanceOf(address _owner) public constant returns (uint256 balance);
73 	function transfer(address _to, uint256 _value) public returns (bool);
74 }
75 
76 contract rateInterface {
77     function readRate(string _currency) public view returns (uint256 oneEtherValue);
78 }
79 
80 contract ICOEngineInterface {
81 
82     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
83     function started() public view returns(bool);
84 
85     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
86     function ended() public view returns(bool);
87 
88     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
89     function startTime() public view returns(uint);
90 
91     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
92     function endTime() public view returns(uint);
93 
94     // Optional function, can be implemented in place of startTime
95     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
96     // function startBlock() public view returns(uint);
97 
98     // Optional function, can be implemented in place of endTime
99     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
100     // function endBlock() public view returns(uint);
101 
102     // returns the total number of the tokens available for the sale, must not change when the ico is started
103     function totalTokens() public view returns(uint);
104 
105     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
106     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
107     function remainingTokens() public view returns(uint);
108 
109     // return the price as number of tokens released for each ether
110     function price() public view returns(uint);
111 }
112 
113 contract KYCBase {
114     using SafeMath for uint256;
115 
116     mapping (address => bool) public isKycSigner;
117     mapping (uint64 => uint256) public alreadyPayed;
118 
119     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
120 
121     function KYCBase(address [] kycSigners) internal {
122         for (uint i = 0; i < kycSigners.length; i++) {
123             isKycSigner[kycSigners[i]] = true;
124         }
125     }
126 
127     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
128     function releaseTokensTo(address buyer) internal returns(bool);
129 
130     // This method can be overridden to enable some sender to buy token for a different address
131     function senderAllowedFor(address buyer)
132         internal view returns(bool)
133     {
134         return buyer == msg.sender;
135     }
136 
137     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
138         public payable returns (bool)
139     {
140         require(senderAllowedFor(buyerAddress));
141         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
142     }
143 
144     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
145         public payable returns (bool)
146     {
147         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
148     }
149 
150     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
151         private returns (bool)
152     {
153         // check the signature
154         bytes32 hash = sha256("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount);
155         address signer = ecrecover(hash, v, r, s);
156         //if (!isKycSigner[signer]) {
157         //    revert();
158         //} else {
159             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
160             require(totalPayed <= maxAmount);
161             alreadyPayed[buyerId] = totalPayed;
162             emit KycVerified(signer, buyerAddress, buyerId, maxAmount);
163             return releaseTokensTo(buyerAddress);
164         //}
165     }
166 }
167 
168 contract RC is ICOEngineInterface, KYCBase {
169     using SafeMath for uint256;
170     TokenSale tokenSaleContract;
171     uint256 public startTime;
172     uint256 public endTime;
173     
174     uint256 public soldTokens;
175     uint256 public remainingTokens;
176     
177     uint256 public oneTokenInUsdWei;
178 	
179 	mapping(address => uint256) public balanceUser; // address => token amount
180 	uint256[] public tokenThreshold; // array of token threshold reached in wei of token
181     uint256[] public bonusThreshold; // array of bonus of each tokenThreshold reached - 20% = 20
182 
183     function RC(address _tokenSaleContract, uint256 _oneTokenInUsdWei, uint256 _remainingTokens,  uint256 _startTime , uint256 _endTime, address [] kycSigner, uint256[] _tokenThreshold, uint256[] _bonusThreshold ) public KYCBase(kycSigner) {
184         require ( _tokenSaleContract != 0 );
185         require ( _oneTokenInUsdWei != 0 );
186         require( _remainingTokens != 0 );
187         require ( _tokenThreshold.length != 0 );
188         require ( _tokenThreshold.length == _bonusThreshold.length );
189         bonusThreshold = _bonusThreshold;
190         tokenThreshold = _tokenThreshold;
191         
192         
193         tokenSaleContract = TokenSale(_tokenSaleContract);
194         
195         tokenSaleContract.addMeByRC();
196         
197         soldTokens = 0;
198         remainingTokens = _remainingTokens;
199         oneTokenInUsdWei = _oneTokenInUsdWei;
200         
201         setTimeRC( _startTime, _endTime );
202     }
203     
204     function setTimeRC(uint256 _startTime, uint256 _endTime ) internal {
205         if( _startTime == 0 ) {
206             startTime = tokenSaleContract.startTime();
207         } else {
208             startTime = _startTime;
209         }
210         if( _endTime == 0 ) {
211             endTime = tokenSaleContract.endTime();
212         } else {
213             endTime = _endTime;
214         }
215     }
216     
217     modifier onlyTokenSaleOwner() {
218         require(msg.sender == tokenSaleContract.owner() );
219         _;
220     }
221     
222     function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {
223         if ( _newStart != 0 ) startTime = _newStart;
224         if ( _newEnd != 0 ) endTime = _newEnd;
225     }
226     
227     event BuyRC(address indexed buyer, bytes trackID, uint256 value, uint256 soldToken, uint256 valueTokenInUsdWei );
228     
229     function releaseTokensTo(address buyer) internal returns(bool) {
230         require( now > startTime );
231         require( now < endTime );
232         //require( msg.value >= 1*10**18); //1 Ether
233         require( remainingTokens > 0 );
234         
235         uint256 tokenAmount = tokenSaleContract.buyFromRC.value(msg.value)(buyer, oneTokenInUsdWei, remainingTokens);
236         
237 		balanceUser[msg.sender] = balanceUser[msg.sender].add(tokenAmount);		
238         remainingTokens = remainingTokens.sub(tokenAmount);
239         soldTokens = soldTokens.add(tokenAmount);
240         
241         emit BuyRC( msg.sender, msg.data, msg.value, tokenAmount, oneTokenInUsdWei );
242         return true;
243     }
244     
245     function started() public view returns(bool) {
246         return now > startTime || remainingTokens == 0;
247     }
248     
249     function ended() public view returns(bool) {
250         return now > endTime || remainingTokens == 0;
251     }
252     
253     function startTime() public view returns(uint) {
254         return startTime;
255     }
256     
257     function endTime() public view returns(uint) {
258         return endTime;
259     }
260     
261     function totalTokens() public view returns(uint) {
262         return remainingTokens.add(soldTokens);
263     }
264     
265     function remainingTokens() public view returns(uint) {
266         return remainingTokens;
267     }
268     
269     function price() public view returns(uint) {
270         uint256 oneEther = 10**18;
271         return oneEther.mul(10**18).div( tokenSaleContract.tokenValueInEther(oneTokenInUsdWei) );
272     }
273 	
274 	function () public {
275         require( now > endTime );
276         require( balanceUser[msg.sender] > 0 );
277         uint256 bonusApplied = 0;
278         for (uint i = 0; i < tokenThreshold.length; i++) {
279             if ( soldTokens > tokenThreshold[i] ) {
280                 bonusApplied = bonusThreshold[i];
281 			}
282 		}    
283 		require( bonusApplied > 0 );
284 		
285 		uint256 addTokenAmount = balanceUser[msg.sender].mul( bonusApplied ).div(10**2);
286 		balanceUser[msg.sender] = 0; 
287 		
288 		tokenSaleContract.claim(msg.sender, addTokenAmount);
289 	}
290 }
291 
292 contract TokenSale is Ownable {
293     using SafeMath for uint256;
294     tokenInterface public tokenContract;
295     rateInterface public rateContract;
296     
297     address public wallet;
298     address public advisor;
299     uint256 public advisorFee; // 1 = 0,1%
300     
301 	uint256 public constant decimals = 18;
302     
303     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
304     uint256 public startTime;  // seconds from 1970-01-01T00:00:00Z
305 
306     mapping(address => bool) public rc;
307 
308 
309     function TokenSale(address _tokenAddress, address _rateAddress, uint256 _startTime, uint256 _endTime) public {
310         tokenContract = tokenInterface(_tokenAddress);
311         rateContract = rateInterface(_rateAddress);
312         setTime(_startTime, _endTime); 
313         wallet = msg.sender;
314         advisor = msg.sender;
315         advisorFee = 0 * 10**3;
316     }
317     
318     function tokenValueInEther(uint256 _oneTokenInUsdWei) public view returns(uint256 tknValue) {
319         uint256 oneEtherInUsd = rateContract.readRate("usd");
320         tknValue = _oneTokenInUsdWei.mul(10 ** uint256(decimals)).div(oneEtherInUsd);
321         return tknValue;
322     } 
323     
324     modifier isBuyable() {
325         require( now > startTime ); // check if started
326         require( now < endTime ); // check if ended
327         require( msg.value > 0 );
328 		
329 		uint256 remainingTokens = tokenContract.balanceOf(this);
330         require( remainingTokens > 0 ); // Check if there are any remaining tokens 
331         _;
332     }
333     
334     event Buy(address buyer, uint256 value, address indexed ambassador);
335     
336     modifier onlyRC() {
337         require( rc[msg.sender] ); //check if is an authorized rcContract
338         _;
339     }
340     
341     function buyFromRC(address _buyer, uint256 _rcTokenValue, uint256 _remainingTokens) onlyRC isBuyable public payable returns(uint256) {
342         uint256 oneToken = 10 ** uint256(decimals);
343         uint256 tokenValue = tokenValueInEther(_rcTokenValue);
344         uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);
345         address _ambassador = msg.sender;
346         
347         
348         uint256 remainingTokens = tokenContract.balanceOf(this);
349         if ( _remainingTokens < remainingTokens ) {
350             remainingTokens = _remainingTokens;
351         }
352         
353         if ( remainingTokens < tokenAmount ) {
354             uint256 refund = (tokenAmount - remainingTokens).mul(tokenValue).div(oneToken);
355             tokenAmount = remainingTokens;
356             forward(msg.value-refund);
357 			remainingTokens = 0; // set remaining token to 0
358              _buyer.transfer(refund);
359         } else {
360 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
361             forward(msg.value);
362         }
363         
364         tokenContract.transfer(_buyer, tokenAmount);
365         emit Buy(_buyer, tokenAmount, _ambassador);
366 		
367         return tokenAmount; 
368     }
369     
370     function forward(uint256 _amount) internal {
371         uint256 advisorAmount = _amount.mul(advisorFee).div(10**3);
372         uint256 walletAmount = _amount - advisorAmount;
373         advisor.transfer(advisorAmount);
374         wallet.transfer(walletAmount);
375     }
376 
377     event NewRC(address contr);
378     
379     function addMeByRC() public {
380         require(tx.origin == owner);
381         
382         rc[ msg.sender ]  = true;
383         
384         emit NewRC(msg.sender);
385     }
386     
387     function setTime(uint256 _newStart, uint256 _newEnd) public onlyOwner {
388         if ( _newStart != 0 ) startTime = _newStart;
389         if ( _newEnd != 0 ) endTime = _newEnd;
390     }
391 
392     function withdraw(address to, uint256 value) public onlyOwner {
393         to.transfer(value);
394     }
395     
396     function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
397         return tokenContract.transfer(to, value);
398     }
399     
400     function setTokenContract(address _tokenContract) public onlyOwner {
401         tokenContract = tokenInterface(_tokenContract);
402     }
403 
404     function setWalletAddress(address _wallet) public onlyOwner {
405         wallet = _wallet;
406     }
407     
408     function setAdvisorAddress(address _advisor) public onlyOwner {
409             advisor = _advisor;
410     }
411     
412     function setAdvisorFee(uint256 _advisorFee) public onlyOwner {
413             advisorFee = _advisorFee;
414     }
415     
416     function setRateContract(address _rateAddress) public onlyOwner {
417         rateContract = rateInterface(_rateAddress);
418     }
419 	
420 	function claim(address _buyer, uint256 _amount) onlyRC public returns(bool) {
421         return tokenContract.transfer(_buyer, _amount);
422     }
423 
424     function () public payable {
425         revert();
426     }
427 }