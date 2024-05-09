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
127 
128  contract StandardToken is ERC20, BasicToken {
129 
130    mapping (address => mapping (address => uint256)) allowed;
131 
132 
133    /**
134     * @dev Transfer tokens from one address to another
135     * @param _from address The address which you want to send tokens from
136     * @param _to address The address which you want to transfer to
137     * @param _value uint256 the amout of tokens to be transfered
138     */
139    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
140      var _allowance = allowed[_from][msg.sender];
141 
142      // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
143      // require (_value <= _allowance);
144 
145      balances[_to] = balances[_to].add(_value);
146      balances[_from] = balances[_from].sub(_value);
147      allowed[_from][msg.sender] = _allowance.sub(_value);
148      Transfer(_from, _to, _value);
149      return true;
150    }
151 
152    /**
153     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
154     * @param _spender The address which will spend the funds.
155     * @param _value The amount of tokens to be spent.
156     */
157    function approve(address _spender, uint256 _value) returns (bool) {
158 
159      // To change the approve amount you first have to reduce the addresses`
160      //  allowance to zero by calling `approve(_spender, 0)` if it is not
161      //  already 0 to mitigate the race condition described here:
162      //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      require((_value == 0) || (allowed[msg.sender][_spender] == 0));
164 
165      allowed[msg.sender][_spender] = _value;
166      Approval(msg.sender, _spender, _value);
167      return true;
168    }
169 
170    /**
171     * @dev Function to check the amount of tokens that an owner allowed to a spender.
172     * @param _owner address The address which owns the funds.
173     * @param _spender address The address which will spend the funds.
174     * @return A uint256 specifing the amount of tokens still avaible for the spender.
175     */
176    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
177      return allowed[_owner][_spender];
178    }
179 
180  }
181 
182 /**
183  * @title Mintable token
184  * @dev Simple ERC20 Token example, with mintable token creation
185  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
186  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
187  */
188 
189 contract MintableToken is StandardToken, Ownable {
190   event Mint(address indexed to, uint256 amount);
191   event MintFinished();
192 
193   bool public mintingFinished = false;
194 
195 
196   modifier canMint() {
197     require(!mintingFinished);
198     _;
199   }
200 
201   /**
202    * @dev Function to mint tokens
203    * @param _to The address that will recieve the minted tokens.
204    * @param _amount The amount of tokens to mint.
205    * @return A boolean that indicates if the operation was successful.
206    */
207   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
208     totalSupply = totalSupply.add(_amount);
209     balances[_to] = balances[_to].add(_amount);
210     Transfer(0X0, _to, _amount);
211     return true;
212   }
213 
214   /**
215    * @dev Function to stop minting new tokens.
216    * @return True if the operation was successful.
217    */
218   function finishMinting() onlyOwner returns (bool) {
219     mintingFinished = true;
220     MintFinished();
221     return true;
222   }
223 }
224 
225 contract ChangeCoin is MintableToken {
226   string public name = "Change COIN";
227   string public symbol = "CAG";
228   uint256 public decimals = 18;
229 
230   bool public tradingStarted = false;
231 
232   /**
233    * @dev modifier that throws if trading has not started yet
234    */
235   modifier hasStartedTrading() {
236     require(tradingStarted);
237     _;
238   }
239 
240   /**
241    * @dev Allows the owner to enable the trading. This can not be undone
242    */
243   function startTrading() onlyOwner {
244     tradingStarted = true;
245   }
246 
247 
248   /**
249    * @dev Allows anyone to transfer the Change tokens once trading has started
250    * @param _to the recipient address of the tokens.
251    * @param _value number of tokens to be transfered.
252    */
253   function transfer(address _to, uint _value) hasStartedTrading returns (bool){
254     return super.transfer(_to, _value);
255   }
256 
257   /**
258    * @dev Allows anyone to transfer the Change tokens once trading has started
259    * @param _from address The address which you want to send tokens from
260    * @param _to address The address which you want to transfer to
261    * @param _value uint the amout of tokens to be transfered
262    */
263   function transferFrom(address _from, address _to, uint _value) hasStartedTrading returns (bool){
264     return super.transferFrom(_from, _to, _value);
265   }
266 }
267 
268 contract ChangeCoinCrowdsale is Ownable {
269   using SafeMath for uint256;
270 
271   // The token being sold
272   ChangeCoin public token;
273 
274   // start and end block where investments are allowed (both inclusive)
275   uint256 public startTimestamp;
276   uint256 public endTimestamp;
277 
278   // address where funds are collected
279   address public hardwareWallet;
280 
281   // how many token units a buyer gets per wei
282   uint256 public rate;
283 
284   // amount of raised money in wei
285   uint256 public weiRaised;
286 
287   uint256 public minContribution;
288 
289   uint256 public hardcap;
290 
291   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
292   event MainSaleClosed();
293 
294   uint256 public raisedInPresale = 36670.280302936701463815 ether;
295 
296   function ChangeCoinCrowdsale() {
297     startTimestamp = 1505568600;
298     endTimestamp = 1508162400;
299     rate = 500;
300     hardwareWallet = 0x71B1Ee0848c4F68df05429490fc4237089692e1e;
301     token = ChangeCoin(0x7d4b8Cce0591C9044a22ee543533b72E976E36C3);
302 
303     minContribution = 0.49 ether;
304     hardcap = 200000 ether;
305 
306     require(startTimestamp >= now);
307     require(endTimestamp >= startTimestamp);
308   }
309 
310   /**
311    * @dev Calculates the amount of bonus coins the buyer gets
312    * @param tokens uint the amount of tokens you get according to current rate
313    * @return uint the amount of bonus tokens the buyer gets
314    */
315   function bonusAmmount(uint256 tokens) internal returns(uint256) {
316     uint256 bonus5 = tokens /20;
317     // add bonus 20% in first 24hours, 15% in first week, 10% in 2nd week
318     if (now < startTimestamp + 24 hours) { // 5080 is aprox 24h
319       return bonus5 * 4;
320     } else if (now < startTimestamp + 1 weeks) {
321       return bonus5 * 3;
322     } else if (now < startTimestamp + 2 weeks) {
323       return bonus5 * 2;
324     } else {
325       return 0;
326     }
327   }
328 
329   // check if valid purchase
330   modifier validPurchase {
331     require(now >= startTimestamp);
332     require(now <= endTimestamp);
333     require(msg.value >= minContribution);
334     require(weiRaised.add(msg.value).add(raisedInPresale) <= hardcap);
335     _;
336   }
337 
338   // @return true if crowdsale event has ended
339   function hasEnded() public constant returns (bool) {
340     bool timeLimitReached = now > endTimestamp;
341     bool capReached = weiRaised.add(raisedInPresale) >= hardcap;
342     return timeLimitReached || capReached;
343   }
344 
345   // low level token purchase function
346   function buyTokens(address beneficiary) payable validPurchase {
347     require(beneficiary != 0x0);
348 
349     uint256 weiAmount = msg.value;
350 
351     // calculate token amount to be created
352     uint256 tokens = weiAmount.mul(rate);
353     tokens = tokens + bonusAmmount(tokens);
354 
355     // update state
356     weiRaised = weiRaised.add(weiAmount);
357 
358     token.mint(beneficiary, tokens);
359     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
360     hardwareWallet.transfer(msg.value);
361   }
362 
363   // finish mining coins and transfer ownership of Change coin to owner
364   function finishMinting() public onlyOwner {
365     require(hasEnded());
366     uint issuedTokenSupply = token.totalSupply();
367     uint restrictedTokens = issuedTokenSupply.mul(60).div(40);
368     token.mint(hardwareWallet, restrictedTokens);
369     token.finishMinting();
370     token.transferOwnership(owner);
371     MainSaleClosed();
372   }
373 
374   // fallback function can be used to buy tokens
375   function () payable {
376     buyTokens(msg.sender);
377   }
378 
379 }