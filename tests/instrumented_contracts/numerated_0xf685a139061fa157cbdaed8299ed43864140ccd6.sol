1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * World War Goo - Competitive Idle Game
6  * 
7  * https://ethergoo.io
8  * 
9  */
10 
11 interface ERC20 {
12     function totalSupply() external constant returns (uint);
13     function balanceOf(address tokenOwner) external constant returns (uint balance);
14     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
15     function transfer(address to, uint tokens) external returns (bool success);
16     function approve(address spender, uint tokens) external returns (bool success);
17     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
18     function transferFrom(address from, address to, uint tokens) external returns (bool success);
19 
20     event Transfer(address indexed from, address indexed to, uint tokens);
21     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
22 }
23 
24 contract PremiumUnit {
25     function mintUnit(address player, uint256 amount) external;
26     function equipUnit(address player, uint80 amount, uint8 chosenPosition) external;
27     uint256 public unitId;
28     uint256 public unitProductionSeconds;
29 }
30 
31 contract NinjaKittyUnit is ERC20, PremiumUnit {
32     using SafeMath for uint;
33     
34     string public constant name = "WWG Premium Unit - NINJA";
35     string public constant symbol = "NINJA";
36     uint256 public constant unitId = 25;
37     uint256 public unitProductionSeconds = 86400; // Num seconds for factory to produce a single unit
38     uint8 public constant decimals = 0;
39     
40     Units constant units = Units(0xf936AA9e1f22C915Abf4A66a5a6e94eb8716BA5e);
41     address constant factories = 0xC767B1CEc507f1584469E8efE1a94AD4c75e02ed;
42     
43     mapping(address => uint256) balances;
44     mapping(address => uint256) lastEquipTime;
45     mapping(address => mapping(address => uint256)) allowed;
46     uint256 public totalSupply;
47     
48     function totalSupply() external view returns (uint) {
49         return totalSupply.sub(balances[address(0)]);
50     }
51     
52     function balanceOf(address tokenOwner) external view returns (uint256) {
53         return balances[tokenOwner];
54     }
55     
56     function transfer(address to, uint tokens) external returns (bool) {
57         balances[msg.sender] = balances[msg.sender].sub(tokens);
58         balances[to] = balances[to].add(tokens);
59         emit Transfer(msg.sender, to, tokens);
60         return true;
61     }
62     
63     function transferFrom(address from, address to, uint tokens) external returns (bool) {
64         balances[from] = balances[from].sub(tokens);
65         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
66         balances[to] = balances[to].add(tokens);
67         emit Transfer(from, to, tokens);
68         return true;
69     }
70     
71     function approve(address spender, uint tokens) external returns (bool) {
72         allowed[msg.sender][spender] = tokens;
73         emit Approval(msg.sender, spender, tokens);
74         return true;
75     }
76     
77     function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
78         allowed[msg.sender][spender] = tokens;
79         emit Approval(msg.sender, spender, tokens);
80         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
81         return true;
82     }
83     
84     function allowance(address tokenOwner, address spender) external view returns (uint256) {
85         return allowed[tokenOwner][spender];
86     }
87     
88     function mintUnit(address player, uint256 amount) external {
89         require(msg.sender == factories);
90         balances[player] += amount;
91         totalSupply += amount;
92         emit Transfer(address(0), player, amount);
93     }
94     
95     function equipUnit(address player, uint80 amount, uint8 chosenPosition) external {
96         require(msg.sender == player || msg.sender == factories);
97         units.mintUnitExternal(unitId, amount, player, chosenPosition);
98         
99         // Burn token
100         balances[player] = balances[player].sub(amount);
101         lastEquipTime[player] = now;
102         totalSupply = totalSupply.sub(amount);
103         emit Transfer(player, address(0), amount);
104     }
105     
106     function unequipUnit(uint80 amount) external {
107         (uint80 unitsOwned,) = units.unitsOwned(msg.sender, unitId);
108         require(unitsOwned >= amount);
109         require(lastEquipTime[msg.sender] + 24 hours < now); // To reduce unequip abuse (only for army premium units)
110         units.deleteUnitExternal(amount, unitId, msg.sender);
111         
112         // Mint token
113         balances[msg.sender] += amount;
114         totalSupply += amount;
115         emit Transfer(address(0), msg.sender, amount);
116     }
117     
118 }
119 
120 interface ApproveAndCallFallBack {
121     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
122 }
123 
124 contract Units {
125     mapping(address => mapping(uint256 => UnitsOwned)) public unitsOwned;
126     function mintUnitExternal(uint256 unit, uint80 amount, address player, uint8 chosenPosition) external;
127     function deleteUnitExternal(uint80 amount, uint256 unit, address player) external;
128     
129     struct UnitsOwned {
130         uint80 units;
131         uint8 factoryBuiltFlag;
132     }
133 }
134 
135 library SafeMath {
136 
137   /**
138   * @dev Multiplies two numbers, throws on overflow.
139   */
140   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141     if (a == 0) {
142       return 0;
143     }
144     uint256 c = a * b;
145     assert(c / a == b);
146     return c;
147   }
148 
149   /**
150   * @dev Integer division of two numbers, truncating the quotient.
151   */
152   function div(uint256 a, uint256 b) internal pure returns (uint256) {
153     // assert(b > 0); // Solidity automatically throws when dividing by 0
154     uint256 c = a / b;
155     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156     return c;
157   }
158 
159   /**
160   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
161   */
162   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163     assert(b <= a);
164     return a - b;
165   }
166 
167   /**
168   * @dev Adds two numbers, throws on overflow.
169   */
170   function add(uint256 a, uint256 b) internal pure returns (uint256) {
171     uint256 c = a + b;
172     assert(c >= a);
173     return c;
174   }
175 }