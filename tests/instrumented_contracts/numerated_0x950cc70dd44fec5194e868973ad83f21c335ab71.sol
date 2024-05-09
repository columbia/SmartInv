1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, May 29, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.4;
6 
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract Ownable {
37     address public owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address newOwner) public onlyOwner {
51         require(newOwner != address(0));
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     }
55 
56 }
57 
58 contract ERC20Basic {
59     function totalSupply() public view returns (uint256);
60     function balanceOf(address who) public view returns (uint256);
61     function transfer(address to, uint256 value) public returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67 
68     mapping(address => uint256) balances;
69 
70     uint256 totalSupply_;
71 
72     function totalSupply() public view returns (uint256) {
73         return totalSupply_;
74     }
75 
76     function transfer(address _to, uint256 _value) public returns (bool) {
77         require(_to != address(0));
78         require(_value <= balances[msg.sender]);
79 
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function balanceOf(address _owner) public view returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90 }
91 
92 contract BurnableToken is BasicToken {
93 
94     event Burn(address indexed burner, uint256 value);
95 
96     function burn(uint256 _value) public {
97         require(_value <= balances[msg.sender]);
98 
99         address burner = msg.sender;
100         balances[burner] = balances[burner].sub(_value);
101         totalSupply_ = totalSupply_.sub(_value);
102         emit Burn(burner, _value);
103     }
104 }
105 
106 contract ERC20 is ERC20Basic {
107     function allowance(address owner, address spender) public view returns (uint256);
108     function transferFrom(address from, address to, uint256 value) public returns (bool);
109     function approve(address spender, uint256 value) public returns (bool);
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 contract StandardToken is ERC20, BasicToken {
114 
115     mapping (address => mapping (address => uint256)) internal allowed;
116 
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118         require(_to != address(0));
119         require(_value <= balances[_from]);
120         require(_value <= allowed[_from][msg.sender]);
121        
122         
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         emit Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     function approve(address _spender, uint256 _value) public returns (bool) {
131         allowed[msg.sender][_spender] = _value;
132         emit Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     function allowance(address _owner, address _spender) public view returns (uint256) {
137         return allowed[_owner][_spender];
138     }
139 
140     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
141         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
142         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143         return true;
144     }
145 
146     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
147         uint oldValue = allowed[msg.sender][_spender];
148         if (_subtractedValue > oldValue) {
149             allowed[msg.sender][_spender] = 0;
150         } else {
151             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
152         }
153         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154         return true;
155     }
156 
157 }
158 
159 contract Pausable is Ownable {
160     event Pause();
161     event Unpause();
162 
163     address public distributionContract;
164 
165     bool distributionContractAdded;
166     bool public paused = false;
167 
168     function addDistributionContract(address _contract) external {
169         require(_contract != address(0));
170         require(distributionContractAdded == false);
171 
172         distributionContract = _contract;
173         distributionContractAdded = true;
174     }
175 
176     modifier whenNotPaused() {
177         if(msg.sender != distributionContract) {
178             require(!paused);
179         }
180         _;
181     }
182 
183     modifier whenPaused() {
184         require(paused);
185         _;
186     }
187 
188     function pause() onlyOwner whenNotPaused public {
189         paused = true;
190         emit Pause();
191     }
192 
193     function unpause() onlyOwner whenPaused public {
194         paused = false;
195         emit Unpause();
196     }
197 }
198 
199 contract PausableToken is StandardToken, Pausable {
200 
201     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
202         return super.transfer(_to, _value);
203     }
204 
205     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
206         return super.transferFrom(_from, _to, _value);
207     }
208 
209     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
210         return super.approve(_spender, _value);
211     }
212 
213     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
214         return super.increaseApproval(_spender, _addedValue);
215     }
216 
217     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
218         return super.decreaseApproval(_spender, _subtractedValue);
219     }
220 }
221 
222 contract FreezableToken is StandardToken, Ownable {
223     mapping (address => bool) public frozenAccounts;
224     event FrozenFunds(address target, bool frozen);
225 
226     function freezeAccount(address target) public onlyOwner {
227         frozenAccounts[target] = true;
228         emit FrozenFunds(target, true);
229     }
230 
231     function unFreezeAccount(address target) public onlyOwner {
232         frozenAccounts[target] = false;
233         emit FrozenFunds(target, false);
234     }
235 
236     function frozen(address _target) view public returns (bool){
237         return frozenAccounts[_target];
238     }
239 
240     modifier canTransfer(address _sender) {
241         require(!frozenAccounts[_sender]);
242         _;
243     }
244 
245     function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool success) {
246         return super.transfer(_to, _value);
247     }
248 
249     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns (bool success) {
250         return super.transferFrom(_from, _to, _value);
251     }
252 }
253 
254 contract TimeLockToken is StandardToken, Ownable {
255     mapping (address => uint) public timelockAccounts;
256     event TimeLockFunds(address target, uint releasetime);
257 
258     function timelockAccount(address target, uint releasetime) public onlyOwner {
259         uint r_time;
260         r_time = now + (releasetime * 1 days);
261         timelockAccounts[target] = r_time;
262         emit TimeLockFunds(target, r_time);
263     }
264 
265     function timeunlockAccount(address target) public onlyOwner {
266         timelockAccounts[target] = now;
267         emit TimeLockFunds(target, now);
268     }
269 
270     function releasetime(address _target) view public returns (uint){
271         return timelockAccounts[_target];
272     }
273 
274     modifier ReleaseTimeTransfer(address _sender) {
275         require(now >= timelockAccounts[_sender]);
276         _;
277     }
278 
279     function transfer(address _to, uint256 _value) public ReleaseTimeTransfer(msg.sender) returns (bool success) {
280         return super.transfer(_to, _value);
281     }
282 
283     function transferFrom(address _from, address _to, uint256 _value) public ReleaseTimeTransfer(_from) returns (bool success) {
284         return super.transferFrom(_from, _to, _value);
285     }
286 }
287 
288 contract HAPPYTCON is TimeLockToken, FreezableToken, PausableToken, BurnableToken {
289     string public constant name = "Happytcon";
290     string public constant symbol = "HPTC";
291     uint public constant decimals = 18;
292 
293     uint public constant INITIAL_SUPPLY = 1000000000 * (10 ** decimals);
294 
295     constructor() public {
296         totalSupply_ = INITIAL_SUPPLY;
297         balances[msg.sender] = totalSupply_;
298         emit Transfer(address(0), msg.sender, totalSupply_);
299     }
300 }