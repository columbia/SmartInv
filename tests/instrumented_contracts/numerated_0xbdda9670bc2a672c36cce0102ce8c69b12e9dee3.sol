1 pragma solidity 0.5.16;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) 
7             return 0;
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28         return c;
29     }
30 
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b != 0);
33         return a % b;
34     }
35 }
36 
37 
38 contract ERC20 {
39     using SafeMath for uint256;
40 
41     mapping (address => uint256) internal _balances;
42     mapping (address => mapping (address => uint256)) internal _allowed;
43     
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 
47     uint256 internal _totalSupply;
48 
49     /**
50     * @dev Total number of tokens in existence
51     */
52     function totalSupply() public view returns (uint256) {
53         return _totalSupply;
54     }
55 
56     /**
57     * @dev Gets the balance of the specified address.
58     * @param owner The address to query the balance of.
59     * @return A uint256 representing the amount owned by the passed address.
60     */
61     function balanceOf(address owner) public view returns (uint256) {
62         return _balances[owner];
63     }
64 
65     /**
66     * @dev Function to check the amount of tokens that an owner allowed to a spender.
67     * @param owner address The address which owns the funds.
68     * @param spender address The address which will spend the funds.
69     * @return A uint256 specifying the amount of tokens still available for the spender.
70     */
71     function allowance(address owner, address spender) public view returns (uint256) {
72         return _allowed[owner][spender];
73     }
74 
75     /**
76     * @dev Transfer token to a specified address
77     * @param to The address to transfer to.
78     * @param value The amount to be transferred.
79     */
80     function transfer(address to, uint256 value) public returns (bool) {
81         _transfer(msg.sender, to, value);
82         return true;
83     }
84 
85     /**
86     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
87     * Beware that changing an allowance with this method brings the risk that someone may use both the old
88     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
89     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
90     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
91     * @param spender The address which will spend the funds.
92     * @param value The amount of tokens to be spent.
93     */
94     function approve(address spender, uint256 value) public returns (bool) {
95         _allowed[msg.sender][spender] = value;
96         emit Approval(msg.sender, spender, value);
97         return true;
98     }
99 
100     /**
101     * @dev Transfer tokens from one address to another.
102     * Note that while this function emits an Approval event, this is not required as per the specification,
103     * and other compliant implementations may not emit the event.
104     * @param from address The address which you want to send tokens from
105     * @param to address The address which you want to transfer to
106     * @param value uint256 the amount of tokens to be transferred
107     */
108     function transferFrom(address from, address to, uint256 value) public returns (bool) {
109         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
110         _transfer(from, to, value);
111         return true;
112     }
113 
114     function _transfer(address from, address to, uint256 value) internal {
115         require(to != address(0));
116         _balances[from] = _balances[from].sub(value);
117         _balances[to] = _balances[to].add(value);
118         emit Transfer(from, to, value);
119     }
120 
121 }
122 
123 contract ERC20Mintable is ERC20 {
124     string public name;
125     string public symbol;
126     uint8 public decimals;
127 
128     function _mint(address to, uint256 amount) internal {
129         _balances[to] = _balances[to].add(amount);
130         _totalSupply = _totalSupply.add(amount);
131         emit Transfer(address(0), to, amount);
132     }
133 
134     function _burn(address from, uint256 amount) internal {
135         _balances[from] = _balances[from].sub(amount);
136         _totalSupply = _totalSupply.sub(amount);
137         emit Transfer(from, address(0), amount);
138     }
139 }
140 
141 contract ThreeFMutual {
142 
143     struct Player {
144         uint256 id;             // agent id
145         bytes32 name;           // agent name
146         uint256 ref;            // referral vault
147         bool isAgent;           // referral activated
148         bool claimed;           // insurance claimed
149         uint256 eth;            // eth player has paid
150         uint256 shares;         // shares
151         uint256 units;          // uints of insurance
152         uint256 plyrLastSeen;   // last day player played
153         uint256 mask;           // player mask
154         uint256 level;          // agent level
155         uint256 accumulatedRef; // accumulated referral income
156     }
157 
158     mapping(address => mapping(uint256 => uint256)) public unitToExpirePlayer;
159     mapping(uint256 => uint256) public unitToExpire; // unit of insurance due at day x
160 
161     uint256 public issuedInsurance; // all issued insurance
162     uint256 public ethOfShare;      // virtual eth pointer
163     uint256 public shares;          // total share
164     uint256 public pool;            // eth gonna pay to beneficiary
165     uint256 public today;           // today's date
166     uint256 public _now;            // current time
167     uint256 public mask;            // global mask
168     uint256 public agents;          // number of agent
169 
170     // player data
171     mapping(address => Player) public player;       // player data
172     mapping(uint256 => address) public agentxID_;   // return agent address by id
173     mapping(bytes32 => address) public agentxName_; // return agent address by name
174 
175 }
176 
177 contract TFToken is ERC20Mintable {
178     string public constant name = "ThirdFloorToken";
179     string public constant symbol = "TFT";
180     uint8 public constant decimals = 18;
181 
182     ThreeFMutual public constant Mutual = ThreeFMutual(0x66be1bc6C6aF47900BBD4F3711801bE6C2c6CB32);
183 
184     mapping(address => uint256) public claimedAmount;
185 
186     function claim(address receiver) external {
187         uint256 balance;
188         (,,,,,balance,,,,,,) = Mutual.player(receiver);
189         require(balance > claimedAmount[receiver]);
190         _mint(receiver, balance.sub(claimedAmount[receiver]));
191         claimedAmount[receiver] = balance;
192     }
193 
194 }