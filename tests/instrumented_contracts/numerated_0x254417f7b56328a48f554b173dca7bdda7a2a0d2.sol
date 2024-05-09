1 pragma solidity 0.6.12;
2 
3 // Baby Simba is born. His entire family takes care of him affectionately. However, after a while, he will face the realities of the wild nature of Savannah. As he grows up, he will attract the attention of his enemies. He will make new friends and his family will grow with you. His testosterone level will increase, his muscles will grow stronger and he will have a bushy mane. He will fight rival clans and everyone on the road to the kingdom.
4 
5 contract Context {
6  
7     constructor() internal {}
8 
9     function _msgSender() internal view returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 
20 contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26     constructor() internal {
27         address msgSender = _msgSender();
28         _owner = msgSender;
29         emit OwnershipTransferred(address(0), msgSender);
30     }
31 
32 
33     function owner() public view returns (address) {
34         return _owner;
35     }
36 
37 
38     modifier onlyOwner() {
39         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
40         _;
41     }
42 
43 
44     function renounceOwnership() public onlyOwner {
45         emit OwnershipTransferred(_owner, address(0));
46         _owner = address(0);
47     }
48 
49 
50     function transferOwnership(address newOwner) public onlyOwner {
51         _transferOwnership(newOwner);
52     }
53 
54 
55     function _transferOwnership(address newOwner) internal {
56         require(newOwner != address(0), 'Ownable: new owner is the zero address');
57         emit OwnershipTransferred(_owner, newOwner);
58         _owner = newOwner;
59     }
60 }
61 
62 
63 library SafeMath {
64 
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, 'SafeMath: addition overflow');
68 
69         return c;
70     }
71 
72 
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, 'SafeMath: subtraction overflow');
75     }
76 
77 
78     function sub(
79         uint256 a,
80         uint256 b,
81         string memory errorMessage
82     ) internal pure returns (uint256) {
83         require(b <= a, errorMessage);
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89 
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b, 'SafeMath: multiplication overflow');
100 
101         return c;
102     }
103 
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, 'SafeMath: division by zero');
107     }
108 
109 
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122 
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, 'SafeMath: modulo by zero');
125     }
126 
127 
128     function mod(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         require(b != 0, errorMessage);
134         return a % b;
135     }
136 
137     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
138         z = x < y ? x : y;
139     }
140 
141     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
142     function sqrt(uint256 y) internal pure returns (uint256 z) {
143         if (y > 3) {
144             z = y;
145             uint256 x = y / 2 + 1;
146             while (x < z) {
147                 z = x;
148                 x = (y / x + x) / 2;
149             }
150         } else if (y != 0) {
151             z = 1;
152         }
153     }
154 }
155 
156 library Address {
157 
158     function isContract(address account) internal view returns (bool) {
159         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
160         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
161         // for accounts without code, i.e. `keccak256('')`
162         bytes32 codehash;
163         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
164         // solhint-disable-next-line no-inline-assembly
165         assembly {
166             codehash := extcodehash(account)
167         }
168         return (codehash != accountHash && codehash != 0x0);
169     }
170 
171 
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, 'Address: insufficient balance');
174 
175         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
176         (bool success, ) = recipient.call{value: amount}('');
177         require(success, 'Address: unable to send value, recipient may have reverted');
178     }
179 
180 
181     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionCall(target, data, 'Address: low-level call failed');
183     }
184 
185 
186     function functionCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         return _functionCallWithValue(target, data, 0, errorMessage);
192     }
193 
194 
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
201     }
202 
203 
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(address(this).balance >= value, 'Address: insufficient balance for call');
211         return _functionCallWithValue(target, data, value, errorMessage);
212     }
213 
214     function _functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 weiValue,
218         string memory errorMessage
219     ) private returns (bytes memory) {
220         require(isContract(target), 'Address: call to non-contract');
221 
222         // solhint-disable-next-line avoid-low-level-calls
223         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
224         if (success) {
225             return returndata;
226         } else {
227             // Look for revert reason and bubble it up if present
228             if (returndata.length > 0) {
229                 // The easiest way to bubble the revert reason is using memory via assembly
230 
231                 // solhint-disable-next-line no-inline-assembly
232                 assembly {
233                     let returndata_size := mload(returndata)
234                     revert(add(32, returndata), returndata_size)
235                 }
236             } else {
237                 revert(errorMessage);
238             }
239         }
240     }
241 }
242 
243 
244 interface IERC20 {
245 
246     function totalSupply() external view returns (uint256);
247 
248  
249     function balanceOf(address account) external view returns (uint256);
250 
251 
252     function transfer(address recipient, uint256 amount) external returns (bool);
253 
254 
255     function allowance(address owner, address spender) external view returns (uint256);
256 
257 
258     function approve(address spender, uint256 amount) external returns (bool);
259 
260 
261     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
262 
263 
264     event Transfer(address indexed from, address indexed to, uint256 value);
265 
266 
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 }
269 
270  
271 contract ERC20 is Context, IERC20 {
272     using SafeMath for uint256;
273     using Address for address;
274 
275     mapping (address => uint256) private _balances;
276 
277     mapping (address => mapping (address => uint256)) private _allowances;
278 
279     uint256 private _totalSupply;
280 
281     string private _name;
282     string private _symbol;
283     uint8 private _decimals;
284 
285 
286     constructor(string memory name, string memory symbol, uint256 totalSupply) public {
287         _name = name;
288         _symbol = symbol;
289         _decimals = 18;
290         _totalSupply = _totalSupply.add(totalSupply);
291         _balances[msg.sender] = _balances[msg.sender].add(totalSupply);
292     }
293 
294 
295     function name() public view returns (string memory) {
296         return _name;
297     }
298 
299 
300     function symbol() public view returns (string memory) {
301         return _symbol;
302     }
303 
304 
305     function decimals() public view returns (uint8) {
306         return _decimals;
307     }
308 
309  
310     function totalSupply() public view override returns (uint256) {
311         return _totalSupply;
312     }
313 
314 
315     function balanceOf(address account) public view override returns (uint256) {
316         return _balances[account];
317     }
318 
319 
320     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325 
326     function allowance(address owner, address spender) public view virtual override returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330 
331     function approve(address spender, uint256 amount) public virtual override returns (bool) {
332         _approve(_msgSender(), spender, amount);
333         return true;
334     }
335 
336 
337     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
338         _transfer(sender, recipient, amount);
339         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
340         return true;
341     }
342 
343 
344     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
345         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
346         return true;
347     }
348 
349 
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
352         return true;
353     }
354 
355 
356     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
357         require(sender != address(0), "ERC20: transfer from the zero address");
358         require(recipient != address(0), "ERC20: transfer to the zero address");
359 
360         _beforeTokenTransfer(sender, recipient, amount);
361 
362         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
363         _balances[recipient] = _balances[recipient].add(amount);
364         emit Transfer(sender, recipient, amount);
365     }
366 
367 
368     function _burn(address account, uint256 amount) internal virtual {
369         require(account != address(0), "ERC20: burn from the zero address");
370 
371         _beforeTokenTransfer(account, address(0), amount);
372 
373         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
374         _totalSupply = _totalSupply.sub(amount);
375         emit Transfer(account, address(0), amount);
376     }
377 
378 
379     function _approve(address owner, address spender, uint256 amount) internal virtual {
380         require(owner != address(0), "ERC20: approve from the zero address");
381         require(spender != address(0), "ERC20: approve to the zero address");
382 
383         _allowances[owner][spender] = amount;
384         emit Approval(owner, spender, amount);
385     }
386 
387 
388     function _setupDecimals(uint8 decimals_) internal {
389         _decimals = decimals_;
390     }
391 
392 
393     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
394 }
395 
396 
397 contract SimbaToken is ERC20('SimbaToken', 'SIMBA', 1000000000000000e18), Ownable {
398     
399     function burn(uint amount) public {
400         require(amount > 0);
401         require(balanceOf(msg.sender) >= amount);
402         _burn(msg.sender, amount);
403     }
404 }