1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
5     if (_a == 0) {
6       return 0;
7     }
8     uint256 c = _a * _b;
9     require(c / _a == _b);
10     return c;
11   }
12 
13   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     require(_b > 0);
15     uint256 c = _a / _b;
16     return c;
17   }
18 
19   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20     require(_b <= _a);
21     uint256 c = _a - _b;
22     return c;
23   }
24 
25   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
26     uint256 c = _a + _b;
27     require(c >= _a);
28     return c;
29   }
30 }
31 
32 library Roles {
33   struct Role {
34     mapping (address => bool) bearer;
35   }
36 
37   function add(Role storage _role, address _account) internal {
38     require(_account != address(0));
39     _role.bearer[_account] = true;
40   }
41 
42   function remove(Role storage _role, address _account) internal {
43     require(_account != address(0));
44     _role.bearer[_account] = false;
45   }
46 
47   function has(Role storage _role, address _account) internal view returns (bool)
48   {
49     require(_account != address(0));
50     return _role.bearer[_account];
51   }
52 }
53 
54 interface IERC20 {
55   function totalSupply() external view returns (uint256);
56 
57   function balanceOf(address _who) external view returns (uint256);
58 
59   function allowance(address _owner, address _spender) external view returns (uint256);
60 
61   function transfer(address _to, uint256 _value) external returns (bool);
62 
63   function approve(address _spender, uint256 _value) external returns (bool);
64 
65   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
66 
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract ERC20 is IERC20 {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) private balances;
76 
77   mapping(address => mapping (address => uint256)) private allowed;
78 
79   uint256 private totalSupply_;
80 
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   function balanceOf(address _owner) public view returns (uint256) {
86     return balances[_owner];
87   }
88 
89   function allowance(address _owner, address _spender) public view returns (uint256) {
90     return allowed[_owner][_spender];
91   }
92 
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_value <= balances[msg.sender]);
95     require(_to != address(0));
96 
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     emit Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     require(_spender != address(0));
105     
106     allowed[msg.sender][_spender] = _value;
107     emit Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114     require(_to != address(0));
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     emit Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
124     require(_spender != address(0));
125 
126     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131   function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
132     require(_spender != address(0));
133 
134     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].sub(_subtractedValue));
135     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139   function _mint(address _account, uint256 _amount) internal {
140     require(_account != 0);
141 
142     totalSupply_ = totalSupply_.add(_amount);
143     balances[_account] = balances[_account].add(_amount);
144     emit Transfer(address(0), _account, _amount);
145   }
146 
147   function _burn(address _account, uint256 _amount) internal {
148     require(_account != 0);
149     require(_amount <= balances[_account]);
150 
151     totalSupply_ = totalSupply_.sub(_amount);
152     balances[_account] = balances[_account].sub(_amount);
153     emit Transfer(_account, address(0), _amount);
154   }
155 }
156 
157 contract PauserRole {
158   using Roles for Roles.Role;
159 
160   event PauserAdded(address indexed _account);
161   event PauserRemoved(address indexed _account);
162 
163   Roles.Role private pausers;
164 
165   constructor() public {
166     addPauser_(msg.sender);
167   }
168 
169   modifier onlyPauser() {
170     require(isPauser(msg.sender));
171     _;
172   }
173 
174   function isPauser(address _account) public view returns (bool) {
175     return pausers.has(_account);
176   }
177 
178   function addPauser(address _account) public onlyPauser {
179     addPauser_(_account);
180   }
181 
182   function renouncePauser() public {
183     removePauser_(msg.sender);
184   }
185 
186   function addPauser_(address _account) internal {
187     pausers.add(_account);
188     emit PauserAdded(_account);
189   }
190 
191   function removePauser_(address _account) internal {
192     pausers.remove(_account);
193     emit PauserRemoved(_account);
194   }
195 }
196 
197 contract Pausable is PauserRole {
198   event Pause();
199   event Unpause();
200 
201   bool private paused_ = false;
202 
203   function paused() public view returns(bool) {
204     return paused_;
205   }
206 
207   modifier whenNotPaused() {
208     require(!paused_);
209     _;
210   }
211 
212   modifier whenPaused() {
213     require(paused_);
214     _;
215   }
216 
217   function pause() public onlyPauser whenNotPaused {
218     paused_ = true;
219     emit Pause();
220   }
221 
222   function unpause() public onlyPauser whenPaused {
223     paused_ = false;
224     emit Unpause();
225   }
226 }
227 
228 contract ERC20Pausable is ERC20, Pausable {
229   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
230     return super.transfer(_to, _value);
231   }
232 
233   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
234     return super.transferFrom(_from, _to, _value);
235   }
236 
237   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
238     return super.approve(_spender, _value);
239   }
240 
241   function increaseAllowance(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
242     return super.increaseAllowance(_spender, _addedValue);
243   }
244 
245   function decreaseAllowance(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
246     return super.decreaseAllowance(_spender, _subtractedValue);
247   }
248 }
249 
250 contract ERC20Burnable is ERC20 {
251   function burn(uint256 value) public {
252     _burn(msg.sender, value);
253   }
254 }
255 
256 contract BMToken is ERC20Pausable, ERC20Burnable {
257   string public constant name = "Boombit Token";
258   string public constant symbol = "BM";
259   uint8 public constant decimals = 18;
260   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
261 
262   constructor() public {
263     _mint(msg.sender, INITIAL_SUPPLY);
264   }
265 }