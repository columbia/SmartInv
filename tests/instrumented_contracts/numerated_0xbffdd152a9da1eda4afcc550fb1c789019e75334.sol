1 pragma solidity ^0.4.16;
2 
3 
4 contract Ownable {
5     
6     address public owner;
7 
8     function Ownable() public {
9         owner = msg.sender;
10     }
11     
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18 }
19 
20 
21 contract AceWins is Ownable {
22     
23     uint256 public totalSupply;
24     mapping(address => uint256) startBalances;
25     mapping(address => mapping(address => uint256)) allowed;
26     mapping(address => uint256) startBlocks;
27     
28     string public constant name = "Ace Wins";
29     string public constant symbol = "ACE";
30     uint32 public constant decimals = 10;
31     uint256 public calc = 951839;
32 
33     function AceWins() public {
34         totalSupply = 9000000 * 10**uint256(decimals);
35         startBalances[owner] = totalSupply;
36         startBlocks[owner] = block.number;
37         Transfer(address(0), owner, totalSupply);
38     }
39 
40 
41     function fracExp(uint256 k, uint256 q, uint256 n, uint256 p) pure public returns (uint256) {
42         uint256 s = 0;
43         uint256 N = 1;
44         uint256 B = 1;
45         for (uint256 i = 0; i < p; ++i) {
46             s += k * N / B / (q**i);
47             N = N * (n-i);
48             B = B * (i+1);
49         }
50         return s;
51     }
52 
53 
54     function compoundInterest(address tokenOwner) view public returns (uint256) {
55         require(startBlocks[tokenOwner] > 0);
56         uint256 start = startBlocks[tokenOwner];
57         uint256 current = block.number;
58         uint256 blockCount = current - start;
59         uint256 balance = startBalances[tokenOwner];
60         return fracExp(balance, calc, blockCount, 8) - balance;
61     }
62 
63 
64     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
65         return startBalances[tokenOwner] + compoundInterest(tokenOwner);
66     }
67 
68     
69 
70     function updateBalance(address tokenOwner) private {
71         if (startBlocks[tokenOwner] == 0) {
72             startBlocks[tokenOwner] = block.number;
73         }
74         uint256 ci = compoundInterest(tokenOwner);
75         startBalances[tokenOwner] = startBalances[tokenOwner] + ci;
76         totalSupply = totalSupply + ci;
77         startBlocks[tokenOwner] = block.number;
78     }
79     
80 
81  
82     function transfer(address to, uint256 tokens) public returns (bool) {
83         updateBalance(msg.sender);
84         updateBalance(to);
85         require(tokens <= startBalances[msg.sender]);
86 
87         startBalances[msg.sender] = startBalances[msg.sender] - tokens;
88         startBalances[to] = startBalances[to] + tokens;
89         Transfer(msg.sender, to, tokens);
90         return true;
91     }
92 
93 
94     function transferFrom(address from, address to, uint256 tokens) public returns (bool) {
95         updateBalance(from);
96         updateBalance(to);
97         require(tokens <= startBalances[from]);
98 
99         startBalances[from] = startBalances[from] - tokens;
100         allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
101         startBalances[to] = startBalances[to] + tokens;
102         Transfer(from, to, tokens);
103         return true;
104     }
105 
106    
107      function setCalc(uint256 _Calc) public {
108       require(msg.sender==owner);
109       calc = _Calc;
110     } 
111      
112     function approve(address spender, uint256 tokens) public returns (bool) {
113         allowed[msg.sender][spender] = tokens;
114         Approval(msg.sender, spender, tokens);
115         return true;
116     }
117 
118     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
119         return allowed[tokenOwner][spender];
120     }
121    
122     event Transfer(address indexed from, address indexed to, uint256 tokens);
123 
124     event Approval(address indexed owner, address indexed spender, uint256 tokens);
125 
126 }