1 pragma solidity 0.5.16;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint);
5     function balanceOf(address account) external view returns (uint);
6     function transfer(address recipient, uint amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint);
8     function approve(address spender, uint amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint value);
11     event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 
14 contract Context {
15     constructor () internal { }
16     // solhint-disable-previous-line no-empty-blocks
17 
18     function _msgSender() internal view returns (address payable) {
19         return msg.sender;
20     }
21 }
22 
23 contract ERC20 is Context, IERC20 {
24     using SafeMath for uint;
25 
26     mapping (address => uint) private _balances;
27 
28     mapping (address => mapping (address => uint)) private _allowances;
29 
30     uint private _totalSupply;
31     function totalSupply() public view returns (uint) {
32         return _totalSupply;
33     }
34     function balanceOf(address account) public view returns (uint) {
35         return _balances[account];
36     }
37     function transfer(address recipient, uint amount) public returns (bool) {
38         _transfer(_msgSender(), recipient, amount);
39         return true;
40     }
41     function allowance(address owner, address spender) public view returns (uint) {
42         return _allowances[owner][spender];
43     }
44     function approve(address spender, uint amount) public returns (bool) {
45         _approve(_msgSender(), spender, amount);
46         return true;
47     }
48     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
49         _transfer(sender, recipient, amount);
50         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
51         return true;
52     }
53     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
54         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
55         return true;
56     }
57     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
58         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
59         return true;
60     }
61     function _transfer(address sender, address recipient, uint amount) internal {
62         require(sender != address(0), "ERC20: transfer from the zero address");
63         require(recipient != address(0), "ERC20: transfer to the zero address");
64 
65         _beforeTokenTransfer(sender, recipient, amount);
66 
67         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
68         _balances[recipient] = _balances[recipient].add(amount);
69         emit Transfer(sender, recipient, amount);
70     }
71     function _mint(address account, uint amount) internal {
72         require(account != address(0), "ERC20: mint to the zero address");
73 
74         _beforeTokenTransfer(address(0), account, amount);
75 
76         _totalSupply = _totalSupply.add(amount);
77         _balances[account] = _balances[account].add(amount);
78         emit Transfer(address(0), account, amount);
79     }
80     function _burn(address account, uint amount) internal {
81         require(account != address(0), "ERC20: burn from the zero address");
82 
83         _beforeTokenTransfer(account, address(0), amount);
84 
85         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
86         _totalSupply = _totalSupply.sub(amount);
87         emit Transfer(account, address(0), amount);
88     }
89     function _approve(address owner, address spender, uint amount) internal {
90         require(owner != address(0), "ERC20: approve from the zero address");
91         require(spender != address(0), "ERC20: approve to the zero address");
92 
93         _allowances[owner][spender] = amount;
94         emit Approval(owner, spender, amount);
95     }
96 
97      /**
98      * @dev Hook that is called before any transfer of tokens. This includes
99      * minting and burning.
100      *
101      * Calling conditions:
102      *
103      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
104      * will be to transferred to `to`.
105      * - when `from` is zero, `amount` tokens will be minted for `to`.
106      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
107      * - `from` and `to` are never both zero.
108      *
109      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
110      */
111     function _beforeTokenTransfer(address from, address to, uint256 amount) internal { }
112 }
113 
114 contract ERC20Detailed is IERC20 {
115     string private _name;
116     string private _symbol;
117     uint8 private _decimals;
118     uint256 private _cap;
119 
120     constructor (string memory name, string memory symbol, uint8 decimals, uint256 cap) public {
121         _name = name;
122         _symbol = symbol;
123         _decimals = decimals;
124         _cap = cap;
125     }
126     function name() public view returns (string memory) {
127         return _name;
128     }
129     function symbol() public view returns (string memory) {
130         return _symbol;
131     }
132     function decimals() public view returns (uint8) {
133         return _decimals;
134     }
135 
136     /**
137      * @dev Returns the cap on the token's total supply.
138      */
139     function cap() public view returns (uint256) {
140         return _cap;
141     }
142 
143 }
144 
145 library SafeMath {
146     function add(uint a, uint b) internal pure returns (uint) {
147         uint c = a + b;
148         require(c >= a, "SafeMath: addition overflow");
149 
150         return c;
151     }
152     function sub(uint a, uint b) internal pure returns (uint) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
156         require(b <= a, errorMessage);
157         uint c = a - b;
158 
159         return c;
160     }
161     function mul(uint a, uint b) internal pure returns (uint) {
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171     function div(uint a, uint b) internal pure returns (uint) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
175         // Solidity only automatically asserts when dividing by 0
176         require(b > 0, errorMessage);
177         uint c = a / b;
178 
179         return c;
180     }
181 }
182 
183 library Address {
184     function isContract(address account) internal view returns (bool) {
185         bytes32 codehash;
186         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
187         // solhint-disable-next-line no-inline-assembly
188         assembly { codehash := extcodehash(account) }
189         return (codehash != 0x0 && codehash != accountHash);
190     }
191 }
192 
193 library SafeERC20 {
194     using SafeMath for uint;
195     using Address for address;
196 
197     function safeTransfer(IERC20 token, address to, uint value) internal {
198         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
199     }
200 
201     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
202         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
203     }
204 
205     function safeApprove(IERC20 token, address spender, uint value) internal {
206         require((value == 0) || (token.allowance(address(this), spender) == 0),
207             "SafeERC20: approve from non-zero to non-zero allowance"
208         );
209         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
210     }
211     function callOptionalReturn(IERC20 token, bytes memory data) private {
212         require(address(token).isContract(), "SafeERC20: call to non-contract");
213 
214         // solhint-disable-next-line avoid-low-level-calls
215         (bool success, bytes memory returndata) = address(token).call(data);
216         require(success, "SafeERC20: low-level call failed");
217 
218         if (returndata.length > 0) { // Return data is optional
219             // solhint-disable-next-line max-line-length
220             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
221         }
222     }
223 }
224 
225 /**
226  * HD Token
227  */
228 contract HD is ERC20, ERC20Detailed {
229     using SafeERC20 for IERC20;
230     using Address for address;
231     using SafeMath for uint;
232 
233     address public governance;
234     address public pendingGov;
235 
236     mapping (address => bool) public minters;
237 
238     event NewPendingGov(address oldPendingGov, address newPendingGov);
239 
240     event NewGov(address oldGov, address newGov);
241 
242     // Modifiers
243     modifier onlyGov() {
244         require(msg.sender == governance, "HUB-Token: !governance");
245         _;
246     }
247 
248     constructor () public ERC20Detailed("HUB.finance", "HD", 18, 21000000 * 10 ** 18) {
249         governance = tx.origin;
250     }
251 
252     /** 
253      * Minte Token for Account
254      * @param _account minter
255      * @param _amount amount
256      */
257     function mint(address _account, uint256 _amount) public {
258         require(minters[msg.sender], "HUB-Token: !minter");
259         _mint(_account, _amount);
260     }
261     
262     /** 
263      * Add minter
264      * @param _minter minter
265      */
266     function addMinter(address _minter) public onlyGov {
267         minters[_minter] = true;
268     }
269     
270     /** 
271      * Remove minter
272      * @param _minter minter
273      */
274     function removeMinter(address _minter) public onlyGov {
275         minters[_minter] = false;
276     }
277 
278     /** 
279      * Set new governance
280      * @param _pendingGov the new governance
281      */
282     function setPendingGov(address _pendingGov)
283         external
284         onlyGov
285     {
286         address oldPendingGov = pendingGov;
287         pendingGov = _pendingGov;
288         emit NewPendingGov(oldPendingGov, _pendingGov);
289     }
290 
291     /** 
292      * lets msg.sender accept governance
293      */
294     function acceptGov()
295         external {
296         require(msg.sender == pendingGov, "HUB-Token: !pending");
297         address oldGov = governance;
298         governance = pendingGov;
299         pendingGov = address(0);
300         emit NewGov(oldGov, governance);
301     }
302 
303     /**
304      * @dev See {ERC20-_beforeTokenTransfer}.
305      *
306      * Requirements:
307      *
308      * - minted tokens must not cause the total supply to go over the cap.
309      */
310     function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
311         super._beforeTokenTransfer(from, to, amount);
312 
313         if (from == address(0)) { // When minting tokens
314             require(totalSupply().add(amount) <= cap(), "HUB-Token: Cap exceeded");
315         }
316     }
317 }