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
112 contract PRASMToken is ERC20, Ownable, Pausable {
113 
114     uint128 internal MONTH = 30 * 24 * 3600; // 1 month
115 
116     using SafeMath for uint256;
117 
118     struct LockupInfo {
119         uint256 releaseTime;
120         uint256 unlockAmountPerMonth;
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
132     mapping(address => mapping(address => uint256)) internal allowed;
133     mapping(address => LockupInfo) internal lockupInfo;
134 
135     event Unlock(address indexed holder, uint256 value);
136     event Lock(address indexed holder, uint256 value);
137 
138     constructor() public {
139         name = "PRASM";
140         symbol = "PSM";
141         decimals = 18;
142         initialSupply = 4000000000;
143         totalSupply_ = initialSupply * 10 ** uint(decimals);
144         balances[owner] = totalSupply_;
145         emit Transfer(address(0), owner, totalSupply_);
146     }
147 
148     function () public payable {
149         revert();
150     }
151 
152     function totalSupply() public view returns (uint256) {
153         return totalSupply_;
154     }
155 
156     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
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
172         return balances[_holder] + lockupInfo[_holder].lockupBalance;
173     }
174 
175     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
176         if (locks[_from]) {
177             autoUnlock(_from);            
178         }
179         require(_to != address(0));
180         require(_value <= balances[_from]);
181         require(_value <= allowed[_from][msg.sender]);
182         
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
192         allowed[msg.sender][_spender] = _value;
193         emit Approval(msg.sender, _spender, _value);
194         return true;
195     }
196     
197     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
198         require(isContract(_spender));
199         TokenRecipient spender = TokenRecipient(_spender);
200         if (approve(_spender, _value)) {
201             spender.receiveApproval(msg.sender, _value, this, _extraData);
202             return true;
203         }
204     }
205 
206     function allowance(address _holder, address _spender) public view returns (uint256) {
207         return allowed[_holder][_spender];
208     }
209 
210     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _releaseRate) public onlyOwner returns (bool) {
211         require(locks[_holder] == false);
212         require(balances[_holder] >= _amount);
213         balances[_holder] = balances[_holder].sub(_amount);
214         lockupInfo[_holder] = LockupInfo(_releaseStart, _amount.div(100).mul(_releaseRate), _amount);
215 
216         locks[_holder] = true;
217 
218         emit Lock(_holder, _amount);
219 
220         return true;
221     }
222 
223     function unlock(address _holder) public onlyOwner returns (bool) {
224         require(locks[_holder] == true);
225         uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
226 
227         delete lockupInfo[_holder];
228         locks[_holder] = false;
229 
230         emit Unlock(_holder, releaseAmount);
231         balances[_holder] = balances[_holder].add(releaseAmount);
232 
233         return true;
234     }
235 
236     function getNowTime() public view returns(uint256) {
237       return now;
238     }
239 
240     function showLockState(address _holder) public view returns (bool, uint256, uint256) {
241         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime);
242     }
243 
244     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
245         require(_to != address(0));
246         require(_value <= balances[owner]);
247 
248         balances[owner] = balances[owner].sub(_value);
249         balances[_to] = balances[_to].add(_value);
250         emit Transfer(owner, _to, _value);
251         return true;
252     }
253 
254     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _releaseRate) public onlyOwner returns (bool) {
255         distribute(_to, _value);
256         lock(_to, _value, _releaseStart, _releaseRate);
257         return true;
258     }
259 
260     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
261         token.transfer(_to, _value);
262         return true;
263     }
264 
265     function isContract(address addr) internal view returns (bool) {
266         uint size;
267         assembly{size := extcodesize(addr)}
268         return size > 0;
269     }
270 
271     function autoUnlock(address _holder) internal returns (bool) {
272         if (lockupInfo[_holder].releaseTime <= now) {
273             return releaseTimeLock(_holder);
274         }
275         return false;
276     }
277 
278     function releaseTimeLock(address _holder) internal returns(bool) {
279         require(locks[_holder]);
280         uint256 releaseAmount = 0;
281 
282         if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerMonth) {
283             releaseAmount = lockupInfo[_holder].lockupBalance;
284             delete lockupInfo[_holder];
285             locks[_holder] = false;
286         } else {            
287             releaseAmount = lockupInfo[_holder].unlockAmountPerMonth;
288             lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(MONTH);
289             lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(releaseAmount);
290         }
291         emit Unlock(_holder, releaseAmount);
292         balances[_holder] = balances[_holder].add(releaseAmount);
293         return true;
294     }
295 
296 }