1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 // Used for function invoke restriction
51 contract Owned {
52 
53     address public owner; // temporary address
54 
55     constructor() internal {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner() {
60         if (msg.sender != owner)
61             revert();
62         _; // function code inserted here
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner returns (bool success) {
66         if (msg.sender != owner)
67             revert();
68         owner = _newOwner;
69         return true;
70 
71     }
72 }
73 
74 contract ClickGem is Owned {
75     using SafeMath for uint256;
76 
77     uint256     public  totalSupply;
78     uint8       public  decimals;
79     string      public  name;
80     string      public  symbol;
81     bool        public  tokenIsFrozen;
82     bool        public  tokenMintingEnabled;
83     bool        public  contractLaunched;
84     bool		public	stakingStatus;
85 
86     mapping (address => mapping (address => uint256))   public allowance;
87     mapping (address => uint256)                        public balances;
88     event Transfer(address indexed _sender, address indexed _recipient, uint256 _amount);
89     event Approve(address indexed _owner, address indexed _spender, uint256 _amount);
90     event LaunchContract(address indexed _launcher, bool _launched);
91     event FreezeTransfers(address indexed _invoker, bool _frozen);
92     event UnFreezeTransfers(address indexed _invoker, bool _thawed);
93     event MintTokens(address indexed _minter, uint256 _amount, bool indexed _minted);
94     event TokenMintingDisabled(address indexed _invoker, bool indexed _disabled);
95     event TokenMintingEnabled(address indexed _invoker, bool indexed _enabled);
96 
97 
98     constructor() public {
99         name = "ClickGem Token";
100         symbol = "CGMT";
101         decimals = 18;
102 
103         totalSupply = 300000000000000000000000000000;
104         balances[msg.sender] = totalSupply;
105         tokenIsFrozen = false;
106         tokenMintingEnabled = false;
107         contractLaunched = false;
108     }
109 
110 
111 
112     /// @notice Used to launch the contract, and enabled token minting
113     function launchContract() public onlyOwner {
114         require(!contractLaunched);
115         tokenIsFrozen = false;
116         tokenMintingEnabled = true;
117         contractLaunched = true;
118         emit LaunchContract(msg.sender, true);
119     }
120 
121     function disableTokenMinting() public onlyOwner returns (bool disabled) {
122         tokenMintingEnabled = false;
123         emit TokenMintingDisabled(msg.sender, true);
124         return true;
125     }
126 
127     function enableTokenMinting() public onlyOwner returns (bool enabled) {
128         tokenMintingEnabled = true;
129         emit TokenMintingEnabled(msg.sender, true);
130         return true;
131     }
132 
133     
134 
135     /// @notice Used to transfer funds
136     /// @param _receiver Eth address to send TEMPLATE-TOKENToken tokens too
137     /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to send
138     function transfer(address _receiver, uint256 _amount)
139     public
140     returns (bool success)
141     {
142         require(transferCheck(msg.sender, _receiver, _amount));
143         balances[msg.sender] = balances[msg.sender].sub(_amount);
144         balances[_receiver] = balances[_receiver].add(_amount);
145         emit Transfer(msg.sender, _receiver, _amount);
146         return true;
147     }
148 
149 
150     /// @notice Used to burn tokens and decrease total supply
151     /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to burn
152     function tokenBurner(uint256 _amount) public
153     onlyOwner
154     returns (bool burned)
155     {
156         require(_amount > 0);
157         require(totalSupply.sub(_amount) > 0);
158         require(balances[msg.sender] > _amount);
159         require(balances[msg.sender].sub(_amount) > 0);
160         totalSupply = totalSupply.sub(_amount);
161         balances[msg.sender] = balances[msg.sender].sub(_amount);
162         emit Transfer(msg.sender, 0, _amount);
163         return true;
164     }
165 
166     /// @notice Low level function Used to create new tokens and increase total supply
167     /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to create
168 
169     function tokenMinter(uint256 _amount)
170     internal
171     view
172     returns (bool valid)
173     {
174         require(tokenMintingEnabled);
175         require(_amount > 0);
176         require(totalSupply.add(_amount) > 0);
177         require(totalSupply.add(_amount) > totalSupply);
178         return true;
179     }
180 
181 
182     /// @notice Used to create new tokens and increase total supply
183     /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to create
184     function tokenFactory(uint256 _amount) public
185     onlyOwner
186     returns (bool success)
187     {
188         require(tokenMinter(_amount));
189         totalSupply = totalSupply.add(_amount);
190         balances[msg.sender] = balances[msg.sender].add(_amount);
191         emit Transfer(0, msg.sender, _amount);
192         return true;
193     }
194 
195 
196     /// @notice Reusable code to do sanity check of transfer variables
197     function transferCheck(address _sender, address _receiver, uint256 _amount)
198     private
199     constant
200     returns (bool success)
201     {
202         require(!tokenIsFrozen);
203         require(_amount > 0);
204         require(_receiver != address(0));
205         require(balances[_sender].sub(_amount) >= 0);
206         require(balances[_receiver].add(_amount) > 0);
207         require(balances[_receiver].add(_amount) > balances[_receiver]);
208         return true;
209     }
210 
211 
212     /// @notice Used to retrieve total supply
213     function totalSupply()
214     public
215     constant
216     returns (uint256 _totalSupply)
217     {
218         return totalSupply;
219     }
220 
221     /// @notice Used to look up balance of a person
222     function balanceOf(address _person)
223     public
224     constant
225     returns (uint256 _balance)
226     {
227         return balances[_person];
228     }
229 
230     function AirDropper(address[] _to, uint256[] _value) public onlyOwner returns (bool) {
231         require(_to.length > 0);
232         require(_to.length == _value.length);
233 
234         for (uint i = 0; i < _to.length; i++) {
235             if (transfer(_to[i], _value[i]) == false) {
236                 return false;
237             }
238         }
239         return true;
240     }
241 
242 
243     /// @notice Used to look up the allowance of someone
244     function allowance(address _owner, address _spender)
245     public
246     constant
247     returns (uint256 _amount)
248     {
249         return allowance[_owner][_spender];
250     }
251 }