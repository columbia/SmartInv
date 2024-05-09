1 pragma solidity ^0.5.0;
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
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
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
63         newOwner = address(0);
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
106 contract SUMMITZ is ERC20, Ownable, Pausable {
107 
108     using SafeMath for uint256;
109 
110     struct LockupInfo {
111         uint256 releaseTime;
112         uint256 termOfRound;
113         uint256 unlockAmountPerRound;        
114         uint256 lockupBalance;
115     }
116 
117     string public name;
118     string public symbol;
119     uint8 constant public decimals =18;
120     uint256 internal initialSupply;
121     uint256 internal totalSupply_;
122     uint256 public mint_cap;
123 
124     mapping(address => uint256) internal balances;
125     mapping(address => bool) internal locks;
126     mapping(address => bool) public frozen;
127     mapping(address => mapping(address => uint256)) internal allowed;
128     mapping(address => LockupInfo[]) internal lockupInfo;
129 
130     event Lock(address indexed holder, uint256 value);
131     event Unlock(address indexed holder, uint256 value);
132     event Burn(address indexed owner, uint256 value);
133     event Mint(uint256 value);
134     event Freeze(address indexed holder);
135     event Unfreeze(address indexed holder);
136 
137     modifier notFrozen(address _holder) {
138         require(!frozen[_holder]);
139         _;
140     }
141 
142     constructor() public {
143         name = "SUMMITZ";
144         symbol = "SUM";
145         initialSupply = 3000000000; //3,000,000,000
146         totalSupply_ = initialSupply * 10 ** uint(decimals);
147         mint_cap = totalSupply_;
148         balances[owner] = totalSupply_;
149         emit Transfer(address(0), owner, totalSupply_);
150     }
151 
152     function totalSupply() public view returns (uint256) {
153         return totalSupply_;
154     }
155 
156     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
157         if (locks[msg.sender]) {
158             autoUnlock(msg.sender);            
159         }
160         require(_to != address(0));
161         require(_value <= balances[msg.sender]);
162         
163 
164         // SafeMath.sub will throw if there is not enough balance.
165         balances[msg.sender] = balances[msg.sender].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         emit Transfer(msg.sender, _to, _value);
168         return true;
169     }
170 
171     function balanceOf(address _holder) public view returns (uint256 balance) {
172         uint256 lockedBalance = 0;
173         if(locks[_holder]) {
174             for(uint256 idx = 0; idx < lockupInfo[_holder].length ; idx++ ) {
175                 lockedBalance = lockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
176             }
177         }
178         return balances[_holder] + lockedBalance;
179     }
180 
181     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
182         if (locks[_from]) {
183             autoUnlock(_from);            
184         }
185         require(_to != address(0));
186         require(_value <= balances[_from]);
187         require(_value <= allowed[_from][msg.sender]);
188         
189 
190         balances[_from] = balances[_from].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193         emit Transfer(_from, _to, _value);
194         return true;
195     }
196 
197     function approve(address _spender, uint256 _value) public returns (bool) {
198         allowed[msg.sender][_spender] = _value;
199         emit Approval(msg.sender, _spender, _value);
200         return true;
201     }
202 
203     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
204         require(spender != address(0));
205         allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
206         
207         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
208         return true;
209     }
210 
211     function decreaseAllowance( address spender, uint256 subtractedValue) public returns (bool) {
212         require(spender != address(0));
213         allowed[msg.sender][spender] = (allowed[msg.sender][spender].sub(subtractedValue));
214 
215         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
216         return true;
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
320         emit Transfer(burner, address(0), _value);
321         return true;
322     }
323 
324     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
325         require(totalSupply_.add(_amount) <= mint_cap);
326         totalSupply_ = totalSupply_.add(_amount);
327         balances[_to] = balances[_to].add(_amount);
328         emit Transfer(address(0), _to, _amount);
329         return true;
330     }
331 
332     function autoUnlock(address _holder) internal returns (bool) {
333 
334         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
335             if(locks[_holder]==false) {
336                 return true;
337             }
338             if (lockupInfo[_holder][idx].releaseTime <= now) {
339                 if( releaseTimeLock(_holder, idx) ) {
340                     idx -=1;
341                 }
342             }
343         }
344         return true;
345     }
346 
347     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
348         require(locks[_holder]);
349         require(_idx < lockupInfo[_holder].length);
350 
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
379 }