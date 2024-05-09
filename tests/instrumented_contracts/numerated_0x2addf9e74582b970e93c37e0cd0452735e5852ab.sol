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
182 contract MintableToken is StandardToken, Ownable {
183   event MintFinished();
184 
185   bool public mintingFinished = false;
186 
187 
188   modifier canMint() {
189     require(!mintingFinished);
190     _;
191   }
192 
193   /**
194    * @dev Function to mint tokens
195    * @param _to The address that will recieve the minted tokens.
196    * @param _amount The amount of tokens to mint.
197    * @return A boolean that indicates if the operation was successful.
198    */
199   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
200     totalSupply = totalSupply.add(_amount);
201     balances[_to] = balances[_to].add(_amount);
202     Transfer(0X0, _to, _amount);
203     return true;
204   }
205 
206   /**
207    * @dev Function to stop minting new tokens.
208    * @return True if the operation was successful.
209    */
210   function finishMinting() onlyOwner returns (bool) {
211     mintingFinished = true;
212     MintFinished();
213     return true;
214   }
215 }
216 
217 contract ChangeCoin is MintableToken {
218   string public name = "Change COIN";
219   string public symbol = "CAG";
220   uint256 public decimals = 18;
221 
222   bool public tradingStarted = false;
223 
224   /**
225    * @dev modifier that throws if trading has not started yet
226    */
227   modifier hasStartedTrading() {
228     require(tradingStarted);
229     _;
230   }
231 
232   /**
233    * @dev Allows the owner to enable the trading. This can not be undone
234    */
235   function startTrading() onlyOwner {
236     tradingStarted = true;
237   }
238 
239 
240   /**
241    * @dev Allows anyone to transfer the Change tokens once trading has started
242    * @param _to the recipient address of the tokens.
243    * @param _value number of tokens to be transfered.
244    */
245   function transfer(address _to, uint _value) hasStartedTrading returns (bool){
246     return super.transfer(_to, _value);
247   }
248 
249   /**
250    * @dev Allows anyone to transfer the Change tokens once trading has started
251    * @param _from address The address which you want to send tokens from
252    * @param _to address The address which you want to transfer to
253    * @param _value uint the amout of tokens to be transfered
254    */
255   function transferFrom(address _from, address _to, uint _value) hasStartedTrading returns (bool){
256     return super.transferFrom(_from, _to, _value);
257   }
258 }
259 
260 contract ChangeCoinPresale is Ownable {
261   using SafeMath for uint256;
262 
263   // The token being sold
264   ChangeCoin public token;
265 
266   // start and end block where investments are allowed (both inclusive)
267   uint256 public startTimestamp;
268   uint256 public endTimestamp;
269 
270   // address where funds are collected
271   address public hardwareWallet;
272 
273   // how many token units a buyer gets per wei
274   uint256 public rate;
275 
276   // amount of raised money in wei
277   uint256 public weiRaised;
278 
279   // minimum contributio to participate in tokensale
280   uint256 public minContribution;
281 
282   // maximum amount of ether being raised
283   uint256 public hardcap;
284 
285   // number of participants in presale
286   uint256 public numberOfPurchasers = 0;
287 
288   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
289   event PreSaleClosed();
290 
291   function ChangeCoinPresale() {
292     startTimestamp = 1504785900;
293     endTimestamp = 1504789200;
294     rate = 500;
295     hardwareWallet = 0x12b97A56F63F8CF75052B5b816d7Ad9e794B8198;
296     token = new ChangeCoin();
297     minContribution = 0 ether;
298     //minContribution = 9.9 ether;
299     hardcap = 50000 ether;
300 
301     require(startTimestamp >= now);
302     require(endTimestamp >= startTimestamp);
303   }
304 
305   /**
306    * @dev Calculates the amount of bonus coins the buyer gets
307    * @param tokens uint the amount of tokens you get according to current rate
308    * @return uint the amount of bonus tokens the buyer gets
309    */
310   function bonusAmmount(uint256 tokens) internal returns(uint256) {
311     // first 500 get extra 30%
312     if (numberOfPurchasers < 2) {
313       return tokens * 3 / 10;
314     } else {
315       return tokens /4;
316     }
317   }
318 
319   // check if valid purchase
320   modifier validPurchase {
321     require(now >= startTimestamp);
322     require(now <= endTimestamp);
323     require(msg.value >= minContribution);
324     require(weiRaised.add(msg.value) <= hardcap);
325     _;
326   }
327 
328   // @return true if crowdsale event has ended
329   function hasEnded() public constant returns (bool) {
330     bool timeLimitReached = now > endTimestamp;
331     bool capReached = weiRaised >= hardcap;
332     return timeLimitReached || capReached;
333   }
334 
335   // low level token purchase function
336   function buyTokens(address beneficiary) payable validPurchase {
337     require(beneficiary != 0x0);
338 
339     uint256 weiAmount = msg.value;
340 
341     // calculate token amount to be created
342     uint256 tokens = weiAmount.mul(rate);
343     tokens = tokens + bonusAmmount(tokens);
344 
345     // update state
346     weiRaised = weiRaised.add(weiAmount);
347     numberOfPurchasers = numberOfPurchasers + 1;
348 
349     token.mint(beneficiary, tokens);
350     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
351     hardwareWallet.transfer(msg.value);
352   }
353 
354   // transfer ownership of the token to the owner of the presale contract
355   function finishPresale() public onlyOwner {
356     require(hasEnded());
357     token.transferOwnership(owner);
358     PreSaleClosed();
359   }
360 
361   // fallback function can be used to buy tokens
362   function () payable {
363     buyTokens(msg.sender);
364   }
365 
366 }