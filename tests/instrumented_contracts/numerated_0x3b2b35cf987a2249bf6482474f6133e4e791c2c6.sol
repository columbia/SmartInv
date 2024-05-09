1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal pure returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal pure returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal pure returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract Ownable {
29   address public owner;
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) constant public returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) tokenBalances;
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(tokenBalances[msg.sender]>=_value);
87     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
88     tokenBalances[_to] = tokenBalances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) constant public returns (uint256 balance) {
99     return tokenBalances[_owner];
100   }
101 
102 }
103 contract ERD is BasicToken,Ownable {
104 
105    using SafeMath for uint256;
106    
107    string public constant name = "ERD";
108    string public constant symbol = "ERD";
109    uint256 public constant decimals = 18;  
110    address public ethStore = 0xDcbFE8d41D4559b3EAD3179fa7Bb3ad77EaDa564;
111    uint256 public REMAINING_SUPPLY = 100000000000  * (10 ** uint256(decimals));
112    event Debug(string message, address addr, uint256 number);
113    event Message(string message);
114     string buyMessage;
115   
116   address wallet;
117    /**
118    * @dev Contructor that gives msg.sender all of existing tokens.
119    */
120     function ERD(address _wallet) public {
121         owner = msg.sender;
122         totalSupply = REMAINING_SUPPLY;
123         wallet = _wallet;
124         tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts
125     }
126     
127      function mint(address from, address to, uint256 tokenAmount) public onlyOwner {
128       require(tokenBalances[from] >= tokenAmount);               // checks if it has enough to sell
129       tokenBalances[to] = tokenBalances[to].add(tokenAmount);                  // adds the amount to buyer's balance
130       tokenBalances[from] = tokenBalances[from].sub(tokenAmount);                        // subtracts amount from seller's balance
131       REMAINING_SUPPLY = tokenBalances[wallet];
132       Transfer(from, to, tokenAmount); 
133     }
134     
135     function getTokenBalance(address user) public view returns (uint256 balance) {
136         balance = tokenBalances[user]; // show token balance in full tokens not part
137         return balance;
138     }
139 }
140 contract ERDTokenTransaction {
141     using SafeMath for uint256;
142     struct Transaction {
143         //uint entityId;
144         address entityId;
145         uint transactionId;
146         uint transactionType;       //0 for debit, 1 for credit
147         uint amount;
148         string transactionDate;
149         uint256 transactionTimeStamp;
150         string currency;
151         string accountingPeriod;
152     }
153     
154     struct AccountChart {
155         //uint entityId;
156         address entityId;
157         uint accountsPayable;
158         uint accountsReceivable;
159         uint sales;
160         uint isEntityInitialized;
161     }
162     
163     address[] entities;
164     uint[] allTransactionIdsList;
165     
166     uint[] allTransactionIdsAgainstAnEntityList;
167     mapping(address=>uint[])  entityTransactionsIds;
168     mapping(address=>Transaction[])  entityTransactions;
169     mapping(address=>AccountChart)  entityAccountChart;
170     mapping(address=>bool) freezedTokens;
171     address wallet;
172     ERD public token;   
173     uint256 transactionIdSequence = 0;
174     // how many token units a buyer gets per wei
175     uint256 public ratePerWei = 100;
176     uint256 public perTransactionRate = 1 * 10 ** 14;   //0.0001 tokens
177     
178     /**
179    * event for token purchase logging
180    * @param purchaser who paid for the tokens
181    * @param beneficiary who got the tokens
182    * @param value weis paid for purchase
183    * @param amount amount of tokens purchased
184    */
185   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
186   event EmitAccountChartDetails (address entityId, uint accountsPayable,uint accountsReceivable,uint sales);
187   event EmitTransactionDetails (address entityId, uint transactionId, uint transactionType,uint amount,string transactionDate,string currency, string accountingPeriod);
188   event EmitTransactionIds (uint[] ids);
189   event EmitEntityIds (address[] ids);
190     //Objects for use within program
191 
192     Transaction transObj;
193     AccountChart AccountChartObj;
194     
195     function ERDTokenTransaction(address _wallet) public {
196         wallet = _wallet;
197         token = createTokenContract(wallet);
198         
199         //add owner entity 
200          entities.push(0);
201         //initialize account chart 
202         AccountChartObj = AccountChart({
203             entityId : wallet,
204             accountsPayable: 0,
205             accountsReceivable: 0,
206             sales:0,
207             isEntityInitialized:1 
208         });
209         entityAccountChart[wallet] = AccountChartObj;
210     }
211     
212     function createTokenContract(address wall) internal returns (ERD) {
213     return new ERD(wall);
214    }
215     
216     // fallback function can be used to buy tokens
217     function () public payable {
218      buyTokens(msg.sender);
219     }
220     
221     // low level token purchase function
222    // Minimum purchase can be of 1 ETH
223   
224    function buyTokens(address beneficiary) public payable {
225     require(beneficiary != 0x0);
226 
227     uint256 weiAmount = msg.value;
228 
229     // calculate token amount to be given
230     uint256 tokens = weiAmount.mul(ratePerWei);
231    
232     token.mint(wallet, beneficiary, tokens); 
233     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
234     forwardFunds();
235   }
236    // send ether to the fund collection wallet
237   // override to create custom fund forwarding mechanisms
238   function forwardFunds() internal {
239     wallet.transfer(msg.value);
240   }
241     //Add transaction against entity
242     function AddTransactionAgainstExistingEntity(address entId,uint transType,uint amt,string curr, string accPr) public 
243     {
244         require (entityAccountChart[entId].isEntityInitialized == 1);
245         transactionIdSequence = transactionIdSequence + 1;
246          transObj = Transaction({
247             entityId : entId,
248             transactionId : transactionIdSequence,
249             transactionType: transType,
250             amount: amt,
251             transactionDate : "NA",
252             transactionTimeStamp: now,
253             currency : curr,
254             accountingPeriod : accPr
255           });
256           
257           entityTransactions[entId].push(transObj);
258           allTransactionIdsList.push(transactionIdSequence);
259           entityTransactionsIds[entId].push(transactionIdSequence);
260           MakeTokenCreditAndDebitEntry(msg.sender);
261     }
262     function MakeTokenCreditAndDebitEntry(address entId) internal {
263     
264           transactionIdSequence = transactionIdSequence + 1;
265          //debit entry
266          transObj = Transaction({
267             entityId : wallet,   //owner entity
268             transactionId : transactionIdSequence,
269             transactionType: 0, //debit type
270             amount: perTransactionRate,
271             transactionDate : "NA",
272             transactionTimeStamp: now,
273             currency : "ERD",
274             accountingPeriod : ""
275           });
276           entityTransactions[entId].push(transObj);
277           allTransactionIdsList.push(transactionIdSequence);
278           entityTransactionsIds[entId].push(transactionIdSequence);
279           
280           
281           transactionIdSequence = transactionIdSequence + 1;
282          //credit entry
283          transObj = Transaction({
284             entityId : entId,
285             transactionId : transactionIdSequence,
286             transactionType: 1,     //credit
287             amount: perTransactionRate,
288             transactionDate : "NA",
289             transactionTimeStamp: now,
290             currency : "ERD",
291             accountingPeriod : ""
292           });
293           
294           entityTransactions[entId].push(transObj);
295           allTransactionIdsList.push(transactionIdSequence);
296           entityTransactionsIds[entId].push(transactionIdSequence);
297     }
298     //add accout chart against entity
299     function updateAccountChartAgainstExistingEntity(address entId, uint accPayable, uint accReceivable,uint sale) public
300     {
301         require(token.getTokenBalance(msg.sender)>=perTransactionRate);
302         require(freezedTokens[entId] == false);
303         require (entityAccountChart[entId].isEntityInitialized == 1);
304         token.mint(msg.sender, wallet, perTransactionRate);
305         require(freezedTokens[entId] == false);
306     
307        
308         AccountChartObj = AccountChart({
309             entityId : entId,
310             accountsPayable: accPayable,
311             accountsReceivable: accReceivable,
312             sales:sale,
313             isEntityInitialized:1
314         });
315         
316         entityAccountChart[entId] = AccountChartObj;
317         
318          MakeTokenCreditAndDebitEntry(msg.sender);
319     }
320     function addEntity(address entId) public
321     {
322         require(token.getTokenBalance(msg.sender)>=perTransactionRate);
323         require(freezedTokens[entId] == false);
324         require (entityAccountChart[entId].isEntityInitialized == 0);
325         token.mint(msg.sender, wallet, perTransactionRate);
326        
327         entities.push(entId);
328         //initialize account chart 
329         AccountChartObj = AccountChart({
330             entityId : entId,
331             accountsPayable: 0,
332             accountsReceivable: 0,
333             sales:0,
334             isEntityInitialized:1 
335         });
336         entityAccountChart[entId] = AccountChartObj;
337         MakeTokenCreditAndDebitEntry(msg.sender);
338     }
339     
340     function getAllEntityIds() public returns (address[] entityList) 
341     {
342         require(token.getTokenBalance(msg.sender)>=perTransactionRate);
343         token.mint(msg.sender, wallet, perTransactionRate);
344         require(freezedTokens[msg.sender] == false);
345         MakeTokenCreditAndDebitEntry(msg.sender);
346         EmitEntityIds(entities);
347         return entities;
348     }
349     
350     function getAllTransactionIdsByEntityId(address entId) public returns (uint[] transactionIds)
351     {
352         require(token.getTokenBalance(msg.sender)>=perTransactionRate);
353         require(freezedTokens[entId] == false);
354         token.mint(msg.sender, wallet, perTransactionRate);
355         MakeTokenCreditAndDebitEntry(msg.sender);
356         EmitTransactionIds(entityTransactionsIds[entId]);
357         return entityTransactionsIds[entId];
358     }
359     
360     function getAllTransactionIds() public returns (uint[] transactionIds)
361     {
362         require(token.getTokenBalance(msg.sender)>=perTransactionRate);
363         require(freezedTokens[msg.sender] == false);
364         token.mint(msg.sender,wallet,perTransactionRate);
365         MakeTokenCreditAndDebitEntry(msg.sender);
366         EmitTransactionIds(allTransactionIdsList);
367         return allTransactionIdsList;
368     }
369     
370     function getTransactionByTransactionId(uint transId) public 
371     {
372         require(token.getTokenBalance(msg.sender)>=perTransactionRate);
373         require(freezedTokens[msg.sender] == false);
374         token.mint(msg.sender, wallet, perTransactionRate);
375         MakeTokenCreditAndDebitEntry(msg.sender);
376         for(uint i=0; i<entities.length;i++)
377         {
378             //loop through all the enitities , gets each entity by entity[i]
379             Transaction[] storage transactionsListByEntityId = entityTransactions[entities[i]];
380             for (uint j=0;j<transactionsListByEntityId.length;j++)
381             {
382                 //loop through all the transactions list against each entity
383                 // checks if transaction id is matched returns the transaction object
384                 if(transactionsListByEntityId[j].transactionId==transId)
385                 {
386                     EmitTransactionDetails (transactionsListByEntityId[j].entityId,transactionsListByEntityId[j].transactionId,
387                             transactionsListByEntityId[j].transactionType,transactionsListByEntityId[j].amount,
388                             transactionsListByEntityId[j].transactionDate,transactionsListByEntityId[j].currency,
389                             transactionsListByEntityId[j].accountingPeriod);
390                 }
391                
392             }
393         }
394         EmitTransactionDetails (0,0,0,0,"NA","NA","NA");
395     }
396     
397     function getTransactionByTransactionAndEntityId(address entId, uint transId) public 
398     {
399         require(token.getTokenBalance(msg.sender)>=perTransactionRate);
400         require(freezedTokens[msg.sender] == false);
401         token.mint(msg.sender, wallet, perTransactionRate);
402         MakeTokenCreditAndDebitEntry(msg.sender);
403         // gets each entity by entity[entId]
404         Transaction[] storage transactionsListByEntityId = entityTransactions[entId];
405         for (uint j=0;j<transactionsListByEntityId.length;j++)
406         {
407             //loop through all the transactions list against each entity
408             // checks if transaction id is matched returns the transaction object
409             if(transactionsListByEntityId[j].transactionId==transId)
410             {
411                 EmitTransactionDetails (transactionsListByEntityId[j].entityId,transactionsListByEntityId[j].transactionId,
412                             transactionsListByEntityId[j].transactionType,transactionsListByEntityId[j].amount,
413                             transactionsListByEntityId[j].transactionDate,transactionsListByEntityId[j].currency,
414                             transactionsListByEntityId[j].accountingPeriod);
415             }
416         }
417         EmitTransactionDetails (0,0,0,0,"NA","NA","NA");
418     }
419     
420     function getAccountChartDetailsByEntityId(address entId) public
421     {
422         require(token.getTokenBalance(msg.sender)>=perTransactionRate);
423         require(freezedTokens[msg.sender] == false);
424         token.mint(msg.sender, wallet, perTransactionRate);
425         MakeTokenCreditAndDebitEntry(msg.sender);
426         EmitAccountChartDetails (entityAccountChart[entId].entityId,entityAccountChart[entId].accountsPayable,
427                 entityAccountChart[entId].accountsReceivable,entityAccountChart[entId].sales);
428     }
429      function showMyTokenBalance() public constant returns (uint256 tokenBalance) {
430         tokenBalance = token.getTokenBalance(msg.sender);
431         return tokenBalance;
432     }
433     
434      function freezeTokensOfOneUser(address entityId) public {
435         require(msg.sender == wallet);
436         freezedTokens[entityId] = true;
437     }
438     
439     function UnfreezeTokensOfOneUser(address entityId) public {
440         require(msg.sender == wallet);
441         freezedTokens[entityId] = false;
442     }
443 }