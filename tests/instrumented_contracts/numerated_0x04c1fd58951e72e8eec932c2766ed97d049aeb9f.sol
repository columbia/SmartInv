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
31 
32 contract Ownable {
33     address public owner;
34     address public newOwner;
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() public {
38     owner = msg.sender;
39     newOwner = address(0);
40     }
41 
42     modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45     }
46 
47     modifier onlyNewOwner() {
48     require(msg.sender != address(0));
49     require(msg.sender == newOwner);
50     _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54     require(_newOwner != address(0));
55     newOwner = _newOwner;
56     }
57     
58     function acceptOwnership() public onlyNewOwner returns(bool) {
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61     }
62 }
63 
64 
65 contract Pausable is Ownable {
66     event Pause();
67     event Unpause();
68     bool public paused = false;
69     
70     modifier whenNotPaused() {
71     require(!paused);
72     _;
73     }
74     modifier whenPaused() {
75     require(paused);
76     _;
77     }
78 
79     
80     function pause() onlyOwner whenNotPaused public {
81     paused = true;
82     emit Pause();
83     }
84     
85     
86     function unpause() onlyOwner whenPaused public {
87     paused = false;
88     emit Unpause();
89     }
90 
91 }
92 
93  
94 
95 contract ERC20 {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function allowance(address owner, address spender) public view returns (uint256);
99     function transfer(address to, uint256 value) public returns (bool);
100     function transferFrom(address from, address to, uint256 value) public returns (bool);
101     function approve(address spender, uint256 value) public returns (bool);
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106  
107 
108 interface TokenRecipient {
109  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
110 }
111 
112  
113 
114 contract RyangCoin is ERC20, Ownable, Pausable {
115     uint128 internal MONTH = 30 * 24 * 3600;
116     using SafeMath for uint256;
117     
118     
119     struct LockupInfo {
120     uint256 releaseTime;
121     uint256 termOfRound;
122     uint256 unlockAmountPerRound;
123     uint256 lockupBalance;
124     }
125     
126     string public name;
127     string public symbol;
128     uint8 public decimals;
129     uint256 internal initialSupply;
130     uint256 internal totalSupply_;
131     
132     mapping(address => uint256) internal balances;
133     mapping(address => bool) internal locks;
134     mapping(address => bool) public frozen;
135     mapping(address => mapping(address => uint256)) internal allowed;
136     mapping(address => LockupInfo) internal lockupInfo;
137     
138     event Unlock(address indexed holder, uint256 value);
139     event Lock(address indexed holder, uint256 value);
140     event Burn(address indexed owner, uint256 value);
141     event Mint(uint256 value);
142     event Freeze(address indexed holder);
143     event Unfreeze(address indexed holder);
144     
145     modifier notFrozen(address _holder) {
146     require(!frozen[_holder]);
147     _;
148     }
149 
150     constructor() public {
151     name = "RyangCoin";
152     symbol = "RYC";
153     decimals = 0;
154     initialSupply = 10000000000;
155     totalSupply_ = 10000000000;
156     balances[owner] = totalSupply_;
157     emit Transfer(address(0), owner, totalSupply_);
158     }
159 
160     function () public payable {
161     revert();
162     }
163 
164     function totalSupply() public view returns (uint256) {
165     return totalSupply_;
166     }
167 
168     function _transfer(address _from, address _to, uint _value) internal {
169        
170         require(_to != address(0));
171         require(_value <= balances[_from]);
172         require(_value <= allowed[_from][msg.sender]);
173     
174        balances[_from] = balances[_from].sub(_value);
175        balances[_to] = balances[_to].add(_value);
176       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177       emit Transfer(_from, _to, _value);
178     }
179     
180     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
181     
182     if (locks[msg.sender]) {
183     autoUnlock(msg.sender);
184     }
185     
186     require(_to != address(0));
187     require(_value <= balances[msg.sender]);
188     
189     balances[msg.sender] = balances[msg.sender].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     emit Transfer(msg.sender, _to, _value);
192     return true;
193     }
194 
195     function balanceOf(address _holder) public view returns (uint256 balance) {
196     return balances[_holder] + lockupInfo[_holder].lockupBalance;
197     }
198     
199     function sendwithgas (address _from, address _to, uint256 _value, uint256 _fee) public whenNotPaused notFrozen(_from) returns (bool) {
200         if(locks[_from]){
201             autoUnlock(_from);
202         }
203         require(_to != address(0));
204         require(_value <= balances[_from]);
205         balances[msg.sender] = balances[msg.sender].add(_fee);
206         balances[_from] = balances[_from].sub(_value + _fee);
207         balances[_to] = balances[_to].add(_value);
208         emit Transfer(_from, _to, _value);
209         emit Transfer(_from, msg.sender, _value);
210         
211         return true;
212     }
213      
214     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from) returns (bool) {
215 
216         if (locks[_from]) {
217         autoUnlock(_from);
218         }
219     
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223 
224     _transfer(_from, _to, _value);
225     
226     return true;
227     }
228     
229     
230 
231     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     emit Approval(msg.sender, _spender, _value);
234     return true;
235     }
236 
237     function allowance(address _holder, address _spender) public view returns (uint256) {
238     return allowed[_holder][_spender];
239     }
240 
241     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
242     require(locks[_holder] == false);
243     require(balances[_holder] >= _amount);
244     balances[_holder] = balances[_holder].sub(_amount);
245     lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount);
246     
247     locks[_holder] = true;
248     emit Lock(_holder, _amount);
249     return true;
250     } 
251 
252     function unlock(address _holder) public onlyOwner returns (bool) {
253     require(locks[_holder] == true);
254     uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
255     
256     delete lockupInfo[_holder];
257     locks[_holder] = false;
258     emit Unlock(_holder, releaseAmount);
259     balances[_holder] = balances[_holder].add(releaseAmount);
260     return true;
261     
262     }
263 
264  
265     function freezeAccount(address _holder) public onlyOwner returns (bool) {
266     require(!frozen[_holder]);
267     frozen[_holder] = true;
268     emit Freeze(_holder);
269     return true;
270     }
271 
272  
273 
274     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
275     require(frozen[_holder]);
276     frozen[_holder] = false;
277     emit Unfreeze(_holder);
278     return true;
279     }
280 
281  
282 
283     function getNowTime() public view returns(uint256) {
284     return now;
285     }
286 
287 
288     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
289     return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
290     }
291     
292     
293    function burn(uint256 _value) public onlyOwner returns (bool success) {
294     require(_value <= balances[msg.sender]);
295     address burner = msg.sender;
296     balances[burner] = balances[burner].sub(_value);
297     totalSupply_ = totalSupply_.sub(_value);
298     emit Burn(burner, _value);
299     return true;
300     }
301 
302  
303     function mint( uint256 _amount) onlyOwner public returns (bool) {
304     totalSupply_ = totalSupply_.add(_amount);
305     balances[owner] = balances[owner].add(_amount);
306     
307     emit Transfer(address(0), owner, _amount);
308     return true;
309     }
310 
311     function isContract(address addr) internal view returns (bool) {
312     uint size;
313     assembly{size := extcodesize(addr)}
314     return size > 0;
315     }
316 
317     function autoUnlock(address _holder) internal returns (bool) {
318         if (lockupInfo[_holder].releaseTime <= now) {
319         return releaseTimeLock(_holder);
320         }
321     
322     return false;
323     }
324 
325 
326     function releaseTimeLock(address _holder) internal returns(bool) {
327     require(locks[_holder]);
328     uint256 releaseAmount = 0;
329 
330     for( ; lockupInfo[_holder].releaseTime <= now ; )
331     {
332     if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {
333     releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
334     delete lockupInfo[_holder];
335     locks[_holder] = false;
336     break;
337     } else {
338     releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
339     lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
340     lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
341     }
342     
343     }
344     
345     emit Unlock(_holder, releaseAmount);
346     balances[_holder] = balances[_holder].add(releaseAmount);
347     return true;
348     }
349 }