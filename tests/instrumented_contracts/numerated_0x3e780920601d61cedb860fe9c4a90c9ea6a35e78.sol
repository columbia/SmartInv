1 //SPDX-License-Identifier: MIT
2 /*
3 * MIT License
4 * ===========
5 *
6 * Permission is hereby granted, free of charge, to any person obtaining a copy
7 * of this software and associated documentation files (the "Software"), to deal
8 * in the Software without restriction, including without limitation the rights
9 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 * copies of the Software, and to permit persons to whom the Software is
11 * furnished to do so, subject to the following conditions:
12 *
13 * The above copyright notice and this permission notice shall be included in all
14 * copies or substantial portions of the Software.
15 *
16 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
22 */
23 
24 pragma solidity ^0.5.17;
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint);
28     function balanceOf(address account) external view returns (uint);
29     function transfer(address recipient, uint amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint);
31     function approve(address spender, uint amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint value);
34     event Approval(address indexed owner, address indexed spender, uint value);
35 }
36 
37 contract Context {
38     constructor () internal { }
39     // solhint-disable-previous-line no-empty-blocks
40 
41     function _msgSender() internal view returns (address payable) {
42         return msg.sender;
43     }
44 }
45 
46 contract ERC20 is Context, IERC20 {
47     using SafeMath for uint;
48 
49     mapping (address => uint) private _balances;
50 
51     mapping (address => mapping (address => uint)) private _allowances;
52 
53     uint private _totalSupply;
54     function totalSupply() public view returns (uint) {
55         return _totalSupply;
56     }
57     function balanceOf(address account) public view returns (uint) {
58         return _balances[account];
59     }
60     function transfer(address recipient, uint amount) public returns (bool) {
61         _transfer(_msgSender(), recipient, amount);
62         return true;
63     }
64     function allowance(address owner, address spender) public view returns (uint) {
65         return _allowances[owner][spender];
66     }
67     function approve(address spender, uint amount) public returns (bool) {
68         _approve(_msgSender(), spender, amount);
69         return true;
70     }
71     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
72         _transfer(sender, recipient, amount);
73         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
74         return true;
75     }
76     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
77         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
78         return true;
79     }
80     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
81         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
82         return true;
83     }
84     function _transfer(address sender, address recipient, uint amount) internal {
85         require(sender != address(0), "ERC20: transfer from the zero address");
86         require(recipient != address(0), "ERC20: transfer to the zero address");
87 
88         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
89         _balances[recipient] = _balances[recipient].add(amount);
90         emit Transfer(sender, recipient, amount);
91     }
92     function _mint(address account, uint amount) internal {
93         require(account != address(0), "ERC20: mint to the zero address");
94 
95         _totalSupply = _totalSupply.add(amount);
96         require(_totalSupply <= 1e23, "_totalSupply exceed hard limit");
97         _balances[account] = _balances[account].add(amount);
98         emit Transfer(address(0), account, amount);
99     }
100     function _burn(address account, uint amount) internal {
101         require(account != address(0), "ERC20: burn from the zero address");
102 
103         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
104         _totalSupply = _totalSupply.sub(amount);
105         emit Transfer(account, address(0), amount);
106     }
107     function _approve(address owner, address spender, uint amount) internal {
108         require(owner != address(0), "ERC20: approve from the zero address");
109         require(spender != address(0), "ERC20: approve to the zero address");
110 
111         _allowances[owner][spender] = amount;
112         emit Approval(owner, spender, amount);
113     }
114 }
115 
116 contract ERC20Detailed is IERC20 {
117     string private _name;
118     string private _symbol;
119     uint8 private _decimals;
120 
121     constructor (string memory name, string memory symbol, uint8 decimals) public {
122         _name = name;
123         _symbol = symbol;
124         _decimals = decimals;
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
135 }
136 
137 library SafeMath {
138     function add(uint a, uint b) internal pure returns (uint) {
139         uint c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144     function sub(uint a, uint b) internal pure returns (uint) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
148         require(b <= a, errorMessage);
149         uint c = a - b;
150 
151         return c;
152     }
153     function mul(uint a, uint b) internal pure returns (uint) {
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163     function div(uint a, uint b) internal pure returns (uint) {
164         return div(a, b, "SafeMath: division by zero");
165     }
166     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
167         // Solidity only automatically asserts when dividing by 0
168         require(b > 0, errorMessage);
169         uint c = a / b;
170 
171         return c;
172     }
173 }
174 
175 library Address {
176     function isContract(address account) internal view returns (bool) {
177         bytes32 codehash;
178         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
179         // solhint-disable-next-line no-inline-assembly
180         assembly { codehash := extcodehash(account) }
181         return (codehash != 0x0 && codehash != accountHash);
182     }
183 }
184 
185 library SafeERC20 {
186     using SafeMath for uint;
187     using Address for address;
188 
189     function safeTransfer(IERC20 token, address to, uint value) internal {
190         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
191     }
192 
193     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
194         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
195     }
196 
197     function safeApprove(IERC20 token, address spender, uint value) internal {
198         require((value == 0) || (token.allowance(address(this), spender) == 0),
199             "SafeERC20: approve from non-zero to non-zero allowance"
200         );
201         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
202     }
203     function callOptionalReturn(IERC20 token, bytes memory data) private {
204         require(address(token).isContract(), "SafeERC20: call to non-contract");
205 
206         // solhint-disable-next-line avoid-low-level-calls
207         (bool success, bytes memory returndata) = address(token).call(data);
208         require(success, "SafeERC20: low-level call failed");
209 
210         if (returndata.length > 0) { // Return data is optional
211             // solhint-disable-next-line max-line-length
212             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
213         }
214     }
215 }
216 
217 contract BoostToken is ERC20, ERC20Detailed {
218     using SafeERC20 for IERC20;
219     using Address for address;
220     using SafeMath for uint;
221 
222 
223     address public governance;
224     mapping (address => bool) public minters;
225 
226     constructor () public ERC20Detailed("Boosted Finance", "BOOST", 18) {
227         governance = msg.sender;
228         addMinter(governance);
229         // underlying _mint function has hard limit 
230         mint(governance, 1e23);
231     }
232 
233     function mint(address account, uint amount) public {
234         require(minters[msg.sender], "!minter");
235         _mint(account, amount);
236     }
237 
238     function setGovernance(address _governance) public {
239         require(msg.sender == governance, "!governance");
240         governance = _governance;
241     }
242 
243     function addMinter(address _minter) public {
244         require(msg.sender == governance, "!governance");
245         minters[_minter] = true;
246     }
247 
248     function removeMinter(address _minter) public {
249         require(msg.sender == governance, "!governance");
250         minters[_minter] = false;
251     }
252 
253     function burn(uint256 amount) public {
254         _burn(msg.sender, amount);
255     }
256 }