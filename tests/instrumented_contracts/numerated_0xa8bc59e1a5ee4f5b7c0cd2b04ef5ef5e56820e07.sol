1 contract EscrowMyEther  {
2        
3 
4         
5         address public owner;
6 
7        
8         //Each buyer address consist of an array of EscrowStruct
9         //Used to store buyer's transactions and for buyers to interact with his transactions. (Such as releasing funds to seller)
10         struct EscrowStruct
11         {    
12             address buyer;          //Person who is making payment
13             address seller;         //Person who will receive funds
14             address escrow_agent;   //Escrow agent to resolve disputes, if any
15                                        
16             uint escrow_fee;        //Fee charged by escrow
17             uint amount;            //Amount of Ether (in Wei) seller will receive after fees
18 
19             bool escrow_intervention; //Buyer or Seller can call for Escrow intervention
20             bool release_approval;   //Buyer or Escrow(if escrow_intervention is true) can approve release of funds to seller
21             bool refund_approval;    //Seller or Escrow(if escrow_intervention is true) can approve refund of funds to buyer 
22 
23             bytes32 notes;             //Notes for Seller
24             
25         }
26 
27         struct TransactionStruct
28         {                        
29             //Links to transaction from buyer
30             address buyer;          //Person who is making payment
31             uint buyer_nounce;         //Nounce of buyer transaction                            
32         }
33 
34 
35         
36         //Database of Buyers. Each buyer then contain an array of his transactions
37         mapping(address => EscrowStruct[]) public buyerDatabase;
38 
39         //Database of Seller and Escrow Agent
40         mapping(address => TransactionStruct[]) public sellerDatabase;        
41         mapping(address => TransactionStruct[]) public escrowDatabase;
42                
43         //Every address have a Funds bank. All refunds, sales and escrow comissions are sent to this bank. Address owner can withdraw them at any time.
44         mapping(address => uint) public Funds;
45 
46         mapping(address => uint) public escrowFee;
47 
48 
49 
50         //Run once the moment contract is created. Set contract creator
51         function EscrowMyEther () public {
52             owner = msg.sender;
53         }
54 
55         function() internal payable
56         {
57             //LogFundsReceived(msg.sender, msg.value);
58         }
59 
60         function setEscrowFee(uint fee) public {
61 
62             //Allowed fee range: 0.1% to 10%, in increments of 0.1%
63             require (fee >= 1 && fee <= 100);
64             escrowFee[msg.sender] = fee;
65         }
66 
67         function getEscrowFee(address escrowAddress) public constant returns (uint) {
68             return (escrowFee[escrowAddress]);
69         }
70 
71         
72         function newEscrow(address sellerAddress, address escrowAddress, bytes32 notes) public payable returns (bool) {
73 
74             require(msg.value > 0 && msg.sender != escrowAddress);
75         
76             //Store escrow details in memory
77             EscrowStruct memory currentEscrow;
78             TransactionStruct memory currentTransaction;
79             
80             currentEscrow.buyer = msg.sender;
81             currentEscrow.seller = sellerAddress;
82             currentEscrow.escrow_agent = escrowAddress;
83 
84             //Calculates and stores Escrow Fee.
85             currentEscrow.escrow_fee = getEscrowFee(escrowAddress)*msg.value/1000;
86             
87             //0.25% dev fee
88             uint dev_fee = msg.value/400;
89             Funds[owner] += dev_fee;   
90 
91             //Amount seller receives = Total amount - 0.25% dev fee - Escrow Fee
92             currentEscrow.amount = msg.value;
93 
94             //These default to false, no need to set them again
95             /*currentEscrow.escrow_intervention = false;
96             currentEscrow.release_approval = false;
97             currentEscrow.refund_approval = false;  */ 
98             
99             currentEscrow.notes = notes;
100  
101             //Links this transaction to Seller and Escrow's list of transactions.
102             currentTransaction.buyer = msg.sender;
103             currentTransaction.buyer_nounce = buyerDatabase[msg.sender].length;
104 
105             sellerDatabase[sellerAddress].push(currentTransaction);
106             escrowDatabase[escrowAddress].push(currentTransaction);
107             buyerDatabase[msg.sender].push(currentEscrow);
108             
109             return true;
110 
111         }
112 
113         //switcher 0 for Buyer, 1 for Seller, 2 for Escrow
114         function getNumTransactions(address inputAddress, uint switcher) public constant returns (uint)
115         {
116 
117             if (switcher == 0) return (buyerDatabase[inputAddress].length);
118 
119             else if (switcher == 1) return (sellerDatabase[inputAddress].length);
120 
121             else return (escrowDatabase[inputAddress].length);
122         }
123 
124         //switcher 0 for Buyer, 1 for Seller, 2 for Escrow
125         function getSpecificTransaction(address inputAddress, uint switcher, uint ID) public constant returns (address, address, address, uint, bytes32, uint, bytes32)
126 
127         {
128             bytes32 status;
129             EscrowStruct memory currentEscrow;
130             if (switcher == 0)
131             {
132                 currentEscrow = buyerDatabase[inputAddress][ID];
133                 status = checkStatus(inputAddress, ID);
134             } 
135             
136             else if (switcher == 1)
137 
138             {  
139                 currentEscrow = buyerDatabase[sellerDatabase[inputAddress][ID].buyer][sellerDatabase[inputAddress][ID].buyer_nounce];
140                 status = checkStatus(currentEscrow.buyer, sellerDatabase[inputAddress][ID].buyer_nounce);
141             }
142 
143                         
144             else if (switcher == 2)
145             
146             {        
147                 currentEscrow = buyerDatabase[escrowDatabase[inputAddress][ID].buyer][escrowDatabase[inputAddress][ID].buyer_nounce];
148                 status = checkStatus(currentEscrow.buyer, escrowDatabase[inputAddress][ID].buyer_nounce);
149             }
150 
151             return (currentEscrow.buyer, currentEscrow.seller, currentEscrow.escrow_agent, currentEscrow.amount, status, currentEscrow.escrow_fee, currentEscrow.notes);
152         }   
153 
154 
155         function buyerHistory(address buyerAddress, uint startID, uint numToLoad) public constant returns (address[], address[],uint[], bytes32[]){
156 
157 
158             uint length;
159             if (buyerDatabase[buyerAddress].length < numToLoad)
160                 length = buyerDatabase[buyerAddress].length;
161             
162             else 
163                 length = numToLoad;
164             
165             address[] memory sellers = new address[](length);
166             address[] memory escrow_agents = new address[](length);
167             uint[] memory amounts = new uint[](length);
168             bytes32[] memory statuses = new bytes32[](length);
169            
170             for (uint i = 0; i < length; i++)
171             {
172   
173                 sellers[i] = (buyerDatabase[buyerAddress][startID + i].seller);
174                 escrow_agents[i] = (buyerDatabase[buyerAddress][startID + i].escrow_agent);
175                 amounts[i] = (buyerDatabase[buyerAddress][startID + i].amount);
176                 statuses[i] = checkStatus(buyerAddress, startID + i);
177             }
178             
179             return (sellers, escrow_agents, amounts, statuses);
180         }
181 
182 
183                  
184         function SellerHistory(address inputAddress, uint startID , uint numToLoad) public constant returns (address[], address[], uint[], bytes32[]){
185 
186             address[] memory buyers = new address[](numToLoad);
187             address[] memory escrows = new address[](numToLoad);
188             uint[] memory amounts = new uint[](numToLoad);
189             bytes32[] memory statuses = new bytes32[](numToLoad);
190 
191             for (uint i = 0; i < numToLoad; i++)
192             {
193                 if (i >= sellerDatabase[inputAddress].length)
194                     break;
195                 buyers[i] = sellerDatabase[inputAddress][startID + i].buyer;
196                 escrows[i] = buyerDatabase[buyers[i]][sellerDatabase[inputAddress][startID +i].buyer_nounce].escrow_agent;
197                 amounts[i] = buyerDatabase[buyers[i]][sellerDatabase[inputAddress][startID + i].buyer_nounce].amount;
198                 statuses[i] = checkStatus(buyers[i], sellerDatabase[inputAddress][startID + i].buyer_nounce);
199             }
200             return (buyers, escrows, amounts, statuses);
201         }
202 
203         function escrowHistory(address inputAddress, uint startID, uint numToLoad) public constant returns (address[], address[], uint[], bytes32[]){
204         
205             address[] memory buyers = new address[](numToLoad);
206             address[] memory sellers = new address[](numToLoad);
207             uint[] memory amounts = new uint[](numToLoad);
208             bytes32[] memory statuses = new bytes32[](numToLoad);
209 
210             for (uint i = 0; i < numToLoad; i++)
211             {
212                 if (i >= escrowDatabase[inputAddress].length)
213                     break;
214                 buyers[i] = escrowDatabase[inputAddress][startID + i].buyer;
215                 sellers[i] = buyerDatabase[buyers[i]][escrowDatabase[inputAddress][startID +i].buyer_nounce].seller;
216                 amounts[i] = buyerDatabase[buyers[i]][escrowDatabase[inputAddress][startID + i].buyer_nounce].amount;
217                 statuses[i] = checkStatus(buyers[i], escrowDatabase[inputAddress][startID + i].buyer_nounce);
218             }
219             return (buyers, sellers, amounts, statuses);
220     }
221 
222         function checkStatus(address buyerAddress, uint nounce) public constant returns (bytes32){
223 
224             bytes32 status = "";
225 
226             if (buyerDatabase[buyerAddress][nounce].release_approval){
227                 status = "Complete";
228             } else if (buyerDatabase[buyerAddress][nounce].refund_approval){
229                 status = "Refunded";
230             } else if (buyerDatabase[buyerAddress][nounce].escrow_intervention){
231                 status = "Pending Escrow Decision";
232             } else
233             {
234                 status = "In Progress";
235             }
236        
237             return (status);
238         }
239 
240         
241         //When transaction is complete, buyer will release funds to seller
242         //Even if EscrowEscalation is raised, buyer can still approve fund release at any time
243         function buyerFundRelease(uint ID) public
244         {
245             require(ID < buyerDatabase[msg.sender].length && 
246             buyerDatabase[msg.sender][ID].release_approval == false &&
247             buyerDatabase[msg.sender][ID].refund_approval == false);
248             
249             //Set release approval to true. Ensure approval for each transaction can only be called once.
250             buyerDatabase[msg.sender][ID].release_approval = true;
251 
252             address seller = buyerDatabase[msg.sender][ID].seller;
253             address escrow_agent = buyerDatabase[msg.sender][ID].escrow_agent;
254 
255             uint amount = buyerDatabase[msg.sender][ID].amount;
256             uint escrow_fee = buyerDatabase[msg.sender][ID].escrow_fee;
257 
258             //Move funds under seller's owership
259             Funds[seller] += amount;
260             Funds[escrow_agent] += escrow_fee;
261 
262 
263         }
264 
265         //Seller can refund the buyer at any time
266         function sellerRefund(uint ID) public
267         {
268             address buyerAddress = sellerDatabase[msg.sender][ID].buyer;
269             uint buyerID = sellerDatabase[msg.sender][ID].buyer_nounce;
270 
271             require(
272             buyerDatabase[buyerAddress][buyerID].release_approval == false &&
273             buyerDatabase[buyerAddress][buyerID].refund_approval == false); 
274 
275             address escrow_agent = buyerDatabase[buyerAddress][buyerID].escrow_agent;
276             uint escrow_fee = buyerDatabase[buyerAddress][buyerID].escrow_fee;
277             uint amount = buyerDatabase[buyerAddress][buyerID].amount;
278         
279             //Once approved, buyer can invoke WithdrawFunds to claim his refund
280             buyerDatabase[buyerAddress][buyerID].refund_approval = true;
281 
282             Funds[buyerAddress] += amount;
283             Funds[escrow_agent] += escrow_fee;
284             
285         }
286         
287         
288 
289         //Either buyer or seller can raise escalation with escrow agent. 
290         //Once escalation is activated, escrow agent can release funds to seller OR make a full refund to buyer
291 
292         //Switcher = 0 for Buyer, Switcher = 1 for Seller
293         function EscrowEscalation(uint switcher, uint ID) public
294         {
295             //To activate EscrowEscalation
296             //1) Buyer must not have approved fund release.
297             //2) Seller must not have approved a refund.
298             //3) EscrowEscalation is being activated for the first time
299 
300             //There is no difference whether the buyer or seller activates EscrowEscalation.
301             address buyerAddress;
302             uint buyerID; //transaction ID of in buyer's history
303             if (switcher == 0) // Buyer
304             {
305                 buyerAddress = msg.sender;
306                 buyerID = ID;
307             } else if (switcher == 1) //Seller
308             {
309                 buyerAddress = sellerDatabase[msg.sender][ID].buyer;
310                 buyerID = sellerDatabase[msg.sender][ID].buyer_nounce;
311             }
312 
313             require(buyerDatabase[buyerAddress][buyerID].escrow_intervention == false  &&
314             buyerDatabase[buyerAddress][buyerID].release_approval == false &&
315             buyerDatabase[buyerAddress][buyerID].refund_approval == false);
316 
317             //Activate the ability for Escrow Agent to intervent in this transaction
318             buyerDatabase[buyerAddress][buyerID].escrow_intervention = true;
319 
320             
321         }
322         
323         //ID is the transaction ID from Escrow's history. 
324         //Decision = 0 is for refunding Buyer. Decision = 1 is for releasing funds to Seller
325         function escrowDecision(uint ID, uint Decision) public
326         {
327             //Escrow can only make the decision IF
328             //1) Buyer has not yet approved fund release to seller
329             //2) Seller has not yet approved a refund to buyer
330             //3) Escrow Agent has not yet approved fund release to seller AND not approved refund to buyer
331             //4) Escalation Escalation is activated
332 
333             address buyerAddress = escrowDatabase[msg.sender][ID].buyer;
334             uint buyerID = escrowDatabase[msg.sender][ID].buyer_nounce;
335             
336 
337             require(
338             buyerDatabase[buyerAddress][buyerID].release_approval == false &&
339             buyerDatabase[buyerAddress][buyerID].escrow_intervention == true &&
340             buyerDatabase[buyerAddress][buyerID].refund_approval == false);
341             
342             uint escrow_fee = buyerDatabase[buyerAddress][buyerID].escrow_fee;
343             uint amount = buyerDatabase[buyerAddress][buyerID].amount;
344 
345             if (Decision == 0) //Refund Buyer
346             {
347                 buyerDatabase[buyerAddress][buyerID].refund_approval = true;    
348                 Funds[buyerAddress] += amount;
349                 Funds[msg.sender] += escrow_fee;
350                 
351             } else if (Decision == 1) //Release funds to Seller
352             {                
353                 buyerDatabase[buyerAddress][buyerID].release_approval = true;
354                 Funds[buyerDatabase[buyerAddress][buyerID].seller] += amount;
355                 Funds[msg.sender] += escrow_fee;
356             }  
357         }
358         
359         function WithdrawFunds() public
360         {
361             uint amount = Funds[msg.sender];
362             Funds[msg.sender] = 0;
363             if (!msg.sender.send(amount))
364                 Funds[msg.sender] = amount;
365         }
366 
367 
368         function CheckBalance(address fromAddress) public constant returns (uint){
369             return (Funds[fromAddress]);
370         }
371      
372 }