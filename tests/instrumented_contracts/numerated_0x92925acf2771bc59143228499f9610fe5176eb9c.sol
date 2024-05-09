1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     constructor() {
20         _transferOwnership(_msgSender());
21     }
22 
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26 
27     modifier onlyOwner() {
28         require(owner() == _msgSender(), "Ownable: caller is not the owner");
29         _;
30     }
31 
32     function renounceOwnership() public virtual onlyOwner {
33         _transferOwnership(address(0));
34     }
35 
36     function transferOwnership(address newOwner) public virtual onlyOwner {
37         require(newOwner != address(0), "Ownable: new owner is the zero address");
38         _transferOwnership(newOwner);
39     }
40 
41     function _transferOwnership(address newOwner) internal virtual {
42         address oldOwner = _owner;
43         _owner = newOwner;
44         emit OwnershipTransferred(oldOwner, newOwner);
45     }
46 }
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50 
51     function balanceOf(address account) external view returns (uint256);
52 
53     function transfer(address to, uint256 amount) external returns (bool);
54 
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     function transferFrom(
60         address from,
61         address to,
62         uint256 amount
63     ) external returns (bool);
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 interface IERC20Metadata is IERC20 {
71     function name() external view returns (string memory);
72 
73     function symbol() external view returns (string memory);
74 
75     function decimals() external view returns (uint8);
76 }
77 
78 contract ERC20 is Context, IERC20, IERC20Metadata {
79     mapping(address => uint256) private _balances;
80 
81     mapping(address => mapping(address => uint256)) private _allowances;
82 
83     uint256 private _totalSupply;
84 
85     string private _name;
86     string private _symbol;
87 
88     constructor(string memory name_, string memory symbol_) {
89         _name = name_;
90         _symbol = symbol_;
91     }
92 
93     function name() public view virtual override returns (string memory) {
94         return _name;
95     }
96 
97     function symbol() public view virtual override returns (string memory) {
98         return _symbol;
99     }
100 
101     function decimals() public view virtual override returns (uint8) {
102         return 18;
103     }
104 
105     function totalSupply() public view virtual override returns (uint256) {
106         return _totalSupply;
107     }
108 
109     function balanceOf(address account) public view virtual override returns (uint256) {
110         return _balances[account];
111     }
112 
113     function transfer(address to, uint256 amount) public virtual override returns (bool) {
114         address owner = _msgSender();
115         _transfer(owner, to, amount);
116         return true;
117     }
118 
119     function allowance(address owner, address spender) public view virtual override returns (uint256) {
120         return _allowances[owner][spender];
121     }
122 
123     function approve(address spender, uint256 amount) public virtual override returns (bool) {
124         address owner = _msgSender();
125         _approve(owner, spender, amount);
126         return true;
127     }
128 
129     function transferFrom(
130         address from,
131         address to,
132         uint256 amount
133     ) public virtual override returns (bool) {
134         address spender = _msgSender();
135         _spendAllowance(from, spender, amount);
136         _transfer(from, to, amount);
137         return true;
138     }
139 
140     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
141         address owner = _msgSender();
142         _approve(owner, spender, _allowances[owner][spender] + addedValue);
143         return true;
144     }
145 
146     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
147         address owner = _msgSender();
148         uint256 currentAllowance = _allowances[owner][spender];
149         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
150         unchecked {
151             _approve(owner, spender, currentAllowance - subtractedValue);
152         }
153 
154         return true;
155     }
156 
157     function _transfer(
158         address from,
159         address to,
160         uint256 amount
161     ) internal virtual {
162         require(from != address(0), "ERC20: transfer from the zero address");
163         require(to != address(0), "ERC20: transfer to the zero address");
164 
165         _beforeTokenTransfer(from, to, amount);
166 
167         uint256 fromBalance = _balances[from];
168         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
169         unchecked {
170             _balances[from] = fromBalance - amount;
171         }
172         _balances[to] += amount;
173 
174         emit Transfer(from, to, amount);
175 
176         _afterTokenTransfer(from, to, amount);
177     }
178 
179     function _mint(address account, uint256 amount) internal virtual {
180         require(account != address(0), "ERC20: mint to the zero address");
181 
182         _beforeTokenTransfer(address(0), account, amount);
183 
184         _totalSupply += amount;
185         _balances[account] += amount;
186         emit Transfer(address(0), account, amount);
187 
188         _afterTokenTransfer(address(0), account, amount);
189     }
190 
191     function _burn(address account, uint256 amount) internal virtual {
192         require(account != address(0), "ERC20: burn from the zero address");
193 
194         _beforeTokenTransfer(account, address(0), amount);
195 
196         uint256 accountBalance = _balances[account];
197         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
198         unchecked {
199             _balances[account] = accountBalance - amount;
200         }
201         _totalSupply -= amount;
202 
203         emit Transfer(account, address(0), amount);
204 
205         _afterTokenTransfer(account, address(0), amount);
206     }
207 
208     function _approve(
209         address owner,
210         address spender,
211         uint256 amount
212     ) internal virtual {
213         require(owner != address(0), "ERC20: approve from the zero address");
214         require(spender != address(0), "ERC20: approve to the zero address");
215 
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function _spendAllowance(
221         address owner,
222         address spender,
223         uint256 amount
224     ) internal virtual {
225         uint256 currentAllowance = allowance(owner, spender);
226         if (currentAllowance != type(uint256).max) {
227             require(currentAllowance >= amount, "ERC20: insufficient allowance");
228             unchecked {
229                 _approve(owner, spender, currentAllowance - amount);
230             }
231         }
232     }
233 
234     function _beforeTokenTransfer(
235         address from,
236         address to,
237         uint256 amount
238     ) internal virtual {}
239 
240     function _afterTokenTransfer(
241         address from,
242         address to,
243         uint256 amount
244     ) internal virtual {}
245 }
246 
247 abstract contract ERC20Burnable is Context, ERC20 {
248     function burn(uint256 amount) public virtual {
249         _burn(_msgSender(), amount);
250     }
251 
252     function burnFrom(address account, uint256 amount) public virtual {
253         _spendAllowance(account, _msgSender(), amount);
254         _burn(account, amount);
255     }
256 }
257 
258 
259 contract SYLToken is ERC20, ERC20Burnable, Ownable {
260     constructor() ERC20("SYLToken", "SYL") {
261         _mint(msg.sender, 100000000 * 10 ** decimals());
262     }
263 }