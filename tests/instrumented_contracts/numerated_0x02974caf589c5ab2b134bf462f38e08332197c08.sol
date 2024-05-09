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
228      * @param _newOwner The address to transfer ownership to.
229      */
230     function changeOwner(address _newOwner) onlyOwner internal {
231         require(_newOwner != address(0));
232         OwnerChanged(owner, _newOwner);
233         owner = _newOwner;
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
247     string public constant name = "bean";
248     string public constant symbol = "XCC";
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
290     //function claimTokens(address _token) public {  //for test
291         if (_token == 0x0) {
292             owner.transfer(this.balance);
293             return;
294         }
295         MintableToken token = MintableToken(_token);
296         uint256 balance = token.balanceOf(this);
297         token.transfer(owner, balance);
298         Transfer(_token, owner, balance);
299     }
300 }
301 
302 
303 /**
304  * @title Crowdsale
305  * @dev Crowdsale is a base contract for managing a token crowdsale.
306  * Crowdsales have a start and end timestamps, where investors can make
307  * token purchases. Funds collected are forwarded to a wallet
308  * as they arrive.
309  */
310 contract Crowdsale is Ownable {
311     using SafeMath for uint256;
312     // address where funds are collected
313     address public wallet;
314 
315     // amount of raised money in wei
316     uint256 public weiRaised;
317     uint256 public tokenAllocated;
318 
319     function Crowdsale(
320     address _wallet
321     )
322     public
323     {
324         require(_wallet != address(0));
325         wallet = _wallet;
326     }
327 }
328 
329 
330 contract XCCCrowdsale is Ownable, Crowdsale, MintableToken {
331     using SafeMath for uint256;
332 
333     enum State {Active, Closed}
334     State public state;
335 
336     // https://www.coingecko.com/en/coins/ethereum
337     //$0.002 = 1 token => $ 1,000 = 1.6730521490354853 ETH =>
338     // 500,000 token = 1.6730521490354853 ETH => 1 ETH = 500,000/1.6730521490354853 = 298,855
339     uint256 public rate  = 298855;
340     //uint256 public rate  = 300000; //for test's
341 
342     mapping (address => uint256) public deposited;
343     mapping(address => bool) public whitelist;
344 
345     uint256 public constant INITIAL_SUPPLY = 5 * (10 ** 12) * (10 ** uint256(decimals));
346     uint256 public fundForSale = 5 * (10 ** 12) * (10 ** uint256(decimals));
347     uint256 public fundPreSale =  1 * (10 ** 12) * (10 ** uint256(decimals));
348 
349     uint256 public countInvestor;
350 
351     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
352     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
353     event Finalized();
354 
355     function XCCCrowdsale(
356     address _owner
357     )
358     public
359     Crowdsale(_owner)
360     {
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
381     // low level token purchase function
382     function buyTokens(address _investor) public inState(State.Active) payable returns (uint256){
383         require(_investor != address(0));
384         uint256 weiAmount = msg.value;
385         uint256 tokens = validPurchaseTokens(weiAmount);
386         if (tokens == 0) {revert();}
387         weiRaised = weiRaised.add(weiAmount);
388         tokenAllocated = tokenAllocated.add(tokens);
389         mint(_investor, tokens, owner);
390 
391         TokenPurchase(_investor, weiAmount, tokens);
392         if (deposited[_investor] == 0) {
393             countInvestor = countInvestor.add(1);
394         }
395         deposit(_investor);
396         wallet.transfer(weiAmount);
397         return tokens;
398     }
399 
400     function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {
401         uint256 currentDate = now;
402         //currentDate = 1526860799; //for test's
403         uint256 currentPeriod = getPeriod(currentDate);
404         uint256 amountOfTokens = 0;
405         if(currentPeriod < 2){
406             amountOfTokens = _weiAmount.mul(rate);
407             if (10**3*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 10**5*(10 ** uint256(decimals))) {
408                 amountOfTokens = amountOfTokens.mul(101).div(100);
409             }
410             if (10**5*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 10**6*(10 ** uint256(decimals))) {
411                 amountOfTokens = amountOfTokens.mul(1015).div(1000);
412             }
413             if (10**6*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 5*10**6*(10 ** uint256(decimals))) {
414                 amountOfTokens = amountOfTokens.mul(1025).div(1000);
415             }
416             if (5*10**6*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 9*10**6*(10 ** uint256(decimals))) {
417                 amountOfTokens = amountOfTokens.mul(105).div(100);
418             }
419             if (9*10**6*(10 ** uint256(decimals)) <= amountOfTokens) {
420                 amountOfTokens = amountOfTokens.mul(110).div(100);
421             }
422 
423             if(currentPeriod == 0){
424                 amountOfTokens = amountOfTokens.mul(1075).div(1000);
425                 if (tokenAllocated.add(amountOfTokens) > fundPreSale) {
426                     TokenLimitReached(tokenAllocated, amountOfTokens);
427                     return 0;
428                 }
429             return amountOfTokens;
430             }
431         }
432         return amountOfTokens;
433     }
434 
435     function getPeriod(uint256 _currentDate) public pure returns (uint) {
436         //1525651200 - May, 07, 2018 00:00:00 && 1528156799 - Jun, 04, 2018 23:59:59
437         //1540080000 - Oct, 21, 2018 00:00:00 && 1542758399 - Nov, 20, 2018 23:59:59
438 
439         if( 1525651200 <= _currentDate && _currentDate <= 1528156799){
440             return 0;
441         }
442         if( 1540080000 <= _currentDate && _currentDate <= 1542758399){
443             return 1;
444         }
445         return 10;
446     }
447 
448     function deposit(address investor) internal {
449         require(state == State.Active);
450         deposited[investor] = deposited[investor].add(msg.value);
451     }
452 
453     function mintForOwner(address _wallet) internal returns (bool result) {
454         result = false;
455         require(_wallet != address(0));
456         balances[_wallet] = balances[_wallet].add(INITIAL_SUPPLY);
457         result = true;
458     }
459 
460     function getDeposited(address _investor) public view returns (uint256){
461         return deposited[_investor];
462     }
463 
464     function validPurchaseTokens(uint256 _weiAmount) public inState(State.Active) returns (uint256) {
465         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
466         if (10**3*(10 ** uint256(decimals)) > addTokens || addTokens > 9999*10**3*(10 ** uint256(decimals))) {
467             return 0;
468         }
469         if (tokenAllocated.add(addTokens) > fundForSale) {
470             TokenLimitReached(tokenAllocated, addTokens);
471             return 0;
472         }
473         return addTokens;
474     }
475 
476     function finalize() public onlyOwner inState(State.Active) returns (bool result) {
477         result = false;
478         state = State.Closed;
479         wallet.transfer(this.balance);
480         finishMinting();
481         Finalized();
482         result = true;
483     }
484 
485     function setRate(uint256 _newRate) external onlyOwner returns (bool){
486         require(_newRate > 0);
487         rate = _newRate;
488         return true;
489     }
490 }