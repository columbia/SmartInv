1 pragma solidity 0.5.8;
2 
3 /**
4  *
5  * SOLD TOO EARLY $REEE AAaaAAaaAAAaAAAAaAAAAaAAaAaAaAaAAaaAaAaaAAAaAaAaAAAAaAaAaAAAAaAaAaAAAAaaAAAAAaAaAaAaAAAAaAaAaAAaAaAAAAaA
6  * 
7  * WEBSITE: soldearly.gg
8  * TWITTER: twitter.com/soldearlygg
9  * TG: t.me/soldearly
10  *
11  */
12 
13 
14 interface ERC20 {
15   function totalSupply() external view returns (uint256);
16   function balanceOf(address who) external view returns (uint256);
17   function allowance(address owner, address spender) external view returns (uint256);
18   function transfer(address to, uint256 value) external returns (bool);
19   function approve(address spender, uint256 value) external returns (bool);
20   function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22   event Transfer(address indexed from, address indexed to, uint256 value);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract SOLD_EARLY is ERC20 {
27     using SafeMath for uint256;
28 
29     mapping (address => uint256) private balances;
30     mapping (address => mapping (address => uint256)) private allowed;
31     mapping(address => psale) private burns;
32 
33     string public constant name  = "SOLD EARLY";
34     string public constant symbol = "REEE";
35     uint8 public constant decimals = 18;
36     uint256 constant MAX_SUPPLY = 200000000000 * (10 ** 18);
37 
38     struct psale {
39         uint256 amountBurnt;
40         uint256 unlockTime;
41     }
42 
43     constructor() public {
44         balances[address(this)] = MAX_SUPPLY;
45         emit Transfer(address(0), address(this), MAX_SUPPLY);
46         transferInternal(address(this), msg.sender, MAX_SUPPLY - 69420000000 * (10 ** 18));
47     }
48 
49     function totalSupply() public view returns (uint256) {
50         return MAX_SUPPLY;
51     }
52 
53     function balanceOf(address player) public view returns (uint256) {
54         return balances[player];
55     }
56 
57     function allowance(address player, address spender) public view returns (uint256) {
58         return allowed[player][spender];
59     }
60 
61     function transfer(address to, uint256 amount) public returns (bool) {
62         require(to != address(0));
63         transferInternal(msg.sender, to, amount);
64         return true;
65     }
66 
67     function transferFrom(address from, address to, uint256 amount) public returns (bool) {
68         require(to != address(0));
69         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
70         transferInternal(from, to, amount);
71         return true;
72     }
73 
74     function transferInternal(address from, address to, uint256 amount) internal {
75         balances[from] = balances[from].sub(amount);
76         balances[to] = balances[to].add(amount);
77         emit Transfer(from, to, amount);
78     }
79 
80     function approve(address spender, uint256 value) public returns (bool) {
81         require(spender != address(0));
82         allowed[msg.sender][spender] = value;
83         emit Approval(msg.sender, spender, value);
84         return true;
85     }
86 
87 
88     // Can burn PSALE token to claim $REEE 1:1 after 12 hours, must hold some $REEE strong hands only!
89     function burnPSALE(uint256 amount) external {
90       require(balances[msg.sender] > 0); // MUST BE $REEE BULL
91       require(burns[msg.sender].unlockTime == 0);
92       ERC20 psaleToken = ERC20(0xBAcaCD83b68C92Ae07eF382d0c0277D1Bd1c7C4D);
93       psaleToken.transferFrom(msg.sender, address(0x000000000000000000000000000000000000dEaD), amount);
94       burns[msg.sender] = psale(amount, now + 12 hours);
95     }
96 
97     function claimPSALE() external {
98       psale memory burnt = burns[msg.sender];
99       require(burnt.unlockTime < now);
100       transferInternal(address(this), msg.sender, burnt.amountBurnt);
101       delete burns[msg.sender];
102     }
103 
104 }
105 
106 
107 library SafeMath {
108   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109     if (a == 0) {
110       return 0;
111     }
112     uint256 c = a * b;
113     require(c / a == b);
114     return c;
115   }
116 
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     uint256 c = a / b;
119     return c;
120   }
121 
122   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123     require(b <= a);
124     return a - b;
125   }
126 
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     require(c >= a);
130     return c;
131   }
132 
133   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
134     uint256 c = add(a,m);
135     uint256 d = sub(c,1);
136     return mul(div(d,m),m);
137   }
138 }