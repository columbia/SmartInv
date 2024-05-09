1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 // https://github.com/ethereum/EIPs/issues/20
28 interface ERC20 {
29     function totalSupply() public view returns (uint supply);
30     function decimals() public view returns(uint digits);
31 
32     function balanceOf(address _owner) public view returns (uint balance);
33     function transfer(address _to, uint _value) public returns (bool success);
34     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
35 
36     function approve(address _spender, uint _value) public returns (bool success);
37     function allowance(address _owner, address _spender) public view returns (uint remaining);
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 interface tokenRecipient {
44     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
45 }
46 
47 contract BurnableToken is ERC20 {
48 
49     function burn(uint256 _value) public returns (bool success);
50     function burnFrom(address _from, uint256 _value) public returns (bool success);
51 
52     event Burn(address indexed _from, uint256 _value);
53 }
54 
55 contract Ownable {
56 
57     address public owner;
58 
59     /// @notice The Constructor assigns the message sender to be `owner`
60     function Ownable() public {
61         owner = msg.sender;
62     }
63 
64     address newOwner=0x0;
65 
66     event OwnerUpdate(address _prevOwner, address _newOwner);
67 
68     ///change the owner
69     function changeOwner(address _newOwner) public onlyOwner {
70         require(_newOwner != owner);
71         newOwner = _newOwner;
72     }
73 
74     /// accept the ownership
75     function acceptOwnership() public{
76         require(msg.sender == newOwner);
77         OwnerUpdate(owner, newOwner);
78         owner = newOwner;
79         newOwner = 0x0;
80     }
81 
82     /// `owner` is the only address that can call a function with this
83     /// modifier
84     modifier onlyOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88 }
89 
90 contract Controlled is Ownable{
91 
92     function Controlled() public {
93         exclude[msg.sender] = true;
94         exclude[this] = true;
95     }
96 
97     modifier onlyAdmin() {
98         if(msg.sender != owner){
99             require(admins[msg.sender]);
100         }
101         _;
102     }
103 
104     mapping(address => bool) admins;
105 
106     // Flag that determines if the token is transferable or not.
107     bool public transferEnabled = false;
108 
109     // frozen account
110     mapping(address => bool) exclude;
111     mapping(address => bool) locked;
112     mapping(address => bool) public frozenAccount;
113 
114 
115     /* This generates a public event on the blockchain that will notify clients */
116     event FrozenFunds(address target, bool frozen);
117 
118 
119     function setAdmin(address _addr, bool isAdmin) public onlyOwner
120     returns (bool success){
121         admins[_addr]=isAdmin;
122         return true;
123     }
124 
125 
126     function enableTransfer(bool _enable) public onlyOwner{
127         transferEnabled=_enable;
128     }
129 
130 
131     function setExclude(address _addr, bool isExclude) public onlyOwner returns (bool success){
132         exclude[_addr]=isExclude;
133         return true;
134     }
135 
136     function setLock(address _addr, bool isLock) public onlyAdmin returns (bool success){
137         locked[_addr]=isLock;
138         return true;
139     }
140 
141 
142     function freezeAccount(address target, bool freeze) onlyOwner public {
143         frozenAccount[target] = freeze;
144         FrozenFunds(target, freeze);
145     }
146 
147     modifier transferAllowed(address _addr) {
148         require(!frozenAccount[_addr]);
149         if (!exclude[_addr]) {
150             require(transferEnabled);
151             require(!locked[_addr]);
152         }
153         _;
154     }
155 
156 }
157 
158 contract TokenERC20 is  ERC20, BurnableToken, Controlled {
159 
160     using SafeMath for uint256;
161 
162    // Public variables of the token
163     string public name;
164     string public symbol;
165     uint8 public decimals = 18;
166     string public version = 'v1.0';
167 
168     // 18 decimals is the strongly suggested default, avoid changing it
169     uint256 public totalSupply;
170 
171     // This creates an array with all balanceOf
172     mapping (address => uint256)  public balanceOf;
173     mapping (address => mapping (address => uint256))  public allowance;
174 
175 
176     function totalSupply() public view returns (uint supply){
177         return totalSupply;
178     }
179     function decimals() public view returns(uint digits){
180         return decimals;
181     }
182 
183     function balanceOf(address _owner) public view returns (uint balance){
184         return balanceOf[_owner];
185     }
186     function allowance(address _owner, address _spender) public view returns (uint remaining){
187         return allowance[_owner][_spender];
188     }
189 
190     /**
191      * Internal transfer, only can be called by this contract
192      */
193     function _transfer(address _from, address _to, uint _value) transferAllowed(_from) internal {
194         // Prevent transfer to 0x0 address. Use burn() instead
195         require(_to != 0x0);
196         // Check if the sender has enough
197         require(balanceOf[_from] >= _value);
198         // Check for overflows
199         require(balanceOf[_to] + _value > balanceOf[_to]);
200         // Save this for an assertion in the future
201         uint previousBalances = balanceOf[_from] + balanceOf[_to];
202         // Subtract from the sender
203         balanceOf[_from] -= _value;
204         // Add the same to the recipient
205         balanceOf[_to] += _value;
206         Transfer(_from, _to, _value);
207         // Asserts are used to use static analysis to find bugs in your code. They should never fail
208         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
209     }
210 
211     /**
212      * Transfer tokens
213      *
214      * Send `_value` tokens to `_to` from your account
215      *
216      * @param _to The address of the recipient
217      * @param _value the amount to send
218      */
219     function transfer(address _to, uint256 _value) public returns (bool success) {
220         _transfer(msg.sender, _to, _value);
221         return true;
222     }
223 
224     /**
225      * Transfer tokens from other address
226      *
227      * Send `_value` tokens to `_to` in behalf of `_from`
228      *
229      * @param _from The address of the sender
230      * @param _to The address of the recipient
231      * @param _value the amount to send
232      */
233     function transferFrom(address _from, address _to, uint256 _value) transferAllowed(_from) public returns (bool success) {
234         require(_value <= allowance[_from][msg.sender]);     // Check allowance
235         allowance[_from][msg.sender] -= _value;
236         _transfer(_from, _to, _value);
237         return true;
238     }
239 
240     /**
241      * Set allowance for other address
242      *
243      * Allows `_spender` to spend no more than `_value` tokens in your behalf
244      *
245      * @param _spender The address authorized to spend
246      * @param _value the max amount they can spend
247      */
248     function approve(address _spender, uint256 _value) public
249     returns (bool success) {
250         allowance[msg.sender][_spender] = _value;
251         return true;
252     }
253 
254     /**
255      * Set allowance for other address and notify
256      *
257      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
258      *
259      * @param _spender The address authorized to spend
260      * @param _value the max amount they can spend
261      * @param _extraData some extra information to send to the approved contract
262      */
263     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
264     public
265     returns (bool success) {
266         tokenRecipient spender = tokenRecipient(_spender);
267         if (approve(_spender, _value)) {
268             spender.receiveApproval(msg.sender, _value, this, _extraData);
269             return true;
270         }
271     }
272 
273      /**
274      * Destroy tokens
275      *
276      * Remove `_value` tokens from the system irreversibly
277      *
278      * @param _value the amount of money to burn
279      */
280     function burn(uint256 _value) public returns (bool success) {
281         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
282         balanceOf[msg.sender] -= _value;            // Subtract from the sender
283         totalSupply -= _value;                      // Updates totalSupply
284         Burn(msg.sender, _value);
285         return true;
286     }
287 
288     /**
289      * Destroy tokens from other account
290      *
291      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
292      *
293      * @param _from the address of the sender
294      * @param _value the amount of money to burn
295      */
296     function burnFrom(address _from, uint256 _value) public returns (bool success) {
297         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
298         require(_value <= allowance[_from][msg.sender]);    // Check allowance
299         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
300         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
301         totalSupply -= _value;                              // Update totalSupply
302         Burn(_from, _value);
303         return true;
304     }
305 
306 }
307 
308 contract AdvancedToken is  TokenERC20 {
309 
310     uint  constant internal ETH_DECIMALS = 18;
311     uint  constant internal PRECISION = (10**18);
312 
313     // allocate end time, default is now plus 1 days
314     uint256 public allocateEndTime;
315 
316     function AdvancedToken() public {
317        allocateEndTime = now + 1 days;
318     }
319 
320     // Allocate tokens to the users
321     // @param _owners The owners list of the token
322     // @param _values The value list of the token (value = _value * 10 ** decimals)
323     function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {
324         require(allocateEndTime > now);
325         require(_owners.length == _values.length);
326         for(uint256 i = 0; i < _owners.length ; i++){
327             address to = _owners[i];
328             uint256 value = _values[i] * 10 ** uint256(decimals);
329             require(totalSupply + value > totalSupply && balanceOf[to] + value > balanceOf[to]) ;
330             totalSupply += value;
331             balanceOf[to] += value;
332         }
333     }
334 
335 
336     //Early stage investing
337     bool enableEarlyStage = false;
338     uint256 public totalEarlyStage;
339     uint256 remainEarlyStage;
340     uint256 earlyStagePrice;   //PRECISION=10**18
341     uint256 earlyStageGiftRate;     //x/10000
342 
343     // air drop token
344     bool enableAirdrop = false;
345     uint256 public totalAirdrop;
346     uint256 remainAirdrop;
347     mapping (address => bool) dropList;
348     uint256 public airdropValue;
349 
350 
351     modifier canEarlyStage() {
352         require(enableEarlyStage && remainEarlyStage>0 && earlyStagePrice>0 && balanceOf[this]>0);
353         _;
354     }
355 
356     modifier canAirdrop() {
357         require(enableAirdrop && remainAirdrop>0);
358         _;
359     }
360 
361     modifier canGetTokens() {
362         require(enableAirdrop && remainAirdrop>0 &&  airdropValue>0);
363         require(dropList[msg.sender] == false);
364         _;
365     }
366 
367     function setEarlyParams (bool isEarlyStage, uint256 _price, uint256 _earlyStageGiftRate) onlyOwner public {
368         if(isEarlyStage){
369             require(_price>0);
370             require(_earlyStageGiftRate>=0 && _earlyStageGiftRate<= 10000 );
371         }
372         enableEarlyStage = isEarlyStage;
373         if(_price>0){
374             earlyStagePrice = _price;
375         }
376         if(_earlyStageGiftRate>0){
377             earlyStageGiftRate = _earlyStageGiftRate;
378         }
379 
380     }
381 
382     function setAirdropParams (bool isAirdrop, uint256 _value) onlyAdmin public {
383         if(isAirdrop){
384             require(_value>0);
385         }
386         airdropValue = _value;
387     }
388 
389 
390     function setAirdorpList(address[] addresses, bool hasDrop) onlyAdmin public {
391         for (uint i = 0; i < addresses.length; i++) {
392             dropList[addresses[i]] = hasDrop;
393         }
394     }
395 
396 
397     /// @notice Buy tokens from contract by sending ether
398      function buy() payable public {
399          _buy(msg.value);
400      }
401 
402     function _buy(uint256 value)  private returns(uint256){
403         uint256 amount = 0;
404         if(value>0){
405             amount = uint256(PRECISION).mul(value).div(earlyStagePrice).div(10**uint256(ETH_DECIMALS-decimals));    // calculates the amount
406         }
407         if(amount>0){
408             _transfer(this, msg.sender, amount);
409             if(earlyStageGiftRate>0){
410                 _transfer(this, msg.sender, amount.mul(earlyStageGiftRate).div(10000));
411             }
412         }
413         return amount;
414     }
415 
416 
417     function () payable public {
418         if(msg.value>0){
419             _buy(msg.value);
420         }
421         if( enableAirdrop && remainAirdrop>0  &&  airdropValue>0 && dropList[msg.sender] == false){
422              _getTokens();
423         }
424     }
425 
426 
427     function _airdrop(address _owner, uint256 _value)  canAirdrop private returns(bool) {
428         require(_value>0);
429         _transfer(this, _owner, _value);
430         return true;
431     }
432 
433      // drop token
434     function airdrop(address[] _owners, uint256 _value) onlyAdmin canAirdrop public {
435          require(_value>0 && remainAirdrop>= _value * _owners.length);
436          for(uint256 i = 0; i < _owners.length ; i++){
437              _airdrop(_owners[i], _value);
438         }
439      }
440 
441 
442     function _getTokens()  private returns(bool) {
443         address investor = msg.sender;
444         uint256 toGive = airdropValue;
445         if (toGive > 0) {
446             _airdrop(investor, toGive);
447             dropList[investor] = true;
448         }
449         return true;
450     }
451 
452     /*
453     * Proxy transfer  token. When some users of the ethereum account has no ether,
454     * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
455     * @param _from
456     * @param _to
457     * @param _value
458     * @param feeProxy
459     * @param _v
460     * @param _r
461     * @param _s
462     */
463     function transferProxy(address _from, address _to, uint256 _value, uint256 _feeProxy,
464         uint8 _v,bytes32 _r, bytes32 _s) public transferAllowed(_from) returns (bool){
465         require(_value + _feeProxy >= _value);
466         require(balanceOf[_from] >=_value  + _feeProxy);
467         uint256 nonce = nonces[_from];
468         bytes32 h = keccak256(_from,_to,_value,_feeProxy,nonce);
469         require(_from == ecrecover(h,_v,_r,_s));
470         require(balanceOf[_to] + _value > balanceOf[_to]);
471         require(balanceOf[msg.sender] + _feeProxy > balanceOf[msg.sender]);
472         balanceOf[_from] -= (_value  + _feeProxy);
473         balanceOf[_to] += _value;
474         Transfer(_from, _to, _value);
475         if(_feeProxy>0){
476             balanceOf[msg.sender] += _feeProxy;
477             Transfer(_from, msg.sender, _feeProxy);
478         }
479         nonces[_from] = nonce + 1;
480         return true;
481     }
482 
483     // support withdraw
484     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
485 
486     /**
487      * @dev Withdraw all ERC20 compatible tokens
488      * @param token ERC20 The address of the token contract
489      */
490     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyOwner {
491         require(token.transfer(sendTo, amount));
492         TokenWithdraw(token, amount, sendTo);
493     }
494 
495     event EtherWithdraw(uint amount, address sendTo);
496 
497     /**
498      * @dev Withdraw Ethers
499      */
500     function withdrawEther(uint amount, address sendTo) external onlyOwner {
501         sendTo.transfer(amount);
502         EtherWithdraw(amount, sendTo);
503     }
504 
505 
506     // The nonce for avoid transfer replay attacks
507     mapping(address => uint256) nonces;
508 
509     /*
510      * Get the nonce
511      * @param _addr
512      */
513     function getNonce(address _addr) public constant returns (uint256){
514         return nonces[_addr];
515     }
516 
517 }
518 
519 
520 contract SafeasyToken is AdvancedToken {
521 
522    function SafeasyToken() public{
523         name = "Safeasy Token";
524         decimals = 6;
525         symbol = "SET";
526         version = 'v1.1';
527 
528         uint256 initialSupply = uint256(2* 10 ** 9);
529         totalSupply = initialSupply.mul( 10 ** uint256(decimals));
530 
531         enableEarlyStage = true;
532         totalEarlyStage = totalSupply.div(100).mul(30);
533         remainEarlyStage = totalEarlyStage;
534         earlyStagePrice = 10 ** 14; // 10**18=1:1eth, 10**15=1000:1eth
535         earlyStageGiftRate = 2000;  // 100=1%
536         enableAirdrop = true;
537         totalAirdrop = totalSupply.div(100).mul(15);
538         remainAirdrop = totalAirdrop;
539         airdropValue = 50000000;
540 
541         uint256 totalDistributed = totalEarlyStage.add(totalAirdrop);
542         balanceOf[this] = totalDistributed;
543         balanceOf[msg.sender] = totalSupply.sub(totalDistributed);
544 
545     }
546 }