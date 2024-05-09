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
13 interface VETH {
14     function genesis() external view returns (uint);
15     function totalBurnt() external view returns (uint);
16     function totalFees() external view returns (uint);
17     function upgradeHeight() external view returns (uint);
18     function mapEraDay_Units(uint, uint) external view returns (uint);
19 }
20 library SafeMath {
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24 
25     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
26         require(b <= a, errorMessage);
27         uint256 c = a - b;
28         return c;
29     }
30 }
31     //======================================VETHER=========================================//
32 contract Vether4 is ERC20 {
33     using SafeMath for uint;
34     // ERC-20 Parameters
35     string public name; string public symbol;
36     uint public decimals; uint public override totalSupply;
37     // ERC-20 Mappings
38     mapping(address => uint) private _balances;
39     mapping(address => mapping(address => uint)) private _allowances;
40     // Public Parameters
41     uint public coin; uint public emission;
42     uint public currentEra; uint public currentDay;
43     uint public daysPerEra; uint public secondsPerDay;
44     uint public upgradeHeight; uint public upgradedAmount;
45     uint public genesis; uint public nextEraTime; uint public nextDayTime;
46     address payable public burnAddress; address deployer;
47     address public vether1; address public vether2; address public vether3;
48     uint public totalFees; uint public totalBurnt; uint public totalEmitted;
49     address[] public excludedArray; uint public excludedCount;
50     // Public Mappings
51     mapping(uint=>uint) public mapEra_Emission;                                             // Era->Emission
52     mapping(uint=>mapping(uint=>uint)) public mapEraDay_MemberCount;                        // Era,Days->MemberCount
53     mapping(uint=>mapping(uint=>address[])) public mapEraDay_Members;                       // Era,Days->Members
54     mapping(uint=>mapping(uint=>uint)) public mapEraDay_Units;                              // Era,Days->Units
55     mapping(uint=>mapping(uint=>uint)) public mapEraDay_UnitsRemaining;                     // Era,Days->TotalUnits
56     mapping(uint=>mapping(uint=>uint)) public mapEraDay_EmissionRemaining;                  // Era,Days->Emission
57     mapping(uint=>mapping(uint=>mapping(address=>uint))) public mapEraDay_MemberUnits;      // Era,Days,Member->Units
58     mapping(address=>mapping(uint=>uint[])) public mapMemberEra_Days;                       // Member,Era->Days[]
59     mapping(address=>bool) public mapAddress_Excluded;                                      // Address->Excluded
60     // Events
61     event NewEra(uint era, uint emission, uint time, uint totalBurnt);
62     event NewDay(uint era, uint day, uint time, uint previousDayTotal, uint previousDayMembers);
63     event Burn(address indexed payer, address indexed member, uint era, uint day, uint units, uint dailyTotal);
64     event Withdrawal(address indexed caller, address indexed member, uint era, uint day, uint value, uint vetherRemaining);
65 
66     //=====================================CREATION=========================================//
67     // Constructor
68     constructor() public {
69         vether1 = 0x31Bb711de2e457066c6281f231fb473FC5c2afd3;                               // First Vether
70         vether2 = 0x01217729940055011F17BeFE6270e6E59B7d0337;                               // Second Vether
71         vether3 = 0x75572098dc462F976127f59F8c97dFa291f81d8b;                               // Third Vether
72         upgradeHeight = 51;                                                                 // Height at which to upgrade
73         name = "Vether"; symbol = "VETH"; decimals = 18; 
74         coin = 10**decimals; totalSupply = 1000000*coin;
75         genesis = VETH(vether1).genesis(); emission = 2048*coin; 
76         currentEra = 1; currentDay = upgradeHeight;                                         // Begin at Upgrade Height
77         daysPerEra = 244; secondsPerDay = 84200;
78         totalBurnt = VETH(vether2).totalBurnt(); totalFees = 0;
79         totalEmitted = (upgradeHeight-1)*emission;
80         burnAddress = 0x0111011001100001011011000111010101100101; deployer = msg.sender;
81         _balances[address(this)] = totalSupply; 
82         emit Transfer(burnAddress, address(this), totalSupply);
83         nextEraTime = genesis + (secondsPerDay * daysPerEra);
84         nextDayTime = now + secondsPerDay;
85         mapAddress_Excluded[address(this)] = true;                                          
86         excludedArray.push(address(this)); excludedCount = 1;                               
87         mapAddress_Excluded[burnAddress] = true;
88         excludedArray.push(burnAddress); excludedCount +=1; 
89         mapEra_Emission[currentEra] = emission; 
90         mapEraDay_EmissionRemaining[currentEra][currentDay] = emission; 
91         _setMappings();                                                                  // Map historical units
92     }
93     function _setMappings() internal {
94         uint upgradeHeight1 = VETH(vether2).upgradeHeight();                
95         for(uint i=1;i<upgradeHeight1; i++) {
96             mapEraDay_Units[1][i] = VETH(vether1).mapEraDay_Units(1,i); 
97         }
98         uint upgradeHeight2 = VETH(vether3).upgradeHeight(); 
99         for(uint i=upgradeHeight1;i<upgradeHeight2; i++) {
100             mapEraDay_Units[1][i] = VETH(vether2).mapEraDay_Units(1,i); 
101         }
102         mapEraDay_Units[1][upgradeHeight2] = VETH(vether3).mapEraDay_Units(1,upgradeHeight2); 
103     }
104 
105     //========================================ERC20=========================================//
106     function balanceOf(address account) public view override returns (uint256) {
107         return _balances[account];
108     }
109     function allowance(address owner, address spender) public view virtual override returns (uint256) {
110         return _allowances[owner][spender];
111     }
112     // ERC20 Transfer function
113     function transfer(address to, uint value) public override returns (bool success) {
114         _transfer(msg.sender, to, value);
115         return true;
116     }
117     // ERC20 Approve function
118     function approve(address spender, uint value) public override returns (bool success) {
119         _allowances[msg.sender][spender] = value;
120         emit Approval(msg.sender, spender, value);
121         return true;
122     }
123     // ERC20 TransferFrom function
124     function transferFrom(address from, address to, uint value) public override returns (bool success) {
125         require(value <= _allowances[from][msg.sender], 'Must not send more than allowance');
126         _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
127         _transfer(from, to, value);
128         return true;
129     }
130     // Internal transfer function which includes the Fee
131     function _transfer(address _from, address _to, uint _value) private {
132         require(_balances[_from] >= _value, 'Must not send more than balance');
133         require(_balances[_to] + _value >= _balances[_to], 'Balance overflow');
134         _balances[_from] =_balances[_from].sub(_value);
135         uint _fee = _getFee(_from, _to, _value);                                            // Get fee amount
136         _balances[_to] += (_value.sub(_fee));                                               // Add to receiver
137         _balances[address(this)] += _fee;                                                   // Add fee to self
138         totalFees += _fee;                                                                  // Track fees collected
139         emit Transfer(_from, _to, (_value.sub(_fee)));                                      // Transfer event
140         if (!mapAddress_Excluded[_from] && !mapAddress_Excluded[_to]) {
141             emit Transfer(_from, address(this), _fee);                                      // Fee Transfer event
142         }
143     }
144     // Calculate Fee amount
145     function _getFee(address _from, address _to, uint _value) private view returns (uint) {
146         if (mapAddress_Excluded[_from] || mapAddress_Excluded[_to]) {
147            return 0;                                                                        // No fee if excluded
148         } else {
149             return (_value / 1000);                                                         // Fee amount = 0.1%
150         }
151     }
152 
153     //=====================================DISTRIBUTE======================================//
154     // Distribute to previous owners
155     function distribute(address[] memory owners, uint[] memory ownership) public{
156         require(msg.sender == deployer);
157         uint maxEmissions = (upgradeHeight-1) * mapEra_Emission[1]; 
158         for(uint i = 0; i<owners.length; i++){
159             upgradedAmount += ownership[i];                                                 // Track
160             require(upgradedAmount <= maxEmissions, "Must not send more than possible");    // Safety Check
161             _transfer(address(this), owners[i], ownership[i]);                              // Send to owner
162         }
163     }
164     // purge
165     function purgeDeployer() public{require(msg.sender == deployer);deployer = address(0);}
166 
167     //==================================PROOF-OF-VALUE======================================//
168     // Calls when sending Ether
169     receive() external payable {
170         burnAddress.call.value(msg.value)("");                                              // Burn ether
171         _recordBurn(msg.sender, msg.sender, currentEra, currentDay, msg.value);             // Record Burn
172     }
173     // Burn ether for nominated member
174     function burnEtherForMember(address member) external payable {
175         burnAddress.call.value(msg.value)("");                                              // Burn ether
176         _recordBurn(msg.sender, member, currentEra, currentDay, msg.value);                 // Record Burn
177     }
178     // Internal - Records burn
179     function _recordBurn(address _payer, address _member, uint _era, uint _day, uint _eth) private {
180         if (mapEraDay_MemberUnits[_era][_day][_member] == 0){                               // If hasn't contributed to this Day yet
181             mapMemberEra_Days[_member][_era].push(_day);                                    // Add it
182             mapEraDay_MemberCount[_era][_day] += 1;                                         // Count member
183             mapEraDay_Members[_era][_day].push(_member);                                    // Add member
184         }
185         mapEraDay_MemberUnits[_era][_day][_member] += _eth;                                 // Add member's share
186         mapEraDay_UnitsRemaining[_era][_day] += _eth;                                       // Add to total historicals
187         mapEraDay_Units[_era][_day] += _eth;                                                // Add to total outstanding
188         totalBurnt += _eth;                                                                 // Add to total burnt
189         emit Burn(_payer, _member, _era, _day, _eth, mapEraDay_Units[_era][_day]);          // Burn event
190         _updateEmission();                                                                  // Update emission Schedule
191     }
192     // Allows changing an excluded address
193     function addExcluded(address excluded) external {    
194         if(!mapAddress_Excluded[excluded]){
195             _transfer(msg.sender, address(this), mapEra_Emission[1]/16);                    // Pay fee of 128 Vether
196             mapAddress_Excluded[excluded] = true;                                           // Add desired address
197             excludedArray.push(excluded); excludedCount +=1;                                // Record details
198             totalFees += mapEra_Emission[1]/16;                                             // Record fees
199         }              
200     }
201     //======================================WITHDRAWAL======================================//
202     // Used to efficiently track participation in each era
203     function getDaysContributedForEra(address member, uint era) public view returns(uint){
204         return mapMemberEra_Days[member][era].length;
205     }
206     // Call to withdraw a claim
207     function withdrawShare(uint era, uint day) external returns (uint value) {
208         value = _withdrawShare(era, day, msg.sender);                           
209     }
210     // Call to withdraw a claim for another member
211     function withdrawShareForMember(uint era, uint day, address member) external returns (uint value) {
212         value = _withdrawShare(era, day, member);
213     }
214     // Internal - withdraw function
215     function _withdrawShare (uint _era, uint _day, address _member) private returns (uint value) {
216         _updateEmission(); 
217         if (_era < currentEra) {                                                            // Allow if in previous Era
218             value = _processWithdrawal(_era, _day, _member);                                // Process Withdrawal
219         } else if (_era == currentEra) {                                                    // Handle if in current Era
220             if (_day < currentDay) {                                                        // Allow only if in previous Day
221                 value = _processWithdrawal(_era, _day, _member);                            // Process Withdrawal
222             }
223         }  
224         return value;
225     }
226     // Internal - Withdrawal function
227     function _processWithdrawal (uint _era, uint _day, address _member) private returns (uint value) {
228         uint memberUnits = mapEraDay_MemberUnits[_era][_day][_member];                      // Get Member Units
229         if (memberUnits == 0) { 
230             value = 0;                                                                      // Do nothing if 0 (prevents revert)
231         } else {
232             value = getEmissionShare(_era, _day, _member);                                  // Get the emission Share for Member
233             mapEraDay_MemberUnits[_era][_day][_member] = 0;                                 // Set to 0 since it will be withdrawn
234             mapEraDay_UnitsRemaining[_era][_day] = mapEraDay_UnitsRemaining[_era][_day].sub(memberUnits);  // Decrement Member Units
235             mapEraDay_EmissionRemaining[_era][_day] = mapEraDay_EmissionRemaining[_era][_day].sub(value);  // Decrement emission
236             totalEmitted += value;                                                          // Add to Total Emitted
237             _transfer(address(this), _member, value);                                       // ERC20 transfer function
238             emit Withdrawal(msg.sender, _member, _era, _day, 
239             value, mapEraDay_EmissionRemaining[_era][_day]);
240         }
241         return value;
242     }
243     // Get emission Share function
244     function getEmissionShare(uint era, uint day, address member) public view returns (uint value) {
245         uint memberUnits = mapEraDay_MemberUnits[era][day][member];                         // Get Member Units
246         if (memberUnits == 0) {
247             return 0;                                                                       // If 0, return 0
248         } else {
249             uint totalUnits = mapEraDay_UnitsRemaining[era][day];                           // Get Total Units
250             uint emissionRemaining = mapEraDay_EmissionRemaining[era][day];                 // Get emission remaining for Day
251             uint balance = _balances[address(this)];                                        // Find remaining balance
252             if (emissionRemaining > balance) { emissionRemaining = balance; }               // In case less than required emission
253             value = (emissionRemaining * memberUnits) / totalUnits;                         // Calculate share
254             return  value;                            
255         }
256     }
257     //======================================EMISSION========================================//
258     // Internal - Update emission function
259     function _updateEmission() private {
260         uint _now = now;                                                                    // Find now()
261         if (_now >= nextDayTime) {                                                          // If time passed the next Day time
262             if (currentDay >= daysPerEra) {                                                 // If time passed the next Era time
263                 currentEra += 1; currentDay = 0;                                            // Increment Era, reset Day
264                 nextEraTime = _now + (secondsPerDay * daysPerEra);                          // Set next Era time
265                 emission = getNextEraEmission();                                            // Get correct emission
266                 mapEra_Emission[currentEra] = emission;                                     // Map emission to Era
267                 emit NewEra(currentEra, emission, nextEraTime, totalBurnt);                 // Emit Event
268             }
269             currentDay += 1;                                                                // Increment Day
270             nextDayTime = _now + secondsPerDay;                                             // Set next Day time
271             emission = getDayEmission();                                                    // Check daily Dmission
272             mapEraDay_EmissionRemaining[currentEra][currentDay] = emission;                 // Map emission to Day
273             uint _era = currentEra; uint _day = currentDay-1;
274             if(currentDay == 1){ _era = currentEra-1; _day = daysPerEra; }                  // Handle New Era
275             emit NewDay(currentEra, currentDay, nextDayTime, 
276             mapEraDay_Units[_era][_day], mapEraDay_MemberCount[_era][_day]);                // Emit Event
277         }
278     }
279     // Calculate Era emission
280     function getNextEraEmission() public view returns (uint) {
281         if (emission > coin) {                                                              // Normal Emission Schedule
282             return emission / 2;                                                            // Emissions: 2048 -> 1.0
283         } else{                                                                             // Enters Fee Era
284             return coin;                                                                    // Return 1.0 from fees
285         }
286     }
287     // Calculate Day emission
288     function getDayEmission() public view returns (uint) {
289         uint balance = _balances[address(this)];                                            // Find remaining balance
290         if (balance > emission) {                                                           // Balance is sufficient
291             return emission;                                                                // Return emission
292         } else {                                                                            // Balance has dropped low
293             return balance;                                                                 // Return full balance
294         }
295     }
296 }