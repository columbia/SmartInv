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
89     uint256 public oneTokenInUsdWei;
90 
91     function RC(address _tokenSaleContract, uint256 _oneTokenInUsdWei, uint256 _remainingTokens,  uint256 _startTime , uint256 _endTime ) public {
92         require ( _tokenSaleContract != 0 );
93         require ( _oneTokenInUsdWei != 0 );
94         require( _remainingTokens != 0 );
95         
96         tokenSaleContract = TokenSale(_tokenSaleContract);
97         
98         tokenSaleContract.addMeByRC();
99         
100         soldTokens = 0;
101         remainingTokens = _remainingTokens;
102         oneTokenInUsdWei = _oneTokenInUsdWei;
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
130     event BuyRC(address indexed buyer, bytes trackID, uint256 value, uint256 soldToken, uint256 valueTokenInUsdWei );
131     
132     function () public payable {
133         require( now > startTime );
134         require( now < endTime );
135         require( msg.value >= 1*10**18); //1 Ether
136         require( remainingTokens > 0 );
137         
138         uint256 tokenAmount = tokenSaleContract.buyFromRC.value(msg.value)(msg.sender, oneTokenInUsdWei, remainingTokens);
139         
140         remainingTokens = remainingTokens.sub(tokenAmount);
141         soldTokens = soldTokens.add(tokenAmount);
142         
143         BuyRC( msg.sender, msg.data, msg.value, tokenAmount, oneTokenInUsdWei );
144     }
145 }
146 
147 contract CardSale {
148     using SafeMath for uint256;
149     TokenSale tokenSaleContract;
150     
151     uint256 public startTime;
152     uint256 public endTime;
153     
154     uint256 public soldTokens;
155     uint256 public remainingTokens;    
156     
157     mapping(address => bool) public rc;
158     
159     function CardSale(address _tokenSaleContract, uint256 _remainingTokens,  uint256 _startTime , uint256 _endTime ) public {
160         require ( _tokenSaleContract != 0 );
161         require( _remainingTokens != 0 );
162         
163         tokenSaleContract = TokenSale(_tokenSaleContract);
164         
165         tokenSaleContract.addMeByRC();
166         
167         soldTokens = 0;
168         remainingTokens = _remainingTokens;
169         
170         setTimeRC( _startTime, _endTime );
171     }
172     
173     function setTimeRC(uint256 _startTime, uint256 _endTime ) internal {
174         if( _startTime == 0 ) {
175             startTime = tokenSaleContract.startTime();
176         } else {
177             startTime = _startTime;
178         }
179         if( _endTime == 0 ) {
180             endTime = tokenSaleContract.endTime();
181         } else {
182             endTime = _endTime;
183         }
184     }
185 
186     function owner() view public returns (address) {
187         return tokenSaleContract.owner();
188     }
189     
190     modifier onlyTokenSaleOwner() {
191         require(msg.sender == owner() );
192         _;
193     }
194     
195     function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {
196         if ( _newStart != 0 ) startTime = _newStart;
197         if ( _newEnd != 0 ) endTime = _newEnd;
198     }
199     
200     event NewRC(address contr);
201     
202     function addMeByRC() public {
203         require(tx.origin == owner() );
204         
205         rc[ msg.sender ]  = true;
206         
207         NewRC(msg.sender);
208     }
209     
210     function newCard(uint256 _oneTokenInUsdWei) onlyTokenSaleOwner public {
211         new RC(this, _oneTokenInUsdWei, remainingTokens, 0, 0 );
212     }
213     
214     function () public payable {
215         revert();
216     }
217     
218     modifier onlyRC() {
219         require( rc[msg.sender] ); //check if is an authorized rcContract
220         _;
221     }
222     
223     function buyFromRC(address _buyer, uint256 _rcTokenValue, uint256 ) onlyRC public payable returns(uint256) {
224         uint256 tokenAmount = tokenSaleContract.buyFromRC.value(msg.value)(_buyer, _rcTokenValue, remainingTokens);
225         remainingTokens = remainingTokens.sub(tokenAmount);
226         soldTokens = soldTokens.add(tokenAmount);
227         return tokenAmount;
228     }
229 }
230 
231 contract TokenSale is Ownable {
232     using SafeMath for uint256;
233     tokenInterface public tokenContract;
234     rateInterface public rateContract;
235     
236     address public wallet;
237     address public advisor;
238     uint256 public advisorFee; // 1 = 0,1%
239     
240 	uint256 public constant decimals = 18;
241     
242     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
243     uint256 public startTime;  // seconds from 1970-01-01T00:00:00Z
244 
245     mapping(address => bool) public rc;
246 
247 
248     function TokenSale(address _tokenAddress, address _rateAddress, uint256 _startTime, uint256 _endTime) public {
249         tokenContract = tokenInterface(_tokenAddress);
250         rateContract = rateInterface(_rateAddress);
251         setTime(_startTime, _endTime); 
252         wallet = msg.sender;
253         advisor = msg.sender;
254         advisorFee = 0 * 10**3;
255     }
256     
257     function tokenValueInEther(uint256 _oneTokenInUsdWei) public view returns(uint256 tknValue) {
258         uint256 oneEtherInUsd = rateContract.readRate("usd");
259         tknValue = _oneTokenInUsdWei.mul(10 ** uint256(decimals)).div(oneEtherInUsd);
260         return tknValue;
261     } 
262     
263     modifier isBuyable() {
264         require( now > startTime ); // check if started
265         require( now < endTime ); // check if ended
266         require( msg.value > 0 );
267 		
268 		uint256 remainingTokens = tokenContract.balanceOf(this);
269         require( remainingTokens > 0 ); // Check if there are any remaining tokens 
270         _;
271     }
272     
273     event Buy(address buyer, uint256 value, address indexed ambassador);
274     
275     modifier onlyRC() {
276         require( rc[msg.sender] ); //check if is an authorized rcContract
277         _;
278     }
279     
280     function buyFromRC(address _buyer, uint256 _rcTokenValue, uint256 _remainingTokens) onlyRC isBuyable public payable returns(uint256) {
281         uint256 oneToken = 10 ** uint256(decimals);
282         uint256 tokenValue = tokenValueInEther(_rcTokenValue);
283         uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);
284         address _ambassador = msg.sender;
285         
286         
287         uint256 remainingTokens = tokenContract.balanceOf(this);
288         if ( _remainingTokens < remainingTokens ) {
289             remainingTokens = _remainingTokens;
290         }
291         
292         if ( remainingTokens < tokenAmount ) {
293             uint256 refund = (tokenAmount - remainingTokens).mul(tokenValue).div(oneToken);
294             tokenAmount = remainingTokens;
295             forward(msg.value-refund);
296 			remainingTokens = 0; // set remaining token to 0
297              _buyer.transfer(refund);
298         } else {
299 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
300             forward(msg.value);
301         }
302         
303         tokenContract.transfer(_buyer, tokenAmount);
304         Buy(_buyer, tokenAmount, _ambassador);
305 		
306         return tokenAmount; 
307     }
308     
309     function forward(uint256 _amount) internal {
310         uint256 advisorAmount = _amount.mul(advisorFee).div(10**3);
311         uint256 walletAmount = _amount - advisorAmount;
312         advisor.transfer(advisorAmount);
313         wallet.transfer(walletAmount);
314     }
315 
316     event NewRC(address contr);
317     
318     function addMeByRC() public {
319         require(tx.origin == owner);
320         
321         rc[ msg.sender ]  = true;
322         
323         NewRC(msg.sender);
324     }
325     
326     function setTime(uint256 _newStart, uint256 _newEnd) public onlyOwner {
327         if ( _newStart != 0 ) startTime = _newStart;
328         if ( _newEnd != 0 ) endTime = _newEnd;
329     }
330 
331     function withdraw(address to, uint256 value) public onlyOwner {
332         to.transfer(value);
333     }
334     
335     function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
336         return tokenContract.transfer(to, value);
337     }
338     
339     function setTokenContract(address _tokenContract) public onlyOwner {
340         tokenContract = tokenInterface(_tokenContract);
341     }
342 
343     function setWalletAddress(address _wallet) public onlyOwner {
344         wallet = _wallet;
345     }
346     
347     function setAdvisorAddress(address _advisor) public onlyOwner {
348             advisor = _advisor;
349     }
350     
351     function setAdvisorFee(uint256 _advisorFee) public onlyOwner {
352             advisorFee = _advisorFee;
353     }
354     
355     function setRateContract(address _rateAddress) public onlyOwner {
356         rateContract = rateInterface(_rateAddress);
357     }
358 
359     function () public payable {
360         revert();
361     }
362     
363     function newRC(uint256 _oneTokenInUsdWei, uint256 _remainingTokens) onlyOwner public {
364         new RC(this, _oneTokenInUsdWei, _remainingTokens, 0, 0 );
365     }
366 }