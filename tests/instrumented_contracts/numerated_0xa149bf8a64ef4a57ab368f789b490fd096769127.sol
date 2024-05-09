1 pragma solidity ^0.4.24;
2 /* ANCI
3 // Antrodia Cinamomum Token (ANCI)
4 // ERC20 Contract with Timelock capabilities
5 // The bigger intricate timelock mechanisms out here
6 // ---
7 // ---
8 //   _   _            _   _  _  ___ ___   ___
9 //  | |_| |_  ___    /_\ | \| |/ __|_ _| | _ \_____ __ _____ _ _
10 //  |  _| ' \/ -_)  / _ \| .` | (__ | |  |  _/ _ \ V  V / -_) '_|
11 //   \__|_||_\___| /_/ \_\_|\_|\___|___| |_| \___/\_/\_/\___|_|
12 //
13 // ---
14 // ---
15 */
16 
17 /* an owner is required */
18 contract Owned {
19     address public owner;
20 
21     function Owned() public {
22         owner = msg.sender;
23     }
24 
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     function setOwner(address _owner) onlyOwner public {
31         owner = _owner;
32     }
33 }
34 
35 /* SafeMath implementation to guard against overflows */
36 contract SafeMath {
37     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
38         uint256 c = _a + _b;
39         assert(c >= _a); // checks for overflow
40         return c;
41     }
42 
43     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
44         assert(_a >= _b); // guards against overflow
45         return _a - _b;
46     }
47 
48     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
49         uint256 c = _a * _b;
50         assert(_a == 0 || c / _a == _b); // checks for overflow
51         return c;
52     }
53 }
54 
55 /* The main contract for the timelock capable ERC20 token */
56 contract Token is SafeMath, Owned {
57     uint256 constant DAY_IN_SECONDS = 86400;
58     string public constant standard = "0.777";
59     string public name = "";
60     string public symbol = "";
61     uint8 public decimals = 0;
62     uint256 public totalSupply = 0;
63     mapping (address => uint256) public balanceP;
64     mapping (address => mapping (address => uint256)) public allowance;
65 
66     mapping (address => uint256[]) public lockTime;
67     mapping (address => uint256[]) public lockValue;
68     mapping (address => uint256) public lockNum;
69     mapping (address => bool) public locker;
70     uint256 public later = 0;
71     uint256 public earlier = 0;
72 
73 
74     /* standard ERC20 events */
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 
78     /* custom lock-related events */
79     event TransferredLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
80     event TokenUnlocked(address indexed _address, uint256 _value);
81 
82     /* ERC20 constructor */
83     function Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
84         require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
85 
86         name = _name;
87         symbol = _symbol;
88         decimals = _decimals;
89         totalSupply = _totalSupply;
90 
91         balanceP[msg.sender] = _totalSupply;
92 
93     }
94 
95     /* don't allow zero address */
96     modifier validAddress(address _address) {
97         require(_address != 0x0);
98         _;
99     }
100 
101     /* owner may add & remove optional locker contract */
102     function addLocker(address _address) public validAddress(_address) onlyOwner {
103         locker[_address] = true;
104     }
105 
106     function removeLocker(address _address) public validAddress(_address) onlyOwner {
107         locker[_address] = false;
108     }
109 
110     /* owner may fast-forward or delay ALL timelocks */
111     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
112         earlier = add(earlier, _earlier);
113     }
114 
115     function setUnlockLater(uint256 _later) public onlyOwner {
116         later = add(later, _later);
117     }
118 
119     /* shows unlocked balance */
120     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
121         _balance = balanceP[_address];
122         uint256 i = 0;
123         while (i < lockNum[_address]) {
124             if (add(now, earlier) > add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
125             i++;
126         }
127         return _balance;
128     }
129 
130     /* shows locked balance */
131     function balanceLocked(address _address) public view returns (uint256 _balance) {
132         _balance = 0;
133         uint256 i = 0;
134         while (i < lockNum[_address]) {
135             if (add(now, earlier) < add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
136             i++;
137         }
138         return  _balance;
139     }
140 
141     /* standard ERC20 compatible balance accessor */
142     function balanceOf(address _address) public view returns (uint256 _balance) {
143         _balance = balanceP[_address];
144         uint256 i = 0;
145         while (i < lockNum[_address]) {
146             _balance = add(_balance, lockValue[_address][i]);
147             i++;
148         }
149         return _balance;
150     }
151 
152     /* show the timelock periods and locked values */
153     function showTime(address _address) public view validAddress(_address) returns (uint256[] _time) {
154         uint i = 0;
155         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
156         while (i < lockNum[_address]) {
157             tempLockTime[i] = sub(add(lockTime[_address][i], later), earlier);
158             i++;
159         }
160         return tempLockTime;
161     }
162 
163     function showValue(address _address) public view validAddress(_address) returns (uint256[] _value) {
164         return lockValue[_address];
165     }
166 
167     /* calculates and handles the timelocks before related operations */
168     function calcUnlock(address _address) private {
169         uint256 i = 0;
170         uint256 j = 0;
171         uint256[] memory currentLockTime;
172         uint256[] memory currentLockValue;
173         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
174         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
175         currentLockTime = lockTime[_address];
176         currentLockValue = lockValue[_address];
177         while (i < lockNum[_address]) {
178             if (add(now, earlier) > add(currentLockTime[i], later)) {
179                 balanceP[_address] = add(balanceP[_address], currentLockValue[i]);
180 
181                 /* emit custom timelock expiration event */
182                 emit TokenUnlocked(_address, currentLockValue[i]);
183             } else {
184                 newLockTime[j] = currentLockTime[i];
185                 newLockValue[j] = currentLockValue[i];
186                 j++;
187             }
188             i++;
189         }
190         uint256[] memory trimLockTime = new uint256[](j);
191         uint256[] memory trimLockValue = new uint256[](j);
192         i = 0;
193         while (i < j) {
194             trimLockTime[i] = newLockTime[i];
195             trimLockValue[i] = newLockValue[i];
196             i++;
197         }
198         lockTime[_address] = trimLockTime;
199         lockValue[_address] = trimLockValue;
200         lockNum[_address] = j;
201     }
202 
203     /* ERC20 compliant transfer method */
204     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool success) {
205         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
206         if (balanceP[msg.sender] >= _value && _value > 0) {
207             balanceP[msg.sender] = sub(balanceP[msg.sender], _value);
208             balanceP[_to] = add(balanceP[_to], _value);
209             emit Transfer(msg.sender, _to, _value);
210             return true;
211         }
212         else {
213             return false;
214         }
215     }
216 
217     /* custom timelocked transfer method */
218     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool success) {
219         require(_value.length == _time.length);
220 
221         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
222         uint256 i = 0;
223         uint256 totalValue = 0;
224         while (i < _value.length) {
225             totalValue = add(totalValue, _value[i]);
226             i++;
227         }
228         if (balanceP[msg.sender] >= totalValue && totalValue > 0) {
229             i = 0;
230             while (i < _time.length) {
231                 balanceP[msg.sender] = sub(balanceP[msg.sender], _value[i]);
232                 lockTime[_to].length = lockNum[_to]+1;
233                 lockValue[_to].length = lockNum[_to]+1;
234                 lockTime[_to][lockNum[_to]] = add(now, _time[i]);
235                 lockValue[_to][lockNum[_to]] = _value[i];
236 
237                 /* emit custom timelock event */
238                 emit TransferredLocked(msg.sender, _to, lockTime[_to][lockNum[_to]], lockValue[_to][lockNum[_to]]);
239 
240                 /* emit standard transfer event */
241                 emit Transfer(msg.sender, _to, lockValue[_to][lockNum[_to]]);
242                 lockNum[_to]++;
243                 i++;
244             }
245             return true;
246         }
247         else {
248             return false;
249         }
250     }
251 
252     /* custom timelocker method */
253     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public
254 	    validAddress(_from) validAddress(_to) returns (bool success) {
255         require(locker[msg.sender]);
256         require(_value.length == _time.length);
257 
258         if (lockNum[_from] > 0) calcUnlock(_from);
259         uint256 i = 0;
260         uint256 totalValue = 0;
261         while (i < _value.length) {
262             totalValue = add(totalValue, _value[i]);
263             i++;
264         }
265         if (balanceP[_from] >= totalValue && totalValue > 0) {
266             i = 0;
267             while (i < _time.length) {
268                 balanceP[_from] = sub(balanceP[_from], _value[i]);
269                 lockTime[_to].length = lockNum[_to]+1;
270                 lockValue[_to].length = lockNum[_to]+1;
271                 lockTime[_to][lockNum[_to]] = add(now, _time[i]);
272                 lockValue[_to][lockNum[_to]] = _value[i];
273 
274                 /* emit custom timelock event */
275                 emit TransferredLocked(_from, _to, lockTime[_to][lockNum[_to]], lockValue[_to][lockNum[_to]]);
276 
277                 /* emit standard transfer event */
278                 emit Transfer(_from, _to, lockValue[_to][lockNum[_to]]);
279                 lockNum[_to]++;
280                 i++;
281             }
282             return true;
283         }
284         else {
285             return false;
286         }
287     }
288 
289     /* standard ERC20 compliant transferFrom method */
290     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool success) {
291         if (lockNum[_from] > 0) calcUnlock(_from);
292         if (balanceP[_from] >= _value && _value > 0) {
293             allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
294             balanceP[_from] = sub(balanceP[_from], _value);
295             balanceP[_to] = add(balanceP[_to], _value);
296             emit Transfer(_from, _to, _value);
297             return true;
298         }
299         else {
300             return false;
301         }
302     }
303 
304     /* standard ERC20 compliant approve method */
305     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool success) {
306         require(_value == 0 || allowance[msg.sender][_spender] == 0);
307 
308         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
309         allowance[msg.sender][_spender] = _value;
310         emit Approval(msg.sender, _spender, _value);
311         return true;
312     }
313 
314     /* safety method against ether transfer */
315     function () public payable {
316         revert();
317     }
318 
319 }