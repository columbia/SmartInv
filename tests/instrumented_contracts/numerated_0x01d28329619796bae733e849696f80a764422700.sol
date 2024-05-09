1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4 
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
28 }
29 
30 contract ApproveAndCallReceiver {
31     function receiveApproval(
32         address _from, 
33         uint256 _amount, 
34         address _token, 
35         bytes _data
36     ) public;
37 }
38 
39 //normal contract. already compiled as bin
40 contract Controlled {
41     /// @notice The address of the controller is the only address that can call
42     ///  a function with this modifier
43     modifier onlyController { 
44         require(msg.sender == controller); 
45         _; 
46     }
47 
48     //block for check//bool private initialed = false;
49     address public controller;
50 
51     function Controlled() public {
52       //block for check//require(!initialed);
53       controller = msg.sender;
54       //block for check//initialed = true;
55     }
56 
57     /// @notice Changes the controller of the contract
58     /// @param _newController The new controller of the contract
59     function changeController(address _newController) onlyController public {
60         controller = _newController;
61     }
62 }
63 
64 contract ERC20Token {
65     /* This is a slight change to the ERC20 base standard.
66       function totalSupply() constant returns (uint256 supply);
67       is replaced with:
68       uint256 public totalSupply;
69       This automatically creates a getter function for the totalSupply.
70       This is moved to the base contract since public getter functions are not
71       currently recognised as an implementation of the matching abstract
72       function by the compiler.
73     */
74     /// total amount of tokens
75     uint256 public totalSupply;
76     //function totalSupply() public constant returns (uint256 balance);
77 
78     /// @param _owner The address from which the balance will be retrieved
79     /// @return The balance
80     mapping (address => uint256) public balanceOf;
81     //function balanceOf(address _owner) public constant returns (uint256 balance);
82 
83     /// @notice send `_value` token to `_to` from `msg.sender`
84     /// @param _to The address of the recipient
85     /// @param _value The amount of token to be transferred
86     /// @return Whether the transfer was successful or not
87     function transfer(address _to, uint256 _value) public returns (bool success);
88 
89     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
90     /// @param _from The address of the sender
91     /// @param _to The address of the recipient
92     /// @param _value The amount of token to be transferred
93     /// @return Whether the transfer was successful or not
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
95 
96     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
97     /// @param _spender The address of the account able to transfer the tokens
98     /// @param _value The amount of tokens to be approved for transfer
99     /// @return Whether the approval was successful or not
100     function approve(address _spender, uint256 _value) public returns (bool success);
101 
102     /// @param _owner The address of the account owning tokens
103     /// @param _spender The address of the account able to transfer the tokens
104     /// @return Amount of remaining tokens allowed to spent
105     mapping (address => mapping (address => uint256)) public allowance;
106     //function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
107 
108     event Transfer(address indexed _from, address indexed _to, uint256 _value);
109     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
110 }
111 
112 //abstract contract. used for interface
113 contract TokenController {
114     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
115     /// @param _owner The address that sent the ether to create tokens
116     /// @return True if the ether is accepted, false if it throws
117     function proxyPayment(address _owner) payable public returns(bool);
118 
119     /// @notice Notifies the controller about a token transfer allowing the
120     ///  controller to react if desired
121     /// @param _from The origin of the transfer
122     /// @param _to The destination of the transfer
123     /// @param _amount The amount of the transfer
124     /// @return False if the controller does not authorize the transfer
125     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
126 
127     /// @notice Notifies the controller about an approval allowing the
128     ///  controller to react if desired
129     /// @param _owner The address that calls `approve()`
130     /// @param _spender The spender in the `approve()` call
131     /// @param _amount The amount in the `approve()` call
132     /// @return False if the controller does not authorize the approval
133     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
134 }
135 
136 
137 contract TokenI is ERC20Token, Controlled {
138 
139     string public name;                //The Token's name: e.g. DigixDAO Tokens
140     uint8 public decimals;             //Number of decimals of the smallest unit
141     string public symbol;              //An identifier: e.g. REP
142 
143 ///////////////////
144 // ERC20 Methods
145 ///////////////////
146 
147     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
148     ///  its behalf, and then a function is triggered in the contract that is
149     ///  being approved, `_spender`. This allows users to use their tokens to
150     ///  interact with contracts in one function call instead of two
151     /// @param _spender The address of the contract able to transfer the tokens
152     /// @param _amount The amount of tokens to be approved for transfer
153     /// @return True if the function call was successful
154     function approveAndCall(
155         address _spender,
156         uint256 _amount,
157         bytes _extraData
158     ) public returns (bool success);
159 
160 ////////////////
161 // Generate and destroy tokens
162 ////////////////
163 
164     /// @notice Generates `_amount` tokens that are assigned to `_owner`
165     /// @param _owner The address that will be assigned the new tokens
166     /// @param _amount The quantity of tokens generated
167     /// @return True if the tokens are generated correctly
168     function generateTokens(address _owner, uint _amount) public returns (bool);
169 
170 
171     /// @notice Burns `_amount` tokens from `_owner`
172     /// @param _owner The address that will lose the tokens
173     /// @param _amount The quantity of tokens to burn
174     /// @return True if the tokens are burned correctly
175     function destroyTokens(address _owner, uint _amount) public returns (bool);
176 
177 ////////////////
178 // Enable tokens transfers
179 ////////////////
180 
181     /// @notice Enables token holders to transfer their tokens freely if true
182     /// @param _transfersEnabled True if transfers are allowed in the clone
183     function enableTransfers(bool _transfersEnabled) public;
184 
185 //////////
186 // Safety Methods
187 //////////
188 
189     /// @notice This method can be used by the controller to extract mistakenly
190     ///  sent tokens to this contract.
191     /// @param _token The address of the token contract that you want to recover
192     ///  set to 0 in case you want to extract ether.
193     function claimTokens(address _token) public;
194 
195 ////////////////
196 // Events
197 ////////////////
198 
199     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
200 }
201 
202 contract Token is TokenI {
203     using SafeMath for uint256;
204 
205     address public owner;
206 
207     uint256 public maximumToken = 10 * 10**8 * 10**18; //总发行量1b
208 
209     struct FreezeInfo {
210         address user;
211         uint256 amount;
212     }
213     //Key1: step(募资阶段); Key2: user sequence(用户序列)
214     mapping (uint8 => mapping (uint8 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。
215     mapping (uint8 => uint8) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence
216     mapping (uint8 => uint8) internal unlockTime;
217 
218     bool public transfersEnabled;
219 
220     /* This generates a public event on the blockchain that will notify clients */
221     //event Transfer(address indexed from, address indexed to, uint256 value);
222 
223     /* This notifies clients about the amount burnt */
224     event Burn(address indexed from, uint256 value);
225     
226     /* This notifies clients about the amount frozen */
227     event Freeze(address indexed from, uint256 value);
228     
229     /* This notifies clients about the amount unfrozen */
230     event Unfreeze(address indexed from, uint256 value);
231 
232     /* Initializes contract with initial supply tokens to the creator of the contract */
233     function Token(
234         uint256 initialSupply,
235         string tokenName,
236         uint8 decimalUnits,
237         string tokenSymbol,
238         bool transfersEnable
239         ) public {
240         balanceOf[msg.sender] = initialSupply;
241         totalSupply = initialSupply;
242         name = tokenName;
243         symbol = tokenSymbol;
244         decimals = decimalUnits;
245         transfersEnabled = transfersEnable;
246         owner = msg.sender;
247     }
248 
249     modifier onlyOwner() {
250         require(msg.sender == owner);
251         _;
252     }
253 
254     modifier ownerOrUser(address user){
255         require(msg.sender == owner || msg.sender == user);
256         _;
257     }
258 
259     modifier realUser(address user){
260         if(user == 0x0){
261             revert();
262         }
263         _;
264     }
265 
266     modifier moreThanZero(uint256 _value){
267         if (_value <= 0){
268             revert();
269         }
270         _;
271     }
272 
273     modifier moreOrEqualZero(uint256 _value){
274         if(_value < 0){
275             revert();
276         }
277         _;
278     }
279 
280     /// @dev Internal function to determine if an address is a contract
281     /// @param _addr The address being queried
282     /// @return True if `_addr` is a contract
283     function isContract(address _addr) constant internal returns(bool) {
284         uint size;
285         if (_addr == 0) {
286             return false;
287         }
288         assembly {
289             size := extcodesize(_addr)
290         }
291         return size>0;
292     }
293 
294     /* Send coins */
295     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) public returns (bool) {
296         require(balanceOf[msg.sender] > _value);           // Check if the sender has enough
297         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
298         balanceOf[msg.sender] = balanceOf[msg.sender] - _value;                     // Subtract from the sender
299         balanceOf[_to] = balanceOf[_to] + _value;                            // Add the same to the recipient
300         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
301         return true;
302     }
303 
304     /* Allow another contract to spend some tokens in your behalf */
305     function approve(address _spender, uint256 _value) moreThanZero(_value) public
306         returns (bool success) {
307         allowance[msg.sender][_spender] = _value;
308         return true;
309     }
310 
311     /**
312      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
313      *  its behalf, and then a function is triggered in the contract that is
314      *  being approved, `_spender`. This allows users to use their tokens to
315      *  interact with contracts in one function call instead of two
316      * @param _spender The address of the contract able to transfer the tokens
317      * @param _amount The amount of tokens to be approved for transfer
318      * @return True if the function call was successful
319      */
320     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
321         require(approve(_spender, _amount));
322 
323         ApproveAndCallReceiver(_spender).receiveApproval(
324             msg.sender,
325             _amount,
326             this,
327             _extraData
328         );
329 
330         return true;
331     }
332 
333     /* A contract attempts to get the coins */
334     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) public returns (bool success) {
335         require(balanceOf[_from] > _value);                 // Check if the sender has enough
336         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
337         require(_value < allowance[_from][msg.sender]);     // Check allowance
338         balanceOf[_from] = balanceOf[_from] - _value;                           // Subtract from the sender
339         balanceOf[_to] = balanceOf[_to] + _value;                             // Add the same to the recipient
340         allowance[_from][msg.sender] = allowance[_from][msg.sender] + _value;
341         Transfer(_from, _to, _value);
342         return true;
343     }
344     
345     //只能自己或者 owner 才能冻结账户
346     function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyController public returns (bool success) {
347         //info256("balanceOf[_user]", balanceOf[_user]);
348         require(balanceOf[_user] >= _value);
349         balanceOf[_user] = balanceOf[_user] - _value;
350         freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});
351         lastFreezeSeq[_step]++;
352         Freeze(_user, _value);
353         return true;
354     }
355 
356     event info(string name, uint8 value);
357     event info256(string name, uint256 value);
358     
359     //为用户解锁账户资金
360     function unFreeze(uint8 _step) onlyController public returns (bool unlockOver) {
361         //_end = length of freezeOf[_step]
362         uint8 _end = lastFreezeSeq[_step];
363         require(_end > 0);
364         //info("_end", _end);
365         unlockOver = (_end <= 49);
366         uint8 _start = (_end > 49) ? _end-50 : 0;
367         //info("_start", _start);
368         for(; _end>_start; _end--){
369             FreezeInfo storage fInfo = freezeOf[_step][_end-1];
370             uint256 _amount = fInfo.amount;
371             balanceOf[fInfo.user] += _amount;
372             delete freezeOf[_step][_end-1];
373             lastFreezeSeq[_step]--;
374             Unfreeze(fInfo.user, _amount);
375         }
376     }
377     
378     //accept ether
379     function() payable public {
380         //屏蔽控制方的合约类型检查，以兼容发行方无控制合约的情况。
381         require(isContract(controller));
382         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
383         require(proxyPayment);
384     }
385 
386 ////////////////
387 // Generate and destroy tokens
388 ////////////////
389 
390     /// @notice Generates `_amount` tokens that are assigned to `_owner`
391     /// @param _user The address that will be assigned the new tokens
392     /// @param _amount The quantity of tokens generated
393     /// @return True if the tokens are generated correctly
394     function generateTokens(address _user, uint _amount) onlyController public returns (bool) {
395         require(balanceOf[owner] >= _amount);
396         balanceOf[_user] += _amount;
397         balanceOf[owner] -= _amount;
398         Transfer(0, _user, _amount);
399         return true;
400     }
401 
402     /// @notice Burns `_amount` tokens from `_owner`
403     /// @param _user The address that will lose the tokens
404     /// @param _amount The quantity of tokens to burn
405     /// @return True if the tokens are burned correctly
406     function destroyTokens(address _user, uint _amount) onlyController public returns (bool) {
407         balanceOf[owner] += _amount;
408         balanceOf[_user] -= _amount;
409         Transfer(_user, 0, _amount);
410         return true;
411     }
412 
413     function changeOwner(address newOwner) onlyOwner public returns (bool) {
414         balanceOf[newOwner] = balanceOf[owner];
415         balanceOf[owner] = 0;
416         owner = newOwner;
417         return true;
418     }
419 
420 ////////////////
421 // Enable tokens transfers
422 ////////////////
423 
424     /// @notice Enables token holders to transfer their tokens freely if true
425     /// @param _transfersEnabled True if transfers are allowed in the clone
426     function enableTransfers(bool _transfersEnabled) onlyController public {
427         transfersEnabled = _transfersEnabled;
428     }
429 
430 //////////
431 // Safety Methods
432 //////////
433 
434     /// @notice This method can be used by the controller to extract mistakenly
435     ///  sent tokens to this contract.
436     ///  set to 0 in case you want to extract ether.
437     function claimTokens(address _token) onlyController public {
438         if (_token == 0x0) {
439             controller.transfer(this.balance);
440             return;
441         }
442 
443         Token token = Token(_token);
444         uint balance = token.balanceOf(this);
445         token.transfer(controller, balance);
446         ClaimedTokens(_token, controller, balance);
447     }
448 }
449 
450 contract BaseTokenSale is TokenController, Controlled {
451 
452     using SafeMath for uint256;
453 
454     uint256 public startFundingTime;
455     uint256 public endFundingTime;
456     
457     uint256 constant public maximumFunding = 1951 ether; //硬顶
458     uint256 public maxFunding;  //最高投资额度
459     uint256 public minFunding = 0.001 ether;  //最低起投额度
460     uint256 public tokensPerEther = 41000;
461     uint256 constant public maxGasPrice = 50000000000;
462     uint256 constant oneDay = 86400;
463     uint256 public totalCollected = 0;
464     bool    public paused;
465     Token public tokenContract;
466     bool public finalized = false;
467     bool public allowChange = true;
468     bool private transfersEnabled = true;
469     address private vaultAddress;
470 
471     bool private initialed = false;
472 
473     event Payment(address indexed _sender, uint256 _ethAmount, uint256 _tokenAmount);
474 
475     /**
476      * @param _startFundingTime The UNIX time that the BaseTokenSale will be able to start receiving funds
477      * @param _endFundingTime   The UNIX time that the BaseTokenSale will stop being able to receive funds
478      * @param _vaultAddress     The address that will store the donated funds
479      * @param _tokenAddress     Address of the token contract this contract controls
480      */
481     function BaseTokenSale(
482         uint _startFundingTime, 
483         uint _endFundingTime, 
484         address _vaultAddress,
485         address _tokenAddress
486     ) public {
487         require(_endFundingTime > now);
488         require(_endFundingTime >= _startFundingTime);
489         require(_vaultAddress != 0);
490         require(_tokenAddress != 0);
491         require(!initialed);
492 
493         startFundingTime = _startFundingTime;
494         endFundingTime = _endFundingTime;
495         vaultAddress = _vaultAddress;
496         tokenContract = Token(_tokenAddress);
497         paused = false;
498         initialed = true;
499     }
500 
501 
502     function setTime(uint time1, uint time2) onlyController public {
503         require(endFundingTime > now && startFundingTime < endFundingTime);
504         startFundingTime = time1;
505         endFundingTime = time2;
506     }
507 
508 
509     /**
510      * @dev The fallback function is called when ether is sent to the contract, it simply calls `doPayment()` with the address that sent the ether as the `_owner`. Payable is a required solidity modifier for functions to receive ether, without this modifier functions will throw if ether is sent to them
511      */
512     function () payable notPaused public {
513         doPayment(msg.sender);
514     }
515 
516     /**
517      * @notice `proxyPayment()` allows the caller to send ether to the BaseTokenSale and have the tokens created in an address of their choosing
518      * @param _owner The address that will hold the newly created tokens
519      */
520     function proxyPayment(address _owner) payable notPaused public returns(bool success) {
521         return doPayment(_owner);
522     }
523 
524     /**
525     * @notice Notifies the controller about a transfer, for this BaseTokenSale all transfers are allowed by default and no extra notifications are needed
526     * @param _from The origin of the transfer
527     * @param _to The destination of the transfer
528     * @param _amount The amount of the transfer
529     * @return False if the controller does not authorize the transfer
530     */
531     function onTransfer(address _from, address _to, uint _amount) public returns(bool success) {
532         if ( _from == vaultAddress || transfersEnabled) {
533             return true;
534         }
535         _to;
536         _amount;
537         return false;
538     }
539 
540     /**
541      * @notice Notifies the controller about an approval, for this BaseTokenSale all
542      * approvals are allowed by default and no extra notifications are needed
543      * @param _owner The address that calls `approve()`
544      * @param _spender The spender in the `approve()` call
545      * @param _amount The amount in the `approve()` call
546      * @return False if the controller does not authorize the approval
547      */
548     function onApprove(address _owner, address _spender, uint _amount) public returns(bool success) {
549         if ( _owner == vaultAddress ) {
550             return true;
551         }
552         _spender;
553         _amount;
554         return false;
555     }
556 
557     event info(string name, string msg);
558     event info256(string name, uint256 value);
559 
560     /// @dev `doPayment()` is an internal function that sends the ether that this
561     ///  contract receives to the `vault` and creates tokens in the address of the
562     ///  `_owner` assuming the BaseTokenSale is still accepting funds
563     /// @param _owner The address that will hold the newly created tokens
564     function doPayment(address _owner) internal returns(bool success) {
565         //info("step", "enter doPayment");
566         require(msg.value >= minFunding);
567         require(endFundingTime > now);
568 
569         // Track how much the BaseTokenSale has collected
570         require(totalCollected < maximumFunding);
571         totalCollected = totalCollected.add(msg.value);
572 
573         //Send the ether to the vault
574         require(vaultAddress.send(msg.value));
575         
576         uint256 tokenValue = tokensPerEther.mul(msg.value);
577         // Creates an equal amount of tokens as ether sent. The new tokens are created in the `_owner` address
578         require(tokenContract.generateTokens(_owner, tokenValue));
579         uint256 lock1 = tokenValue / 10;    //前5个月按照每月10%锁定
580         uint256 lock2 = tokenValue / 5;     //最后一个月解锁20%
581         require(tokenContract.freeze(_owner, lock1, 0)); //私募第一轮解锁
582         tokenContract.freeze(_owner, lock1, 1); //私募第二轮解锁
583         tokenContract.freeze(_owner, lock1, 2);
584         tokenContract.freeze(_owner, lock1, 3);
585         tokenContract.freeze(_owner, lock1, 4);
586         tokenContract.freeze(_owner, lock2, 5);
587         //require(tokenContract.freeze(_owner, lock3, 5)); //私募第三轮解锁
588         Payment(_owner, msg.value, tokenValue);
589         return true;
590     }
591 
592     function changeTokenController(address _newController) onlyController public {
593         tokenContract.changeController(_newController);
594     }
595 
596     /**
597      * 修改TNB兑换比率
598      */
599     function changeTokensPerEther(uint256 _newRate) onlyController public {
600         require(allowChange);
601         tokensPerEther = _newRate;
602     }
603 
604     function changeFundingLimit(uint256 _min, uint256 _max) onlyController public {
605         require(_min > 0 && _min <= _max);
606         minFunding = _min;
607         maxFunding = _max;
608     }
609 
610     /**
611      * 允许普通用户转账
612      */
613     function allowTransfersEnabled(bool _allow) onlyController public {
614         transfersEnabled = _allow;
615     }
616 
617     /// @dev Internal function to determine if an address is a contract
618     /// @param _addr The address being queried
619     /// @return True if `_addr` is a contract
620     function isContract(address _addr) constant internal returns (bool) {
621         if (_addr == 0) {
622             return false;
623         }
624         uint256 size;
625         assembly {
626             size := extcodesize(_addr)
627         }
628         return (size > 0);
629     }
630 
631     /// @notice `finalizeSale()` ends the BaseTokenSale. It will generate the platform and team tokens
632     ///  and set the controller to the referral fee contract.
633     /// @dev `finalizeSale()` can only be called after the end of the funding period or if the maximum amount is raised.
634     function finalizeSale() onlyController public {
635         require(now > endFundingTime || totalCollected >= maximumFunding);
636         require(!finalized);
637 
638         //20000 TNB/ETH and 90 percent discount
639         uint256 totalTokens = totalCollected * tokensPerEther * 10**18;
640         if (!tokenContract.generateTokens(vaultAddress, totalTokens)) {
641             revert();
642         }
643 
644         finalized = true;
645         allowChange = false;
646     }
647 
648 //////////
649 // Safety Methods
650 //////////
651 
652     /// @notice This method can be used by the controller to extract mistakenly
653     ///  sent tokens to this contract.
654     /// @param _token The address of the token contract that you want to recover
655     ///  set to 0 in case you want to extract ether.
656     function claimTokens(address _token) onlyController public {
657         if (_token == 0x0) {
658             controller.transfer(this.balance);
659             return;
660         }
661 
662         ERC20Token token = ERC20Token(_token);
663         uint balance = token.balanceOf(this);
664         token.transfer(controller, balance);
665         ClaimedTokens(_token, controller, balance);
666     }
667 
668     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
669 
670   /// @notice Pauses the contribution if there is any issue
671     function pauseContribution() onlyController public {
672         paused = true;
673     }
674 
675     /// @notice Resumes the contribution
676     function resumeContribution() onlyController public {
677         paused = false;
678     }
679 
680     modifier notPaused() {
681         require(!paused);
682         _;
683     }
684 }