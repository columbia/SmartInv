1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract OysterPearl {
6     // Public variables of PRL
7     string public name = "Oyster Pearl";
8     string public symbol = "TPRL";
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11     uint256 public funds = 0;
12     address public owner;
13     bool public saleClosed = true;
14     bool public ownerLock = false;
15     uint256 public claimAmount;
16     uint256 public payAmount;
17     uint256 public feeAmount;
18     uint256 public epoch;
19     uint256 public retentionMax;
20 
21     //this creates an array with all balances
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24     mapping (address => bool) public buried;
25     mapping (address => uint256) public claimed;
26 
27     //this generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     //this notifies clients about the amount burnt
31     event Burn(address indexed from, uint256 value);
32     
33     //this notifies clients about the an address getting buried
34     event Bury(address indexed target, uint256 value);
35     
36     //this notifies clients about a claim being made on a buried address
37     event Claim(address indexed target, address indexed payout, address indexed fee);
38 
39     /**
40      * Constructor function
41      *
42      * Initializes contract
43      */
44     function OysterPearl() public {
45         owner = msg.sender;
46         totalSupply = 0;
47         
48         // Marketing share (5%)
49         totalSupply += 25000000 * 10 ** uint256(decimals);
50         
51         // Devfund share (15%)
52         totalSupply += 75000000 * 10 ** uint256(decimals);
53         
54         // Allocation to match PREPRL supply
55         totalSupply += 1000000 * 10 ** uint256(decimals);
56         
57         // Assign reserved PRL supply to contract owner
58         balanceOf[owner] = totalSupply;
59         
60         claimAmount = 5 * 10 ** (uint256(decimals) - 1);
61         payAmount = 4 * 10 ** (uint256(decimals) - 1);
62         feeAmount = 1 * 10 ** (uint256(decimals) - 1);
63         
64         //seconds in a year 31556952
65         epoch = 60;
66         
67         //Maximum time for a sector to remain stored
68         retentionMax = 40 * 10 ** uint256(decimals);
69     }
70     
71     modifier onlyOwner {
72         // Owner can lock themselves out to complete decentralization of Oyster network
73         require(!ownerLock);
74         
75         // Lockout will occur eventually, guaranteeing Oyster decentralization
76         require(block.number < 8000000);
77         
78         // Only the contract owner is permitted
79         require(msg.sender == owner);
80         _;
81     }
82     
83     modifier onlyOwnerForce {
84         // Only the contract owner is permitted
85         require(msg.sender == owner);
86         _;
87     }
88     
89     /**
90      * Transfers the contract owner to a new address
91      */
92     function transferOwnership(address newOwner) public onlyOwnerForce {
93         owner = newOwner;
94     }
95     
96     /**
97      * Withdraw funds from the crowdsale
98      */
99     function withdrawFunds() public onlyOwnerForce {
100         owner.transfer(this.balance);
101     }
102     
103     /**
104      * Permanently lock out the contract owner to decentralize Oyster
105      */
106     function selfLock() public onlyOwner {
107         // The sale must be closed before the owner gets locked out
108         require(saleClosed);
109         // Permanently lock out the contract owner
110         ownerLock = true;
111     }
112     
113     /**
114      * Contract owner can alter the storage-peg and broker fees
115      */
116     function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet) public onlyOwner {
117         require(claimAmountSet == (payAmountSet + feeAmountSet));
118         
119         claimAmount = claimAmountSet * 10 ** (uint256(decimals) - 1);
120         payAmount = payAmountSet * 10 ** (uint256(decimals) - 1);
121         feeAmount = feeAmountSet * 10 ** (uint256(decimals) - 1);
122     }
123     
124     /**
125      * Contract owner can alter the epoch time
126      */
127     function amendEpoch(uint256 epochSet) public onlyOwner {
128         // Set the epoch
129         epoch = epochSet;
130     }
131     
132     /**
133      * Contract owner can alter the maximum storage retention
134      */
135     function amendRetention(uint8 retentionSet) public onlyOwner {
136         // Set RetentionMax
137         retentionMax = retentionSet * 10 ** uint256(decimals);
138     }
139     
140     /**
141      * Contract owner can close the crowdsale
142      */
143     function closeSale() public onlyOwner {
144         // The sale must be currently open
145         require(!saleClosed);
146         // Lock the crowdsale
147         saleClosed = true;
148     }
149 
150     /**
151      * Contract owner can open the crowdsale
152      */
153     function openSale() public onlyOwner {
154         // The sale must be currently closed
155         require(saleClosed);
156         // Unlock the crowdsale
157         saleClosed = false;
158     }
159     
160     /**
161      * Oyster Protocol Function
162      * More information at https://oyster.ws/OysterWhitepaper.pdf
163      * 
164      * Bury an address
165      *
166      * When an address is buried; only claimAmount can be withdrawn once per epoch
167      *
168      */
169     function bury() public {
170         // The address must be previously unburied
171         require(!buried[msg.sender]);
172         
173         // An address must have atleast claimAmount to be buried
174         require(balanceOf[msg.sender] > claimAmount);
175         
176         // Prevent addresses with large balances from getting buried
177         require(balanceOf[msg.sender] <= retentionMax);
178         
179         // Set buried state to true
180         buried[msg.sender] = true;
181         
182         // Set the initial claim clock to 1
183         claimed[msg.sender] = 1;
184         
185         // Execute an event reflecting the change
186         Bury(msg.sender, balanceOf[msg.sender]);
187     }
188     
189     /**
190      * Oyster Protocol Function
191      * More information at https://oyster.ws/OysterWhitepaper.pdf
192      * 
193      * Claim PRL from a buried address
194      *
195      * If a prior claim wasn't made during the current epoch
196      *
197      * @param _payout The address of the recipient
198      * @param _fee the amount to send
199      */
200     function claim(address _payout, address _fee) public {
201         // The claimed address must have already been buried
202         require(buried[msg.sender]);
203         
204         // The payout and fee addresses must be different
205         require(_payout != _fee);
206         
207         // The claimed address cannot pay itself
208         require(msg.sender != _payout);
209         
210         // The claimed address cannot pay itself
211         require(msg.sender != _fee);
212         
213         // It must be either the first time this address is being claimed or atleast epoch in time has passed
214         require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);
215         
216         // Check if the buried address has enough
217         require(balanceOf[msg.sender] >= claimAmount);
218         
219         // Reset the claim clock to the current time
220         claimed[msg.sender] = block.timestamp;
221         
222         // Save this for an assertion in the future
223         uint256 previousBalances = balanceOf[msg.sender] + balanceOf[_payout] + balanceOf[_fee];
224         
225         // Remove claimAmount from the buried address
226         balanceOf[msg.sender] -= claimAmount;
227         
228         // Pay the website owner that invoked the webnode that found the PRL seed key
229         balanceOf[_payout] += payAmount;
230         
231         // Pay the broker node that unlocked the PRL
232         balanceOf[_fee] += feeAmount;
233         
234         // Execute events to reflect the changes
235         Transfer(msg.sender, _payout, payAmount);
236         Transfer(msg.sender, _fee, feeAmount);
237         Claim(msg.sender, _payout, _fee);
238         
239         // Asserts are used to use static analysis to find bugs in your code, they should never fail
240         assert(balanceOf[msg.sender] + balanceOf[_payout] + balanceOf[_fee] == previousBalances);
241     }
242     
243     /**
244      * Crowdsale function
245      */
246     function () payable public {
247         // Check if crowdsale is still active
248         require(!saleClosed);
249         
250         // Minimum amount is 1 finney
251         require(msg.value >= 1 finney);
252         
253         // Price is 1 ETH = 5000 PRL
254         uint256 amount = msg.value * 5000;
255         
256         // totalSupply limit is 500 million PRL
257         require(totalSupply + amount <= (500000000 * 10 ** uint256(decimals)));
258         
259         // Increases the total supply
260         totalSupply += amount;
261         
262         // Adds the amount to buyer's balance
263         balanceOf[msg.sender] += amount;
264         
265         // Track ETH amount raised
266         funds += msg.value;
267         
268         // Execute an event reflecting the change
269         Transfer(this, msg.sender, amount);
270     }
271 
272     /**
273      * Internal transfer, only can be called by this contract
274      */
275     function _transfer(address _from, address _to, uint _value) internal {
276         // Sending addresses cannot be buried
277         require(!buried[_from]);
278         
279         // If the receiving addresse is buried, it cannot exceed retentionMax
280         if (buried[_to]) {
281             require(balanceOf[_to] + _value <= retentionMax);
282         }
283         
284         // Prevent transfer to 0x0 address. Use burn() instead
285         require(_to != 0x0);
286         
287         // Check if the sender has enough
288         require(balanceOf[_from] >= _value);
289         
290         // Check for overflows
291         require(balanceOf[_to] + _value > balanceOf[_to]);
292         
293         // Save this for an assertion in the future
294         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
295         
296         // Subtract from the sender
297         balanceOf[_from] -= _value;
298         
299         // Add the same to the recipient
300         balanceOf[_to] += _value;
301         Transfer(_from, _to, _value);
302         
303         // Asserts are used to use static analysis to find bugs in your code, they should never fail
304         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
305     }
306 
307     /**
308      * Transfer tokens
309      *
310      * Send `_value` tokens to `_to` from your account
311      *
312      * @param _to The address of the recipient
313      * @param _value the amount to send
314      */
315     function transfer(address _to, uint256 _value) public {
316         _transfer(msg.sender, _to, _value);
317     }
318 
319     /**
320      * Transfer tokens from other address
321      *
322      * Send `_value` tokens to `_to` in behalf of `_from`
323      *
324      * @param _from The address of the sender
325      * @param _to The address of the recipient
326      * @param _value the amount to send
327      */
328     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
329         // Check allowance
330         require(_value <= allowance[_from][msg.sender]);
331         allowance[_from][msg.sender] -= _value;
332         _transfer(_from, _to, _value);
333         return true;
334     }
335 
336     /**
337      * Set allowance for other address
338      *
339      * Allows `_spender` to spend no more than `_value` tokens in your behalf
340      *
341      * @param _spender The address authorized to spend
342      * @param _value the max amount they can spend
343      */
344     function approve(address _spender, uint256 _value) public
345         returns (bool success) {
346         // Buried addresses cannot be approved
347         require(!buried[_spender]);
348         
349         allowance[msg.sender][_spender] = _value;
350         return true;
351     }
352 
353     /**
354      * Set allowance for other address and notify
355      *
356      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
357      *
358      * @param _spender The address authorized to spend
359      * @param _value the max amount they can spend
360      * @param _extraData some extra information to send to the approved contract
361      */
362     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
363         public
364         returns (bool success) {
365         tokenRecipient spender = tokenRecipient(_spender);
366         if (approve(_spender, _value)) {
367             spender.receiveApproval(msg.sender, _value, this, _extraData);
368             return true;
369         }
370     }
371 
372     /**
373      * Destroy tokens
374      *
375      * Remove `_value` tokens from the system irreversibly
376      *
377      * @param _value the amount of money to burn
378      */
379     function burn(uint256 _value) public returns (bool success) {
380         // Buried addresses cannot be burnt
381         require(!buried[msg.sender]);
382         
383         // Check if the sender has enough
384         require(balanceOf[msg.sender] >= _value);
385         
386         // Subtract from the sender
387         balanceOf[msg.sender] -= _value;
388         
389         // Updates totalSupply
390         totalSupply -= _value;
391         Burn(msg.sender, _value);
392         return true;
393     }
394 
395     /**
396      * Destroy tokens from other account
397      *
398      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
399      *
400      * @param _from the address of the sender
401      * @param _value the amount of money to burn
402      */
403     function burnFrom(address _from, uint256 _value) public returns (bool success) {
404         // Buried addresses cannot be burnt
405         require(!buried[_from]);
406         
407         // Check if the targeted balance is enough
408         require(balanceOf[_from] >= _value);
409         
410         // Check allowance
411         require(_value <= allowance[_from][msg.sender]);
412         
413         // Subtract from the targeted balance
414         balanceOf[_from] -= _value;
415         
416         // Subtract from the sender's allowance
417         allowance[_from][msg.sender] -= _value;
418         
419         // Update totalSupply
420         totalSupply -= _value;
421         Burn(_from, _value);
422         return true;
423     }
424 }