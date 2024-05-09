1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   function balanceOf(address who) constant returns (uint256);
51   function transfer(address to, uint256 value) returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) constant returns (uint256);
62   function transferFrom(address from, address to, uint256 value) returns (bool);
63   function approve(address spender, uint256 value) returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
73     uint256 c = a * b;
74     assert(a == 0 || c / a == b);
75     return c;
76   }
77 
78   function div(uint256 a, uint256 b) internal constant returns (uint256) {
79     // assert(b > 0); // Solidity automatically throws when dividing by 0
80     uint256 c = a / b;
81     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82     return c;
83   }
84 
85   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   function add(uint256 a, uint256 b) internal constant returns (uint256) {
91     uint256 c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances. 
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) returns (bool) {
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of. 
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) constant returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amout of tokens to be transfered
148    */
149   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
150     var _allowance = allowed[_from][msg.sender];
151 
152     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153     // require (_value <= _allowance);
154 
155     balances[_to] = balances[_to].add(_value);
156     balances[_from] = balances[_from].sub(_value);
157     allowed[_from][msg.sender] = _allowance.sub(_value);
158     Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) returns (bool) {
168 
169     // To change the approve amount you first have to reduce the addresses`
170     //  allowance to zero by calling `approve(_spender, 0)` if it is not
171     //  already 0 to mitigate the race condition described here:
172     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
174 
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifing the amount of tokens still avaible for the spender.
185    */
186   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
187     return allowed[_owner][_spender];
188   }
189 
190 }
191 
192 
193 
194 contract CRCToken is StandardToken,Ownable{
195 	//the base info of the token 
196 	string public name;
197 	string public symbol;
198 	string public constant version = "1.0";
199 	uint256 public constant decimals = 18;
200 
201 	uint256 public constant MAX_SUPPLY = 500000000 * 10**decimals;
202 	uint256 public constant quota = MAX_SUPPLY/100;
203 
204 	//the percentage of all usages
205 	uint256 public constant allOfferingPercentage = 50;
206 	uint256 public constant teamKeepingPercentage = 15;
207 	uint256 public constant communityContributionPercentage = 35;
208 
209 	//the quota of all usages
210 	uint256 public constant allOfferingQuota = quota*allOfferingPercentage;
211 	uint256 public constant teamKeepingQuota = quota*teamKeepingPercentage;
212 	uint256 public constant communityContributionQuota = quota*communityContributionPercentage;
213 
214 	//the cap of diff offering channel
215 	//this percentage must less the the allOfferingPercentage
216 	uint256 public constant privateOfferingPercentage = 10;
217 	uint256 public constant privateOfferingCap = quota*privateOfferingPercentage;
218 
219 	//diff rate of the diff offering channel
220 	uint256 public constant publicOfferingExchangeRate = 25000;
221 	uint256 public constant privateOfferingExchangeRate = 50000;
222 
223 	//need to edit
224 	address public etherProceedsAccount;
225 	address public crcWithdrawAccount;
226 
227 	//dependency on the start day
228 	uint256 public fundingStartBlock;
229 	uint256 public fundingEndBlock;
230 	uint256 public teamKeepingLockEndBlock ;
231 
232 	uint256 public privateOfferingSupply;
233 	uint256 public allOfferingSupply;
234 	uint256 public teamWithdrawSupply;
235 	uint256 public communityContributionSupply;
236 
237 
238 
239 	// bool public isFinalized;// switched to true in operational state
240 
241 	event CreateCRC(address indexed _to, uint256 _value);
242 
243 	// uint256 public
244 
245 	function CRCToken(){
246 		name = "CRCToken";
247 		symbol ="CRC";
248 
249 		etherProceedsAccount = 0x5390f9D18A7131aC9C532C1dcD1bEAb3e8A44cbF;
250 		crcWithdrawAccount = 0xb353425bA4FE2670DaC1230da934498252E692bD;
251 
252 		fundingStartBlock=4263161;
253 		fundingEndBlock=4313561;
254 		teamKeepingLockEndBlock=5577161;
255 
256 		totalSupply = 0 ;
257 		privateOfferingSupply=0;
258 		allOfferingSupply=0;
259 		teamWithdrawSupply=0;
260 		communityContributionSupply=0;
261 	}
262 
263 
264 	modifier beforeFundingStartBlock(){
265 		assert(getCurrentBlockNum() < fundingStartBlock);
266 		_;
267 	}
268 
269 	modifier notBeforeFundingStartBlock(){
270 		assert(getCurrentBlockNum() >= fundingStartBlock);
271 		_;
272 	}
273 	modifier notAfterFundingEndBlock(){
274 		assert(getCurrentBlockNum() < fundingEndBlock);
275 		_;
276 	}
277 	modifier notBeforeTeamKeepingLockEndBlock(){
278 		assert(getCurrentBlockNum() >= teamKeepingLockEndBlock);
279 		_;
280 	}
281 
282 	modifier totalSupplyNotReached(uint256 _ethContribution,uint rate){
283 		assert(totalSupply.add(_ethContribution.mul(rate)) <= MAX_SUPPLY);
284 		_;
285 	}
286 	modifier allOfferingNotReached(uint256 _ethContribution,uint rate){
287 		assert(allOfferingSupply.add(_ethContribution.mul(rate)) <= allOfferingQuota);
288 		_;
289 	}	 
290 
291 	modifier privateOfferingCapNotReached(uint256 _ethContribution){
292 		assert(privateOfferingSupply.add(_ethContribution.mul(privateOfferingExchangeRate)) <= privateOfferingCap);
293 		_;
294 	}	 
295 	
296 
297 	modifier etherProceedsAccountOnly(){
298 		assert(msg.sender == getEtherProceedsAccount());
299 		_;
300 	}
301 	modifier crcWithdrawAccountOnly(){
302 		assert(msg.sender == getCrcWithdrawAccount());
303 		_;
304 	}
305 
306 
307 
308 
309 	function processFunding(address receiver,uint256 _value,uint256 fundingRate) internal
310 		totalSupplyNotReached(_value,fundingRate)
311 		allOfferingNotReached(_value,fundingRate)
312 
313 	{
314 		uint256 tokenAmount = _value.mul(fundingRate);
315 		totalSupply=totalSupply.add(tokenAmount);
316 		allOfferingSupply=allOfferingSupply.add(tokenAmount);
317 		balances[receiver] += tokenAmount;  // safeAdd not needed; bad semantics to use here
318 		CreateCRC(receiver, tokenAmount);	 // logs token creation
319 	}
320 
321 
322 	function () payable external{
323 		if(getCurrentBlockNum()<=fundingStartBlock){
324 			processPrivateFunding(msg.sender);
325 		}else{
326 			processEthPulicFunding(msg.sender);
327 		}
328 
329 
330 	}
331 
332 	function processEthPulicFunding(address receiver) internal
333 	 notBeforeFundingStartBlock
334 	 notAfterFundingEndBlock
335 	{
336 		processFunding(receiver,msg.value,publicOfferingExchangeRate);
337 	}
338 	
339 
340 	function processPrivateFunding(address receiver) internal
341 	 beforeFundingStartBlock
342 	 privateOfferingCapNotReached(msg.value)
343 	{
344 		uint256 tokenAmount = msg.value.mul(privateOfferingExchangeRate);
345 		privateOfferingSupply=privateOfferingSupply.add(tokenAmount);
346 		processFunding(receiver,msg.value,privateOfferingExchangeRate);
347 	}  
348 
349 	function icoPlatformWithdraw(uint256 _value) external
350 		crcWithdrawAccountOnly
351 	{
352 		processFunding(msg.sender,_value,1);
353 	}
354 
355 	function teamKeepingWithdraw(uint256 tokenAmount) external
356 	   crcWithdrawAccountOnly
357 	   notBeforeTeamKeepingLockEndBlock
358 	{
359 		assert(teamWithdrawSupply.add(tokenAmount)<=teamKeepingQuota);
360 		assert(totalSupply.add(tokenAmount)<=MAX_SUPPLY);
361 		teamWithdrawSupply=teamWithdrawSupply.add(tokenAmount);
362 		totalSupply=totalSupply.add(tokenAmount);
363 		balances[msg.sender]+=tokenAmount;
364 		CreateCRC(msg.sender, tokenAmount);
365 	}
366 
367 	function communityContributionWithdraw(uint256 tokenAmount) external
368 	    crcWithdrawAccountOnly
369 	{
370 		assert(communityContributionSupply.add(tokenAmount)<=communityContributionQuota);
371 		assert(totalSupply.add(tokenAmount)<=MAX_SUPPLY);
372 		communityContributionSupply=communityContributionSupply.add(tokenAmount);
373 		totalSupply=totalSupply.add(tokenAmount);
374 		balances[msg.sender] += tokenAmount;
375 		CreateCRC(msg.sender, tokenAmount);
376 	}
377 
378 	function etherProceeds() external
379 		etherProceedsAccountOnly
380 	{
381 		if(!msg.sender.send(this.balance)) revert();
382 	}
383 	
384 
385 
386 
387 	function getCurrentBlockNum()  internal returns (uint256){
388 		return block.number;
389 	}
390 
391 	function getEtherProceedsAccount() internal  returns (address){
392 		return etherProceedsAccount;
393 	}
394 
395 
396 	function getCrcWithdrawAccount() internal returns (address){
397 		return crcWithdrawAccount;
398 	}
399 
400 	function setName(string _name) external
401 		onlyOwner
402 	{
403 		name=_name;
404 	}
405 
406 	function setSymbol(string _symbol) external
407 		onlyOwner
408 	{
409 		symbol=_symbol;
410 	}
411 
412 
413 	function setEtherProceedsAccount(address _etherProceedsAccount) external
414 		onlyOwner
415 	{
416 		etherProceedsAccount=_etherProceedsAccount;
417 	}
418 
419 	function setCrcWithdrawAccount(address _crcWithdrawAccount) external
420 		onlyOwner
421 	{
422 		crcWithdrawAccount=_crcWithdrawAccount;
423 	}
424 
425 	function setFundingBlock(uint256 _fundingStartBlock,uint256 _fundingEndBlock,uint256 _teamKeepingLockEndBlock) external
426 		onlyOwner
427 	{
428 
429 		fundingStartBlock=_fundingStartBlock;
430 		fundingEndBlock = _fundingEndBlock;
431 		teamKeepingLockEndBlock = _teamKeepingLockEndBlock;
432 	}
433 
434 
435 }