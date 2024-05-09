1 // SPDX-License-Identifier: MIT
2 
3 // ███╗░░░███╗███████╗████████╗██████╗░░█████╗░██████╗░░█████╗░██╗░░░░░██╗░░░██╗
4 // ████╗░████║██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║░░░░░╚██╗░██╔╝
5 // ██╔████╔██║█████╗░░░░░██║░░░██████╔╝██║░░██║██████╔╝██║░░██║██║░░░░░░╚████╔╝░
6 // ██║╚██╔╝██║██╔══╝░░░░░██║░░░██╔══██╗██║░░██║██╔═══╝░██║░░██║██║░░░░░░░╚██╔╝░░
7 // ██║░╚═╝░██║███████╗░░░██║░░░██║░░██║╚█████╔╝██║░░░░░╚█████╔╝███████╗░░░██║░░░
8 // ╚═╝░░░░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝░╚════╝░╚═╝░░░░░░╚════╝░╚══════╝░░░╚═╝░░░
9 
10 pragma solidity ^0.8.17;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(
26         address indexed previousOwner,
27         address indexed newOwner
28     );
29 
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34     modifier onlyOwner() {
35         _checkOwner();
36         _;
37     }
38 
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     function _checkOwner() internal view virtual {
44         require(owner() == _msgSender(), "Ownable: caller is not the owner");
45     }
46 
47     function renounceOwnership() public virtual onlyOwner {
48         _transferOwnership(address(0));
49     }
50 
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(
53             newOwner != address(0),
54             "Ownable: new owner is the zero address"
55         );
56         _transferOwnership(newOwner);
57     }
58 
59     function _transferOwnership(address newOwner) internal virtual {
60         address oldOwner = _owner;
61         _owner = newOwner;
62         emit OwnershipTransferred(oldOwner, newOwner);
63     }
64 }
65 
66 interface IERC20 {
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(
69         address indexed owner,
70         address indexed spender,
71         uint256 value
72     );
73 
74     function totalSupply() external view returns (uint256);
75 
76     function balanceOf(address account) external view returns (uint256);
77 
78     function transfer(address to, uint256 amount) external returns (bool);
79 
80     function allowance(address owner, address spender)
81         external
82         view
83         returns (uint256);
84 
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     function transferFrom(
88         address from,
89         address to,
90         uint256 amount
91     ) external returns (bool);
92 }
93 
94 interface IERC20Metadata is IERC20 {
95     function name() external view returns (string memory);
96 
97     function symbol() external view returns (string memory);
98 
99     function decimals() external view returns (uint8);
100 }
101 
102 contract ERC20 is Context, IERC20, IERC20Metadata {
103     mapping(address => uint256) private _balances;
104 
105     mapping(address => mapping(address => uint256)) private _allowances;
106 
107     uint256 private _totalSupply;
108 
109     string private _name;
110     string private _symbol;
111 
112     constructor(string memory name_, string memory symbol_) {
113         _name = name_;
114         _symbol = symbol_;
115     }
116 
117     function name() public view virtual override returns (string memory) {
118         return _name;
119     }
120 
121     function symbol() public view virtual override returns (string memory) {
122         return _symbol;
123     }
124 
125     function decimals() public view virtual override returns (uint8) {
126         return 18;
127     }
128 
129     function totalSupply() public view virtual override returns (uint256) {
130         return _totalSupply;
131     }
132 
133     function balanceOf(address account)
134         public
135         view
136         virtual
137         override
138         returns (uint256)
139     {
140         return _balances[account];
141     }
142 
143     function transfer(address to, uint256 amount)
144         public
145         virtual
146         override
147         returns (bool)
148     {
149         address owner = _msgSender();
150         _transfer(owner, to, amount);
151         return true;
152     }
153 
154     function allowance(address owner, address spender)
155         public
156         view
157         virtual
158         override
159         returns (uint256)
160     {
161         return _allowances[owner][spender];
162     }
163 
164     function approve(address spender, uint256 amount)
165         public
166         virtual
167         override
168         returns (bool)
169     {
170         address owner = _msgSender();
171         _approve(owner, spender, amount);
172         return true;
173     }
174 
175     function transferFrom(
176         address from,
177         address to,
178         uint256 amount
179     ) public virtual override returns (bool) {
180         address spender = _msgSender();
181         _spendAllowance(from, spender, amount);
182         _transfer(from, to, amount);
183         return true;
184     }
185 
186     function increaseAllowance(address spender, uint256 addedValue)
187         public
188         virtual
189         returns (bool)
190     {
191         address owner = _msgSender();
192         _approve(owner, spender, allowance(owner, spender) + addedValue);
193         return true;
194     }
195 
196     function decreaseAllowance(address spender, uint256 subtractedValue)
197         public
198         virtual
199         returns (bool)
200     {
201         address owner = _msgSender();
202         uint256 currentAllowance = allowance(owner, spender);
203         require(
204             currentAllowance >= subtractedValue,
205             "ERC20: decreased allowance below zero"
206         );
207         unchecked {
208             _approve(owner, spender, currentAllowance - subtractedValue);
209         }
210 
211         return true;
212     }
213 
214     function _transfer(
215         address from,
216         address to,
217         uint256 amount
218     ) internal virtual {
219         require(from != address(0), "ERC20: transfer from the zero address");
220         require(to != address(0), "ERC20: transfer to the zero address");
221 
222         _beforeTokenTransfer(from, to, amount);
223 
224         uint256 fromBalance = _balances[from];
225         require(
226             fromBalance >= amount,
227             "ERC20: transfer amount exceeds balance"
228         );
229         unchecked {
230             _balances[from] = fromBalance - amount;
231         }
232         _balances[to] += amount;
233 
234         emit Transfer(from, to, amount);
235 
236         _afterTokenTransfer(from, to, amount);
237     }
238 
239     function _mint(address account, uint256 amount) internal virtual {
240         require(account != address(0), "ERC20: mint to the zero address");
241 
242         _beforeTokenTransfer(address(0), account, amount);
243 
244         _totalSupply += amount;
245         _balances[account] += amount;
246         emit Transfer(address(0), account, amount);
247 
248         _afterTokenTransfer(address(0), account, amount);
249     }
250 
251     function _approve(
252         address owner,
253         address spender,
254         uint256 amount
255     ) internal virtual {
256         require(owner != address(0), "ERC20: approve from the zero address");
257         require(spender != address(0), "ERC20: approve to the zero address");
258 
259         _allowances[owner][spender] = amount;
260         emit Approval(owner, spender, amount);
261     }
262 
263     function _spendAllowance(
264         address owner,
265         address spender,
266         uint256 amount
267     ) internal virtual {
268         uint256 currentAllowance = allowance(owner, spender);
269         if (currentAllowance != type(uint256).max) {
270             require(
271                 currentAllowance >= amount,
272                 "ERC20: insufficient allowance"
273             );
274             unchecked {
275                 _approve(owner, spender, currentAllowance - amount);
276             }
277         }
278     }
279 
280     function _beforeTokenTransfer(
281         address from,
282         address to,
283         uint256 amount
284     ) internal virtual {}
285 
286     function _afterTokenTransfer(
287         address from,
288         address to,
289         uint256 amount
290     ) internal virtual {}
291 }
292 
293 contract MetropolyToken is ERC20, Ownable {
294     constructor() ERC20("Metropoly", "METRO") {
295         _mint(msg.sender, 1000000000 * 10**18);
296     }
297 }