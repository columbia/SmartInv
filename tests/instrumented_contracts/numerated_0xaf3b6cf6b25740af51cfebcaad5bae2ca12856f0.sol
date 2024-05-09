1 pragma solidity ^0.4.19;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 contract ERC20 is ERC20Basic {
12 
13   function allowance(address owner, address spender) public view returns (uint256);
14 
15   function transferFrom(address from, address to, uint256 value) public returns (bool);
16 
17   function approve(address spender, uint256 value) public returns (bool);
18 
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21 }
22 
23 
24 
25 contract BasicToken is ERC20Basic {
26 
27   using SafeMath for uint256;
28 
29   mapping(address => uint256) balances;
30 
31   uint256 totalSupply_;
32 
33   uint256 totalRecycledTokens_; 
34 
35   bool public paused = false; 
36 
37   bool public tgeMode = false;
38 
39   address public ceoAddress;
40 
41   address public marketplaceAddress;
42 
43 
44   function totalSupply() public view returns (uint256) {
45     return totalSupply_;
46   }
47 
48   modifier whenNotPaused() { 
49         require(!paused);
50         _;
51   }
52   
53   modifier whenPaused() { 
54         require(paused);
55         _;
56   }
57 
58   modifier onlyCEO() {
59       require(msg.sender == ceoAddress);
60       _;  
61   }
62 
63   function pause() public onlyCEO() whenNotPaused() {
64       paused = true;
65   }
66 
67   function unpause() public onlyCEO() whenPaused() {
68       paused = false;
69   }
70 
71   modifier inTGE() {
72       require(tgeMode);
73       _;  
74   }
75 
76   modifier afterTGE() {
77       require(!tgeMode);
78       _;  
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public whenNotPaused() returns (bool) {
87     require( !tgeMode || (msg.sender == ceoAddress) ); 
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   function balanceOf(address _owner) public view returns (uint256) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 
104 contract ExoToken is ERC20, BasicToken {
105 
106   string public name = "ExoToken";
107 
108   string public symbol = "EXT"; 
109 
110   uint8 public decimals = 18;
111 
112   uint256 public MaxNumTokens = 175000000000000000000000000;
113   
114   uint256 private priceOfToken;
115 
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119   mapping(address => bool) private tgeUserMap;
120   address[] private tgeUserList;
121 
122   event Mint(address _to, uint256 _amount);
123   event RecycleTokens(uint256 value);
124 
125 
126   uint32 public bonusFactor_1 = 5; 
127   uint32 public bonusFactor_2 = 10;
128   uint32 public bonusFactor_3 = 20;
129 
130 
131   function setBonusFactors(uint32 factor_1, uint32 factor_2, uint32 factor_3) public onlyCEO() inTGE() {
132     bonusFactor_1 = factor_1;
133     bonusFactor_2 = factor_2;
134     bonusFactor_3 = factor_3;
135   }
136 
137   /*** CONSTRUCTOR ***/
138   function ExoToken(uint256 initialSupply, uint256 initialPriceOfToken) public {  
139     // set initialSupply to e.g. 82,250,000
140     require(initialPriceOfToken > 0);
141     ceoAddress = msg.sender;
142     marketplaceAddress = msg.sender;
143     priceOfToken = initialPriceOfToken; 
144     balances[msg.sender] = initialSupply;
145     totalSupply_ = initialSupply;
146   }
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused() afterTGE() returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);    
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public whenNotPaused() afterTGE() returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) whenNotPaused() public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   function setPriceOfToken(uint256 newPriceOfToken) public onlyCEO() {
194     require(newPriceOfToken > 0);
195     priceOfToken = newPriceOfToken;
196   }
197 
198   function getPriceOfToken() public view returns(uint256) {
199     return priceOfToken;
200   }
201 
202   function getNumRecycledTokens() public view returns(uint256) {
203     return totalRecycledTokens_;
204   }
205   
206 
207   function recycleTokensForPayment(uint256 numTokens, uint256 payment) public onlyCEO() { 
208     require(payment <= this.balance); 
209     recycleTokens(numTokens); 
210     ceoAddress.transfer(payment);
211   }
212   
213 
214   function recycleTokens(uint256 numTokens) public onlyCEO() { 
215     // allow more tokens to be minted
216     require(numTokens <= balances[ceoAddress]);
217 
218     totalSupply_ = totalSupply_.sub(numTokens);
219     balances[ceoAddress] = balances[ceoAddress].sub(numTokens);
220     totalRecycledTokens_ = totalRecycledTokens_.add(numTokens);
221     RecycleTokens(numTokens);
222   }
223 
224 
225   uint256 public firstBonusStep = 1 ether;
226   uint256 public secondBonusStep = 5 ether;
227   uint256 public thirdBonusStep = 10 ether;
228 
229   function setBonusSteps(uint256 step_1, uint256 step_2, uint256 step_3) public onlyCEO() inTGE() {
230     firstBonusStep = step_1;
231     secondBonusStep = step_2;
232     thirdBonusStep = step_3;
233   }
234 
235 
236 
237   function purchase() public payable whenNotPaused() inTGE() {
238     /// when in TGE - buy tokens (from CEO account) for ETH
239 
240     uint256 amount = msg.value.div(priceOfToken);
241     require(amount > 0);
242         
243     if (tgeUserMap[ msg.sender] == false) { // In Solidity, mapping will return the default value for each key type
244       tgeUserMap[ msg.sender] = true;
245       tgeUserList.push( msg.sender);
246     }
247 
248     uint bonusFactor;
249     if (msg.value < firstBonusStep) {
250       bonusFactor = 100; // no bonus  
251     } else if (msg.value < secondBonusStep) {
252       bonusFactor = 100 + bonusFactor_1;
253     } else if (msg.value < thirdBonusStep) {
254       bonusFactor = 100 + bonusFactor_2;
255     } else {
256       bonusFactor = 100 + bonusFactor_3;
257     }
258     
259     amount = amount.mul(bonusFactor).div(100);
260     amount = amount.mul(1000000000000000000);
261     
262      /// mint requested amount of tokens
263     
264     doMint(msg.sender, amount);
265 
266     /// Transfer tokens from ceo to msg.sender
267     // require(amount <= balances[ceoAddress]); 
268     // balances[ceoAddress] = balances[ceoAddress].sub(amount);
269     // balances[msg.sender] = balances[msg.sender].add(amount);
270     // Transfer(ceoAddress, msg.sender, amount);
271   }
272 
273 
274  /// mint function - either by CEO or from site
275  function mintTokens(address buyerAddress, uint256 amount) public whenNotPaused() returns (bool) {  
276     require(msg.sender == marketplaceAddress || msg.sender == ceoAddress); 
277     return doMint(buyerAddress, amount);
278   }
279 
280  function doMint(address buyerAddress, uint256 amount) private whenNotPaused() returns (bool) {
281     require( totalSupply_.add(amount) <= MaxNumTokens);
282     totalSupply_ = totalSupply_.add(amount);
283     balances[buyerAddress] = balances[buyerAddress].add(amount);
284     Mint(buyerAddress, amount);
285     return true;
286   }
287 
288   
289 
290   function getNumTGEUsers() public view returns (uint256) {
291       return tgeUserList.length;
292   }
293 
294   function getTGEUser( uint32 ind) public view returns (address) {
295       return tgeUserList[ind];
296   }
297 
298 
299   function payout() public onlyCEO {
300       ceoAddress.transfer(this.balance);
301   }
302 
303   function payoutPartial(uint256 amount) public onlyCEO {
304       require(amount <= this.balance);
305       ceoAddress.transfer(amount);  
306   }
307 
308   function setTGEMode(bool newMode) public onlyCEO {
309       tgeMode = newMode;
310   }
311 
312   function setCEO(address newCEO) public onlyCEO {
313       require(newCEO != address(0));
314       uint256 ceoTokens = balances[ceoAddress];
315       balances[ceoAddress] = 0;
316       balances[newCEO] = balances[newCEO].add(ceoTokens);
317       ceoAddress = newCEO; 
318   }
319 
320   function setMarketplaceAddress(address newMarketplace) public onlyCEO {
321     marketplaceAddress = newMarketplace;
322   }
323 
324 
325   /**
326    * @dev Increase the amount of tokens that an owner allowed to a spender.
327    *
328    * approve should be called when allowed[_spender] == 0. To increment
329    * allowed value is better to use this function to avoid 2 calls (and wait until
330    * the first transaction is mined)
331    * From MonolithDAO Token.sol
332    * @param _spender The address which will spend the funds.
333    * @param _addedValue The amount of tokens to increase the allowance by.
334    */
335   function increaseApproval(address _spender, uint _addedValue) whenNotPaused() public returns (bool) {
336     allowed[msg.sender][_spender] = (
337       allowed[msg.sender][_spender].add(_addedValue));
338     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
339     return true;
340   }
341   
342 
343   /**
344    * @dev Decrease the amount of tokens that an owner allowed to a spender.
345    *
346    * approve should be called when allowed[_spender] == 0. To decrement
347    * allowed value is better to use this function to avoid 2 calls (and wait until
348    * the first transaction is mined)
349    * From MonolithDAO Token.sol
350    * @param _spender The address which will spend the funds.
351    * @param _subtractedValue The amount of tokens to decrease the allowance by.
352    */
353   function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused() public returns (bool) {
354     uint oldValue = allowed[msg.sender][_spender];
355     if (_subtractedValue > oldValue) {
356       allowed[msg.sender][_spender] = 0;
357     } else {
358       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
359     }
360     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364 }
365 
366 library SafeMath {
367 
368     /**
369     * @dev Multiplies two numbers, throws on overflow.
370     */
371     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
372       if (a == 0) {
373         return 0;
374       }
375       uint256 c = a * b;
376       assert(c / a == b);
377       return c;
378     }
379 
380     /**
381     * @dev Integer division of two numbers, truncating the quotient.
382     */
383     function div(uint256 a, uint256 b) internal pure returns (uint256) {
384       // assert(b > 0); // Solidity automatically throws when dividing by 0
385       uint256 c = a / b;
386       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
387       return c;
388     }
389 
390     /**
391     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
392     */
393     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
394       assert(b <= a);
395       return a - b;
396     }
397 
398     /**
399     * @dev Adds two numbers, throws on overflow.
400     */
401     function add(uint256 a, uint256 b) internal pure returns (uint256) {
402       uint256 c = a + b;
403       assert(c >= a);
404       return c;
405     }
406 }