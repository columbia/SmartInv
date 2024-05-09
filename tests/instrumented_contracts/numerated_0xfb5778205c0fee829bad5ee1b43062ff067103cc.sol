1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18 
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26 
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40 
41 
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45 
46 
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b > 0, errorMessage);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55 
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         return mod(a, b, "SafeMath: modulo by zero");
58     }
59 
60 
61     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b != 0, errorMessage);
63         return a % b;
64     }
65 }
66 
67 
68 library Address {
69 
70     function isContract(address account) internal view returns (bool) {
71         bytes32 codehash;
72         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
73         // solhint-disable-next-line no-inline-assembly
74         assembly { codehash := extcodehash(account) }
75         return (codehash != accountHash && codehash != 0x0);
76     }
77 
78 
79     function sendValue(address payable recipient, uint256 amount) internal {
80         require(address(this).balance >= amount, "Address: insufficient balance");
81 
82         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
83         (bool success, ) = recipient.call{ value: amount }("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87 
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89       return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92 
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97 
98     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
100     }
101 
102 
103     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
104         require(address(this).balance >= value, "Address: insufficient balance for call");
105         return _functionCallWithValue(target, data, value, errorMessage);
106     }
107 
108     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
109         require(isContract(target), "Address: call to non-contract");
110 
111         // solhint-disable-next-line avoid-low-level-calls
112         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
113         if (success) {
114             return returndata;
115         } else {
116             // Look for revert reason and bubble it up if present
117             if (returndata.length > 0) {
118                 // The easiest way to bubble the revert reason is using memory via assembly
119 
120                 // solhint-disable-next-line no-inline-assembly
121                 assembly {
122                     let returndata_size := mload(returndata)
123                     revert(add(32, returndata), returndata_size)
124                 }
125             } else {
126                 revert(errorMessage);
127             }
128         }
129     }
130 }
131 
132 library SafeERC20 {
133     using SafeMath for uint256;
134     using Address for address;
135 
136     function safeTransfer(IERC20 token, address to, uint256 value) internal {
137         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
138     }
139 
140     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
141         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
142     }
143 
144 
145     function safeApprove(IERC20 token, address spender, uint256 value) internal {
146         // safeApprove should only be called when setting an initial allowance,
147         // or when resetting it to zero. To increase and decrease it, use
148         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
149         // solhint-disable-next-line max-line-length
150         require((value == 0) || (token.allowance(address(this), spender) == 0),
151             "SafeERC20: approve from non-zero to non-zero allowance"
152         );
153         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
154     }
155 
156     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
157         uint256 newAllowance = token.allowance(address(this), spender).add(value);
158         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
159     }
160 
161     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
162         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
163         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
164     }
165 
166 
167     function _callOptionalReturn(IERC20 token, bytes memory data) private {
168         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
169         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
170         // the target address contains contract code and also asserts for success in the low-level call.
171 
172         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
173         if (returndata.length > 0) { // Return data is optional
174             // solhint-disable-next-line max-line-length
175             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
176         }
177     }
178 }
179 
180 
181 interface IERC20 {
182 
183     function totalSupply() external view returns (uint256);
184 
185     function balanceOf(address account) external view returns (uint256);
186 
187     function transfer(address recipient, uint256 amount) external returns (bool);
188 
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     function approve(address spender, uint256 amount) external returns (bool);
192 
193     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
194 
195     function decimals() external view returns (uint8);
196 
197     event Transfer(address indexed from, address indexed to, uint256 value);
198 
199     event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 
203 
204 contract Ownable {
205     address private _owner;
206 
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209     constructor () internal {
210         _owner = 0x34cDFD77C01Fa95CeAA277c2D309035ca6CB551e;
211         emit OwnershipTransferred(address(0), _owner);
212     }
213 
214     function owner() public view returns (address) {
215         return _owner;
216     }
217 
218 
219     modifier onlyOwner() {
220         require(_owner == msg.sender, "Ownable: caller is not the owner");
221         _;
222     }
223 
224 
225     function transferOwnership(address newOwner) public virtual onlyOwner {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         emit OwnershipTransferred(_owner, newOwner);
228         _owner = newOwner;
229     }
230 }
231 
232 
233 contract UFP is IERC20, Ownable {
234     using SafeMath for uint256;
235     using SafeERC20 for IERC20;
236     using Address for address;
237 
238     mapping (address => uint256) private _balances;
239 
240     mapping (address => mapping (address => uint256)) private _allowances;
241 
242     uint256 private _totalSupply;
243 
244     string private _name;
245     string private _symbol;
246     uint8 private _decimals;
247 
248     constructor () public {
249         _decimals = 18;
250         _totalSupply = 40000000 * uint(10) ** _decimals;
251         _name = "Unichain Finance Protocol";
252         _symbol = "UFP";
253         _balances[0x34cDFD77C01Fa95CeAA277c2D309035ca6CB551e] = _totalSupply;
254         emit Transfer(address(0), 0x34cDFD77C01Fa95CeAA277c2D309035ca6CB551e, _totalSupply);
255     }
256 
257 
258     function name() public view returns (string memory) {
259         return _name;
260     }
261 
262 
263     function symbol() public view returns (string memory) {
264         return _symbol;
265     }
266 
267 
268     function decimals() public view override returns (uint8) {
269         return _decimals;
270     }
271 
272 
273     function totalSupply() public view override returns (uint256) {
274         return _totalSupply;
275     }
276 
277 
278     function balanceOf(address account) public view override returns (uint256) {
279         return _balances[account];
280     }
281 
282 
283     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
284         _transfer(msg.sender, recipient, amount);
285         return true;
286     }
287 
288 
289     function allowance(address owner, address spender) public view virtual override returns (uint256) {
290         return _allowances[owner][spender];
291     }
292 
293 
294     function approve(address spender, uint256 amount) public virtual override returns (bool) {
295         _approve(msg.sender, spender, amount);
296         return true;
297     }
298 
299 
300     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
301         _transfer(sender, recipient, amount);
302         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
303         return true;
304     }
305 
306 
307     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
308         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
309         return true;
310     }
311 
312 
313     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
314         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
315         return true;
316     }
317 
318 
319     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
323         _balances[recipient] = _balances[recipient].add(amount);
324         emit Transfer(sender, recipient, amount);
325     }
326 
327 
328     function _approve(address owner, address spender, uint256 amount) internal virtual {
329         require(owner != address(0), "ERC20: approve from the zero address");
330         require(spender != address(0), "ERC20: approve to the zero address");
331 
332         _allowances[owner][spender] = amount;
333         emit Approval(owner, spender, amount);
334     }
335 
336 
337 }