1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.2;
3 
4 
5 //import "hardhat/console.sol";
6 
7 abstract contract ERC20 {
8   function balanceOf(address a) public view virtual returns (uint256);  
9 }
10 
11 contract Vinyl {
12   address admin_address;
13   uint256 public totalEarned; //amount due to store owner
14   uint256 public numOrders; //max order num
15   uint256 public startOrderNum; //max order num  
16   uint32 public numProducts; //max products
17   bool public purchasesDisabled;
18 
19   uint256 public refund_percent; //percentage to refund when leaving the queue
20   
21   event ePurchased(uint256 oid);
22   event eRefund(uint256 oid, uint256 amount);
23   event eBoost(uint256 oid);  
24   event eShipped(uint256 oid);
25   
26   struct ProductStruct {
27     uint256 price;
28     uint256 supply;
29   }
30 
31   struct AccessStruct {
32     ERC20 econtract;
33     uint256 minRequired;
34     bool enabled;
35   }
36     
37   ProductStruct[32] public products;
38   AccessStruct[16] public accessProfiles;
39   
40   struct OrderStruct {
41     uint32 state; //0 pending, 1 in progress, 2 filled, 3 refunded
42     uint32 pid; //product id    
43     uint256 boostAmount; //premium staked for order queue
44     uint256 paidAmount; //amount paid for order
45     address owner;
46   }
47   
48   mapping(uint256 => OrderStruct) orders;
49 
50   modifier requireAdmin() {
51     require(admin_address == msg.sender,"Requires admin privileges");
52     _;
53   }
54 
55   modifier requireOwner(uint256 oid) {
56     if (oid >= numOrders) {
57       revert("Order ID out of range");
58     }
59     
60     require(msg.sender == orders[oid].owner,"Not owner of order");
61     _;
62   }
63 
64   modifier requireOwnerOrAdmin(uint256 oid) {
65     if (oid >= numOrders) {
66       revert("Order ID out of range");
67     }
68     
69     require(msg.sender == orders[oid].owner ||
70 	    admin_address == msg.sender,"Not owner or admin");
71     _;
72   }
73 
74   constructor() {
75     startOrderNum = 0;  //ethereum        
76     //startOrderNum = 10000;  //arbitrum    
77     //startOrderNum = 20000;  //polygon
78 
79     numOrders = startOrderNum;
80     
81     admin_address = msg.sender;
82     refund_percent = 100;
83   }
84 
85   function numOrdersByAddress(address a) public view returns (uint32) {
86     uint32 n = 0;
87     for (uint256 i = startOrderNum; i<numOrders;i++) {
88       if (orders[i].owner == a) {
89 	n++;
90       }
91     }
92     return n;
93   }
94   
95   function orderByAddress(address a,uint32 j) public view returns(uint256) {
96     if (j >= numOrdersByAddress(a)) {
97       revert("Order index out of range");
98     }
99     
100     uint32 n = 0;
101     uint256 oid = 0;
102     
103     for (uint256 i = startOrderNum;i<numOrders;i++) {
104       if (orders[i].owner == a) {
105 	if (j==n) {
106 	  oid = i;
107 	  break;
108 	}
109 	n++;
110       }
111     }
112     return oid;
113   }  
114   
115   function orderDetails(uint256 oid) public view returns (uint32 state, uint32 pid, uint256 boostAmount, uint256 paidAmount, address owner) {
116     require(oid < numOrders,"Order id not in range");
117     state = orders[oid].state;
118     pid = orders[oid].pid;
119     boostAmount = orders[oid].boostAmount;
120     paidAmount = orders[oid].paidAmount;
121     owner = orders[oid].owner;
122 
123     //TODO get place in queue
124   }
125 
126   /* only allow access to addresses holding a minimum
127      number of ERC20 or ERC721 token */
128   function check_elligible(address a) public view returns (bool) {
129     bool flag = true;
130     for (uint256 i = 0;i<16;i++) {
131       if (!accessProfiles[i].enabled) continue;
132       if (accessProfiles[i].econtract.balanceOf(a) >=
133 	  accessProfiles[i].minRequired) {
134 	return true;
135       } else {
136 	flag = false;
137       }
138     }
139     return flag;
140   }
141   
142   function purchase(uint32 pid) public payable returns(uint256) {
143     require(pid < numProducts, "Invalid product id");
144     require(products[pid].supply > 0, "Sold Out");
145     
146     require(!purchasesDisabled,"Purchases disabled");
147     require(msg.value>=products[pid].price, "Must send minimum value to purchase!");
148     if (!check_elligible(msg.sender)) {
149       revert("Not elligible.");
150     }
151 
152     //i
153     //send change if too much was sent
154     if (msg.value > 0) {
155       uint256 diff = msg.value - products[pid].price;
156       if (diff > 0) {
157 	payable(msg.sender).transfer(diff);
158       }
159     }
160     
161     //create an order for address together with 'pid'
162     orders[numOrders].paidAmount = products[pid].price;
163     orders[numOrders].pid = pid;
164     orders[numOrders].owner = msg.sender;
165 
166     if (msg.value > 0) {
167       uint256 diff = msg.value - products[pid].price;
168       if (diff > 0) {
169 	orders[numOrders].boostAmount = diff;
170       }
171     }
172     
173     uint256 oid = numOrders;
174     numOrders++;
175     products[pid].supply--;
176     
177     emit ePurchased(oid);
178     return oid;
179   }
180 
181   function refund(uint32 oid) public payable requireOwnerOrAdmin(oid) {
182     require(orders[oid].state==0, "Order not in refundable state");
183 
184     //sets order state to refunded    
185     orders[oid].state = 3; 
186 
187     // refund 95 percent of initial purchase price
188     // as well as any premium payed for order queue
189     
190     uint256 amount_to_refund = orders[oid].paidAmount;
191     if (msg.sender != admin_address) {
192       // if admin is forcing refund, refund 100% rather than 95%
193       if (refund_percent < 100) {
194 	amount_to_refund /= 100;
195 	amount_to_refund *= refund_percent;
196       }
197     }
198     
199     //keep refund_percent% cancellation fee
200     totalEarned += (orders[oid].paidAmount - amount_to_refund);
201 //  console.log("Keeping %d",totalEarned);
202 
203 //  console.log("Refunding %d",amount_to_refund);    
204     amount_to_refund += orders[oid].boostAmount;
205 
206 //    console.log("Refunding total: %d",amount_to_refund);
207 
208     emit eRefund(oid,amount_to_refund);
209     
210     payable(orders[oid].owner).transfer(amount_to_refund);
211   }
212 
213   function boost(uint32 oid) public payable requireOwner(oid) {
214     require(orders[oid].state==0, "Order must be in pending state");    
215     //store ether in contract for order 'oid', to determine
216     //place in queue
217     orders[oid].boostAmount += msg.value;
218 
219     emit eBoost(oid);
220   }
221 
222   function unboost(uint32 oid, uint256 amount) public payable requireOwner(oid) {
223     require(orders[oid].state==0, "Order must be in pending state");
224     require(amount <= orders[oid].boostAmount,"Limit exceeded");
225     require(amount > 0,"Amount must be more than 0");
226     
227     orders[oid].boostAmount -= amount;
228     payable(msg.sender).transfer(amount); //refund boosted amount
229 
230     emit eBoost(oid);    
231   }
232 
233   //check what address owns orderID  
234   function ownerOf(uint256 oid) public view returns(address) {
235     return orders[oid].owner;
236   }
237 
238   //returns all orders numbers for a particular owner;
239   function ordersByOwner(address a) public view returns (uint256[] memory) {
240     uint256 [] memory q;
241 
242     uint256 num;
243     for (uint256 i = startOrderNum; i<numOrders;i++) {
244       if (orders[i].owner != a) continue;
245       num++;
246     }
247     q = new uint256[](num);
248     
249     uint256 k = 0;
250     for (uint256 i = startOrderNum;i<numOrders;i++) {
251       if (orders[i].owner != a) continue;      
252       q[k] = i;
253       k++;
254     }
255 
256     return q;
257   }
258   
259   //return sorted by boost amount queue of pending orders
260   function queue() public view returns (uint256[] memory) {
261     uint256 [] memory q;
262     
263     uint256 numPending;
264     for (uint256 i = startOrderNum;i<numOrders;i++) {
265       if (orders[i].state != 0) continue;
266       numPending++;
267     }
268     q = new uint256[](numPending);
269     
270     uint256 k = 0;
271     for (uint256 i = startOrderNum;i<numOrders;i++) {
272       if (orders[i].state != 0) continue;
273       q[k] = i;
274       k++;
275     }
276     
277     //sort in place based on boost value
278 
279     if (numPending > 1) {
280       bool flag;    
281       do {
282 	flag = false;
283 	for (uint256 i = 0;i<numPending-1;i++) {
284 	  if (orders[q[i]].boostAmount < orders[q[i+1]].boostAmount) {
285 	    uint256 tmp = q[i];
286 	    q[i] = q[i+1];
287 	    q[i+1] = tmp;
288 	    flag = true;
289 	  }
290 	}
291       } while (flag==true);
292     }
293     
294     return q;
295   }
296   
297   //get order ids and staked amounts for top 2 active queue positions
298   function topQueue() public view returns(uint256 oid1, uint256 oid2, uint256 amount1, uint256 amount2) {
299     uint256 m1 = 0; //largest boost
300     uint256 m2 = 0;    
301     uint256 mi1 = 0; // largest boost index
302     uint256 mi2 = 0;    
303 
304     //if only 1 order, premium paid is 0
305     if (numOrders >= 2) {
306       for (uint256 i = startOrderNum;i<numOrders;i++) {
307 	if (orders[i].state != 0) continue;
308       
309 	if (orders[i].boostAmount > m1) {
310 	  m2 = m1;
311 	  mi2 = mi1;
312 	  m1 = orders[i].boostAmount;
313 	  mi1 = i;
314 	} else if (orders[i].boostAmount > m2) {
315 	  m2 = orders[i].boostAmount;
316 	  mi2 = i;
317 	}
318       }
319     }
320     
321     oid1 = mi1;
322     oid2 = mi2;
323     amount1 = m1;
324     amount2 = m2;
325   }
326 
327   
328   function setAccessProfileEnabled(uint32 oid, bool enabled) public requireAdmin {
329     require(oid < 16,"Index out of range");
330     accessProfiles[oid].enabled = enabled;
331   }
332 
333   function setStoreEnabled(bool enabled) public requireAdmin {
334     purchasesDisabled = !enabled;
335   }
336 
337   function setRefundPercent(uint256 rp) public requireAdmin {
338     refund_percent = rp;
339   }
340 
341   function setAccessProfile(uint32 oid, address a, uint256 minRequired, bool enabled) public requireAdmin {
342     accessProfiles[oid].econtract = ERC20(a);
343     accessProfiles[oid].minRequired = minRequired;
344     accessProfiles[oid].enabled = enabled;
345   }
346 
347   //change an order to in progress, taking payment
348   function setShipped(uint32[] memory oids) public requireAdmin {
349     for (uint i=0;i<oids.length;i++) {
350       uint32 oid = oids[i];
351       if (oid >= numOrders) continue;
352       if(orders[oid].state != 0) continue;
353 
354       //add amount paid plus differential boost amount to earned stack
355       totalEarned += orders[oid].paidAmount;
356       totalEarned += orders[oid].boostAmount;
357 
358       orders[oid].state = 2; //finalize order
359       emit eShipped(oid);
360     }
361   }
362   
363   function setNumProducts(uint32 n) public requireAdmin {
364     numProducts = n;
365   }
366 
367   /* sets details of a product (currently only price is stored on-chain) */
368   function setProduct(uint32 pid,uint256 price,uint256 supply) public requireAdmin {
369     require(pid<numProducts,"Product ID out of range");
370     products[pid].price = price;
371     products[pid].supply = supply;
372   }
373 
374   /* Shop owner can only withdraw from the stack 'totalEarned',
375      which tracks the value of orders that have gone into the 'in progress' state */
376   
377   function withdraw(uint256 amount) public payable requireAdmin {
378     require(amount <= totalEarned,"Earned limit exceeded");
379     require(amount <= address(this).balance,"Insufficient funds to withdraw");
380     totalEarned -= amount;
381     payable(msg.sender).transfer(amount);
382   }
383 
384   //in case of screw up, allow totalEarned to be adjusted,
385   // but only DOWNWARD 
386   function adjustTotalEarned(uint256 t) public requireAdmin {
387     require (t < totalEarned,"Can only adjust down");
388     totalEarned = t;
389   }
390   
391   /* All showopner to make deposits in case of screw up to allow
392      those in queue to refund themselves */
393   
394   function deposit() public payable requireAdmin {
395   }
396   
397 }