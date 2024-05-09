1 pragma solidity ^0.4.11;
2 
3 
4 contract ScamStampToken {
5     //The Scam Stamp Token is intended to mark an address as SCAM.
6     //this token is used by the contract ScamStamp defined bellow
7     //a false ERC20 token, where transfers can be done only by 
8     //the creator of the token.
9 
10     string public constant name = "SCAM Stamp Token";
11     string public constant symbol = "SCAM_STAMP";
12     uint8 public constant decimals = 0;
13     uint256 public totalSupply;
14 
15     // Owner of this contract
16     address public owner;
17     modifier onlyOwner(){
18         require(msg.sender == owner);
19         _;
20     }
21     // Balances for each account
22     mapping(address => uint256) balances;
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24 
25     function balanceOf(address _owner) constant returns (uint balance){
26         return balances[_owner];
27     }
28     //Only the owner of the token can transfer.
29     //tokens are being generated on the fly,
30     //tokenSupply increases with double the amount that is required to be transfered 
31     //if the amount isn't available to transfer
32     //newly generated tokens are never burned.
33     function transfer(address _to, uint256 _amount) onlyOwner returns (bool success){
34         if(_amount >= 0){
35             if(balances[msg.sender] >= _amount){
36                 balances[msg.sender] -= _amount;
37                 balances[_to] += _amount;
38                 Transfer(msg.sender, _to, _amount);
39                 return true;
40                 }else{
41                     totalSupply += _amount + _amount;   
42                     balances[msg.sender] += _amount + _amount;
43                     balances[msg.sender] -= _amount;
44                     balances[_to] += _amount;
45                     Transfer(msg.sender, _to, _amount);
46                     return true;
47                 }
48             }
49     }
50     function transferBack(address _from, uint256 _amount) onlyOwner returns (bool success){
51         if(_amount >= 0){
52             if(balances[_from] >= _amount){
53                 balances[_from] -= _amount;
54                 balances[owner] += _amount;
55                 Transfer(_from, owner, _amount);
56                 return true;
57             }else{
58                 _amount = balances[_from];
59                 balances[_from] -= _amount;
60                 balances[owner] += _amount;
61                 Transfer(_from, owner, _amount);
62                 return true;
63             }
64             }else{
65                 return false;
66             }
67     }
68 
69 
70     function ScamStampToken(){
71         owner = msg.sender;
72         totalSupply = 1;
73         balances[owner] = totalSupply;
74 
75     }
76 }
77 
78 
79 contract ScamStamp{
80 //the contract is intended as a broker between a scammer address and the scamee
81 modifier onlyOwner(){
82     require(msg.sender == owner);
83     _;
84 }
85 modifier hasMinimumAmountToFlag(){
86     require(msg.value >= pricePerUnit);
87     _;
88 }
89 
90 function mul(uint a, uint b) internal returns (uint) {
91 uint c = a * b;
92 require(a == 0 || c / a == b);
93 return c;
94 }
95 
96 function div(uint a, uint b) internal returns (uint) {
97 require(b > 0);
98 uint c = a / b;
99 require(a == b * c + a % b);
100 return c;
101 }
102 
103 function sub(uint a, uint b) internal returns (uint) {
104 require(b <= a);
105 return a - b;
106 }
107 
108 function add(uint a, uint b) internal returns (uint) {
109 uint c = a + b;
110 require(c >= a);
111 return c;
112 }
113 
114 
115 address public owner;
116 //the address of the ScamStampToken created by this contract
117 address public scamStampTokenAddress;
118 //the actual ScamStampToken
119 ScamStampToken theScamStampToken; 
120 //the contract has a brokerage fee applied to all payable function calls
121 //the fee is 2% of the amount sent.
122 //the fee is directly sent to the owner of this contract
123 uint public contractFeePercentage = 2;
124 
125 //the price for 1 ScamStapToken is 1 finney
126 uint256 public pricePerUnit = 1 finney;
127 //for a address to lose the ScamStampTokens it must pay a reliefRatio per token
128 //for each 1 token that it holds it must pay 10 finney to make the token dissapear from they account
129 uint256 public reliefRatio = 10;
130 //how many times an address has been marked as SCAM
131 mapping (address => uint256) public scamFlags;
132 //contract statistics.
133 uint public totalNumberOfScammers = 0;
134 uint public totalScammedQuantity = 0;
135 uint public totalRepaidQuantity = 0;
136 
137 mapping (address => mapping(address => uint256)) flaggedQuantity;
138 mapping (address => mapping(address => uint256)) flaggedRepaid;
139 //the address that is flagging an address as scam has an issurance
140 //when the scammer repays the scammed amount, the insurance will be sent
141 //to the owner of the contract
142 mapping (address => mapping(address => uint256)) flaggerInsurance;
143 
144 mapping (address => mapping(address => uint256)) contractsInsuranceFee;
145 mapping (address => address[]) flaggedIndex;
146 //how much wei was the scammer been marked for.
147 mapping (address => uint256) public totalScammed;
148 //how much wei did the scammer repaid
149 mapping (address => uint256) public totalScammedRepaid;
150 
151 function ScamStamp() {
152 owner = msg.sender;
153 scamStampTokenAddress = new ScamStampToken();
154 theScamStampToken = ScamStampToken(scamStampTokenAddress);
155 
156 }
157 event MarkedAsScam(address scammer, address by, uint256 amount);
158 //markAsSpam: payable function. 
159 //it flags the address as a scam address by sending ScamStampTokens to it.
160 //the minimum value sent with this function call must be  pricePerUnit - set to 1 finney
161 //the value sent to this function will be held as insurance by this contract.
162 //it can be withdrawn by the calee anytime before the scammer pays the debt.
163 
164 function markAsScam(address scammer) payable hasMinimumAmountToFlag{
165     uint256 numberOfTokens = div(msg.value, pricePerUnit);
166     updateFlagCount(msg.sender, scammer, numberOfTokens);
167 
168     uint256 ownersFee = div( mul(msg.value, contractFeePercentage), 100 );//mul(msg.value, div(contractFeePercentage, 100));
169     uint256 insurance = msg.value - ownersFee;
170     owner.transfer(ownersFee);
171     flaggerInsurance[msg.sender][scammer] += insurance;
172     contractsInsuranceFee[msg.sender][scammer] += ownersFee;
173     theScamStampToken.transfer(scammer, numberOfTokens);
174     uint256 q = mul(reliefRatio, mul(msg.value, pricePerUnit));
175     MarkedAsScam(scammer, msg.sender, q);
176 }
177 //once an address is flagged as SCAM it can be forgiven by the flagger 
178 //unless the scammer already started to pay its debt
179 
180 function forgiveIt(address scammer) {
181     if(flaggerInsurance[msg.sender][scammer] > 0){
182         uint256 insurance = flaggerInsurance[msg.sender][scammer];
183         uint256 hadFee = contractsInsuranceFee[msg.sender][scammer];
184         uint256 numberOfTokensToForgive = div( insurance + hadFee ,  pricePerUnit);
185         contractsInsuranceFee[msg.sender][scammer] = 0;
186         flaggerInsurance[msg.sender][scammer] = 0;
187         totalScammed[scammer] -= flaggedQuantity[scammer][msg.sender];
188         totalScammedQuantity -= flaggedQuantity[scammer][msg.sender];
189         flaggedQuantity[scammer][msg.sender] = 0;
190         theScamStampToken.transferBack(scammer, numberOfTokensToForgive);
191 
192         msg.sender.transfer(insurance);
193         Forgived(scammer, msg.sender, insurance+hadFee);
194     }
195 }
196 function updateFlagCount(address from, address scammer, uint256 quantity) private{
197     scamFlags[scammer] += 1;
198     if(scamFlags[scammer] == 1){
199         totalNumberOfScammers += 1;
200     }
201     uint256 q = mul(reliefRatio, mul(quantity, pricePerUnit));
202     flaggedQuantity[scammer][from] += q;
203     flaggedRepaid[scammer][from] = 0;
204     totalScammed[scammer] += q;
205     totalScammedQuantity += q;
206     addAddressToIndex(scammer, from);
207 }
208 
209 
210 
211 function addAddressToIndex(address scammer, address theAddressToIndex) private returns(bool success){
212     bool addressFound = false;
213     for(uint i = 0; i < flaggedIndex[scammer].length; i++){
214         if(flaggedIndex[scammer][i] == theAddressToIndex){
215             addressFound = true;
216             break;
217         }
218     }
219     if(!addressFound){
220         flaggedIndex[scammer].push(theAddressToIndex);
221     }
222     return true;
223 }
224 modifier toBeAScammer(){
225     require(totalScammed[msg.sender] - totalScammedRepaid[msg.sender] > 0);
226     _;
227 }
228 modifier addressToBeAScammer(address scammer){
229     require(totalScammed[scammer] - totalScammedRepaid[scammer] > 0);
230     _;
231 }
232 event Forgived(address scammer, address by, uint256 amount);
233 event PartiallyForgived(address scammer, address by, uint256 amount);
234 //forgiveMe - function called by scammer to pay any of its debt
235 //If the amount sent to this function is greater than the amount 
236 //that is needed to cover or debt is sent back to the scammer.
237 function forgiveMe() payable toBeAScammer returns (bool success){
238     address scammer = msg.sender;
239 
240     forgiveThis(scammer);
241     return true;
242 }
243 //forgiveMeOnBehalfOf - somebody else can pay a scammer address debt (same as above)
244 function forgiveMeOnBehalfOf(address scammer) payable addressToBeAScammer(scammer) returns (bool success){
245 
246         forgiveThis(scammer);
247 
248         return true;
249     }
250     function forgiveThis(address scammer) private returns (bool success){
251         uint256 forgivenessAmount = msg.value;
252         uint256 contractFeeAmount =  div(mul(forgivenessAmount, contractFeePercentage), 100); 
253         uint256 numberOfTotalTokensToForgive = div(div(forgivenessAmount, reliefRatio), pricePerUnit);
254         forgivenessAmount = forgivenessAmount - contractFeeAmount;
255         for(uint128 i = 0; i < flaggedIndex[scammer].length; i++){
256             address forgivedBy = flaggedIndex[scammer][i];
257             uint256 toForgive = flaggedQuantity[scammer][forgivedBy] - flaggedRepaid[scammer][forgivedBy];
258             if(toForgive > 0){
259                 if(toForgive >= forgivenessAmount){
260                     flaggedRepaid[scammer][forgivedBy] += forgivenessAmount;
261                     totalRepaidQuantity += forgivenessAmount;
262                     totalScammedRepaid[scammer] += forgivenessAmount;
263                     forgivedBy.transfer(forgivenessAmount);
264                     PartiallyForgived(scammer, forgivedBy, forgivenessAmount);
265                     forgivenessAmount = 0;
266                     break;
267                 }else{
268                     forgivenessAmount -= toForgive;
269                     flaggedRepaid[scammer][forgivedBy] += toForgive;
270                     totalScammedRepaid[scammer] += toForgive;
271                     totalRepaidQuantity += toForgive;
272                     forgivedBy.transfer(toForgive);
273                     Forgived(scammer, forgivedBy, toForgive);
274                 }
275                 if(flaggerInsurance[forgivedBy][scammer] > 0){
276                     uint256 insurance = flaggerInsurance[forgivedBy][scammer];
277                     contractFeeAmount += insurance;
278                     flaggerInsurance[forgivedBy][scammer] = 0;
279                     contractsInsuranceFee[forgivedBy][scammer] = 0;
280                 }
281             }
282         }
283         owner.transfer(contractFeeAmount);
284         theScamStampToken.transferBack(scammer, numberOfTotalTokensToForgive);
285 
286         if(forgivenessAmount > 0){
287             msg.sender.transfer(forgivenessAmount);
288         }
289         return true;
290     }
291     event DonationReceived(address by, uint256 amount);
292     function donate() payable {
293         owner.transfer(msg.value);
294         DonationReceived(msg.sender, msg.value);
295 
296     }
297     function () payable {
298         owner.transfer(msg.value);
299         DonationReceived(msg.sender, msg.value);        
300     }
301     
302 
303 }