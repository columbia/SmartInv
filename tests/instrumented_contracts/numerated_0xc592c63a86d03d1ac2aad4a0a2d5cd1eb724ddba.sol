1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal constant returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner public {
66     require(newOwner != address(0));
67     OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 
71 }
72 
73 /**
74  * @title Pausable
75  * @dev Base contract which allows children to implement an emergency stop mechanism.
76  */
77 contract Pausable is Ownable {
78   event Pause();
79   event Unpause();
80 
81   bool public paused = true;
82 
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is not paused.
86    */
87   modifier whenNotPaused() {
88     require(!paused);
89     _;
90   }
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is paused.
94    */
95   modifier whenPaused() {
96     require(paused);
97     _;
98   }
99 
100   /**
101    * @dev called by the owner to pause, triggers stopped state
102    */
103   function pause() onlyOwner whenNotPaused public {
104     paused = true;
105     Pause();
106   }
107 
108   /**
109    * @dev called by the owner to unpause, returns to normal state
110    */
111   function unpause() onlyOwner whenPaused public {
112     paused = false;
113     Unpause();
114   }
115 }
116 
117 contract Token {
118     uint256 public totalSupply;
119 
120     function balanceOf(address who) public constant returns (uint256);
121 
122     function transfer(address to, uint256 value) public returns (bool);
123 
124     function allowance(address owner, address spender) public constant returns (uint256);
125 
126     function transferFrom(address from, address to, uint256 value) public returns (bool);
127 
128     function approve(address spender, uint256 value) public returns (bool);
129 
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 
132     event Transfer(address indexed from, address indexed to, uint256 value);
133 }
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is Token, Pausable {
143 
144     using SafeMath for uint256;
145 
146     mapping (address => mapping (address => uint256)) allowed;
147 
148 
149     mapping (address => uint256) balances;
150 
151     /**
152     * @dev transfer token for a specified address
153     * @param _to The address to transfer to.
154     * @param _value The amount to be transferred.
155     */
156     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
157         require(_to != address(0));
158 
159         // SafeMath.sub will throw if there is not enough balance.
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         Transfer(msg.sender, _to, _value);
163         return true;
164     }
165 
166     /**
167     * @dev Gets the balance of the specified address.
168     * @param _owner The address to query the the balance of.
169     * @return An uint256 representing the amount owned by the passed address.
170     */
171     function balanceOf(address _owner) public constant returns (uint256 balance) {
172         return balances[_owner];
173     }
174 
175 
176     /**
177      * @dev Transfer tokens from one address to another
178      * @param _from address The address which you want to send tokens from
179      * @param _to address The address which you want to transfer to
180      * @param _value uint256 the amount of tokens to be transferred
181      */
182     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
183         require(_to != address(0));
184 
185         uint256 _allowance = allowed[_from][msg.sender];
186         balances[_from] = balances[_from].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         allowed[_from][msg.sender] = _allowance.sub(_value);
189         Transfer(_from, _to, _value);
190         return true;
191     }
192 
193     /**
194      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195      *
196      * Beware that changing an allowance with this method brings the risk that someone may use both the old
197      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200      * @param _spender The address which will spend the funds.
201      * @param _value The amount of tokens to be spent.
202      */
203     function approve(address _spender, uint256 _value) public returns (bool) {
204         allowed[msg.sender][_spender] = _value;
205         Approval(msg.sender, _spender, _value);
206         return true;
207     }
208 
209     /**
210      * @dev Function to check the amount of tokens that an owner allowed to a spender.
211      * @param _owner address The address which owns the funds.
212      * @param _spender address The address which will spend the funds.
213      * @return A uint256 specifying the amount of tokens still available for the spender.
214      */
215     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
216         return allowed[_owner][_spender];
217     }
218 
219     /**
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      */
225     function increaseApproval(address _spender, uint _addedValue)
226     returns (bool success) {
227         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232     function decreaseApproval(address _spender, uint _subtractedValue)
233     returns (bool success) {
234         uint oldValue = allowed[msg.sender][_spender];
235         if (_subtractedValue > oldValue) {
236             allowed[msg.sender][_spender] = 0;
237         }
238         else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245 }
246 
247 contract Status {
248     uint256 public endTimeTwo = 1512072000; // 11/30/2017 @ 8:00pm (UTC)
249     uint public weiRaised;
250 
251     function hasEnded() public constant returns (bool) {
252         return now > endTimeTwo;
253     }
254 }
255 
256 contract FinalizableCrowdsale is Ownable, Status {
257   using SafeMath for uint256;
258 
259   bool public isFinalized = false;
260 
261   event Finalized();
262 
263   /**
264    * @dev Must be called after crowdsale ends, to do some extra finalization
265    * work. Calls the contract's finalization function.
266    */
267   function finalize() onlyOwner  public {
268     require(!isFinalized);
269     require(hasEnded());
270 
271     finalization();
272     Finalized();
273 
274     isFinalized = true;
275   }
276 
277   /**
278    * @dev Can be overridden to add finalization logic. The overriding function
279    * should call super.finalization() to ensure the chain of finalization is
280    * executed entirely.
281    */
282   function finalization() internal {
283   }
284 }
285 
286 contract RefundVault is Ownable {
287   using SafeMath for uint256;
288 
289   enum State { Active, Refunding, Closed }
290 
291   mapping (address => uint256) public deposited;
292   address public escrow;
293   State public state;
294 
295   event Closed();
296   event RefundsEnabled();
297   event Refunded(address indexed beneficiary, uint256 weiAmount);
298 
299   function RefundVault(address _escrow) {
300     require(_escrow != 0x0);
301     escrow = _escrow;
302     state = State.Active;
303   }
304 
305   function deposit(address investor) onlyOwner public payable {
306     require(state == State.Active);
307     deposited[investor] = deposited[investor].add(msg.value);
308   }
309 
310   function close() onlyOwner public {
311     require(state == State.Active);
312     state = State.Closed;
313     Closed();
314     escrow.transfer(this.balance);
315   }
316 
317   function enableRefunds() onlyOwner public {
318     require(state == State.Active);
319     state = State.Refunding;
320     RefundsEnabled();
321   }
322 
323   function refund(address investor) public {
324     require(state == State.Refunding);
325     uint256 depositedValue = deposited[investor];
326     deposited[investor] = 0;
327     investor.transfer(depositedValue);
328     Refunded(investor, depositedValue);
329   }
330 }
331 
332 contract RefundableCrowdsale is FinalizableCrowdsale {
333   using SafeMath for uint256;
334 
335   // minimum amount of funds to be raised in weis
336   uint256 public goal = 5000 ether;
337 
338   // refund vault used to hold funds while crowdsale is running
339   RefundVault public vault;
340 
341   function RefundableCrowdsale(address _escrow) {
342     vault = new RefundVault(_escrow);
343   }
344 
345   // We're overriding the fund forwarding from Crowdsale.
346   // In addition to sending the funds, we want to call
347   // the RefundVault deposit function
348   function forwardFunds() internal {
349     vault.deposit.value(msg.value)(msg.sender);
350   }
351 
352   // if crowdsale is unsuccessful, investors can claim refunds here
353   function claimRefund() public {
354     require(isFinalized);
355     require(!goalReached());
356 
357     vault.refund(msg.sender);
358   }
359 
360   // vault finalization task, called when owner calls finalize()
361   function finalization() internal {
362     if (goalReached()) {
363       vault.close();
364     } else {
365       vault.enableRefunds();
366     }
367 
368     super.finalization();
369   }
370 
371   function goalReached() public constant returns (bool) {
372     return weiRaised >= goal;
373   }
374 
375 }
376 
377 contract LCD is StandardToken, Status, RefundableCrowdsale {
378 
379     string public constant name = "LCD Token";
380     string public constant symbol = "LCD";
381     uint256 public constant decimals = 2;
382     uint256 public constant tokenCreationCap = 100000000 * 10 ** decimals;
383     uint256 public constant tokenCreationCapOne = 75000000 * 10 ** decimals;
384     address public escrow;
385     // uint256 public startTimeOne = 1508227200; // 10/17/2017 @ 8:00am (UTC)
386        uint256 public startTimeOne = 1508140800; // 10/16/2017 @ 8:00am (UTC)    
387     uint256 public endTimeOne = 1509433200; // 10/31/2017 @ 7:00am (UTC)
388     uint256 public startTimeTwo = 1509480000; // 10/31/2017 @ 8:00pm (UTC)
389     uint256 public oneTokenInWei = 781250000000000;
390     Stage public currentStage = Stage.Two;
391 
392     event CreateLCD(address indexed _to, uint256 _value);
393     event PriceChanged(string _text, uint _newPrice);
394 
395     function LCD (address _escrow) FinalizableCrowdsale() RefundableCrowdsale(_escrow)
396     {
397         escrow = _escrow;
398         balances[escrow] = 50000000 * 10 ** decimals;
399         totalSupply = balances[escrow];
400     }
401 
402     enum Stage {
403         One,
404         Two
405     }
406 
407     function () payable {
408         createTokens();
409     }
410 
411     function createTokens() internal {
412         uint multiplier = 10 ** decimals;
413         if (now >= startTimeOne && now <= endTimeOne) {
414             uint256 tokens = msg.value.div(oneTokenInWei) * multiplier;
415             uint256 checkedSupply = totalSupply.add(tokens);
416             if(checkedSupply <= tokenCreationCapOne) {
417                 addTokens(tokens, 40);
418                 updateStage();
419             }
420         } else if (currentStage == Stage.Two || now >= startTimeTwo && now <= endTimeTwo) {
421             tokens = msg.value.div(oneTokenInWei) * multiplier;
422             checkedSupply = totalSupply.add(tokens);
423             if (checkedSupply <= tokenCreationCap) {
424                 addTokens(tokens, 0);
425             }
426         } else {
427             revert();
428         }
429     }
430 
431     function updateStage() internal {
432         if (totalSupply >= tokenCreationCapOne) {
433             currentStage = Stage.Two;
434         }
435     }
436 
437     function addTokens(uint256 tokens, uint sale) internal {
438         if (sale > 0) {
439             tokens += tokens / 100 * sale;
440         }
441         balances[msg.sender] += tokens;
442         totalSupply = totalSupply.add(tokens);
443         weiRaised += msg.value;
444         CreateLCD(msg.sender, tokens);
445         forwardFunds();
446     }
447 
448     function setTokenPrice(uint256 _tokenPrice) external onlyOwner {
449         oneTokenInWei = _tokenPrice;
450         PriceChanged("New price is", _tokenPrice);
451     }
452 
453     function changeStageTwo() external onlyOwner {
454         currentStage = Stage.Two;
455     }
456 
457     function destroy() onlyOwner external {
458        selfdestruct(escrow);
459     }
460 }