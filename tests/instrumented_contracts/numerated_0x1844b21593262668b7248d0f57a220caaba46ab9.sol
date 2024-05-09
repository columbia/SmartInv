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
52         saleClosed = true;
53         directorLock = false;
54         funds = 0;
55         totalSupply = 0;
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
137     function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet, uint8 accuracy) public onlyDirector returns (bool success) {
138         require(claimAmountSet == (payAmountSet + feeAmountSet));
139         
140         claimAmount = claimAmountSet * 10 ** (uint256(decimals) - accuracy);
141         payAmount = payAmountSet * 10 ** (uint256(decimals) - accuracy);
142         feeAmount = feeAmountSet * 10 ** (uint256(decimals) - accuracy);
143         return true;
144     }
145     
146     /**
147      * Director can alter the epoch time
148      */
149     function amendEpoch(uint256 epochSet) public onlyDirector returns (bool success) {
150         // Set the epoch
151         epoch = epochSet;
152         return true;
153     }
154     
155     /**
156      * Director can alter the maximum time of storage retention
157      */
158     function amendRetention(uint8 retentionSet, uint8 accuracy) public onlyDirector returns (bool success) {
159         // Set retentionMax
160         retentionMax = retentionSet * 10 ** (uint256(decimals) - accuracy);
161         return true;
162     }
163     
164     /**
165      * Director can close the crowdsale
166      */
167     function closeSale() public onlyDirector returns (bool success) {
168         // The sale must be currently open
169         require(!saleClosed);
170         
171         // Lock the crowdsale
172         saleClosed = true;
173         return true;
174     }
175 
176     /**
177      * Director can open the crowdsale
178      */
179     function openSale() public onlyDirector returns (bool success) {
180         // The sale must be currently closed
181         require(saleClosed);
182         
183         // Unlock the crowdsale
184         saleClosed = false;
185         return true;
186     }
187     
188     /**
189      * Oyster Protocol Function
190      * More information at https://oyster.ws/OysterWhitepaper.pdf
191      * 
192      * Bury an address
193      *
194      * When an address is buried; only claimAmount can be withdrawn once per epoch
195      */
196     function bury() public returns (bool success) {
197         // The address must be previously unburied
198         require(!buried[msg.sender]);
199         
200         // An address must have at least claimAmount to be buried
201         require(balances[msg.sender] >= claimAmount);
202         
203         // Prevent addresses with large balances from getting buried
204         require(balances[msg.sender] <= retentionMax);
205         
206         // Set buried state to true
207         buried[msg.sender] = true;
208         
209         // Set the initial claim clock to 1
210         claimed[msg.sender] = 1;
211         
212         // Execute an event reflecting the change
213         Bury(msg.sender, balances[msg.sender]);
214         return true;
215     }
216     
217     /**
218      * Oyster Protocol Function
219      * More information at https://oyster.ws/OysterWhitepaper.pdf
220      * 
221      * Claim PRL from a buried address
222      *
223      * If a prior claim wasn't made during the current epoch, then claimAmount can be withdrawn
224      *
225      * @param _payout the address of the website owner
226      * @param _fee the address of the broker node
227      */
228     function claim(address _payout, address _fee) public returns (bool success) {
229         // The claimed address must have already been buried
230         require(buried[msg.sender]);
231         
232         // The payout and fee addresses must be different
233         require(_payout != _fee);
234         
235         // The claimed address cannot pay itself
236         require(msg.sender != _payout);
237         
238         // The claimed address cannot pay itself
239         require(msg.sender != _fee);
240         
241         // It must be either the first time this address is being claimed or atleast epoch in time has passed
242         require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);
243         
244         // Check if the buried address has enough
245         require(balances[msg.sender] >= claimAmount);
246         
247         // Reset the claim clock to the current block time
248         claimed[msg.sender] = block.timestamp;
249         
250         // Save this for an assertion in the future
251         uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];
252         
253         // Remove claimAmount from the buried address
254         balances[msg.sender] -= claimAmount;
255         
256         // Pay the website owner that invoked the web node that found the PRL seed key
257         balances[_payout] += payAmount;
258         
259         // Pay the broker node that unlocked the PRL
260         balances[_fee] += feeAmount;
261         
262         // Execute events to reflect the changes
263         Claim(msg.sender, _payout, _fee);
264         Transfer(msg.sender, _payout, payAmount);
265         Transfer(msg.sender, _fee, feeAmount);
266         
267         // Failsafe logic that should never be false
268         assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);
269         return true;
270     }
271     
272     /**
273      * Crowdsale function
274      */
275     function () public payable {
276         // Check if crowdsale is still active
277         require(!saleClosed);
278         
279         // Minimum amount is 1 finney
280         require(msg.value >= 1 finney);
281         
282         // Price is 1 ETH = 5000 PRL
283         uint256 amount = msg.value * 5000;
284         
285         // totalSupply limit is 500 million PRL
286         require(totalSupply + amount <= (500000000 * 10 ** uint256(decimals)));
287         
288         // Increases the total supply
289         totalSupply += amount;
290         
291         // Adds the amount to the balance
292         balances[msg.sender] += amount;
293         
294         // Track ETH amount raised
295         funds += msg.value;
296         
297         // Execute an event reflecting the change
298         Transfer(this, msg.sender, amount);
299     }
300 
301     /**
302      * Internal transfer, can be called by this contract only
303      */
304     function _transfer(address _from, address _to, uint _value) internal {
305         // Sending addresses cannot be buried
306         require(!buried[_from]);
307         
308         // If the receiving address is buried, it cannot exceed retentionMax
309         if (buried[_to]) {
310             require(balances[_to] + _value <= retentionMax);
311         }
312         
313         // Prevent transfer to 0x0 address, use burn() instead
314         require(_to != 0x0);
315         
316         // Check if the sender has enough
317         require(balances[_from] >= _value);
318         
319         // Check for overflows
320         require(balances[_to] + _value > balances[_to]);
321         
322         // Save this for an assertion in the future
323         uint256 previousBalances = balances[_from] + balances[_to];
324         
325         // Subtract from the sender
326         balances[_from] -= _value;
327         
328         // Add the same to the recipient
329         balances[_to] += _value;
330         Transfer(_from, _to, _value);
331         
332         // Failsafe logic that should never be false
333         assert(balances[_from] + balances[_to] == previousBalances);
334     }
335 
336     /**
337      * Transfer tokens
338      *
339      * Send `_value` tokens to `_to` from your account
340      *
341      * @param _to the address of the recipient
342      * @param _value the amount to send
343      */
344     function transfer(address _to, uint256 _value) public {
345         _transfer(msg.sender, _to, _value);
346     }
347 
348     /**
349      * Transfer tokens from other address
350      *
351      * Send `_value` tokens to `_to` in behalf of `_from`
352      *
353      * @param _from the address of the sender
354      * @param _to the address of the recipient
355      * @param _value the amount to send
356      */
357     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
358         // Check allowance
359         require(_value <= allowance[_from][msg.sender]);
360         allowance[_from][msg.sender] -= _value;
361         _transfer(_from, _to, _value);
362         return true;
363     }
364 
365     /**
366      * Set allowance for other address
367      *
368      * Allows `_spender` to spend no more than `_value` tokens on your behalf
369      *
370      * @param _spender the address authorized to spend
371      * @param _value the max amount they can spend
372      */
373     function approve(address _spender, uint256 _value) public returns (bool success) {
374         // Buried addresses cannot be approved
375         require(!buried[msg.sender]);
376         
377         allowance[msg.sender][_spender] = _value;
378         Approval(msg.sender, _spender, _value);
379         return true;
380     }
381 
382     /**
383      * Set allowance for other address and notify
384      *
385      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
386      *
387      * @param _spender the address authorized to spend
388      * @param _value the max amount they can spend
389      * @param _extraData some extra information to send to the approved contract
390      */
391     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
392         tokenRecipient spender = tokenRecipient(_spender);
393         if (approve(_spender, _value)) {
394             spender.receiveApproval(msg.sender, _value, this, _extraData);
395             return true;
396         }
397     }
398 
399     /**
400      * Destroy tokens
401      *
402      * Remove `_value` tokens from the system irreversibly
403      *
404      * @param _value the amount of money to burn
405      */
406     function burn(uint256 _value) public returns (bool success) {
407         // Buried addresses cannot be burnt
408         require(!buried[msg.sender]);
409         
410         // Check if the sender has enough
411         require(balances[msg.sender] >= _value);
412         
413         // Subtract from the sender
414         balances[msg.sender] -= _value;
415         
416         // Updates totalSupply
417         totalSupply -= _value;
418         Burn(msg.sender, _value);
419         return true;
420     }
421 
422     /**
423      * Destroy tokens from other account
424      *
425      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
426      *
427      * @param _from the address of the sender
428      * @param _value the amount of money to burn
429      */
430     function burnFrom(address _from, uint256 _value) public returns (bool success) {
431         // Buried addresses cannot be burnt
432         require(!buried[_from]);
433         
434         // Check if the targeted balance is enough
435         require(balances[_from] >= _value);
436         
437         // Check allowance
438         require(_value <= allowance[_from][msg.sender]);
439         
440         // Subtract from the targeted balance
441         balances[_from] -= _value;
442         
443         // Subtract from the sender's allowance
444         allowance[_from][msg.sender] -= _value;
445         
446         // Update totalSupply
447         totalSupply -= _value;
448         Burn(_from, _value);
449         return true;
450     }
451 }