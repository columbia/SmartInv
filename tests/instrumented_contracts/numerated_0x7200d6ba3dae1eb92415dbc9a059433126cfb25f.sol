1 pragma solidity ^0.4.18;
2 
3 /*
4 // --
5 // --
6 // --
7 //   ___       ___       ___       ___       ___
8 //   /\  \     /\__\     /\  \     /\__\     /\  \
9 //   /::\  \   /:/ _/_   /::\  \   /::L_L_    \:\  \
10 //   /\:\:\__\ /:/_/\__\ /::\:\__\ /:/L:\__\   /::\__\
11 //   \:\:\/__/ \:\/:/  / \/\::/  / \/_/:/  /  /:/\/__/
12 //   \::/  /   \::/  /     \/__/    /:/  /   \/__/
13 //   \/__/     \/__/               \/__/
14 // --
15 // --
16 // --
17 */
18 
19 // Contract must have an owner
20 contract Owned {
21     address public owner;
22 
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     function setOwner(address _owner) onlyOwner public {
33         owner = _owner;
34     }
35 }
36 
37 // SafeMath methods
38 contract SafeMath {
39     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
40         uint256 c = _a + _b;
41         assert(c >= _a);
42         return c;
43     }
44 
45     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
46         assert(_a >= _b);
47         return _a - _b;
48     }
49 
50     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
51         uint256 c = _a * _b;
52         assert(_a == 0 || c / _a == _b);
53         return c;
54     }
55 }
56 
57 // for safety methods
58 interface ERC20Token {
59   function transfer(address _to, uint256 _value) external returns (bool);
60   function balanceOf(address _addr) external view returns (uint256);
61   function decimals() external view returns (uint8);
62 }
63 
64 // the main ERC20-compliant contract
65 contract Token is SafeMath, Owned {
66     uint256 constant DAY_IN_SECONDS = 86400;
67     string public constant standard = "0.66";
68     string public name = "";
69     string public symbol = "";
70     uint8 public decimals = 0;
71     uint256 public totalSupply = 0;
72     mapping (address => uint256) public balanceP;
73     mapping (address => mapping (address => uint256)) public allowance;
74 
75     mapping (address => uint256[]) public lockTime;
76     mapping (address => uint256[]) public lockValue;
77     mapping (address => uint256) public lockNum;
78     mapping (address => bool) public locker;
79     uint256 public later = 0;
80     uint256 public earlier = 0;
81 
82     // standard ERC20 events
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 
86     // timelock-related events
87     event TransferLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
88     event TokenUnlocked(address indexed _address, uint256 _value);
89 
90     // safety method-related events
91     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
92     event WrongEtherEmptied(address indexed _addr, uint256 _amount);
93 
94     // constructor for the ERC20 Token
95     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
96         require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
97 
98         name = _name;
99         symbol = _symbol;
100         decimals = _decimals;
101         totalSupply = _totalSupply;
102 
103         balanceP[msg.sender] = _totalSupply;
104 
105     }
106 
107     modifier validAddress(address _address) {
108         require(_address != 0x0);
109         _;
110     }
111 
112     // owner may add or remove a locker address for the contract
113     function addLocker(address _address) public validAddress(_address) onlyOwner {
114         locker[_address] = true;
115     }
116 
117     function removeLocker(address _address) public validAddress(_address) onlyOwner {
118         locker[_address] = false;
119     }
120 
121     // fast-forward the timelocks for all accounts
122     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
123         earlier = add(earlier, _earlier);
124     }
125 
126     // delay the timelocks for all accounts
127     function setUnlockLater(uint256 _later) public onlyOwner {
128         later = add(later, _later);
129     }
130 
131     // show unlocked balance of an account
132     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
133         _balance = balanceP[_address];
134         uint256 i = 0;
135         while (i < lockNum[_address]) {
136             if (add(now, earlier) > add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
137             i++;
138         }
139         return _balance;
140     }
141 
142     // show timelocked balance of an account
143     function balanceLocked(address _address) public view returns (uint256 _balance) {
144         _balance = 0;
145         uint256 i = 0;
146         while (i < lockNum[_address]) {
147             if (add(now, earlier) < add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
148             i++;
149         }
150         return  _balance;
151     }
152 
153     // standard ERC20 balanceOf with timelock added
154     function balanceOf(address _address) public view returns (uint256 _balance) {
155         _balance = balanceP[_address];
156         uint256 i = 0;
157         while (i < lockNum[_address]) {
158             _balance = add(_balance, lockValue[_address][i]);
159             i++;
160         }
161         return _balance;
162     }
163 
164     // show timelocks in an account
165     function showTime(address _address) public view validAddress(_address) returns (uint256[] _time) {
166         uint i = 0;
167         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
168         while (i < lockNum[_address]) {
169             tempLockTime[i] = sub(add(lockTime[_address][i], later), earlier);
170             i++;
171         }
172         return tempLockTime;
173     }
174 
175     // show values locked in an account's timelocks
176     function showValue(address _address) public view validAddress(_address) returns (uint256[] _value) {
177         return lockValue[_address];
178     }
179 
180     // Calculate and process the timelock states of an account
181     function calcUnlock(address _address) private {
182         uint256 i = 0;
183         uint256 j = 0;
184         uint256[] memory currentLockTime;
185         uint256[] memory currentLockValue;
186         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
187         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
188         currentLockTime = lockTime[_address];
189         currentLockValue = lockValue[_address];
190         while (i < lockNum[_address]) {
191             if (add(now, earlier) > add(currentLockTime[i], later)) {
192                 balanceP[_address] = add(balanceP[_address], currentLockValue[i]);
193                 emit TokenUnlocked(_address, currentLockValue[i]);
194             } else {
195                 newLockTime[j] = currentLockTime[i];
196                 newLockValue[j] = currentLockValue[i];
197                 j++;
198             }
199             i++;
200         }
201         uint256[] memory trimLockTime = new uint256[](j);
202         uint256[] memory trimLockValue = new uint256[](j);
203         i = 0;
204         while (i < j) {
205             trimLockTime[i] = newLockTime[i];
206             trimLockValue[i] = newLockValue[i];
207             i++;
208         }
209         lockTime[_address] = trimLockTime;
210         lockValue[_address] = trimLockValue;
211         lockNum[_address] = j;
212     }
213 
214     // standard ERC20 transfer
215     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool success) {
216         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
217         if (balanceP[msg.sender] >= _value && _value > 0) {
218             balanceP[msg.sender] = sub(balanceP[msg.sender], _value);
219             balanceP[_to] = add(balanceP[_to], _value);
220             emit Transfer(msg.sender, _to, _value);
221             return true;
222         }
223         else {
224             return false;
225         }
226     }
227 
228     // transfer Token with timelocks
229     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool success) {
230         require(_value.length == _time.length);
231 
232         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
233         uint256 i = 0;
234         uint256 totalValue = 0;
235         while (i < _value.length) {
236             totalValue = add(totalValue, _value[i]);
237             i++;
238         }
239         if (balanceP[msg.sender] >= totalValue && totalValue > 0) {
240             i = 0;
241             while (i < _time.length) {
242                 balanceP[msg.sender] = sub(balanceP[msg.sender], _value[i]);
243                 lockTime[_to].length = lockNum[_to]+1;
244                 lockValue[_to].length = lockNum[_to]+1;
245                 lockTime[_to][lockNum[_to]] = add(now, _time[i]);
246                 lockValue[_to][lockNum[_to]] = _value[i];
247 
248                 // emit custom TransferLocked event
249                 emit TransferLocked(msg.sender, _to, lockTime[_to][lockNum[_to]], lockValue[_to][lockNum[_to]]);
250 
251                 // emit standard Transfer event for wallets
252                 emit Transfer(msg.sender, _to, lockValue[_to][lockNum[_to]]);
253                 lockNum[_to]++;
254                 i++;
255             }
256             return true;
257         }
258         else {
259             return false;
260         }
261     }
262 
263     // lockers set by owners may transfer Token with timelocks
264     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public
265 	    validAddress(_from) validAddress(_to) returns (bool success) {
266         require(locker[msg.sender]);
267         require(_value.length == _time.length);
268 
269         if (lockNum[_from] > 0) calcUnlock(_from);
270         uint256 i = 0;
271         uint256 totalValue = 0;
272         while (i < _value.length) {
273             totalValue = add(totalValue, _value[i]);
274             i++;
275         }
276         if (balanceP[_from] >= totalValue && totalValue > 0 && allowance[_from][msg.sender] >= totalValue) {
277             i = 0;
278             while (i < _time.length) {
279                 balanceP[_from] = sub(balanceP[_from], _value[i]);
280                 allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value[i]);
281                 lockTime[_to].length = lockNum[_to]+1;
282                 lockValue[_to].length = lockNum[_to]+1;
283                 lockTime[_to][lockNum[_to]] = add(now, _time[i]);
284                 lockValue[_to][lockNum[_to]] = _value[i];
285 
286                 // emit custom TransferLocked event
287                 emit TransferLocked(_from, _to, lockTime[_to][lockNum[_to]], lockValue[_to][lockNum[_to]]);
288 
289                 // emit standard Transfer event for wallets
290                 emit Transfer(_from, _to, lockValue[_to][lockNum[_to]]);
291                 lockNum[_to]++;
292                 i++;
293             }
294             return true;
295         }
296         else {
297             return false;
298         }
299     }
300 
301     // standard ERC20 transferFrom
302     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool success) {
303         if (lockNum[_from] > 0) calcUnlock(_from);
304         if (balanceP[_from] >= _value && _value > 0 && allowance[_from][msg.sender] >= _value) {
305             allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
306             balanceP[_from] = sub(balanceP[_from], _value);
307             balanceP[_to] = add(balanceP[_to], _value);
308             emit Transfer(_from, _to, _value);
309             return true;
310         }
311         else {
312             return false;
313         }
314     }
315 
316     // should only be called when first setting an allowance
317     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool success) {
318         require(allowance[msg.sender][_spender] == 0);
319 
320         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
321         allowance[msg.sender][_spender] = _value;
322         emit Approval(msg.sender, _spender, _value);
323         return true;
324     }
325 
326     // increase or decrease allowance
327     function increaseApproval(address _spender, uint _value) public returns (bool) {
328       allowance[msg.sender][_spender] = add(allowance[msg.sender][_spender], _value);
329       emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
330       return true;
331     }
332 
333     function decreaseApproval(address _spender, uint _value) public returns (bool) {
334       if(_value > allowance[msg.sender][_spender]) {
335         allowance[msg.sender][_spender] = 0;
336       } else {
337         allowance[msg.sender][_spender] = sub(allowance[msg.sender][_spender], _value);
338       }
339       emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
340       return true;
341     }
342 
343     // safety methods
344     function () public payable {
345         revert();
346     }
347 
348     function emptyWrongToken(address _addr) onlyOwner public {
349       ERC20Token wrongToken = ERC20Token(_addr);
350       uint256 amount = wrongToken.balanceOf(address(this));
351       require(amount > 0);
352       require(wrongToken.transfer(msg.sender, amount));
353 
354       emit WrongTokenEmptied(_addr, msg.sender, amount);
355     }
356 
357     // shouldn't happen, just in case
358     function emptyWrongEther() onlyOwner public {
359       uint256 amount = address(this).balance;
360       require(amount > 0);
361       msg.sender.transfer(amount);
362 
363       emit WrongEtherEmptied(msg.sender, amount);
364     }
365 
366 }