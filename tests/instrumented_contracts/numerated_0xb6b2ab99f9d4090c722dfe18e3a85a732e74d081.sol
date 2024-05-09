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
247     string public constant name = "Dgenex";
248     string public constant symbol = "DGX";
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
319 
320     function Crowdsale(address _wallet) public {
321         require(_wallet != address(0));
322         wallet = _wallet;
323     }
324 }
325 
326 
327 contract DGXCrowdsale is Ownable, Crowdsale, MintableToken {
328     using SafeMath for uint256;
329 
330     uint256 weiMaxSale = 10 ether; // 10.0 ETH
331 
332     mapping (address => uint256) public deposited;
333 
334     uint256 public constant INITIAL_SUPPLY = 10 * (10 ** 9) * (10 ** uint256(decimals));
335     uint256 public fundForSale = 5 * (10 ** 9) * (10 ** uint256(decimals));
336     uint256 public fundDigitalMarket = 2 * (10 ** 9) * (10 ** uint256(decimals));
337     uint256 public fundTeam = 3 * (10 ** 9) * (10 ** uint256(decimals));
338     address public addressFundDigitalMarket = 0x4053AB17d8431ae373761197125A67019e56166f;
339     address public addressFundTeam = 0x34C2B49cF13A31f1017BBbEF165B7ef5fDB04941;
340 
341     uint256 public countInvestor;
342 
343     //$0.01 = 1 token => $ 1,000 = 2.08881106 ETH =>
344     //100,000 token = 2.08881106 ETH => 1 ETH = 100,000/2.08881106 = 47874
345     uint256 public rate = 47874;
346     //uint256 public rate = 1000; // for test
347 
348     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
349     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
350     event Burn(address indexed burner, uint256 value);
351 
352     function DGXCrowdsale(address _owner, address _wallet)
353     public
354     Crowdsale(_wallet)
355     {
356 
357         require(_owner != address(0));
358         owner = _owner;
359         transfersEnabled = true;
360         mintingFinished = false;
361         totalSupply = INITIAL_SUPPLY;
362         bool resultMintForOwner = mintForOwner(owner);
363         require(resultMintForOwner);
364     }
365 
366     // fallback function can be used to buy tokens
367     function() payable public {
368         buyTokens(msg.sender);
369     }
370 
371     // low level token purchase function
372     function buyTokens(address _investor) public payable returns (uint256){
373         require(_investor != address(0));
374         uint256 weiAmount = msg.value;
375         uint256 tokens = validPurchaseTokens(weiAmount);
376         if (tokens == 0) {revert();}
377         weiRaised = weiRaised.add(weiAmount);
378         tokenAllocated = tokenAllocated.add(tokens);
379         mint(_investor, tokens, owner);
380 
381         TokenPurchase(_investor, weiAmount, tokens);
382         if (deposited[_investor] == 0) {
383             countInvestor = countInvestor.add(1);
384         }
385         deposit(_investor);
386         wallet.transfer(weiAmount);
387         return tokens;
388     }
389 
390     /**
391     * Total supply tokens for periods
392     *
393     * pre  ICO   from 05 April 11.00 GMT to 19 April 11.00GMT 2018
394     * main ICO   from 19 April 11.00GMT to 31 May 11.00GMT 2018
395     *
396     * 30% bonus token given to investors during the pre-ICO.
397     * 20% bonus token given to investors during the main ICO
398     */
399     function getTotalAmountOfTokens(uint256 _weiAmount) internal view returns (uint256) {
400         uint256 amountOfTokens = 0;
401         uint256 currentTime = now;
402         //currentTime = 1523358000; //Tue, 10 Apr 2018 11:00:00 GMT
403         //currentTime = 1526814000; //Sun, 20 May 2018 11:00:00 GMT
404         if (1522926000 <= currentTime && currentTime < 1524135600) {
405             amountOfTokens = _weiAmount.mul(rate).mul(130).div(100);
406         }
407         if (1524135600 <= currentTime && currentTime <= 1527764400) {
408             amountOfTokens = _weiAmount.mul(rate).mul(120).div(100);
409         }
410         return amountOfTokens;
411     }
412 
413     function deposit(address investor) internal {
414         deposited[investor] = deposited[investor].add(msg.value);
415     }
416 
417     function mintForOwner(address _wallet) internal returns (bool result) {
418         result = false;
419         require(_wallet != address(0));
420         balances[_wallet] = balances[_wallet].add(fundForSale);
421         balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);
422         balances[addressFundDigitalMarket] = balances[addressFundDigitalMarket].add(fundDigitalMarket);
423         result = true;
424     }
425 
426     function getDeposited(address _investor) public view returns (uint256){
427         return deposited[_investor];
428     }
429 
430     function setRate(uint256 _newRate) public returns (bool){
431         require(_newRate > 0);
432         rate = _newRate;
433         return true;
434     }
435 
436     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
437         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
438         if (_weiAmount > weiMaxSale) {
439             return 0;
440         }
441         if (tokenAllocated.add(addTokens) > fundForSale) {
442             TokenLimitReached(tokenAllocated, addTokens);
443             return 0;
444         }
445         return addTokens;
446     }
447 
448     function ownerBurnToken() public onlyOwner returns (uint256 burnToken) {
449         uint256 teamAfterBurn = tokenAllocated.mul(60).div(100);
450         uint256 digitalMarketAfterBurn = tokenAllocated.mul(40).div(100);
451         burnToken = totalSupply.sub(tokenAllocated);
452         balances[owner] = 0;
453         balances[addressFundTeam] = teamAfterBurn;
454         balances[addressFundDigitalMarket] = digitalMarketAfterBurn;
455         totalSupply = tokenAllocated.add(teamAfterBurn).add(digitalMarketAfterBurn);
456         Burn(owner, burnToken);
457     }
458 
459     function removeContract() public onlyOwner {
460         selfdestruct(owner);
461     }
462 }