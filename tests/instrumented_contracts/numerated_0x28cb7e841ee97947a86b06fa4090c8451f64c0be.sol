1 /**
2 
3 Link marines the time has finally come. Presenting YFLink governance token:
4 
5 #     # ####### #
6  #   #  #       #       # #    # #    #     #  ####
7   # #   #       #       # ##   # #   #      # #    #
8    #    #####   #       # # #  # ####       # #    #
9    #    #       #       # #  # # #  #   ### # #    #
10    #    #       #       # #   ## #   #  ### # #    #
11    #    #       ####### # #    # #    # ### #  ####
12 
13 
14 ######                                            #
15 #     # #  ####  #####  #        ##   #   #      # #   #####    ##   #####  #####   ##   #####  # #      # ##### #   #
16 #     # # #      #    # #       #  #   # #      #   #  #    #  #  #  #    #   #    #  #  #    # # #      #   #    # #
17 #     # #  ####  #    # #      #    #   #      #     # #    # #    # #    #   #   #    # #####  # #      #   #     #
18 #     # #      # #####  #      ######   #      ####### #    # ###### #####    #   ###### #    # # #      #   #     #
19 #     # # #    # #      #      #    #   #      #     # #    # #    # #        #   #    # #    # # #      #   #     #
20 ######  #  ####  #      ###### #    #   #      #     # #####  #    # #        #   #    # #####  # ###### #   #     #
21 
22 
23 This code was forked from Andre Cronje's YFI and modified.
24 It has not been audited and may contain bugs - be warned.
25 Similarly as YFI, it has zero initial supply and has zero financial value.
26 There is no sale of it either, it can only be minted by staking Link.
27 
28 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 SOFTWARE.
35 
36 */
37 
38 pragma solidity ^0.5.16;
39 
40 interface IERC20 {
41     function totalSupply() external view returns (uint);
42     function balanceOf(address account) external view returns (uint);
43     function transfer(address recipient, uint amount) external returns (bool);
44     function allowance(address owner, address spender) external view returns (uint);
45     function approve(address spender, uint amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
47     event Transfer(address indexed from, address indexed to, uint value);
48     event Approval(address indexed owner, address indexed spender, uint value);
49 }
50 
51 contract Context {
52     constructor () internal { }
53     // solhint-disable-previous-line no-empty-blocks
54 
55     function _msgSender() internal view returns (address payable) {
56         return msg.sender;
57     }
58 }
59 
60 contract ERC20 is Context, IERC20 {
61     using SafeMath for uint;
62 
63     mapping (address => uint) private _balances;
64 
65     mapping (address => mapping (address => uint)) private _allowances;
66 
67     uint private _totalSupply;
68     function totalSupply() public view returns (uint) {
69         return _totalSupply;
70     }
71     function balanceOf(address account) public view returns (uint) {
72         return _balances[account];
73     }
74     function transfer(address recipient, uint amount) public returns (bool) {
75         _transfer(_msgSender(), recipient, amount);
76         return true;
77     }
78     function allowance(address owner, address spender) public view returns (uint) {
79         return _allowances[owner][spender];
80     }
81     function approve(address spender, uint amount) public returns (bool) {
82         _approve(_msgSender(), spender, amount);
83         return true;
84     }
85     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
86         _transfer(sender, recipient, amount);
87         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
88         return true;
89     }
90     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
91         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
92         return true;
93     }
94     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
95         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
96         return true;
97     }
98     function _transfer(address sender, address recipient, uint amount) internal {
99         require(sender != address(0), "ERC20: transfer from the zero address");
100         require(recipient != address(0), "ERC20: transfer to the zero address");
101 
102         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
103         _balances[recipient] = _balances[recipient].add(amount);
104         emit Transfer(sender, recipient, amount);
105     }
106     function _mint(address account, uint amount) internal {
107         require(account != address(0), "ERC20: mint to the zero address");
108 
109         _totalSupply = _totalSupply.add(amount);
110         _balances[account] = _balances[account].add(amount);
111         emit Transfer(address(0), account, amount);
112     }
113     function _burn(address account, uint amount) internal {
114         require(account != address(0), "ERC20: burn from the zero address");
115 
116         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
117         _totalSupply = _totalSupply.sub(amount);
118         emit Transfer(account, address(0), amount);
119     }
120     function _approve(address owner, address spender, uint amount) internal {
121         require(owner != address(0), "ERC20: approve from the zero address");
122         require(spender != address(0), "ERC20: approve to the zero address");
123 
124         _allowances[owner][spender] = amount;
125         emit Approval(owner, spender, amount);
126     }
127 }
128 
129 contract ERC20Detailed is IERC20 {
130     string private _name;
131     string private _symbol;
132     uint8 private _decimals;
133 
134     constructor (string memory name, string memory symbol, uint8 decimals) public {
135         _name = name;
136         _symbol = symbol;
137         _decimals = decimals;
138     }
139     function name() public view returns (string memory) {
140         return _name;
141     }
142     function symbol() public view returns (string memory) {
143         return _symbol;
144     }
145     function decimals() public view returns (uint8) {
146         return _decimals;
147     }
148 }
149 
150 library SafeMath {
151     function add(uint a, uint b) internal pure returns (uint) {
152         uint c = a + b;
153         require(c >= a, "SafeMath: addition overflow");
154 
155         return c;
156     }
157     function sub(uint a, uint b) internal pure returns (uint) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
161         require(b <= a, errorMessage);
162         uint c = a - b;
163 
164         return c;
165     }
166     function mul(uint a, uint b) internal pure returns (uint) {
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176     function div(uint a, uint b) internal pure returns (uint) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
180         // Solidity only automatically asserts when dividing by 0
181         require(b > 0, errorMessage);
182         uint c = a / b;
183 
184         return c;
185     }
186 }
187 
188 library Address {
189     function isContract(address account) internal view returns (bool) {
190         bytes32 codehash;
191         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
192         // solhint-disable-next-line no-inline-assembly
193         assembly { codehash := extcodehash(account) }
194         return (codehash != 0x0 && codehash != accountHash);
195     }
196 }
197 
198 library SafeERC20 {
199     using SafeMath for uint;
200     using Address for address;
201 
202     function safeTransfer(IERC20 token, address to, uint value) internal {
203         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
204     }
205 
206     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
207         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
208     }
209 
210     function safeApprove(IERC20 token, address spender, uint value) internal {
211         require((value == 0) || (token.allowance(address(this), spender) == 0),
212             "SafeERC20: approve from non-zero to non-zero allowance"
213         );
214         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
215     }
216     function callOptionalReturn(IERC20 token, bytes memory data) private {
217         require(address(token).isContract(), "SafeERC20: call to non-contract");
218 
219         // solhint-disable-next-line avoid-low-level-calls
220         (bool success, bytes memory returndata) = address(token).call(data);
221         require(success, "SafeERC20: low-level call failed");
222 
223         if (returndata.length > 0) { // Return data is optional
224             // solhint-disable-next-line max-line-length
225             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
226         }
227     }
228 }
229 
230 contract YFLink is ERC20, ERC20Detailed {
231     using SafeERC20 for IERC20;
232     using Address for address;
233     using SafeMath for uint;
234 
235 
236     address public governance;
237     mapping (address => bool) public minters;
238 
239     constructor () public ERC20Detailed("YFLink", "YFL", 18) {
240         governance = tx.origin;
241     }
242 
243     function mint(address account, uint256 amount) public {
244         require(minters[msg.sender], "!minter");
245         _mint(account, amount);
246     }
247 
248     function setGovernance(address _governance) public {
249         require(msg.sender == governance, "!governance");
250         governance = _governance;
251     }
252 
253     function addMinter(address _minter) public {
254         require(msg.sender == governance, "!governance");
255         minters[_minter] = true;
256     }
257 
258     function removeMinter(address _minter) public {
259         require(msg.sender == governance, "!governance");
260         minters[_minter] = false;
261     }
262 }