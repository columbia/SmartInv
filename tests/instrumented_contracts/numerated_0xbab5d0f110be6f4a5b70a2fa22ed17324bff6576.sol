1 pragma solidity ^0.4.17;
2 
3 // File: contracts/USDp.sol
4 
5 /// @title USDp Token contract
6 contract USDp {
7 
8     address public server; // Address, which the platform website uses.
9     address public populous; // Address of the Populous bank contract.
10 
11     uint256 public totalSupply;
12     bytes32 public name;// token name, e.g, pounds for fiat UK pounds.
13     uint8 public decimals;// How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
14     bytes32 public symbol;// An identifier: eg SBX.
15 
16     uint256 constant private MAX_UINT256 = 2**256 - 1;
17     mapping (address => uint256) public balances;
18     mapping (address => mapping (address => uint256)) public allowed;
19     //EVENTS
20     // An event triggered when a transfer of tokens is made from a _from address to a _to address.
21     event Transfer(
22         address indexed _from, 
23         address indexed _to, 
24         uint256 _value
25     );
26     // An event triggered when an owner of tokens successfully approves another address to spend a specified amount of tokens.
27     event Approval(
28         address indexed _owner, 
29         address indexed _spender, 
30         uint256 _value
31     );
32     event EventMintTokens(bytes32 currency, address owner, uint amount);
33     event EventDestroyTokens(bytes32 currency, address owner, uint amount);
34 
35     // MODIFIERS
36 
37     modifier onlyServer {
38         require(isServer(msg.sender) == true);
39         _;
40     }
41 
42     modifier onlyServerOrOnlyPopulous {
43         require(isServer(msg.sender) == true || isPopulous(msg.sender) == true);
44         _;
45     }
46 
47     modifier onlyPopulous {
48         require(isPopulous(msg.sender) == true);
49         _;
50     }
51     // NON-CONSTANT METHODS
52     
53     /** @dev Creates a new currency/token.
54       * param _decimalUnits The decimal units/places the token can have.
55       * param _tokenSymbol The token's symbol, e.g., GBP.
56       * param _decimalUnits The tokens decimal unites/precision
57       * param _amount The amount of tokens to create upon deployment
58       * param _owner The owner of the tokens created upon deployment
59       * param _server The server/admin address
60       */
61     constructor ()
62         public
63     {
64         populous = server = 0x63d509F7152769Ddf162eD048B83719fE1e31080;
65         symbol = name = 0x55534470; // Set the name = USDp for display purposes
66         decimals = 6; // Amount of decimals for display purposes
67         // balances[server] = safeAdd(balances[server], 10000000000000000);
68         totalSupply = 0; //safeAdd(totalSupply, 10000000000000000);
69     }
70 
71     // ERC20
72     /** @dev Mints a specified amount of tokens 
73       * @param owner The token owner.
74       * @param amount The amount of tokens to create.
75       */
76     function mint(uint amount, address owner) public onlyServerOrOnlyPopulous returns (bool success) {
77         balances[owner] = safeAdd(balances[owner], amount);
78         totalSupply = safeAdd(totalSupply, amount);
79         emit EventMintTokens(symbol, owner, amount);
80         return true;
81     }
82 
83     /** @dev Destroys a specified amount of tokens 
84       * @dev The method uses a modifier from withAccessManager contract to only permit populous to use it.
85       * @dev The method uses SafeMath to carry out safe token deductions/subtraction.
86       * @param amount The amount of tokens to create.
87       */
88     function destroyTokens(uint amount) public onlyServerOrOnlyPopulous returns (bool success) {
89         require(balances[msg.sender] >= amount);
90         balances[msg.sender] = safeSub(balances[msg.sender], amount);
91         totalSupply = safeSub(totalSupply, amount);
92         emit EventDestroyTokens(symbol, populous, amount);
93         return true;
94     }
95 
96     /** @dev Destroys a specified amount of tokens, from a user.
97       * @dev The method uses a modifier from withAccessManager contract to only permit populous to use it.
98       * @dev The method uses SafeMath to carry out safe token deductions/subtraction.
99       * @param amount The amount of tokens to create.
100       */
101     function destroyTokensFrom(uint amount, address from) public onlyServerOrOnlyPopulous returns (bool success) {
102         require(balances[from] >= amount);
103         balances[from] = safeSub(balances[from], amount);
104         totalSupply = safeSub(totalSupply, amount);
105         emit EventDestroyTokens(symbol, from, amount);
106         return true;
107     }
108 
109     function transfer(address _to, uint256 _value) public returns (bool success) {
110         require(balances[msg.sender] >= _value);
111         balances[msg.sender] -= _value;
112         balances[_to] += _value;
113         emit Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
118         uint256 allowance = allowed[_from][msg.sender];
119         require(balances[_from] >= _value && allowance >= _value);
120         balances[_to] += _value;
121         balances[_from] -= _value;
122         if (allowance < MAX_UINT256) {
123             allowed[_from][msg.sender] -= _value;
124         }
125         emit Transfer(_from, _to, _value);
126         return true;
127     }
128 
129     function balanceOf(address _owner) public view returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133     function approve(address _spender, uint256 _value) public returns (bool success) {
134         allowed[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
140         return allowed[_owner][_spender];
141     }
142 
143 
144     // ACCESS MANAGER
145 
146     /** @dev Checks a given address to determine whether it is populous address.
147       * @param sender The address to be checked.
148       * @return bool returns true or false is the address corresponds to populous or not.
149       */
150     function isPopulous(address sender) public view returns (bool) {
151         return sender == populous;
152     }
153 
154         /** @dev Changes the populous contract address.
155       * @dev The method requires the message sender to be the set server.
156       * @param _populous The address to be set as populous.
157       */
158     function changePopulous(address _populous) public {
159         require(isServer(msg.sender) == true);
160         populous = _populous;
161     }
162 
163     // CONSTANT METHODS
164     
165     /** @dev Checks a given address to determine whether it is the server.
166       * @param sender The address to be checked.
167       * @return bool returns true or false is the address corresponds to the server or not.
168       */
169     function isServer(address sender) public view returns (bool) {
170         return sender == server;
171     }
172 
173     /** @dev Changes the server address that is set by the constructor.
174       * @dev The method requires the message sender to be the set server.
175       * @param _server The new address to be set as the server.
176       */
177     function changeServer(address _server) public {
178         require(isServer(msg.sender) == true);
179         server = _server;
180     }
181 
182 
183     // SAFE MATH
184 
185     /** @dev Safely multiplies two unsigned/non-negative integers.
186     * @dev Ensures that one of both numbers can be derived from dividing the product by the other.
187     * @param a The first number.
188     * @param b The second number.
189     * @return uint The expected result.
190     */
191     function safeMul(uint a, uint b) internal pure returns (uint) {
192         uint c = a * b;
193         assert(a == 0 || c / a == b);
194         return c;
195     }
196 
197   /** @dev Safely subtracts one number from another
198     * @dev Ensures that the number to subtract is lower.
199     * @param a The first number.
200     * @param b The second number.
201     * @return uint The expected result.
202     */
203     function safeSub(uint a, uint b) internal pure returns (uint) {
204         assert(b <= a);
205         return a - b;
206     }
207 
208   /** @dev Safely adds two unsigned/non-negative integers.
209     * @dev Ensures that the sum of both numbers is greater or equal to one of both.
210     * @param a The first number.
211     * @param b The second number.
212     * @return uint The expected result.
213     */
214     function safeAdd(uint a, uint b) internal pure returns (uint) {
215         uint c = a + b;
216         assert(c>=a && c>=b);
217         return c;
218     }
219 
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         assert(b > 0); // Solidity automatically throws when dividing by 0
222         uint256 c = a / b;
223         assert(a == b * c + a % b); // There is no case in which this doesn't hold
224         return c;
225     }
226 }