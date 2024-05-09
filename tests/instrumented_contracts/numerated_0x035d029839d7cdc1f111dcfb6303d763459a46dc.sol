1 pragma solidity ^0.4.18;
2 
3 /// @title manages special access privileges.
4 /// @author Axiom Zen (https://www.axiomzen.co)
5 /// @dev See KittyAccessControl
6 
7 contract AccessControl {
8       /// @dev Emited when contract is upgraded - See README.md for updgrade plan
9     event ContractUpgrade(address newContract);
10 
11     // The addresses of the accounts (or contracts) that can execute actions within each roles.
12     address public ceoAddress;
13     address public cfoAddress;
14     address public cooAddress;
15 
16     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
17     bool public paused = false;
18 
19     /// @dev Access modifier for CEO-only functionality
20     modifier onlyCEO() {
21         require(msg.sender == ceoAddress);
22         _;
23     }
24 
25     /// @dev Access modifier for CFO-only functionality
26     modifier onlyCFO() {
27         require(msg.sender == cfoAddress);
28         _;
29     }
30 
31     /// @dev Access modifier for COO-only functionality
32     modifier onlyCOO() {
33         require(msg.sender == cooAddress);
34         _;
35     }
36 
37     modifier onlyCLevel() {
38         require(
39             msg.sender == cooAddress ||
40             msg.sender == ceoAddress ||
41             msg.sender == cfoAddress
42         );
43         _;
44     }
45 
46     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
47     /// @param _newCEO The address of the new CEO
48     function setCEO(address _newCEO) external onlyCEO {
49         require(_newCEO != address(0));
50 
51         ceoAddress = _newCEO;
52     }
53 
54     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
55     /// @param _newCFO The address of the new CFO
56     function setCFO(address _newCFO) external onlyCEO {
57         require(_newCFO != address(0));
58 
59         cfoAddress = _newCFO;
60     }
61 
62     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
63     /// @param _newCOO The address of the new COO
64     function setCOO(address _newCOO) external onlyCEO {
65         require(_newCOO != address(0));
66 
67         cooAddress = _newCOO;
68     }
69 
70     /*** Pausable functionality adapted from OpenZeppelin ***/
71 
72     /// @dev Modifier to allow actions only when the contract IS NOT paused
73     modifier whenNotPaused() {
74         require(!paused);
75         _;
76     }
77 
78     /// @dev Modifier to allow actions only when the contract IS paused
79     modifier whenPaused {
80         require(paused);
81         _;
82     }
83 
84     /// @dev Called by any "C-level" role to pause the contract. Used only when
85     ///  a bug or exploit is detected and we need to limit damage.
86     function pause() external onlyCLevel whenNotPaused {
87         paused = true;
88     }
89 
90     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
91     ///  one reason we may pause the contract is when CFO or COO accounts are
92     ///  compromised.
93     /// @notice This is public rather than external so it can be called by
94     ///  derived contracts.
95     function unpause() public onlyCEO whenPaused {
96         // can't unpause if contract was upgraded
97         paused = false;
98     }
99 }
100 
101 pragma solidity ^0.4.18;
102 
103 contract EggFactory is AccessControl{
104     
105     event EggOpened(address eggOwner, uint256 eggId, uint256 amount);
106     event EggBought(address eggOwner, uint256 eggId, uint256 amount);
107     
108     // @dev Sanity check that allows us to ensure that we are pointing to the
109     //  right auction in our setEggFactoryAddress() call.
110     bool public isEggFactory = true;
111 
112     address public vaultAddress;
113 
114     // @dev Scheme of egg
115     struct EggScheme{
116         uint256 id;
117         uint256 stock; // max available eggs. zero for unlimited
118         uint256 purchased; // purchased eggs
119         uint256 customGene; // custom gene for future beast
120         uint256 maxAllowedToBuy; // max amount allowed to buy on single transaction. zero for unnlimited
121         
122         uint256 increase; // price increase. zero for no increase
123         uint256 price; // base price of the egg
124         
125         bool active; // is the egg active to be bought
126         bool open; // is the egg active to be opened 
127         bool isEggScheme;
128     }
129 
130     // Mapping of existing eggs 
131     // @dev: uint256 is the ID of the egg scheme
132     mapping (uint256 => EggScheme) public eggs;
133     uint256[] public eggsIndexes;
134     
135     uint256[] public activeEggs;
136     mapping (uint256 => uint256) indexesActiveEggs;
137 
138     // Mapping of eggs owned by an address
139     // @dev: owner => ( eggId => eggsAmount )
140     mapping ( address => mapping ( uint256 => uint256 ) ) public eggsOwned;
141     
142 
143     // Extend constructor
144     function EggFactory(address _vaultAddress) public {
145         vaultAddress = _vaultAddress;
146         ceoAddress = msg.sender;
147     }
148 
149     // Verify existence of id to avoid collision
150     function eggExists( uint _eggId) internal view returns(bool) {
151         return eggs[_eggId].isEggScheme;
152     }
153 
154     function listEggsIds() external view returns(uint256[]){
155         return eggsIndexes;
156     }
157     
158     function listActiveEggs() external view returns(uint256[]){
159         return activeEggs;
160     }
161 
162     // Get the amount of purchased eggs of a struct
163     function getPurchased(uint256 _eggId) external view returns(uint256){
164         return eggs[_eggId].purchased;
165     }
166 
167     // Set a new address for vault contract
168     function setVaultAddress(address _vaultAddress) public onlyCEO returns (bool) {
169         require( _vaultAddress != address(0x0) );
170         vaultAddress = _vaultAddress;
171     }
172     
173     function setActiveStatusEgg( uint256 _eggId, bool state ) public onlyCEO returns (bool){
174         require(eggExists(_eggId));
175         eggs[_eggId].active = state;
176 
177         if(state) {
178             uint newIndex = activeEggs.push(_eggId);
179             indexesActiveEggs[_eggId] = uint256(newIndex-1);
180         }
181         else {
182             indexesActiveEggs[activeEggs[activeEggs.length-1]] = indexesActiveEggs[_eggId];
183             activeEggs[indexesActiveEggs[_eggId]] = activeEggs[activeEggs.length-1]; 
184             delete activeEggs[activeEggs.length-1];
185             activeEggs.length--;
186         }
187         
188         return true;
189     }
190     
191     function setOpenStatusEgg( uint256 _eggId, bool state ) public onlyCEO returns (bool){
192         require(eggExists(_eggId));
193         eggs[_eggId].open = state;
194         return true;
195     }
196 
197     // Add modifier of onlyCOO
198     function createEggScheme( uint256 _eggId, uint256 _stock, uint256 _maxAllowedToBuy, uint256 _customGene, uint256 _price, uint256 _increase, bool _active, bool _open ) public onlyCEO returns (bool){
199         require(!eggExists(_eggId));
200         
201         eggs[_eggId].isEggScheme = true;
202         
203         eggs[_eggId].id = _eggId;
204         eggs[_eggId].stock = _stock;
205         eggs[_eggId].maxAllowedToBuy = _maxAllowedToBuy;
206         eggs[_eggId].purchased = 0;
207         eggs[_eggId].customGene = _customGene;
208         eggs[_eggId].price = _price;
209         eggs[_eggId].increase = _increase;
210         
211         setActiveStatusEgg(_eggId,_active);
212         setOpenStatusEgg(_eggId,_open);
213         
214         eggsIndexes.push(_eggId);
215         return true;
216     }
217 
218     function buyEgg(uint256 _eggId, uint256 _amount) public payable returns(bool){
219         require(eggs[_eggId].active == true);
220         require((currentEggPrice(_eggId)*_amount) == msg.value);
221         require(eggs[_eggId].maxAllowedToBuy == 0 || _amount<=eggs[_eggId].maxAllowedToBuy);
222         require(eggs[_eggId].stock == 0 || eggs[_eggId].purchased+_amount<=eggs[_eggId].stock); // until max
223         
224         vaultAddress.transfer(msg.value); // transfer the amount to vault
225         
226         eggs[_eggId].purchased += _amount;
227         eggsOwned[msg.sender][_eggId] += _amount;
228 
229         emit EggBought(msg.sender, _eggId, _amount);
230     } 
231     
232     function currentEggPrice( uint256 _eggId ) public view returns (uint256) {
233         return eggs[_eggId].price + (eggs[_eggId].purchased * eggs[_eggId].increase);
234     }
235     
236     function openEgg(uint256 _eggId, uint256 _amount) external {
237         require(eggs[_eggId].open == true);
238         require(eggsOwned[msg.sender][_eggId] >= _amount);
239         
240         eggsOwned[msg.sender][_eggId] -= _amount;
241         emit EggOpened(msg.sender, _eggId, _amount);
242     }
243 }