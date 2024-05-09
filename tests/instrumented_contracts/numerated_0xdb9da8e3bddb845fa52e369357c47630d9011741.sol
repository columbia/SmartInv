1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  * @dev Based on: OpenZeppelin
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param _newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address _newOwner) public onlyOwner {
42     require(_newOwner != address(0));
43     emit OwnershipTransferred(owner, _newOwner);
44     owner = _newOwner;
45   }
46 
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 {
54   function totalSupply() public view returns (uint256);
55 
56   function balanceOf(address _who) public view returns (uint256);
57 
58   function allowance(address _owner, address _spender)
59     public view returns (uint256);
60 
61   function transfer(address _to, uint256 _value) public returns (bool);
62 
63   function approve(address _spender, uint256 _value)
64     public returns (bool);
65 
66   function transferFrom(address _from, address _to, uint256 _value)
67     public returns (bool);
68 
69   event Transfer(
70     address indexed from,
71     address indexed to,
72     uint256 value
73   );
74 
75   event Approval(
76     address indexed owner,
77     address indexed spender,
78     uint256 value
79   );
80 }
81 
82 
83 
84 
85 
86 
87 /**
88  * @title TridentDistribution
89  * @dev Implementation of the TridentDistribution smart contract.
90  */
91 contract TridentDistribution is Ownable {
92 
93   // Stores the Trident smart contract
94   ERC20 public trident;
95 
96   // Struct that represents a transfer order
97   struct Order {
98     uint256 amount;         // amount of tokens to transfer
99     address account;        // account to transfer amount to
100     string metadata;        // arbitrary metadata
101   }
102 
103   // Array of all current transfer orders
104   Order[] orders;
105 
106   // Accounts allowed to place orders
107   address[] orderDelegates;
108 
109   // Accounts allowed to approve orders
110   address[] approvalDelegates;
111 
112   // Amount of ETH sent with each order executed
113   uint public complementaryEthPerOrder;
114 
115 
116   // Event emitted when an account has been approved as an order delegate
117   event ApproveOrderDelegate(
118       address indexed orderDelegate
119     );
120   // Event emitted when an account has been revoked from being an order delegate
121   event RevokeOrderDelegate(
122       address indexed orderDelegate
123     );
124 
125   // Event emitted when an account has been approved as an approval delegate
126   event ApproveApprovalDelegate(
127       address indexed approvalDelegate
128     );
129   // Event emitted when an account has been revoked from being an approval delegate
130   event RevokeApprovalDelegate(
131       address indexed approvalDelegate
132     );
133 
134   // Event emitted when an order has been placed
135   event OrderPlaced(
136     uint indexed orderIndex
137     );
138 
139   // Event emitted when an order has been approved and executed
140   event OrderApproved(
141     uint indexed orderIndex
142     );
143 
144   // Event emitted when an order has been revoked
145   event OrderRevoked(
146     uint indexed orderIndex
147     );
148 
149   // Event emitted when the entire orders batch is approved and executed
150   event AllOrdersApproved();
151 
152   // Event emitted when complementaryEthPerOrder has been set
153   event ComplementaryEthPerOrderSet();
154 
155 
156 
157   constructor(ERC20 _tridentSmartContract) public {
158       trident = _tridentSmartContract;
159   }
160 
161   /**
162    * @dev Fallback function to allow contract to receive ETH via 'send'.
163    */
164   function () public payable {
165   }
166 
167 
168   /**
169    * @dev Throws if called by any account other than an owner or an order delegate.
170    */
171   modifier onlyOwnerOrOrderDelegate() {
172     bool allowedToPlaceOrders = false;
173 
174     if(msg.sender==owner) {
175       allowedToPlaceOrders = true;
176     }
177     else {
178       for(uint i=0; i<orderDelegates.length; i++) {
179         if(orderDelegates[i]==msg.sender) {
180           allowedToPlaceOrders = true;
181           break;
182         }
183       }
184     }
185 
186     require(allowedToPlaceOrders==true);
187     _;
188   }
189 
190   /**
191    * @dev Throws if called by any account other than an owner or an approval delegate.
192    */
193   modifier onlyOwnerOrApprovalDelegate() {
194     bool allowedToApproveOrders = false;
195 
196     if(msg.sender==owner) {
197       allowedToApproveOrders = true;
198     }
199     else {
200       for(uint i=0; i<approvalDelegates.length; i++) {
201         if(approvalDelegates[i]==msg.sender) {
202           allowedToApproveOrders = true;
203           break;
204         }
205       }
206     }
207 
208     require(allowedToApproveOrders==true);
209     _;
210   }
211 
212 
213   /**
214    * @dev Return the array of order delegates.
215    */
216   function getOrderDelegates() external view returns (address[]) {
217     return orderDelegates;
218   }
219 
220   /**
221    * @dev Return the array of burn delegates.
222    */
223   function getApprovalDelegates() external view returns (address[]) {
224     return approvalDelegates;
225   }
226 
227   /**
228    * @dev Give an account permission to place orders.
229    * @param _orderDelegate The account to be approved.
230    */
231   function approveOrderDelegate(address _orderDelegate) onlyOwner external returns (bool) {
232     bool delegateFound = false;
233     for(uint i=0; i<orderDelegates.length; i++) {
234       if(orderDelegates[i]==_orderDelegate) {
235         delegateFound = true;
236         break;
237       }
238     }
239 
240     if(!delegateFound) {
241       orderDelegates.push(_orderDelegate);
242     }
243 
244     emit ApproveOrderDelegate(_orderDelegate);
245     return true;
246   }
247 
248   /**
249    * @dev Revoke permission to place orders from an order delegate.
250    * @param _orderDelegate The account to be revoked.
251    */
252   function revokeOrderDelegate(address _orderDelegate) onlyOwner external returns (bool) {
253     uint length = orderDelegates.length;
254     require(length > 0);
255 
256     address lastDelegate = orderDelegates[length-1];
257     if(_orderDelegate == lastDelegate) {
258       delete orderDelegates[length-1];
259       orderDelegates.length--;
260     }
261     else {
262       // Game plan: find the delegate, replace it with the very last item in the array, then delete the last item
263       for(uint i=0; i<length; i++) {
264         if(orderDelegates[i]==_orderDelegate) {
265           orderDelegates[i] = lastDelegate;
266           delete orderDelegates[length-1];
267           orderDelegates.length--;
268           break;
269         }
270       }
271     }
272 
273     emit RevokeOrderDelegate(_orderDelegate);
274     return true;
275   }
276 
277   /**
278    * @dev Give an account permission to approve orders.
279    * @param _approvalDelegate The account to be approved.
280    */
281   function approveApprovalDelegate(address _approvalDelegate) onlyOwner external returns (bool) {
282     bool delegateFound = false;
283     for(uint i=0; i<approvalDelegates.length; i++) {
284       if(approvalDelegates[i]==_approvalDelegate) {
285         delegateFound = true;
286         break;
287       }
288     }
289 
290     if(!delegateFound) {
291       approvalDelegates.push(_approvalDelegate);
292     }
293 
294     emit ApproveApprovalDelegate(_approvalDelegate);
295     return true;
296   }
297 
298   /**
299    * @dev Revoke permission to approve orders from an approval delegate.
300    * @param _approvalDelegate The account to be revoked.
301    */
302   function revokeApprovalDelegate(address _approvalDelegate) onlyOwner external returns (bool) {
303     uint length = approvalDelegates.length;
304     require(length > 0);
305 
306     address lastDelegate = approvalDelegates[length-1];
307     if(_approvalDelegate == lastDelegate) {
308       delete approvalDelegates[length-1];
309       approvalDelegates.length--;
310     }
311     else {
312       // Game plan: find the delegate, replace it with the very last item in the array, then delete the last item
313       for(uint i=0; i<length; i++) {
314         if(approvalDelegates[i]==_approvalDelegate) {
315           approvalDelegates[i] = lastDelegate;
316           delete approvalDelegates[length-1];
317           approvalDelegates.length--;
318           break;
319         }
320       }
321     }
322 
323     emit RevokeApprovalDelegate(_approvalDelegate);
324     return true;
325   }
326 
327 
328   /**
329    * @dev Internal function to delete an order at the given index from the orders array.
330    * @param _orderIndex The index of the order to be removed.
331    */
332   function _deleteOrder(uint _orderIndex) internal {
333     require(orders.length > _orderIndex);
334 
335     uint lastIndex = orders.length-1;
336     if(_orderIndex != lastIndex) {
337       // Replace the order to be deleted with the very last item in the array
338       orders[_orderIndex] = orders[lastIndex];
339     }
340     delete orders[lastIndex];
341     orders.length--;
342   }
343 
344   /**
345    * @dev Internal function to execute an order at the given index.
346    * @param _orderIndex The index of the order to be executed.
347    */
348   function _executeOrder(uint _orderIndex) internal {
349     require(orders.length > _orderIndex);
350     require(complementaryEthPerOrder <= address(this).balance);
351 
352     Order memory order = orders[_orderIndex];
353     _deleteOrder(_orderIndex);
354 
355     trident.transfer(order.account, order.amount);
356 
357     // Transfer the complementary ETH
358     address(order.account).transfer(complementaryEthPerOrder);
359   }
360 
361   /**
362    * @dev Function to place an order.
363    * @param _amount The amount of tokens to transfer.
364    * @param _account The account to transfer the tokens to.
365    * @param _metadata Arbitrary metadata.
366    * @return A boolean that indicates if the operation was successful.
367    */
368   function placeOrder(uint256 _amount, address _account, string _metadata) onlyOwnerOrOrderDelegate external returns (bool) {
369     orders.push(Order({amount: _amount, account: _account, metadata: _metadata}));
370 
371     emit OrderPlaced(orders.length-1);
372 
373     return true;
374   }
375 
376   /**
377    * @dev Return the number of orders.
378    */
379   function getOrdersCount() external view returns (uint) {
380     return orders.length;
381   }
382 
383   /**
384    * @dev Return the number of orders.
385    */
386   function getOrdersTotalAmount() external view returns (uint) {
387     uint total = 0;
388     for(uint i=0; i<orders.length; i++) {
389         Order memory order = orders[i];
390         total += order.amount;
391     }
392 
393     return total;
394   }
395 
396   /**
397    * @dev Return the order at the given index.
398    */
399   function getOrderAtIndex(uint _orderIndex) external view returns (uint256 amount, address account, string metadata) {
400     Order memory order = orders[_orderIndex];
401     return (order.amount, order.account, order.metadata);
402   }
403 
404   /**
405    * @dev Function to revoke an order at the given index.
406    * @param _orderIndex The index of the order to be revoked.
407    * @return A boolean that indicates if the operation was successful.
408    */
409   function revokeOrder(uint _orderIndex) onlyOwnerOrApprovalDelegate external returns (bool) {
410     _deleteOrder(_orderIndex);
411 
412     emit OrderRevoked(_orderIndex);
413 
414     return true;
415   }
416 
417   /**
418    * @dev Function to approve an order at the given index.
419    * @param _orderIndex The index of the order to be approved.
420    * @return A boolean that indicates if the operation was successful.
421    */
422   function approveOrder(uint _orderIndex) onlyOwnerOrApprovalDelegate external returns (bool) {
423     _executeOrder(_orderIndex);
424 
425     emit OrderApproved(_orderIndex);
426 
427     return true;
428   }
429 
430   /**
431    * @dev Function to approve all orders in the orders array.
432    * @return A boolean that indicates if the operation was successful.
433    */
434   function approveAllOrders() onlyOwnerOrApprovalDelegate external returns (bool) {
435     uint orderCount = orders.length;
436     uint totalComplementaryEth = complementaryEthPerOrder * orderCount;
437     require(totalComplementaryEth <= address(this).balance);
438 
439     for(uint i=0; i<orderCount; i++) {
440         Order memory order = orders[i];
441         trident.transfer(order.account, order.amount);
442 
443         // Transfer the complementary ETH
444         address(order.account).transfer(complementaryEthPerOrder);
445     }
446 
447     // Dispose of all approved orders
448     delete orders;
449 
450 
451     emit AllOrdersApproved();
452 
453     return true;
454   }
455 
456 
457 
458   /**
459    * @dev Function to set the complementary eth sent with each order executed.
460    * @param _complementaryEthPerOrder The index of the order to be approved.
461    * @return A boolean that indicates if the operation was successful.
462    */
463   function setComplementaryEthPerOrder(uint _complementaryEthPerOrder) onlyOwner external returns (bool) {
464     complementaryEthPerOrder = _complementaryEthPerOrder;
465 
466     emit ComplementaryEthPerOrderSet();
467 
468     return true;
469   }
470 
471 
472   /**
473    * @dev Function withdraws all ETH from the smart contract.
474    * @return A boolean that indicates if the operation was successful.
475    */
476   function withdrawAllEth() onlyOwner external returns (bool) {
477     uint ethBalance = address(this).balance;
478     require(ethBalance > 0);
479 
480     owner.transfer(ethBalance);
481 
482     return true;
483   }
484 
485 
486   /**
487    * @dev Function withdraws all Trident from the smart contract.
488    * @return A boolean that indicates if the operation was successful.
489    */
490   function withdrawAllTrident() onlyOwner external returns (bool) {
491     uint tridentBalance = trident.balanceOf(address(this));
492     require(tridentBalance > 0);
493 
494     return trident.transfer(owner, tridentBalance);
495   }
496 
497 }