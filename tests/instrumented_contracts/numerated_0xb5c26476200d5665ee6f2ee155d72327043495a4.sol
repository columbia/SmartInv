1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract UpgradeAgent {
28   function upgradeFrom(address _from, uint256 _value) external;
29 }
30 
31 contract ERC223Interface {
32     uint public totalSupply;
33     function name() public view returns (string _name);
34     function symbol() public view returns (string _symbol);
35     function decimals() public view returns (uint8 _decimals);
36     function totalSupply() public view returns (uint256 _supply);
37 
38     function balanceOf(address who) public view returns (uint256);
39 
40     function transfer(address to, uint value) public returns (bool ok);
41     function transfer(address to, uint value, bytes data) public returns (bool ok);
42     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
43 
44     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
45 }
46 
47 contract ERC20Interface {
48     function allowance(address owner, address spender) public view returns (uint256);
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50     function transferFrom(address from, address to, uint256 value, bytes data) public returns (bool);
51     
52     function approve(address spender, uint256 value) public returns (bool);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ReceivingContract { 
58 
59     struct TKN {
60         address sender;
61         uint value;
62         bytes data;
63         bytes4 sig;
64     }
65 
66     function tokenFallback(address _from, uint _value, bytes _data) public pure {
67         TKN memory tkn;
68         tkn.sender = _from;
69         tkn.value = _value;
70         tkn.data = _data;
71         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
72         
73         tkn.sig = bytes4(u);
74     }
75 }
76 
77 contract Owned {
78     address public owner;
79     
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86     
87     function Owned() public {
88         owner = msg.sender;
89     }
90     
91     function changeOwner(address _newOwner) public onlyOwner {
92         require(_newOwner != address(0));
93         OwnershipTransferred(owner, _newOwner);
94         owner = _newOwner;
95     }
96 }
97 
98 contract TORUE is ERC223Interface,ERC20Interface,Owned {
99     using SafeMath for uint;
100     
101     string public name = "torue";
102     string public symbol = "TRE";
103     uint8 public decimals = 6;
104     uint256 public totalSupply = 100e8 * 1e6;
105 
106     mapping (address => uint256) balances;
107     mapping (address => uint256) public lockedAccounts;
108     mapping (address => bool) public frozenAccounts;
109     mapping (address => mapping (address => uint256)) internal allowed;
110     mapping (address => bool) public salvageableAddresses;
111     
112     event Mint(address indexed to, uint256 amount);
113     event MintFinished();
114     event Burn(address indexed burner, uint256 value);
115     event DistributeTokens(uint count,uint256 totalAmount);
116     event Upgrade(address indexed from, address indexed to, uint256 value);
117     event AccountLocked(address indexed addr, uint256 releaseTime);
118     event AccountFrozen(address indexed addr, bool frozen);
119 
120     address ownerAddress = 0xA0Bf23D5Ef64B6DdEbF5343a3C897c53005ee665;
121     address lockupAddress1 = 0xB3c289934692ECE018d137fFcaB54631e6e2b405;
122     address lockupAddress2 = 0x533c43AF0DDb5ee5215c0139d917F1A871ff9CB5;
123 
124     bool public compatible20 = true;
125     bool public compatible223 = true;
126     bool public compatible223ex = true;
127     
128     bool public mintingFinished = false;
129     bool public salvageFinished = false;
130     bool public paused = false;
131     bool public upgradable = false;
132     bool public upgradeAgentLocked = false;
133     
134     address public upgradeMaster;
135     address public upgradeAgent;
136     uint256 public totalUpgraded;
137 
138     modifier canMint() {
139         require(!mintingFinished);
140         _;
141     }
142     
143     modifier isRunning(){
144         require(!paused);
145         _;
146     }
147     
148     function TORUE() public {
149         require(msg.sender==ownerAddress);
150         owner = ownerAddress;
151         upgradeMaster = ownerAddress;
152         balances[owner] = totalSupply.mul(70).div(100);
153         balances[lockupAddress1] = totalSupply.mul(15).div(100);
154         balances[lockupAddress2] = totalSupply.mul(15).div(100);
155         paused = false;
156     }
157     
158     function switchCompatible20(bool _value) onlyOwner public {
159         compatible20 = _value;
160     }
161     function switchCompatible223(bool _value) onlyOwner public {
162         compatible223 = _value;
163     }
164     function switchCompatible223ex(bool _value) onlyOwner public {
165         compatible223ex = _value;
166     }
167 
168     function switchPaused(bool _paused) onlyOwner public {
169         paused = _paused;
170     }
171     
172     function switchUpgradable(bool _value) onlyOwner public {
173         upgradable = _value;
174     }
175     
176     function switchUpgradeAgentLocked(bool _value) onlyOwner public {
177         upgradeAgentLocked = _value;
178     }
179 
180     function isUnlocked(address _addr) private view returns (bool){
181         return(now > lockedAccounts[_addr] && frozenAccounts[_addr] == false);
182     }
183     
184     function isUnlockedBoth(address _addr) private view returns (bool){
185         return(now > lockedAccounts[msg.sender] && now > lockedAccounts[_addr] && frozenAccounts[msg.sender] == false && frozenAccounts[_addr] == false);
186     }
187     
188     function lockAccounts(address[] _addresses, uint256 _releaseTime) onlyOwner public {
189         require(_addresses.length > 0);
190                 
191         for(uint j = 0; j < _addresses.length; j++){
192             require(lockedAccounts[_addresses[j]] < _releaseTime);
193             lockedAccounts[_addresses[j]] = _releaseTime;
194             AccountLocked(_addresses[j], _releaseTime);
195         }
196     }
197 
198     function freezeAccounts(address[] _addresses, bool _value) onlyOwner public {
199         require(_addresses.length > 0);
200 
201         for (uint j = 0; j < _addresses.length; j++) {
202             require(_addresses[j] != 0x0);
203             frozenAccounts[_addresses[j]] = _value;
204             AccountFrozen(_addresses[j], _value);
205         }
206     }
207 
208     function setSalvageable(address _addr, bool _value) onlyOwner public {
209         salvageableAddresses[_addr] = _value;
210     }
211     
212     function finishSalvage(address _addr) onlyOwner public returns (bool) {
213         require(_addr==owner);
214         salvageFinished = true;
215         return true;
216     }
217     
218     function salvageTokens(address _addr,uint256 _amount) onlyOwner public isRunning returns(bool) {
219         require(_amount > 0 && balances[_addr] >= _amount);
220         require(now > lockedAccounts[msg.sender] && now > lockedAccounts[_addr]);
221         require(salvageableAddresses[_addr] == true && salvageFinished == false);
222         balances[_addr] = balances[_addr].sub(_amount);
223         balances[msg.sender] = balances[msg.sender].add(_amount);
224         Transfer(_addr, msg.sender, _amount);
225         return true;
226     }
227 
228     function approve(address _spender, uint256 _value) public isRunning returns (bool) {
229         require(compatible20);
230         allowed[msg.sender][_spender] = _value;
231         Approval(msg.sender, _spender, _value);
232         return true;
233     }
234 
235     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
236         return allowed[_owner][_spender];
237     }
238     
239     function transferFrom(address _from, address _to, uint256 _value) public isRunning returns (bool) {
240         require(compatible20);
241         require(isUnlocked(_from));
242         require(isUnlocked(_to));
243         
244         require(_to != address(0));
245         require(_value <= balances[_from]);
246         require(_value <= allowed[_from][msg.sender]);
247         balances[_from] = balances[_from].sub(_value);
248         balances[_to] = balances[_to].add(_value);
249         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
250         
251         if(isContract(_to)) {
252             bytes memory empty;
253             ReceivingContract rc = ReceivingContract(_to);
254             rc.tokenFallback(msg.sender, _value, empty);
255         }
256         Transfer(_from, _to, _value);
257         return true;
258     }
259     
260     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public isRunning returns (bool) {
261         require(compatible223);
262         require(isUnlocked(_from));
263         require(isUnlocked(_to));
264         
265         require(_to != address(0));
266         require(_value <= balances[_from]);
267         require(_value <= allowed[_from][msg.sender]);
268         balances[_from] = balances[_from].sub(_value);
269         balances[_to] = balances[_to].add(_value);
270         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
271         
272         if(isContract(_to)) {
273             ReceivingContract rc = ReceivingContract(_to);
274             rc.tokenFallback(msg.sender, _value, _data);
275         }
276         Transfer(msg.sender, _to, _value, _data);
277         Transfer(_from, _to, _value);
278         return true;
279     }
280 
281     function increaseApproval(address _spender, uint _addedValue) public isRunning returns (bool) {
282         require(compatible20);
283         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
284         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285         return true;
286     }
287     
288     function decreaseApproval(address _spender, uint _subtractedValue) public isRunning returns (bool) {
289         require(compatible20);
290         uint oldValue = allowed[msg.sender][_spender];
291         if (_subtractedValue > oldValue) {
292             allowed[msg.sender][_spender] = 0;
293         } else {
294             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295         }
296         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297         return true;
298     }
299     
300     function mint(address _to, uint256 _amount) onlyOwner canMint public isRunning returns (bool) {
301         totalSupply = totalSupply.add(_amount);
302         balances[_to] = balances[_to].add(_amount);
303         Mint(_to, _amount);
304         Transfer(address(0), _to, _amount);
305         return true;
306     }
307     
308     function finishMinting(address _addr) onlyOwner public returns (bool) {
309         require(_addr==owner);
310         mintingFinished = true;
311         MintFinished();
312         return true;
313     }
314     
315     function burn(uint256 _value) public isRunning {
316         require(_value > 0);
317         require(_value <= balances[msg.sender]);
318 
319         address burner = msg.sender;
320         balances[burner] = balances[burner].sub(_value);
321         totalSupply = totalSupply.sub(_value);
322         Burn(msg.sender, _value);
323     }
324 
325     function isContract(address _addr) private view returns (bool is_contract) {
326         uint ln;
327         assembly {
328             ln := extcodesize(_addr)
329         }
330         return (ln > 0);
331     }
332 
333     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public isRunning returns (bool ok) {
334         require(compatible223ex);
335         require(isUnlockedBoth(_to));
336         require(balances[msg.sender] >= _value);
337         balances[msg.sender] = balances[msg.sender].sub(_value);
338         balances[_to] = balances[_to].add(_value);
339         if (isContract(_to)) {
340             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
341         }
342         Transfer(msg.sender, _to, _value, _data);
343         Transfer(msg.sender, _to, _value);
344 
345         return true;
346     }
347 
348     function transfer(address _to, uint _value, bytes _data) public isRunning returns (bool ok) {
349         require(compatible223);
350         require(isUnlockedBoth(_to));
351         require(balances[msg.sender] >= _value);
352         balances[msg.sender] = balances[msg.sender].sub(_value);
353         balances[_to] = balances[_to].add(_value);
354         if(isContract(_to)) {
355             ReceivingContract rc = ReceivingContract(_to);
356             rc.tokenFallback(msg.sender, _value, _data);
357         }
358         Transfer(msg.sender, _to, _value, _data);
359         Transfer(msg.sender, _to, _value);
360         return true;
361     }
362     
363     function transfer(address _to, uint _value) public isRunning returns (bool ok) {
364         require(isUnlockedBoth(_to));
365         require(balances[msg.sender] >= _value);
366         balances[msg.sender] = balances[msg.sender].sub(_value);
367         balances[_to] = balances[_to].add(_value);
368         if(isContract(_to)) {
369             bytes memory empty;
370             ReceivingContract rc = ReceivingContract(_to);
371             rc.tokenFallback(msg.sender, _value, empty);
372         }
373         Transfer(msg.sender, _to, _value);
374         return true;
375     }
376     
377     function name() public view returns (string _name) {
378         return name;
379     }
380     
381     function symbol() public view returns (string _symbol) {
382         return symbol;
383     }
384     
385     function decimals() public view returns (uint8 _decimals) {
386         return decimals;
387     }
388     
389     function totalSupply() public view returns (uint256 _totalSupply) {
390         return totalSupply;
391     }
392 
393     function balanceOf(address _owner) public view returns (uint256 balance) {
394         return balances[_owner];
395     }
396     
397     function distributeTokens(address[] _addresses, uint256 _amount) onlyOwner public isRunning returns(bool) {
398         require(_addresses.length > 0 && isUnlocked(msg.sender));
399 
400         uint256 totalAmount = _amount.mul(_addresses.length);
401         require(balances[msg.sender] >= totalAmount);
402 
403         for (uint j = 0; j < _addresses.length; j++) {
404             require(isUnlocked(_addresses[j]));
405             balances[_addresses[j]] = balances[_addresses[j]].add(_amount);
406             Transfer(msg.sender, _addresses[j], _amount);
407         }
408         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
409         DistributeTokens(_addresses.length, totalAmount);
410         
411         return true;
412     }
413     
414     function distributeTokens(address[] _addresses, uint256[] _amounts) onlyOwner public isRunning returns (bool) {
415         require(_addresses.length > 0 && _addresses.length == _amounts.length && isUnlocked(msg.sender));
416         uint256 totalAmount = 0;
417         for(uint j = 0; j < _addresses.length; j++){
418             require(_amounts[j] > 0 && _addresses[j] != 0x0 && isUnlocked(_addresses[j]));
419             totalAmount = totalAmount.add(_amounts[j]);
420         }
421         require(balances[msg.sender] >= totalAmount);
422         
423         for (j = 0; j < _addresses.length; j++) {
424             balances[_addresses[j]] = balances[_addresses[j]].add(_amounts[j]);
425             Transfer(msg.sender, _addresses[j], _amounts[j]);
426         }
427         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
428         DistributeTokens(_addresses.length, totalAmount);
429 
430         return true;
431     }
432 
433     function upgrade(uint256 _value) external isRunning {
434         require(upgradable);
435         require(upgradeAgent != 0);
436         require(_value != 0);
437         require(_value <= balances[msg.sender]);
438         balances[msg.sender] = balances[msg.sender].sub(_value);
439         totalSupply = totalSupply.sub(_value);
440         totalUpgraded = totalUpgraded.add(_value);
441         UpgradeAgent(upgradeAgent).upgradeFrom(msg.sender, _value);
442         Upgrade(msg.sender, upgradeAgent, _value);
443     }
444     
445     function setUpgradeAgent(address _agent) external {
446         require(_agent != 0);
447         require(!upgradeAgentLocked);
448         require(msg.sender == upgradeMaster);
449         
450         upgradeAgent = _agent;
451         upgradeAgentLocked = true;
452     }
453     
454     function setUpgradeMaster(address _master) external {
455         require(_master != 0);
456         require(msg.sender == upgradeMaster);
457         
458         upgradeMaster = _master;
459     }
460 
461 }