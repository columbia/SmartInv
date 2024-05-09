1 //    .::::::::::.        -(_)====u         .::::::::::.
2 //    .::::''''''::::.                      .::::''''''::::.
3 //  .:::'          `::::....          ....::::'          `:::.
4 // .::'             `:::::::|        |:::::::'             `::.
5 //.::|               |::::::|_ ___ __|::::::|               |::.
6 //`--'               |::::::|_()__()_|::::::|               `--'
7 // :::               |::-o::|        |::o-::|               :::
8 // `::.             .|::::::|        |::::::|.             .::'
9 //  `:::.          .::\-----'        `-----/::.          .:::'
10 //    `::::......::::'                      `::::......::::'
11 //      `::::::::::'                          `::::::::::'
12 //  _____                     _   _             _         _             _          
13 //  \_   \_ ____   _____  ___| |_(_) __ _  __ _| |_ ___  /_\  _ __   __| |_ __ ___ 
14 //   / /\/ '_ \ \ / / _ \/ __| __| |/ _` |/ _` | __/ _ \//_\\| '_ \ / _` | '__/ _ \
15 ///\/ /_ | | | \ V /  __/\__ \ |_| | (_| | (_| | ||  __/  _  \ | | | (_| | | |  __/
16 //\____/ |_| |_|\_/ \___||___/\__|_|\__, |\__,_|\__\___\_/ \_/_| |_|\__,_|_|  \___|
17 //                                  |___/                                          
18 
19 // Telegram: t.me/
20 // Website: InvestigateAndreCronje.finance
21 // Twitter: https://twitter.com/AndreCronjeInv1
22 
23 
24 
25 
26 pragma solidity ^0.4.25;
27 
28 interface ERC20 {
29   function totalSupply() external view returns (uint256);
30   function balanceOf(address who) external view returns (uint256);
31   function allowance(address owner, address spender) external view returns (uint256);
32   function transfer(address to, uint256 value) external returns (bool);
33   function approve(address spender, uint256 value) external returns (bool);
34   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
35   function transferFrom(address from, address to, uint256 value) external returns (bool);
36 
37   event Transfer(address indexed from, address indexed to, uint256 value);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 interface ApproveAndCallFallBack {
42     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
43 }
44 
45 
46 contract IAC is ERC20 {
47   using SafeMath for uint256;
48 
49   mapping (address => uint256) private balances;
50   mapping (address => mapping (address => uint256)) private allowed;
51   string public constant name  = "Investigate Andre Cronje";
52   string public constant symbol = "IAC";
53   uint8 public constant decimals = 18;
54   
55   address owner = msg.sender;
56 
57   uint256 _totalSupply = 3000 * (10 ** 18); 
58 
59   constructor() public {
60     balances[msg.sender] = _totalSupply;
61     emit Transfer(address(0), msg.sender, _totalSupply);
62   }
63 
64   function totalSupply() public view returns (uint256) {
65     return _totalSupply;
66   }
67 
68   function balanceOf(address player) public view returns (uint256) {
69     return balances[player];
70   }
71 
72   function allowance(address player, address spender) public view returns (uint256) {
73     return allowed[player][spender];
74   }
75 
76 
77   function transfer(address to, uint256 value) public returns (bool) {
78     require(value <= balances[msg.sender]);
79     require(to != address(0));
80 
81     balances[msg.sender] = balances[msg.sender].sub(value);
82     balances[to] = balances[to].add(value);
83 
84     emit Transfer(msg.sender, to, value);
85     return true;
86   }
87 
88   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
89     for (uint256 i = 0; i < receivers.length; i++) {
90       transfer(receivers[i], amounts[i]);
91     }
92   }
93 
94   function approve(address spender, uint256 value) public returns (bool) {
95     require(spender != address(0));
96     allowed[msg.sender][spender] = value;
97     emit Approval(msg.sender, spender, value);
98     return true;
99   }
100 
101   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
102         allowed[msg.sender][spender] = tokens;
103         emit Approval(msg.sender, spender, tokens);
104         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
105         return true;
106     }
107 
108   function transferFrom(address from, address to, uint256 value) public returns (bool) {
109     require(value <= balances[from]);
110     require(value <= allowed[from][msg.sender]);
111     require(to != address(0));
112     
113     balances[from] = balances[from].sub(value);
114     balances[to] = balances[to].add(value);
115     
116     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
117     
118     emit Transfer(from, to, value);
119     return true;
120   }
121 
122   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
123     require(spender != address(0));
124     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
125     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
126     return true;
127   }
128 
129   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
130     require(spender != address(0));
131     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
132     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
133     return true;
134   }
135 
136   function burn(uint256 amount) external {
137     require(amount != 0);
138     require(amount <= balances[msg.sender]);
139     _totalSupply = _totalSupply.sub(amount);
140     balances[msg.sender] = balances[msg.sender].sub(amount);
141     emit Transfer(msg.sender, address(0), amount);
142   }
143 }
144 
145 
146 
147 
148 library SafeMath {
149   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150     if (a == 0) {
151       return 0;
152     }
153     uint256 c = a * b;
154     require(c / a == b);
155     return c;
156   }
157 
158   function div(uint256 a, uint256 b) internal pure returns (uint256) {
159     uint256 c = a / b;
160     return c;
161   }
162 
163   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164     require(b <= a);
165     return a - b;
166   }
167 
168   function add(uint256 a, uint256 b) internal pure returns (uint256) {
169     uint256 c = a + b;
170     require(c >= a);
171     return c;
172   }
173 
174   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
175     uint256 c = add(a,m);
176     uint256 d = sub(c,1);
177     return mul(div(d,m),m);
178   }
179 }