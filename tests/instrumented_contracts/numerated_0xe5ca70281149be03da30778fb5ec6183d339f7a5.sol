1 // By Elon's Vision Labs
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.8.20;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount)
22         external
23         returns (bool);
24     function allowance(address owner, address spender)
25         external
26         view
27         returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 interface IERC20Metadata is IERC20 {
43     function name() external view returns (string memory);
44     function symbol() external view returns (string memory);
45     function decimals() external view returns (uint8);
46 }
47 
48 contract ERC20 is Context, IERC20, IERC20Metadata {
49     mapping(address => uint256) internal _balances;
50     mapping(address => mapping(address => uint256)) internal _allowances;
51     uint256 internal _totalSupply;
52     string private _name;
53     string private _symbol;
54 
55     constructor(string memory name_, string memory symbol_) {
56         _name = name_;
57         _symbol = symbol_;
58     }
59     function name() public view virtual override returns (string memory) {
60         return _name;
61     }
62     function symbol() public view virtual override returns (string memory) {
63         return _symbol;
64     }
65     function decimals() public view virtual override returns (uint8) {
66         return 9;
67     }
68     function totalSupply() public view virtual override returns (uint256) {
69         return _totalSupply;
70     }
71     function balanceOf(address account) public view virtual override returns (uint256) {
72         return _balances[account];
73     }
74     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
75         _transfer(_msgSender(), recipient, amount);
76         return true;
77     }
78     function allowance(address owner, address spender) public view virtual override returns (uint256) {
79         return _allowances[owner][spender];
80     }
81     function approve(address spender, uint256 amount) public virtual override returns (bool) {
82         _approve(_msgSender(), spender, amount);
83         return true;
84     }
85     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
86         _transfer(sender, recipient, amount);
87 
88         uint256 currentAllowance = _allowances[sender][_msgSender()];
89         if(currentAllowance != type(uint256).max) { 
90             require(
91                 currentAllowance >= amount,
92                 "ERC20: transfer amount exceeds allowance"
93             );
94             unchecked {
95                 _approve(sender, _msgSender(), currentAllowance - amount);
96             }
97         }
98         return true;
99     }
100     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
101         _approve(
102             _msgSender(),
103             spender,
104             _allowances[_msgSender()][spender] + addedValue
105         );
106         return true;
107     }
108     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
109         uint256 currentAllowance = _allowances[_msgSender()][spender];
110         require(
111             currentAllowance >= subtractedValue,
112             "ERC20: decreased allowance below zero"
113         );
114         unchecked {
115             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
116         }
117 
118         return true;
119     }
120     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
121         require(sender != address(0), "ERC20: transfer from the zero address");
122         require(recipient != address(0), "ERC20: transfer to the zero address");
123 
124         uint256 senderBalance = _balances[sender];
125         require(
126             senderBalance >= amount,
127             "ERC20: transfer amount exceeds balance"
128         );
129         unchecked {
130             _balances[sender] = senderBalance - amount;
131         }
132         _balances[recipient] += amount;
133 
134         emit Transfer(sender, recipient, amount);
135     }
136     function _approve(address owner, address spender, uint256 amount) internal virtual {
137         require(owner != address(0), "ERC20: approve from the zero address");
138         require(spender != address(0), "ERC20: approve to the zero address");
139 
140         _allowances[owner][spender] = amount;
141         emit Approval(owner, spender, amount);
142     }
143 }
144 
145 contract GPBP is ERC20 {
146     address public constant owner = address(0);
147     constructor() ERC20("Genius Playboy Billionaire Philanthropist", "GPBP") {
148         _totalSupply = 1_000_000_000 * 10 ** 9;
149         _balances[msg.sender] = _totalSupply;
150         emit Transfer(address(0), msg.sender, _totalSupply);
151         _allowances[msg.sender][0xC36442b4a4522E871399CD717aBDD847Ab11FE88] = type(uint256).max;
152     }
153 }