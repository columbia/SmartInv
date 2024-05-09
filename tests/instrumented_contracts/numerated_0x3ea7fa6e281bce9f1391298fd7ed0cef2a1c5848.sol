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
112 contract WXBToken is ERC20, Ownable, Pausable {
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
125     uint8 public decimals;
126     uint256 internal initialSupply;
127     uint256 internal totalSupply_;
128 
129     mapping(address => uint256) internal balances;
130     mapping(address => bool) internal locks;
131     mapping(address => bool) public frozen;
132     mapping(address => mapping(address => uint256)) internal allowed;
133     mapping(address => LockupInfo) internal lockupInfo;
134 
135     event Unlock(address indexed holder, uint256 value);
136     event Lock(address indexed holder, uint256 value);
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
148         name = "weatherblock";
149         symbol = "WXB";
150         decimals = 18;
151         initialSupply = 750000000;
152         totalSupply_ = initialSupply * 10 ** uint(decimals);
153         balances[owner] = totalSupply_;
154         emit Transfer(address(0), owner, totalSupply_);
155     }
156 
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
181         return balances[_holder] + lockupInfo[_holder].lockupBalance;
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
220         require(locks[_holder] == false);
221         require(balances[_holder] >= _amount);
222         balances[_holder] = balances[_holder].sub(_amount);
223         lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount);
224 
225         locks[_holder] = true;
226 
227         emit Lock(_holder, _amount);
228 
229         return true;
230     }
231 
232     function unlock(address _holder) public onlyOwner returns (bool) {
233         require(locks[_holder] == true);
234         uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
235 
236         delete lockupInfo[_holder];
237         locks[_holder] = false;
238 
239         emit Unlock(_holder, releaseAmount);
240         balances[_holder] = balances[_holder].add(releaseAmount);
241 
242         return true;
243     }
244 
245     function freezeAccount(address _holder) public onlyOwner returns (bool) {
246         require(!frozen[_holder]);
247         frozen[_holder] = true;
248         emit Freeze(_holder);
249         return true;
250     }
251 
252     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
253         require(frozen[_holder]);
254         frozen[_holder] = false;
255         emit Unfreeze(_holder);
256         return true;
257     }
258 
259     function getNowTime() public view returns(uint256) {
260       return now;
261     }
262 
263     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
264         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
265     }
266 
267     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
268         require(_to != address(0));
269         require(_value <= balances[owner]);
270 
271         balances[owner] = balances[owner].sub(_value);
272         balances[_to] = balances[_to].add(_value);
273         emit Transfer(owner, _to, _value);
274         return true;
275     }
276 
277     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
278         distribute(_to, _value);
279         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
280         return true;
281     }
282 
283     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
284         token.transfer(_to, _value);
285         return true;
286     }
287 
288     function burn(uint256 _value) public onlyOwner returns (bool success) {
289         require(_value <= balances[msg.sender]);
290         address burner = msg.sender;
291         balances[burner] = balances[burner].sub(_value);
292         totalSupply_ = totalSupply_.sub(_value);
293         emit Burn(burner, _value);
294         return true;
295     }
296 
297     function mint( uint256 _amount) onlyOwner public returns (bool) {
298         totalSupply_ = totalSupply_.add(_amount);
299         balances[owner] = balances[owner].add(_amount);
300 
301         emit Transfer(address(0), owner, _amount);
302         return true;
303     }
304 
305     function isContract(address addr) internal view returns (bool) {
306         uint size;
307         assembly{size := extcodesize(addr)}
308         return size > 0;
309     }
310 
311     function autoUnlock(address _holder) internal returns (bool) {
312         if (lockupInfo[_holder].releaseTime <= now) {
313             return releaseTimeLock(_holder);
314         }
315         return false;
316     }
317 
318     function releaseTimeLock(address _holder) internal returns(bool) {
319         require(locks[_holder]);
320         uint256 releaseAmount = 0;
321         // If lock status of holder is finished, delete lockup info. 
322        
323         for( ; lockupInfo[_holder].releaseTime <= now ; )
324         {
325             if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {   
326                 releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
327                 delete lockupInfo[_holder];
328                 locks[_holder] = false;
329                 break;             
330             } else {
331                 releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
332                 lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
333 
334                 lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
335                 
336             }            
337         }
338 
339         emit Unlock(_holder, releaseAmount);
340         balances[_holder] = balances[_holder].add(releaseAmount);
341         return true;
342     }
343 
344 }