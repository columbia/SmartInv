1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;       
19     }       
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract Ownable {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() public {
41         owner = msg.sender;
42         newOwner = address(0);
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49     modifier onlyNewOwner() {
50         require(msg.sender != address(0));
51         require(msg.sender == newOwner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         require(_newOwner != address(0));
57         newOwner = _newOwner;
58     }
59 
60     function acceptOwnership() public onlyNewOwner returns(bool) {
61         emit OwnershipTransferred(owner, newOwner);        
62         owner = newOwner;
63         newOwner = 0x0;
64     }
65 }
66 
67 contract Pausable is Ownable {
68     event Pause();
69     event Unpause();
70 
71     bool public paused = false;
72 
73     modifier whenNotPaused() {
74         require(!paused);
75         _;
76     }
77 
78     modifier whenPaused() {
79         require(paused);
80         _;
81     }
82 
83     function pause() onlyOwner whenNotPaused public {
84         paused = true;
85         emit Pause();
86     }
87 
88     function unpause() onlyOwner whenPaused public {
89         paused = false;
90         emit Unpause();
91     }
92 }
93 
94 contract ERC20 {
95     function totalSupply() public view returns (uint256);
96     function balanceOf(address who) public view returns (uint256);
97     function allowance(address owner, address spender) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     function transferFrom(address from, address to, uint256 value) public returns (bool);
100     function approve(address spender, uint256 value) public returns (bool);
101 
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 interface TokenRecipient {
108     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
109 }
110 
111 
112 contract BSG is ERC20, Ownable, Pausable {
113 
114     using SafeMath for uint256;
115 
116     struct LockupInfo {
117         uint256 releaseTime;
118         uint256 termOfRound;
119         uint256 unlockAmountPerRound;        
120         uint256 lockupBalance;
121     }
122 
123     string public name;
124     string public symbol;
125     uint8 constant public decimals =18;
126     uint256 internal initialSupply;
127     uint256 internal totalSupply_;
128 
129     mapping(address => uint256) internal balances;
130     mapping(address => bool) internal locks;
131     mapping(address => bool) public frozen;
132     mapping(address => mapping(address => uint256)) internal allowed;
133     mapping(address => LockupInfo[]) internal lockupInfo;
134 
135     event Lock(address indexed holder, uint256 value);
136     event Unlock(address indexed holder, uint256 value);
137     event Burn(address indexed owner, uint256 value);
138     event Freeze(address indexed holder);
139     event Unfreeze(address indexed holder);
140 
141     modifier notFrozen(address _holder) {
142         require(!frozen[_holder]);
143         _;
144     }
145 
146     constructor() public {
147         name = "Bistro game";
148         symbol = "BSG";
149         initialSupply = 5000000000;
150         totalSupply_ = initialSupply * 10 ** uint(decimals);
151         balances[owner] = totalSupply_;
152         emit Transfer(address(0), owner, totalSupply_);
153     }
154     
155     function totalSupply() public view returns (uint256) {
156         return totalSupply_;
157     }
158 
159     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
160         if (locks[msg.sender]) {
161             autoUnlock(msg.sender);            
162         }
163         require(_to != address(0));
164         require(_value <= balances[msg.sender]);
165         
166 
167         // SafeMath.sub will throw if there is not enough balance.
168         balances[msg.sender] = balances[msg.sender].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         emit Transfer(msg.sender, _to, _value);
171         return true;
172     }
173 
174     function balanceOf(address _holder) public view returns (uint256 balance) {
175         uint256 lockedBalance = 0;
176         if(locks[_holder]) {
177             for(uint256 idx = 0; idx < lockupInfo[_holder].length ; idx++ ) {
178                 lockedBalance = lockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
179             }
180         }
181         return balances[_holder] + lockedBalance;
182     }
183 
184     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
185         if (locks[_from]) {
186             autoUnlock(_from);            
187         }
188         require(_to != address(0));
189         require(_value <= balances[_from]);
190         require(_value <= allowed[_from][msg.sender]);
191         
192 
193         balances[_from] = balances[_from].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196         emit Transfer(_from, _to, _value);
197         return true;
198     }
199 
200     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
201         allowed[msg.sender][_spender] = _value;
202         emit Approval(msg.sender, _spender, _value);
203         return true;
204     }
205     
206     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
207         require(isContract(_spender));
208         TokenRecipient spender = TokenRecipient(_spender);
209         if (approve(_spender, _value)) {
210             spender.receiveApproval(msg.sender, _value, this, _extraData);
211             return true;
212         }
213     }
214 
215     function allowance(address _holder, address _spender) public view returns (uint256) {
216         return allowed[_holder][_spender];
217     }
218 
219     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
220         require(balances[_holder] >= _amount);
221         if(_termOfRound==0 ) {
222             _termOfRound = 1;
223         }
224         balances[_holder] = balances[_holder].sub(_amount);
225         lockupInfo[_holder].push(
226             LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount)
227         );
228 
229         locks[_holder] = true;
230 
231         emit Lock(_holder, _amount);
232 
233         return true;
234     }
235 
236     function unlock(address _holder, uint256 _idx) public onlyOwner returns (bool) {
237         require(locks[_holder]);
238         require(_idx < lockupInfo[_holder].length);
239         LockupInfo storage lockupinfo = lockupInfo[_holder][_idx];
240         uint256 releaseAmount = lockupinfo.lockupBalance;
241 
242         delete lockupInfo[_holder][_idx];
243         lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
244         lockupInfo[_holder].length -=1;
245         if(lockupInfo[_holder].length == 0) {
246             locks[_holder] = false;
247         }
248 
249         emit Unlock(_holder, releaseAmount);
250         balances[_holder] = balances[_holder].add(releaseAmount);
251 
252         return true;
253     }
254 
255     function freezeAccount(address _holder) public onlyOwner returns (bool) {
256         require(!frozen[_holder]);
257         frozen[_holder] = true;
258         emit Freeze(_holder);
259         return true;
260     }
261 
262     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
263         require(frozen[_holder]);
264         frozen[_holder] = false;
265         emit Unfreeze(_holder);
266         return true;
267     }
268 
269     function getNowTime() public view returns(uint256) {
270         return now;
271     }
272 
273     function showLockState(address _holder, uint256 _idx) public view returns (bool, uint256, uint256, uint256, uint256, uint256) {
274         if(locks[_holder]) {
275             return (
276                 locks[_holder], 
277                 lockupInfo[_holder].length, 
278                 lockupInfo[_holder][_idx].lockupBalance, 
279                 lockupInfo[_holder][_idx].releaseTime, 
280                 lockupInfo[_holder][_idx].termOfRound, 
281                 lockupInfo[_holder][_idx].unlockAmountPerRound
282             );
283         } else {
284             return (
285                 locks[_holder], 
286                 lockupInfo[_holder].length, 
287                 0,0,0,0
288             );
289 
290         }        
291     }
292     
293     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
294         require(_to != address(0));
295         require(_value <= balances[owner]);
296 
297         balances[owner] = balances[owner].sub(_value);
298         balances[_to] = balances[_to].add(_value);
299         emit Transfer(owner, _to, _value);
300         return true;
301     }
302 
303     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
304         distribute(_to, _value);
305         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
306         return true;
307     }
308 
309     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
310         token.transfer(_to, _value);
311         return true;
312     }
313 
314     function burn(uint256 _value) public onlyOwner returns (bool success) {
315         require(_value <= balances[msg.sender]);
316         address burner = msg.sender;
317         balances[burner] = balances[burner].sub(_value);
318         totalSupply_ = totalSupply_.sub(_value);
319         emit Burn(burner, _value);
320         return true;
321     }
322 
323     function isContract(address addr) internal view returns (bool) {
324         uint size;
325         assembly{size := extcodesize(addr)}
326         return size > 0;
327     }
328 
329     function autoUnlock(address _holder) internal returns (bool) {
330 
331         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
332             if(locks[_holder]==false) {
333                 return true;
334             }
335             if (lockupInfo[_holder][idx].releaseTime <= now) {
336                 // If lockupinfo was deleted, loop restart at same position.
337                 if( releaseTimeLock(_holder, idx) ) {
338                     idx -=1;
339                 }
340             }
341         }
342         return true;
343     }
344 
345     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
346         require(locks[_holder]);
347         require(_idx < lockupInfo[_holder].length);
348 
349         // If lock status of holder is finished, delete lockup info. 
350         LockupInfo storage info = lockupInfo[_holder][_idx];
351         uint256 releaseAmount = info.unlockAmountPerRound;
352         uint256 sinceFrom = now.sub(info.releaseTime);
353         uint256 sinceRound = sinceFrom.div(info.termOfRound);
354         releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );
355 
356         if(releaseAmount >= info.lockupBalance) {            
357             releaseAmount = info.lockupBalance;
358 
359             delete lockupInfo[_holder][_idx];
360             lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
361             lockupInfo[_holder].length -=1;
362 
363             if(lockupInfo[_holder].length == 0) {
364                 locks[_holder] = false;
365             }
366             emit Unlock(_holder, releaseAmount);
367             balances[_holder] = balances[_holder].add(releaseAmount);
368             return true;
369         } else {
370             lockupInfo[_holder][_idx].releaseTime = lockupInfo[_holder][_idx].releaseTime.add( sinceRound.add(1).mul(info.termOfRound) );
371             lockupInfo[_holder][_idx].lockupBalance = lockupInfo[_holder][_idx].lockupBalance.sub(releaseAmount);
372             emit Unlock(_holder, releaseAmount);
373             balances[_holder] = balances[_holder].add(releaseAmount);
374             return false;
375         }
376     }
377 }