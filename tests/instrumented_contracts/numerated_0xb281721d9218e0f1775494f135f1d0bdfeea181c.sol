1 pragma solidity >=0.4.22 <0.6.0;
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
106 contract COZi is ERC20, Ownable, Pausable {
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
119     uint8 public decimals;
120     uint256 internal initialSupply;
121     uint256 internal totalSupply_;
122 
123     mapping(address => uint256) internal balances;
124     mapping(address => bool) internal locks;
125     mapping(address => bool) public frozen;
126     mapping(address => mapping(address => uint256)) internal allowed;
127     mapping(address => LockupInfo) internal lockupInfo;
128 
129     event Unlock(address indexed holder, uint256 value);
130     event Lock(address indexed holder, uint256 value);
131     event Burn(address indexed owner, uint256 value);
132     event Mint(uint256 value);
133     event Freeze(address indexed holder);
134     event Unfreeze(address indexed holder);
135 
136     modifier notFrozen(address _holder) {
137         require(!frozen[_holder]);
138         _;
139     }
140     
141     constructor() public payable{
142         name = "COZi";
143         symbol = "COZi";
144         decimals = 18;
145         initialSupply = 12000000;
146         totalSupply_ = initialSupply * 10 ** uint(decimals);
147         balances[owner] = totalSupply_;
148         emit Transfer(address(0), owner, totalSupply_);
149     }
150 
151     function () external payable {
152         revert();
153         
154     }
155 
156     function totalSupply() public view returns (uint256) {
157         return totalSupply_;
158     }
159 
160     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
161         if (locks[msg.sender]) {
162             autoUnlock(msg.sender);            
163         }   
164         require(_to != address(0));
165         require(_value <= balances[msg.sender]);
166         
167 
168         // SafeMath.sub will throw if there is not enough balance.
169         balances[msg.sender] = balances[msg.sender].sub(_value);
170         balances[_to] = balances[_to].add(_value);
171         emit Transfer(msg.sender, _to, _value);
172         return true;
173     }
174 
175     function balanceOf(address _holder) public view returns (uint256 balance) {
176         return balances[_holder] + lockupInfo[_holder].lockupBalance;
177     }
178 
179     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
180         if (locks[_from]) {
181             autoUnlock(_from);            
182         }
183         require(_to != address(0));
184         require(_value <= balances[_from]);
185         require(_value <= allowed[_from][msg.sender]);
186         
187 
188         balances[_from] = balances[_from].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191         emit Transfer(_from, _to, _value);
192         return true;
193     }
194 
195     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
196         allowed[msg.sender][_spender] = _value;
197         emit Approval(msg.sender, _spender, _value);
198         return true;
199     }
200     
201     function allowance(address _holder, address _spender) public view returns (uint256) {
202         return allowed[_holder][_spender];
203     }
204 
205     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
206         require(locks[_holder] == false);
207         require(balances[_holder] >= _amount);
208         balances[_holder] = balances[_holder].sub(_amount);
209         lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount);
210 
211         locks[_holder] = true; 
212 
213         emit Lock(_holder, _amount);
214 
215         return true;
216     }
217 
218     function unlock(address _holder) public onlyOwner returns (bool) {
219         require(locks[_holder] == true);
220         uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
221 
222         delete lockupInfo[_holder];
223         locks[_holder] = false;
224 
225         emit Unlock(_holder, releaseAmount);
226         balances[_holder] = balances[_holder].add(releaseAmount);
227 
228         return true;
229     }
230 
231     function freezeAccount(address _holder) public onlyOwner returns (bool) {
232         require(!frozen[_holder]);
233         frozen[_holder] = true;
234         emit Freeze(_holder);
235         return true;
236     }
237 
238     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
239         require(frozen[_holder]);
240         frozen[_holder] = false;
241         emit Unfreeze(_holder);
242         return true;
243     }
244 
245     function getNowTime() public view returns(uint256) {
246       return now;
247     }
248 
249     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
250         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
251     }
252 
253     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
254         require(_to != address(0));
255         require(_value <= balances[owner]);
256 
257         balances[owner] = balances[owner].sub(_value);
258         balances[_to] = balances[_to].add(_value);
259         emit Transfer(owner, _to, _value);
260         return true;
261     }
262 
263     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
264         distribute(_to, _value);
265         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
266         return true;
267     }
268 
269     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
270         token.transfer(_to, _value);
271         return true;
272     }
273 
274     function burn(uint256 _value) public onlyOwner returns (bool success) {
275         require(_value <= balances[msg.sender]);
276         address burner = msg.sender;
277         balances[burner] = balances[burner].sub(_value);
278         totalSupply_ = totalSupply_.sub(_value);
279         emit Burn(burner, _value);
280         return true;
281     }
282 
283     function mint( uint256 _amount) onlyOwner public returns (bool) {
284         totalSupply_ = totalSupply_.add(_amount);
285         balances[owner] = balances[owner].add(_amount);
286 
287         emit Transfer(address(0), owner, _amount);
288         return true;
289     }
290 
291     function isContract(address addr) internal view returns (bool) {
292         uint size;
293         assembly{size := extcodesize(addr)}
294         return size > 0;
295     }
296 
297     function autoUnlock(address _holder) internal returns (bool) {
298         if (lockupInfo[_holder].releaseTime <= now) {
299             return releaseTimeLock(_holder);
300         } 
301         return false;
302     }
303 
304     function releaseTimeLock(address _holder) internal returns(bool) {
305         require(locks[_holder]);
306         uint256 releaseAmount = 0;
307         // If lock status of holder is finished, delete lockup info. 
308        
309         for( ; lockupInfo[_holder].releaseTime <= now ; )
310         {
311             if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {   
312                 releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
313                 delete lockupInfo[_holder];
314                 locks[_holder] = false;
315                 break;             
316             } else {
317                 releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
318                 lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
319 
320                 lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
321                 
322             }            
323         }
324 
325         emit Unlock(_holder, releaseAmount);
326         balances[_holder] = balances[_holder].add(releaseAmount);
327         return true;
328     }
329 
330 }