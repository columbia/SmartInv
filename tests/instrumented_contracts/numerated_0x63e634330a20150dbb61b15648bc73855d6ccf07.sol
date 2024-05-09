1 //--------------------------------------------------------------//
2 //---------------------BLOCKLANCER TOKEN -----------------------//
3 //--------------------------------------------------------------//
4 
5 pragma solidity ^0.4.8;
6 
7 /// Migration Agent
8 /// allows us to migrate to a new contract should it be needed
9 /// makes blocklancer future proof
10 contract MigrationAgent {
11     function migrateFrom(address _from, uint256 _value);
12 }
13 
14 contract ERC20Interface {
15      // Get the total token supply
16      function totalSupply() constant returns (uint256 totalSupply);
17   
18      // Get the account balance of another account with address _owner
19      function balanceOf(address _owner) constant returns (uint256 balance);
20   
21      // Send _value amount of tokens to address _to
22      function transfer(address _to, uint256 _value) returns (bool success);
23   
24      // Send _value amount of tokens from address _from to address _to
25      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
26   
27      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
28      // If this function is called again it overwrites the current allowance with _value.
29      // this function is required for some DEX functionality
30      function approve(address _spender, uint256 _value) returns (bool success);
31   
32      // Returns the amount which _spender is still allowed to withdraw from _owner
33      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
34   
35      // Triggered when tokens are transferred.
36      event Transfer(address indexed _from, address indexed _to, uint256 _value);
37   
38      // Triggered whenever approve(address _spender, uint256 _value) is called.
39      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 /// Blocklancer Token (LNC) - crowdfunding code for Blocklancer Project
43 contract BlocklancerToken is ERC20Interface {
44     string public constant name = "Lancer Token";
45     string public constant symbol = "LNC";
46     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
47     
48     mapping(address => mapping (address => uint256)) allowed;
49 
50     uint public fundingStart;
51 
52     // The flag indicates if the LNC contract is in Funding state.
53     bool public funding = true;
54     bool allowTransfer=false;
55 
56     // Receives ETH and its own LNC endowment.
57     address public master;
58 
59     // The current total token supply.
60     uint256 totalTokens;
61     
62     uint exchangeRate=20000;
63 	uint EarlyInvestorExchangeRate=25000;
64 	
65 	bool startRefund=false;
66 
67     mapping (address => uint256) balances;
68     mapping (address => bool) initialInvestor;
69     mapping (address => uint) lastTransferred;
70     
71     //needed to refund everyone should the ICO fail
72     // needed because the price per LNC isn't linear
73     mapping (address => uint256) balancesEther;
74 
75     //address of the contract that manages the migration
76     //can only be changed by the creator
77     address public migrationAgent;
78     
79     //total amount of token migrated
80     //allows everyone to see the progress of the migration
81     uint256 public totalMigrated;
82 
83     event Migrate(address indexed _from, address indexed _to, uint256 _value);
84     event Refund(address indexed _from, uint256 _value);
85     
86     //total amount of participants in the ICO
87     uint totalParticipants;
88 
89     function BlocklancerToken() {
90         master = msg.sender;
91         fundingStart = 1501977600;
92         initialInvestor[0x32be343b94f860124dc4fee278fdcbd38c102d88]=true;initialInvestor[0x3106fe2245b376888d684bdcd83dfa9641a869ff]=true;initialInvestor[0x7f7c64c7b7f5a611e739b4da26659bf741414917]=true;initialInvestor[0x4b3b8e0c2c221e916a48e2e5f3718ae2bce51894]=true;initialInvestor[0x507c8fea802a0772eb5e001a8fba38f36fb9b66b]=true;initialInvestor[0x3c35b66dbaf1bc716f41759c7513a7af2f727ce0]=true;initialInvestor[0x7da3ff5dc152352dcffaf08d528e78f1efd4e9d1]=true;initialInvestor[0x404b688a1d9eb850be2527c5dd341561cfa84e11]=true;initialInvestor[0x80ad7165f29f97896a0b5758193879de34fd9712]=true;initialInvestor[0xd70837a61a322f69ba3742111216a7b97d61d3a7]=true;initialInvestor[0x5eefc4f295045ea11827f515c10d50829580cd31]=true;initialInvestor[0xc8c154d54e8d66073b23361cc74cf5d13efc4dc9]=true;initialInvestor[0x00b279438dff4bb6f37038b12704e31967955cb0]=true;initialInvestor[0xfff78f0db7995c7f2299d127d332aef95bc3e7b7]=true;initialInvestor[0xae631a37ad50bf03e8028d0ae8ba041c70ac4c70]=true;initialInvestor[0x4effca51ba840ae9563f5ac1aa794d1e5d3a3806]=true;initialInvestor[0x315a233620b8536d37a92d588aaf5eb050b50d84]=true;initialInvestor[0x1ebf9e3470f303f6a6ac43347e41877b0a5aaa39]=true;initialInvestor[0xbf022480bda3f6c839cd443397761d5e83f3c02b]=true;initialInvestor[0xe727ea5340256a5236287ee3074eea34d8483457]=true;initialInvestor[0x45ecfeea42fc525c0b29313d3de9089488ef71dc]=true;initialInvestor[0xe59e4aac45862796cb52434967cf72ea46474ff3]=true;initialInvestor[0x7c367c14a322404f9e332b68d7d661b46a5c93ea]=true;initialInvestor[0x08bea4ccc9c45e506d5bc5e638acaa13fa3e801c]=true;initialInvestor[0x5dfb4a015eb0c3477a99ba88b2ac60459c879674]=true;initialInvestor[0x771a2137708ca7e07e7b7c55e5ea666e88d7c0c8]=true;initialInvestor[0xcc8ab06eb5a14855fc8b90abcb6be2f34ee5cea1]=true;initialInvestor[0x0764d446d0701a9b52382f8984b9d270d266e02c]=true;initialInvestor[0x2d90b415a38e2e19cdd02ff3ad81a97af7cbf672]=true;initialInvestor[0x0d4266de516944a49c8109a4397d1fcf06fb7ed0]=true;initialInvestor[0x7a5159617df20008b4dbe06d645a1b0305406794]=true;initialInvestor[0xaf9e23965c09ebf5d313c669020b0e1757cbb92c]=true;initialInvestor[0x33d94224754c122baa1ebaf455d16a9c82f69c98]=true;initialInvestor[0x267be1c1d684f78cb4f6a176c4911b741e4ffdc0]=true;initialInvestor[0xf6ac7c81ca099e34421b7eff7c9e80c8f56b74ae]=true;initialInvestor[0xd85faf59e73225ef386b46a1b17c493019b23e1e]=true;initialInvestor[0x3833f8dbdbd6bdcb6a883ff209b869148965b364]=true;initialInvestor[0x7ed1e469fcb3ee19c0366d829e291451be638e59]=true;initialInvestor[0x6c1ddafafd55a53f80cb7f4c8c8f9a9f13f61d70]=true;initialInvestor[0x94ef531595ffe510f8dc92e0e07a987f57784338]=true;initialInvestor[0xcc54e4e2f425cc4e207344f9e0619c1e40f42f26]=true;initialInvestor[0x70ee7bfc1aeac50349c29475a11ed4c57961b387]=true;initialInvestor[0x89be0bd8b6007101c7da7170a6461580994221d0]=true;initialInvestor[0xa7802ba51ba87556263d84cfc235759b214ccf35]=true;initialInvestor[0xb6a34bd460f02241e80e031023ec20ce6fc310ae]=true;initialInvestor[0x07004b458b56fb152c06ad81fe1be30c8a8b2ea1]=true;initialInvestor[0xb6da110659ef762a381cf2d6f601eb19b5f5d51e]=true;initialInvestor[0x20abf65634219512c6c98a64614c43220ca2085b]=true;initialInvestor[0x3afd1483693fe606c0e58f580bd08ae9aba092fd]=true;initialInvestor[0x61e120b9ca6559961982d9bd1b1dbea7485b84d1]=true;initialInvestor[0x481525718f1536ca2d739aa7e68b94b5e1d5d2c2]=true;initialInvestor[0x8e129a434cde6f52838fad2d30d8b08f744abf48]=true;initialInvestor[0x13df035952316f5fb663c262064ee39e44aa6b43]=true;initialInvestor[0x03c6c82a1d6d13b2f92ed63a10b1b791ffaa1e02]=true;initialInvestor[0xb079a72c627d0a34b880aee0504b901cbce64568]=true;initialInvestor[0xbf27721ca05c983c902df12492620ab2a8b9db91]=true;initialInvestor[0x4ced2b7d27ac74b0ecb2440d9857ba6c6407149f]=true;initialInvestor[0x330c63a5b737b5542be108a74b3fef6272619585]=true;initialInvestor[0x266dccd07a275a6e72b6bc549f7c2ce9e082f13f]=true;initialInvestor[0xf4280bf77a043568e40da2b8068b11243082c944]=true;initialInvestor[0x67d2f0e2d642a87300781df25c45b00bccaf6983]=true;initialInvestor[0x9f658a6628864e94f9a1c53ba519f0ae37a8b4a5]=true;initialInvestor[0x498d256ee53d4d05269cfa1a80c3214e525076ca]=true;initialInvestor[0xa1beac79dda14bce1ee698fdee47e2f7f2fd1f0d]=true;initialInvestor[0xfeb063bd508b82043d6b4d5c51e1e42b44f39b33]=true;initialInvestor[0xfeb7a283e1dbf2d5d8e9ba64ab5e607a41213561]=true;initialInvestor[0xabedb3d632fddccd4e95957be4ee0daffbe6acdd]=true;initialInvestor[0x4d8a7cb44d317113c82f25a0174a637a8f012ebb]=true;initialInvestor[0xe922c94161d45bdd31433b3c7b912ad214d399ce]=true;initialInvestor[0x11f9ad6eb7e9e98349b8397c836c0e3e88455b0a]=true;initialInvestor[0xfc28b52160639167fa59f30232bd8d43fab681e6]=true;initialInvestor[0xaf8a6c54fc8fa59cfcbc631e56b3d5b22fa42b75]=true;initialInvestor[0xd3c0ebb99a5616f3647f16c2efb40b133b5b1e1c]=true;initialInvestor[0x877341abeac8f44ac69ba7c99b1d5d31ce7a11d7]=true;initialInvestor[0xb22f376f70f34c906a88a91f6999a0bd1a0f3c3d]=true;initialInvestor[0x2c99db3838d6af157c8d671291d560a013c6c01e]=true;initialInvestor[0xd0f38af6984f3f847f7f2fcd6ea27aa878257059]=true;initialInvestor[0x2a5da89176d5316782d7f1c9db74d209679ad9ce]=true;initialInvestor[0xc88eea647a570738e69ad3dd8975577df720318d]=true;initialInvestor[0xb32b18dfea9072047a368ec056a464b73618345a]=true;initialInvestor[0x945b9a00bffb201a5602ee661f2a4cc6e5285ca6]=true;initialInvestor[0x86957ac9a15f114c08296523569511c22e471266]=true;initialInvestor[0x007bfe6994536ec9e89505c7de8e9eb748d3cb27]=true;initialInvestor[0x6ad0f0f578115b6fafa73df45e9f1e9056b84459]=true;initialInvestor[0x621663b4b6580b70b74afaf989c707d533bbec91]=true;initialInvestor[0xdc86c0632e88de345fc2ac01608c63f2ed99605a]=true;initialInvestor[0x3d83bb077b2557ef5f361bf1a9e68d093d919b28]=true;initialInvestor[0x56307b37377f75f397d4936cf507baf0f4943ea5]=true;initialInvestor[0x555cbe849bf5e01db195a81ecec1e65329fff643]=true;initialInvestor[0x7398a2edb928a2e179f62bfb795f292254f6850e]=true;initialInvestor[0x30382b132f30c175bee2858353f3a2dd0d074c3a]=true;initialInvestor[0x5baeac0a0417a05733884852aa068b706967e790]=true;initialInvestor[0xcb12b8a675e652296a8134e70f128521e633b327]=true;initialInvestor[0xaa8c03e04b121511858d88be7a1b2f5a2d70f6ac]=true;initialInvestor[0x77529c0ea5381262db964da3d5f6e2cc92e9b48b]=true;initialInvestor[0x59e5fe8a9637702c6d597c5f1c4ebe3fba747371]=true;initialInvestor[0x296fe436ecc0ea6b7a195ded26451e77e1335108]=true;initialInvestor[0x41bacae05437a3fe126933e57002ae3f129aa079]=true;initialInvestor[0x6cd5b9b60d2bcf81af8e6ef5d750dc9a8f18bf45]=true;
93     }
94     
95     //returns the total amount of participants in the ICO
96     function getAmountofTotalParticipants() constant returns (uint){
97         return totalParticipants;
98     }
99 
100     /// allows to transfer token to another address
101     function transfer(address _to, uint256 _value) returns (bool success) {
102         // Don't allow in funding state
103         if(funding) throw;
104         if(!allowTransfer)throw;
105 
106         var senderBalance = balances[msg.sender];
107         //only allow if the balance of the sender is more than he want's to send
108         if (senderBalance >= _value && _value > 0) {
109             //reduce the sender balance by the amount he sends
110             senderBalance -= _value;
111             balances[msg.sender] = senderBalance;
112             
113             //increase the balance of the receiver by the amount we reduced the balance of the sender
114             balances[_to] += _value;
115             
116             //saves the last time someone sent LNc from this address
117             //is needed for our Token Holder Tribunal
118             //this ensures that everyone can only vote one time
119             //otherwise it would be possible to send the LNC around and everyone votes again and again
120             lastTransferred[msg.sender]=block.timestamp;
121             Transfer(msg.sender, _to, _value);
122             return true;
123         }
124         //transfer failed
125         return false;
126     }
127 
128     //returns the total amount of LNC in circulation
129     //get displayed on the website whilst the crowd funding
130     function totalSupply() constant returns (uint256 totalSupply) {
131         return totalTokens;
132     }
133     
134     //retruns the balance of the owner address
135     function balanceOf(address _owner) constant returns (uint256 balance) {
136         return balances[_owner];
137     }
138     
139     //returns the amount anyone pledged into this contract
140     function EtherBalanceOf(address _owner) constant returns (uint256) {
141         return balancesEther[_owner];
142     }
143     
144     //returns the amount anyone pledged into this contract
145     function isInitialInvestor(address _owner) constant returns (bool) {
146         return initialInvestor[_owner];
147     }
148     
149     //time left before the crodsale begins
150     function TimeLeftBeforeCrowdsale() external constant returns (uint256) {
151         if(fundingStart>block.timestamp)
152             return fundingStart-block.timestamp;
153         else
154             return 0;
155     }
156 
157     // allows us to migrate to anew contract
158     function migrate(uint256 _value) external {
159         // can only be called if the funding ended
160         if(funding) throw;
161         
162         //the migration agent address needs to be set
163         if(migrationAgent == 0) throw;
164 
165         // must migrate more than nothing
166         if(_value == 0) throw;
167         
168         //if the value is higher than the sender owns abort
169         if(_value > balances[msg.sender]) throw;
170 
171         //reduce the balance of the owner
172         balances[msg.sender] -= _value;
173         
174         //reduce the token left in the old contract
175         totalTokens -= _value;
176         totalMigrated += _value;
177         
178         //call the migration agent to complete the migration
179         //credits the same amount of LNC in the new contract
180         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
181         Migrate(msg.sender, migrationAgent, _value);
182     }
183 
184     //sets the address of the migration agent
185     function setMigrationAgent(address _agent) external {
186         //not possible in funding mode
187         if(funding) throw;
188         
189         //only allow to set this once
190         if(migrationAgent != 0) throw;
191         
192         //anly the owner can call this function
193         if(msg.sender != master) throw;
194         
195         //set the migration agent
196         migrationAgent = _agent;
197     }
198     
199     function setExchangeRate(uint _exchangeRate){
200         if(msg.sender!=master)throw;
201         exchangeRate=_exchangeRate;
202     }
203     
204     function setICORunning(bool r){
205         if(msg.sender!=master)throw;
206         funding=r;
207     }
208     
209     function setTransfer(bool r){
210         if(msg.sender!=master)throw;
211         allowTransfer=r;
212     }
213 	
214 	function addInitialInvestor(address invest){
215 		if(msg.sender!=master)throw;
216 		initialInvestor[invest]=true;
217 	}
218 	
219 	function addToken(address invest,uint256 value){
220 		if(msg.sender!=master)throw;
221 		balances[invest]+=value;
222 		totalTokens+=value;
223 	}
224 	
225 	function setEarlyInvestorExchangeRate(uint invest){
226 		if(msg.sender!=master)throw;
227 		EarlyInvestorExchangeRate=invest;
228 	}
229 	
230 	function setStartDate(uint time){
231 		if(msg.sender!=master)throw;
232 		fundingStart=time;
233 	}
234 	
235 	function setStartRefund(bool s){
236 		if(msg.sender!=master)throw;
237 		startRefund=s;
238 	}
239     
240     //return the current exchange rate -> LNC per Ether
241     function getExchangeRate(address investorAddress) constant returns(uint){
242 		if(initialInvestor[investorAddress])
243 			return EarlyInvestorExchangeRate;
244 		else
245 			return exchangeRate;
246     }
247     
248     //returns if the crowd sale is still open
249     function ICOopen() constant returns(bool){
250         if(!funding) return false;
251         else if(block.timestamp < fundingStart) return false;
252         else return true;
253     }
254 
255     //when someone send ether to this contract
256     function() payable external {
257         //not possible if the funding has ended
258         if(!funding) throw;
259         
260         //not possible before the funding started
261         if(block.timestamp < fundingStart) throw;
262 
263         // Do not allow creating 0 or more than the cap tokens.
264         if(msg.value == 0) throw;
265 
266         //calculate the amount of LNC the sender receives
267         var numTokens = msg.value * getExchangeRate(msg.sender);
268         totalTokens += numTokens;
269 
270         // increase the amount of token the sender holds
271         balances[msg.sender] += numTokens;
272         
273         //increase the amount of ether the sender pledged into the contract
274         balancesEther[msg.sender] += msg.value;
275         
276         //icrease the amount of people that sent ether to this contract
277         totalParticipants+=1;
278 
279         // Log token creation
280         Transfer(0, msg.sender, numTokens);
281     }
282 
283     //called after the crodsale ended
284     //needed to allow everyone to send their LNC around
285     function finalize(uint percentOfTotal) external {
286         if(msg.sender!=master)throw;
287         if(funding)throw;
288 
289         // allows to tranfer token to another address
290         // disables buying LNC
291         funding = false;
292 
293         //send 12% of the token to the devs
294         //10 % for the devs
295         //2 % for the bounty participants
296         uint256 additionalTokens = totalTokens * percentOfTotal / (100 - percentOfTotal);
297         totalTokens += additionalTokens;
298         balances[master] += additionalTokens;
299         Transfer(0, master, additionalTokens);
300 
301         // Transfer ETH to the Blocklancer address.
302         if (!master.send(this.balance)) throw;
303     }
304 	
305 	//everyone needs to call this function should the minimum cap not be reached
306     //refunds the sender
307     function refund() external {
308         if(!startRefund) throw;
309 
310         var gntValue = balances[msg.sender];
311         var ethValue = balancesEther[msg.sender];
312         if (gntValue == 0) throw;
313         
314         //set the amount of token the sender has to 0
315         balances[msg.sender] = 0;
316         
317         //set the amount of ether the sender owns to 0
318         balancesEther[msg.sender] = 0;
319         totalTokens -= gntValue;
320 
321         Refund(msg.sender, ethValue);
322         if (!msg.sender.send(ethValue)) throw;
323     }
324 	
325     // Send _value amount of tokens from address _from to address _to
326     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
327      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
328      // fees in sub-currencies; the command should fail unless the _from account has
329      // deliberately authorized the sender of the message via some mechanism; we propose
330      // these standardized APIs for approval:
331      function transferFrom(address _from,address _to,uint256 _amount) returns (bool success) {
332          if(funding) throw;
333          if(!allowTransfer)throw;
334          if (balances[_from] >= _amount
335              && allowed[_from][msg.sender] >= _amount
336              && _amount > 0
337              && balances[_to] + _amount > balances[_to]) {
338              balances[_from] -= _amount;
339              allowed[_from][msg.sender] -= _amount;
340              balances[_to] += _amount;
341              Transfer(_from, _to, _amount);
342              return true;
343          } else {
344              return false;
345          }
346      }
347   
348      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
349      // If this function is called again it overwrites the current allowance with _value.
350      function approve(address _spender, uint256 _amount) returns (bool success) {
351          if(funding) throw;
352          if(!allowTransfer)throw;
353          allowed[msg.sender][_spender] = _amount;
354          Approval(msg.sender, _spender, _amount);
355          return true;
356      }
357   
358      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
359          return allowed[_owner][_spender];
360      }
361 }