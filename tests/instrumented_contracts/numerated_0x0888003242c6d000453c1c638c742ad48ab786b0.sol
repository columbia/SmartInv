1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 *
6 *
7 *    ______  ____________    ______     __
8 *   / ___/ |/ /_  __/ __ \  /_  __/__  / /_____ ___
9 *  / /__/    / / / / /_/ /   / / / _ \/  '_/ -_) _ \
10 *  \___/_/|_/ /_/  \____/   /_/  \___/_/\_\\__/_//_/
11 *
12 *
13 *
14 */
15 
16 // Contract must have an owner
17 contract Owned {
18     address public owner;
19 
20     constructor() public {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     function setOwner(address _owner) onlyOwner public {
30         owner = _owner;
31     }
32 }
33 
34 // SafeMath methods
35 contract SafeMath {
36     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
37         uint256 c = _a + _b;
38         assert(c >= _a);
39         return c;
40     }
41 
42     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
43         assert(_a >= _b);
44         return _a - _b;
45     }
46 
47     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         uint256 c = _a * _b;
49         assert(_a == 0 || c / _a == _b);
50         return c;
51     }
52 }
53 
54 // Standard ERC20 Token Interface
55 interface ERC20Token {
56     function name() external view returns (string _name);
57     function symbol() external view returns (string _symbol);
58     function decimals() external view returns (uint8 _decimals);
59     function totalSupply() external view returns (uint256 _totalSupply);
60     function balanceOf(address _owner) external view returns (uint256 _balance);
61     function transfer(address _to, uint256 _value) external returns (bool _success);
62     function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
63     function approve(address _spender, uint256 _value) external returns (bool _success);
64     function allowance(address _owner, address _spender) external view returns (uint256 _remaining);
65 
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 }
69 
70 // the main ERC20-compliant multi-timelock enabled contract
71 contract TokenMultiTimeLock is SafeMath, Owned, ERC20Token {
72     string private constant standard = "0.666";
73     string private constant version = "v3.0";
74     string private _name = "CNTO";
75     string private _symbol = "NTO";
76     uint8 private _decimals = 18;
77     uint256 private _totalSupply = 2 * 10**9 * uint256(10)**_decimals;
78     mapping (address => uint256) private balanceP;
79     mapping (address => mapping (address => uint256)) private _allowance;
80 
81     mapping (address => uint256[]) private lockTime;
82     mapping (address => uint256[]) private lockValue;
83     mapping (address => uint256) private lockNum;
84     uint256 private later = 0;
85     uint256 private earlier = 0;
86 
87     // burn token event
88     event Burn(address indexed _from, uint256 _value);
89 
90     // timelock-related events
91     event TransferLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
92     event TokenUnlocked(address indexed _address, uint256 _value);
93 
94     // safety method-related events
95     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
96     event WrongEtherEmptied(address indexed _addr, uint256 _amount);
97 
98     // constructor for the ERC20 Token
99     constructor() public {
100         balanceP[msg.sender] = _totalSupply;
101     }
102 
103     modifier validAddress(address _address) {
104         require(_address != 0x0);
105         _;
106     }
107 
108     // fast-forward the timelocks for all accounts
109     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
110         earlier = add(earlier, _earlier);
111     }
112 
113     // delay the timelocks for all accounts
114     function setUnlockLater(uint256 _later) public onlyOwner {
115         later = add(later, _later);
116     }
117 
118     // standard ERC20 name function
119     function name() public view returns (string) {
120         return _name;
121     }
122 
123     // standard ERC20 symbol function
124     function symbol() public view returns (string) {
125         return _symbol;
126     }
127 
128     // standard ERC20 decimals function
129     function decimals() public view returns (uint8) {
130         return _decimals;
131     }
132 
133     // standard ERC20 totalSupply function
134     function totalSupply() public view returns (uint256) {
135         return _totalSupply;
136     }
137 
138     // standard ERC20 allowance function
139     function allowance(address _owner, address _spender) external view returns (uint256) {
140         return _allowance[_owner][_spender];
141     }
142 
143     // show unlocked balance of an account
144     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
145         _balance = balanceP[_address];
146         uint256 i = 0;
147         while (i < lockNum[_address]) {
148             if (add(now, earlier) >= add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
149             i++;
150         }
151         return _balance;
152     }
153 
154     // show timelocked balance of an account
155     function balanceLocked(address _address) public view returns (uint256 _balance) {
156         _balance = 0;
157         uint256 i = 0;
158         while (i < lockNum[_address]) {
159             if (add(now, earlier) < add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
160             i++;
161         }
162         return  _balance;
163     }
164 
165     // standard ERC20 balanceOf with timelock added
166     function balanceOf(address _address) public view returns (uint256 _balance) {
167         _balance = balanceP[_address];
168         uint256 i = 0;
169         while (i < lockNum[_address]) {
170             _balance = add(_balance, lockValue[_address][i]);
171             i++;
172         }
173         return _balance;
174     }
175 
176     // show timelocks in an account
177     function showLockTimes(address _address) public view validAddress(_address) returns (uint256[] _times) {
178         uint i = 0;
179         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
180         while (i < lockNum[_address]) {
181             tempLockTime[i] = sub(add(lockTime[_address][i], later), earlier);
182             i++;
183         }
184         return tempLockTime;
185     }
186 
187     // show values locked in an account's timelocks
188     function showLockValues(address _address) public view validAddress(_address) returns (uint256[] _values) {
189         return lockValue[_address];
190     }
191 
192     function showLockNum(address _address) public view validAddress(_address) returns (uint256 _lockNum) {
193         return lockNum[_address];
194     }
195 
196     // Calculate and process the timelock states of an account
197     function calcUnlock(address _address) private {
198         uint256 i = 0;
199         uint256 j = 0;
200         uint256[] memory currentLockTime;
201         uint256[] memory currentLockValue;
202         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
203         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
204         currentLockTime = lockTime[_address];
205         currentLockValue = lockValue[_address];
206         while (i < lockNum[_address]) {
207             if (add(now, earlier) >= add(currentLockTime[i], later)) {
208                 balanceP[_address] = add(balanceP[_address], currentLockValue[i]);
209                 emit TokenUnlocked(_address, currentLockValue[i]);
210             } else {
211                 newLockTime[j] = currentLockTime[i];
212                 newLockValue[j] = currentLockValue[i];
213                 j++;
214             }
215             i++;
216         }
217         uint256[] memory trimLockTime = new uint256[](j);
218         uint256[] memory trimLockValue = new uint256[](j);
219         i = 0;
220         while (i < j) {
221             trimLockTime[i] = newLockTime[i];
222             trimLockValue[i] = newLockValue[i];
223             i++;
224         }
225         lockTime[_address] = trimLockTime;
226         lockValue[_address] = trimLockValue;
227         lockNum[_address] = j;
228     }
229 
230     // standard ERC20 transfer
231     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool _success) {
232         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
233         require(balanceP[msg.sender] >= _value && _value >= 0);
234         balanceP[msg.sender] = sub(balanceP[msg.sender], _value);
235         balanceP[_to] = add(balanceP[_to], _value);
236         emit Transfer(msg.sender, _to, _value);
237         return true;
238     }
239 
240     // transfer Token with timelocks
241     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool _success) {
242         require(_value.length == _time.length);
243 
244         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
245         uint256 i = 0;
246         uint256 totalValue = 0;
247         while (i < _value.length) {
248             totalValue = add(totalValue, _value[i]);
249             i++;
250         }
251         require(balanceP[msg.sender] >= totalValue && totalValue >= 0);
252         require(add(lockNum[msg.sender], _time.length) <= 42);
253         i = 0;
254         while (i < _time.length) {
255             if (_value[i] > 0) {
256                 balanceP[msg.sender] = sub(balanceP[msg.sender], _value[i]);
257                 lockTime[_to].length = lockNum[_to]+1;
258                 lockValue[_to].length = lockNum[_to]+1;
259                 lockTime[_to][lockNum[_to]] = sub(add(add(now, _time[i]), earlier), later);
260                 lockValue[_to][lockNum[_to]] = _value[i];
261                 lockNum[_to]++;
262             }
263 
264             // emit custom TransferLocked event
265             emit TransferLocked(msg.sender, _to, _time[i], _value[i]);
266 
267             // emit standard Transfer event for wallets
268             emit Transfer(msg.sender, _to, _value[i]);
269 
270             i++;
271         }
272         return true;
273     }
274 
275     // TransferFrom Token with timelocks
276     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public
277 	    validAddress(_from) validAddress(_to) returns (bool success) {
278         require(_value.length == _time.length);
279 
280         if (lockNum[_from] > 0) calcUnlock(_from);
281         uint256 i = 0;
282         uint256 totalValue = 0;
283         while (i < _value.length) {
284             totalValue = add(totalValue, _value[i]);
285             i++;
286         }
287         require(balanceP[_from] >= totalValue && totalValue >= 0 && _allowance[_from][msg.sender] >= totalValue);
288         require(add(lockNum[_from], _time.length) <= 42);
289         i = 0;
290         while (i < _time.length) {
291             if (_value[i] > 0) {
292                 balanceP[_from] = sub(balanceP[_from], _value[i]);
293                 _allowance[_from][msg.sender] = sub(_allowance[_from][msg.sender], _value[i]);
294                 lockTime[_to].length = lockNum[_to]+1;
295                 lockValue[_to].length = lockNum[_to]+1;
296                 lockTime[_to][lockNum[_to]] = sub(add(add(now, _time[i]), earlier), later);
297                 lockValue[_to][lockNum[_to]] = _value[i];
298                 lockNum[_to]++;
299             }
300 
301             // emit custom TransferLocked event
302             emit TransferLocked(_from, _to, _time[i], _value[i]);
303 
304             // emit standard Transfer event for wallets
305             emit Transfer(_from, _to, _value[i]);
306 
307             i++;
308         }
309         return true;
310     }
311 
312     // standard ERC20 transferFrom
313     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool _success) {
314         if (lockNum[_from] > 0) calcUnlock(_from);
315         require(balanceP[_from] >= _value && _value >= 0 && _allowance[_from][msg.sender] >= _value);
316         _allowance[_from][msg.sender] = sub(_allowance[_from][msg.sender], _value);
317         balanceP[_from] = sub(balanceP[_from], _value);
318         balanceP[_to] = add(balanceP[_to], _value);
319         emit Transfer(_from, _to, _value);
320         return true;
321     }
322 
323     // should only be called when first setting an _allowance
324     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool _success) {
325         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
326         _allowance[msg.sender][_spender] = _value;
327         emit Approval(msg.sender, _spender, _value);
328         return true;
329     }
330 
331     // increase or decrease _allowance
332     function increaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
333         _allowance[msg.sender][_spender] = add(_allowance[msg.sender][_spender], _value);
334         emit Approval(msg.sender, _spender, _allowance[msg.sender][_spender]);
335         return true;
336     }
337 
338     function decreaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
339         if(_value >= _allowance[msg.sender][_spender]) {
340             _allowance[msg.sender][_spender] = 0;
341         } else {
342             _allowance[msg.sender][_spender] = sub(_allowance[msg.sender][_spender], _value);
343         }
344         emit Approval(msg.sender, _spender, _allowance[msg.sender][_spender]);
345         return true;
346     }
347 
348     // owner may burn own token
349     function burn(uint256 _value) public onlyOwner returns (bool _success) {
350         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
351         require(balanceP[msg.sender] >= _value && _value >= 0);
352         balanceP[msg.sender] = sub(balanceP[msg.sender], _value);
353         _totalSupply = sub(_totalSupply, _value);
354         emit Burn(msg.sender, _value);
355         return true;
356     }
357 
358     // safety methods
359     function () public payable {
360         revert();
361     }
362 
363     function emptyWrongToken(address _addr) onlyOwner public {
364         ERC20Token wrongToken = ERC20Token(_addr);
365         uint256 amount = wrongToken.balanceOf(address(this));
366         require(amount > 0);
367         require(wrongToken.transfer(msg.sender, amount));
368 
369         emit WrongTokenEmptied(_addr, msg.sender, amount);
370     }
371 
372     // shouldn't happen, just in case
373     function emptyWrongEther() onlyOwner public {
374         uint256 amount = address(this).balance;
375         require(amount > 0);
376         msg.sender.transfer(amount);
377 
378         emit WrongEtherEmptied(msg.sender, amount);
379     }
380 
381 }