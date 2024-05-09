1 pragma solidity ^0.5.1;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint);
5 
6     function balanceOf(address account) external view returns (uint);
7 
8     function transfer(address recipient, uint amount) external returns (bool);
9 
10     function allowance(address owner, address spender) external view returns (uint);
11 
12     function approve(address spender, uint amount) external returns (bool);
13 
14     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint value);
17     event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 contract Context {
21     constructor () internal {}
22     // solhint-disable-previous-line no-empty-blocks
23 
24     function _msgSender() internal view returns (address payable) {
25         return msg.sender;
26     }
27 }
28 
29 contract ERC20 is Context, IERC20 {
30     using SafeMath for uint;
31 
32     mapping(address => uint) private _balances;
33 
34     mapping(address => mapping(address => uint)) private _allowances;
35 
36     uint private _totalSupply;
37 
38     function totalSupply() public view returns (uint) {
39         return _totalSupply;
40     }
41 
42     function balanceOf(address account) public view returns (uint) {
43         return _balances[account];
44     }
45 
46     function transfer(address recipient, uint amount) public returns (bool) {
47         _transfer(_msgSender(), recipient, amount);
48         return true;
49     }
50 
51     function allowance(address owner, address spender) public view returns (uint) {
52         return _allowances[owner][spender];
53     }
54 
55     function approve(address spender, uint amount) public returns (bool) {
56         _approve(_msgSender(), spender, amount);
57         return true;
58     }
59 
60     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
61         _transfer(sender, recipient, amount);
62         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
63         return true;
64     }
65 
66     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
67         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
68         return true;
69     }
70 
71     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
72         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
73         return true;
74     }
75 
76     function _transfer(address sender, address recipient, uint amount) internal {
77         require(sender != address(0), "ERC20: transfer from the zero address");
78         require(recipient != address(0), "ERC20: transfer to the zero address");
79 
80         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
81         _balances[recipient] = _balances[recipient].add(amount);
82         emit Transfer(sender, recipient, amount);
83     }
84 
85     function _mint(address account, uint amount) internal {
86         require(account != address(0), "ERC20: mint to the zero address");
87 
88         _totalSupply = _totalSupply.add(amount);
89         _balances[account] = _balances[account].add(amount);
90         emit Transfer(address(0), account, amount);
91     }
92 
93     function _burn(address account, uint amount) internal {
94         require(account != address(0), "ERC20: burn from the zero address");
95 
96         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
97         _totalSupply = _totalSupply.sub(amount);
98         emit Transfer(account, address(0), amount);
99     }
100 
101     function _approve(address owner, address spender, uint amount) internal {
102         require(owner != address(0), "ERC20: approve from the zero address");
103         require(spender != address(0), "ERC20: approve to the zero address");
104 
105         _allowances[owner][spender] = amount;
106         emit Approval(owner, spender, amount);
107     }
108 }
109 
110 contract ERC20Detailed is IERC20 {
111     string private _name;
112     string private _symbol;
113     uint8 private _decimals;
114 
115     constructor (string memory name, string memory symbol, uint8 decimals) public {
116         _name = name;
117         _symbol = symbol;
118         _decimals = decimals;
119     }
120     function name() public view returns (string memory) {
121         return _name;
122     }
123 
124     function symbol() public view returns (string memory) {
125         return _symbol;
126     }
127 
128     function decimals() public view returns (uint8) {
129         return _decimals;
130     }
131 }
132 
133 library SafeMath {
134     function add(uint a, uint b) internal pure returns (uint) {
135         uint c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     function sub(uint a, uint b) internal pure returns (uint) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
146         require(b <= a, errorMessage);
147         uint c = a - b;
148 
149         return c;
150     }
151 
152     function mul(uint a, uint b) internal pure returns (uint) {
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     function div(uint a, uint b) internal pure returns (uint) {
164         return div(a, b, "SafeMath: division by zero");
165     }
166 
167     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
168         // Solidity only automatically asserts when dividing by 0
169         require(b > 0, errorMessage);
170         uint c = a / b;
171 
172         return c;
173     }
174 }
175 
176 library Address {
177     function isContract(address account) internal view returns (bool) {
178         bytes32 codehash;
179         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
180         // solhint-disable-next-line no-inline-assembly
181         assembly {codehash := extcodehash(account)}
182         return (codehash != 0x0 && codehash != accountHash);
183     }
184 }
185 
186 library SafeERC20 {
187     using SafeMath for uint;
188     using Address for address;
189 
190     function safeTransfer(IERC20 token, address to, uint value) internal {
191         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
192     }
193 
194     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
195         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
196     }
197 
198     function safeApprove(IERC20 token, address spender, uint value) internal {
199         require((value == 0) || (token.allowance(address(this), spender) == 0),
200             "SafeERC20: approve from non-zero to non-zero allowance"
201         );
202         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
203     }
204 
205     function callOptionalReturn(IERC20 token, bytes memory data) private {
206         require(address(token).isContract(), "SafeERC20: call to non-contract");
207 
208         // solhint-disable-next-line avoid-low-level-calls
209         (bool success, bytes memory returndata) = address(token).call(data);
210         require(success, "SafeERC20: low-level call failed");
211 
212         if (returndata.length > 0) {// Return data is optional
213             // solhint-disable-next-line max-line-length
214             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
215         }
216     }
217 }
218 
219 contract DPLTOKEN is ERC20, ERC20Detailed {
220     using SafeERC20 for IERC20;
221     using Address for address;
222     using SafeMath for uint;
223 
224 
225     address public owner;
226     mapping(address => bool) public minters;
227 
228     constructor () public ERC20Detailed("Dolphin Protocol", "DPL", 18) {
229         owner = msg.sender;
230         _mint(msg.sender, 3600000 * 1e18);
231     }
232 
233     function setOwner(address _owner) public {
234         require(msg.sender == owner, "!owner");
235         owner = _owner;
236     }
237 
238     function addMinter(address _minter) public {
239         require(msg.sender == owner, "!owner");
240         minters[_minter] = true;
241     }
242 
243     function removeMinter(address _minter) public {
244         require(msg.sender == owner, "!owner");
245         minters[_minter] = false;
246     }
247 
248     function burn(uint256 amount) external {
249         _burn(msg.sender, amount);
250     }
251 }