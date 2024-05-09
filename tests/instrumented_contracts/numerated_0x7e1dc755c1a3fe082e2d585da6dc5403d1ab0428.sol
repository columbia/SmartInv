1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 *
6 *    __   ____  _________
7 *   / /  / __ \/ ___/ __ \
8 *  / /__/ /_/ / (_ / /_/ /
9 * /____/\____/\___/\____/
10 *
11 *
12 */
13 
14 // Contract must have an owner
15 contract Owned {
16     address public owner;
17 
18     constructor() public {
19         owner = msg.sender;
20     }
21 
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     function setOwner(address _owner) onlyOwner public {
28         owner = _owner;
29     }
30 }
31 
32 // SafeMath methods
33 contract SafeMath {
34     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
35         uint256 c = _a + _b;
36         assert(c >= _a);
37         return c;
38     }
39 
40     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41         assert(_a >= _b);
42         return _a - _b;
43     }
44 
45     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
46         uint256 c = _a * _b;
47         assert(_a == 0 || c / _a == _b);
48         return c;
49     }
50 }
51 
52 // Standard ERC20 Token Interface
53 interface ERC20Token {
54     function name() external view returns (string _name);
55     function symbol() external view returns (string _symbol);
56     function decimals() external view returns (uint8 _decimals);
57     function totalSupply() external view returns (uint256 _totalSupply);
58     function balanceOf(address _owner) external view returns (uint256 _balance);
59     function transfer(address _to, uint256 _value) external returns (bool _success);
60     function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
61     function approve(address _spender, uint256 _value) external returns (bool _success);
62     function allowance(address _owner, address _spender) external view returns (uint256 _remaining);
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 }
67 
68 // the main ERC20-compliant multi-timelock enabled contract
69 contract TokenMultiTimeLock is SafeMath, Owned, ERC20Token {
70     string private constant standard = "545028";
71     string private constant version = "alpha";
72     string private _name = "NTEST";
73     string private _symbol = "NTST";
74     uint8 private _decimals = 18;
75     uint256 private _totalSupply = 2 * 10**9 * uint256(10)**_decimals;
76     mapping (address => uint256) private balanceP;
77     mapping (address => mapping (address => uint256)) private _allowance;
78 
79     mapping (address => uint256[]) private lockTime;
80     mapping (address => uint256[]) private lockValue;
81     mapping (address => uint256) private lockNum;
82     uint256 private later = 0;
83     uint256 private earlier = 0;
84 
85     // burn token event
86     event Burn(address indexed _from, uint256 _value);
87 
88     // timelock-related events
89     event TransferLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
90     event TokenUnlocked(address indexed _address, uint256 _value);
91 
92     // safety method-related events
93     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
94     event WrongEtherEmptied(address indexed _addr, uint256 _amount);
95 
96     // constructor for the ERC20 Token
97     constructor() public {
98         balanceP[msg.sender] = _totalSupply;
99     }
100 
101     modifier validAddress(address _address) {
102         require(_address != 0x0);
103         _;
104     }
105 
106     // fast-forward the timelocks for all accounts
107     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
108         earlier = add(earlier, _earlier);
109     }
110 
111     // delay the timelocks for all accounts
112     function setUnlockLater(uint256 _later) public onlyOwner {
113         later = add(later, _later);
114     }
115 
116     // standard ERC20 name function
117     function name() public view returns (string) {
118         return _name;
119     }
120 
121     // standard ERC20 symbol function
122     function symbol() public view returns (string) {
123         return _symbol;
124     }
125 
126     // standard ERC20 decimals function
127     function decimals() public view returns (uint8) {
128         return _decimals;
129     }
130 
131     // standard ERC20 totalSupply function
132     function totalSupply() public view returns (uint256) {
133         return _totalSupply;
134     }
135 
136     // standard ERC20 allowance function
137     function allowance(address _owner, address _spender) external view returns (uint256) {
138         return _allowance[_owner][_spender];
139     }
140 
141     // show unlocked balance of an account
142     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
143         _balance = balanceP[_address];
144         uint256 i = 0;
145         while (i < lockNum[_address]) {
146             if (add(now, earlier) >= add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
147             i++;
148         }
149         return _balance;
150     }
151 
152     // show timelocked balance of an account
153     function balanceLocked(address _address) public view returns (uint256 _balance) {
154         _balance = 0;
155         uint256 i = 0;
156         while (i < lockNum[_address]) {
157             if (add(now, earlier) < add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
158             i++;
159         }
160         return  _balance;
161     }
162 
163     // standard ERC20 balanceOf with timelock added
164     function balanceOf(address _address) public view returns (uint256 _balance) {
165         _balance = balanceP[_address];
166         uint256 i = 0;
167         while (i < lockNum[_address]) {
168             _balance = add(_balance, lockValue[_address][i]);
169             i++;
170         }
171         return _balance;
172     }
173 
174     // show timelocks in an account
175     function showLockTimes(address _address) public view validAddress(_address) returns (uint256[] _times) {
176         uint i = 0;
177         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
178         while (i < lockNum[_address]) {
179             tempLockTime[i] = sub(add(lockTime[_address][i], later), earlier);
180             i++;
181         }
182         return tempLockTime;
183     }
184 
185     // show values locked in an account's timelocks
186     function showLockValues(address _address) public view validAddress(_address) returns (uint256[] _values) {
187         return lockValue[_address];
188     }
189 
190     function showLockNum(address _address) public view validAddress(_address) returns (uint256 _lockNum) {
191         return lockNum[_address];
192     }
193 
194     // Calculate and process the timelock states of an account
195     function calcUnlock(address _address) private {
196         uint256 i = 0;
197         uint256 j = 0;
198         uint256[] memory currentLockTime;
199         uint256[] memory currentLockValue;
200         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
201         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
202         currentLockTime = lockTime[_address];
203         currentLockValue = lockValue[_address];
204         while (i < lockNum[_address]) {
205             if (add(now, earlier) >= add(currentLockTime[i], later)) {
206                 balanceP[_address] = add(balanceP[_address], currentLockValue[i]);
207                 emit TokenUnlocked(_address, currentLockValue[i]);
208             } else {
209                 newLockTime[j] = currentLockTime[i];
210                 newLockValue[j] = currentLockValue[i];
211                 j++;
212             }
213             i++;
214         }
215         uint256[] memory trimLockTime = new uint256[](j);
216         uint256[] memory trimLockValue = new uint256[](j);
217         i = 0;
218         while (i < j) {
219             trimLockTime[i] = newLockTime[i];
220             trimLockValue[i] = newLockValue[i];
221             i++;
222         }
223         lockTime[_address] = trimLockTime;
224         lockValue[_address] = trimLockValue;
225         lockNum[_address] = j;
226     }
227 
228     // standard ERC20 transfer
229     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool _success) {
230         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
231         require(balanceP[msg.sender] >= _value && _value >= 0);
232         balanceP[msg.sender] = sub(balanceP[msg.sender], _value);
233         balanceP[_to] = add(balanceP[_to], _value);
234         emit Transfer(msg.sender, _to, _value);
235         return true;
236     }
237 
238     // transfer Token with timelocks
239     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool _success) {
240         require(_value.length == _time.length);
241 
242         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
243         uint256 i = 0;
244         uint256 totalValue = 0;
245         while (i < _value.length) {
246             totalValue = add(totalValue, _value[i]);
247             i++;
248         }
249         require(balanceP[msg.sender] >= totalValue && totalValue >= 0);
250         require(add(lockNum[msg.sender], _time.length) <= 42);
251         i = 0;
252         while (i < _time.length) {
253             if (_value[i] > 0) {
254                 balanceP[msg.sender] = sub(balanceP[msg.sender], _value[i]);
255                 lockTime[_to].length = lockNum[_to]+1;
256                 lockValue[_to].length = lockNum[_to]+1;
257                 lockTime[_to][lockNum[_to]] = sub(add(add(now, _time[i]), earlier), later);
258                 lockValue[_to][lockNum[_to]] = _value[i];
259                 lockNum[_to]++;
260             }
261 
262             // emit custom TransferLocked event
263             emit TransferLocked(msg.sender, _to, _time[i], _value[i]);
264 
265             // emit standard Transfer event for wallets
266             emit Transfer(msg.sender, _to, _value[i]);
267 
268             i++;
269         }
270         return true;
271     }
272 
273     // TransferFrom Token with timelocks
274     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public
275 	    validAddress(_from) validAddress(_to) returns (bool success) {
276         require(_value.length == _time.length);
277 
278         if (lockNum[_from] > 0) calcUnlock(_from);
279         uint256 i = 0;
280         uint256 totalValue = 0;
281         while (i < _value.length) {
282             totalValue = add(totalValue, _value[i]);
283             i++;
284         }
285         require(balanceP[_from] >= totalValue && totalValue >= 0 && _allowance[_from][msg.sender] >= totalValue);
286         require(add(lockNum[_from], _time.length) <= 42);
287         i = 0;
288         while (i < _time.length) {
289             if (_value[i] > 0) {
290                 balanceP[_from] = sub(balanceP[_from], _value[i]);
291                 _allowance[_from][msg.sender] = sub(_allowance[_from][msg.sender], _value[i]);
292                 lockTime[_to].length = lockNum[_to]+1;
293                 lockValue[_to].length = lockNum[_to]+1;
294                 lockTime[_to][lockNum[_to]] = sub(add(add(now, _time[i]), earlier), later);
295                 lockValue[_to][lockNum[_to]] = _value[i];
296                 lockNum[_to]++;
297             }
298 
299             // emit custom TransferLocked event
300             emit TransferLocked(_from, _to, _time[i], _value[i]);
301 
302             // emit standard Transfer event for wallets
303             emit Transfer(_from, _to, _value[i]);
304 
305             i++;
306         }
307         return true;
308     }
309 
310     // standard ERC20 transferFrom
311     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool _success) {
312         if (lockNum[_from] > 0) calcUnlock(_from);
313         require(balanceP[_from] >= _value && _value >= 0 && _allowance[_from][msg.sender] >= _value);
314         _allowance[_from][msg.sender] = sub(_allowance[_from][msg.sender], _value);
315         balanceP[_from] = sub(balanceP[_from], _value);
316         balanceP[_to] = add(balanceP[_to], _value);
317         emit Transfer(_from, _to, _value);
318         return true;
319     }
320 
321     // should only be called when first setting an _allowance
322     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool _success) {
323         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
324         _allowance[msg.sender][_spender] = _value;
325         emit Approval(msg.sender, _spender, _value);
326         return true;
327     }
328 
329     // increase or decrease _allowance
330     function increaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
331         _allowance[msg.sender][_spender] = add(_allowance[msg.sender][_spender], _value);
332         emit Approval(msg.sender, _spender, _allowance[msg.sender][_spender]);
333         return true;
334     }
335 
336     function decreaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
337         if(_value >= _allowance[msg.sender][_spender]) {
338             _allowance[msg.sender][_spender] = 0;
339         } else {
340             _allowance[msg.sender][_spender] = sub(_allowance[msg.sender][_spender], _value);
341         }
342         emit Approval(msg.sender, _spender, _allowance[msg.sender][_spender]);
343         return true;
344     }
345 
346     // owner may burn own token
347     function burn(uint256 _value) public onlyOwner returns (bool _success) {
348         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
349         require(balanceP[msg.sender] >= _value && _value >= 0);
350         balanceP[msg.sender] = sub(balanceP[msg.sender], _value);
351         _totalSupply = sub(_totalSupply, _value);
352         emit Burn(msg.sender, _value);
353         return true;
354     }
355 
356     // safety methods
357     function () public payable {
358         revert();
359     }
360 
361     function emptyWrongToken(address _addr) onlyOwner public {
362         ERC20Token wrongToken = ERC20Token(_addr);
363         uint256 amount = wrongToken.balanceOf(address(this));
364         require(amount > 0);
365         require(wrongToken.transfer(msg.sender, amount));
366 
367         emit WrongTokenEmptied(_addr, msg.sender, amount);
368     }
369 
370     // shouldn't happen, just in case
371     function emptyWrongEther() onlyOwner public {
372         uint256 amount = address(this).balance;
373         require(amount > 0);
374         msg.sender.transfer(amount);
375 
376         emit WrongEtherEmptied(msg.sender, amount);
377     }
378 
379 }