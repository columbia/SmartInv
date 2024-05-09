1 pragma solidity ^0.4.25;
2 
3 contract token {
4     function transfer(address receiver, uint256 amount) public;
5     function balanceOf(address _owner) public pure returns (uint256 balance);
6     function burnFrom(address from, uint256 value) public;
7 }
8 
9 
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34   
35 }
36 
37 
38 /**
39  * To buy ADT user must be Whitelisted
40  * Add user address and value to Whitelist
41  * Remove user address from Whitelist
42  * Check if User is Whitelisted
43  * Check if User have equal or greater value than Whitelisted
44  */
45  
46 library Whitelist {
47     
48     struct List {
49         mapping(address => bool) registry;
50         mapping(address => uint256) amount;
51     }
52 
53     function addUserWithValue(List storage list, address _addr, uint256 _value)
54         internal
55     {
56         list.registry[_addr] = true;
57         list.amount[_addr] = _value;
58     }
59     
60     function add(List storage list, address _addr)
61         internal
62     {
63         list.registry[_addr] = true;
64     }
65 
66     function remove(List storage list, address _addr)
67         internal
68     {
69         list.registry[_addr] = false;
70         list.amount[_addr] = 0;
71     }
72 
73     function check(List storage list, address _addr)
74         view
75         internal
76         returns (bool)
77     {
78         return list.registry[_addr];
79     }
80 
81     function checkValue(List storage list, address _addr, uint256 _value)
82         view
83         internal
84         returns (bool)
85     {
86         /** 
87          * divided by  10^18 because ether decimal is 18
88          * and conversion to ether to uint256 is carried out 
89         */
90          
91         return list.amount[_addr] <= _value;
92     }
93 }
94 
95 
96 contract owned {
97     address public owner;
98 
99     constructor() public {
100         owner = 0x91520dc19a9e103a849076a9dd860604ff7a6282;
101     }
102 
103     modifier onlyOwner {
104         require(msg.sender == owner);
105         _;
106     }
107 
108     function transferOwnership(address newOwner) onlyOwner public {
109         owner = newOwner;
110     }
111 }
112 
113 
114 /**
115  * Contract to whitelist User for buying token
116  */
117 contract Whitelisted is owned {
118 
119     Whitelist.List private _list;
120     uint256 decimals = 100000000000000;
121     
122     modifier onlyWhitelisted() {
123         require(Whitelist.check(_list, msg.sender) == true);
124         _;
125     }
126 
127     event AddressAdded(address _addr);
128     event AddressRemoved(address _addr);
129     event AddressReset(address _addr);
130     
131     /**
132      * Add User to Whitelist with ether amount
133      * @param _address User Wallet address
134      * @param amount The amount of ether user Whitelisted
135      */
136     function addWhiteListAddress(address _address, uint256 amount)
137     public {
138         
139         require(!isAddressWhiteListed(_address));
140         
141         uint256 val = SafeMath.mul(amount, decimals);
142         Whitelist.addUserWithValue(_list, _address, val);
143         
144         emit AddressAdded(_address);
145     }
146     
147     /**
148      * Set User's Whitelisted ether amount to 0 so that 
149      * during second buy transaction user won't need to 
150      * validate for Whitelisted amount
151      */
152     function resetUserWhiteListAmount()
153     internal {
154         
155         Whitelist.addUserWithValue(_list, msg.sender, 0);
156         emit AddressReset(msg.sender);
157     }
158 
159 
160     /**
161      * Disable User from Whitelist so user can't buy token
162      * @param _addr User Wallet address
163      */
164     function disableWhitelistAddress(address _addr)
165     public onlyOwner {
166         
167         Whitelist.remove(_list, _addr);
168         emit AddressRemoved(_addr);
169     }
170     
171     /**
172      * Check if User is Whitelisted
173      * @param _addr User Wallet address
174      */
175     function isAddressWhiteListed(address _addr)
176     public
177     view
178     returns (bool) {
179         
180         return Whitelist.check(_list, _addr);
181     }
182 
183 
184     /**
185      * Check if User has enough ether amount in Whitelisted to buy token 
186      * @param _addr User Wallet address
187      * @param amount The amount of ether user inputed
188      */
189     function isWhiteListedValueValid(address _addr, uint256 amount)
190     public
191     view
192     returns (bool) {
193         
194         return Whitelist.checkValue(_list, _addr, amount);
195     }
196 
197 
198    /**
199      * Check if User is valid to buy token 
200      * @param _addr User Wallet address
201      * @param amount The amount of ether user inputed
202      */
203     function isValidUser(address _addr, uint256 amount)
204     public
205     view
206     returns (bool) {
207         
208         return isAddressWhiteListed(_addr) && isWhiteListedValueValid(_addr, amount);
209     }
210     
211     /**
212      * returns the total amount of the address hold by the user during white list
213      */
214     function getUserAmount(address _addr) public constant returns (uint256) {
215         
216         require(isAddressWhiteListed(_addr));
217         return _list.amount[_addr];
218     }
219     
220 }
221 
222 
223 
224 contract AccessCrowdsale is Whitelisted {
225     using SafeMath for uint256;
226     
227     address public beneficiary;
228     uint256 public SoftCap;
229     uint256 public HardCap;
230     uint256 public amountRaised;
231     uint256 public preSaleStartdate;
232     uint256 public preSaleDeadline;
233     uint256 public mainSaleStartdate;
234     uint256 public mainSaleDeadline;
235     uint256 public price;
236     uint256 public fundTransferred;
237     uint256 public tokenSold;
238     token public tokenReward;
239     mapping(address => uint256) public balanceOf;
240     bool crowdsaleClosed = false;
241     bool returnFunds = false;
242 	
243     event GoalReached(address recipient, uint totalAmountRaised);
244     event FundTransfer(address backer, uint amount, bool isContribution);
245 
246     /**
247      * Constrctor function
248      *
249      * Setup the owner
250      */
251     constructor() public {
252         beneficiary = 0x91520dc19a9e103a849076a9dd860604ff7a6282;
253         SoftCap = 15000 ether;
254         HardCap = 150000 ether;
255         preSaleStartdate = 1550102400;
256         preSaleDeadline = 1552608000;
257         mainSaleStartdate = 1552611600;
258         mainSaleDeadline = 1560643200;
259         price = 0.0004 ether;
260         tokenReward = token(0x97e4017964bc43ec8b3ceadeae27d89bc5a33c7b);
261     }
262 
263     /**
264      * Fallback function
265      *
266      * The function without name is the default function that is called whenever anyone sends funds to a contract
267      */
268     function () payable public {
269         
270         uint256 bonus = 0;
271         uint256 amount;
272         uint256 ethamount = msg.value;
273         
274         require(!crowdsaleClosed);
275         // divide by price to get the actual adt token
276         uint256 onlyAdt = ethamount.div(price);
277         // multiply adt value with decimal of adt to get the wei adt
278         uint256 weiAdt = SafeMath.mul(onlyAdt, 100000000000000);
279     
280         require(isValidUser(msg.sender, weiAdt));
281 
282 
283         
284         balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount);
285         amountRaised = amountRaised.add(ethamount);
286         
287         //add bonus for funders
288         if(now >= preSaleStartdate && now <= preSaleDeadline){
289             amount =  ethamount.div(price);
290             bonus = amount * 33 / 100;
291             amount = amount.add(bonus);
292         }
293         else if(now >= mainSaleStartdate && now <= mainSaleStartdate + 30 days){
294             amount =  ethamount.div(price);
295             bonus = amount * 25/100;
296             amount = amount.add(bonus);
297         }
298         else if(now >= mainSaleStartdate + 30 days && now <= mainSaleStartdate + 45 days){
299             amount =  ethamount.div(price);
300             bonus = amount * 15/100;
301             amount = amount.add(bonus);
302         }
303         else if(now >= mainSaleStartdate + 45 days && now <= mainSaleStartdate + 60 days){
304             amount =  ethamount.div(price);
305             bonus = amount * 10/100;
306             amount = amount.add(bonus);
307         } else {
308             amount =  ethamount.div(price);
309             bonus = amount * 7/100;
310             amount = amount.add(bonus);
311         }
312         
313         amount = amount.mul(100000000000000);
314         tokenReward.transfer(msg.sender, amount);
315         tokenSold = tokenSold.add(amount);
316         
317         resetUserWhiteListAmount();
318         emit FundTransfer(msg.sender, ethamount, true);
319     }
320 
321     modifier afterDeadline() {if (now >= mainSaleDeadline) _; }
322 
323     /**
324      *ends the campaign after deadline
325      */
326      
327     function endCrowdsale() public afterDeadline  onlyOwner {
328         crowdsaleClosed = true;
329     }
330     
331     function EnableReturnFunds() public onlyOwner {
332         returnFunds = true;
333     }
334     
335     function DisableReturnFunds() public onlyOwner {
336         returnFunds = false;
337     }
338 	
339     function ChangePrice(uint256 _price) public onlyOwner {
340         price = _price;	
341     }
342 
343     function ChangeBeneficiary(address _beneficiary) public onlyOwner {
344         beneficiary = _beneficiary;	
345     }
346 	 
347     function ChangePreSaleDates(uint256 _preSaleStartdate, uint256 _preSaleDeadline) onlyOwner public{
348         if(_preSaleStartdate != 0){
349             preSaleStartdate = _preSaleStartdate;
350         }
351         if(_preSaleDeadline != 0){
352             preSaleDeadline = _preSaleDeadline;
353         }
354         
355         if(crowdsaleClosed == true){
356             crowdsaleClosed = false;
357         }
358     }
359     
360     function ChangeMainSaleDates(uint256 _mainSaleStartdate, uint256 _mainSaleDeadline) onlyOwner public{
361         if(_mainSaleStartdate != 0){
362             mainSaleStartdate = _mainSaleStartdate;
363         }
364         if(_mainSaleDeadline != 0){
365             mainSaleDeadline = _mainSaleDeadline; 
366         }
367         
368         if(crowdsaleClosed == true){
369             crowdsaleClosed = false;       
370         }
371     }
372     
373     /**
374      * Get all the remaining token back from the contract
375      */
376     function getTokensBack() onlyOwner public{
377         
378         require(crowdsaleClosed);
379         
380         uint256 remaining = tokenReward.balanceOf(this);
381         tokenReward.transfer(beneficiary, remaining);
382     }
383     
384     /**
385      * User can get their ether back if crowdsale didn't meet it's requirement 
386      */
387     function safeWithdrawal() public afterDeadline {
388         if (returnFunds) {
389             uint amount = balanceOf[msg.sender];
390             if (amount > 0) {
391                 if (msg.sender.send(amount)) {
392                     emit FundTransfer(msg.sender, amount, false);
393                     balanceOf[msg.sender] = 0;
394                     fundTransferred = fundTransferred.add(amount);
395                 } 
396             }
397         }
398 
399         if (returnFunds == false && beneficiary == msg.sender) {
400             uint256 ethToSend = amountRaised - fundTransferred;
401             if (beneficiary.send(ethToSend)) {
402                 fundTransferred = fundTransferred.add(ethToSend);
403             } 
404         }
405     }
406     
407     function getResponse(uint256 val) public constant returns(uint256) {
408         uint256 adtDec = 100000000000000;
409         
410         uint256 onlyAdt = val.div(price);
411         // multiply adt value with decimal of adt to get the wei adt
412         uint256 weiAdt = SafeMath.mul(onlyAdt, adtDec);
413         
414         return weiAdt;
415     }
416 
417 }