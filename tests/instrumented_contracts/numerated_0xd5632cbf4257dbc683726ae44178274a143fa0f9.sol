1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
5     if (_a == 0) {
6       return 0;
7     }
8     uint256 c = _a * _b;
9     assert(c / _a == _b);
10     return c;
11   }
12 
13   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // assert(_b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = _a / _b;
16     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
17     return c;
18   }
19   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20     assert(_b <= _a);
21     return _a - _b;
22   }
23 
24   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     uint256 c = _a + _b;
26     assert(c >= _a);
27     return c;
28   }
29 }
30 
31 contract Ownable {
32     address public owner;
33     address public newOwner;
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35     constructor() public {
36         owner = msg.sender;
37         newOwner = address(0);
38     }
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43     modifier onlyNewOwner() {
44         require(msg.sender != address(0));
45         require(msg.sender == newOwner);
46         _;
47     }
48     function transferOwnership(address _newOwner) public onlyOwner {
49 
50         require(_newOwner != address(0));
51 newOwner = _newOwner;
52     }
53     function acceptOwnership() public onlyNewOwner returns(bool) {
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56     }
57 }
58 contract Pausable is Ownable {
59   event Pause();
60   event Unpause();
61   bool public paused = false;
62   modifier whenNotPaused() {
63     require(!paused);
64 
65     _;
66  }
67   modifier whenPaused() {
68     require(paused);
69     _;
70 
71   }
72   function pause() onlyOwner whenNotPaused public {
73     paused = true;
74     emit Pause();
75   }
76 
77   function unpause() onlyOwner whenPaused public {
78     paused = false;
79     emit Unpause();
80   }
81 }
82 
83 contract ERC20 {
84     function totalSupply() public view returns (uint256);
85     function balanceOf(address who) public view returns (uint256);
86     function allowance(address owner, address spender) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 interface TokenRecipient {
95     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
96 }
97 
98 contract OreOreCoin is ERC20, Ownable, Pausable {
99     uint128 internal MONTH = 30 * 24 * 3600; // 1 month
100     using SafeMath for uint256;
101 
102     struct LockupInfo {
103         uint256 releaseTime;
104         uint256 termOfRound;
105         uint256 unlockAmountPerRound;        
106         uint256 lockupBalance;
107     }
108     string public name;
109     string public symbol;
110     uint8 public decimals;
111     uint256 internal initialSupply;
112     uint256 internal totalSupply_;
113 
114     mapping(address => uint256) internal balances;
115     mapping(address => bool) internal locks;
116     mapping(address => bool) public frozen;
117     mapping(address => mapping(address => uint256)) internal allowed;
118     mapping(address => LockupInfo) internal lockupInfo;
119 
120     event Unlock(address indexed holder, uint256 value);
121     event Lock(address indexed holder, uint256 value);
122     event Burn(address indexed owner, uint256 value);
123     event Mint(uint256 value);
124     event Freeze(address indexed holder);
125     event Unfreeze(address indexed holder);
126 
127     modifier notFrozen(address _holder) {
128         require(!frozen[_holder]);
129         _;
130     }
131     constructor() public {
132         name = "OreOreCoin";
133         symbol = "OOC";
134         decimals = 0;
135         initialSupply = 1000000;
136         totalSupply_ = 1000000;
137         balances[owner] = totalSupply_;
138         emit Transfer(address(0), owner, totalSupply_);
139 
140     }
141     function () public payable {
142         revert();
143     }
144     function totalSupply() public view returns (uint256) {
145         return totalSupply_;
146     }
147 
148     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
149         if (locks[msg.sender]) {
150             autoUnlock(msg.sender);            
151         }
152         require(_to != address(0));
153         require(_value <= balances[msg.sender]);
154 
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         emit Transfer(msg.sender, _to, _value);
158         return true;
159     }
160     function balanceOf(address _holder) public view returns (uint256 balance) {
161         return balances[_holder] + lockupInfo[_holder].lockupBalance;
162     }
163 
164     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
165         if (locks[_from]) {
166             autoUnlock(_from);            
167         }
168         require(_to != address(0));
169 
170         require(_value <= balances[_from]);
171         require(_value <= allowed[_from][msg.sender]);
172         balances[_from] = balances[_from].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175         emit Transfer(_from, _to, _value);
176         return true;
177     }
178 
179     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         emit Approval(msg.sender, _spender, _value);
182         return true;
183 
184     }
185     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
186         require(isContract(_spender));
187         TokenRecipient spender = TokenRecipient(_spender);
188         if (approve(_spender, _value)) {
189             spender.receiveApproval(msg.sender, _value, this, _extraData);
190             return true;
191         }
192     }
193 
194     function allowance(address _holder, address _spender) public view returns (uint256) {
195         return allowed[_holder][_spender];
196     }
197 
198     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
199         require(locks[_holder] == false);
200         require(balances[_holder] >= _amount);
201         balances[_holder] = balances[_holder].sub(_amount);
202         lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount);
203 
204         locks[_holder] = true;
205         emit Lock(_holder, _amount);
206         return true;
207 
208     }
209 
210     function unlock(address _holder) public onlyOwner returns (bool) {
211         require(locks[_holder] == true);
212         uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
213 
214 
215 
216         delete lockupInfo[_holder];
217         locks[_holder] = false;
218         emit Unlock(_holder, releaseAmount);
219         balances[_holder] = balances[_holder].add(releaseAmount);
220         return true;
221     }
222 
223     function freezeAccount(address _holder) public onlyOwner returns (bool) {
224         require(!frozen[_holder]);
225         frozen[_holder] = true;
226         emit Freeze(_holder);
227         return true;
228     }
229 
230     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
231         require(frozen[_holder]);
232         frozen[_holder] = false;
233         emit Unfreeze(_holder);
234         return true;
235     }
236 
237 
238 
239     function getNowTime() public view returns(uint256) {
240       return now;
241     }
242 
243 
244 
245     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
246         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
247     }
248 
249 
250 
251     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
252 
253         require(_to != address(0));
254 
255         require(_value <= balances[owner]);
256         balances[owner] = balances[owner].sub(_value);
257         balances[_to] = balances[_to].add(_value);
258         emit Transfer(owner, _to, _value);
259         return true;
260     }
261 
262 
263 
264     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
265         distribute(_to, _value);
266         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
267         return true;
268     }
269 
270 
271     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
272         token.transfer(_to, _value);
273         return true;
274     }
275 
276 
277     function burn(uint256 _value) public onlyOwner returns (bool success) {
278         require(_value <= balances[msg.sender]);
279         address burner = msg.sender;
280         balances[burner] = balances[burner].sub(_value);
281         totalSupply_ = totalSupply_.sub(_value);
282         emit Burn(burner, _value);
283         return true;
284 
285     }
286 
287 
288 
289     function mint( uint256 _amount) onlyOwner public returns (bool) {
290         totalSupply_ = totalSupply_.add(_amount);
291         balances[owner] = balances[owner].add(_amount);
292         emit Transfer(address(0), owner, _amount);
293         return true;
294     }
295     function isContract(address addr) internal view returns (bool) {
296         uint size;
297         assembly{size := extcodesize(addr)}
298         return size > 0;
299     }
300     function autoUnlock(address _holder) internal returns (bool) {
301         if (lockupInfo[_holder].releaseTime <= now) {
302             return releaseTimeLock(_holder);
303         }
304         return false;
305     }
306     function releaseTimeLock(address _holder) internal returns(bool) {
307 
308         require(locks[_holder]);
309 
310         uint256 releaseAmount = 0;
311        
312         for( ; lockupInfo[_holder].releaseTime <= now ; )
313         {
314             if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {   
315                 releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
316                 delete lockupInfo[_holder];
317                 locks[_holder] = false;
318                 break;             
319 
320             } else {
321                 releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
322                 lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
323                 lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
324             }            
325         }
326         emit Unlock(_holder, releaseAmount);
327         balances[_holder] = balances[_holder].add(releaseAmount);
328         return true;
329     }
330 }