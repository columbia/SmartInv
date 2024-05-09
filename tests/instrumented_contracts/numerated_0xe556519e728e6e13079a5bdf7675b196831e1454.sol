1 /**
2  * Source Code first verified at https://etherscan.io on Friday, May 24, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.25;
6 
7 /**
8  * 
9  * World War Goo - Competitive Idle Game
10  * 
11  * https://ethergoo.io
12  * 
13  */
14 
15 interface ERC20 {
16     function totalSupply() external constant returns (uint);
17     function balanceOf(address tokenOwner) external constant returns (uint balance);
18     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
19     function transfer(address to, uint tokens) external returns (bool success);
20     function approve(address spender, uint tokens) external returns (bool success);
21     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
22     function transferFrom(address from, address to, uint tokens) external returns (bool success);
23 
24     event Transfer(address indexed from, address indexed to, uint tokens);
25     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
26 }
27 
28 contract PremiumUnit {
29     function mintUnit(address player, uint256 amount) external;
30     function equipUnit(address player, uint80 amount, uint8 chosenPosition) external;
31     uint256 public unitId;
32     uint256 public unitProductionSeconds;
33 }
34 
35 contract MadScienceKittyUnit is ERC20, PremiumUnit {
36     using SafeMath for uint;
37     
38     string public constant name = "WWG Premium Unit - MAD SCIENTIST";
39     string public constant symbol = "MAD SCIENCE";
40     uint256 public constant unitId = 6;
41     uint256 public unitProductionSeconds = 86400; // Num seconds for factory to produce a single unit
42     uint8 public constant decimals = 0;
43     
44     Units constant units = Units(0xf936AA9e1f22C915Abf4A66a5a6e94eb8716BA5e);
45     address constant factories = 0xC767B1CEc507f1584469E8efE1a94AD4c75e02ed;
46     
47     mapping(address => uint256) balances;
48     mapping(address => uint256) lastEquipTime;
49     mapping(address => mapping(address => uint256)) allowed;
50     uint256 public totalSupply;
51     
52     function totalSupply() external view returns (uint) {
53         return totalSupply.sub(balances[address(0)]);
54     }
55     
56     function balanceOf(address tokenOwner) external view returns (uint256) {
57         return balances[tokenOwner];
58     }
59     
60     function transfer(address to, uint tokens) external returns (bool) {
61         balances[msg.sender] = balances[msg.sender].sub(tokens);
62         balances[to] = balances[to].add(tokens);
63         emit Transfer(msg.sender, to, tokens);
64         return true;
65     }
66     
67     function transferFrom(address from, address to, uint tokens) external returns (bool) {
68         balances[from] = balances[from].sub(tokens);
69         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
70         balances[to] = balances[to].add(tokens);
71         emit Transfer(from, to, tokens);
72         return true;
73     }
74     
75     function approve(address spender, uint tokens) external returns (bool) {
76         allowed[msg.sender][spender] = tokens;
77         emit Approval(msg.sender, spender, tokens);
78         return true;
79     }
80     
81     function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
82         allowed[msg.sender][spender] = tokens;
83         emit Approval(msg.sender, spender, tokens);
84         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
85         return true;
86     }
87     
88     function allowance(address tokenOwner, address spender) external view returns (uint256) {
89         return allowed[tokenOwner][spender];
90     }
91     
92     function mintUnit(address player, uint256 amount) external {
93         require(msg.sender == factories);
94         balances[player] += amount;
95         totalSupply += amount;
96         emit Transfer(address(0), player, amount);
97     }
98     
99     function equipUnit(address player, uint80 amount, uint8 chosenPosition) external {
100         require(msg.sender == player || msg.sender == factories);
101         units.mintUnitExternal(unitId, amount, player, chosenPosition);
102         
103         // Burn token
104         balances[player] = balances[player].sub(amount);
105         //lastEquipTime[player] = now; // Only for army premium units
106         totalSupply = totalSupply.sub(amount);
107         emit Transfer(player, address(0), amount);
108     }
109     
110     function unequipUnit(uint80 amount) external {
111         (uint80 unitsOwned,) = units.unitsOwned(msg.sender, unitId);
112         require(unitsOwned >= amount);
113         //require(lastEquipTime[msg.sender] + 24 hours < now); // To reduce unequip abuse (only for army premium units)
114         units.deleteUnitExternal(amount, unitId, msg.sender);
115         
116         // Mint token
117         balances[msg.sender] += amount;
118         totalSupply += amount;
119         emit Transfer(address(0), msg.sender, amount);
120     }
121     
122 }
123 
124 
125 interface ApproveAndCallFallBack {
126     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
127 }
128 
129 contract Units {
130     mapping(address => mapping(uint256 => UnitsOwned)) public unitsOwned;
131     function mintUnitExternal(uint256 unit, uint80 amount, address player, uint8 chosenPosition) external;
132     function deleteUnitExternal(uint80 amount, uint256 unit, address player) external;
133     
134     struct UnitsOwned {
135         uint80 units;
136         uint8 factoryBuiltFlag;
137     }
138 }
139 
140 library SafeMath {
141 
142   /**
143   * @dev Multiplies two numbers, throws on overflow.
144   */
145   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146     if (a == 0) {
147       return 0;
148     }
149     uint256 c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   /**
155   * @dev Integer division of two numbers, truncating the quotient.
156   */
157   function div(uint256 a, uint256 b) internal pure returns (uint256) {
158     // assert(b > 0); // Solidity automatically throws when dividing by 0
159     uint256 c = a / b;
160     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161     return c;
162   }
163 
164   /**
165   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
166   */
167   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168     assert(b <= a);
169     return a - b;
170   }
171 
172   /**
173   * @dev Adds two numbers, throws on overflow.
174   */
175   function add(uint256 a, uint256 b) internal pure returns (uint256) {
176     uint256 c = a + b;
177     assert(c >= a);
178     return c;
179   }
180 }