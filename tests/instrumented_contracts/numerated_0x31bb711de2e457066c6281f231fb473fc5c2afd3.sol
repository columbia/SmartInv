1 pragma solidity 0.6.4;
2 //ERC20 Interface
3 interface ERC20 {
4     function totalSupply() external view returns (uint);
5     function balanceOf(address account) external view returns (uint);
6     function transfer(address, uint) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint);
8     function approve(address, uint) external returns (bool);
9     function transferFrom(address, address, uint) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint value);
11     event Approval(address indexed owner, address indexed spender, uint value);
12     }
13 // Uniswap Factory Interface
14 interface UniswapFactory {
15     function getExchange(address token) external view returns (address exchange);
16     }
17 // Uniswap Exchange Interface
18 interface UniswapExchange {
19     function tokenToEthTransferInput(uint tokens_sold,uint min_eth,uint deadline, address recipient) external returns (uint  eth_bought);
20     }
21     //======================================VETHER=========================================//
22 contract Vether is ERC20 {
23     // ERC-20 Parameters
24     string public name; string public symbol;
25     uint public decimals; uint public override totalSupply;
26     // ERC-20 Mappings
27     mapping(address => uint) public override balanceOf;
28     mapping(address => mapping(address => uint)) public override allowance;
29     // Public Parameters
30     uint coin; uint public emission;
31     uint public currentEra; uint public currentDay;
32     uint public daysPerEra; uint public secondsPerDay;
33     uint public genesis; uint public nextEraTime; uint public nextDayTime;
34     address payable public burnAddress;
35     address public registryAddress;
36     uint public totalFees; uint public totalBurnt;
37     // Public Mappings
38     mapping(uint=>uint) public mapEra_Emission;                                             // Era->Emission
39     mapping(uint=>mapping(uint=>uint)) public mapEraDay_Units;                              // Era,Days->Units
40     mapping(uint=>mapping(uint=>uint)) public mapEraDay_UnitsRemaining;                     // Era,Days->TotalUnits
41     mapping(uint=>mapping(uint=>uint)) public mapEraDay_Emission;                           // Era,Days->Emission
42     mapping(uint=>mapping(uint=>uint)) public mapEraDay_EmissionRemaining;                  // Era,Days->Emission
43     mapping(uint=>mapping(uint=>mapping(address=>uint))) public mapEraDay_MemberUnits;      // Era,Days,Member->Units
44     mapping(address=>mapping(uint=>uint[])) public mapMemberEra_Days;                       // Member,Era->Days[]
45     mapping(address=>bool) public mapAddress_Excluded;                                      // Address->Excluded
46     // Events
47     event NewEra(uint era, uint emission, uint time);
48     event NewDay(uint era, uint day, uint time);
49     event Burn(address indexed payer, address indexed member, uint era, uint day, uint units);
50     event Withdrawal(address indexed caller, address indexed member, uint era, uint day, uint value);
51 
52     //=====================================CREATION=========================================//
53     // Constructor
54     constructor() public {
55         name = "Vether"; symbol = "VETH"; decimals = 18; 
56         coin = 1*10**decimals; totalSupply = 1000000*coin;                                  // Set Supply
57         emission = 2048*coin; currentEra = 1; currentDay = 1;                               // Set emission, Era and Day
58         genesis = now; daysPerEra = 244; secondsPerDay = 84200;                             // Set genesis time
59         burnAddress = 0x0111011001100001011011000111010101100101;                           // Set Burn Address
60         registryAddress = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;                       // Set UniSwap V1 Mainnet
61         
62         balanceOf[address(this)] = totalSupply; 
63         emit Transfer(burnAddress, address(this), totalSupply);                             // Mint the total supply to this address
64         nextEraTime = genesis + (secondsPerDay * daysPerEra);                               // Set next time for coin era
65         nextDayTime = genesis + secondsPerDay;                                              // Set next time for coin day
66         mapAddress_Excluded[address(this)] = true;                                          // Add this address to be excluded from fees
67         mapEra_Emission[currentEra] = emission;                                             // Map Starting emission
68         mapEraDay_EmissionRemaining[currentEra][currentDay] = emission; 
69         mapEraDay_Emission[currentEra][currentDay] = emission;
70     }
71     //========================================ERC20=========================================//
72     // ERC20 Transfer function
73     function transfer(address to, uint value) public override returns (bool success) {
74         _transfer(msg.sender, to, value);
75         return true;
76     }
77     // ERC20 Approve function
78     function approve(address spender, uint value) public override returns (bool success) {
79         allowance[msg.sender][spender] = value;
80         emit Approval(msg.sender, spender, value);
81         return true;
82     }
83     // ERC20 TransferFrom function
84     function transferFrom(address from, address to, uint value) public override returns (bool success) {
85         require(value <= allowance[from][msg.sender], 'Must not send more than allowance');
86         allowance[from][msg.sender] -= value;
87         _transfer(from, to, value);
88         return true;
89     }
90     // Internal transfer function which includes the Fee
91     function _transfer(address _from, address _to, uint _value) private {
92         require(balanceOf[_from] >= _value, 'Must not send more than balance');
93         require(balanceOf[_to] + _value >= balanceOf[_to], 'Balance overflow');
94         balanceOf[_from] -= _value;
95         uint _fee = _getFee(_from, _to, _value);                                            // Get fee amount
96         balanceOf[_to] += (_value - _fee);                                                  // Add to receiver
97         balanceOf[address(this)] += _fee;                                                   // Add fee to self
98         totalFees += _fee;                                                                  // Track fees collected
99         emit Transfer(_from, _to, (_value - _fee));                                         // Transfer event
100         if (!mapAddress_Excluded[_from] && !mapAddress_Excluded[_to]) {
101             emit Transfer(_from, address(this), _fee);                                      // Fee Transfer event
102         }
103     }
104     // Calculate Fee amount
105     function _getFee(address _from, address _to, uint _value) private view returns (uint) {
106         if (mapAddress_Excluded[_from] || mapAddress_Excluded[_to]) {
107            return 0;                                                                        // No fee if excluded
108         } else {
109             return (_value / 1000);                                                         // Fee amount = 0.1%
110         }
111     }
112     //==================================PROOF-OF-VALUE======================================//
113     // Calls when sending Ether
114     receive() external payable {
115         burnAddress.call.value(msg.value)("");                                              // Burn ether
116         _recordBurn(msg.sender, msg.sender, currentEra, currentDay, msg.value);             // Record Burn
117     }
118     // Burn ether for nominated member
119     function burnEtherForMember(address member) external payable {
120         burnAddress.call.value(msg.value)("");                                              // Burn ether
121         _recordBurn(msg.sender, member, currentEra, currentDay, msg.value);                 // Record Burn
122     }
123     // Burn ERC-20 Tokens
124     function burnTokens(address token, uint amount) external {
125         _burnTokens(token, amount, msg.sender);                                             // Record Burn
126     }
127     // Burn tokens for nominated member
128     function burnTokensForMember(address token, uint amount, address member) external {
129         _burnTokens(token, amount, member);                                                 // Record Burn
130     }
131     // Calls when sending Tokens
132     function _burnTokens (address _token, uint _amount, address _member) private {
133         uint _eth; address _ex = getExchange(_token);                                       // Get exchange
134         if (_ex == address(0)) {                                                            // Handle Token without Exchange
135             uint _startGas = gasleft();                                                     // Start counting gas
136             ERC20(_token).transferFrom(msg.sender, address(this), _amount);                 // Must collect tokens
137             ERC20(_token).transfer(burnAddress, _amount);                                   // Burn token
138             uint gasPrice = tx.gasprice; uint _endGas = gasleft();                          // Stop counting gas
139             uint _gasUsed = (_startGas - _endGas) + 20000;                                  // Calculate gas and add gas overhead
140             _eth = _gasUsed * gasPrice;                                                     // Attribute gas burnt
141         } else {
142             ERC20(_token).transferFrom(msg.sender, address(this), _amount);                 // Must collect tokens
143             ERC20(_token).approve(_ex, _amount);                                            // Approve Exchange contract to transfer
144             _eth = UniswapExchange(_ex).tokenToEthTransferInput(
145                     _amount, 1, block.timestamp + 1000, burnAddress);                       // Uniswap Exchange Transfer function
146         }
147         _recordBurn(msg.sender, _member, currentEra, currentDay, _eth);
148     }
149     // Get Token Exchange
150     function getExchange(address token ) public view returns (address){
151         address exchangeToReturn = address(0);
152         address exchangeFound = UniswapFactory(registryAddress).getExchange(token);         // Try UniSwap V1
153         if (exchangeFound != address(0)) {
154             exchangeToReturn = exchangeFound;
155         }
156         return exchangeToReturn;
157     }
158     // Internal - Records burn
159     function _recordBurn(address _payer, address _member, uint _era, uint _day, uint _eth) private {
160         if (mapEraDay_MemberUnits[_era][_day][_member] == 0){                               // If hasn't contributed to this Day yet
161             mapMemberEra_Days[_member][_era].push(_day);                                    // Add it
162         }
163         mapEraDay_MemberUnits[_era][_day][_member] += _eth;                                 // Add member's share
164         mapEraDay_UnitsRemaining[_era][_day] += _eth;                                       // Add to total historicals
165         mapEraDay_Units[_era][_day] += _eth;                                                // Add to total outstanding
166         totalBurnt += _eth;                                                                 // Add to total burnt
167         emit Burn(_payer, _member, _era, _day, _eth);                                       // Burn event
168         _updateEmission();                                                                  // Update emission Schedule
169     }
170     // Allows adding an excluded address, once per Era
171     function addExcluded(address excluded) external {                   
172         _transfer(msg.sender, address(this), mapEra_Emission[1]/16);                        // Pay fee of 128 Vether
173         mapAddress_Excluded[excluded] = true;                                               // Add desired address
174     }
175     //======================================WITHDRAWAL======================================//
176     // Used to efficiently track participation in each era
177     function getDaysContributedForEra(address member, uint era) public view returns(uint){
178         return mapMemberEra_Days[member][era].length;
179     }
180     // Call to withdraw a claim
181     function withdrawShare(uint era, uint day) external {
182         _withdrawShare(era, day, msg.sender);                           
183     }
184     // Call to withdraw a claim for another member
185     function withdrawShareForMember(uint era, uint day, address member) external {
186         _withdrawShare(era, day, member);
187     }
188     // Internal - withdraw function
189     function _withdrawShare (uint _era, uint _day, address _member) private {               // Update emission Schedule
190         _updateEmission();
191         if (_era < currentEra) {                                                            // Allow if in previous Era
192             _processWithdrawal(_era, _day, _member);                                        // Process Withdrawal
193         } else if (_era == currentEra) {                                                    // Handle if in current Era
194             if (_day < currentDay) {                                                        // Allow only if in previous Day
195                 _processWithdrawal(_era, _day, _member);                                    // Process Withdrawal
196             }
197         }   
198     }
199     // Internal - Withdrawal function
200     function _processWithdrawal (uint _era, uint _day, address _member) private {
201         uint memberUnits = mapEraDay_MemberUnits[_era][_day][_member];                      // Get Member Units
202         if (memberUnits == 0) {                                                             // Do nothing if 0 (prevents revert)
203         } else {
204             uint emissionToTransfer = getEmissionShare(_era, _day, _member);                // Get the emission Share for Member
205             mapEraDay_MemberUnits[_era][_day][_member] = 0;                                 // Set to 0 since it will be withdrawn
206             mapEraDay_UnitsRemaining[_era][_day] -= memberUnits;                            // Decrement Member Units
207             mapEraDay_EmissionRemaining[_era][_day] -= emissionToTransfer;                  // Decrement emission
208             _transfer(address(this), _member, emissionToTransfer);                          // ERC20 transfer function
209             emit Withdrawal(msg.sender, _member, _era, _day, emissionToTransfer);           // Withdrawal Event
210         }
211     }
212          // Get emission Share function
213     function getEmissionShare(uint era, uint day, address member) public view returns (uint emissionShare) {
214         uint memberUnits = mapEraDay_MemberUnits[era][day][member];                         // Get Member Units
215         if (memberUnits == 0) {
216             return 0;                                                                       // If 0, return 0
217         } else {
218             uint totalUnits = mapEraDay_UnitsRemaining[era][day];                           // Get Total Units
219             uint emissionRemaining = mapEraDay_EmissionRemaining[era][day];                 // Get emission remaining for Day
220             uint balance = balanceOf[address(this)];                                        // Find remaining balance
221             if (emissionRemaining > balance) { emissionRemaining = balance; }               // In case less than required emission
222             emissionShare = (emissionRemaining * memberUnits) / totalUnits;                 // Calculate share
223             return  emissionShare;                            
224         }
225     }
226     //======================================EMISSION========================================//
227     // Internal - Update emission function
228     function _updateEmission() private {
229         uint _now = now;                                                                    // Find now()
230         if (_now >= nextDayTime) {                                                          // If time passed the next Day time
231             if (currentDay >= daysPerEra) {                                                 // If time passed the next Era time
232                 currentEra += 1; currentDay = 0;                                            // Increment Era, reset Day
233                 nextEraTime = _now + (secondsPerDay * daysPerEra);                          // Set next Era time
234                 emission = getNextEraEmission();                                            // Get correct emission
235                 mapEra_Emission[currentEra] = emission;                                     // Map emission to Era
236                 emit NewEra(currentEra, emission, nextEraTime);                             // Emit Event
237             }
238             currentDay += 1;                                                                // Increment Day
239             nextDayTime = _now + secondsPerDay;                                             // Set next Day time
240             emission = getDayEmission();                                                    // Check daily Dmission
241             mapEraDay_Emission[currentEra][currentDay] = emission;                          // Map emission to Day
242             mapEraDay_EmissionRemaining[currentEra][currentDay] = emission;                 // Map emission to Day
243             emit NewDay(currentEra, currentDay, nextDayTime);                               // Emit Event
244         }
245     }
246     // Calculate Era emission
247     function getNextEraEmission() public view returns (uint) {
248         if (emission > coin) {                                                              // Normal Emission Schedule
249             return emission / 2;                                                            // Emissions: 2048 -> 1.0
250         } else{                                                                             // Enters Fee Era
251             return coin;                                                                    // Return 1.0 from fees
252         }
253     }
254     // Calculate Day emission
255     function getDayEmission() public view returns (uint) {
256         uint balance = balanceOf[address(this)];                                            // Find remaining balance
257         if (balance > emission) {                                                           // Balance is sufficient
258             return emission;                                                                // Return emission
259         } else {                                                                            // Balance has dropped low
260             return balance;                                                                 // Return full balance
261         }
262     }
263 }