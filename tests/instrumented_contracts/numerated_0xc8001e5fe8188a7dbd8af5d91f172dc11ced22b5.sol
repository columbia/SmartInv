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
112 contract LandBoxToken is ERC20, Ownable, Pausable {
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
125     uint8 constant public decimals = 18;
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
147         name = "LandBox";
148         symbol = "LAND";
149         initialSupply = 200000000;
150         totalSupply_ = initialSupply * 10 ** uint(decimals);
151         balances[owner] = totalSupply_;
152         emit Transfer(address(0), owner, totalSupply_);
153     }
154 
155     function () public payable {
156         revert();
157     }
158 
159     function totalSupply() public view returns (uint256) {
160         return totalSupply_;
161     }
162 
163     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
164         if (locks[msg.sender]) {
165             autoUnlock(msg.sender);            
166         }
167         require(_to != address(0));
168         require(_value <= balances[msg.sender]);
169         
170 
171         // SafeMath.sub will throw if there is not enough balance.
172         balances[msg.sender] = balances[msg.sender].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         emit Transfer(msg.sender, _to, _value);
175         return true;
176     }
177 
178     function balanceOf(address _holder) public view returns (uint256 balance) {
179         uint256 lockedBalance = 0;
180         if(locks[_holder]) {
181             for(uint256 idx = 0; idx < lockupInfo[_holder].length ; idx++ ) {
182                 lockedBalance = lockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
183             }
184         }
185         return balances[_holder] + lockedBalance;
186     }
187 
188     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
189         if (locks[_from]) {
190             autoUnlock(_from);            
191         }
192         require(_to != address(0));
193         require(_value <= balances[_from]);
194         require(_value <= allowed[_from][msg.sender]);
195         
196 
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200         emit Transfer(_from, _to, _value);
201         return true;
202     }
203 
204     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
205         allowed[msg.sender][_spender] = _value;
206         emit Approval(msg.sender, _spender, _value);
207         return true;
208     }
209     
210     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
211         require(isContract(_spender));
212         TokenRecipient spender = TokenRecipient(_spender);
213         if (approve(_spender, _value)) {
214             spender.receiveApproval(msg.sender, _value, this, _extraData);
215             return true;
216         }
217     }
218 
219     function allowance(address _holder, address _spender) public view returns (uint256) {
220         return allowed[_holder][_spender];
221     }
222 
223     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
224         require(balances[_holder] >= _amount);
225         if(_termOfRound==0 ) {
226             _termOfRound = 1;
227         }
228         balances[_holder] = balances[_holder].sub(_amount);
229         lockupInfo[_holder].push(
230             LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount)
231         );
232 
233         locks[_holder] = true;
234 
235         emit Lock(_holder, _amount);
236 
237         return true;
238     }
239 
240     function unlock(address _holder, uint256 _idx) public onlyOwner returns (bool) {
241         require(locks[_holder]);
242         require(_idx < lockupInfo[_holder].length);
243         LockupInfo storage lockupinfo = lockupInfo[_holder][_idx];
244         uint256 releaseAmount = lockupinfo.lockupBalance;
245 
246         delete lockupInfo[_holder][_idx];
247         lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
248         lockupInfo[_holder].length -=1;
249         if(lockupInfo[_holder].length == 0) {
250             locks[_holder] = false;
251         }
252 
253         emit Unlock(_holder, releaseAmount);
254         balances[_holder] = balances[_holder].add(releaseAmount);
255 
256         return true;
257     }
258 
259     function freezeAccount(address _holder) public onlyOwner returns (bool) {
260         require(!frozen[_holder]);
261         frozen[_holder] = true;
262         emit Freeze(_holder);
263         return true;
264     }
265 
266     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
267         require(frozen[_holder]);
268         frozen[_holder] = false;
269         emit Unfreeze(_holder);
270         return true;
271     }
272 
273     function getNowTime() public view returns(uint256) {
274         return now;
275     }
276 
277     function showLockState(address _holder, uint256 _idx) public view returns (bool, uint256, uint256, uint256, uint256, uint256) {
278         if(locks[_holder]) {
279             return (
280                 locks[_holder], 
281                 lockupInfo[_holder].length, 
282                 lockupInfo[_holder][_idx].lockupBalance, 
283                 lockupInfo[_holder][_idx].releaseTime, 
284                 lockupInfo[_holder][_idx].termOfRound, 
285                 lockupInfo[_holder][_idx].unlockAmountPerRound
286             );
287         } else {
288             return (
289                 locks[_holder], 
290                 lockupInfo[_holder].length, 
291                 0,0,0,0
292             );
293 
294         }        
295     }
296     
297     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
298         require(_to != address(0));
299         require(_value <= balances[owner]);
300 
301         balances[owner] = balances[owner].sub(_value);
302         balances[_to] = balances[_to].add(_value);
303         emit Transfer(owner, _to, _value);
304         return true;
305     }
306 
307     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
308         distribute(_to, _value);
309         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
310         return true;
311     }
312 
313     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
314         token.transfer(_to, _value);
315         return true;
316     }
317 
318     function burn(uint256 _value) public onlyOwner returns (bool success) {
319         require(_value <= balances[msg.sender]);
320         address burner = msg.sender;
321         balances[burner] = balances[burner].sub(_value);
322         totalSupply_ = totalSupply_.sub(_value);
323         emit Burn(burner, _value);
324         return true;
325     }
326 
327     function isContract(address addr) internal view returns (bool) {
328         uint size;
329         assembly{size := extcodesize(addr)}
330         return size > 0;
331     }
332 
333     function autoUnlock(address _holder) internal returns (bool) {
334 
335         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
336             if(locks[_holder]==false) {
337                 return true;
338             }
339             if (lockupInfo[_holder][idx].releaseTime <= now) {
340                 // If lockupinfo was deleted, loop restart at same position.
341                 if( releaseTimeLock(_holder, idx) ) {
342                     idx -=1;
343                 }
344             }
345         }
346         return true;
347     }
348 
349     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
350         require(locks[_holder]);
351         require(_idx < lockupInfo[_holder].length);
352 
353         // If lock status of holder is finished, delete lockup info. 
354         LockupInfo storage info = lockupInfo[_holder][_idx];
355         uint256 releaseAmount = info.unlockAmountPerRound;
356         uint256 sinceFrom = now.sub(info.releaseTime);
357         uint256 sinceRound = sinceFrom.div(info.termOfRound);
358         releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );
359 
360         if(releaseAmount >= info.lockupBalance) {            
361             releaseAmount = info.lockupBalance;
362 
363             delete lockupInfo[_holder][_idx];
364             lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
365             lockupInfo[_holder].length -=1;
366 
367             if(lockupInfo[_holder].length == 0) {
368                 locks[_holder] = false;
369             }
370             emit Unlock(_holder, releaseAmount);
371             balances[_holder] = balances[_holder].add(releaseAmount);
372             return true;
373         } else {
374             lockupInfo[_holder][_idx].releaseTime = lockupInfo[_holder][_idx].releaseTime.add( sinceRound.add(1).mul(info.termOfRound) );
375             lockupInfo[_holder][_idx].lockupBalance = lockupInfo[_holder][_idx].lockupBalance.sub(releaseAmount);
376             emit Unlock(_holder, releaseAmount);
377             balances[_holder] = balances[_holder].add(releaseAmount);
378             return false;
379         }
380     }
381 
382 
383 }