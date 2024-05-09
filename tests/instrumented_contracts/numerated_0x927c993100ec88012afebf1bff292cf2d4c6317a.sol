1 pragma solidity ^0.5.4;
2 
3 library SafeMath {
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
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 
52 }
53 
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract BasicToken is ERC20Basic {
62     using SafeMath for uint256;
63 
64     mapping(address => uint256) balances;
65 
66     uint256 totalSupply_;
67 
68     function totalSupply() public view returns (uint256) {
69         return totalSupply_;
70     }
71 
72     function transfer(address _to, uint256 _value) public returns (bool) {
73         require(_to != address(0));
74         require(_value <= balances[msg.sender]);
75 
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         emit Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     function balanceOf(address _owner) public view returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86 }
87 
88 contract BurnableToken is BasicToken {
89 
90     event Burn(address indexed burner, uint256 value);
91 
92     function burn(uint256 _value) public {
93         require(_value <= balances[msg.sender]);
94 
95         address burner = msg.sender;
96         balances[burner] = balances[burner].sub(_value);
97         totalSupply_ = totalSupply_.sub(_value);
98         emit Burn(burner, _value);
99     }
100 }
101 
102 contract ERC20 is ERC20Basic {
103     function allowance(address owner, address spender) public view returns (uint256);
104     function transferFrom(address from, address to, uint256 value) public returns (bool);
105     function approve(address spender, uint256 value) public returns (bool);
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 contract StandardToken is ERC20, BasicToken {
110 
111     mapping (address => mapping (address => uint256)) internal allowed;
112 
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[_from]);
116         require(_value <= allowed[_from][msg.sender]);
117        
118         
119         balances[_from] = balances[_from].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         emit Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function approve(address _spender, uint256 _value) public returns (bool) {
127         allowed[msg.sender][_spender] = _value;
128         emit Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     function allowance(address _owner, address _spender) public view returns (uint256) {
133         return allowed[_owner][_spender];
134     }
135 
136     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
137         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
138         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139         return true;
140     }
141 
142     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
143         uint oldValue = allowed[msg.sender][_spender];
144         if (_subtractedValue > oldValue) {
145             allowed[msg.sender][_spender] = 0;
146         } else {
147             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
148         }
149         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150         return true;
151     }
152 
153 }
154 
155 contract Pausable is Ownable {
156     event Pause();
157     event Unpause();
158 
159     address public distributionContract;
160 
161     bool distributionContractAdded;
162     bool public paused = false;
163 
164     function addDistributionContract(address _contract) external {
165         require(_contract != address(0));
166         require(distributionContractAdded == false);
167 
168         distributionContract = _contract;
169         distributionContractAdded = true;
170     }
171 
172     modifier whenNotPaused() {
173         if(msg.sender != distributionContract) {
174             require(!paused);
175         }
176         _;
177     }
178 
179     modifier whenPaused() {
180         require(paused);
181         _;
182     }
183 
184     function pause() onlyOwner whenNotPaused public {
185         paused = true;
186         emit Pause();
187     }
188 
189     function unpause() onlyOwner whenPaused public {
190         paused = false;
191         emit Unpause();
192     }
193 }
194 
195 contract PausableToken is StandardToken, Pausable {
196 
197     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
198         return super.transfer(_to, _value);
199     }
200 
201     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
202         return super.transferFrom(_from, _to, _value);
203     }
204 
205     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
206         return super.approve(_spender, _value);
207     }
208 
209     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
210         return super.increaseApproval(_spender, _addedValue);
211     }
212 
213     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
214         return super.decreaseApproval(_spender, _subtractedValue);
215     }
216 }
217 
218 contract FreezableToken is StandardToken, Ownable {
219     mapping (address => bool) public frozenAccounts;
220     event FrozenFunds(address target, bool frozen);
221 
222     function freezeAccount(address target) public onlyOwner {
223         frozenAccounts[target] = true;
224         emit FrozenFunds(target, true);
225     }
226 
227     function unFreezeAccount(address target) public onlyOwner {
228         frozenAccounts[target] = false;
229         emit FrozenFunds(target, false);
230     }
231 
232     function frozen(address _target) view public returns (bool){
233         return frozenAccounts[_target];
234     }
235 
236     modifier canTransfer(address _sender) {
237         require(!frozenAccounts[_sender]);
238         _;
239     }
240 
241     function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool success) {
242         return super.transfer(_to, _value);
243     }
244 
245     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns (bool success) {
246         return super.transferFrom(_from, _to, _value);
247     }
248 }
249 
250 contract TimeLockToken is StandardToken, Ownable {
251     mapping (address => uint) public timelockAccounts;
252     event TimeLockFunds(address target, uint releasetime);
253 
254     function timelockAccount(address target, uint releasetime) public onlyOwner {
255         uint r_time;
256         r_time = now + (releasetime * 1 days);
257         timelockAccounts[target] = r_time;
258         emit TimeLockFunds(target, r_time);
259     }
260 
261     function timeunlockAccount(address target) public onlyOwner {
262         timelockAccounts[target] = now;
263         emit TimeLockFunds(target, now);
264     }
265 
266     function releasetime(address _target) view public returns (uint){
267         return timelockAccounts[_target];
268     }
269 
270     modifier ReleaseTimeTransfer(address _sender) {
271         require(now >= timelockAccounts[_sender]);
272         _;
273     }
274 
275     function transfer(address _to, uint256 _value) public ReleaseTimeTransfer(msg.sender) returns (bool success) {
276         return super.transfer(_to, _value);
277     }
278 
279     function transferFrom(address _from, address _to, uint256 _value) public ReleaseTimeTransfer(_from) returns (bool success) {
280         return super.transferFrom(_from, _to, _value);
281     }
282 }
283 
284 contract BNSToken is TimeLockToken, FreezableToken, PausableToken, BurnableToken {
285     string public constant name = "BNS";
286     string public constant symbol = "BNS";
287     uint public constant decimals = 18;
288 
289     uint public constant INITIAL_SUPPLY = 2799811359 * (10 ** decimals);
290 
291     constructor() public {
292         totalSupply_ = INITIAL_SUPPLY;
293         balances[msg.sender] = totalSupply_;
294         emit Transfer(address(0), msg.sender, totalSupply_);
295     }
296 }