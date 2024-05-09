1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 pragma solidity ^0.4.11;
35 
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control 
40  * functions, this simplifies the implementation of "user permissions". 
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   /** 
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner. 
57    */
58   modifier onlyOwner() {
59     if (msg.sender != owner) {
60       throw;
61     }
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to. 
69    */
70   function transferOwnership(address newOwner) onlyOwner {
71     if (newOwner != address(0)) {
72       owner = newOwner;
73     }
74   }
75 
76 }
77 
78 pragma solidity ^0.4.11;
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) constant returns (uint256);
89   function transfer(address to, uint256 value);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 pragma solidity ^0.4.11;
94 
95 
96 
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) constant returns (uint256);
104   function transferFrom(address from, address to, uint256 value);
105   function approve(address spender, uint256 value);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 pragma solidity ^0.4.11;
110 
111 
112 
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances. 
117  */
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) {
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of. 
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) constant returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 pragma solidity ^0.4.11;
146 
147 
148 
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is ERC20, BasicToken {
158 
159   mapping (address => mapping (address => uint256)) allowed;
160 
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param _from address The address which you want to send tokens from
165    * @param _to address The address which you want to transfer to
166    * @param _value uint256 the amout of tokens to be transfered
167    */
168   function transferFrom(address _from, address _to, uint256 _value) {
169     var _allowance = allowed[_from][msg.sender];
170 
171     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
172     // if (_value > _allowance) throw;
173 
174     balances[_to] = balances[_to].add(_value);
175     balances[_from] = balances[_from].sub(_value);
176     allowed[_from][msg.sender] = _allowance.sub(_value);
177     Transfer(_from, _to, _value);
178   }
179 
180   /**
181    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) {
186 
187     // To change the approve amount you first have to reduce the addresses`
188     //  allowance to zero by calling `approve(_spender, 0)` if it is not
189     //  already 0 to mitigate the race condition described here:
190     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
192 
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifing the amount of tokens still avaible for the spender.
202    */
203   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
204     return allowed[_owner][_spender];
205   }
206 
207 }
208 
209 pragma solidity ^0.4.11;
210 
211 
212 
213 contract ACFToken is StandardToken {
214 
215     string public name = "ArtCoinFund";
216     string public symbol = "ACF";
217     uint256 public decimals = 18;
218     uint256 public INITIAL_SUPPLY = 750000 * 10**18;
219 
220     function ACFToken() {
221         totalSupply = INITIAL_SUPPLY;
222         balances[msg.sender] = INITIAL_SUPPLY;
223     }
224 
225 }
226 
227 pragma solidity ^0.4.11;
228 
229 
230 
231 contract ACFPreSale is Ownable{
232 
233     uint public startTime = 1509494400;   // unix ts in which the sale starts.
234     uint public endTime = 1510704000;     // unix ts in which the sale end.
235 
236     address public ACFWallet;           // The address to hold the funds donated
237 
238     uint public totalCollected = 0;     // In wei
239     bool public saleStopped = false;    // Has ACF  stopped the sale?
240     bool public saleFinalized = false;  // Has ACF  finalized the sale?
241 
242     ACFToken public token;              // The token
243 
244 
245     uint constant public minInvestment = 0.1 ether;    // Minimum investment  0,1 ETH
246     uint public minFundingGoal = 150 ether;          // Minimum funding goal for sale success
247 
248     /** Addresses that are allowed to invest even before ICO opens. For testing, for ICO partners, etc. */
249     mapping (address => bool) public whitelist;
250 
251     /** How much they have invested */
252     mapping(address => uint) public balances;
253 
254     event NewBuyer(address indexed holder, uint256 ACFAmount, uint256 amount);
255     // Address early participation whitelist status changed
256     event Whitelisted(address addr, bool status);
257     // Investor has been refunded because the ico did not reach the min funding goal
258     event Refunded(address investor, uint value);
259 
260     function ACFPreSale (
261     address _token,
262     address _ACFWallet
263     )
264     {
265         token = ACFToken(_token);
266         ACFWallet = _ACFWallet;
267         // add wallet as whitelisted
268         setWhitelistStatus(ACFWallet, true);
269         transferOwnership(ACFWallet);
270     }
271 
272     // change whitelist status for a specific address
273     function setWhitelistStatus(address addr, bool status)
274     onlyOwner {
275         whitelist[addr] = status;
276         Whitelisted(addr, status);
277     }
278 
279     // Get the rate for a ACF token 1 ACF = 0.05 ETH -> 20 ACF = 1 ETH
280     function getRate() constant public returns (uint256) {
281         return 20;
282     }
283 
284     /**
285         * Get the amount of unsold tokens allocated to this contract;
286     */
287     function getTokensLeft() public constant returns (uint) {
288         return token.balanceOf(this);
289     }
290 
291     function () public payable {
292         doPayment(msg.sender);
293     }
294 
295     function doPayment(address _owner)
296     only_during_sale_period_or_whitelisted(_owner)
297     only_sale_not_stopped
298     non_zero_address(_owner)
299     minimum_value(minInvestment)
300     internal {
301 
302         uint256 tokensLeft = getTokensLeft();
303 
304         if(tokensLeft <= 0){
305             // nothing to sell
306             throw;
307         }
308         // Calculate how many tokens at current price
309         uint256 tokenAmount = SafeMath.mul(msg.value, getRate());
310         // do not allow selling more than what we have
311         if(tokenAmount > tokensLeft) {
312             // buy all
313             tokenAmount = tokensLeft;
314 
315             // calculate change
316             uint256 change = SafeMath.sub(msg.value, SafeMath.div(tokenAmount, getRate()));
317             if(!_owner.send(change)) throw;
318 
319         }
320         // transfer token (it will throw error if transaction is not valid)
321         token.transfer(_owner, tokenAmount);
322         // record investment
323         balances[_owner] = SafeMath.add(balances[_owner], msg.value);
324         // record total selling
325         totalCollected = SafeMath.add(totalCollected, msg.value);
326 
327         NewBuyer(_owner, tokenAmount, msg.value);
328     }
329 
330     //  Function to stop sale for an emergency.
331     //  Only ACF can do it after it has been activated.
332     function emergencyStopSale()
333     only_sale_not_stopped
334     onlyOwner
335     public {
336         saleStopped = true;
337     }
338 
339     //  Function to restart stopped sale.
340     //  Only ACF  can do it after it has been disabled and sale is ongoing.
341     function restartSale()
342     only_during_sale_period
343     only_sale_stopped
344     onlyOwner
345     public {
346         saleStopped = false;
347     }
348 
349 
350     //  Moves funds in sale contract to ACFWallet.
351     //   Moves funds in sale contract to ACFWallet.
352     function moveFunds()
353     onlyOwner
354     public {
355         // move funds
356         if (!ACFWallet.send(this.balance)) throw;
357     }
358 
359 
360     function finalizeSale()
361     only_after_sale
362     onlyOwner
363     public {
364         doFinalizeSale();
365     }
366 
367     function doFinalizeSale()
368     internal {
369         if (totalCollected >= minFundingGoal){
370             // move all remaining eth in the sale contract to ACFWallet
371             if (!ACFWallet.send(this.balance)) throw;
372         }
373         // transfer remaining tokens to ACFWallet
374         token.transfer(ACFWallet, getTokensLeft());
375 
376         saleFinalized = true;
377         saleStopped = true;
378     }
379 
380     /**
381         Refund investment, token will remain to the investor
382     **/
383     function refund()
384     only_sale_refundable {
385         address investor = msg.sender;
386         if(balances[investor] == 0) throw; // nothing to refund
387         uint amount = balances[investor];
388         // remove balance
389         delete balances[investor];
390         // send back eth
391         if(!investor.send(amount)) throw;
392 
393         Refunded(investor, amount);
394     }
395 
396     function getNow() internal constant returns (uint) {
397         return now;
398     }
399 
400     modifier only(address x) {
401         if (msg.sender != x) throw;
402         _;
403     }
404 
405     modifier only_during_sale_period {
406         if (getNow() < startTime) throw;
407         if (getNow() >= endTime) throw;
408         _;
409     }
410 
411     // valid only during sale or before sale if the sender is whitelisted
412     modifier only_during_sale_period_or_whitelisted(address x) {
413         if (getNow() < startTime && !whitelist[x]) throw;
414         if (getNow() >= endTime) throw;
415         _;
416     }
417 
418     modifier only_after_sale {
419         if (getNow() < endTime) throw;
420         _;
421     }
422 
423     modifier only_sale_stopped {
424         if (!saleStopped) throw;
425         _;
426     }
427 
428     modifier only_sale_not_stopped {
429         if (saleStopped) throw;
430         _;
431     }
432 
433     modifier non_zero_address(address x) {
434         if (x == 0) throw;
435         _;
436     }
437 
438     modifier minimum_value(uint256 x) {
439         if (msg.value < x) throw;
440         _;
441     }
442 
443     modifier only_sale_refundable {
444         if (getNow() < endTime) throw; // sale must have ended
445         if (totalCollected >= minFundingGoal) throw; // sale must be under min funding goal
446         _;
447     }
448 
449 }