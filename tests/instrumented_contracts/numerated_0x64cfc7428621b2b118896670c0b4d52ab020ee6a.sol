1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 *
6 *     _  _   _ ___ ___    _____    _
7 *    /_\| | | / __|   \  |_   _|__| |_____ _ _
8 *   / _ \ |_| \__ \ |) |   | |/ _ \ / / -_) ' \
9 *  /_/ \_\___/|___/___/    |_|\___/_\_\___|_||_|
10 *
11 *
12 *
13 */
14 
15 // SafeMath methods
16 library SafeMath {
17     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
18         uint256 c = _a + _b;
19         assert(c >= _a);
20         return c;
21     }
22 
23     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
24         assert(_a >= _b);
25         return _a - _b;
26     }
27 
28     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
29         uint256 c = _a * _b;
30         assert(_a == 0 || c / _a == _b);
31         return c;
32     }
33 }
34 
35 // Contract must have an owner
36 contract Owned {
37     address public owner;
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function setOwner(address _owner) onlyOwner public {
49         owner = _owner;
50     }
51 }
52 
53 // Standard ERC20 Token Interface
54 interface ERC20Token {
55     function name() external view returns (string name_);
56     function symbol() external view returns (string symbol_);
57     function decimals() external view returns (uint8 decimals_);
58     function totalSupply() external view returns (uint256 totalSupply_);
59     function balanceOf(address _owner) external view returns (uint256 _balance);
60     function transfer(address _to, uint256 _value) external returns (bool _success);
61     function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
62     function approve(address _spender, uint256 _value) external returns (bool _success);
63     function allowance(address _owner, address _spender) external view returns (uint256 _remaining);
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 }
68 
69 // the main ERC20-compliant multi-timelock enabled contract
70 contract AUSD is Owned, ERC20Token {
71     using SafeMath for uint256;
72 
73     string private constant standard = "201811113309";
74     string private constant version = "6.0663600";
75     string private name_ = "AUSD";
76     string private symbol_ = "AUSD";
77     uint8 private decimals_ = 18;
78     uint256 private totalSupply_ = uint256(20) * uint256(10)**uint256(8) * uint256(10)**uint256(decimals_);
79     mapping (address => uint256) private balanceP;
80     mapping (address => mapping (address => uint256)) private allowed;
81 
82     mapping (address => uint256[]) private lockTime;
83     mapping (address => uint256[]) private lockValue;
84     mapping (address => uint256) private lockNum;
85     uint256 private later = 0;
86     uint256 private earlier = 0;
87     bool private mintable_ = true;
88 
89     // burn token event
90     event Burn(address indexed _from, uint256 _value);
91 
92     // mint token event
93     event Mint(address indexed _to, uint256 _value);
94 
95     // timelock-related events
96     event TransferLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
97     event TokenUnlocked(address indexed _address, uint256 _value);
98 
99     // safety method-related events
100     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
101     event WrongEtherEmptied(address indexed _addr, uint256 _amount);
102 
103     // constructor for the ERC20 Token
104     constructor() public {
105         balanceP[msg.sender] = totalSupply_;
106     }
107 
108     modifier validAddress(address _address) {
109         require(_address != 0x0);
110         _;
111     }
112 
113     modifier isMintable() {
114         require(mintable_);
115         _;
116     }
117 
118     // fast-forward the timelocks for all accounts
119     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
120         earlier = earlier.add(_earlier);
121     }
122 
123     // delay the timelocks for all accounts
124     function setUnlockLater(uint256 _later) public onlyOwner {
125         later = later.add(_later);
126     }
127 
128     // owner may permanently disable minting
129     function disableMint() public onlyOwner isMintable {
130         mintable_ = false;
131     }
132 
133     // show if the token is still mintable
134     function mintable() public view returns (bool) {
135         return mintable_;
136     }
137 
138     // standard ERC20 name function
139     function name() public view returns (string) {
140         return name_;
141     }
142 
143     // standard ERC20 symbol function
144     function symbol() public view returns (string) {
145         return symbol_;
146     }
147 
148     // standard ERC20 decimals function
149     function decimals() public view returns (uint8) {
150         return decimals_;
151     }
152 
153     // standard ERC20 totalSupply function
154     function totalSupply() public view returns (uint256) {
155         return totalSupply_;
156     }
157 
158     // standard ERC20 allowance function
159     function allowance(address _owner, address _spender) external view returns (uint256) {
160         return allowed[_owner][_spender];
161     }
162 
163     // show unlocked balance of an account
164     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
165         _balance = balanceP[_address];
166         uint256 i = 0;
167         while (i < lockNum[_address]) {
168             if (now.add(earlier) >= lockTime[_address][i].add(later)) _balance = _balance.add(lockValue[_address][i]);
169             i++;
170         }
171         return _balance;
172     }
173 
174     // show timelocked balance of an account
175     function balanceLocked(address _address) public view returns (uint256 _balance) {
176         _balance = 0;
177         uint256 i = 0;
178         while (i < lockNum[_address]) {
179             if (now.add(earlier) < lockTime[_address][i].add(later)) _balance = _balance.add(lockValue[_address][i]);
180             i++;
181         }
182         return  _balance;
183     }
184 
185     // standard ERC20 balanceOf with timelock added
186     function balanceOf(address _address) public view returns (uint256 _balance) {
187         _balance = balanceP[_address];
188         uint256 i = 0;
189         while (i < lockNum[_address]) {
190             _balance = _balance.add(lockValue[_address][i]);
191             i++;
192         }
193         return _balance;
194     }
195 
196     // show timelocks in an account
197     function showLockTimes(address _address) public view validAddress(_address) returns (uint256[] _times) {
198         uint i = 0;
199         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
200         while (i < lockNum[_address]) {
201             tempLockTime[i] = lockTime[_address][i].add(later).sub(earlier);
202             i++;
203         }
204         return tempLockTime;
205     }
206 
207     // show values locked in an account's timelocks
208     function showLockValues(address _address) public view validAddress(_address) returns (uint256[] _values) {
209         return lockValue[_address];
210     }
211 
212     function showLockNum(address _address) public view validAddress(_address) returns (uint256 _lockNum) {
213         return lockNum[_address];
214     }
215 
216     // Calculate and process the timelock states of an account
217     function calcUnlock(address _address) private {
218         uint256 i = 0;
219         uint256 j = 0;
220         uint256[] memory currentLockTime;
221         uint256[] memory currentLockValue;
222         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
223         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
224         currentLockTime = lockTime[_address];
225         currentLockValue = lockValue[_address];
226         while (i < lockNum[_address]) {
227             if (now.add(earlier) >= currentLockTime[i].add(later)) {
228                 balanceP[_address] = balanceP[_address].add(currentLockValue[i]);
229                 emit TokenUnlocked(_address, currentLockValue[i]);
230             } else {
231                 newLockTime[j] = currentLockTime[i];
232                 newLockValue[j] = currentLockValue[i];
233                 j++;
234             }
235             i++;
236         }
237         uint256[] memory trimLockTime = new uint256[](j);
238         uint256[] memory trimLockValue = new uint256[](j);
239         i = 0;
240         while (i < j) {
241             trimLockTime[i] = newLockTime[i];
242             trimLockValue[i] = newLockValue[i];
243             i++;
244         }
245         lockTime[_address] = trimLockTime;
246         lockValue[_address] = trimLockValue;
247         lockNum[_address] = j;
248     }
249 
250     // standard ERC20 transfer
251     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool _success) {
252         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
253         require(balanceP[msg.sender] >= _value && _value >= 0);
254         balanceP[msg.sender] = balanceP[msg.sender].sub(_value);
255         balanceP[_to] = balanceP[_to].add(_value);
256         emit Transfer(msg.sender, _to, _value);
257         return true;
258     }
259 
260     // transfer Token with timelocks
261     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool _success) {
262         require(_value.length == _time.length);
263 
264         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
265         uint256 i = 0;
266         uint256 totalValue = 0;
267         while (i < _value.length) {
268             totalValue = totalValue.add(_value[i]);
269             i++;
270         }
271         require(balanceP[msg.sender] >= totalValue && totalValue >= 0);
272         require(lockNum[_to].add(_time.length) <= 42);
273         i = 0;
274         while (i < _time.length) {
275             if (_value[i] > 0) {
276                 balanceP[msg.sender] = balanceP[msg.sender].sub(_value[i]);
277                 lockTime[_to].length = lockNum[_to]+1;
278                 lockValue[_to].length = lockNum[_to]+1;
279                 lockTime[_to][lockNum[_to]] = now.add(_time[i]).add(earlier).sub(later);
280                 lockValue[_to][lockNum[_to]] = _value[i];
281                 lockNum[_to]++;
282             }
283 
284             // emit custom TransferLocked event
285             emit TransferLocked(msg.sender, _to, _time[i], _value[i]);
286 
287             // emit standard Transfer event for wallets
288             emit Transfer(msg.sender, _to, _value[i]);
289 
290             i++;
291         }
292         return true;
293     }
294 
295     // TransferFrom Token with timelocks
296     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public
297 	    validAddress(_from) validAddress(_to) returns (bool success) {
298         require(_value.length == _time.length);
299 
300         if (lockNum[_from] > 0) calcUnlock(_from);
301         uint256 i = 0;
302         uint256 totalValue = 0;
303         while (i < _value.length) {
304             totalValue = totalValue.add(_value[i]);
305             i++;
306         }
307         require(balanceP[_from] >= totalValue && totalValue >= 0 && allowed[_from][msg.sender] >= totalValue);
308         require(lockNum[_to].add(_time.length) <= 42);
309         i = 0;
310         while (i < _time.length) {
311             if (_value[i] > 0) {
312                 balanceP[_from] = balanceP[_from].sub(_value[i]);
313                 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value[i]);
314                 lockTime[_to].length = lockNum[_to]+1;
315                 lockValue[_to].length = lockNum[_to]+1;
316                 lockTime[_to][lockNum[_to]] = now.add(_time[i]).add(earlier).sub(later);
317                 lockValue[_to][lockNum[_to]] = _value[i];
318                 lockNum[_to]++;
319             }
320 
321             // emit custom TransferLocked event
322             emit TransferLocked(_from, _to, _time[i], _value[i]);
323 
324             // emit standard Transfer event for wallets
325             emit Transfer(_from, _to, _value[i]);
326 
327             i++;
328         }
329         return true;
330     }
331 
332     // standard ERC20 transferFrom
333     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool _success) {
334         if (lockNum[_from] > 0) calcUnlock(_from);
335         require(balanceP[_from] >= _value && _value >= 0 && allowed[_from][msg.sender] >= _value);
336         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
337         balanceP[_from] = balanceP[_from].sub(_value);
338         balanceP[_to] = balanceP[_to].add(_value);
339         emit Transfer(_from, _to, _value);
340         return true;
341     }
342 
343     // should only be called when first setting an allowed
344     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool _success) {
345         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
346         allowed[msg.sender][_spender] = _value;
347         emit Approval(msg.sender, _spender, _value);
348         return true;
349     }
350 
351     // increase or decrease allowed
352     function increaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
353         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
354         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
355         return true;
356     }
357 
358     function decreaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
359         if(_value >= allowed[msg.sender][_spender]) {
360             allowed[msg.sender][_spender] = 0;
361         } else {
362             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_value);
363         }
364         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365         return true;
366     }
367 
368     // owner may burn own token
369     function burn(uint256 _value) public onlyOwner returns (bool _success) {
370         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
371         require(balanceP[msg.sender] >= _value && _value >= 0);
372         balanceP[msg.sender] = balanceP[msg.sender].sub(_value);
373         totalSupply_ = totalSupply_.sub(_value);
374         emit Burn(msg.sender, _value);
375         return true;
376     }
377 
378     // owner may mint new token and increase total supply
379     function mint(uint256 _value) public onlyOwner isMintable returns (bool _success) {
380         balanceP[msg.sender] = balanceP[msg.sender].add(_value);
381         totalSupply_ = totalSupply_.add(_value);
382         emit Mint(msg.sender, _value);
383         return true;
384     }
385 
386     // safety methods
387     function () public payable {
388         revert();
389     }
390 
391     function emptyWrongToken(address _addr) onlyOwner public {
392         ERC20Token wrongToken = ERC20Token(_addr);
393         uint256 amount = wrongToken.balanceOf(address(this));
394         require(amount > 0);
395         require(wrongToken.transfer(msg.sender, amount));
396 
397         emit WrongTokenEmptied(_addr, msg.sender, amount);
398     }
399 
400     // shouldn't happen, just in case
401     function emptyWrongEther() onlyOwner public {
402         uint256 amount = address(this).balance;
403         require(amount > 0);
404         msg.sender.transfer(amount);
405 
406         emit WrongEtherEmptied(msg.sender, amount);
407     }
408 
409 }