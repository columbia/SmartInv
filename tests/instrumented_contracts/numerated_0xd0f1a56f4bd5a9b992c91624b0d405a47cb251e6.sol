1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC20 interface 
7  * 
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 
21 
22 /**
23  * @title OwnableWithAdmin 
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract OwnableWithAdmin {
28   address public owner;
29   address public adminOwner;
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   constructor() public {
37     owner = msg.sender;
38     adminOwner = msg.sender;
39   }
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   /**
49    * @dev Throws if called by any account other than the admin.
50    */
51   modifier onlyAdmin() {
52     require(msg.sender == adminOwner);
53     _;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner or admin.
58    */
59   modifier onlyOwnerOrAdmin() {
60     require(msg.sender == adminOwner || msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74   /**
75    * @dev Allows the current adminOwner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferAdminOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(adminOwner, newOwner);
81     adminOwner = newOwner;
82   }
83 
84 }
85 
86 
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     if (a == 0) {
99       return 0;
100     }
101     uint256 c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   /**
117   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 
133   function uint2str(uint i) internal pure returns (string){
134       if (i == 0) return "0";
135       uint j = i;
136       uint length;
137       while (j != 0){
138           length++;
139           j /= 10;
140       }
141       bytes memory bstr = new bytes(length);
142       uint k = length - 1;
143       while (i != 0){
144           bstr[k--] = byte(48 + i % 10);
145           i /= 10;
146       }
147       return string(bstr);
148   }
149  
150   
151 }
152 
153 
154 
155 /**
156  * @title AirDrop
157  * @notice Contract is not payable.
158  * Owner or admin can allocate tokens.
159  * Tokens will be released direct. 
160  *
161  *
162  */
163 contract AirDrop is OwnableWithAdmin {
164   using SafeMath for uint256;
165 
166   uint256 private constant DECIMALFACTOR = 10**uint256(18);
167 
168 
169   event FundsBooked(address backer, uint256 amount, bool isContribution);
170   event LogTokenClaimed(address indexed _recipient, uint256 _amountClaimed, uint256 _totalAllocated, uint256 _grandTotalClaimed);
171   event LogNewAllocation(address indexed _recipient, uint256 _totalAllocated);
172   event LogRemoveAllocation(address indexed _recipient, uint256 _tokenAmountRemoved);
173   event LogOwnerSetAllocation(address indexed _recipient, uint256 _totalAllocated);
174   event LogTest();
175    
176 
177   // Amount of tokens claimed
178   uint256 public grandTotalClaimed = 0;
179 
180   // The token being sold
181   ERC20 public token;
182 
183   // Amount of tokens Raised
184   uint256 public tokensTotal = 0;
185 
186   // Max token amount
187   uint256 public hardCap = 0;
188   
189 
190 
191   // Buyers total allocation
192   mapping (address => uint256) public allocationsTotal;
193 
194   // User total Claimed
195   mapping (address => uint256) public totalClaimed;
196 
197 
198   //Buyers
199   mapping(address => bool) public buyers;
200 
201   //Buyers who received all there tokens
202   mapping(address => bool) public buyersReceived;
203 
204   //List of all addresses
205   address[] public addresses;
206   
207  
208   constructor(ERC20 _token) public {
209      
210     require(_token != address(0));
211 
212     token = _token;
213   }
214 
215   
216   /**
217    * @dev fallback function ***DO NOT OVERRIDE***
218    */
219   function () public {
220     //Not payable
221   }
222 
223   /**
224     * @dev Set many allocations buy admin
225     * @param _recipients Array of wallets
226     * @param _tokenAmount Amount Allocated tokens + 18 decimals
227     */
228   function setManyAllocations (address[] _recipients, uint256 _tokenAmount) onlyOwnerOrAdmin  public{
229     for (uint256 i = 0; i < _recipients.length; i++) {
230       setAllocation(_recipients[i],_tokenAmount);
231     }    
232   }
233 
234 
235   /**
236     * @dev Set allocation buy admin
237     * @param _recipient Users wallet
238     * @param _tokenAmount Amount Allocated tokens + 18 decimals
239     */
240   function setAllocation (address _recipient, uint256 _tokenAmount) onlyOwnerOrAdmin  public{
241       require(_tokenAmount > 0);      
242       require(_recipient != address(0)); 
243 
244       //Check hardCap 
245       require(_validateHardCap(_tokenAmount));
246 
247       //Allocate tokens
248       _setAllocation(_recipient, _tokenAmount);    
249 
250       //Increese token amount
251       tokensTotal = tokensTotal.add(_tokenAmount);  
252 
253       //Logg Allocation
254       emit LogOwnerSetAllocation(_recipient, _tokenAmount);
255   }
256 
257   /**
258     * @dev Remove allocation 
259     * @param _recipient Users wallet
260     *  
261     */
262   function removeAllocation (address _recipient) onlyOwner  public{         
263       require(_recipient != address(0)); 
264       require(totalClaimed[_recipient] == 0); //Check if user claimed tokens
265 
266 
267       //_recipient total amount
268       uint256 _tokenAmountRemoved = allocationsTotal[_recipient];
269 
270       //Decreese token amount
271       tokensTotal = tokensTotal.sub(_tokenAmountRemoved);
272 
273       //Reset allocation
274       allocationsTotal[_recipient] = 0;
275        
276       //Set buyer to false
277       buyers[_recipient] = false;
278 
279       emit LogRemoveAllocation(_recipient, _tokenAmountRemoved);
280   }
281 
282 
283  /**
284    * @dev Set internal allocation 
285    *  _buyer The adress of the buyer
286    *  _tokenAmount Amount Allocated tokens + 18 decimals
287    */
288   function _setAllocation (address _buyer, uint256 _tokenAmount) internal{
289 
290       if(!buyers[_buyer]){
291         //Add buyer to buyers list 
292         buyers[_buyer] = true;
293 
294         //Remove from list 
295         buyersReceived[_buyer] = false;
296 
297         //Add _buyer to addresses list
298         addresses.push(_buyer);
299 
300         //Reset buyer allocation
301         allocationsTotal[_buyer] = 0;
302 
303 
304       }  
305 
306       //Add tokens to buyers allocation
307       allocationsTotal[_buyer]  = allocationsTotal[_buyer].add(_tokenAmount); 
308 
309 
310       //Logg Allocation
311       emit LogNewAllocation(_buyer, _tokenAmount);
312 
313   }
314 
315 
316   /**
317     * @dev Return address available allocation
318     * @param _recipient which address is applicable
319     */
320   function checkAvailableTokens (address _recipient) public view returns (uint256) {
321     //Check if user have bought tokens
322     require(buyers[_recipient]); 
323 
324     return allocationsTotal[_recipient];
325   }
326 
327   /**
328     * @dev Transfer a recipients available allocation to their address
329     * @param _recipients Array of addresses to withdraw tokens for
330     */
331   function distributeManyTokens(address[] _recipients) onlyOwnerOrAdmin public {
332     for (uint256 i = 0; i < _recipients.length; i++) {
333       distributeTokens( _recipients[i]);
334     }
335   }
336 
337   /**
338     * @notice Withdraw available tokens
339     * 
340     */
341   function withdrawTokens() public {
342     distributeTokens(msg.sender);
343   }
344 
345   /**
346     * @dev Transfer a recipients available allocation to _recipient
347     *
348     */
349   function distributeTokens(address _recipient) public {
350     
351     //Check have bought tokens
352     require(buyers[_recipient]);
353 
354     //If all tokens are received, add _recipient to buyersReceived
355     //To prevent the loop to fail if user allready used the withdrawTokens 
356     buyersReceived[_recipient] = true;
357 
358     uint256 _availableTokens = allocationsTotal[_recipient];
359      
360 
361     //Check if contract has tokens
362     require(token.balanceOf(this)>=_availableTokens);
363 
364     //Transfer tokens
365     require(token.transfer(_recipient, _availableTokens));
366 
367     //Add claimed tokens to totalClaimed
368     totalClaimed[_recipient] = totalClaimed[_recipient].add(_availableTokens);
369 
370     //Add claimed tokens to grandTotalClaimed
371     grandTotalClaimed = grandTotalClaimed.add(_availableTokens);
372 
373 
374     //Reset allocation
375     allocationsTotal[_recipient] = 0;
376 
377 
378     emit LogTokenClaimed(_recipient, _availableTokens, allocationsTotal[_recipient], grandTotalClaimed);
379 
380     
381 
382   }
383 
384 
385 
386   function _validateHardCap(uint256 _tokenAmount) internal view returns (bool) {
387       return tokensTotal.add(_tokenAmount) <= hardCap;
388   }
389 
390 
391   function getListOfAddresses() public onlyOwnerOrAdmin view returns (address[]) {    
392     return addresses;
393   }
394 
395 
396   // Allow transfer of tokens back to owner or reserve wallet
397   function returnTokens() public onlyOwner {
398     uint256 balance = token.balanceOf(this);
399     require(token.transfer(owner, balance));
400   }
401 
402   // Owner can transfer tokens that are sent here by mistake
403   function refundTokens(address _recipient, ERC20 _token) public onlyOwner {
404     uint256 balance = _token.balanceOf(this);
405     require(_token.transfer(_recipient, balance));
406   }
407 
408 
409 }
410 
411 
412 
413 /**
414  * @title BYTMAirDrop
415  *  
416  *
417 */
418 contract BYTMAirDrop is AirDrop {
419   constructor(   
420     ERC20 _token
421   ) public AirDrop(_token) {
422 
423     // 40,000,000 tokens
424     hardCap = 40000000 * (10**uint256(18)); 
425 
426   }
427 }