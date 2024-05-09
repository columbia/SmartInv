1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     address public owner;
41 
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47     function Ownable() {
48         owner = msg.sender;
49     }
50 
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         if (msg.sender != owner) {
57             revert();
58         }
59         _;
60     }
61 
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) onlyOwner {
68         if (newOwner != address(0)) {
69             owner = newOwner;
70         }
71     }
72 
73 }
74 
75 /**
76  * @title ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 contract ERC20 {
80     uint256 public tokenTotalSupply;
81 
82     function balanceOf(address who) constant returns(uint256);
83 
84     function allowance(address owner, address spender) constant returns(uint256);
85 
86     function transfer(address to, uint256 value) returns (bool success);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     function transferFrom(address from, address to, uint256 value) returns (bool success);
90 
91     function approve(address spender, uint256 value) returns (bool success);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 
94     function totalSupply() constant returns (uint256 availableSupply);
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implemantation of the basic standart token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract BioToken is ERC20, Ownable {
105     using SafeMath for uint;
106 
107     string public name = "BIONT Token";
108     string public symbol = "BIONT";
109     uint public decimals = 18;
110 
111     bool public tradingStarted = false;
112     bool public mintingFinished = false;
113     bool public salePaused = false;
114 
115     uint256 public tokenTotalSupply = 0;
116     uint256 public trashedTokens = 0;
117     uint256 public hardcap = 140000000 * (10 ** decimals); // 140 million tokens
118     uint256 public ownerTokens = 14000000 * (10 ** decimals); // 14 million tokens
119 
120     uint public ethToToken = 300; // 1 eth buys 300 tokens
121     uint public noContributors = 0;
122 
123     uint public start = 1503346080; // 08/21/2017 @ 20:08pm (UTC)
124     uint public initialSaleEndDate = start + 9 weeks;
125     uint public ownerGrace = initialSaleEndDate + 182 days;
126     uint public fiveYearGrace = initialSaleEndDate + 5 * 365 days;
127 
128     address public multisigVault;
129     address public lockedVault;
130     address public ownerVault;
131 
132     address public authorizerOne;
133     address public authorizerTwo;
134 
135     mapping(address => uint256) balances;
136     mapping(address => mapping(address => uint256)) allowed;
137     mapping(address => uint256) authorizedWithdrawal;
138 
139     event Mint(address indexed to, uint256 value);
140     event MintFinished();
141     event TokenSold(address recipient, uint256 ether_amount, uint256 pay_amount, uint256 exchangerate);
142     event MainSaleClosed();
143 
144     /**
145      * @dev Fix for the ERC20 short address attack.
146      */
147     modifier onlyPayloadSize(uint size) {
148         if (msg.data.length < size + 4) {
149             revert();
150         }
151         _;
152     }
153 
154     modifier canMint() {
155         if (mintingFinished) {
156             revert();
157         }
158 
159         _;
160     }
161 
162     /**
163      * @dev modifier that throws if trading has not started yet
164      */
165     modifier hasStartedTrading() {
166         require(tradingStarted);
167         _;
168     }
169 
170     /**
171      * @dev modifier to allow token creation only when the sale IS ON
172      */
173     modifier saleIsOn() {
174         require(now > start && now < initialSaleEndDate && salePaused == false);
175         _;
176     }
177 
178     /**
179      * @dev modifier to allow token creation only when the hardcap has not been reached
180      */
181     modifier isUnderHardCap() {
182         require(tokenTotalSupply <= hardcap);
183         _;
184     }
185 
186     function BioToken(address _ownerVault, address _authorizerOne, address _authorizerTwo, address _lockedVault, address _multisigVault) {
187         ownerVault = _ownerVault;
188         authorizerOne = _authorizerOne;
189         authorizerTwo = _authorizerTwo;
190         lockedVault = _lockedVault;
191         multisigVault = _multisigVault;
192 
193         mint(ownerVault, ownerTokens);
194     }
195 
196     /**
197      * @dev Function to mint tokens
198      * @param _to The address that will recieve the minted tokens.
199      * @param _amount The amount of tokens to mint.
200      * @return A boolean that indicates if the operation was successful.
201      */
202     function mint(address _to, uint256 _amount) private canMint returns(bool) {
203         tokenTotalSupply = tokenTotalSupply.add(_amount);
204 
205         require(tokenTotalSupply <= hardcap);
206 
207         balances[_to] = balances[_to].add(_amount);
208         noContributors = noContributors.add(1);
209         Mint(_to, _amount);
210         Transfer(this, _to, _amount);
211         return true;
212     }
213 
214     /**
215      * @dev Function to mint tokens
216      * @param _to The address that will recieve the minted tokens.
217      * @param _amount The amount of tokens to mint.
218      * @return A boolean that indicates if the operation was successful.
219      */
220     function masterMint(address _to, uint256 _amount) public canMint onlyOwner returns(bool) {
221         tokenTotalSupply = tokenTotalSupply.add(_amount);
222 
223         require(tokenTotalSupply <= hardcap);
224 
225         balances[_to] = balances[_to].add(_amount);
226         noContributors = noContributors.add(1);
227         Mint(_to, _amount);
228         Transfer(this, _to, _amount);
229         return true;
230     }
231 
232     /**
233      * @dev Function to stop minting new tokens.
234      * @return True if the operation was successful.
235      */
236     function finishMinting() private onlyOwner returns(bool) {
237         mintingFinished = true;
238         MintFinished();
239         return true;
240     }
241 
242     /**
243      * @dev transfer token for a specified address
244      * @param _to The address to transfer to.
245      * @param _value The amount to be transferred.
246      */
247     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) hasStartedTrading returns (bool success) {
248         // don't allow the vault to make transfers
249         if (msg.sender == lockedVault && now < fiveYearGrace) {
250             revert();
251         }
252 
253         // owner needs to wait as well
254         if (msg.sender == ownerVault && now < ownerGrace) {
255             revert();
256         }
257 
258         balances[msg.sender] = balances[msg.sender].sub(_value);
259         balances[_to] = balances[_to].add(_value);
260         Transfer(msg.sender, _to, _value);
261 
262         return true;
263     }
264 
265     /**
266      * @dev Transfer tokens from one address to another
267      * @param _from address The address which you want to send tokens from
268      * @param _to address The address which you want to transfer to
269      * @param _value uint256 the amout of tokens to be transfered
270      */
271     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) hasStartedTrading returns (bool success) {
272         if (_from == lockedVault && now < fiveYearGrace) {
273             revert();
274         }
275 
276         // owner needs to wait as well
277         if (_from == ownerVault && now < ownerGrace) {
278             revert();
279         }
280 
281         var _allowance = allowed[_from][msg.sender];
282 
283         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
284         // if (_value > _allowance) throw;
285 
286         balances[_to] = balances[_to].add(_value);
287         balances[_from] = balances[_from].sub(_value);
288         allowed[_from][msg.sender] = _allowance.sub(_value);
289         Transfer(_from, _to, _value);
290 
291         return true;
292     }
293 
294     /**
295      * @dev Transfer tokens from one address to another according to off exchange agreements
296      * @param _from address The address which you want to send tokens from
297      * @param _to address The address which you want to transfer to
298      * @param _value uint256 the amount of tokens to be transferred
299      */
300     function masterTransferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public hasStartedTrading onlyOwner returns (bool success) {
301         if (_from == lockedVault && now < fiveYearGrace) {
302             revert();
303         }
304 
305         // owner needs to wait as well
306         if (_from == ownerVault && now < ownerGrace) {
307             revert();
308         }
309 
310         balances[_to] = balances[_to].add(_value);
311         balances[_from] = balances[_from].sub(_value);
312         Transfer(_from, _to, _value);
313 
314         return true;
315     }
316 
317     function totalSupply() constant returns (uint256 availableSupply) {
318         return tokenTotalSupply;
319     }
320 
321     /**
322      * @dev Gets the balance of the specified address.
323      * @param _owner The address to query the the balance of.
324      * @return An uint256 representing the amount owned by the passed address.
325      */
326     function balanceOf(address _owner) constant returns(uint256 balance) {
327         return balances[_owner];
328     }
329 
330     /**
331      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
332      * @param _spender The address which will spend the funds.
333      * @param _value The amount of tokens to be spent.
334      */
335     function approve(address _spender, uint256 _value) returns (bool success) {
336 
337         // To change the approve amount you first have to reduce the addresses`
338         //  allowance to zero by calling `approve(_spender, 0)` if it is not
339         //  already 0 to mitigate the race condition described here:
340         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
341         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
342             revert();
343         }
344 
345         allowed[msg.sender][_spender] = _value;
346         Approval(msg.sender, _spender, _value);
347 
348         return true;
349     }
350 
351     /**
352      * @dev Function to check the amount of tokens than an owner allowed to a spender.
353      * @param _owner address The address which owns the funds.
354      * @param _spender address The address which will spend the funds.
355      * @return A uint256 specifying the amount of tokens still available for the spender.
356      */
357     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
358         return allowed[_owner][_spender];
359     }
360 
361     /**
362      * @dev Allows the owner to enable the trading. This can not be undone
363      */
364     function startTrading() onlyOwner {
365         tradingStarted = true;
366     }
367 
368     /**
369      * @dev Allows the owner to enable the trading. This can not be undone
370      */
371     function pauseSale() onlyOwner {
372         salePaused = true;
373     }
374 
375     /**
376      * @dev Allows the owner to enable the trading. This can not be undone
377      */
378     function resumeSale() onlyOwner {
379         salePaused = false;
380     }
381 
382     /**
383      * @dev Allows the owner to enable the trading. This can not be undone
384      */
385     function getNoContributors() constant returns(uint contributors) {
386         return noContributors;
387     }
388 
389     /**
390      * @dev Allows the owner to set the multisig wallet address.
391      * @param _multisigVault the multisig wallet address
392      */
393     function setMultisigVault(address _multisigVault) public onlyOwner {
394         if (_multisigVault != address(0)) {
395             multisigVault = _multisigVault;
396         }
397     }
398 
399     function setAuthorizedWithdrawalAmount(uint256 _amount) public {
400         if (_amount < 0) {
401             revert();
402         }
403 
404         if (msg.sender != authorizerOne && msg.sender != authorizerTwo) {
405             revert();
406         }
407 
408         authorizedWithdrawal[msg.sender] = _amount;
409     }
410 
411     /**
412      * @dev Allows the owner to send the funds to the vault.
413      * @param _amount the amount in wei to send
414      */
415     function withdrawEthereum(uint256 _amount) public onlyOwner {
416         require(multisigVault != address(0));
417         require(_amount <= this.balance); // wei
418 
419         if (authorizedWithdrawal[authorizerOne] != authorizedWithdrawal[authorizerTwo]) {
420             revert();
421         }
422 
423         if (_amount > authorizedWithdrawal[authorizerOne]) {
424             revert();
425         }
426 
427         if (!multisigVault.send(_amount)) {
428             revert();
429         }
430 
431         authorizedWithdrawal[authorizerOne] = authorizedWithdrawal[authorizerOne].sub(_amount);
432         authorizedWithdrawal[authorizerTwo] = authorizedWithdrawal[authorizerTwo].sub(_amount);
433     }
434 
435     function showAuthorizerOneAmount() constant public returns(uint256 remaining) {
436         return authorizedWithdrawal[authorizerOne];
437     }
438 
439     function showAuthorizerTwoAmount() constant public returns(uint256 remaining) {
440         return authorizedWithdrawal[authorizerTwo];
441     }
442 
443     function showEthBalance() constant public returns(uint256 remaining) {
444         return this.balance;
445     }
446 
447     function retrieveTokens() public onlyOwner {
448         require(lockedVault != address(0));
449 
450         uint256 capOut = hardcap.sub(tokenTotalSupply);
451         tokenTotalSupply = hardcap;
452 
453         balances[lockedVault] = balances[lockedVault].add(capOut);
454         Transfer(this, lockedVault, capOut);
455     }
456 
457     function trashTokens(address _from, uint256 _amount) onlyOwner returns(bool) {
458         balances[_from] = balances[_from].sub(_amount);
459         trashedTokens = trashedTokens.add(_amount);
460         tokenTotalSupply = tokenTotalSupply.sub(_amount);
461     }
462 
463     function decreaseSupply(uint256 value, address from) onlyOwner returns (bool) {
464       balances[from] = balances[from].sub(value);
465       trashedTokens = trashedTokens.add(value);
466       tokenTotalSupply = tokenTotalSupply.sub(value);
467       Transfer(from, 0, value);
468       return true;
469     }
470 
471     function finishSale() public onlyOwner {
472         finishMinting();
473         retrieveTokens();
474         startTrading();
475 
476         MainSaleClosed();
477     }
478 
479     function saleOn() constant returns(bool) {
480         return (now > start && now < initialSaleEndDate && salePaused == false);
481     }
482 
483     /**
484      * @dev Allows anyone to create tokens by depositing ether.
485      * @param recipient the recipient to receive tokens.
486      */
487     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
488         uint bonus = 0;
489         uint period = 1 weeks;
490         uint256 tokens;
491 
492         if (now <= start + 2 * period) {
493             bonus = 20;
494         } else if (now > start + 2 * period && now <= start + 3 * period) {
495             bonus = 15;
496         } else if (now > start + 3 * period && now <= start + 4 * period) {
497             bonus = 10;
498         } else if (now > start + 4 * period && now <= start + 5 * period) {
499             bonus = 5;
500         }
501 
502         // the bonus is in percentages, solidity is doing standard integer division, basically rounding 'down'
503         if (bonus > 0) {
504             tokens = ethToToken.mul(msg.value) + ethToToken.mul(msg.value).mul(bonus).div(100);
505         } else {
506             tokens = ethToToken.mul(msg.value);
507         }
508 
509         if (tokens <= 0) {
510             revert();
511         }
512 
513         mint(recipient, tokens);
514 
515         TokenSold(recipient, msg.value, tokens, ethToToken);
516     }
517 
518     function() external payable {
519         createTokens(msg.sender);
520     }
521 }