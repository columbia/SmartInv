1 pragma solidity ^0.5.3;
2 
3 
4     interface IERC20 {
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23     library SafeMath {
24 
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26 
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint256 c = a * b;
32         require(c / a == b);
33 
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Solidity only automatically asserts when dividing by 0
39         require(b > 0);
40         uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42 
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a);
56 
57         return c;
58     }
59 
60     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b != 0);
62         return a % b;
63     }
64 }
65 
66     contract ERC20 is IERC20 {
67     using SafeMath for uint256;
68 
69     mapping (address => uint256) private _balances;
70 
71     mapping (address => mapping (address => uint256)) private _allowed;
72 
73     uint256 private _totalSupply;
74 
75     function totalSupply() public view returns (uint256) {
76         return _totalSupply;
77     }
78 
79     function balanceOf(address owner) public view returns (uint256) {
80         return _balances[owner];
81     }
82 
83     function allowance(address owner, address spender) public view returns (uint256) {
84         return _allowed[owner][spender];
85     }
86 
87     function transfer(address to, uint256 value) public returns (bool) {
88         _transfer(msg.sender, to, value);
89         return true;
90     }
91 
92     function approve(address spender, uint256 value) public returns (bool) {
93         _approve(msg.sender, spender, value);
94         return true;
95     }
96 
97     function transferFrom(address from, address to, uint256 value) public returns (bool) {
98         _transfer(from, to, value);
99         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
100         return true;
101     }
102 
103     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
104         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
105         return true;
106     }
107 
108     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
109         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
110         return true;
111     }
112 
113     function _transfer(address from, address to, uint256 value) internal {
114         require(to != address(0));
115 
116         _balances[from] = _balances[from].sub(value);
117         _balances[to] = _balances[to].add(value);
118         emit Transfer(from, to, value);
119     }
120 
121     function _mint(address account, uint256 value) internal {
122         require(account != address(0));
123 
124         _totalSupply = _totalSupply.add(value);
125         _balances[account] = _balances[account].add(value);
126         emit Transfer(address(0), account, value);
127     }
128 
129     function _burn(address account, uint256 value) internal {
130         require(account != address(0));
131 
132         _totalSupply = _totalSupply.sub(value);
133         _balances[account] = _balances[account].sub(value);
134         emit Transfer(account, address(0), value);
135     }
136 
137     function _approve(address owner, address spender, uint256 value) internal {
138         require(spender != address(0));
139         require(owner != address(0));
140 
141         _allowed[owner][spender] = value;
142         emit Approval(owner, spender, value);
143     }
144 
145     function _burnFrom(address account, uint256 value) internal {
146         _burn(account, value);
147         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
148     }
149 }
150 
151     contract ERC20Burnable is ERC20 {
152 
153     function burn(uint256 value) public {
154         _burn(msg.sender, value);
155     }
156 
157     function burnFrom(address from, uint256 value) public {
158         _burnFrom(from, value);
159     }
160 }
161 
162     library Roles {
163     struct Role {
164         mapping (address => bool) bearer;
165     }
166 
167     function add(Role storage role, address account) internal {
168         require(account != address(0));
169         require(!has(role, account));
170 
171         role.bearer[account] = true;
172     }
173 
174     function remove(Role storage role, address account) internal {
175         require(account != address(0));
176         require(has(role, account));
177 
178         role.bearer[account] = false;
179     }
180 
181     function has(Role storage role, address account) internal view returns (bool) {
182         require(account != address(0));
183         return role.bearer[account];
184     }
185 }
186 
187 contract PauserRole {
188     using Roles for Roles.Role;
189 
190     event PauserAdded(address indexed account);
191     event PauserRemoved(address indexed account);
192 
193     Roles.Role private _pausers;
194 
195     constructor () internal {
196         _addPauser(msg.sender);
197     }
198 
199     modifier onlyPauser() {
200         require(isPauser(msg.sender));
201         _;
202     }
203 
204     function isPauser(address account) public view returns (bool) {
205         return _pausers.has(account);
206     }
207 
208     function addPauser(address account) public onlyPauser {
209         _addPauser(account);
210     }
211 
212     function renouncePauser() public {
213         _removePauser(msg.sender);
214     }
215 
216     function _addPauser(address account) internal {
217         _pausers.add(account);
218         emit PauserAdded(account);
219     }
220 
221     function _removePauser(address account) internal {
222         _pausers.remove(account);
223         emit PauserRemoved(account);
224     }
225 }
226 
227     contract Pausable is PauserRole {
228     event Paused(address account);
229     event Unpaused(address account);
230 
231     bool private _paused;
232 
233     constructor () internal {
234         _paused = false;
235     }
236 
237     function paused() public view returns (bool) {
238         return _paused;
239     }
240 
241     modifier whenNotPaused() {
242         require(!_paused);
243         _;
244     }
245 
246     modifier whenPaused() {
247         require(_paused);
248         _;
249     }
250 
251     function pause() public onlyPauser whenNotPaused {
252         _paused = true;
253         emit Paused(msg.sender);
254     }
255 
256     function unpause() public onlyPauser whenPaused {
257         _paused = false;
258         emit Unpaused(msg.sender);
259     }
260 }
261 
262     contract ERC20Pausable is ERC20, Pausable {
263     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
264         return super.transfer(to, value);
265     }
266 
267     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
268         return super.transferFrom(from, to, value);
269     }
270 
271     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
272         return super.approve(spender, value);
273     }
274 
275     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
276         return super.increaseAllowance(spender, addedValue);
277     }
278 
279     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
280         return super.decreaseAllowance(spender, subtractedValue);
281     }
282 }
283     contract MinterRole {
284     using Roles for Roles.Role;
285 
286     event MinterAdded(address indexed account);
287     event MinterRemoved(address indexed account);
288 
289     Roles.Role private _minters;
290 
291     constructor () internal {
292         _addMinter(msg.sender);
293     }
294 
295     modifier onlyMinter() {
296         require(isMinter(msg.sender));
297         _;
298     }
299 
300     function isMinter(address account) public view returns (bool) {
301         return _minters.has(account);
302     }
303 
304     function addMinter(address account) public onlyMinter {
305         _addMinter(account);
306     }
307 
308     function renounceMinter() public {
309         _removeMinter(msg.sender);
310     }
311 
312     function _addMinter(address account) internal {
313         _minters.add(account);
314         emit MinterAdded(account);
315     }
316 
317     function _removeMinter(address account) internal {
318         _minters.remove(account);
319         emit MinterRemoved(account);
320     }
321 }
322 
323     contract ERC20Mintable is ERC20, MinterRole {
324 
325     function mint(address to, uint256 value) public onlyMinter returns (bool) {
326         _mint(to, value);
327         return true;
328     }
329 }
330 
331     contract OliveGardensResort is IERC20, ERC20Burnable, ERC20Pausable, ERC20Mintable {
332     string private _name;
333     string private _symbol;
334     uint8 private _decimals;
335 
336     constructor (string memory name, string memory symbol, uint8 decimals) public {
337         _name = name;
338         _symbol = symbol;
339         _decimals = decimals;
340     }
341 
342     function name() public view returns (string memory) {
343         return _name;
344     }
345 
346     /**
347      * @return the symbol of the token.
348      */
349     function symbol() public view returns (string memory) {
350         return _symbol;
351     }
352 
353     function decimals() public view returns (uint8) {
354         return _decimals;
355     }
356 }