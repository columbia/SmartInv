1 pragma solidity 0.4.18;
2 
3 
4 contract Owned {
5     // The address of the account of the current owner
6     address public owner;
7 
8     // The publiser is the inital owner
9     function Owned() public {
10         owner = msg.sender;
11     }
12 
13     /**
14      * Access is restricted to the current owner
15      */
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     /**
22      * Transfer ownership to `_newOwner`
23      *
24      * @param _newOwner The address of the account that will become the new owner
25      */
26     function transferOwnership(address _newOwner) public onlyOwner {
27         owner = _newOwner;
28     }
29 }
30 
31 
32 // ERC Token Standard #20 Interface
33 // https://github.com/ethereum/EIPs/issues/20
34 contract ERC20Interface {
35     // Total supply
36     uint256 public totalSupply; // Implicit getter
37 
38     // Get the account balance of another account with address _owner
39     function balanceOf(address _owner) public constant returns (uint256 balance);
40 
41     // Send _amount amount of tokens to address _to
42     function transfer(address _to, uint256 _amount) public returns (bool success);
43 
44     // Send _amount amount of tokens from address _from to address _to
45     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
46 
47     // Allow _spender to withdraw from your account, multiple times, up to the _amount amount.
48     // If this function is called again it overwrites the current allowance with _amount.
49     // this function is required for some DEX functionality
50     function approve(address _spender, uint256 _amount) public returns (bool success);
51 
52     // Returns the amount which _spender is still allowed to withdraw from _owner
53     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
54 
55     // Triggered when tokens are transferred.
56     event TransferEvent(address indexed _from, address indexed _to, uint256 _amount);
57 
58     // Triggered whenever approve(address _spender, uint256 _amount) is called.
59     event ApprovalEvent(address indexed _owner, address indexed _spender, uint256 _amount);
60 }
61 
62 
63 /**
64  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
65  *
66  * Modified version of https://github.com/ConsenSys/Tokens that implements the
67  * original Token contract, an abstract contract for the full ERC 20 Token standard
68  */
69 contract EngravedToken is ERC20Interface, Owned {
70     string public constant symbol = "EGR";
71     string public constant name = "Engraved Token";
72     uint8 public constant decimals = 3;
73 
74     // Core team incentive distribution
75     bool public incentiveDistributionStarted = false;
76     uint256 public incentiveDistributionDate = 0;
77     uint256 public incentiveDistributionRound = 1;
78     uint256 public incentiveDistributionMaxRounds = 4;
79     uint256 public incentiveDistributionInterval = 1 years;
80     uint256 public incentiveDistributionRoundDenominator = 2;
81 
82     // Core team incentives
83     struct Incentive {
84         address recipient;
85         uint8 percentage;
86     }
87 
88     Incentive[] public incentives;
89 
90     // Token starts if the locked state restricting transfers
91     bool public locked;
92 
93     // Balances for each account
94     mapping(address => uint256) internal balances;
95 
96     // Owner of account approves the transfer of an amount to another account
97     mapping(address => mapping (address => uint256)) internal allowed;
98 
99     // Constructor
100     function EngravedToken() public {
101         owner = msg.sender;
102         balances[owner] = 0;
103         totalSupply = 0;
104         locked = true;
105 
106         incentives.push(Incentive(0xCA73c8705cbc5942f42Ad39bC7EAeCA8228894BB, 5)); // 5% founder
107         incentives.push(Incentive(0xd721f5c14a4AF2625AF1E1E107Cc148C8660BA72, 5)); // 5% founder
108     }
109 
110     /**
111      * Prevents accidental sending of ether
112      */
113     function() public {
114         assert(false);
115     }
116 
117     /**
118      * Get balance of `_owner`
119      *
120      * @param _owner The address from which the balance will be retrieved
121      * @return The balance
122      */
123     function balanceOf(address _owner) public constant returns (uint256 balance) {
124         return balances[_owner];
125     }
126 
127     /**
128      * Send `_amount` token to `_to` from `msg.sender`
129      *
130      * @param _to The address of the recipient
131      * @param _amount The amount of token to be transferred
132      * @return Whether the transfer was successful or not
133      */
134     function transfer(address _to, uint256 _amount) public returns (bool success) {
135         require(!locked);
136         require(balances[msg.sender] >= _amount);
137         require(_amount > 0);
138         assert(balances[_to] + _amount > balances[_to]);
139 
140         balances[msg.sender] -= _amount;
141         balances[_to] += _amount;
142         TransferEvent(msg.sender, _to, _amount);
143         return true;
144     }
145 
146     /**
147      * Send `_amount` token to `_to` from `_from` on the condition it is approved by `_from`
148      *
149      * @param _from The address of the sender
150      * @param _to The address of the recipient
151      * @param _amount The amount of token to be transferred
152      * @return Whether the transfer was successful or not
153      */
154     function transferFrom (
155         address _from,
156         address _to,
157         uint256 _amount
158     ) public returns (bool success) {
159         require(!locked);
160         require(balances[_from] >= _amount);
161         require(allowed[_from][msg.sender] >= _amount);
162         require(_amount > 0);
163         assert(balances[_to] + _amount > balances[_to]);
164 
165         balances[_from] -= _amount;
166         allowed[_from][msg.sender] -= _amount;
167         balances[_to] += _amount;
168         TransferEvent(_from, _to, _amount);
169         return true;
170     }
171 
172     /**
173      * `msg.sender` approves `_spender` to spend `_amount` tokens
174      *
175      * @param _spender The address of the account able to transfer the tokens
176      * @param _amount The amount of tokens to be approved for transfer
177      * @return Whether the approval was successful or not
178      */
179     function approve(address _spender, uint256 _amount) public returns (bool success) {
180         require(!locked);
181 
182         // Update allowance
183         allowed[msg.sender][_spender] = _amount;
184 
185         // Notify listners
186         ApprovalEvent(msg.sender, _spender, _amount);
187         return true;
188     }
189 
190     /**
191      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
192      *
193      * @param _owner The address of the account owning tokens
194      * @param _spender The address of the account able to transfer the tokens
195      * @return Amount of remaining tokens allowed to spent
196      */
197     function allowance(address _owner, address _spender) public constant returns (
198         uint256 remaining
199     ) {
200         return allowed[_owner][_spender];
201     }
202 
203     /**
204      * Starts incentive distribution
205      *
206      * Called by the crowdsale contract when tokenholders voted
207      * for the transfer of ownership of the token contract to DCorp
208      *
209      * @return Whether the incentive distribution was started
210      */
211     function startIncentiveDistribution() public onlyOwner returns (bool success) {
212         if (!incentiveDistributionStarted) {
213             incentiveDistributionDate = now;
214             incentiveDistributionStarted = true;
215         }
216 
217         return incentiveDistributionStarted;
218     }
219 
220     /**
221      * Distributes incentives over the core team members as
222      * described in the whitepaper
223      */
224     function withdrawIncentives() public {
225         // Crowdsale triggers incentive distribution
226         require(incentiveDistributionStarted);
227 
228         // Enforce max distribution rounds
229         require(incentiveDistributionRound < incentiveDistributionMaxRounds);
230 
231         // Enforce time interval
232         require(now > incentiveDistributionDate);
233 
234         uint256 totalSupplyToDate = totalSupply;
235         uint256 denominator = 1;
236 
237         // Incentive decreased each round
238         if (incentiveDistributionRound > 1) {
239             denominator = incentiveDistributionRoundDenominator**(incentiveDistributionRound - 1);
240         }
241 
242         for (uint256 i = 0; i < incentives.length; i++) {
243 
244             uint256 amount = totalSupplyToDate * incentives[i].percentage / 10**2 / denominator;
245             address recipient = incentives[i].recipient;
246 
247             // Create tokens
248             balances[recipient] += amount;
249             totalSupply += amount;
250 
251             // Notify listeners
252             TransferEvent(0, this, amount);
253             TransferEvent(this, recipient, amount);
254         }
255 
256         // Next round
257         incentiveDistributionDate = now + incentiveDistributionInterval;
258         incentiveDistributionRound++;
259     }
260 
261     /**
262      * Unlocks the token irreversibly so that the transfering of value is enabled
263      *
264      * @return Whether the unlocking was successful or not
265      */
266     function unlock() public onlyOwner returns (bool success) {
267         locked = false;
268         return true;
269     }
270 
271     /**
272      * Issues `_amount` new tokens to `_recipient` (_amount < 0 guarantees that tokens are never removed)
273      *
274      * @param _recipient The address to which the tokens will be issued
275      * @param _amount The amount of new tokens to issue
276      * @return Whether the approval was successful or not
277      */
278     function issue(address _recipient, uint256 _amount) public onlyOwner returns (bool success) {
279         // Guarantee positive
280         require(_amount >= 0);
281 
282         // Create tokens
283         balances[_recipient] += _amount;
284         totalSupply += _amount;
285 
286         // Notify listners
287         TransferEvent(0, owner, _amount);
288         TransferEvent(owner, _recipient, _amount);
289 
290         return true;
291     }
292 
293 }