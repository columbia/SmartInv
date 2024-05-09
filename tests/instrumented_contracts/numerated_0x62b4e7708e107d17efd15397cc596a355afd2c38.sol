1 pragma solidity ^0.4.24;
2 
3  
4 /**
5  * @title ERC20 interface + Mint function
6  * 
7  */
8 contract ERC20 {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   function mint(address _to, uint256 _amount) public returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20  
21 /**
22  * @title OwnableWithAdmin 
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract OwnableWithAdmin {
27   address public owner;
28   address public adminOwner;
29 
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   constructor() public {
36     owner = msg.sender;
37     adminOwner = msg.sender;
38   }
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the admin.
49    */
50   modifier onlyAdmin() {
51     require(msg.sender == adminOwner);
52     _;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner or admin.
57    */
58   modifier onlyOwnerOrAdmin() {
59     require(msg.sender == adminOwner || msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     emit OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73   /**
74    * @dev Allows the current adminOwner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferAdminOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     emit OwnershipTransferred(adminOwner, newOwner);
80     adminOwner = newOwner;
81   }
82 
83 }
84 
85  
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, throws on overflow.
94   */
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     if (a == 0) {
97       return 0;
98     }
99     uint256 c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers, truncating the quotient.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   /**
115   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
116   */
117   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   /**
123   * @dev Adds two numbers, throws on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 
131   function uint2str(uint i) internal pure returns (string){
132       if (i == 0) return "0";
133       uint j = i;
134       uint length;
135       while (j != 0){
136           length++;
137           j /= 10;
138       }
139       bytes memory bstr = new bytes(length);
140       uint k = length - 1;
141       while (i != 0){
142           bstr[k--] = byte(48 + i % 10);
143           i /= 10;
144       }
145       return string(bstr);
146   }
147  
148   
149 }
150 
151  
152 /**
153  * @title Crowdsale
154  * Contract is payable.
155  * Direct transfer of tokens with no allocation.
156  *
157  *
158  */
159 contract Crowdsale is OwnableWithAdmin {
160   using SafeMath for uint256;
161 
162   uint256 private constant DECIMALFACTOR = 10**uint256(18);
163 
164   event FundTransfer(address backer, uint256 amount, bool isContribution);
165   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount  );
166    
167   //Is active
168   bool internal crowdsaleActive = true;
169 
170   // The token being sold
171   ERC20 public token;
172 
173   // Address where funds are collected
174   address public wallet;
175 
176   // How many weis one token costs 
177   uint256 public rate;
178 
179   // Minimum weis one token costs 
180   uint256 public minRate; 
181 
182   // Minimum buy in weis 
183   uint256 public minWeiAmount = 100000000000000000; 
184 
185   // Amount of tokens Raised
186   uint256 public tokensTotal = 0;
187 
188   // Amount of wei raised
189   uint256 public weiRaised;
190 
191   // Max token amount
192   uint256 public hardCap = 0;
193 
194   
195   // start and end timestamps where investments are allowed (both inclusive)
196   uint256 public startTime;
197   uint256 public endTime;
198   
199   //Whitelist
200   mapping(address => bool) public whitelist;
201   
202  
203   constructor(uint256 _startTime, uint256 _endTime, address _wallet, ERC20 _token) public {
204      
205     require(_wallet != address(0));
206     require(_token != address(0));
207 
208      
209 
210     startTime   = _startTime;
211     endTime     = _endTime;
212   
213     wallet = _wallet;
214     token = _token;
215   }
216 
217   // -----------------------------------------
218   // Crowdsale external interface
219   // -----------------------------------------
220 
221   /**
222    * @dev fallback function ***DO NOT OVERRIDE***
223    */
224   function () public payable  {
225 
226     //Check if msg sender value is more then 0
227     require( msg.value > 0 );
228 
229     //Validate crowdSale
230     require(isCrowdsaleActive());
231 
232     //Validate whitelisted
233     require(isWhitelisted(msg.sender));
234 
235     // wei sent
236     uint256 _weiAmount = msg.value;
237 
238     // Minimum buy in weis 
239     require(_weiAmount>minWeiAmount);
240 
241     // calculate token amount to be created after rate update
242     uint256 _tokenAmount = _calculateTokens(_weiAmount);
243 
244     //Check hardCap 
245     require(_validateHardCap(_tokenAmount));
246 
247     //Mint tokens and transfer tokens to buyer
248     require(token.mint(msg.sender, _tokenAmount));
249 
250     //Update state
251     tokensTotal = tokensTotal.add(_tokenAmount);
252 
253     //Update state
254     weiRaised = weiRaised.add(_weiAmount);
255 
256     //Funds log function
257     emit TokenPurchase(msg.sender, _tokenAmount , _weiAmount);
258 
259     //Transfer funds to wallet
260     _forwardFunds();
261 
262  
263   }
264 
265  
266   // send ether to the fund collection wallet
267   function _forwardFunds() internal {
268     wallet.transfer(msg.value);
269   }
270 
271 
272   /*
273    * @dev fiat and btc transfer
274    * The company received FIAT or BTC and admin will mint the 
275    * amount of tokens directly to the receiving partyâ€™s wallet
276    *
277   **/
278   function fiatTransfer(address _recipient, uint256 _tokenAmount, uint256 _weiAmount) onlyOwnerOrAdmin public{
279     
280     require(_tokenAmount > 0);      
281     require(_recipient != address(0)); 
282 
283     //Validate crowdSale
284     require(isCrowdsaleActive());
285 
286     //Validate whitelisted
287     require(isWhitelisted(_recipient));
288 
289     // Minimum buy in weis 
290     require(_weiAmount>minWeiAmount); 
291 
292     //Check hardCap 
293     require(_validateHardCap(_tokenAmount));
294 
295     //Mint tokens and transfer tokens to buyer
296     require(token.mint(_recipient, _tokenAmount));
297 
298     //Update state
299     tokensTotal = tokensTotal.add(_tokenAmount);
300 
301     //Update state
302     weiRaised = weiRaised.add(_weiAmount);
303 
304     //Funds log function
305     emit TokenPurchase(_recipient, _tokenAmount, _weiAmount);
306 
307   }
308 
309   // @return true if the transaction can buy tokens
310   function isCrowdsaleActive() public view returns (bool) {
311     bool withinPeriod = now >= startTime && now <= endTime;
312     return withinPeriod;
313   }
314 
315   function _validateHardCap(uint256 _tokenAmount) internal view returns (bool) {
316       return tokensTotal.add(_tokenAmount) <= hardCap;
317   }
318 
319 
320   function _calculateTokens(uint256 _wei) internal view returns (uint256) {
321     return _wei.mul(DECIMALFACTOR).div(rate);
322   }
323 
324  
325 
326   /**
327    * @dev Update current rate
328    * @param _rate How many wei one token costs
329    * We need to be able to update the rate as the eth rate changes
330    */ 
331   function setRate(uint256 _rate) onlyOwnerOrAdmin public{
332     require(_rate > minRate);
333     rate = _rate;
334   }
335 
336 
337   function addToWhitelist(address _buyer) onlyOwnerOrAdmin public{
338     require(_buyer != 0x0);     
339     whitelist[_buyer] = true;
340   }
341   
342 
343   function addManyToWhitelist(address[] _beneficiaries) onlyOwnerOrAdmin public{
344     for (uint256 i = 0; i < _beneficiaries.length; i++) {
345       if(_beneficiaries[i] != 0x0){
346         whitelist[_beneficiaries[i]] = true;
347       }
348     }
349   }
350 
351 
352   function removeFromWhitelist(address _buyer) onlyOwnerOrAdmin public{
353     whitelist[_buyer] = false;
354   }
355 
356 
357   // @return true if buyer is whitelisted
358   function isWhitelisted(address _buyer) public view returns (bool) {
359       return whitelist[_buyer];
360   }
361 
362 
363   
364 
365   // Owner can transfer tokens that are sent here by mistake
366   function refundTokens(address _recipient, ERC20 _token) public onlyOwner {
367     uint256 balance = _token.balanceOf(this);
368     require(_token.transfer(_recipient, balance));
369   }
370 
371 
372 }
373 
374  
375 /**
376  * @title BYTMCrowdsale
377  *  
378  *
379 */
380 contract BYTMCrowdsale is Crowdsale {
381   constructor(   
382     uint256 _startTime, 
383     uint256 _endTime,  
384     address _wallet, 
385     ERC20 _token
386   ) public Crowdsale( _startTime, _endTime,  _wallet, _token) {
387 
388     // Initial rate
389     //What one token cost in wei
390     rate = 870000000000000;   
391 
392     // Initial minimum rate
393     // rate can't be set below this
394     // 0.12 euro
395     minRate = 670000000000000;  
396 
397     // HardCap 1,000,000,000
398     hardCap = 1000000000 * (10**uint256(18)); 
399 
400     //min buy amount in wei
401     // 100euro
402     minWeiAmount = 545000000000000000;
403 
404   }
405 }