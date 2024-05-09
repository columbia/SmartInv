1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64 
65     // SafeMath.sub will throw if there is not enough balance.
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   /**
73   * @dev Gets the balance of the specified address.
74   * @param _owner The address to query the the balance of.
75   * @return An uint256 representing the amount owned by the passed address.
76   */
77   function balanceOf(address _owner) public constant returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public constant returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117 
118     uint256 _allowance = allowed[_from][msg.sender];
119 
120     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
121     // require (_value <= _allowance);
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = _allowance.sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    */
162   function increaseApproval (address _spender, uint _addedValue)
163     returns (bool success) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   function decreaseApproval (address _spender, uint _subtractedValue)
170     returns (bool success) {
171     uint oldValue = allowed[msg.sender][_spender];
172     if (_subtractedValue > oldValue) {
173       allowed[msg.sender][_spender] = 0;
174     } else {
175       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
176     }
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181 }
182 
183 
184 /**
185  * @title Ownable
186  * @dev The Ownable contract has an owner address, and provides basic authorization control
187  * functions, this simplifies the implementation of "user permissions".
188  */
189 contract Ownable {
190   address public owner;
191 
192 
193   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194 
195 
196   /**
197    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
198    * account.
199    */
200   function Ownable() {
201     owner = msg.sender;
202   }
203 
204 
205   /**
206    * @dev Throws if called by any account other than the owner.
207    */
208   modifier onlyOwner() {
209     require(msg.sender == owner);
210     _;
211   }
212 
213 
214   /**
215    * @dev Allows the current owner to transfer control of the contract to a newOwner.
216    * @param newOwner The address to transfer ownership to.
217    */
218   function transferOwnership(address newOwner) onlyOwner public {
219     require(newOwner != address(0));
220     OwnershipTransferred(owner, newOwner);
221     owner = newOwner;
222   }
223 
224 }
225 
226 
227 
228 
229 /**
230  * @title Mintable token
231  * @dev Simple ERC20 Token example, with mintable token creation
232  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
233  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
234  */
235 
236 contract MintableToken is StandardToken, Ownable {
237   event Mint(address indexed to, uint256 amount);
238   event MintFinished();
239 
240   bool public mintingFinished = false;
241 
242 
243   modifier canMint() {
244     require(!mintingFinished);
245     _;
246   }
247 
248   /**
249    * @dev Function to mint tokens
250    * @param _to The address that will receive the minted tokens.
251    * @param _amount The amount of tokens to mint.
252    * @return A boolean that indicates if the operation was successful.
253    */
254   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
255     totalSupply = totalSupply.add(_amount);
256     balances[_to] = balances[_to].add(_amount);
257     Mint(_to, _amount);
258     Transfer(0x0, _to, _amount);
259     return true;
260   }
261 
262   /**
263    * @dev Function to stop minting new tokens.
264    * @return True if the operation was successful.
265    */
266   function finishMinting() onlyOwner public returns (bool) {
267     mintingFinished = true;
268     MintFinished();
269     return true;
270   }
271 }
272 
273 
274 
275 contract BlockchainTradedFund is MintableToken {
276     string public name = "Blockchain Traded Fund";
277     string public symbol = "BTF";
278     uint8 public decimals = 18;
279 
280     uint256 public maxTotalSupply = 200000000 * (10 ** uint256(decimals));
281 
282 
283     modifier canMint() {
284         require(!mintingFinished);
285         _;
286         assert(totalSupply <= maxTotalSupply);
287     }
288 }
289 
290 
291 
292 contract BTFCrowdsale is Ownable {
293     using SafeMath for uint256;
294 
295     // The token being sold
296     BlockchainTradedFund public token;
297 
298     // start and end timestamps where investments are allowed (both inclusive)
299     uint256 public startTime;
300     uint256 public endTime;
301 
302     // address where funds are collected
303     address public wallet;
304 
305     // how many token units a buyer gets per wei
306     uint256 public rate;
307 
308     // amount of raised money in wei
309     uint256 public weiRaised;
310 
311     /**
312     * event for token purchase logging
313     * @param purchaser who paid for the tokens
314     * @param beneficiary who got the tokens
315     * @param value weis paid for purchase
316     * @param amount amount of tokens purchased
317     */
318     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
319 
320     bool public tokenForTeamGranted = false;
321 
322     function BTFCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
323         // add 60 sec to account for network latency
324         require(_startTime.add(60) >= now);
325         require(_endTime >= _startTime);
326         require(_rate > 0);
327         require(_wallet != 0x0);
328 
329         startTime = _startTime;
330         endTime = _endTime;
331         rate = _rate;
332         wallet = _wallet;
333     }
334 
335     // creates the token to be sold.
336     // override this method to have crowdsale of a specific mintable token.
337     function createTokenContract() public onlyOwner returns (BlockchainTradedFund) {
338         require(token == address(0));
339         token = new BlockchainTradedFund();
340     }
341 
342 
343     // fallback function can be used to buy tokens
344     function () payable {
345         buyTokens(msg.sender);
346     }
347 
348     // low level token purchase function
349     function buyTokens(address beneficiary) public payable {
350         require(beneficiary != 0x0);
351         require(validPurchase());
352 
353         uint256 weiAmount = msg.value;
354 
355         // calculate token amount to be created
356         uint256 tokens = weiAmount.mul(rate);
357 
358         // update state
359         weiRaised = weiRaised.add(weiAmount);
360 
361         token.mint(beneficiary, tokens);
362         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
363 
364         forwardFunds();
365     }
366 
367     // send ether to the fund collection wallet
368     // override to create custom fund forwarding mechanisms
369     function forwardFunds() internal {
370         wallet.transfer(msg.value);
371     }
372 
373     // @return true if the transaction can buy tokens
374     function validPurchase() internal constant returns (bool) {
375         bool withinPeriod = now >= startTime && now <= endTime;
376         bool nonZeroPurchase = msg.value != 0;
377         return withinPeriod && nonZeroPurchase;
378     }
379 
380     function walletTransfer(address newWallet) public onlyOwner returns(bool) {
381         wallet = newWallet;
382         return true;
383     }
384 
385     // @return true if crowdsale event has ended
386     function hasEnded() public constant returns (bool) {
387         return now > endTime;
388     }
389 
390     /**
391      * Mint 55 mln tokens for owner.
392      */
393     function getTokenForTeam(address beneficiary) public onlyOwner returns(bool) {
394         require(!tokenForTeamGranted);
395         uint256 decimals = BlockchainTradedFund(token).decimals();
396         uint256 amountGranted = 55000000 * (10 ** uint256(decimals));
397         token.mint(beneficiary, amountGranted);
398         tokenForTeamGranted = true;
399         return true;
400     }
401 
402 
403 }