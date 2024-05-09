1 pragma solidity ^0.6.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(
16         uint256 a,
17         uint256 b,
18         string memory errorMessage
19     ) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33 
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40 
41     function div(
42         uint256 a,
43         uint256 b,
44         string memory errorMessage
45     ) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         return c;
49     }
50 
51     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
52         return mod(a, b, "SafeMath: modulo by zero");
53     }
54 
55     function mod(
56         uint256 a,
57         uint256 b,
58         string memory errorMessage
59     ) internal pure returns (uint256) {
60         require(b != 0, errorMessage);
61         return a % b;
62     }
63 }
64 
65 pragma solidity ^0.6.0;
66 
67 interface IERC20 {
68     function totalSupply() external view returns (uint256);
69 
70     function balanceOf(address account) external view returns (uint256);
71 
72     function transfer(address recipient, uint256 amount)
73         external
74         returns (bool);
75 
76     function allowance(address owner, address spender)
77         external
78         view
79         returns (uint256);
80 
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     event Approval(
92         address indexed owner,
93         address indexed spender,
94         uint256 value
95     );
96 }
97 
98 contract ERC20 is IERC20 {
99     using SafeMath for uint256;
100 
101     mapping(address => uint256) private _balances;
102 
103     mapping(address => mapping(address => uint256)) private _allowances;
104 
105     uint256 private _totalSupply;
106 
107     string private _name;
108     string private _symbol;
109     uint8 private _decimals;
110 
111     constructor(string memory name, string memory symbol) public {
112         _name = name;
113         _symbol = symbol;
114         _decimals = 18;
115     }
116 
117     function name() public view returns (string memory) {
118         return _name;
119     }
120 
121     function symbol() public view returns (string memory) {
122         return _symbol;
123     }
124 
125     function decimals() public view returns (uint8) {
126         return _decimals;
127     }
128 
129     function totalSupply() public override view returns (uint256) {
130         return _totalSupply;
131     }
132 
133     function balanceOf(address account) public override view returns (uint256) {
134         return _balances[account];
135     }
136 
137     function transfer(address recipient, uint256 amount)
138         public
139         virtual
140         override
141         returns (bool)
142     {
143         _transfer(msg.sender, recipient, amount);
144         return true;
145     }
146 
147     function allowance(address owner, address spender)
148         public
149         virtual
150         override
151         view
152         returns (uint256)
153     {
154         return _allowances[owner][spender];
155     }
156 
157     function approve(address spender, uint256 amount)
158         public
159         virtual
160         override
161         returns (bool)
162     {
163         _approve(msg.sender, spender, amount);
164         return true;
165     }
166 
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) public virtual override returns (bool) {
172         _transfer(sender, recipient, amount);
173         _approve(
174             sender,
175             msg.sender,
176             _allowances[sender][msg.sender].sub(
177                 amount,
178                 "ERC20: transfer amount exceeds allowance"
179             )
180         );
181         return true;
182     }
183 
184     function increaseAllowance(address spender, uint256 addedValue)
185         public
186         virtual
187         returns (bool)
188     {
189         _approve(
190             msg.sender,
191             spender,
192             _allowances[msg.sender][spender].add(addedValue)
193         );
194         return true;
195     }
196 
197     function decreaseAllowance(address spender, uint256 subtractedValue)
198         public
199         virtual
200         returns (bool)
201     {
202         _approve(
203             msg.sender,
204             spender,
205             _allowances[msg.sender][spender].sub(
206                 subtractedValue,
207                 "ERC20: decreased allowance below zero"
208             )
209         );
210         return true;
211     }
212 
213     function _transfer(
214         address sender,
215         address recipient,
216         uint256 amount
217     ) internal virtual {
218         require(sender != address(0), "ERC20: transfer from the zero address");
219         require(recipient != address(0), "ERC20: transfer to the zero address");
220 
221         _balances[sender] = _balances[sender].sub(
222             amount,
223             "ERC20: transfer amount exceeds balance"
224         );
225         _balances[recipient] = _balances[recipient].add(amount);
226         emit Transfer(sender, recipient, amount);
227     }
228 
229     function _mint(address account, uint256 amount) internal virtual {
230         require(account != address(0), "ERC20: mint to the zero address");
231 
232         _totalSupply = _totalSupply.add(amount);
233         _balances[account] = _balances[account].add(amount);
234         emit Transfer(address(0), account, amount);
235     }
236 
237     function _burn(address account, uint256 amount) internal virtual {
238         require(account != address(0), "ERC20: burn from the zero address");
239 
240         _balances[account] = _balances[account].sub(
241             amount,
242             "ERC20: burn amount exceeds balance"
243         );
244         _totalSupply = _totalSupply.sub(amount);
245         emit Transfer(account, address(0), amount);
246     }
247 
248     function _approve(
249         address owner,
250         address spender,
251         uint256 amount
252     ) internal virtual {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255 
256         _allowances[owner][spender] = amount;
257         emit Approval(owner, spender, amount);
258     }
259 
260     function _setupDecimals(uint8 decimals_) internal {
261         _decimals = decimals_;
262     }
263 }
264 
265 contract Firemoon is ERC20 {
266     constructor() public ERC20("Firemoon", "FIRM") {
267         _mint(msg.sender, 3000 * (10**uint256(decimals())));
268     }
269 
270     function transfer(address to, uint256 amount)
271         public
272         override
273         returns (bool)
274     {
275         return super.transfer(to, _partialBurn(amount));
276     }
277 
278     function transferFrom(
279         address from,
280         address to,
281         uint256 amount
282     ) public override returns (bool) {
283         return
284             super.transferFrom(
285                 from,
286                 to,
287                 _partialBurnTransferFrom(from, amount)
288             );
289     }
290 
291     function _partialBurn(uint256 amount) internal returns (uint256) {
292         uint256 burnAmount = amount.div(50);
293 
294         if (burnAmount > 0) {
295             _burn(msg.sender, burnAmount);
296         }
297 
298         return amount.sub(burnAmount);
299     }
300 
301     function _partialBurnTransferFrom(address _originalSender, uint256 amount)
302         internal
303         returns (uint256)
304     {
305         uint256 burnAmount = amount.div(50);
306 
307         if (burnAmount > 0) {
308             _burn(_originalSender, burnAmount);
309         }
310 
311         return amount.sub(burnAmount);
312     }
313 }