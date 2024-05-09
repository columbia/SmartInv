1 /**
2  *This is the only live Ace Wins Contract. The previous contract is not used any longer. ACW is the new ticker. The old ticker ACE is no longer in use.
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 
8 contract Ownable {
9     
10     address public owner;
11 
12     function Ownable() public {
13         owner = msg.sender;
14     }
15     
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22 }
23 
24 
25 contract AceWins is Ownable {
26     
27     uint256 public totalSupply;
28     mapping(address => uint256) startBalances;
29     mapping(address => mapping(address => uint256)) allowed;
30     mapping(address => uint256) startBlocks;
31     
32     string public constant name = "Ace Wins";
33     string public constant symbol = "ACW";
34     uint32 public constant decimals = 10;
35     uint256 public calc = 951839;
36 
37     function AceWins() public {
38         totalSupply = 12500000 * 10**uint256(decimals);
39         startBalances[owner] = totalSupply;
40         startBlocks[owner] = block.number;
41         Transfer(address(0), owner, totalSupply);
42     }
43 
44 
45     function fracExp(uint256 k, uint256 q, uint256 n, uint256 p) pure public returns (uint256) {
46         uint256 s = 0;
47         uint256 N = 1;
48         uint256 B = 1;
49         for (uint256 i = 0; i < p; ++i) {
50             s += k * N / B / (q**i);
51             N = N * (n-i);
52             B = B * (i+1);
53         }
54         return s;
55     }
56 
57 
58     function compoundInterest(address tokenOwner) view public returns (uint256) {
59         require(startBlocks[tokenOwner] > 0);
60         uint256 start = startBlocks[tokenOwner];
61         uint256 current = block.number;
62         uint256 blockCount = current - start;
63         uint256 balance = startBalances[tokenOwner];
64         return fracExp(balance, calc, blockCount, 8) - balance;
65     }
66 
67 
68     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
69         return startBalances[tokenOwner] + compoundInterest(tokenOwner);
70     }
71 
72     
73 
74     function updateBalance(address tokenOwner) private {
75         if (startBlocks[tokenOwner] == 0) {
76             startBlocks[tokenOwner] = block.number;
77         }
78         uint256 ci = compoundInterest(tokenOwner);
79         startBalances[tokenOwner] = startBalances[tokenOwner] + ci;
80         totalSupply = totalSupply + ci;
81         startBlocks[tokenOwner] = block.number;
82     }
83     
84 
85  
86     function transfer(address to, uint256 tokens) returns (bool success) {
87         updateBalance(msg.sender);
88         updateBalance(to);
89         require(tokens <= startBalances[msg.sender]);
90 
91         startBalances[msg.sender] = startBalances[msg.sender] - tokens;
92         startBalances[to] = startBalances[to] + tokens;
93         Transfer(msg.sender, to, tokens);
94         return true;
95     }
96 
97     function transferFrom(address from, address to, uint256 tokens) returns (bool success) {
98         updateBalance(from);
99         updateBalance(to);
100         if (startBalances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0) {
101             startBalances[to] = startBalances[to] + tokens;
102             startBalances[from] = startBalances[from] - tokens;
103             allowed[from][msg.sender] -= tokens;
104             Transfer(from, to, tokens);
105             return true;
106         } else { return false; }
107     }
108 
109     
110 
111    
112      function setCalc(uint256 _Calc) public {
113       require(msg.sender==owner);
114       calc = _Calc;
115     }
116     
117      
118     function approve(address spender, uint256 tokens) public returns (bool) {
119         allowed[msg.sender][spender] = tokens;
120         Approval(msg.sender, spender, tokens);
121         return true;
122     } 
123     
124 
125     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
126         return allowed[tokenOwner][spender];
127     }
128    
129     event Transfer(address indexed from, address indexed to, uint256 tokens);
130     event Approval(address indexed owner, address indexed spender, uint256 tokens);
131     
132 }