1 pragma solidity ^0.5.8;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address account) external view returns (uint256);
7 
8     function transfer(address recipient, uint256 amount)external returns (bool);
9 
10     function allowance(address owner, address spender) external view returns (uint256);
11 
12     function approve(address spender, uint256 amount) external returns (bool);
13 
14     function transferFrom(address sender,address recipient,uint256 amount) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner,address indexed spender,uint256 value);
18 }
19 
20 contract Context {
21     constructor() internal {}
22 
23     // solhint-disable-previous-line no-empty-blocks
24 
25     function _msgSender() internal view returns (address payable) {
26         return msg.sender;
27     }
28 }
29 
30 contract ERC20 is Context, IERC20 {
31     using SafeMath for uint256;
32 
33     mapping(address => uint256) private _balances;
34 
35     mapping(address => mapping(address => uint256)) private _allowances;
36 
37     uint256 private _totalSupply;
38 
39     function totalSupply() public view returns (uint256) {
40         return _totalSupply;
41     }
42 
43     function balanceOf(address account) public view returns (uint256) {
44         return _balances[account];
45     }
46 
47     function transfer(address recipient, uint256 amount) public returns (bool) {
48         _transfer(_msgSender(), recipient, amount);
49         return true;
50     }
51 
52     function allowance(address owner, address spender)
53         public
54         view
55         returns (uint256)
56     {
57         return _allowances[owner][spender];
58     }
59 
60     function approve(address spender, uint256 amount) public returns (bool) {
61         _approve(_msgSender(), spender, amount);
62         return true;
63     }
64 
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) public returns (bool) {
70         _transfer(sender, recipient, amount);
71         _approve(
72             sender,
73             _msgSender(),
74             _allowances[sender][_msgSender()].sub(
75                 amount,
76                 "ERC20: transfer amount exceeds allowance"
77             )
78         );
79         return true;
80     }
81 
82     function increaseAllowance(address spender, uint256 addedValue)
83         public
84         returns (bool)
85     {
86         _approve(
87             _msgSender(),
88             spender,
89             _allowances[_msgSender()][spender].add(addedValue)
90         );
91         return true;
92     }
93 
94     function decreaseAllowance(address spender, uint256 subtractedValue)
95         public
96         returns (bool)
97     {
98         _approve(
99             _msgSender(),
100             spender,
101             _allowances[_msgSender()][spender].sub(
102                 subtractedValue,
103                 "ERC20: decreased allowance below zero"
104             )
105         );
106         return true;
107     }
108 
109     function _transfer(
110         address sender,
111         address recipient,
112         uint256 amount
113     ) internal {
114         require(sender != address(0), "ERC20: transfer from the zero address");
115         require(recipient != address(0), "ERC20: transfer to the zero address");
116 
117         _balances[sender] = _balances[sender].sub(
118             amount,
119             "ERC20: transfer amount exceeds balance"
120         );
121         _balances[recipient] = _balances[recipient].add(amount);
122         emit Transfer(sender, recipient, amount);
123     }
124 
125     function _mint(address account, uint256 amount) internal {
126         require(account != address(0), "ERC20: mint to the zero address");
127 
128         _totalSupply = _totalSupply.add(amount);
129         _balances[account] = _balances[account].add(amount);
130         emit Transfer(address(0), account, amount);
131     }
132 
133     function _burn(address account, uint256 amount) internal {
134         require(account != address(0), "ERC20: burn from the zero address");
135 
136         _balances[account] = _balances[account].sub(
137             amount,
138             "ERC20: burn amount exceeds balance"
139         );
140         _totalSupply = _totalSupply.sub(amount);
141         emit Transfer(account, address(0), amount);
142     }
143 
144     function _approve(
145         address owner,
146         address spender,
147         uint256 amount
148     ) internal {
149         require(owner != address(0), "ERC20: approve from the zero address");
150         require(spender != address(0), "ERC20: approve to the zero address");
151 
152         _allowances[owner][spender] = amount;
153         emit Approval(owner, spender, amount);
154     }
155 }
156 
157 contract ERC20Detailed is IERC20 {
158     string private _name;
159     string private _symbol;
160     uint8 private _decimals;
161 
162     constructor(
163         string memory name,
164         string memory symbol,
165         uint8 decimals
166     ) public {
167         _name = name;
168         _symbol = symbol;
169         _decimals = decimals;
170     }
171 
172     function name() public view returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public view returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public view returns (uint8) {
181         return _decimals;
182     }
183 }
184 
185 library SafeMath {
186     function add(uint256 a, uint256 b) internal pure returns (uint256) {
187         uint256 c = a + b;
188         require(c >= a, "SafeMath: addition overflow");
189 
190         return c;
191     }
192 
193     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194         return sub(a, b, "SafeMath: subtraction overflow");
195     }
196 
197     function sub(
198         uint256 a,
199         uint256 b,
200         string memory errorMessage
201     ) internal pure returns (uint256) {
202         require(b <= a, errorMessage);
203         uint256 c = a - b;
204 
205         return c;
206     }
207 
208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209         if (a == 0) {
210             return 0;
211         }
212 
213         uint256 c = a * b;
214         require(c / a == b, "SafeMath: multiplication overflow");
215 
216         return c;
217     }
218 
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     function div(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         // Solidity only automatically asserts when dividing by 0
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231 
232         return c;
233     }
234 }
235 
236 library Address {
237     function isContract(address account) internal view returns (bool) {
238         bytes32 codehash;
239 
240             bytes32 accountHash
241          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
242         // solhint-disable-next-line no-inline-assembly
243         assembly {
244             codehash := extcodehash(account)
245         }
246         return (codehash != 0x0 && codehash != accountHash);
247     }
248 }
249 
250 library SafeERC20 {
251     using SafeMath for uint256;
252     using Address for address;
253 
254     function safeTransfer(
255         IERC20 token,
256         address to,
257         uint256 value
258     ) internal {
259         callOptionalReturn(
260             token,
261             abi.encodeWithSelector(token.transfer.selector, to, value)
262         );
263     }
264 
265     function safeTransferFrom(
266         IERC20 token,
267         address from,
268         address to,
269         uint256 value
270     ) internal {
271         callOptionalReturn(
272             token,
273             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
274         );
275     }
276 
277     function safeApprove(
278         IERC20 token,
279         address spender,
280         uint256 value
281     ) internal {
282         require(
283             (value == 0) || (token.allowance(address(this), spender) == 0),
284             "SafeERC20: approve from non-zero to non-zero allowance"
285         );
286         callOptionalReturn(
287             token,
288             abi.encodeWithSelector(token.approve.selector, spender, value)
289         );
290     }
291 
292     function callOptionalReturn(IERC20 token, bytes memory data) private {
293         require(address(token).isContract(), "SafeERC20: call to non-contract");
294 
295         // solhint-disable-next-line avoid-low-level-calls
296         (bool success, bytes memory returndata) = address(token).call(data);
297         require(success, "SafeERC20: low-level call failed");
298 
299         if (returndata.length > 0) {
300             // Return data is optional
301             // solhint-disable-next-line max-line-length
302             require(
303                 abi.decode(returndata, (bool)),
304                 "SafeERC20: ERC20 operation did not succeed"
305             );
306         }
307     }
308 }
309 
310 contract RealityGem is ERC20, ERC20Detailed {
311     using SafeERC20 for IERC20;
312     using Address for address;
313     using SafeMath for uint256;
314 
315     address public governance;
316     mapping(address => bool) public minters;
317 
318     modifier onlyGovernance() {
319         require(msg.sender == governance, "!governance");
320         _;
321     }
322 
323     constructor() public ERC20Detailed("Reality.Gem", "RG", 18) {
324         governance = msg.sender;
325     }
326 
327     function mint(address account, uint256 amount) public {
328         require(minters[msg.sender], "!minter");
329         uint256 finalAmount = amount;
330         _mint(account, finalAmount);
331     }
332 
333     function setGovernance(address _governance) public onlyGovernance {
334         require(msg.sender == governance, "!governance");
335         require(_governance != address(0), "governance can't be address(0)");
336         governance = _governance;
337     }
338 
339     function addMinter(address _minter) public onlyGovernance {
340         require(msg.sender == governance, "!governance");
341         minters[_minter] = true;
342     }
343 
344     function removeMinter(address _minter) public onlyGovernance{
345         require(msg.sender == governance, "!governance");
346         minters[_minter] = false;
347     }
348 }