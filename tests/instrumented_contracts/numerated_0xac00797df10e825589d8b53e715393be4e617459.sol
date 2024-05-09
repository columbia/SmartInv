1 pragma solidity ^0.6.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this;
10         return msg.data;
11     }
12 }
13 
14 
15 pragma solidity ^0.6.0;
16 
17 interface IERC20 {
18     
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 
37 pragma solidity ^0.6.0;
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 
85 
86 pragma solidity ^0.6.2;
87 
88 library Address {
89     function isContract(address account) internal view returns (bool) {
90         bytes32 codehash;
91         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
92         assembly { codehash := extcodehash(account) }
93         return (codehash != accountHash && codehash != 0x0);
94     }
95 
96     function sendValue(address payable recipient, uint256 amount) internal {
97         (bool success, ) = recipient.call{ value: amount }("");
98         require(success, "Address: unable to send value, recipient may have reverted");
99     }
100 
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102       return functionCall(target, data, "Address: low-level call failed");
103     }
104 
105    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
106         return _functionCallWithValue(target, data, 0, errorMessage);
107     }
108 
109     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
111     }
112 
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         return _functionCallWithValue(target, data, value, errorMessage);
116     }
117 
118     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
119         require(isContract(target), "Address: call to non-contract");
120         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
121         if (success) {
122             return returndata;
123         } else {
124             if (returndata.length > 0) {
125                 assembly {
126                     let returndata_size := mload(returndata)
127                     revert(add(32, returndata), returndata_size)
128                 }
129             } else {
130                 revert(errorMessage);
131             }
132         }
133     }
134 }
135 
136 
137 pragma solidity ^0.6.0;
138 
139 contract ERC20 is Context, IERC20 {
140     using SafeMath for uint256;
141     using Address for address;
142 
143     mapping (address => uint256) private _balances;
144 
145     mapping (address => mapping (address => uint256)) private _allowances;
146 
147     uint256 private _totalSupply;
148     uint256 private _fisrtSupply = 100000 * 10**18;
149 
150     string private _name;
151     string private _symbol;
152     uint8 private _decimals;
153 
154     constructor (string memory name, string memory symbol) public {
155         _name = name;
156         _symbol = symbol;
157         _decimals = 18;
158 		
159 		_firstGenerate(msg.sender, _fisrtSupply);
160     }
161 
162    function name() public view returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public view returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public view returns (uint8) {
171         return _decimals;
172     }
173 
174    function totalSupply() public view override returns (uint256) {
175         return _totalSupply;
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return _balances[account];
180     }
181 
182     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187    function allowance(address owner, address spender) public view virtual override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191    function approve(address spender, uint256 amount) public virtual override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
203         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
204         return true;
205     }
206 
207     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
208         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
209         return true;
210     }
211 
212    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
213         require(sender != address(0), "ERC20: transfer from the zero address");
214         require(recipient != address(0), "ERC20: transfer to the zero address");
215 
216         _beforeTokenTransfer(sender, recipient, amount);
217 
218         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
219         _balances[recipient] = _balances[recipient].add(amount);
220         emit Transfer(sender, recipient, amount);
221     }
222 
223     function _firstGenerate(address account, uint256 amount) internal virtual {
224         require(account != address(0), "ERC20: generate to the zero address");
225 
226         _beforeTokenTransfer(address(0), account, amount);
227 
228         _totalSupply = _totalSupply.add(amount);
229         _balances[account] = _balances[account].add(amount);
230         emit Transfer(address(0), account, amount);
231     }
232 
233     function _burn(address account, uint256 amount) internal virtual {
234         require(account != address(0), "ERC20: burn from the zero address");
235 
236         _beforeTokenTransfer(account, address(0), amount);
237 
238         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
239         _totalSupply = _totalSupply.sub(amount);
240         emit Transfer(account, address(0), amount);
241     }
242 
243    function _approve(address owner, address spender, uint256 amount) internal virtual {
244         require(owner != address(0), "ERC20: approve from the zero address");
245         require(spender != address(0), "ERC20: approve to the zero address");
246 
247         _allowances[owner][spender] = amount;
248         emit Approval(owner, spender, amount);
249     }
250 
251     function _setupDecimals(uint8 decimals_) internal {
252         _decimals = decimals_;
253     }
254 
255    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
256 }
257 
258 
259 pragma solidity ^0.6.0;
260 
261 contract Ownable is Context {
262     address private _owner;
263 
264     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
265 
266     constructor () internal {
267         address msgSender = _msgSender();
268         _owner = msgSender;
269         emit OwnershipTransferred(address(0), msgSender);
270     }
271 
272     function owner() public view returns (address) {
273         return _owner;
274     }
275 
276     modifier onlyOwner() {
277         require(_owner == _msgSender(), "Ownable: caller is not the owner");
278         _;
279     }
280 
281     function renounceOwnership() public virtual onlyOwner {
282         emit OwnershipTransferred(_owner, address(0));
283         _owner = address(0);
284     }
285 
286    function transferOwnership(address newOwner) public virtual onlyOwner {
287         require(newOwner != address(0), "Ownable: new owner is the zero address");
288         emit OwnershipTransferred(_owner, newOwner);
289         _owner = newOwner;
290     }
291 }
292 
293 
294 pragma solidity ^0.6.2;
295 
296 contract BUBBLE is ERC20("BUBBLE", "BBL"), Ownable {
297     using SafeMath for uint256;
298 	
299 	uint256 private _divRate = 10000;
300 	uint256 private BurnRate = 0;
301 	
302     function setBurnRate(uint256 _BurnRate) external onlyOwner {
303 		BurnRate = _BurnRate;
304 	} 
305 	
306 	function getBurnRate() public view returns(uint256) {
307 		return BurnRate;
308 	} 
309 
310     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
311         uint256 burnAmount = amount.mul(BurnRate);
312         burnAmount = burnAmount.div(_divRate);
313 		burn(msg.sender, burnAmount);
314         return super.transfer(recipient, amount.sub(burnAmount));
315     }
316 
317     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
318         uint256 burnAmount = amount.mul(BurnRate);
319         burnAmount = burnAmount.div(_divRate);
320 		burn(sender, burnAmount);
321         return super.transferFrom(sender, recipient, amount.sub(burnAmount));
322     }
323 	
324 	function burn(address account, uint256 amount) private {
325         _burn(account, amount);
326     }
327 }