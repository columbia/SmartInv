1 /**
2  *Submitted for verification at FtmScan.com on 2021-07-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.6;
7 
8 interface ibToken {
9     function mint(uint) external returns (uint);
10     function redeemUnderlying(uint) external returns (uint);
11     function exchangeRateStored() external view returns (uint);
12     function balanceOf(address) external view returns (uint);
13 }
14 
15 contract FixedEUR {
16     string public constant name = "Iron Bank EUR";
17     string public constant symbol = "ibEUR";
18     uint8 public constant decimals = 18;
19     
20     ibToken public immutable ib;
21     address public gov;
22     address public nextgov;
23     uint public commitgov;
24     uint public constant delay = 1 days;
25     
26     uint public liquidity;
27     
28     constructor(ibToken _ib) {
29         ib = _ib;
30         gov = msg.sender;
31     }
32     
33     modifier g() {
34         require(msg.sender == gov);
35         _;
36     }
37     
38     function setGov(address _gov) external g {
39         nextgov = _gov;
40         commitgov = block.timestamp + delay;
41     }
42     
43     function acceptGov() external {
44         require(msg.sender == nextgov && commitgov < block.timestamp);
45         gov = nextgov;
46     }
47     
48     function balanceIB() public view returns (uint) {
49         return ib.balanceOf(address(this));
50     }
51     
52     function balanceUnderlying() public view returns (uint) {
53         uint256 _b = balanceIB();
54         if (_b > 0) {
55             return _b * ib.exchangeRateStored() / 1e18;
56         }
57         return 0;
58     }
59     
60     function _redeem(uint amount) internal {
61         require(ib.redeemUnderlying(amount) == 0, "ib: withdraw failed");
62     }
63     
64     function profit() external {
65         uint _profit = balanceUnderlying() - liquidity;
66         _redeem(_profit);
67         _transferTokens(address(this), gov, _profit);
68     }
69     
70     function withdraw(uint amount) external g {
71         liquidity -= amount;
72         _redeem(amount);
73         _burn(amount);
74     }
75     
76     function deposit() external {
77         uint _amount = balances[address(this)];
78         allowances[address(this)][address(ib)] = _amount;
79         liquidity += _amount;
80         require(ib.mint(_amount) == 0, "ib: supply failed");
81     }
82     
83     /// @notice Total number of tokens in circulation
84     uint public totalSupply = 0;
85     
86     mapping(address => mapping (address => uint)) internal allowances;
87     mapping(address => uint) internal balances;
88     
89     event Transfer(address indexed from, address indexed to, uint amount);
90     event Approval(address indexed owner, address indexed spender, uint amount);
91     
92     function mint(uint amount) external g {
93         // mint the amount
94         totalSupply += amount;
95         // transfer the amount to the recipient
96         balances[address(this)] += amount;
97         emit Transfer(address(0), address(this), amount);
98     }
99     
100     function burn(uint amount) external g {
101         _burn(amount);
102     }
103     
104     function _burn(uint amount) internal {
105         // burn the amount
106         totalSupply -= amount;
107         // transfer the amount from the recipient
108         balances[address(this)] -= amount;
109         emit Transfer(address(this), address(0), amount);
110     }
111     
112     function allowance(address account, address spender) external view returns (uint) {
113         return allowances[account][spender];
114     }
115 
116     function approve(address spender, uint amount) external returns (bool) {
117         allowances[msg.sender][spender] = amount;
118 
119         emit Approval(msg.sender, spender, amount);
120         return true;
121     }
122 
123     function balanceOf(address account) external view returns (uint) {
124         return balances[account];
125     }
126 
127     function transfer(address dst, uint amount) external returns (bool) {
128         _transferTokens(msg.sender, dst, amount);
129         return true;
130     }
131 
132     function transferFrom(address src, address dst, uint amount) external returns (bool) {
133         address spender = msg.sender;
134         uint spenderAllowance = allowances[src][spender];
135 
136         if (spender != src && spenderAllowance != type(uint).max) {
137             uint newAllowance = spenderAllowance - amount;
138             allowances[src][spender] = newAllowance;
139 
140             emit Approval(src, spender, newAllowance);
141         }
142 
143         _transferTokens(src, dst, amount);
144         return true;
145     }
146 
147     function _transferTokens(address src, address dst, uint amount) internal {
148         balances[src] -= amount;
149         balances[dst] += amount;
150         
151         emit Transfer(src, dst, amount);
152     }
153 }