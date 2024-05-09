1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract OysterPearl {
6     // Public variables of PRL
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     uint256 public funds;
12     address public director;
13     bool public saleClosed;
14     bool public directorLock;
15     uint256 public claimAmount;
16     uint256 public payAmount;
17     uint256 public feeAmount;
18     uint256 public epoch;
19     uint256 public retentionMax;
20 
21     // This creates an array with all balances
22     mapping (address => uint256) public balances;
23     mapping (address => mapping (address => uint256)) public allowance;
24     mapping (address => bool) public buried;
25     mapping (address => uint256) public claimed;
26 
27     // ERC20 event
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     
30     // ERC20 event
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33     // This notifies clients about the amount burnt
34     event Burn(address indexed from, uint256 value);
35     
36     // This notifies clients about the an address getting buried
37     event Bury(address indexed target, uint256 value);
38     
39     // This notifies clients about a claim being made on a buried address
40     event Claim(address indexed target, address indexed payout, address indexed fee);
41 
42     /**
43      * Constructor function
44      *
45      * Initializes contract
46      */
47     function OysterPearl() public {
48         director = msg.sender;
49         name = "Oyster Pearl";
50         symbol = "TSPRL";
51         decimals = 18;
52         funds = 0;
53         totalSupply = 0;
54         saleClosed = true;
55         directorLock = false;
56         
57         // Marketing share (5%)
58         totalSupply += 25000000 * 10 ** uint256(decimals);
59         
60         // Devfund share (15%)
61         totalSupply += 75000000 * 10 ** uint256(decimals);
62         
63         // Allocation to match PREPRL supply
64         totalSupply += 1000000 * 10 ** uint256(decimals);
65         
66         // Assign reserved PRL supply to contract owner
67         balances[director] = totalSupply;
68         
69         //define default values for Oyster functions
70         claimAmount = 5 * 10 ** (uint256(decimals) - 1);
71         payAmount = 4 * 10 ** (uint256(decimals) - 1);
72         feeAmount = 1 * 10 ** (uint256(decimals) - 1);
73         
74         //seconds in a year
75         epoch = 31536001;
76         
77         //Maximum time for a sector to remain stored
78         retentionMax = 40 * 10 ** uint256(decimals);
79     }
80     
81     /**
82      * ERC20 function
83      */
84     function balanceOf(address _owner) public constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87     
88     modifier onlyDirector {
89         // Owner can lock themselves out to complete decentralization of Oyster network
90         require(!directorLock);
91         
92         // Lockout will occur eventually, guaranteeing Oyster decentralization
93         require(block.number < 8000000);
94         
95         // Only the contract owner is permitted
96         require(msg.sender == director);
97         _;
98     }
99     
100     modifier onlyDirectorForce {
101         // Only the contract owner is permitted
102         require(msg.sender == director);
103         _;
104     }
105     
106     /**
107      * Transfers the contract owner to a new address
108      */
109     function transferDirector(address newDirector) public onlyDirectorForce {
110         director = newDirector;
111     }
112     
113     /**
114      * Withdraw funds from the crowdsale
115      */
116     function withdrawFunds() public onlyDirectorForce {
117         director.transfer(this.balance);
118     }
119     
120     /**
121      * Permanently lock out the contract owner to decentralize Oyster
122      */
123     function selfLock() public onlyDirector {
124         // The sale must be closed before the owner gets locked out
125         require(saleClosed);
126         
127         // Permanently lock out the contract owner
128         directorLock = true;
129     }
130     
131     /**
132      * Contract owner can alter the storage-peg and broker fees
133      */
134     function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet) public onlyDirector {
135         require(claimAmountSet == (payAmountSet + feeAmountSet));
136         
137         claimAmount = claimAmountSet * 10 ** (uint256(decimals) - 1);
138         payAmount = payAmountSet * 10 ** (uint256(decimals) - 1);
139         feeAmount = feeAmountSet * 10 ** (uint256(decimals) - 1);
140     }
141     
142     /**
143      * Contract owner can alter the epoch time
144      */
145     function amendEpoch(uint256 epochSet) public onlyDirector {
146         // Set the epoch
147         epoch = epochSet;
148     }
149     
150     /**
151      * Contract owner can alter the maximum storage retention
152      */
153     function amendRetention(uint8 retentionSet) public onlyDirector {
154         // Set RetentionMax
155         retentionMax = retentionSet * 10 ** uint256(decimals);
156     }
157     
158     /**
159      * Director can close the crowdsale
160      */
161     function closeSale() public onlyDirector {
162         // The sale must be currently open
163         require(!saleClosed);
164         
165         // Lock the crowdsale
166         saleClosed = true;
167     }
168 
169     /**
170      * Director can open the crowdsale
171      */
172     function openSale() public onlyDirector {
173         // The sale must be currently closed
174         require(saleClosed);
175         
176         // Unlock the crowdsale
177         saleClosed = false;
178     }
179     
180     /**
181      * Oyster Protocol Function
182      * More information at https://oyster.ws/OysterWhitepaper.pdf
183      * 
184      * Bury an address
185      *
186      * When an address is buried; only claimAmount can be withdrawn once per epoch
187      *
188      */
189     function bury() public {
190         // The address must be previously unburied
191         require(!buried[msg.sender]);
192         
193         // An address must have atleast claimAmount to be buried
194         require(balances[msg.sender] > claimAmount);
195         
196         // Prevent addresses with large balances from getting buried
197         require(balances[msg.sender] <= retentionMax);
198         
199         // Set buried state to true
200         buried[msg.sender] = true;
201         
202         // Set the initial claim clock to 1
203         claimed[msg.sender] = 1;
204         
205         // Execute an event reflecting the change
206         Bury(msg.sender, balances[msg.sender]);
207     }
208     
209     /**
210      * Oyster Protocol Function
211      * More information at https://oyster.ws/OysterWhitepaper.pdf
212      * 
213      * Claim PRL from a buried address
214      *
215      * If a prior claim wasn't made during the current epoch
216      *
217      * @param _payout The address of the recipient
218      * @param _fee the amount to send
219      */
220     function claim(address _payout, address _fee) public {
221         // The claimed address must have already been buried
222         require(buried[msg.sender]);
223         
224         // The payout and fee addresses must be different
225         require(_payout != _fee);
226         
227         // The claimed address cannot pay itself
228         require(msg.sender != _payout);
229         
230         // The claimed address cannot pay itself
231         require(msg.sender != _fee);
232         
233         // It must be either the first time this address is being claimed or atleast epoch in time has passed
234         require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);
235         
236         // Check if the buried address has enough
237         require(balances[msg.sender] >= claimAmount);
238         
239         // Reset the claim clock to the current time
240         claimed[msg.sender] = block.timestamp;
241         
242         // Save this for an assertion in the future
243         uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];
244         
245         // Remove claimAmount from the buried address
246         balances[msg.sender] -= claimAmount;
247         
248         // Pay the website owner that invoked the webnode that found the PRL seed key
249         balances[_payout] += payAmount;
250         
251         // Pay the broker node that unlocked the PRL
252         balances[_fee] += feeAmount;
253         
254         // Execute events to reflect the changes
255         Transfer(msg.sender, _payout, payAmount);
256         Transfer(msg.sender, _fee, feeAmount);
257         Claim(msg.sender, _payout, _fee);
258         
259         // Asserts are used to use static analysis to find bugs in your code, they should never fail
260         assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);
261     }
262     
263     /**
264      * Crowdsale function
265      */
266     function () payable public {
267         // Check if crowdsale is still active
268         require(!saleClosed);
269         
270         // Minimum amount is 1 finney
271         require(msg.value >= 1 finney);
272         
273         // Price is 1 ETH = 5000 PRL
274         uint256 amount = msg.value * 5000;
275         
276         // totalSupply limit is 500 million PRL
277         require(totalSupply + amount <= (500000000 * 10 ** uint256(decimals)));
278         
279         // Increases the total supply
280         totalSupply += amount;
281         
282         // Adds the amount to buyer's balance
283         balances[msg.sender] += amount;
284         
285         // Track ETH amount raised
286         funds += msg.value;
287         
288         // Execute an event reflecting the change
289         Transfer(this, msg.sender, amount);
290     }
291 
292     /**
293      * Internal transfer, only can be called by this contract
294      */
295     function _transfer(address _from, address _to, uint _value) internal {
296         // Sending addresses cannot be buried
297         require(!buried[_from]);
298         
299         // If the receiving addresse is buried, it cannot exceed retentionMax
300         if (buried[_to]) {
301             require(balances[_to] + _value <= retentionMax);
302         }
303         
304         // Prevent transfer to 0x0 address. Use burn() instead
305         require(_to != 0x0);
306         
307         // Check if the sender has enough
308         require(balances[_from] >= _value);
309         
310         // Check for overflows
311         require(balances[_to] + _value > balances[_to]);
312         
313         // Save this for an assertion in the future
314         uint256 previousBalances = balances[_from] + balances[_to];
315         
316         // Subtract from the sender
317         balances[_from] -= _value;
318         
319         // Add the same to the recipient
320         balances[_to] += _value;
321         Transfer(_from, _to, _value);
322         
323         // Asserts are used to use static analysis to find bugs in your code, they should never fail
324         assert(balances[_from] + balances[_to] == previousBalances);
325     }
326 
327     /**
328      * Transfer tokens
329      *
330      * Send `_value` tokens to `_to` from your account
331      *
332      * @param _to The address of the recipient
333      * @param _value the amount to send
334      */
335     function transfer(address _to, uint256 _value) public {
336         _transfer(msg.sender, _to, _value);
337     }
338 
339     /**
340      * Transfer tokens from other address
341      *
342      * Send `_value` tokens to `_to` in behalf of `_from`
343      *
344      * @param _from The address of the sender
345      * @param _to The address of the recipient
346      * @param _value the amount to send
347      */
348     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
349         // Check allowance
350         require(_value <= allowance[_from][msg.sender]);
351         allowance[_from][msg.sender] -= _value;
352         _transfer(_from, _to, _value);
353         return true;
354     }
355 
356     /**
357      * Set allowance for other address
358      *
359      * Allows `_spender` to spend no more than `_value` tokens in your behalf
360      *
361      * @param _spender The address authorized to spend
362      * @param _value the max amount they can spend
363      */
364     function approve(address _spender, uint256 _value) public
365         returns (bool success) {
366         // Buried addresses cannot be approved
367         require(!buried[_spender]);
368         
369         allowance[msg.sender][_spender] = _value;
370         
371         Approval(msg.sender, _spender, _value);
372         return true;
373     }
374 
375     /**
376      * Set allowance for other address and notify
377      *
378      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
379      *
380      * @param _spender The address authorized to spend
381      * @param _value the max amount they can spend
382      * @param _extraData some extra information to send to the approved contract
383      */
384     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
385         public
386         returns (bool success) {
387         tokenRecipient spender = tokenRecipient(_spender);
388         if (approve(_spender, _value)) {
389             spender.receiveApproval(msg.sender, _value, this, _extraData);
390             return true;
391         }
392     }
393 
394     /**
395      * Destroy tokens
396      *
397      * Remove `_value` tokens from the system irreversibly
398      *
399      * @param _value the amount of money to burn
400      */
401     function burn(uint256 _value) public returns (bool success) {
402         // Buried addresses cannot be burnt
403         require(!buried[msg.sender]);
404         
405         // Check if the sender has enough
406         require(balances[msg.sender] >= _value);
407         
408         // Subtract from the sender
409         balances[msg.sender] -= _value;
410         
411         // Updates totalSupply
412         totalSupply -= _value;
413         Burn(msg.sender, _value);
414         return true;
415     }
416 
417     /**
418      * Destroy tokens from other account
419      *
420      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
421      *
422      * @param _from the address of the sender
423      * @param _value the amount of money to burn
424      */
425     function burnFrom(address _from, uint256 _value) public returns (bool success) {
426         // Buried addresses cannot be burnt
427         require(!buried[_from]);
428         
429         // Check if the targeted balance is enough
430         require(balances[_from] >= _value);
431         
432         // Check allowance
433         require(_value <= allowance[_from][msg.sender]);
434         
435         // Subtract from the targeted balance
436         balances[_from] -= _value;
437         
438         // Subtract from the sender's allowance
439         allowance[_from][msg.sender] -= _value;
440         
441         // Update totalSupply
442         totalSupply -= _value;
443         Burn(_from, _value);
444         return true;
445     }
446 }