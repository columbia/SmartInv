1 pragma solidity ^0.4.22;
2 //code by h4nuko0n(wooyoung han)
3 //hanu@cloudus.dev
4 //lockable,pasuable token 
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;       
21     }       
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 contract Ownable {
37     address public owner;
38     address public newOwner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor() public {
43         owner = msg.sender;
44         newOwner = address(0);
45     }
46 
47     modifier onlyOwner() { //owner
48         require(msg.sender == owner);
49         _;
50     }
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
82   }//pasue check 
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
109     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
110 }
111 
112 
113 contract KAKITOKEN is ERC20, Ownable, Pausable {
114 
115     uint128 internal MONTH = 30 * 24 * 3600; // 30day,1month
116 
117     using SafeMath for uint256;
118 
119     struct LockupInfo {
120         uint256 releaseTime;
121         uint256 unlockAmountPerMonth;
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
133     mapping(address => mapping(address => uint256)) internal allowed;
134     mapping(address => LockupInfo) internal lockupInfo;
135 
136     event Unlock(address indexed holder, uint256 value);
137     event Lock(address indexed holder, uint256 value);
138     event Burn(address indexed owner, uint256 value);
139 
140     constructor() public {
141         name = "KAKI";
142         symbol = "KAKI";
143         decimals = 18;
144         initialSupply = 2000000000;
145         totalSupply_ = initialSupply * 10 ** uint(decimals);
146         balances[owner] = totalSupply_;
147         emit Transfer(address(0), owner, totalSupply_);
148     }
149 
150     function totalSupply() public view returns (uint256) {
151         return totalSupply_;
152     }
153 
154     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
155         if (locks[msg.sender]) {
156             autoUnlock(msg.sender);            
157         }
158         require(_to != address(0));
159         require(_value <= balances[msg.sender]);
160         
161 
162         // SafeMath.sub will throw if there is not enough balance.
163         balances[msg.sender] = balances[msg.sender].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         emit Transfer(msg.sender, _to, _value);
166         return true;
167     }
168 
169     function balanceOf(address _holder) public view returns (uint256 balance) {
170         return balances[_holder] + lockupInfo[_holder].lockupBalance;
171     }
172 
173     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
174         if (locks[_from]) {
175             autoUnlock(_from);            
176         }
177         require(_to != address(0));
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180         
181 
182         balances[_from] = balances[_from].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185         emit Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
190         allowed[msg.sender][_spender] = _value;
191         emit Approval(msg.sender, _spender, _value);
192         return true;
193     }
194     
195     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
196         require(isContract(_spender));
197         TokenRecipient spender = TokenRecipient(_spender);
198         if (approve(_spender, _value)) {
199             spender.receiveApproval(msg.sender, _value, this, _extraData);
200             return true;
201         }//approve
202     }
203 
204     function allowance(address _holder, address _spender) public view returns (uint256) {
205         return allowed[_holder][_spender];
206     }
207 
208     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _releaseRate) public onlyOwner returns (bool) {
209         require(locks[_holder] == false);
210         require(balances[_holder] >= _amount);
211         balances[_holder] = balances[_holder].sub(_amount);
212         lockupInfo[_holder] = LockupInfo(_releaseStart, _amount.div(100).mul(_releaseRate), _amount);
213 
214         locks[_holder] = true;
215 
216         emit Lock(_holder, _amount);
217 
218         return true;
219     }
220 
221     function unlock(address _holder) public onlyOwner returns (bool) {
222         require(locks[_holder] == true);
223         uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
224 
225         delete lockupInfo[_holder];
226         locks[_holder] = false;
227 
228         emit Unlock(_holder, releaseAmount);
229         balances[_holder] = balances[_holder].add(releaseAmount);
230 
231         return true;
232     }
233 
234     function getNowTime() public view returns(uint256) {
235       return now;//now
236     }
237 
238     function showLockState(address _holder) public view returns (bool, uint256, uint256) {
239         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime);
240     }
241 
242     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
243         require(_to != address(0));
244         require(_value <= balances[owner]);
245 
246         balances[owner] = balances[owner].sub(_value);
247         balances[_to] = balances[_to].add(_value);
248         emit Transfer(owner, _to, _value);
249         return true;
250     }
251 
252     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _releaseRate) public onlyOwner returns (bool) {
253         distribute(_to, _value);
254         lock(_to, _value, _releaseStart, _releaseRate);
255         return true;
256     }
257 
258     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
259         token.transfer(_to, _value);
260         return true;
261     }
262 
263     function burn(uint256 _value) public onlyOwner returns (bool success) {
264         require(_value <= balances[msg.sender]);
265         address burner = msg.sender;
266         balances[burner] = balances[burner].sub(_value);
267         totalSupply_ = totalSupply_.sub(_value);
268         emit Burn(burner, _value);//burn
269         return true;
270     }
271 
272     function isContract(address addr) internal view returns (bool) {
273         uint size;
274         assembly{size := extcodesize(addr)}
275         return size > 0;
276     }
277 
278     function autoUnlock(address _holder) internal returns (bool) {
279         if (lockupInfo[_holder].releaseTime <= now) {
280             return releaseTimeLock(_holder);
281         }
282         return false;
283     }
284 
285     function releaseTimeLock(address _holder) internal returns(bool) {
286         require(locks[_holder]);
287         uint256 releaseAmount = 0;
288         // If lock status of holder is finished, delete lockup info. 
289         if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerMonth) {
290             releaseAmount = lockupInfo[_holder].lockupBalance;
291             delete lockupInfo[_holder];
292             locks[_holder] = false;
293         } else {            
294             releaseAmount = lockupInfo[_holder].unlockAmountPerMonth;
295             lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(MONTH);
296             lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(releaseAmount);
297         }
298         emit Unlock(_holder, releaseAmount);
299         balances[_holder] = balances[_holder].add(releaseAmount);
300         return true;
301     }
302 
303 }