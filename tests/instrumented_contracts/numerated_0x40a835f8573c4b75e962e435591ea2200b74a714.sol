1 pragma solidity ^0.4.16;
2     contract MyEtherTeller  {
3         
4         //Author: Nidscom.io
5         //Date: 23 March 2018
6         //Version: MyEtherTeller v1.0 MainNet
7         
8         address public owner;
9 
10        
11         //Each buyer address consist of an array of EscrowStruct
12         //Used to store buyer's transactions and for buyers to interact with his transactions. (Such as releasing funds to seller)
13         struct EscrowStruct
14         {    
15             address buyer;          //Person who is making payment
16             address seller;         //Person who will receive funds
17             address escrow_agent;   //Escrow agent to resolve disputes, if any
18                                        
19             uint escrow_fee;        //Fee charged by escrow
20             uint amount;            //Amount of Ether (in Wei) seller will receive after fees
21 
22             bool escrow_intervention; //Buyer or Seller can call for Escrow intervention
23             bool release_approval;   //Buyer or Escrow(if escrow_intervention is true) can approve release of funds to seller
24             bool refund_approval;    //Seller or Escrow(if escrow_intervention is true) can approve refund of funds to buyer 
25 
26             bytes32 notes;             //Notes for Seller
27             
28         }
29 
30         struct TransactionStruct
31         {                        
32             //Links to transaction from buyer
33             address buyer;          //Person who is making payment
34             uint buyer_nounce;         //Nounce of buyer transaction                            
35         }
36 
37 
38         
39         //Database of Buyers. Each buyer then contain an array of his transactions
40         mapping(address => EscrowStruct[]) public buyerDatabase;
41 
42         //Database of Seller and Escrow Agent
43         mapping(address => TransactionStruct[]) public sellerDatabase;        
44         mapping(address => TransactionStruct[]) public escrowDatabase;
45                
46         //Every address have a Funds bank. All refunds, sales and escrow comissions are sent to this bank. Address owner can withdraw them at any time.
47         mapping(address => uint) public Funds;
48 
49         mapping(address => uint) public escrowFee;
50 
51 
52 
53         //Run once the moment contract is created. Set contract creator
54         function MyEtherTeller() {
55             owner = msg.sender;
56         }
57 
58         function() payable
59         {
60             //LogFundsReceived(msg.sender, msg.value);
61         }
62 
63         function setEscrowFee(uint fee) {
64 
65             //Allowed fee range: 0.1% to 10%, in increments of 0.1%
66             require (fee >= 1 && fee <= 100);
67             escrowFee[msg.sender] = fee;
68         }
69 
70         function getEscrowFee(address escrowAddress) constant returns (uint) {
71             return (escrowFee[escrowAddress]);
72         }
73 
74         
75         function newEscrow(address sellerAddress, address escrowAddress, bytes32 notes) payable returns (bool) {
76 
77             require(msg.value > 0 && msg.sender != escrowAddress);
78         
79             //Store escrow details in memory
80             EscrowStruct memory currentEscrow;
81             TransactionStruct memory currentTransaction;
82             
83             currentEscrow.buyer = msg.sender;
84             currentEscrow.seller = sellerAddress;
85             currentEscrow.escrow_agent = escrowAddress;
86 
87             //Calculates and stores Escrow Fee.
88             currentEscrow.escrow_fee = getEscrowFee(escrowAddress)*msg.value/1000;
89             
90             //0.25% dev fee
91             uint dev_fee = msg.value/400;
92             Funds[owner] += dev_fee;   
93 
94             //Amount seller receives = Total amount - 0.25% dev fee - Escrow Fee
95             currentEscrow.amount = msg.value - dev_fee - currentEscrow.escrow_fee;
96 
97             //These default to false, no need to set them again
98             /*currentEscrow.escrow_intervention = false;
99             currentEscrow.release_approval = false;
100             currentEscrow.refund_approval = false;  */ 
101             
102             currentEscrow.notes = notes;
103  
104             //Links this transaction to Seller and Escrow's list of transactions.
105             currentTransaction.buyer = msg.sender;
106             currentTransaction.buyer_nounce = buyerDatabase[msg.sender].length;
107 
108             sellerDatabase[sellerAddress].push(currentTransaction);
109             escrowDatabase[escrowAddress].push(currentTransaction);
110             buyerDatabase[msg.sender].push(currentEscrow);
111             
112             return true;
113 
114         }
115 
116         //switcher 0 for Buyer, 1 for Seller, 2 for Escrow
117         function getNumTransactions(address inputAddress, uint switcher) constant returns (uint)
118         {
119 
120             if (switcher == 0) return (buyerDatabase[inputAddress].length);
121 
122             else if (switcher == 1) return (sellerDatabase[inputAddress].length);
123 
124             else return (escrowDatabase[inputAddress].length);
125         }
126 
127         //switcher 0 for Buyer, 1 for Seller, 2 for Escrow
128         function getSpecificTransaction(address inputAddress, uint switcher, uint ID) constant returns (address, address, address, uint, bytes32, uint, bytes32)
129 
130         {
131             bytes32 status;
132             EscrowStruct memory currentEscrow;
133             if (switcher == 0)
134             {
135                 currentEscrow = buyerDatabase[inputAddress][ID];
136                 status = checkStatus(inputAddress, ID);
137             } 
138             
139             else if (switcher == 1)
140 
141             {  
142                 currentEscrow = buyerDatabase[sellerDatabase[inputAddress][ID].buyer][sellerDatabase[inputAddress][ID].buyer_nounce];
143                 status = checkStatus(currentEscrow.buyer, sellerDatabase[inputAddress][ID].buyer_nounce);
144             }
145 
146                         
147             else if (switcher == 2)
148             
149             {        
150                 currentEscrow = buyerDatabase[escrowDatabase[inputAddress][ID].buyer][escrowDatabase[inputAddress][ID].buyer_nounce];
151                 status = checkStatus(currentEscrow.buyer, escrowDatabase[inputAddress][ID].buyer_nounce);
152             }
153 
154             return (currentEscrow.buyer, currentEscrow.seller, currentEscrow.escrow_agent, currentEscrow.amount, status, currentEscrow.escrow_fee, currentEscrow.notes);
155         }   
156 
157 
158         function buyerHistory(address buyerAddress, uint startID, uint numToLoad) constant returns (address[], address[],uint[], bytes32[]){
159 
160 
161             uint length;
162             if (buyerDatabase[buyerAddress].length < numToLoad)
163                 length = buyerDatabase[buyerAddress].length;
164             
165             else 
166                 length = numToLoad;
167             
168             address[] memory sellers = new address[](length);
169             address[] memory escrow_agents = new address[](length);
170             uint[] memory amounts = new uint[](length);
171             bytes32[] memory statuses = new bytes32[](length);
172            
173             for (uint i = 0; i < length; i++)
174             {
175   
176                 sellers[i] = (buyerDatabase[buyerAddress][startID + i].seller);
177                 escrow_agents[i] = (buyerDatabase[buyerAddress][startID + i].escrow_agent);
178                 amounts[i] = (buyerDatabase[buyerAddress][startID + i].amount);
179                 statuses[i] = checkStatus(buyerAddress, startID + i);
180             }
181             
182             return (sellers, escrow_agents, amounts, statuses);
183         }
184 
185 
186                  
187         function SellerHistory(address inputAddress, uint startID , uint numToLoad) constant returns (address[], address[], uint[], bytes32[]){
188 
189             address[] memory buyers = new address[](numToLoad);
190             address[] memory escrows = new address[](numToLoad);
191             uint[] memory amounts = new uint[](numToLoad);
192             bytes32[] memory statuses = new bytes32[](numToLoad);
193 
194             for (uint i = 0; i < numToLoad; i++)
195             {
196                 if (i >= sellerDatabase[inputAddress].length)
197                     break;
198                 buyers[i] = sellerDatabase[inputAddress][startID + i].buyer;
199                 escrows[i] = buyerDatabase[buyers[i]][sellerDatabase[inputAddress][startID +i].buyer_nounce].escrow_agent;
200                 amounts[i] = buyerDatabase[buyers[i]][sellerDatabase[inputAddress][startID + i].buyer_nounce].amount;
201                 statuses[i] = checkStatus(buyers[i], sellerDatabase[inputAddress][startID + i].buyer_nounce);
202             }
203             return (buyers, escrows, amounts, statuses);
204         }
205 
206         function escrowHistory(address inputAddress, uint startID, uint numToLoad) constant returns (address[], address[], uint[], bytes32[]){
207         
208             address[] memory buyers = new address[](numToLoad);
209             address[] memory sellers = new address[](numToLoad);
210             uint[] memory amounts = new uint[](numToLoad);
211             bytes32[] memory statuses = new bytes32[](numToLoad);
212 
213             for (uint i = 0; i < numToLoad; i++)
214             {
215                 if (i >= escrowDatabase[inputAddress].length)
216                     break;
217                 buyers[i] = escrowDatabase[inputAddress][startID + i].buyer;
218                 sellers[i] = buyerDatabase[buyers[i]][escrowDatabase[inputAddress][startID +i].buyer_nounce].seller;
219                 amounts[i] = buyerDatabase[buyers[i]][escrowDatabase[inputAddress][startID + i].buyer_nounce].amount;
220                 statuses[i] = checkStatus(buyers[i], escrowDatabase[inputAddress][startID + i].buyer_nounce);
221             }
222             return (buyers, sellers, amounts, statuses);
223     }
224 
225         function checkStatus(address buyerAddress, uint nounce) constant returns (bytes32){
226 
227             bytes32 status = "";
228 
229             if (buyerDatabase[buyerAddress][nounce].release_approval){
230                 status = "Complete";
231             } else if (buyerDatabase[buyerAddress][nounce].refund_approval){
232                 status = "Refunded";
233             } else if (buyerDatabase[buyerAddress][nounce].escrow_intervention){
234                 status = "Pending Escrow Decision";
235             } else
236             {
237                 status = "In Progress";
238             }
239        
240             return (status);
241         }
242 
243         
244         //When transaction is complete, buyer will release funds to seller
245         //Even if EscrowEscalation is raised, buyer can still approve fund release at any time
246         function buyerFundRelease(uint ID)
247         {
248             require(ID < buyerDatabase[msg.sender].length && 
249             buyerDatabase[msg.sender][ID].release_approval == false &&
250             buyerDatabase[msg.sender][ID].refund_approval == false);
251             
252             //Set release approval to true. Ensure approval for each transaction can only be called once.
253             buyerDatabase[msg.sender][ID].release_approval = true;
254 
255             address seller = buyerDatabase[msg.sender][ID].seller;
256             address escrow_agent = buyerDatabase[msg.sender][ID].escrow_agent;
257 
258             uint amount = buyerDatabase[msg.sender][ID].amount;
259             uint escrow_fee = buyerDatabase[msg.sender][ID].escrow_fee;
260 
261             //Move funds under seller's owership
262             Funds[seller] += amount;
263             Funds[escrow_agent] += escrow_fee;
264 
265 
266         }
267 
268         //Seller can refund the buyer at any time
269         function sellerRefund(uint ID)
270         {
271             address buyerAddress = sellerDatabase[msg.sender][ID].buyer;
272             uint buyerID = sellerDatabase[msg.sender][ID].buyer_nounce;
273 
274             require(
275             buyerDatabase[buyerAddress][buyerID].release_approval == false &&
276             buyerDatabase[buyerAddress][buyerID].refund_approval == false); 
277 
278             address escrow_agent = buyerDatabase[buyerAddress][buyerID].escrow_agent;
279             uint escrow_fee = buyerDatabase[buyerAddress][buyerID].escrow_fee;
280             uint amount = buyerDatabase[buyerAddress][buyerID].amount;
281         
282             //Once approved, buyer can invoke WithdrawFunds to claim his refund
283             buyerDatabase[buyerAddress][buyerID].refund_approval = true;
284 
285             Funds[buyerAddress] += amount;
286             Funds[escrow_agent] += escrow_fee;
287             
288         }
289         
290         
291 
292         //Either buyer or seller can raise escalation with escrow agent. 
293         //Once escalation is activated, escrow agent can release funds to seller OR make a full refund to buyer
294 
295         //Switcher = 0 for Buyer, Switcher = 1 for Seller
296         function EscrowEscalation(uint switcher, uint ID)
297         {
298             //To activate EscrowEscalation
299             //1) Buyer must not have approved fund release.
300             //2) Seller must not have approved a refund.
301             //3) EscrowEscalation is being activated for the first time
302 
303             //There is no difference whether the buyer or seller activates EscrowEscalation.
304             address buyerAddress;
305             uint buyerID; //transaction ID of in buyer's history
306             if (switcher == 0) // Buyer
307             {
308                 buyerAddress = msg.sender;
309                 buyerID = ID;
310             } else if (switcher == 1) //Seller
311             {
312                 buyerAddress = sellerDatabase[msg.sender][ID].buyer;
313                 buyerID = sellerDatabase[msg.sender][ID].buyer_nounce;
314             }
315 
316             require(buyerDatabase[buyerAddress][buyerID].escrow_intervention == false  &&
317             buyerDatabase[buyerAddress][buyerID].release_approval == false &&
318             buyerDatabase[buyerAddress][buyerID].refund_approval == false);
319 
320             //Activate the ability for Escrow Agent to intervent in this transaction
321             buyerDatabase[buyerAddress][buyerID].escrow_intervention = true;
322 
323             
324         }
325         
326         //ID is the transaction ID from Escrow's history. 
327         //Decision = 0 is for refunding Buyer. Decision = 1 is for releasing funds to Seller
328         function escrowDecision(uint ID, uint Decision)
329         {
330             //Escrow can only make the decision IF
331             //1) Buyer has not yet approved fund release to seller
332             //2) Seller has not yet approved a refund to buyer
333             //3) Escrow Agent has not yet approved fund release to seller AND not approved refund to buyer
334             //4) Escalation Escalation is activated
335 
336             address buyerAddress = escrowDatabase[msg.sender][ID].buyer;
337             uint buyerID = escrowDatabase[msg.sender][ID].buyer_nounce;
338             
339 
340             require(
341             buyerDatabase[buyerAddress][buyerID].release_approval == false &&
342             buyerDatabase[buyerAddress][buyerID].escrow_intervention == true &&
343             buyerDatabase[buyerAddress][buyerID].refund_approval == false);
344             
345             uint escrow_fee = buyerDatabase[buyerAddress][buyerID].escrow_fee;
346             uint amount = buyerDatabase[buyerAddress][buyerID].amount;
347 
348             if (Decision == 0) //Refund Buyer
349             {
350                 buyerDatabase[buyerAddress][buyerID].refund_approval = true;    
351                 Funds[buyerAddress] += amount;
352                 Funds[msg.sender] += escrow_fee;
353                 
354             } else if (Decision == 1) //Release funds to Seller
355             {                
356                 buyerDatabase[buyerAddress][buyerID].release_approval = true;
357                 Funds[buyerDatabase[buyerAddress][buyerID].seller] += amount;
358                 Funds[msg.sender] += escrow_fee;
359             }  
360         }
361         
362         function WithdrawFunds()
363         {
364             uint amount = Funds[msg.sender];
365             Funds[msg.sender] = 0;
366             if (!msg.sender.send(amount))
367                 Funds[msg.sender] = amount;
368         }
369 
370 
371         function CheckBalance(address fromAddress) constant returns (uint){
372             return (Funds[fromAddress]);
373         }
374      
375     }