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
14     function name() external view returns (string memory);
15     function symbol() external view returns (string memory);
16     function decimals() external view returns (uint);
17     function totalSupply() external view returns (uint);
18     function genesis() external view returns (uint);
19     function currentEra() external view returns (uint);
20     function currentDay() external view returns (uint);
21     function emission() external view returns (uint);
22     function daysPerEra() external view returns (uint);
23     function secondsPerDay() external view returns (uint);
24     function totalBurnt() external view returns (uint);
25     function totalFees() external view returns (uint);
26     function burnAddress() external view returns (address payable);
27 }
28 library SafeMath {
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 }
39     //======================================VETHER=========================================//
40 contract Vether is ERC20 {
41     using SafeMath for uint;
42     // ERC-20 Parameters
43     string public name; string public symbol;
44     uint public decimals; uint public override totalSupply;
45     // ERC-20 Mappings
46     mapping(address => uint) private _balances;
47     mapping(address => mapping(address => uint)) private _allowances;
48     // Public Parameters
49     uint coin = 10**18; uint public emission;
50     uint public currentEra; uint public currentDay;
51     uint public daysPerEra; uint public secondsPerDay;
52     uint public upgradeHeight; uint public upgradedAmount;
53     uint public genesis; uint public nextEraTime; uint public nextDayTime;
54     address payable public burnAddress; address public vether1; address deployer;
55     uint public totalFees; uint public totalBurnt; uint public totalEmitted;
56     address[] public holderArray; uint public holders;
57     // Public Mappings
58     mapping(uint=>uint) public mapEra_Emission;                                             // Era->Emission
59     mapping(uint=>mapping(uint=>uint)) public mapEraDay_MemberCount;                        // Era,Days->MemberCount
60     mapping(uint=>mapping(uint=>address[])) public mapEraDay_Members;                       // Era,Days->Members
61     mapping(uint=>mapping(uint=>uint)) public mapEraDay_Units;                              // Era,Days->Units
62     mapping(uint=>mapping(uint=>uint)) public mapEraDay_UnitsRemaining;                     // Era,Days->TotalUnits
63     mapping(uint=>mapping(uint=>uint)) public mapEraDay_Emission;                           // Era,Days->Emission
64     mapping(uint=>mapping(uint=>uint)) public mapEraDay_EmissionRemaining;                  // Era,Days->Emission
65     mapping(uint=>mapping(uint=>mapping(address=>uint))) public mapEraDay_MemberUnits;      // Era,Days,Member->Units
66     mapping(address=>mapping(uint=>uint[])) public mapMemberEra_Days;                       // Member,Era->Days[]
67     mapping(address=>bool) public mapAddress_Excluded;                                      // Address->Excluded
68     mapping(address=>uint) public mapPreviousOwnership;                                     // Map previous owners
69     mapping(address=>bool) public mapHolder;                                                // Vether Holder
70     // Events
71     event NewEra(uint era, uint emission, uint time, uint totalBurnt);
72     event NewDay(uint era, uint day, uint time, uint previousDayTotal, uint previousDayMembers);
73     event Burn(address indexed payer, address indexed member, uint era, uint day, uint units, uint dailyTotal);
74     event Withdrawal(address indexed caller, address indexed member, uint era, uint day, uint value, uint vetherRemaining);
75 
76     //=====================================CREATION=========================================//
77     // Constructor
78     constructor() public {
79         vether1 = 0x31Bb711de2e457066c6281f231fb473FC5c2afd3;                               // First Vether
80         upgradeHeight = 45;                                                                  // Height at which to upgrade
81         name = VETH(vether1).name(); 
82         symbol = VETH(vether1).symbol(); 
83         decimals = VETH(vether1).decimals(); 
84         totalSupply = VETH(vether1).totalSupply();
85         genesis = VETH(vether1).genesis();
86         currentEra = VETH(vether1).currentEra(); 
87         currentDay = upgradeHeight;                                                         // Begin at Upgrade Height
88         emission = VETH(vether1).emission(); 
89         daysPerEra = VETH(vether1).daysPerEra(); 
90         secondsPerDay = VETH(vether1).secondsPerDay();
91         totalBurnt = VETH(vether1).totalBurnt(); 
92         totalFees = VETH(vether1).totalFees(); 
93         totalEmitted = (upgradeHeight-1)*emission;
94         burnAddress = VETH(vether1).burnAddress(); 
95         deployer = msg.sender;
96         _balances[address(this)] = totalSupply; 
97         emit Transfer(burnAddress, address(this), totalSupply);                             // Mint the total supply to this address
98         nextEraTime = genesis + (secondsPerDay * daysPerEra);                               // Set next time for coin era
99         nextDayTime = genesis + (secondsPerDay * upgradeHeight);                            // Set next time for coin day
100         mapAddress_Excluded[address(this)] = true;                                          // Add this address to be excluded from fees
101         mapEra_Emission[currentEra] = emission;                                             // Map Starting emission
102         mapEraDay_EmissionRemaining[currentEra][currentDay] = emission; 
103         mapEraDay_Emission[currentEra][currentDay] = emission;
104     }
105 
106     //========================================ERC20=========================================//
107     function balanceOf(address account) public view override returns (uint256) {
108         return _balances[account];
109     }
110     function allowance(address owner, address spender) public view virtual override returns (uint256) {
111         if(mapAddress_Excluded[spender]){
112             return totalSupply;
113         } else {
114             return _allowances[owner][spender];
115         }
116     }
117     // ERC20 Transfer function
118     function transfer(address to, uint value) public override returns (bool success) {
119         _transfer(msg.sender, to, value);
120         return true;
121     }
122     // ERC20 Approve function
123     function approve(address spender, uint value) public override returns (bool success) {
124         _allowances[msg.sender][spender] = value;
125         emit Approval(msg.sender, spender, value);
126         return true;
127     }
128     // ERC20 TransferFrom function
129     function transferFrom(address from, address to, uint value) public override returns (bool success) {
130         if(!mapAddress_Excluded[msg.sender]){
131             require(value <= _allowances[from][msg.sender], 'Must not send more than allowance');
132             _allowances[from][msg.sender] -= value;
133         }
134         _transfer(from, to, value);
135         return true;
136     }
137     // Internal transfer function which includes the Fee
138     function _transfer(address _from, address _to, uint _value) private {
139         require(_balances[_from] >= _value, 'Must not send more than balance');
140         require(_balances[_to] + _value >= _balances[_to], 'Balance overflow');
141         if(!mapHolder[_to]){holderArray.push(_to); holders+=1; mapHolder[_to]=true;}
142         _balances[_from] -= _value;
143         uint _fee = _getFee(_from, _to, _value);                                            // Get fee amount
144         _balances[_to] += (_value.sub(_fee));                                               // Add to receiver
145         _balances[address(this)] += _fee;                                                   // Add fee to self
146         totalFees += _fee;                                                                  // Track fees collected
147         emit Transfer(_from, _to, (_value.sub(_fee)));                                      // Transfer event
148         if (!mapAddress_Excluded[_from] && !mapAddress_Excluded[_to]) {
149             emit Transfer(_from, address(this), _fee);                                      // Fee Transfer event
150         }
151     }
152     // Calculate Fee amount
153     function _getFee(address _from, address _to, uint _value) private view returns (uint) {
154         if (mapAddress_Excluded[_from] || mapAddress_Excluded[_to]) {
155            return 0;                                                                        // No fee if excluded
156         } else {
157             return (_value / 1000);                                                         // Fee amount = 0.1%
158         }
159     }
160     // Allow to query for remaining upgrade amount
161     function getRemainingAmount() public view returns (uint amount){
162         uint maxEmissions = (upgradeHeight-1) * mapEra_Emission[1];                         // Max Emission on Old Contract
163         uint maxUpgradeAmount = (maxEmissions).sub(VETH(vether1).totalFees());              // Minus any collected fees
164         if(maxUpgradeAmount >= upgradedAmount){
165             return maxUpgradeAmount.sub(upgradedAmount);                                    // Return remaining
166         } else {
167             return 0;                                                                       // Return 0
168         }
169     }
170     // Allow any holder of the old asset to upgrade
171     function upgrade(uint amount) public returns (bool success){
172         uint _amount = amount;
173         if(mapPreviousOwnership[msg.sender] < amount){_amount = mapPreviousOwnership[msg.sender];} // Upgrade as much as possible
174         uint remainingAmount = getRemainingAmount();
175         if(remainingAmount < amount){_amount = remainingAmount;}                            // Handle final amount
176         upgradedAmount += _amount; mapPreviousOwnership[msg.sender] -= _amount;             // Update mappings
177         ERC20(vether1).transferFrom(msg.sender, burnAddress, _amount);                      // Must collect & burn tokens
178         _transfer(address(this), msg.sender, _amount);                                      // Send to owner
179         return true;
180     }
181     function snapshot(address[] memory owners, uint[] memory ownership) public{
182         require(msg.sender == deployer);
183         for(uint i = 0; i<owners.length; i++){
184             mapPreviousOwnership[owners[i]] = ownership[i];
185         }
186     }
187     function purgeDeployer() public{require(msg.sender == deployer);deployer = address(0);}
188 
189     //==================================PROOF-OF-VALUE======================================//
190     // Calls when sending Ether
191     receive() external payable {
192         burnAddress.call.value(msg.value)("");                                              // Burn ether
193         _recordBurn(msg.sender, msg.sender, currentEra, currentDay, msg.value);             // Record Burn
194     }
195     // Burn ether for nominated member
196     function burnEtherForMember(address member) external payable {
197         burnAddress.call.value(msg.value)("");                                              // Burn ether
198         _recordBurn(msg.sender, member, currentEra, currentDay, msg.value);                 // Record Burn
199     }
200     // Internal - Records burn
201     function _recordBurn(address _payer, address _member, uint _era, uint _day, uint _eth) private {
202         require(VETH(vether1).currentDay() >= upgradeHeight || VETH(vether1).currentEra() > 1); // Prohibit until upgrade height
203         if (mapEraDay_MemberUnits[_era][_day][_member] == 0){                               // If hasn't contributed to this Day yet
204             mapMemberEra_Days[_member][_era].push(_day);                                    // Add it
205             mapEraDay_MemberCount[_era][_day] += 1;                                         // Count member
206             mapEraDay_Members[_era][_day].push(_member);                                    // Add member
207         }
208         mapEraDay_MemberUnits[_era][_day][_member] += _eth;                                 // Add member's share
209         mapEraDay_UnitsRemaining[_era][_day] += _eth;                                       // Add to total historicals
210         mapEraDay_Units[_era][_day] += _eth;                                                // Add to total outstanding
211         totalBurnt += _eth;                                                                 // Add to total burnt
212         emit Burn(_payer, _member, _era, _day, _eth, mapEraDay_Units[_era][_day]);          // Burn event
213         _updateEmission();                                                                  // Update emission Schedule
214     }
215     // Allows changing an excluded address
216     function changeExcluded(address excluded) external {    
217         if(!mapAddress_Excluded[excluded]){
218             _transfer(msg.sender, address(this), mapEra_Emission[1]/16);                    // Pay fee of 128 Vether
219             mapAddress_Excluded[excluded] = true;                                           // Add desired address
220             totalFees += mapEra_Emission[1]/16;
221         } else {
222             _transfer(msg.sender, address(this), mapEra_Emission[1]/32);                    // Pay fee of 64 Vether
223             mapAddress_Excluded[excluded] = false;                                          // Change desired address
224             totalFees += mapEra_Emission[1]/32;
225         }               
226     }
227     //======================================WITHDRAWAL======================================//
228     // Used to efficiently track participation in each era
229     function getDaysContributedForEra(address member, uint era) public view returns(uint){
230         return mapMemberEra_Days[member][era].length;
231     }
232     // Call to withdraw a claim
233     function withdrawShare(uint era, uint day) external returns (uint value) {
234         value = _withdrawShare(era, day, msg.sender);                           
235     }
236     // Call to withdraw a claim for another member
237     function withdrawShareForMember(uint era, uint day, address member) external returns (uint value) {
238         value = _withdrawShare(era, day, member);
239     }
240     // Internal - withdraw function
241     function _withdrawShare (uint _era, uint _day, address _member) private returns (uint value) {
242         _updateEmission(); 
243         if (_era < currentEra) {                                                            // Allow if in previous Era
244             value = _processWithdrawal(_era, _day, _member);                                // Process Withdrawal
245         } else if (_era == currentEra) {                                                    // Handle if in current Era
246             if (_day < currentDay) {                                                        // Allow only if in previous Day
247                 value = _processWithdrawal(_era, _day, _member);                            // Process Withdrawal
248             }
249         }  
250         return value;
251     }
252     // Internal - Withdrawal function
253     function _processWithdrawal (uint _era, uint _day, address _member) private returns (uint value) {
254         uint memberUnits = mapEraDay_MemberUnits[_era][_day][_member];                      // Get Member Units
255         if (memberUnits == 0) { 
256             value = 0;                                                                      // Do nothing if 0 (prevents revert)
257         } else {
258             value = getEmissionShare(_era, _day, _member);                                  // Get the emission Share for Member
259             mapEraDay_MemberUnits[_era][_day][_member] = 0;                                 // Set to 0 since it will be withdrawn
260             mapEraDay_UnitsRemaining[_era][_day] -= memberUnits;                            // Decrement Member Units
261             mapEraDay_EmissionRemaining[_era][_day] -= value;                               // Decrement emission
262             totalEmitted += value;                                                          // Add to Total Emitted
263             _transfer(address(this), _member, value);                                       // ERC20 transfer function
264             emit Withdrawal(msg.sender, _member, _era, _day, 
265             value, mapEraDay_EmissionRemaining[_era][_day]);
266         }
267         return value;
268     }
269     // Get emission Share function
270     function getEmissionShare(uint era, uint day, address member) public view returns (uint value) {
271         uint memberUnits = mapEraDay_MemberUnits[era][day][member];                         // Get Member Units
272         if (memberUnits == 0) {
273             return 0;                                                                       // If 0, return 0
274         } else {
275             uint totalUnits = mapEraDay_UnitsRemaining[era][day];                           // Get Total Units
276             uint emissionRemaining = mapEraDay_EmissionRemaining[era][day];                 // Get emission remaining for Day
277             uint balance = _balances[address(this)];                                        // Find remaining balance
278             if (emissionRemaining > balance) { emissionRemaining = balance; }               // In case less than required emission
279             value = (emissionRemaining * memberUnits) / totalUnits;                         // Calculate share
280             return  value;                            
281         }
282     }
283     //======================================EMISSION========================================//
284     // Internal - Update emission function
285     function _updateEmission() private {
286         uint _now = now;                                                                    // Find now()
287         if (_now >= nextDayTime) {                                                          // If time passed the next Day time
288             if (currentDay >= daysPerEra) {                                                 // If time passed the next Era time
289                 currentEra += 1; currentDay = 0;                                            // Increment Era, reset Day
290                 nextEraTime = _now + (secondsPerDay * daysPerEra);                          // Set next Era time
291                 emission = getNextEraEmission();                                            // Get correct emission
292                 mapEra_Emission[currentEra] = emission;                                     // Map emission to Era
293                 emit NewEra(currentEra, emission, nextEraTime, totalBurnt);                 // Emit Event
294             }
295             currentDay += 1;                                                                // Increment Day
296             nextDayTime = _now + secondsPerDay;                                             // Set next Day time
297             emission = getDayEmission();                                                    // Check daily Dmission
298             mapEraDay_Emission[currentEra][currentDay] = emission;                          // Map emission to Day
299             mapEraDay_EmissionRemaining[currentEra][currentDay] = emission;                 // Map emission to Day
300             uint _era = currentEra; uint _day = currentDay-1;
301             if(currentDay == 1){ _era = currentEra-1; _day = daysPerEra; }                  // Handle New Era
302             emit NewDay(currentEra, currentDay, nextDayTime, 
303             mapEraDay_Units[_era][_day], mapEraDay_MemberCount[_era][_day]);                // Emit Event
304         }
305     }
306     // Calculate Era emission
307     function getNextEraEmission() public view returns (uint) {
308         if (emission > coin) {                                                              // Normal Emission Schedule
309             return emission / 2;                                                            // Emissions: 2048 -> 1.0
310         } else{                                                                             // Enters Fee Era
311             return coin;                                                                    // Return 1.0 from fees
312         }
313     }
314     // Calculate Day emission
315     function getDayEmission() public view returns (uint) {
316         uint balance = _balances[address(this)];                                            // Find remaining balance
317         if (balance > emission) {                                                           // Balance is sufficient
318             return emission;                                                                // Return emission
319         } else {                                                                            // Balance has dropped low
320             return balance;                                                                 // Return full balance
321         }
322     }
323 }