1 pragma solidity ^0.4.25;
2 
3 contract ERC20 {
4     bytes32 public standard;
5     bytes32 public name;
6     bytes32 public symbol;
7     uint256 public totalSupply;
8     uint8 public decimals;
9     bool public allowTransactions;
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12     function transfer(address _to, uint256 _value) returns (bool success);
13     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
14     function approve(address _spender, uint256 _value) returns (bool success);
15     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
16 }
17 
18 
19 contract ExToke {
20 
21     string public name = "ExToke Token";
22     string public symbol = "XTE";
23     uint8 public decimals = 18;
24     
25     uint256 public crowdSaleSupply = 500000000  * (uint256(10) ** decimals);
26     uint256 public tokenSwapSupply = 3000000000 * (uint256(10) ** decimals);
27     uint256 public dividendSupply = 2400000000 * (uint256(10) ** decimals);
28     uint256 public totalSupply = 7000000000 * (uint256(10) ** decimals);
29 
30     mapping(address => uint256) public balanceOf;
31     
32     
33     address public oldAddress = 0x28925299Ee1EDd8Fd68316eAA64b651456694f0f;
34     address tokenAdmin = 0xEd86f5216BCAFDd85E5875d35463Aca60925bF16;
35     
36     uint256 public finishTime = 1548057600;
37     
38     uint256[] public releaseDates = 
39     [1543665600, 1546344000, 1549022400, 1551441600, 1554120000, 1556712000,
40     1559390400, 1561982400, 1564660800, 1567339200, 1569931200, 1572609600,
41     1575201600, 1577880000, 1580558400, 1583064000, 1585742400, 1588334400,
42     1591012800, 1593604800, 1596283200, 1598961600, 1601553600, 1604232000];
43     
44     uint256 public nextRelease = 0;
45 
46     function ExToke() public {
47         balanceOf[tokenAdmin] = 1100000000 * (uint256(10) ** decimals);
48     }
49 
50     uint256 public scaling = uint256(10) ** 8;
51 
52     mapping(address => uint256) public scaledDividendBalanceOf;
53 
54     uint256 public scaledDividendPerToken;
55 
56     mapping(address => uint256) public scaledDividendCreditedTo;
57 
58     function update(address account) internal {
59         if(nextRelease < 24 && block.timestamp > releaseDates[nextRelease]){
60             releaseDivTokens();
61         }
62         uint256 owed =
63             scaledDividendPerToken - scaledDividendCreditedTo[account];
64         scaledDividendBalanceOf[account] += balanceOf[account] * owed;
65         scaledDividendCreditedTo[account] = scaledDividendPerToken;
66         
67         
68     }
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 
73     mapping(address => mapping(address => uint256)) public allowance;
74 
75     function transfer(address to, uint256 value) public returns (bool success) {
76         require(balanceOf[msg.sender] >= value);
77 
78         update(msg.sender);
79         update(to);
80 
81         balanceOf[msg.sender] -= value;
82         balanceOf[to] += value;
83 
84         emit Transfer(msg.sender, to, value);
85         return true;
86     }
87 
88     function transferFrom(address from, address to, uint256 value)
89         public
90         returns (bool success)
91     {
92         require(value <= balanceOf[from]);
93         require(value <= allowance[from][msg.sender]);
94 
95         update(from);
96         update(to);
97 
98         balanceOf[from] -= value;
99         balanceOf[to] += value;
100         allowance[from][msg.sender] -= value;
101         emit Transfer(from, to, value);
102         return true;
103     }
104 
105     uint256 public scaledRemainder = 0;
106     
107     function() public payable{
108         tokenAdmin.transfer(msg.value);
109         if(finishTime >= block.timestamp && crowdSaleSupply >= msg.value * 100000){
110             balanceOf[msg.sender] += msg.value * 100000;
111             crowdSaleSupply -= msg.value * 100000;
112             
113         }
114         else if(finishTime < block.timestamp){
115             balanceOf[tokenAdmin] += crowdSaleSupply;
116             crowdSaleSupply = 0;
117         }
118     }
119 
120     function releaseDivTokens() public returns (bool success){
121         require(block.timestamp > releaseDates[nextRelease]);
122         uint256 releaseAmount = 100000000 * (uint256(10) ** decimals);
123         dividendSupply -= releaseAmount;
124         uint256 available = (releaseAmount * scaling) + scaledRemainder;
125         scaledDividendPerToken += available / totalSupply;
126         scaledRemainder = available % totalSupply;
127         nextRelease += 1;
128         return true;
129     }
130 
131     function withdraw() public returns (bool success){
132         update(msg.sender);
133         uint256 amount = scaledDividendBalanceOf[msg.sender] / scaling;
134         scaledDividendBalanceOf[msg.sender] %= scaling;  // retain the remainder
135         balanceOf[msg.sender] += amount;
136         return true;
137     }
138 
139     function approve(address spender, uint256 value)
140         public
141         returns (bool success)
142     {
143         allowance[msg.sender][spender] = value;
144         emit Approval(msg.sender, spender, value);
145         return true;
146     }
147     
148 
149     function swap(uint256 sendAmount) returns (bool success){
150         require(tokenSwapSupply >= sendAmount * 3);
151         if(ERC20(oldAddress).transferFrom(msg.sender, tokenAdmin, sendAmount)){
152             balanceOf[msg.sender] += sendAmount * 3;
153             tokenSwapSupply -= sendAmount * 3;
154         }
155         return true;
156     }
157 
158 }