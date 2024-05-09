1 pragma solidity ^0.5.1;
2 
3 contract SC {
4     address public owner;
5     string public symbol;
6     string public name;
7     uint8 public decimals = 10;
8     uint tokenSupply = 0;
9     bool public paused = false;
10     uint[7] milestones = [200000000000000000,700000000000000000,1300000000000000000,1600000000000000000,1800000000000000000,1900000000000000000,2000000000000000000];
11     uint[7] conversion = [8125000,5078100,1103800,380800,114600,31300,15600];
12     mapping(address => uint) balances;
13     mapping(address => mapping(address => uint)) allowed;
14 
15     modifier notPaused {
16         require(paused == false);
17         _;
18     }
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     event Transfer(address indexed from, address indexed to, uint tokens);
25     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
26     event Pause();
27     event UnPause();
28     event Burn(uint amount);
29     event Mint(uint amount);
30 
31     constructor(string memory _name) public {
32         owner = msg.sender;
33         balances[msg.sender] = 0;
34         symbol = _name;
35         name = _name;
36 
37     }
38 
39     function safeAdd(uint a, uint b) public pure returns (uint c) {
40         c = a + b;
41         require(c >= a);
42     }
43 
44     function safeSub(uint a, uint b) public pure returns (uint c) {
45         require(b <= a);
46         c = a - b;
47     }
48 
49     function safeMul(uint a, uint b) public pure returns (uint c) {
50         c = a * b;
51         require(a == 0 || c / a == b);
52     }
53 
54     function safeDiv(uint a, uint b) public pure returns (uint c) {
55         require(b > 0);
56         c = a / b;
57     }
58 
59     function burn(uint amount) public onlyOwner {
60         if (balances[owner] < amount) revert();
61         balances[owner] = safeSub(balances[owner], amount);
62         tokenSupply = safeSub(tokenSupply, amount);
63         emit Burn(amount);
64     }
65 
66     function mintFromTraded(uint tradedAmount) public onlyOwner returns (uint minted) {
67         uint toMint = 0;
68         uint ts = tokenSupply;
69 
70         for (uint8 ml = 0; ml <= 6; ml++) {
71             if (ts >= milestones[ml]) {
72                 continue;
73             }
74             if (ts + tradedAmount * conversion[ml] < milestones[ml]) {
75                 toMint += tradedAmount * conversion[ml];
76                 ts += tradedAmount * conversion[ml];
77                 tradedAmount = 0;
78                 break;
79             }
80             uint diff = (milestones[ml] - ts) / conversion[ml];
81             tradedAmount -= diff;
82             toMint += milestones[ml] - ts;
83             ts = milestones[ml];
84         }
85         if (tradedAmount > 0) {
86             toMint += tradedAmount * conversion[6];
87             ts += tradedAmount * conversion[6];
88         }
89 
90         tokenSupply = ts;
91         balances[owner] = safeAdd(balances[owner], toMint);
92         emit Mint(toMint);
93 
94         return toMint;
95     }
96 
97     function totalSupply() public view returns (uint) {
98         return tokenSupply;
99     }
100 
101     function balanceOf(address tokenOwner) public view returns (uint balance) {
102         return balances[tokenOwner];
103     }
104 
105     function transfer(address to, uint tokens) public notPaused returns (bool success) {
106         if (tokens <= 0) revert();
107         if (to == address(0)) revert();
108         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         emit Transfer(msg.sender, to, tokens);
111         return true;
112     }
113 
114     function approve(address spender, uint tokens) public notPaused returns (bool success) {
115         allowed[msg.sender][spender] = tokens;
116         emit Approval(msg.sender, spender, tokens);
117         return true;
118     }
119 
120     function transferFrom(address from, address to, uint tokens) public notPaused returns (bool success) {
121         balances[from] = safeSub(balances[from], tokens);
122         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
123         balances[to] = safeAdd(balances[to], tokens);
124         emit Transfer(from, to, tokens);
125         return true;
126     }
127 
128     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
129         return allowed[tokenOwner][spender];
130     }
131 
132     function etherBalance() public view onlyOwner returns (uint balance) {
133         return address(this).balance;
134     }
135 
136     function sendEther(uint amount, address payable to) public onlyOwner {
137         to.transfer(amount);
138     }
139 
140     function pause() public notPaused onlyOwner {
141         paused = true;
142         emit Pause();
143     }
144 
145     function unPause() public onlyOwner {
146         if (paused == false) revert();
147         paused = false;
148         emit UnPause();
149     }
150 
151     function() external payable {}
152 }