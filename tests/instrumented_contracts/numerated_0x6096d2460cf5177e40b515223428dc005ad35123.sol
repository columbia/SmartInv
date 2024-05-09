1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipRenounced(address indexed previousOwner);
37   event OwnershipTransferred(
38     address indexed previousOwner,
39     address indexed newOwner
40   );
41 
42 
43   constructor() public {
44     owner = msg.sender;
45   }
46 
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function renounceOwnership() public onlyOwner {
53     emit OwnershipRenounced(owner);
54     owner = address(0);
55   }
56 
57   function transferOwnership(address _newOwner) public onlyOwner {
58     _transferOwnership(_newOwner);
59   }
60 
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 library SafeMath {
69 
70   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
71     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
72     // benefit is lost if 'b' is also tested.
73     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74     if (_a == 0) {
75       return 0;
76     }
77 
78     c = _a * _b;
79     assert(c / _a == _b);
80     return c;
81   }
82 
83   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
84     // assert(_b > 0); // Solidity automatically throws when dividing by 0
85     // uint256 c = _a / _b;
86     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
87     return _a / _b;
88   }
89 
90   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     assert(_b <= _a);
92     return _a - _b;
93   }
94 
95   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
96     c = _a + _b;
97     assert(c >= _a);
98     return c;
99   }
100 }
101 
102 contract PreciumTokenBase is IERC20 {
103     using SafeMath for uint256;
104 
105     mapping (address => uint256) public balances_;
106     mapping (address => mapping (address => uint256)) public allowed_;
107 
108     uint256 public totalSupply_;
109 
110     function totalSupply() public view returns (uint256) {
111         return totalSupply_;
112     }
113 
114     function balanceOf(address _owner) public view returns (uint256) {
115         return balances_[_owner];
116     }
117 
118     function allowance(address _owner, address _spender) public view returns (uint256) {
119         return allowed_[_owner][_spender];
120     }
121 
122     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
123         require(_value <= balances_[_from]);
124         require(_to != address(0));
125 
126         balances_[_from] = balances_[_from].sub(_value);
127         balances_[_to] = balances_[_to].add(_value);
128         emit Transfer(_from, _to, _value);
129         
130         return true;
131     }
132 
133     function transfer(address _to, uint256 _value) public returns (bool) {
134         return _transfer(msg.sender, _to, _value);
135     }
136 
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         allowed_[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     function _transferFrom(address _from, address _to, uint256 _value) internal returns (bool) {
144         require(_value <= balances_[_from]);
145         require(_value <= allowed_[_from][msg.sender]);
146         require(_to != address(0));
147 
148         balances_[_from] = balances_[_from].sub(_value);
149         balances_[_to] = balances_[_to].add(_value);
150         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
151         emit Transfer(_from, _to, _value);
152         return true;
153     }
154 
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         return _transferFrom(_from, _to, _value);
157     }
158 
159     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
160         allowed_[msg.sender][_spender] = allowed_[msg.sender][_spender].add(_addedValue);
161         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
162         return true;
163     }
164 
165     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
166         uint256 oldValue = allowed_[msg.sender][_spender];
167         if (_subtractedValue >= oldValue) {
168             allowed_[msg.sender][_spender] = 0;
169         } else {
170             allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171         }
172         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
173         return true;
174     }
175 
176     function _burn(address _account, uint256 _amount) internal {
177         require(_account != 0);
178         require(_amount <= balances_[_account]);
179 
180         totalSupply_ = totalSupply_.sub(_amount);
181         balances_[_account] = balances_[_account].sub(_amount);
182         emit Transfer(_account, address(0), _amount);
183     }
184     
185     function burn(uint256 _amount) public {
186         _burn(msg.sender, _amount);
187     }
188 }
189 
190 contract PreciumToken is PreciumTokenBase, Ownable {
191 
192     string public name;
193     string public symbol;
194     uint256 public decimals = 18;
195     struct lockInfo {
196         uint256 lockQuantity;
197         uint lockPeriod;
198     }
199     mapping (address => lockInfo[]) public tokenLockInfo;
200     mapping (address => uint256) public unlockQuantity;
201     mapping (address => bool) public lockStatus;
202     mapping (address => bool) private FreezedWallet;
203 
204     function PreciumToken(uint256 initialSupply, string tokenName, uint256 decimalsToken, string tokenSymbol) public {
205         decimals = decimalsToken;
206         totalSupply_ = initialSupply * 10 ** uint256(decimals);
207         emit Transfer(0, msg.sender, totalSupply_);
208         balances_[msg.sender] = totalSupply_;
209         name = tokenName;
210         symbol = tokenSymbol;
211         unlockQuantity[msg.sender] = balances_[msg.sender];
212     }
213 
214     function transfer(address _to, uint256 _value) public returns (bool) {
215 
216         bool transferResult;
217         uint256 lockQuantity;
218         uint256 lockTotalQuantity;
219         uint lockPeriod;
220 
221         require(FreezedWallet[msg.sender] == false);
222         require(FreezedWallet[_to] == false);
223         
224         if(lockStatus[msg.sender] == false) {
225             transferResult = _transfer(msg.sender, _to, _value);
226             if (transferResult == true) {
227                 unlockQuantity[msg.sender] = unlockQuantity[msg.sender].sub(_value);
228                 unlockQuantity[_to] = unlockQuantity[_to].add(_value);
229             }
230         }
231         else{
232             for(uint i = 0; i < tokenLockInfo[msg.sender].length; i++) {
233                 lockQuantity = tokenLockInfo[msg.sender][i].lockQuantity;
234                 lockPeriod = tokenLockInfo[msg.sender][i].lockPeriod;
235 
236                 if(lockPeriod <= now && lockQuantity != 0) {
237                     unlockQuantity[msg.sender] = unlockQuantity[msg.sender].add(lockQuantity);
238                     tokenLockInfo[msg.sender][i].lockQuantity = 0;
239                     lockQuantity = tokenLockInfo[msg.sender][i].lockQuantity;
240                 }
241                 lockTotalQuantity = lockTotalQuantity.add(lockQuantity);
242             }
243             if(lockTotalQuantity == 0)
244                 lockStatus[msg.sender] = false;
245                     
246             require(_value <= unlockQuantity[msg.sender]);
247             
248             transferResult = _transfer(msg.sender, _to, _value);
249             if (transferResult == true) {
250                 unlockQuantity[msg.sender] = unlockQuantity[msg.sender].sub(_value);
251                 unlockQuantity[_to] = unlockQuantity[_to].add(_value);
252             }
253         }
254         
255         return transferResult;
256     }
257     
258     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
259         
260         bool transferResult;
261         uint256 lockQuantity;
262         uint256 lockTotalQuantity;
263         uint lockPeriod;
264         
265         require(FreezedWallet[_from] == false);
266         require(FreezedWallet[_to] == false);
267         
268         if(lockStatus[_from] == false) {
269             transferResult = _transferFrom(_from, _to, _value);
270             if (transferResult == true) {
271                 unlockQuantity[_from] = unlockQuantity[_from].sub(_value);
272                 unlockQuantity[_to] = unlockQuantity[_to].add(_value);
273             }
274         }
275         else{
276             for(uint i = 0; i < tokenLockInfo[_from].length; i++) {
277                 lockQuantity = tokenLockInfo[_from][i].lockQuantity;
278                 lockPeriod = tokenLockInfo[_from][i].lockPeriod;
279 
280                 if(lockPeriod <= now && lockQuantity != 0) {
281                     unlockQuantity[_from] = unlockQuantity[_from].add(lockQuantity);
282                     tokenLockInfo[_from][i].lockQuantity = 0;
283                     lockQuantity = tokenLockInfo[_from][i].lockQuantity;
284                 }
285                 lockTotalQuantity = lockTotalQuantity.add(lockQuantity);
286             }
287             if(lockTotalQuantity == 0)
288                 lockStatus[_from] = false;
289                     
290             require(_value <= unlockQuantity[_from]);
291             
292             transferResult = _transferFrom(_from, _to, _value);
293             if (transferResult == true) {
294                 unlockQuantity[_from] = unlockQuantity[_from].sub(_value);
295                 unlockQuantity[_to] = unlockQuantity[_to].add(_value);
296             }
297         }
298         
299         return transferResult;
300     }
301 
302     function transferAndLock(address _to, uint256 _value, uint _lockPeriod) onlyOwner public {
303        
304         bool transferResult;
305         
306         require(FreezedWallet[_to] == false);
307         
308         transferResult = _transfer(msg.sender, _to, _value);
309         if (transferResult == true) {
310             lockStatus[_to] = true;
311             tokenLockInfo[_to].push(lockInfo(_value, now + _lockPeriod * 1 days ));
312             unlockQuantity[msg.sender] = unlockQuantity[msg.sender].sub(_value);
313         }
314     }
315 
316     function changeLockPeriod(address _owner, uint256 _index, uint _newLockPeriod) onlyOwner public {
317         
318         require(_index < tokenLockInfo[_owner].length);
319         
320         tokenLockInfo[_owner][_index].lockPeriod = now + _newLockPeriod * 1 days;
321     }
322     
323     function freezingWallet(address _owner) onlyOwner public {
324         
325         FreezedWallet[_owner] = true;
326     }
327     
328     function unfreezingWallet(address _owner) onlyOwner public {
329         
330         FreezedWallet[_owner] = false;
331     }
332     
333     function burn(uint256 _amount) onlyOwner public {
334         
335         _burn(msg.sender, _amount);
336         unlockQuantity[msg.sender] = unlockQuantity[msg.sender].sub(_amount);
337     }
338 
339     function getNowTime() view public returns(uint res) {
340         
341         return now;
342     }
343 
344     function getLockInfo(address _owner, uint256 _index) view public returns(uint256, uint) {
345         
346         return (tokenLockInfo[_owner][_index].lockQuantity, tokenLockInfo[_owner][_index].lockPeriod);
347     }
348 
349     function getUnlockQuantity(address _owner) view public returns(uint res) {
350         
351         return unlockQuantity[_owner];
352     }
353     
354     function getLockStatus(address _owner) view public returns(bool res) {
355         
356         return lockStatus[_owner];
357     }
358     
359     function getLockCount(address _owner) view public returns(uint res) {
360         
361         return tokenLockInfo[_owner].length;
362     }
363     
364     function getFreezingInfo(address _owner) view public returns(bool res) {
365         
366         return FreezedWallet[_owner];
367     }
368 }