1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-26
3 */
4 
5 pragma solidity 0.5.16;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint);
9     function balanceOf(address account) external view returns (uint);
10     function transfer(address recipient, uint amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint);
12     function approve(address spender, uint amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint value);
15     event Approval(address indexed owner, address indexed spender, uint value);
16 }
17 
18 contract Context {
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 }
26 
27 contract ERC20 is Context, IERC20 {
28     using SafeMath for uint;
29 
30     mapping (address => uint) private _balances;
31 
32     mapping (address => mapping (address => uint)) private _allowances;
33 
34     uint private _totalSupply;
35     function totalSupply() public view returns (uint) {
36         return _totalSupply;
37     }
38     function balanceOf(address account) external view returns (uint) {
39         return _balances[account];
40     }
41     function transfer(address recipient, uint amount) external returns (bool) {
42         _transfer(_msgSender(), recipient, amount);
43         return true;
44     }
45     function allowance(address owner, address spender) external view returns (uint) {
46         return _allowances[owner][spender];
47     }
48     function approve(address spender, uint amount) external returns (bool) {
49         _approve(_msgSender(), spender, amount);
50         return true;
51     }
52     function transferFrom(address sender, address recipient, uint amount) external returns (bool) {
53         _transfer(sender, recipient, amount);
54         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
55         return true;
56     }
57     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
58         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
59         return true;
60     }
61     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
62         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
63         return true;
64     }
65     function _transfer(address sender, address recipient, uint amount) internal {
66         require(sender != address(0), "ERC20: transfer from the zero address");
67         require(recipient != address(0), "ERC20: transfer to the zero address");
68 
69         _beforeTokenTransfer(sender, recipient, amount);
70 
71         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
72         _balances[recipient] = _balances[recipient].add(amount);
73         emit Transfer(sender, recipient, amount);
74     }
75     function _mint(address account, uint amount) internal {
76         require(account != address(0), "ERC20: mint to the zero address");
77 
78         _beforeTokenTransfer(address(0), account, amount);
79 
80         _totalSupply = _totalSupply.add(amount);
81         _balances[account] = _balances[account].add(amount);
82         emit Transfer(address(0), account, amount);
83     }
84     function _burn(address account, uint amount) internal {
85         require(account != address(0), "ERC20: burn from the zero address");
86 
87         _beforeTokenTransfer(account, address(0), amount);
88 
89         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
90         _totalSupply = _totalSupply.sub(amount);
91         emit Transfer(account, address(0), amount);
92     }
93     function _approve(address owner, address spender, uint amount) internal {
94         require(owner != address(0), "ERC20: approve from the zero address");
95         require(spender != address(0), "ERC20: approve to the zero address");
96 
97         _allowances[owner][spender] = amount;
98         emit Approval(owner, spender, amount);
99     }
100 
101      /**
102      * @dev Hook that is called before any transfer of tokens. This includes
103      * minting and burning.
104      *
105      * Calling conditions:
106      *
107      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
108      * will be to transferred to `to`.
109      * - when `from` is zero, `amount` tokens will be minted for `to`.
110      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
111      * - `from` and `to` are never both zero.
112      *
113      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
114      */
115     function _beforeTokenTransfer(address from, address to, uint256 amount) internal { }
116 }
117 
118 contract ERC20Detailed is IERC20 {
119     string private _name;
120     string private _symbol;
121     uint8 private _decimals;
122     uint256 private _cap;
123 
124     constructor (string memory name, string memory symbol, uint8 decimals, uint256 cap) public {
125         _name = name;
126         _symbol = symbol;
127         _decimals = decimals;
128         _cap = cap;
129     }
130     function name() external view returns (string memory) {
131         return _name;
132     }
133     function symbol() external view returns (string memory) {
134         return _symbol;
135     }
136     function decimals() external view returns (uint8) {
137         return _decimals;
138     }
139 
140     /**
141      * @dev Returns the cap on the token's total supply.
142      */
143     function cap() public view returns (uint256) {
144         return _cap;
145     }
146 
147 }
148 
149 library SafeMath {
150     function add(uint a, uint b) internal pure returns (uint) {
151         uint c = a + b;
152         require(c >= a, "SafeMath: addition overflow");
153 
154         return c;
155     }
156     function sub(uint a, uint b) internal pure returns (uint) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
160         require(b <= a, errorMessage);
161         uint c = a - b;
162 
163         return c;
164     }
165     function mul(uint a, uint b) internal pure returns (uint) {
166         if (a == 0) {
167             return 0;
168         }
169 
170         uint c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172 
173         return c;
174     }
175     function div(uint a, uint b) internal pure returns (uint) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
179         // Solidity only automatically asserts when dividing by 0
180         require(b > 0, errorMessage);
181         uint c = a / b;
182 
183         return c;
184     }
185 }
186 
187 library Address {
188     function isContract(address account) internal view returns (bool) {
189         bytes32 codehash;
190         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
191         // solhint-disable-next-line no-inline-assembly
192         assembly { codehash := extcodehash(account) }
193         return (codehash != 0x0 && codehash != accountHash);
194     }
195 }
196 
197 library SafeERC20 {
198     using SafeMath for uint;
199     using Address for address;
200 
201     function safeTransfer(IERC20 token, address to, uint value) internal {
202         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
203     }
204 
205     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
206         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
207     }
208 
209     function safeApprove(IERC20 token, address spender, uint value) internal {
210         require((value == 0) || (token.allowance(address(this), spender) == 0),
211             "SafeERC20: approve from non-zero to non-zero allowance"
212         );
213         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
214     }
215     function callOptionalReturn(IERC20 token, bytes memory data) private {
216         require(address(token).isContract(), "SafeERC20: call to non-contract");
217 
218         // solhint-disable-next-line avoid-low-level-calls
219         (bool success, bytes memory returndata) = address(token).call(data);
220         require(success, "SafeERC20: low-level call failed");
221 
222         if (returndata.length > 0) { // Return data is optional
223             // solhint-disable-next-line max-line-length
224             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
225         }
226     }
227 }
228 
229 /**
230  * Frog Token
231  */
232 pragma solidity 0.5.16;
233 
234 contract Frog is ERC20, ERC20Detailed {
235     using SafeERC20 for IERC20;
236     using Address for address;
237     using SafeMath for uint;
238 
239     address public governance;
240     address public pendingGov;
241 
242     mapping (address => bool) public minters;
243 
244     event NewPendingGov(address oldPendingGov, address newPendingGov);
245 
246     event NewGov(address oldGov, address newGov);
247 
248     // Modifiers
249     modifier onlyGov() {
250         require(msg.sender == governance, "Frog-Token: You are not the governance");
251         _;
252     }
253 
254     constructor () public ERC20Detailed("FrogSwap", "FROG", 18, 3000000 * 10 ** 18) {
255         governance = tx.origin;
256     }
257 
258     /** 
259      * Minte Token for Account
260      * @param _account minter
261      * @param _amount amount
262      */
263     function mint(address _account, uint256 _amount) external {
264         require(minters[msg.sender], "Frog-Token: You are not the minter");
265         _mint(_account, _amount);
266     }
267     
268     /** 
269      * Add minter
270      * @param _minter minter
271      */
272     function addMinter(address _minter) external onlyGov {
273         minters[_minter] = true;
274     }
275     
276     /** 
277      * Remove minter
278      * @param _minter minter
279      */
280     function removeMinter(address _minter) external onlyGov {
281         minters[_minter] = false;
282     }
283 
284     /** 
285      * Set new governance
286      * @param _pendingGov the new governance
287      */
288     function setPendingGov(address _pendingGov)
289         external
290         onlyGov
291     {
292         address oldPendingGov = pendingGov;
293         pendingGov = _pendingGov;
294         emit NewPendingGov(oldPendingGov, _pendingGov);
295     }
296 
297     /** 
298      * lets msg.sender accept governance
299      */
300     function acceptGov()
301         external {
302         require(msg.sender == pendingGov, "Frog-Token: You are not the pending governance");
303         address oldGov = governance;
304         governance = pendingGov;
305         pendingGov = address(0);
306         emit NewGov(oldGov, governance);
307     }
308 
309     /**
310      * @dev See {ERC20-_beforeTokenTransfer}.
311      *
312      * Requirements:
313      *
314      * - minted tokens must not cause the total supply to go over the cap.
315      */
316     function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
317         super._beforeTokenTransfer(from, to, amount);
318 
319         if (from == address(0)) { // When minting tokens
320             require(totalSupply().add(amount) <= cap(), "Frog-Token: Capacity exceeded");
321         }
322     }
323 }