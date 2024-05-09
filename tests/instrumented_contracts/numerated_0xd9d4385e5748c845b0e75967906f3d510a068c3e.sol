1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6     if (_a == 0) {
7     return 0;
8     }
9     uint256 c = _a * _b;
10     assert(c / _a == _b);
11     return c;
12     }
13 
14     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
15     uint256 c = _a / _b;
16     return c;
17     }
18 
19     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20     assert(_b <= _a);
21     return _a - _b;
22     }
23 
24     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     uint256 c = _a + _b;
26     assert(c >= _a);
27     return c;
28     }
29 }
30 
31 contract Ownable {
32     address public owner;
33     address public newOwner;
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     constructor() public {
37     owner = msg.sender;
38     newOwner = address(0);
39     }
40 
41     modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44     }
45 
46     modifier onlyNewOwner() {
47     require(msg.sender != address(0));
48     require(msg.sender == newOwner);
49     _;
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53     require(_newOwner != address(0));
54     newOwner = _newOwner;
55     }
56     
57     function acceptOwnership() public onlyNewOwner returns(bool) {
58     emit OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60     }
61 }
62 
63 
64 contract Pausable is Ownable {
65     event Pause();
66     event Unpause();
67     bool public paused = false;
68     
69     modifier whenNotPaused() {
70     require(!paused);
71     _;
72     }
73     modifier whenPaused() {
74     require(paused);
75     _;
76     }
77 
78     
79     function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     emit Pause();
82     }
83     
84     function unpause() onlyOwner whenPaused public {
85     paused = false;
86     emit Unpause();
87     }
88 }
89 
90 contract ERC20 {
91     function totalSupply() public view returns (uint256);
92     function balanceOf(address who) public view returns (uint256);
93     function allowance(address owner, address spender) public view returns (uint256);
94     function transfer(address to, uint256 value) public returns (bool);
95     function transferFrom(address from, address to, uint256 value) public returns (bool);
96     function approve(address spender, uint256 value) public returns (bool);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 interface TokenRecipient {
102  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
103 }
104 
105 contract GoMoney is ERC20, Ownable, Pausable {
106     uint128 internal MONTH = 30 * 24 * 3600;
107     using SafeMath for uint256;
108     
109     struct LockupInfo {
110     uint256 releaseTime;
111     uint256 termOfRound;
112     uint256 unlockAmountPerRound;
113     uint256 lockupBalance;
114     }
115     
116     string public name;
117     string public symbol;
118     uint8 public decimals;
119     uint256 internal initialSupply;
120     uint256 internal totalSupply_;
121     
122     mapping(address => uint256) internal balances;
123     mapping(address => bool) internal locks;
124     mapping(address => bool) public frozen;
125     mapping(address => mapping(address => uint256)) internal allowed;
126     mapping(address => LockupInfo) internal lockupInfo;
127     
128     event Unlock(address indexed holder, uint256 value);
129     event Lock(address indexed holder, uint256 value);
130     event Burn(address indexed owner, uint256 value);
131     event Mint(uint256 value);
132     event Freeze(address indexed holder);
133     event Unfreeze(address indexed holder);
134     
135     modifier notFrozen(address _holder) {
136     require(!frozen[_holder]);
137     _;
138     }
139 
140     constructor() public {
141     name = "GoMoney";
142     symbol = "GOM";
143     decimals = 0;
144     initialSupply = 10000000000;
145     totalSupply_ = 10000000000;
146     balances[owner] = totalSupply_;
147     emit Transfer(address(0), owner, totalSupply_);
148     }
149 
150     function () public payable {
151     revert();
152     }
153 
154     function totalSupply() public view returns (uint256) {
155     return totalSupply_;
156     }
157 
158     function _transfer(address _from, address _to, uint _value) internal {
159         // Prevent transfer to 0x0 address. Use burn() instead
160        
161         require(_to != address(0));
162         require(_value <= balances[_from]);
163         require(_value <= allowed[_from][msg.sender]);
164     
165        balances[_from] = balances[_from].sub(_value);
166        balances[_to] = balances[_to].add(_value);
167       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168       emit Transfer(_from, _to, _value);
169     }
170     
171     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
172     
173     if (locks[msg.sender]) {
174     autoUnlock(msg.sender);
175     }
176     
177     require(_to != address(0));
178     require(_value <= balances[msg.sender]);
179 
180     balances[msg.sender] = balances[msg.sender].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     emit Transfer(msg.sender, _to, _value);
183     return true;
184     }
185 
186     function balanceOf(address _holder) public view returns (uint256 balance) {
187     return balances[_holder] + lockupInfo[_holder].lockupBalance;
188     }
189     
190     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
191 
192         if (locks[_from]) {
193         autoUnlock(_from);
194         }
195     
196     require(_to != address(0));
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199 
200     _transfer(_from, _to, _value);
201     
202     return true;
203     }
204 
205     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     emit Approval(msg.sender, _spender, _value);
208     return true;
209     }
210     
211     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
212     require(isContract(_spender));
213     TokenRecipient spender = TokenRecipient(_spender);
214     
215         if (approve(_spender, _value)) {
216         spender.receiveApproval(msg.sender, _value, this, _extraData);
217         return true;
218         }
219     }
220 
221     function allowance(address _holder, address _spender) public view returns (uint256) {
222     return allowed[_holder][_spender];
223     }
224 
225     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
226     require(locks[_holder] == false);
227     require(balances[_holder] >= _amount);
228     balances[_holder] = balances[_holder].sub(_amount);
229     lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount);
230     
231     locks[_holder] = true;
232     emit Lock(_holder, _amount);
233     return true;
234     }
235 
236     function unlock(address _holder) public onlyOwner returns (bool) {
237     require(locks[_holder] == true);
238     uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
239     
240     delete lockupInfo[_holder];
241     locks[_holder] = false;
242     emit Unlock(_holder, releaseAmount);
243     balances[_holder] = balances[_holder].add(releaseAmount);
244     return true;
245     }
246 
247     function freezeAccount(address _holder) public onlyOwner returns (bool) {
248     require(!frozen[_holder]);
249     frozen[_holder] = true;
250     emit Freeze(_holder);
251     return true;
252     }
253 
254     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
255     require(frozen[_holder]);
256     frozen[_holder] = false;
257     emit Unfreeze(_holder);
258     return true;
259     }
260 
261     function getNowTime() public view returns(uint256) {
262     return now;
263     }
264 
265     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
266     return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
267     }
268 
269    function burn(uint256 _value) public onlyOwner returns (bool success) {
270     require(_value <= balances[msg.sender]);
271     address burner = msg.sender;
272     balances[burner] = balances[burner].sub(_value);
273     totalSupply_ = totalSupply_.sub(_value);
274     emit Burn(burner, _value);
275     return true;
276     }
277 
278     function mint( uint256 _amount) onlyOwner public returns (bool) {
279     totalSupply_ = totalSupply_.add(_amount);
280     balances[owner] = balances[owner].add(_amount);
281     
282     emit Transfer(address(0), owner, _amount);
283     return true;
284     }
285 
286     function isContract(address addr) internal view returns (bool) {
287     uint size;
288     assembly{size := extcodesize(addr)}
289     return size > 0;
290     }
291 
292     function autoUnlock(address _holder) internal returns (bool) {
293         if (lockupInfo[_holder].releaseTime <= now) {
294         return releaseTimeLock(_holder);
295         }
296     
297     return false;
298     }
299 
300 
301     function releaseTimeLock(address _holder) internal returns(bool) {
302     require(locks[_holder]);
303     uint256 releaseAmount = 0;
304     
305     for( ; lockupInfo[_holder].releaseTime <= now ; )
306     {
307     if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {
308     releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
309     delete lockupInfo[_holder];
310     locks[_holder] = false;
311     break;
312     } else {
313     releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
314     lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
315     lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
316     }
317     }
318     emit Unlock(_holder, releaseAmount);
319     balances[_holder] = balances[_holder].add(releaseAmount);
320     return true;
321     }
322 }