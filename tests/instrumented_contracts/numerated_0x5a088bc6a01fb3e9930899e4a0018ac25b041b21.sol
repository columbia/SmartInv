1 pragma solidity ^0.4.24;
2 
3 // SafeMath methods
4 library SafeMath {
5     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
6         uint256 c = _a + _b;
7         assert(c >= _a);
8         return c;
9     }
10 
11     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
12         assert(_a >= _b);
13         return _a - _b;
14     }
15 
16     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
17         uint256 c = _a * _b;
18         assert(_a == 0 || c / _a == _b);
19         return c;
20     }
21 }
22 
23 // Contract must have an owner
24 contract Owned {
25     address public owner;
26 
27     constructor() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function setOwner(address _owner) onlyOwner public {
37         owner = _owner;
38     }
39 }
40 
41 // Standard ERC20 Token Interface
42 interface ERC20Token {
43     function name() external view returns (string name_);
44     function symbol() external view returns (string symbol_);
45     function decimals() external view returns (uint8 decimals_);
46     function totalSupply() external view returns (uint256 totalSupply_);
47     function balanceOf(address _owner) external view returns (uint256 _balance);
48     function transfer(address _to, uint256 _value) external returns (bool _success);
49     function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
50     function approve(address _spender, uint256 _value) external returns (bool _success);
51     function allowance(address _owner, address _spender) external view returns (uint256 _remaining);
52 
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 // the main ERC20-compliant multi-timelock enabled contract
58 contract YULP is Owned, ERC20Token {
59     using SafeMath for uint256;
60 
61     string private constant standard = "201907023309";
62     string private constant version = "6.0675600";
63     string private name_ = "Yeuler Points";
64     string private symbol_ = "YULP";
65     uint8 private decimals_ = 18;
66     uint256 private totalSupply_ = uint256(100) * uint256(10)**uint256(8) * uint256(10)**uint256(decimals_);
67     mapping (address => uint256) private balanceP;
68     mapping (address => mapping (address => uint256)) private allowed;
69 
70     mapping (address => uint256[]) private lockTime;
71     mapping (address => uint256[]) private lockValue;
72     mapping (address => uint256) private lockNum;
73     uint256 private later = 0;
74     uint256 private earlier = 0;
75     bool private mintable_ = true;
76 
77     // burn token event
78     event Burn(address indexed _from, uint256 _value);
79 
80     // mint token event
81     event Mint(address indexed _to, uint256 _value);
82 
83     // timelock-related events
84     event TransferLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
85     event TokenUnlocked(address indexed _address, uint256 _value);
86 
87     // safety method-related events
88     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
89     event WrongEtherEmptied(address indexed _addr, uint256 _amount);
90 
91     // constructor for the ERC20 Token
92     constructor() public {
93         balanceP[msg.sender] = totalSupply_;
94     }
95 
96     modifier validAddress(address _address) {
97         require(_address != 0x0);
98         _;
99     }
100 
101     modifier isMintable() {
102         require(mintable_);
103         _;
104     }
105 
106     // fast-forward the timelocks for all accounts
107     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
108         earlier = earlier.add(_earlier);
109     }
110 
111     // delay the timelocks for all accounts
112     function setUnlockLater(uint256 _later) public onlyOwner {
113         later = later.add(_later);
114     }
115 
116     // owner may permanently disable minting
117     function disableMint() public onlyOwner isMintable {
118         mintable_ = false;
119     }
120 
121     // show if the token is still mintable
122     function mintable() public view returns (bool) {
123         return mintable_;
124     }
125 
126     // standard ERC20 name function
127     function name() public view returns (string) {
128         return name_;
129     }
130 
131     // standard ERC20 symbol function
132     function symbol() public view returns (string) {
133         return symbol_;
134     }
135 
136     // standard ERC20 decimals function
137     function decimals() public view returns (uint8) {
138         return decimals_;
139     }
140 
141     // standard ERC20 totalSupply function
142     function totalSupply() public view returns (uint256) {
143         return totalSupply_;
144     }
145 
146     // standard ERC20 allowance function
147     function allowance(address _owner, address _spender) external view returns (uint256) {
148         return allowed[_owner][_spender];
149     }
150 
151     // show unlocked balance of an account
152     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
153         _balance = balanceP[_address];
154         uint256 i = 0;
155         while (i < lockNum[_address]) {
156             if (now.add(earlier) >= lockTime[_address][i].add(later)) _balance = _balance.add(lockValue[_address][i]);
157             i++;
158         }
159         return _balance;
160     }
161 
162     // show timelocked balance of an account
163     function balanceLocked(address _address) public view returns (uint256 _balance) {
164         _balance = 0;
165         uint256 i = 0;
166         while (i < lockNum[_address]) {
167             if (now.add(earlier) < lockTime[_address][i].add(later)) _balance = _balance.add(lockValue[_address][i]);
168             i++;
169         }
170         return  _balance;
171     }
172 
173     // standard ERC20 balanceOf with timelock added
174     function balanceOf(address _address) public view returns (uint256 _balance) {
175         _balance = balanceP[_address];
176         uint256 i = 0;
177         while (i < lockNum[_address]) {
178             _balance = _balance.add(lockValue[_address][i]);
179             i++;
180         }
181         return _balance;
182     }
183 
184     // show timelocks in an account
185     function showLockTimes(address _address) public view validAddress(_address) returns (uint256[] _times) {
186         uint i = 0;
187         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
188         while (i < lockNum[_address]) {
189             tempLockTime[i] = lockTime[_address][i].add(later).sub(earlier);
190             i++;
191         }
192         return tempLockTime;
193     }
194 
195     // show values locked in an account's timelocks
196     function showLockValues(address _address) public view validAddress(_address) returns (uint256[] _values) {
197         return lockValue[_address];
198     }
199 
200     function showLockNum(address _address) public view validAddress(_address) returns (uint256 _lockNum) {
201         return lockNum[_address];
202     }
203 
204     // Calculate and process the timelock states of an account
205     function calcUnlock(address _address) private {
206         uint256 i = 0;
207         uint256 j = 0;
208         uint256[] memory currentLockTime;
209         uint256[] memory currentLockValue;
210         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
211         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
212         currentLockTime = lockTime[_address];
213         currentLockValue = lockValue[_address];
214         while (i < lockNum[_address]) {
215             if (now.add(earlier) >= currentLockTime[i].add(later)) {
216                 balanceP[_address] = balanceP[_address].add(currentLockValue[i]);
217                 emit TokenUnlocked(_address, currentLockValue[i]);
218             } else {
219                 newLockTime[j] = currentLockTime[i];
220                 newLockValue[j] = currentLockValue[i];
221                 j++;
222             }
223             i++;
224         }
225         uint256[] memory trimLockTime = new uint256[](j);
226         uint256[] memory trimLockValue = new uint256[](j);
227         i = 0;
228         while (i < j) {
229             trimLockTime[i] = newLockTime[i];
230             trimLockValue[i] = newLockValue[i];
231             i++;
232         }
233         lockTime[_address] = trimLockTime;
234         lockValue[_address] = trimLockValue;
235         lockNum[_address] = j;
236     }
237 
238     // standard ERC20 transfer
239     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool _success) {
240         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
241         require(balanceP[msg.sender] >= _value && _value >= 0);
242         balanceP[msg.sender] = balanceP[msg.sender].sub(_value);
243         balanceP[_to] = balanceP[_to].add(_value);
244         emit Transfer(msg.sender, _to, _value);
245         return true;
246     }
247 
248     // transfer Token with timelocks
249     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool _success) {
250         require(_value.length == _time.length);
251 
252         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
253         uint256 i = 0;
254         uint256 totalValue = 0;
255         while (i < _value.length) {
256             totalValue = totalValue.add(_value[i]);
257             i++;
258         }
259         require(balanceP[msg.sender] >= totalValue && totalValue >= 0);
260         require(lockNum[_to].add(_time.length) <= 42);
261         i = 0;
262         while (i < _time.length) {
263             if (_value[i] > 0) {
264                 balanceP[msg.sender] = balanceP[msg.sender].sub(_value[i]);
265                 lockTime[_to].length = lockNum[_to]+1;
266                 lockValue[_to].length = lockNum[_to]+1;
267                 lockTime[_to][lockNum[_to]] = now.add(_time[i]).add(earlier).sub(later);
268                 lockValue[_to][lockNum[_to]] = _value[i];
269                 lockNum[_to]++;
270             }
271 
272             // emit custom TransferLocked event
273             emit TransferLocked(msg.sender, _to, _time[i], _value[i]);
274 
275             // emit standard Transfer event for wallets
276             emit Transfer(msg.sender, _to, _value[i]);
277 
278             i++;
279         }
280         return true;
281     }
282 
283     // TransferFrom Token with timelocks
284     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public
285 	    validAddress(_from) validAddress(_to) returns (bool success) {
286         require(_value.length == _time.length);
287 
288         if (lockNum[_from] > 0) calcUnlock(_from);
289         uint256 i = 0;
290         uint256 totalValue = 0;
291         while (i < _value.length) {
292             totalValue = totalValue.add(_value[i]);
293             i++;
294         }
295         require(balanceP[_from] >= totalValue && totalValue >= 0 && allowed[_from][msg.sender] >= totalValue);
296         require(lockNum[_to].add(_time.length) <= 42);
297         i = 0;
298         while (i < _time.length) {
299             if (_value[i] > 0) {
300                 balanceP[_from] = balanceP[_from].sub(_value[i]);
301                 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value[i]);
302                 lockTime[_to].length = lockNum[_to]+1;
303                 lockValue[_to].length = lockNum[_to]+1;
304                 lockTime[_to][lockNum[_to]] = now.add(_time[i]).add(earlier).sub(later);
305                 lockValue[_to][lockNum[_to]] = _value[i];
306                 lockNum[_to]++;
307             }
308 
309             // emit custom TransferLocked event
310             emit TransferLocked(_from, _to, _time[i], _value[i]);
311 
312             // emit standard Transfer event for wallets
313             emit Transfer(_from, _to, _value[i]);
314 
315             i++;
316         }
317         return true;
318     }
319 
320     // standard ERC20 transferFrom
321     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool _success) {
322         if (lockNum[_from] > 0) calcUnlock(_from);
323         require(balanceP[_from] >= _value && _value >= 0 && allowed[_from][msg.sender] >= _value);
324         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
325         balanceP[_from] = balanceP[_from].sub(_value);
326         balanceP[_to] = balanceP[_to].add(_value);
327         emit Transfer(_from, _to, _value);
328         return true;
329     }
330 
331     // should only be called when first setting an allowed
332     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool _success) {
333         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
334         allowed[msg.sender][_spender] = _value;
335         emit Approval(msg.sender, _spender, _value);
336         return true;
337     }
338 
339     // increase or decrease allowed
340     function increaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
341         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
342         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343         return true;
344     }
345 
346     function decreaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
347         if(_value >= allowed[msg.sender][_spender]) {
348             allowed[msg.sender][_spender] = 0;
349         } else {
350             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_value);
351         }
352         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353         return true;
354     }
355 
356     // owner may burn own token
357     function burn(uint256 _value) public onlyOwner returns (bool _success) {
358         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
359         require(balanceP[msg.sender] >= _value && _value >= 0);
360         balanceP[msg.sender] = balanceP[msg.sender].sub(_value);
361         totalSupply_ = totalSupply_.sub(_value);
362         emit Burn(msg.sender, _value);
363         return true;
364     }
365 
366     // owner may mint new token and increase total supply
367     function mint(uint256 _value) public onlyOwner isMintable returns (bool _success) {
368         balanceP[msg.sender] = balanceP[msg.sender].add(_value);
369         totalSupply_ = totalSupply_.add(_value);
370         emit Mint(msg.sender, _value);
371         return true;
372     }
373 
374     // safety methods
375     function () public payable {
376         revert();
377     }
378 
379     function emptyWrongToken(address _addr) onlyOwner public {
380         ERC20Token wrongToken = ERC20Token(_addr);
381         uint256 amount = wrongToken.balanceOf(address(this));
382         require(amount > 0);
383         require(wrongToken.transfer(msg.sender, amount));
384 
385         emit WrongTokenEmptied(_addr, msg.sender, amount);
386     }
387 
388     // shouldn't happen, just in case
389     function emptyWrongEther() onlyOwner public {
390         uint256 amount = address(this).balance;
391         require(amount > 0);
392         msg.sender.transfer(amount);
393 
394         emit WrongEtherEmptied(msg.sender, amount);
395     }
396 
397 }