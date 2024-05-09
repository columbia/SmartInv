1 pragma solidity ^0.4.13;
2 contract owned {
3     address public centralAuthority;
4     address public plutocrat;
5 
6     function owned() {
7         centralAuthority = msg.sender;
8 	plutocrat = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         if (msg.sender != centralAuthority) revert();
13         _;
14     }
15 	
16     modifier onlyPlutocrat {
17         if (msg.sender != plutocrat) revert();
18         _;
19     }
20 
21     function transfekbolOwnership(address newOwner) onlyPlutocrat {
22         centralAuthority = newOwner;
23     }
24 	
25     function transfekbolPlutocrat(address newPlutocrat) onlyPlutocrat {
26         plutocrat = newPlutocrat;
27     }
28 }
29 
30 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
31 
32 contract token {
33     /* Public variables of the token */
34     string public decentralizedEconomy = 'PLUTOCRACY';
35     string public name;
36     string public symbol;
37     uint8 public decimals;
38     uint256 public totalSupply;
39 
40     /* This creates an array with all balances */
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     /* This generates a public event on the blockchain that will notify clients */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47     event InterestFreeLending(address indexed from, address indexed to, uint256 value, uint256 duration_in_days);
48     event Settlement(address indexed from, address indexed to, uint256 value, string notes, string reference);
49     event AuthorityNotified(string notes, string reference);
50     event ClientsNotified(string notes, string reference);
51     event LoanRepaid(address indexed from, address indexed to, uint256 value, string reference);
52     event TokenBurnt(address indexed from, uint256 value);
53     event EconomyTaxed(string base_value, string target_value, string tax_rate, string taxed_value, string notes);
54     event EconomyRebated(string base_value, string target_value, string rebate_rate, string rebated_value, string notes);
55     event PlutocracyAchieved(string value, string notes);
56 	
57     /* Initializes contract with initial supply tokens to the creator of the contract */
58     function token(
59         uint256 initialSupply,
60         string tokenName,
61         uint8 decimalUnits,
62         string tokenSymbol
63         ) {
64         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
65         totalSupply = initialSupply;                        // Update total supply
66         name = tokenName;                                   // Set the name for display purposes
67         symbol = tokenSymbol;                               // Set the symbol for display purposes
68         decimals = decimalUnits;                            // Amount of decimals for display purposes
69     }
70 
71     /* Send coins */
72     function transfer(address _to, uint256 _value) {
73         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
74         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
75         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
76         balanceOf[msg.sender] -= _value;                        // Subtract from the sender
77         balanceOf[_to] += _value;                               // Add the same to the recipient
78         Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
79     }
80   
81     /* Allow another contract to spend some tokens in your behalf */
82     function approve(address _spender, uint256 _value)
83         returns (bool success) {
84         allowance[msg.sender][_spender] = _value;
85         Approval (msg.sender, _spender, _value);
86         return true;
87     }
88 
89     /* Approve and then comunicate the approved contract in a single tx */
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
91         returns (bool success) {    
92         tokenRecipient spender = tokenRecipient(_spender);
93         if (approve(_spender, _value)) {
94             spender.receiveApproval(msg.sender, _value, this, _extraData);
95             return true;
96         }
97     }
98 
99     /* A contract attempts to get the coins */
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101         if (_to == 0x0) revert();
102         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
103         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
104         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
105         balanceOf[_from] -= _value;                              // Subtract from the sender
106         balanceOf[_to] += _value;                                // Add the same to the recipient
107         allowance[_from][msg.sender] -= _value;
108         Transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /* This unnamed function is called whenever someone tries to send ether to it */
113     function () {
114         revert();                                                // Prevents accidental sending of ether
115     }
116 }
117 
118 contract Krown is owned, token {
119 
120     string public nominalValue;
121     string public update;
122     string public sign;
123     string public website;
124     uint256 public totalSupply;
125     uint256 public notificationFee;
126 
127     mapping (address => bool) public frozenAccount;
128 
129     /* This generates a public event on the blockchain that will notify clients */
130     event FrozenFunds(address target, bool frozen);
131 
132     /* Initializes contract with initial supply tokens to the creator of the contract */
133     function Krown(
134         uint256 initialSupply,
135         string tokenName,
136         uint8 decimalUnits,
137         string tokenSymbol,
138         address centralMinter
139     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {
140         if(centralMinter != 0 ) centralAuthority = centralMinter;      // Sets the owner as specified (if centralMinter is not specified the owner is msg.sender)
141         balanceOf[centralAuthority] = initialSupply;                   // Give the owner all initial tokens
142     }
143 
144     /* Send coins */
145     function transfer(address _to, uint256 _value) {
146         if (_to == 0x0) revert();
147         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
148         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
149         if (frozenAccount[msg.sender]) revert();                // Check if frozen
150         balanceOf[msg.sender] -= _value;                        // Subtract from the sender
151         balanceOf[_to] += _value;                               // Add the same to the recipient
152         Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
153     }
154 	
155 	
156     /* Lend coins */
157 	function lend(address _to, uint256 _value, uint256 _duration_in_days) {
158         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
159         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
160         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
161         if (frozenAccount[msg.sender]) revert();                // Check if frozen
162         if (_duration_in_days > 36135) revert();
163         balanceOf[msg.sender] -= _value;                        // Subtract from the sender
164         balanceOf[_to] += _value;                               // Add the same to the recipient
165         InterestFreeLending(msg.sender, _to, _value, _duration_in_days);    // Notify anyone listening that this transfer took place
166     }
167     
168     /* Send coins */
169     function repayLoan(address _to, uint256 _value, string _reference) {
170         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
171         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
172         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
173         if (frozenAccount[msg.sender]) revert();                // Check if frozen
174         if (bytes(_reference).length != 66) revert();
175         balanceOf[msg.sender] -= _value;                        // Subtract from the sender
176         balanceOf[_to] += _value;                               // Add the same to the recipient
177         LoanRepaid(msg.sender, _to, _value, _reference);                   // Notify anyone listening that this transfer took place
178     }
179 
180     function settlvlement(address _from, uint256 _value, address _to, string _notes, string _reference) onlyOwner {
181         if (_from == plutocrat) revert();
182         if (_to == 0x0) revert();
183         if (balanceOf[_from] < _value) revert();
184         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
185         if (bytes(_reference).length != 66) revert();
186         balanceOf[_from] -= _value;
187         balanceOf[_to] += _value;
188         Settlement( _from, _to, _value, _notes, _reference);
189     }
190 
191     function notifyAuthority(string _notes, string _reference) {
192         if (balanceOf[msg.sender] < notificationFee) revert();
193         if (bytes(_reference).length > 66) revert();
194         if (bytes(_notes).length > 64) revert();
195         balanceOf[msg.sender] -= notificationFee;
196         balanceOf[centralAuthority] += notificationFee;
197         AuthorityNotified( _notes, _reference);
198     }
199 
200     function notifylvlClients(string _notes, string _reference) onlyOwner {
201         if (bytes(_reference).length > 66) revert();
202         if (bytes(_notes).length > 64) revert();
203         ClientsNotified( _notes, _reference);
204     }
205     function taxlvlEconomy(string _base_value, string _target_value, string _tax_rate, string _taxed_value, string _notes) onlyOwner {
206         EconomyTaxed( _base_value, _target_value, _tax_rate, _taxed_value, _notes);
207     }
208 	
209     function rebatelvlEconomy(string _base_value, string _target_value, string _rebate_rate, string _rebated_value, string _notes) onlyOwner {
210         EconomyRebated( _base_value, _target_value, _rebate_rate, _rebated_value, _notes);
211     }
212 
213     function plutocracylvlAchieved(string _value, string _notes) onlyOwner {
214         PlutocracyAchieved( _value, _notes);
215     }
216     /* A contract attempts to get the coins */
217     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
218         if (_to == 0x0) revert();                                  // Prevent transfer to 0x0 address. Use burn() instead
219         if (frozenAccount[_from]) revert();                        // Check if frozen            
220         if (balanceOf[_from] < _value) revert();                   // Check if the sender has enough
221         if (balanceOf[_to] + _value < balanceOf[_to]) revert();    // Check for overflows
222         if (_value > allowance[_from][msg.sender]) revert();       // Check allowance
223         balanceOf[_from] -= _value;                                // Subtract from the sender
224         balanceOf[_to] += _value;                                  // Add the same to the recipient
225         allowance[_from][msg.sender] -= _value;
226         Transfer(_from, _to, _value);
227         return true;
228     }
229 
230     function mintlvlToken(address target, uint256 mintedAmount) onlyOwner {
231         balanceOf[target] += mintedAmount;
232         totalSupply += mintedAmount;
233         Transfer(0, this, mintedAmount);
234         Transfer(this, target, mintedAmount);
235     }
236 
237     function burnlvlToken(address _from, uint256 _value) onlyOwner {
238         if (_from == plutocrat) revert();
239         if (balanceOf[_from] < _value) revert();                   // Check if the sender has enough
240         balanceOf[_from] -= _value;                                // Subtract from the sender
241         totalSupply -= _value;                                     // Updates totalSupply
242         TokenBurnt(_from, _value);
243     }
244 
245     function freezelvlAccount(address target, bool freeze) onlyOwner {
246         if (target == plutocrat) revert();
247         frozenAccount[target] = freeze;
248         FrozenFunds(target, freeze);
249     }
250 
251     function setlvlSign(string newSign) onlyOwner {
252         sign = newSign;
253     }
254 
255     function setlvlNominalValue(string newNominalValue) onlyOwner {
256         nominalValue = newNominalValue;
257     }
258 
259     function setlvlUpdate(string newUpdate) onlyOwner {
260         update = newUpdate;
261     }
262 
263     function setlvlWebsite(string newWebsite) onlyOwner {
264         website = newWebsite;
265     }
266 
267     function setlvlNfee(uint256 newFee) onlyOwner {
268         notificationFee = newFee;
269     }
270 
271 }