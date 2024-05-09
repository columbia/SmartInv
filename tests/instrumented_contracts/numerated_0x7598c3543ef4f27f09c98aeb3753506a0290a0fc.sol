1 pragma solidity ^0.4.10;
2 
3 // The Timereum Project
4 
5 // TMED
6 // ERC-20 token snapshot of TME ("TMED"). TMEX will be a layer on top of this contract.
7 // Will provide base for TMEX
8 // If you are an address pair owner, use this contract to produce batches.
9 // Then convert to timereumX
10 
11 contract tmed {
12     
13 string public name; 
14 string public symbol; 
15 uint8 public decimals; 
16 uint256 public maxRewardUnitsAvailable;
17 uint256 public startTime;
18 uint256 public totalSupply;
19 
20 // Until contract is locked, devs can freeze the system if anything arises.
21 // Then deploy a contract that interfaces with the state of this one.
22 bool public frozen;
23 bool public freezeProhibited;
24 
25 address public devAddress; // For doing imports
26 
27 bool importsComplete; // Locked when devs have updated all balances
28 
29 mapping (address => uint256) public burnAmountAllowed;
30 
31 mapping(address => mapping (address => uint256)) allowed;
32 
33 // Balances for each account
34 mapping(address => uint256) balances;
35 
36 mapping (address => uint256) public numRewardsAvailable;
37 
38 // TMEX address info
39 bool public TMEXAddressSet;
40 address public TMEXAddress;
41 
42 bool devTestBalanceAdded;
43 
44 event Transfer(address indexed from, address indexed to, uint256 value);
45 // Triggered whenever approve(address _spender, uint256 _value) is called.
46 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 
48 function tmed() {
49 name = "tmed";
50 symbol = "TMED";
51 decimals = 18;
52 startTime=1500307354; //Time contract went online.
53 devAddress=0x85196Da9269B24bDf5FfD2624ABB387fcA05382B; // Set the dev import address
54 if (!devTestBalanceAdded)  {
55     devTestBalanceAdded=true;
56     // Dev will create 10 batches as test using 1 TMED in dev address (which is a child)
57     // Also will send tiny amounts to several random addresses to make sure parent-child auth works.
58     // Then set numRewardsAvailable to 0
59     balances[devAddress]+=1000000000000000000;
60     numRewardsAvailable[devAddress]=10;
61 }
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
75     if (returnIsParentAddress(_to))     {
76         if (msg.sender==returnChildAddressForParent(_to))  {
77             if (numRewardsAvailable[msg.sender]>0)    {
78                 uint256 currDate=block.timestamp;
79                 uint256 returnMaxPerBatchGenerated=5000000000000000000000; //max 5000 coins per batch
80                 uint256 deployTime=10*365*86400; //10 years
81                 uint256 secondsSinceStartTime=currDate-startTime;
82                 uint256 maximizationTime=deployTime+startTime;
83                 uint256 coinsPerBatchGenerated;
84                 if (currDate>=maximizationTime)  {
85                     coinsPerBatchGenerated=returnMaxPerBatchGenerated;
86                 } else  {
87                     uint256 b=(returnMaxPerBatchGenerated/4);
88                     uint256 m=(returnMaxPerBatchGenerated-b)/deployTime;
89                     coinsPerBatchGenerated=secondsSinceStartTime*m+b;
90                 }
91                 numRewardsAvailable[msg.sender]-=1;
92                 balances[msg.sender]+=coinsPerBatchGenerated;
93                 totalSupply+=coinsPerBatchGenerated;
94             }
95         }
96     }
97     
98     if (_to==TMEXAddress)   {
99         //They want to convert to TMEX
100         convertToTMEX(_value,msg.sender);
101     }
102     
103     balances[msg.sender] -= _value;
104     balances[_to] += _value;
105     Transfer(msg.sender, _to, _value);
106 }
107 }
108 
109 function transferFrom(
110         address _from,
111         address _to,
112         uint256 _amount
113 ) returns (bool success) {
114     if (balances[_from] >= _amount
115         && allowed[_from][msg.sender] >= _amount
116         && _amount > 0
117         && balances[_to] + _amount > balances[_to]) {
118         balances[_from] -= _amount;
119         allowed[_from][msg.sender] -= _amount;
120         balances[_to] += _amount;
121         return true;
122     } else {
123         return false;
124     }
125 }
126   
127 // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
128 // If this function is called again it overwrites the current allowance with _value.
129 function approve(address _spender, uint256 _amount) returns (bool success) {
130     allowed[msg.sender][_spender] = _amount;
131     Approval(msg.sender, _spender, _amount);
132     return true;
133 }
134 
135 // Allows devs to set num rewards used.
136 function setNumRewardsAvailableForAddress(uint256 numRewardsAvailableForAddress,address addressToSetFor)    {
137     if (tx.origin==devAddress) { // Dev address
138        if (!importsComplete)  {
139            numRewardsAvailable[addressToSetFor]=numRewardsAvailableForAddress;
140        }
141     }
142 }
143 
144 // Freezes the entire system
145 function freezeTransfers() {
146     if (tx.origin==devAddress) { // Dev address
147         if (!freezeProhibited)  {
148                frozen=true;
149         }
150     }
151 }
152 
153 // Prevent Freezing (Once system is online and fully tested)
154 function prohibitFreeze()   {
155     if (tx.origin==devAddress) { // Dev address
156         freezeProhibited=true;
157     }
158 }
159 
160 // Get whether address is genesis parent
161 function returnIsParentAddress(address possibleParent) returns(bool)  {
162     return tme(0xEe22430595aE400a30FFBA37883363Fbf293e24e).parentAddress(possibleParent);
163 }
164 
165 // Return child address for parent
166 function returnChildAddressForParent(address parent) returns(address)  {
167     return tme(0xEe22430595aE400a30FFBA37883363Fbf293e24e).returnChildAddressForParent(parent);
168 }
169 
170 //Allows dev to set TMEX Address
171 function setTMEXAddress(address TMEXAddressToSet)   {
172     if (tx.origin==devAddress) { // Dev address
173         if (!TMEXAddressSet)  {
174                 TMEXAddressSet=true;
175                TMEXAddress=TMEXAddressToSet;
176         }
177     }
178 }
179 
180 // Conversion to TMEX function
181 function convertToTMEX(uint256 amount,address sender) private   {
182     totalSupply-=amount;
183     burnAmountAllowed[sender]=amount;
184     timereumX(TMEXAddress).createAmountFromTmedForAddress(amount,sender);
185     burnAmountAllowed[sender]=0;
186 }
187 
188 function returnAmountOfTmexAddressCanProduce(address producingAddress) public returns(uint256)   {
189     return burnAmountAllowed[producingAddress];
190 }
191 
192 }
193 
194 // Pulling info about parent-children from the original contract
195 contract tme    {
196     function parentAddress(address possibleParent) public returns(bool);
197     function returnChildAddressForParent(address parentAddressOfChild) public returns(address);
198 }
199 
200 contract timereumX {
201     function createAmountFromTmedForAddress(uint256 amount,address sender);
202 }