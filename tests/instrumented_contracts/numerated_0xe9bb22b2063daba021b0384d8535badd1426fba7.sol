1 /*
2       https://pyrabank.com
3       "relax and divs"
4 */
5 pragma solidity >=0.6.2;
6  
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9   function balanceOf(address who) external view returns (uint256);
10   function allowance(address owner, address spender) external view returns (uint256);
11   function transfer(address to, uint256 value) external returns (bool);
12   function approve(address spender, uint256 value) external returns (bool);
13   function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
14   function transferFrom(address from, address to, uint256 value) external returns (bool);
15  
16   event Transfer(address indexed from, address indexed to, uint256 value);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19  
20 interface ApproveAndCallFallBack {
21     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
22 }
23  
24  
25 contract Private is IERC20 {
26   using SafeMath for uint256;
27  
28   mapping (address => uint256) private balances;
29   mapping (address => mapping (address => uint256)) private allowed;
30   string public constant name  = "Pyrabank Private";
31   string public constant symbol = "PBPRV";
32   uint8 public constant decimals = 18;
33   bool public isBootStrapped = false;
34  
35   address public owner = msg.sender;
36  
37   address[15] ambassadorList = [
38     0x5138240E96360ad64010C27eB0c685A8b2eDE4F2,
39     0x9D7a76fD386eDEB3A871c3A096Ca875aDc1a55b7,
40     0x90D20d17Cc9e07020bB490c5e34f486286d3Eeb2,
41     0xAA7A7C2DECB180f68F11E975e6D92B5Dc06083A6,
42     0xF8be37CF74A05B96Ca40e7998B08f237f0f8b80b,
43     0xb7159F2a8380c8c84a6664916B59B1588670E6ec,
44     0x818F1B08E38376E9635C5bE156B8786317e833b3,
45     0x7D10f0fa8aB734328718212f21Aa8018CCcEd0f4,
46     0x15938D852a889f2f955aA74182Ebb64D3B148242,
47     0x39E00115d71313fD5983DE3Cf2b5820dd3Cc4447,
48     0xEe54D208f62368B4efFe176CB548A317dcAe963F,
49     0xeef3ADc384017E09bad1b5422aBaf7544555fee9,
50     0x43678bB266e75F50Fbe5927128Ab51930b447eaB,
51     0xD0A18Fd109F116c7bdb431d07aD6722d5A59F449,
52     0x09a054B60bd3B908791B55eEE81b515B93831E99
53   ];
54   address marketingAccount = 0xf160BCDA554662f4E66fc1Bf8FcAf385E8e5da4d;
55 
56   uint256 _totalSupply = 20000000000 * (10 ** 18); // 20 billion supply
57 
58   /**
59    * @dev Bootstrap the supply distribution and fund the UniswapV2 liquidity pool
60    */
61   function bootstrap() external returns (bool){
62 
63 
64       require(isBootStrapped == false, 'Require unintialized token');
65       require(msg.sender == owner, 'Require ownership');
66 
67       //Distribute tokens
68       uint256 premineAmount = 100000000 * (10 ** 18); //100 mil per preminer
69       uint256 marketingAmount = 1000000000 * (10 ** 18); // 1 bil for marketing
70 
71       balances[marketingAccount] = marketingAmount;
72       emit Transfer(address(0), marketingAccount, marketingAmount);
73 
74 
75       for (uint256 i = 0; i < 15; i++) {
76         balances[ambassadorList[i]] = premineAmount;
77         emit Transfer(address(0), ambassadorList[i], balances[ambassadorList[i]]);
78       }
79       balances[owner] = _totalSupply.sub(marketingAmount + 15 * premineAmount);
80 
81       emit Transfer(address(0), owner, balances[owner]);
82 
83       isBootStrapped = true;
84 
85       return isBootStrapped;
86 
87   }
88  
89   function totalSupply() public override view returns (uint256) {
90     return _totalSupply;
91   }
92  
93   function balanceOf(address player) public override view returns (uint256) {
94     return balances[player];
95   }
96  
97   function allowance(address player, address spender) public override view returns (uint256) {
98     return allowed[player][spender];
99   }
100  
101  
102   function transfer(address to, uint256 value) public override returns (bool) {
103     require(value <= balances[msg.sender]);
104     require(to != address(0));
105  
106     balances[msg.sender] = balances[msg.sender].sub(value);
107     balances[to] = balances[to].add(value);
108  
109     emit Transfer(msg.sender, to, value);
110     return true;
111   }
112  
113   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
114     for (uint256 i = 0; i < receivers.length; i++) {
115       transfer(receivers[i], amounts[i]);
116     }
117   }
118  
119   function approve(address spender, uint256 value) override public returns (bool) {
120     require(spender != address(0));
121     allowed[msg.sender][spender] = value;
122     emit Approval(msg.sender, spender, value);
123     return true;
124   }
125  
126   function approveAndCall(address spender, uint256 tokens, bytes calldata data) override external returns (bool) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
130         return true;
131     }
132  
133   function transferFrom(address from, address to, uint256 value) override public returns (bool) {
134     require(value <= balances[from]);
135     require(value <= allowed[from][msg.sender]);
136     require(to != address(0));
137  
138     balances[from] = balances[from].sub(value);
139     balances[to] = balances[to].add(value);
140  
141     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
142  
143     emit Transfer(from, to, value);
144     return true;
145   }
146  
147   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
148     require(spender != address(0));
149     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
150     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
151     return true;
152   }
153  
154   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
155     require(spender != address(0));
156     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
157     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
158     return true;
159   }
160  
161   function burn(uint256 amount) external {
162     require(amount != 0);
163     require(amount <= balances[msg.sender]);
164     _totalSupply = _totalSupply.sub(amount);
165     balances[msg.sender] = balances[msg.sender].sub(amount);
166     emit Transfer(msg.sender, address(0), amount);
167   }
168  
169 }
170  
171  
172  
173 library SafeMath {
174   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175     if (a == 0) {
176       return 0;
177     }
178     uint256 c = a * b;
179     require(c / a == b);
180     return c;
181   }
182  
183   function div(uint256 a, uint256 b) internal pure returns (uint256) {
184     uint256 c = a / b;
185     return c;
186   }
187  
188   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189     require(b <= a);
190     return a - b;
191   }
192  
193   function add(uint256 a, uint256 b) internal pure returns (uint256) {
194     uint256 c = a + b;
195     require(c >= a);
196     return c;
197   }
198  
199   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
200     uint256 c = add(a,m);
201     uint256 d = sub(c,1);
202     return mul(div(d,m),m);
203   }
204 }