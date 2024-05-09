1 //Symbol: UNFI
2 //Decimals: 18
3 //Total Supply: 4500
4 //Website: https://universefinance.tech/
5 
6 pragma solidity ^0.5.0;
7 
8 library SafeMath {
9   function add(uint256 a, uint256 b) internal pure returns (uint256) {
10       uint256 c = a + b;
11       require(c >= a);
12       return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16       require(b <= a);
17       uint256 c = a - b;
18       return c;
19   }
20 
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a / b;
32     return c;
33   }
34 
35   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
36     uint256 c = add(a,m);
37     uint256 d = sub(c,1);
38     return mul(div(d,m),m);
39   }
40 }
41 
42 contract ERC20 {
43   function totalSupply() public view returns (uint256);
44   function balanceOf(address holder) public view returns (uint256);
45   function allowance(address holder, address spender) public view returns (uint256);
46   function transfer(address to, uint256 amount) public returns (bool success);
47   function approve(address spender, uint256 amount) public returns (bool success);
48   function transferFrom(address from, address to, uint256 amount) public returns (bool success);
49 
50   event Transfer(address indexed from, address indexed to, uint256 amount);
51   event Approval(address indexed holder, address indexed spender, uint256 amount);
52 }
53 
54 contract UniverseFinance is ERC20 {
55 
56     using SafeMath for uint256;
57 
58     string public symbol = "UNFI";
59     string public name = "Universe Finance";
60     uint8 public decimals = 18;
61     uint256 private _totalSupply = 4500000000000000000000;
62     uint256 oneHundredPercent = 100;
63 
64     mapping(address => uint256) balances;
65     mapping(address => mapping(address => uint256)) allowed;
66 
67     constructor() public {
68         balances[msg.sender] = _totalSupply;
69         emit Transfer(address(0), msg.sender, _totalSupply);
70     }
71 
72     function totalSupply() public view returns (uint256) {
73       return _totalSupply;
74     }
75 
76     function balanceOf(address holder) public view returns (uint256) {
77         return balances[holder];
78     }
79 
80     function allowance(address holder, address spender) public view returns (uint256) {
81         return allowed[holder][spender];
82     }
83 
84     function findOnePercent(uint256 amount) private view returns (uint256)  {
85         uint256 roundAmount = amount.ceil(oneHundredPercent);
86         uint256 onePercent = roundAmount.mul(oneHundredPercent).div(10000);
87         return onePercent;
88     }
89 
90     function transfer(address to, uint256 amount) public returns (bool success) {
91       require(amount <= balances[msg.sender]);
92       require(to != address(0));
93 
94       uint256 tokensToBurn = findOnePercent(amount);
95       uint256 tokensToTransfer = amount.sub(tokensToBurn);
96 
97       balances[msg.sender] = balances[msg.sender].sub(amount);
98       balances[to] = balances[to].add(tokensToTransfer);
99 
100       _totalSupply = _totalSupply.sub(tokensToBurn);
101 
102       emit Transfer(msg.sender, to, tokensToTransfer);
103       emit Transfer(msg.sender, address(0), tokensToBurn);
104       return true;
105     }
106 
107     function approve(address spender, uint256 amount) public returns (bool success) {
108         allowed[msg.sender][spender] = amount;
109         emit Approval(msg.sender, spender, amount);
110         return true;
111     }
112 
113     function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
114       require(amount <= balances[from]);
115       require(amount <= allowed[from][msg.sender]);
116       require(to != address(0));
117 
118       balances[from] = balances[from].sub(amount);
119 
120       uint256 tokensToBurn = findOnePercent(amount);
121       uint256 tokensToTransfer = amount.sub(tokensToBurn);
122 
123       balances[to] = balances[to].add(tokensToTransfer);
124       _totalSupply = _totalSupply.sub(tokensToBurn);
125 
126       allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
127 
128       emit Transfer(from, to, tokensToTransfer);
129       emit Transfer(from, address(0), tokensToBurn);
130 
131       return true;
132     }
133 }