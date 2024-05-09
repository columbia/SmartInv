1 pragma solidity 0.4.15;
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
39     function balanceOf(address _owner) constant returns (uint256 balance);
40 
41     // Send _amount amount of tokens to address _to
42     function transfer(address _to, uint256 _amount) returns (bool success);
43 
44     // Send _amount amount of tokens from address _from to address _to
45     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
46 
47     // Allow _spender to withdraw from your account, multiple times, up to the _amount amount.
48     // If this function is called again it overwrites the current allowance with _amount.
49     // this function is required for some DEX functionality
50     function approve(address _spender, uint256 _amount) returns (bool success);
51 
52     // Returns the amount which _spender is still allowed to withdraw from _owner
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
54 
55     // Triggered when tokens are transferred.
56     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
57 
58     // Triggered whenever approve(address _spender, uint256 _amount) is called.
59     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
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
94     mapping(address => uint256) balances;
95 
96     // Owner of account approves the transfer of an amount to another account
97     mapping(address => mapping (address => uint256)) allowed;
98 
99     // Constructor
100     function EngravedToken() {
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
111      * Get balance of `_owner`
112      *
113      * @param _owner The address from which the balance will be retrieved
114      * @return The balance
115      */
116     function balanceOf(address _owner) constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120     /**
121      * Send `_amount` token to `_to` from `msg.sender`
122      *
123      * @param _to The address of the recipient
124      * @param _amount The amount of token to be transferred
125      * @return Whether the transfer was successful or not
126      */
127     function transfer(address _to, uint256 _amount) returns (bool success) {
128 
129         require(!locked);
130         require(balances[msg.sender] >= _amount);
131         require(_amount > 0);
132         assert(balances[_to] + _amount > balances[_to]);
133 
134         balances[msg.sender] -= _amount;
135         balances[_to] += _amount;
136         Transfer(msg.sender, _to, _amount);
137         return true;
138     }
139 
140     /**
141      * Send `_amount` token to `_to` from `_from` on the condition it is approved by `_from`
142      *
143      * @param _from The address of the sender
144      * @param _to The address of the recipient
145      * @param _amount The amount of token to be transferred
146      * @return Whether the transfer was successful or not
147      */
148     function transferFrom (
149         address _from,
150         address _to,
151         uint256 _amount
152     ) public returns (bool success) {
153         require(!locked);
154         require(balances[_from] >= _amount);
155         require(allowed[_from][msg.sender] >= _amount);
156         require(_amount > 0);
157         assert(balances[_to] + _amount > balances[_to]);
158 
159         balances[_from] -= _amount;
160         allowed[_from][msg.sender] -= _amount;
161         balances[_to] += _amount;
162         Transfer(_from, _to, _amount);
163         return true;
164     }
165 
166     /**
167      * `msg.sender` approves `_spender` to spend `_amount` tokens
168      *
169      * @param _spender The address of the account able to transfer the tokens
170      * @param _amount The amount of tokens to be approved for transfer
171      * @return Whether the approval was successful or not
172      */
173     function approve(address _spender, uint256 _amount) returns (bool success) {
174         require(!locked);
175 
176         // Update allowance
177         allowed[msg.sender][_spender] = _amount;
178 
179         // Notify listners
180         Approval(msg.sender, _spender, _amount);
181         return true;
182     }
183 
184     /**
185      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
186      *
187      * @param _owner The address of the account owning tokens
188      * @param _spender The address of the account able to transfer the tokens
189      * @return Amount of remaining tokens allowed to spent
190      */
191     function allowance(address _owner, address _spender) public constant returns (
192         uint256 remaining
193     ) {
194         return allowed[_owner][_spender];
195     }
196 
197     /**
198      * Starts incentive distribution
199      *
200      * Called by the crowdsale contract when tokenholders voted
201      * for the transfer of ownership of the token contract to DCorp
202      *
203      * @return Whether the incentive distribution was started
204      */
205     function startIncentiveDistribution() public onlyOwner returns (bool success) {
206         if (!incentiveDistributionStarted) {
207             incentiveDistributionDate = now;
208             incentiveDistributionStarted = true;
209         }
210 
211         return incentiveDistributionStarted;
212     }
213 
214     /**
215      * Distributes incentives over the core team members as
216      * described in the whitepaper
217      */
218     function withdrawIncentives() public {
219         // Crowdsale triggers incentive distribution
220         require(incentiveDistributionStarted);
221 
222         // Enforce max distribution rounds
223         require(incentiveDistributionRound < incentiveDistributionMaxRounds);
224 
225         // Enforce time interval
226         require(now > incentiveDistributionDate);
227 
228         uint256 totalSupplyToDate = totalSupply;
229         uint256 denominator = 1;
230 
231         // Incentive decreased each round
232         if (incentiveDistributionRound > 1) {
233             denominator = incentiveDistributionRoundDenominator**(incentiveDistributionRound - 1);
234         }
235 
236         for (uint256 i = 0; i < incentives.length; i++) {
237 
238             uint256 amount = totalSupplyToDate * incentives[i].percentage / 10**2 / denominator;
239             address recipient = incentives[i].recipient;
240 
241             // Create tokens
242             balances[recipient] += amount;
243             totalSupply += amount;
244 
245             // Notify listeners
246             Transfer(0, this, amount);
247             Transfer(this, recipient, amount);
248         }
249 
250         // Next round
251         incentiveDistributionDate = now + incentiveDistributionInterval;
252         incentiveDistributionRound++;
253     }
254 
255     /**
256      * Unlocks the token irreversibly so that the transfering of value is enabled
257      *
258      * @return Whether the unlocking was successful or not
259      */
260     function unlock() public onlyOwner returns (bool success) {
261         locked = false;
262         return true;
263     }
264 
265     /**
266      * Issues `_amount` new tokens to `_recipient` (_amount < 0 guarantees that tokens are never removed)
267      *
268      * @param _recipient The address to which the tokens will be issued
269      * @param _amount The amount of new tokens to issue
270      * @return Whether the approval was successful or not
271      */
272     function issue(address _recipient, uint256 _amount) public onlyOwner returns (bool success) {
273         // Guarantee positive
274         require(_amount >= 0);
275 
276         // Create tokens
277         balances[_recipient] += _amount;
278         totalSupply += _amount;
279 
280         // Notify listners
281         Transfer(0, owner, _amount);
282         Transfer(owner, _recipient, _amount);
283 
284         return true;
285     }
286 
287     /**
288      * Prevents accidental sending of ether
289      */
290     function () {
291         assert(false);
292     }
293 
294 }