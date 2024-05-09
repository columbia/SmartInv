1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 contract MyToken is IERC20 {
16     string public name = "KUMA";
17     string public symbol = "KUMA";
18     uint8 public decimals = 18;
19     uint256 private constant MAX = ~uint256(0);
20     uint256 private _totalSupply = 58_000_000_000_000 * 10**decimals;      
21     
22     uint256 public buyTaxRate;
23     uint256 public sellTaxRate;
24     address public taxReceiver;
25     address private admin;
26     
27     mapping(address => uint256) private _balances;
28     mapping(address => mapping(address => uint256)) private _allowances;
29 
30     constructor() {
31         _balances[msg.sender] = _totalSupply;
32         emit Transfer(address(0), msg.sender, _totalSupply);
33         admin = msg.sender;
34     }
35 
36     function totalSupply() public view override returns (uint256) {
37         return _totalSupply;
38     }
39 
40     function balanceOf(address account) public view override returns (uint256) {
41         return _balances[account];
42     }
43 
44     function transfer(address recipient, uint256 amount) public override returns (bool) {
45         _transfer(msg.sender, recipient, amount);
46         return true;
47     }
48 
49     function allowance(address owner, address spender) public view override returns (uint256) {
50         return _allowances[owner][spender];
51     }
52 
53     function approve(address spender, uint256 amount) public override returns (bool) {
54         _approve(msg.sender, spender, amount);
55         return true;
56     }
57 
58     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
59         _transfer(sender, recipient, amount);
60         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
61         return true;
62     }
63 
64     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
65         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
66         return true;
67     }
68 
69     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
70         _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
71         return true;
72     }
73 
74     function setTaxRate(uint256 _buyTaxRate, uint256 _sellTaxRate) public onlyAdmin {
75         require(_buyTaxRate <= 100 && _sellTaxRate <= 100, "Tax rate must be less than or equal to 100");
76         buyTaxRate = _buyTaxRate;
77         sellTaxRate = _sellTaxRate;
78     }
79 
80     function setTaxReceiver(address _taxReceiver) public onlyAdmin {
81         require(_taxReceiver != address(0), "Invalid tax receiver address");
82         taxReceiver = _taxReceiver;
83     }
84     
85     modifier onlyAdmin() {
86         require(msg.sender == admin, "Only the admin can call this function");
87         _;
88     }
89 
90     function _transfer(address sender, address recipient, uint256 amount) internal {
91         require(sender != address(0), "ERC20: transfer from the zero address");
92         require(recipient != address(0), "ERC20: transfer to the zero address");
93         require(amount > 0, "Transfer amount must be greater than zero");
94 
95         uint256 transferAmount = amount;
96         uint256 taxAmount = 0;
97         
98         if (recipient == address(this)) {
99             taxAmount = amount * sellTaxRate / 100;
100             _balances[taxReceiver] += taxAmount;
101             transferAmount -= taxAmount;
102             emit Transfer(sender, taxReceiver, taxAmount);
103         } else if (sender != address(this)) {
104             taxAmount = amount * buyTaxRate / 100;
105             _balances[taxReceiver] += taxAmount;
106             transferAmount -= taxAmount;
107             emit Transfer(sender, taxReceiver, taxAmount);
108         }
109         
110         _balances[sender] -= amount;
111         _balances[recipient] += transferAmount;
112         emit Transfer(sender, recipient, transferAmount);
113     }
114 
115     function _approve(address owner, address spender, uint256 amount) internal {
116         require(owner != address(0), "ERC20: approve from the zero address");
117         require(spender != address(0), "ERC20: approve to the zero address");
118 
119         _allowances[owner][spender] = amount;
120         emit Approval(owner, spender, amount);
121     }
122 
123     function renounceOwnership() public onlyAdmin {
124         admin = address(0);
125     }
126     
127     function getAdmin() public view returns (address) {
128         return admin;
129     }
130 }