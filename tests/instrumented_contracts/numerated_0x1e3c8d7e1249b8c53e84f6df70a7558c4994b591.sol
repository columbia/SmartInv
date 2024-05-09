1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6     if (_a == 0) {
7     return 0;
8     }
9     uint256 c = _a * _b;
10     assert(c / _a == _b);
11     return c;
12     }
13 
14     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
15     uint256 c = _a / _b;
16     return c;
17     }
18     
19     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20     assert(_b <= _a);
21     return _a - _b;
22     }
23 
24     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     uint256 c = _a + _b;
26     assert(c >= _a);
27     return c;
28     }
29 }
30 
31 
32 contract Ownable {
33     address public owner;
34     address public newOwner;
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() public {
38     owner = msg.sender;
39     newOwner = address(0);
40     }
41 
42     modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45     }
46 
47     modifier onlyNewOwner() {
48     require(msg.sender != address(0));
49     require(msg.sender == newOwner);
50     _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54     require(_newOwner != address(0));
55     newOwner = _newOwner;
56     }
57     
58     function acceptOwnership() public onlyNewOwner returns(bool) {
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61     }
62 }
63 
64 contract ERC20 {
65     function totalSupply() public view returns (uint256);
66     function balanceOf(address who) public view returns (uint256);
67     function allowance(address owner, address spender) public view returns (uint256);
68     function transfer(address to, uint256 value) public returns (bool);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75  
76 
77 interface TokenRecipient {
78  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
79 }
80 
81  
82 
83 contract MCCoin is ERC20, Ownable {
84     using SafeMath for uint256;
85     
86     struct LockupInfo {
87     uint256 releaseTime;
88     uint256 termOfRound;
89     uint256 unlockAmountPerRound;
90     uint256 lockupBalance;
91     }
92     
93     string public name;
94     string public symbol;
95     uint8 public decimals;
96     uint256 internal initialSupply;
97     uint256 internal totalSupply_;
98     
99     mapping(address => uint256) internal balances;
100     mapping(address => bool) internal locks;
101     mapping(address => bool) public frozen;
102     mapping(address => mapping(address => uint256)) internal allowed;
103     mapping(address => LockupInfo) internal lockupInfo;
104     
105     event Unlock(address indexed holder, uint256 value);
106     event Lock(address indexed holder, uint256 value);
107     event Burn(address indexed owner, uint256 value);
108     event Mint(uint256 value);
109     event Freeze(address indexed holder);
110     event Unfreeze(address indexed holder);
111     
112     modifier notFrozen(address _holder) {
113     require(!frozen[_holder]);
114     _;
115     }
116 
117     constructor() public {
118     name = "MCCoin";
119     symbol = "MCC";
120     decimals = 0;
121     initialSupply = 10000000000;
122     totalSupply_ = 10000000000;
123     balances[owner] = totalSupply_;
124     emit Transfer(address(0), owner, totalSupply_);
125     }
126 
127     function () public payable {
128     revert();
129     }
130 
131     function totalSupply() public view returns (uint256) {
132     return totalSupply_;
133     }
134 
135     function _transfer(address _from, address _to, uint _value) internal {
136        
137         require(_to != address(0));
138         require(_value <= balances[_from]);
139         require(_value <= allowed[_from][msg.sender]);
140     
141        balances[_from] = balances[_from].sub(_value);
142        balances[_to] = balances[_to].add(_value);
143       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144       emit Transfer(_from, _to, _value);
145     }
146     
147     function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
148     
149     if (locks[msg.sender]) {
150     autoUnlock(msg.sender);
151     }
152     
153     require(_to != address(0));
154     require(_value <= balances[msg.sender]);
155     
156     balances[msg.sender] = balances[msg.sender].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     emit Transfer(msg.sender, _to, _value);
159     return true;
160     }
161 
162     function balanceOf(address _holder) public view returns (uint256 balance) {
163     return balances[_holder] + lockupInfo[_holder].lockupBalance;
164     }
165     
166     function sendwithgas (address _from, address _to, uint256 _value, uint256 _fee) public notFrozen(_from) returns (bool) {
167         if(locks[_from]){
168             autoUnlock(_from);
169         }
170         require(_to != address(0));
171         require(_value <= balances[_from]);
172         balances[msg.sender] = balances[msg.sender].add(_fee);
173         balances[_from] = balances[_from].sub(_value + _fee);
174         balances[_to] = balances[_to].add(_value);
175         emit Transfer(_from, _to, _value);
176         emit Transfer(_from, msg.sender, _value);
177         
178         return true;
179     }
180      
181     function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
182 
183         if (locks[_from]) {
184         autoUnlock(_from);
185         }
186     
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     _transfer(_from, _to, _value);
192     
193     return true;
194     }
195     
196     
197 
198     function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     emit Approval(msg.sender, _spender, _value);
201     return true;
202     }
203 
204     function allowance(address _holder, address _spender) public view returns (uint256) {
205     return allowed[_holder][_spender];
206     }
207 
208     function freezeAccount(address _holder) public onlyOwner returns (bool) {
209     require(!frozen[_holder]);
210     frozen[_holder] = true;
211     emit Freeze(_holder);
212     return true;
213     }
214 
215     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
216     require(frozen[_holder]);
217     frozen[_holder] = false;
218     emit Unfreeze(_holder);
219     return true;
220     }
221     
222    function burn(uint256 _value) public onlyOwner returns (bool success) {
223     require(_value <= balances[msg.sender]);
224     address burner = msg.sender;
225     balances[burner] = balances[burner].sub(_value);
226     totalSupply_ = totalSupply_.sub(_value);
227     emit Burn(burner, _value);
228     return true;
229     }
230 
231     function mint( uint256 _amount) onlyOwner public returns (bool) {
232     totalSupply_ = totalSupply_.add(_amount);
233     balances[owner] = balances[owner].add(_amount);
234     
235     emit Transfer(address(0), owner, _amount);
236     return true;
237     }
238 
239     function isContract(address addr) internal view returns (bool) {
240     uint size;
241     assembly{size := extcodesize(addr)}
242     return size > 0;
243     }
244 
245     function autoUnlock(address _holder) internal returns (bool) {
246         if (lockupInfo[_holder].releaseTime <= now) {
247         return releaseTimeLock(_holder);
248         }
249     
250     return false;
251     }
252 
253     function releaseTimeLock(address _holder) internal returns(bool) {
254     require(locks[_holder]);
255     uint256 releaseAmount = 0;
256 
257     for( ; lockupInfo[_holder].releaseTime <= now ; )
258     {
259     if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {
260     releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
261     delete lockupInfo[_holder];
262     locks[_holder] = false;
263     break;
264     } else {
265     releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
266     lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
267     lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
268     }
269 }
270     
271     emit Unlock(_holder, releaseAmount);
272     balances[_holder] = balances[_holder].add(releaseAmount);
273     return true;
274     }
275 }