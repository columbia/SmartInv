1 pragma solidity 0.4.16;
2 
3 
4 contract Bond {
5     
6     uint public issuerDateMinutes;
7     string public issuerName;
8     string public name;
9     string public description;
10     uint128 public totalAssetUnits;
11     uint128 public totalFiatValue;
12     uint128 public fiatPerAssetUnit;
13     uint128 public interestRate;
14     string public fiatCurrency;
15     uint16 public paymentPeriods;
16 
17     address public owner;
18     string bondID; 
19     address public issuer;
20     address public escrowContract;
21     mapping(address => uint128) balances;
22     
23     bool public matured;
24     uint public matured_block_number;
25     uint public matured_timestamp;
26     
27     event TxExecuted(uint32 indexed event_id);
28 
29     function Bond(
30         uint _issuerDateMinutes,
31         string _issuerName,
32         string _name,
33         string _description,
34         uint128 _totalAssetUnits,
35         uint128 _totalFiatValue,
36         uint128 _fiatPerAssetUnit,
37         uint128 _interestRate,
38         uint16 _paymentPeriods,
39         string _bondID,
40         string _fiatCurrency,
41         address _escrowContract) {
42             issuerDateMinutes = _issuerDateMinutes;
43             issuerName = _issuerName;
44             name = _name;
45             description = _description;
46             totalAssetUnits = _totalAssetUnits;
47             totalFiatValue = _totalFiatValue;
48             fiatPerAssetUnit = _fiatPerAssetUnit;
49             interestRate = _interestRate;
50             paymentPeriods = _paymentPeriods;
51             fiatCurrency = _fiatCurrency;
52                         
53             owner = msg.sender;
54             bondID = _bondID;
55             escrowContract = _escrowContract;
56             matured = false;
57     }
58     
59     modifier onlyOwner() {
60         if(msg.sender == owner) _;
61     }
62     
63     modifier onlyIssuer() {
64         if(msg.sender == issuer) _;
65     }
66     
67     function setMatured(uint32 event_id) onlyOwner returns (bool success) {
68         if(matured==false){
69             matured = true;
70             matured_block_number = block.number;
71             matured_timestamp = block.timestamp;
72             TxExecuted(event_id);
73         }        
74         return true;
75     }
76     
77     function checkBalance(address account) constant returns (uint128 _balance) {
78         if(matured)
79             return 0;
80         return balances[account];
81     }
82     
83     function getTotalSupply() constant returns (uint supply) {
84         return totalAssetUnits;
85     }
86     
87     function setIssuer(address _issuer, uint32 event_id) onlyOwner returns (bool success) {
88         if(matured==false && issuer==address(0)){
89             issuer = _issuer;
90             balances[_issuer] = totalAssetUnits;
91             TxExecuted(event_id);
92             return true;
93         }
94         return false;
95     }
96     
97     function getIssuer() constant returns (address _issuer) {
98         return issuer;
99     }
100     
101     struct Transfer {
102         uint128 lockAmount;
103         bytes32 currencyAndBank;
104         address executingBond;
105         address lockFrom;
106         address issuer;
107         uint128 assetAmount;
108         uint128 balancesIssuer;
109         uint32 event_id;
110         bool first;
111         bool second;
112     }
113     mapping (bytes16 => Transfer) public transferBond; 
114     function transfer(uint128 assetAmount, bytes16 lockID, uint32 event_id) onlyIssuer returns (bool success) {
115         if(matured==false){
116             uint128 lockAmount;
117             bytes32 currencyAndBank;
118             address executingBond;
119             address lockFrom;
120             transferBond[lockID].assetAmount = assetAmount;
121             transferBond[lockID].event_id = event_id;
122             Escrow escrow = Escrow(escrowContract);        
123             (lockAmount, currencyAndBank, lockFrom, executingBond) = escrow.lockedMoney(lockID);
124             transferBond[lockID].lockAmount = lockAmount;
125             transferBond[lockID].currencyAndBank = currencyAndBank;
126             transferBond[lockID].executingBond = executingBond;
127             transferBond[lockID].lockFrom = lockFrom;
128             transferBond[lockID].issuer = issuer;
129             transferBond[lockID].balancesIssuer = balances[issuer];
130             transferBond[lockID].first = balances[issuer]>=assetAmount;
131             transferBond[lockID].second = escrow.executeLock(lockID, issuer)==true;        
132             if(transferBond[lockID].first && transferBond[lockID].second){ 
133                 balances[lockFrom] += assetAmount;
134                 balances[issuer] -= assetAmount;
135                 TxExecuted(event_id);
136                 return true;
137             }
138         }
139         return false;
140     }
141 }
142 
143 contract Escrow{
144     
145     function Escrow() {
146         owner = msg.sender;
147     }
148 
149     mapping (address => mapping (bytes32 => uint128)) public balances;
150     mapping (bytes16 => Lock) public lockedMoney;
151     address public owner;
152     
153     struct Lock {
154         uint128 amount;
155         bytes32 currencyAndBank;
156         address from;
157         address executingBond;
158     }
159     
160     event TxExecuted(uint32 indexed event_id);
161     
162     modifier onlyOwner() {
163         if(msg.sender == owner)
164         _;
165     }
166     
167     function checkBalance(address acc, string currencyAndBank) constant returns (uint128 balance) {
168         bytes32 cab = sha3(currencyAndBank);
169         return balances[acc][cab];
170     }
171     
172     function getLocked(bytes16 lockID) returns (uint) {
173         return lockedMoney[lockID].amount;
174     }
175     
176     function deposit(address to, uint128 amount, string currencyAndBank, uint32 event_id) 
177         onlyOwner returns(bool success) {
178             bytes32 cab = sha3(currencyAndBank);
179             balances[to][cab] += amount;
180             TxExecuted(event_id);
181             return true;
182     } 
183     
184     function withdraw(uint128 amount, string currencyAndBank, uint32 event_id) 
185         returns(bool success) {
186             bytes32 cab = sha3(currencyAndBank);
187             require(balances[msg.sender][cab] >= amount);
188             balances[msg.sender][cab] -= amount;
189             TxExecuted(event_id);
190             return true;
191     }
192     
193     function lock(uint128 amount, string currencyAndBank, address executingBond, bytes16 lockID, uint32 event_id) 
194         returns(bool success) {   
195             bytes32 cab = sha3(currencyAndBank);
196             require(balances[msg.sender][cab] >= amount);
197             balances[msg.sender][cab] -= amount;
198             lockedMoney[lockID].currencyAndBank = cab;
199             lockedMoney[lockID].amount += amount;
200             lockedMoney[lockID].from = msg.sender;
201             lockedMoney[lockID].executingBond = executingBond;
202             TxExecuted(event_id);
203             return true; 
204     }
205     
206     function executeLock(bytes16 lockID, address issuer) returns(bool success) {
207         if(msg.sender == lockedMoney[lockID].executingBond){
208 	        balances[issuer][lockedMoney[lockID].currencyAndBank] += lockedMoney[lockID].amount;            
209 	        delete lockedMoney[lockID];
210 	        return true;
211 		}else
212 		    return false;
213     }
214     
215     function unlock(bytes16 lockID, uint32 event_id) onlyOwner returns (bool success) {
216         balances[lockedMoney[lockID].from][lockedMoney[lockID].currencyAndBank] +=
217             lockedMoney[lockID].amount;
218         delete lockedMoney[lockID];
219         TxExecuted(event_id);
220         return true;
221     }
222     
223     function pay(address to, uint128 amount, string currencyAndBank, uint32 event_id) 
224         returns (bool success){
225             bytes32 cab = sha3(currencyAndBank);
226             require(balances[msg.sender][cab] >= amount);
227             balances[msg.sender][cab] -= amount;
228             balances[to][cab] += amount;
229             TxExecuted(event_id);
230             return true;
231     }
232 }