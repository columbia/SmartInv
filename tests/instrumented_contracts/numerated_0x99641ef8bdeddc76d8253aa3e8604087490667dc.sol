1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * ____   ____      .__                  _________ .__           .__
6 * \   \ /   /____  |  |  __ __   ____   \_   ___ \|  |__ _____  |__| ____
7 *  \   Y   /\__  \ |  | |  |  \_/ __ \  /    \  \/|  |  \\__  \ |  |/    \
8 *   \     /  / __ \|  |_|  |  /\  ___/  \     \___|   Y  \/ __ \|  |   |  \
9 *    \___/  (____  /____/____/  \___  >  \______  /___|  (____  /__|___|  /
10 *                \/                 \/          \/     \/     \/        \/
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
52 // for safety methods
53 interface ERC20Token {
54   function transfer(address _to, uint256 _value) external returns (bool);
55   function balanceOf(address _addr) external view returns (uint256);
56   function decimals() external view returns (uint8);
57 }
58 
59 // the main ERC20-compliant contract
60 contract Token is SafeMath, Owned {
61     uint256 private constant DAY_IN_SECONDS = 86400;
62     string public constant standard = "0.861057";
63     string public name = "";
64     string public symbol = "";
65     uint8 public decimals = 0;
66     uint256 public totalSupply = 0;
67     mapping (address => uint256) public balanceP;
68     mapping (address => mapping (address => uint256)) public allowance;
69 
70     mapping (address => uint256[]) public lockTime;
71     mapping (address => uint256[]) public lockValue;
72     mapping (address => uint256) public lockNum;
73     mapping (address => bool) public locker;
74     uint256 public later = 0;
75     uint256 public earlier = 0;
76 
77     // standard ERC20 events
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 
81     // timelock-related events
82     event TransferLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
83     event TokenUnlocked(address indexed _address, uint256 _value);
84 
85     // safety method-related events
86     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
87     event WrongEtherEmptied(address indexed _addr, uint256 _amount);
88 
89     // constructor for the ERC20 Token
90     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
91         require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
92 
93         name = _name;
94         symbol = _symbol;
95         decimals = _decimals;
96         totalSupply = _totalSupply;
97 
98         balanceP[msg.sender] = _totalSupply;
99 
100     }
101 
102     modifier validAddress(address _address) {
103         require(_address != 0x0);
104         _;
105     }
106 
107     // owner may add or remove a locker address for the contract
108     function addLocker(address _address) public validAddress(_address) onlyOwner {
109         locker[_address] = true;
110     }
111 
112     function removeLocker(address _address) public validAddress(_address) onlyOwner {
113         locker[_address] = false;
114     }
115 
116     // fast-forward the timelocks for all accounts
117     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
118         earlier = add(earlier, _earlier);
119     }
120 
121     // delay the timelocks for all accounts
122     function setUnlockLater(uint256 _later) public onlyOwner {
123         later = add(later, _later);
124     }
125 
126     // show unlocked balance of an account
127     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
128         _balance = balanceP[_address];
129         uint256 i = 0;
130         while (i < lockNum[_address]) {
131             if (add(now, earlier) >= add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
132             i++;
133         }
134         return _balance;
135     }
136 
137     // show timelocked balance of an account
138     function balanceLocked(address _address) public view returns (uint256 _balance) {
139         _balance = 0;
140         uint256 i = 0;
141         while (i < lockNum[_address]) {
142             if (add(now, earlier) < add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
143             i++;
144         }
145         return  _balance;
146     }
147 
148     // standard ERC20 balanceOf with timelock added
149     function balanceOf(address _address) public view returns (uint256 _balance) {
150         _balance = balanceP[_address];
151         uint256 i = 0;
152         while (i < lockNum[_address]) {
153             _balance = add(_balance, lockValue[_address][i]);
154             i++;
155         }
156         return _balance;
157     }
158 
159     // show timelocks in an account
160     function showTime(address _address) public view validAddress(_address) returns (uint256[] _time) {
161         uint i = 0;
162         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
163         while (i < lockNum[_address]) {
164             tempLockTime[i] = sub(add(lockTime[_address][i], later), earlier);
165             i++;
166         }
167         return tempLockTime;
168     }
169 
170     // show values locked in an account's timelocks
171     function showValue(address _address) public view validAddress(_address) returns (uint256[] _value) {
172         return lockValue[_address];
173     }
174 
175     // Calculate and process the timelock states of an account
176     function calcUnlock(address _address) private {
177         uint256 i = 0;
178         uint256 j = 0;
179         uint256[] memory currentLockTime;
180         uint256[] memory currentLockValue;
181         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
182         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
183         currentLockTime = lockTime[_address];
184         currentLockValue = lockValue[_address];
185         while (i < lockNum[_address]) {
186             if (add(now, earlier) >= add(currentLockTime[i], later)) {
187                 balanceP[_address] = add(balanceP[_address], currentLockValue[i]);
188                 emit TokenUnlocked(_address, currentLockValue[i]);
189             } else {
190                 newLockTime[j] = currentLockTime[i];
191                 newLockValue[j] = currentLockValue[i];
192                 j++;
193             }
194             i++;
195         }
196         uint256[] memory trimLockTime = new uint256[](j);
197         uint256[] memory trimLockValue = new uint256[](j);
198         i = 0;
199         while (i < j) {
200             trimLockTime[i] = newLockTime[i];
201             trimLockValue[i] = newLockValue[i];
202             i++;
203         }
204         lockTime[_address] = trimLockTime;
205         lockValue[_address] = trimLockValue;
206         lockNum[_address] = j;
207     }
208 
209     // standard ERC20 transfer
210     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool success) {
211         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
212         require(balanceP[msg.sender] >= _value && _value >= 0);
213         balanceP[msg.sender] = sub(balanceP[msg.sender], _value);
214         balanceP[_to] = add(balanceP[_to], _value);
215         emit Transfer(msg.sender, _to, _value);
216         return true;
217     }
218 
219     // transfer Token with timelocks
220     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool success) {
221         require(_value.length == _time.length);
222 
223         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
224         uint256 i = 0;
225         uint256 totalValue = 0;
226         while (i < _value.length) {
227             totalValue = add(totalValue, _value[i]);
228             i++;
229         }
230         require(balanceP[msg.sender] >= totalValue && totalValue >= 0);
231         i = 0;
232         while (i < _time.length) {
233             balanceP[msg.sender] = sub(balanceP[msg.sender], _value[i]);
234             lockTime[_to].length = lockNum[_to]+1;
235             lockValue[_to].length = lockNum[_to]+1;
236             lockTime[_to][lockNum[_to]] = add(now, _time[i]);
237             lockValue[_to][lockNum[_to]] = _value[i];
238 
239             // emit custom TransferLocked event
240             emit TransferLocked(msg.sender, _to, lockTime[_to][lockNum[_to]], lockValue[_to][lockNum[_to]]);
241 
242             // emit standard Transfer event for wallets
243             emit Transfer(msg.sender, _to, lockValue[_to][lockNum[_to]]);
244             lockNum[_to]++;
245             i++;
246         }
247         return true;
248     }
249 
250     // lockers set by owners may transfer Token with timelocks
251     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public
252 	    validAddress(_from) validAddress(_to) returns (bool success) {
253         require(locker[msg.sender]);
254         require(_value.length == _time.length);
255 
256         if (lockNum[_from] > 0) calcUnlock(_from);
257         uint256 i = 0;
258         uint256 totalValue = 0;
259         while (i < _value.length) {
260             totalValue = add(totalValue, _value[i]);
261             i++;
262         }
263         require(balanceP[_from] >= totalValue && totalValue >= 0 && allowance[_from][msg.sender] >= totalValue);
264         i = 0;
265         while (i < _time.length) {
266             balanceP[_from] = sub(balanceP[_from], _value[i]);
267             allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value[i]);
268             lockTime[_to].length = lockNum[_to]+1;
269             lockValue[_to].length = lockNum[_to]+1;
270             lockTime[_to][lockNum[_to]] = add(now, _time[i]);
271             lockValue[_to][lockNum[_to]] = _value[i];
272 
273             // emit custom TransferLocked event
274             emit TransferLocked(_from, _to, lockTime[_to][lockNum[_to]], lockValue[_to][lockNum[_to]]);
275 
276             // emit standard Transfer event for wallets
277             emit Transfer(_from, _to, lockValue[_to][lockNum[_to]]);
278             lockNum[_to]++;
279             i++;
280         }
281         return true;
282     }
283 
284     // standard ERC20 transferFrom
285     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool success) {
286         if (lockNum[_from] > 0) calcUnlock(_from);
287         require(balanceP[_from] >= _value && _value >= 0 && allowance[_from][msg.sender] >= _value);
288         allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
289         balanceP[_from] = sub(balanceP[_from], _value);
290         balanceP[_to] = add(balanceP[_to], _value);
291         emit Transfer(_from, _to, _value);
292         return true;
293     }
294 
295     // should only be called when first setting an allowance
296     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool success) {
297         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
298         allowance[msg.sender][_spender] = _value;
299         emit Approval(msg.sender, _spender, _value);
300         return true;
301     }
302 
303     // increase or decrease allowance
304     function increaseApproval(address _spender, uint _value) public returns (bool) {
305       allowance[msg.sender][_spender] = add(allowance[msg.sender][_spender], _value);
306       emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
307       return true;
308     }
309 
310     function decreaseApproval(address _spender, uint _value) public returns (bool) {
311       if(_value >= allowance[msg.sender][_spender]) {
312         allowance[msg.sender][_spender] = 0;
313       } else {
314         allowance[msg.sender][_spender] = sub(allowance[msg.sender][_spender], _value);
315       }
316       emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
317       return true;
318     }
319 
320     // safety methods
321     function () public payable {
322         revert();
323     }
324 
325     function emptyWrongToken(address _addr) onlyOwner public {
326       ERC20Token wrongToken = ERC20Token(_addr);
327       uint256 amount = wrongToken.balanceOf(address(this));
328       require(amount > 0);
329       require(wrongToken.transfer(msg.sender, amount));
330 
331       emit WrongTokenEmptied(_addr, msg.sender, amount);
332     }
333 
334     // shouldn't happen, just in case
335     function emptyWrongEther() onlyOwner public {
336       uint256 amount = address(this).balance;
337       require(amount > 0);
338       msg.sender.transfer(amount);
339 
340       emit WrongEtherEmptied(msg.sender, amount);
341     }
342 
343 }