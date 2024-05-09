1 pragma solidity >= 0.4.24 < 0.6.0;
2 
3 /**
4  * @title ONTO - Open News TOken
5  * @author JH Kwon
6  */
7 
8 /**
9  * @title ERC20 Standard Interface
10  */
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address who) external view returns (uint256);
14     function transfer(address to, uint256 value) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @title ONTO implementation
20  */
21 contract ONTO is IERC20 {
22     string public name = "Open News TOken";
23     string public symbol = "ONTO";
24     uint8 public decimals = 18;
25     
26     uint256 reserveAmount;
27     uint256 operationAmount;
28     uint256 marketingAmount;
29     uint256 advisorAmount;
30     uint256 pubAmount;
31 
32     uint256 teamYHJAmount;
33     uint256 teamLSHAmount;
34     uint256 teamPSHAmount;
35     uint256 teamKJHAmount;
36     uint256 teamPJMAmount;
37 
38 
39     uint256 _totalSupply;
40     mapping(address => uint256) balances;
41 
42     // Addresses
43     address public owner;
44     address public reserve;
45     address public operation;
46     address public marketing;
47     address public advisor;
48     address public pub;
49 
50     address public team_yhj;
51     address public team_lsh;
52     address public team_psh;
53     address public team_kjh;
54     address public team_pjm;
55 
56     modifier isOwner {
57         require(owner == msg.sender);
58         _;
59     }
60     
61     constructor() public {
62         owner = msg.sender;
63 
64         reserve = 0x19ec93c9C85AeE1a7Ecb149229FD96F43c9e62F2;
65         operation = 0x9488A81597Cb3851Cd150bf126B1FF215253Fbc2;
66         marketing = 0x01e6e9AB77c55Ec8892623B0b831816E4c389903;
67         advisor = 0xC74Bb0dcc90B4ADdb44f17C3861B60E95ceF9642;
68         pub = 0xEA2043f8152074d1Ab7a5ff9adB2b61F557087B4;
69         
70         team_yhj = 0x72574232614DAa27A6890D1a8781cAF97f1DAD82;
71         team_lsh = 0x405D01465Ca1209c154309Fb413E1e3A28a0d467;
72         team_psh = 0x95424Aa55E82671585b918FC6ee6ED70F3b2161B;
73         team_kjh = 0x0e916E614f1c2367BA8aE160b186AC03F2eE6D53;
74         team_pjm = 0x9E2E552D09f403489A33fdB1DF3Bcc112d0Ad9A3;
75 
76         reserveAmount     = toWei(1900000000);
77         operationAmount   = toWei(1250000000);
78         marketingAmount   = toWei( 500000000);
79         advisorAmount     = toWei( 250000000);
80         pubAmount         = toWei( 100000000);
81 
82         teamYHJAmount     = toWei( 725000000);
83         teamLSHAmount     = toWei(  12500000);
84         teamPSHAmount     = toWei(  12500000);
85         teamKJHAmount     = toWei( 125000000);
86         teamPJMAmount     = toWei( 125000000);
87 
88         _totalSupply      = toWei(5000000000);  //5,000,000,000
89 
90         require(_totalSupply == reserveAmount + operationAmount + marketingAmount + advisorAmount +  pubAmount + teamYHJAmount + teamLSHAmount + teamPSHAmount + teamKJHAmount + teamPJMAmount );
91         
92         balances[owner] = _totalSupply;
93 
94         emit Transfer(address(0), owner, balances[owner]);
95         
96         transfer(reserve, reserveAmount);
97         transfer(operation, operationAmount);
98         transfer(marketing, marketingAmount);
99         transfer(advisor, advisorAmount);
100         transfer(pub, pubAmount);
101 
102         transfer(team_yhj, teamYHJAmount);
103         transfer(team_lsh, teamLSHAmount);
104         transfer(team_psh, teamPSHAmount);
105         transfer(team_kjh, teamKJHAmount);
106         transfer(team_pjm, teamPJMAmount);
107 
108 
109         require(balances[owner] == 0);
110     }
111     
112     function totalSupply() public view returns (uint) {
113         return _totalSupply;
114     }
115 
116     function balanceOf(address who) public view returns (uint256) {
117         return balances[who];
118     }
119     
120     function transfer(address to, uint256 value) public returns (bool success) {
121         require(msg.sender != to);
122         require(to != owner);
123         require(value > 0);
124         
125         require( balances[msg.sender] >= value );
126         require( balances[to] + value >= balances[to] );    // prevent overflow
127 
128         if(msg.sender == team_yhj || msg.sender == team_lsh || msg.sender == team_psh || msg.sender == team_kjh || msg.sender == team_pjm) {
129             require(now >= 1604188800);     // 100% lock to 01-Nov-2020
130         }
131 
132         balances[msg.sender] -= value;
133         balances[to] += value;
134 
135         emit Transfer(msg.sender, to, value);
136         return true;
137     }
138     
139     function burnCoins(uint256 value) public {
140         require(balances[msg.sender] >= value);
141         require(_totalSupply >= value);
142         
143         balances[msg.sender] -= value;
144         _totalSupply -= value;
145 
146         emit Transfer(msg.sender, address(0), value);
147     }
148 
149     /** @dev Math function
150      */
151 
152     function toWei(uint256 value) private view returns (uint256) {
153         return value * (10 ** uint256(decimals));
154     }
155 }