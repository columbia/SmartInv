1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   /**
45   * @dev transfer token for a specified address
46   * @param _to The address to transfer to.
47   * @param _value The amount to be transferred.
48   */
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52 
53     // SafeMath.sub will throw if there is not enough balance.
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59 
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public view returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) internal allowed;
81 
82 
83   /**
84    * @dev Transfer tokens from one address to another
85    * @param _from address The address which you want to send tokens from
86    * @param _to address The address which you want to transfer to
87    * @param _value uint256 the amount of tokens to be transferred
88    */
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   /**
102    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
103    *
104    * Beware that changing an allowance with this method brings the risk that someone may use both the old
105    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
106    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
107    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108    * @param _spender The address which will spend the funds.
109    * @param _value The amount of tokens to be spent.
110    */
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) public view returns (uint256) {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * approve should be called when allowed[_spender] == 0. To increment
129    * allowed value is better to use this function to avoid 2 calls (and wait until
130    * the first transaction is mined)
131    * From MonolithDAO Token.sol
132    */
133   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
134     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
135     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
140     uint oldValue = allowed[msg.sender][_spender];
141     if (_subtractedValue > oldValue) {
142       allowed[msg.sender][_spender] = 0;
143     } else {
144       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145     }
146     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149 
150 }
151 
152 contract STEAK is StandardToken {
153 
154     uint256 public initialSupply;
155     // the original supply, just for posterity, since totalSupply
156     //  will decrement on burn
157 
158     string public constant name   = "$TEAK";
159     string public constant symbol = "$TEAK";
160     // ^ whether or not to include the `$` here will probably be contested
161     //   but it's more important to me that the joke is obvious, even if it's overdone
162     //   by displaying as `$$TEAK`
163     uint8 public constant decimals = 18;
164     //  (^ can we please get around to standardizing on 18 decimals?)
165 
166     address public tokenSaleContract;
167 
168     modifier validDestination(address to)
169     {
170         require(to != address(this));
171         _;
172     }
173 
174     function STEAK(uint tokenTotalAmount)
175     public
176     {
177         initialSupply = tokenTotalAmount * (10 ** uint256(decimals));
178         totalSupply = initialSupply;
179 
180         // Mint all tokens to crowdsale.
181         balances[msg.sender] = totalSupply;
182         Transfer(address(0x0), msg.sender, totalSupply);
183 
184         tokenSaleContract = msg.sender;
185     }
186 
187     /**
188      * @dev override transfer token for a specified address to add validDestination
189      * @param _to The address to transfer to.
190      * @param _value The amount to be transferred.
191      */
192     function transfer(address _to, uint _value)
193         public
194         validDestination(_to)
195         returns (bool)
196     {
197         return super.transfer(_to, _value);
198     }
199 
200     /**
201      * @dev override transferFrom token for a specified address to add validDestination
202      * @param _from The address to transfer from.
203      * @param _to The address to transfer to.
204      * @param _value The amount to be transferred.
205      */
206     function transferFrom(address _from, address _to, uint _value)
207         public
208         validDestination(_to)
209         returns (bool)
210     {
211         return super.transferFrom(_from, _to, _value);
212     }
213 
214     event Burn(address indexed _burner, uint _value);
215 
216     /**
217      * @dev burn tokens
218      * @param _value The amount to be burned.
219      * @return always true (necessary in case of override)
220      */
221     function burn(uint _value)
222         public
223         returns (bool)
224     {
225         balances[msg.sender] = balances[msg.sender].sub(_value);
226         totalSupply = totalSupply.sub(_value);
227         Burn(msg.sender, _value);
228         Transfer(msg.sender, address(0x0), _value);
229         return true;
230     }
231 
232     /**
233      * @dev burn tokens on the behalf of someone
234      * @param _from The address of the owner of the token.
235      * @param _value The amount to be burned.
236      * @return always true (necessary in case of override)
237      */
238     function burnFrom(address _from, uint256 _value)
239         public
240         returns(bool)
241     {
242         assert(transferFrom(_from, msg.sender, _value));
243         return burn(_value);
244     }
245 }
246 
247 contract StandardCrowdsale {
248     using SafeMath for uint256;
249 
250     // The token being sold
251     StandardToken public token; // Request Modification : change to not mintable
252 
253     // start and end timestamps where investments are allowed (both inclusive)
254     uint256 public startTime;
255     uint256 public endTime;
256 
257     // address where funds are collected
258     address public wallet;
259 
260     // how many token units a buyer gets per wei
261     uint256 public rate;
262 
263     // amount of raised money in wei
264     uint256 public weiRaised;
265 
266     /**
267      * event for token purchase logging
268      * @param purchaser who paid for the tokens
269      * @param value weis paid for purchase
270      * @param amount amount of tokens purchased
271      */
272     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
273 
274     function StandardCrowdsale(
275         uint256 _startTime,
276         uint256 _endTime,
277         uint256 _rate,
278         address _wallet)
279         public
280     {
281         // require(_startTime >= now); // Steak Network Modification
282         require(_endTime >= _startTime);
283         require(_rate > 0);
284         require(_wallet != 0x0);
285 
286         startTime = _startTime;
287         endTime = _endTime;
288         rate = _rate;
289         wallet = _wallet;
290 
291         token = createTokenContract(); // Request Modification : change to StandardToken + position
292     }
293 
294     // creates the token to be sold.
295     // Request Modification : change to StandardToken
296     // override this method to have crowdsale of a specific mintable token.
297     function createTokenContract()
298         internal
299         returns(StandardToken)
300     {
301         return new StandardToken();
302     }
303 
304     // fallback function can be used to buy tokens
305     function ()
306         public
307         payable
308     {
309         buyTokens();
310     }
311 
312     // low level token purchase function
313     // Request Modification : change to not mint but transfer from this contract
314     function buyTokens()
315         public
316         payable
317     {
318         require(validPurchase());
319 
320         uint256 weiAmount = msg.value;
321 
322         // calculate token amount to be created
323         uint256 tokens = weiAmount.mul(rate);
324 
325         // update state
326         weiRaised = weiRaised.add(weiAmount);
327 
328         require(token.transfer(msg.sender, tokens)); // Request Modification : changed here - tranfer instead of mintable
329         TokenPurchase(msg.sender, weiAmount, tokens);
330 
331         forwardFunds();
332     }
333 
334     // send ether to the fund collection wallet
335     // override to create custom fund forwarding mechanisms
336     function forwardFunds()
337         internal
338     {
339         wallet.transfer(msg.value);
340     }
341 
342     // @return true if the transaction can buy tokens
343     function validPurchase()
344         internal
345         returns(bool)
346     {
347         bool withinPeriod = now >= startTime && now <= endTime;
348         bool nonZeroPurchase = msg.value != 0;
349         return withinPeriod && nonZeroPurchase;
350     }
351 
352     // @return true if crowdsale event has ended
353     function hasEnded()
354         public
355         constant
356         returns(bool)
357     {
358         return now > endTime;
359     }
360 
361     modifier onlyBeforeSale() {
362         require(now < startTime);
363         _;
364     }
365 }
366 
367 contract CappedCrowdsale is StandardCrowdsale {
368   using SafeMath for uint256;
369 
370   uint256 public cap;
371 
372   function CappedCrowdsale(uint256 _cap) public {
373     require(_cap > 0);
374     cap = _cap;
375   }
376 
377   // overriding Crowdsale#validPurchase to add extra cap logic
378   // @return true if investors can buy at the moment
379   // Request Modification : delete constant because needed in son contract
380   function validPurchase() internal returns (bool) {
381     bool withinCap = weiRaised.add(msg.value) <= cap;
382     return super.validPurchase() && withinCap;
383   }
384 
385   // overriding Crowdsale#hasEnded to add cap logic
386   // @return true if crowdsale event has ended
387   function hasEnded() public constant returns (bool) {
388     bool capReached = weiRaised >= cap;
389     return super.hasEnded() || capReached;
390   }
391 
392 }
393 
394 contract InfiniteCappedCrowdsale is StandardCrowdsale, CappedCrowdsale {
395     using SafeMath for uint256;
396 
397     /**
398         @param _cap the maximum number of tokens
399         @param _rate tokens per wei received
400         @param _wallet the wallet that receives the funds
401      */
402     function InfiniteCappedCrowdsale(uint256 _cap, uint256 _rate, address _wallet)
403         CappedCrowdsale(_cap)
404         StandardCrowdsale(0, uint256(int256(-1)), _rate, _wallet)
405         public
406     {
407 
408     }
409 }
410 
411 contract ICS is InfiniteCappedCrowdsale {
412 
413     uint256 public constant TOTAL_SUPPLY = 975220000000;
414     uint256 public constant ARBITRARY_VALUATION_IN_ETH = 33;
415     // ^ arbitrary valuation of ~$10k
416     uint256 public constant ETH_TO_WEI = (10 ** 18);
417     uint256 public constant TOKEN_RATE = (TOTAL_SUPPLY / ARBITRARY_VALUATION_IN_ETH);
418     // 29552121212 $TEAK per wei
419 
420 
421     function ICS(address _wallet)
422         InfiniteCappedCrowdsale(ARBITRARY_VALUATION_IN_ETH * ETH_TO_WEI, TOKEN_RATE, _wallet)
423         public
424     {
425 
426     }
427 
428     function createTokenContract() internal returns (StandardToken) {
429         return new STEAK(TOTAL_SUPPLY);
430     }
431 }