1 pragma solidity ^0.4.11;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) throw;
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 // ----------------------------------------------------------------------------------------------
21 // Original from:
22 // https://theethereum.wiki/w/index.php/ERC20_Token_Standard
23 // (c) BokkyPooBah 2017. The MIT Licence.
24 // ----------------------------------------------------------------------------------------------
25 // ERC Token Standard #20 Interface
26 // https://github.com/ethereum/EIPs/issues/20
27 contract ERC20Interface {
28     // Get the total token supply     function totalSupply() constant returns (uint256 totalSupply);
29  
30     // Get the account balance of another account with address _owner
31     function balanceOf(address _owner) constant returns (uint256 balance);
32  
33     // Send _value amount of tokens to address _to
34     function transfer(address _to, uint256 _value) returns (bool success);
35 
36     // Send _value amount of token from address _from to address _to
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
38  
39     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
40     // If this function is called again it overwrites the current allowance with _value.
41     // this function is required for some DEX functionality
42     function approve(address _spender, uint256 _value) returns (bool success); 
43     
44     // Returns the amount which _spender is still allowed to withdraw from _owner
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47    // Triggered when tokens are transferred.
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49  
50     // Triggered whenever approve(address _spender, uint256 _value) is called.
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 
55 // Migration Agent interface
56 contract migration {
57     function migrateFrom(address _from, uint256 _value);
58 }
59 
60 /// @title Zeus Shield Coin (ZSC)
61 contract ZeusShieldCoin is owned, ERC20Interface {
62     // Public variables of the token
63     string public constant standard = 'ERC20';
64     string public constant name = 'Zeus Shield Coin';  
65     string public constant symbol = 'ZSC';
66     uint8  public constant decimals = 18;
67     uint public registrationTime = 0;
68     bool public registered = false;
69 
70     uint256 public totalMigrated = 0;
71     address public migrationAgent = 0;
72 
73     uint256 totalTokens = 0; 
74 
75 
76     // This creates an array with all balances 
77     mapping (address => uint256) balances;
78 
79     // Owner of account approves the transfer of an amount to another account
80     mapping(address => mapping (address => uint256)) allowed;
81    
82     // These are related to ZSC team members
83     mapping (address => bool) public frozenAccount;
84     mapping (address => uint[3]) public frozenTokens;
85 
86     // Variables of token frozen rules for ZSC team members.
87     uint[3] public unlockat;
88 
89     event Migrate(address _from, address _to, uint256 _value);
90 
91     // Constructor
92     function ZeusShieldCoin() 
93     {
94     }
95 
96     // This unnamed function is called whenever someone tries to send ether to it 
97     function () 
98     {
99         throw; // Prevents accidental sending of ether
100     }
101 
102     function totalSupply() 
103         constant 
104         returns (uint256) 
105     {
106         return totalTokens;
107     }
108 
109     // What is the balance of a particular account?
110     function balanceOf(address _owner) 
111         constant 
112         returns (uint256) 
113     {
114         return balances[_owner];
115     }
116 
117     // Transfer the balance from owner's account to another account
118     function transfer(address _to, uint256 _amount) 
119         returns (bool success) 
120     {
121         if (!registered) return false;
122         if (_amount <= 0) return false;
123         if (frozenRules(msg.sender, _amount)) return false;
124 
125         if (balances[msg.sender] >= _amount
126             && balances[_to] + _amount > balances[_to]) {
127 
128             balances[msg.sender] -= _amount;
129             balances[_to] += _amount;
130             Transfer(msg.sender, _to, _amount);
131             return true;
132         } else {
133             return false;
134         }     
135     }
136  
137     // Send _value amount of tokens from address _from to address _to
138     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
139     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
140     // fees in sub-currencies; the command should fail unless the _from account has
141     // deliberately authorized the sender of the message via some mechanism; we propose
142     // these standardized APIs for approval:
143     function transferFrom(address _from, address _to, uint256 _amount) 
144         returns (bool success) 
145     {
146         if (!registered) return false;
147         if (_amount <= 0) return false;
148         if (frozenRules(_from, _amount)) return false;
149 
150         if (balances[_from] >= _amount
151             && allowed[_from][msg.sender] >= _amount
152             && balances[_to] + _amount > balances[_to]) {
153 
154             balances[_from] -= _amount;
155             allowed[_from][msg.sender] -= _amount;
156             balances[_to] += _amount;
157             Transfer(_from, _to, _amount);
158             return true;
159         } else {
160             return false;
161         }
162     }
163 
164     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
165     // If this function is called again it overwrites the current allowance with _value.     
166     function approve(address _spender, uint256 _amount) 
167         returns (bool success) 
168     {
169         allowed[msg.sender][_spender] = _amount;
170         Approval(msg.sender, _spender, _amount);
171         return true;
172     }
173  
174     function allowance(address _owner, address _spender) 
175         constant 
176         returns (uint256 remaining) 
177     {
178         return allowed[_owner][_spender];
179     }
180 
181     /// @dev Set address of migration agent contract and enable migration
182     /// @param _agent The address of the MigrationAgent contract
183     function setMigrationAgent(address _agent) 
184         public
185         onlyOwner
186     {
187         if (!registered) throw;
188         if (migrationAgent != 0) throw;
189         migrationAgent = _agent;
190     }
191 
192     /// @dev Buyer can apply for migrating tokens to the new token contract.
193     /// @param _value The amount of token to be migrated
194     function applyMigrate(uint256 _value) 
195         public
196     {
197         if (!registered) throw;
198         if (migrationAgent == 0) throw;
199 
200         // Validate input value.
201         if (_value == 0) throw;
202         if (_value > balances[msg.sender]) throw;
203 
204         balances[msg.sender] -= _value;
205         totalTokens -= _value;
206         totalMigrated += _value;
207         migration(migrationAgent).migrateFrom(msg.sender, _value);
208         Migrate(msg.sender, migrationAgent, _value);
209     }
210 
211 
212     /// @dev Register for crowdsale and do the token pre-allocation.
213     /// @param _tokenFactory The address of ICO-sale contract
214     /// @param _congressAddress The address of multisig token contract
215     function registerSale(address _tokenFactory, address _congressAddress) 
216         public
217         onlyOwner 
218     {
219         // The token contract can be only registered once.
220         if (!registered) {
221             // Total supply
222             totalTokens  = 6100 * 1000 * 1000 * 10**18; 
223 
224             // (51%) of total supply to ico-sale contract
225             balances[_tokenFactory]    = 3111 * 1000 * 1000 * 10**18;
226 
227             // (34%) of total supply to the congress address for congress and partners
228             balances[_congressAddress] = 2074 * 1000 * 1000 * 10**18;
229 
230             // Allocate rest (15%) of total supply to development team and contributors
231             // 915,000,000 * 10**18;
232             teamAllocation();
233 
234             registered = true;
235             registrationTime = now;
236 
237             unlockat[0] = registrationTime +  6 * 30 days;
238             unlockat[1] = registrationTime + 12 * 30 days;
239             unlockat[2] = registrationTime + 24 * 30 days;
240         }
241     }
242 
243     /// @dev Allocate 15% of total supply to ten team members.
244     /// @param _account The address of account to be frozen.
245     /// @param _totalAmount The amount of tokens to be frozen.
246     function freeze(address _account, uint _totalAmount) 
247         public
248         onlyOwner 
249     {
250         frozenAccount[_account] = true;  
251         frozenTokens[_account][0] = _totalAmount;            // 100% of locked token within 6 months
252         frozenTokens[_account][1] = _totalAmount * 80 / 100; //  80% of locked token within 12 months
253         frozenTokens[_account][2] = _totalAmount * 50 / 100; //  50% of locked token within 24 months
254     }
255 
256     /// @dev Allocate 15% of total supply to the team members.
257     function teamAllocation() 
258         internal 
259     {
260         // 1.5% of total supply allocated to each team member.
261         uint individual = 91500 * 1000 * 10**18;
262 
263         balances[0xCDc5BDEFC6Fddc66E73250fCc2F08339e091dDA3] = individual; // 1.5% 
264         balances[0x8b47D27b085a661E6306Ac27A932a8c0b1C11b84] = individual; // 1.5% 
265         balances[0x825f4977DB4cd48aFa51f8c2c9807Ee89120daB7] = individual; // 1.5% 
266         balances[0xcDf5D7049e61b2F50642DF4cb5a005b1b4A5cfc2] = individual; // 1.5% 
267         balances[0xab0461FB41326a960d3a2Fe2328DD9A65916181d] = individual; // 1.5% 
268         balances[0xd2A131F16e4339B2523ca90431322f559ABC4C3d] = individual; // 1.5%
269         balances[0xCcB4d663E6b05AAda0e373e382628B9214932Fff] = individual; // 1.5% 
270         balances[0x60284720542Ff343afCA6a6DBc542901942260f2] = individual; // 1.5% 
271         balances[0xcb6d0e199081A489f45c73D1D22F6de58596a99C] = individual; // 1.5% 
272         balances[0x928D99333C57D31DB917B4c67D4d8a033F2143A7] = individual; // 1.5% 
273 
274         // Freeze tokens allocated to the team for at most two years.
275         // Freeze tokens in three phases
276         // 91500 * 1000 * 10**18; 100% of locked tokens within 6 months
277         // 73200 * 1000 * 10**18;  80% of locked tokens within 12 months
278         // 45750 * 1000 * 10**18;  50% of locked tokens within 24 months
279         freeze("0xCDc5BDEFC6Fddc66E73250fCc2F08339e091dDA3", individual);
280         freeze("0x8b47D27b085a661E6306Ac27A932a8c0b1C11b84", individual);
281         freeze("0x825f4977DB4cd48aFa51f8c2c9807Ee89120daB7", individual);
282         freeze("0xcDf5D7049e61b2F50642DF4cb5a005b1b4A5cfc2", individual);
283         freeze("0xab0461FB41326a960d3a2Fe2328DD9A65916181d", individual);
284         freeze("0xd2A131F16e4339B2523ca90431322f559ABC4C3d", individual);
285         freeze("0xCcB4d663E6b05AAda0e373e382628B9214932Fff", individual);
286         freeze("0x60284720542Ff343afCA6a6DBc542901942260f2", individual);
287         freeze("0xcb6d0e199081A489f45c73D1D22F6de58596a99C", individual);
288         freeze("0x928D99333C57D31DB917B4c67D4d8a033F2143A7", individual);
289     }
290 
291     /// @dev Token frozen rules for token holders.
292     /// @param _from The token sender.
293     /// @param _value The token amount.
294     function frozenRules(address _from, uint256 _value) 
295         internal 
296         returns (bool success) 
297     {
298         if (frozenAccount[_from]) {
299             if (now < unlockat[0]) {
300                // 100% locked within the first 6 months.
301                if (balances[_from] - _value < frozenTokens[_from][0]) 
302                     return true;  
303             } else if (now >= unlockat[0] && now < unlockat[1]) {
304                // 20% unlocked after 6 months.
305                if (balances[_from] - _value < frozenTokens[_from][1]) 
306                     return true;  
307             } else if (now >= unlockat[1] && now < unlockat[2]) {
308                // 50% unlocked after 12 months. 
309                if (balances[_from]- _value < frozenTokens[_from][2]) 
310                    return true;  
311             } else {
312                // 100% unlocked after 24 months.
313                frozenAccount[_from] = false; 
314             }
315         }
316         return false;
317     }   
318 }