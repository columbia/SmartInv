1 pragma solidity ^0.5.7;
2 
3 /**
4  * Copy right (c) Donex UG (haftungsbeschraenkt)
5  * All rights reserved
6  * Version 0.2.1 (BETA)
7  */
8 
9 contract Master {
10 
11     address payable ownerAddress;
12     address constant oracleAddress = 0xE8013bD526100Ebf67ace0E0F21a296D8974f0A4;
13 
14     mapping (uint => bool) public validDueDate;
15 
16 
17     event NewContract (
18         address contractAddress
19     );
20 
21 
22     modifier onlyByOwner () {
23         require(msg.sender ==  ownerAddress);
24         _;
25     }
26 
27 
28     constructor () public {
29         ownerAddress = msg.sender;
30     }
31 
32 
33     /**
34      * @notice Create a contract representing a conditional payment.
35      * @dev The creator address can be used to connect another smart contract to this master.
36      * @param creator Provide the address of the creator of this contract.
37      * @param long Decide if you want to be in the long or short position of your contract.
38      * @param dueDate Set the due date of your contract. Note that the due date needs to match a valid due date.
39      * @param strikePrice Choose a strike price which will be used on the due date for calculation of the payout. Make sure that the format is correct.
40      */
41     function createConditionalPayment
42     (
43         address payable creator,
44         bool long,
45         uint256 dueDate,
46         uint256 strikePrice
47     )
48         payable
49         public
50         returns(address newDerivativeAddress)
51     {
52         require(validDueDate[dueDate]);
53         ConditionalPayment conditionalPayment = (new ConditionalPayment).value(msg.value)
54         (
55             creator,
56             long,
57             dueDate,
58             strikePrice
59         );
60 
61         emit NewContract(address(conditionalPayment));
62 
63         return address(conditionalPayment);
64     }
65 
66     /// @notice This function will be called by every conditional payment contract at settlement and requests the price from the oracle.
67     function settle
68     (
69         uint256 dueDate
70     )
71         public
72         payable
73         returns (uint256)
74     {
75         Oracle o = Oracle(oracleAddress);
76         return o.sendPrice(dueDate);
77     }
78 
79 
80     /**
81      * Owner functions
82      */
83 
84     function setValidDueDate
85     (
86         uint dueDate,
87         bool valid
88     )
89         public
90         onlyByOwner
91     {
92         validDueDate[dueDate] = valid;
93     }
94 
95     function withdrawFees ()
96         public
97         onlyByOwner
98     {
99         msg.sender.transfer(address(this).balance);
100     }
101 
102     function balanceOfFactory ()
103         public
104         view
105         returns (uint256)
106     {
107         return (address(this).balance);
108     }
109 
110 }
111 
112 
113 
114 /**
115  * @title This contract serves as a conditional payment based on the spot price of an asset on the due date compared to a strike price.
116  * @notice Use the Master to create this contract.
117  */
118 contract ConditionalPayment {
119 
120     address payable public masterAddress;
121 
122     address constant public withdrawFunctionsAddress = 0x0b564F0aD4dcb35Cd43eff2f26Bf96B670eaBF5e;
123 
124     address payable public creator;
125 
126     uint256 public dueDate;
127     uint256 public strikePrice;
128     bool public creatorLong;
129 
130     uint8 public countCounterparties;
131 
132     bool public isSettled;
133     uint256 public settlementPrice;
134 
135     uint256 public totalStakeCounterparties;
136 
137     mapping(address => uint256) public stakes;
138 
139 
140     event ContractAltered ();
141 
142     event UpdatedParticipant
143     (
144         address indexed participant,
145         uint256 stake
146     );
147 
148 
149     modifier onlyByCreator()
150     {
151         require(msg.sender ==  creator);
152         _;
153     }
154 
155     modifier onlyIncremental(uint amount)
156     {
157         require(amount % (0.1 ether) == 0);
158         _;
159     }
160 
161     modifier nonZeroMsgValue()
162     {
163         require(msg.value > 0);
164         _;
165     }
166 
167     modifier dueDateInFuture()
168     {
169         _;
170         require(now < dueDate);
171     }
172 
173     modifier nonZeroStrikePrice(uint256 newStrikePrice)
174     {
175         require(newStrikePrice > 0);
176         _;
177     }
178 
179     modifier emitsContractAlteredEvent()
180     {
181         _;
182         emit ContractAltered();
183     }
184 
185     modifier emitsUpdatedParticipantEvent(address participant)
186     {
187         _;
188         emit UpdatedParticipant(participant,stakes[participant]);
189     }
190 
191 
192     constructor
193     (
194         address payable _creator,
195         bool _long,
196         uint256 _dueDate,
197         uint256 _strikePrice
198     )
199         payable
200         public
201         onlyIncremental(msg.value)
202         nonZeroStrikePrice(_strikePrice)
203         nonZeroMsgValue
204         dueDateInFuture
205         emitsUpdatedParticipantEvent(_creator)
206     {
207         masterAddress = msg.sender;
208 
209         creator = _creator;
210         creatorLong = _long;
211         stakes[creator] = msg.value;
212 
213         strikePrice = _strikePrice;
214         dueDate = _dueDate;
215     }
216 
217 
218     /// @notice The strike price can be changed as long as no counterpary has been found. Use this in order to make the conditional payment more attractive to be entered.
219     function changeStrikePrice (uint256 newStrikePrice)
220         public
221         nonZeroStrikePrice(newStrikePrice)
222         onlyByCreator
223         emitsContractAlteredEvent
224     {
225         require(countCounterparties == 0);
226 
227         strikePrice = newStrikePrice;
228     }
229 
230 
231     /// @notice As a creator you can reduce your stake to the total stake of the counterparties at minimum.
232     function reduceStake (uint256 amount)
233         public
234         onlyByCreator
235         onlyIncremental(amount)
236         emitsContractAlteredEvent
237         emitsUpdatedParticipantEvent(creator)
238     {
239         uint256 maxWithdrawAmount = stakes[msg.sender] - totalStakeCounterparties;
240         if(amount < maxWithdrawAmount)
241         {
242             stakes[msg.sender] -= amount;
243             msg.sender.transfer(amount);
244         }
245         else
246         {
247             stakes[msg.sender] -= maxWithdrawAmount;
248             msg.sender.transfer(maxWithdrawAmount);
249         }
250     }
251 
252 
253     /// @notice As a creator you can add stake which allows more counterparties.
254     function addStake ()
255         public
256         payable
257         onlyByCreator
258         onlyIncremental(msg.value)
259         emitsContractAlteredEvent
260         emitsUpdatedParticipantEvent(creator)
261     {
262         stakes[msg.sender] += msg.value;
263     }
264 
265 
266     /**
267      * @notice Sign the contract. Note you will be subjected to fees at the time of settlement.
268      * @param requestedStrikePrice Since the strike price could have potentially been changed by the creator during your transaction, make sure to enter the strike price you saw before making this transaction.
269      */
270     function signContract (uint256 requestedStrikePrice)
271         payable
272         public
273         onlyIncremental(msg.value)
274         nonZeroMsgValue
275         dueDateInFuture
276         emitsContractAlteredEvent
277         emitsUpdatedParticipantEvent(msg.sender)
278     {
279         require(msg.sender != creator);
280         require(requestedStrikePrice == strikePrice);
281         totalStakeCounterparties += msg.value;
282         require(totalStakeCounterparties <= stakes[creator]);
283 
284         if (stakes[msg.sender] == 0)
285         {
286             countCounterparties += 1;
287         }
288         stakes[msg.sender] += msg.value;
289     }
290 
291 
292     /// @notice Withdraw your stake as soon as the due date is reached and the price is available from the oracle.
293     function withdraw ()
294         public
295         emitsContractAlteredEvent
296     {
297         require(now > dueDate);
298         require(countCounterparties > 0);
299 
300         if (isSettled == false)
301         {
302             Master m = Master(masterAddress);
303             settlementPrice = m.settle.value(totalStakeCounterparties/200)(dueDate);
304             isSettled = true;
305         }
306 
307         uint256 stakeMemory = stakes[msg.sender];
308         Withdraw w = Withdraw(withdrawFunctionsAddress);
309         if (msg.sender == creator)
310         {
311             stakes[msg.sender] = 0;
312             msg.sender.transfer(w.amountCreator(
313                 creatorLong,
314                 stakeMemory,
315                 settlementPrice,
316                 strikePrice,
317                 totalStakeCounterparties));
318         }
319         if (stakes[msg.sender] != 0)
320         {
321             stakes[msg.sender] = 0;
322             msg.sender.transfer(w.amountCounterparty(
323                 creatorLong,
324                 stakeMemory,
325                 settlementPrice,
326                 strikePrice));
327         }
328     }
329 
330 
331     /// @notice In case anything went wrong, you are able to withdraw your stake 90 days after the due date.
332     function unsettledWithdraw ()
333         public
334         emitsContractAlteredEvent
335     {
336         require (now > dueDate + 90 days);
337         require (isSettled == false);
338 
339         uint256 stakeMemory = stakes[msg.sender];
340         stakes[msg.sender] = 0;
341         msg.sender.transfer(stakeMemory);
342     }
343 
344 }
345 
346 
347 
348 
349 interface Oracle {
350 
351     function sendPrice (uint256 dueDate)
352         external
353         view
354         returns (uint256);
355 
356 }
357 
358 
359 interface Withdraw {
360 
361     function amountCreator
362     (
363         bool makerLong,
364         uint256 stakeMemory,
365         uint256 settlementPrice,
366         uint256 strikePrice,
367         uint256 totalStakeAllTakers
368     )
369         external
370         pure
371         returns (uint256);
372 
373 
374     function amountCounterparty
375     (
376         bool makerLong,
377         uint256 stakeMemory,
378         uint256 settlementPrice,
379         uint256 strikePrice
380     )
381         external
382         pure
383         returns (uint256);
384 
385 }