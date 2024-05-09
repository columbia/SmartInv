1 pragma solidity 0.4.11;
2 
3 contract WolkToken {
4   mapping (address => uint256) balances;
5   mapping (address => uint256) allocations;
6   mapping (address => mapping (address => uint256)) allowed;
7   mapping (address => mapping (address => bool)) authorized; //trustee
8 
9   function transfer(address _to, uint256 _value) isTransferable returns (bool success) {
10     if (balances[msg.sender] >= _value && _value > 0) {
11       balances[msg.sender] = safeSub(balances[msg.sender], _value);
12       balances[_to] = safeAdd(balances[_to], _value);
13       Transfer(msg.sender, _to, _value, balances[msg.sender], balances[_to]);
14       return true;
15     } else {
16       return false;
17     }
18   }
19   
20   function transferFrom(address _from, address _to, uint256 _value) isTransferable returns (bool success) {
21     var _allowance = allowed[_from][msg.sender];
22     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
23       balances[_to] = safeAdd(balances[_to], _value);
24       balances[_from] = safeSub(balances[_from], _value);
25       allowed[_from][msg.sender] = safeSub(_allowance, _value);
26       Transfer(_from, _to, _value, balances[_from], balances[_to]);
27       return true;
28     } else {
29       return false;
30     }
31   }
32  
33    // Platform Settlement
34   function settleFrom(address _from, address _to, uint256 _value) isTransferable returns (bool success) {
35     var _allowance = allowed[_from][msg.sender];
36     var isPreauthorized = authorized[_from][msg.sender];
37     if (balances[_from] >= _value && ( isPreauthorized || _allowance >= _value ) && _value > 0) {
38       balances[_to] = safeAdd(balances[_to], _value);
39       balances[_from] = safeSub(balances[_from], _value);
40       Transfer(_from, _to, _value, balances[_from], balances[_to]);
41       if (isPreauthorized && _allowance < _value){
42           allowed[_from][msg.sender] = 0;
43       }else{
44           allowed[_from][msg.sender] = safeSub(_allowance, _value);
45       }
46       return true;
47     } else {
48       return false;
49     }
50   }
51 
52 
53   function totalSupply() external constant returns (uint256) {
54         return generalTokens + reservedTokens;
55   }
56  
57 
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 
63   function approve(address _spender, uint256 _value) returns (bool success) {
64     allowed[msg.sender][_spender] = _value;
65     Approval(msg.sender, _spender, _value);
66     return true;
67   }
68 
69 
70   /// @param _trustee Grant trustee permission to settle media spend
71   /// @return Whether the authorization was successful or not
72   function authorize(address _trustee) returns (bool success) {
73     authorized[msg.sender][_trustee] = true;
74     Authorization(msg.sender, _trustee);
75     return true;
76   }
77 
78   /// @param _trustee_to_remove Revoke trustee's permission on settle media spend 
79   /// @return Whether the deauthorization was successful or not
80   function deauthorize(address _trustee_to_remove) returns (bool success) {
81     authorized[msg.sender][_trustee_to_remove] = false;
82     Deauthorization(msg.sender, _trustee_to_remove);
83     return true;
84   }
85 
86   // @param _owner
87   // @param _trustee
88   // @return authorization_status for platform settlement 
89   function checkAuthorization(address _owner, address _trustee) constant returns (bool authorization_status) {
90     return authorized[_owner][_trustee];
91   }
92 
93   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
94     return allowed[_owner][_spender];
95   }
96 
97 
98   //**** ERC20 TOK Events:
99   event Transfer(address indexed _from, address indexed _to, uint256 _value, uint from_final_tok, uint to_final_tok);
100   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
101   event Authorization(address indexed _owner, address indexed _trustee);
102   event Deauthorization(address indexed _owner, address indexed _trustee_to_remove);
103 
104   event NewOwner(address _newOwner);
105   event MintEvent(uint reward_tok, address recipient);
106   event LogRefund(address indexed _to, uint256 _value);
107   event WolkCreated(address indexed _to, uint256 _value);
108   event Vested(address indexed _to, uint256 _value);
109 
110   modifier onlyOwner { assert(msg.sender == owner); _; }
111   modifier isOperational { assert(saleCompleted); _; }
112   modifier isTransferable { assert(generalTokens > crowdSaleMin); _;}
113   modifier is_not_dust { if (msg.value < dust) throw; _; } // must be sufficiently large (1 mwei) to not be considered dust.
114   
115   //**** ERC20 TOK fields:
116   string  public constant name = 'Wolk Coin';
117   string  public constant symbol = "WOLK";
118   string  public constant version = "1.0";
119   uint256 public constant decimals = 18;
120   uint256 public constant wolkFund  =  10 * 10**1 * 10**decimals;        //  100 Wolk in operation Fund
121   uint256 public constant crowdSaleMin =  10 * 10**3 * 10**decimals; //  10000 Wolk Min
122   uint256 public constant crowdSaleMax =  10 * 10**5 * 10**decimals; //  1000000 Wolk Max
123   uint256 public constant tokenExchangeRate = 10000;   // 10000 Wolk per 1 ETH
124   uint256 public constant dust = 1000000 wei; // 1 Mwei
125 
126   uint256 public generalTokens = wolkFund;     // tokens in circulation
127   uint256 public reservedTokens;              // Unvested developer tokens
128 
129   address public owner = 0x5fcf700654B8062B709a41527FAfCda367daE7b1; // MK - main
130   address public multisigWallet = 0x6968a9b90245cB9bD2506B9460e3D13ED4B2FD1e; 
131 
132   uint256 public constant start_block = 3843600;   // Sale Starting block
133   uint256 public end_block = 3847200;              // Sale Ending block when crowdSaleMax not reached
134   uint256 public unlockedAt;                       // team vesting  
135   uint256 public end_ts;                           // sale End time
136   
137   bool public saleCompleted = false;               
138   bool public fairsaleProtection = true;         
139 
140  
141 
142   // Migration support
143   //address migrationMaster;
144 
145 
146   // Constructor:
147   function Wolk() onlyOwner {
148 
149     // Wolk Inc has 25MM Wolk, 5MM of which is allocated for Wolk Inc Founding staff, who vest at "unlockedAt" time
150     reservedTokens = 25 * 10**decimals;
151     allocations[0x564a3f7d98Eb5B1791132F8875fef582d528d5Cf] = 20; // unassigned
152     allocations[0x7f512CCFEF05F651A70Fa322Ce27F4ad79b74ffe] = 1;  // Sourabh
153     allocations[0x9D203A36cd61b21B7C8c7Da1d8eeB13f04bb24D9] = 2;  // Michael - Test
154     allocations[0x5fcf700654B8062B709a41527FAfCda367daE7b1] = 1;  // Michael - Main
155     allocations[0xC28dA4d42866758d0Fc49a5A3948A1f43de491e9] = 1;  // Urmi
156     
157     balances[owner] = wolkFund; // 100 wOlk growth fund
158     WolkCreated(owner, wolkFund);
159   }
160 
161   // VESTING SUPPORT
162   function unlock() external {
163     if (now < unlockedAt) throw;
164     uint256 vested = allocations[msg.sender] * 10**decimals;
165     if (vested < 0 ) throw; // Will fail if allocation (and therefore toTransfer) is 0.
166     allocations[msg.sender] = 0;
167     reservedTokens = safeSub(reservedTokens, vested);
168     balances[msg.sender] = safeAdd(balances[msg.sender], vested); 
169     Vested(msg.sender, vested);
170   }
171 
172   // CROWDSALE SUPPORT
173   function redeemToken() payable is_not_dust external {
174     if (saleCompleted) throw;
175     if (block.number < start_block) throw;
176     if (block.number > end_block) throw;
177     if (msg.value <= dust) throw;
178     if (tx.gasprice > 0.46 szabo && fairsaleProtection) throw; 
179     if (msg.value > 1 ether && fairsaleProtection) throw; 
180 
181     uint256 tokens = safeMul(msg.value, tokenExchangeRate); // check that we're not over totals
182     uint256 checkedSupply = safeAdd(generalTokens, tokens);
183     if ( checkedSupply > crowdSaleMax) throw; // they need to get their money back if something goes wrong
184       generalTokens = checkedSupply;
185       balances[msg.sender] = safeAdd(balances[msg.sender], tokens);   // safeAdd not needed; bad semantics to use here
186       WolkCreated(msg.sender, tokens); // logs token creation
187     
188   }
189   
190 
191 
192   // Disabling fairsale protection  
193   function fairsaleProtectionOFF() onlyOwner {
194     if ( block.number - start_block < 2000) throw; // fairsale window is strictly enforced for the first 2000 blocks
195     fairsaleProtection = false;
196   }
197 
198 
199   // Finalizing the crowdsale
200   function finalize() onlyOwner {
201     if ( saleCompleted ) throw;
202     if ( generalTokens < crowdSaleMin ) throw; 
203     if ( block.number < end_block ) throw;  
204     saleCompleted = true;
205     end_ts = now;
206     end_block = block.number; 
207     unlockedAt = end_ts + 30 minutes;
208     if ( ! multisigWallet.send(this.balance) ) throw;
209   }
210 
211   function withdraw() onlyOwner{ 		
212 		if ( this.balance == 0) throw;
213 		if ( generalTokens < crowdSaleMin) throw;	
214         if ( ! multisigWallet.send(this.balance) ) throw;
215   }
216 
217 
218   function refund() {
219     if ( saleCompleted ) throw; 
220     if ( block.number < end_block ) throw;   
221     if ( generalTokens >= crowdSaleMin ) throw;  
222     if ( msg.sender == owner ) throw;
223     uint256 Val = balances[msg.sender];
224     balances[msg.sender] = 0;
225     generalTokens = safeSub(generalTokens, Val);
226     uint256 ethVal = safeDiv(Val, tokenExchangeRate);
227     LogRefund(msg.sender, ethVal);
228     if ( ! msg.sender.send(ethVal) ) throw;
229   }
230     
231 
232   // MINTING SUPPORT - Rewarding growth tokens for value-addeddata suppliers
233   
234   modifier onlyMinter { assert(msg.sender == minter_address); _; }
235  
236   address public minter_address = owner;
237 
238  // minting support
239   //uint public max_creation_rate_per_second; // Maximum token creation rate per second
240   //address public minter_address;            // Has permission to mint
241   
242   function mintTokens(uint reward_tok, address recipient) external payable onlyMinter isOperational
243   {
244     balances[recipient] = safeAdd(balances[recipient], reward_tok);
245     generalTokens = safeAdd(generalTokens, reward_tok);
246     MintEvent(reward_tok, recipient);
247   }
248 
249   function changeMintingAddress(address newAddress) onlyOwner returns (bool success) { 
250     minter_address = newAddress; 
251     return true;
252   }
253 
254   
255   //**** SafeMath:
256   function safeMul(uint a, uint b) internal returns (uint) {
257     uint c = a * b;
258     assert(a == 0 || c / a == b);
259     return c;
260   }
261   
262   function safeDiv(uint a, uint b) internal returns (uint) {
263     assert(b > 0);
264     uint c = a / b;
265     assert(a == b * c + a % b);
266     return c;
267   }
268   
269   function safeSub(uint a, uint b) internal returns (uint) {
270     assert(b <= a);
271     return a - b;
272   }
273   
274   function safeAdd(uint a, uint b) internal returns (uint) {
275     uint c = a + b;
276     assert(c>=a && c>=b);
277     return c;
278   }
279 
280   function assert(bool assertion) internal {
281     if (!assertion) throw;
282   }
283 }