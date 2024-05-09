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
66     OwnershipTransferred(owner, newOwner);
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
80 contract RC {
81     using SafeMath for uint256;
82     TokenSale tokenSaleContract;
83     uint256 public startTime;
84     uint256 public endTime;
85     
86     uint256 public soldTokens;
87     uint256 public remainingTokens;
88     
89     uint256 public oneTokenInEurWei;
90 
91     function RC(address _tokenSaleContract, uint256 _oneTokenInEurWei, uint256 _remainingTokens,  uint256 _startTime , uint256 _endTime ) public {
92         require ( _tokenSaleContract != 0 );
93         require ( _oneTokenInEurWei != 0 );
94         require( _remainingTokens != 0 );
95         
96         tokenSaleContract = TokenSale(_tokenSaleContract);
97         
98         tokenSaleContract.addMeByRC();
99         
100         soldTokens = 0;
101         remainingTokens = _remainingTokens;
102         oneTokenInEurWei = _oneTokenInEurWei;
103         
104         setTimeRC( _startTime, _endTime );
105     }
106     
107     function setTimeRC(uint256 _startTime, uint256 _endTime ) internal {
108         if( _startTime == 0 ) {
109             startTime = tokenSaleContract.startTime();
110         } else {
111             startTime = _startTime;
112         }
113         if( _endTime == 0 ) {
114             endTime = tokenSaleContract.endTime();
115         } else {
116             endTime = _endTime;
117         }
118     }
119     
120     modifier onlyTokenSaleOwner() {
121         require(msg.sender == tokenSaleContract.owner() );
122         _;
123     }
124     
125     function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {
126         if ( _newStart != 0 ) startTime = _newStart;
127         if ( _newEnd != 0 ) endTime = _newEnd;
128     }
129     
130     event BuyRC(address indexed buyer, bytes trackID, uint256 value, uint256 soldToken, uint256 valueTokenInEurWei );
131     
132     function () public payable {
133         require( now > startTime );
134         require( now < endTime );
135         //require( msg.value >= 1*10**18); //1 Ether
136         require( remainingTokens > 0 );
137         
138         uint256 tokenAmount = tokenSaleContract.buyFromRC.value(msg.value)(msg.sender, oneTokenInEurWei, remainingTokens);
139         
140         remainingTokens = remainingTokens.sub(tokenAmount);
141         soldTokens = soldTokens.add(tokenAmount);
142         
143         BuyRC( msg.sender, msg.data, msg.value, tokenAmount, oneTokenInEurWei );
144     }
145 }
146 
147 contract TokenSale is Ownable {
148     using SafeMath for uint256;
149     tokenInterface public tokenContract;
150     rateInterface public rateContract;
151     
152     address public wallet;
153     address public advisor;
154     uint256 public advisorFee; // 1 = 0,1%
155     
156 	uint256 public constant decimals = 18;
157     
158     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
159     uint256 public startTime;  // seconds from 1970-01-01T00:00:00Z
160 
161     mapping(address => bool) public rc;
162 
163 
164     function TokenSale(address _tokenAddress, address _rateAddress, uint256 _startTime, uint256 _endTime) public {
165         tokenContract = tokenInterface(_tokenAddress);
166         rateContract = rateInterface(_rateAddress);
167         setTime(_startTime, _endTime); 
168         wallet = msg.sender;
169         advisor = msg.sender;
170         advisorFee = 0 * 10**3;
171     }
172     
173     function tokenValueInEther(uint256 _oneTokenInEurWei) public view returns(uint256 tknValue) {
174         uint256 oneEtherInEur = rateContract.readRate("eur");
175         tknValue = _oneTokenInEurWei.mul(10 ** uint256(decimals)).div(oneEtherInEur);
176         return tknValue;
177     } 
178     
179     modifier isBuyable() {
180         require( now > startTime ); // check if started
181         require( now < endTime ); // check if ended
182         require( msg.value > 0 );
183 		
184 		uint256 remainingTokens = tokenContract.balanceOf(this);
185         require( remainingTokens > 0 ); // Check if there are any remaining tokens 
186         _;
187     }
188     
189     event Buy(address buyer, uint256 value, address indexed ambassador);
190     
191     modifier onlyRC() {
192         require( rc[msg.sender] ); //check if is an authorized rcContract
193         _;
194     }
195     
196     function buyFromRC(address _buyer, uint256 _rcTokenValue, uint256 _remainingTokens) onlyRC isBuyable public payable returns(uint256) {
197         uint256 oneToken = 10 ** uint256(decimals);
198         uint256 tokenValue = tokenValueInEther(_rcTokenValue);
199         uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);
200         address _ambassador = msg.sender;
201         
202         
203         uint256 remainingTokens = tokenContract.balanceOf(this);
204         if ( _remainingTokens < remainingTokens ) {
205             remainingTokens = _remainingTokens;
206         }
207         
208         if ( remainingTokens < tokenAmount ) {
209             uint256 refund = (tokenAmount - remainingTokens).mul(tokenValue).div(oneToken);
210             tokenAmount = remainingTokens;
211             forward(msg.value-refund);
212 			remainingTokens = 0; // set remaining token to 0
213              _buyer.transfer(refund);
214         } else {
215 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
216             forward(msg.value);
217         }
218         
219         tokenContract.transfer(_buyer, tokenAmount);
220         Buy(_buyer, tokenAmount, _ambassador);
221 		
222         return tokenAmount; 
223     }
224     
225     function forward(uint256 _amount) internal {
226         uint256 advisorAmount = _amount.mul(advisorFee).div(10**3);
227         uint256 walletAmount = _amount - advisorAmount;
228         advisor.transfer(advisorAmount);
229         wallet.transfer(walletAmount);
230     }
231 
232     event NewRC(address contr);
233     
234     function addMeByRC() public {
235         require(tx.origin == owner);
236         
237         rc[ msg.sender ]  = true;
238         
239         NewRC(msg.sender);
240     }
241     
242     function setTime(uint256 _newStart, uint256 _newEnd) public onlyOwner {
243         if ( _newStart != 0 ) startTime = _newStart;
244         if ( _newEnd != 0 ) endTime = _newEnd;
245     }
246     
247     modifier onlyOwnerOrRC() {
248         require( rc[msg.sender] || msg.sender == owner );
249         _;
250     }
251 
252     function withdraw(address to, uint256 value) public onlyOwner {
253         to.transfer(value);
254     }
255     
256     function withdrawTokens(address to, uint256 value) public onlyOwnerOrRC returns (bool) {
257         return tokenContract.transfer(to, value);
258     }
259     
260     function setTokenContract(address _tokenContract) public onlyOwner {
261         tokenContract = tokenInterface(_tokenContract);
262     }
263 
264     function setWalletAddress(address _wallet) public onlyOwner {
265         wallet = _wallet;
266     }
267     
268     function setAdvisorAddress(address _advisor) public onlyOwner {
269             advisor = _advisor;
270     }
271     
272     function setAdvisorFee(uint256 _advisorFee) public onlyOwner {
273             advisorFee = _advisorFee;
274     }
275     
276     function setRateContract(address _rateAddress) public onlyOwner {
277         rateContract = rateInterface(_rateAddress);
278     }
279 
280     function () public payable {
281         revert();
282     }
283     
284     function newRC(uint256 _oneTokenInEurWei, uint256 _remainingTokens) onlyOwner public {
285         new RC(this, _oneTokenInEurWei, _remainingTokens, 0, 0 );
286     }
287 }
288 
289 contract PrivateSale {
290     using SafeMath for uint256;
291     TokenSale tokenSaleContract;
292     uint256 public startTime;
293     uint256 internal constant weekInSeconds = 604800; // seconds in a week
294     uint256 public endTime;
295     
296     uint256 public soldTokens;
297     uint256 public remainingTokens;
298     
299     uint256 public oneTokenInEurWei;
300 
301     function PrivateSale(address _tokenSaleContract, uint256 _oneTokenInEurWei, uint256 _remainingTokens,  uint256 _startTime , uint256 _endTime ) public {
302         require ( _tokenSaleContract != 0 );
303         require ( _oneTokenInEurWei != 0 );
304         require( _remainingTokens != 0 );
305         
306         tokenSaleContract = TokenSale(_tokenSaleContract);
307         
308         tokenSaleContract.addMeByRC();
309         
310         soldTokens = 0;
311         remainingTokens = _remainingTokens;
312         oneTokenInEurWei = _oneTokenInEurWei;
313         
314         setTimeRC( _startTime, _endTime );
315     }
316     
317     function setTimeRC(uint256 _startTime, uint256 _endTime ) internal {
318         if( _startTime == 0 ) {
319             startTime = tokenSaleContract.startTime();
320         } else {
321             startTime = _startTime;
322         }
323         if( _endTime == 0 ) {
324             endTime = tokenSaleContract.endTime();
325         } else {
326             endTime = _endTime;
327         }
328     }
329     
330     modifier onlyTokenSaleOwner() {
331         require(msg.sender == tokenSaleContract.owner() );
332         _;
333     }
334     
335     function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {
336         if ( _newStart != 0 ) startTime = _newStart;
337         if ( _newEnd != 0 ) endTime = _newEnd;
338     }
339     
340     event BuyRC(address indexed buyer, bytes trackID, uint256 value, uint256 soldToken, uint256 valueTokenInEurWei );
341     
342     function () public payable {
343         require( now > startTime );
344         require( now < endTime );
345         //require( msg.value >= 1*10**18); //1 Ether
346         require( remainingTokens > 0 );
347         
348         uint256 tokenAmount = tokenSaleContract.buyFromRC.value(msg.value)(msg.sender, oneTokenInEurWei, remainingTokens);
349         
350         remainingTokens = remainingTokens.sub(tokenAmount);
351         soldTokens = soldTokens.add(tokenAmount);
352         
353         uint256 bonusRate;
354         if( now > startTime + weekInSeconds*0  ) { bonusRate = 1000; }
355         if( now > startTime + weekInSeconds*1  ) { bonusRate = 800; }
356         if( now > startTime + weekInSeconds*2  ) { bonusRate = 600; }
357         if( now > startTime + weekInSeconds*3  ) { bonusRate = 400; }
358         if( now > startTime + weekInSeconds*4  ) { bonusRate = 200; }
359         if( now > startTime + weekInSeconds*5  ) { bonusRate = 0; }
360         
361         tokenSaleContract.withdrawTokens(msg.sender, tokenAmount.mul( bonusRate ).div(10**4) );
362         
363         BuyRC( msg.sender, msg.data, msg.value, tokenAmount, oneTokenInEurWei );
364     }
365 }