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
112 contract ElyXToken is ERC20, Ownable, Pausable {
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
138     event Mint(uint256 value);
139     event Freeze(address indexed holder);
140     event Unfreeze(address indexed holder);
141 
142     modifier notFrozen(address _holder) {
143         require(!frozen[_holder]);
144         _;
145     }
146 
147     constructor() public {
148         name = "ElyX";
149         symbol = "ElyX";
150         initialSupply = 10000000000; //10,000,000,000 개
151         totalSupply_ = initialSupply * 10 ** uint(decimals);
152         balances[owner] = totalSupply_;
153         emit Transfer(address(0), owner, totalSupply_);
154     }
155 
156     //
157     function () public payable {
158         revert();
159     }
160 
161     function totalSupply() public view returns (uint256) {
162         return totalSupply_;
163     }
164 
165     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
166         if (locks[msg.sender]) {
167             autoUnlock(msg.sender);            
168         }
169         require(_to != address(0));
170         require(_value <= balances[msg.sender]);
171         
172 
173         // SafeMath.sub will throw if there is not enough balance.
174         balances[msg.sender] = balances[msg.sender].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176         emit Transfer(msg.sender, _to, _value);
177         return true;
178     }
179 
180     function balanceOf(address _holder) public view returns (uint256 balance) {
181         uint256 lockedBalance = 0;
182         if(locks[_holder]) {
183             for(uint256 idx = 0; idx < lockupInfo[_holder].length ; idx++ ) {
184                 lockedBalance = lockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
185             }
186         }
187         return balances[_holder] + lockedBalance;
188     }
189 
190     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
191         if (locks[_from]) {
192             autoUnlock(_from);            
193         }
194         require(_to != address(0));
195         require(_value <= balances[_from]);
196         require(_value <= allowed[_from][msg.sender]);
197         
198 
199         balances[_from] = balances[_from].sub(_value);
200         balances[_to] = balances[_to].add(_value);
201         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202         emit Transfer(_from, _to, _value);
203         return true;
204     }
205 
206     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
207         allowed[msg.sender][_spender] = _value;
208         emit Approval(msg.sender, _spender, _value);
209         return true;
210     }
211     
212     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
213         require(isContract(_spender));
214         TokenRecipient spender = TokenRecipient(_spender);
215         if (approve(_spender, _value)) {
216             spender.receiveApproval(msg.sender, _value, this, _extraData);
217             return true;
218         }
219     }
220 
221     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
222         require(spender != address(0));
223         allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
224         
225         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
226         return true;
227     }
228 
229     function decreaseAllowance( address spender, uint256 subtractedValue) public returns (bool) {
230         require(spender != address(0));
231         allowed[msg.sender][spender] = (allowed[msg.sender][spender].sub(subtractedValue));
232 
233         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
234         return true;
235     }
236 
237     function allowance(address _holder, address _spender) public view returns (uint256) {
238         return allowed[_holder][_spender];
239     }
240 
241     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
242         require(balances[_holder] >= _amount);
243         if(_termOfRound==0 ) {
244             _termOfRound = 1;
245         }
246         balances[_holder] = balances[_holder].sub(_amount);
247         lockupInfo[_holder].push(
248             LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount)
249         );
250 
251         locks[_holder] = true;
252 
253         emit Lock(_holder, _amount);
254 
255         return true;
256     }
257 
258     function unlock(address _holder, uint256 _idx) public onlyOwner returns (bool) {
259         require(locks[_holder]);
260         require(_idx < lockupInfo[_holder].length);
261         LockupInfo storage lockupinfo = lockupInfo[_holder][_idx];
262         uint256 releaseAmount = lockupinfo.lockupBalance;
263 
264         delete lockupInfo[_holder][_idx];
265         lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
266         lockupInfo[_holder].length -=1;
267         if(lockupInfo[_holder].length == 0) {
268             locks[_holder] = false;
269         }
270 
271         emit Unlock(_holder, releaseAmount);
272         balances[_holder] = balances[_holder].add(releaseAmount);
273 
274         return true;
275     }
276 
277     function freezeAccount(address _holder) public onlyOwner returns (bool) {
278         require(!frozen[_holder]);
279         frozen[_holder] = true;
280         emit Freeze(_holder);
281         return true;
282     }
283 
284     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
285         require(frozen[_holder]);
286         frozen[_holder] = false;
287         emit Unfreeze(_holder);
288         return true;
289     }
290 
291     function getNowTime() public view returns(uint256) {
292         return now;
293     }
294 
295     function showLockState(address _holder, uint256 _idx) public view returns (bool, uint256, uint256, uint256, uint256, uint256) {
296         if(locks[_holder]) {
297             return (
298                 locks[_holder], 
299                 lockupInfo[_holder].length, 
300                 lockupInfo[_holder][_idx].lockupBalance, 
301                 lockupInfo[_holder][_idx].releaseTime, 
302                 lockupInfo[_holder][_idx].termOfRound, 
303                 lockupInfo[_holder][_idx].unlockAmountPerRound
304             );
305         } else {
306             return (
307                 locks[_holder], 
308                 lockupInfo[_holder].length, 
309                 0,0,0,0
310             );
311 
312         }        
313     }
314     
315     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
316         require(_to != address(0));
317         require(_value <= balances[owner]);
318 
319         balances[owner] = balances[owner].sub(_value);
320         balances[_to] = balances[_to].add(_value);
321         emit Transfer(owner, _to, _value);
322         return true;
323     }
324 
325     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
326         distribute(_to, _value);
327         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
328         return true;
329     }
330 
331     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
332         token.transfer(_to, _value);
333         return true;
334     }
335 
336     function burn(uint256 _value) public onlyOwner returns (bool success) {
337         require(_value <= balances[msg.sender]);
338         address burner = msg.sender;
339         balances[burner] = balances[burner].sub(_value);
340         totalSupply_ = totalSupply_.sub(_value);
341         emit Burn(burner, _value);
342         return true;
343     }
344 
345     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
346         totalSupply_ = totalSupply_.add(_amount);
347         balances[_to] = balances[_to].add(_amount);
348         emit Transfer(address(0), _to, _amount);
349         return true;
350     }
351 
352     function isContract(address addr) internal view returns (bool) {
353         uint size;
354         assembly{size := extcodesize(addr)}
355         return size > 0;
356     }
357 
358     function autoUnlock(address _holder) internal returns (bool) {
359 
360         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
361             if(locks[_holder]==false) {
362                 return true;
363             }
364             if (lockupInfo[_holder][idx].releaseTime <= now) {
365                 // If lockupinfo was deleted, loop restart at same position.
366                 if( releaseTimeLock(_holder, idx) ) {
367                     idx -=1;
368                 }
369             }
370         }
371         return true;
372     }
373 
374     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
375         require(locks[_holder]);
376         require(_idx < lockupInfo[_holder].length);
377 
378         // If lock status of holder is finished, delete lockup info. 
379         LockupInfo storage info = lockupInfo[_holder][_idx];
380         uint256 releaseAmount = info.unlockAmountPerRound;
381         uint256 sinceFrom = now.sub(info.releaseTime);
382         uint256 sinceRound = sinceFrom.div(info.termOfRound);
383         releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );
384 
385         if(releaseAmount >= info.lockupBalance) {            
386             releaseAmount = info.lockupBalance;
387 
388             delete lockupInfo[_holder][_idx];
389             lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
390             lockupInfo[_holder].length -=1;
391 
392             if(lockupInfo[_holder].length == 0) {
393                 locks[_holder] = false;
394             }
395             emit Unlock(_holder, releaseAmount);
396             balances[_holder] = balances[_holder].add(releaseAmount);
397             return true;
398         } else {
399             lockupInfo[_holder][_idx].releaseTime = lockupInfo[_holder][_idx].releaseTime.add( sinceRound.add(1).mul(info.termOfRound) );
400             lockupInfo[_holder][_idx].lockupBalance = lockupInfo[_holder][_idx].lockupBalance.sub(releaseAmount);
401             emit Unlock(_holder, releaseAmount);
402             balances[_holder] = balances[_holder].add(releaseAmount);
403             return false;
404         }
405     }
406 
407 
408 }