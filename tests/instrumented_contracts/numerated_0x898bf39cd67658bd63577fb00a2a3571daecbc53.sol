1 pragma solidity ^0.4.10;
2 
3 // Miners create Elixor (EXOR), which they then convert to Elixir (ELIX)
4 
5 contract elixor {
6     
7 string public name; 
8 string public symbol; 
9 uint8 public decimals; 
10 uint256 public startTime;
11 uint256 public totalSupply;
12 
13 bool public balanceImportsComplete;
14 
15 mapping (address => bool) public numRewardsAvailableSetForChildAddress;
16 
17 mapping (address => bool) public isNewParent;
18 mapping (address => address) public returnChildForParentNew;
19 
20 bool public genesisImportsComplete;
21 
22 // Until contract is locked, devs can freeze the system if anything arises.
23 // Then deploy a contract that interfaces with the state of this one.
24 bool public frozen;
25 bool public freezeProhibited;
26 
27 address public devAddress; // For doing imports
28 
29 bool importsComplete; // Locked when devs have updated all balances
30 
31 mapping (address => uint256) public burnAmountAllowed;
32 
33 mapping(address => mapping (address => uint256)) allowed;
34 
35 // Balances for each account
36 mapping(address => uint256) balances;
37 
38 mapping (address => uint256) public numRewardsAvailable;
39 
40 // ELIX address info
41 bool public ELIXAddressSet;
42 address public ELIXAddress;
43 
44 event Transfer(address indexed from, address indexed to, uint256 value);
45 // Triggered whenever approve(address _spender, uint256 _value) is called.
46 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 
48 function elixor() {
49 name = "elixor";
50 symbol = "EXOR";
51 decimals = 18;
52 startTime=1500307354; //Time contract went online.
53 devAddress=0x85196Da9269B24bDf5FfD2624ABB387fcA05382B; // Set the dev import address
54 
55 // Dev will create 10 batches as test using 1 EXOR in dev address (which is a child)
56 // Also will send tiny amounts to several random addresses to make sure parent-child auth works.
57 // Then set numRewardsAvailable to 0
58 balances[devAddress]+=1000000000000000000;
59 totalSupply+=1000000000000000000;
60 numRewardsAvailableSetForChildAddress[devAddress]=true;
61 numRewardsAvailable[devAddress]=10;
62 }
63 
64 // Returns balance of particular account
65 function balanceOf(address _owner) constant returns (uint256 balance) {
66     return balances[_owner];
67 }
68 
69 function transfer(address _to, uint256 _value) { 
70 if (!frozen){
71     
72     if (balances[msg.sender] < _value) revert();
73     if (balances[_to] + _value < balances[_to]) revert();
74 
75     if (returnIsParentAddress(_to) || isNewParent[_to])     {
76         if ((msg.sender==returnChildAddressForParent(_to)) || (returnChildForParentNew[_to]==msg.sender))  {
77             
78             if (numRewardsAvailableSetForChildAddress[msg.sender]==false)  {
79                 setNumRewardsAvailableForAddress(msg.sender);
80             }
81 
82             if (numRewardsAvailable[msg.sender]>0)    {
83                 uint256 currDate=block.timestamp;
84                 uint256 returnMaxPerBatchGenerated=5000000000000000000000; //max 5000 coins per batch
85                 uint256 deployTime=10*365*86400; //10 years
86                 uint256 secondsSinceStartTime=currDate-startTime;
87                 uint256 maximizationTime=deployTime+startTime;
88                 uint256 coinsPerBatchGenerated;
89                 if (currDate>=maximizationTime)  {
90                     coinsPerBatchGenerated=returnMaxPerBatchGenerated;
91                 } else  {
92                     uint256 b=(returnMaxPerBatchGenerated/4);
93                     uint256 m=(returnMaxPerBatchGenerated-b)/deployTime;
94                     coinsPerBatchGenerated=secondsSinceStartTime*m+b;
95                 }
96                 numRewardsAvailable[msg.sender]-=1;
97                 balances[msg.sender]+=coinsPerBatchGenerated;
98                 totalSupply+=coinsPerBatchGenerated;
99             }
100         }
101     }
102     
103     if (_to==ELIXAddress)   {
104         //They want to convert to ELIX
105         convertToELIX(_value,msg.sender);
106     }
107     
108     balances[msg.sender] -= _value;
109     balances[_to] += _value;
110     Transfer(msg.sender, _to, _value);
111 }
112 }
113 
114 function transferFrom(
115         address _from,
116         address _to,
117         uint256 _amount
118 ) returns (bool success) {
119     if (!frozen){
120     if (balances[_from] >= _amount
121         && allowed[_from][msg.sender] >= _amount
122         && _amount > 0
123         && balances[_to] + _amount > balances[_to]) {
124         balances[_from] -= _amount;
125         allowed[_from][msg.sender] -= _amount;
126 
127     if (_to==ELIXAddress)   {
128         //They want to convert to ELIX
129         convertToELIX(_amount,msg.sender);
130     }
131 
132         balances[_to] += _amount;
133         return true;
134     } else {
135         return false;
136     }
137     }
138 }
139   
140 // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
141 // If this function is called again it overwrites the current allowance with _value.
142 function approve(address _spender, uint256 _amount) returns (bool success) {
143     allowed[msg.sender][_spender] = _amount;
144     Approval(msg.sender, _spender, _amount);
145     return true;
146 }
147 
148 // Allows devs to set num rewards used. Locked up when system online.
149 function setNumRewardsAvailableForAddresses(uint256[] numRewardsAvailableForAddresses,address[] addressesToSetFor)    {
150     if (tx.origin==devAddress) { // Dev address
151        if (!importsComplete)  {
152            for (uint256 i=0;i<addressesToSetFor.length;i++)  {
153                address addressToSet=addressesToSetFor[i];
154                numRewardsAvailable[addressToSet]=numRewardsAvailableForAddresses[i];
155            }
156        }
157     }
158 }
159 
160 // Freezes the entire system
161 function freezeTransfers() {
162     if (tx.origin==devAddress) { // Dev address
163         if (!freezeProhibited)  {
164                frozen=true;
165         }
166     }
167 }
168 
169 // Prevent Freezing (Once system is ready to be locked)
170 function prohibitFreeze()   {
171     if (tx.origin==devAddress) { // Dev address
172         freezeProhibited=true;
173     }
174 }
175 
176 // Get whether address is genesis parent
177 function returnIsParentAddress(address possibleParent) returns(bool)  {
178     return tme(0xEe22430595aE400a30FFBA37883363Fbf293e24e).parentAddress(possibleParent);
179 }
180 
181 // Return child address for parent
182 function returnChildAddressForParent(address parent) returns(address)  {
183     return tme(0xEe22430595aE400a30FFBA37883363Fbf293e24e).returnChildAddressForParent(parent);
184 }
185 
186 //Allows dev to set ELIX Address
187 function setELIXAddress(address ELIXAddressToSet)   {
188     if (tx.origin==devAddress) { // Dev address
189         if (!ELIXAddressSet)  {
190                 ELIXAddressSet=true;
191                ELIXAddress=ELIXAddressToSet;
192         }
193     }
194 }
195 
196 // Conversion to ELIX function
197 function convertToELIX(uint256 amount,address sender) private   {
198     totalSupply-=amount;
199     burnAmountAllowed[sender]=amount;
200     elixir(ELIXAddress).createAmountFromEXORForAddress(amount,sender);
201     burnAmountAllowed[sender]=0;
202 }
203 
204 function returnAmountOfELIXAddressCanProduce(address producingAddress) public returns(uint256)   {
205     return burnAmountAllowed[producingAddress];
206 }
207 
208 // Locks up all changes to balances
209 function lockBalanceChanges() {
210     if (tx.origin==devAddress) { // Dev address
211        balanceImportsComplete=true;
212    }
213 }
214 
215 function importGenesisPairs(address[] parents,address[] children) public {
216     if (tx.origin==devAddress) { // Dev address
217         if (!genesisImportsComplete)    {
218             for (uint256 i=0;i<parents.length;i++)  {
219                 address child=children[i];
220                 address parent=parents[i];
221                 // Set the parent as parent address
222                 isNewParent[parent]=true; // Exciting
223                 // Set the child of that parent
224                 returnChildForParentNew[parent]=child;
225                 balances[child]+=1000000000000000000;
226                 totalSupply+=1000000000000000000;
227                 numRewardsAvailable[child]=10;
228                 numRewardsAvailableSetForChildAddress[child]=true;
229             }
230         }
231    }
232 
233 }
234 
235 function lockGenesisImports() public    {
236     if (tx.origin==devAddress) {
237         genesisImportsComplete=true;
238     }
239 }
240 
241 // Devs will upload balances snapshot of blockchain via this function.
242 function importAmountForAddresses(uint256[] amounts,address[] addressesToAddTo) public {
243    if (tx.origin==devAddress) { // Dev address
244        if (!balanceImportsComplete)  {
245            for (uint256 i=0;i<addressesToAddTo.length;i++)  {
246                 address addressToAddTo=addressesToAddTo[i];
247                 uint256 amount=amounts[i];
248                 balances[addressToAddTo]+=amount;
249                 totalSupply+=amount;
250            }
251        }
252    }
253 }
254 
255 // Extra balance removal in case any issues arise. Do not anticipate using this function.
256 function removeAmountForAddresses(uint256[] amounts,address[] addressesToRemoveFrom) public {
257    if (tx.origin==devAddress) { // Dev address
258        if (!balanceImportsComplete)  {
259            for (uint256 i=0;i<addressesToRemoveFrom.length;i++)  {
260                 address addressToRemoveFrom=addressesToRemoveFrom[i];
261                 uint256 amount=amounts[i];
262                 balances[addressToRemoveFrom]-=amount;
263                 totalSupply-=amount;
264            }
265        }
266    }
267 }
268 
269 // Manual override in case any issues arise. Do not anticipate using this function.
270 function manuallySetNumRewardsAvailableForChildAddress(address addressToSet,uint256 rewardsAvail) public {
271    if (tx.origin==devAddress) { // Dev address
272        if (!genesisImportsComplete)  {
273             numRewardsAvailable[addressToSet]=rewardsAvail;
274             numRewardsAvailableSetForChildAddress[addressToSet]=true;
275        }
276    }
277 }
278 
279 // Manual override for total supply in case any issues arise. Do not anticipate using this function.
280 function removeFromTotalSupply(uint256 amount) public {
281    if (tx.origin==devAddress) { // Dev address
282        if (!balanceImportsComplete)  {
283             totalSupply-=amount;
284        }
285    }
286 }
287 
288 function setNumRewardsAvailableForAddress(address addressToSet) private {
289     //Get the number of rewards used in the old contract
290     tme tmeContract=tme(0xEe22430595aE400a30FFBA37883363Fbf293e24e);
291     uint256 numRewardsUsed=tmeContract.numRewardsUsed(addressToSet);
292     numRewardsAvailable[addressToSet]=10-numRewardsUsed;
293     numRewardsAvailableSetForChildAddress[addressToSet]=true;
294 }
295 
296 }
297 
298 // Pulling info about parent-child pairs from the original contract
299 contract tme    {
300     function parentAddress(address possibleParent) public returns(bool);
301     function returnChildAddressForParent(address parentAddressOfChild) public returns(address);
302     function numRewardsUsed(address childAddress) public returns(uint256);
303 }
304 
305 contract elixir {
306     function createAmountFromEXORForAddress(uint256 amount,address sender);
307 }