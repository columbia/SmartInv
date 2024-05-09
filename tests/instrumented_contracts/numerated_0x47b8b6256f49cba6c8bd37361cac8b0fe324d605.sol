1 pragma solidity 0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113 
114     uint256 _allowance = allowed[_from][msg.sender];
115 
116     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117     // require (_value <= _allowance);
118 
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowed[_from][msg.sender] = _allowance.sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    *
129    * Beware that changing an allowance with this method brings the risk that someone may use both the old
130    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152   /**
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval (address _spender, uint _addedValue)
159     returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval (address _spender, uint _subtractedValue)
166     returns (bool success) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 contract LordCoin is StandardToken {
180   using SafeMath for uint256;
181 
182   string public name = "Lord Coin";
183   string public symbol = "LC";
184   uint256 public decimals = 18;
185   uint256 public INITIAL_SUPPLY = 20000000 * 1 ether;
186 
187   event Burn(address indexed from, uint256 value);
188 
189   function LordCoin() {
190     totalSupply = INITIAL_SUPPLY;
191     balances[msg.sender] = INITIAL_SUPPLY;
192   }
193 
194   function burn(uint256 _value) returns (bool success) {
195     require(balances[msg.sender] >= _value);
196     balances[msg.sender] = balances[msg.sender].sub(_value);
197     totalSupply = totalSupply.sub(_value);
198     Burn(msg.sender, _value);
199     return true;
200   }
201 }
202 
203 /**
204  * @title Ownable
205  * @dev The Ownable contract has an owner address, and provides basic authorization control
206  * functions, this simplifies the implementation of "user permissions".
207  */
208 contract Ownable {
209   address public owner;
210 
211 
212   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214 
215   /**
216    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
217    * account.
218    */
219   function Ownable() {
220     owner = msg.sender;
221   }
222 
223 
224   /**
225    * @dev Throws if called by any account other than the owner.
226    */
227   modifier onlyOwner() {
228     require(msg.sender == owner);
229     _;
230   }
231 
232 
233   /**
234    * @dev Allows the current owner to transfer control of the contract to a newOwner.
235    * @param newOwner The address to transfer ownership to.
236    */
237   function transferOwnership(address newOwner) onlyOwner public {
238     require(newOwner != address(0));
239     OwnershipTransferred(owner, newOwner);
240     owner = newOwner;
241   }
242 
243 }
244 
245 /**
246  * @title Pausable
247  * @dev Base contract which allows children to implement an emergency stop mechanism.
248  */
249 contract Pausable is Ownable {
250   event Pause();
251   event Unpause();
252 
253   bool public paused = false;
254 
255 
256   /**
257    * @dev Modifier to make a function callable only when the contract is not paused.
258    */
259   modifier whenNotPaused() {
260     require(!paused);
261     _;
262   }
263 
264   /**
265    * @dev Modifier to make a function callable only when the contract is paused.
266    */
267   modifier whenPaused() {
268     require(paused);
269     _;
270   }
271 
272   /**
273    * @dev called by the owner to pause, triggers stopped state
274    */
275   function pause() onlyOwner whenNotPaused public {
276     paused = true;
277     Pause();
278   }
279 
280   /**
281    * @dev called by the owner to unpause, returns to normal state
282    */
283   function unpause() onlyOwner whenPaused public {
284     paused = false;
285     Unpause();
286   }
287 }
288 
289 contract LordCoinICO is Pausable {
290     using SafeMath for uint256;
291 
292     string public constant name = "Lord Coin ICO";
293 
294     LordCoin public LC;
295     address public beneficiary;
296 
297     uint256 public priceETH;
298     uint256 public priceLC;
299 
300     uint256 public weiRaised = 0;
301     uint256 public investorCount = 0;
302     uint256 public lcSold = 0;
303     uint256 public manualLCs = 0;
304 
305     uint public startTime;
306     uint public endTime;
307     uint public time1;
308     uint public time2;
309 
310     uint public constant period2Numerator = 110;
311     uint public constant period2Denominator = 100;
312     uint public constant period3Numerator = 125;
313     uint public constant period3Denominator = 100; 
314 
315     uint256 public constant premiumValue = 500 * 1 ether;
316 
317     bool public crowdsaleFinished = false;
318 
319     event GoalReached(uint256 amountRaised);
320     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
321 
322     modifier onlyAfter(uint time) {
323         require(getCurrentTime() > time);
324         _;
325     }
326 
327     modifier onlyBefore(uint time) {
328         require(getCurrentTime() < time);
329         _;
330     }
331 
332     function LordCoinICO (
333         address _lcAddr,
334         address _beneficiary,
335         uint256 _priceETH,
336         uint256 _priceLC,
337 
338         uint _startTime,
339         uint _period1,
340         uint _period2,
341         uint _duration
342     ) public {
343         LC = LordCoin(_lcAddr);
344         beneficiary = _beneficiary;
345         priceETH = _priceETH;
346         priceLC = _priceLC;
347 
348         startTime = _startTime;
349         time1 = startTime + _period1 * 1 hours;
350         time2 = time1 + _period2 * 1 hours;
351         endTime = _startTime + _duration * 1 days;
352     }
353 
354     function () external payable whenNotPaused {
355         require(msg.value >= 0.01 * 1 ether);
356         doPurchase();
357     }
358 
359     function withdraw(uint256 _value) external onlyOwner {
360         beneficiary.transfer(_value);
361     }
362 
363     function finishCrowdsale() external onlyOwner {
364         LC.transfer(beneficiary, LC.balanceOf(this));
365         crowdsaleFinished = true;
366     }
367 
368     function doPurchase() private onlyAfter(startTime) onlyBefore(endTime) {
369         require(!crowdsaleFinished);
370         require(msg.sender != address(0));
371 
372         uint256 lcCount = msg.value.mul(priceLC).div(priceETH);
373 
374         if (getCurrentTime() > time1 && getCurrentTime() <= time2 && msg.value < premiumValue) {
375             lcCount = lcCount.mul(period2Denominator).div(period2Numerator);
376         }
377 
378         if (getCurrentTime() > time2 && msg.value < premiumValue) {
379             lcCount = lcCount.mul(period3Denominator).div(period3Numerator);
380         }
381 
382         uint256 _wei = msg.value;
383 
384         if (LC.balanceOf(this) < lcCount) {
385           uint256 expectingLCCount = lcCount;
386           lcCount = LC.balanceOf(this);
387           _wei = msg.value.mul(lcCount).div(expectingLCCount);
388           msg.sender.transfer(msg.value.sub(_wei));
389         }
390 
391         transferLCs(msg.sender, _wei, lcCount);
392     }
393 
394     function transferLCs(address _sender, uint256 _wei, uint256 _lcCount) private {
395 
396         if (LC.balanceOf(_sender) == 0) investorCount++;
397 
398         LC.transfer(_sender, _lcCount);
399 
400         lcSold = lcSold.add(_lcCount);
401         weiRaised = weiRaised.add(_wei);
402 
403         NewContribution(_sender, _lcCount, _wei);
404 
405         if (LC.balanceOf(this) == 0) {
406             GoalReached(weiRaised);
407         }
408 
409     }
410 
411     function manualSell(address _sender, uint256 _value) external onlyOwner {
412         transferLCs(_sender, 0, _value);
413         manualLCs = manualLCs.add(_value);
414     }
415 
416 
417 
418     function getCurrentTime() internal constant returns(uint256) {
419         return now;
420     }
421 }