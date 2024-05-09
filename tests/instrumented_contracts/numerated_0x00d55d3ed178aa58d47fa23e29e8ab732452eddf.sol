1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
59     require(_endTime >= _startTime);
60     require(_rate > 0);
61     require(_wallet != 0x0);
62 
63     token = createTokenContract();
64     startTime = _startTime;
65     endTime = _endTime;
66     rate = _rate;
67     wallet = _wallet;
68   }
69 
70   // creates the token to be sold.
71   // override this method to have crowdsale of a specific mintable token.
72   function createTokenContract() internal returns (MintableToken) {
73     return new MintableToken();
74   }
75 
76 
77   // fallback function can be used to buy tokens
78   function () payable {
79     buyTokens(msg.sender);
80   }
81 
82   // low level token purchase function
83   function buyTokens(address beneficiary) public payable {
84     require(beneficiary != 0x0);
85     require(validPurchase());
86 
87     uint256 weiAmount = msg.value;
88     uint256 kweiAmount = weiAmount/1000;
89     
90 
91     // calculate token amount to be created
92     uint256 tokens = kweiAmount.mul(rate);
93 
94     // update state
95     weiRaised = weiRaised.add(weiAmount);
96 
97     token.mint(beneficiary, tokens);
98     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
99 
100     forwardFunds();
101   }
102 
103   // send ether to the fund collection wallet
104   // override to create custom fund forwarding mechanisms
105   function forwardFunds() internal {
106     wallet.transfer(msg.value);
107   }
108 
109   // @return true if the transaction can buy tokens
110   function validPurchase() internal constant returns (bool) {
111     bool withinPeriod = now >= startTime && now <= endTime;
112     bool nonZeroPurchase = msg.value != 0;
113     return withinPeriod && nonZeroPurchase;
114   }
115 
116   // @return true if crowdsale event has ended
117   function hasEnded() public constant returns (bool) {
118     return now > endTime;
119   }
120 
121 
122 }
123 
124 contract Ownable {
125   address public owner;
126 
127 
128   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   function Ownable() {
136     owner = msg.sender;
137   }
138 
139 
140   /**
141    * @dev Throws if called by any account other than the owner.
142    */
143   modifier onlyOwner() {
144     require(msg.sender == owner);
145     _;
146   }
147 
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address newOwner) onlyOwner public {
154     require(newOwner != address(0));
155     OwnershipTransferred(owner, newOwner);
156     owner = newOwner;
157   }
158 
159 }
160 
161 contract ERC20Basic {
162   uint256 public totalSupply;
163   function balanceOf(address who) public constant returns (uint256);
164   function transfer(address to, uint256 value) public returns (bool);
165   event Transfer(address indexed from, address indexed to, uint256 value);
166 }
167 
168 contract BasicToken is ERC20Basic {
169   using SafeMath for uint256;
170 
171   mapping(address => uint256) balances;
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180 
181     // SafeMath.sub will throw if there is not enough balance.
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public constant returns (uint256 balance) {
194     return balances[_owner];
195   }
196 
197 }
198 
199 contract ERC20 is ERC20Basic {
200   function allowance(address owner, address spender) public constant returns (uint256);
201   function transferFrom(address from, address to, uint256 value) public returns (bool);
202   function approve(address spender, uint256 value) public returns (bool);
203   event Approval(address indexed owner, address indexed spender, uint256 value);
204 }
205 
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
218     require(_to != address(0));
219 
220     uint256 _allowance = allowed[_from][msg.sender];
221 
222     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
223     // require (_value <= _allowance);
224 
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = _allowance.sub(_value);
228     Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    *
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param _spender The address which will spend the funds.
240    * @param _value The amount of tokens to be spent.
241    */
242   function approve(address _spender, uint256 _value) public returns (bool) {
243     allowed[msg.sender][_spender] = _value;
244     Approval(msg.sender, _spender, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
255     return allowed[_owner][_spender];
256   }
257 
258   /**
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    */
264   function increaseApproval (address _spender, uint _addedValue)
265     returns (bool success) {
266     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
267     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271   function decreaseApproval (address _spender, uint _subtractedValue)
272     returns (bool success) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 contract BurnableToken is StandardToken {
286 
287     event Burn(address indexed burner, uint256 value);
288 
289     /**
290      * @dev Burns a specific amount of tokens.
291      * @param _value The amount of token to be burned.
292      */
293     function burn(uint256 _value) public {
294         require(_value > 0);
295 
296         address burner = msg.sender;
297         balances[burner] = balances[burner].sub(_value);
298         totalSupply = totalSupply.sub(_value);
299         Burn(burner, _value);
300     }
301 }
302 
303 contract MintableToken is StandardToken, Ownable {
304   event Mint(address indexed to, uint256 amount);
305   event MintFinished();
306 
307   bool public mintingFinished = false;
308 
309 
310   modifier canMint() {
311     require(!mintingFinished);
312     _;
313   }
314 
315   /**
316    * @dev Function to mint tokens
317    * @param _to The address that will receive the minted tokens.
318    * @param _amount The amount of tokens to mint.
319    * @return A boolean that indicates if the operation was successful.
320    */
321   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
322     totalSupply = totalSupply.add(_amount);
323     balances[_to] = balances[_to].add(_amount);
324     Mint(_to, _amount);
325     Transfer(0x0, _to, _amount);
326     return true;
327   }
328 
329   /**
330    * @dev Function to stop minting new tokens.
331    * @return True if the operation was successful.
332    */
333   function finishMinting() onlyOwner public returns (bool) {
334     mintingFinished = true;
335     MintFinished();
336     return true;
337   }
338 }
339 
340 contract ACNN is MintableToken, BurnableToken {
341     string public name = "ACNN";
342     string public symbol = "ACNN";
343     uint256 public decimals = 18;
344     uint256 public maxSupply = 552018 * (10 ** decimals);
345 
346     function ACNN() public {
347 
348     }
349 
350     function transfer(address _to, uint _value) public returns (bool) {
351         return super.transfer(_to, _value);
352     }
353 
354     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
355         return super.transferFrom(_from, _to, _value);
356     }
357 }
358 
359 contract ACNNIco is Ownable, Crowdsale {
360     using SafeMath for uint256;
361 
362     mapping (address => uint256) public boughtTokens;
363 
364     mapping (address => uint256) public claimedAirdropTokens;
365 
366     // max tokens cap
367     uint256 public tokenCap = 500000 * (10 ** 18);
368 
369     // amount of sold tokens
370     uint256 public soldTokens;
371 
372     function ACNNIco(
373         uint256 _startTime,
374         uint256 _endTime,
375         uint256 _rate,
376         address _wallet,
377         address _token
378     ) public
379     Crowdsale (_startTime, _endTime, _rate, _wallet)
380     {
381         require(_token != 0x0);
382         token = ACNN(_token);
383     }
384 
385     /**
386      * @dev Set the ico token contract
387      */
388     function createTokenContract() internal returns (MintableToken) {
389         return ACNN(0x0);
390     }
391 
392     // low level token purchase function
393     function buyTokens(address beneficiary) public payable {
394         require(beneficiary != 0x0);
395         require(validPurchase());
396 
397         // get wei amount
398         uint256 weiAmount = msg.value;
399         uint256 kweiAmount = weiAmount/1000;
400 
401         // calculate token amount to be transferred
402         uint256 tokens = kweiAmount.mul(rate);
403 
404         // calculate new total sold
405         uint256 newTotalSold = soldTokens.add(tokens);
406 
407         // check if we are over the max token cap
408         require(newTotalSold <= tokenCap);
409 
410         // update states
411         weiRaised = weiRaised.add(weiAmount);
412         soldTokens = newTotalSold;
413 
414         // mint tokens to beneficiary
415         token.mint(beneficiary, tokens);
416         TokenPurchase(
417             msg.sender,
418             beneficiary,
419             weiAmount,
420             tokens
421         );
422 
423         forwardFunds();
424     }
425 
426     function updateEndDate(uint256 _endTime) public onlyOwner {
427         require(_endTime > now);
428         require(_endTime > startTime);
429 
430         endTime = _endTime;
431     }
432 
433     function closeTokenSale() public onlyOwner {
434         require(hasEnded());
435 
436         // transfer token ownership to ico owner
437         token.transferOwnership(owner);
438     }
439 
440     function airdrop(address[] users, uint256[] amounts) public onlyOwner {
441         require(users.length > 0);
442         require(amounts.length > 0);
443         require(users.length == amounts.length);
444 
445         uint256 oldRate = 1;
446         uint256 newRate = 2;
447 
448         uint len = users.length;
449         for (uint i = 0; i < len; i++) {
450             address to = users[i];
451             uint256 value = amounts[i];
452 
453             uint256 oldTokens = value.mul(oldRate);
454             uint256 newTokens = value.mul(newRate);
455 
456             uint256 tokensToAirdrop = newTokens.sub(oldTokens);
457 
458             if (claimedAirdropTokens[to] == 0) {
459                 claimedAirdropTokens[to] = tokensToAirdrop;
460                 token.mint(to, tokensToAirdrop);
461             }
462         }
463     }
464 
465     // overriding Crowdsale#hasEnded to add tokenCap logic
466     // @return true if crowdsale event has ended or cap is reached
467     function hasEnded() public constant returns (bool) {
468         bool capReached = soldTokens >= tokenCap;
469         return super.hasEnded() || capReached;
470     }
471 
472     // @return true if crowdsale event has started
473     function hasStarted() public constant returns (bool) {
474         return now >= startTime && now < endTime;
475     }
476 }