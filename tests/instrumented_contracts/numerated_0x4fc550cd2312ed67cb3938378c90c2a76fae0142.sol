1 pragma solidity ^0.4.10;
2 
3 // The Timereum Project
4 
5 // TimereumDelta
6 // ERC-20 token snapshot of TME ("TMED"). TMEX will be a layer on top of this contract.
7 // Will provide base for TMEX
8 // If you are an address pair owner, use this contract to produce batches.
9 // Then convert to timereumX
10 
11 contract timereumDelta {
12     
13 string public name; 
14 string public symbol; 
15 uint8 public decimals; 
16 uint256 public startTime;
17 uint256 public totalSupply;
18 
19 bool public balanceImportsComplete;
20 
21 mapping (address => bool) public numRewardsAvailableSetForChildAddress;
22 
23 mapping (address => bool) public isNewParent;
24 mapping (address => address) public returnChildForParentNew;
25 
26 bool public genesisImportsComplete;
27 
28 // Until contract is locked, devs can freeze the system if anything arises.
29 // Then deploy a contract that interfaces with the state of this one.
30 bool public frozen;
31 bool public freezeProhibited;
32 
33 address public devAddress; // For doing imports
34 
35 bool importsComplete; // Locked when devs have updated all balances
36 
37 mapping (address => uint256) public burnAmountAllowed;
38 
39 mapping(address => mapping (address => uint256)) allowed;
40 
41 // Balances for each account
42 mapping(address => uint256) balances;
43 
44 mapping (address => uint256) public numRewardsAvailable;
45 
46 // TMEX address info
47 bool public TMEXAddressSet;
48 address public TMEXAddress;
49 
50 bool devTestBalanceAdded;
51 
52 event Transfer(address indexed from, address indexed to, uint256 value);
53 // Triggered whenever approve(address _spender, uint256 _value) is called.
54 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 
56 function timereumDelta() {
57 name = "tmed";
58 symbol = "TMED";
59 decimals = 18;
60 startTime=1500307354; //Time contract went online.
61 devAddress=0x85196Da9269B24bDf5FfD2624ABB387fcA05382B; // Set the dev import address
62 if (!devTestBalanceAdded)  {
63     devTestBalanceAdded=true;
64     // Dev will create 10 batches as test using 1 TMED in dev address (which is a child)
65     // Also will send tiny amounts to several random addresses to make sure parent-child auth works.
66     // Then set numRewardsAvailable to 0
67     balances[devAddress]+=1000000000000000000;
68     totalSupply+=1000000000000000000;
69     numRewardsAvailable[devAddress]=10;
70 }
71 }
72 
73 // Returns balance of particular account
74 function balanceOf(address _owner) constant returns (uint256 balance) {
75     return balances[_owner];
76 }
77 
78 function transfer(address _to, uint256 _value) { 
79 if (!frozen){
80     
81     if (balances[msg.sender] < _value) revert();
82     if (balances[_to] + _value < balances[_to]) revert();
83 
84     if (returnIsParentAddress(_to) || isNewParent[_to])     {
85         if ((msg.sender==returnChildAddressForParent(_to)) || (returnChildForParentNew[_to]==msg.sender))  {
86             
87             if (numRewardsAvailableSetForChildAddress[msg.sender]==false)  {
88                 setNumRewardsAvailableForAddress(msg.sender);
89             }
90 
91             if (numRewardsAvailable[msg.sender]>0)    {
92                 uint256 currDate=block.timestamp;
93                 uint256 returnMaxPerBatchGenerated=5000000000000000000000; //max 5000 coins per batch
94                 uint256 deployTime=10*365*86400; //10 years
95                 uint256 secondsSinceStartTime=currDate-startTime;
96                 uint256 maximizationTime=deployTime+startTime;
97                 uint256 coinsPerBatchGenerated;
98                 if (currDate>=maximizationTime)  {
99                     coinsPerBatchGenerated=returnMaxPerBatchGenerated;
100                 } else  {
101                     uint256 b=(returnMaxPerBatchGenerated/4);
102                     uint256 m=(returnMaxPerBatchGenerated-b)/deployTime;
103                     coinsPerBatchGenerated=secondsSinceStartTime*m+b;
104                 }
105                 numRewardsAvailable[msg.sender]-=1;
106                 balances[msg.sender]+=coinsPerBatchGenerated;
107                 totalSupply+=coinsPerBatchGenerated;
108             }
109         }
110     }
111     
112     if (_to==TMEXAddress)   {
113         //They want to convert to TMEX
114         convertToTMEX(_value,msg.sender);
115     }
116     
117     balances[msg.sender] -= _value;
118     balances[_to] += _value;
119     Transfer(msg.sender, _to, _value);
120 }
121 }
122 
123 function transferFrom(
124         address _from,
125         address _to,
126         uint256 _amount
127 ) returns (bool success) {
128     if (!frozen){
129     if (balances[_from] >= _amount
130         && allowed[_from][msg.sender] >= _amount
131         && _amount > 0
132         && balances[_to] + _amount > balances[_to]) {
133         balances[_from] -= _amount;
134         allowed[_from][msg.sender] -= _amount;
135 
136     if (_to==TMEXAddress)   {
137         //They want to convert to TMEX
138         convertToTMEX(_amount,msg.sender);
139     }
140 
141         balances[_to] += _amount;
142         return true;
143     } else {
144         return false;
145     }
146     }
147 }
148   
149 // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
150 // If this function is called again it overwrites the current allowance with _value.
151 function approve(address _spender, uint256 _amount) returns (bool success) {
152     allowed[msg.sender][_spender] = _amount;
153     Approval(msg.sender, _spender, _amount);
154     return true;
155 }
156 
157 // Allows devs to set num rewards used. Locked up when system online.
158 function setNumRewardsAvailableForAddresses(uint256[] numRewardsAvailableForAddresses,address[] addressesToSetFor)    {
159     if (tx.origin==devAddress) { // Dev address
160        if (!importsComplete)  {
161            for (uint256 i=0;i<addressesToSetFor.length;i++)  {
162                address addressToSet=addressesToSetFor[i];
163                numRewardsAvailable[addressToSet]=numRewardsAvailableForAddresses[i];
164            }
165        }
166     }
167 }
168 
169 // Freezes the entire system
170 function freezeTransfers() {
171     if (tx.origin==devAddress) { // Dev address
172         if (!freezeProhibited)  {
173                frozen=true;
174         }
175     }
176 }
177 
178 // Prevent Freezing (Once system is ready to be locked)
179 function prohibitFreeze()   {
180     if (tx.origin==devAddress) { // Dev address
181         freezeProhibited=true;
182     }
183 }
184 
185 // Get whether address is genesis parent
186 function returnIsParentAddress(address possibleParent) returns(bool)  {
187     return tme(0xEe22430595aE400a30FFBA37883363Fbf293e24e).parentAddress(possibleParent);
188 }
189 
190 // Return child address for parent
191 function returnChildAddressForParent(address parent) returns(address)  {
192     return tme(0xEe22430595aE400a30FFBA37883363Fbf293e24e).returnChildAddressForParent(parent);
193 }
194 
195 //Allows dev to set TMEX Address
196 function setTMEXAddress(address TMEXAddressToSet)   {
197     if (tx.origin==devAddress) { // Dev address
198         if (!TMEXAddressSet)  {
199                 TMEXAddressSet=true;
200                TMEXAddress=TMEXAddressToSet;
201         }
202     }
203 }
204 
205 // Conversion to TMEX function
206 function convertToTMEX(uint256 amount,address sender) private   {
207     totalSupply-=amount;
208     burnAmountAllowed[sender]=amount;
209     timereumX(TMEXAddress).createAmountFromTmedForAddress(amount,sender);
210     burnAmountAllowed[sender]=0;
211 }
212 
213 function returnAmountOfTmexAddressCanProduce(address producingAddress) public returns(uint256)   {
214     return burnAmountAllowed[producingAddress];
215 }
216 
217 // Locks up all changes to balances
218 function lockBalanceChanges() {
219     if (tx.origin==devAddress) { // Dev address
220        balanceImportsComplete=true;
221    }
222 }
223 
224 function importGenesisPairs(address[] parents,address[] children) public {
225     if (tx.origin==devAddress) { // Dev address
226         if (!genesisImportsComplete)    {
227             for (uint256 i=0;i<parents.length;i++)  {
228                 address child=children[i];
229                 address parent=parents[i];
230                 // Set the parent as parent address
231                 isNewParent[parent]=true; // Exciting
232                 // Set the child of that parent
233                 returnChildForParentNew[parent]=child;
234                 balances[child]+=1000000000000000000;
235                 totalSupply+=1000000000000000000;
236                 numRewardsAvailable[child]=10;
237                 numRewardsAvailableSetForChildAddress[child]=true;
238             }
239         }
240    }
241 
242 }
243 
244 function lockGenesisImports() public    {
245     if (tx.origin==devAddress) {
246         genesisImportsComplete=true;
247     }
248 }
249 
250 // Devs will upload balances snapshot of blockchain via this function.
251 function importAmountForAddresses(uint256[] amounts,address[] addressesToAddTo) public {
252    if (tx.origin==devAddress) { // Dev address
253        if (!balanceImportsComplete)  {
254            for (uint256 i=0;i<addressesToAddTo.length;i++)  {
255                 address addressToAddTo=addressesToAddTo[i];
256                 uint256 amount=amounts[i];
257                 balances[addressToAddTo]+=amount;
258                 totalSupply+=amount;
259            }
260        }
261    }
262 }
263 
264 // Extra balance removal in case any issues arise. Do not anticipate using this function.
265 function removeAmountForAddresses(uint256[] amounts,address[] addressesToRemoveFrom) public {
266    if (tx.origin==devAddress) { // Dev address
267        if (!balanceImportsComplete)  {
268            for (uint256 i=0;i<addressesToRemoveFrom.length;i++)  {
269                 address addressToRemoveFrom=addressesToRemoveFrom[i];
270                 uint256 amount=amounts[i];
271                 balances[addressToRemoveFrom]-=amount;
272                 totalSupply-=amount;
273            }
274        }
275    }
276 }
277 
278 function setNumRewardsAvailableForAddress(address addressToSet) private {
279     //Get the number of rewards used in the old contract
280     tme tmeContract=tme(0xEe22430595aE400a30FFBA37883363Fbf293e24e);
281     uint256 numRewardsUsed=tmeContract.numRewardsUsed(addressToSet);
282     numRewardsAvailable[addressToSet]=10-numRewardsUsed;
283     numRewardsAvailableSetForChildAddress[addressToSet]=true;
284 }
285 
286 }
287 
288 // Pulling info about parent-children from the original contract
289 contract tme    {
290     function parentAddress(address possibleParent) public returns(bool);
291     function returnChildAddressForParent(address parentAddressOfChild) public returns(address);
292     function numRewardsUsed(address childAddress) public returns(uint256);
293 }
294 
295 contract timereumX {
296     function createAmountFromTmedForAddress(uint256 amount,address sender);
297 }