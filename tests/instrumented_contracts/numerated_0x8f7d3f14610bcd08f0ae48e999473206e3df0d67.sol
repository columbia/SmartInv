1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
30         return a >= b ? a : b;
31     }
32 
33     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
34         return a < b ? a : b;
35     }
36 
37     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
38         return a >= b ? a : b;
39     }
40 
41     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a < b ? a : b;
43     }
44 }
45 
46 
47 contract ERC20Basic {
48     uint256 public totalSupply;
49 
50     bool public transfersEnabled;
51 
52     function balanceOf(address who) public view returns (uint256);
53 
54     function transfer(address to, uint256 value) public returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 
60 contract ERC20 {
61     uint256 public totalSupply;
62 
63     bool public transfersEnabled;
64 
65     function balanceOf(address _owner) public constant returns (uint256 balance);
66 
67     function transfer(address _to, uint256 _value) public returns (bool success);
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
70 
71     function approve(address _spender, uint256 _value) public returns (bool success);
72 
73     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76 
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78 }
79 
80 
81 contract BasicToken is ERC20Basic {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) balances;
85 
86     /**
87     * Protection against short address attack
88     */
89     modifier onlyPayloadSize(uint numwords) {
90         assert(msg.data.length == numwords * 32 + 4);
91         _;
92     }
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     */
99     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102         require(transfersEnabled);
103 
104         // SafeMath.sub will throw if there is not enough balance.
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param _owner The address to query the the balance of.
114     * @return An uint256 representing the amount owned by the passed address.
115     */
116     function balanceOf(address _owner) public constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120 }
121 
122 
123 contract StandardToken is ERC20, BasicToken {
124 
125     mapping (address => mapping (address => uint256)) internal allowed;
126 
127     /**
128      * @dev Transfer tokens from one address to another
129      * @param _from address The address which you want to send tokens from
130      * @param _to address The address which you want to transfer to
131      * @param _value uint256 the amount of tokens to be transferred
132      */
133     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[_from]);
136         require(_value <= allowed[_from][msg.sender]);
137         require(transfersEnabled);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param _owner address The address which owns the funds.
165      * @param _spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 
172     /**
173      * approve should be called when allowed[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      */
178     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         }
189         else {
190             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191         }
192         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193         return true;
194     }
195 
196 }
197 
198 
199 /**
200  * @title Ownable
201  * @dev The Ownable contract has an owner address, and provides basic authorization control
202  * functions, this simplifies the implementation of "user permissions".
203  */
204 contract Ownable {
205     address public owner;
206 
207     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
208 
209     /**
210      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
211      * account.
212      */
213     function Ownable() public {
214     }
215 
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(msg.sender == owner);
222         _;
223     }
224 
225 
226     /**
227      * @dev Allows the current owner to transfer control of the contract to a newOwner.
228      * @param newOwner The address to transfer ownership to.
229      */
230     function changeOwner(address newOwner) onlyOwner internal {
231         require(newOwner != address(0));
232         OwnerChanged(owner, newOwner);
233         owner = newOwner;
234     }
235 
236 }
237 
238 
239 /**
240  * @title Mintable token
241  * @dev Simple ERC20 Token example, with mintable token creation
242  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
243  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
244  */
245 
246 contract MintableToken is StandardToken, Ownable {
247     string public constant name = "DeltaHFT Token";
248     string public constant symbol = "HFT";
249     uint8 public constant decimals = 18;
250 
251     event Mint(address indexed to, uint256 amount);
252     event MintFinished();
253 
254     bool public mintingFinished;
255 
256     modifier canMint() {
257         require(!mintingFinished);
258         _;
259     }
260 
261     /**
262      * @dev Function to mint tokens
263      * @param _to The address that will receive the minted tokens.
264      * @param _amount The amount of tokens to mint.
265      * @return A boolean that indicates if the operation was successful.
266      */
267     function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {
268         balances[_to] = balances[_to].add(_amount);
269         balances[_owner] = balances[_owner].sub(_amount);
270         Mint(_to, _amount);
271         Transfer(_owner, _to, _amount);
272         return true;
273     }
274 
275     /**
276      * @dev Function to stop minting new tokens.
277      * @return True if the operation was successful.
278      */
279     function finishMinting() onlyOwner canMint internal returns (bool) {
280         mintingFinished = true;
281         MintFinished();
282         return true;
283     }
284 
285     /**
286      * Peterson's Law Protection
287      * Claim tokens
288      */
289     function claimTokens(address _token) public onlyOwner {
290         if (_token == 0x0) {
291             owner.transfer(this.balance);
292             return;
293         }
294 
295         MintableToken token = MintableToken(_token);
296         uint256 balance = token.balanceOf(this);
297         token.transfer(owner, balance);
298 
299         Transfer(_token, owner, balance);
300     }
301 }
302 
303 
304 /**
305  * @title Crowdsale
306  * @dev Crowdsale is a base contract for managing a token crowdsale.
307  * Crowdsales have a start and end timestamps, where investors can make
308  * token purchases. Funds collected are forwarded to a wallet
309  * as they arrive.
310  */
311 contract Crowdsale is Ownable {
312     using SafeMath for uint256;
313     // address where funds are collected
314     address public wallet;
315 
316     // amount of raised money in wei
317     uint256 public weiRaised;
318     uint256 public tokenAllocated;
319     uint256 public hardWeiCap = 14412 * (10 ** 18);
320 
321     function Crowdsale(
322     address _wallet
323     )
324     public
325     {
326         require(_wallet != address(0));
327         wallet = _wallet;
328     }
329 }
330 
331 
332 contract HFTCrowdsale is Ownable, Crowdsale, MintableToken {
333     using SafeMath for uint256;
334 
335     enum State {Active, Closed}
336     State public state;
337     uint256[] public rates  = [4000,    3000,    2500,    2000,    1750,    1500];
338     uint256[] public limits = [1*10**24, 7*10**24, 13*10**24, 19*10**24, 25*10**24, 30*10**24];
339     uint256 weiMinSale = 1 * 10**17; // 0.1 ETH
340 
341     mapping (address => uint256) public deposited;
342 
343     uint256 public constant INITIAL_SUPPLY = 100 * (10 ** 6) * (10 ** uint256(decimals));
344     uint256 public fundForSale = 30 * (10 ** 6) * (10 ** uint256(decimals));
345 
346     uint256 public countInvestor;
347     bool public saleToken = true;
348 
349     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
350     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
351     event HardCapReached();
352     event Finalized();
353 
354     function HFTCrowdsale(
355     address _owner
356     )
357     public
358     Crowdsale(_owner)
359     {
360 
361         require(_owner != address(0));
362         owner = _owner;
363         transfersEnabled = true;
364         mintingFinished = false;
365         state = State.Active;
366         totalSupply = INITIAL_SUPPLY;
367         bool resultMintForOwner = mintForOwner(owner);
368         require(resultMintForOwner);
369     }
370 
371     modifier inState(State _state) {
372         require(state == _state);
373         _;
374     }
375 
376     // fallback function can be used to buy tokens
377     function() payable public {
378         buyTokens(msg.sender);
379     }
380 
381     function startSale() public onlyOwner {
382         saleToken = true;
383     }
384 
385     function stopSale() public onlyOwner {
386         saleToken = false;
387     }
388 
389     // low level token purchase function
390     function buyTokens(address _investor) public inState(State.Active) payable returns (uint256){
391         require(_investor != address(0));
392         require(saleToken == true);
393         uint256 weiAmount = msg.value;
394         uint256 tokens = validPurchaseTokens(weiAmount);
395         if (tokens == 0) {revert();}
396         weiRaised = weiRaised.add(weiAmount);
397         tokenAllocated = tokenAllocated.add(tokens);
398         mint(_investor, tokens, owner);
399 
400         TokenPurchase(_investor, weiAmount, tokens);
401         if (deposited[_investor] == 0) {
402             countInvestor = countInvestor.add(1);
403         }
404         deposit(_investor);
405         wallet.transfer(weiAmount);
406         return tokens;
407     }
408 
409     /**
410     * preICO    1 ETH = 4,000 tokens -- Limit = 0,10  ETH
411     * 1 Stage   1 ETH = 3,000 tokens -- Limit = 0,10  ETH
412     * 2 Stage   1 ETH = 2,500 tokens -- Limit = 0,10  ETH
413     * 3 Stage   1 ETH = 2,000 tokens -- Limit = 0,10  ETH
414     * 4 Stage   1 ETH = 1,750 tokens -- Limit = 0,10  ETH
415     * 5 Stage   1 ETH = 1,500 tokens -- Limit = 0,10  ETH
416     *
417     * Bonus token of 10% given to contributors of 1 ETH or more.
418     * Bonus token of 20% given to contributors of 5 ETH or more
419     */
420     function getTotalAmountOfTokens(uint256 _weiAmount) internal view returns (uint256) {
421         uint256 currentPeriod = getPeriod(tokenAllocated);
422         uint256 amountOfTokens = 0;
423         if(currentPeriod < 6){
424             amountOfTokens = _weiAmount.mul(rates[currentPeriod]);
425             if( 1*10**18 <= _weiAmount && _weiAmount < 5*10**18){
426                 amountOfTokens = amountOfTokens.mul(110).div(100);
427             }
428             if( 5*10**18 <= _weiAmount){
429                 amountOfTokens = amountOfTokens.mul(120).div(100);
430             }
431         } else {
432             amountOfTokens = 0;
433         }
434         if(tokenAllocated.add(amountOfTokens) > fundForSale){
435             amountOfTokens = 0;
436         }
437         return amountOfTokens;
438     }
439 
440     /**
441     * Total supply tokens for periods
442     * preICO    1, 000,000 tokens
443     * 1 Stage   7, 000,000 tokens
444     * 2 Stage   13,000,000 tokens
445     * 3 Stage   19,000,000 tokens
446     * 4 Stage   25,000,000 tokens
447     * 5 Stage   30,000,000 tokens
448     *
449     */
450     function getPeriod(uint256 currentTokenAllocated) public view returns (uint) {
451         if(0 < currentTokenAllocated && currentTokenAllocated < limits[0]){
452             return 0;
453         }
454         if(currentTokenAllocated > limits[5]){
455             return 6;
456         }
457         for(uint i = 1; i < 6; i++){
458             if(limits[i-1] <= currentTokenAllocated && currentTokenAllocated < limits[i]){
459                 return i;
460             }
461         }
462     }
463 
464     function deposit(address investor) internal {
465         require(state == State.Active);
466         deposited[investor] = deposited[investor].add(msg.value);
467     }
468 
469     function mintForOwner(address _wallet) internal returns (bool result) {
470         result = false;
471         require(_wallet != address(0));
472         balances[_wallet] = balances[_wallet].add(INITIAL_SUPPLY);
473         result = true;
474     }
475 
476     function getDeposited(address _investor) public view returns (uint256){
477         return deposited[_investor];
478     }
479 
480     function validPurchaseTokens(uint256 _weiAmount) public inState(State.Active) returns (uint256) {
481         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
482         if (_weiAmount < weiMinSale) {
483             return 0;
484         }
485         if (tokenAllocated.add(addTokens) > fundForSale) {
486             TokenLimitReached(tokenAllocated, addTokens);
487             return 0;
488         }
489         if (weiRaised.add(_weiAmount) > hardWeiCap) {
490             HardCapReached();
491             return 0;
492         }
493     return addTokens;
494     }
495 
496     function finalize() public onlyOwner inState(State.Active) returns (bool result) {
497         result = false;
498         state = State.Closed;
499         wallet.transfer(this.balance);
500         finishMinting();
501         Finalized();
502         result = true;
503     }
504 
505     function removeContract() public onlyOwner {
506         selfdestruct(owner);
507     }
508 }