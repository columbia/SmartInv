1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
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
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         emit OwnershipTransferred(_owner, newOwner);
61         _owner = newOwner;
62     }
63 }
64 
65 contract ERC20 is Context, IERC20, IERC20Metadata {
66     mapping(address => uint256) private _balances;
67 
68     mapping(address => mapping(address => uint256)) private _allowances;
69 
70     uint256 private _totalSupply;
71 
72     string private _name;
73     string private _symbol;
74 
75     constructor(string memory name_, string memory symbol_) {
76         _name = name_;
77         _symbol = symbol_;
78     }
79 
80     function name() public view virtual override returns (string memory) {
81         return _name;
82     }
83 
84     function symbol() public view virtual override returns (string memory) {
85         return _symbol;
86     }
87 
88     function decimals() public view virtual override returns (uint8) {
89         return 18;
90     }
91 
92     function totalSupply() public view virtual override returns (uint256) {
93         return _totalSupply;
94     }
95 
96     function balanceOf(address account) public view virtual override returns (uint256) {
97         return _balances[account];
98     }
99 
100     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
101         _transfer(_msgSender(), recipient, amount);
102         return true;
103     }
104 
105     function allowance(address owner, address spender) public view virtual override returns (uint256) {
106         return _allowances[owner][spender];
107     }
108 
109     function approve(address spender, uint256 amount) public virtual override returns (bool) {
110         _approve(_msgSender(), spender, amount);
111         return true;
112     }
113 
114     function transferFrom(
115         address sender,
116         address recipient,
117         uint256 amount
118     ) public virtual override returns (bool) {
119         uint256 currentAllowance = _allowances[sender][_msgSender()];
120         if (currentAllowance != type(uint256).max) {
121             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
122             unchecked {
123                 _approve(sender, _msgSender(), currentAllowance - amount);
124             }
125         }
126 
127         _transfer(sender, recipient, amount);
128 
129         return true;
130     }
131 
132     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
133         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
134         return true;
135     }
136 
137     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
138         uint256 currentAllowance = _allowances[_msgSender()][spender];
139         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
140         unchecked {
141             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
142         }
143 
144         return true;
145     }
146 
147     function _transfer(
148         address sender,
149         address recipient,
150         uint256 amount
151     ) internal virtual {
152         require(sender != address(0), "ERC20: transfer from the zero address");
153         require(recipient != address(0), "ERC20: transfer to the zero address");
154 
155         _beforeTokenTransfer(sender, recipient, amount);
156 
157         uint256 senderBalance = _balances[sender];
158         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
159         unchecked {
160             _balances[sender] = senderBalance - amount;
161         }
162         _balances[recipient] += amount;
163 
164         emit Transfer(sender, recipient, amount);
165 
166         _afterTokenTransfer(sender, recipient, amount);
167     }
168 
169     function _mint(address account, uint256 amount) internal virtual {
170         require(account != address(0), "ERC20: mint to the zero address");
171 
172         _beforeTokenTransfer(address(0), account, amount);
173 
174         _totalSupply += amount;
175         _balances[account] += amount;
176         emit Transfer(address(0), account, amount);
177 
178         _afterTokenTransfer(address(0), account, amount);
179     }
180 
181     function _burn(address account, uint256 amount) internal virtual {
182         require(account != address(0), "ERC20: burn from the zero address");
183 
184         _beforeTokenTransfer(account, address(0), amount);
185 
186         uint256 accountBalance = _balances[account];
187         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
188         unchecked {
189             _balances[account] = accountBalance - amount;
190         }
191         _totalSupply -= amount;
192 
193         emit Transfer(account, address(0), amount);
194 
195         _afterTokenTransfer(account, address(0), amount);
196     }
197 
198     function _approve(
199         address owner,
200         address spender,
201         uint256 amount
202     ) internal virtual {
203         require(owner != address(0), "ERC20: approve from the zero address");
204         require(spender != address(0), "ERC20: approve to the zero address");
205 
206         _allowances[owner][spender] = amount;
207         emit Approval(owner, spender, amount);
208     }
209 
210     function _beforeTokenTransfer(
211         address from,
212         address to,
213         uint256 amount
214     ) internal virtual {}
215 
216     function _afterTokenTransfer(
217         address from,
218         address to,
219         uint256 amount
220     ) internal virtual {}
221 }
222 
223 contract Doge3 is ERC20, Ownable {
224 
225     constructor () ERC20("Doge 3.0", "Doge3.0") 
226     {   
227         _mint(owner(), 420_690_000_000_000 * (10 ** 18));
228     }
229 
230     receive() external payable {
231 
232   	}
233 }