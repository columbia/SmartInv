1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract Token {
35     uint256 public totalSupply;
36     function balanceOf(address who) public constant returns (uint256);
37     function transfer(address to, uint256 value) public returns (bool);
38     function allowance(address owner, address spender) public constant returns (uint256);
39     function transferFrom(address from, address to, uint256 value) public returns (bool);
40     function approve(address spender, uint256 value) public returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 contract Ownable {
51   address public owner;
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) onlyOwner public {
75     require(newOwner != address(0));
76     owner = newOwner;
77   }
78 
79 }
80 
81 contract Pausable is Ownable {
82 
83   bool public endITO = false;
84 
85   uint public endDate = 1530360000;  // June 30 2018 Token transfer enable
86 
87   /**
88    * @dev modifier to allow actions only when the contract IS not paused
89    */
90   modifier whenNotPaused() {
91     require(now >= endDate || endITO);
92     _;
93   }
94 
95   function unPause() public onlyOwner returns (bool) {
96       endITO = true;
97       return endITO;
98   }
99 
100 }
101 
102 contract StandardToken is Token, Pausable {
103     using SafeMath for uint256;
104     mapping (address => mapping (address => uint256)) internal allowed;
105 
106   mapping(address => uint256) balances;
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
114     require(_to != address(0));
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public constant returns (uint256 balance) {
127     return balances[_owner];
128   }
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
138     require(_to != address(0));
139     require(_value <= allowed[_from][msg.sender]);
140 
141     balances[_from] = balances[_from].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    *
151    * Beware that changing an allowance with this method brings the risk that someone may use both the old
152    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    */
180   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
181     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
187     uint oldValue = allowed[msg.sender][_spender];
188     if (_subtractedValue > oldValue) {
189       allowed[msg.sender][_spender] = 0;
190     } else {
191       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192     }
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 }
197 
198 /**
199  * @title Burnable Token
200  * @dev Token that can be irreversibly burned (destroyed).
201  */
202 contract BurnableToken is StandardToken {
203 
204     event Burn(address indexed burner, uint256 value);
205 
206     /**
207      * @dev Burns a specific amount of tokens.
208      * @param _value The amount of token to be burned.
209      */
210     function burn(uint256 _value) public {
211         require(_value > 0);
212         require(_value <= balances[msg.sender]);
213 
214         address burner = msg.sender;
215         balances[burner] = balances[burner].sub(_value);
216         totalSupply = totalSupply.sub(_value);
217         Burn(burner, _value);
218     }
219 }
220 
221 contract KeeppetToken is BurnableToken {
222 
223     string public constant name = "KeepPet Token";
224     string public constant symbol = "PET";
225     uint8 public constant decimals = 0;
226 
227     uint256 public constant INITIAL_SUPPLY = 3500000;
228 
229     /**
230      * @dev Constructor that gives msg.sender all of existing tokens.
231      */
232     function KeeppetToken() public {
233         totalSupply = INITIAL_SUPPLY;
234         balances[owner] = INITIAL_SUPPLY;
235     }
236 
237     function sendTokens(address _to, uint _amount) external onlyOwner {
238         require(_amount <= balances[msg.sender]);
239         balances[msg.sender] -= _amount;
240         balances[_to] += _amount;
241         Transfer(msg.sender, _to, _amount);
242     }
243 }
244 
245 /**
246  * @title RefundVault
247  * @dev This contract is used for storing funds while a crowdsale
248  * is in progress. Supports refunding the money if crowdsale fails,
249  * and forwarding it if crowdsale is successful.
250  */
251 contract RefundVault is Ownable {
252   using SafeMath for uint256;
253 
254   enum State { Active, Refunding, Closed }
255 
256   mapping (address => uint256) public deposited;
257   address public wallet;
258   State public state;
259 
260   event Closed();
261   event RefundsEnabled();
262   event Refunded(address indexed beneficiary, uint256 weiAmount);
263 
264   function RefundVault(address _wallet) public {
265     require(_wallet != address(0));
266     wallet = _wallet;
267     state = State.Active;
268   }
269 
270   function deposit(address investor) onlyOwner public payable {
271     require(state == State.Active);
272     deposited[investor] = deposited[investor].add(msg.value);
273   }
274 
275   function close() onlyOwner public {
276     require(state == State.Active);
277     state = State.Closed;
278     Closed();
279     wallet.transfer(this.balance);
280   }
281 
282   function enableRefunds() onlyOwner public {
283     require(state == State.Active);
284     state = State.Refunding;
285     RefundsEnabled();
286   }
287 
288   function refund(address investor) public {
289     require(state == State.Refunding);
290     uint256 depositedValue = deposited[investor];
291     deposited[investor] = 0;
292     investor.transfer(depositedValue);
293     Refunded(investor, depositedValue);
294   }
295 }
296 
297 contract SalesManager is Ownable {
298     using SafeMath for uint256;
299 
300     /**
301      * Pre-ICO
302      * Start date 31 December 2017 (12:00 GMT)
303      * End date or Hard Cap,  15 January 2018 (12:00 GMT)
304      * Token amount 3500000
305      * min eth = 0,0002
306      * token price = 1,5$
307      * transfer to wallet = NEED wallet
308      * */
309     // TODO: set actual dates before deploy
310     uint public constant etherCost = 750;
311     uint public constant startDate = 1514721600;
312     uint public constant endDate = 1516017600;
313     uint256 public constant softCap = 250000 / etherCost * 1 ether;
314     uint256 public constant hardCap = 1050000 / etherCost * 1 ether;
315 
316     struct Stat {
317         uint256 currentFundraiser;
318         uint256 additionalEthAmount;
319         uint256 ethAmount;
320         uint txCounter;
321     }
322 
323     Stat public stat;
324 
325     // ETH 750$ 13.12.2017 token price 1.5$
326     // TODO: set actual price before deploy
327     uint256 public constant tokenPrice = uint256(15 * 1 ether).div(etherCost * 10);
328     RefundVault public refundVault;
329     KeeppetToken public keeppetToken;
330 
331     /**
332      * @dev modifier to allow actions only when Pre-ICO end date is now
333      */
334     modifier isFinished() {
335         require(now >= endDate);
336         _;
337     }
338 
339     function SalesManager(address wallet) public {
340         require(wallet != address(0));
341         keeppetToken = new KeeppetToken();
342         refundVault = new RefundVault(wallet);
343     }
344 
345     function () payable public {
346        require(msg.value >= 2 * 10**15  && now >= startDate && now < endDate);
347        require(stat.ethAmount + stat.additionalEthAmount < hardCap);
348        buyTokens();
349     }
350 
351     uint bonusX2Stage1 = softCap;
352     uint bonusX2Stage2 = 525000 / etherCost * 1 ether;
353     uint bonusX2Stage3 = 787500 / etherCost * 1 ether;
354     uint bonusX2Stage4 = hardCap;
355 
356     function checkBonus(uint256 amount) public constant returns(bool) {
357         uint256 current = stat.ethAmount + stat.additionalEthAmount;
358         uint256 withAmount = current.add(amount);
359 
360         return ((current < bonusX2Stage1 && bonusX2Stage1 <= withAmount)
361         || (current < bonusX2Stage2 && bonusX2Stage2 <= withAmount)
362         || (current < bonusX2Stage3 && bonusX2Stage3 <= withAmount)
363         || (current < bonusX2Stage4 && bonusX2Stage4 <= withAmount));
364     }
365 
366     uint private bonusPeriod = 1 days;
367 
368     function countMultiplyBonus(uint256 amount) internal returns (uint) {
369         if (now >= startDate && now <= startDate + bonusPeriod) { // From 31 december 2017 to 1 january 2018 (12:00 GMT) — x5
370             return 5;
371         }
372         if (now > startDate + bonusPeriod && now <= startDate + 2 * bonusPeriod) { // From 1 january 2017 to 2 january 2018 (12:00 GMT) — x4
373             return 4;
374         }
375         if (now > startDate + 2 * bonusPeriod && now <= startDate + 3 * bonusPeriod) { // From 2 january 2017 to 3 january 2018 (12:00 GMT) — x3
376             return 3;
377         }
378         if (now > startDate + 3 * bonusPeriod && now <= startDate + 4 * bonusPeriod) { // From 3 january 2017 to 4 january 2018 (12:00 GMT) — x2
379             return 2;
380         }
381         if (checkBonus(amount)) {
382             return 2;
383         }
384         return 1;
385     }
386 
387     function buyTokens() internal {
388         uint256 tokens = msg.value.div(tokenPrice);
389         uint256 balance = keeppetToken.balanceOf(this);
390         tokens = tokens.mul(countMultiplyBonus(msg.value));
391 
392         if (balance < tokens) {
393             uint256 tempTokenPrice = msg.value.div(tokens); // Temp token price for tokens which were bought.
394             uint256 toReturn = tempTokenPrice.mul(tokens.sub(balance)); // Amount for returing.
395             sendTokens(balance, msg.value - toReturn);
396             msg.sender.transfer(toReturn);
397             return;
398         }
399         sendTokens(tokens, msg.value);
400     }
401 
402     function sendTokens(uint256 _amount, uint256 _ethers) internal {
403         keeppetToken.sendTokens(msg.sender, _amount);
404         RefundVault refundVaultContract = RefundVault(refundVault);
405         stat.currentFundraiser += _amount;
406         stat.ethAmount += _ethers;
407         stat.txCounter += 1;
408         refundVaultContract.deposit.value(_ethers)(msg.sender);
409     }
410 
411     function sendTokensManually(address _to, uint256 ethAmount, uint multiplier) public onlyOwner {
412         require(multiplier < 6); // can be multiplier more then in five times.
413         require(_to != address(0) && now <= endDate + 3 days); // available to send 72 hours after endDate
414         uint256 tokens = ethAmount.div(tokenPrice).mul(multiplier);
415         keeppetToken.sendTokens(_to, tokens);
416         stat.currentFundraiser += tokens;
417         stat.additionalEthAmount += ethAmount;
418         stat.txCounter += 1;
419     }
420 
421     function checkFunds() public isFinished onlyOwner {
422         RefundVault refundVaultContract = RefundVault(refundVault);
423         uint256 leftValue = keeppetToken.balanceOf(this);
424         keeppetToken.burn(leftValue);
425         uint256 fullAmount = stat.additionalEthAmount.add(stat.ethAmount);
426         if (fullAmount < softCap) {
427             // If soft cap is not reached enable refunds
428             refundVaultContract.enableRefunds();
429         } else {
430             // Send eth to multisig
431             refundVaultContract.close();
432         }
433     }
434 
435     function unPauseToken() public onlyOwner {
436         require(keeppetToken.unPause());
437     }
438 }