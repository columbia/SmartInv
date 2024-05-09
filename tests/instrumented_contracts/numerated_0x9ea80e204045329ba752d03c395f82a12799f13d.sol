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
48     // The funding cap in weis.
49     uint256 public constant tokenCreationCap = 1000000000* 10**18;
50     uint256 public constant tokenCreationMin = 150000000* 10**18;
51     
52     mapping(address => mapping (address => uint256)) allowed;
53 
54     uint public fundingStart;
55     uint public fundingEnd;
56 
57     // The flag indicates if the LNC contract is in Funding state.
58     bool public funding = true;
59 
60     // Receives ETH and its own LNC endowment.
61     address public master;
62 
63     // The current total token supply.
64     uint256 totalTokens;
65     
66     //needed to calculate the price after the power day
67     //the price increases by 1 % for every 10 million LNC sold after power day
68     uint256 soldAfterPowerHour;
69 
70     mapping (address => uint256) balances;
71     mapping (address => uint) lastTransferred;
72     
73     //needed to refund everyone should the ICO fail
74     // needed because the price per LNC isn't linear
75     mapping (address => uint256) balancesEther;
76 
77     //address of the contract that manages the migration
78     //can only be changed by the creator
79     address public migrationAgent;
80     
81     //total amount of token migrated
82     //allows everyone to see the progress of the migration
83     uint256 public totalMigrated;
84 
85     event Migrate(address indexed _from, address indexed _to, uint256 _value);
86     event Refund(address indexed _from, uint256 _value);
87     
88     //total amount of participants in the ICO
89     uint totalParticipants;
90 
91     function BlocklancerToken() {
92         master = msg.sender;
93         fundingStart = 1501977600;
94         //change first number!
95         fundingEnd = fundingStart + 31 * 1 days;//now + 1000 * 1 minutes;
96     }
97     
98     //returns the total amount of participants in the ICO
99     function getAmountofTotalParticipants() constant returns (uint){
100         return totalParticipants;
101     }
102     
103     //set
104     function getAmountSoldAfterPowerDay() constant external returns(uint256){
105         return soldAfterPowerHour;
106     }
107 
108     /// allows to transfer token to another address
109     function transfer(address _to, uint256 _value) returns (bool success) {
110         // Don't allow in funding state
111         if(funding) throw;
112 
113         var senderBalance = balances[msg.sender];
114         //only allow if the balance of the sender is more than he want's to send
115         if (senderBalance >= _value && _value > 0) {
116             //reduce the sender balance by the amount he sends
117             senderBalance -= _value;
118             balances[msg.sender] = senderBalance;
119             
120             //increase the balance of the receiver by the amount we reduced the balance of the sender
121             balances[_to] += _value;
122             
123             //saves the last time someone sent LNc from this address
124             //is needed for our Token Holder Tribunal
125             //this ensures that everyone can only vote one time
126             //otherwise it would be possible to send the LNC around and everyone votes again and again
127             lastTransferred[msg.sender]=block.timestamp;
128             Transfer(msg.sender, _to, _value);
129             return true;
130         }
131         //transfer failed
132         return false;
133     }
134 
135     //returns the total amount of LNC in circulation
136     //get displayed on the website whilst the crowd funding
137     function totalSupply() constant returns (uint256 totalSupply) {
138         return totalTokens;
139     }
140     
141     //retruns the balance of the owner address
142     function balanceOf(address _owner) constant returns (uint256 balance) {
143         return balances[_owner];
144     }
145     
146     //returns the amount anyone pledged into this contract
147     function EtherBalanceOf(address _owner) constant returns (uint256) {
148         return balancesEther[_owner];
149     }
150     
151     //time left before the crodsale ends
152     function TimeLeft() external constant returns (uint256) {
153         if(fundingEnd>block.timestamp)
154             return fundingEnd-block.timestamp;
155         else
156             return 0;
157     }
158     
159     //time left before the crodsale begins
160     function TimeLeftBeforeCrowdsale() external constant returns (uint256) {
161         if(fundingStart>block.timestamp)
162             return fundingStart-block.timestamp;
163         else
164             return 0;
165     }
166 
167     // allows us to migrate to anew contract
168     function migrate(uint256 _value) external {
169         // can only be called if the funding ended
170         if(funding) throw;
171         
172         //the migration agent address needs to be set
173         if(migrationAgent == 0) throw;
174 
175         // must migrate more than nothing
176         if(_value == 0) throw;
177         
178         //if the value is higher than the sender owns abort
179         if(_value > balances[msg.sender]) throw;
180 
181         //reduce the balance of the owner
182         balances[msg.sender] -= _value;
183         
184         //reduce the token left in the old contract
185         totalTokens -= _value;
186         totalMigrated += _value;
187         
188         //call the migration agent to complete the migration
189         //credits the same amount of LNC in the new contract
190         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
191         Migrate(msg.sender, migrationAgent, _value);
192     }
193 
194     //sets the address of the migration agent
195     function setMigrationAgent(address _agent) external {
196         //not possible in funding mode
197         if(funding) throw;
198         
199         //only allow to set this once
200         if(migrationAgent != 0) throw;
201         
202         //anly the owner can call this function
203         if(msg.sender != master) throw;
204         
205         //set the migration agent
206         migrationAgent = _agent;
207     }
208     
209     //return the current exchange rate -> LNC per Ether
210     function getExchangeRate() constant returns(uint){
211         //15000 LNC at power day
212         if(fundingStart + 1 * 1 days > block.timestamp){
213             return 15000;
214         }
215         //otherwise reduce by 1 % every 10 million LNC sold
216         else{
217             uint256 decrease=100-(soldAfterPowerHour/10000000/1000000000000000000);
218             if(decrease<70){
219                 decrease=70;
220             }
221             return 10000*decrease/100;
222         }
223     }
224     
225     //returns if the crowd sale is still open
226     function ICOopen() constant returns(bool){
227         if(!funding) return false;
228         else if(block.timestamp < fundingStart) return false;
229         else if(block.timestamp > fundingEnd) return false;
230         else if(tokenCreationCap <= totalTokens) return false;
231         else return true;
232     }
233 
234     // Crowdfunding:
235 
236     //when someone send ether to this contract
237     function() payable external {
238         //not possible if the funding has ended
239         if(!funding) throw;
240         
241         //not possible before the funding started
242         if(block.timestamp < fundingStart) throw;
243         
244         //not possible after the funding ended
245         if(block.timestamp > fundingEnd) throw;
246 
247         // Do not allow creating 0 or more than the cap tokens.
248         if(msg.value == 0) throw;
249         
250         //don't allow to create more token than the maximum cap
251         if((msg.value  * getExchangeRate()) > (tokenCreationCap - totalTokens)) throw;
252 
253         //calculate the amount of LNC the sender receives
254         var numTokens = msg.value * getExchangeRate();
255         totalTokens += numTokens;
256         
257         //increase the amount of token sold after power day
258         //allows us to calculate the 1 % price increase per 10 million LNC sold
259         if(getExchangeRate()!=15000){
260             soldAfterPowerHour += numTokens;
261         }
262 
263         // increase the amount of token the sender holds
264         balances[msg.sender] += numTokens;
265         
266         //increase the amount of ether the sender pledged into the contract
267         balancesEther[msg.sender] += msg.value;
268         
269         //icrease the amount of people that sent ether to this contract
270         totalParticipants+=1;
271 
272         // Log token creation
273         Transfer(0, msg.sender, numTokens);
274     }
275 
276     //called after the crodsale ended
277     //needed to allow everyone to send their LNC around
278     function finalize() external {
279         // not possible if the funding already ended
280         if(!funding) throw;
281         
282         //only possible if funding ended and the minimum cap is reached - or
283         //the total amount of token is the same as the maximum cap
284         if((block.timestamp <= fundingEnd ||
285              totalTokens < tokenCreationMin) &&
286             (totalTokens+5000000000000000000000) < tokenCreationCap) throw;
287 
288         // allows to tranfer token to another address
289         // disables buying LNC
290         funding = false;
291 
292         //send 12% of the token to the devs
293         //10 % for the devs
294         //2 % for the bounty participants
295         uint256 percentOfTotal = 12;
296         uint256 additionalTokens = totalTokens * percentOfTotal / (100 - percentOfTotal);
297         totalTokens += additionalTokens;
298         balances[master] += additionalTokens;
299         Transfer(0, master, additionalTokens);
300 
301         // Transfer ETH to the Blocklancer address.
302         if (!master.send(this.balance)) throw;
303     }
304 
305     //everyone needs to call this function should the minimum cap not be reached
306     //refunds the sender
307     function refund() external {
308         // not possible after the ICO was finished
309         if(!funding) throw;
310         
311         //not possible before the ICO ended
312         if(block.timestamp <= fundingEnd) throw;
313         
314         //not possible if more token were created than the minimum
315         if(totalTokens >= tokenCreationMin) throw;
316 
317         var lncValue = balances[msg.sender];
318         var ethValue = balancesEther[msg.sender];
319         if (lncValue == 0) throw;
320         
321         //set the amount of token the sender has to 0
322         balances[msg.sender] = 0;
323         
324         //set the amount of ether the sender owns to 0
325         balancesEther[msg.sender] = 0;
326         totalTokens -= lncValue;
327 
328         Refund(msg.sender, ethValue);
329         if (!msg.sender.send(ethValue)) throw;
330     }
331 	
332     // Send _value amount of tokens from address _from to address _to
333     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
334      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
335      // fees in sub-currencies; the command should fail unless the _from account has
336      // deliberately authorized the sender of the message via some mechanism; we propose
337      // these standardized APIs for approval:
338      function transferFrom(address _from,address _to,uint256 _amount) returns (bool success) {
339          if(funding) throw;
340          if (balances[_from] >= _amount
341              && allowed[_from][msg.sender] >= _amount
342              && _amount > 0
343              && balances[_to] + _amount > balances[_to]) {
344              balances[_from] -= _amount;
345              allowed[_from][msg.sender] -= _amount;
346              balances[_to] += _amount;
347              Transfer(_from, _to, _amount);
348              return true;
349          } else {
350              return false;
351          }
352      }
353   
354      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
355      // If this function is called again it overwrites the current allowance with _value.
356      function approve(address _spender, uint256 _amount) returns (bool success) {
357          if(funding) throw;
358          allowed[msg.sender][_spender] = _amount;
359          Approval(msg.sender, _spender, _amount);
360          return true;
361      }
362   
363      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
364          return allowed[_owner][_spender];
365      }
366 }