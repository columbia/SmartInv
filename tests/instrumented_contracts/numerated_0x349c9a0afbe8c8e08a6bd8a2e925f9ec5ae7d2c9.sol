1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4 
5     function transfer(address to, uint256 value) external returns (bool);
6     function approve(address spender, uint256 value) external returns (bool);
7     function transferFrom(address from, address to, uint256 value) external returns (bool);
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address who) external view returns (uint256);
10     function allowance(address owner, address spender) external view returns (uint256);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         require(c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         require(b > 0);
28         uint256 c = a / b;
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b <= a);
34         uint256 c = a - b;
35         return c;
36     }
37 
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a);
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b != 0);
47         return a % b;
48     }
49 }
50 
51 contract ERC20 is IERC20 {
52 
53     using SafeMath for uint256;
54     mapping (address => uint256) private _balances;
55     mapping (address => mapping (address => uint256)) private _allowed;
56     uint256 private _totalSupply;
57 
58     function totalSupply() public view returns (uint256) {
59         return _totalSupply;
60     }
61 
62     function balanceOf(address owner) public view returns (uint256) {
63         return _balances[owner];
64     }
65 
66     function allowance(address owner, address spender) public view returns (uint256) {
67         return _allowed[owner][spender];
68     }
69 
70     function transfer(address to, uint256 value) public returns (bool) {
71         _transfer(msg.sender, to, value);
72         return true;
73     }
74 
75     function approve(address spender, uint256 value) public returns (bool) {
76 
77         require(spender != address(0));
78         _allowed[msg.sender][spender] = value;
79         emit Approval(msg.sender, spender, value);
80         return true;
81     }
82 
83     function transferFrom(address from, address to, uint256 value) public returns (bool) {
84         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
85         _transfer(from, to, value);
86         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
87         return true;
88     }
89 
90     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
91 
92         require(spender != address(0));
93         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
94         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
95         return true;
96     }
97 
98     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
99 
100         require(spender != address(0));
101         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
102         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
103         return true;
104     }
105 
106     function _transfer(address from, address to, uint256 value) internal {
107 
108         require(to != address(0));
109         _balances[from] = _balances[from].sub(value);
110         _balances[to] = _balances[to].add(value);
111         emit Transfer(from, to, value);
112     }
113 
114     function _mint(address account, uint256 value) internal {
115 
116         require(account != address(0));
117         _totalSupply = _totalSupply.add(value);
118         _balances[account] = _balances[account].add(value);
119         emit Transfer(address(0), account, value);
120     }
121 
122     function _burn(address account, uint256 value) internal {
123         require(account != address(0));
124         _totalSupply = _totalSupply.sub(value);
125         _balances[account] = _balances[account].sub(value);
126         emit Transfer(account, address(0), value);
127     }
128 
129     function _burnFrom(address account, uint256 value) internal {
130         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
131         _burn(account, value);
132         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
133     }
134 }
135 
136 library Roles {
137 
138     struct Role {
139         mapping (address => bool) bearer;
140     }
141 
142     function add(Role storage role, address account) internal {
143         require(account != address(0));
144         require(!has(role, account));
145         role.bearer[account] = true;
146     }
147 
148     function remove(Role storage role, address account) internal {
149         require(account != address(0));
150         require(has(role, account));
151         role.bearer[account] = false;
152     }
153 
154     function has(Role storage role, address account) internal view returns (bool) {
155         require(account != address(0));
156         return role.bearer[account];
157     }
158 }
159 
160 contract PauserRole {
161 
162     using Roles for Roles.Role;
163     event PauserAdded(address indexed account);
164     event PauserRemoved(address indexed account);
165     Roles.Role private _pausers;
166 
167     constructor () internal {
168         _addPauser(msg.sender);
169     }
170 
171     modifier onlyPauser() {
172         require(isPauser(msg.sender));
173         _;
174     }
175 
176     function isPauser(address account) internal view returns (bool) {
177         return _pausers.has(account);
178     }
179 
180     function addPauser(address account) internal onlyPauser {
181         _addPauser(account);
182     }
183 
184     function renouncePauser() internal {
185         _removePauser(msg.sender);
186     }
187 
188     function _addPauser(address account) internal {
189         _pausers.add(account);
190         emit PauserAdded(account);
191     }
192 
193     function _removePauser(address account) internal {
194         _pausers.remove(account);
195         emit PauserRemoved(account);
196     }
197 }
198 
199 contract Ownable {
200 
201     address private _owner;
202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204     constructor () internal {
205         _owner = msg.sender;
206         emit OwnershipTransferred(address(0), _owner);
207     }
208 
209     function owner() public view returns (address) {
210         return _owner;
211     }
212 
213     modifier onlyOwner() {
214         require(isOwner());
215         _;
216     }
217 
218     function isOwner() public view returns (bool) {
219         return msg.sender == _owner;
220     }
221 
222     function renounceOwnership() internal onlyOwner {
223         emit OwnershipTransferred(_owner, address(0));
224         _owner = address(0);
225     }
226 
227     function transferOwnership(address newOwner) internal onlyOwner {
228         _transferOwnership(newOwner);
229     }
230 
231     function _transferOwnership(address newOwner) internal {
232         require(newOwner != address(0));
233         emit OwnershipTransferred(_owner, newOwner);
234         _owner = newOwner;
235     }
236 }
237 
238 contract Pausable is PauserRole, Ownable {
239 
240     event Paused(address account);
241     event Unpaused(address account);
242     bool private _paused;
243     constructor () internal {
244         _paused = false;
245     }
246 
247     function paused() public view returns (bool) {
248         return _paused;
249     }
250 
251     modifier whenNotPaused() {
252         require(!_paused);
253         _;
254     }
255 
256     modifier whenPaused() {
257         require(_paused);
258         _;
259     }
260 
261     function pause() public onlyPauser onlyOwner whenNotPaused {
262         _paused = true;
263         emit Paused(msg.sender);
264     }
265 
266     function unpause() public onlyPauser onlyOwner whenPaused {
267         _paused = false;
268         emit Unpaused(msg.sender);
269     }
270 }
271 
272 contract ERC20Pausable is ERC20, Pausable {
273 
274     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
275         return super.transfer(to, value);
276     }
277 
278     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
279         return super.transferFrom(from, to, value);
280     }
281 
282     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
283         return super.approve(spender, value);
284     }
285 
286     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
287         return super.increaseAllowance(spender, addedValue);
288     }
289 
290     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
291         return super.decreaseAllowance(spender, subtractedValue);
292     }
293 }
294 
295 library SafeERC20 {
296 
297     using SafeMath for uint256;
298 
299     function safeTransfer(IERC20 token, address to, uint256 value) internal {
300         require(token.transfer(to, value));
301     }
302 
303     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
304         require(token.transferFrom(from, to, value));
305     }
306 
307     function safeApprove(IERC20 token, address spender, uint256 value) internal {
308         require((value == 0) || (token.allowance(address(this), spender) == 0));
309         require(token.approve(spender, value));
310     }
311 
312     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
313         uint256 newAllowance = token.allowance(address(this), spender).add(value);
314         require(token.approve(spender, newAllowance));
315     }
316 
317     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
318         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
319         require(token.approve(spender, newAllowance));
320     }
321 }
322 
323 contract TFF_Token is ERC20Pausable {
324 
325   using SafeERC20 for ERC20;
326   address public creator;
327   string public name;
328   string public symbol;
329   uint8 public decimals;
330   uint256 public stage;
331   uint256[4] private tokensToMint;
332 
333   constructor() public {
334 
335     creator = 0xbC57B9bb80DD02c882fcE8cf5700f8A2a003838E;
336     name = "TheFaustFlick";
337     symbol = "TFF";
338     decimals = 3;
339     stage = 0;
340     tokensToMint[0] = 500000000;
341     tokensToMint[1] = 3000000000;
342     tokensToMint[2] = 3000000000;
343     tokensToMint[3] = 3500000000;
344   }
345 
346   function mintTFF() public onlyOwner returns (bool) {
347     require (stage <=3);
348     _mint(creator, tokensToMint[stage]);
349     stage = stage.add(1);
350     return true;
351   }
352 }