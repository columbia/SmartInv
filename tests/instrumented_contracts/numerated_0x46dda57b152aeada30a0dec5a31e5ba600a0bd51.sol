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
21     // Array definitions
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
34     event Burn(address indexed _from, uint256 _value);
35     
36     // This notifies clients about an address getting buried
37     event Bury(address indexed _target, uint256 _value);
38     
39     // This notifies clients about a claim being made on a buried address
40     event Claim(address indexed _target, address indexed _payout, address indexed _fee);
41 
42     /**
43      * Constructor function
44      *
45      * Initializes contract
46      */
47     function OysterPearl() public {
48         director = msg.sender;
49         name = "Oyster Pearl";
50         symbol = "PRL";
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
63         // Allocation to match PREPRL supply and reservation for discretionary use
64         totalSupply += 8000000 * 10 ** uint256(decimals);
65         
66         // Assign reserved PRL supply to the director
67         balances[director] = totalSupply;
68         
69         // Define default values for Oyster functions
70         claimAmount = 5 * 10 ** (uint256(decimals) - 1);
71         payAmount = 4 * 10 ** (uint256(decimals) - 1);
72         feeAmount = 1 * 10 ** (uint256(decimals) - 1);
73         
74         // Seconds in a year
75         epoch = 31536000;
76         
77         // Maximum time for a sector to remain stored
78         retentionMax = 40 * 10 ** uint256(decimals);
79     }
80     
81     /**
82      * ERC20 balance function
83      */
84     function balanceOf(address _owner) public constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87     
88     modifier onlyDirector {
89         // Director can lock themselves out to complete decentralization of Oyster network
90         // An alternative is that another smart contract could become the decentralized director
91         require(!directorLock);
92         
93         // Only the director is permitted
94         require(msg.sender == director);
95         _;
96     }
97     
98     modifier onlyDirectorForce {
99         // Only the director is permitted
100         require(msg.sender == director);
101         _;
102     }
103     
104     /**
105      * Transfers the director to a new address
106      */
107     function transferDirector(address newDirector) public onlyDirectorForce {
108         director = newDirector;
109     }
110     
111     /**
112      * Withdraw funds from the contract
113      */
114     function withdrawFunds() public onlyDirectorForce {
115         director.transfer(this.balance);
116     }
117     
118     /**
119      * Permanently lock out the director to decentralize Oyster
120      * Invocation is discretionary because Oyster might be better suited to
121      * transition to an artificially intelligent smart contract director
122      */
123     function selfLock() public payable onlyDirector {
124         // The sale must be closed before the director gets locked out
125         require(saleClosed);
126         
127         // Prevents accidental lockout
128         require(msg.value == 10 ether);
129         
130         // Permanently lock out the director
131         directorLock = true;
132     }
133     
134     /**
135      * Director can alter the storage-peg and broker fees
136      */
137     function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet, uint8 accuracy) public onlyDirector {
138         require(claimAmountSet == (payAmountSet + feeAmountSet));
139         
140         claimAmount = claimAmountSet * 10 ** (uint256(decimals) - accuracy);
141         payAmount = payAmountSet * 10 ** (uint256(decimals) - accuracy);
142         feeAmount = feeAmountSet * 10 ** (uint256(decimals) - accuracy);
143     }
144     
145     /**
146      * Director can alter the epoch time
147      */
148     function amendEpoch(uint256 epochSet) public onlyDirector {
149         // Set the epoch
150         epoch = epochSet;
151     }
152     
153     /**
154      * Director can alter the maximum time of storage retention
155      */
156     function amendRetention(uint8 retentionSet, uint8 accuracy) public onlyDirector {
157         // Set retentionMax
158         retentionMax = retentionSet * 10 ** (uint256(decimals) - accuracy);
159     }
160     
161     /**
162      * Director can close the crowdsale
163      */
164     function closeSale() public onlyDirector {
165         // The sale must be currently open
166         require(!saleClosed);
167         
168         // Lock the crowdsale
169         saleClosed = true;
170     }
171 
172     /**
173      * Director can open the crowdsale
174      */
175     function openSale() public onlyDirector {
176         // The sale must be currently closed
177         require(saleClosed);
178         
179         // Unlock the crowdsale
180         saleClosed = false;
181     }
182     
183     /**
184      * Oyster Protocol Function
185      * More information at https://oyster.ws/OysterWhitepaper.pdf
186      * 
187      * Bury an address
188      *
189      * When an address is buried; only claimAmount can be withdrawn once per epoch
190      */
191     function bury() public returns (bool success) {
192         // The address must be previously unburied
193         require(!buried[msg.sender]);
194         
195         // An address must have at least claimAmount to be buried
196         require(balances[msg.sender] >= claimAmount);
197         
198         // Prevent addresses with large balances from getting buried
199         require(balances[msg.sender] <= retentionMax);
200         
201         // Set buried state to true
202         buried[msg.sender] = true;
203         
204         // Set the initial claim clock to 1
205         claimed[msg.sender] = 1;
206         
207         // Execute an event reflecting the change
208         Bury(msg.sender, balances[msg.sender]);
209         return true;
210     }
211     
212     /**
213      * Oyster Protocol Function
214      * More information at https://oyster.ws/OysterWhitepaper.pdf
215      * 
216      * Claim PRL from a buried address
217      *
218      * If a prior claim wasn't made during the current epoch, then claimAmount can be withdrawn
219      *
220      * @param _payout the address of the website owner
221      * @param _fee the address of the broker node
222      */
223     function claim(address _payout, address _fee) public returns (bool success) {
224         // The claimed address must have already been buried
225         require(buried[msg.sender]);
226         
227         // The payout and fee addresses must be different
228         require(_payout != _fee);
229         
230         // The claimed address cannot pay itself
231         require(msg.sender != _payout);
232         
233         // The claimed address cannot pay itself
234         require(msg.sender != _fee);
235         
236         // It must be either the first time this address is being claimed or atleast epoch in time has passed
237         require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);
238         
239         // Check if the buried address has enough
240         require(balances[msg.sender] >= claimAmount);
241         
242         // Reset the claim clock to the current time
243         claimed[msg.sender] = block.timestamp;
244         
245         // Save this for an assertion in the future
246         uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];
247         
248         // Remove claimAmount from the buried address
249         balances[msg.sender] -= claimAmount;
250         
251         // Pay the website owner that invoked the web node that found the PRL seed key
252         balances[_payout] += payAmount;
253         
254         // Pay the broker node that unlocked the PRL
255         balances[_fee] += feeAmount;
256         
257         // Execute events to reflect the changes
258         Claim(msg.sender, _payout, _fee);
259         Transfer(msg.sender, _payout, payAmount);
260         Transfer(msg.sender, _fee, feeAmount);
261         
262         // Failsafe logic that should never be false
263         assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);
264         return true;
265     }
266     
267     /**
268      * Crowdsale function
269      */
270     function () public payable {
271         // Check if crowdsale is still active
272         require(!saleClosed);
273         
274         // Minimum amount is 1 finney
275         require(msg.value >= 1 finney);
276         
277         // Price is 1 ETH = 5000 PRL
278         uint256 amount = msg.value * 5000;
279         
280         // totalSupply limit is 500 million PRL
281         require(totalSupply + amount <= (500000000 * 10 ** uint256(decimals)));
282         
283         // Increases the total supply
284         totalSupply += amount;
285         
286         // Adds the amount to the balance
287         balances[msg.sender] += amount;
288         
289         // Track ETH amount raised
290         funds += msg.value;
291         
292         // Execute an event reflecting the change
293         Transfer(this, msg.sender, amount);
294     }
295 
296     /**
297      * Internal transfer, can be called by this contract only
298      */
299     function _transfer(address _from, address _to, uint _value) internal {
300         // Sending addresses cannot be buried
301         require(!buried[_from]);
302         
303         // If the receiving address is buried, it cannot exceed retentionMax
304         if (buried[_to]) {
305             require(balances[_to] + _value <= retentionMax);
306         }
307         
308         // Prevent transfer to 0x0 address, use burn() instead
309         require(_to != 0x0);
310         
311         // Check if the sender has enough
312         require(balances[_from] >= _value);
313         
314         // Check for overflows
315         require(balances[_to] + _value > balances[_to]);
316         
317         // Save this for an assertion in the future
318         uint256 previousBalances = balances[_from] + balances[_to];
319         
320         // Subtract from the sender
321         balances[_from] -= _value;
322         
323         // Add the same to the recipient
324         balances[_to] += _value;
325         Transfer(_from, _to, _value);
326         
327         // Failsafe logic that should never be false
328         assert(balances[_from] + balances[_to] == previousBalances);
329     }
330 
331     /**
332      * Transfer tokens
333      *
334      * Send `_value` tokens to `_to` from your account
335      *
336      * @param _to the address of the recipient
337      * @param _value the amount to send
338      */
339     function transfer(address _to, uint256 _value) public {
340         _transfer(msg.sender, _to, _value);
341     }
342 
343     /**
344      * Transfer tokens from other address
345      *
346      * Send `_value` tokens to `_to` in behalf of `_from`
347      *
348      * @param _from the address of the sender
349      * @param _to the address of the recipient
350      * @param _value the amount to send
351      */
352     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
353         // Check allowance
354         require(_value <= allowance[_from][msg.sender]);
355         allowance[_from][msg.sender] -= _value;
356         _transfer(_from, _to, _value);
357         return true;
358     }
359 
360     /**
361      * Set allowance for other address
362      *
363      * Allows `_spender` to spend no more than `_value` tokens on your behalf
364      *
365      * @param _spender the address authorized to spend
366      * @param _value the max amount they can spend
367      */
368     function approve(address _spender, uint256 _value) public
369         returns (bool success) {
370         // Buried addresses cannot be approved
371         require(!buried[_spender]);
372         allowance[msg.sender][_spender] = _value;
373         Approval(msg.sender, _spender, _value);
374         return true;
375     }
376 
377     /**
378      * Set allowance for other address and notify
379      *
380      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
381      *
382      * @param _spender the address authorized to spend
383      * @param _value the max amount they can spend
384      * @param _extraData some extra information to send to the approved contract
385      */
386     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
387         public
388         returns (bool success) {
389         tokenRecipient spender = tokenRecipient(_spender);
390         if (approve(_spender, _value)) {
391             spender.receiveApproval(msg.sender, _value, this, _extraData);
392             return true;
393         }
394     }
395 
396     /**
397      * Destroy tokens
398      *
399      * Remove `_value` tokens from the system irreversibly
400      *
401      * @param _value the amount of money to burn
402      */
403     function burn(uint256 _value) public returns (bool success) {
404         // Buried addresses cannot be burnt
405         require(!buried[msg.sender]);
406         
407         // Check if the sender has enough
408         require(balances[msg.sender] >= _value);
409         
410         // Subtract from the sender
411         balances[msg.sender] -= _value;
412         
413         // Updates totalSupply
414         totalSupply -= _value;
415         Burn(msg.sender, _value);
416         return true;
417     }
418 
419     /**
420      * Destroy tokens from other account
421      *
422      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
423      *
424      * @param _from the address of the sender
425      * @param _value the amount of money to burn
426      */
427     function burnFrom(address _from, uint256 _value) public returns (bool success) {
428         // Buried addresses cannot be burnt
429         require(!buried[_from]);
430         
431         // Check if the targeted balance is enough
432         require(balances[_from] >= _value);
433         
434         // Check allowance
435         require(_value <= allowance[_from][msg.sender]);
436         
437         // Subtract from the targeted balance
438         balances[_from] -= _value;
439         
440         // Subtract from the sender's allowance
441         allowance[_from][msg.sender] -= _value;
442         
443         // Update totalSupply
444         totalSupply -= _value;
445         Burn(_from, _value);
446         return true;
447     }
448 }