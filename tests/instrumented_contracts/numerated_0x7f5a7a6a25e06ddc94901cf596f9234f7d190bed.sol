1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract Ownable {
38     address public owner;
39 
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46      * account.
47      */
48     function Ownable() public {
49         owner = msg.sender;
50     }
51 
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) public onlyOwner {
67         require(newOwner != address(0));
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 
72 }
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79     event Pause();
80     event Unpause();
81 
82     bool public paused = false;
83 
84 
85     /**
86      * @dev Modifier to make a function callable only when the contract is not paused.
87      */
88     modifier whenNotPaused() {
89         require(!paused);
90         _;
91     }
92 
93     /**
94      * @dev Modifier to make a function callable only when the contract is paused.
95      */
96     modifier whenPaused() {
97         require(paused);
98         _;
99     }
100 
101     /**
102      * @dev called by the owner to pause, triggers stopped state
103      */
104     function pause() onlyOwner whenNotPaused public {
105         paused = true;
106         Pause();
107     }
108 
109     /**
110      * @dev called by the owner to unpause, returns to normal state
111      */
112     function unpause() onlyOwner whenPaused public {
113         paused = false;
114         Unpause();
115     }
116 }
117 
118 contract ERC20Basic {
119     uint256 public totalSupply;
120 
121     function balanceOf(address who) public view returns (uint256);
122 
123     function transfer(address to, uint256 value) public returns (bool);
124 
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 
129 contract ERC20 is ERC20Basic {
130     function allowance(address owner, address spender) public view returns (uint256);
131 
132     function transferFrom(address from, address to, uint256 value) public returns (bool);
133 
134     function approve(address spender, uint256 value) public returns (bool);
135 
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 contract BasicToken is ERC20Basic {
140     using SafeMath for uint256;
141 
142     mapping(address => uint256) balances;
143 
144     /**
145     * @dev transfer token for a specified address
146     * @param _to The address to transfer to.
147     * @param _value The amount to be transferred.
148     */
149     function transfer(address _to, uint256 _value) public returns (bool) {
150         require(_to != address(0));
151         require(_value <= balances[msg.sender]);
152 
153         // SafeMath.sub will throw if there is not enough balance.
154         balances[msg.sender] = balances[msg.sender].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         Transfer(msg.sender, _to, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Gets the balance of the specified address.
162     * @param _owner The address to query the the balance of.
163     * @return An uint256 representing the amount owned by the passed address.
164     */
165     function balanceOf(address _owner) public view returns (uint256 balance) {
166         return balances[_owner];
167     }
168 
169 }
170 
171 contract StandardToken is ERC20, BasicToken {
172 
173     mapping(address => mapping(address => uint256)) internal allowed;
174 
175 
176     /**
177      * @dev Transfer tokens from one address to another
178      * @param _from address The address which you want to send tokens from
179      * @param _to address The address which you want to transfer to
180      * @param _value uint256 the amount of tokens to be transferred
181      */
182     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183         require(_to != address(0));
184         require(_value <= balances[_from]);
185         require(_value <= allowed[_from][msg.sender]);
186 
187         balances[_from] = balances[_from].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190         Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196      *
197      * Beware that changing an allowance with this method brings the risk that someone may use both the old
198      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      * @param _spender The address which will spend the funds.
202      * @param _value The amount of tokens to be spent.
203      */
204     function approve(address _spender, uint256 _value) public returns (bool) {
205         allowed[msg.sender][_spender] = _value;
206         Approval(msg.sender, _spender, _value);
207         return true;
208     }
209 
210     /**
211      * @dev Function to check the amount of tokens that an owner allowed to a spender.
212      * @param _owner address The address which owns the funds.
213      * @param _spender address The address which will spend the funds.
214      * @return A uint256 specifying the amount of tokens still available for the spender.
215      */
216     function allowance(address _owner, address _spender) public view returns (uint256) {
217         return allowed[_owner][_spender];
218     }
219 
220     /**
221      * approve should be called when allowed[_spender] == 0. To increment
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      */
226     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
227         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
233         uint oldValue = allowed[msg.sender][_spender];
234         if (_subtractedValue > oldValue) {
235             allowed[msg.sender][_spender] = 0;
236         } else {
237             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238         }
239         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240         return true;
241     }
242 
243 }
244 
245 contract PausableToken is StandardToken, Pausable {
246 
247     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
248         return super.transfer(_to, _value);
249     }
250 
251     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
252         return super.transferFrom(_from, _to, _value);
253     }
254 
255     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
256         return super.approve(_spender, _value);
257     }
258 
259     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
260         return super.increaseApproval(_spender, _addedValue);
261     }
262 
263     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
264         return super.decreaseApproval(_spender, _subtractedValue);
265     }
266 }
267 
268 
269 contract TokenImpl is PausableToken {
270     string public name;
271     string public symbol;
272 
273     uint8 public decimals = 5;
274     uint256 private decimal_num = 100000;
275 
276 
277     // cap of money in eth * decimal_num
278     uint256 public cap;
279 
280     // the target token
281     ERC20Basic public targetToken;
282     // how many token units a buyer gets per ether
283     uint16 public exchangeRate;
284 
285     // the freeze token
286     mapping(address => uint256) frozenTokens;
287     uint16 public frozenRate;
288 
289     bool public canBuy = true;
290     bool public projectFailed = false;
291     uint16 public backEthRatio = 10000;
292 
293 
294     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value);
295     event UpdateTargetToken(address _target, uint16 _exchangeRate, uint16 _freezeRate);
296     event IncreaseCap(uint256 cap);
297     event ProjectFailed(uint16 _fee);
298     event PauseBuy();
299     event UnPauseBuy();
300 
301 
302     function TokenImpl(string _name, string _symbol, uint256 _cap) public {
303         require(_cap > 0);
304         name = _name;
305         symbol = _symbol;
306         cap = _cap.mul(decimal_num);
307         paused = true;
308     }
309 
310     // fallback function can be used to buy tokens
311     function() external payable {
312         buyTokens(msg.sender);
313     }
314 
315     // low level token purchase function
316     function buyTokens(address beneficiary) public payable {
317         require(canBuy && msg.value >= (0.00001 ether));
318         require(beneficiary != address(0));
319 
320         uint256 _amount = msg.value.mul(decimal_num).div(1 ether);
321         totalSupply = totalSupply.add(_amount);
322         require(totalSupply <= cap);
323         balances[beneficiary] = balances[beneficiary].add(_amount);
324         TokenPurchase(msg.sender, beneficiary, _amount);
325 
326         forwardFunds();
327     }
328 
329     // send ether to the fund collection wallet
330     function forwardFunds() internal {
331         if(!projectFailed){
332             owner.transfer(msg.value);
333         }
334     }
335 
336 
337     /**
338       * @dev exchange tokens of _exchanger.
339       */
340     function exchange(address _exchanger, uint256 _value) internal {
341         if (projectFailed) {
342             _exchanger.transfer(_value.mul(1 ether).mul(backEthRatio).div(10000).div(decimal_num));
343         } else {
344             require(targetToken != address(0) && exchangeRate > 0);
345             uint256 _tokens = _value.mul(exchangeRate).div(decimal_num);
346             targetToken.transfer(_exchanger, _tokens);
347         }
348     }
349 
350     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused
351     returns (bool) {
352         updateFrozenToken(_from);
353         require(_to != address(0));
354         require(_value.add(frozenTokens[_from]) <= balances[_from]);
355         require(_value <= allowed[_from][msg.sender]);
356         updateFrozenToken(msg.sender);
357         if (_to == address(this)) {
358             if (frozenRate == 0 || projectFailed) {
359                 exchange(msg.sender, _value);
360                 return super.transferFrom(_from, _to, _value);
361             }
362             uint256 tokens = _value.mul(10000 - frozenRate).div(10000);
363             uint256 fTokens = _value.sub(tokens);
364             balances[_from] = balances[_from].sub(_value);
365             balances[_to] = balances[_to].add(tokens);
366             balances[msg.sender] = balances[msg.sender].add(fTokens);
367             frozenTokens[msg.sender] = frozenTokens[msg.sender].add(fTokens);
368             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
369             Transfer(_from, _to, _value);
370             exchange(msg.sender, tokens);
371             return true;
372         } else {
373             return super.transferFrom(_from, _to, _value);
374         }
375     }
376 
377     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
378         require(_to != address(0));
379         updateFrozenToken(msg.sender);
380         require(_value.add(frozenTokens[msg.sender]) <= balances[msg.sender]);
381 
382         uint256 tokens = _value;
383         if (_to == address(this)) {
384             if (frozenRate > 0 && !projectFailed) {
385                 tokens = _value.mul(10000 - frozenRate).div(10000);
386                 uint256 fTokens = _value.sub(tokens);
387                 frozenTokens[msg.sender] = frozenTokens[msg.sender].add(fTokens);
388             }
389             exchange(msg.sender, tokens);
390         }
391         return super.transfer(_to, tokens);
392     }
393 
394     function updateFrozenToken(address _owner) internal {
395         if (frozenRate == 0 && frozenTokens[_owner] > 0) {
396             frozenTokens[_owner] = 0;
397         }
398     }
399 
400     function balanceOfFrozen(address _owner) public view returns (uint256) {
401         if (frozenRate == 0) {
402             return 0;
403         }
404         return frozenTokens[_owner];
405     }
406 
407     function balanceOfTarget(address _owner) public view returns (uint256) {
408         if (targetToken != address(0)) {
409             return targetToken.balanceOf(_owner);
410         } else {
411             return 0;
412         }
413     }
414 
415     function saleRatio() public view returns (uint256 ratio) {
416         if (cap == 0) {
417             return 0;
418         } else {
419             return totalSupply.mul(10000).div(cap);
420         }
421     }
422 
423 
424     function canExchangeNum() public view returns (uint256) {
425         if (targetToken != address(0) && exchangeRate > 0) {
426             uint256 _tokens = targetToken.balanceOf(this);
427             return decimal_num.mul(_tokens).div(exchangeRate);
428         } else {
429             return 0;
430         }
431     }
432 
433     function pauseBuy() onlyOwner public {
434         canBuy = false;
435         PauseBuy();
436     }
437 
438     function unPauseBuy() onlyOwner public {
439         canBuy = true;
440         UnPauseBuy();
441     }
442 
443     // increase the amount of eth
444     function increaseCap(int256 _cap_inc) onlyOwner public {
445         require(_cap_inc != 0);
446         if (_cap_inc > 0) {
447             cap = cap.add(decimal_num.mul(uint256(_cap_inc)));
448         } else {
449             uint256 _dec = uint256(- 1 * _cap_inc);
450             uint256 cap_dec = decimal_num.mul(_dec);
451             if (cap_dec >= cap - totalSupply) {
452                 cap = totalSupply;
453             } else {
454                 cap = cap.sub(cap_dec);
455             }
456         }
457         IncreaseCap(cap);
458     }
459 
460 
461     function projectFailed(uint16 _fee) onlyOwner public {
462         require(!projectFailed && _fee >= 0 && _fee <= 10000);
463         projectFailed = true;
464         backEthRatio = 10000 - _fee;
465         frozenRate = 0;
466         ProjectFailed(_fee);
467     }
468 
469 
470     function updateTargetToken(address _target, uint16 _exchangeRate, uint16 _freezeRate) onlyOwner public {
471         require(_freezeRate > 0 || _exchangeRate > 0);
472 
473         if (_exchangeRate > 0) {
474             require(_target != address(0));
475             exchangeRate = _exchangeRate;
476             targetToken = ERC20Basic(_target);
477         }
478         if (_freezeRate > 0) {
479             frozenRate = _freezeRate;
480         }
481         UpdateTargetToken(_target, _exchangeRate, _freezeRate);
482     }
483 
484 
485     function destroy() onlyOwner public {
486         selfdestruct(owner);
487     }
488 
489 }