1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.6;
3 
4 interface ibToken {
5     function mint(uint) external returns (uint);
6     function redeemUnderlying(uint) external returns (uint);
7     function exchangeRateStored() external view returns (uint);
8     function balanceOf(address) external view returns (uint);
9 }
10 
11 contract FixedForex {
12     string public constant name = "Iron Bank KRW";
13     string public constant symbol = "ibKRW";
14     uint8 public constant decimals = 18;
15     
16     ibToken public immutable ib;
17     address public gov;
18     address public nextgov;
19     uint public commitgov;
20     uint public constant delay = 1 days;
21     
22     uint public liquidity;
23     
24     constructor(ibToken _ib) {
25         ib = _ib;
26         gov = msg.sender;
27     }
28     
29     modifier g() {
30         require(msg.sender == gov);
31         _;
32     }
33     
34     function setGov(address _gov) external g {
35         nextgov = _gov;
36         commitgov = block.timestamp + delay;
37     }
38     
39     function acceptGov() external {
40         require(msg.sender == nextgov && commitgov < block.timestamp);
41         gov = nextgov;
42     }
43     
44     function balanceIB() public view returns (uint) {
45         return ib.balanceOf(address(this));
46     }
47     
48     function balanceUnderlying() public view returns (uint) {
49         uint256 _b = balanceIB();
50         if (_b > 0) {
51             return _b * ib.exchangeRateStored() / 1e18;
52         }
53         return 0;
54     }
55     
56     function _redeem(uint amount) internal {
57         require(ib.redeemUnderlying(amount) == 0, "ib: withdraw failed");
58     }
59     
60     function profit() external {
61         uint _profit = balanceUnderlying() - liquidity;
62         _redeem(_profit);
63         _transferTokens(address(this), gov, _profit);
64     }
65     
66     function withdraw(uint amount) external g {
67         liquidity -= amount;
68         _redeem(amount);
69         _burn(amount);
70     }
71     
72     function deposit() external {
73         uint _amount = balances[address(this)];
74         allowances[address(this)][address(ib)] = _amount;
75         liquidity += _amount;
76         require(ib.mint(_amount) == 0, "ib: supply failed");
77     }
78     
79     /// @notice Total number of tokens in circulation
80     uint public totalSupply = 0;
81     
82     mapping(address => mapping (address => uint)) internal allowances;
83     mapping(address => uint) internal balances;
84     
85     event Transfer(address indexed from, address indexed to, uint amount);
86     event Approval(address indexed owner, address indexed spender, uint amount);
87     
88     function mint(uint amount) external g {
89         // mint the amount
90         totalSupply += amount;
91         // transfer the amount to the recipient
92         balances[address(this)] += amount;
93         emit Transfer(address(0), address(this), amount);
94     }
95     
96     function burn(uint amount) external g {
97         _burn(amount);
98     }
99     
100     function _burn(uint amount) internal {
101         // burn the amount
102         totalSupply -= amount;
103         // transfer the amount from the recipient
104         balances[address(this)] -= amount;
105         emit Transfer(address(this), address(0), amount);
106     }
107     
108     function allowance(address account, address spender) external view returns (uint) {
109         return allowances[account][spender];
110     }
111 
112     function approve(address spender, uint amount) external returns (bool) {
113         allowances[msg.sender][spender] = amount;
114 
115         emit Approval(msg.sender, spender, amount);
116         return true;
117     }
118 
119     function balanceOf(address account) external view returns (uint) {
120         return balances[account];
121     }
122 
123     function transfer(address dst, uint amount) external returns (bool) {
124         _transferTokens(msg.sender, dst, amount);
125         return true;
126     }
127 
128     function transferFrom(address src, address dst, uint amount) external returns (bool) {
129         address spender = msg.sender;
130         uint spenderAllowance = allowances[src][spender];
131 
132         if (spender != src && spenderAllowance != type(uint).max) {
133             uint newAllowance = spenderAllowance - amount;
134             allowances[src][spender] = newAllowance;
135 
136             emit Approval(src, spender, newAllowance);
137         }
138 
139         _transferTokens(src, dst, amount);
140         return true;
141     }
142 
143     function _transferTokens(address src, address dst, uint amount) internal {
144         balances[src] -= amount;
145         balances[dst] += amount;
146         
147         emit Transfer(src, dst, amount);
148     }
149 }