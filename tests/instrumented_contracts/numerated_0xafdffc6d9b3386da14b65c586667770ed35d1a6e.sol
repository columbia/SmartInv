1 pragma solidity ^0.4.25;
2 
3 contract Token {
4     function transfer(address to, uint tokens) public returns (bool success);
5 
6     function balanceOf(address tokenOwner) public constant returns (uint balance);
7 }
8 
9 contract EtherSnap {
10 
11     uint private units;
12     uint private bonus;
13 
14     address private owner;
15 
16     // Token specification
17     string public name = "EtherSnap";
18     string public symbol = "ETS";
19     uint public decimals = 18;
20 
21     uint private icoUnits; // ICO tokens
22     uint private tnbUnits; // Team & Bounty tokens
23 
24     mapping(address => uint) public balances;
25     mapping(address => uint) private contribution;
26     mapping(address => uint) private extra_tokens;
27     mapping(address => mapping(address => uint)) allowed;
28 
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31     event Contribute(address indexed account, uint ethereum, uint i, uint b, uint e, uint t, uint bp, uint ep);
32 
33     constructor () public {
34         owner = msg.sender;
35     }
36 
37     function totalSupply() public view returns (uint) {
38         return (icoUnits + tnbUnits) - balances[address(0)];
39     }
40 
41     function balanceOf(address tokenOwner) public view returns (uint balance) {
42         return balances[tokenOwner];
43     }
44 
45     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
46         return allowed[tokenOwner][spender];
47     }
48 
49     function transfer(address to, uint tokens) public returns (bool success) {
50         require(tokens > 0 && balances[msg.sender] >= tokens && balances[to] + tokens > balances[to]);
51         balances[to] += tokens;
52         balances[msg.sender] -= tokens;
53         emit Transfer(msg.sender, to, tokens);
54         return true;
55     }
56 
57     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
58         require(tokens > 0 && balances[from] >= tokens && allowed[from][msg.sender] >= tokens && balances[to] + tokens > balances[to]);
59         balances[to] += tokens;
60         balances[from] -= tokens;
61         allowed[from][msg.sender] -= tokens;
62         emit Transfer(from, to, tokens);
63         return true;
64     }
65 
66     function approve(address spender, uint tokens) public returns (bool success) {
67         allowed[msg.sender][spender] = tokens;
68         emit Approval(msg.sender, spender, tokens);
69         return true;
70     }
71 
72     function withdraw(address token) public returns (bool success) {
73         // Allow owner only
74         require(msg.sender == owner);
75         // Transfer ethereum balance
76         if (token == address(0)) {
77             msg.sender.transfer(address(this).balance);
78         }
79         // Transfer ERC-20 tokens to owner
80         else {
81             Token ERC20 = Token(token);
82             ERC20.transfer(owner, ERC20.balanceOf(address(this)));
83         }
84         return true;
85     }
86 
87     function setup(uint _bonus, uint _units) public returns (bool success) {
88         // Allow owner only
89         require(msg.sender == owner);
90         // Update ICO configuration
91         bonus = _bonus;
92         units = _units;
93         return true;
94     }
95 
96     function fill() public returns (bool success) {
97         // Allow owner only
98         require(msg.sender == owner);
99         // Calculate maximum tokens to redeem
100         uint maximum = 35 * (icoUnits / 65);
101         // Checkout availability to redeem
102         require(maximum > tnbUnits);
103         // Calculate available tokens
104         uint available = maximum - tnbUnits;
105         // Update database
106         tnbUnits += available;
107         balances[msg.sender] += available;
108         // Emit callbacks
109         emit Transfer(address(this), msg.sender, available);
110         return true;
111     }
112 
113     function contribute(address _acc, uint _wei) private returns (bool success) {
114         // Checkout ether and ICO state
115         require(_wei > 0 && units > 0);
116 
117         // Calculate initial tokens for contribution
118         uint iTokens = _wei * units;
119 
120         // Calculate bonus tokens
121         uint bTokens = bonus > 0 ? ((iTokens * bonus) / 100) : 0;
122 
123         // Update contribution
124         uint total = contribution[_acc] + _wei;
125         contribution[_acc] = total;
126 
127         // Calculate extra bonus percentage for contribution
128         uint extra = (total / 5 ether) * 10;
129         extra = extra > 50 ? 50 : extra;
130 
131         // Calculate tokens for extra bonus percentage
132         uint eTokens = extra > 0 ? (((total * units) * extra) / 100) : 0;
133 
134         // Remove already claimed extra tokens
135         uint cTokens = extra_tokens[_acc];
136         if (eTokens > cTokens) {
137             eTokens -= cTokens;
138         } else {
139             eTokens = 0;
140         }
141 
142         // Calculate sum of total tokens
143         uint tTokens = iTokens + bTokens + eTokens;
144 
145         // Update user balance and database
146         icoUnits += tTokens;
147         balances[_acc] += tTokens;
148         extra_tokens[_acc] += eTokens;
149 
150         // Emit callbacks
151         emit Transfer(address(this), _acc, tTokens);
152         emit Contribute(_acc, _wei, iTokens, bTokens, eTokens, tTokens, bonus, extra);
153 
154         return true;
155     }
156 
157     function mint(address account, uint amount) public returns (bool success) {
158         // Allow owner only
159         require(msg.sender == owner);
160         // Execute contribute method
161         return contribute(account, amount);
162     }
163 
164     function() public payable {
165         contribute(msg.sender, msg.value);
166     }
167 }