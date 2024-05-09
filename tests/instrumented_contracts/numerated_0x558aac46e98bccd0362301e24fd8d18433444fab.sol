1 pragma solidity 0.4.11;
2 
3 contract Wolker {
4   mapping (address => uint256) balances;
5   mapping (address => uint256) allocations;
6   mapping (address => mapping (address => uint256)) allowed;
7   mapping (address => mapping (address => bool)) authorized; //trustee
8 
9   /// @param _to The address of the recipient
10   /// @param _value The amount of token to be transferred
11   /// @return Whether the transfer was successful or not
12   function transfer(address _to, uint256 _value) returns (bool success) {
13     if (balances[msg.sender] >= _value && _value > 0) {
14       balances[msg.sender] = safeSub(balances[msg.sender], _value);
15       balances[_to] = safeAdd(balances[_to], _value);
16       Transfer(msg.sender, _to, _value, balances[msg.sender], balances[_to]);
17       return true;
18     } else {
19       throw;
20     }
21   }
22   
23   /// @param _from The address of the sender
24   /// @param _to The address of the recipient
25   /// @param _value The amount of token to be transferred
26   /// @return Whether the transfer was successful or not
27   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
28     var _allowance = allowed[_from][msg.sender];
29     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
30       balances[_to] = safeAdd(balances[_to], _value);
31       balances[_from] = safeSub(balances[_from], _value);
32       allowed[_from][msg.sender] = safeSub(_allowance, _value);
33       Transfer(_from, _to, _value, balances[_from], balances[_to]);
34       return true;
35     } else {
36       throw;
37     }
38   }
39  
40   /// @return total amount of tokens
41   function totalSupply() external constant returns (uint256) {
42         return generalTokens + reservedTokens;
43   }
44  
45   /// @param _owner The address from which the balance will be retrieved
46   /// @return The balance
47   function balanceOf(address _owner) constant returns (uint256 balance) {
48     return balances[_owner];
49   }
50 
51 
52   /// @param _spender The address of the account able to transfer the tokens
53   /// @param _value The amount of Wolk token to be approved for transfer
54   /// @return Whether the approval was successful or not
55   function approve(address _spender, uint256 _value) returns (bool success) {
56     allowed[msg.sender][_spender] = _value;
57     Approval(msg.sender, _spender, _value);
58     return true;
59   }
60 
61 
62   /// @param _trustee Grant trustee permission to settle media spend
63   /// @return Whether the authorization was successful or not
64   function authorize(address _trustee) returns (bool success) {
65     authorized[msg.sender][_trustee] = true;
66     Authorization(msg.sender, _trustee);
67     return true;
68   }
69 
70   /// @param _trustee_to_remove Revoke trustee's permission on settle media spend 
71   /// @return Whether the deauthorization was successful or not
72   function deauthorize(address _trustee_to_remove) returns (bool success) {
73     authorized[msg.sender][_trustee_to_remove] = false;
74     Deauthorization(msg.sender, _trustee_to_remove);
75     return true;
76   }
77 
78   // @param _owner
79   // @param _trustee
80   // @return authorization_status for platform settlement 
81   function check_authorization(address _owner, address _trustee) constant returns (bool authorization_status) {
82     return authorized[_owner][_trustee];
83   }
84 
85   /// @param _owner The address of the account owning tokens
86   /// @param _spender The address of the account able to transfer the tokens
87   /// @return Amount of remaining tokens allowed to spent
88   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89     return allowed[_owner][_spender];
90   }
91 
92 
93   //**** ERC20 TOK Events:
94   event Transfer(address indexed _from, address indexed _to, uint256 _value, uint from_final_tok, uint to_final_tok);
95   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96   event Authorization(address indexed _owner, address indexed _trustee);
97   event Deauthorization(address indexed _owner, address indexed _trustee_to_remove);
98 
99   event NewOwner(address _newOwner);
100   event MintEvent(uint reward_tok, address recipient);
101   event LogRefund(address indexed _to, uint256 _value);
102   event CreateWolk(address indexed _to, uint256 _value);
103   event Vested(address indexed _to, uint256 _value);
104 
105   modifier onlyOwner {
106     assert(msg.sender == owner);
107     _;
108   }
109 
110   modifier isOperational() {
111     assert(isFinalized);
112     _;
113   }
114 
115 
116   //**** ERC20 TOK fields:
117   string  public constant name = 'Wolk';
118   string  public constant symbol = "WOLK";
119   string  public constant version = "0.2";
120   uint256 public constant decimals = 18;
121   uint256 public constant wolkFund  =  10 * 10**1 * 10**decimals;        //  100 Wolk in operation Fund
122   uint256 public constant tokenCreationMin =  20 * 10**1 * 10**decimals; //  200 Wolk Min
123   uint256 public constant tokenCreationMax = 100 * 10**1 * 10**decimals; // 1000 Wolk Max
124   uint256 public constant tokenExchangeRate = 10000;   // 10000 Wolk per 1 ETH
125   uint256 public generalTokens = wolkFund; // tokens in circulation
126   uint256 public reservedTokens; 
127 
128   //address public owner = msg.sender;
129   address public owner = 0xC28dA4d42866758d0Fc49a5A3948A1f43de491e9; // michael - main
130   address public multisig_owner = 0x6968a9b90245cB9bD2506B9460e3D13ED4B2FD1e; // new multi-sig
131 
132   bool public isFinalized = false;          // after token sale success, this is true
133   uint public constant dust = 1000000 wei; 
134   bool public fairsale_protection = true;
135 
136   
137      // Actual crowdsale
138   uint256 public start_block;                // Starting block
139   uint256 public end_block;                  // Ending block
140   uint256 public unlockedAt;                 // Unlocking block 
141  
142   uint256 public end_ts;                     // Unix End time
143 
144 
145   // minting support
146   //uint public max_creation_rate_per_second; // Maximum token creation rate per second
147   //address public minter_address;            // Has permission to mint
148 
149   // migration support
150   //address migrationMaster;
151 
152 
153   //**** Constructor:
154   function Wolk() 
155   {
156 
157     // Actual crowdsale
158     start_block = 3831300;
159     end_block = 3831900;
160 
161     // wolkFund is 100
162     balances[msg.sender] = wolkFund;
163 
164     // Wolk Inc has 25MM Wolk, 5MM of which is allocated for Wolk Inc Founding staff, who vest at "unlockedAt" time
165     reservedTokens = 25 * 10**decimals;
166     allocations[0x564a3f7d98Eb5B1791132F8875fef582d528d5Cf] = 20; // unassigned
167     allocations[0x7f512CCFEF05F651A70Fa322Ce27F4ad79b74ffe] = 1;  // Sourabh
168     allocations[0x9D203A36cd61b21B7C8c7Da1d8eeB13f04bb24D9] = 2;  // Michael - Test
169     allocations[0x5fcf700654B8062B709a41527FAfCda367daE7b1] = 1;  // Michael - Main
170     allocations[0xC28dA4d42866758d0Fc49a5A3948A1f43de491e9] = 1;  // Urmi
171     
172     
173     CreateWolk(msg.sender, wolkFund); 
174   }
175 
176   // ****** VESTING SUPPORT
177   /// @notice Allow developer to unlock allocated tokens by transferring them to developer's address on vesting schedule of "vested 100% on 1 year)
178   function unlock() external {
179     if (now < unlockedAt) throw;
180     uint256 vested = allocations[msg.sender] * 10**decimals;
181     if (vested < 0 ) throw; // Will fail if allocation (and therefore toTransfer) is 0.
182     allocations[msg.sender] = 0;
183     reservedTokens = safeSub(reservedTokens, vested);
184     balances[msg.sender] = safeAdd(balances[msg.sender], vested); 
185     Vested(msg.sender, vested);
186   }
187 
188   // ******* CROWDSALE SUPPORT
189   // Accepts ETH and creates WOLK
190   function createTokens() payable external is_not_dust {
191     if (isFinalized) throw;
192     if (block.number < start_block) throw;
193     if (block.number > end_block) throw;
194     if (msg.value == 0) throw;
195     if (tx.gasprice > 0.021 szabo && fairsale_protection) throw; 
196     if (msg.value > 0.04 ether && fairsale_protection) throw; 
197 
198     uint256 tokens = safeMul(msg.value, tokenExchangeRate); // check that we're not over totals
199     uint256 checkedSupply = safeAdd(generalTokens, tokens);
200     if ( checkedSupply > tokenCreationMax) { 
201       throw; // they need to get their money back if something goes wrong
202     } else {
203       generalTokens = checkedSupply;
204       balances[msg.sender] = safeAdd(balances[msg.sender], tokens);   // safeAdd not needed; bad semantics to use here
205       CreateWolk(msg.sender, tokens); // logs token creation
206     }
207   }
208   
209   // The value of the message must be sufficiently large to not be considered dust.
210   modifier is_not_dust { if (msg.value < dust) throw; _; }
211 
212   // Disabling fairsale protection  
213   function fairsale_protectionOFF() external {
214     if ( block.number - start_block < 200) throw; // fairsale window is strictly enforced
215     if ( msg.sender != owner ) throw;
216     fairsale_protection = false;
217   }
218 
219   // Finalizing the crowdsale
220   function finalize() external {
221     if ( isFinalized ) throw;
222     if ( msg.sender != owner ) throw;  // locks finalize to ETH owner
223     if ( generalTokens < tokenCreationMin ) throw; // have to sell tokenCreationMin to finalize
224     if ( block.number < end_block ) throw;  
225     isFinalized = true;
226     end_ts = now;
227     unlockedAt = end_ts + 2 minutes;
228     if ( ! multisig_owner.send(this.balance) ) throw;
229   }
230 
231   function refund() external {
232     if ( isFinalized ) throw; 
233     if ( block.number < end_block ) throw;   
234     if ( generalTokens >= tokenCreationMin ) throw;  
235     if ( msg.sender == owner ) throw;
236     uint256 Val = balances[msg.sender];
237     balances[msg.sender] = 0;
238     generalTokens = safeSub(generalTokens, Val);
239     uint256 ethVal = safeDiv(Val, tokenExchangeRate);
240     LogRefund(msg.sender, ethVal);
241     if ( ! msg.sender.send(ethVal) ) throw;
242   }
243     
244   // ****** Platform Settlement
245   function settleFrom(address _from, address _to, uint256 _value) isOperational() external returns (bool success) {
246     if ( msg.sender != owner ) throw;
247     var _allowance = allowed[_from][msg.sender];
248     if (balances[_from] >= _value && (allowed[_from][msg.sender] >= _value || authorized[_from][msg.sender] == true ) && _value > 0) {
249       balances[_to] = safeAdd(balances[_to], _value);
250       balances[_from] = safeSub(balances[_from], _value);
251       allowed[_from][msg.sender] = safeSub(_allowance, _value);
252       if ( allowed[_from][msg.sender] < 0 ){
253          allowed[_from][msg.sender] = 0;
254       }
255       Transfer(_from, _to, _value, balances[_from], balances[_to]);
256       return true;
257     } else {
258       throw;
259     }
260   }
261 
262   // ****** MINTING SUPPORT
263   // Mint new tokens
264   modifier only_minter {
265     assert(msg.sender == minter_address);
266     _;
267   }
268   
269   address public minter_address = owner;            // Has permission to mint
270 
271   function mintTokens(uint reward_tok, address recipient) external payable only_minter
272   {
273     balances[recipient] = safeAdd(balances[recipient], reward_tok);
274     generalTokens = safeAdd(generalTokens, reward_tok);
275     MintEvent(reward_tok, recipient);
276   }
277 
278   function changeMintingAddress(address newAddress) onlyOwner returns (bool success) { 
279     minter_address = newAddress; 
280     return true;
281   }
282 
283   
284   //**** SafeMath:
285   function safeMul(uint a, uint b) internal returns (uint) {
286     uint c = a * b;
287     assert(a == 0 || c / a == b);
288     return c;
289   }
290   
291   function safeDiv(uint a, uint b) internal returns (uint) {
292     assert(b > 0);
293     uint c = a / b;
294     assert(a == b * c + a % b);
295     return c;
296   }
297   
298   function safeSub(uint a, uint b) internal returns (uint) {
299     assert(b <= a);
300     return a - b;
301   }
302   
303   function safeAdd(uint a, uint b) internal returns (uint) {
304     uint c = a + b;
305     assert(c>=a && c>=b);
306     return c;
307   }
308 
309   function assert(bool assertion) internal {
310     if (!assertion) throw;
311   }
312 }