1 pragma solidity ^0.4.2;
2 
3 pragma solidity ^0.4.2;
4 
5 contract Owned {
6 
7 	address owner;
8 
9 	function Owned() {
10 		owner = msg.sender;
11 	}
12 
13 	modifier onlyOwner {
14         if (msg.sender != owner)
15             throw;
16         _;
17     }
18 }
19 
20 contract ImpactRegistry is Owned {
21 
22   modifier onlyMaster {
23     if (msg.sender != owner && msg.sender != masterContract)
24         throw;
25     _;
26   }
27 
28   address public masterContract;
29 
30   /* This creates a map with donations per user */
31   mapping (address => uint) accountBalances;
32 
33   /* Additional structure to help to iterate over donations */
34   address[] accountIndex;
35 
36   uint public unit;
37 
38   struct Impact {
39     uint value;
40     uint linked;
41     uint accountCursor;
42     uint count;
43     mapping(uint => address) addresses;
44     mapping(address => uint) values;
45   }
46 
47   /* Structures that store a match between validated outcomes and donations */
48   mapping (string => Impact) impact;
49 
50 
51   function ImpactRegistry(address _masterContract, uint _unit) {
52     masterContract = _masterContract;
53     unit = _unit;
54   }
55 
56   function registerDonation(address _from, uint _value) onlyMaster {
57     if (accountBalances[_from] == 0) {
58       accountIndex.push(_from);
59     }
60 
61     if (accountBalances[_from] + _value < accountBalances[_from])
62       throw;
63 
64     accountBalances[_from] += _value;
65   }
66 
67   function setUnit(uint _value) onlyOwner {
68     unit = _value;
69   }
70 
71   function setMasterContract(address _contractAddress) onlyOwner {
72       masterContract = _contractAddress;
73   }
74 
75   function registerOutcome(string _name, uint _value) onlyMaster{
76     impact[_name] = Impact(_value, 0, 0, 0);
77   }
78 
79   function linkImpact(string _name) onlyOwner {
80     uint left = impact[_name].value - impact[_name].linked;
81     if (left > 0) {
82 
83       uint i = impact[_name].accountCursor;
84 
85       if (accountBalances[accountIndex[i]] >= 0) {
86         /*Calculate shard */
87         uint shard = accountBalances[accountIndex[i]];
88         if (shard > left) {
89           shard = left;
90         }
91 
92         if (shard > unit) {
93           shard = unit;
94         }
95 
96         /* Update balances */
97         accountBalances[accountIndex[i]] -= shard;
98 
99         /* Update impact */
100         if (impact[_name].values[accountIndex[i]] == 0) {
101           impact[_name].addresses[impact[_name].count++] = accountIndex[i];
102         }
103 
104         impact[_name].values[accountIndex[i]] += shard;
105         impact[_name].linked += shard;
106 
107         /* Move to next account removing empty ones */
108         if (accountBalances[accountIndex[i]] == 0) {
109           accountIndex[i] = accountIndex[accountIndex.length-1];
110           accountIndex.length = accountIndex.length - 1;
111           i--;
112         }
113       }
114 
115       /* Update cursor */
116 
117       if (accountIndex.length > 0) {
118         i = (i + 1) % accountIndex.length;
119       } else {
120         i = 0;
121       }
122 
123       impact[_name].accountCursor = i;
124     }
125   }
126 
127   function payBack(address _account) onlyMaster{
128     accountBalances[_account] = 0;
129   }
130 
131   function getBalance(address _donorAddress) returns(uint) {
132     return accountBalances[_donorAddress];
133   }
134 
135   function getImpactCount(string outcome) returns(uint) {
136     return impact[outcome].count;
137   }
138 
139   function getImpactLinked(string outcome) returns(uint) {
140     return impact[outcome].linked;
141   }
142 
143   function getImpactDonor(string outcome, uint index) returns(address) {
144     return impact[outcome].addresses[index];
145   }
146 
147   function getImpactValue(string outcome, address addr) returns(uint) {
148     return impact[outcome].values[addr];
149   }
150 
151   /* This unnamed function is called whenever someone tries to send ether to it */
152   function () {
153     throw;     // Prevents accidental sending of ether
154   }
155 
156 }
157 
158 
159 contract ContractProvider {
160 	function contracts(bytes32 contractName) returns (address addr){}
161 }
162 
163 
164 contract Token {function transfer(address _to, uint256 _value);}
165 
166 contract Charity is Owned {
167     /* Public variables of the token */
168     string public name;
169     address public judgeAddress;
170     address public beneficiaryAddress;
171     address public IMPACT_REGISTRY_ADDRESS;
172     address public CONTRACT_PROVIDER_ADDRESS;
173 
174 
175     /* This creates a map with donations per user */
176     mapping (address => uint) accountBalances;
177 
178     /* Additional structure to help to iterate over donations */
179     address[] accountIndex;
180 
181     /* Total amount of all of the donations */
182     uint public total;
183 
184     /* This generates a public event on the blockchain that will notify clients */
185     event OutcomeEvent(string name, uint value);
186     event DonationEvent(address indexed from, uint value);
187 
188     function Charity(string _name) {
189         name = _name;
190     }
191 
192     function setJudge(address _judgeAddress) onlyOwner {
193         judgeAddress = _judgeAddress;
194     }
195 
196     function setBeneficiary(address _beneficiaryAddress) onlyOwner {
197         beneficiaryAddress = _beneficiaryAddress;
198     }
199 
200     function setImpactRegistry(address impactRegistryAddress) onlyOwner {
201         IMPACT_REGISTRY_ADDRESS = impactRegistryAddress;
202     }
203 
204     function setContractProvider(address _contractProvider) onlyOwner {
205         CONTRACT_PROVIDER_ADDRESS = _contractProvider;
206     }
207 
208     function notify(address _from, uint _value) onlyOwner {
209         if (total + _value < total)
210           throw;
211 
212         total += _value;
213         ImpactRegistry(IMPACT_REGISTRY_ADDRESS).registerDonation(_from, _value);
214         DonationEvent(_from, _value);
215     }
216 
217     function fund(uint _value) onlyOwner {
218         if (total + _value < total)
219           throw;
220 
221         total += _value;
222     }
223 
224     function unlockOutcome(string _name, uint _value) {
225         if (msg.sender != judgeAddress) throw;
226         if (total < _value) throw;
227 
228         address tokenAddress = ContractProvider(CONTRACT_PROVIDER_ADDRESS).contracts("digitalGBP");
229         Token(tokenAddress).transfer(beneficiaryAddress, _value);
230         total -= _value;
231 
232         ImpactRegistry(IMPACT_REGISTRY_ADDRESS).registerOutcome(_name, _value);
233 
234         OutcomeEvent(_name, _value);
235     }
236 
237     function payBack(address account) onlyOwner {
238         uint balance = getBalance(account);
239         if (balance > 0) {
240             address tokenAddress = ContractProvider(CONTRACT_PROVIDER_ADDRESS).contracts("digitalGBP");
241             Token(tokenAddress).transfer(account, balance);
242             total -= accountBalances[account];
243             ImpactRegistry(IMPACT_REGISTRY_ADDRESS).payBack(account);
244         }
245     }
246 
247     function getBalance(address donor) returns(uint) {
248         return ImpactRegistry(IMPACT_REGISTRY_ADDRESS).getBalance(donor);
249     }
250 
251     /* Extra security measure to save funds in case of critical error or attack */
252     function escape(address escapeAddress) onlyOwner {
253         address tokenAddress = ContractProvider(CONTRACT_PROVIDER_ADDRESS).contracts("digitalGBP");
254         Token(tokenAddress).transfer(escapeAddress, total);
255         total = 0;
256     }
257 
258     /* This unnamed function is called whenever someone tries to send ether to it */
259     function () {
260         throw;     // Prevents accidental sending of ether
261     }
262 }