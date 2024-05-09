1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // SencTokenSale - SENC Token Sale Contract
5 //
6 // Copyright (c) 2018 InfoCorp Technologies Pte Ltd.
7 // http://www.sentinel-chain.org/
8 //
9 // The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // Total tokens 500m
14 // * Founding Team 10% - 5 tranches of 20% of 50,000,000 in **arrears** every 24 weeks from the activation date.
15 // * Early Support 20% - 4 tranches of 25% of 100,000,000 in **advance** every 4 weeks from activation date.
16 // * Pre-sale 20% - 4 tranches of 25% of 100,000,000 in **advance** every 4 weeks from activation date.
17 //   * To be separated into ~ 28 presale addresses
18 // ----------------------------------------------------------------------------
19 
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26   function Ownable() public {
27     owner = msg.sender;
28   }
29 
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 contract Pausable is Ownable {
44   event Pause();
45   event Unpause();
46 
47   bool public paused = false;
48 
49   modifier whenNotPaused() {
50     require(!paused);
51     _;
52   }
53 
54   modifier whenPaused() {
55     require(paused);
56     _;
57   }
58 
59   function pause() onlyOwner whenNotPaused public {
60     paused = true;
61     Pause();
62   }
63 
64   function unpause() onlyOwner whenPaused public {
65     paused = false;
66     Unpause();
67   }
68 }
69 
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) public view returns (uint256);
79   function transferFrom(address from, address to, uint256 value) public returns (bool);
80   function approve(address spender, uint256 value) public returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   function approve(address _spender, uint256 _value) public returns (bool) {
129     allowed[msg.sender][_spender] = _value;
130     Approval(msg.sender, _spender, _value);
131     return true;
132   }
133  
134   function allowance(address _owner, address _spender) public view returns (uint256) {
135     return allowed[_owner][_spender];
136   }
137 
138   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
139     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
140     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141     return true;
142   }
143 
144   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
145     uint oldValue = allowed[msg.sender][_spender];
146     if (_subtractedValue > oldValue) {
147       allowed[msg.sender][_spender] = 0;
148     } else {
149       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
150     }
151     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154 
155 }
156 
157 contract PausableToken is StandardToken, Pausable {
158 
159   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
160     return super.transfer(_to, _value);
161   }
162 
163   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
164     return super.transferFrom(_from, _to, _value);
165   }
166 
167   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
168     return super.approve(_spender, _value);
169   }
170 
171   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
172     return super.increaseApproval(_spender, _addedValue);
173   }
174 
175   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
176     return super.decreaseApproval(_spender, _subtractedValue);
177   }
178 }
179 
180 contract OperatableBasic {
181     function setPrimaryOperator (address addr) public;
182     function setSecondaryOperator (address addr) public;
183     function isPrimaryOperator(address addr) public view returns (bool);
184     function isSecondaryOperator(address addr) public view returns (bool);
185 }
186 
187 contract Operatable is Ownable, OperatableBasic {
188     address public primaryOperator;
189     address public secondaryOperator;
190 
191     modifier canOperate() {
192         require(msg.sender == primaryOperator || msg.sender == secondaryOperator || msg.sender == owner);
193         _;
194     }
195 
196     function Operatable() public {
197         primaryOperator = owner;
198         secondaryOperator = owner;
199     }
200 
201     function setPrimaryOperator (address addr) public onlyOwner {
202         primaryOperator = addr;
203     }
204 
205     function setSecondaryOperator (address addr) public onlyOwner {
206         secondaryOperator = addr;
207     }
208 
209     function isPrimaryOperator(address addr) public view returns (bool) {
210         return (addr == primaryOperator);
211     }
212 
213     function isSecondaryOperator(address addr) public view returns (bool) {
214         return (addr == secondaryOperator);
215     }
216 }
217 
218 contract Salvageable is Operatable {
219     // Salvage other tokens that are accidentally sent into this token
220     function emergencyERC20Drain(ERC20 oddToken, uint amount) public canOperate {
221         if (address(oddToken) == address(0)) {
222             owner.transfer(amount);
223             return;
224         }
225         oddToken.transfer(owner, amount);
226     }
227 }
228 
229 library SafeMath {
230 
231   /**
232   * @dev Multiplies two numbers, throws on overflow.
233   */
234   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
235     if (a == 0) {
236       return 0;
237     }
238     uint256 c = a * b;
239     assert(c / a == b);
240     return c;
241   }
242 
243   /**
244   * @dev Integer division of two numbers, truncating the quotient.
245   */
246   function div(uint256 a, uint256 b) internal pure returns (uint256) {
247     // assert(b > 0); // Solidity automatically throws when dividing by 0
248     uint256 c = a / b;
249     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
250     return c;
251   }
252 
253   /**
254   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
255   */
256   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
257     assert(b <= a);
258     return a - b;
259   }
260 
261   /**
262   * @dev Adds two numbers, throws on overflow.
263   */
264   function add(uint256 a, uint256 b) internal pure returns (uint256) {
265     uint256 c = a + b;
266     assert(c >= a);
267     return c;
268   }
269 }
270 
271 contract SencTokenConfig {
272     string public constant NAME = "Sentinel Chain Token";
273     string public constant SYMBOL = "SENC";
274     uint8 public constant DECIMALS = 18;
275     uint public constant DECIMALSFACTOR = 10 ** uint(DECIMALS);
276     uint public constant TOTALSUPPLY = 500000000 * DECIMALSFACTOR;
277 }
278 
279 contract SencToken is PausableToken, SencTokenConfig, Salvageable {
280     using SafeMath for uint;
281 
282     string public name = NAME;
283     string public symbol = SYMBOL;
284     uint8 public decimals = DECIMALS;
285     bool public mintingFinished = false;
286 
287     event Mint(address indexed to, uint amount);
288     event MintFinished();
289 
290     modifier canMint() {
291         require(!mintingFinished);
292         _;
293     }
294 
295     function SencToken() public {
296         paused = true;
297     }
298 
299     function pause() onlyOwner public {
300         revert();
301     }
302 
303     function unpause() onlyOwner public {
304         super.unpause();
305     }
306 
307     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
308         require(totalSupply_.add(_amount) <= TOTALSUPPLY);
309         totalSupply_ = totalSupply_.add(_amount);
310         balances[_to] = balances[_to].add(_amount);
311         Mint(_to, _amount);
312         Transfer(address(0), _to, _amount);
313         return true;
314     }
315 
316     function finishMinting() onlyOwner canMint public returns (bool) {
317         mintingFinished = true;
318         MintFinished();
319         return true;
320     }
321 
322     // Airdrop tokens from bounty wallet to contributors as long as there are enough balance
323     function airdrop(address bountyWallet, address[] dests, uint[] values) public onlyOwner returns (uint) {
324         require(dests.length == values.length);
325         uint i = 0;
326         while (i < dests.length && balances[bountyWallet] >= values[i]) {
327             this.transferFrom(bountyWallet, dests[i], values[i]);
328             i += 1;
329         }
330         return(i);
331     }
332 }
333 
334 contract SencVesting is Salvageable {
335     using SafeMath for uint;
336 
337     SencToken public token;
338 
339     bool public started = false;
340     uint public startTimestamp;
341     uint public totalTokens;
342 
343     struct Entry {
344         uint tokens;
345         bool advance;
346         uint periods;
347         uint periodLength;
348         uint withdrawn;
349     }
350     mapping (address => Entry) public entries;
351 
352     event NewEntry(address indexed beneficiary, uint tokens, bool advance, uint periods, uint periodLength);
353     event Withdrawn(address indexed beneficiary, uint withdrawn);
354 
355     function SencVesting(SencToken _token) public {
356         require(_token != address(0));
357         token = _token;
358     }
359 
360     function addEntryIn4WeekPeriods(address beneficiary, uint tokens, bool advance, uint periods) public onlyOwner {
361         addEntry(beneficiary, tokens, advance, periods, 4 * 7 days);
362     }
363     function addEntryIn24WeekPeriods(address beneficiary, uint tokens, bool advance, uint periods) public onlyOwner {
364         addEntry(beneficiary, tokens, advance, periods, 24 * 7 days);
365     }
366     function addEntryInSecondsPeriods(address beneficiary, uint tokens, bool advance, uint periods, uint secondsPeriod) public onlyOwner {
367         addEntry(beneficiary, tokens, advance, periods, secondsPeriod);
368     }
369 
370     function addEntry(address beneficiary, uint tokens, bool advance, uint periods, uint periodLength) internal {
371         require(!started);
372         require(beneficiary != address(0));
373         require(tokens > 0);
374         require(periods > 0);
375         require(entries[beneficiary].tokens == 0);
376         entries[beneficiary] = Entry({
377             tokens: tokens,
378             advance: advance,
379             periods: periods,
380             periodLength: periodLength,
381             withdrawn: 0
382         });
383         totalTokens = totalTokens.add(tokens);
384         NewEntry(beneficiary, tokens, advance, periods, periodLength);
385     }
386 
387     function start() public onlyOwner {
388         require(!started);
389         require(totalTokens > 0);
390         require(totalTokens == token.balanceOf(this));
391         started = true;
392         startTimestamp = now;
393     }
394 
395     function vested(address beneficiary, uint time) public view returns (uint) {
396         uint result = 0;
397         if (startTimestamp > 0 && time >= startTimestamp) {
398             Entry memory entry = entries[beneficiary];
399             if (entry.tokens > 0) {
400                 uint periods = time.sub(startTimestamp).div(entry.periodLength);
401                 if (entry.advance) {
402                     periods++;
403                 }
404                 if (periods >= entry.periods) {
405                     result = entry.tokens;
406                 } else {
407                     result = entry.tokens.mul(periods).div(entry.periods);
408                 }
409             }
410         }
411         return result;
412     }
413 
414     function withdrawable(address beneficiary) public view returns (uint) {
415         uint result = 0;
416         Entry memory entry = entries[beneficiary];
417         if (entry.tokens > 0) {
418             uint _vested = vested(beneficiary, now);
419             result = _vested.sub(entry.withdrawn);
420         }
421         return result;
422     }
423 
424     function withdraw() public {
425         withdrawInternal(msg.sender);
426     }
427 
428     function withdrawOnBehalfOf(address beneficiary) public onlyOwner {
429         withdrawInternal(beneficiary);
430     }
431 
432     function withdrawInternal(address beneficiary) internal {
433         Entry storage entry = entries[beneficiary];
434         require(entry.tokens > 0);
435         uint _vested = vested(beneficiary, now);
436         uint _withdrawn = entry.withdrawn;
437         require(_vested > _withdrawn);
438         uint _withdrawable = _vested.sub(_withdrawn);
439         entry.withdrawn = _vested;
440         require(token.transfer(beneficiary, _withdrawable));
441         Withdrawn(beneficiary, _withdrawable);
442     }
443 
444     function tokens(address beneficiary) public view returns (uint) {
445         return entries[beneficiary].tokens;
446     }
447 
448     function withdrawn(address beneficiary) public view returns (uint) {
449         return entries[beneficiary].withdrawn;
450     }
451 
452     function emergencyERC20Drain(ERC20 oddToken, uint amount) public canOperate {
453         // Cannot withdraw SencToken if vesting started
454         require(!started || address(oddToken) != address(token));
455         super.emergencyERC20Drain(oddToken,amount);
456     }
457 }