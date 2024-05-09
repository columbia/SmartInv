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
112 contract BAIToken is ERC20, Ownable, Pausable {
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
135     mapping(address => LockupInfo) internal lockupInfo;
136 
137     event Unlock(address indexed holder, uint256 value);
138     event Lock(address indexed holder, uint256 value);
139     event Burn(address indexed owner, uint256 value);
140     //event Mint(uint256 value);
141     event Freeze(address indexed holder);
142     event Unfreeze(address indexed holder);
143 
144     modifier notFrozen(address _holder) {
145         require(!frozen[_holder]);
146         _;
147     }
148 
149     constructor() public {
150         name = "BAI Token";
151         symbol = "BAI";
152         decimals = 18;
153         initialSupply = 300000000000;
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
183         return balances[_holder] + lockupInfo[_holder].lockupBalance;
184     }
185 
186     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
187         if (locks[_from]) {
188             autoUnlock(_from);            
189         }
190         require(_to != address(0));
191         require(_value <= balances[_from]);
192         require(_value <= allowed[_from][msg.sender]);
193         
194 
195         balances[_from] = balances[_from].sub(_value);
196         balances[_to] = balances[_to].add(_value);
197         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198         emit Transfer(_from, _to, _value);
199         return true;
200     }
201 
202     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
203         allowed[msg.sender][_spender] = _value;
204         emit Approval(msg.sender, _spender, _value);
205         return true;
206     }
207     
208     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
209         require(isContract(_spender));
210         TokenRecipient spender = TokenRecipient(_spender);
211         if (approve(_spender, _value)) {
212             spender.receiveApproval(msg.sender, _value, this, _extraData);
213             return true;
214         }
215     }
216 
217     function allowance(address _holder, address _spender) public view returns (uint256) {
218         return allowed[_holder][_spender];
219     }
220 
221     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
222         require(locks[_holder] == false);
223         require(balances[_holder] >= _amount);
224         balances[_holder] = balances[_holder].sub(_amount);
225         lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount);
226 
227         locks[_holder] = true;
228 
229         emit Lock(_holder, _amount);
230 
231         return true;
232     }
233 
234     function unlock(address _holder) public onlyOwner returns (bool) {
235         require(locks[_holder] == true);
236         uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
237 
238         delete lockupInfo[_holder];
239         locks[_holder] = false;
240 
241         emit Unlock(_holder, releaseAmount);
242         balances[_holder] = balances[_holder].add(releaseAmount);
243 
244         return true;
245     }
246 
247     function freezeAccount(address _holder) public onlyOwner returns (bool) {
248         require(!frozen[_holder]);
249         frozen[_holder] = true;
250         emit Freeze(_holder);
251         return true;
252     }
253 
254     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
255         require(frozen[_holder]);
256         frozen[_holder] = false;
257         emit Unfreeze(_holder);
258         return true;
259     }
260 
261     function getNowTime() public view returns(uint256) {
262       return now;
263     }
264 
265     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
266         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
267     }
268 
269     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
270         require(_to != address(0));
271         require(_value <= balances[owner]);
272 
273         balances[owner] = balances[owner].sub(_value);
274         balances[_to] = balances[_to].add(_value);
275         emit Transfer(owner, _to, _value);
276         return true;
277     }
278 
279     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
280         distribute(_to, _value);
281         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
282         return true;
283     }
284 
285     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
286         token.transfer(_to, _value);
287         return true;
288     }
289 
290     function burn(uint256 _value) public onlyOwner returns (bool success) {
291         require(_value <= balances[msg.sender]);
292         address burner = msg.sender;
293         balances[burner] = balances[burner].sub(_value);
294         totalSupply_ = totalSupply_.sub(_value);
295         emit Burn(burner, _value);
296         return true;
297     }
298 
299     /*
300     function mint( uint256 _amount) onlyOwner public returns (bool) {
301         totalSupply_ = totalSupply_.add(_amount);
302         balances[owner] = balances[owner].add(_amount);
303 
304         emit Transfer(address(0), owner, _amount);
305         return true;
306     }
307     */
308 
309     function isContract(address addr) internal view returns (bool) {
310         uint size;
311         assembly{size := extcodesize(addr)}
312         return size > 0;
313     }
314 
315     function autoUnlock(address _holder) internal returns (bool) {
316         if (lockupInfo[_holder].releaseTime <= now) {
317             return releaseTimeLock(_holder);
318         }
319         return false;
320     }
321 
322     function releaseTimeLock(address _holder) internal returns(bool) {
323         require(locks[_holder]);
324         uint256 releaseAmount = 0;
325         // If lock status of holder is finished, delete lockup info. 
326        
327         for( ; lockupInfo[_holder].releaseTime <= now ; )
328         {
329             if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {   
330                 releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
331                 delete lockupInfo[_holder];
332                 locks[_holder] = false;
333                 break;             
334             } else {
335                 releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
336                 lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
337 
338                 lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
339                 
340             }            
341         }
342 
343         emit Unlock(_holder, releaseAmount);
344         balances[_holder] = balances[_holder].add(releaseAmount);
345         return true;
346     }
347     // TODO:
348 
349 
350 }