1 pragma solidity ^0.4.17;
2 
3 
4 
5 /// @title CurrencyToken contract
6 contract GBPp {
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
32     // event EventMintTokens(bytes32 currency, uint amount);
33 
34     // MODIFIERS
35 
36     modifier onlyServer {
37         require(isServer(msg.sender) == true);
38         _;
39     }
40 
41     modifier onlyServerOrOnlyPopulous {
42         require(isServer(msg.sender) == true || isPopulous(msg.sender) == true);
43         _;
44     }
45 
46     modifier onlyPopulous {
47         require(isPopulous(msg.sender) == true);
48         _;
49     }
50     // NON-CONSTANT METHODS
51     
52     /** @dev Creates a new currency/token.
53       * param _decimalUnits The decimal units/places the token can have.
54       * param _tokenSymbol The token's symbol, e.g., GBP.
55       * param _decimalUnits The tokens decimal unites/precision
56       * param _amount The amount of tokens to create upon deployment
57       * param _owner The owner of the tokens created upon deployment
58       * param _server The server/admin address
59       */
60     function GBPp ()
61         public
62     {
63         populous = server = 0x63d509F7152769Ddf162eD048B83719fE1e31080;
64         symbol = name = 0x47425070; // Set the name for display purposes
65         decimals = 6; // Amount of decimals for display purposes
66         balances[server] = safeAdd(balances[server], 10000000000000000);
67         totalSupply = safeAdd(totalSupply, 10000000000000000);
68     }
69 
70     // ERC20
71 
72     //Note.. Need to emit event, Pokens destroyed... from system
73     /** @dev Destroys a specified amount of tokens 
74       * @dev The method uses a modifier from withAccessManager contract to only permit populous to use it.
75       * @dev The method uses SafeMath to carry out safe token deductions/subtraction.
76       * @param amount The amount of tokens to create.
77       */
78 
79     function destroyTokens(uint amount) public onlyPopulous returns (bool success) {
80         if (balances[populous] < amount) {
81             return false;
82         } else {
83             balances[populous] = safeSub(balances[populous], amount);
84             totalSupply = safeSub(totalSupply, amount);
85             return true;
86         }
87     }
88 
89     
90     /** @dev Destroys a specified amount of tokens, from a user.
91       * @dev The method uses a modifier from withAccessManager contract to only permit populous to use it.
92       * @dev The method uses SafeMath to carry out safe token deductions/subtraction.
93       * @param amount The amount of tokens to create.
94       */
95     function destroyTokensFrom(uint amount, address from) public onlyPopulous returns (bool success) {
96         if (balances[from] < amount) {
97             return false;
98         } else {
99             balances[from] = safeSub(balances[from], amount);
100             totalSupply = safeSub(totalSupply, amount);
101             return true;
102         }
103     }
104 
105     function transfer(address _to, uint256 _value) public returns (bool success) {
106         require(balances[msg.sender] >= _value);
107         balances[msg.sender] -= _value;
108         balances[_to] += _value;
109         Transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
114         uint256 allowance = allowed[_from][msg.sender];
115         require(balances[_from] >= _value && allowance >= _value);
116         balances[_to] += _value;
117         balances[_from] -= _value;
118         if (allowance < MAX_UINT256) {
119             allowed[_from][msg.sender] -= _value;
120         }
121         Transfer(_from, _to, _value);
122         return true;
123     }
124 
125     function balanceOf(address _owner) public view returns (uint256 balance) {
126         return balances[_owner];
127     }
128 
129     function approve(address _spender, uint256 _value) public returns (bool success) {
130         allowed[msg.sender][_spender] = _value;
131         Approval(msg.sender, _spender, _value);
132         return true;
133     }
134 
135     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
136         return allowed[_owner][_spender];
137     }
138 
139 
140     // ACCESS MANAGER
141 
142     /** @dev Checks a given address to determine whether it is populous address.
143       * @param sender The address to be checked.
144       * @return bool returns true or false is the address corresponds to populous or not.
145       */
146     function isPopulous(address sender) public view returns (bool) {
147         return sender == populous;
148     }
149 
150         /** @dev Changes the populous contract address.
151       * @dev The method requires the message sender to be the set server.
152       * @param _populous The address to be set as populous.
153       */
154     function changePopulous(address _populous) public {
155         require(isServer(msg.sender) == true);
156         populous = _populous;
157     }
158 
159     // CONSTANT METHODS
160     
161     /** @dev Checks a given address to determine whether it is the server.
162       * @param sender The address to be checked.
163       * @return bool returns true or false is the address corresponds to the server or not.
164       */
165     function isServer(address sender) public view returns (bool) {
166         return sender == server;
167     }
168 
169     /** @dev Changes the server address that is set by the constructor.
170       * @dev The method requires the message sender to be the set server.
171       * @param _server The new address to be set as the server.
172       */
173     function changeServer(address _server) public {
174         require(isServer(msg.sender) == true);
175         server = _server;
176     }
177 
178 
179     // SAFE MATH
180 
181 
182       /** @dev Safely multiplies two unsigned/non-negative integers.
183     * @dev Ensures that one of both numbers can be derived from dividing the product by the other.
184     * @param a The first number.
185     * @param b The second number.
186     * @return uint The expected result.
187     */
188     function safeMul(uint a, uint b) internal pure returns (uint) {
189         uint c = a * b;
190         assert(a == 0 || c / a == b);
191         return c;
192     }
193 
194   /** @dev Safely subtracts one number from another
195     * @dev Ensures that the number to subtract is lower.
196     * @param a The first number.
197     * @param b The second number.
198     * @return uint The expected result.
199     */
200     function safeSub(uint a, uint b) internal pure returns (uint) {
201         assert(b <= a);
202         return a - b;
203     }
204 
205   /** @dev Safely adds two unsigned/non-negative integers.
206     * @dev Ensures that the sum of both numbers is greater or equal to one of both.
207     * @param a The first number.
208     * @param b The second number.
209     * @return uint The expected result.
210     */
211     function safeAdd(uint a, uint b) internal pure returns (uint) {
212         uint c = a + b;
213         assert(c>=a && c>=b);
214         return c;
215     }
216 
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         assert(b > 0); // Solidity automatically throws when dividing by 0
219         uint256 c = a / b;
220         assert(a == b * c + a % b); // There is no case in which this doesn't hold
221         return c;
222     }
223 }