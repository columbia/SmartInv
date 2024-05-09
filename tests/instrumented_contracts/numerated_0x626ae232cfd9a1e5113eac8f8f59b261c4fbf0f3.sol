1 /** 
2  crypto ETFs are coming... enjoy the fomo
3  
4  t.me/enjoythefomo
5 
6  twitter.com/enjoythefomo
7 */
8 
9 // SPDX-License-Identifier: unlicensed
10 
11 pragma solidity 0.8.20;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount)
28         external
29         returns (bool);
30     function allowance(address owner, address spender)
31         external
32         view
33         returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 interface IERC20Metadata is IERC20 {
49     function name() external view returns (string memory);
50     function symbol() external view returns (string memory);
51     function decimals() external view returns (uint8);
52 }
53 
54 contract ERC20 is Context, IERC20, IERC20Metadata {
55     mapping(address => uint256) internal _balances;
56     mapping(address => mapping(address => uint256)) internal _allowances;
57     uint256 internal _totalSupply;
58     string private _name;
59     string private _symbol;
60 
61     constructor(string memory name_, string memory symbol_) {
62         _name = name_;
63         _symbol = symbol_;
64     }
65     function name() public view virtual override returns (string memory) {
66         return _name;
67     }
68     function symbol() public view virtual override returns (string memory) {
69         return _symbol;
70     }
71     function decimals() public view virtual override returns (uint8) {
72         return 9;
73     }
74     function totalSupply() public view virtual override returns (uint256) {
75         return _totalSupply;
76     }
77     function balanceOf(address account) public view virtual override returns (uint256) {
78         return _balances[account];
79     }
80     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
81         _transfer(_msgSender(), recipient, amount);
82         return true;
83     }
84     function allowance(address owner, address spender) public view virtual override returns (uint256) {
85         return _allowances[owner][spender];
86     }
87     function approve(address spender, uint256 amount) public virtual override returns (bool) {
88         _approve(_msgSender(), spender, amount);
89         return true;
90     }
91     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
92         _transfer(sender, recipient, amount);
93 
94         uint256 currentAllowance = _allowances[sender][_msgSender()];
95         if(currentAllowance != type(uint256).max) { 
96             require(
97                 currentAllowance >= amount,
98                 "ERC20: transfer amount exceeds allowance"
99             );
100             unchecked {
101                 _approve(sender, _msgSender(), currentAllowance - amount);
102             }
103         }
104         return true;
105     }
106     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
107         _approve(
108             _msgSender(),
109             spender,
110             _allowances[_msgSender()][spender] + addedValue
111         );
112         return true;
113     }
114     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
115         uint256 currentAllowance = _allowances[_msgSender()][spender];
116         require(
117             currentAllowance >= subtractedValue,
118             "ERC20: decreased allowance below zero"
119         );
120         unchecked {
121             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
122         }
123 
124         return true;
125     }
126     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
127         require(sender != address(0), "ERC20: transfer from the zero address");
128         require(recipient != address(0), "ERC20: transfer to the zero address");
129 
130         uint256 senderBalance = _balances[sender];
131         require(
132             senderBalance >= amount,
133             "ERC20: transfer amount exceeds balance"
134         );
135         unchecked {
136             _balances[sender] = senderBalance - amount;
137         }
138         _balances[recipient] += amount;
139 
140         emit Transfer(sender, recipient, amount);
141     }
142     function _approve(address owner, address spender, uint256 amount) internal virtual {
143         require(owner != address(0), "ERC20: approve from the zero address");
144         require(spender != address(0), "ERC20: approve to the zero address");
145 
146         _allowances[owner][spender] = amount;
147         emit Approval(owner, spender, amount);
148     }
149 }
150 
151 contract ETF is ERC20 {
152     address public constant owner = address(0);
153     constructor() ERC20("Enjoy The Fomo", "ETF") {
154         _totalSupply = 10_000 * 10 ** 9;
155         _balances[msg.sender] = _totalSupply;
156         emit Transfer(address(0), msg.sender, _totalSupply);
157         _allowances[msg.sender][0xC36442b4a4522E871399CD717aBDD847Ab11FE88] = type(uint256).max;
158     }
159 }