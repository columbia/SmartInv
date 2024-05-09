1 pragma solidity ^0.4.13;
2 
3 contract Crowdsale {
4   using SafeMath for uint256;
5 
6   // The token being sold
7   MintableToken public token;
8 
9   // start and end timestamps where investments are allowed (both inclusive)
10   uint256 public startTime;
11   uint256 public endTime;
12   uint256 public icoStartTime;
13   uint256 public icoDiscountTime;
14 
15   // address where funds are collected
16   address public wallet;
17 
18   // how many token units a buyer gets per wei
19   uint256 public rate;
20 
21   // amount of raised money in wei
22   uint256 public weiRaised;
23   
24   // amount of tokens tokensIssued
25   uint256 public tokensIssued;
26 
27   /**
28    * event for token purchase logging
29    * @param purchaser who paid for the tokens
30    * @param beneficiary who got the tokens
31    * @param value weis paid for purchase
32    * @param amount amount of tokens purchased
33    */
34   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
35 
36 
37   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _icoStartTime, uint256 _icoDiscountTime, uint256 _rate, address _wallet) public {
38     require(_startTime >= 1517443200); // startTime safe check (cannot be before Feb2018)
39     require(_endTime >= _startTime);
40     require(_rate > 0);
41     require(_wallet != address(0));
42 
43      
44     startTime = _startTime;     // preICO Start Time (12th Feb 2018)
45     icoStartTime=_icoStartTime; // ICO start Time (12th March 2018)
46     icoDiscountTime = _icoDiscountTime; // ICO discount Time End (12th April 2018)
47     endTime = _endTime;         // ICO End Time (12th June 2018)
48     rate = _rate;               // exchange rate FDU/ETH
49     wallet = _wallet;
50     token = createTokenContract();
51   }
52 
53    // creates the FDU token to be sold.
54   // issue tokens to Kickstart
55    function createTokenContract() internal returns (MintableToken) {
56     MintableToken  _token = new FiduxaCoin(); // create token
57     _token.mint(wallet, 20000000000000000000000000); // issue 20Mil tokens (Kickstart pool, Founders, Advisors)
58     return _token;
59    }
60     
61   // fallback function can be used to buy tokens
62   function () external payable {
63     buyTokens(msg.sender);
64   }
65 
66   // Token purchase function
67   function buyTokens(address beneficiary) public payable {
68     require(beneficiary != address(0));
69     require(validPurchase());
70 
71     uint256 weiAmount = msg.value;
72 
73     // calculate token amount to be created
74     uint256 tokens = getTokenAmount(weiAmount);
75 
76     // update state
77     weiRaised = weiRaised.add(weiAmount);
78     tokensIssued = tokensIssued.add(tokens); 
79 
80     token.mint(beneficiary, tokens);
81     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
82 
83     forwardFunds();
84   }
85 
86   // @return true if crowdsale event has ended .. this function is not used now as we rely on validPurchase
87   function hasEnded() public view returns (bool) {
88     bool capReached = tokensIssued >= 80000000000000000000000000; // Token sale Hard Capped to 100Mil (80 investors + 20 others)
89     bool timeOver = now > endTime; // Token sale ended
90     return capReached || timeOver;
91   }
92 
93   // Set Business logic 
94   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
95     if (now >= icoDiscountTime ) return weiAmount.mul(rate); // ICO full price
96      else if (now >= icoStartTime ) return weiAmount.mul(rate).div(100).mul(120); // ICO 20% discount
97         else return weiAmount.mul(rate).div(100).mul(140); //preICO 40% discount 
98   }
99 
100   // send ether to Fiduxa main collection wallet
101   // safety measure: we send to the contract creator address only
102   function forwardFunds() internal {
103     wallet.transfer(msg.value);
104   }
105 
106   // @return true if the transaction can buy tokens based on cap and timing
107   function validPurchase() internal view returns (bool) {
108     bool withinPeriod = now >= startTime && now <= endTime; // check ICO timing validity
109     bool nonZeroPurchase = msg.value != 0; // deny fake transactions 
110     bool withinCap = tokensIssued <= 80000000000000000000000000; // verify cap reached
111     // as we do not include the current purchase in cap calculation the very last transaction may be accepted even if 
112     // the total amount is greater than the cap.
113     return withinPeriod && nonZeroPurchase && withinCap;
114   }
115 
116 }
117 
118 contract ERC20Basic {
119   function totalSupply() public view returns (uint256);
120   function balanceOf(address who) public view returns (uint256);
121   function transfer(address to, uint256 value) public returns (bool);
122   event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   uint256 totalSupply_;
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 contract ERC20 is ERC20Basic {
167   function allowance(address owner, address spender) public view returns (uint256);
168   function transferFrom(address from, address to, uint256 value) public returns (bool);
169   function approve(address spender, uint256 value) public returns (bool);
170   event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 contract FiduxaCoinCrowdsale is Crowdsale {
174 
175   function FiduxaCoinCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _icoStartTime, uint256 _icoDiscountTime, uint256 _rate, address _wallet) 
176     Crowdsale(_startTime, _endTime, _icoStartTime, _icoDiscountTime, _rate, _wallet) public {          
177   }
178 
179  
180 
181 }
182 
183 contract Ownable {
184   address public owner;
185 
186 
187   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189 
190   /**
191    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
192    * account.
193    */
194   function Ownable() public {
195     owner = msg.sender;
196   }
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     require(msg.sender == owner);
203     _;
204   }
205 
206   /**
207    * @dev Allows the current owner to transfer control of the contract to a newOwner.
208    * @param newOwner The address to transfer ownership to.
209    */
210   function transferOwnership(address newOwner) public onlyOwner {
211     require(newOwner != address(0));
212     OwnershipTransferred(owner, newOwner);
213     owner = newOwner;
214   }
215 
216 }
217 
218 library SafeMath {
219 
220   /**
221   * @dev Multiplies two numbers, throws on overflow.
222   */
223   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224     if (a == 0) {
225       return 0;
226     }
227     uint256 c = a * b;
228     assert(c / a == b);
229     return c;
230   }
231 
232   /**
233   * @dev Integer division of two numbers, truncating the quotient.
234   */
235   function div(uint256 a, uint256 b) internal pure returns (uint256) {
236     // assert(b > 0); // Solidity automatically throws when dividing by 0
237     uint256 c = a / b;
238     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239     return c;
240   }
241 
242   /**
243   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
244   */
245   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
246     assert(b <= a);
247     return a - b;
248   }
249 
250   /**
251   * @dev Adds two numbers, throws on overflow.
252   */
253   function add(uint256 a, uint256 b) internal pure returns (uint256) {
254     uint256 c = a + b;
255     assert(c >= a);
256     return c;
257   }
258 }
259 
260 contract StandardToken is ERC20, BasicToken {
261 
262   mapping (address => mapping (address => uint256)) internal allowed;
263 
264 
265   /**
266    * @dev Transfer tokens from one address to another
267    * @param _from address The address which you want to send tokens from
268    * @param _to address The address which you want to transfer to
269    * @param _value uint256 the amount of tokens to be transferred
270    */
271   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
272     require(_to != address(0));
273     require(_value <= balances[_from]);
274     require(_value <= allowed[_from][msg.sender]);
275 
276     balances[_from] = balances[_from].sub(_value);
277     balances[_to] = balances[_to].add(_value);
278     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
279     Transfer(_from, _to, _value);
280     return true;
281   }
282 
283   /**
284    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
285    *
286    * Beware that changing an allowance with this method brings the risk that someone may use both the old
287    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
288    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
289    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290    * @param _spender The address which will spend the funds.
291    * @param _value The amount of tokens to be spent.
292    */
293   function approve(address _spender, uint256 _value) public returns (bool) {
294     allowed[msg.sender][_spender] = _value;
295     Approval(msg.sender, _spender, _value);
296     return true;
297   }
298 
299   /**
300    * @dev Function to check the amount of tokens that an owner allowed to a spender.
301    * @param _owner address The address which owns the funds.
302    * @param _spender address The address which will spend the funds.
303    * @return A uint256 specifying the amount of tokens still available for the spender.
304    */
305   function allowance(address _owner, address _spender) public view returns (uint256) {
306     return allowed[_owner][_spender];
307   }
308 
309   /**
310    * @dev Increase the amount of tokens that an owner allowed to a spender.
311    *
312    * approve should be called when allowed[_spender] == 0. To increment
313    * allowed value is better to use this function to avoid 2 calls (and wait until
314    * the first transaction is mined)
315    * From MonolithDAO Token.sol
316    * @param _spender The address which will spend the funds.
317    * @param _addedValue The amount of tokens to increase the allowance by.
318    */
319   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
320     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
321     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325   /**
326    * @dev Decrease the amount of tokens that an owner allowed to a spender.
327    *
328    * approve should be called when allowed[_spender] == 0. To decrement
329    * allowed value is better to use this function to avoid 2 calls (and wait until
330    * the first transaction is mined)
331    * From MonolithDAO Token.sol
332    * @param _spender The address which will spend the funds.
333    * @param _subtractedValue The amount of tokens to decrease the allowance by.
334    */
335   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
336     uint oldValue = allowed[msg.sender][_spender];
337     if (_subtractedValue > oldValue) {
338       allowed[msg.sender][_spender] = 0;
339     } else {
340       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
341     }
342     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343     return true;
344   }
345 
346 }
347 
348 contract MintableToken is StandardToken, Ownable {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   /**
361    * @dev Function to mint tokens
362    * @param _to The address that will receive the minted tokens.
363    * @param _amount The amount of tokens to mint.
364    * @return A boolean that indicates if the operation was successful.
365    */
366   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
367     totalSupply_ = totalSupply_.add(_amount);
368     balances[_to] = balances[_to].add(_amount);
369     Mint(_to, _amount);
370     Transfer(address(0), _to, _amount);
371     return true;
372   }
373 
374   /**
375    * @dev Function to stop minting new tokens.
376    * @return True if the operation was successful.
377    */
378   function finishMinting() onlyOwner canMint public returns (bool) {
379     mintingFinished = true;
380     MintFinished();
381     return true;
382   }
383 }
384 
385 contract FiduxaCoin is MintableToken {
386   string public name = "FiduxaCoin";
387   string public symbol = "FDU";
388   uint8 public decimals = 18;
389 }