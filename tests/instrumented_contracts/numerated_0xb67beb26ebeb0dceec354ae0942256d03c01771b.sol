1 pragma solidity ^0.4.22;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;       
20     }       
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract Ownable {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     constructor() public {
42         owner = msg.sender;
43         newOwner = address(0);
44     }
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50     modifier onlyNewOwner() {
51         require(msg.sender != address(0));
52         require(msg.sender == newOwner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         require(_newOwner != address(0));
58         newOwner = _newOwner;
59     }
60 
61     function acceptOwnership() public onlyNewOwner returns(bool) {
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64     }
65 }
66 
67 contract Pausable is Ownable {
68   event Pause();
69   event Unpause();
70 
71   bool public paused = false;
72 
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   modifier whenPaused() {
79     require(paused);
80     _;
81   }
82 
83   function pause() onlyOwner whenNotPaused public {
84     paused = true;
85     emit Pause();
86   }
87 
88   function unpause() onlyOwner whenPaused public {
89     paused = false;
90     emit Unpause();
91   }
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
112 contract DSToken is ERC20, Ownable, Pausable {
113 
114     uint128 internal MONTH = 30 * 24 * 3600; // 1 month
115 
116     using SafeMath for uint256;
117 
118     struct LockupInfo {
119         uint256 releaseTime;
120         uint256 termOfRound;
121         uint256 unlockAmountPerRound;        
122         uint256 lockupBalance;
123     }
124 
125     string public name;
126     string public symbol;
127     uint8 public decimals;
128     uint256 internal initialSupply;
129     uint256 internal totalSupply_;
130 
131     mapping(address => uint256) internal balances;
132     mapping(address => bool) internal locks;
133     mapping(address => bool) public frozen;
134     mapping(address => mapping(address => uint256)) internal allowed;
135     mapping(address => LockupInfo[]) internal lockupInfo;
136 
137     event Unlock(address indexed holder, uint256 value);
138     event Lock(address indexed holder, uint256 value);
139     event Burn(address indexed owner, uint256 value);
140     event Mint(uint256 value);
141     event Freeze(address indexed holder);
142     event Unfreeze(address indexed holder);
143 
144     modifier notFrozen(address _holder) {
145         require(!frozen[_holder]);
146         _;
147     }
148 
149     constructor() public {
150         name = "DS Token";
151         symbol = "DS";
152         decimals = 18;
153         initialSupply = 10000000000;
154         totalSupply_ = initialSupply * 10 ** uint(decimals);
155         balances[owner] = totalSupply_;
156         emit Transfer(address(0), owner, totalSupply_);
157     }
158 
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
223     function allowance(address _holder, address _spender) public view returns (uint256) {
224         return allowed[_holder][_spender];
225     }
226 
227     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
228         require(balances[_holder] >= _amount);
229         if(_termOfRound ==0) {
230             _termOfRound = 1;
231         }
232         balances[_holder] = balances[_holder].sub(_amount);
233         lockupInfo[_holder].push(
234             LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount)
235         );
236 
237         locks[_holder] = true;
238 
239         emit Lock(_holder, _amount);
240 
241         return true;
242     }
243 
244     function unlock(address _holder, uint256 _idx) public onlyOwner returns (bool) {
245         require(locks[_holder]);
246         require(_idx < lockupInfo[_holder].length);
247         LockupInfo storage lockupinfo = lockupInfo[_holder][_idx];
248         uint256 releaseAmount = lockupinfo.lockupBalance;
249 
250         delete lockupInfo[_holder][_idx];
251         lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
252         lockupInfo[_holder].length -=1;
253         if(lockupInfo[_holder].length == 0) {
254             locks[_holder] = false;
255         }
256 
257         emit Unlock(_holder, releaseAmount);
258         balances[_holder] = balances[_holder].add(releaseAmount);
259 
260         return true;
261     }
262 
263     function freezeAccount(address _holder) public onlyOwner returns (bool) {
264         require(!frozen[_holder]);
265         frozen[_holder] = true;
266         emit Freeze(_holder);
267         return true;
268     }
269 
270     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
271         require(frozen[_holder]);
272         frozen[_holder] = false;
273         emit Unfreeze(_holder);
274         return true;
275     }
276 
277     function getNowTime() public view returns(uint256) {
278       return now;
279     }
280 
281     function showLockState(address _holder, uint256 _idx) public view returns (bool, uint256, uint256, uint256, uint256, uint256) {
282         if(locks[_holder]) {
283             return (
284                 locks[_holder], 
285                 lockupInfo[_holder].length, 
286                 lockupInfo[_holder][_idx].lockupBalance, 
287                 lockupInfo[_holder][_idx].releaseTime, 
288                 lockupInfo[_holder][_idx].termOfRound, 
289                 lockupInfo[_holder][_idx].unlockAmountPerRound
290             );
291         } else {
292             return (
293                 locks[_holder], 
294                 lockupInfo[_holder].length, 
295                 0,0,0,0
296             );
297 
298         }        
299     }
300     
301     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
302         require(_to != address(0));
303         require(_value <= balances[owner]);
304 
305         balances[owner] = balances[owner].sub(_value);
306         balances[_to] = balances[_to].add(_value);
307         emit Transfer(owner, _to, _value);
308         return true;
309     }
310 
311     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
312         distribute(_to, _value);
313         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
314         return true;
315     }
316 
317     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
318         token.transfer(_to, _value);
319         return true;
320     }
321 
322     function burn(uint256 _value) public onlyOwner returns (bool success) {
323         require(_value <= balances[msg.sender]);
324         address burner = msg.sender;
325         balances[burner] = balances[burner].sub(_value);
326         totalSupply_ = totalSupply_.sub(_value);
327         emit Burn(burner, _value);
328         return true;
329     }
330 
331     function mint( uint256 _amount) onlyOwner public returns (bool) {
332         totalSupply_ = totalSupply_.add(_amount);
333         balances[owner] = balances[owner].add(_amount);
334 
335         emit Transfer(address(0), owner, _amount);
336         return true;
337     }
338 
339     function isContract(address addr) internal view returns (bool) {
340         uint size;
341         assembly{size := extcodesize(addr)}
342         return size > 0;
343     }
344 
345     function autoUnlock(address _holder) internal returns (bool) {
346 
347         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
348             if(locks[_holder]==false) {
349                 return true;
350             }
351             if (lockupInfo[_holder][idx].releaseTime <= now) {
352                 // If lockupinfo was deleted, loop restart at same position.
353                 if( releaseTimeLock(_holder, idx) ) {
354                     idx -=1;
355                 }
356             }
357         }
358         return true;
359     }
360 
361     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
362         require(locks[_holder]);
363         require(_idx < lockupInfo[_holder].length);
364 
365         // If lock status of holder is finished, delete lockup info. 
366         LockupInfo storage info = lockupInfo[_holder][_idx];
367         uint256 releaseAmount = info.unlockAmountPerRound;
368         uint256 sinceFrom = now.sub(info.releaseTime);
369         uint256 sinceRound = sinceFrom.div(info.termOfRound);
370         releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );
371 
372         if(releaseAmount >= info.lockupBalance) {            
373             releaseAmount = info.lockupBalance;
374 
375             delete lockupInfo[_holder][_idx];
376             lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
377             lockupInfo[_holder].length -=1;
378 
379             if(lockupInfo[_holder].length == 0) {
380                 locks[_holder] = false;
381             }
382             emit Unlock(_holder, releaseAmount);
383             balances[_holder] = balances[_holder].add(releaseAmount);
384             return true;
385         } else {
386             lockupInfo[_holder][_idx].releaseTime = lockupInfo[_holder][_idx].releaseTime.add( sinceRound.add(1).mul(info.termOfRound) );
387             lockupInfo[_holder][_idx].lockupBalance = lockupInfo[_holder][_idx].lockupBalance.sub(releaseAmount);
388             emit Unlock(_holder, releaseAmount);
389             balances[_holder] = balances[_holder].add(releaseAmount);
390             return false;
391         }
392     }
393 
394 
395 }