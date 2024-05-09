1 pragma solidity ^0.4.18;
2 
3 
4 // https://github.com/ethereum/EIPs/issues/20
5 interface ERC20 {
6     function totalSupply() public view returns (uint supply);
7     function decimals() public view returns(uint digits);
8 
9     function balanceOf(address _owner) public view returns (uint balance);
10     function transfer(address _to, uint _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
12 
13     function approve(address _spender, uint _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public view returns (uint remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18     event Burn(address indexed _from, uint256 _value);
19 
20 }
21 
22 interface tokenRecipient {
23     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
24 }
25 
26 
27 contract Ownable {
28 
29     /// `owner` is the only address that can call a function with this
30     /// modifier
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     address public owner;
37 
38     /// @notice The Constructor assigns the message sender to be `owner`
39     function Ownable() public {
40         owner = msg.sender;
41     }
42 
43     address newOwner=0x0;
44 
45     event OwnerUpdate(address _prevOwner, address _newOwner);
46 
47     ///change the owner
48     function changeOwner(address _newOwner) public onlyOwner {
49         require(_newOwner != owner);
50         newOwner = _newOwner;
51     }
52 
53     /// accept the ownership
54     function acceptOwnership() public{
55         require(msg.sender == newOwner);
56         OwnerUpdate(owner, newOwner);
57         owner = newOwner;
58         newOwner = 0x0;
59     }
60 }
61 
62 contract Controlled is Ownable{
63 
64     function Controlled() public {
65         exclude[msg.sender] = true;
66     }
67 
68     modifier onlyAdmin() {
69         if(msg.sender != owner){
70             require(admins[msg.sender]);
71         }
72         _;
73     }
74 
75     mapping(address => bool) admins;
76 
77     // Flag that determines if the token is transferable or not.
78     bool public transferEnabled = false;
79 
80     // frozen account
81     mapping(address => bool) exclude;
82     mapping(address => bool) locked;
83     mapping(address => bool) public frozenAccount;
84 
85     // The nonce for avoid transfer replay attacks
86     mapping(address => uint256) nonces;
87 
88 
89     /* This generates a public event on the blockchain that will notify clients */
90     event FrozenFunds(address target, bool frozen);
91 
92 
93     function setAdmin(address _addr, bool isAdmin) public onlyOwner returns (bool success){
94         admins[_addr]=isAdmin;
95         return true;
96     }
97 
98 
99     function enableTransfer(bool _enable) public onlyOwner{
100         transferEnabled=_enable;
101     }
102 
103 
104     function setExclude(address _addr, bool isExclude) public onlyOwner returns (bool success){
105         exclude[_addr]=isExclude;
106         return true;
107     }
108 
109     function setLock(address _addr, bool isLock) public onlyAdmin returns (bool success){
110         locked[_addr]=isLock;
111         return true;
112     }
113 
114 
115     function freezeAccount(address target, bool freeze) onlyOwner public {
116         frozenAccount[target] = freeze;
117         FrozenFunds(target, freeze);
118     }
119 
120     /*
121      * Get the nonce
122      * @param _addr
123      */
124     function getNonce(address _addr) public constant returns (uint256){
125         return nonces[_addr];
126     }
127 
128     modifier transferAllowed(address _addr) {
129         if (!exclude[_addr]) {
130             assert(transferEnabled);
131             assert(!locked[_addr]);
132             assert(!frozenAccount[_addr]);
133         }
134         _;
135     }
136 
137 }
138 
139 contract FeeControlled is Controlled{
140 
141     // receive transfer fee account
142     address feeReceAccount = 0x0;
143 
144     // transfer rate  default value,  rate/10000
145     uint16 defaultTransferRate = 0;
146      // transfer fee min & max
147     uint256 transferFeeMin = 0;
148     uint256 transferFeeMax = 10 ** 10;
149 
150     // transfer rate, rate/10000
151     mapping(address => int16) transferRates;
152     // reverse transfer rate when receive from user
153     mapping(address => int16) transferReverseRates;
154 
155 
156     function setFeeReceAccount(address _addr) public onlyAdmin
157     returns (bool success){
158         require(_addr != address(0) && feeReceAccount != _addr);
159         feeReceAccount = _addr;
160         return true;
161     }
162 
163     function setFeeParams(uint16 _transferRate, uint256 _transferFeeMin, uint256 _transferFeeMax) public onlyAdmin
164     returns (bool success){
165         require(_transferRate>=0  && _transferRate<10000);
166         require(_transferFeeMin>=0 && _transferFeeMin<transferFeeMax);
167         transferFeeMin = _transferFeeMin;
168         transferFeeMax = _transferFeeMax;
169         defaultTransferRate = _transferRate;
170         if(feeReceAccount==0x0){
171             feeReceAccount = owner;
172         }
173         return true;
174     }
175 
176 
177     function setTransferRate(address[] _addrs, int16 _transferRate) public onlyAdmin
178     returns (bool success){
179         require((_transferRate>=0  || _transferRate==-1)&& _transferRate<10000);
180         for(uint256 i = 0; i < _addrs.length ; i++){
181             address _addr = _addrs[i];
182             transferRates[_addr] = _transferRate;
183         }
184         return true;
185     }
186 
187 
188     function removeTransferRate(address[] _addrs) public onlyAdmin
189     returns (bool success){
190         for(uint256 i = 0; i < _addrs.length ; i++){
191             address _addr = _addrs[i];
192             delete transferRates[_addr];
193         }
194         return true;
195     }
196 
197     function setReverseRate(address[] _addrs, int16 _reverseRate) public onlyAdmin
198     returns (bool success){
199         require(_reverseRate>0 && _reverseRate<10000);
200         for(uint256 i = 0; i < _addrs.length ; i++){
201             address _addr = _addrs[i];
202             transferReverseRates[_addr] = _reverseRate;
203         }
204         return true;
205     }
206 
207 
208     function removeReverseRate(address[] _addrs) public onlyAdmin returns (bool success){
209         for(uint256 i = 0; i < _addrs.length ; i++){
210             address _addr = _addrs[i];
211             delete transferReverseRates[_addr];
212         }
213         return true;
214     }
215 
216     function getTransferRate(address _addr) public constant returns(uint16 transferRate){
217         if(_addr==owner || exclude[_addr] || transferRates[_addr]==-1){
218             return 0;
219         }else if(transferRates[_addr]==0){
220             return defaultTransferRate;
221         }else{
222             return uint16(transferRates[_addr]);
223         }
224     }
225 
226     function getTransferFee(address _addr, uint256 _value) public constant returns(uint256 transferFee){
227         uint16 transferRate = getTransferRate(_addr);
228         transferFee = 0x0;
229         if(transferRate>0){
230            transferFee =  _value * transferRate / 10000;
231         }
232         if(transferFee<transferFeeMin){
233             transferFee = transferFeeMin;
234         }
235         if(transferFee>transferFeeMax){
236             transferFee = transferFeeMax;
237         }
238         return transferFee;
239     }
240 
241     function getReverseRate(address _addr) public constant returns(uint16 reverseRate){
242         return uint16(transferReverseRates[_addr]);
243     }
244 
245     function getReverseFee(address _addr, uint256 _value) public constant returns(uint256 reverseFee){
246         uint16 reverseRate = uint16(transferReverseRates[_addr]);
247         reverseFee = 0x0;
248         if(reverseRate>0){
249             reverseFee = _value * reverseRate / 10000;
250         }
251         if(reverseFee<transferFeeMin){
252             reverseFee = transferFeeMin;
253         }
254         if(reverseFee>transferFeeMax){
255             reverseFee = transferFeeMax;
256         }
257         return reverseFee;
258     }
259 
260 }
261 
262 contract TokenERC20 is ERC20, Controlled {
263 
264    // Public variables of the token
265     string public name;
266     string public symbol;
267     uint8 public decimals = 18;
268     string public version = 'v1.0';
269 
270     // 18 decimals is the strongly suggested default, avoid changing it
271     uint256 public totalSupply;
272 
273     uint256 public allocateEndTime;
274 
275     // This creates an array with all balances
276     mapping (address => uint256) public balances;
277     mapping (address => mapping (address => uint256)) public allowed;
278     
279 
280     function totalSupply() public view returns(uint){
281         return totalSupply;
282     }
283 
284     function decimals() public view returns(uint){
285         return decimals;
286     }
287 
288     function balanceOf(address _owner) public view returns(uint){
289         return balances[_owner];
290     }
291     
292     function allowance(address _owner, address _spender) 
293     public view returns (uint remaining){
294         return allowed[_owner][_spender];
295     }
296     
297     
298 
299     // Allocate tokens to the users
300     // @param _owners The owners list of the token
301     // @param _values The value list of the token
302     function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {
303         require(allocateEndTime > now);
304         require(_owners.length == _values.length);
305         for(uint256 i = 0; i < _owners.length ; i++){
306             address to = _owners[i];
307             uint256 value = _values[i];
308             require(totalSupply + value > totalSupply && balances[to] + value > balances[to]) ;
309             totalSupply += value;
310             balances[to] += value;
311         }
312     }
313 
314     /**
315      * Internal transfer, only can be called by this contract
316      */
317     function _transfer(address _from, address _to, uint _value) transferAllowed(_from) internal {
318         // Prevent transfer to 0x0 address. Use burn() instead
319         require(_to != 0x0);
320         // Check if the sender has enough
321         require(balances[_from] >= _value);
322         // Check for overflows
323         require(balances[_to] + _value > balances[_to]);
324         // Save this for an assertion in the future
325         uint previousBalances = balances[_from] + balances[_to];
326         // Subtract from the sender
327         balances[_from] -= _value;
328         // Add the same to the recipient
329         balances[_to] += _value;
330         Transfer(_from, _to, _value);
331         // Asserts are used to use static analysis to find bugs in your code. They should never fail
332         assert(balances[_from] + balances[_to] == previousBalances);
333     }
334 
335     /**
336      * Transfer tokens
337      *
338      * Send `_value` tokens to `_to` from your account
339      *
340      * @param _to The address of the recipient
341      * @param _value the amount to send
342      */
343     function transfer(address _to, uint256 _value) public returns (bool success) {
344         _transfer(msg.sender, _to, _value);
345         return true;
346     }
347 
348     /**
349      * Transfer tokens from other address
350      *
351      * Send `_value` tokens to `_to` in behalf of `_from`
352      *
353      * @param _from The address of the sender
354      * @param _to The address of the recipient
355      * @param _value the amount to send
356      */
357     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
358         require(_value <= allowed[_from][msg.sender]);     // Check allowance
359         allowed[_from][msg.sender] -= _value;
360         _transfer(_from, _to, _value);
361         return true;
362     }
363 
364     /**
365      * Set allowance for other address
366      *
367      * Allows `_spender` to spend no more than `_value` tokens in your behalf
368      *
369      * @param _spender The address authorized to spend
370      * @param _value the max amount they can spend
371      */
372     function approve(address _spender, uint256 _value) public
373     returns (bool success) {
374         allowed[msg.sender][_spender] = _value;
375         return true;
376     }
377 
378     /**
379      * Set allowance for other address and notify
380      *
381      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
382      *
383      * @param _spender The address authorized to spend
384      * @param _value the max amount they can spend
385      * @param _extraData some extra information to send to the approved contract
386      */
387     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
388     public
389     returns (bool success) {
390         tokenRecipient spender = tokenRecipient(_spender);
391         if (approve(_spender, _value)) {
392             spender.receiveApproval(msg.sender, _value, this, _extraData);
393             return true;
394         }
395     }
396 
397     /**
398      * Destroy tokens
399      *
400      * Remove `_value` tokens from the system irreversibly
401      *
402      * @param _value the amount of money to burn
403      */
404     function burn(uint256 _value) public returns (bool success) {
405         require(balances[msg.sender] >= _value);   // Check if the sender has enough
406         balances[msg.sender] -= _value;            // Subtract from the sender
407         totalSupply -= _value;                      // Updates totalSupply
408         Burn(msg.sender, _value);
409         return true;
410     }
411 
412     /**
413      * Destroy tokens from other account
414      *
415      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
416      *
417      * @param _from the address of the sender
418      * @param _value the amount of money to burn
419      */
420     function burnFrom(address _from, uint256 _value) public returns (bool success) {
421         require(balances[_from] >= _value);                // Check if the targeted balance is enough
422         require(_value <= allowed[_from][msg.sender]);    // Check allowance
423         balances[_from] -= _value;                         // Subtract from the targeted balance
424         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
425         totalSupply -= _value;                              // Update totalSupply
426         Burn(_from, _value);
427         return true;
428     }
429 
430 
431     /*
432     * Proxy transfer  token. When some users of the ethereum account has no ether,
433     * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
434     * @param _from
435     * @param _to
436     * @param _value
437     * @param feeProxy
438     * @param _v
439     * @param _r
440     * @param _s
441     */
442     function transferProxy(address _from, address _to, uint256 _value, uint256 _feeProxy,
443         uint8 _v,bytes32 _r, bytes32 _s) public transferAllowed(_from) returns (bool){
444         require(_value + _feeProxy >= _value);
445         require(balances[_from] >=_value  + _feeProxy);
446         uint256 nonce = nonces[_from];
447         bytes32 h = keccak256(_from,_to,_value,_feeProxy,nonce);
448         require(_from == ecrecover(h,_v,_r,_s));
449         require(balances[_to] + _value > balances[_to]);
450         require(balances[msg.sender] + _feeProxy > balances[msg.sender]);
451         balances[_from] -= (_value  + _feeProxy);
452         balances[_to] += _value;
453         Transfer(_from, _to, _value);
454         if(_feeProxy>0){
455             balances[msg.sender] += _feeProxy;
456             Transfer(_from, msg.sender, _feeProxy);
457         }
458         nonces[_from] = nonce + 1;
459         return true;
460     }
461 }
462 
463 contract StableToken is TokenERC20, FeeControlled {
464 
465 
466     function transfer(address _to, uint256 _value) public returns (bool success) {
467         return _transferWithRate(msg.sender, _to, _value);
468     }
469 
470     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
471         return _transferWithRate(_from, _to, _value);
472     }
473 
474      function _transferWithRate(address _from, address _to, uint256 _value)  transferAllowed(_from) internal returns (bool success) {
475         // check transfer rate and transfer fee to owner
476         require(balances[_from] >= _value);
477         uint256 transferFee = getTransferFee(_from, _value);
478         require(balances[_from] >= _value + transferFee);
479         if(msg.sender!=_from){
480             require(allowed[_from][msg.sender] >= _value + transferFee);
481         }
482         require(balances[_to] + _value > balances[_to]);
483         if(transferFee>0){
484             require(balances[feeReceAccount] + transferFee > balances[feeReceAccount]);
485         }
486 
487         balances[_from] -= (_value + transferFee);
488         if(msg.sender!=_from){
489             allowed[_from][msg.sender] -= (_value + transferFee);
490         }
491 
492         balances[_to] += _value;
493         Transfer(_from, _to, _value);
494 
495         if(transferFee>0){
496             balances[feeReceAccount] += transferFee;
497             Transfer(_from, feeReceAccount, transferFee);
498         }
499         return true;
500     }
501 
502 
503      /*
504      * Proxy transfer token with reverse transfer fee. When some users of the ethereum account has no ether,
505      * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
506      * @param _from
507      * @param _to, must be reverse address
508      * @param _value
509      * @param fee
510      * @param _v
511      * @param _r
512      * @param _s
513      */
514     function transferReverseProxy(address _from, address _to, uint256 _value,uint256 _feeProxy,
515         uint8 _v,bytes32 _r, bytes32 _s) public transferAllowed(_from) returns (bool){
516         require(_feeProxy>=0);
517         require(balances[_from] >= _value + _feeProxy);
518         require(getReverseRate(_to)>0);
519         uint256 nonce = nonces[_from];
520         bytes32 h = keccak256(_from,_to,_value, _feeProxy, nonce);
521         require(_from == ecrecover(h,_v,_r,_s));
522 
523         uint256 transferReverseFee = getReverseFee(_to, _value);
524         require(transferReverseFee>0);
525         require(balances[_to] + _value > balances[_to]);
526         require(balances[feeReceAccount] + transferReverseFee > balances[feeReceAccount]);
527         require(balances[msg.sender] + _feeProxy >= balances[msg.sender]);
528 
529         balances[_from] -= (_value + _feeProxy);
530         balances[_to] += (_value - transferReverseFee);
531         balances[feeReceAccount] += transferReverseFee;
532         Transfer(_from, _to, _value);
533         Transfer(_to, feeReceAccount, transferReverseFee);
534         if(_feeProxy>0){
535             balances[msg.sender] += _feeProxy;
536             Transfer(_from, msg.sender, _feeProxy);
537         }
538 
539         nonces[_from] = nonce + 1;
540         return true;
541     }
542 
543     /*
544     * Proxy transfer  token. When some users of the ethereum account has no ether,
545     * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
546     * @param _from
547     * @param _to
548     * @param _value
549     * @param feeProxy
550     * @param _v
551     * @param _r
552     * @param _s
553     */
554     function transferProxy(address _from, address _to, uint256 _value, uint256 _feeProxy,
555         uint8 _v,bytes32 _r, bytes32 _s) public transferAllowed(_from) returns (bool){
556         uint256 transferFee = getTransferFee(_from, _value);
557         require(_value + transferFee + _feeProxy >= _value);
558         require(balances[_from] >=_value + transferFee + _feeProxy);
559         uint256 nonce = nonces[_from];
560         bytes32 h = keccak256(_from,_to,_value,_feeProxy,nonce);
561         require(_from == ecrecover(h,_v,_r,_s));
562         require(balances[_to] + _value > balances[_to]);
563         require(balances[msg.sender] + _feeProxy > balances[msg.sender]);
564         balances[_from] -= (_value + transferFee + _feeProxy);
565         balances[_to] += _value;
566         Transfer(_from, _to, _value);
567         if(_feeProxy>0){
568             balances[msg.sender] += _feeProxy;
569             Transfer(_from, msg.sender, _feeProxy);
570         }
571         if(transferFee>0){
572             balances[feeReceAccount] += transferFee;
573             Transfer(_from, feeReceAccount, transferFee);
574         }
575         nonces[_from] = nonce + 1;
576         return true;
577     }
578 
579    /*
580     * Wrapper function:  transferProxy + transferReverseProxy
581     * address[] _addrs => [_from, _origin, _to]
582     * uint256[] _values => [_value, _feeProxy]
583     * token flows
584     * _from->_origin: _value
585     * _from->sender: _feeProxy
586     * _origin->_to: _value
587     * _to->feeAccount: transferFee
588     * _from sign:
589     * (_v[0],_r[0],_s[0]) = sign(_from, _origin, _value, _feeProxy, nonces[_from])
590     * _origin sign:
591     * (_v[1],_r[1],_s[1]) = sign(_origin, _to, _value)
592     */
593     function transferReverseProxyThirdParty(address[] _addrs, uint256[] _values,
594         uint8[] _v, bytes32[] _r, bytes32[] _s)
595         public transferAllowed(_addrs[0]) returns (bool){
596         address _from = _addrs[0];
597         address _origin = _addrs[1];
598         address _to = _addrs[2];
599         uint256 _value = _values[0];
600         uint256 _feeProxy = _values[1];
601 
602         require(_feeProxy>=0);
603         require(balances[_from] >= (_value + _feeProxy));
604         require(getReverseRate(_to)>0);
605         uint256 transferReverseFee = getReverseFee(_to, _value);
606         require(transferReverseFee>0);
607 
608         // check sign _from => _origin
609         uint256 nonce = nonces[_from];
610         bytes32 h = keccak256(_from, _origin, _value, _feeProxy, nonce);
611         require(_from == ecrecover(h,_v[0],_r[0],_s[0]));
612          // check sign _origin => _to
613         bytes32 h1 = keccak256(_origin, _to, _value);
614         require(_origin == ecrecover(h1,_v[1],_r[1],_s[1]));
615 
616 
617         require(balances[_to] + _value > balances[_to]);
618         require(balances[feeReceAccount] + transferReverseFee > balances[feeReceAccount]);
619         require(balances[msg.sender] + _feeProxy >= balances[msg.sender]);
620 
621         balances[_from] -= _value + _feeProxy;
622         balances[_to] += (_value - transferReverseFee);
623         balances[feeReceAccount] += transferReverseFee;
624        
625         Transfer(_from, _origin, _value);
626         Transfer(_origin, _to, _value);
627         Transfer(_to, feeReceAccount, transferReverseFee);
628         
629         if(_feeProxy>0){
630             balances[msg.sender] += _feeProxy;
631             Transfer(_from, msg.sender, _feeProxy);
632         }
633        
634 
635         nonces[_from] = nonce + 1;
636         return true;
637     }
638 
639     /*
640      * Proxy approve that some one can authorize the agent for broadcast transaction
641      * which call approve method, and agents may charge agency fees
642      * @param _from The address which should tranfer TOKEN to others
643      * @param _spender The spender who allowed by _from
644      * @param _value The value that should be tranfered.
645      * @param _v
646      * @param _r
647      * @param _s
648      */
649     function approveProxy(address _from, address _spender, uint256 _value,
650         uint8 _v,bytes32 _r, bytes32 _s) public returns (bool success) {
651         uint256 nonce = nonces[_from];
652         bytes32 hash = keccak256(_from,_spender,_value,nonce);
653         require(_from == ecrecover(hash,_v,_r,_s));
654         allowed[_from][_spender] = _value;
655         Approval(_from, _spender, _value);
656         nonces[_from] = nonce + 1;
657         return true;
658     }
659 }
660 
661 contract HanYinToken is StableToken{
662     
663     function HanYinToken() public {
664         name = "HanYin stable Token";
665         decimals = 6;
666         symbol = "HYT";
667         version = 'v1.0';
668         
669         allocateEndTime = now + 1 days;
670 
671         setFeeParams(100, 0, 1000000000000);
672     }
673 }