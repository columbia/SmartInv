1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.8;
4 
5 contract SafeMath {
6     function safeDiv(uint a, uint b) internal returns (uint) {
7         assert(b > 0);
8         uint c = a / b;
9         assert(a == b * c + a % b);
10         return c;
11     }
12 
13     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
14         uint256 z = x + y;
15         assert((z >= x) && (z >= y));
16         return z;
17     }
18 
19     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
20         assert(x >= y);
21         uint256 z = x - y;
22         return z;
23     }
24 
25     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
26         uint256 z = x * y;
27         assert((x == 0)||(z/x == y));
28         return z;
29     }
30 }
31 
32 contract Token {
33     /* This is a slight change to the ERC20 base standard.
34     function totalSupply() constant returns (uint256 supply);
35     is replaced with:
36     uint256 public totalSupply;
37     This automatically creates a getter function for the totalSupply.
38     This is moved to the base contract since public getter functions are not
39     currently recognised as an implementation of the matching abstract
40     function by the compiler.
41     */
42     /// total amount of tokens
43     uint256 public totalSupply;
44 
45     /// @param _owner The address from which the balance will be retrieved
46     /// @return The balance
47     function balanceOf(address _owner) constant returns (uint256 balance);
48 
49     /// @notice send `_value` token to `_to` from `msg.sender`
50     /// @param _to The address of the recipient
51     /// @param _value The amount of token to be transferred
52     /// @return Whether the transfer was successful or not
53     function transfer(address _to, uint256 _value) returns (bool success);
54 
55     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
56     /// @param _from The address of the sender
57     /// @param _to The address of the recipient
58     /// @param _value The amount of token to be transferred
59     /// @return Whether the transfer was successful or not
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
61 
62     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
63     /// @param _spender The address of the account able to transfer the tokens
64     /// @param _value The amount of tokens to be approved for transfer
65     /// @return Whether the approval was successful or not
66     function approve(address _spender, uint256 _value) returns (bool success);
67 
68     /// @param _owner The address of the account owning tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @return Amount of remaining tokens allowed to spent
71     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
72 
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75 }
76 
77 contract StandardToken is Token {
78 
79     uint256 constant MAX_UINT256 = 2**256 - 1;
80 
81     bool public isFrozen;              // switched to true in frozen state
82 
83     function transfer(address _to, uint256 _value) returns (bool success) {
84         if (isFrozen) revert();
85         //Default assumes totalSupply can't be over max (2^256 - 1).
86         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
87         //Replace the if with this one instead.
88         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
89         require(balances[msg.sender] >= _value);
90         balances[msg.sender] -= _value;
91         balances[_to] += _value;
92         Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97         if (isFrozen) revert();
98         //same as above. Replace this line with the following if you want to protect against wrapping uints.
99         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
100         uint256 allowance = allowed[_from][msg.sender];
101         require(balances[_from] >= _value && allowance >= _value);
102         balances[_to] += _value;
103         balances[_from] -= _value;
104         if (allowance < MAX_UINT256) {
105             allowed[_from][msg.sender] -= _value;
106         }
107         Transfer(_from, _to, _value);
108         return true;
109     }
110 
111     function balanceOf(address _owner) constant returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115     function approve(address _spender, uint256 _value) returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
122         return allowed[_owner][_spender];
123     }
124 
125     mapping (address => uint256) balances;
126     mapping (address => mapping (address => uint256)) allowed;
127 }
128 
129 contract PreAdsMobileToken is StandardToken, SafeMath {
130 
131     /* Public variables of the token */
132 
133     /*
134         NOTE:
135         The following variables are OPTIONAL vanities. One does not have to include them.
136         They allow one to customise the token contract & in no way influences the core functionality.
137         Some wallets/interfaces might not even bother to look at this information.
138     */
139     string public name;                   //fancy name: eg Simon Bucks
140     uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
141     string public symbol;                 //An identifier: eg SBX
142     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
143 
144     // contracts
145     address public ethFundDeposit;      // deposit address for ETH for AdsMobile
146 
147     // crowdsale parameters
148     bool public isFinalized;              // switched to true in operational state
149     uint256 public fundingStartBlock;
150     uint256 public fundingEndBlock;
151     uint256 public checkNumber;
152     uint256 public totalSupplyWithOutBonus;
153     uint256 public constant tokenExchangeRate               = 400; // 400 AdsMobile tokens per 1 ETH
154     uint256 public constant tokenCreationCapWithOutBonus    = 400 * 10**18;
155     uint256 public constant tokenNeedForBonusLevel0         = 2 * 10**17; // 0.2
156     uint256 public constant bonusLevel0PercentModifier      = 300;
157     uint256 public constant tokenNeedForBonusLevel1         = 1 * 10**17; // 0.1
158     uint256 public constant bonusLevel1PercentModifier      = 200;
159     uint256 public constant tokenCreationMinPayment         = 1 * 10**17; // 0.1
160 
161     // events
162     event CreateAds(address indexed _to, uint256 _value);
163 
164     // constructor
165     function PreAdsMobileToken(
166     string _tokenName,
167     string _tokenSymbol,
168     address _ethFundDeposit,
169     uint256 _fundingStartBlock,
170     uint256 _fundingEndBlock
171     )
172     {
173         balances[msg.sender] = 0;               // Give the creator all initial tokens
174         totalSupply = 0;                        // Update total supply
175         name = _tokenName;           // Set the name for display purposes
176         decimals = 18;                          // Amount of decimals for display purposes
177         symbol = _tokenSymbol;                        // Set the symbol for display purposes
178         isFinalized = false;                    // controls pre through crowdsale state
179         isFrozen = false;
180         ethFundDeposit = _ethFundDeposit;
181         fundingStartBlock = _fundingStartBlock;
182         fundingEndBlock = _fundingEndBlock;
183         checkNumber = 42;                       //Answer to the Ultimate Question of Life, the Universe, and Everything
184     }
185 
186     /// @dev Accepts ether and creates new ADS tokens.
187     function createTokens() public payable {
188         if (isFinalized) revert();
189         if (block.number < fundingStartBlock) revert();
190         if (block.number > fundingEndBlock) revert();
191         if (msg.value == 0) revert();
192         uint256 tokensWithOutBonus = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
193         if (tokensWithOutBonus < tokenCreationMinPayment) revert();
194         uint256 checkedSupplyWithOutBonus = safeAdd(totalSupplyWithOutBonus, tokensWithOutBonus);
195         // return money if something goes wrong
196         if (tokenCreationCapWithOutBonus < checkedSupplyWithOutBonus) revert();  // odd fractions won't be found
197         totalSupplyWithOutBonus = checkedSupplyWithOutBonus;
198 
199         uint256 tokens = tokensWithOutBonus;
200         if(tokens >= tokenNeedForBonusLevel0) {
201             tokens = safeDiv(tokens, 100);
202             tokens = safeMult(tokens, bonusLevel0PercentModifier);
203         } else {
204             if(tokens >= tokenNeedForBonusLevel1) {
205                 tokens = safeDiv(tokens, 100);
206                 tokens = safeMult(tokens, bonusLevel1PercentModifier);
207             }
208         }
209         uint256 checkedSupply = safeAdd(totalSupply, tokens);
210         totalSupply = checkedSupply;
211         balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
212         CreateAds(msg.sender, tokens);  // logs token creation
213     }
214 
215     //just for test cashin and cashout on small amount before let it go
216     function cashin() external payable {
217         if (isFinalized) revert();
218     }
219 
220     function cashout(uint256 amount) external {
221         if (isFinalized) revert();
222         if (msg.sender != ethFundDeposit) revert(); // locks finalize to the ultimate ETH owner
223         if (!ethFundDeposit.send(amount)) revert();  // send the eth to AdsMobile
224     }
225 
226     //in case we want to transfer token to other contract we need freeze all future transfers
227     function freeze() external {
228         if (msg.sender != ethFundDeposit) revert(); // locks finalize to the ultimate ETH owner
229         isFrozen = true;
230     }
231 
232     function unFreeze() external {
233         if (msg.sender != ethFundDeposit) revert(); // locks finalize to the ultimate ETH owner
234         isFrozen = false;
235     }
236 
237     /// @dev Ends the funding period and sends the ETH home
238     function finalize() external {
239         if (isFinalized) revert();
240         if (msg.sender != ethFundDeposit) revert(); // locks finalize to the ultimate ETH owner
241         if (block.number <= fundingEndBlock && totalSupplyWithOutBonus < tokenCreationCapWithOutBonus - tokenCreationMinPayment) revert();
242         // move to operational
243         if (!ethFundDeposit.send(this.balance)) revert();  // send the eth to AdsMobile
244         isFinalized = true;
245     }
246 
247     /**
248      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
249      * msg.sender.
250      */
251     function() external payable {
252         createTokens();
253     }
254 
255 }