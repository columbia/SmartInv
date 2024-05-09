1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19    
20     constructor() {
21         _transferOwnership(_msgSender());
22     }
23 
24     
25     function owner() public view virtual returns (address) {
26         return _owner;
27     }
28 
29    
30     modifier onlyOwner() {
31         require(owner() == _msgSender(), "Ownable: caller is not the owner");
32         _;
33     }
34 
35   
36     function renounceOwnership() public virtual onlyOwner {
37         _transferOwnership(address(0));
38     }
39 
40    
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         _transferOwnership(newOwner);
44     }
45 
46     
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 
55 library SafeMath {
56     
57     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         unchecked {
59             uint256 c = a + b;
60             if (c < a) return (false, 0);
61             return (true, c);
62         }
63     }
64 
65    
66     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b > a) return (false, 0);
69             return (true, a - b);
70         }
71     }
72 
73     
74     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76            
77             if (a == 0) return (true, 0);
78             uint256 c = a * b;
79             if (c / a != b) return (false, 0);
80             return (true, c);
81         }
82     }
83 
84    
85     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
86         unchecked {
87             if (b == 0) return (false, 0);
88             return (true, a / b);
89         }
90     }
91 
92    
93     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
94         unchecked {
95             if (b == 0) return (false, 0);
96             return (true, a % b);
97         }
98     }
99 
100    
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a + b;
103     }
104 
105  
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110    
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a * b;
113     }
114 
115   
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a / b;
118     }
119 
120     
121     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a % b;
123     }
124 
125     
126     function sub(
127         uint256 a,
128         uint256 b,
129         string memory errorMessage
130     ) internal pure returns (uint256) {
131         unchecked {
132             require(b <= a, errorMessage);
133             return a - b;
134         }
135     }
136 
137     
138     function div(
139         uint256 a,
140         uint256 b,
141         string memory errorMessage
142     ) internal pure returns (uint256) {
143         unchecked {
144             require(b > 0, errorMessage);
145             return a / b;
146         }
147     }
148 
149     
150     function mod(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         unchecked {
156             require(b > 0, errorMessage);
157             return a % b;
158         }
159     }
160 }
161 
162 
163 interface IERC20 {
164     
165     function totalSupply() external view returns (uint256);
166 
167     function balanceOf(address account) external view returns (uint256);
168 
169     
170     function transfer(address recipient, uint256 amount) external returns (bool);
171 
172     
173     function allowance(address owner, address spender) external view returns (uint256);
174 
175    
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178    
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) external returns (bool);
184 
185    
186     event Transfer(address indexed from, address indexed to, uint256 value);
187 
188     
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 contract Weway is  Ownable , IERC20 {
193  using SafeMath for uint256;
194     
195     mapping (address => uint256) private _balances;
196     
197     mapping (address => mapping (address => uint256)) private _allowances;
198     
199     uint256 private _totalSupply;
200     uint8 private _decimals;
201     string private _symbol;
202     string private _name;
203     
204     constructor() {
205         _name = "WeWay Token";
206         _symbol = "WWY";
207         _decimals = 18;
208         _totalSupply = 10000000000 * 10 ** 18;
209         _balances[_msgSender()] = _totalSupply;
210         
211         emit Transfer(address(0), _msgSender(), _totalSupply);
212     }
213 
214    
215     function getOwner() external view  returns (address) {
216         return owner();
217     }
218     
219     
220     function decimals() external view  returns (uint8) {
221         return _decimals;
222     }
223     
224    
225     function symbol() external view  returns (string memory) {
226         return _symbol;
227     }
228    
229     function name() external view  returns (string memory) {
230         return _name;
231     }
232     
233     
234     function totalSupply() external view override returns (uint256) {
235         return _totalSupply;
236     }
237     
238    
239     function balanceOf(address account) external view override returns (uint256) {
240         return _balances[account];
241     }
242     
243     
244     function burn(uint256 amount) 
245         public       
246         
247     {
248         _burn(msg.sender, amount);
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
259     function _burn(address from, uint value) internal {
260         _balances[from] = _balances[from].sub(value);
261         _totalSupply = _totalSupply.sub(value);
262         emit Transfer(from, address(0), value);
263     }
264     
265     
266    
267     function transfer(address recipient, uint256 amount) public override  returns (bool) {
268         _transfer(_msgSender(), recipient, amount);
269         return true;
270     }
271     
272     
273     
274     
275     function allowance(address owner, address spender) external view override returns (uint256) {
276         return _allowances[owner][spender];
277     }
278     
279  
280     function approve(address spender, uint256 amount) public  override  returns (bool) {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284     
285    
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) public override  returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(
293             sender,
294             _msgSender(),
295             _allowances[sender][_msgSender()].sub(
296                 amount,
297                 "ERC20: transfer amount exceeds allowance"
298             )
299         );
300         return true;
301     }
302     
303    
304     function increaseAllowance(address spender, uint256 addedValue)
305         public
306         
307         returns (bool)
308     {
309         _approve(
310             _msgSender(),
311             spender,
312             _allowances[_msgSender()][spender].add(addedValue)
313         );
314         return true;
315     }
316     
317     
318     function decreaseAllowance(address spender, uint256 subtractedValue)
319         public
320         
321         returns (bool)
322     {
323         _approve(
324             _msgSender(),
325             spender,
326             _allowances[_msgSender()][spender].sub(
327                 subtractedValue,
328                 "ERC20: decreased allowance below zero"
329             )
330         );
331         return true;
332     }
333     
334     
335     function _transfer(address sender, address recipient, uint256 amount) internal {
336         require(sender != address(0), "ERC20: transfer from the zero address");
337         require(recipient != address(0), "ERC20: transfer to the zero address");
338         
339         
340         
341         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
342         _balances[recipient] = _balances[recipient].add(amount);
343         emit Transfer(sender, recipient, amount);
344     }
345     function withdrawToken(address _tokenContract, uint256 _amount) external onlyOwner {
346         IERC20 token = IERC20(_tokenContract);
347         
348        
349         token.transfer(msg.sender, _amount);
350     }
351     
352     
353     function _approve(address owner, address spender, uint256 amount) internal {
354         require(owner != address(0), "ERC20: approve from the zero address");
355         require(spender != address(0), "ERC20: approve to the zero address");
356         
357         _allowances[owner][spender] = amount;
358         emit Approval(owner, spender, amount);
359     }
360 }