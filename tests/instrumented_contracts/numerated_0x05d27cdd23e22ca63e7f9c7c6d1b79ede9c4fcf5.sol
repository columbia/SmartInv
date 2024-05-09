1 // SPDX-License-Identifier: MIT
2 
3 
4 // ------------------------------------------------------------------------
5 // MIT License
6 // Copyright (c) 2020 Yearn Finance Passive Income
7 //
8 // Permission is hereby granted, free of charge, to any person obtaining a copy
9 // of this software and associated documentation files (the "Software"), to deal
10 // in the Software without restriction, including without limitation the rights
11 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 // copies of the Software, and to permit persons to whom the Software is
13 // furnished to do so, subject to the following conditions:
14 //
15 // The above copyright notice and this permission notice shall be included in all
16 // copies or substantial portions of the Software.
17 //
18 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
19 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
20 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
21 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
22 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
23 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
24 // SOFTWARE.
25 // ------------------------------------------------------------------------    
26 
27     pragma solidity ^0.5.16;
28 
29     interface IERC20 {
30         function totalSupply() external view returns (uint);
31         function balanceOf(address account) external view returns (uint);
32         function transfer(address recipient, uint amount) external returns (bool);
33         function allowance(address owner, address spender) external view returns (uint);
34         function approve(address spender, uint amount) external returns (bool);
35         function transferFrom(address sender, address recipient, uint amount) external returns (bool);
36         event Transfer(address indexed from, address indexed to, uint value);
37         event Approval(address indexed owner, address indexed spender, uint value);
38     }
39 
40     contract Context {
41         constructor () internal { }
42         // solhint-disable-previous-line no-empty-blocks
43 
44         function _msgSender() internal view returns (address payable) {
45             return msg.sender;
46         }
47     }
48 
49     contract ERC20 is Context, IERC20 {
50         using SafeMath for uint;
51 
52         mapping (address => uint) private _balances;
53 
54         mapping (address => mapping (address => uint)) private _allowances;
55 
56         uint private _totalSupply;
57         function totalSupply() public view returns (uint) {
58             return _totalSupply;
59         }
60         function balanceOf(address account) public view returns (uint) {
61             return _balances[account];
62         }
63         function transfer(address recipient, uint amount) public returns (bool) {
64             _transfer(_msgSender(), recipient, amount);
65             return true;
66         }
67         function allowance(address owner, address spender) public view returns (uint) {
68             return _allowances[owner][spender];
69         }
70         function approve(address spender, uint amount) public returns (bool) {
71             _approve(_msgSender(), spender, amount);
72             return true;
73         }
74         function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
75             _transfer(sender, recipient, amount);
76             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
77             return true;
78         }
79         function increaseAllowance(address spender, uint addedValue) public returns (bool) {
80             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
81             return true;
82         }
83         function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
84             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
85             return true;
86         }
87         function _transfer(address sender, address recipient, uint amount) internal {
88             require(sender != address(0), "ERC20: transfer from the zero address");
89             require(recipient != address(0), "ERC20: transfer to the zero address");
90 
91             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
92             _balances[recipient] = _balances[recipient].add(amount);
93             emit Transfer(sender, recipient, amount);
94         }
95         function _mint(address account, uint amount) internal {
96             require(account != address(0), "ERC20: mint to the zero address");
97 
98             _totalSupply = _totalSupply.add(amount);
99             _balances[account] = _balances[account].add(amount);
100             emit Transfer(address(0), account, amount);
101         }
102         function _burn(address account, uint amount) internal {
103             require(account != address(0), "ERC20: burn from the zero address");
104             require(_balances[account] >= amount);
105             _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
106             _totalSupply = _totalSupply.sub(amount);
107             emit Transfer(account, address(0), amount);
108         }
109         function _approve(address owner, address spender, uint amount) internal {
110             require(owner != address(0), "ERC20: approve from the zero address");
111             require(spender != address(0), "ERC20: approve to the zero address");
112 
113             _allowances[owner][spender] = amount;
114             emit Approval(owner, spender, amount);
115         }
116     }
117 
118     contract ERC20Detailed is IERC20 {
119         string private _name;
120         string private _symbol;
121         uint8 private _decimals;
122 
123         constructor (string memory name, string memory symbol, uint8 decimals) public {
124             _name = name;
125             _symbol = symbol;
126             _decimals = decimals;
127         }
128         function name() public view returns (string memory) {
129             return _name;
130         }
131         function symbol() public view returns (string memory) {
132             return _symbol;
133         }
134         function decimals() public view returns (uint8) {
135             return _decimals;
136         }
137     }
138 
139     library SafeMath {
140         function add(uint a, uint b) internal pure returns (uint) {
141             uint c = a + b;
142             require(c >= a, "SafeMath: addition overflow");
143 
144             return c;
145         }
146         function sub(uint a, uint b) internal pure returns (uint) {
147             return sub(a, b, "SafeMath: subtraction overflow");
148         }
149         function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
150             require(b <= a, errorMessage);
151             uint c = a - b;
152 
153             return c;
154         }
155         function mul(uint a, uint b) internal pure returns (uint) {
156             if (a == 0) {
157                 return 0;
158             }
159 
160             uint c = a * b;
161             require(c / a == b, "SafeMath: multiplication overflow");
162 
163             return c;
164         }
165         function div(uint a, uint b) internal pure returns (uint) {
166             return div(a, b, "SafeMath: division by zero");
167         }
168         function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
169             // Solidity only automatically asserts when dividing by 0
170             require(b > 0, errorMessage);
171             uint c = a / b;
172 
173             return c;
174         }
175     }
176 
177     library Address {
178         function isContract(address account) internal view returns (bool) {
179             bytes32 codehash;
180             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
181             // solhint-disable-next-line no-inline-assembly
182             assembly { codehash := extcodehash(account) }
183             return (codehash != 0x0 && codehash != accountHash);
184         }
185     }
186 
187     library SafeERC20 {
188         using SafeMath for uint;
189         using Address for address;
190 
191         function safeTransfer(IERC20 token, address to, uint value) internal {
192             callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
193         }
194 
195         function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
196             callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
197         }
198 
199         function safeApprove(IERC20 token, address spender, uint value) internal {
200             require((value == 0) || (token.allowance(address(this), spender) == 0),
201                 "SafeERC20: approve from non-zero to non-zero allowance"
202             );
203             callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
204         }
205         function callOptionalReturn(IERC20 token, bytes memory data) private {
206             require(address(token).isContract(), "SafeERC20: call to non-contract");
207 
208             // solhint-disable-next-line avoid-low-level-calls
209             (bool success, bytes memory returndata) = address(token).call(data);
210             require(success, "SafeERC20: low-level call failed");
211 
212             if (returndata.length > 0) { // Return data is optional
213                 // solhint-disable-next-line max-line-length
214                 require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
215             }
216         }
217     }
218 
219     contract YFPI is ERC20, ERC20Detailed {
220     using SafeERC20 for IERC20;
221     using Address for address;
222     using SafeMath for uint;
223        
224     address public owner;
225 
226     constructor () public ERC20Detailed("Yearn Finance Passive Income", "YFPI", 18) {
227         owner = msg.sender;
228         _mint(_msgSender(), 30000 * (10 ** uint256(decimals())));
229     }
230 
231     function burn(uint amount) public {
232          _burn(msg.sender, amount);
233     }
234     
235 
236     }