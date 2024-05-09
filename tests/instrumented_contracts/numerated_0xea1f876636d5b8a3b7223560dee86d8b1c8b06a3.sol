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
63 contract Pausable is Ownable {
64     event Pause();
65     event Unpause();
66     bool public paused = false;
67     
68     modifier whenNotPaused() {
69     require(!paused);
70     _;
71     }
72     modifier whenPaused() {
73     require(paused);
74     _;
75     }
76 
77     
78     function pause() onlyOwner whenNotPaused public {
79     paused = true;
80     emit Pause();
81     }
82     
83     function unpause() onlyOwner whenPaused public {
84     paused = false;
85     emit Unpause();
86     }
87 
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
159         require(_to != address(0));
160         require(_value <= balances[_from]);
161         require(_value <= allowed[_from][msg.sender]);
162     
163        balances[_from] = balances[_from].sub(_value);
164        balances[_to] = balances[_to].add(_value);
165       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166       emit Transfer(_from, _to, _value);
167     }
168 
169     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
170     if (locks[msg.sender]) {
171     autoUnlock(msg.sender);
172     }
173     
174     require(_to != address(0));
175     require(_value <= balances[msg.sender]);
176 
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     emit Transfer(msg.sender, _to, _value);
180     return true;
181     }
182 
183     function balanceOf(address _holder) public view returns (uint256 balance) {
184     return balances[_holder] + lockupInfo[_holder].lockupBalance;
185     }
186     
187     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
188 
189         if (locks[_from]) {
190         autoUnlock(_from);
191         }
192     
193     require(_to != address(0));
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196 
197     _transfer(_from, _to, _value);
198     
199     return true;
200     }
201 
202     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206     }
207     
208     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
209     require(isContract(_spender));
210     TokenRecipient spender = TokenRecipient(_spender);
211     
212         if (approve(_spender, _value)) {
213         spender.receiveApproval(msg.sender, _value, this, _extraData);
214         return true;
215         }
216     }
217     
218     function allowance(address _holder, address _spender) public view returns (uint256) {
219     return allowed[_holder][_spender];
220     }
221     
222     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
223     require(locks[_holder] == false);
224     require(balances[_holder] >= _amount);
225     balances[_holder] = balances[_holder].sub(_amount);
226     lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount);
227     
228     locks[_holder] = true;
229     emit Lock(_holder, _amount);
230     return true;
231     }
232 
233     function unlock(address _holder) public onlyOwner returns (bool) {
234     require(locks[_holder] == true);
235     uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
236     
237     delete lockupInfo[_holder];
238     locks[_holder] = false;
239     emit Unlock(_holder, releaseAmount);
240     balances[_holder] = balances[_holder].add(releaseAmount);
241     return true;
242     
243     }
244 
245     function freezeAccount(address _holder) public onlyOwner returns (bool) {
246     require(!frozen[_holder]);
247     frozen[_holder] = true;
248     emit Freeze(_holder);
249     return true;
250     }
251 
252     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
253     require(frozen[_holder]);
254     frozen[_holder] = false;
255     emit Unfreeze(_holder);
256     return true;
257     }
258 
259     function getNowTime() public view returns(uint256) {
260     return now;
261     }
262 
263     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
264     return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
265     }
266     
267    function burn(uint256 _value) public onlyOwner returns (bool success) {
268     require(_value <= balances[msg.sender]);
269     address burner = msg.sender;
270     balances[burner] = balances[burner].sub(_value);
271     totalSupply_ = totalSupply_.sub(_value);
272     emit Burn(burner, _value);
273     return true;
274     }
275 
276     function mint( uint256 _amount) onlyOwner public returns (bool) {
277     totalSupply_ = totalSupply_.add(_amount);
278     balances[owner] = balances[owner].add(_amount);
279     
280     emit Transfer(address(0), owner, _amount);
281     return true;
282     }
283 
284     function isContract(address addr) internal view returns (bool) {
285     uint size;
286     assembly{size := extcodesize(addr)}
287     return size > 0;
288     }
289 
290     function autoUnlock(address _holder) internal returns (bool) {
291         if (lockupInfo[_holder].releaseTime <= now) {
292         return releaseTimeLock(_holder);
293         }
294     
295     return false;
296     }
297 
298     function releaseTimeLock(address _holder) internal returns(bool) {
299     require(locks[_holder]);
300     uint256 releaseAmount = 0;
301 
302     for( ; lockupInfo[_holder].releaseTime <= now ; )
303     {
304     if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {
305     releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
306     delete lockupInfo[_holder];
307     locks[_holder] = false;
308     break;
309     } else {
310     releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
311     lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
312     lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
313     }
314 }
315 
316     emit Unlock(_holder, releaseAmount);
317     balances[_holder] = balances[_holder].add(releaseAmount);
318     return true;
319     }
320 
321 }