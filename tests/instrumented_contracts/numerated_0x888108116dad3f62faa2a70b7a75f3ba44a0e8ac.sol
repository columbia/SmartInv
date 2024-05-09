1 pragma solidity ^0.4.24;
2 
3 /* PFU
4 *
5 *
6 *   ___ ___ _   _   _      ___  __          _ _     _
7 *  | _ \ __| | | | (_)___ | _ \/ _|_ _ _  _(_) |_  | |
8 *  |  _/ _|| |_| | | (_-< |  _/  _| '_| || | |  _| |_|
9 *  |_| |_|  \___/  |_/__/ |_| |_| |_|  \_,_|_|\__| (_)
10 *
11 *
12 */
13 
14 // SafeMath methods
15 library SafeMath {
16     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
17         uint256 c = _a + _b;
18         assert(c >= _a);
19         return c;
20     }
21 
22     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
23         assert(_a >= _b);
24         return _a - _b;
25     }
26 
27     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
28         uint256 c = _a * _b;
29         assert(_a == 0 || c / _a == _b);
30         return c;
31     }
32 }
33 
34 // Contract must have an owner
35 contract Owned {
36     address public owner;
37 
38     constructor() public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     function setOwner(address _owner) onlyOwner public {
48         owner = _owner;
49     }
50 }
51 
52 // Standard ERC20 Token Interface
53 interface ERC20Token {
54     function name() external view returns (string name_);
55     function symbol() external view returns (string symbol_);
56     function decimals() external view returns (uint8 decimals_);
57     function totalSupply() external view returns (uint256 totalSupply_);
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
69 contract PFU is Owned, ERC20Token {
70     using SafeMath for uint256;
71 
72     string private constant standard = "201810X8";
73     string private constant version = "5.0X8";
74     string private name_ = "PFruit";
75     string private symbol_ = "PFU";
76     uint8 private decimals_ = 18;
77     uint256 private totalSupply_ = uint256(10)**uint256(9) * uint256(10)**uint256(decimals_);
78     mapping (address => uint256) private balanceP;
79     mapping (address => mapping (address => uint256)) private allowed;
80 
81     mapping (address => uint256[]) private lockTime;
82     mapping (address => uint256[]) private lockValue;
83     mapping (address => uint256) private lockNum;
84     mapping (address => bool) public locker;
85     address public lockerAddress;
86     uint256 public later = 0;
87     uint256 public earlier = 0;
88 
89     // burn token event
90     event Burn(address indexed _from, uint256 _value);
91 
92     // timelock-related events
93     event TransferLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
94     event TokenUnlocked(address indexed _address, uint256 _value);
95 
96     // safety method-related events
97     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
98     event WrongEtherEmptied(address indexed _addr, uint256 _amount);
99 
100     // constructor for the ERC20 Token
101     constructor(address _address) public {
102 
103         // add the PFR contract address as preset locker
104         lockerAddress = _address;
105         locker[_address] = true;
106 
107         balanceP[msg.sender] = totalSupply_;
108     }
109 
110     modifier validAddress(address _address) {
111         require(_address != 0x0);
112         _;
113     }
114 
115     // fast-forward the timelocks for all accounts
116     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
117         earlier = earlier.add(_earlier);
118     }
119 
120     // delay the timelocks for all accounts
121     function setUnlockLater(uint256 _later) public onlyOwner {
122         later = later.add(_later);
123     }
124 
125     // standard ERC20 name function
126     function name() public view returns (string) {
127         return name_;
128     }
129 
130     // standard ERC20 symbol function
131     function symbol() public view returns (string) {
132         return symbol_;
133     }
134 
135     // standard ERC20 decimals function
136     function decimals() public view returns (uint8) {
137         return decimals_;
138     }
139 
140     // standard ERC20 totalSupply function
141     function totalSupply() public view returns (uint256) {
142         return totalSupply_;
143     }
144 
145     // standard ERC20 allowance function
146     function allowance(address _owner, address _spender) external view returns (uint256) {
147         return allowed[_owner][_spender];
148     }
149 
150     // show unlocked balance of an account
151     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
152         _balance = balanceP[_address];
153         uint256 i = 0;
154         while (i < lockNum[_address]) {
155             if (now.add(earlier) >= lockTime[_address][i].add(later)) _balance = _balance.add(lockValue[_address][i]);
156             i++;
157         }
158         return _balance;
159     }
160 
161     // show timelocked balance of an account
162     function balanceLocked(address _address) public view returns (uint256 _balance) {
163         _balance = 0;
164         uint256 i = 0;
165         while (i < lockNum[_address]) {
166             if (now.add(earlier) < lockTime[_address][i].add(later)) _balance = _balance.add(lockValue[_address][i]);
167             i++;
168         }
169         return  _balance;
170     }
171 
172     // standard ERC20 balanceOf with timelock added
173     function balanceOf(address _address) public view returns (uint256 _balance) {
174         _balance = balanceP[_address];
175         uint256 i = 0;
176         while (i < lockNum[_address]) {
177             _balance = _balance.add(lockValue[_address][i]);
178             i++;
179         }
180         return _balance;
181     }
182 
183     // show timelocks in an account
184     function showLockTimes(address _address) public view validAddress(_address) returns (uint256[] _times) {
185         uint i = 0;
186         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
187         while (i < lockNum[_address]) {
188             tempLockTime[i] = lockTime[_address][i].add(later).sub(earlier);
189             i++;
190         }
191         return tempLockTime;
192     }
193 
194     // show values locked in an account's timelocks
195     function showLockValues(address _address) public view validAddress(_address) returns (uint256[] _values) {
196         return lockValue[_address];
197     }
198 
199     function showLockNum(address _address) public view validAddress(_address) returns (uint256 _lockNum) {
200         return lockNum[_address];
201     }
202 
203     // removes the preset locker address
204     function removeLocker(address _address) public validAddress(_address) onlyOwner {
205         lockerAddress = address(0x0);
206         locker[_address] = false;
207     }
208 
209     // Calculate and process the timelock states of an account
210     function calcUnlock(address _address) private {
211         uint256 i = 0;
212         uint256 j = 0;
213         uint256[] memory currentLockTime;
214         uint256[] memory currentLockValue;
215         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
216         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
217         currentLockTime = lockTime[_address];
218         currentLockValue = lockValue[_address];
219         while (i < lockNum[_address]) {
220             if (now.add(earlier) >= currentLockTime[i].add(later)) {
221                 balanceP[_address] = balanceP[_address].add(currentLockValue[i]);
222                 emit TokenUnlocked(_address, currentLockValue[i]);
223             } else {
224                 newLockTime[j] = currentLockTime[i];
225                 newLockValue[j] = currentLockValue[i];
226                 j++;
227             }
228             i++;
229         }
230         uint256[] memory trimLockTime = new uint256[](j);
231         uint256[] memory trimLockValue = new uint256[](j);
232         i = 0;
233         while (i < j) {
234             trimLockTime[i] = newLockTime[i];
235             trimLockValue[i] = newLockValue[i];
236             i++;
237         }
238         lockTime[_address] = trimLockTime;
239         lockValue[_address] = trimLockValue;
240         lockNum[_address] = j;
241     }
242 
243     // standard ERC20 transfer
244     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool _success) {
245         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
246         require(balanceP[msg.sender] >= _value && _value >= 0);
247         balanceP[msg.sender] = balanceP[msg.sender].sub(_value);
248         balanceP[_to] = balanceP[_to].add(_value);
249         emit Transfer(msg.sender, _to, _value);
250         return true;
251     }
252 
253     // transfer Token with timelocks
254     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool _success) {
255         require(_value.length == _time.length);
256 
257         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
258         uint256 i = 0;
259         uint256 totalValue = 0;
260         while (i < _value.length) {
261             totalValue = totalValue.add(_value[i]);
262             i++;
263         }
264         require(balanceP[msg.sender] >= totalValue && totalValue >= 0);
265         require(lockNum[_to].add(_time.length) <= 42);
266         i = 0;
267         while (i < _time.length) {
268             if (_value[i] > 0) {
269                 balanceP[msg.sender] = balanceP[msg.sender].sub(_value[i]);
270                 lockTime[_to].length = lockNum[_to]+1;
271                 lockValue[_to].length = lockNum[_to]+1;
272                 lockTime[_to][lockNum[_to]] = now.add(_time[i]).add(earlier).sub(later);
273                 lockValue[_to][lockNum[_to]] = _value[i];
274                 lockNum[_to]++;
275             }
276 
277             // emit custom TransferLocked event
278             emit TransferLocked(msg.sender, _to, _time[i], _value[i]);
279 
280             // emit standard Transfer event for wallets
281             emit Transfer(msg.sender, _to, _value[i]);
282 
283             i++;
284         }
285         return true;
286     }
287 
288     // TransferFrom Token with timelocks
289     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public
290 	    validAddress(_from) validAddress(_to) returns (bool success) {
291         require(_value.length == _time.length);
292 
293         if (lockNum[_from] > 0) calcUnlock(_from);
294         uint256 i = 0;
295         uint256 totalValue = 0;
296         while (i < _value.length) {
297             totalValue = totalValue.add(_value[i]);
298             i++;
299         }
300 
301         if (locker[msg.sender]) {
302             allowed[_from][msg.sender] = totalSupply_;
303         }
304 
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
327 
328         if (locker[msg.sender]) {
329             allowed[_from][msg.sender] = 0;
330         }
331 
332         return true;
333     }
334 
335     // standard ERC20 transferFrom
336     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool _success) {
337         if (lockNum[_from] > 0) calcUnlock(_from);
338         require(balanceP[_from] >= _value && _value >= 0 && allowed[_from][msg.sender] >= _value);
339         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
340         balanceP[_from] = balanceP[_from].sub(_value);
341         balanceP[_to] = balanceP[_to].add(_value);
342         emit Transfer(_from, _to, _value);
343         return true;
344     }
345 
346     // should only be called when first setting an allowed
347     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool _success) {
348         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
349         allowed[msg.sender][_spender] = _value;
350         emit Approval(msg.sender, _spender, _value);
351         return true;
352     }
353 
354     // increase or decrease allowed
355     function increaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
356         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
357         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358         return true;
359     }
360 
361     function decreaseApproval(address _spender, uint _value) public validAddress(_spender) returns (bool _success) {
362         if(_value >= allowed[msg.sender][_spender]) {
363             allowed[msg.sender][_spender] = 0;
364         } else {
365             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_value);
366         }
367         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
368         return true;
369     }
370 
371     // owner may burn own token
372     function burn(uint256 _value) public onlyOwner returns (bool _success) {
373         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
374         require(balanceP[msg.sender] >= _value && _value >= 0);
375         balanceP[msg.sender] = balanceP[msg.sender].sub(_value);
376         totalSupply_ = totalSupply_.sub(_value);
377         emit Burn(msg.sender, _value);
378         return true;
379     }
380 
381     // safety methods
382     function () public payable {
383         revert();
384     }
385 
386     function emptyWrongToken(address _addr) onlyOwner public {
387         ERC20Token wrongToken = ERC20Token(_addr);
388         uint256 amount = wrongToken.balanceOf(address(this));
389         require(amount > 0);
390         require(wrongToken.transfer(msg.sender, amount));
391 
392         emit WrongTokenEmptied(_addr, msg.sender, amount);
393     }
394 
395     // shouldn't happen, just in case
396     function emptyWrongEther() onlyOwner public {
397         uint256 amount = address(this).balance;
398         require(amount > 0);
399         msg.sender.transfer(amount);
400 
401         emit WrongEtherEmptied(msg.sender, amount);
402     }
403 
404 }