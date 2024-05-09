1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.2;
3 
4 library EnumerableSet {
5     struct Set {
6         bytes32[] _values;
7         mapping (bytes32 => uint256) _indexes;
8     }
9 
10     function _add(Set storage set, bytes32 value) private returns (bool) {
11         if (!_contains(set, value)) {
12             set._values.push(value);
13             set._indexes[value] = set._values.length;
14             return true;
15         } else {
16             return false;
17         }
18     }
19 
20     function _remove(Set storage set, bytes32 value) private returns (bool) {
21         uint256 valueIndex = set._indexes[value];
22 
23         if (valueIndex != 0) {
24             uint256 toDeleteIndex = valueIndex - 1;
25             uint256 lastIndex = set._values.length - 1;
26 
27             bytes32 lastvalue = set._values[lastIndex];
28 
29             set._values[toDeleteIndex] = lastvalue;
30             set._indexes[lastvalue] = toDeleteIndex + 1;
31             set._values.pop();
32 
33             delete set._indexes[value];
34 
35             return true;
36         } else {
37             return false;
38         }
39     }
40 
41     function _contains(Set storage set, bytes32 value) private view returns (bool) {
42         return set._indexes[value] != 0;
43     }
44 
45     function _length(Set storage set) private view returns (uint256) {
46         return set._values.length;
47     }
48 
49     function _at(Set storage set, uint256 index) private view returns (bytes32) {
50         require(set._values.length > index, "EnumerableSet: index out of bounds");
51         return set._values[index];
52     }
53 
54     struct AddressSet {
55         Set _inner;
56     }
57 
58     function add(AddressSet storage set, address value) internal returns (bool) {
59         return _add(set._inner, bytes32(uint256(value)));
60     }
61 
62     function remove(AddressSet storage set, address value) internal returns (bool) {
63         return _remove(set._inner, bytes32(uint256(value)));
64     }
65 
66     function contains(AddressSet storage set, address value) internal view returns (bool) {
67         return _contains(set._inner, bytes32(uint256(value)));
68     }
69 
70     function length(AddressSet storage set) internal view returns (uint256) {
71         return _length(set._inner);
72     }
73 
74     function at(AddressSet storage set, uint256 index) internal view returns (address) {
75         return address(uint256(_at(set._inner, index)));
76     }
77 
78     struct UintSet {
79         Set _inner;
80     }
81 
82     function add(UintSet storage set, uint256 value) internal returns (bool) {
83         return _add(set._inner, bytes32(value));
84     }
85 
86     function remove(UintSet storage set, uint256 value) internal returns (bool) {
87         return _remove(set._inner, bytes32(value));
88     }
89 
90     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
91         return _contains(set._inner, bytes32(value));
92     }
93 
94     function length(UintSet storage set) internal view returns (uint256) {
95         return _length(set._inner);
96     }
97 
98     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
99         return uint256(_at(set._inner, index));
100     }
101 }
102 
103 library Address {
104     function isContract(address account) internal view returns (bool) {
105         uint256 size;
106         assembly { size := extcodesize(account) }
107         return size > 0;
108     }
109 
110     function sendValue(address payable recipient, uint256 amount) internal {
111         require(address(this).balance >= amount, "Address: insufficient balance");
112 
113         (bool success, ) = recipient.call{ value: amount }("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
118       return functionCall(target, data, "Address: low-level call failed");
119     }
120 
121     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
122         return _functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         return _functionCallWithValue(target, data, value, errorMessage);
132     }
133 
134     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135         require(isContract(target), "Address: call to non-contract");
136 
137         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
138         if (success) {
139             return returndata;
140         } else {
141             if (returndata.length > 0) {
142                 assembly {
143                     let returndata_size := mload(returndata)
144                     revert(add(32, returndata), returndata_size)
145                 }
146             } else {
147                 revert(errorMessage);
148             }
149         }
150     }
151 }
152 
153 abstract contract Context {
154     function _msgSender() internal view virtual returns (address payable) {
155         return msg.sender;
156     }
157 
158     function _msgData() internal view virtual returns (bytes memory) {
159         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
160         return msg.data;
161     }
162 }
163 
164 library SafeMath {
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         uint256 c = a + b;
167         require(c >= a, "SafeMath: addition overflow");
168 
169         return c;
170     }
171 
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return sub(a, b, "SafeMath: subtraction overflow");
174     }
175 
176     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184 
185         if (a == 0) {
186             return 0;
187         }
188 
189         uint256 c = a * b;
190         require(c / a == b, "SafeMath: multiplication overflow");
191 
192         return c;
193     }
194 
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198 
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         return mod(a, b, "SafeMath: modulo by zero");
209     }
210 
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b != 0, errorMessage);
213         return a % b;
214     }
215 }
216 
217 contract Ownable is Context {
218     address private _owner;
219 
220     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221 
222     constructor () internal {
223         address msgSender = _msgSender();
224         _owner = msgSender;
225         emit OwnershipTransferred(address(0), msgSender);
226     }
227 
228     function owner() public view returns (address) {
229         return _owner;
230     }
231 
232     modifier onlyOwner() {
233         require(_owner == _msgSender(), "Ownable: caller is not the owner");
234         _;
235     }
236 
237     function renounceOwnership() internal virtual onlyOwner {
238         emit OwnershipTransferred(_owner, address(0));
239         _owner = address(0);
240     }
241 
242     function transferOwnership(address newOwner) public virtual onlyOwner {
243         require(newOwner != address(0), "Ownable: new owner is the zero address");
244         emit OwnershipTransferred(_owner, newOwner);
245         _owner = newOwner;
246     }
247 }
248 
249 interface IERC20 {
250     function totalSupply() external view returns (uint256);
251     function balanceOf(address account) external view returns (uint256);
252     function transfer(address recipient, uint256 amount) external returns (bool);
253     function approve(address spender, uint256 amount) external returns (bool);
254     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
255 
256     event Transfer(address indexed from, address indexed to, uint256 value);
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 contract ERC20 is Context, IERC20 {
261     using SafeMath for uint256;
262     using Address for address;
263 
264     mapping (address => uint256) private _balances;
265 
266     uint256 private _totalSupply;
267     string private _name;
268     string private _symbol;
269     uint8 private _decimals;
270 
271     constructor (string memory name, string memory symbol) public {
272         _name = name;
273         _symbol = symbol;
274         _decimals = 18;
275     }
276 
277     function name() public view returns (string memory) {
278         return _name;
279     }
280 
281     function symbol() public view returns (string memory) {
282         return _symbol;
283     }
284 
285     function decimals() public view returns (uint8) {
286         return _decimals;
287     }
288 
289     function totalSupply() public view override returns (uint256) {
290         return _totalSupply;
291     }
292 
293     function balanceOf(address account) public view override returns (uint256) {
294         return _balances[account];
295     }
296 
297     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
298         _transfer(_msgSender(), recipient, amount);
299         return true;
300     }
301 
302     function approve(address spender, uint256 amount) public virtual override returns (bool) {
303         _approve(_msgSender(), spender, amount);
304         return true;
305     }
306 
307     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
308         _transfer(sender, recipient, amount);
309         return true;
310     }
311 
312     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
313         require(sender != address(0), "ERC20: transfer from the zero address");
314         require(recipient != address(0), "ERC20: transfer to the zero address");
315 
316         _beforeTokenTransfer(sender, recipient, amount);
317 
318         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
319         _balances[recipient] = _balances[recipient].add(amount);
320         emit Transfer(sender, recipient, amount);
321     }
322 
323     function _mint(address account, uint256 amount) internal virtual {
324         require(account != address(0), "ERC20: mint to the zero address");
325 
326         _beforeTokenTransfer(address(0), account, amount);
327 
328         _totalSupply = _totalSupply.add(amount);
329         _balances[account] = _balances[account].add(amount);
330         emit Transfer(address(0), account, amount);
331     }
332 
333     function _burn(address account, uint256 amount) internal virtual {
334         require(account != address(0), "ERC20: burn from the zero address");
335 
336         _beforeTokenTransfer(account, address(0), amount);
337 
338         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
339         _totalSupply = _totalSupply.sub(amount);
340         emit Transfer(account, address(0), amount);
341     }
342 
343     function _approve(address owner, address spender, uint256 amount) internal virtual {
344         require(owner != address(0), "ERC20: approve from the zero address");
345         require(spender != address(0), "ERC20: approve to the zero address");
346 
347         emit Approval(owner, spender, amount);
348     }
349 
350     function _setupDecimals(uint8 decimals_) internal {
351         _decimals = decimals_;
352     }
353 
354     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
355 }
356 
357 contract Lockable is Context {
358     event Locked(address account);
359     event Unlocked(address account);
360 
361     mapping(address => bool) private _locked;
362 
363     function locked(address _to) internal view returns (bool) {
364         return _locked[_to];
365     }
366 
367     function _lock(address to) internal virtual {
368         require(to != address(0), "ERC20: lock to the zero address");
369 
370         _locked[to] = true;
371         emit Locked(to);
372     }
373 
374 
375     function _unlock(address to) internal virtual {
376         require(to != address(0), "ERC20: lock to the zero address");
377 
378         _locked[to] = false;
379         emit Unlocked(to);
380     }
381 }
382 
383 contract ERC20PresetMinterPauser is Context, ERC20, Lockable, Ownable {
384 
385     constructor(string memory name, string memory symbol) internal ERC20(name, symbol) {
386     }
387 
388     function mint(address to, uint256 amount) internal virtual onlyOwner {
389         _mint(to, amount);
390     }
391 
392     function lock(address to) public virtual onlyOwner {
393         _lock(to);
394     }
395 
396     function unlock(address to) public virtual onlyOwner {
397         _unlock(to);
398     }
399 
400     function burn(uint256 amount) public virtual onlyOwner {
401         _burn(_msgSender(), amount*(10**uint256(decimals())));
402     }
403 }
404 
405 contract CreateToken is ERC20PresetMinterPauser {
406     constructor ()
407         ERC20PresetMinterPauser("BLS", "BLS")
408         public
409     {
410         mint(msg.sender, 9000*(10**8)*(10**uint256(decimals())));
411     }
412 }