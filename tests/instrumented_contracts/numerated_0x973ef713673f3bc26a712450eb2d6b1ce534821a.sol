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
112 contract RTNToken is ERC20, Ownable, Pausable {
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
128     uint256 internal mintCap;
129 
130     mapping(address => uint256) internal balances;
131     mapping(address => bool) internal locks;
132     mapping(address => bool) public frozen;
133     mapping(address => mapping(address => uint256)) internal allowed;
134     mapping(address => LockupInfo[]) internal lockupInfo;
135 
136     event Lock(address indexed holder, uint256 value);
137     event Unlock(address indexed holder, uint256 value);
138     event Burn(address indexed owner, uint256 value);
139     event Mint(uint256 value);
140     event Freeze(address indexed holder);
141     event Unfreeze(address indexed holder);
142 
143     modifier notFrozen(address _holder) {
144         require(!frozen[_holder]);
145         _;
146     }
147 
148     constructor() public {
149         name = "RTN Token";
150         symbol = "RTN";
151         initialSupply = 1000000000; //1,000,000,000 개
152         totalSupply_ = initialSupply * 10 ** uint(decimals);
153         mintCap = 3000000000 * 10 ** uint(decimals); //3,000,000,000
154         balances[owner] = totalSupply_;
155         emit Transfer(address(0), owner, totalSupply_);
156     }
157 
158     //
159     function () public payable {
160         revert();
161     }
162 
163     function totalSupply() public view returns (uint256) {
164         return totalSupply_;
165     }
166 
167     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
168         if (locks[msg.sender]) {
169             autoUnlock(msg.sender);            
170         }
171         require(_to != address(0));
172         require(_value <= balances[msg.sender]);
173         
174 
175         // SafeMath.sub will throw if there is not enough balance.
176         balances[msg.sender] = balances[msg.sender].sub(_value);
177         balances[_to] = balances[_to].add(_value);
178         emit Transfer(msg.sender, _to, _value);
179         return true;
180     }
181 
182     function balanceOf(address _holder) public view returns (uint256 balance) {
183         uint256 lockedBalance = 0;
184         if(locks[_holder]) {
185             for(uint256 idx = 0; idx < lockupInfo[_holder].length ; idx++ ) {
186                 lockedBalance = lockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
187             }
188         }
189         return balances[_holder] + lockedBalance;
190     }
191 
192     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
193         if (locks[_from]) {
194             autoUnlock(_from);            
195         }
196         require(_to != address(0));
197         require(_value <= balances[_from]);
198         require(_value <= allowed[_from][msg.sender]);
199         
200 
201         balances[_from] = balances[_from].sub(_value);
202         balances[_to] = balances[_to].add(_value);
203         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204         emit Transfer(_from, _to, _value);
205         return true;
206     }
207 
208     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
209         allowed[msg.sender][_spender] = _value;
210         emit Approval(msg.sender, _spender, _value);
211         return true;
212     }
213     
214     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
215         require(isContract(_spender));
216         TokenRecipient spender = TokenRecipient(_spender);
217         if (approve(_spender, _value)) {
218             spender.receiveApproval(msg.sender, _value, this, _extraData);
219             return true;
220         }
221     }
222 
223     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
224         require(spender != address(0));
225         allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
226         
227         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
228         return true;
229     }
230 
231     function decreaseAllowance( address spender, uint256 subtractedValue) public returns (bool) {
232         require(spender != address(0));
233         allowed[msg.sender][spender] = (allowed[msg.sender][spender].sub(subtractedValue));
234 
235         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
236         return true;
237     }
238 
239     function allowance(address _holder, address _spender) public view returns (uint256) {
240         return allowed[_holder][_spender];
241     }
242 
243     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
244         require(balances[_holder] >= _amount);
245         if(_termOfRound==0 ) {
246             _termOfRound = 1;
247         }
248         balances[_holder] = balances[_holder].sub(_amount);
249         lockupInfo[_holder].push(
250             LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount)
251         );
252 
253         locks[_holder] = true;
254 
255         emit Lock(_holder, _amount);
256 
257         return true;
258     }
259 
260     function unlock(address _holder, uint256 _idx) public onlyOwner returns (bool) {
261         require(locks[_holder]);
262         require(_idx < lockupInfo[_holder].length);
263         LockupInfo storage lockupinfo = lockupInfo[_holder][_idx];
264         uint256 releaseAmount = lockupinfo.lockupBalance;
265 
266         delete lockupInfo[_holder][_idx];
267         lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
268         lockupInfo[_holder].length -=1;
269         if(lockupInfo[_holder].length == 0) {
270             locks[_holder] = false;
271         }
272 
273         emit Unlock(_holder, releaseAmount);
274         balances[_holder] = balances[_holder].add(releaseAmount);
275 
276         return true;
277     }
278 
279     function freezeAccount(address _holder) public onlyOwner returns (bool) {
280         require(!frozen[_holder]);
281         frozen[_holder] = true;
282         emit Freeze(_holder);
283         return true;
284     }
285 
286     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
287         require(frozen[_holder]);
288         frozen[_holder] = false;
289         emit Unfreeze(_holder);
290         return true;
291     }
292 
293     function getNowTime() public view returns(uint256) {
294         return now;
295     }
296 
297     function showLockState(address _holder, uint256 _idx) public view returns (bool, uint256, uint256, uint256, uint256, uint256) {
298         if(locks[_holder]) {
299             return (
300                 locks[_holder], 
301                 lockupInfo[_holder].length, 
302                 lockupInfo[_holder][_idx].lockupBalance, 
303                 lockupInfo[_holder][_idx].releaseTime, 
304                 lockupInfo[_holder][_idx].termOfRound, 
305                 lockupInfo[_holder][_idx].unlockAmountPerRound
306             );
307         } else {
308             return (
309                 locks[_holder], 
310                 lockupInfo[_holder].length, 
311                 0,0,0,0
312             );
313 
314         }        
315     }
316     
317     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
318         require(_to != address(0));
319         require(_value <= balances[owner]);
320 
321         balances[owner] = balances[owner].sub(_value);
322         balances[_to] = balances[_to].add(_value);
323         emit Transfer(owner, _to, _value);
324         return true;
325     }
326 
327     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
328         distribute(_to, _value);
329         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
330         return true;
331     }
332 
333     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
334         token.transfer(_to, _value);
335         return true;
336     }
337 
338     function burn(uint256 _value) public onlyOwner returns (bool success) {
339         require(_value <= balances[msg.sender]);
340         address burner = msg.sender;
341         balances[burner] = balances[burner].sub(_value);
342         totalSupply_ = totalSupply_.sub(_value);
343         emit Burn(burner, _value);
344         return true;
345     }
346 
347     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
348         require(mintCap >= totalSupply_.add(_amount));
349         totalSupply_ = totalSupply_.add(_amount);
350         balances[_to] = balances[_to].add(_amount);
351         emit Transfer(address(0), _to, _amount);
352         return true;
353     }
354 
355     function isContract(address addr) internal view returns (bool) {
356         uint size;
357         assembly{size := extcodesize(addr)}
358         return size > 0;
359     }
360 
361     function autoUnlock(address _holder) internal returns (bool) {
362 
363         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
364             if(locks[_holder]==false) {
365                 return true;
366             }
367             if (lockupInfo[_holder][idx].releaseTime <= now) {
368                 // If lockupinfo was deleted, loop restart at same position.
369                 if( releaseTimeLock(_holder, idx) ) {
370                     idx -=1;
371                 }
372             }
373         }
374         return true;
375     }
376 
377     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
378         require(locks[_holder]);
379         require(_idx < lockupInfo[_holder].length);
380 
381         // If lock status of holder is finished, delete lockup info. 
382         LockupInfo storage info = lockupInfo[_holder][_idx];
383         uint256 releaseAmount = info.unlockAmountPerRound;
384         uint256 sinceFrom = now.sub(info.releaseTime);
385         uint256 sinceRound = sinceFrom.div(info.termOfRound);
386         releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );
387 
388         if(releaseAmount >= info.lockupBalance) {            
389             releaseAmount = info.lockupBalance;
390 
391             delete lockupInfo[_holder][_idx];
392             lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
393             lockupInfo[_holder].length -=1;
394 
395             if(lockupInfo[_holder].length == 0) {
396                 locks[_holder] = false;
397             }
398             emit Unlock(_holder, releaseAmount);
399             balances[_holder] = balances[_holder].add(releaseAmount);
400             return true;
401         } else {
402             lockupInfo[_holder][_idx].releaseTime = lockupInfo[_holder][_idx].releaseTime.add( sinceRound.add(1).mul(info.termOfRound) );
403             lockupInfo[_holder][_idx].lockupBalance = lockupInfo[_holder][_idx].lockupBalance.sub(releaseAmount);
404             emit Unlock(_holder, releaseAmount);
405             balances[_holder] = balances[_holder].add(releaseAmount);
406             return false;
407         }
408     }
409 
410 
411 }