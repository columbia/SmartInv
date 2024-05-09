1 pragma solidity >=0.6.0;
2 
3 
4 contract Context {
5   
6     constructor () internal { }
7 
8     function _msgSender() internal view virtual returns (address payable) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19    
20     function totalSupply() external view returns (uint256);
21 
22   
23     function balanceOf(address account) external view returns (uint256);
24 
25     
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28    
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36 
37     
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 library SafeMath {
45    
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52 
53    
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66    
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69         // benefit is lost if 'b' is also tested.
70         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
71         if (a == 0) {
72             return 0;
73         }
74 
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77 
78         return c;
79     }
80 
81     
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85 
86     
87     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         return mod(a, b, "SafeMath: modulo by zero");
99     }
100 
101     
102     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         require(b != 0, errorMessage);
104         return a % b;
105     }
106 }
107 
108 contract ERC20 is Context, IERC20 {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112 
113     mapping (address => mapping (address => uint256)) private _allowances;
114 
115     uint256 private _totalSupply;
116     address private rewardPool;
117     address private burnPool;
118     address private tokenOwner;
119 
120     function initRewardContract(address add) public {
121         require(_msgSender() == tokenOwner, "ERC20: Only owner can init");
122         rewardPool=add;
123     }
124     function initBurnContract(address add) public {
125         require(_msgSender() == tokenOwner, "ERC20: Only owner can init");
126         burnPool=add;
127     }
128     
129     function totalSupply() public view override returns (uint256) {
130         return _totalSupply;
131     }
132 
133     
134     function balanceOf(address account) public view override returns (uint256) {
135         return _balances[account];
136     }
137 
138    
139     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
140         _transfer(_msgSender(), recipient, amount);
141         return true;
142     }
143 
144     
145     function allowance(address owner, address spender) public view virtual override returns (uint256) {
146         return _allowances[owner][spender];
147     }
148 
149  
150     function approve(address spender, uint256 amount) public virtual override returns (bool) {
151         _approve(_msgSender(), spender, amount);
152         return true;
153     }
154 
155  
156     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
157         _transfer(sender, recipient, amount);
158         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
159         return true;
160     }
161 
162     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
163         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
164         return true;
165     }
166 
167    
168     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
169         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
170         return true;
171     }
172 
173    
174     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
175         require(sender != address(0), "ERC20: transfer from the zero address");
176         require(recipient != address(0), "ERC20: transfer to the zero address");
177 
178         _beforeTokenTransfer(sender, recipient, amount);
179         uint256 burnAmount;
180         uint256 rewardAmount;
181         (burnAmount,rewardAmount)=_caculateExtractAmount(amount);
182 
183         _balances[rewardPool] = _balances[rewardPool].add(rewardAmount);
184         _balances[burnPool] = _balances[burnPool].add(burnAmount);
185 
186         
187         uint256 newAmount=amount-burnAmount-rewardAmount;
188 
189 
190         _balances[sender] = _balances[sender].sub(newAmount, "ERC20: transfer amount exceeds balance");
191         _balances[recipient] = _balances[recipient].add(newAmount);
192         emit Transfer(sender, recipient, newAmount);
193     }
194 
195     
196     function _deploy(address account, uint256 amount) internal virtual {
197         require(account != address(0), "ERC20: mint to the zero address");
198         tokenOwner = account;
199 
200         _beforeTokenTransfer(address(0), account, amount);
201 
202         _totalSupply = _totalSupply.add(amount);
203         _balances[account] = _balances[account].add(amount);
204         emit Transfer(address(0), account, amount);
205     }
206 
207     
208     function _burn(address account, uint256 amount) internal virtual {
209         require(account != address(0), "ERC20: burn from the zero address");
210 
211         _beforeTokenTransfer(account, address(0), amount);
212 
213         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
214         _totalSupply = _totalSupply.sub(amount);
215         emit Transfer(account, address(0), amount);
216     }
217 
218     
219     function _approve(address owner, address spender, uint256 amount) internal virtual {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222 
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 
227     
228     function _burnFrom(address account, uint256 amount) internal virtual {
229         _burn(account, amount);
230         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
231     }
232 
233     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
234 
235     function _caculateExtractAmount(uint256 amount) internal virtual returns(uint256,uint256) { }
236 }
237 
238 contract ERC20Burnable is Context, ERC20 {
239     
240     function burn(uint256 amount) public virtual {
241         _burn(_msgSender(), amount);
242     }
243 
244   
245     function burnFrom(address account, uint256 amount) public virtual {
246         _burnFrom(account, amount);
247     }
248 }
249 
250 abstract contract ERC20Detailed is IERC20 {
251     string private _name;
252     string private _symbol;
253     uint8 private _decimals;
254 
255 
256     constructor (string memory name, string memory symbol, uint8 decimals) public {
257         _name = name;
258         _symbol = symbol;
259         _decimals = decimals;
260     }
261 
262     
263     function name() public view returns (string memory) {
264         return _name;
265     }
266 
267    
268     function symbol() public view returns (string memory) {
269         return _symbol;
270     }
271 
272     
273     function decimals() public view returns (uint8) {
274         return _decimals;
275     }
276 }
277 
278 contract PolkaBridge is ERC20, ERC20Detailed, ERC20Burnable {
279     uint256 BeginExtract;
280 
281     constructor(uint256 initialSupply)
282         public
283         ERC20Detailed("PolkaBridge", "PBR", 18)
284     {
285         _deploy(msg.sender, initialSupply);
286         BeginExtract = 1615766400; //15 Mar 2021 1615766400
287     }
288 
289     function _caculateExtractAmount(uint256 amount)
290         internal
291         override
292         returns (uint256, uint256)
293     {
294         if (block.timestamp > BeginExtract) {
295             uint256 extractAmount = (amount * 5) / 1000;
296 
297             uint256 burnAmount = (extractAmount * 10) / 100;
298             uint256 rewardAmount = (extractAmount * 90) / 100;
299 
300             return (burnAmount, rewardAmount);
301         } else {
302             return (0, 0);
303         }
304     }
305 }