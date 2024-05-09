1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-15
3 */
4 
5 pragma solidity ^0.4.22;
6 
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;       
23     }       
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 
38 contract Ownable {
39     address public owner;
40     address public newOwner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     constructor() public {
45         owner = msg.sender;
46         newOwner = address(0);
47     }
48 
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53     modifier onlyNewOwner() {
54         require(msg.sender != address(0));
55         require(msg.sender == newOwner);
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         require(_newOwner != address(0));
61         newOwner = _newOwner;
62     }
63 
64     function acceptOwnership() public onlyNewOwner returns(bool) {
65         emit OwnershipTransferred(owner, newOwner);        
66         owner = newOwner;
67         newOwner = 0x0;
68     }
69 }
70 
71 contract Pausable is Ownable {
72     event Pause();
73     event Unpause();
74 
75     bool public paused = false;
76 
77     modifier whenNotPaused() {
78         require(!paused);
79         _;
80     }
81 
82     modifier whenPaused() {
83         require(paused);
84         _;
85     }
86 
87     function pause() onlyOwner whenNotPaused public {
88         paused = true;
89         emit Pause();
90     }
91 
92     function unpause() onlyOwner whenPaused public {
93         paused = false;
94         emit Unpause();
95     }
96 }
97 
98 contract ERC20 {
99     function totalSupply() public view returns (uint256);
100     function balanceOf(address who) public view returns (uint256);
101     function allowance(address owner, address spender) public view returns (uint256);
102     function transfer(address to, uint256 value) public returns (bool);
103     function transferFrom(address from, address to, uint256 value) public returns (bool);
104     function approve(address spender, uint256 value) public returns (bool);
105 
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 }
109 
110 
111 interface TokenRecipient {
112     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
113 }
114 
115 
116 contract LandBoxToken is ERC20, Ownable, Pausable {
117 
118     using SafeMath for uint256;
119 
120     struct LockupInfo {
121         uint256 releaseTime;
122         uint256 termOfRound;
123         uint256 unlockAmountPerRound;        
124         uint256 lockupBalance;
125     }
126 
127     string public name;
128     string public symbol;
129     uint8 constant public decimals = 18;
130     uint256 internal initialSupply;
131     uint256 internal totalSupply_;
132 
133     mapping(address => uint256) internal balances;
134     mapping(address => bool) internal locks;
135     mapping(address => bool) public frozen;
136     mapping(address => mapping(address => uint256)) internal allowed;
137     mapping(address => LockupInfo[]) internal lockupInfo;
138 
139     event Lock(address indexed holder, uint256 value);
140     event Unlock(address indexed holder, uint256 value);
141     event Burn(address indexed owner, uint256 value);
142     event Freeze(address indexed holder);
143     event Unfreeze(address indexed holder);
144 
145     modifier notFrozen(address _holder) {
146         require(!frozen[_holder]);
147         _;
148     }
149 
150     constructor() public {
151         name = "LandBox";
152         symbol = "LAND";
153         initialSupply = 20000000000;
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
229         if(_termOfRound==0 ) {
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
278         return now;
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
331     function isContract(address addr) internal view returns (bool) {
332         uint size;
333         assembly{size := extcodesize(addr)}
334         return size > 0;
335     }
336 
337     function autoUnlock(address _holder) internal returns (bool) {
338 
339         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
340             if(locks[_holder]==false) {
341                 return true;
342             }
343             if (lockupInfo[_holder][idx].releaseTime <= now) {
344                 // If lockupinfo was deleted, loop restart at same position.
345                 if( releaseTimeLock(_holder, idx) ) {
346                     idx -=1;
347                 }
348             }
349         }
350         return true;
351     }
352 
353     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
354         require(locks[_holder]);
355         require(_idx < lockupInfo[_holder].length);
356 
357         // If lock status of holder is finished, delete lockup info. 
358         LockupInfo storage info = lockupInfo[_holder][_idx];
359         uint256 releaseAmount = info.unlockAmountPerRound;
360         uint256 sinceFrom = now.sub(info.releaseTime);
361         uint256 sinceRound = sinceFrom.div(info.termOfRound);
362         releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );
363 
364         if(releaseAmount >= info.lockupBalance) {            
365             releaseAmount = info.lockupBalance;
366 
367             delete lockupInfo[_holder][_idx];
368             lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
369             lockupInfo[_holder].length -=1;
370 
371             if(lockupInfo[_holder].length == 0) {
372                 locks[_holder] = false;
373             }
374             emit Unlock(_holder, releaseAmount);
375             balances[_holder] = balances[_holder].add(releaseAmount);
376             return true;
377         } else {
378             lockupInfo[_holder][_idx].releaseTime = lockupInfo[_holder][_idx].releaseTime.add( sinceRound.add(1).mul(info.termOfRound) );
379             lockupInfo[_holder][_idx].lockupBalance = lockupInfo[_holder][_idx].lockupBalance.sub(releaseAmount);
380             emit Unlock(_holder, releaseAmount);
381             balances[_holder] = balances[_holder].add(releaseAmount);
382             return false;
383         }
384     }
385 }