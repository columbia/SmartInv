1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  * from OpenZeppelin
8  * https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/master/contracts/math/SafeMath.sol
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b > 0); // Solidity only automatically asserts when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     /**
41     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51     * @dev Adds two numbers, reverts on overflow.
52     */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a);
56 
57         return c;
58     }
59 
60     /**
61     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
62     * reverts when dividing by zero.
63     */
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0);
66         return a % b;
67     }
68 }
69 
70 
71 /**
72 * @dev Contract that is working with ERC223 tokens.
73 */
74 contract ContractReceiver {     
75     struct TKN {
76         address sender;
77         uint256 value;
78         bytes data;
79         bytes4 sig;
80     }    
81     
82     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
83         TKN memory tkn;
84         tkn.sender = _from;
85         tkn.value = _value;
86         tkn.data = _data;
87         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
88         tkn.sig = bytes4(u);
89     }
90 }
91 
92 
93 /**
94 * @dev PetToken
95 * @dev Author: Solange Gueiros
96 */
97 contract PetToken {
98     using SafeMath for uint256;
99 
100     address public owner;
101     address public ownerMaster;
102     string public name;
103     string public symbol;
104     uint8 public decimals;
105 
106     address public adminAddress;
107     address public auditAddress;
108     address public marketMakerAddress;
109     address public mintFeeReceiver;
110     address public transferFeeReceiver;
111     address public burnFeeReceiver; 
112 
113     uint256 public decimalpercent = 1000000;            //precisão da porcentagem (4) + 2 casas para 100%   
114     struct feeStruct {        
115         uint256 abs;
116         uint256 prop;
117     }
118     feeStruct public mintFee;
119     feeStruct public transferFee;
120     feeStruct public burnFee;
121     uint256 public feeAbsMax;
122     uint256 public feePropMax;
123 
124     struct approveMintStruct {        
125         uint256 amount;
126         address admin;
127         address audit;
128         address marketMaker;
129     }
130     mapping (address => approveMintStruct) public mintApprove;
131 
132     struct approveBurnStruct {
133         uint256 amount;
134         address admin;
135     }    
136     mapping (address => approveBurnStruct) public burnApprove;
137 
138     uint256 public transferWait;
139     uint256 public transferMaxAmount;
140     uint256 public lastTransfer;
141     bool public speedBump;
142 
143 
144     constructor(address _ownerMaster, string _name, string _symbol,
145             uint256 _feeAbsMax, uint256 _feePropMax,
146             uint256 _transferWait, uint256 _transferMaxAmount
147         ) public {
148         decimals = 18;
149         owner = msg.sender;
150         name = _name;
151         symbol = _symbol;        
152         feeAbsMax = _feeAbsMax;
153         feePropMax = _feePropMax;        
154         ownerMaster = _ownerMaster;
155         transferWait = _transferWait;
156         transferMaxAmount = _transferMaxAmount;
157         lastTransfer = 0;        
158         speedBump = false;
159     }
160 
161     /**
162     * @dev Modifiers
163     */
164     modifier onlyAdmin() {
165         require(msg.sender == adminAddress, "Only admin");
166         _;
167     }
168     modifier onlyAudit() {
169         require(msg.sender == auditAddress, "Only audit");
170         _;
171     }
172     modifier onlyMarketMaker() {
173         require(msg.sender == marketMakerAddress, "Only market maker");
174         _;
175     }
176     modifier noSpeedBump() {
177         require(!speedBump, "Speed bump activated");
178         _;
179     }
180     modifier hasMintPermission(address _address) {
181         require(mintApprove[_address].admin != 0x0, "Require admin approval");
182         require(mintApprove[_address].audit != 0x0, "Require audit approval");
183         require(mintApprove[_address].marketMaker != 0x0, "Require market maker approval"); 
184         _;
185     }     
186 
187     /**
188     * @dev AlfaPetToken functions
189     */
190     function mint(address _to, uint256 _amount) public hasMintPermission(_to) canMint noSpeedBump {
191         uint256 fee = calcMintFee (_amount);
192         uint256 toValue = _amount.sub(fee);
193         _mint(mintFeeReceiver, fee);
194         _mint(_to, toValue);
195         _mintApproveClear(_to);
196     }
197 
198     function transfer(address _to, uint256 _amount) public returns (bool success) {
199         if (speedBump) 
200         {
201             //Verifica valor
202             require (_amount <= transferMaxAmount, "Speed bump activated, amount exceeded");
203 
204             //Verifica frequencia
205             require (now > (lastTransfer + transferWait), "Speed bump activated, frequency exceeded");
206             lastTransfer = now;
207         }
208         uint256 fee = calcTransferFee (_amount);
209         uint256 toValue = _amount.sub(fee);
210         _transfer(transferFeeReceiver, fee);
211         _transfer(_to, toValue);
212         return true;
213     }
214 
215     function burn(uint256 _amount) public onlyMarketMaker {
216         uint256 fee = calcBurnFee (_amount);
217         uint256 fromValue = _amount.sub(fee);
218         _transfer(burnFeeReceiver, fee);
219         _burn(msg.sender, fromValue);
220     }
221 
222     /*
223     * @dev Calc Fees
224     */
225     function calcMintFee(uint256 _amount) public view returns (uint256) {
226         uint256 fee = 0;
227         fee = _amount.div(decimalpercent);
228         fee = fee.mul(mintFee.prop);
229         fee = fee.add(mintFee.abs);
230         return fee;
231     }
232 
233     function calcTransferFee(uint256 _amount) public view returns (uint256) {
234         uint256 fee = 0;
235         fee = _amount.div(decimalpercent);
236         fee = fee.mul(transferFee.prop);
237         fee = fee.add(transferFee.abs);
238         return fee;
239     }
240 
241     function calcBurnFee(uint256 _amount) public view returns (uint256) {
242         uint256 fee = 0;
243         fee = _amount.div(decimalpercent);
244         fee = fee.mul(burnFee.prop);
245         fee = fee.add(burnFee.abs);
246         return fee;
247     }
248 
249 
250     /**
251     * @dev Set variables
252     */
253     function setAdmin(address _address) public onlyOwner returns (address) {
254         adminAddress = _address;
255         return adminAddress;
256     }
257     function setAudit(address _address) public onlyOwner returns (address) {
258         auditAddress = _address;
259         return auditAddress;
260     }
261     function setMarketMaker(address _address) public onlyOwner returns (address) {
262         marketMakerAddress = _address;    
263         return marketMakerAddress;
264     }
265 
266     function setMintFeeReceiver(address _address) public onlyOwner returns (bool) {
267         mintFeeReceiver = _address;
268         return true;
269     }
270     function setTransferFeeReceiver(address _address) public onlyOwner returns (bool) {
271         transferFeeReceiver = _address;
272         return true;
273     }
274     function setBurnFeeReceiver(address _address) public onlyOwner returns (bool) {
275         burnFeeReceiver = _address;
276         return true;
277     }
278 
279     /**
280     * @dev Set Fees
281     */
282     event SetFee(string action, string typeFee, uint256 value);
283 
284     function setMintFeeAbs(uint256 _value) external onlyOwner returns (bool) {
285         require(_value < feeAbsMax, "Must be less then maximum");
286         mintFee.abs = _value;
287         emit SetFee("mint", "absolute", _value);
288         return true;
289     }
290     function setMintFeeProp(uint256 _value) external onlyOwner returns (bool) {
291         require(_value < feePropMax, "Must be less then maximum");
292         mintFee.prop = _value;
293         emit SetFee("mint", "proportional", _value);
294         return true;
295     }
296 
297     function setTransferFeeAbs(uint256 _value) external onlyOwner returns (bool) {
298         require(_value < feeAbsMax, "Must be less then maximum");
299         transferFee.abs = _value;
300         emit SetFee("transfer", "absolute", _value);
301         return true;
302     } 
303     function setTransferFeeProp(uint256 _value) external onlyOwner returns (bool) {
304         require(_value < feePropMax, "Must be less then maximum");
305         transferFee.prop = _value;
306         emit SetFee("transfer", "proportional", _value);
307         return true;
308     }
309 
310     function setBurnFeeAbs(uint256 _value) external onlyOwner returns (bool) {
311         require(_value < feeAbsMax, "Must be less then maximum");
312         burnFee.abs = _value;
313         emit SetFee("burn", "absolute", _value);
314         return true;
315     }
316     function setBurnFeeProp(uint256 _value) external onlyOwner returns (bool) {
317         require(_value < feePropMax, "Must be less then maximum");
318         burnFee.prop = _value;
319         emit SetFee("burn", "proportional", _value);
320         return true;
321     }
322    
323     /*
324     * @dev Mint Approval
325     */
326     function mintApproveReset(address _address) public onlyOwner {
327         _mintApproveClear(_address);
328     }
329 
330     function _mintApproveClear(address _address) internal {
331         mintApprove[_address].amount = 0;
332         mintApprove[_address].admin = 0x0;
333         mintApprove[_address].audit = 0x0;
334         mintApprove[_address].marketMaker = 0x0;
335     }
336 
337     function mintAdminApproval(address _address, uint256 _value) public onlyAdmin {
338         if (mintApprove[_address].amount > 0) {
339             require(mintApprove[_address].amount == _value, "Value is diferent");
340         }
341         else {
342             mintApprove[_address].amount = _value;
343         }        
344         mintApprove[_address].admin = msg.sender;
345         
346         if ((mintApprove[_address].audit != 0x0) && (mintApprove[_address].marketMaker != 0x0))
347             mint(_address, _value);
348     }
349 
350     function mintAdminCancel(address _address) public onlyAdmin {
351         require(mintApprove[_address].admin == msg.sender, "Only cancel if the address is the same admin");
352         mintApprove[_address].admin = 0x0;
353     }
354 
355     function mintAuditApproval(address _address, uint256 _value) public onlyAudit {
356         if (mintApprove[_address].amount > 0) {
357             require(mintApprove[_address].amount == _value, "Value is diferent");
358         }
359         else {
360             mintApprove[_address].amount = _value;
361         }        
362         mintApprove[_address].audit = msg.sender;
363 
364         if ((mintApprove[_address].admin != 0x0) && (mintApprove[_address].marketMaker != 0x0))
365             mint(_address, _value);
366     }
367 
368     function mintAuditCancel(address _address) public onlyAudit {
369         require(mintApprove[_address].audit == msg.sender, "Only cancel if the address is the same audit");
370         mintApprove[_address].audit = 0x0;
371     }
372 
373     function mintMarketMakerApproval(address _address, uint256 _value) public onlyMarketMaker {
374         if (mintApprove[_address].amount > 0) {
375             require(mintApprove[_address].amount == _value, "Value is diferent");
376         }
377         else {
378             mintApprove[_address].amount = _value;
379         }        
380         mintApprove[_address].marketMaker = msg.sender;
381 
382         if ((mintApprove[_address].admin != 0x0) && (mintApprove[_address].audit != 0x0))
383             mint(_address, _value);
384     }
385 
386     function mintMarketMakerCancel(address _address) public onlyMarketMaker {
387         require(mintApprove[_address].marketMaker == msg.sender, "Only cancel if the address is the same marketMaker");
388         mintApprove[_address].marketMaker = 0x0;
389     }
390 
391     /*
392     * @dev SpeedBump
393     */
394     event SpeedBumpUpdated(bool value);
395     function setSpeedBump (bool _value) public onlyMasterOwner {  
396         speedBump = _value;
397         emit SpeedBumpUpdated(_value);
398     }
399 
400     /**
401     * @dev Ownable 
402     * ownerMaster can not be changed.
403     */
404     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);    
405 
406     modifier onlyOwner() {
407         require((msg.sender == owner) || (msg.sender == ownerMaster), "Only owner");
408         _;
409     }
410     modifier onlyMasterOwner() {
411         require(msg.sender == ownerMaster, "Only master owner");
412         _;
413     }
414     function transferOwnership(address _newOwner) public onlyOwner {
415         _transferOwnership(_newOwner);
416     }
417     function _transferOwnership(address _newOwner) internal {
418         require(_newOwner != address(0), "newOwner must be not 0x0");
419         emit OwnershipTransferred(owner, _newOwner);
420         owner = _newOwner;
421     }
422 
423 
424     /**
425     * @dev Mintable token
426     */
427     event Mint(address indexed to, uint256 amount);
428     event MintFinished();
429     bool public mintingFinished = false;
430 
431     modifier canMint() {
432         require(!mintingFinished, "Mint is finished");
433         _;
434     }
435     function finishMinting() public onlyMasterOwner canMint returns (bool) {
436         mintingFinished = true;
437         emit MintFinished();
438         return true;
439     }
440     function _mint(address _account, uint256 _amount) internal canMint {
441         require(_account != 0, "Address must not be zero");
442         totalSupply_ = totalSupply_.add(_amount);
443         balances[_account] = balances[_account].add(_amount);
444         emit Transfer(address(0), _account, _amount);
445         emit Mint(_account, _amount);
446     }
447 
448     /**
449     * @dev Burnable Token
450     */
451     event Burn(address indexed burner, uint256 value);
452 
453     function _burn(address _account, uint256 _amount) internal {
454         require(_account != 0, "Address must not be zero");
455         require(_amount <= balances[_account], "Insuficient funds");
456 
457         totalSupply_ = totalSupply_.sub(_amount);
458         balances[_account] = balances[_account].sub(_amount);
459         emit Transfer(_account, address(0), _amount);
460         emit Burn(_account, _amount);
461     }
462 
463     /**
464     * @dev Standard ERC20 token
465     */
466     mapping (address => uint256) private balances;
467     mapping (address => mapping (address => uint256)) private allowed;
468     uint256 private totalSupply_;
469 
470     event Transfer(address indexed from, address indexed to, uint256 value);
471     event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
472 
473     function totalSupply() public view returns (uint256) {
474         return totalSupply_;
475     }    
476     function balanceOf(address _owner) public view returns (uint256) {
477         return balances[_owner];
478     }
479     
480     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
481         return allowed[_owner][_spender];
482     }
483     function approve(address spender, uint256 value) public pure returns (bool success){
484         //Not implemented
485         return false;
486     }
487     function transferFrom(address from, address to, uint256 value) public pure returns (bool success){
488         //Not implemented
489         return false;
490     }
491 
492     /**
493     * @dev ERC223 token
494     */
495     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
496   
497     function _transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) private returns (bool success) {                
498         if (isContract(_to)) {
499             if (balanceOf(msg.sender) < _value) revert("Insuficient funds");
500             balances[msg.sender] = balanceOf(msg.sender).sub(_value);
501             balances[_to] = balanceOf(_to).add(_value);
502             assert(_to.call.value(0)(bytes4(keccak256(abi.encodePacked(_custom_fallback))), msg.sender, _value, _data));
503             emit Transfer(msg.sender, _to, _value, _data);
504             return true;
505         }
506         else {
507             return transferToAddress(_to, _value, _data);
508         }
509     }
510 
511     function _transfer(address _to, uint256 _value, bytes _data) private returns (bool success) {            
512         if(isContract(_to)) {
513             return transferToContract(_to, _value, _data);
514         }
515         else {
516             return transferToAddress(_to, _value, _data);
517         }
518     }
519 
520     function _transfer(address _to, uint256 _value) private returns (bool success) {            
521         bytes memory empty;
522         if(isContract(_to)) {
523             return transferToContract(_to, _value, empty);
524         }
525         else {
526             return transferToAddress(_to, _value, empty);
527         }
528     }
529 
530     function isContract(address _addr) private view returns (bool is_contract) {
531         uint codeLength;
532         assembly {
533             codeLength := extcodesize(_addr)
534         }
535         return (codeLength>0);
536     }
537 
538     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
539         if (balanceOf(msg.sender) < _value) revert("Insuficient funds");
540         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
541         balances[_to] = balanceOf(_to).add(_value);        
542         emit Transfer(msg.sender, _to, _value, _data);
543         return true;
544     }
545   
546     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
547         if (balanceOf(msg.sender) < _value) revert("Insuficient funds");
548         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
549         balances[_to] = balanceOf(_to).add(_value);
550         ContractReceiver receiver = ContractReceiver(_to);
551         receiver.tokenFallback(msg.sender, _value, _data);
552         emit Transfer(msg.sender, _to, _value, _data);
553         return true;
554     }
555 
556 }