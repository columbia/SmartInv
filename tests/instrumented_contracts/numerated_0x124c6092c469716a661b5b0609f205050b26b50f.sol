1 //   _    _ _   _                __ _                            
2 //  | |  (_) | | |              / _(_)                           
3 //  | | ___| |_| |_ ___ _ __   | |_ _ _ __   __ _ _ __   ___ ___ 
4 //  | |/ / | __| __/ _ \ '_ \  |  _| | '_ \ / _` | '_ \ / __/ _ \
5 //  |   <| | |_| ||  __/ | | |_| | | | | | | (_| | | | | (_|  __/
6 //  |_|\_\_|\__|\__\___|_| |_(_)_| |_|_| |_|\__,_|_| |_|\___\___|
7 //
8 pragma solidity ^0.5.16;
9 
10 library SafeMathInt {
11     int256 private constant MIN_INT256 = int256(1) << 255;
12     int256 private constant MAX_INT256 = ~(int256(1) << 255);
13 
14     /**
15      * @dev Multiplies two int256 variables and fails on overflow.
16      */
17     function mul(int256 a, int256 b)
18         internal
19         pure
20         returns (int256)
21     {
22         int256 c = a * b;
23 
24         // Detect overflow when multiplying MIN_INT256 with -1
25         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
26         require((b == 0) || (c / b == a));
27         return c;
28     }
29 
30     /**
31      * @dev Division of two int256 variables and fails on overflow.
32      */
33     function div(int256 a, int256 b)
34         internal
35         pure
36         returns (int256)
37     {
38         // Prevent overflow when dividing MIN_INT256 by -1
39         require(b != -1 || a != MIN_INT256);
40 
41         // Solidity already throws when dividing by 0.
42         return a / b;
43     }
44 
45     /**
46      * @dev Subtracts two int256 variables and fails on overflow.
47      */
48     function sub(int256 a, int256 b)
49         internal
50         pure
51         returns (int256)
52     {
53         int256 c = a - b;
54         require((b >= 0 && c <= a) || (b < 0 && c > a));
55         return c;
56     }
57 
58     /**
59      * @dev Adds two int256 variables and fails on overflow.
60      */
61     function add(int256 a, int256 b)
62         internal
63         pure
64         returns (int256)
65     {
66         int256 c = a + b;
67         require((b >= 0 && c >= a) || (b < 0 && c < a));
68         return c;
69     }
70 
71     /**
72      * @dev Converts to absolute value, and fails on overflow.
73      */
74     function abs(int256 a)
75         internal
76         pure
77         returns (int256)
78     {
79         require(a != MIN_INT256);
80         return a < 0 ? -a : a;
81     }
82 }
83 
84 interface IERC20 {
85     function totalSupply() external view returns (uint);
86     function balanceOf(address account) external view returns (uint);
87     function transfer(address recipient, uint amount) external returns (bool);
88     function allowance(address owner, address spender) external view returns (uint);
89     function approve(address spender, uint amount) external returns (bool);
90     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
91     event Transfer(address indexed from, address indexed to, uint value);
92     event Approval(address indexed owner, address indexed spender, uint value);
93 }
94 
95 contract Context {
96     constructor () internal { }
97     // solhint-disable-previous-line no-empty-blocks
98 
99     function _msgSender() internal view returns (address payable) {
100         return msg.sender;
101     }
102 }
103 
104 contract ERC20_BASED is Context, IERC20 {
105     using SafeMath for uint;
106 
107     uint internal _gonsPerFragment;
108 
109     mapping(address => uint) internal _gonBalances;
110 
111     mapping (address => mapping (address => uint)) internal _allowedFragments;
112 
113     uint internal _totalSupply;
114     function totalSupply() public view returns (uint) {
115         return _totalSupply;
116     }
117     function balanceOf(address account) public view returns (uint) {
118         return _gonBalances[account].div(_gonsPerFragment);
119     }
120     function transfer(address recipient, uint amount) public returns (bool) {
121         _transfer(_msgSender(), recipient, amount);
122         return true;
123     }
124     function allowance(address owner, address spender) public view returns (uint) {
125         return _allowedFragments[owner][spender];
126     }
127     function approve(address spender, uint amount) public returns (bool) {
128         _approve(_msgSender(), spender, amount);
129         return true;
130     }
131     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
132         _transfer(sender, recipient, amount);
133         _approve(sender, _msgSender(), _allowedFragments[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
134         return true;
135     }
136     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
137         _approve(_msgSender(), spender, _allowedFragments[_msgSender()][spender].add(addedValue));
138         return true;
139     }
140     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
141         _approve(_msgSender(), spender, _allowedFragments[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
142         return true;
143     }
144     function _transfer(address sender, address recipient, uint amount) internal {
145         require(sender != address(0), "ERC20: transfer from the zero address");
146         require(recipient != address(0), "ERC20: transfer to the zero address");
147 
148         uint gonValue = amount.mul(_gonsPerFragment);
149         _gonBalances[sender] = _gonBalances[sender].sub(gonValue, "ERC20: transfer amount exceeds balance");
150         _gonBalances[recipient] = _gonBalances[recipient].add(gonValue);
151 
152         emit Transfer(sender, recipient, amount);
153     }
154     function _approve(address owner, address spender, uint amount) internal {
155         require(owner != address(0), "ERC20: approve from the zero address");
156         require(spender != address(0), "ERC20: approve to the zero address");
157 
158         _allowedFragments[owner][spender] = amount;
159         emit Approval(owner, spender, amount);
160     }
161 }
162 
163 contract ERC20Detailed is IERC20 {
164     string private _name;
165     string private _symbol;
166     uint8 private _decimals;
167 
168     constructor (string memory name, string memory symbol, uint8 decimals) public {
169         _name = name;
170         _symbol = symbol;
171         _decimals = decimals;
172     }
173     function name() public view returns (string memory) {
174         return _name;
175     }
176     function symbol() public view returns (string memory) {
177         return _symbol;
178     }
179     function decimals() public view returns (uint8) {
180         return _decimals;
181     }
182 }
183 
184 library SafeMath {
185     function add(uint a, uint b) internal pure returns (uint) {
186         uint c = a + b;
187         require(c >= a, "SafeMath: addition overflow");
188 
189         return c;
190     }
191     function sub(uint a, uint b) internal pure returns (uint) {
192         return sub(a, b, "SafeMath: subtraction overflow");
193     }
194     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
195         require(b <= a, errorMessage);
196         uint c = a - b;
197 
198         return c;
199     }
200     function mul(uint a, uint b) internal pure returns (uint) {
201         if (a == 0) {
202             return 0;
203         }
204 
205         uint c = a * b;
206         require(c / a == b, "SafeMath: multiplication overflow");
207 
208         return c;
209     }
210     function div(uint a, uint b) internal pure returns (uint) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
214         // Solidity only automatically asserts when dividing by 0
215         require(b > 0, errorMessage);
216         uint c = a / b;
217 
218         return c;
219     }
220 }
221 
222 contract kBASEv0 is ERC20_BASED, ERC20Detailed {
223     using SafeMath for uint;
224     using SafeMathInt for int256;
225 
226     address public governance;
227 
228     constructor () public ERC20Detailed("kBASEv0 - Kitten.Finance", "kBASEv0", uint8(DECIMALS)) {
229         governance = msg.sender;
230 
231         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
232         _gonBalances[msg.sender] = TOTAL_GONS;
233         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
234         
235         emit Transfer(address(0x0), msg.sender, _totalSupply);
236     }
237 
238     function setGovernance(address _governance) public {
239         require(msg.sender == governance, "!governance");
240         governance = _governance;
241     }
242 
243     //=====================================================================
244 
245     uint private constant DECIMALS = 18;
246     uint private constant MAX_UINT256 = ~uint(0);
247     uint private constant INITIAL_FRAGMENTS_SUPPLY = 100000 * uint(10)**DECIMALS;
248     uint private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
249     uint private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
250 
251     event LogRebase(uint indexed epoch, uint totalSupply);
252     event LogMonetaryPolicyUpdated(address monetaryPolicy);
253 
254     address public monetaryPolicy;
255     
256     function setMonetaryPolicy(address monetaryPolicy_) external
257     {
258         require(msg.sender == governance, "!governance");
259         monetaryPolicy = monetaryPolicy_;
260         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
261     }
262 
263     function rebase(uint epoch, int256 supplyDelta) external returns (uint)
264     {
265         require(msg.sender == monetaryPolicy, "!monetaryPolicy");
266 
267         if (supplyDelta == 0) {
268             emit LogRebase(epoch, _totalSupply);
269             return _totalSupply;
270         }
271 
272         if (supplyDelta < 0) {
273             _totalSupply = _totalSupply.sub(uint(supplyDelta.abs()));
274         } else {
275             _totalSupply = _totalSupply.add(uint(supplyDelta));
276         }
277 
278         if (_totalSupply > MAX_SUPPLY) {
279             _totalSupply = MAX_SUPPLY;
280         }
281 
282         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
283 
284         // From this point forward, _gonsPerFragment is taken as the source of truth.
285         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
286         // conversion rate.
287         // This means our applied supplyDelta can deviate from the requested supplyDelta,
288         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
289         //
290         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
291         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
292         // ever increased, it must be re-included.
293         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
294 
295         emit LogRebase(epoch, _totalSupply);
296         return _totalSupply;
297     }
298 
299     //=====================================================================
300 }