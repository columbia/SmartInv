1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) public view returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51     using SafeMath for uint256;
52 
53     mapping(address => uint256) public balances;
54 
55     /**
56     * @dev transfer token for a specified address
57     * @param _to The address to transfer to.
58     * @param _value The amount to be transferred.
59     */
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         require(_to != address(0));
62         require(_value <= balances[msg.sender]);
63 
64         // SafeMath.sub will throw if there is not enough balance.
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     /**
72     * @dev Gets the balance of the specified address.
73     * @param _owner The address to query the the balance of.
74     * @return An uint256 representing the amount owned by the passed address.
75     */
76     function balanceOf(address _owner) public view returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) public view returns (uint256);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title SafeERC20
95  * @dev Wrappers around ERC20 operations that throw on failure.
96  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
97  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
98  */
99 library SafeERC20 {
100   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
101     assert(token.transfer(to, value));
102   }
103 
104   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
105     assert(token.transferFrom(from, to, value));
106   }
107 
108   function safeApprove(ERC20 token, address spender, uint256 value) internal {
109     assert(token.approve(spender, value));
110   }
111 }
112 
113 /**
114  * @title TokenTimelock
115  * @dev TokenTimelock is a token holder contract that will allow a
116  * beneficiary to extract the tokens after a given release time
117  */
118 contract TokenTimelock {
119   using SafeERC20 for ERC20Basic;
120 
121   // ERC20 basic token contract being held
122   ERC20Basic public token;
123 
124   // beneficiary of tokens after they are released
125   address public beneficiary;
126 
127   // timestamp when token release is enabled
128   uint64 public releaseTime;
129 
130   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
131     require(_releaseTime > uint64(block.timestamp));
132     token = _token;
133     beneficiary = _beneficiary;
134     releaseTime = _releaseTime;
135   }
136 
137   /**
138    * @notice Transfers tokens held by timelock to beneficiary.
139    */
140   function release() public {
141     require(uint64(block.timestamp) >= releaseTime);
142 
143     uint256 amount = token.balanceOf(this);
144     require(amount > 0);
145 
146     token.safeTransfer(beneficiary, amount);
147   }
148 }
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
159     mapping (address => mapping (address => uint256)) internal allowed;
160 
161 
162     /**
163      * @dev Transfer tokens from one address to another
164      * @param _from address The address which you want to send tokens from
165      * @param _to address The address which you want to transfer to
166      * @param _value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
169         require(_to != address(0));
170         require(_value <= balances[_from]);
171         require(_value <= allowed[_from][msg.sender]);
172 
173         balances[_from] = balances[_from].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176         Transfer(_from, _to, _value);
177         return true;
178     }
179 
180     /**
181      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182      *
183      * Beware that changing an allowance with this method brings the risk that someone may use both the old
184      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187      * @param _spender The address which will spend the funds.
188      * @param _value The amount of tokens to be spent.
189      */
190     function approve(address _spender, uint256 _value) public returns (bool) {
191         allowed[msg.sender][_spender] = _value;
192         Approval(msg.sender, _spender, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Function to check the amount of tokens that an owner allowed to a spender.
198      * @param _owner address The address which owns the funds.
199      * @param _spender address The address which will spend the funds.
200      * @return A uint256 specifying the amount of tokens still available for the spender.
201      */
202     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
203         return allowed[_owner][_spender];
204     }
205 
206     /**
207      * approve should be called when allowed[_spender] == 0. To increment
208      * allowed value is better to use this function to avoid 2 calls (and wait until
209      * the first transaction is mined)
210      * From MonolithDAO Token.sol
211      */
212     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
213         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
219         uint oldValue = allowed[msg.sender][_spender];
220         if (_subtractedValue > oldValue) {
221             allowed[msg.sender][_spender] = 0;
222         } else {
223             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224         }
225         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229 }
230 
231 contract Owned {
232     address public owner;
233 
234     function Owned() public {
235         owner = msg.sender;
236     }
237 
238     modifier onlyOwner {
239         require(msg.sender == owner);
240         _;
241     }
242 }
243 
244 contract IungoToken is StandardToken, Owned {
245     string public constant name = "IUNGO token";
246     string public constant symbol = "ING";
247     uint8 public constant decimals = 18;
248 
249     /// Maximum tokens to be allocated (100 million)
250     uint256 public constant HARD_CAP = 100000000 * 10**uint256(decimals);
251 
252     /// Maximum tokens to be allocated on the sale (64 million)
253     uint256 public constant TOKENS_SALE_HARD_CAP = 64000000 * 10**uint256(decimals);
254 
255     /// The owner of this address is the Iungo Founders fund
256     address public foundersFundAddress;
257 
258     /// The owner of this address is the Iungo Team Foundation fund
259     address public teamFundAddress;
260 
261     /// The owner of this address is the Reserve fund
262     address public reserveFundAddress;
263 
264     /// This address will be sent all the received ether
265     address public fundsTreasury;
266 
267     /// This is the address of the timelock contract for 
268     /// the first 1/3 of the Founders fund tokens
269     address public foundersFundTimelock1Address;
270 
271     /// This is the address of the timelock contract for 
272     /// the second 1/3 of the Founders fund tokens
273     address public foundersFundTimelock2Address;
274 
275     /// This is the address of the timelock contract for 
276     /// the third 1/3 of the Founders fund tokens
277     address public foundersFundTimelock3Address;
278 
279     /// seconds since 01.01.1970 to 06.12.2017 12:00:00 UTC
280     /// tier 1 start time
281     uint64 private constant date06Dec2017 = 1512561600;
282 
283     /// seconds since 01.01.1970 to 21.12.2017 14:00:00 UTC
284     /// tier 1 end time; tier 2 start time
285     uint64 private constant date21Dec2017 = 1513864800;
286 
287     /// seconds since 01.01.1970 to 12.01.2018 14:00:00 UTC
288     /// tier 2 end time; tier 3 start time
289     uint64 private constant date12Jan2018 = 1515765600;
290 
291     /// seconds since 01.01.1970 to 21.01.2018 14:00:00 UTC
292     /// tier 3 end time; tier 4 start time
293     uint64 private constant date21Jan2018 = 1516543200;
294 
295     /// seconds since 01.01.1970 to 31.01.2018 23:59:59 UTC
296     /// tier 4 end time; closing token sale; trading open
297     uint64 private constant date31Jan2018 = 1517443199;
298 
299     /// Base exchange rate is set to 1 ETH = 1000 ING
300     uint256 public constant BASE_RATE = 1000;
301 
302     /// no tokens can be ever issued when this is set to "true"
303     bool public tokenSaleClosed = false;
304 
305     /// Issue event index starting from 0.
306     uint256 public issueIndex = 0;
307 
308     /// Emitted for each sucuessful token purchase.
309     event Issue(uint _issueIndex, address addr, uint tokenAmount);
310 
311     /// Require that the buyers can still purchase
312     modifier inProgress {
313         require(totalSupply < TOKENS_SALE_HARD_CAP
314                 && !tokenSaleClosed
315                 && !saleDue());
316         _;
317     }
318 
319     /// Allow the closing to happen only once 
320     modifier beforeEnd {
321         require(!tokenSaleClosed);
322         _;
323     }
324 
325     /// Require that the end of the sale has passed (time is 01 Feb 2018 or later)
326     modifier tradingOpen {
327         require(saleDue());
328         _;
329     }
330 
331     /**
332      * CONSTRUCTOR
333      *
334      * @dev Initialize the IungoToken Token
335      * @param _foundersFundAddress The owner of this address is the Iungo Founders fund
336      * @param _teamFundAddress The owner of this address is the Iungo Team Foundation fund
337      * @param _reserveFundAddress The owner of this address is the Reserve fund
338      */
339     function IungoToken (address _foundersFundAddress, address _teamFundAddress,
340                          address _reserveFundAddress, address _fundsTreasury) public {
341         foundersFundAddress = 0x9CB0016511Fb93EAc7bC585A2bc2f0C34DEcEa15;
342         teamFundAddress = 0xDda7003998244f6161A5BBAf0F4ed5a40E908b51;
343         reserveFundAddress = 0x9186b48Db83E63adEDaB43C19345f39c83928E3f;
344         fundsTreasury = 0x31a633c4eE2C317DE2C65beb00593EAdD9f172d6;
345     }
346 
347     /// @dev Returns the current price.
348     function price() public view returns (uint256 tokens) {
349         return computeTokenAmount(1 ether);
350     }
351 
352     /// @dev This default function allows token to be purchased by directly
353     /// sending ether to this smart contract.
354     function () public payable {
355         purchaseTokens(msg.sender);
356     }
357 
358     /// @dev Issue token based on Ether received.
359     /// @param _beneficiary Address that newly issued token will be sent to.
360     function purchaseTokens(address _beneficiary) public payable inProgress {
361         // only accept a minimum amount of ETH?
362         require(msg.value >= 0.01 ether);
363 
364         uint256 tokens = computeTokenAmount(msg.value);
365         doIssueTokens(_beneficiary, tokens);
366 
367         /// forward the raised funds to the fund address
368         fundsTreasury.transfer(msg.value);
369     }
370 
371     /// @dev Batch issue tokens on the presale
372     /// @param _addresses addresses that the presale tokens will be sent to.
373     /// @param _addresses the amounts of tokens, with decimals expanded (full).
374     function issueTokensMulti(address[] _addresses, uint256[] _tokens) public onlyOwner inProgress {
375         require(_addresses.length == _tokens.length);
376         require(_addresses.length <= 100);
377 
378         for (uint256 i = 0; i < _tokens.length; i = i.add(1)) {
379             doIssueTokens(_addresses[i], _tokens[i]);
380         }
381     }
382 
383     /// @dev Issue tokens for a single buyer on the presale
384     /// @param _beneficiary addresses that the presale tokens will be sent to.
385     /// @param _tokensAmount the amount of tokens, with decimals expanded (full).
386     function issueTokens(address _beneficiary, uint256 _tokensAmount) public onlyOwner inProgress {
387         doIssueTokens(_beneficiary, _tokensAmount);
388     }
389 
390     /// @dev issue tokens for a single buyer
391     /// @param _beneficiary addresses that the tokens will be sent to.
392     /// @param _tokensAmount the amount of tokens, with decimals expanded (full).
393     function doIssueTokens(address _beneficiary, uint256 _tokensAmount) internal {
394         require(_beneficiary != address(0));
395 
396         // compute without actually increasing it
397         uint256 increasedTotalSupply = totalSupply.add(_tokensAmount);
398         // roll back if hard cap reached
399         require(increasedTotalSupply <= TOKENS_SALE_HARD_CAP);
400 
401         // increase token total supply
402         totalSupply = increasedTotalSupply;
403         // update the buyer's balance to number of tokens sent
404         balances[_beneficiary] = balances[_beneficiary].add(_tokensAmount);
405         // event is fired when tokens issued
406         Issue(
407             issueIndex++,
408             _beneficiary,
409             _tokensAmount
410         );
411     }
412 
413     /// @dev Compute the amount of ING token that can be purchased.
414     /// @param ethAmount Amount of Ether to purchase ING.
415     /// @return Amount of ING token to purchase
416     function computeTokenAmount(uint256 ethAmount) internal view returns (uint256 tokens) {
417         /// the percentage value (0-100) of the discount for each tier
418         uint64 discountPercentage = currentTierDiscountPercentage();
419 
420         uint256 tokenBase = ethAmount.mul(BASE_RATE);
421         uint256 tokenBonus = tokenBase.mul(discountPercentage).div(100);
422 
423         tokens = tokenBase.add(tokenBonus);
424     }
425 
426     /// @dev Determine the current sale tier.
427     /// @return the index of the current sale tier.
428     function currentTierDiscountPercentage() internal view returns (uint64) {
429         uint64 _now = uint64(block.timestamp);
430         require(_now <= date31Jan2018);
431 
432         if(_now > date21Jan2018) return 0;
433         if(_now > date12Jan2018) return 15;
434         if(_now > date21Dec2017) return 35;
435         return 50;
436     }
437 
438     // function getnow() public view returns (uint64) {
439     //     return uint64(block.timestamp);
440     // }
441     // 
442     // function setnow(uint64 time) public {
443     //     _now = time;
444     // }
445 
446     /// @dev Finalize the sale and distribute the reserve, team tokens, lock the founders tokens
447     function close() public onlyOwner beforeEnd {
448         uint64 _now = uint64(block.timestamp);
449 
450         /// Final (sold tokens) / (team + reserve + founders funds tokens) = 64 / 36 proportion = 0.5625
451         /// (sold tokens) + (team + reserve + founders funds tokens) = 64% + 36% = 100%
452         /// Therefore, (team + reserve + founders funds tokens) = 56.25% of the sold tokens = 36% of the total tokens
453         uint256 totalTokens = totalSupply.add(totalSupply.mul(5625).div(10000));
454 
455         /// Tokens to be allocated to the Reserve fund (12% of total ING)
456         uint256 reserveFundTokens = totalTokens.mul(12).div(100);
457         balances[reserveFundAddress] = balances[reserveFundAddress].add(reserveFundTokens);
458         totalSupply = totalSupply.add(reserveFundTokens);
459         /// fire event when tokens issued
460         Issue(
461             issueIndex++,
462             reserveFundAddress,
463             reserveFundTokens
464         );
465 
466         /// Tokens to be allocated to the Team fund (12% of total ING)
467         uint256 teamFundTokens = totalTokens.mul(12).div(100);
468         balances[teamFundAddress] = balances[teamFundAddress].add(teamFundTokens);
469         totalSupply = totalSupply.add(teamFundTokens);
470         /// fire event when tokens issued
471         Issue(
472             issueIndex++,
473             teamFundAddress,
474             teamFundTokens
475         );
476 
477         /// Tokens to be allocated to the locked Founders fund
478         /// 12% (3 x 4%) of total ING allocated to the Founders fund locked as follows:
479         /// first 4% locked for 6 months (183 days)
480         TokenTimelock lock1_6months = new TokenTimelock(this, foundersFundAddress, _now + 183*24*60*60);
481         foundersFundTimelock1Address = address(lock1_6months);
482         uint256 foundersFund1Tokens = totalTokens.mul(4).div(100);
483         /// update the contract balance to number of tokens issued
484         balances[foundersFundTimelock1Address] = balances[foundersFundTimelock1Address].add(foundersFund1Tokens);
485         /// increase total supply respective to the tokens issued
486         totalSupply = totalSupply.add(foundersFund1Tokens);
487         /// fire event when tokens issued
488         Issue(
489             issueIndex++,
490             foundersFundTimelock1Address,
491             foundersFund1Tokens
492         );
493 
494         /// second 4% locked for 12 months (365 days)
495         TokenTimelock lock2_12months = new TokenTimelock(this, foundersFundAddress, _now + 365*24*60*60);
496         foundersFundTimelock2Address = address(lock2_12months);
497         uint256 foundersFund2Tokens = totalTokens.mul(4).div(100);
498         balances[foundersFundTimelock2Address] = balances[foundersFundTimelock2Address].add(foundersFund2Tokens);
499         /// increase total supply respective to the tokens issued
500         totalSupply = totalSupply.add(foundersFund2Tokens);
501         /// fire event when tokens issued
502         Issue(
503             issueIndex++,
504             foundersFundTimelock2Address,
505             foundersFund2Tokens
506         );
507 
508         /// third 4% locked for 18 months (548 days)
509         TokenTimelock lock3_18months = new TokenTimelock(this, foundersFundAddress, _now + 548*24*60*60);
510         foundersFundTimelock3Address = address(lock3_18months);
511         uint256 foundersFund3Tokens = totalTokens.mul(4).div(100);
512         balances[foundersFundTimelock3Address] = balances[foundersFundTimelock3Address].add(foundersFund3Tokens);
513         /// increase total supply respective to the tokens issued
514         totalSupply = totalSupply.add(foundersFund3Tokens);
515         /// fire event when tokens issued
516         Issue(
517             issueIndex++,
518             foundersFundTimelock3Address,
519             foundersFund3Tokens
520         );
521 
522         /// burn the unallocated tokens - no more tokens can be issued after this line
523         tokenSaleClosed = true;
524 
525         /// forward the raised funds to the fund address
526         fundsTreasury.transfer(this.balance);
527     }
528 
529     /// @return if the token sale is finished
530     function saleDue() public view returns (bool) {
531         return date31Jan2018 < uint64(block.timestamp);
532     }
533 
534     /// Transfer limited by the tradingOpen modifier (time is 01 Feb 2018 or later)
535     function transferFrom(address _from, address _to, uint256 _value) public tradingOpen returns (bool) {
536         return super.transferFrom(_from, _to, _value);
537     }
538 
539     /// Transfer limited by the tradingOpen modifier (time is 01 Feb 2018 or later)
540     function transfer(address _to, uint256 _value) public tradingOpen returns (bool) {
541         return super.transfer(_to, _value);
542     }
543 }