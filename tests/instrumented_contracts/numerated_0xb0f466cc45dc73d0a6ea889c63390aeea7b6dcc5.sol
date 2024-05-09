1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.6;
4 
5 interface IERC20 {
6   function totalSupply() external view returns (uint);
7   function balanceOf(address account) external view returns (uint);
8   function transfer(address recipient, uint256 amount) external returns (bool);
9   function allowance(address owner, address spender) external view returns (uint);
10   function symbol() external view returns (string memory);
11   function decimals() external view returns (uint);
12   function approve(address spender, uint amount) external returns (bool);
13   function mint(address account, uint amount) external;
14   function burn(address account, uint amount) external;
15   function transferFrom(address sender, address recipient, uint amount) external returns (bool);
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 contract ERC20 {
21 
22   event Transfer(address indexed from, address indexed to, uint value);
23   event Approval(address indexed owner, address indexed spender, uint value);
24 
25   mapping (address => uint) public balanceOf;
26   mapping (address => mapping (address => uint)) public allowance;
27 
28   string public name;
29   string public symbol;
30   uint8 public immutable decimals;
31   uint public totalSupply;
32 
33   constructor(
34     string memory _name,
35     string memory _symbol,
36     uint8 _decimals
37   ) {
38     name = _name;
39     symbol = _symbol;
40     decimals = _decimals;
41     require(_decimals > 0, "decimals");
42   }
43 
44   function transfer(address _recipient, uint _amount) external returns (bool) {
45     _transfer(msg.sender, _recipient, _amount);
46     return true;
47   }
48 
49   function approve(address _spender, uint _amount) external returns (bool) {
50     _approve(msg.sender, _spender, _amount);
51     return true;
52   }
53 
54   function transferFrom(address _sender, address _recipient, uint _amount) external returns (bool) {
55     require(allowance[_sender][msg.sender] >= _amount, "ERC20: insufficient approval");
56     _transfer(_sender, _recipient, _amount);
57     _approve(_sender, msg.sender, allowance[_sender][msg.sender] - _amount);
58     return true;
59   }
60 
61   function _transfer(address _sender, address _recipient, uint _amount) internal {
62     require(_sender != address(0), "ERC20: transfer from the zero address");
63     require(_recipient != address(0), "ERC20: transfer to the zero address");
64     require(balanceOf[_sender] >= _amount, "ERC20: insufficient funds");
65 
66     balanceOf[_sender] -= _amount;
67     balanceOf[_recipient] += _amount;
68     emit Transfer(_sender, _recipient, _amount);
69   }
70 
71   function _mint(address _account, uint _amount) internal {
72     require(_account != address(0), "ERC20: mint to the zero address");
73 
74     totalSupply += _amount;
75     balanceOf[_account] += _amount;
76     emit Transfer(address(0), _account, _amount);
77   }
78 
79   function _burn(address _account, uint _amount) internal {
80     require(_account != address(0), "ERC20: burn from the zero address");
81 
82     balanceOf[_account] -= _amount;
83     totalSupply -= _amount;
84     emit Transfer(_account, address(0), _amount);
85   }
86 
87   function _approve(address _owner, address _spender, uint _amount) internal {
88     require(_owner != address(0), "ERC20: approve from the zero address");
89     require(_spender != address(0), "ERC20: approve to the zero address");
90 
91     allowance[_owner][_spender] = _amount;
92     emit Approval(_owner, _spender, _amount);
93   }
94 }
95 
96 contract AutoStaking is ERC20("xWILD", "xWILD", 18) {
97 
98   IERC20 public wild;
99 
100   event Deposit(uint wildAmount, uint shareAmount);
101   event Withdraw(uint wildAmount, uint shareAmount);
102 
103   constructor(IERC20 _wild) {
104     wild = _wild;
105   }
106 
107   function deposit(uint _wildAmount) external {
108     uint poolWILD = wild.balanceOf(address(this));
109     uint shareAmount;
110 
111     if (totalSupply == 0 || poolWILD == 0) {
112       _mint(msg.sender, _wildAmount);
113     } else {
114       shareAmount = _wildAmount * totalSupply / poolWILD;
115       _mint(msg.sender, shareAmount);
116     }
117 
118     wild.transferFrom(msg.sender, address(this), _wildAmount);
119 
120     emit Deposit(_wildAmount, shareAmount);
121   }
122 
123   function withdraw(uint _share) external {
124     uint wildAmount = _share * wild.balanceOf(address(this)) / totalSupply;
125     _burn(msg.sender, _share);
126     wild.transfer(msg.sender, wildAmount);
127 
128     emit Withdraw(wildAmount, _share);
129   }
130 }