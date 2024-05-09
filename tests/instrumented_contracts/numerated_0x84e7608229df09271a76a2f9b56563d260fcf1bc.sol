1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5 
6     function Owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function setOwner(address _owner) onlyOwner public {
16         owner = _owner;
17     }
18 }
19 
20 contract SafeMath {
21     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
22         uint256 c = _a + _b;
23         assert(c >= _a);
24         return c;
25     }
26 
27     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
28         assert(_a >= _b);
29         return _a - _b;
30     }
31 
32     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
33         uint256 c = _a * _b;
34         assert(_a == 0 || c / _a == _b);
35         return c;
36     }
37 }
38 
39 contract Token is SafeMath, Owned {
40     uint256 constant DAY_IN_SECONDS = 86400;
41     string public constant standard = "0.66";
42     string public name = "";
43     string public symbol = "";
44     uint8 public decimals = 0;
45     uint256 public totalSupply = 0;
46     mapping (address => uint256) public balanceP;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     mapping (address => uint256[]) public lockTime;
50     mapping (address => uint256[]) public lockValue;
51     mapping (address => uint256) public lockNum;
52     mapping (address => bool) public locker;
53     uint256 public later = 0;
54     uint256 public earlier = 0;
55 
56 
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59     event TransferredLocked(address indexed _from, address indexed _to, uint256 _time, uint256 _value);
60     event TokenUnlocked(address indexed _address, uint256 _value);
61 
62     function Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
63         require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
64 
65         name = _name;
66         symbol = _symbol;
67         decimals = _decimals;
68         totalSupply = _totalSupply;
69 
70         balanceP[msg.sender] = _totalSupply;
71 
72     }
73 
74     modifier validAddress(address _address) {
75         require(_address != 0x0);
76         _;
77     }
78 
79     function addLocker(address _address) public validAddress(_address) onlyOwner {
80         locker[_address] = true;
81     }
82 
83     function removeLocker(address _address) public validAddress(_address) onlyOwner {
84         locker[_address] = false;
85     }
86 
87     function setUnlockEarlier(uint256 _earlier) public onlyOwner {
88         earlier = add(earlier, _earlier);
89     }
90 
91     function setUnlockLater(uint256 _later) public onlyOwner {
92         later = add(later, _later);
93     }
94 
95     function balanceUnlocked(address _address) public view returns (uint256 _balance) {
96         _balance = balanceP[_address];
97         uint256 i = 0;
98         while (i < lockNum[_address]) {
99             if (add(now, earlier) > add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
100             i++;
101         }
102         return _balance;
103     }
104 
105     function balanceLocked(address _address) public view returns (uint256 _balance) {
106         _balance = 0;
107         uint256 i = 0;
108         while (i < lockNum[_address]) {
109             if (add(now, earlier) < add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
110             i++;
111         }
112         return  _balance;
113     }
114 
115     function balanceOf(address _address) public view returns (uint256 _balance) {
116         _balance = balanceP[_address];
117         uint256 i = 0;
118         while (i < lockNum[_address]) {
119             _balance = add(_balance, lockValue[_address][i]);
120             i++;
121         }
122         return _balance;
123     }
124 
125     function showTime(address _address) public view validAddress(_address) returns (uint256[] _time) {
126         uint i = 0;
127         uint256[] memory tempLockTime = new uint256[](lockNum[_address]);
128         while (i < lockNum[_address]) {
129             tempLockTime[i] = sub(add(lockTime[_address][i], later), earlier);
130             i++;
131         }
132         return tempLockTime;
133     }
134 
135     function showValue(address _address) public view validAddress(_address) returns (uint256[] _value) {
136         return lockValue[_address];
137     }
138 
139     function calcUnlock(address _address) private {
140         uint256 i = 0;
141         uint256 j = 0;
142         uint256[] memory currentLockTime;
143         uint256[] memory currentLockValue;
144         uint256[] memory newLockTime = new uint256[](lockNum[_address]);
145         uint256[] memory newLockValue = new uint256[](lockNum[_address]);
146         currentLockTime = lockTime[_address];
147         currentLockValue = lockValue[_address];
148         while (i < lockNum[_address]) {
149             if (add(now, earlier) > add(currentLockTime[i], later)) {
150                 balanceP[_address] = add(balanceP[_address], currentLockValue[i]);
151                 emit TokenUnlocked(_address, currentLockValue[i]);
152             } else {
153                 newLockTime[j] = currentLockTime[i];
154                 newLockValue[j] = currentLockValue[i];
155                 j++;
156             }
157             i++;
158         }
159         uint256[] memory trimLockTime = new uint256[](j);
160         uint256[] memory trimLockValue = new uint256[](j);
161         i = 0;
162         while (i < j) {
163             trimLockTime[i] = newLockTime[i];
164             trimLockValue[i] = newLockValue[i];
165             i++;
166         }
167         lockTime[_address] = trimLockTime;
168         lockValue[_address] = trimLockValue;
169         lockNum[_address] = j;
170     }
171 
172     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool success) {
173         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
174         if (balanceP[msg.sender] >= _value && _value > 0) {
175             balanceP[msg.sender] = sub(balanceP[msg.sender], _value);
176             balanceP[_to] = add(balanceP[_to], _value);
177             emit Transfer(msg.sender, _to, _value);
178             return true;
179         }
180         else {
181             return false;
182         }
183     }
184 
185     function transferLocked(address _to, uint256[] _time, uint256[] _value) public validAddress(_to) returns (bool success) {
186         require(_value.length == _time.length);
187 
188         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
189         uint256 i = 0;
190         uint256 totalValue = 0;
191         while (i < _value.length) {
192             totalValue = add(totalValue, _value[i]);
193             i++;
194         }
195         if (balanceP[msg.sender] >= totalValue && totalValue > 0) {
196             i = 0;
197             while (i < _time.length) {
198                 balanceP[msg.sender] = sub(balanceP[msg.sender], _value[i]);
199                 lockTime[_to].length = lockNum[_to]+1;
200                 lockValue[_to].length = lockNum[_to]+1;
201                 lockTime[_to][lockNum[_to]] = add(now, _time[i]);
202                 lockValue[_to][lockNum[_to]] = _value[i];
203                 emit TransferredLocked(msg.sender, _to, lockTime[_to][lockNum[_to]], lockValue[_to][lockNum[_to]]);
204                 emit Transfer(msg.sender, _to, lockValue[_to][lockNum[_to]]);
205                 lockNum[_to]++;
206                 i++;
207             }
208             return true;
209         }
210         else {
211             return false;
212         }
213     }
214 
215     function transferLockedFrom(address _from, address _to, uint256[] _time, uint256[] _value) public 
216 	    validAddress(_from) validAddress(_to) returns (bool success) {
217         require(locker[msg.sender]);
218         require(_value.length == _time.length);
219 
220         if (lockNum[_from] > 0) calcUnlock(_from);
221         uint256 i = 0;
222         uint256 totalValue = 0;
223         while (i < _value.length) {
224             totalValue = add(totalValue, _value[i]);
225             i++;
226         }
227         if (balanceP[_from] >= totalValue && totalValue > 0) {
228             i = 0;
229             while (i < _time.length) {
230                 balanceP[_from] = sub(balanceP[_from], _value[i]);
231                 lockTime[_to].length = lockNum[_to]+1;
232                 lockValue[_to].length = lockNum[_to]+1;
233                 lockTime[_to][lockNum[_to]] = add(now, _time[i]);
234                 lockValue[_to][lockNum[_to]] = _value[i];
235                 emit TransferredLocked(_from, _to, lockTime[_to][lockNum[_to]], lockValue[_to][lockNum[_to]]);
236                 emit Transfer(_from, _to, lockValue[_to][lockNum[_to]]);
237                 lockNum[_to]++;
238                 i++;
239             }
240             return true;
241         }
242         else {
243             return false;
244         }
245     }
246 
247     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool success) {
248         if (lockNum[_from] > 0) calcUnlock(_from);
249         if (balanceP[_from] >= _value && _value > 0) {
250             allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
251             balanceP[_from] = sub(balanceP[_from], _value);
252             balanceP[_to] = add(balanceP[_to], _value);
253             emit Transfer(_from, _to, _value);
254             return true;
255         }
256         else {
257             return false;
258         }
259     }
260 
261     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool success) {
262         require(_value == 0 || allowance[msg.sender][_spender] == 0);
263 
264         if (lockNum[msg.sender] > 0) calcUnlock(msg.sender);
265         allowance[msg.sender][_spender] = _value;
266         emit Approval(msg.sender, _spender, _value);
267         return true;
268     }
269 
270     function () public payable {
271         revert();
272     }
273 
274 }