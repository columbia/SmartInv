1 pragma solidity ^0.4.11;
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
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41 
42     /**
43      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44      * account.
45      */
46     function Ownable() {
47         owner = msg.sender;
48     }
49 
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59 
60     /**
61      * @dev Allows the current owner to transfer control of the contract to a newOwner.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function transferOwnership(address newOwner) onlyOwner {
65         if (newOwner != address(0)) {
66             owner = newOwner;
67         }
68     }
69 
70 }
71 
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77     event Pause();
78     event Unpause();
79 
80     bool public paused = false;
81 
82 
83     /**
84      * @dev modifier to allow actions only when the contract IS paused
85      */
86     modifier whenNotPaused() {
87         require(!paused);
88         _;
89     }
90 
91     /**
92      * @dev modifier to allow actions only when the contract IS NOT paused
93      */
94     modifier whenPaused {
95         require(paused);
96         _;
97     }
98 
99     /**
100      * @dev called by the owner to pause, triggers stopped state
101      */
102     function pause() onlyOwner whenNotPaused returns (bool) {
103         paused = true;
104         Pause();
105         return true;
106     }
107 
108     /**
109      * @dev called by the owner to unpause, returns to normal state
110      */
111     function unpause() onlyOwner whenPaused returns (bool) {
112         paused = false;
113         Unpause();
114         return true;
115     }
116 }
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124     uint256 public totalSupply;
125     function balanceOf(address who) constant returns (uint256);
126     function transfer(address to, uint256 value) returns (bool);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135     using SafeMath for uint256;
136 
137     mapping(address => uint256) balances;
138 
139     /**
140     * @dev transfer token for a specified address
141     * @param _to The address to transfer to.
142     * @param _value The amount to be transferred.
143     */
144     function transfer(address _to, uint256 _value) returns (bool) {
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     /**
152     * @dev Gets the balance of the specified address.
153     * @param _owner The address to query the the balance of.
154     * @return An uint256 representing the amount owned by the passed address.
155     */
156     function balanceOf(address _owner) constant returns (uint256 balance) {
157         return balances[_owner];
158     }
159 
160 }
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167     function allowance(address owner, address spender) constant returns (uint256);
168     function transferFrom(address from, address to, uint256 value) returns (bool);
169     function approve(address spender, uint256 value) returns (bool);
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 /**
174  * @title Standard ERC20 token
175  *
176  * @dev Implementation of the basic standard token.
177  * @dev https://github.com/ethereum/EIPs/issues/20
178  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
179  */
180 contract StandardToken is ERC20, BasicToken {
181 
182     mapping (address => mapping (address => uint256)) allowed;
183 
184 
185     /**
186      * @dev Transfer tokens from one address to another
187      * @param _from address The address which you want to send tokens from
188      * @param _to address The address which you want to transfer to
189      * @param _value uint256 the amout of tokens to be transfered
190      */
191     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
192         var _allowance = allowed[_from][msg.sender];
193 
194         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
195         // require (_value <= _allowance);
196 
197         balances[_to] = balances[_to].add(_value);
198         balances[_from] = balances[_from].sub(_value);
199         allowed[_from][msg.sender] = _allowance.sub(_value);
200         Transfer(_from, _to, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
206      * @param _spender The address which will spend the funds.
207      * @param _value The amount of tokens to be spent.
208      */
209     function approve(address _spender, uint256 _value) returns (bool) {
210 
211         // To change the approve amount you first have to reduce the addresses`
212         //  allowance to zero by calling `approve(_spender, 0)` if it is not
213         //  already 0 to mitigate the race condition described here:
214         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
216 
217         allowed[msg.sender][_spender] = _value;
218         Approval(msg.sender, _spender, _value);
219         return true;
220     }
221 
222     /**
223      * @dev Function to check the amount of tokens that an owner allowed to a spender.
224      * @param _owner address The address which owns the funds.
225      * @param _spender address The address which will spend the funds.
226      * @return A uint256 specifing the amount of tokens still avaible for the spender.
227      */
228     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
229         return allowed[_owner][_spender];
230     }
231 
232 }
233 
234 /**
235  * @title HoQuToken
236  * @dev HoQu.io token contract.
237  */
238 contract HoQuToken is StandardToken, Pausable {
239 
240     string public constant name = "HOQU Token";
241     string public constant symbol = "HQX";
242     uint32 public constant decimals = 18;
243 
244     /**
245      * @dev Give all tokens to msg.sender.
246      */
247     function HoQuToken(uint _totalSupply) {
248         require (_totalSupply > 0);
249         totalSupply = balances[msg.sender] = _totalSupply;
250     }
251 
252     function transfer(address _to, uint _value) whenNotPaused returns (bool) {
253         return super.transfer(_to, _value);
254     }
255 
256     function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
257         return super.transferFrom(_from, _to, _value);
258     }
259 }
260 
261 /**
262  * @title ClaimableCrowdsale
263  * @title HoQu.io claimable crowdsale contract.
264  */
265 contract ClaimableCrowdsale is Pausable {
266     using SafeMath for uint256;
267 
268     // all accepted ethers will be sent to this address
269     address beneficiaryAddress;
270 
271     // all remain tokens after ICO should go to that address
272     address public bankAddress;
273 
274     // token instance
275     HoQuToken public token;
276 
277     uint256 public maxTokensAmount;
278     uint256 public issuedTokensAmount = 0;
279     uint256 public minBuyableAmount;
280     uint256 public tokenRate; // amount of HQX per 1 ETH
281     
282     uint256 endDate;
283 
284     bool public isFinished = false;
285 
286     // buffer for claimable tokens
287     mapping(address => uint256) public tokens;
288     mapping(address => bool) public approved;
289     mapping(uint32 => address) internal tokenReceivers;
290     uint32 internal receiversCount;
291 
292     /**
293     * Events for token purchase logging
294     */
295     event TokenBought(address indexed _buyer, uint256 _tokens, uint256 _amount);
296     event TokenAdded(address indexed _receiver, uint256 _tokens, uint256 _equivalentAmount);
297     event TokenToppedUp(address indexed _receiver, uint256 _tokens, uint256 _equivalentAmount);
298     event TokenSubtracted(address indexed _receiver, uint256 _tokens, uint256 _equivalentAmount);
299     event TokenSent(address indexed _receiver, uint256 _tokens);
300 
301     modifier inProgress() {
302         require (!isFinished);
303         require (issuedTokensAmount < maxTokensAmount);
304         require (now <= endDate);
305         _;
306     }
307     
308     /**
309     * @param _tokenAddress address of a HQX token contract
310     * @param _bankAddress address for remain HQX tokens accumulation
311     * @param _beneficiaryAddress accepted ETH go to this address
312     * @param _tokenRate rate HQX per 1 ETH
313     * @param _minBuyableAmount min ETH per each buy action (in ETH wei)
314     * @param _maxTokensAmount ICO HQX capacity (in HQX wei)
315     * @param _endDate the date when ICO will expire
316     */
317     function ClaimableCrowdsale(
318         address _tokenAddress,
319         address _bankAddress,
320         address _beneficiaryAddress,
321         uint256 _tokenRate,
322         uint256 _minBuyableAmount,
323         uint256 _maxTokensAmount,
324         uint256 _endDate
325     ) {
326         token = HoQuToken(_tokenAddress);
327 
328         bankAddress = _bankAddress;
329         beneficiaryAddress = _beneficiaryAddress;
330 
331         tokenRate = _tokenRate;
332         minBuyableAmount = _minBuyableAmount;
333         maxTokensAmount = _maxTokensAmount;
334 
335         endDate = _endDate;
336     }
337 
338     /*
339      * @dev Set new HoQu token exchange rate.
340      */
341     function setTokenRate(uint256 _tokenRate) onlyOwner {
342         require (_tokenRate > 0);
343         tokenRate = _tokenRate;
344     }
345 
346     /**
347      * Buy HQX. Tokens will be stored in contract until claim stage
348      */
349     function buy() payable inProgress whenNotPaused {
350         uint256 payAmount = msg.value;
351         uint256 returnAmount = 0;
352 
353         // calculate token amount to be transfered to investor
354         uint256 tokensAmount = tokenRate.mul(payAmount);
355     
356         if (issuedTokensAmount + tokensAmount > maxTokensAmount) {
357             tokensAmount = maxTokensAmount.sub(issuedTokensAmount);
358             payAmount = tokensAmount.div(tokenRate);
359             returnAmount = msg.value.sub(payAmount);
360         }
361     
362         issuedTokensAmount = issuedTokensAmount.add(tokensAmount);
363         require (issuedTokensAmount <= maxTokensAmount);
364 
365         storeTokens(msg.sender, tokensAmount);
366         TokenBought(msg.sender, tokensAmount, payAmount);
367 
368         beneficiaryAddress.transfer(payAmount);
369     
370         if (returnAmount > 0) {
371             msg.sender.transfer(returnAmount);
372         }
373     }
374 
375     /**
376      * Add HQX payed by another crypto (BTC, LTC). Tokens will be stored in contract until claim stage
377      */
378     function add(address _receiver, uint256 _equivalentEthAmount) onlyOwner inProgress whenNotPaused {
379         uint256 tokensAmount = tokenRate.mul(_equivalentEthAmount);
380         issuedTokensAmount = issuedTokensAmount.add(tokensAmount);
381 
382         storeTokens(_receiver, tokensAmount);
383         TokenAdded(_receiver, tokensAmount, _equivalentEthAmount);
384     }
385 
386     /**
387      * Add HQX by referral program. Tokens will be stored in contract until claim stage
388      */
389     function topUp(address _receiver, uint256 _equivalentEthAmount) onlyOwner whenNotPaused {
390         uint256 tokensAmount = tokenRate.mul(_equivalentEthAmount);
391         issuedTokensAmount = issuedTokensAmount.add(tokensAmount);
392 
393         storeTokens(_receiver, tokensAmount);
394         TokenToppedUp(_receiver, tokensAmount, _equivalentEthAmount);
395     }
396 
397     /**
398      * Reduce bought HQX amount. Emergency use only
399      */
400     function sub(address _receiver, uint256 _equivalentEthAmount) onlyOwner whenNotPaused {
401         uint256 tokensAmount = tokenRate.mul(_equivalentEthAmount);
402 
403         require (tokens[_receiver] >= tokensAmount);
404 
405         tokens[_receiver] = tokens[_receiver].sub(tokensAmount);
406         issuedTokensAmount = issuedTokensAmount.sub(tokensAmount);
407 
408         TokenSubtracted(_receiver, tokensAmount, _equivalentEthAmount);
409     }
410 
411     /**
412      * Internal method for storing tokens in contract until claim stage
413      */
414     function storeTokens(address _receiver, uint256 _tokensAmount) internal whenNotPaused {
415         if (tokens[_receiver] == 0) {
416             tokenReceivers[receiversCount] = _receiver;
417             receiversCount++;
418             approved[_receiver] = false;
419         }
420         tokens[_receiver] = tokens[_receiver].add(_tokensAmount);
421     }
422 
423     /**
424      * Claim all bought HQX. Available tokens will be sent to transaction sender address if it is approved
425      */
426     function claim() whenNotPaused {
427         claimFor(msg.sender);
428     }
429 
430     /**
431      * Claim all bought HQX for specific approved address
432      */
433     function claimOne(address _receiver) onlyOwner whenNotPaused {
434         claimFor(_receiver);
435     }
436 
437     /**
438      * Claim all bought HQX for all approved addresses
439      */
440     function claimAll() onlyOwner whenNotPaused {
441         for (uint32 i = 0; i < receiversCount; i++) {
442             address receiver = tokenReceivers[i];
443             if (approved[receiver] && tokens[receiver] > 0) {
444                 claimFor(receiver);
445             }
446         }
447     }
448 
449     /**
450      * Internal method for claiming tokens for specific approved address
451      */
452     function claimFor(address _receiver) internal whenNotPaused {
453         require(approved[_receiver]);
454         require(tokens[_receiver] > 0);
455 
456         uint256 tokensToSend = tokens[_receiver];
457         tokens[_receiver] = 0;
458 
459         token.transferFrom(bankAddress, _receiver, tokensToSend);
460         TokenSent(_receiver, tokensToSend);
461     }
462 
463     function approve(address _receiver) onlyOwner whenNotPaused {
464         approved[_receiver] = true;
465     }
466     
467     /**
468      * Finish Sale.
469      */
470     function finish() onlyOwner {
471         require (issuedTokensAmount >= maxTokensAmount || now > endDate);
472         require (!isFinished);
473         isFinished = true;
474         token.transfer(bankAddress, token.balanceOf(this));
475     }
476 
477     function getReceiversCount() constant onlyOwner returns (uint32) {
478         return receiversCount;
479     }
480 
481     function getReceiver(uint32 i) constant onlyOwner returns (address) {
482         return tokenReceivers[i];
483     }
484     
485     /**
486      * Buy HQX. Tokens will be stored in contract until claim stage
487      */
488     function() external payable {
489         buy();
490     }
491 }