1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 *   ___  ___  _  ____   __  _____ ___  _  _____ _  _ 
6 *  / __|/ _ \| |/ /\ \ / / |_   _/ _ \| |/ / __| \| |
7 *  \__ \ (_) | ' <  \ V /    | || (_) | ' <| _|| .` |
8 *  |___/\___/|_|\_\  |_|     |_| \___/|_|\_\___|_|\_|
9 *
10 *                                                   
11 */
12 
13 // SafeMath methods
14 library SafeMath {
15     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
16         uint256 c = _a + _b;
17         assert(c >= _a);
18         return c;
19     }
20 
21     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
22         assert(_a >= _b);
23         return _a - _b;
24     }
25 
26     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
27         uint256 c = _a * _b;
28         assert(_a == 0 || c / _a == _b);
29         return c;
30     }
31 }
32 
33 // Contract must have an owner
34 contract Owned {
35     address public owner;
36 
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function setOwner(address _owner) onlyOwner public {
47         owner = _owner;
48     }
49 }
50 
51 // Standard ERC20 Token Interface
52 interface ERC20Token {
53     function name() external view returns (string name_);
54     function symbol() external view returns (string symbol_);
55     function decimals() external view returns (uint8 decimals_);
56     function totalSupply() external view returns (uint256 totalSupply_);
57     function balanceOf(address _owner) external view returns (uint256 _balance);
58     function transfer(address _to, uint256 _value) external returns (bool _success);
59     function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
60     function approve(address _spender, uint256 _value) external returns (bool _success);
61     function allowance(address _owner, address _spender) external view returns (uint256 _remaining);
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 }
66 
67 // the main ERC20-compliant multi-timelock enabled contract
68 contract SOKY is Owned, ERC20Token {
69     using SafeMath for uint256;
70 
71     string private constant standard = "20181130150xd";
72     string private constant version = "1.01afam";
73     string private name_ = "SOKY";
74     string private symbol_ = "SOKY";
75     uint8 private decimals_ = 18;
76     uint256 private totalSupply_ = uint256(50) * uint256(10)**uint256(8) * uint256(10)**uint256(decimals_);
77     mapping (address => uint256) private balanceP;
78     mapping (address => mapping (address => uint256)) private allowed;
79 
80     mapping (address => uint256[]) private lockTime;
81     mapping (address => uint256[]) private lockValue;
82     mapping (address => uint256) private lockNum;
83     uint256 private later = 0;
84     uint256 private earlier = 0;
85     bool private mintable_ = false;
86 
87     // burn token event
88     event Burn(address indexed _from, uint256 _value);
89 
90     // mint token event
91     event Mint(address indexed _to, uint256 _value);
92 
93     // timelock-related events
94     event TransferLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
95     event TokenUnlocked(address indexed _address, uint256 _value);
96 
97     // safety method-related events
98     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
99     event WrongEtherEmptied(address indexed _addr, uint256 _amount);
100 
101     // constructor for the ERC20 Token
102     constructor() public {
103         balanceP[msg.sender] = totalSupply_;
104     }
105 
106     modifier validAddress(address _address) {
107         require(_address != 0x0);
108         _;
109     }
110 
111     modifier isMintable() {
112         require(mintable_);
113         _;
114     }
115 
116     // fast-forward the timelocks for all accounts
117     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
118         earlier = earlier.add(_earlier);
119     }
120 
121     // delay the timelocks for all accounts
122     function setUnlockLater(uint256 _later) public onlyOwner {
123         later = later.add(_later);
124     }
125 
126     // owner may permanently disable minting
127     function disableMint() public onlyOwner isMintable {
128         mintable_ = false;
129     }
130 
131     // show if the token is still mintable
132     function mintable() public view returns (bool) {
133         return mintable_;
134     }
135 
136     // standard ERC20 name function
137     function name() public view returns (string) {
138         return name_;
139     }
140 
141     // standard ERC20 symbol function
142     function symbol() public view returns (string) {
143         return symbol_;
144     }
145 
146     // standard ERC20 decimals function
147     function decimals() public view returns (uint8) {
148         return decimals_;
149     }
150 
151     // standard ERC20 totalSupply function
152     function totalSupply() public view returns (uint256) {
153         return totalSupply_;
154     }
155 
156     // standard ERC20 allowance function
157     function allowance(address _owner, address _spender) external view returns (uint256) {
158         return allowed[_owner][_spender];
159     }
160 
161     // show unlocked balance of an account
162     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
163         _balance = balanceP[_address];
164         uint256 i = 0;
165         while (i < lockNum[_address]) {
166             if (now.add(earlier) >= lockTime[_address][i].add(later)) _balance = _balance.add(lockValue[_address][i]);
167             i++;
168         }
169         return _balance;
170     }
171 
172     // show timelocked balance of an account
173     function balanceLocked(address _address) public view returns (uint256 _balance) {
174         _balance = 0;
175         uint256 i = 0;
176         while (i < lockNum[_address]) {
177             if (now.add(earlier) < lockTime[_address][i].add(later)) _balance = _balance.add(lockValue[_address][i]);
178             i++;
179         }
180         return  _balance;
181     }
182 
183     // standard ERC20 balanceOf with timelock added
184     function balanceOf(address _address) public view returns (uint256 _balance) {
185         _balance = balanceP[_address];
186         uint256 i = 0;
187         while (i < lockNum[_address]) {
188             _balance = _balance.add(lockValue[_address][i]);
189             i++;
190         }
191         return _balance;
192     }
193 
194     // show timelocks in an account
195     function showLockTimes(address _address) public view validAddress(_address) returns (uint256[] _times) {
196         uint i = 0;
197         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
198         while (i < lockNum[_address]) {
199             tempLockTime[i] = lockTime[_address][i].add(later).sub(earlier);
200             i++;
201         }
202         return tempLockTime;
203     }
204 
205     // show values locked in an account's timelocks
206     function showLockValues(address _address) public view validAddress(_address) returns (uint256[] _values) {
207         return lockValue[_address];
208     }
209 
210     function showLockNum(address _address) public view validAddress(_address) returns (uint256 _lockNum) {
211         return lockNum[_address];
212     }
213 
214     // Calculate and process the timelock states of an account
215     function calcUnlock(address _address) private {
216         uint256 i = 0;
217         uint256 j = 0;
218         uint256[] memory currentLockTime;
219         uint256[] memory currentLockValue;
220         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
221         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
222         currentLockTime = lockTime[_address];
223         currentLockValue = lockValue[_address];
224         while (i < lockNum[_address]) {
225             if (now.add(earlier) >= currentLockTime[i].add(later)) {
226                 balanceP[_address] = balanceP[_address].add(currentLockValue[i]);
227                 emit TokenUnlocked(_address, currentLockValue[i]);
228             } else {
229                 newLockTime[j] = currentLockTime[i];
230                 newLockValue[j] = currentLockValue[i];
231                 j++;
232             }
233             i++;
234         }
235         uint256[] memory trimLockTime = new uint256[](j);
236         uint256[] memory trimLockValue = new uint256[](j);
237         i = 0;
238         while (i < j) {
239             trimLockTime[i] = newLockTime[i];
240             trimLockValue[i] = newLockValue[i];
241             i++;
242         }
243         lockTime[_address] = trimLockTime;
244         lockValue[_address] = trimLockValue;
245         lockNum[_address] = j;
246     }
247 
248     // standard ERC20 transfer
249     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool _success) {
250         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
251         require(balanceP[msg.sender] >= _value && _value >= 0);
252         balanceP[msg.sender] = balanceP[msg.sender].sub(_value);
253         balanceP[_to] = balanceP[_to].add(_value);
254         emit Transfer(msg.sender, _to, _value);
255         return true;
256     }
257 
258     // transfer Token with timelocks
259     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool _success) {
260         require(_value.length == _time.length);
261 
262         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
263         uint256 i = 0;
264         uint256 totalValue = 0;
265         while (i < _value.length) {
266             totalValue = totalValue.add(_value[i]);
267             i++;
268         }
269         require(balanceP[msg.sender] >= totalValue && totalValue >= 0);
270         require(lockNum[_to].add(_time.length) <= 42);
271         i = 0;
272         while (i < _time.length) {
273             if (_value[i] > 0) {
274                 balanceP[msg.sender] = balanceP[msg.sender].sub(_value[i]);
275                 lockTime[_to].length = lockNum[_to]+1;
276                 lockValue[_to].length = lockNum[_to]+1;
277                 lockTime[_to][lockNum[_to]] = now.add(_time[i]).add(earlier).sub(later);
278                 lockValue[_to][lockNum[_to]] = _value[i];
279                 lockNum[_to]++;
280             }
281 
282             // emit custom TransferLocked event
283             emit TransferLocked(msg.sender, _to, _time[i], _value[i]);
284 
285             // emit standard Transfer event for wallets
286             emit Transfer(msg.sender, _to, _value[i]);
287 
288             i++;
289         }
290         return true;
291     }
292 
293     // TransferFrom Token with timelocks
294     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public
295 	    validAddress(_from) validAddress(_to) returns (bool success) {
296         require(_value.length == _time.length);
297 
298         if (lockNum[_from] > 0) calcUnlock(_from);
299         uint256 i = 0;
300         uint256 totalValue = 0;
301         while (i < _value.length) {
302             totalValue = totalValue.add(_value[i]);
303             i++;
304         }
305         require(balanceP[_from] >= totalValue && totalValue >= 0 && allowed[_from][msg.sender] >= totalValue);
306         require(lockNum[_to].add(_time.length) <= 42);
307         i = 0;
308         while (i < _time.length) {
309             if (_value[i] > 0) {
310                 balanceP[_from] = balanceP[_from].sub(_value[i]);
311                 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value[i]);
312                 lockTime[_to].length = lockNum[_to]+1;
313                 lockValue[_to].length = lockNum[_to]+1;
314                 lockTime[_to][lockNum[_to]] = now.add(_time[i]).add(earlier).sub(later);
315                 lockValue[_to][lockNum[_to]] = _value[i];
316                 lockNum[_to]++;
317             }
318 
319             // emit custom TransferLocked event
320             emit TransferLocked(_from, _to, _time[i], _value[i]);
321 
322             // emit standard Transfer event for wallets
323             emit Transfer(_from, _to, _value[i]);
324 
325             i++;
326         }
327         return true;
328     }
329 
330     // standard ERC20 transferFrom
331     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool _success) {
332         if (lockNum[_from] > 0) calcUnlock(_from);
333         require(balanceP[_from] >= _value && _value >= 0 && allowed[_from][msg.sender] >= _value);
334         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
335         balanceP[_from] = balanceP[_from].sub(_value);
336         balanceP[_to] = balanceP[_to].add(_value);
337         emit Transfer(_from, _to, _value);
338         return true;
339     }
340 
341     // should only be called when first setting an allowed
342     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool _success) {
343         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
344         allowed[msg.sender][_spender] = _value;
345         emit Approval(msg.sender, _spender, _value);
346         return true;
347     }
348 
349     // increase or decrease allowed
350     function increaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
351         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
352         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353         return true;
354     }
355 
356     function decreaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
357         if(_value >= allowed[msg.sender][_spender]) {
358             allowed[msg.sender][_spender] = 0;
359         } else {
360             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_value);
361         }
362         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
363         return true;
364     }
365 
366     // owner may burn own token
367     function burn(uint256 _value) public onlyOwner returns (bool _success) {
368         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
369         require(balanceP[msg.sender] >= _value && _value >= 0);
370         balanceP[msg.sender] = balanceP[msg.sender].sub(_value);
371         totalSupply_ = totalSupply_.sub(_value);
372         emit Burn(msg.sender, _value);
373         return true;
374     }
375 
376     // owner may mint new token and increase total supply
377     function mint(uint256 _value) public onlyOwner isMintable returns (bool _success) {
378         balanceP[msg.sender] = balanceP[msg.sender].add(_value);
379         totalSupply_ = totalSupply_.add(_value);
380         emit Mint(msg.sender, _value);
381         return true;
382     }
383 
384     // safety methods
385     function () public payable {
386         revert();
387     }
388 
389     function emptyWrongToken(address _addr) onlyOwner public {
390         ERC20Token wrongToken = ERC20Token(_addr);
391         uint256 amount = wrongToken.balanceOf(address(this));
392         require(amount > 0);
393         require(wrongToken.transfer(msg.sender, amount));
394 
395         emit WrongTokenEmptied(_addr, msg.sender, amount);
396     }
397 
398     // shouldn't happen, just in case
399     function emptyWrongEther() onlyOwner public {
400         uint256 amount = address(this).balance;
401         require(amount > 0);
402         msg.sender.transfer(amount);
403 
404         emit WrongEtherEmptied(msg.sender, amount);
405     }
406 
407 }