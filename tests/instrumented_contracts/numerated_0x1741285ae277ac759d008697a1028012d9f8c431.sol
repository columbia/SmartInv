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
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold.
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126 
127   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   function Ownable() {
135     owner = msg.sender;
136   }
137 
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address newOwner) onlyOwner public {
153     require(newOwner != address(0));
154     OwnershipTransferred(owner, newOwner);
155     owner = newOwner;
156   }
157 
158 }
159 
160 contract FinalizableCrowdsale is Crowdsale, Ownable {
161   using SafeMath for uint256;
162 
163   bool public isFinalized = false;
164 
165   event Finalized();
166 
167   /**
168    * @dev Must be called after crowdsale ends, to do some extra finalization
169    * work. Calls the contract's finalization function.
170    */
171   function finalize() onlyOwner public {
172     require(!isFinalized);
173     require(hasEnded());
174 
175     finalization();
176     Finalized();
177 
178     isFinalized = true;
179   }
180 
181   /**
182    * @dev Can be overridden to add finalization logic. The overriding function
183    * should call super.finalization() to ensure the chain of finalization is
184    * executed entirely.
185    */
186   function finalization() internal {
187   }
188 }
189 
190 contract ERC20Basic {
191   uint256 public totalSupply;
192   function balanceOf(address who) public constant returns (uint256);
193   function transfer(address to, uint256 value) public returns (bool);
194   event Transfer(address indexed from, address indexed to, uint256 value);
195 }
196 
197 contract BasicToken is ERC20Basic {
198   using SafeMath for uint256;
199 
200   mapping(address => uint256) balances;
201 
202   /**
203   * @dev transfer token for a specified address
204   * @param _to The address to transfer to.
205   * @param _value The amount to be transferred.
206   */
207   function transfer(address _to, uint256 _value) public returns (bool) {
208     require(_to != address(0));
209 
210     // SafeMath.sub will throw if there is not enough balance.
211     balances[msg.sender] = balances[msg.sender].sub(_value);
212     balances[_to] = balances[_to].add(_value);
213     Transfer(msg.sender, _to, _value);
214     return true;
215   }
216 
217   /**
218   * @dev Gets the balance of the specified address.
219   * @param _owner The address to query the the balance of.
220   * @return An uint256 representing the amount owned by the passed address.
221   */
222   function balanceOf(address _owner) public constant returns (uint256 balance) {
223     return balances[_owner];
224   }
225 
226 }
227 
228 contract ERC20 is ERC20Basic {
229   function allowance(address owner, address spender) public constant returns (uint256);
230   function transferFrom(address from, address to, uint256 value) public returns (bool);
231   function approve(address spender, uint256 value) public returns (bool);
232   event Approval(address indexed owner, address indexed spender, uint256 value);
233 }
234 
235 contract StandardToken is ERC20, BasicToken {
236 
237   mapping (address => mapping (address => uint256)) allowed;
238 
239 
240   /**
241    * @dev Transfer tokens from one address to another
242    * @param _from address The address which you want to send tokens from
243    * @param _to address The address which you want to transfer to
244    * @param _value uint256 the amount of tokens to be transferred
245    */
246   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
247     require(_to != address(0));
248 
249     uint256 _allowance = allowed[_from][msg.sender];
250 
251     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
252     // require (_value <= _allowance);
253 
254     balances[_from] = balances[_from].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     allowed[_from][msg.sender] = _allowance.sub(_value);
257     Transfer(_from, _to, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263    *
264    * Beware that changing an allowance with this method brings the risk that someone may use both the old
265    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271   function approve(address _spender, uint256 _value) public returns (bool) {
272     allowed[msg.sender][_spender] = _value;
273     Approval(msg.sender, _spender, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Function to check the amount of tokens that an owner allowed to a spender.
279    * @param _owner address The address which owns the funds.
280    * @param _spender address The address which will spend the funds.
281    * @return A uint256 specifying the amount of tokens still available for the spender.
282    */
283   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
284     return allowed[_owner][_spender];
285   }
286 
287   /**
288    * approve should be called when allowed[_spender] == 0. To increment
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    */
293   function increaseApproval (address _spender, uint _addedValue)
294     returns (bool success) {
295     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
296     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300   function decreaseApproval (address _spender, uint _subtractedValue)
301     returns (bool success) {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312 }
313 
314 contract BurnableToken is StandardToken {
315 
316     event Burn(address indexed burner, uint256 value);
317 
318     /**
319      * @dev Burns a specific amount of tokens.
320      * @param _value The amount of token to be burned.
321      */
322     function burn(uint256 _value) public {
323         require(_value > 0);
324 
325         address burner = msg.sender;
326         balances[burner] = balances[burner].sub(_value);
327         totalSupply = totalSupply.sub(_value);
328         Burn(burner, _value);
329     }
330 }
331 
332 contract MintableToken is StandardToken, Ownable {
333   event Mint(address indexed to, uint256 amount);
334   event MintFinished();
335 
336   bool public mintingFinished = false;
337 
338 
339   modifier canMint() {
340     require(!mintingFinished);
341     _;
342   }
343 
344   /**
345    * @dev Function to mint tokens
346    * @param _to The address that will receive the minted tokens.
347    * @param _amount The amount of tokens to mint.
348    * @return A boolean that indicates if the operation was successful.
349    */
350   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
351     totalSupply = totalSupply.add(_amount);
352     balances[_to] = balances[_to].add(_amount);
353     Mint(_to, _amount);
354     Transfer(0x0, _to, _amount);
355     return true;
356   }
357 
358   /**
359    * @dev Function to stop minting new tokens.
360    * @return True if the operation was successful.
361    */
362   function finishMinting() onlyOwner public returns (bool) {
363     mintingFinished = true;
364     MintFinished();
365     return true;
366   }
367 }
368 
369 contract HermesToken is MintableToken, BurnableToken {
370 	string public name = "Hermes Fund";
371 	string public symbol = "HFD";
372 	uint8 public decimals = 18;
373 }
374 
375 contract HermesTokenCrowdsale is FinalizableCrowdsale {
376     using SafeMath for uint256;
377 
378     uint256 public rate = 1;
379     uint256 public initSupply = rate.mul(33 ether);
380     address public developersWallet;
381 
382     function HermesTokenCrowdsale (
383         address _contributionWallet,
384         address _developersWallet
385         )
386         Crowdsale (
387             now + 1,
388             now + 2419200, // 4 weeks
389             rate,
390             _contributionWallet
391             )
392             {
393                 developersWallet = _developersWallet;
394                 token.mint(developersWallet, initSupply);
395             }
396 
397             function createTokenContract () internal returns (MintableToken) {
398                 return new HermesToken();
399             }
400 
401             function finalization() internal {
402                 token.transferOwnership(owner);
403             }
404 
405         }