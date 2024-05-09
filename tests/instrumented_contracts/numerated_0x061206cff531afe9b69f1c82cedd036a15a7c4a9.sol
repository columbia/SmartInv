1 pragma solidity ^0.6.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 
15 library SafeMath {
16     
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27 
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58         return c;
59     }
60 
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         return mod(a, b, "SafeMath: modulo by zero");
63     }
64 
65     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b != 0, errorMessage);
67         return a % b;
68     }
69 }
70 
71 // SPDX-License-Identifier: MIT
72 
73 interface IERC20 {
74     
75     function totalSupply() external view returns (uint256);
76     function balanceOf(address account) external view returns (uint256);
77     function transfer(address recipient, uint256 amount) external returns (bool);
78     function allowance(address owner, address spender) external view returns (uint256);
79     function approve(address spender, uint256 amount) external returns (bool);
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // SPDX-License-Identifier: MIT
86 
87 pragma solidity ^0.6.2;
88 
89 library Address {
90     
91     function isContract(address account) internal view returns (bool) {
92         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
93         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
94         // for accounts without code, i.e. `keccak256('')`
95         bytes32 codehash;
96         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
97         // solhint-disable-next-line no-inline-assembly
98         assembly { codehash := extcodehash(account) }
99         return (codehash != accountHash && codehash != 0x0);
100     }
101     
102     function sendValue(address payable recipient, uint256 amount) internal {
103         require(address(this).balance >= amount, "Address: insufficient balance");
104 
105         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
106         (bool success, ) = recipient.call{ value: amount }("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111       return functionCall(target, data, "Address: low-level call failed");
112     }
113     
114     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
115         return _functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
123         require(address(this).balance >= value, "Address: insufficient balance for call");
124         return _functionCallWithValue(target, data, value, errorMessage);
125     }
126 
127     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
128         require(isContract(target), "Address: call to non-contract");
129 
130         // solhint-disable-next-line avoid-low-level-calls
131         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
132         if (success) {
133             return returndata;
134         } else {
135             // Look for revert reason and bubble it up if present
136             if (returndata.length > 0) {
137                 // The easiest way to bubble the revert reason is using memory via assembly
138 
139                 // solhint-disable-next-line no-inline-assembly
140                 assembly {
141                     let returndata_size := mload(returndata)
142                     revert(add(32, returndata), returndata_size)
143                 }
144             } else {
145                 revert(errorMessage);
146             }
147         }
148     }
149 }
150 
151 // SPDX-License-Identifier: MIT
152 
153 pragma solidity ^0.6.0;
154 
155 contract OTEN is Context, IERC20 {
156     using SafeMath for uint256;
157     using Address for address;
158     mapping (address => uint256) private _balances;
159     mapping (address => mapping (address => uint256)) private _allowances;
160     uint256 private _totalSupply;
161     string private _name;
162     string private _symbol;
163     uint8 private _decimals;
164     
165     constructor (string memory name, string memory symbol) public {
166         _name = name;
167         _symbol = symbol;
168         _decimals = 18;
169         _totalSupply = 10000000000000000000;
170         _balances[msg.sender] = _totalSupply;
171     }
172 
173     function name() public view returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public view returns (string memory) {
178         return _symbol;
179     }
180     
181     function decimals() public view returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public view override returns (uint256) {
186         return _totalSupply;
187     }
188 
189     function balanceOf(address account) public view override returns (uint256) {
190         return _balances[account];
191     }
192 
193     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender) public view virtual override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202    
203     function approve(address spender, uint256 amount) public virtual override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
215         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
216         return true;
217     }
218 
219     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
220         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
221         return true;
222     }
223 
224     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
225         require(sender != address(0), "ERC20: transfer from the zero address");
226         require(recipient != address(0), "ERC20: transfer to the zero address");
227 
228         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
229         _balances[recipient] = _balances[recipient].add(amount);
230         emit Transfer(sender, recipient, amount);
231     }
232 
233     function _approve(address owner, address spender, uint256 amount) internal virtual {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236 
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 }