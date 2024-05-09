1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     
6     function totalSupply() external view returns (uint256);
7 
8     
9     function balanceOf(address account) external view returns (uint256);
10 
11     
12     function transfer(address recipient, uint256 amount) external returns (bool);
13 
14     
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22 
23     
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         
55         
56         
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63 
64         return c;
65     }
66 
67     
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         
78 
79         return c;
80     }
81 
82     
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86 
87     
88     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b != 0, errorMessage);
90         return a % b;
91     }
92 }
93 
94 contract ERC20 is IERC20 {
95     using SafeMath for uint256;
96 
97     mapping (address => uint256) private _balances;
98 
99     mapping (address => mapping (address => uint256)) private _allowances;
100 
101     uint256 private _totalSupply;
102 
103     
104     function totalSupply() public view returns (uint256) {
105         return _totalSupply;
106     }
107 
108     
109     function balanceOf(address account) public view returns (uint256) {
110         return _balances[account];
111     }
112 
113     
114     function transfer(address recipient, uint256 amount) public returns (bool) {
115         _transfer(msg.sender, recipient, amount);
116         return true;
117     }
118 
119     
120     function allowance(address owner, address spender) public view returns (uint256) {
121         return _allowances[owner][spender];
122     }
123 
124     
125     function approve(address spender, uint256 value) public returns (bool) {
126         _approve(msg.sender, spender, value);
127         return true;
128     }
129 
130     
131     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
132         _transfer(sender, recipient, amount);
133         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
134         return true;
135     }
136 
137     
138     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
139         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
140         return true;
141     }
142 
143     
144     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
145         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
146         return true;
147     }
148 
149     
150     function _transfer(address sender, address recipient, uint256 amount) internal {
151         require(sender != address(0), "ERC20: transfer from the zero address");
152         require(recipient != address(0), "ERC20: transfer to the zero address");
153 
154         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
155         _balances[recipient] = _balances[recipient].add(amount);
156         emit Transfer(sender, recipient, amount);
157     }
158 
159     
160     function _mint(address account, uint256 amount) internal {
161         require(account != address(0), "ERC20: mint to the zero address");
162 
163         _totalSupply = _totalSupply.add(amount);
164         _balances[account] = _balances[account].add(amount);
165         emit Transfer(address(0), account, amount);
166     }
167 
168      
169     function _burn(address account, uint256 value) internal {
170         require(account != address(0), "ERC20: burn from the zero address");
171 
172         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
173         _totalSupply = _totalSupply.sub(value);
174         emit Transfer(account, address(0), value);
175     }
176 
177     
178     function _approve(address owner, address spender, uint256 value) internal {
179         require(owner != address(0), "ERC20: approve from the zero address");
180         require(spender != address(0), "ERC20: approve to the zero address");
181 
182         _allowances[owner][spender] = value;
183         emit Approval(owner, spender, value);
184     }
185 
186     
187     function _burnFrom(address account, uint256 amount) internal {
188         _burn(account, amount);
189         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
190     }
191 }
192 
193 contract ERC20Detailed is IERC20 {
194     string private _name;
195     string private _symbol;
196     uint8 private _decimals;
197 
198     
199     constructor (string memory name, string memory symbol, uint8 decimals) public {
200         _name = name;
201         _symbol = symbol;
202         _decimals = decimals;
203     }
204 
205     
206     function name() public view returns (string memory) {
207         return _name;
208     }
209 
210     
211     function symbol() public view returns (string memory) {
212         return _symbol;
213     }
214 
215     
216     function decimals() public view returns (uint8) {
217         return _decimals;
218     }
219 }
220 
221 contract Ownable {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     
227     constructor () internal {
228         _owner = msg.sender;
229         emit OwnershipTransferred(address(0), _owner);
230     }
231 
232     
233     function owner() public view returns (address) {
234         return _owner;
235     }
236 
237     
238     modifier onlyOwner() {
239         require(isOwner(), "Ownable: caller is not the owner");
240         _;
241     }
242 
243     
244     function isOwner() public view returns (bool) {
245         return msg.sender == _owner;
246     }
247 
248     
249     function renounceOwnership() public onlyOwner {
250         emit OwnershipTransferred(_owner, address(0));
251         _owner = address(0);
252     }
253 
254     
255     function transferOwnership(address newOwner) public onlyOwner {
256         _transferOwnership(newOwner);
257     }
258 
259     
260     function _transferOwnership(address newOwner) internal {
261         require(newOwner != address(0), "Ownable: new owner is the zero address");
262         emit OwnershipTransferred(_owner, newOwner);
263         _owner = newOwner;
264     }
265 }
266 
267 contract EBKToken is ERC20, ERC20Detailed, Ownable {
268     uint256 public _freezeTimestamp = 1577836800; 
269     bool public _freezeTokenTransfers = false;
270 
271     
272     constructor (uint256 _totalSupply) public ERC20Detailed("Ebakus", "EBK", 18) {
273         uint256 totalSupply = _totalSupply * (10 ** uint256(decimals()));
274         _mint(msg.sender, totalSupply);
275     }
276 
277     
278     modifier whenNotFreezed() {
279         require(!_freezeTokenTransfers, "Token transfers has been freezed");
280         _;
281     }
282 
283     
284     function freeze() public onlyOwner {
285         require(now >= _freezeTimestamp);
286         _freezeTokenTransfers = true;
287     }
288 
289     function transfer(address to, uint256 value) public whenNotFreezed returns (bool) {
290         return super.transfer(to, value);
291     }
292 
293     function transferFrom(address from, address to, uint256 value) public whenNotFreezed returns (bool) {
294         return super.transferFrom(from, to, value);
295     }
296 
297     function approve(address spender, uint256 value) public whenNotFreezed returns (bool) {
298         return super.approve(spender, value);
299     }
300 
301     function increaseAllowance(address spender, uint256 addedValue) public whenNotFreezed returns (bool) {
302         return super.increaseAllowance(spender, addedValue);
303     }
304 
305     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotFreezed returns (bool) {
306         return super.decreaseAllowance(spender, subtractedValue);
307     }
308 }