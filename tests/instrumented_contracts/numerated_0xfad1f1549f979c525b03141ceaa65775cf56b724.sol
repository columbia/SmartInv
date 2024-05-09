1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.11;
7 
8 /*************************************************************************
9  * import "./StandardToken.sol" : start
10  *************************************************************************/
11 
12 
13 /*************************************************************************
14  * import "./SafeMath.sol" : start
15  *************************************************************************/
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23   function mul(uint256 a, uint256 b)  constant returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b)  constant returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b)  constant returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b)  constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 /*************************************************************************
48  * import "./SafeMath.sol" : end
49  *************************************************************************/
50 
51 
52 /**
53  * @title Standard ERC20 token
54  *
55  * @dev Implementation of the basic standard token.
56  * @dev https://github.com/ethereum/EIPs/issues/20
57  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
58  */
59 contract StandardToken {
60 
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 
64   uint256 public totalSupply;
65 
66   address public owner;
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70   event Pause();
71   event Unpause();
72 
73   bool public paused = false;
74 
75   using SafeMath for uint256;
76 
77   mapping (address => mapping (address => uint256)) internal allowed;
78   mapping(address => uint256) balances;
79 
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   function StandardToken() {
86     owner = msg.sender;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(msg.sender == owner);
94     _;
95   }
96 
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address newOwner) onlyOwner public {
103     require(newOwner != address(0));
104     OwnershipTransferred(owner, newOwner);
105     owner = newOwner;
106   }
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public constant returns (uint256 balance) {
130     return balances[_owner];
131   }
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value)  public whenNotPaused returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware - changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value)  public whenNotPaused returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifying the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    */
182   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
189     uint oldValue = allowed[msg.sender][_spender];
190     if (_subtractedValue > oldValue) {
191       allowed[msg.sender][_spender] = 0;
192     } else {
193       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194     }
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Modifier to make a function callable only when the contract is not paused.
201    */
202   modifier whenNotPaused() {
203     require(!paused);
204     _;
205   }
206 
207   /**
208    * @dev Modifier to make a function callable only when the contract is paused.
209    */
210   modifier whenPaused() {
211     require(paused);
212     _;
213   }
214 
215   /**
216    * @dev called by the owner to pause, triggers stopped state
217    */
218   function pause() onlyOwner whenNotPaused public {
219     paused = true;
220     Pause();
221   }
222 
223   /**
224    * @dev called by the owner to unpause, returns to normal state
225    */
226   function unpause() onlyOwner whenPaused public {
227     paused = false;
228     Unpause();
229   }
230 
231 }
232 /*************************************************************************
233  * import "./StandardToken.sol" : end
234  *************************************************************************/
235 
236 contract CoinsOpenToken is StandardToken
237 {
238 
239 
240   // Token informations
241   string public constant name = "COT";
242   string public constant symbol = "COT";
243   uint8 public constant decimals = 18;
244 
245   uint public totalSupply = 23000000000000000000000000;
246   uint256 public presaleSupply = 2000000000000000000000000;
247   uint256 public saleSupply = 13000000000000000000000000;
248   uint256 public reserveSupply = 8000000000000000000000000;
249 
250   uint256 public saleStartTime = 1511136000; /* Monday, November 20, 2017 12:00:00 AM */
251   uint256 public saleEndTime = 1513728000; /* Wednesday, December 20, 2017 12:00:00 AM */
252   uint256 public preSaleStartTime = 1508457600; /* Friday, October 20, 2017 12:00:00 AM */
253   uint256 public developerLock = 1500508800;
254 
255   uint256 public totalWeiRaised = 0;
256 
257   uint256 public preSaleTokenPrice = 1400;
258   uint256 public saleTokenPrice = 700;
259 
260   mapping (address => uint256) lastDividend;
261   mapping (uint256 =>uint256) dividendList;
262   uint256 currentDividend = 0;
263   uint256 dividendAmount = 0;
264 
265   struct BuyOrder {
266       uint256 wether;
267       address receiver;
268       address payer;
269       bool presale;
270   }
271 
272   /**
273    * event for token purchase logging
274    * @param purchaser who paid for the tokens
275    * @param beneficiary who got the tokens
276    * @param value weis paid for purchase
277    * @param amount amount of tokens purchased
278    */
279   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, bool presale);
280 
281   /**
282    * event for notifying of a Ether received to distribute as dividend
283    * @param amount of dividend received
284    */
285   event DividendAvailable(uint amount);
286 
287   /**
288    * event triggered when sending dividend to owner
289    * @param receiver who is receiving the payout
290    * @param amountofether paid received
291    */
292   event SendDividend(address indexed receiver, uint amountofether);
293 
294   function() payable {
295     if (msg.sender == owner) {
296       giveDividend();
297     } else {
298       buyTokens(msg.sender);
299     }
300   }
301 
302   function endSale() whenNotPaused {
303     require (!isInSale());
304     require (saleSupply != 0);
305     reserveSupply = reserveSupply.add(saleSupply);
306   }
307 
308   /**
309    * Buy tokens during the sale/presale
310    * @param _receiver who should receive the tokens
311    */
312   function buyTokens(address _receiver) payable whenNotPaused {
313     require (msg.value != 0);
314     require (_receiver != 0x0);
315     require (isInSale());
316     bool isPresale = isInPresale();
317     if (!isPresale) {
318       checkPresale();
319     }
320     uint256 tokenPrice = saleTokenPrice;
321     if (isPresale) {
322       tokenPrice = preSaleTokenPrice;
323     }
324     uint256 tokens = (msg.value).mul(tokenPrice);
325     if (isPresale) {
326       if (presaleSupply < tokens) {
327         msg.sender.transfer(msg.value);
328         return;
329       }
330     } else {
331       if (saleSupply < tokens) {
332         msg.sender.transfer(msg.value);
333         return;
334       }
335     }
336     checkDividend(_receiver);
337     TokenPurchase(msg.sender, _receiver, msg.value, tokens, isPresale);
338     totalWeiRaised = totalWeiRaised.add(msg.value);
339     Transfer(0x0, _receiver, tokens);
340     balances[_receiver] = balances[_receiver].add(tokens);
341     if (isPresale) {
342       presaleSupply = presaleSupply.sub(tokens);
343     } else {
344       saleSupply = saleSupply.sub(tokens);
345     }
346   }
347 
348   /**
349    * @dev Pay this function to add the dividends
350    */
351   function giveDividend() payable whenNotPaused {
352     require (msg.value != 0);
353     dividendAmount = dividendAmount.add(msg.value);
354     dividendList[currentDividend] = (msg.value).mul(10000000000).div(totalSupply);
355     currentDividend = currentDividend.add(1);
356     DividendAvailable(msg.value);
357   }
358 
359   /**
360    * @dev Returns true if we are still in pre sale period
361    * @param _account The address to check and send dividends
362    */
363   function checkDividend(address _account) whenNotPaused {
364     if (lastDividend[_account] != currentDividend) {
365       if (balanceOf(_account) != 0) {
366         uint256 toSend = 0;
367         for (uint i = lastDividend[_account]; i < currentDividend; i++) {
368           toSend += balanceOf(_account).mul(dividendList[i]).div(10000000000);
369         }
370         if (toSend > 0 && toSend <= dividendAmount) {
371           _account.transfer(toSend);
372           dividendAmount = dividendAmount.sub(toSend);
373           SendDividend(_account, toSend);
374         }
375       }
376       lastDividend[_account] = currentDividend;
377     }
378   }
379 
380   /**
381   * @dev transfer token for a specified address checking if they are dividends to pay
382   * @param _to The address to transfer to.
383   * @param _value The amount to be transferred.
384   */
385   function transfer(address _to, uint256 _value) public returns (bool) {
386     checkDividend(msg.sender);
387     return super.transfer(_to, _value);
388   }
389 
390   /**
391    * @dev Transfer tokens from one address to another checking if they are dividends to pay
392    * @param _from address The address which you want to send tokens from
393    * @param _to address The address which you want to transfer to
394    * @param _value uint256 the amount of tokens to be transferred
395    */
396   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
397     checkDividend(_from);
398     return super.transferFrom(_from, _to, _value);
399   }
400 
401   /**
402    * @dev Returns true if we are still in pre sale period
403    */
404   function isInPresale() constant returns (bool) {
405     return saleStartTime > now;
406   }
407 
408   /**
409    * @dev Returns true if we are still in sale period
410    */
411   function isInSale() constant returns (bool) {
412     return saleEndTime >= now && preSaleStartTime <= now;
413   }
414 
415   // @return true if the transaction can buy tokens
416   function checkPresale() internal {
417     if (!isInPresale() && presaleSupply > 0) {
418       saleSupply = saleSupply.add(presaleSupply);
419       presaleSupply = 0;
420     }
421   }
422 
423   /**
424    * Distribute tokens from the reserve
425    * @param _amount Amount to transfer
426    * @param _receiver Address of the receiver
427    */
428   function distributeReserveSupply(uint256 _amount, address _receiver) onlyOwner whenNotPaused {
429     require (_amount <= reserveSupply);
430     require (now >= developerLock);
431     checkDividend(_receiver);
432     balances[_receiver] = balances[_receiver].add(_amount);
433     reserveSupply.sub(_amount);
434     Transfer(0x0, _receiver, _amount);
435   }
436 
437   /**
438    * Withdraw some Ether from contract
439    */
440   function withdraw(uint _amount) onlyOwner {
441     require (_amount != 0);
442     require (_amount < this.balance);
443     (msg.sender).transfer(_amount);
444   }
445 
446   /**
447    * Withdraw Ether from contract
448    */
449   function withdrawEverything() onlyOwner {
450     (msg.sender).transfer(this.balance);
451   }
452 
453 }