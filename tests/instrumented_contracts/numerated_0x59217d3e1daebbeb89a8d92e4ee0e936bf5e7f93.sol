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
112 contract Linkbox is ERC20, Ownable, Pausable {
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
137     event Freeze(address indexed holder);
138     event Unfreeze(address indexed holder);
139 
140     modifier notFrozen(address _holder) {
141         require(!frozen[_holder]);
142         _;
143     }
144 
145     constructor() public {
146         name = "LINKBOX";
147         symbol = "LBOX";
148         initialSupply = 21000000000;
149         totalSupply_ = initialSupply * 10 ** uint(decimals);
150         balances[owner] = totalSupply_;
151         emit Transfer(address(0), owner, totalSupply_);
152     }
153 
154     function () public payable {
155         revert();
156     }
157 
158     function totalSupply() public view returns (uint256) {
159         return totalSupply_;
160     }
161 
162     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
163         if (locks[msg.sender]) {
164             autoUnlock(msg.sender);            
165         }
166         require(_to != address(0));
167         require(_value <= balances[msg.sender]);
168         
169 
170         // SafeMath.sub will throw if there is not enough balance.
171         balances[msg.sender] = balances[msg.sender].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         emit Transfer(msg.sender, _to, _value);
174         return true;
175     }
176 
177     function balanceOf(address _holder) public view returns (uint256 balance) {
178         uint256 lockedBalance = 0;
179         if(locks[_holder]) {
180             for(uint256 idx = 0; idx < lockupInfo[_holder].length ; idx++ ) {
181                 lockedBalance = lockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
182             }
183         }
184         return balances[_holder] + lockedBalance;
185     }
186 
187     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
188         if (locks[_from]) {
189             autoUnlock(_from);            
190         }
191         require(_to != address(0));
192         require(_value <= balances[_from]);
193         require(_value <= allowed[_from][msg.sender]);
194         
195 
196         balances[_from] = balances[_from].sub(_value);
197         balances[_to] = balances[_to].add(_value);
198         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199         emit Transfer(_from, _to, _value);
200         return true;
201     }
202 
203     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
204         allowed[msg.sender][_spender] = _value;
205         emit Approval(msg.sender, _spender, _value);
206         return true;
207     }
208     
209     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
210         require(isContract(_spender));
211         TokenRecipient spender = TokenRecipient(_spender);
212         if (approve(_spender, _value)) {
213             spender.receiveApproval(msg.sender, _value, this, _extraData);
214             return true;
215         }
216     }
217 
218     function allowance(address _holder, address _spender) public view returns (uint256) {
219         return allowed[_holder][_spender];
220     }
221 
222     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
223         require(balances[_holder] >= _amount);
224         if(_termOfRound==0 ) {
225             _termOfRound = 1;
226         }
227         balances[_holder] = balances[_holder].sub(_amount);
228         lockupInfo[_holder].push(
229             LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount)
230         );
231 
232         locks[_holder] = true;
233 
234         emit Lock(_holder, _amount);
235 
236         return true;
237     }
238 
239     function unlock(address _holder, uint256 _idx) public onlyOwner returns (bool) {
240         require(locks[_holder]);
241         require(_idx < lockupInfo[_holder].length);
242         LockupInfo storage lockupinfo = lockupInfo[_holder][_idx];
243         uint256 releaseAmount = lockupinfo.lockupBalance;
244 
245         delete lockupInfo[_holder][_idx];
246         lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
247         lockupInfo[_holder].length -=1;
248         if(lockupInfo[_holder].length == 0) {
249             locks[_holder] = false;
250         }
251 
252         emit Unlock(_holder, releaseAmount);
253         balances[_holder] = balances[_holder].add(releaseAmount);
254 
255         return true;
256     }
257 
258     function freezeAccount(address _holder) public onlyOwner returns (bool) {
259         require(!frozen[_holder]);
260         frozen[_holder] = true;
261         emit Freeze(_holder);
262         return true;
263     }
264 
265     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
266         require(frozen[_holder]);
267         frozen[_holder] = false;
268         emit Unfreeze(_holder);
269         return true;
270     }
271 
272     function getNowTime() public view returns(uint256) {
273         return now;
274     }
275 
276     function showLockState(address _holder, uint256 _idx) public view returns (bool, uint256, uint256, uint256, uint256, uint256) {
277         if(locks[_holder]) {
278             return (
279                 locks[_holder], 
280                 lockupInfo[_holder].length, 
281                 lockupInfo[_holder][_idx].lockupBalance, 
282                 lockupInfo[_holder][_idx].releaseTime, 
283                 lockupInfo[_holder][_idx].termOfRound, 
284                 lockupInfo[_holder][_idx].unlockAmountPerRound
285             );
286         } else {
287             return (
288                 locks[_holder], 
289                 lockupInfo[_holder].length, 
290                 0,0,0,0
291             );
292 
293         }        
294     }
295     
296     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
297         require(_to != address(0));
298         require(_value <= balances[owner]);
299 
300         balances[owner] = balances[owner].sub(_value);
301         balances[_to] = balances[_to].add(_value);
302         emit Transfer(owner, _to, _value);
303         return true;
304     }
305 
306     function distributeWithLockup(address _to, uint256 _value, uint8 month) public onlyOwner returns (bool) {
307         require( month == 3 || month == 6 || month == 12 );
308         distribute(_to, _value);
309         if( month == 3) {
310             lock(_to, _value, now + 90 days, 90 days, 25);
311         } else if( month == 6 ) {
312             lock(_to, _value, now + 180 days, 1, 100);
313         } else {
314             lock(_to, _value, now + 1 years , 1, 100);
315         }
316         return true;
317     }
318 
319     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
320         token.transfer(_to, _value);
321         return true;
322     }
323 
324     function isContract(address addr) internal view returns (bool) {
325         uint size;
326         assembly{size := extcodesize(addr)}
327         return size > 0;
328     }
329 
330     function autoUnlock(address _holder) internal returns (bool) {
331 
332         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
333             if(locks[_holder]==false) {
334                 return true;
335             }
336             if (lockupInfo[_holder][idx].releaseTime <= now) {
337                 // If lockupinfo was deleted, loop restart at same position.
338                 if( releaseTimeLock(_holder, idx) ) {
339                     idx -=1;
340                 }
341             }
342         }
343         return true;
344     }
345 
346     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
347         require(locks[_holder]);
348         require(_idx < lockupInfo[_holder].length);
349 
350         // If lock status of holder is finished, delete lockup info. 
351         LockupInfo storage info = lockupInfo[_holder][_idx];
352         uint256 releaseAmount = info.unlockAmountPerRound;
353         uint256 sinceFrom = now.sub(info.releaseTime);
354         uint256 sinceRound = sinceFrom.div(info.termOfRound);
355         releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );
356 
357         if(releaseAmount >= info.lockupBalance) {            
358             releaseAmount = info.lockupBalance;
359 
360             delete lockupInfo[_holder][_idx];
361             lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
362             lockupInfo[_holder].length -=1;
363 
364             if(lockupInfo[_holder].length == 0) {
365                 locks[_holder] = false;
366             }
367             emit Unlock(_holder, releaseAmount);
368             balances[_holder] = balances[_holder].add(releaseAmount);
369             return true;
370         } else {
371             lockupInfo[_holder][_idx].releaseTime = lockupInfo[_holder][_idx].releaseTime.add( sinceRound.add(1).mul(info.termOfRound) );
372             lockupInfo[_holder][_idx].lockupBalance = lockupInfo[_holder][_idx].lockupBalance.sub(releaseAmount);
373             emit Unlock(_holder, releaseAmount);
374             balances[_holder] = balances[_holder].add(releaseAmount);
375             return false;
376         }
377     }
378 
379 
380 }