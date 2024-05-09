1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal constant returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   uint256 public totalSupply;
79   function balanceOf(address who) constant returns (uint256);
80   function transfer(address to, uint256 value) returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) returns (bool) {
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) constant returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) constant returns (uint256);
122   function transferFrom(address from, address to, uint256 value) returns (bool);
123   function approve(address spender, uint256 value) returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 contract StandardToken is ERC20, BasicToken {
128 
129    mapping (address => mapping (address => uint256)) allowed;
130 
131 
132    /**
133     * @dev Transfer tokens from one address to another
134     * @param _from address The address which you want to send tokens from
135     * @param _to address The address which you want to transfer to
136     * @param _value uint256 the amout of tokens to be transfered
137     */
138    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
139      var _allowance = allowed[_from][msg.sender];
140 
141      // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
142      // require (_value <= _allowance);
143 
144      balances[_to] = balances[_to].add(_value);
145      balances[_from] = balances[_from].sub(_value);
146      allowed[_from][msg.sender] = _allowance.sub(_value);
147      Transfer(_from, _to, _value);
148      return true;
149    }
150 
151    /**
152     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
153     * @param _spender The address which will spend the funds.
154     * @param _value The amount of tokens to be spent.
155     */
156    function approve(address _spender, uint256 _value) returns (bool) {
157 
158      // To change the approve amount you first have to reduce the addresses`
159      //  allowance to zero by calling `approve(_spender, 0)` if it is not
160      //  already 0 to mitigate the race condition described here:
161      //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      require((_value == 0) || (allowed[msg.sender][_spender] == 0));
163 
164      allowed[msg.sender][_spender] = _value;
165      Approval(msg.sender, _spender, _value);
166      return true;
167    }
168 
169    /**
170     * @dev Function to check the amount of tokens that an owner allowed to a spender.
171     * @param _owner address The address which owns the funds.
172     * @param _spender address The address which will spend the funds.
173     * @return A uint256 specifing the amount of tokens still avaible for the spender.
174     */
175    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
176      return allowed[_owner][_spender];
177    }
178 
179  }
180 
181 contract MintableToken is StandardToken, Ownable {
182   event MintFinished();
183 
184   bool public mintingFinished = false;
185 
186 
187   modifier canMint() {
188     require(!mintingFinished);
189     _;
190   }
191 
192   /**
193    * @dev Function to mint tokens
194    * @param _to The address that will recieve the minted tokens.
195    * @param _amount The amount of tokens to mint.
196    * @return A boolean that indicates if the operation was successful.
197    */
198   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
199     totalSupply = totalSupply.add(_amount);
200     balances[_to] = balances[_to].add(_amount);
201     Transfer(0X0, _to, _amount);
202     return true;
203   }
204 
205   /**
206    * @dev Function to stop minting new tokens.
207    * @return True if the operation was successful.
208    */
209   function finishMinting() onlyOwner returns (bool) {
210     mintingFinished = true;
211     MintFinished();
212     return true;
213   }
214 }
215 
216 contract WisePlat is MintableToken {
217   string public name = "WisePlat Token";
218   string public symbol = "WISE";
219   uint256 public decimals = 18;
220   address public bountyWallet = 0x0;
221 
222   bool public transferStatus = false;
223 
224   /**
225    * @dev modifier that throws if trading has not started yet
226    */
227   modifier hasStartedTransfer() {
228     require(transferStatus || msg.sender == bountyWallet);
229     _;
230   }
231 
232   /**
233    * @dev Allows the owner to enable transfer.
234    */
235   function startTransfer() public onlyOwner {
236     transferStatus = true;
237   }
238   /**
239    * @dev Allows the owner to stop transfer.
240    */
241   function stopTransfer() public onlyOwner {
242     transferStatus = false;
243   }
244 
245   function setbountyWallet(address _bountyWallet) public onlyOwner {
246     bountyWallet = _bountyWallet;
247   }
248 
249   /**
250    * @dev Allows anyone to transfer the WISE tokens once transfer has started
251    * @param _to the recipient address of the tokens.
252    * @param _value number of tokens to be transfered.
253    */
254   function transfer(address _to, uint _value) hasStartedTransfer returns (bool){
255     return super.transfer(_to, _value);
256   }
257 
258   /**
259    * @dev Allows anyone to transfer the WISE tokens once transfer has started
260    * @param _from address The address which you want to send tokens from
261    * @param _to address The address which you want to transfer to
262    * @param _value uint the amout of tokens to be transfered
263    */
264   function transferFrom(address _from, address _to, uint _value) hasStartedTransfer returns (bool){
265     return super.transferFrom(_from, _to, _value);
266   }
267 }
268 
269 contract WisePlatSale is Ownable {
270   using SafeMath for uint256;
271 
272   // The token being offered
273   WisePlat public token;
274 
275   // start and end block where investments are allowed (both inclusive)
276   uint256 public constant startTimestamp	= 1509274800;		//Pre-ICO start						2017/10/29 @ 11:00:00 (UTC)
277   uint256 public constant middleTimestamp	= 1511607601;		//Pre-ICO finish and ICO start		2017/11/25 @ 11:00:01 (UTC)
278   uint256 public constant endTimestamp		= 1514764799;		//ICO finish						2017/12/31 @ 23:59:59 (UTC)
279 
280   // address where funds are collected
281   address public constant devWallet 		= 0x00d6F1eA4238e8d9f1C33B7500CB89EF3e91190c;
282   address public constant proWallet 		= 0x6501BDA688e8AC6C9cD96dc2DFBd6bDF3e886C05;
283   address public constant bountyWallet 		= 0x354FFa86F138883b880C282000B5005E867E8eE4;
284   address public constant remainderWallet	= 0x656C64D5C8BADe2a56A564B12706eE89bbe486EA;
285   address public constant fundsWallet		= 0x06D49e8aA90b1413A641D69c6B8AC154f5c9FE92;
286  
287   // how many token units a buyer gets per wei
288   uint256 public rate						= 10;
289   uint256 public constant ratePreICO		= 20;	//on Pre-ICO it is 20 WISE for 1 ETH
290   uint256 public constant rateICO			= 15;	//on ICO it is 15 WISE for 1 ETH
291   
292   // amount of raised money in wei
293   uint256 public weiRaised;
294 
295   // minimum contribution to participate in token offer
296   uint256 public constant minContribution 		= 0.1 ether;
297   uint256 public constant minContribution_mBTC 	= 10;
298   uint256 public rateBTCxETH 					= 17;
299 
300   // WISE tokens
301   uint256 public constant tokensTotal		=	 10000000 * 1e18;		//WISE Total tokens				10,000,000.00
302   uint256 public constant tokensCrowdsale	=	  7000000 * 1e18;		//WISE tokens for Crowdsale		 7,000,000.00
303   uint256 public constant tokensDevelopers  =	  1900000 * 1e18;		//WISE tokens for Developers	 1,900,000.00
304   uint256 public constant tokensPromotion	=	  1000000 * 1e18;		//WISE tokens for Promotion		 1,000,000.00
305   uint256 public constant tokensBounty      = 	   100000 * 1e18;		//WISE tokens for Bounty		   100,000.00
306   uint256 public tokensRemainder;  
307   
308   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
309   event TokenClaim4BTC(address indexed purchaser_evt, address indexed beneficiary_evt, uint256 value_evt, uint256 amount_evt, uint256 btc_evt, uint256 rateBTCxETH_evt);
310   event SaleClosed();
311 
312   function WisePlatSale() {
313     token = new WisePlat();
314 	token.mint(devWallet, tokensDevelopers);
315 	token.mint(proWallet, tokensPromotion);
316 	token.mint(bountyWallet, tokensBounty);
317 	token.setbountyWallet(bountyWallet);		//allow transfer for bountyWallet
318     require(startTimestamp >= now);
319     require(endTimestamp >= startTimestamp);
320   }
321 
322   // check if valid purchase
323   modifier validPurchase {
324     require(now >= startTimestamp);
325     require(now <= endTimestamp);
326     require(msg.value >= minContribution);
327     require(tokensTotal > token.totalSupply());
328     _;
329   }
330   // check if valid claim for BTC
331   modifier validPurchase4BTC {
332     require(now >= startTimestamp);
333     require(now <= endTimestamp);
334     require(tokensTotal > token.totalSupply());
335     _;
336   }
337 
338   // @return true if crowdsale event has ended
339   function hasEnded() public constant returns (bool) {
340     bool timeLimitReached = now > endTimestamp;
341     bool allOffered = tokensTotal <= token.totalSupply();
342     return timeLimitReached || allOffered;
343   }
344 
345   // low level token purchase function
346   function buyTokens(address beneficiary) payable validPurchase {
347     require(beneficiary != 0x0);
348 
349     uint256 weiAmount = msg.value;
350 
351     // calculate token amount to be created
352 	if (now < middleTimestamp) {rate = ratePreICO;} else {rate = rateICO;}
353     uint256 tokens = weiAmount.mul(rate);
354     
355 	require(token.totalSupply().add(tokens) <= tokensTotal);
356 	
357     // update state
358     weiRaised = weiRaised.add(weiAmount);
359     
360     token.mint(beneficiary, tokens);
361     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
362     fundsWallet.transfer(msg.value);	//transfer funds to fundsWallet
363   }
364   
365   //claim tokens buyed for mBTC
366   function claimTokens4mBTC(address beneficiary, uint256 mBTC) validPurchase4BTC public onlyOwner {
367     require(beneficiary != 0x0);
368 	require(mBTC >= minContribution_mBTC);
369 
370 	//uint256 _BTC = mBTC.div(1000);			//convert mBTC	to BTC
371 	//uint256 _ETH = _BTC.mul(rateBTCxETH);		//convert BTC	to ETH
372     //uint256 weiAmount = _ETH * 1e18;			//convert ETH	to wei
373 	uint256 weiAmount = mBTC.mul(rateBTCxETH) * 1e15;	//all convert in one line mBTC->BTC->ETH->wei
374 
375     // calculate token amount to be created
376 	if (now < middleTimestamp) {rate = ratePreICO;} else {rate = rateICO;}
377     uint256 tokens = weiAmount.mul(rate);
378     
379 	require(token.totalSupply().add(tokens) <= tokensTotal);
380 	
381     // update state
382     weiRaised = weiRaised.add(weiAmount);
383     
384     token.mint(beneficiary, tokens);
385     TokenClaim4BTC(msg.sender, beneficiary, weiAmount, tokens, mBTC, rateBTCxETH);
386     //fundsWallet.transfer(msg.value);	//transfer funds to fundsWallet	- already should be transfered to BTC wallet
387   }
388 
389   // to enable transfer
390   function startTransfers() public onlyOwner {
391 	token.startTransfer();
392   }
393   
394   // to stop transfer
395   function stopTransfers() public onlyOwner {
396 	token.stopTransfer();
397   }
398   
399   // to correct exchange rate ETH for BTC
400   function correctExchangeRateBTCxETH(uint256 _rateBTCxETH) public onlyOwner {
401 	require(_rateBTCxETH != 0);
402 	rateBTCxETH = _rateBTCxETH;
403   }
404   
405   // finish mining coins and transfer ownership of WISE token to owner
406   function finishMinting() public onlyOwner {
407     require(hasEnded());
408     uint issuedTokenSupply = token.totalSupply();			
409 	tokensRemainder = tokensTotal.sub(issuedTokenSupply);
410 	if (tokensRemainder > 0) {token.mint(remainderWallet, tokensRemainder);}
411     token.finishMinting();
412     token.transferOwnership(owner);
413     SaleClosed();
414   }
415 
416   // fallback function can be used to buy tokens
417   function () payable {
418     buyTokens(msg.sender);
419   }
420   
421   /**
422   * @dev Reclaim all ERC20Basic compatible tokens
423   * @param tokenAddr address The address of the token contract
424   */
425   function reclaimToken(address tokenAddr) external onlyOwner {
426 	require(!isTokenOfferedToken(tokenAddr));
427     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
428     uint256 balance = tokenInst.balanceOf(this);
429     tokenInst.transfer(msg.sender, balance);
430   }
431   function isTokenOfferedToken(address tokenAddr) returns(bool) {
432         return token == tokenAddr;
433   }
434  
435 }