1 pragma solidity 0.4.25;
2 
3 library SafeMath256 {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint256 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     function _validateAddress(address _addr) internal pure {
45         require(_addr != address(0), "invalid address");
46     }
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner, "not a contract owner");
54         _;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         _validateAddress(newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 
63 }
64 
65 contract Controllable is Ownable {
66     mapping(address => bool) controllers;
67 
68     modifier onlyController {
69         require(_isController(msg.sender), "no controller rights");
70         _;
71     }
72 
73     function _isController(address _controller) internal view returns (bool) {
74         return controllers[_controller];
75     }
76 
77     function _setControllers(address[] _controllers) internal {
78         for (uint256 i = 0; i < _controllers.length; i++) {
79             _validateAddress(_controllers[i]);
80             controllers[_controllers[i]] = true;
81         }
82     }
83 }
84 
85 contract Upgradable is Controllable {
86     address[] internalDependencies;
87     address[] externalDependencies;
88 
89     function getInternalDependencies() public view returns(address[]) {
90         return internalDependencies;
91     }
92 
93     function getExternalDependencies() public view returns(address[]) {
94         return externalDependencies;
95     }
96 
97     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
98         for (uint256 i = 0; i < _newDependencies.length; i++) {
99             _validateAddress(_newDependencies[i]);
100         }
101         internalDependencies = _newDependencies;
102     }
103 
104     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
105         externalDependencies = _newDependencies;
106         _setControllers(_newDependencies);
107     }
108 }
109 
110 interface IERC20 {
111   function totalSupply() external view returns (uint256);
112 
113   function balanceOf(address who) external view returns (uint256);
114 
115   function allowance(address owner, address spender)
116     external view returns (uint256);
117 
118   function transfer(address to, uint256 value) external returns (bool);
119 
120   function approve(address spender, uint256 value)
121     external returns (bool);
122 
123   function transferFrom(address from, address to, uint256 value)
124     external returns (bool);
125 
126   event Transfer(
127     address indexed from,
128     address indexed to,
129     uint256 value
130   );
131 
132   event Approval(
133     address indexed owner,
134     address indexed spender,
135     uint256 value
136   );
137 }
138 
139 contract ERC20 is IERC20 {
140     using SafeMath256 for uint256;
141 
142     mapping (address => uint256) _balances;
143 
144     mapping (address => mapping (address => uint256)) _allowed;
145 
146     uint256 _totalSupply;
147 
148     string public name;
149     string public symbol;
150     uint8 public decimals;
151 
152     function totalSupply() public view returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(address owner) public view returns (uint256) {
157         return _balances[owner];
158     }
159 
160     function allowance(
161         address owner,
162         address spender
163     )
164       public
165       view
166       returns (uint256)
167     {
168         return _allowed[owner][spender];
169     }
170 
171     function transfer(address to, uint256 value) public returns (bool) {
172         _transfer(msg.sender, to, value);
173         return true;
174     }
175 
176     function _validateAddress(address _addr) internal pure {
177         require(_addr != address(0), "invalid address");
178     }
179 
180     function approve(address spender, uint256 value) public returns (bool) {
181         _validateAddress(spender);
182 
183         _allowed[msg.sender][spender] = value;
184         emit Approval(msg.sender, spender, value);
185         return true;
186     }
187 
188     function transferFrom(
189         address from,
190         address to,
191         uint256 value
192     )
193       public
194       returns (bool)
195     {
196         require(value <= _allowed[from][msg.sender], "not enough allowed tokens");
197 
198         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
199         _transfer(from, to, value);
200         return true;
201     }
202 
203     function increaseAllowance(
204         address spender,
205         uint256 addedValue
206     )
207       public
208       returns (bool)
209     {
210         _validateAddress(spender);
211 
212         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
213         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
214         return true;
215     }
216 
217     function decreaseAllowance(
218         address spender,
219         uint256 subtractedValue
220     )
221       public
222       returns (bool)
223     {
224         _validateAddress(spender);
225 
226         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
227         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
228         return true;
229     }
230 
231     function _transfer(address from, address to, uint256 value) internal {
232         require(value <= _balances[from], "not enough tokens");
233         _validateAddress(to);
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     function _mint(address account, uint256 value) internal {
241         _validateAddress(account);
242         _totalSupply = _totalSupply.add(value);
243         _balances[account] = _balances[account].add(value);
244         emit Transfer(address(0), account, value);
245     }
246 
247     function _burn(address account, uint256 value) internal {
248         _validateAddress(account);
249         require(value <= _balances[account], "not enough tokens to burn");
250 
251         _totalSupply = _totalSupply.sub(value);
252         _balances[account] = _balances[account].sub(value);
253         emit Transfer(account, address(0), value);
254     }
255 
256     function _burnFrom(address account, uint256 value) internal {
257         require(value <= _allowed[account][msg.sender], "not enough allowed tokens to burn");
258 
259         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
260         _burn(account, value);
261     }
262 }
263 
264 contract Gold is ERC20, Upgradable {
265     address[5] founders = [
266         0x23b3763f31F4da6B42F47927BCF66A221E8705Cd,
267         0x5CFF40372b96e133967d980F72812653163121fa,
268         0xE246C5Aa2D57878DA70779A75B12dCDFFd77aDBA,
269         0x950eEAf8ddbA1409dbD25aD16d50A867EEA75c3E,
270         0x87252E8F04F6c6bC4d2c690893addb7108aa8a5f
271     ];
272 
273     address foundation = 0x5Ff8957EF7e964E8072815211c9Fc3E7F820F1D4;
274     address NonsenseGames = 0x10208FB4Ef202BdC49803995b0A8CA185383bba4;
275 
276     string constant WP_IPFS_HASH = "QmfR75tK12q2LpkU5dzYqykUUpYswSiewpCbDuwYhRb6M5";
277 
278 
279     constructor(address treasury) public {
280         name = "Dragonereum Gold";
281         symbol = "GOLD";
282         decimals = 18;
283 
284         uint256 _foundersGold = 6000000 * 10**18; // 10%
285         uint256 _foundationGold = 6000000 * 10**18; // 10%
286         uint256 _NonsenseGamesGold = 3000000 * 10**18; // 5%
287         uint256 _gameAccountGold = 45000000 * 10**18; // 75%
288 
289         uint256 _founderStake = _foundersGold.div(founders.length);
290         for (uint256 i = 0; i < founders.length; i++) {
291             _mint(founders[i], _founderStake);
292         }
293 
294         _mint(foundation, _foundationGold);
295         _mint(NonsenseGames, _NonsenseGamesGold);
296         _mint(treasury, _gameAccountGold);
297 
298         require(_totalSupply == 60000000 * 10**18, "wrong total supply");
299     }
300 
301     function remoteTransfer(address _to, uint256 _value) external onlyController {
302         _transfer(tx.origin, _to, _value);
303     }
304 
305     function burn(uint256 _value) external onlyController {
306         _burn(msg.sender, _value);
307     }
308 }