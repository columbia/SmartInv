1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 
19     /**
20     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21     * account.
22     */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28     * owner
29     */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35 
36     /**
37     * @dev Allows the current owner to relinquish control of the contract.
38     * @notice Renouncing to ownership will leave the contract without an owner.
39     * It will not be possible to call the functions with the `onlyOwner`
40     * modifier anymore.
41     */
42     function renounceOwnership() public onlyOwner {
43         emit OwnershipRenounced(owner);
44         owner = address(0);
45     }
46 
47     /**
48     * @dev Allows the current owner to transfer control of the contract to a newOwner.
49     * @param _newOwner The address to transfer ownership to.
50     */
51     function transferOwnership(address _newOwner) public onlyOwner {
52         _transferOwnership(_newOwner);
53     }
54 
55     /**
56     * @dev Transfers control of the contract to a newOwner.
57     * @param _newOwner The address to transfer ownership to.
58     */
59     function _transferOwnership(address _newOwner) internal {
60         require(_newOwner != address(0));
61         emit OwnershipTransferred(owner, _newOwner);
62         owner = _newOwner;
63     }
64 }
65 
66 /**
67 * @title SafeMath
68 * @dev Math operations with safety checks that revert on error
69 */
70 library SafeMath {
71 
72     /**
73     * @dev Multiplies two numbers, reverts on overflow.
74     */
75     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79         if (_a == 0) {
80             return 0;
81         }
82 
83         uint256 c = _a * _b;
84         require(c / _a == _b);
85 
86         return c;
87     }
88 
89     /**
90     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
91     */
92     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
93         require(_b > 0); // Solidity only automatically asserts when dividing by 0
94         uint256 c = _a / _b;
95         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
96 
97         return c;
98     }
99 
100     /**
101     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
102     */
103     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
104         require(_b <= _a);
105         uint256 c = _a - _b;
106 
107         return c;
108     }
109 
110     /**
111     * @dev Adds two numbers, reverts on overflow.
112     */
113     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
114         uint256 c = _a + _b;
115         require(c >= _a);
116 
117         return c;
118     }
119 
120     /**
121     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
122     * reverts when dividing by zero.
123     */
124     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125         require(b != 0);
126         return a % b;
127     }
128 }
129 
130 /**
131 * @title ERC20 interface
132 * @dev see https://github.com/ethereum/EIPs/issues/20
133 */
134 contract ERC20 {
135     function totalSupply() public view returns (uint256);
136 
137     function balanceOf(address _who) public view returns (uint256);
138 
139     function allowance(address _owner, address _spender)
140         public view returns (uint256);
141 
142     function transfer(address _to, uint256 _value) public returns (bool);
143 
144     function approve(address _spender, uint256 _value)
145         public returns (bool);
146 
147     function transferFrom(address _from, address _to, uint256 _value)
148         public returns (bool);
149 
150     event Transfer(
151         address indexed from,
152         address indexed to,
153         uint256 value
154     );
155 
156     event Approval(
157         address indexed owner,
158         address indexed spender,
159         uint256 value
160     );
161 }
162 
163 contract KvantorSaleToken is ERC20, Ownable {
164     using SafeMath for uint256;
165 
166     string public name = "KVANTOR Sale token";
167     string public symbol = "KVT_SALE";
168     uint public decimals = 8;
169 
170     uint256 crowdsaleStartTime = 1535317200;
171     uint256 crowdsaleFinishTime = 1537995600;
172 
173 
174     address public kvtOwner = 0xe4ed7e14e961550c0ce7571df8a5b11dec9f7f52;
175     ERC20 public kvtToken = ERC20(0x96c8aa08b1712dDe92f327c0dC7c71EcE6c06525);
176 
177     uint256 tokenMinted = 0;
178     // cap 60 mln KVT
179     uint256 public tokenCap = 6000000000000000;
180     // rate is 0,0000000 ETH discreet
181     uint256 public rate = 3061857781;
182     
183     uint256 public weiRaised = 0;
184     address public wallet = 0x5B007Da9dBf09842Cb4751bd5BcD6ea2808256F5;
185 
186     constructor() public {
187         
188     }
189 
190 
191     /* non-standard code */
192 
193 
194     function transfer(address _to, uint256 _value) public returns (bool) {
195         require(_value <= balances[msg.sender]);
196         require(_to != address(0));
197 
198         if (this == _to) {
199             require(kvtToken.transfer(msg.sender, _value));
200             _burn(msg.sender, _value);
201         } else {
202             balances[msg.sender] = balances[msg.sender].sub(_value);
203             balances[_to] = balances[_to].add(_value);
204         }
205         emit Transfer(msg.sender, _to, _value);
206         return true;
207     }
208 
209     function transferFrom(
210         address _from,
211         address _to,
212         uint256 _value
213     )
214         public
215         returns (bool)
216     {
217         require(_value <= balances[_from]);
218         require(_value <= allowed[_from][msg.sender]);
219         require(_to != address(0));
220 
221         if (this == _to) {
222             require(kvtToken.transfer(_from, _value));
223             _burn(_from, _value);
224         } else {
225             balances[_from] = balances[_from].sub(_value);
226             balances[_to] = balances[_to].add(_value);   
227         }
228         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229         emit Transfer(_from, _to, _value);
230         return true;
231     }
232     
233     /* this function calculates tokens with discount rules */
234     
235     function calculateTokens(uint256 _weiAmount) view public returns (uint256) {
236         
237         uint256 tokens = _weiAmount.mul(rate).mul(100).div(75).div(100 finney);
238         if(tokens.div(100000000) < 5000)
239             return _weiAmount.mul(rate).mul(100).div(80).div(100 finney);
240         
241         tokens = _weiAmount.mul(rate).mul(100).div(73).div(100 finney);
242         if(tokens.div(100000000) < 25000)
243             return _weiAmount.mul(rate).mul(100).div(75).div(100 finney);
244             
245         tokens = _weiAmount.mul(rate).mul(100).div(70).div(100 finney);
246         if(tokens.div(100000000) < 50000)
247             return _weiAmount.mul(rate).mul(100).div(73).div(100 finney);
248             
249         tokens = _weiAmount.mul(rate).mul(100).div(65).div(100 finney);
250         if(tokens.div(100000000) < 250000)
251             return _weiAmount.mul(rate).mul(100).div(70).div(100 finney);
252             
253         tokens = _weiAmount.mul(rate).mul(100).div(60).div(100 finney);
254         if(tokens.div(100000000) < 500000)
255             return _weiAmount.mul(rate).mul(100).div(65).div(100 finney);
256             
257         return _weiAmount.mul(rate).mul(100).div(60).div(100 finney);
258             
259     }
260     
261 
262     function buyTokens(address _beneficiary) public payable {
263         require(crowdsaleStartTime <= now && now <= crowdsaleFinishTime);
264 
265         uint256 weiAmount = msg.value;
266 
267         require(_beneficiary != address(0));
268         require(weiAmount != 0);
269 
270         // calculate token amount to be created
271         uint256 tokens = calculateTokens(weiAmount);
272         
273         /* min purchase = 100 KVT */
274         require(tokens.div(100000000) >= 100);
275         
276         require(tokenMinted.add(tokens) < tokenCap);
277         tokenMinted = tokenMinted.add(tokens);
278 
279         // update state
280         weiRaised = weiRaised.add(weiAmount);
281 
282         _mint(_beneficiary, tokens);
283 
284         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
285 
286         wallet.transfer(msg.value);
287     }
288 
289     function returnKVTToOwner() onlyOwner public {
290         uint256 tokens = kvtToken.balanceOf(this).sub(this.totalSupply());
291 
292         require(now > crowdsaleFinishTime);
293         require(tokens > 0);
294         require(kvtToken.transfer(kvtOwner, tokens));
295     }
296 
297     function returnKVTToSomeone(address _to) onlyOwner public {
298         uint256 tokens = this.balanceOf(_to);
299 
300         require(now > crowdsaleFinishTime);
301         require(tokens > 0);
302         require(kvtToken.transfer(_to, tokens));
303         _burn(_to, tokens);
304     }
305     
306     function finishHim() onlyOwner public {
307         selfdestruct(this);
308     }
309 
310     function setRate(uint256 _rate) onlyOwner public {
311         rate = _rate;
312     }
313 
314     function setTokenCap(uint256 _tokenCap) onlyOwner public {
315         tokenCap = _tokenCap;
316     }
317     
318     /* zeppelen standard code */    
319     /**
320     * Event for token purchase logging
321     * @param purchaser who paid for the tokens
322     * @param beneficiary who got the tokens
323     * @param value weis paid for purchase
324     * @param amount amount of tokens purchased
325     */
326     event TokenPurchase(
327         address indexed purchaser,
328         address indexed beneficiary,
329         uint256 value,
330         uint256 amount
331     );
332 
333     /**
334     * @dev fallback function ***DO NOT OVERRIDE***
335     */
336     function () external payable {
337         buyTokens(msg.sender);
338     }
339     
340     mapping (address => uint256) private balances;
341 
342     mapping (address => mapping (address => uint256)) private allowed;
343 
344     uint256 private totalSupply_;
345 
346     /**
347     * @dev Total number of tokens in existence
348     */
349     function totalSupply() public view returns (uint256) {
350         return totalSupply_;
351     }
352 
353     /**
354     * @dev Gets the balance of the specified address.
355     * @param _owner The address to query the the balance of.
356     * @return An uint256 representing the amount owned by the passed address.
357     */
358     function balanceOf(address _owner) public view returns (uint256) {
359         return balances[_owner];
360     }
361 
362     /**
363     * @dev Function to check the amount of tokens that an owner allowed to a spender.
364     * @param _owner address The address which owns the funds.
365     * @param _spender address The address which will spend the funds.
366     * @return A uint256 specifying the amount of tokens still available for the spender.
367     */
368     function allowance(
369         address _owner,
370         address _spender
371     )
372         public
373         view
374         returns (uint256)
375     {
376         return allowed[_owner][_spender];
377     }
378 
379     /**
380     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
381     * Beware that changing an allowance with this method brings the risk that someone may use both the old
382     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
383     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
384     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
385     * @param _spender The address which will spend the funds.
386     * @param _value The amount of tokens to be spent.
387     */
388     function approve(address _spender, uint256 _value) public returns (bool) {
389         allowed[msg.sender][_spender] = _value;
390         emit Approval(msg.sender, _spender, _value);
391         return true;
392     }
393 
394 
395     /**
396     * @dev Increase the amount of tokens that an owner allowed to a spender.
397     * approve should be called when allowed[_spender] == 0. To increment
398     * allowed value is better to use this function to avoid 2 calls (and wait until
399     * the first transaction is mined)
400     * From MonolithDAO Token.sol
401     * @param _spender The address which will spend the funds.
402     * @param _addedValue The amount of tokens to increase the allowance by.
403     */
404     function increaseApproval(
405         address _spender,
406         uint256 _addedValue
407     )
408         public
409         returns (bool)
410     {
411         allowed[msg.sender][_spender] = (
412         allowed[msg.sender][_spender].add(_addedValue));
413         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
414         return true;
415     }
416 
417     /**
418     * @dev Decrease the amount of tokens that an owner allowed to a spender.
419     * approve should be called when allowed[_spender] == 0. To decrement
420     * allowed value is better to use this function to avoid 2 calls (and wait until
421     * the first transaction is mined)
422     * From MonolithDAO Token.sol
423     * @param _spender The address which will spend the funds.
424     * @param _subtractedValue The amount of tokens to decrease the allowance by.
425     */
426     function decreaseApproval(
427         address _spender,
428         uint256 _subtractedValue
429     )
430         public
431         returns (bool)
432     {
433         uint256 oldValue = allowed[msg.sender][_spender];
434         if (_subtractedValue >= oldValue) {
435             allowed[msg.sender][_spender] = 0;
436         } else {
437             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
438         }
439         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
440         return true;
441     }
442 
443     /**
444     * @dev Internal function that mints an amount of the token and assigns it to
445     * an account. This encapsulates the modification of balances such that the
446     * proper events are emitted.
447     * @param _account The account that will receive the created tokens.
448     * @param _amount The amount that will be created.
449     */
450     function _mint(address _account, uint256 _amount) internal {
451         require(_account != 0);
452         totalSupply_ = totalSupply_.add(_amount);
453         balances[_account] = balances[_account].add(_amount);
454         emit Transfer(address(0), _account, _amount);
455     }
456 
457     /**
458     * @dev Internal function that burns an amount of the token of a given
459     * account.
460     * @param _account The account whose tokens will be burnt.
461     * @param _amount The amount that will be burnt.
462     */
463     function _burn(address _account, uint256 _amount) internal {
464         require(_account != 0);
465         require(_amount <= balances[_account]);
466 
467         totalSupply_ = totalSupply_.sub(_amount);
468         balances[_account] = balances[_account].sub(_amount);
469         emit Transfer(_account, address(0), _amount);
470     }
471 
472     /**
473     * @dev Internal function that burns an amount of the token of a given
474     * account, deducting from the sender's allowance for said account. Uses the
475     * internal _burn function.
476     * @param _account The account whose tokens will be burnt.
477     * @param _amount The amount that will be burnt.
478     */
479     function _burnFrom(address _account, uint256 _amount) internal {
480         require(_amount <= allowed[_account][msg.sender]);
481 
482         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
483         // this function needs to emit an event with the updated approval.
484         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
485         _burn(_account, _amount);
486     }
487 }