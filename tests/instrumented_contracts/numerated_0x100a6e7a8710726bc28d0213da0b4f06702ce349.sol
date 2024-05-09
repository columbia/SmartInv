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
50     
51     modifier onlyNewOwner() {
52         require(msg.sender != address(0));
53         require(msg.sender == newOwner);
54         _;
55     }
56 
57     function transferOwnership(address _newOwner) public onlyOwner {
58         require(_newOwner != address(0));
59         newOwner = _newOwner;
60     }
61 
62     function acceptOwnership() public onlyNewOwner returns(bool) {
63         emit OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65     }
66 }
67 
68 contract Pausable is Ownable {
69   event Pause();
70   event Unpause();
71 
72   bool public paused = false;
73 
74   modifier whenNotPaused() {
75     require(!paused);
76     _;
77   }
78 
79   modifier whenPaused() {
80     require(paused);
81     _;
82   }
83 
84   function pause() onlyOwner whenNotPaused public {
85     paused = true;
86     emit Pause();
87   }
88 
89   function unpause() onlyOwner whenPaused public {
90     paused = false;
91     emit Unpause();
92   }
93 }
94 
95 contract ERC20 {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function allowance(address owner, address spender) public view returns (uint256);
99     function transfer(address to, uint256 value) public returns (bool);
100     function transferFrom(address from, address to, uint256 value) public returns (bool);
101     function approve(address spender, uint256 value) public returns (bool);
102 
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 
108 interface TokenRecipient {
109     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
110 }
111 
112 
113 contract LitecoinDiamond is ERC20, Ownable, Pausable {
114     
115     using SafeMath for uint256;
116 
117     struct LockupInfo {
118         uint256 releaseTime;
119         uint256 termOfRound;
120         uint256 unlockAmountPerRound;        
121         uint256 lockupBalance;
122     }
123 
124     string public name;
125     string public symbol;
126     uint8 public decimals;
127     uint256 internal initialSupply;
128     uint256 internal totalSupply_;
129 
130     mapping(address => uint256) internal balances;
131     mapping(address => bool) internal locks;
132     mapping(address => bool) public frozen;
133     mapping(address => mapping(address => uint256)) internal allowed;
134     mapping(address => LockupInfo) internal lockupInfo;
135 
136     event Unlock(address indexed holder, uint256 value);
137     event Lock(address indexed holder, uint256 value);
138     event Burn(address indexed owner, uint256 value);
139     event Freeze(address indexed holder);
140     event Unfreeze(address indexed holder);
141 
142     modifier notFrozen(address _holder) {
143         require(!frozen[_holder]);
144         _;
145     }
146     
147     constructor() public payable{
148         name = "LitecoinDiamond";
149         symbol = "LTCD";
150         decimals = 0;
151         initialSupply = 840000000;
152         totalSupply_ = initialSupply * 10 ** uint(decimals);
153         balances[owner] = totalSupply_;
154         emit Transfer(address(0), owner, totalSupply_);
155     }
156 
157     function () external payable {
158         revert();
159         
160     }
161 
162     function totalSupply() public view returns (uint256) {
163         return totalSupply_;
164     }
165 
166     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
167         if (locks[msg.sender]) {
168             autoUnlock(msg.sender);            
169         }   
170         require(_to != address(0));
171         require(_value <= balances[msg.sender]);
172         
173 
174         // SafeMath.sub will throw if there is not enough balance.
175         balances[msg.sender] = balances[msg.sender].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         emit Transfer(msg.sender, _to, _value);
178         return true;
179     }
180 
181     function balanceOf(address _holder) public view returns (uint256 balance) {
182         return balances[_holder] + lockupInfo[_holder].lockupBalance;
183     }
184 
185     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
186         if (locks[_from]) {
187             autoUnlock(_from);            
188         }
189         require(_to != address(0));
190         require(_value <= balances[_from]);
191         require(_value <= allowed[_from][msg.sender]);
192         
193 
194         balances[_from] = balances[_from].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
197         emit Transfer(_from, _to, _value);
198         return true;
199     }
200 
201     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206     
207     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
208         require(isContract(_spender));
209         TokenRecipient spender = TokenRecipient(_spender);
210         if (approve(_spender, _value)) {
211             //to do
212             //spender.receiveApproval(msg.sender, _value, this.address, _extraData);
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
299     function isContract(address addr) internal view returns (bool) {
300         uint size;
301         assembly{size := extcodesize(addr)}
302         return size > 0;
303     }
304 
305     function autoUnlock(address _holder) internal returns (bool) {
306         if (lockupInfo[_holder].releaseTime <= now) {
307             return releaseTimeLock(_holder);
308         } 
309         return false;
310     }
311 
312     function releaseTimeLock(address _holder) internal returns(bool) {
313         require(locks[_holder]);
314         uint256 releaseAmount = 0;
315         // If lock status of holder is finished, delete lockup info. 
316        
317         for( ; lockupInfo[_holder].releaseTime <= now ; )
318         {
319             if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {   
320                 releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
321                 delete lockupInfo[_holder];
322                 locks[_holder] = false;
323                 break;             
324             } else {
325                 releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
326                 lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
327 
328                 lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
329                 
330             }            
331         }
332 
333         emit Unlock(_holder, releaseAmount);
334         balances[_holder] = balances[_holder].add(releaseAmount);
335         return true;
336     }
337 
338 }