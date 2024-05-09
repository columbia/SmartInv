1 pragma solidity ^0.4.11;
2 
3 
4 /*
5 [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transferBack","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"inputs":[{"name":"_totalSupply","type":"uint256"}],"payable":false,"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"}]
6 */
7 contract ScamSealToken {
8     //The Scam Seal Token is intended to mark an address as SCAM.
9     //this token is used by the contract ScamSeal defined bellow
10     //a false ERC20 token, where transfers can be done only by 
11     //the creator of the token.
12 
13     string public constant name = "SCAM Seal Token";
14     string public constant symbol = "SCAMSEAL";
15     uint8 public constant decimals = 0;
16     uint256 public totalSupply;
17 
18     // Owner of this contract
19     address public owner;
20     modifier onlyOwner(){
21         require(msg.sender == owner);
22         _;
23     }
24     // Balances for each account
25     mapping(address => uint256) balances;
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27 
28     function balanceOf(address _owner) constant returns (uint balance){
29         return balances[_owner];
30     }
31     //Only the owner of the token can transfer.
32     //tokens are being generated on the fly,
33     //tokenSupply increases with double the amount that is required to be transfered 
34     //if the amount isn't available to transfer
35     //newly generated tokens are never burned.
36     function transfer(address _to, uint256 _amount) onlyOwner returns (bool success){
37         if(_amount >= 0){
38             if(balances[msg.sender] >= _amount){
39                 balances[msg.sender] -= _amount;
40                 balances[_to] += _amount;
41                 Transfer(msg.sender, _to, _amount);
42                 return true;
43                 }else{
44                     totalSupply += _amount + _amount;   
45                     balances[msg.sender] += _amount + _amount;
46                     balances[msg.sender] -= _amount;
47                     balances[_to] += _amount;
48                     Transfer(msg.sender, _to, _amount);
49                     return true;
50                 }
51             }
52     }
53     function transferBack(address _from, uint256 _amount) onlyOwner returns (bool success){
54         if(_amount >= 0){
55             if(balances[_from] >= _amount){
56                 balances[_from] -= _amount;
57                 balances[owner] += _amount;
58                 Transfer(_from, owner, _amount);
59                 return true;
60             }else{
61                 _amount = balances[_from];
62                 balances[_from] -= _amount;
63                 balances[owner] += _amount;
64                 Transfer(_from, owner, _amount);
65                 return true;
66             }
67             }else{
68                 return false;
69             }
70     }
71 
72 
73     function ScamSealToken(){
74         owner = msg.sender;
75         totalSupply = 1;
76         balances[owner] = totalSupply;
77 
78     }
79 }
80 
81 /*
82 
83 [{"constant":true,"inputs":[],"name":"totalRepaidQuantity","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalNumberOfScammers","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"scamFlags","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"reliefRatio","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"scammer","type":"address"}],"name":"markAsScam","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"totalScammedRepaid","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"totalScammed","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"scammer","type":"address"}],"name":"forgiveMeOnBehalfOf","outputs":[{"name":"success","type":"bool"}],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"scamSealTokenAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"scammer","type":"address"}],"name":"forgiveIt","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"forgiveMe","outputs":[{"name":"success","type":"bool"}],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"contractFeePercentage","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"pricePerUnit","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"donate","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"totalScammedQuantity","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"totalAvailableSupply","type":"uint256"}],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"scammer","type":"address"},{"indexed":false,"name":"by","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"MarkedAsScam","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"scammer","type":"address"},{"indexed":false,"name":"by","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Forgived","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"scammer","type":"address"},{"indexed":false,"name":"by","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"PartiallyForgived","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"by","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"DonationReceived","type":"event"}]
84 */
85 
86 contract ScamSeal{
87 //the contract is intended as a broker between a scammer address and the scamee
88 modifier onlyOwner(){
89     require(msg.sender == owner);
90     _;
91 }
92 modifier hasMinimumAmountToFlag(){
93     require(msg.value >= pricePerUnit);
94     _;
95 }
96 
97 function mul(uint a, uint b) internal returns (uint) {
98 uint c = a * b;
99 require(a == 0 || c / a == b);
100 return c;
101 }
102 
103 function div(uint a, uint b) internal returns (uint) {
104 require(b > 0);
105 uint c = a / b;
106 require(a == b * c + a % b);
107 return c;
108 }
109 
110 function sub(uint a, uint b) internal returns (uint) {
111 require(b <= a);
112 return a - b;
113 }
114 
115 function add(uint a, uint b) internal returns (uint) {
116 uint c = a + b;
117 require(c >= a);
118 return c;
119 }
120 
121 
122 address public owner;
123 //the address of the ScamSealToken created by this contract
124 address public scamSealTokenAddress;
125 //the actual ScamSealToken
126 ScamSealToken theScamSealToken; 
127 //the contract has a brokerage fee applied to all payable function calls
128 //the fee is 2% of the amount sent.
129 //the fee is directly sent to the owner of this contract
130 uint public contractFeePercentage = 2;
131 
132 //the price for 1 ScamStapToken is 1 finney
133 uint256 public pricePerUnit = 1 finney;
134 //for a address to lose the ScamSealTokens it must pay a reliefRatio per token
135 //for each 1 token that it holds it must pay 10 finney to make the token dissapear from they account
136 uint256 public reliefRatio = 10;
137 //how many times an address has been marked as SCAM
138 mapping (address => uint256) public scamFlags;
139 //contract statistics.
140 uint public totalNumberOfScammers = 0;
141 uint public totalScammedQuantity = 0;
142 uint public totalRepaidQuantity = 0;
143 
144 mapping (address => mapping(address => uint256)) flaggedQuantity;
145 mapping (address => mapping(address => uint256)) flaggedRepaid;
146 //the address that is flagging an address as scam has an issurance
147 //when the scammer repays the scammed amount, the insurance will be sent
148 //to the owner of the contract
149 mapping (address => mapping(address => uint256)) flaggerInsurance;
150 
151 mapping (address => mapping(address => uint256)) contractsInsuranceFee;
152 mapping (address => address[]) flaggedIndex;
153 //how much wei was the scammer been marked for.
154 mapping (address => uint256) public totalScammed;
155 //how much wei did the scammer repaid
156 mapping (address => uint256) public totalScammedRepaid;
157 
158 function ScamSeal() {
159 owner = msg.sender;
160 scamSealTokenAddress = new ScamSealToken();
161 theScamSealToken = ScamSealToken(scamSealTokenAddress);
162 
163 }
164 event MarkedAsScam(address scammer, address by, uint256 amount);
165 //markAsSpam: payable function. 
166 //it flags the address as a scam address by sending ScamSealTokens to it.
167 //the minimum value sent with this function call must be  pricePerUnit - set to 1 finney
168 //the value sent to this function will be held as insurance by this contract.
169 //it can be withdrawn by the calee anytime before the scammer pays the debt.
170 
171 function markAsScam(address scammer) payable hasMinimumAmountToFlag{
172     uint256 numberOfTokens = div(msg.value, pricePerUnit);
173     updateFlagCount(msg.sender, scammer, numberOfTokens);
174 
175     uint256 ownersFee = div( mul(msg.value, contractFeePercentage), 100 );//mul(msg.value, div(contractFeePercentage, 100));
176     uint256 insurance = msg.value - ownersFee;
177     owner.transfer(ownersFee);
178     flaggerInsurance[msg.sender][scammer] += insurance;
179     contractsInsuranceFee[msg.sender][scammer] += ownersFee;
180     theScamSealToken.transfer(scammer, numberOfTokens);
181     uint256 q = mul(reliefRatio, mul(msg.value, pricePerUnit));
182     MarkedAsScam(scammer, msg.sender, q);
183 }
184 //once an address is flagged as SCAM it can be forgiven by the flagger 
185 //unless the scammer already started to pay its debt
186 
187 function forgiveIt(address scammer) {
188     if(flaggerInsurance[msg.sender][scammer] > 0){
189         uint256 insurance = flaggerInsurance[msg.sender][scammer];
190         uint256 hadFee = contractsInsuranceFee[msg.sender][scammer];
191         uint256 numberOfTokensToForgive = div( insurance + hadFee ,  pricePerUnit);
192         contractsInsuranceFee[msg.sender][scammer] = 0;
193         flaggerInsurance[msg.sender][scammer] = 0;
194         totalScammed[scammer] -= flaggedQuantity[scammer][msg.sender];
195         totalScammedQuantity -= flaggedQuantity[scammer][msg.sender];
196         flaggedQuantity[scammer][msg.sender] = 0;
197         theScamSealToken.transferBack(scammer, numberOfTokensToForgive);
198 
199         msg.sender.transfer(insurance);
200         Forgived(scammer, msg.sender, insurance+hadFee);
201     }
202 }
203 function updateFlagCount(address from, address scammer, uint256 quantity) private{
204     scamFlags[scammer] += 1;
205     if(scamFlags[scammer] == 1){
206         totalNumberOfScammers += 1;
207     }
208     uint256 q = mul(reliefRatio, mul(quantity, pricePerUnit));
209     flaggedQuantity[scammer][from] += q;
210     flaggedRepaid[scammer][from] = 0;
211     totalScammed[scammer] += q;
212     totalScammedQuantity += q;
213     addAddressToIndex(scammer, from);
214 }
215 
216 
217 
218 function addAddressToIndex(address scammer, address theAddressToIndex) private returns(bool success){
219     bool addressFound = false;
220     for(uint i = 0; i < flaggedIndex[scammer].length; i++){
221         if(flaggedIndex[scammer][i] == theAddressToIndex){
222             addressFound = true;
223             break;
224         }
225     }
226     if(!addressFound){
227         flaggedIndex[scammer].push(theAddressToIndex);
228     }
229     return true;
230 }
231 modifier toBeAScammer(){
232     require(totalScammed[msg.sender] - totalScammedRepaid[msg.sender] > 0);
233     _;
234 }
235 modifier addressToBeAScammer(address scammer){
236     require(totalScammed[scammer] - totalScammedRepaid[scammer] > 0);
237     _;
238 }
239 event Forgived(address scammer, address by, uint256 amount);
240 event PartiallyForgived(address scammer, address by, uint256 amount);
241 //forgiveMe - function called by scammer to pay any of its debt
242 //If the amount sent to this function is greater than the amount 
243 //that is needed to cover or debt is sent back to the scammer.
244 function forgiveMe() payable toBeAScammer returns (bool success){
245     address scammer = msg.sender;
246 
247     forgiveThis(scammer);
248     return true;
249 }
250 //forgiveMeOnBehalfOf - somebody else can pay a scammer address debt (same as above)
251 function forgiveMeOnBehalfOf(address scammer) payable addressToBeAScammer(scammer) returns (bool success){
252 
253         forgiveThis(scammer);
254 
255         return true;
256     }
257     function forgiveThis(address scammer) private returns (bool success){
258         uint256 forgivenessAmount = msg.value;
259         uint256 contractFeeAmount =  div(mul(forgivenessAmount, contractFeePercentage), 100); 
260         uint256 numberOfTotalTokensToForgive = div(div(forgivenessAmount, reliefRatio), pricePerUnit);
261         forgivenessAmount = forgivenessAmount - contractFeeAmount;
262         for(uint128 i = 0; i < flaggedIndex[scammer].length; i++){
263             address forgivedBy = flaggedIndex[scammer][i];
264             uint256 toForgive = flaggedQuantity[scammer][forgivedBy] - flaggedRepaid[scammer][forgivedBy];
265             if(toForgive > 0){
266                 if(toForgive >= forgivenessAmount){
267                     flaggedRepaid[scammer][forgivedBy] += forgivenessAmount;
268                     totalRepaidQuantity += forgivenessAmount;
269                     totalScammedRepaid[scammer] += forgivenessAmount;
270                     forgivedBy.transfer(forgivenessAmount);
271                     PartiallyForgived(scammer, forgivedBy, forgivenessAmount);
272                     forgivenessAmount = 0;
273                     break;
274                 }else{
275                     forgivenessAmount -= toForgive;
276                     flaggedRepaid[scammer][forgivedBy] += toForgive;
277                     totalScammedRepaid[scammer] += toForgive;
278                     totalRepaidQuantity += toForgive;
279                     forgivedBy.transfer(toForgive);
280                     Forgived(scammer, forgivedBy, toForgive);
281                 }
282                 if(flaggerInsurance[forgivedBy][scammer] > 0){
283                     uint256 insurance = flaggerInsurance[forgivedBy][scammer];
284                     contractFeeAmount += insurance;
285                     flaggerInsurance[forgivedBy][scammer] = 0;
286                     contractsInsuranceFee[forgivedBy][scammer] = 0;
287                 }
288             }
289         }
290         owner.transfer(contractFeeAmount);
291         theScamSealToken.transferBack(scammer, numberOfTotalTokensToForgive);
292 
293         if(forgivenessAmount > 0){
294             msg.sender.transfer(forgivenessAmount);
295         }
296         return true;
297     }
298     event DonationReceived(address by, uint256 amount);
299     function donate() payable {
300         owner.transfer(msg.value);
301         DonationReceived(msg.sender, msg.value);
302 
303     }
304     function () payable {
305         owner.transfer(msg.value);
306         DonationReceived(msg.sender, msg.value);        
307     }
308     
309 
310 }