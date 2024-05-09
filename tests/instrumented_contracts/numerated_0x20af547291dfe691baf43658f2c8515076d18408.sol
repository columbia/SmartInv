1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.1;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40 
41         return c;
42     }
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         return mod(a, b, "SafeMath: modulo by zero");
63     }
64     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b != 0, errorMessage);
66         return a % b;
67     }
68 }
69 
70 library Address {
71     function isContract(address account) internal view returns (bool) {
72         uint256 size;
73         assembly { size := extcodesize(account) }
74         return size > 0;
75     }
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78         (bool success, ) = recipient.call{ value: amount }("");
79         require(success, "Address: unable to send value, recipient may have reverted");
80     }
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82         return functionCall(target, data, "Address: low-level call failed");
83     }
84     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
85         return functionCallWithValue(target, data, 0, errorMessage);
86     }
87     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
89     }
90     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
91         require(address(this).balance >= value, "Address: insufficient balance for call");
92         require(isContract(target), "Address: call to non-contract");
93         (bool success, bytes memory returndata) = target.call{ value: value }(data);
94         return _verifyCallResult(success, returndata, errorMessage);
95     }
96     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
97         return functionStaticCall(target, data, "Address: low-level static call failed");
98     }
99     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
100         require(isContract(target), "Address: static call to non-contract");
101         (bool success, bytes memory returndata) = target.staticcall(data);
102         return _verifyCallResult(success, returndata, errorMessage);
103     }
104     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
105         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
106     }
107     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
108         require(isContract(target), "Address: delegate call to non-contract");
109         (bool success, bytes memory returndata) = target.delegatecall(data);
110         return _verifyCallResult(success, returndata, errorMessage);
111     }
112     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
113         if (success) {
114             return returndata;
115         } else {
116             if (returndata.length > 0) {
117                 assembly {
118                     let returndata_size := mload(returndata)
119                     revert(add(32, returndata), returndata_size)
120                 }
121             } else {
122                 revert(errorMessage);
123             }
124         }
125     }
126 }
127 
128 contract ERC20 is Context, IERC20 {
129     using SafeMath for uint256;
130     using Address for address;
131 
132     mapping (address => uint256) private _balances;
133 
134     mapping (address => mapping (address => uint256)) private _allowances;
135 
136     uint256 private _totalSupply;
137 
138     string private _name;
139     string private _symbol;
140     uint8 private _decimals;
141 
142     constructor (string memory name_, string memory symbol_) {
143         _name = name_;
144         _symbol = symbol_;
145         _decimals = 18;
146     }
147     function name() public view returns (string memory) {
148         return _name;
149     }
150     function symbol() public view returns (string memory) {
151         return _symbol;
152     }
153     function decimals() public view returns (uint8) {
154         return _decimals;
155     }
156     function totalSupply() public view override returns (uint256) {
157         return _totalSupply;
158     }
159     function balanceOf(address account) public view override returns (uint256) {
160         return _balances[account];
161     }
162     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
163         _transfer(_msgSender(), recipient, amount);
164         return true;
165     }
166     function allowance(address owner, address spender) public view virtual override returns (uint256) {
167         return _allowances[owner][spender];
168     }
169     function approve(address spender, uint256 amount) public virtual override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
174         _transfer(sender, recipient, amount);
175         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
176         return true;
177     }
178     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
180         return true;
181     }
182     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
184         return true;
185     }
186     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
187         require(sender != address(0), "ERC20: transfer from the zero address");
188         require(recipient != address(0), "ERC20: transfer to the zero address");
189 
190         _beforeTokenTransfer(sender, recipient, amount);
191 
192         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
193         _balances[recipient] = _balances[recipient].add(amount);
194         emit Transfer(sender, recipient, amount);
195     }
196     function _mint(address account, uint256 amount) internal virtual {
197         require(account != address(0), "ERC20: mint to the zero address");
198 
199         _beforeTokenTransfer(address(0), account, amount);
200 
201         _totalSupply = _totalSupply.add(amount);
202         _balances[account] = _balances[account].add(amount);
203         emit Transfer(address(0), account, amount);
204     }
205     function _burn(address account, uint256 amount) internal virtual {
206         require(account != address(0), "ERC20: burn from the zero address");
207 
208         _beforeTokenTransfer(account, address(0), amount);
209 
210         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
211         _totalSupply = _totalSupply.sub(amount);
212         emit Transfer(account, address(0), amount);
213     }
214     function _approve(address owner, address spender, uint256 amount) internal virtual {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217 
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221     function _setupDecimals(uint8 decimals_) internal {
222         _decimals = decimals_;
223     }
224     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
225 }
226 
227 
228 
229 contract DICK is ERC20 {
230   constructor (string memory name, string memory symbol) ERC20(name, symbol) {
231     _mint(msg.sender, 1000000000000000 ether);
232   }
233 }