1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(
12         address sender,
13         address recipient,
14         uint256 amount
15     ) external returns (bool);
16    
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 interface IERC20Metadata is IERC20 {
22     function name() external view returns (string memory);
23     function symbol() external view returns (string memory);
24     function decimals() external view returns (uint8);
25 }
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor () {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48 
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57 
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68 }
69 
70 contract ERC20 is Context, IERC20, IERC20Metadata {
71     mapping(address => uint256) private _balances;
72 
73     mapping(address => mapping(address => uint256)) private _allowances;
74 
75     uint256 private _totalSupply;
76 
77     string private _name;
78     string private _symbol;
79 
80     constructor(string memory name_, string memory symbol_) {
81         _name = name_;
82         _symbol = symbol_;
83     }
84 
85     function name() public view virtual override returns (string memory) {
86         return _name;
87     }
88 
89     function symbol() public view virtual override returns (string memory) {
90         return _symbol;
91     }
92 
93     function decimals() public view virtual override returns (uint8) {
94         return 18;
95     }
96 
97     function totalSupply() public view virtual override returns (uint256) {
98         return _totalSupply;
99     }
100 
101     function balanceOf(address account) public view virtual override returns (uint256) {
102         return _balances[account];
103     }
104 
105     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
106         _transfer(_msgSender(), recipient, amount);
107         return true;
108     }
109 
110     function allowance(address owner, address spender) public view virtual override returns (uint256) {
111         return _allowances[owner][spender];
112     }
113 
114     function approve(address spender, uint256 amount) public virtual override returns (bool) {
115         _approve(_msgSender(), spender, amount);
116         return true;
117     }
118 
119     function transferFrom(
120         address sender,
121         address recipient,
122         uint256 amount
123     ) public virtual override returns (bool) {
124         uint256 currentAllowance = _allowances[sender][_msgSender()];
125         if (currentAllowance != type(uint256).max) {
126             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
127             unchecked {
128                 _approve(sender, _msgSender(), currentAllowance - amount);
129             }
130         }
131 
132         _transfer(sender, recipient, amount);
133 
134         return true;
135     }
136 
137     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
138         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
139         return true;
140     }
141 
142     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
143         uint256 currentAllowance = _allowances[_msgSender()][spender];
144         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
145         unchecked {
146             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
147         }
148 
149         return true;
150     }
151 
152     function _transfer(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) internal virtual {
157         require(sender != address(0), "ERC20: transfer from the zero address");
158         require(recipient != address(0), "ERC20: transfer to the zero address");
159 
160         _beforeTokenTransfer(sender, recipient, amount);
161 
162         uint256 senderBalance = _balances[sender];
163         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
164         unchecked {
165             _balances[sender] = senderBalance - amount;
166         }
167         _balances[recipient] += amount;
168 
169         emit Transfer(sender, recipient, amount);
170 
171         _afterTokenTransfer(sender, recipient, amount);
172     }
173 
174     function _mint(address account, uint256 amount) internal virtual {
175         require(account != address(0), "ERC20: mint to the zero address");
176 
177         _beforeTokenTransfer(address(0), account, amount);
178 
179         _totalSupply += amount;
180         _balances[account] += amount;
181         emit Transfer(address(0), account, amount);
182 
183         _afterTokenTransfer(address(0), account, amount);
184     }
185 
186     function _burn(address account, uint256 amount) internal virtual {
187         require(account != address(0), "ERC20: burn from the zero address");
188 
189         _beforeTokenTransfer(account, address(0), amount);
190 
191         uint256 accountBalance = _balances[account];
192         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
193         unchecked {
194             _balances[account] = accountBalance - amount;
195         }
196         _totalSupply -= amount;
197 
198         emit Transfer(account, address(0), amount);
199 
200         _afterTokenTransfer(account, address(0), amount);
201     }
202 
203     function _approve(
204         address owner,
205         address spender,
206         uint256 amount
207     ) internal virtual {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210 
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function _beforeTokenTransfer(
216         address from,
217         address to,
218         uint256 amount
219     ) internal virtual {}
220 
221     function _afterTokenTransfer(
222         address from,
223         address to,
224         uint256 amount
225     ) internal virtual {}
226 }
227 
228 
229 contract PEPE3 is ERC20, Ownable {
230     constructor () ERC20("Pepe 3.0", "PEPE 3.0") 
231     {   
232         transferOwnership(0x8e8c991dc73E2938047a6148037D8034150F5Ad7);
233         _mint(owner(), 1_000_000_000_000_000 * (10 ** decimals()));
234     }
235 
236     receive() external payable {}
237 
238     function _transfer(address from,address to,uint256 amount) internal  override {
239         require(from != address(0), "ERC20: transfer from the zero address");
240         require(to != address(0), "ERC20: transfer to the zero address");
241        
242         if (amount == 0) {
243             super._transfer(from, to, 0);
244             return;
245         }
246 
247         super._transfer(from, to, amount);
248     }
249 }