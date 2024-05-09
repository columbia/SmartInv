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
112 contract CASTWEETTOKEN is ERC20, Ownable, Pausable {
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
137     event Burn(address indexed owner, uint256 value);
138 
139     constructor() public {
140         name = "CASTWEET";
141         symbol = "CTT";
142         decimals = 18;
143         initialSupply = 2000000000;
144         totalSupply_ = initialSupply * 10 ** uint(decimals);
145         balances[owner] = totalSupply_;
146         emit Transfer(address(0), owner, totalSupply_);
147     }
148 
149     function totalSupply() public view returns (uint256) {
150         return totalSupply_;
151     }
152 
153     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
154         if (locks[msg.sender]) {
155             autoUnlock(msg.sender);            
156         }
157         require(_to != address(0));
158         require(_value <= balances[msg.sender]);
159         
160 
161         // SafeMath.sub will throw if there is not enough balance.
162         balances[msg.sender] = balances[msg.sender].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         emit Transfer(msg.sender, _to, _value);
165         return true;
166     }
167 
168     function balanceOf(address _holder) public view returns (uint256 balance) {
169         return balances[_holder] + lockupInfo[_holder].lockupBalance;
170     }
171 
172     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
173         if (locks[_from]) {
174             autoUnlock(_from);            
175         }
176         require(_to != address(0));
177         require(_value <= balances[_from]);
178         require(_value <= allowed[_from][msg.sender]);
179         
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         emit Transfer(_from, _to, _value);
185         return true;
186     }
187 
188     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193     
194     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
195         require(isContract(_spender));
196         TokenRecipient spender = TokenRecipient(_spender);
197         if (approve(_spender, _value)) {
198             spender.receiveApproval(msg.sender, _value, this, _extraData);
199             return true;
200         }
201     }
202 
203     function allowance(address _holder, address _spender) public view returns (uint256) {
204         return allowed[_holder][_spender];
205     }
206 
207     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _releaseRate) public onlyOwner returns (bool) {
208         require(locks[_holder] == false);
209         require(balances[_holder] >= _amount);
210         balances[_holder] = balances[_holder].sub(_amount);
211         lockupInfo[_holder] = LockupInfo(_releaseStart, _amount.div(100).mul(_releaseRate), _amount);
212 
213         locks[_holder] = true;
214 
215         emit Lock(_holder, _amount);
216 
217         return true;
218     }
219 
220     function unlock(address _holder) public onlyOwner returns (bool) {
221         require(locks[_holder] == true);
222         uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
223 
224         delete lockupInfo[_holder];
225         locks[_holder] = false;
226 
227         emit Unlock(_holder, releaseAmount);
228         balances[_holder] = balances[_holder].add(releaseAmount);
229 
230         return true;
231     }
232 
233     function getNowTime() public view returns(uint256) {
234       return now;
235     }
236 
237     function showLockState(address _holder) public view returns (bool, uint256, uint256) {
238         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime);
239     }
240 
241     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
242         require(_to != address(0));
243         require(_value <= balances[owner]);
244 
245         balances[owner] = balances[owner].sub(_value);
246         balances[_to] = balances[_to].add(_value);
247         emit Transfer(owner, _to, _value);
248         return true;
249     }
250 
251     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _releaseRate) public onlyOwner returns (bool) {
252         distribute(_to, _value);
253         lock(_to, _value, _releaseStart, _releaseRate);
254         return true;
255     }
256 
257     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
258         token.transfer(_to, _value);
259         return true;
260     }
261 
262     function burn(uint256 _value) public onlyOwner returns (bool success) {
263         require(_value <= balances[msg.sender]);
264         address burner = msg.sender;
265         balances[burner] = balances[burner].sub(_value);
266         totalSupply_ = totalSupply_.sub(_value);
267         emit Burn(burner, _value);
268         return true;
269     }
270 
271     function isContract(address addr) internal view returns (bool) {
272         uint size;
273         assembly{size := extcodesize(addr)}
274         return size > 0;
275     }
276 
277     function autoUnlock(address _holder) internal returns (bool) {
278         if (lockupInfo[_holder].releaseTime <= now) {
279             return releaseTimeLock(_holder);
280         }
281         return false;
282     }
283 
284     function releaseTimeLock(address _holder) internal returns(bool) {
285         require(locks[_holder]);
286         uint256 releaseAmount = 0;
287         // If lock status of holder is finished, delete lockup info. 
288         if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerMonth) {
289             releaseAmount = lockupInfo[_holder].lockupBalance;
290             delete lockupInfo[_holder];
291             locks[_holder] = false;
292         } else {            
293             releaseAmount = lockupInfo[_holder].unlockAmountPerMonth;
294             lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(MONTH);
295             lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(releaseAmount);
296         }
297         emit Unlock(_holder, releaseAmount);
298         balances[_holder] = balances[_holder].add(releaseAmount);
299         return true;
300     }
301 
302 }