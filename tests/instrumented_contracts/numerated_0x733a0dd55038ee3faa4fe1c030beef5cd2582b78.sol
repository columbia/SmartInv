1 pragma solidity 0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20   
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 // Used for function invoke restriction
50 contract Owned {
51 
52     address public owner; // temporary address
53 
54     function Owned() internal {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner() {
59         if (msg.sender != owner)
60             revert();
61         _; // function code inserted here
62     }
63 
64     function transferOwnership(address _newOwner) public onlyOwner returns (bool success) {
65         if (msg.sender != owner)
66             revert();
67         owner = _newOwner;
68         return true;
69         
70     }
71 }
72 
73 contract TKP is Owned {
74     using SafeMath for uint256;
75 
76     address[]   public  TKPUsers;
77     uint256     public  totalSupply;
78     uint8       public  decimals;
79     string      public  name;
80     string      public  symbol;
81     bool        public  tokenTransfersFrozen;
82     bool        public  tokenMintingEnabled;
83     bool        public  contractLaunched;
84 
85     mapping (address => mapping (address => uint256))   public allowance;
86     mapping (address => uint256)                        public balances;
87     mapping (address => uint256)                        public icoBalances;
88     mapping (address => uint256)                        public TKPUserArrayIdentifier;
89     mapping (address => bool)                           public TKPUserRegistered;
90 
91     event Transfer(address indexed _sender, address indexed _recipient, uint256 _amount);
92     event Approve(address indexed _owner, address indexed _spender, uint256 _amount);
93     event LaunchContract(address indexed _launcher, bool _launched);
94     event FreezeTokenTransfers(address indexed _invoker, bool _frozen);
95     event ThawTokenTransfers(address indexed _invoker, bool _thawed);
96     event MintTokens(address indexed _minter, uint256 _amount, bool indexed _minted);
97     event TokenMintingDisabled(address indexed _invoker, bool indexed _disabled);
98     event TokenMintingEnabled(address indexed _invoker, bool indexed _enabled);
99 
100     function TKP() public {
101         name = "Trish Kelly Portfolio Coin";
102         symbol = "TKP";
103         decimals = 18;
104        
105         totalSupply = 60000000000000000000000000;
106         balances[msg.sender] = balances[msg.sender].add(totalSupply);
107         tokenTransfersFrozen = true;
108         tokenMintingEnabled = false;
109         contractLaunched = false;
110     }
111 
112   
113     function transactionReplay(address _receiver, uint256 _amount)
114         onlyOwner
115         public
116         returns (bool replayed)
117     {
118         require(transferCheck(msg.sender, _receiver, _amount));
119         balances[msg.sender] = balances[msg.sender].sub(_amount);
120         balances[_receiver] = balances[_receiver].add(_amount);
121         Transfer(msg.sender, _receiver, _amount);
122         return true;
123     }
124 
125     /// @notice Used to launch the contract, and enabled token minting
126     function launchContract() public onlyOwner {
127         require(!contractLaunched);
128         tokenTransfersFrozen = false;
129         tokenMintingEnabled = true;
130         contractLaunched = true;
131         LaunchContract(msg.sender, true);
132     }
133 
134     function disableTokenMinting() public onlyOwner returns (bool disabled) {
135         tokenMintingEnabled = false;
136         TokenMintingDisabled(msg.sender, true);
137         return true;
138     }
139 
140     function enableTokenMinting() public onlyOwner returns (bool enabled) {
141         tokenMintingEnabled = true;
142         TokenMintingEnabled(msg.sender, true);
143         return true;
144     }
145 
146     function freezeTokenTransfers() public onlyOwner returns (bool success) {
147         tokenTransfersFrozen = true;
148         FreezeTokenTransfers(msg.sender, true);
149         return true;
150     }
151 
152     function thawTokenTransfers() public onlyOwner returns (bool success) {
153         tokenTransfersFrozen = false;
154         ThawTokenTransfers(msg.sender, true);
155         return true;
156     }
157 
158     /// @notice Used to transfer funds
159     /// @param _receiver Eth address to send TKP tokens too
160     /// @param _amount The amount of TKP tokens in wei to send
161     function transfer(address _receiver, uint256 _amount)
162         public
163         returns (bool success)
164     {
165         require(transferCheck(msg.sender, _receiver, _amount));
166         balances[msg.sender] = balances[msg.sender].sub(_amount);
167         balances[_receiver] = balances[_receiver].add(_amount);
168         Transfer(msg.sender, _receiver, _amount);
169         return true;
170     }
171 
172     /// @notice Used to transfer funds on behalf of owner to receiver
173 
174     function transferFrom(address _owner, address _receiver, uint256 _amount) 
175         public 
176         returns (bool success)
177     {
178         require(allowance[_owner][msg.sender] >= _amount);
179         require(transferCheck(_owner, _receiver, _amount));
180         allowance[_owner][msg.sender] = allowance[_owner][msg.sender].sub(_amount);
181         balances[_owner] =  balances[_owner].sub(_amount);
182         balances[_receiver] = balances[_receiver].add(_amount);
183         Transfer(_owner, _receiver, _amount);
184         return true;
185     }
186 
187     /// @notice Used to approve someone to send funds on your behalf
188     /// @param _spender The eth address of the person you are approving
189     /// @param _amount The amount of TKP tokens _spender is allowed to send (in wei)
190     function approve(address _spender, uint256 _amount)
191         public
192         returns (bool approved)
193     {
194         require(_amount > 0);
195         require(balances[msg.sender] >= _amount);
196         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_amount);
197         return true;
198     }
199 
200     /// @notice Used to burn tokens and decrease total supply
201     /// @param _amount The amount of TKP tokens in wei to burn
202     function tokenBurner(uint256 _amount) public
203         onlyOwner
204         returns (bool burned)
205     {
206         require(_amount > 0);
207         require(totalSupply.sub(_amount) > 0);
208         require(balances[msg.sender] > _amount);
209         require(balances[msg.sender].sub(_amount) > 0);
210         totalSupply = totalSupply.sub(_amount);
211         balances[msg.sender] = balances[msg.sender].sub(_amount);
212         Transfer(msg.sender, 0, _amount);
213         return true;
214     }
215 
216     /// @notice Low level function Used to create new tokens and increase total supply
217     /// @param _amount The amount of TKP tokens in wei to create
218 
219    function tokenMinter(uint256 _amount)
220         internal
221         view
222         returns (bool valid)
223     {
224         require(tokenMintingEnabled);
225         require(_amount > 0);
226         require(totalSupply.add(_amount) > 0);
227         require(totalSupply.add(_amount) > totalSupply);
228         return true;
229     }
230     
231 
232     /// @notice Used to create new tokens and increase total supply
233     /// @param _amount The amount of TKP tokens in wei to create
234     function tokenFactory(uint256 _amount) public
235         onlyOwner
236         returns (bool success)
237     {
238         require(tokenMinter(_amount));
239         totalSupply = totalSupply.add(_amount);
240         balances[msg.sender] = balances[msg.sender].add(_amount);
241         Transfer(0, msg.sender, _amount);
242         return true;
243     }
244 
245   
246     /// @notice Reusable code to do sanity check of transfer variables
247         function transferCheck(address _sender, address _receiver, uint256 _amount)
248         private
249         constant
250         returns (bool success)
251     {
252         require(!tokenTransfersFrozen);
253         require(_amount > 0);
254         require(_receiver != address(0));
255         require(balances[_sender].sub(_amount) >= 0);
256         require(balances[_receiver].add(_amount) > 0);
257         require(balances[_receiver].add(_amount) > balances[_receiver]);
258         return true;
259     }
260 
261 
262     /// @notice Used to retrieve total supply
263     function totalSupply() 
264         public
265         constant
266         returns (uint256 _totalSupply)
267     {
268         return totalSupply;
269     }
270 
271     /// @notice Used to look up balance of a person
272     function balanceOf(address _person)
273         public
274         constant
275         returns (uint256 _balance)
276     {
277         return balances[_person];
278     }
279 
280     /// @notice Used to look up the allowance of someone
281     function allowance(address _owner, address _spender)
282         public
283         constant 
284         returns (uint256 _amount)
285     {
286         return allowance[_owner][_spender];
287     }
288 }