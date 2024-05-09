1 pragma solidity ^0.4.24;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 
9 library SafeMath {
10 /**
11 * @dev Multiplies two numbers, throws on overflow.
12 */
13 
14     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
15     if (_a == 0) {
16     return 0;
17     }
18     uint256 c = _a * _b;
19     assert(c / _a == _b);
20     return c;
21     }
22     
23     
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
28     // assert(_b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = _a / _b;
30     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
31     return c;
32     }
33     
34      
35     
36     /**
37     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42     }
43     
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     uint256 c = _a + _b;
49     assert(c >= _a);
50     return c;
51     }
52 }
53 
54  
55 
56 contract Ownable {
57     address public owner;
58     address public newOwner;
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     constructor() public {
62     owner = msg.sender;
63     newOwner = address(0);
64     }
65 
66     modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69     }
70 
71     modifier onlyNewOwner() {
72     require(msg.sender != address(0));
73     require(msg.sender == newOwner);
74     _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78     require(_newOwner != address(0));
79     newOwner = _newOwner;
80     }
81     
82     function acceptOwnership() public onlyNewOwner returns(bool) {
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85     }
86 }
87 
88 
89 contract Pausable is Ownable {
90     event Pause();
91     event Unpause();
92     bool public paused = false;
93     
94     modifier whenNotPaused() {
95     require(!paused);
96     _;
97     }
98     modifier whenPaused() {
99     require(paused);
100     _;
101     }
102 
103     
104     function pause() onlyOwner whenNotPaused public {
105     paused = true;
106     emit Pause();
107     }
108     
109     
110     function unpause() onlyOwner whenPaused public {
111     paused = false;
112     emit Unpause();
113     }
114 
115 }
116 
117  
118 
119 contract ERC20 {
120     function totalSupply() public view returns (uint256);
121     function balanceOf(address who) public view returns (uint256);
122     function allowance(address owner, address spender) public view returns (uint256);
123     function transfer(address to, uint256 value) public returns (bool);
124     function transferFrom(address from, address to, uint256 value) public returns (bool);
125     function approve(address spender, uint256 value) public returns (bool);
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130  
131 
132 interface TokenRecipient {
133  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
134 }
135 
136  
137 
138 contract YoLoCoin is ERC20, Ownable, Pausable {
139     uint128 internal MONTH = 30 * 24 * 3600; // 1 month
140     using SafeMath for uint256;
141     
142     
143     struct LockupInfo {
144     uint256 releaseTime;
145     uint256 termOfRound;
146     uint256 unlockAmountPerRound;
147     uint256 lockupBalance;
148     }
149     
150     string public name;
151     string public symbol;
152     uint8 public decimals;
153     uint256 internal initialSupply;
154     uint256 internal totalSupply_;
155     
156     mapping(address => uint256) internal balances;
157     mapping(address => bool) internal locks;
158     mapping(address => bool) public frozen;
159     mapping(address => mapping(address => uint256)) internal allowed;
160     mapping(address => LockupInfo) internal lockupInfo;
161     
162     event Unlock(address indexed holder, uint256 value);
163     event Lock(address indexed holder, uint256 value);
164     event Burn(address indexed owner, uint256 value);
165     event Mint(uint256 value);
166     event Freeze(address indexed holder);
167     event Unfreeze(address indexed holder);
168     
169     modifier notFrozen(address _holder) {
170     require(!frozen[_holder]);
171     _;
172     }
173 
174     constructor() public {
175     name = "YoLoCoin";
176     symbol = "YLC";
177     decimals = 0;
178     initialSupply = 100000000;
179     totalSupply_ = 100000000;
180     balances[owner] = totalSupply_;
181     emit Transfer(address(0), owner, totalSupply_);
182     }
183 
184     function () public payable {
185     revert();
186     }
187 
188     function totalSupply() public view returns (uint256) {
189     return totalSupply_;
190     }
191 
192  
193 
194 /**
195      * Internal transfer, only can be called by this contract
196      */
197     function _transfer(address _from, address _to, uint _value) internal {
198         // Prevent transfer to 0x0 address. Use burn() instead
199        
200         require(_to != address(0));
201         require(_value <= balances[_from]);
202         require(_value <= allowed[_from][msg.sender]);
203     
204        balances[_from] = balances[_from].sub(_value);
205        balances[_to] = balances[_to].add(_value);
206       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207       emit Transfer(_from, _to, _value);
208     }
209     
210     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
211     
212     if (locks[msg.sender]) {
213     autoUnlock(msg.sender);
214     }
215     
216     require(_to != address(0));
217     require(_value <= balances[msg.sender]);
218     
219     // SafeMath.sub will throw if there is not enough balance.
220     balances[msg.sender] = balances[msg.sender].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     emit Transfer(msg.sender, _to, _value);
223     return true;
224     }
225 
226     function balanceOf(address _holder) public view returns (uint256 balance) {
227     return balances[_holder] + lockupInfo[_holder].lockupBalance;
228     }
229     
230     function sendwithgas (address _from, address _to, uint256 _value, uint256 _fee) public whenNotPaused notFrozen(_from) returns (bool) {
231         if(locks[_from]){
232             autoUnlock(_from);
233         }
234         require(_to != address(0));
235         require(_value <= balances[_from]);
236         balances[msg.sender] = balances[msg.sender].add(_fee);
237         balances[_from] = balances[_from].sub(_value + _fee);
238         balances[_to] = balances[_to].add(_value);
239     }
240      
241     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from) returns (bool) {
242 
243         if (locks[_from]) {
244         autoUnlock(_from);
245         }
246     
247     require(_to != address(0));
248     require(_value <= balances[_from]);
249     require(_value <= allowed[_from][msg.sender]);
250 
251     _transfer(_from, _to, _value);
252     
253     return true;
254     }
255     
256     
257 
258     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
259     allowed[msg.sender][_spender] = _value;
260     emit Approval(msg.sender, _spender, _value);
261     return true;
262     }
263 
264     function allowance(address _holder, address _spender) public view returns (uint256) {
265     return allowed[_holder][_spender];
266     }
267 
268  
269 
270     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
271     require(locks[_holder] == false);
272     require(balances[_holder] >= _amount);
273     balances[_holder] = balances[_holder].sub(_amount);
274     lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount);
275     
276     locks[_holder] = true;
277     emit Lock(_holder, _amount);
278     return true;
279     }
280 
281  
282 
283     function unlock(address _holder) public onlyOwner returns (bool) {
284     require(locks[_holder] == true);
285     uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
286     
287     delete lockupInfo[_holder];
288     locks[_holder] = false;
289     emit Unlock(_holder, releaseAmount);
290     balances[_holder] = balances[_holder].add(releaseAmount);
291     return true;
292     
293     }
294 
295  
296     function freezeAccount(address _holder) public onlyOwner returns (bool) {
297     require(!frozen[_holder]);
298     frozen[_holder] = true;
299     emit Freeze(_holder);
300     return true;
301     }
302 
303  
304 
305     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
306     require(frozen[_holder]);
307     frozen[_holder] = false;
308     emit Unfreeze(_holder);
309     return true;
310     }
311 
312  
313 
314     function getNowTime() public view returns(uint256) {
315     return now;
316     }
317 
318 
319     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
320     return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
321     }
322     
323     
324    function burn(uint256 _value) public onlyOwner returns (bool success) {
325     require(_value <= balances[msg.sender]);
326     address burner = msg.sender;
327     balances[burner] = balances[burner].sub(_value);
328     totalSupply_ = totalSupply_.sub(_value);
329     emit Burn(burner, _value);
330     return true;
331     }
332 
333  
334     function mint( uint256 _amount) onlyOwner public returns (bool) {
335     totalSupply_ = totalSupply_.add(_amount);
336     balances[owner] = balances[owner].add(_amount);
337     
338     emit Transfer(address(0), owner, _amount);
339     return true;
340     }
341 
342     function isContract(address addr) internal view returns (bool) {
343     uint size;
344     assembly{size := extcodesize(addr)}
345     return size > 0;
346     }
347 
348     function autoUnlock(address _holder) internal returns (bool) {
349         if (lockupInfo[_holder].releaseTime <= now) {
350         return releaseTimeLock(_holder);
351         }
352     
353     return false;
354     }
355 
356 
357     function releaseTimeLock(address _holder) internal returns(bool) {
358     require(locks[_holder]);
359     uint256 releaseAmount = 0;
360     
361      
362     // If lock status of holder is finished, delete lockup info.
363     for( ; lockupInfo[_holder].releaseTime <= now ; )
364     {
365     if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {
366     releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
367     delete lockupInfo[_holder];
368     locks[_holder] = false;
369     break;
370     } else {
371     releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
372     lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
373     lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
374     }
375     
376     }
377     
378     emit Unlock(_holder, releaseAmount);
379     balances[_holder] = balances[_holder].add(releaseAmount);
380     return true;
381     }
382 }