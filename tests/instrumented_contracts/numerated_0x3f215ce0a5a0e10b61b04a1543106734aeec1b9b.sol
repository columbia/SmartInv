1 pragma solidity >=0.4.22 <0.6.0;
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
13         // assert(a == b * c + a % b); // There tis no case in which this doesn't hold
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
27 }
28 
29 contract Ownable {
30     address public owner;
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32   /** 
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36     constructor() public {
37         owner = msg.sender;
38     }
39   /**
40    * @dev Throws if called by any account other than the owner. 
41    */
42     modifier onlyOwner() {
43         require(msg.sender == owner,"Owner can call this function.");
44         _;
45     }
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to. 
49    */
50     function transferOwnership(address newOwner) public onlyOwner {
51         require(newOwner != address(0),"Use new owner address.");
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     } 
55 }
56 
57   
58 contract ERC223 {
59     function totalSupply() public view returns (uint256);
60     function balanceOf(address who) public view returns (uint256);
61     function roleOf(address who) public view returns (uint256);
62     function setUserRole(address _user_address, uint256 _role_define) public;
63     function transfer(address to, uint256 value) public;
64     function transfer(address to, uint value, bytes memory data) public;
65     function transferFrom(address from, address to, uint256 value) public;
66     function approve(address spender, uint256 value) public;
67     function allowance(address owner, address spender) public view returns (uint256);
68     event Transfer(address indexed from, address indexed to, uint value, bytes data);
69     event Transfer(address indexed from, address indexed to, uint256 value);    
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 // Interface for the contract which implements the ERC223 fallback
74 contract ERC223ReceivingContract { 
75     function tokenFallback(address _from, uint _value, bytes memory _data) public;
76 }
77 
78 contract WRTToken is Ownable, ERC223 {
79     using SafeMath for uint256;
80     // Token properties
81     string public name = "Warrior Token";
82     string public symbol = "WRT";
83     uint256 public decimals = 18;
84     uint256 public numberDecimal18 = 1000000000000000000;
85     uint256 public RATE = 360e18;
86 
87     // Distribution of tokens
88     uint256 public _totalSupply = 100000000e18;
89     uint256 public _presaleSupply = 5000000e18; // 5% for presale
90     uint256 public _projTeamSupply = 5000000e18; // 5% for project team ( will be time sealed for 6 months )
91     uint256 public _PartnersSupply = 10000000e18; // 10% for partners and advisors ( will be time sealed for 12 months )
92     uint256 public _PRSupply = 9000000e18; // 9% for marketing and bonus 
93     uint256 public _metaIcoSupply = 1000000e18; // 1% for Expenses done during the ICO i.e. marketing
94     uint256 public _icoSupply = 30000000e18; // 30% for ICO
95 
96     //number of total tokens sold in main sale
97     uint256 public totalNumberTokenSoldMainSale = 0;
98     uint256 public totalNumberTokenSoldPreSale = 0;
99 
100     uint256 public softCapUSD = 5000000;
101     uint256 public hardCapUSD = 10000000;
102     
103     bool public mintingFinished = false;
104     bool public tradable = true;
105     bool public active = true;
106 
107 
108     // Balances for each account
109     mapping (address => uint256) balances;
110     
111     // role for each account
112     // 0 => No Role, 1 =>Admin, 2 => Team, 3=> Advisors, 4=> Partner, 5=> Marketing, 6=> MetaICO
113     
114     mapping (address => uint256) role;
115     
116     // time seal for upper management
117     mapping (address => uint256) vault;
118 
119     // Owner of account approves the transfer of an amount to another account
120     mapping (address => mapping(address => uint256)) allowed;
121 
122     mapping (address => bool) whitelist;
123 
124     // start and end timestamps where investments are allowed (both inclusive)
125     uint256 public mainSaleStartTime; 
126     uint256 public mainSaleEndTime;
127     uint256 public preSaleStartTime;
128     uint256 public preSaleEndTime;
129     
130     uint256 public projsealDate; // seal date for project team 
131     uint256 public partnersealDate; // seal date for partners and advisors ( will be time sealed for 12 months )
132 
133 
134     uint256 contractDeployedTime;
135     
136 
137     // Wallet Address of Token
138     address payable public  multisig;
139 
140     // how many token units a buyer get in base unit 
141 
142     event MintFinished();
143     event StartTradable();
144     event PauseTradable();
145     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
146     event Burn(address indexed burner, uint256 value);
147 
148 
149     modifier canMint() {
150         require(!mintingFinished);
151         _;
152     }
153 
154     modifier canTradable() {
155         require(tradable);
156         _;
157     }
158 
159     modifier isActive() {
160         require(active);
161         _;
162     }
163     
164     modifier saleIsOpen(){
165         require((mainSaleStartTime <= now && now <= mainSaleEndTime) || (preSaleStartTime <= now && now <= preSaleEndTime));
166         _;
167     }
168 
169     // Constructor
170     // @notice WarriorToken Contract
171     // @return the transaction address
172     constructor(address payable _multisig, uint256 _preSaleStartTime, uint256 _mainSaleStartTime) public {
173         require(_multisig != address(0x0),"Invalid address.");
174         require(_mainSaleStartTime > _preSaleStartTime);
175         multisig = _multisig;
176 
177 
178         mainSaleStartTime = _mainSaleStartTime;
179         preSaleStartTime = _preSaleStartTime;
180         // for now the token sale will run for 60 days
181         mainSaleEndTime = mainSaleStartTime + 60 days;
182         preSaleEndTime = preSaleStartTime + 60 days;
183         contractDeployedTime = now;
184 
185         balances[multisig] = _totalSupply;
186 
187         // The project team can get their token 180days after the main sale ends
188         projsealDate = mainSaleEndTime + 180 days;
189         // The partners and advisors can get their token 1 year after the main sale ends
190         partnersealDate = mainSaleEndTime + 365 days;
191 
192         owner = msg.sender;
193     }
194 
195     function getTimePassed() public view returns (uint256) {
196         return (now - contractDeployedTime).div(1 days);
197     }
198 
199     function isPresale() public view returns (bool) {
200         return now < preSaleEndTime && now > preSaleStartTime;
201     }
202 
203 
204     function applyBonus(uint256 tokens) public view returns (uint256) {
205         if ( now < (preSaleStartTime + 1 days) ) {
206             return tokens.mul(20).div(10); // 100% bonus     
207         } else if ( now < (preSaleStartTime + 7 days) ) {
208             return tokens.mul(15).div(10); // 50% bonus
209         } else if ( now < (preSaleStartTime + 14 days) ) {
210             return tokens.mul(13).div(10); // 30% bonus
211         } else if ( now < (preSaleStartTime + 21 days) ) {
212             return tokens.mul(115).div(100); // 15% bonus
213         } else if ( now < (preSaleStartTime + 28 days) ) {
214             return tokens.mul(11).div(10); // 10% bonus
215         } 
216         return tokens; // if reached till hear means no bonus 
217     }
218 
219     // Payable method
220     // @notice Anyone can buy the tokens on tokensale by paying ether
221     function () external payable {        
222         tokensale(msg.sender);
223     }
224 
225     // @notice tokensale
226     // @param recipient The address of the recipient
227     // @return the transaction address and send the event as Transfer
228     function tokensale(address recipient) internal saleIsOpen isActive {
229         require(recipient != address(0x0));
230         require(validPurchase());
231         require(whitelisted(recipient));
232         
233         uint256 weiAmount = msg.value;
234         uint256 numberToken = weiAmount.mul(RATE).div(1 ether);
235 
236         numberToken = applyBonus(numberToken);
237         
238         // An investor is only allowed to buy tokens between 333 to 350,000 tokens
239         require(numberToken >= 333e18 && numberToken <= 350000e18);
240 
241         
242         // if its a presale
243         if (isPresale()) {
244             require(_presaleSupply >= numberToken);
245             totalNumberTokenSoldPreSale = totalNumberTokenSoldPreSale.add(numberToken);
246             _presaleSupply = _presaleSupply.sub(numberToken);
247         // as the validPurchase checks for the period, else block will only mean its main sale
248         } else {
249             require(_icoSupply >= numberToken);
250             totalNumberTokenSoldMainSale = totalNumberTokenSoldMainSale.add(numberToken);
251             _icoSupply = _icoSupply.sub(numberToken);
252         }
253     
254         updateBalances(recipient, numberToken);
255         forwardFunds();
256         whitelist[recipient] = false;
257     }
258 
259     function transFromProjTeamSupply(address receiver, uint256 tokens) public onlyOwner {
260  
261         require(tokens <= _projTeamSupply);
262         updateBalances(receiver, tokens);
263         _projTeamSupply = _projTeamSupply.sub(tokens);
264         role[receiver] = 2;
265     }
266 
267     function transFromPartnersSupply(address receiver, uint256 tokens) public onlyOwner {
268         require(tokens <= _PartnersSupply);
269         updateBalances(receiver, tokens);        
270         _PartnersSupply = _PartnersSupply.sub(tokens);
271         role[receiver] = 4;
272     }
273     
274     function setUserRole(address _user, uint256 _role) public onlyOwner {
275         role[_user] = _role;
276     }
277 
278     function transFromPRSupply(address receiver, uint256 tokens) public onlyOwner {
279         require(tokens <= _PRSupply);
280         updateBalances(receiver, tokens);
281         _PRSupply = _PRSupply.sub(tokens);
282         role[receiver] = 5;
283     }
284 
285     function transFromMetaICOSupply(address receiver, uint256 tokens) public onlyOwner {
286         require(tokens <= _metaIcoSupply);
287         updateBalances(receiver, tokens);
288         _metaIcoSupply = _metaIcoSupply.sub(tokens);
289         role[receiver] = 6;
290     }
291 
292     function setWhitelistStatus(address user, bool status) public onlyOwner returns (bool) {
293 
294         whitelist[user] = status; 
295         
296         return whitelist[user];
297     }
298     
299     function setWhitelistForBulk(address[] memory listAddresses, bool status) public onlyOwner {
300         for (uint256 i = 0; i < listAddresses.length; i++) {
301             whitelist[listAddresses[i]] = status;
302         }
303     }
304 
305     // used to transfer manually when senders are using BTC
306     function transferToAll(address[] memory tos, uint256[] memory values) public onlyOwner canTradable isActive {
307         require(
308             tos.length == values.length
309             );
310         
311         for(uint256 i = 0; i < tos.length; i++){
312             require(_icoSupply >= values[i]);   
313             totalNumberTokenSoldMainSale = totalNumberTokenSoldMainSale.add(values[i]);
314             _icoSupply = _icoSupply.sub(values[i]);
315             updateBalances(tos[i],values[i]);
316         }
317     }
318 
319     function transferToAllInPreSale(address[] memory tos, uint256[] memory values) public onlyOwner canTradable isActive {
320         require(
321             tos.length == values.length
322             );
323         
324         for(uint256 i = 0; i < tos.length; i++){
325             require(_presaleSupply >= values[i]);   
326             totalNumberTokenSoldPreSale = totalNumberTokenSoldPreSale.add(values[i]);
327             _presaleSupply = _presaleSupply.sub(values[i]);
328             updateBalances(tos[i],values[i]);
329         }
330     }
331     
332     function updateBalances(address receiver, uint256 tokens) internal {
333         balances[multisig] = balances[multisig].sub(tokens);
334         balances[receiver] = balances[receiver].add(tokens);
335         emit Transfer(multisig, receiver, tokens);
336     }
337 
338     function whitelisted(address user) public view returns (bool) {
339         return whitelist[user];
340     }
341     
342     // send ether to the fund collection wallet
343     // override to create custom fund forwarding mechanisms
344     function forwardFunds()  internal {
345        multisig.transfer(msg.value);
346     }
347 
348     
349     // @return true if the transaction can buy tokens
350     function validPurchase() internal view returns (bool) {
351         bool withinPeriod = (now >= mainSaleStartTime && now <= mainSaleEndTime) || (now >= preSaleStartTime && now <= preSaleEndTime);
352         bool nonZeroPurchase = msg.value != 0;
353         return withinPeriod && nonZeroPurchase;
354     }
355 
356     // @return true if crowdsale current lot event has ended
357     function hasEnded() public view returns (bool) {
358         return now > mainSaleEndTime;
359     }
360 
361     function hasPreSaleEnded() public view returns (bool) {
362         return now > preSaleEndTime;
363     }
364 
365     // Set/change Multi-signature wallet address
366     function changeMultiSignatureWallet(address payable _multisig) public onlyOwner isActive {
367         multisig = _multisig;
368     }
369 
370     // Change ETH/Token exchange rate
371     function changeTokenRate(uint _tokenPrice) public onlyOwner isActive {
372         RATE = _tokenPrice;
373     }
374 
375     // Set Finish Minting.
376     function finishMinting() public onlyOwner isActive {
377         mintingFinished = true;
378         emit MintFinished();
379     }
380 
381     // Start or pause tradable to Transfer token
382     function startTradable(bool _tradable) public onlyOwner isActive {
383         tradable = _tradable;
384         if (tradable)
385             emit StartTradable();
386         else
387             emit PauseTradable();
388     }
389     
390     function setActive(bool _active) public onlyOwner {
391         active = _active;
392     }
393     
394     //Change mainSaleStartTime to start ICO manually
395     function changeMainSaleStartTime(uint256 _mainSaleStartTime) public onlyOwner {
396         mainSaleStartTime = _mainSaleStartTime;
397     }
398 
399     //Change mainSaleEndTime to end ICO manually
400     function changeMainSaleEndTime(uint256 _mainSaleEndTime) public onlyOwner {
401         mainSaleEndTime = _mainSaleEndTime;
402     }
403 
404     function changePreSaleStartTime(uint256 _preSaleStartTime) public onlyOwner {
405         preSaleStartTime = _preSaleStartTime;
406     }
407 
408     //Change mainSaleEndTime to end ICO manually
409     function changePreSaleEndTime(uint256 _preSaleEndTime) public onlyOwner {
410         preSaleEndTime = _preSaleEndTime;
411     }
412 
413     //Change total supply
414     function changeTotalSupply(uint256 newSupply) public onlyOwner {
415         _totalSupply = newSupply;
416     }
417 
418     // In case multiple ICOs are planned, use this with the totalSupply function
419     function changeICOSupply(uint256 newICOSupply) public onlyOwner {
420         _icoSupply = newICOSupply;
421     }
422 
423     // Get current price of a Token
424     // @return the price or token value for a ether
425     function getRate() public view returns (uint256 result) {
426         return RATE;
427     }
428     
429     function getTokenDetail() public view returns (string memory, string memory, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
430         return (name, symbol, mainSaleStartTime, mainSaleEndTime, preSaleStartTime, preSaleEndTime, _totalSupply, _icoSupply, _presaleSupply, totalNumberTokenSoldMainSale, totalNumberTokenSoldPreSale);
431     }
432 
433 
434     // ERC223 Methods  
435     
436     // What is the balance of a particular account?
437     // @param who The address of the particular account
438     // @return the balance the particular account
439     function balanceOf(address who) public view returns (uint256) {
440         return balances[who];
441     }
442     function roleOf(address who) public view returns (uint256) {
443         return role[who];
444     }
445 
446     // @return total tokens supplied
447     function totalSupply() public view returns (uint256) {
448         return _totalSupply;
449     }
450     
451     function burn(uint256 _value) public {
452         require(_value <= balances[msg.sender]);
453         balances[msg.sender] = balances[msg.sender].sub(_value);
454         _totalSupply = _totalSupply.sub(_value);
455         emit Burn(multisig, _value);
456         
457     }
458     
459     /**
460      * @dev Transfer the specified amount of tokens to the specified address.
461      *      Invokes the `tokenFallback` function if the recipient is a contract.
462      *      The token transfer fails if the recipient is a contract
463      *      but does not implement the `tokenFallback` function
464      *      or the fallback function to receive funds.
465      *
466      * @param _to    Receiver address.
467      * @param _value Amount of tokens that will be transferred.
468      * @param _data  Transaction metadata.
469      */
470     function transfer(address _to, uint _value, bytes memory _data) public {
471         // Standard function transfer similar to ERC20 transfer with no _data .
472         // Added due to backwards compatibility reasons .
473         uint codeLength;
474 
475         assembly {
476             // Retrieve the size of the code on target address, this needs assembly .
477             codeLength := extcodesize(_to)
478         }
479         if(role[msg.sender] == 2)
480         {
481             require(now >= projsealDate,"you can not transfer yet");
482         }
483         if(role[msg.sender] == 3 || role[msg.sender] == 4)
484         {
485             require(now >= partnersealDate,"you can not transfer yet");
486         }
487 
488         balances[msg.sender] = balances[msg.sender].sub(_value);
489         balances[_to] = balances[_to].add(_value);
490         if(codeLength>0) {
491             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
492             receiver.tokenFallback(msg.sender, _value, _data);
493         }
494         emit Transfer(msg.sender, _to, _value, _data);
495     }
496     
497     /**
498      * @dev Transfer the specified amount of tokens to the specified address.
499      *      This function works the same with the previous one
500      *      but doesn't contain `_data` param.
501      *      Added due to backwards compatibility reasons.
502      *
503      * @param _to    Receiver address.
504      * @param _value Amount of tokens that will be transferred.
505      */
506     function transfer(address _to, uint _value) public {
507         uint codeLength;
508         bytes memory empty;
509         assembly {
510             // Retrieve the size of the code on target address, this needs assembly .
511             codeLength := extcodesize(_to)
512         }
513        if(role[msg.sender] == 2)
514         {
515             require(now >= projsealDate,"you can not transfer yet");
516         }
517         if(role[msg.sender] == 3 || role[msg.sender] == 4)
518         {
519             require(now >= partnersealDate,"you can not transfer yet");
520         }
521         balances[msg.sender] = balances[msg.sender].sub(_value);
522         balances[_to] = balances[_to].add(_value);
523         if(codeLength>0) {
524             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
525             receiver.tokenFallback(msg.sender, _value, empty);
526         }
527         emit Transfer(msg.sender, _to, _value, empty);
528     }
529 
530     // @notice send `value` token to `to` from `from`
531     // @param from The address of the sender
532     // @param to The address of the recipient
533     // @param value The amount of token to be transferred
534     // @return the transaction address and send the event as Transfer
535     function transferFrom(address from, address to, uint256 value) public canTradable isActive {
536         require (
537             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
538         );
539         if(role[from] == 2)
540         {
541             require(now >= projsealDate,"you can not transfer yet");
542         }
543         if(role[from] == 3 || role[from] == 4)
544         {
545             require(now >= partnersealDate,"you can not transfer yet");
546         }
547         balances[from] = balances[from].sub(value);
548         balances[to] = balances[to].add(value);
549         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
550         emit Transfer(from, to, value);
551     }
552     // Allow spender to withdraw from your account, multiple times, up to the value amount.
553     // If this function is called again it overwrites the current allowance with value.
554     // @param spender The address of the sender
555     // @param value The amount to be approved
556     // @return the transaction address and send the event as Approval
557     function approve(address spender, uint256 value) public isActive {
558         require (
559             balances[msg.sender] >= value && value > 0
560         );
561         allowed[msg.sender][spender] = value;
562         emit Approval(msg.sender, spender, value);
563     }
564     // Check the allowed value for the spender to withdraw from owner
565     // @param owner The address of the owner
566     // @param spender The address of the spender
567     // @return the amount which spender is still allowed to withdraw from owner
568     function allowance(address _owner, address spender) public view returns (uint256) {
569         return allowed[_owner][spender];
570     }    
571 }