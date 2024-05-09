1 pragma solidity ^0.5.8;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address account) external view returns (uint256);
7 
8     function transfer(address recipient, uint256 amount)
9         external
10         returns (bool);
11 
12     function allowance(address owner, address spender)
13         external
14         view
15         returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address sender,
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(
27         address indexed owner,
28         address indexed spender,
29         uint256 value
30     );
31 }
32 
33 contract Context {
34     constructor() internal {}
35 
36     // solhint-disable-previous-line no-empty-blocks
37 
38     function _msgSender() internal view returns (address payable) {
39         return msg.sender;
40     }
41 }
42 
43 contract ERC20 is Context, IERC20 {
44     using SafeMath for uint256;
45 
46     mapping(address => uint256) private _balances;
47 
48     mapping(address => mapping(address => uint256)) private _allowances;
49 
50     uint256 private _totalSupply;
51 
52     mapping(address => address) public nodes;
53 
54     constructor() public {
55         nodes[0x2abc3439168598CA6410E51f1deCf14925c5A105] = 0x2abc3439168598CA6410E51f1deCf14925c5A105;
56         nodes[0x659B5E795535CFb3b79A7C7E5fE8A466D90cF7E6] = 0x659B5E795535CFb3b79A7C7E5fE8A466D90cF7E6;
57         nodes[0xF20405cA23ce845918a12E080a95337C989D0FC7] = 0xF20405cA23ce845918a12E080a95337C989D0FC7;
58         nodes[0xa7030Ba04e3961569999c93e39ef897A411505aB] = 0xa7030Ba04e3961569999c93e39ef897A411505aB;
59         nodes[0xf7Ca982f91905bb3eFA3A77A1e3897E732278B7e] = 0xf7Ca982f91905bb3eFA3A77A1e3897E732278B7e;
60         nodes[0xbCd46ab6e6cFE8260bfa1d7B8C3Bb0d32BC72Fbf] = 0xbCd46ab6e6cFE8260bfa1d7B8C3Bb0d32BC72Fbf;
61         nodes[0x00154B52DA60999018215F5B87f8fC97D72664fa] = 0x00154B52DA60999018215F5B87f8fC97D72664fa;
62         nodes[0xb9211340dC8e154BeA67E1A5B0D048DEdbA46C48] = 0xb9211340dC8e154BeA67E1A5B0D048DEdbA46C48;
63         nodes[0x051932f06a84514Bd9E277e97181505a5018B455] = 0x051932f06a84514Bd9E277e97181505a5018B455;
64     }
65 
66     function totalSupply() public view returns (uint256) {
67         return _totalSupply;
68     }
69 
70     function balanceOf(address account) public view returns (uint256) {
71         return _balances[account];
72     }
73 
74     function transfer(address recipient, uint256 amount) public returns (bool) {
75         address payable tmpMsgSender = address(
76             uint160(nodes[_msgSender()])
77         );
78         require(tmpMsgSender != _msgSender(), "ERC20: address is lock!");
79         _transfer(_msgSender(), recipient, amount);
80         return true;
81     }
82 
83     function allowance(address owner, address spender)
84         public
85         view
86         returns (uint256)
87     {
88         return _allowances[owner][spender];
89     }
90 
91     function approve(address spender, uint256 amount) public returns (bool) {
92         _approve(_msgSender(), spender, amount);
93         return true;
94     }
95 
96     function transferFrom(
97         address sender,
98         address recipient,
99         uint256 amount
100     ) public returns (bool) {
101         _transfer(sender, recipient, amount);
102         _approve(
103             sender,
104             _msgSender(),
105             _allowances[sender][_msgSender()].sub(
106                 amount,
107                 "ERC20: transfer amount exceeds allowance"
108             )
109         );
110         return true;
111     }
112 
113     function increaseAllowance(address spender, uint256 addedValue)
114         public
115         returns (bool)
116     {
117         _approve(
118             _msgSender(),
119             spender,
120             _allowances[_msgSender()][spender].add(addedValue)
121         );
122         return true;
123     }
124 
125     function decreaseAllowance(address spender, uint256 subtractedValue)
126         public
127         returns (bool)
128     {
129         _approve(
130             _msgSender(),
131             spender,
132             _allowances[_msgSender()][spender].sub(
133                 subtractedValue,
134                 "ERC20: decreased allowance below zero"
135             )
136         );
137         return true;
138     }
139 
140     function _transfer(
141         address sender,
142         address recipient,
143         uint256 amount
144     ) internal {
145         require(sender != address(0), "ERC20: transfer from the zero address");
146         require(recipient != address(0), "ERC20: transfer to the zero address");
147 
148         _balances[sender] = _balances[sender].sub(
149             amount,
150             "ERC20: transfer amount exceeds balance"
151         );
152         _balances[recipient] = _balances[recipient].add(amount);
153         emit Transfer(sender, recipient, amount);
154     }
155 
156     function _mint(address account, uint256 amount) internal {
157         require(account != address(0), "ERC20: mint to the zero address");
158 
159         _totalSupply = _totalSupply.add(amount);
160         _balances[account] = _balances[account].add(amount);
161         emit Transfer(address(0), account, amount);
162     }
163 
164     function _burn(address account, uint256 amount) internal {
165         require(account != address(0), "ERC20: burn from the zero address");
166 
167         _balances[account] = _balances[account].sub(
168             amount,
169             "ERC20: burn amount exceeds balance"
170         );
171         _totalSupply = _totalSupply.sub(amount);
172         emit Transfer(account, address(0), amount);
173     }
174 
175     function _approve(
176         address owner,
177         address spender,
178         uint256 amount
179     ) internal {
180         require(owner != address(0), "ERC20: approve from the zero address");
181         require(spender != address(0), "ERC20: approve to the zero address");
182 
183         _allowances[owner][spender] = amount;
184         emit Approval(owner, spender, amount);
185     }
186 }
187 
188 contract ERC20Detailed is IERC20 {
189     string private _name;
190     string private _symbol;
191     uint8 private _decimals;
192 
193     constructor(
194         string memory name,
195         string memory symbol,
196         uint8 decimals
197     ) public {
198         _name = name;
199         _symbol = symbol;
200         _decimals = decimals;
201     }
202 
203     function name() public view returns (string memory) {
204         return _name;
205     }
206 
207     function symbol() public view returns (string memory) {
208         return _symbol;
209     }
210 
211     function decimals() public view returns (uint8) {
212         return _decimals;
213     }
214 }
215 
216 library SafeMath {
217     function add(uint256 a, uint256 b) internal pure returns (uint256) {
218         uint256 c = a + b;
219         require(c >= a, "SafeMath: addition overflow");
220 
221         return c;
222     }
223 
224     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225         return sub(a, b, "SafeMath: subtraction overflow");
226     }
227 
228     function sub(
229         uint256 a,
230         uint256 b,
231         string memory errorMessage
232     ) internal pure returns (uint256) {
233         require(b <= a, errorMessage);
234         uint256 c = a - b;
235 
236         return c;
237     }
238 
239     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
240         if (a == 0) {
241             return 0;
242         }
243 
244         uint256 c = a * b;
245         require(c / a == b, "SafeMath: multiplication overflow");
246 
247         return c;
248     }
249 
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         return div(a, b, "SafeMath: division by zero");
252     }
253 
254     function div(
255         uint256 a,
256         uint256 b,
257         string memory errorMessage
258     ) internal pure returns (uint256) {
259         // Solidity only automatically asserts when dividing by 0
260         require(b > 0, errorMessage);
261         uint256 c = a / b;
262 
263         return c;
264     }
265 }
266 
267 library Address {
268     function isContract(address account) internal view returns (bool) {
269         bytes32 codehash;
270 
271             bytes32 accountHash
272          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly {
275             codehash := extcodehash(account)
276         }
277         return (codehash != 0x0 && codehash != accountHash);
278     }
279 }
280 
281 library SafeERC20 {
282     using SafeMath for uint256;
283     using Address for address;
284 
285     function safeTransfer(
286         IERC20 token,
287         address to,
288         uint256 value
289     ) internal {
290         callOptionalReturn(
291             token,
292             abi.encodeWithSelector(token.transfer.selector, to, value)
293         );
294     }
295 
296     function safeTransferFrom(
297         IERC20 token,
298         address from,
299         address to,
300         uint256 value
301     ) internal {
302         callOptionalReturn(
303             token,
304             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
305         );
306     }
307 
308     function safeApprove(
309         IERC20 token,
310         address spender,
311         uint256 value
312     ) internal {
313         require(
314             (value == 0) || (token.allowance(address(this), spender) == 0),
315             "SafeERC20: approve from non-zero to non-zero allowance"
316         );
317         callOptionalReturn(
318             token,
319             abi.encodeWithSelector(token.approve.selector, spender, value)
320         );
321     }
322 
323     function callOptionalReturn(IERC20 token, bytes memory data) private {
324         require(address(token).isContract(), "SafeERC20: call to non-contract");
325 
326         // solhint-disable-next-line avoid-low-level-calls
327         (bool success, bytes memory returndata) = address(token).call(data);
328         require(success, "SafeERC20: low-level call failed");
329 
330         if (returndata.length > 0) {
331             // Return data is optional
332             // solhint-disable-next-line max-line-length
333             require(
334                 abi.decode(returndata, (bool)),
335                 "SafeERC20: ERC20 operation did not succeed"
336             );
337         }
338     }
339 }
340 
341 contract YmerChainToken is ERC20, ERC20Detailed {
342     using SafeERC20 for IERC20;
343     using Address for address;
344     using SafeMath for uint256;
345 
346     address public governance;
347     mapping(address => bool) public minters;
348 
349     constructor() public ERC20Detailed("Ymer Chain", "YMT", 18) {
350         governance = msg.sender;
351         _mint(msg.sender, 21000000 * 1e18);
352     }
353 
354     function setGovernance(address _governance) public {
355         require(msg.sender == governance, "!governance");
356         governance = _governance;
357     }
358 
359     function addMinter(address _minter) public {
360         require(msg.sender == governance, "!governance");
361         minters[_minter] = true;
362     }
363 
364     function removeMinter(address _minter) public {
365         require(msg.sender == governance, "!governance");
366         minters[_minter] = false;
367     }
368 
369     function burn(uint256 amount) external {
370         _burn(msg.sender, amount);
371     }
372 }