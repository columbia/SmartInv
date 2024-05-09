1 pragma solidity ^0.4.22;
2 library SafeMath {
3 
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;       
18     }       
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 contract Ownable {
34     address public owner;
35     address public newOwner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     constructor() public {
40         owner = msg.sender;
41         newOwner = address(0);
42     }
43 
44     modifier onlyOwner() { //owner
45         require(msg.sender == owner);
46         _;
47     }
48     modifier onlyNewOwner() {
49         require(msg.sender != address(0));
50         require(msg.sender == newOwner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         require(_newOwner != address(0));
56         newOwner = _newOwner;
57     }
58 
59     function acceptOwnership() public onlyNewOwner returns(bool) {
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62     }
63 }
64 
65 contract Pausable is Ownable {
66   event Pause();
67   event Unpause();
68 
69   bool public paused = false;
70 
71   modifier whenNotPaused() {
72     require(!paused);
73     _;
74   }
75 
76   modifier whenPaused() {
77     require(paused);
78     _;
79   }//pasue check 
80 
81   function pause() onlyOwner whenNotPaused public {
82     paused = true;
83     emit Pause();
84   }
85 
86   function unpause() onlyOwner whenPaused public {
87     paused = false;
88     emit Unpause();
89   }
90 }
91 
92 contract ERC20 {
93     function totalSupply() public view returns (uint256);
94     function balanceOf(address who) public view returns (uint256);
95     function allowance(address owner, address spender) public view returns (uint256);
96     function transfer(address to, uint256 value) public returns (bool);
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98     function approve(address spender, uint256 value) public returns (bool);
99 
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 interface TokenRecipient {
106     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
107 }
108 
109 
110 contract MONYON is ERC20, Ownable, Pausable {
111 
112     uint128 internal MONTH = 30 * 24 * 3600; // 30day,1month
113 
114     using SafeMath for uint256;
115 
116     struct LockupInfo {
117         uint256 releaseTime;
118         uint256 unlockAmountPerMonth;
119         uint256 lockupBalance;
120     }
121 
122     string public name;
123     string public symbol;
124     uint8 public decimals;
125     uint256 internal initialSupply;
126     uint256 internal totalSupply_;
127 
128     mapping(address => uint256) internal balances;
129     mapping(address => bool) internal locks;
130     mapping(address => mapping(address => uint256)) internal allowed;
131     mapping(address => LockupInfo) internal lockupInfo;
132 
133     event Unlock(address indexed holder, uint256 value);
134     event Lock(address indexed holder, uint256 value);
135     event Burn(address indexed owner, uint256 value);
136 
137     constructor() public {
138         name = "MONYON";
139         symbol = "MNO";
140         decimals = 18;
141         initialSupply = 200000000;
142         totalSupply_ = initialSupply * 10 ** uint(decimals);
143         balances[owner] = totalSupply_;
144         emit Transfer(address(0), owner, totalSupply_);
145     }
146 
147     function totalSupply() public view returns (uint256) {
148         return totalSupply_;
149     }
150 
151     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
152         if (locks[msg.sender]) {
153             autoUnlock(msg.sender);            
154         }
155         require(_to != address(0));
156         require(_value <= balances[msg.sender]);
157 
158 
159         // SafeMath.sub will throw if there is not enough balance.
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         emit Transfer(msg.sender, _to, _value);
163         return true;
164     }
165 
166     function balanceOf(address _holder) public view returns (uint256 balance) {
167         return balances[_holder] + lockupInfo[_holder].lockupBalance;
168     }
169 
170     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
171         if (locks[_from]) {
172             autoUnlock(_from);            
173         }
174         require(_to != address(0));
175         require(_value <= balances[_from]);
176         require(_value <= allowed[_from][msg.sender]);
177 
178 
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         emit Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
187         allowed[msg.sender][_spender] = _value;
188         emit Approval(msg.sender, _spender, _value);
189         return true;
190     }
191 
192     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
193         require(isContract(_spender));
194         TokenRecipient spender = TokenRecipient(_spender);
195         if (approve(_spender, _value)) {
196             spender.receiveApproval(msg.sender, _value, this, _extraData);
197             return true;
198         }//approve
199     }
200 
201     function allowance(address _holder, address _spender) public view returns (uint256) {
202         return allowed[_holder][_spender];
203     }
204 
205     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _releaseRate) public onlyOwner returns (bool) {
206         require(locks[_holder] == false);
207         require(balances[_holder] >= _amount);
208         balances[_holder] = balances[_holder].sub(_amount);
209         lockupInfo[_holder] = LockupInfo(_releaseStart, _amount.div(100).mul(_releaseRate), _amount);
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
231     function getNowTime() public view returns(uint256) {
232       return now;//now
233     }
234 
235     function showLockState(address _holder) public view returns (bool, uint256, uint256) {
236         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime);
237     }
238 
239     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
240         require(_to != address(0));
241         require(_value <= balances[owner]);
242 
243         balances[owner] = balances[owner].sub(_value);
244         balances[_to] = balances[_to].add(_value);
245         emit Transfer(owner, _to, _value);
246         return true;
247     }
248 
249     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _releaseRate) public onlyOwner returns (bool) {
250         distribute(_to, _value);
251         lock(_to, _value, _releaseStart, _releaseRate);
252         return true;
253     }
254 
255     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
256         token.transfer(_to, _value);
257         return true;
258     }
259 
260     function burn(uint256 _value) public onlyOwner returns (bool success) {
261         require(_value <= balances[msg.sender]);
262         address burner = msg.sender;
263         balances[burner] = balances[burner].sub(_value);
264         totalSupply_ = totalSupply_.sub(_value);
265         emit Burn(burner, _value);//burn
266         return true;
267     }
268 
269     function isContract(address addr) internal view returns (bool) {
270         uint size;
271         assembly{size := extcodesize(addr)}
272         return size > 0;
273     }
274 
275     function autoUnlock(address _holder) internal returns (bool) {
276         if (lockupInfo[_holder].releaseTime <= now) {
277             return releaseTimeLock(_holder);
278         }
279         return false;
280     }
281 
282     function releaseTimeLock(address _holder) internal returns(bool) {
283         require(locks[_holder]);
284         uint256 releaseAmount = 0;
285         // If lock status of holder is finished, delete lockup info. 
286         if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerMonth) {
287             releaseAmount = lockupInfo[_holder].lockupBalance;
288             delete lockupInfo[_holder];
289             locks[_holder] = false;
290         } else {            
291             releaseAmount = lockupInfo[_holder].unlockAmountPerMonth;
292             lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(MONTH);
293             lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(releaseAmount);
294         }
295         emit Unlock(_holder, releaseAmount);
296         balances[_holder] = balances[_holder].add(releaseAmount);
297         return true;
298     }
299 
300 }