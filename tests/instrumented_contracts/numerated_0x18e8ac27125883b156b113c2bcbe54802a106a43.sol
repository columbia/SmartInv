1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // @Name SafeMath
5 // @Desc Math operations with safety checks that throw on error
6 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7 // ----------------------------------------------------------------------------
8 library SafeMath {
9     
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a / b;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 // ----------------------------------------------------------------------------
35 // @title ERC20Basic
36 // @dev Simpler version of ERC20 interface
37 // See https://github.com/ethereum/EIPs/issues/179
38 // ----------------------------------------------------------------------------
39 contract ERC20Basic {
40     function totalSupply() public view returns (uint256);
41     function balanceOf(address who) public view returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 // ----------------------------------------------------------------------------
46 // @title ERC20 interface
47 // @dev See https://github.com/ethereum/EIPs/issues/20
48 // ----------------------------------------------------------------------------
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) public view returns (uint256);
51     function transferFrom(address from, address to, uint256 value) public returns (bool);
52     function approve(address spender, uint256 value) public returns (bool); 
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 // ----------------------------------------------------------------------------
56 // @title Basic token
57 // @dev Basic version of StandardToken, with no allowances.
58 // ----------------------------------------------------------------------------
59 contract BasicToken is ERC20Basic {
60     using SafeMath for uint256;
61 
62     mapping(address => uint256) balances;
63 
64     uint256 totalSupply_;
65 
66     function totalSupply() public view returns (uint256) {
67         return totalSupply_;
68     }
69 
70     function transfer(address _to, uint256 _value) public returns (bool) {
71         require(_to != address(0));
72         require(_value <= balances[msg.sender]);
73 
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76     
77         emit Transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     function balanceOf(address _owner) public view returns (uint256) {
82         return balances[_owner];
83     }
84 }
85 // ----------------------------------------------------------------------------
86 // @title Ownable
87 // @dev There are 5 role groups for FunkeyCoin [FKC].
88 // If an exchange is hacked, all stolen FKC in the hacker’s wallet must be incinerated and given back to its original investors.
89 // However, incineration and reissuance of tokens for specific addresses are sensitive matters. 
90 // Therefore, it requires 4 signatures: 3 C-Level personnels and Development Team Leader. 
91 // Incineration and Reissuing tokens for specific addresses can only be used in case of hacking and cannot be used otherwise. 
92 // ----------------------------------------------------------------------------
93 contract Ownable {
94     // Development Team Leader
95     address public owner;
96     // As the Funkeypay’s emergency standby personnel,
97     // the person immediately blocks the transaction function of all tokens when an incident occurs.
98     address public operator;
99 
100     // Has the authority to incinerate stolen tokens,
101     // reissue tokens due to incineration, and reappoint C-Level members.
102     address public CEO;                 
103     address public CTO;
104     address public CMO;
105 
106     bool public CEO_Signature;
107     bool public CTO_Signature;
108     bool public CMO_Signature;
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
112     event CEOTransferred(address indexed previousCEO, address indexed newCEO);
113     event CTOTransferred(address indexed previousCTO, address indexed newCTO);
114     event CMOTransferred(address indexed previousCMO, address indexed newCMO);
115 
116     constructor() public {
117         owner    = msg.sender;
118         operator = 0xFd48048f8c7B900b5E5216Dc9d7bCd147c2E2efb;
119 
120         CEO = 0xAC9C29a58C54921e822c972ACb5EBA955B59C744;
121         CTO = 0x60552ccF90872ad2d332DC26a5931Bc6BFb3142c;
122         CMO = 0xff76E74fE7AC6Dcd9C151D57A71A99D89910a098;
123 
124         ClearCLevelSignature();
125     }
126 
127     modifier onlyOwner() { require(msg.sender == owner); _; }
128     modifier onlyOwnerOrOperator() { require(msg.sender == owner || msg.sender == operator); _; }
129     modifier onlyCEO() { require(msg.sender == CEO); _; }
130     modifier onlyCTO() { require(msg.sender == CTO); _; }
131     modifier onlyCMO() { require(msg.sender == CMO); _; }
132     modifier AllCLevelSignature() { require(msg.sender == owner && CEO_Signature && CTO_Signature && CMO_Signature); _; }
133 
134     function CEOSignature() external onlyCEO { CEO_Signature = true; }
135     function CTOSignature() external onlyCTO { CTO_Signature = true; }
136     function CMOSignature() external onlyCMO { CMO_Signature = true; }
137 
138     function transferOwnership(address _newOwner) external AllCLevelSignature {
139         require(_newOwner != address(0));
140         ClearCLevelSignature();
141         emit OwnershipTransferred(owner, _newOwner);
142         owner = _newOwner;
143     }
144   
145     function transferOperator(address _newOperator) external onlyOwner {
146         require(_newOperator != address(0));
147         emit OperatorTransferred(operator, _newOperator);
148         operator = _newOperator;
149     }
150 
151     function transferCEO(address _newCEO) external AllCLevelSignature {
152         require(_newCEO != address(0));
153         ClearCLevelSignature();
154         emit CEOTransferred(CEO, _newCEO);
155         CEO = _newCEO;
156     }
157 
158     function transferCTO(address _newCTO) external AllCLevelSignature {
159         require(_newCTO != address(0));
160         ClearCLevelSignature();
161         emit CTOTransferred(CTO, _newCTO);
162         CTO = _newCTO;
163     }
164 
165     function transferCMO(address _newCMO) external AllCLevelSignature {
166         require(_newCMO != address(0));
167         ClearCLevelSignature();
168         emit CMOTransferred(CMO, _newCMO);
169         CMO = _newCMO;
170     }
171 
172     function SignatureInvalidity() external onlyOwnerOrOperator {
173         ClearCLevelSignature();
174     }
175 
176     function ClearCLevelSignature() internal {
177         CEO_Signature = false;
178         CTO_Signature = false;
179         CMO_Signature = false;
180     }
181 }
182 // ----------------------------------------------------------------------------
183 // @title BlackList
184 // @dev Base contract which allows children to implement an emergency stop mechanism.
185 // ----------------------------------------------------------------------------
186 contract BlackList is Ownable {
187 
188     event Lock(address indexed LockedAddress);
189     event Unlock(address indexed UnLockedAddress);
190 
191     mapping( address => bool ) public blackList;
192 
193     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
194 
195     function SetLockAddress(address _lockAddress) external onlyOwnerOrOperator returns (bool) {
196         require(_lockAddress != address(0));
197         require(_lockAddress != owner);
198         require(blackList[_lockAddress] != true);
199         
200         blackList[_lockAddress] = true;
201         
202         emit Lock(_lockAddress);
203 
204         return true;
205     }
206 
207     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
208         require(blackList[_unlockAddress] != false);
209         
210         blackList[_unlockAddress] = false;
211         
212         emit Unlock(_unlockAddress);
213 
214         return true;
215     }
216 }
217 // ----------------------------------------------------------------------------
218 // @title Pausable
219 // @dev Base contract which allows children to implement an emergency stop mechanism.
220 // ----------------------------------------------------------------------------
221 contract Pausable is Ownable {
222     event Pause();
223     event Unpause();
224 
225     bool public paused = false;
226 
227     modifier whenNotPaused() { require(!paused); _; }
228     modifier whenPaused() { require(paused); _; }
229 
230     function pause() onlyOwnerOrOperator whenNotPaused public {
231         paused = true;
232         emit Pause();
233     }
234 
235     function unpause() onlyOwner whenPaused public {
236         paused = false;
237         emit Unpause();
238     }
239 }
240 // ----------------------------------------------------------------------------
241 // @title Standard ERC20 token
242 // @dev Implementation of the basic standard token.
243 // https://github.com/ethereum/EIPs/issues/20
244 // ----------------------------------------------------------------------------
245 contract StandardToken is ERC20, BasicToken {
246   
247     mapping (address => mapping (address => uint256)) internal allowed;
248 
249     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
250         require(_to != address(0));
251         require(_value <= balances[_from]);
252         require(_value <= allowed[_from][msg.sender]);
253 
254         balances[_from] = balances[_from].sub(_value);
255         balances[_to] = balances[_to].add(_value);
256         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257     
258         emit Transfer(_from, _to, _value);
259     
260         return true;
261     }
262 
263     function approve(address _spender, uint256 _value) public returns (bool) {
264         allowed[msg.sender][_spender] = _value;
265     
266         emit Approval(msg.sender, _spender, _value);
267     
268         return true;
269     }
270 
271     function allowance(address _owner, address _spender) public view returns (uint256) {
272         return allowed[_owner][_spender];
273     }
274 
275     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
276         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
277     
278         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     
280         return true;
281     }
282 
283     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
284         uint256 oldValue = allowed[msg.sender][_spender];
285     
286         if (_subtractedValue > oldValue) {
287         allowed[msg.sender][_spender] = 0;
288         } else {
289         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290         }
291     
292         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293         return true;
294     }
295 }
296 // ----------------------------------------------------------------------------
297 // @title MultiTransfer Token
298 // @dev Only Admin
299 // ----------------------------------------------------------------------------
300 contract MultiTransferToken is StandardToken, Ownable {
301 
302     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
303         require(_to.length == _amount.length);
304 
305         uint256 ui;
306         uint256 amountSum = 0;
307     
308         for (ui = 0; ui < _to.length; ui++) {
309             require(_to[ui] != address(0));
310 
311             amountSum = amountSum.add(_amount[ui]);
312         }
313 
314         require(amountSum <= balances[msg.sender]);
315 
316         for (ui = 0; ui < _to.length; ui++) {
317             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
318             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
319         
320             emit Transfer(msg.sender, _to[ui], _amount[ui]);
321         }
322     
323         return true;
324     }
325 }
326 // ----------------------------------------------------------------------------
327 // @title Burnable Token
328 // @dev Token that can be irreversibly burned (destroyed).
329 // ----------------------------------------------------------------------------
330 contract BurnableToken is StandardToken, Ownable {
331 
332     event BurnAdminAmount(address indexed burner, uint256 value);
333     event BurnHackerAmount(address indexed hacker, uint256 hackingamount, string reason);
334 
335     function burnAdminAmount(uint256 _value) onlyOwner public {
336         require(_value <= balances[msg.sender]);
337 
338         balances[msg.sender] = balances[msg.sender].sub(_value);
339         totalSupply_ = totalSupply_.sub(_value);
340     
341         emit BurnAdminAmount(msg.sender, _value);
342         emit Transfer(msg.sender, address(0), _value);
343     }
344     
345     // burnHackingAmount() Function only exists for the incineration of stolen FKC.
346     // When a certain situation occurs, the function can be called after reviewing whether the wallet is the hacker’s wallet
347     // and signed by 3 C-level members & Development Team Leader.
348     function burnHackingAmount(address _hackerAddress, string _reason) AllCLevelSignature public {
349         ClearCLevelSignature();
350 
351         uint256 hackerAmount =  balances[_hackerAddress];
352         
353         require(hackerAmount > 0);
354 
355         balances[_hackerAddress] = balances[_hackerAddress].sub(hackerAmount);
356         totalSupply_ = totalSupply_.sub(hackerAmount);
357     
358         emit BurnHackerAmount(_hackerAddress, hackerAmount, _reason);
359         emit Transfer(_hackerAddress, address(0), hackerAmount);
360     }
361 }
362 // ----------------------------------------------------------------------------
363 // @title Mintable token
364 // @dev Simple ERC20 Token example, with mintable token creation
365 // Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
366 // ----------------------------------------------------------------------------
367 contract MintableToken is StandardToken, Ownable {
368     event Mint(address indexed to, uint256 amount);
369     event MintFinished();
370     event MintRestarted(string reason);
371 
372     bool public mintingFinished = false;
373 
374     modifier canMint() { require(!mintingFinished); _; }
375     modifier cannotMint() { require(mintingFinished); _; }
376 
377     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
378         totalSupply_ = totalSupply_.add(_amount);
379         balances[_to] = balances[_to].add(_amount);
380     
381         emit Mint(_to, _amount);
382         emit Transfer(address(0), _to, _amount);
383     
384         return true;
385     }
386 
387     function finishMinting() onlyOwner canMint public returns (bool) {
388         mintingFinished = true;
389         emit MintFinished();
390         return true;
391     }
392 
393     // restartMinting() Function isn’t for just simple reissuing.
394     // When the hacking occurs, all amount of FKC in the hacker's wallet
395     // is incinerated and corresponding quantity of FKC will be reissued to the victims’ wallets.
396     function restartMinting(string _reason) AllCLevelSignature cannotMint public returns (bool) {
397         ClearCLevelSignature();
398 
399         mintingFinished = false;
400         emit MintRestarted(_reason);
401         return true;
402     }
403 }
404 // ----------------------------------------------------------------------------
405 // @title Pausable token
406 // @dev StandardToken modified with pausable transfers.
407 // ----------------------------------------------------------------------------
408 contract PausableToken is StandardToken, Pausable, BlackList {
409 
410     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
411         return super.transfer(_to, _value);
412     }
413 
414     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
415         return super.transferFrom(_from, _to, _value);
416     }
417 
418     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
419         return super.approve(_spender, _value);
420     }
421 
422     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
423         return super.increaseApproval(_spender, _addedValue);
424     }
425 
426     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
427         return super.decreaseApproval(_spender, _subtractedValue);
428     }
429 }
430 // ----------------------------------------------------------------------------
431 // @Project FunkeyCoin (FKC)
432 // @Creator Gi Hyeok - Ryu
433 // @Source Code Verification (CEO : JK JUNG / CTO : SeungWoo KANG)
434 // ----------------------------------------------------------------------------
435 contract FunkeyCoin is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
436     string public name = "FunkeyCoin";
437     string public symbol = "FKC";
438     uint256 public decimals = 18;
439 }