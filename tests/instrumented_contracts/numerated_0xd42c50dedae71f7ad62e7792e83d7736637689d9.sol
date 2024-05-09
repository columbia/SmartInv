1 pragma solidity ^0.4.19;
2 
3 
4 contract Owned
5 {
6     address public owner;
7 
8     modifier onlyOwner
9 	{
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) public onlyOwner()
15 	{
16         owner = newOwner;
17     }
18 }
19 
20 
21 contract Agricoin is Owned
22 {
23     // Dividends payout struct.
24     struct DividendPayout
25     {
26         uint amount;            // Value of dividend payout.
27         uint momentTotalSupply; // Total supply in payout moment,
28     }
29 
30     // Redemption payout struct.
31     struct RedemptionPayout
32     {
33         uint amount;            // Value of redemption payout.
34         uint momentTotalSupply; // Total supply in payout moment.
35         uint price;             // Price of Agricoin in weis.
36     }
37 
38     // Balance struct with dividends and redemptions record.
39     struct Balance
40     {
41         uint icoBalance;
42         uint balance;                       // Agricoin balance.
43         uint posibleDividends;              // Dividend number, which user can get.
44         uint lastDividensPayoutNumber;      // Last dividend payout index, which user has gotten.
45         uint posibleRedemption;             // Redemption value in weis, which user can use.
46         uint lastRedemptionPayoutNumber;    // Last redemption payout index, which user has used.
47     }
48 
49     // Can act only one from payers.
50     modifier onlyPayer()
51     {
52         require(payers[msg.sender]);
53         _;
54     }
55     
56     // Can act only after token activation.
57     modifier onlyActivated()
58     {
59         require(isActive);
60         _;
61     }
62 
63     // Transfer event.
64     event Transfer(address indexed _from, address indexed _to, uint _value);    
65 
66     // Approve event.
67     event Approval(address indexed _owner, address indexed _spender, uint _value);
68 
69     // Activate event.
70     event Activate(bool icoSuccessful);
71 
72     // DividendPayout dividends event.
73     event PayoutDividends(uint etherAmount, uint indexed id);
74 
75     // DividendPayout redemption event.
76     event PayoutRedemption(uint etherAmount, uint indexed id, uint price);
77 
78     // Get unpaid event.
79     event GetUnpaid(uint etherAmount);
80 
81     // Get dividends.
82     event GetDividends(address indexed investor, uint etherAmount);
83 
84     // Constructor.
85     function Agricoin(uint payout_period_start, uint payout_period_end, address _payer) public
86     {
87         owner = msg.sender;// Save the owner.
88 
89         // Set payout period.
90         payoutPeriodStart = payout_period_start;
91         payoutPeriodEnd = payout_period_end;
92 
93         payers[_payer] = true;
94     }
95 
96     // Activate token.
97 	function activate(bool icoSuccessful) onlyOwner() external returns (bool)
98 	{
99 		require(!isActive);// Check once activation.
100 
101         startDate = now;// Save activation date.
102 		isActive = true;// Make token active.
103 		owner = 0x00;// Set owner to null.
104 		
105         if (icoSuccessful)
106         {
107             isSuccessfulIco = true;
108             totalSupply += totalSupplyOnIco;
109             Activate(true);// Call activation event.
110         }
111         else
112         {
113             Activate(false);// Call activation event.
114         }
115 
116         return true;
117 	}
118 
119     // Add new payer by payer.
120     function addPayer(address payer) onlyPayer() external
121     {
122         payers[payer] = true;
123     }
124 
125     // Get balance of address.
126 	function balanceOf(address owner) public view returns (uint)
127 	{
128 		return balances[owner].balance;
129 	}
130 
131     // Get posible dividends value.
132     function posibleDividendsOf(address owner) public view returns (uint)
133     {
134         return balances[owner].posibleDividends;
135     }
136 
137     // Get posible redemption value.
138     function posibleRedemptionOf(address owner) public view returns (uint)
139     {
140         return balances[owner].posibleRedemption;
141     }
142 
143     // Transfer _value etheres to _to.
144     function transfer(address _to, uint _value) onlyActivated() external returns (bool)
145     {
146         require(balanceOf(msg.sender) >= _value);
147 
148         recalculate(msg.sender);// Recalculate user's struct.
149         
150         if (_to != 0x00)// For normal transfer.
151         {
152             recalculate(_to);// Recalculate recipient's struct.
153 
154             // Change balances.
155             balances[msg.sender].balance -= _value;
156             balances[_to].balance += _value;
157 
158             Transfer(msg.sender, _to, _value);// Call transfer event.
159         }
160         else// For redemption transfer.
161         {
162             require(payoutPeriodStart <= now && now >= payoutPeriodEnd);// Check redemption period.
163             
164             uint amount = _value * redemptionPayouts[amountOfRedemptionPayouts].price;// Calculate amount of weis in redemption.
165 
166             require(amount <= balances[msg.sender].posibleRedemption);// Check redemption limits.
167 
168             // Change user's struct.
169             balances[msg.sender].posibleRedemption -= amount;
170             balances[msg.sender].balance -= _value;
171 
172             totalSupply -= _value;// Decrease total supply.
173 
174             msg.sender.transfer(amount);// Transfer redemption to user.
175 
176             Transfer(msg.sender, _to, _value);// Call transfer event.
177         }
178 
179         return true;
180     }
181 
182     // Transfer from _from to _to _value tokens.
183     function transferFrom(address _from, address _to, uint _value) onlyActivated() external returns (bool)
184     {
185         // Check transfer posibility.
186         require(balances[_from].balance >= _value);
187         require(allowed[_from][msg.sender] >= _value);
188         require(_to != 0x00);
189 
190         // Recalculate structs.
191         recalculate(_from);
192         recalculate(_to);
193 
194         // Change balances.
195         balances[_from].balance -= _value;
196         balances[_to].balance += _value;
197         
198         Transfer(_from, _to, _value);// Call tranfer event.
199         
200         return true;
201     }
202 
203     // Approve for transfers.
204     function approve(address _spender, uint _value) onlyActivated() public returns (bool)
205     {
206         // Recalculate structs.
207         recalculate(msg.sender);
208         recalculate(_spender);
209 
210         allowed[msg.sender][_spender] = _value;// Set allowed.
211         
212         Approval(msg.sender, _spender, _value);// Call approval event.
213         
214         return true;
215     }
216 
217     // Get allowance.
218     function allowance(address _owner, address _spender) onlyActivated() external view returns (uint)
219     {
220         return allowed[_owner][_spender];
221     }
222 
223     // Mint _value tokens to _to address.
224     function mint(address _to, uint _value, bool icoMinting) onlyOwner() external returns (bool)
225     {
226         require(!isActive);// Check no activation.
227 
228         if (icoMinting)
229         {
230             balances[_to].icoBalance += _value;
231             totalSupplyOnIco += _value;
232         }
233         else
234         {
235             balances[_to].balance += _value;// Increase user's balance.
236             totalSupply += _value;// Increase total supply.
237 
238             Transfer(0x00, _to, _value);// Call transfer event.
239         }
240         
241         return true;
242     }
243 
244     // Pay dividends.
245     function payDividends() onlyPayer() onlyActivated() external payable returns (bool)
246     {
247         require(now >= payoutPeriodStart && now <= payoutPeriodEnd);// Check payout period.
248 
249         dividendPayouts[amountOfDividendsPayouts].amount = msg.value;// Set payout amount in weis.
250         dividendPayouts[amountOfDividendsPayouts].momentTotalSupply = totalSupply;// Save total supply on that moment.
251         
252         PayoutDividends(msg.value, amountOfDividendsPayouts);// Call dividend payout event.
253 
254         amountOfDividendsPayouts++;// Increment dividend payouts amount.
255 
256         return true;
257     }
258 
259     // Pay redemption.
260     function payRedemption(uint price) onlyPayer() onlyActivated() external payable returns (bool)
261     {
262         require(now >= payoutPeriodStart && now <= payoutPeriodEnd);// Check payout period.
263 
264         redemptionPayouts[amountOfRedemptionPayouts].amount = msg.value;// Set payout amount in weis.
265         redemptionPayouts[amountOfRedemptionPayouts].momentTotalSupply = totalSupply;// Save total supply on that moment.
266         redemptionPayouts[amountOfRedemptionPayouts].price = price;// Set price of Agricoin in weis at this redemption moment.
267 
268         PayoutRedemption(msg.value, amountOfRedemptionPayouts, price);// Call redemption payout event.
269 
270         amountOfRedemptionPayouts++;// Increment redemption payouts amount.
271 
272         return true;
273     }
274 
275     // Get back unpaid dividends and redemption.
276     function getUnpaid() onlyPayer() onlyActivated() external returns (bool)
277     {
278         require(now >= payoutPeriodEnd);// Check end payout period.
279 
280         GetUnpaid(this.balance);// Call getting unpaid ether event.
281 
282         msg.sender.transfer(this.balance);// Transfer all ethers back to payer.
283 
284         return true;
285     }
286 
287     // Recalculates dividends and redumptions.
288     function recalculate(address user) onlyActivated() public returns (bool)
289     {
290         if (isSuccessfulIco)
291         {
292             if (balances[user].icoBalance != 0)
293             {
294                 balances[user].balance += balances[user].icoBalance;
295                 Transfer(0x00, user, balances[user].icoBalance);
296                 balances[user].icoBalance = 0;
297             }
298         }
299 
300         // Check for necessity of recalculation.
301         if (balances[user].lastDividensPayoutNumber == amountOfDividendsPayouts &&
302             balances[user].lastRedemptionPayoutNumber == amountOfRedemptionPayouts)
303         {
304             return true;
305         }
306 
307         uint addedDividend = 0;
308 
309         // For dividends.
310         for (uint i = balances[user].lastDividensPayoutNumber; i < amountOfDividendsPayouts; i++)
311         {
312             addedDividend += (balances[user].balance * dividendPayouts[i].amount) / dividendPayouts[i].momentTotalSupply;
313         }
314 
315         balances[user].posibleDividends += addedDividend;
316         balances[user].lastDividensPayoutNumber = amountOfDividendsPayouts;
317 
318         uint addedRedemption = 0;
319 
320         // For redemption.
321         for (uint j = balances[user].lastRedemptionPayoutNumber; j < amountOfRedemptionPayouts; j++)
322         {
323             addedRedemption += (balances[user].balance * redemptionPayouts[j].amount) / redemptionPayouts[j].momentTotalSupply;
324         }
325 
326         balances[user].posibleRedemption += addedRedemption;
327         balances[user].lastRedemptionPayoutNumber = amountOfRedemptionPayouts;
328 
329         return true;
330     }
331 
332     // Get dividends.
333     function () external payable
334     {
335         if (payoutPeriodStart >= now && now <= payoutPeriodEnd)// Check payout period.
336         {
337             if (posibleDividendsOf(msg.sender) > 0)// Check posible dividends.
338             {
339                 uint dividendsAmount = posibleDividendsOf(msg.sender);// Get posible dividends amount.
340 
341                 GetDividends(msg.sender, dividendsAmount);// Call getting dividends event.
342 
343                 balances[msg.sender].posibleDividends = 0;// Set balance to zero.
344 
345                 msg.sender.transfer(dividendsAmount);// Transfer dividends amount.
346             }
347         }
348     }
349 
350     // Token name.
351     string public constant name = "Agricoin";
352     
353     // Token market symbol.
354     string public constant symbol = "AGR";
355     
356     // Amount of digits after comma.
357     uint public constant decimals = 2;
358 
359     // Total supply.
360     uint public totalSupply;
361 
362     // Total supply on ICO only;
363     uint public totalSupplyOnIco;
364        
365     // Activation date.
366     uint public startDate;
367     
368     // Payment period start date, setted by ICO contract before activation.
369     uint public payoutPeriodStart;
370     
371     // Payment period last date, setted by ICO contract before activation.
372     uint public payoutPeriodEnd;
373     
374     // Dividends DividendPayout counter.
375     uint public amountOfDividendsPayouts = 0;
376 
377     // Redemption DividendPayout counter.
378     uint public amountOfRedemptionPayouts = 0;
379 
380     // Dividend payouts.
381     mapping (uint => DividendPayout) public dividendPayouts;
382     
383     // Redemption payouts.
384     mapping (uint => RedemptionPayout) public redemptionPayouts;
385 
386     // Dividend and redemption payers.
387     mapping (address => bool) public payers;
388 
389     // Balance records.
390     mapping (address => Balance) public balances;
391 
392     // Allowed balances.
393     mapping (address => mapping (address => uint)) public allowed;
394 
395     // Set true for activating token. If false then token isn't working.
396     bool public isActive = false;
397 
398     // Set true for activate ico minted tokens.
399     bool public isSuccessfulIco = false;
400 }