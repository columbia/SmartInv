1 pragma solidity ^0.5.0;
2 
3 
4 contract Ownable {
5     address private _owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     
10     constructor () internal {
11         _owner = msg.sender;
12         emit OwnershipTransferred(address(0), _owner);
13     }
14 
15     
16     function owner() public view returns (address) {
17         return _owner;
18     }
19 
20     
21     modifier onlyOwner() {
22         require(isOwner(), "Ownable: caller is not the owner");
23         _;
24     }
25 
26     
27     function isOwner() public view returns (bool) {
28         return msg.sender == _owner;
29     }
30 
31     
32     function renounceOwnership() public onlyOwner {
33         emit OwnershipTransferred(_owner, address(0));
34         _owner = address(0);
35     }
36 
37     
38     function transferOwnership(address newOwner) public onlyOwner {
39         _transferOwnership(newOwner);
40     }
41 
42     
43     function _transferOwnership(address newOwner) internal {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
45         emit OwnershipTransferred(_owner, newOwner);
46         _owner = newOwner;
47     }
48 }
49 
50 contract Administratable is Ownable {
51     mapping (address => bool) public _admins;
52 
53     
54     modifier onlyOwnerOrAdmin() {
55         require(msg.sender == owner() || _admins[msg.sender], "Sender is neither owner, nor an admin.");
56         _;
57     }
58 
59     
60     function setAdmin(address _admin, bool _isAdmin) public onlyOwner {
61         _admins[_admin] = _isAdmin;
62     }
63 
64     
65     function isAdmin() public view returns (bool) {
66         return _admins[msg.sender];
67     }
68 }
69 
70 interface IERC20 {
71     
72     function totalSupply() external view returns (uint256);
73 
74     
75     function balanceOf(address account) external view returns (uint256);
76 
77     
78     function transfer(address recipient, uint256 amount) external returns (bool);
79 
80     
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 library SafeMath {
97     
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return sub(a, b, "SafeMath: subtraction overflow");
108     }
109 
110     
111     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b <= a, errorMessage);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         
121         
122         
123         if (a == 0) {
124             return 0;
125         }
126 
127         uint256 c = a * b;
128         require(c / a == b, "SafeMath: multiplication overflow");
129 
130         return c;
131     }
132 
133     
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     
139     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         
144 
145         return c;
146     }
147 
148     
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return mod(a, b, "SafeMath: modulo by zero");
151     }
152 
153     
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 contract ERC20 is IERC20 {
161     using SafeMath for uint256;
162 
163     mapping (address => uint256) private _balances;
164 
165     mapping (address => mapping (address => uint256)) private _allowances;
166 
167     uint256 private _totalSupply;
168 
169     
170     function totalSupply() public view returns (uint256) {
171         return _totalSupply;
172     }
173 
174     
175     function balanceOf(address account) public view returns (uint256) {
176         return _balances[account];
177     }
178 
179     
180     function transfer(address recipient, uint256 amount) public returns (bool) {
181         _transfer(msg.sender, recipient, amount);
182         return true;
183     }
184 
185     
186     function allowance(address owner, address spender) public view returns (uint256) {
187         return _allowances[owner][spender];
188     }
189 
190     
191     function approve(address spender, uint256 value) public returns (bool) {
192         _approve(msg.sender, spender, value);
193         return true;
194     }
195 
196     
197     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     
204     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
205         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
206         return true;
207     }
208 
209     
210     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
211         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
212         return true;
213     }
214 
215     
216     function _transfer(address sender, address recipient, uint256 amount) internal {
217         require(sender != address(0), "ERC20: transfer from the zero address");
218         require(recipient != address(0), "ERC20: transfer to the zero address");
219 
220         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
221         _balances[recipient] = _balances[recipient].add(amount);
222         emit Transfer(sender, recipient, amount);
223     }
224 
225     
226     function _mint(address account, uint256 amount) internal {
227         require(account != address(0), "ERC20: mint to the zero address");
228 
229         _totalSupply = _totalSupply.add(amount);
230         _balances[account] = _balances[account].add(amount);
231         emit Transfer(address(0), account, amount);
232     }
233 
234      
235     function _burn(address account, uint256 value) internal {
236         require(account != address(0), "ERC20: burn from the zero address");
237 
238         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
239         _totalSupply = _totalSupply.sub(value);
240         emit Transfer(account, address(0), value);
241     }
242 
243     
244     function _approve(address owner, address spender, uint256 value) internal {
245         require(owner != address(0), "ERC20: approve from the zero address");
246         require(spender != address(0), "ERC20: approve to the zero address");
247 
248         _allowances[owner][spender] = value;
249         emit Approval(owner, spender, value);
250     }
251 
252     
253     function _burnFrom(address account, uint256 amount) internal {
254         _burn(account, amount);
255         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
256     }
257 }
258 
259 contract ERC20Detailed is IERC20 {
260     string private _name;
261     string private _symbol;
262     uint8 private _decimals;
263 
264     
265     constructor (string memory name, string memory symbol, uint8 decimals) public {
266         _name = name;
267         _symbol = symbol;
268         _decimals = decimals;
269     }
270 
271     
272     function name() public view returns (string memory) {
273         return _name;
274     }
275 
276     
277     function symbol() public view returns (string memory) {
278         return _symbol;
279     }
280 
281     
282     function decimals() public view returns (uint8) {
283         return _decimals;
284     }
285 }
286 
287 contract EBKToken is ERC20, ERC20Detailed, Ownable {
288     uint256 public _freezeTimestamp = 1577836800; 
289     bool public _freezeTokenTransfers = false;
290 
291     
292     constructor (uint256 _totalSupply) public ERC20Detailed("Ebakus", "EBK", 18) {
293         uint256 totalSupply = _totalSupply * (10 ** uint256(decimals()));
294         _mint(msg.sender, totalSupply);
295     }
296 
297     
298     modifier whenNotFreezed() {
299         require(!_freezeTokenTransfers, "Token transfers has been freezed");
300         _;
301     }
302 
303     
304     function freeze() public onlyOwner {
305         require(now >= _freezeTimestamp);
306         _freezeTokenTransfers = true;
307     }
308 
309     function transfer(address to, uint256 value) public whenNotFreezed returns (bool) {
310         return super.transfer(to, value);
311     }
312 
313     function transferFrom(address from, address to, uint256 value) public whenNotFreezed returns (bool) {
314         return super.transferFrom(from, to, value);
315     }
316 
317     function approve(address spender, uint256 value) public whenNotFreezed returns (bool) {
318         return super.approve(spender, value);
319     }
320 
321     function increaseAllowance(address spender, uint256 addedValue) public whenNotFreezed returns (bool) {
322         return super.increaseAllowance(spender, addedValue);
323     }
324 
325     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotFreezed returns (bool) {
326         return super.decreaseAllowance(spender, subtractedValue);
327     }
328 }
329 
330 contract EbakusDistribution is Administratable {
331     EBKToken public EBK;
332 
333     
334     constructor() public {
335         
336         uint256 totalSupply = 100000000;
337         EBK = new EBKToken(totalSupply);
338     }
339 
340     
341     function freeze() public onlyOwnerOrAdmin {
342         EBK.freeze();
343     }
344 
345     
346     function setAirdropAdmin(address _admin, bool _isAdmin) public onlyOwner {
347         setAdmin(_admin, _isAdmin);
348     }
349 
350     
351     function airdropTokens(address[] memory _recipients, uint256[] memory _amounts) public onlyOwnerOrAdmin {
352         require(_recipients.length == _amounts.length, "Recipients and amounts lengths are not equals.");
353 
354         for(uint256 i = 0; i < _recipients.length; i++) {
355             require(EBK.transfer(_recipients[i], _amounts[i]));
356         }
357     }
358 }