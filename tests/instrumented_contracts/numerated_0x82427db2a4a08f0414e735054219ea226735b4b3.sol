1 //  _____                     _   _             _         _             _          
2 //  \_   \_ ____   _____  ___| |_(_) __ _  __ _| |_ ___  /_\  _ __   __| |_ __ ___ 
3 //   / /\/ '_ \ \ / / _ \/ __| __| |/ _` |/ _` | __/ _ \//_\\| '_ \ / _` | '__/ _ \
4 ///\/ /_ | | | \ V /  __/\__ \ |_| | (_| | (_| | ||  __/  _  \ | | | (_| | | |  __/
5 //\____/ |_| |_|\_/ \___||___/\__|_|\__, |\__,_|\__\___\_/ \_/_| |_|\__,_|_|  \___|
6 //                                  |___/                                          
7 //___  _\_____  \ 
8 //\  \/ //  ____/ 
9 // \   //       \ 
10 //  \_/ \_______ \
11 //              \/
12 // Telegram: https://t.me/investigateandre
13 // Website: InvestigateAndreCronje.finance
14 // Twitter: https://twitter.com/AndreCronjeInv1
15 
16 //Disclaimer:We are not responsible for your investments and you take part in this game at your own risk. 
17 //Do not play with more than you can afford to lose. Keep it fun.
18 
19 
20 
21 
22 pragma solidity ^0.4.25;
23 
24 interface ERC20 {
25   function totalSupply() external view returns (uint256);
26   function balanceOf(address who) external view returns (uint256);
27   function allowance(address owner, address spender) external view returns (uint256);
28   function transfer(address to, uint256 value) external returns (bool);
29   function approve(address spender, uint256 value) external returns (bool);
30   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
31   function transferFrom(address from, address to, uint256 value) external returns (bool);
32 
33   event Transfer(address indexed from, address indexed to, uint256 value);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 interface ApproveAndCallFallBack {
38     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
39 }
40 
41 
42 contract IAC is ERC20 {
43   using SafeMath for uint256;
44 
45   mapping (address => uint256) private balances;
46   mapping (address => mapping (address => uint256)) private allowed;
47   string public constant name  = "Investigate Andre Cronje v2";
48   string public constant symbol = "IACv2";
49   uint8 public constant decimals = 18;
50   
51   address owner = msg.sender;
52 
53   uint256 _totalSupply = 1000 * (10 ** 18); 
54 
55   constructor() public {
56     balances[msg.sender] = _totalSupply;
57     emit Transfer(address(0), msg.sender, _totalSupply);
58   }
59 
60   function totalSupply() public view returns (uint256) {
61     return _totalSupply;
62   }
63 
64   function balanceOf(address player) public view returns (uint256) {
65     return balances[player];
66   }
67 
68   function allowance(address player, address spender) public view returns (uint256) {
69     return allowed[player][spender];
70   }
71 
72 
73   function transfer(address to, uint256 value) public returns (bool) {
74     require(value <= balances[msg.sender]);
75     require(to != address(0));
76 
77     balances[msg.sender] = balances[msg.sender].sub(value);
78     balances[to] = balances[to].add(value);
79 
80     emit Transfer(msg.sender, to, value);
81     return true;
82   }
83 
84   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
85     for (uint256 i = 0; i < receivers.length; i++) {
86       transfer(receivers[i], amounts[i]);
87     }
88   }
89 
90   function approve(address spender, uint256 value) public returns (bool) {
91     require(spender != address(0));
92     allowed[msg.sender][spender] = value;
93     emit Approval(msg.sender, spender, value);
94     return true;
95   }
96 
97   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
98         allowed[msg.sender][spender] = tokens;
99         emit Approval(msg.sender, spender, tokens);
100         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
101         return true;
102     }
103 
104   function transferFrom(address from, address to, uint256 value) public returns (bool) {
105     require(value <= balances[from]);
106     require(value <= allowed[from][msg.sender]);
107     require(to != address(0));
108     
109     balances[from] = balances[from].sub(value);
110     balances[to] = balances[to].add(value);
111     
112     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
113     
114     emit Transfer(from, to, value);
115     return true;
116   }
117 
118   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
119     require(spender != address(0));
120     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
121     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
122     return true;
123   }
124 
125   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
126     require(spender != address(0));
127     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
128     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
129     return true;
130   }
131 
132   function burn(uint256 amount) external {
133     require(amount != 0);
134     require(amount <= balances[msg.sender]);
135     _totalSupply = _totalSupply.sub(amount);
136     balances[msg.sender] = balances[msg.sender].sub(amount);
137     emit Transfer(msg.sender, address(0), amount);
138   }
139 }
140 
141 
142 
143 
144 library SafeMath {
145   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146     if (a == 0) {
147       return 0;
148     }
149     uint256 c = a * b;
150     require(c / a == b);
151     return c;
152   }
153 
154   function div(uint256 a, uint256 b) internal pure returns (uint256) {
155     uint256 c = a / b;
156     return c;
157   }
158 
159   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160     require(b <= a);
161     return a - b;
162   }
163 
164   function add(uint256 a, uint256 b) internal pure returns (uint256) {
165     uint256 c = a + b;
166     require(c >= a);
167     return c;
168   }
169 
170   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
171     uint256 c = add(a,m);
172     uint256 d = sub(c,1);
173     return mul(div(d,m),m);
174   }
175 }