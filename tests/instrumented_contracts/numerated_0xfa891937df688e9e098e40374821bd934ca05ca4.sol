1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-11
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;       
24     }       
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 
39 contract Ownable {
40     address public owner;
41     address public newOwner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     constructor() public {
46         owner = msg.sender;
47         newOwner = address(0);
48     }
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54     modifier onlyNewOwner() {
55         require(msg.sender != address(0));
56         require(msg.sender == newOwner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         require(_newOwner != address(0));
62         newOwner = _newOwner;
63     }
64 
65     function acceptOwnership() public onlyNewOwner returns(bool) {
66         emit OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68     }
69 }
70 
71 contract Pausable is Ownable {
72   event Pause();
73   event Unpause();
74 
75   bool public paused = false;
76 
77   modifier whenNotPaused() {
78     require(!paused);
79     _;
80   }
81 
82   modifier whenPaused() {
83     require(paused);
84     _;
85   }
86 
87   function pause() onlyOwner whenNotPaused public {
88     paused = true;
89     emit Pause();
90   }
91 
92   function unpause() onlyOwner whenPaused public {
93     paused = false;
94     emit Unpause();
95   }
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
116 contract HWQCToken is ERC20, Ownable, Pausable {
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
129     uint8 public decimals;
130     uint256 internal initialSupply;
131     uint256 internal totalSupply_;
132 
133     mapping(address => uint256) internal balances;
134     mapping(address => bool) internal locks;
135     mapping(address => bool) public frozen;
136     mapping(address => mapping(address => uint256)) internal allowed;
137     mapping(address => LockupInfo) internal lockupInfo;
138 
139     event Unlock(address indexed holder, uint256 value);
140     event Lock(address indexed holder, uint256 value);
141     event Burn(address indexed owner, uint256 value);
142     event Mint(uint256 value);
143     event Freeze(address indexed holder);
144     event Unfreeze(address indexed holder);
145 
146     modifier notFrozen(address _holder) {
147         require(!frozen[_holder]);
148         _;
149     }
150 
151     constructor() public {
152         name = "HighWay Q Coin ";
153         symbol = "HWQC";
154         decimals = 18;
155         initialSupply = 3000000000;
156         totalSupply_ = initialSupply * 10 ** uint(decimals);
157         balances[owner] = totalSupply_;
158         emit Transfer(address(0), owner, totalSupply_);
159     }
160 
161     function () public payable {
162         revert();
163     }
164 
165     function totalSupply() public view returns (uint256) {
166         return totalSupply_;
167     }
168 
169     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
170         if (locks[msg.sender]) {
171             autoUnlock(msg.sender);            
172         }
173         require(_to != address(0));
174         require(_value <= balances[msg.sender]);
175         
176 
177         // SafeMath.sub will throw if there is not enough balance.
178         balances[msg.sender] = balances[msg.sender].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         emit Transfer(msg.sender, _to, _value);
181         return true;
182     }
183 
184     function balanceOf(address _holder) public view returns (uint balance) {
185         return balances[_holder];
186     }
187     
188     function lockupBalance(address _holder) public view returns (uint256 balance) {
189         return lockupInfo[_holder].lockupBalance;
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
228         require(locks[_holder] == false);
229         require(_releaseStart > now);
230         require(_termOfRound > 0);
231         require(_amount.mul(_releaseRate).div(100) > 0);
232         require(balances[_holder] >= _amount);
233         balances[_holder] = balances[_holder].sub(_amount);
234         lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.mul(_releaseRate).div(100), _amount);
235         
236         locks[_holder] = true;
237         
238         emit Lock(_holder, _amount);
239         
240         return true;
241     }
242     
243 
244     function unlock(address _holder) public onlyOwner returns (bool) {
245         require(locks[_holder] == true);
246         uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
247 
248         delete lockupInfo[_holder];
249         locks[_holder] = false;
250 
251         emit Unlock(_holder, releaseAmount);
252         balances[_holder] = balances[_holder].add(releaseAmount);
253 
254         return true;
255     }
256 
257     function freezeAccount(address _holder) public onlyOwner returns (bool) {
258         require(!frozen[_holder]);
259         frozen[_holder] = true;
260         emit Freeze(_holder);
261         return true;
262     }
263 
264     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
265         require(frozen[_holder]);
266         frozen[_holder] = false;
267         emit Unfreeze(_holder);
268         return true;
269     }
270 
271     function getNowTime() public view returns(uint256) {
272       return now;
273     }
274 
275     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
276         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
277     }
278 
279     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
280         require(_to != address(0));
281         require(_value <= balances[owner]);
282 
283         balances[owner] = balances[owner].sub(_value);
284         balances[_to] = balances[_to].add(_value);
285         emit Transfer(owner, _to, _value);
286         return true;
287     }
288 
289     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
290         distribute(_to, _value);
291         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
292         return true;
293     }
294 
295     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
296         token.transfer(_to, _value);
297         return true;
298     }
299 
300     function burn(uint256 _value) public onlyOwner returns (bool success) {
301         require(_value <= balances[msg.sender]);
302         address burner = msg.sender;
303         balances[burner] = balances[burner].sub(_value);
304         totalSupply_ = totalSupply_.sub(_value);
305         emit Burn(burner, _value);
306         return true;
307     }
308 
309     function mint( uint256 _amount) onlyOwner public returns (bool) {
310         totalSupply_ = totalSupply_.add(_amount);
311         balances[owner] = balances[owner].add(_amount);
312 
313         emit Transfer(address(0), owner, _amount);
314         return true;
315     }
316 
317     function isContract(address addr) internal view returns (bool) {
318         uint size;
319         assembly{size := extcodesize(addr)}
320         return size > 0;
321     }
322 
323     function autoUnlock(address _holder) internal returns (bool) {
324         if (lockupInfo[_holder].releaseTime <= now) {
325             return releaseTimeLock(_holder);
326         }
327         return false;
328     }
329 
330     function releaseTimeLock(address _holder) internal returns(bool) {
331         require(locks[_holder]);
332         uint256 releaseAmount = 0;
333         // If lock status of holder is finished, delete lockup info. 
334        
335         for( ; lockupInfo[_holder].releaseTime <= now ; )
336         {
337             if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {   
338                 releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
339                 delete lockupInfo[_holder];
340                 locks[_holder] = false;
341                 break;             
342             } else {
343                 releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
344                 lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
345 
346                 lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
347                 
348             }            
349         }
350 
351         emit Unlock(_holder, releaseAmount);
352         balances[_holder] = balances[_holder].add(releaseAmount);
353         return true;
354     }
355 
356 }