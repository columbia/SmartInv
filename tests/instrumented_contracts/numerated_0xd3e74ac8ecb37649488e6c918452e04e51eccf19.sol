1 pragma solidity ^0.4.8;
2 
3 // folio.ninja ERC20 Token & Crowdsale Contract
4 // Contact: info@folio.ninja
5 // Cap of 12,632,000 Tokens
6 // 632,000 Tokens to Foundation
7 // 25,000 ETH Cap that goes to Developers
8 // Allows subsequent contribution / minting if cap not reached.
9 
10 contract Assertive {
11   function assert(bool assertion) internal {
12       if (!assertion) throw;
13   }
14 }
15 
16 contract SafeMath is Assertive{
17     function safeMul(uint a, uint b) internal returns (uint) {
18         uint c = a * b;
19         assert(a == 0 || c / a == b);
20         return c;
21     }
22 
23     function safeSub(uint a, uint b) internal returns (uint) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function safeAdd(uint a, uint b) internal returns (uint) {
29         uint c = a + b;
30         assert(c>=a && c>=b);
31         return c;
32     }
33 }
34 
35 contract ERC20Protocol {
36     function totalSupply() constant returns (uint256 totalSupply) {}
37     function balanceOf(address _owner) constant returns (uint256 balance) {}
38     function transfer(address _to, uint256 _value) returns (bool success) {}
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
40     function approve(address _spender, uint256 _value) returns (bool success) {}
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract ERC20 is ERC20Protocol {
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { 
55             return false;
56         }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
61             balances[_to] += _value;
62             balances[_from] -= _value;
63             allowed[_from][msg.sender] -= _value;
64             Transfer(_from, _to, _value);
65             return true;
66         } else { 
67             return false;
68         }
69     }
70 
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82         return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint256) balances;
86 
87     mapping (address => mapping (address => uint256)) allowed;
88 
89     uint256 public totalSupply;
90 }
91 
92 // Folio Ninja Token Contract
93 contract FolioNinjaToken is ERC20, SafeMath {
94     // Consant token specific fields
95     string public constant name = "folio.ninja";
96     string public constant symbol = "FLN";
97     uint public constant decimals = 18;
98     uint public constant MAX_TOTAL_TOKEN_AMOUNT = 12632000 * 10 ** decimals;
99 
100     // Fields that are only changed in constructor
101     address public minter; // Contribution contract
102     address public FOUNDATION_WALLET; // Can change to other minting contribution contracts but only until total amount of token minted
103     uint public startTime; // Contribution start time in seconds
104     uint public endTime; // Contribution end time in seconds
105 
106     // MODIFIERS
107     modifier only_minter {
108         assert(msg.sender == minter);
109         _;
110     }
111 
112     modifier only_foundation {
113         assert(msg.sender == FOUNDATION_WALLET);
114         _;
115     }
116 
117     modifier is_later_than(uint x) {
118         assert(now > x);
119         _;
120     }
121 
122     modifier max_total_token_amount_not_reached(uint amount) {
123         assert(safeAdd(totalSupply, amount) <= MAX_TOTAL_TOKEN_AMOUNT);
124         _;
125     }
126 
127     // METHODS
128     function FolioNinjaToken(address setMinter, address setFoundation, uint setStartTime, uint setEndTime) {
129         minter = setMinter;
130         FOUNDATION_WALLET = setFoundation;
131         startTime = setStartTime;
132         endTime = setEndTime;
133     }
134 
135     /// Pre: Address of contribution contract (minter) is set
136     /// Post: Mints token
137     function mintToken(address recipient, uint amount)
138         external
139         only_minter
140         max_total_token_amount_not_reached(amount)
141     {
142         balances[recipient] = safeAdd(balances[recipient], amount);
143         totalSupply = safeAdd(totalSupply, amount);
144     }
145 
146     /// Pre: Prevent transfers until contribution period is over.
147     /// Post: Transfer FLN from msg.sender
148     /// Note: ERC20 interface
149     function transfer(address recipient, uint amount)
150         is_later_than(endTime)
151         returns (bool success)
152     {
153         return super.transfer(recipient, amount);
154     }
155 
156     /// Pre: Prevent transfers until contribution period is over.
157     /// Post: Transfer FLN from arbitrary address
158     /// Note: ERC20 interface
159     function transferFrom(address sender, address recipient, uint amount)
160         is_later_than(endTime)
161         returns (bool success)
162     {
163         return super.transferFrom(sender, recipient, amount);
164     }
165 
166     /// Pre: minting address is set. Restricted to foundation.
167     /// Post: New minter can now create tokens up to MAX_TOTAL_TOKEN_AMOUNT.
168     /// Note: This allows additional contribution periods at a later stage, while still using the same ERC20 compliant contract.
169     function changeMintingAddress(address newMintingAddress) only_foundation { minter = newMintingAddress; }
170 
171     /// Pre: foundation address is set. Restricted to foundation.
172     /// Post: New address set. This address controls the setting of the minter address
173     function changeFoundationAddress(address newFoundationAddress) only_foundation { FOUNDATION_WALLET = newFoundationAddress; }
174 }
175 
176 /// @title Contribution Contract
177 contract Contribution is SafeMath {
178     // FIELDS
179 
180     // Constant fields
181     uint public constant ETHER_CAP = 25000 ether; // Max amount raised during first contribution; targeted amount AUD 7M
182     uint public constant MAX_CONTRIBUTION_DURATION = 8 weeks; // Max amount in seconds of contribution period
183 
184     // Price Rates
185     uint public constant PRICE_RATE_FIRST = 480;
186     uint public constant PRICE_RATE_SECOND = 460;
187     uint public constant PRICE_RATE_THIRD = 440;
188     uint public constant PRICE_RATE_FOURTH = 400;
189 
190     // Foundation Holdings
191     uint public constant FOUNDATION_TOKENS = 632000 ether;
192 
193     // Fields that are only changed in constructor
194     address public FOUNDATION_WALLET; // folio.ninja foundation wallet
195     address public DEV_WALLET; // folio.ninja multisig wallet
196 
197     uint public startTime; // Contribution start time in seconds
198     uint public endTime; // Contribution end time in seconds
199 
200     FolioNinjaToken public folioToken; // Contract of the ERC20 compliant folio.ninja token
201 
202     // Fields that can be changed by functions
203     uint public etherRaised; // This will keep track of the Ether raised during the contribution
204     bool public halted; // The foundation address can set this to true to halt the contribution due to an emergency
205 
206     // EVENTS
207     event TokensBought(address indexed sender, uint eth, uint amount);
208 
209     // MODIFIERS
210     modifier only_foundation {
211         assert(msg.sender == FOUNDATION_WALLET);
212         _;
213     }
214 
215     modifier is_not_halted {
216         assert(!halted);
217         _;
218     }
219 
220     modifier ether_cap_not_reached {
221         assert(safeAdd(etherRaised, msg.value) <= ETHER_CAP);
222         _;
223     }
224 
225     modifier is_not_earlier_than(uint x) {
226         assert(now >= x);
227         _;
228     }
229 
230     modifier is_earlier_than(uint x) {
231         assert(now < x);
232         _;
233     }
234 
235     // CONSTANT METHODS
236 
237     /// Pre: startTime, endTime specified in constructor,
238     /// Post: Price rate at given blockTime; One ether equals priceRate() of FLN tokens
239     function priceRate() constant returns (uint) {
240         // Four price tiers
241         if (startTime <= now && now < startTime + 1 weeks)
242             return PRICE_RATE_FIRST;
243         if (startTime + 1 weeks <= now && now < startTime + 2 weeks)
244             return PRICE_RATE_SECOND;
245         if (startTime + 2 weeks <= now && now < startTime + 3 weeks)
246             return PRICE_RATE_THIRD;
247         if (startTime + 3 weeks <= now && now < endTime)
248             return PRICE_RATE_FOURTH;
249         // Should not be called before or after contribution period
250         assert(false);
251     }
252 
253     // NON-CONSTANT METHODS
254     function Contribution(address setDevWallet, address setFoundationWallet, uint setStartTime) {
255         DEV_WALLET = setDevWallet;
256         FOUNDATION_WALLET = setFoundationWallet;
257         startTime = setStartTime;
258         endTime = startTime + MAX_CONTRIBUTION_DURATION;
259         folioToken = new FolioNinjaToken(this, FOUNDATION_WALLET, startTime, endTime); // Create Folio Ninja Token Contract
260 
261         // Mint folio.ninja foundation tokens
262         folioToken.mintToken(FOUNDATION_WALLET, FOUNDATION_TOKENS);
263     }
264 
265     /// Pre: N/a
266     /// Post: Bought folio.ninja tokens according to priceRate() and msg.value
267     function () payable { buyRecipient(msg.sender); }
268 
269     /// Pre: N/a
270     /// Post: Bought folio ninja tokens according to priceRate() and msg.value on behalf of recipient
271     function buyRecipient(address recipient)
272         payable
273         is_not_earlier_than(startTime)
274         is_earlier_than(endTime)
275         is_not_halted
276         ether_cap_not_reached
277     {
278         uint amount = safeMul(msg.value, priceRate());
279         folioToken.mintToken(recipient, amount);
280         etherRaised = safeAdd(etherRaised, msg.value);
281         assert(DEV_WALLET.send(msg.value));
282         TokensBought(recipient, msg.value, amount);
283     }
284 
285     /// Pre: Emergency situation that requires contribution period to stop.
286     /// Post: Contributing not possible anymore.
287     function halt() only_foundation { halted = true; }
288 
289     /// Pre: Emergency situation resolved.
290     /// Post: Contributing becomes possible again.
291     function unhalt() only_foundation { halted = false; }
292 
293     /// Pre: Restricted to foundation.
294     /// Post: New address set. To halt contribution and/or change minter in FolioNinjaToken contract.
295     function changeFoundationAddress(address newFoundationAddress) only_foundation { FOUNDATION_WALLET = newFoundationAddress; }
296 
297     /// Pre: Restricted to foundation.
298     /// Post: New address set. To change beneficiary of contributions
299     function changeDevAddress(address newDevAddress) only_foundation { DEV_WALLET = newDevAddress; }
300 }