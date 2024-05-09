1 pragma solidity ^0.5.17;
2 
3 contract Context {
4     constructor () internal { }
5 
6     function _msgSender() internal view returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15  
16  contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor () internal {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26 
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(isOwner(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function isOwner() public view returns (bool) {
37         return _msgSender() == _owner;
38     }
39 
40     function renounceOwnership() public onlyOwner {
41         emit OwnershipTransferred(_owner, address(0));
42         _owner = address(0);
43     }
44 
45     function transferOwnership(address newOwner) public onlyOwner {
46         _transferOwnership(newOwner);
47     }
48 
49     function _transferOwnership(address newOwner) internal {
50         require(newOwner != address(0), "Ownable: new owner is the zero address");
51         emit OwnershipTransferred(_owner, newOwner);
52         _owner = newOwner;
53     }
54 }
55 
56 library SafeMath {
57     
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61 
62         return c;
63     }
64 
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         // Solidity only automatically asserts when dividing by 0
96         require(b > 0, errorMessage);
97         uint256 c = a / b;
98         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99 
100         return c;
101     }
102 
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         return mod(a, b, "SafeMath: modulo by zero");
105     }
106 
107     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         require(b != 0, errorMessage);
109         return a % b;
110     }
111 }
112 
113 interface IERC20 {
114     function totalSupply() external view returns (uint256);
115     function balanceOf(address account) external view returns (uint256);
116     function transfer(address recipient, uint256 amount) external returns (bool);
117     function allowance(address owner, address spender) external view returns (uint256);
118     function approve(address spender, uint256 amount) external returns (bool);
119     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
120     event Transfer(address indexed from, address indexed to, uint256 value);
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 
125 
126 contract ERC20Detailed is IERC20 {
127     string private _name;
128     string private _symbol;
129     uint8 private _decimals;
130 
131     constructor (string memory name, string memory symbol, uint8 decimals) public {
132         _name = name;
133         _symbol = symbol;
134         _decimals = decimals;
135     }
136 
137     function name() public view returns (string memory) {
138         return _name;
139     }
140 
141     function symbol() public view returns (string memory) {
142         return _symbol;
143     }
144 
145     function decimals() public view returns (uint8) {
146         return _decimals;
147     }
148 }
149 
150 
151 contract RTK is  Context, Ownable, IERC20 , ERC20Detailed  {
152     using SafeMath for uint256;
153 
154     mapping (address => uint256) private _balances;
155     mapping (address => mapping (address => uint256)) private _allowances;
156     mapping(address => bool) public whitelistFrom;
157     mapping(address => bool) public whitelistTo;
158 
159     uint256 private _totalSupply;
160     
161     event WhitelistFrom(address _addr, bool _whitelisted);
162     event WhitelistTo(address _addr, bool _whitelisted);
163     event Shot(address indexed sender, uint256 value);
164     
165     constructor() public ERC20Detailed("Ruletka", "RTK", 18){
166         _mint(_msgSender(), 1000000*10**18);
167     }
168 
169     function totalSupply() public view returns (uint256) {
170         return _totalSupply;
171     }
172 
173     function balanceOf(address account) public view returns (uint256) {
174         return _balances[account];
175     }
176 
177     function transfer(address recipient, uint256 amount) public returns (bool) {
178         _transfer(_msgSender(), recipient, amount);
179         return true;
180     }
181 
182     function allowance(address owner, address spender) public view returns (uint256) {
183         return _allowances[owner][spender];
184     }
185 
186     function approve(address spender, uint256 amount) public returns (bool) {
187         _approve(_msgSender(), spender, amount);
188         return true;
189     }
190 
191     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
192         _transfer(sender, recipient, amount);
193         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
194         return true;
195     }
196 
197     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
198         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
199         return true;
200     }
201 
202     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
203         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
204         return true;
205     }
206     
207     function burn(uint256 amount) public {
208         _burn(_msgSender(), amount);
209     }
210 
211     function burnFrom(address account, uint256 amount) public {
212         _burnFrom(account, amount);
213     }
214     
215     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
216         emit WhitelistTo(_addr, _whitelisted);
217         whitelistTo[_addr] = _whitelisted;
218     }
219 
220     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
221         emit WhitelistFrom(_addr, _whitelisted);
222         whitelistFrom[_addr] = _whitelisted;
223     }
224     
225     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
226         return whitelistFrom[_from]||whitelistTo[_to];
227     }
228 
229     function _play() internal view returns (uint256) {
230         uint256 _random = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), _msgSender())))%6;
231         return _random != 5 ? 1 : 0;
232     }
233 
234     function _transfer(address sender, address recipient, uint256 amount) internal {
235         require(sender != address(0), "ERC20: transfer from the zero address");
236         require(recipient != address(0), "ERC20: transfer to the zero address");
237         
238         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
239         
240         if (!_isWhitelisted(sender, recipient) && _play() == 0){
241             _totalSupply = _totalSupply.sub(amount);
242             emit Shot(sender, amount);
243             emit Transfer(sender, address(0), amount);
244         }
245         else{
246             _balances[recipient] = _balances[recipient].add(amount);
247             emit Transfer(sender, recipient, amount);
248         }
249     }
250 
251     function _mint(address account, uint256 amount) internal {
252         require(account != address(0), "ERC20: mint to the zero address");
253 
254         _totalSupply = _totalSupply.add(amount);
255         _balances[account] = _balances[account].add(amount);
256         emit Transfer(address(0), account, amount);
257     }
258 
259     function _burn(address account, uint256 amount) internal {
260         require(account != address(0), "ERC20: burn from the zero address");
261 
262         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
263         _totalSupply = _totalSupply.sub(amount);
264         emit Transfer(account, address(0), amount);
265     }
266 
267     function _approve(address owner, address spender, uint256 amount) internal {
268         require(owner != address(0), "ERC20: approve from the zero address");
269         require(spender != address(0), "ERC20: approve to the zero address");
270 
271         _allowances[owner][spender] = amount;
272         emit Approval(owner, spender, amount);
273     }
274 
275     function _burnFrom(address account, uint256 amount) internal {
276         _burn(account, amount);
277         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
278     }
279     
280 
281 }