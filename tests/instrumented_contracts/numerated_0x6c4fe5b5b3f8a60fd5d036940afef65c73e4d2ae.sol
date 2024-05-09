1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
29         return a >= b ? a : b;
30     }
31 
32     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a < b ? a : b;
34     }
35 
36     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
37         return a >= b ? a : b;
38     }
39 
40     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a < b ? a : b;
42     }
43 }
44 
45 contract ERC20Basic {
46     uint256 public totalSupply;
47 
48     bool public transfersEnabled;
49 
50     function balanceOf(address who) public view returns (uint256);
51 
52     function transfer(address to, uint256 value) public returns (bool);
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 {
58     uint256 public totalSupply;
59 
60     bool public transfersEnabled;
61 
62     function balanceOf(address _owner) public constant returns (uint256 balance);
63 
64     function transfer(address _to, uint256 _value) public returns (bool success);
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
67 
68     function approve(address _spender, uint256 _value) public returns (bool success);
69 
70     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 }
75 
76 contract BasicToken is ERC20Basic {
77     using SafeMath for uint256;
78 
79     mapping(address => uint256) balances;
80 
81     /**
82     * @dev transfer token for a specified address
83     * @param _to The address to transfer to.
84     * @param _value The amount to be transferred.
85     */
86     function transfer(address _to, uint256 _value) public returns (bool) {
87         require(_to != address(0));
88         require(_value <= balances[msg.sender]);
89         require(transfersEnabled);
90 
91         // SafeMath.sub will throw if there is not enough balance.
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         Transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     /**
99     * @dev Gets the balance of the specified address.
100     * @param _owner The address to query the the balance of.
101     * @return An uint256 representing the amount owned by the passed address.
102     */
103     function balanceOf(address _owner) public constant returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107 }
108 
109 contract StandardToken is ERC20, BasicToken {
110 
111     mapping(address => mapping(address => uint256)) internal allowed;
112 
113 
114     /**
115      * @dev Transfer tokens from one address to another
116      * @param _from address The address which you want to send tokens from
117      * @param _to address The address which you want to transfer to
118      * @param _value uint256 the amount of tokens to be transferred
119      */
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121         require(_to != address(0));
122         require(_value <= balances[_from]);
123         require(_value <= allowed[_from][msg.sender]);
124         require(transfersEnabled);
125 
126         balances[_from] = balances[_from].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129         Transfer(_from, _to, _value);
130         return true;
131     }
132 
133     /**
134      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135      *
136      * Beware that changing an allowance with this method brings the risk that someone may use both the old
137      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      * @param _spender The address which will spend the funds.
141      * @param _value The amount of tokens to be spent.
142      */
143     function approve(address _spender, uint256 _value) public returns (bool) {
144         allowed[msg.sender][_spender] = _value;
145         Approval(msg.sender, _spender, _value);
146         return true;
147     }
148 
149     /**
150      * @dev Function to check the amount of tokens that an owner allowed to a spender.
151      * @param _owner address The address which owns the funds.
152      * @param _spender address The address which will spend the funds.
153      * @return A uint256 specifying the amount of tokens still available for the spender.
154      */
155     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
156         return allowed[_owner][_spender];
157     }
158 
159     /**
160      * approve should be called when allowed[_spender] == 0. To increment
161      * allowed value is better to use this function to avoid 2 calls (and wait until
162      * the first transaction is mined)
163      * From MonolithDAO Token.sol
164      */
165     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
166         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168         return true;
169     }
170 
171     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
172         uint oldValue = allowed[msg.sender][_spender];
173         if (_subtractedValue > oldValue) {
174             allowed[msg.sender][_spender] = 0;
175         } else {
176             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177         }
178         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179         return true;
180     }
181 
182 }
183 
184 /**
185  * @title Ownable
186  * @dev The Ownable contract has an owner address, and provides basic authorization control
187  * functions, this simplifies the implementation of "user permissions".
188  */
189 contract Ownable {
190     address public owner;
191     address public advisor;
192 
193     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
194 
195     /**
196      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197      * account.
198      */
199     function Ownable() public {
200         advisor = msg.sender;
201     }
202 
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         require(msg.sender == owner || msg.sender == advisor);
209         _;
210     }
211 
212 
213     /**
214      * @dev Allows the current owner to transfer control of the contract to a newOwner.
215      * @param newOwner The address to transfer ownership to.
216      */
217     function changeOwner(address newOwner) onlyOwner public {
218         require(newOwner != address(0));
219         OwnerChanged(owner, newOwner);
220         owner = newOwner;
221     }
222 
223     function changeAdvisor(address newAdvisor) onlyOwner public {
224         advisor = newAdvisor;
225         OwnerChanged(advisor, newAdvisor);
226     }
227 
228 }
229 
230 /**
231  * @title Mintable token
232  * @dev Simple ERC20 Token example, with mintable token creation
233  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
234  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
235  */
236 
237 contract MintableToken is StandardToken, Ownable {
238     string public constant name = "MCFit Token";
239     string public constant symbol = "MCF";
240     uint8 public constant decimals = 18;
241 
242     uint256 public totalAllocated = 0;
243 
244     event Mint(address indexed to, uint256 amount);
245     event MintFinished();
246 
247     bool public mintingFinished;
248 
249     modifier canMint() {
250         require(!mintingFinished);
251         _;
252     }
253 
254     /**
255      * @dev Function to mint tokens
256      * @param _to The address that will receive the minted tokens.
257      * @param _amount The amount of tokens to mint.
258      * @return A boolean that indicates if the operation was successful.
259      */
260     function mint(address _to, uint256 _amount) canMint internal returns (bool) {
261 
262         require(!mintingFinished);
263         totalAllocated = totalAllocated.add(_amount);
264         balances[_to] = balances[_to].add(_amount);
265         Mint(_to, _amount);
266         Transfer(address(0), _to, _amount);
267         return true;
268     }
269 
270     function withDraw(address _investor) internal returns (bool) {
271 
272         require(mintingFinished);
273         uint256 amount = balanceOf(_investor);
274         require(amount <= totalAllocated);
275         totalAllocated = totalAllocated.sub(amount);
276         balances[_investor] = balances[_investor].sub(amount);
277         return true;
278     }
279 
280     /**
281      * @dev Function to stop minting new tokens.
282      * @return True if the operation was successful.
283      */
284     function finishMinting() onlyOwner canMint internal returns (bool) {
285         mintingFinished = true;
286         MintFinished();
287         return true;
288     }
289 
290 }
291 
292 /**
293  * @title Crowdsale
294  * @dev Crowdsale is a base contract for managing a token crowdsale.
295  * Crowdsales have a start and end timestamps, where investors can make
296  * token purchases and the crowdsale will assign them tokens based
297  * on a token per ETH rate. Funds collected are forwarded to a wallet
298  * as they arrive.
299  */
300 contract Crowdsale is Ownable {
301     using SafeMath for uint256;
302 
303     // start and end timestamps where investments are allowed (both inclusive)
304     uint256 public startTime;
305     uint256 public endTime;
306     bool public checkDate;
307 
308     // address where funds are collected
309     address public wallet;
310 
311     // how many token units a buyer gets per wei
312     uint256 public rate;
313 
314     // amount of raised money in wei
315     uint256 public weiRaised;
316     uint256 public tokenRaised;
317     bool public isFinalized = false;
318 
319     event Finalized();
320 
321 
322     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
323 
324         require(_startTime >= now);
325         require(_endTime >= _startTime);
326         require(_rate > 0);
327         require(_wallet != address(0));
328 
329         //token = createTokenContract();
330         startTime = _startTime;
331         endTime = _endTime;
332         rate = _rate;
333         wallet = _wallet;
334         checkDate = false;
335     }
336 
337     // @return true if crowdsale event has ended
338     function hasEnded() public constant returns (bool) {
339         return now > endTime;
340     }
341 
342     /**
343  * @dev Must be called after crowdsale ends, to do some extra finalization
344  * work. Calls the contract's finalization function.
345  */
346     function finalize() onlyOwner public {
347         require(!isFinalized);
348         //require(hasEnded());
349 
350         finalization();
351         Finalized();
352 
353         isFinalized = true;
354     }
355 
356     /**
357      * @dev Can be overridden to add finalization logic. The overriding function
358      * should call super.finalization() to ensure the chain of finalization is
359      * executed entirely.
360      */
361     function finalization() internal pure {
362     }
363 }
364 
365 
366 contract MCFitCrowdsale is Ownable, Crowdsale, MintableToken {
367     using SafeMath for uint256;
368 
369     enum State {Active, Closed}
370     State public state;
371 
372     mapping(address => uint256) public deposited;
373     uint256 public constant INITIAL_SUPPLY = 1 * (10**9) * (10 ** uint256(decimals));
374     uint256 public fundReservCompany = 350 * (10**6) * (10 ** uint256(decimals));
375     uint256 public fundTeamCompany = 300 * (10**6) * (10 ** uint256(decimals));
376     uint256 public countInvestor;
377 
378     uint256 limit40Percent = 30*10**6*10**18;
379     uint256 limit20Percent = 60*10**6*10**18;
380     uint256 limit10Percent = 100*10**6*10**18;
381 
382     event Closed();
383     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
384 
385 
386     function MCFitCrowdsale(uint256 _startTime, uint256 _endTime,uint256 _rate, address _wallet) public
387     Crowdsale(_startTime, _endTime, _rate, _wallet)
388     {
389         owner = _wallet;
390         //advisor = msg.sender;
391         transfersEnabled = true;
392         mintingFinished = false;
393         state = State.Active;
394         totalSupply = INITIAL_SUPPLY;
395         bool resultMintFunds = mintToSpecialFund(owner);
396         require(resultMintFunds);
397     }
398 
399     // fallback function can be used to buy tokens
400     function() payable public {
401         buyTokens(msg.sender);
402     }
403 
404     // low level token purchase function
405     function buyTokens(address _investor) public payable returns (uint256){
406         require(state == State.Active);
407         require(_investor != address(0));
408         if(checkDate){
409             assert(now >= startTime && now < endTime);
410         }
411         uint256 weiAmount = msg.value;
412         // calculate token amount to be created
413         uint256 tokens = getTotalAmountOfTokens(weiAmount);
414         weiRaised = weiRaised.add(weiAmount);
415         mint(_investor, tokens);
416         TokenPurchase(_investor, weiAmount, tokens);
417         if(deposited[_investor] == 0){
418             countInvestor = countInvestor.add(1);
419         }
420         deposit(_investor);
421         wallet.transfer(weiAmount);
422         return tokens;
423     }
424 
425     function getTotalAmountOfTokens(uint256 _weiAmount) internal constant returns (uint256 amountOfTokens) {
426         uint256 currentTokenRate = 0;
427         uint256 currentDate = now;
428         //uint256 currentDate = 1516492800; // 21 Jan 2018
429         require(currentDate >= startTime);
430 
431         if (totalAllocated < limit40Percent && currentDate < endTime) {
432             if(_weiAmount < 5 * 10**17){revert();}
433             return currentTokenRate = _weiAmount.mul(rate*140);
434         } else if (totalAllocated < limit20Percent && currentDate < endTime) {
435             if(_weiAmount < 5 * 10**17){revert();}
436             return currentTokenRate = _weiAmount.mul(rate*120);
437         } else if (totalAllocated < limit10Percent && currentDate < endTime) {
438             if(_weiAmount < 5 * 10**17){revert();}
439             return currentTokenRate = _weiAmount.mul(rate*110);
440         } else {
441             return currentTokenRate = _weiAmount.mul(rate*100);
442         }
443     }
444 
445     function deposit(address investor) internal {
446         require(state == State.Active);
447         deposited[investor] = deposited[investor].add(msg.value);
448     }
449 
450     function close() onlyOwner public {
451         require(state == State.Active);
452         if(checkDate){
453             require(hasEnded());
454         }
455         state = State.Closed;
456         transfersEnabled = false;
457         finishMinting();
458         Closed();
459         finalize();
460         wallet.transfer(this.balance);
461     }
462 
463     function mintToSpecialFund(address _wallet) public onlyOwner returns (bool result) {
464         result = false;
465         require(_wallet != address(0));
466         balances[_wallet] = balances[_wallet].add(fundReservCompany);
467         balances[_wallet] = balances[_wallet].add(fundTeamCompany);
468         result = true;
469     }
470 
471     function changeRateUSD(uint256 _rate) onlyOwner public {
472         require(state == State.Active);
473         require(_rate > 0);
474         rate = _rate;
475     }
476 
477     function changeCheckDate(bool _state, uint256 _startTime, uint256 _endTime) onlyOwner public {
478         require(state == State.Active);
479         require(_startTime >= now);
480         require(_endTime >= _startTime);
481 
482         checkDate = _state;
483         startTime = _startTime;
484         endTime = _endTime;
485     }
486 
487     function getDeposited(address _investor) public view returns (uint256){
488         return deposited[_investor];
489     }
490 
491     function removeContract() public onlyOwner {
492         selfdestruct(owner);
493     }
494 
495 }