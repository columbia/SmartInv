1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract OysterShell {
6     // Public variables of SHL
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     uint256 public lockedSupply;
12     address public director;
13     bool public directorLock;
14     uint256 public feeAmount;
15     uint256 public retentionMin;
16     uint256 public retentionMax;
17     uint256 public lockMin;
18     uint256 public lockMax;
19 
20     // Array definitions
21     mapping (address => uint256) public balances;
22     mapping (address => mapping (address => uint256)) public allowance;
23     mapping (address => uint256) public locked;
24 
25     // ERC20 event
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     
28     // ERC20 event
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31     // This notifies clients about the amount burnt
32     event Burn(address indexed _from, uint256 _value);
33     
34     // This notifies clients about an address getting locked
35     event Lock(address indexed _target, uint256 _value, uint256 _release);
36     
37     // This notifies clients about a claim being made on a locked address
38     event Claim(address indexed _target, address indexed _payout, address indexed _fee);
39 
40     /**
41      * Constructor function
42      *
43      * Initializes contract
44      */
45     function OysterShell() public {
46         director = msg.sender;
47         name = "Oyster Shell";
48         symbol = "SHL";
49         decimals = 18;
50         directorLock = false;
51         totalSupply = 98592692 * 10 ** uint256(decimals);
52         lockedSupply = 0;
53         
54         // Assign total SHL supply to the director
55         balances[director] = totalSupply;
56         
57         // SHL fee paid to brokers
58         feeAmount = 1 * 10 ** uint256(decimals);
59         
60         // Minimum SHL that can get locked
61         retentionMin = 20 * 10 ** uint256(decimals);
62         
63         // Maximum SHL that can get locked
64         retentionMax = 200 * 10 ** uint256(decimals);
65         
66         // Minimum lock duration
67         lockMin = 10;
68         
69         // Maximum lock duration
70         lockMax = 360;
71     }
72     
73     /**
74      * ERC20 balance function
75      */
76     function balanceOf(address _owner) public constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79     
80     /**
81      * SHL lock time retrieval function
82      */
83     function lockTime(address _owner) public constant returns (uint256 lockedValue) {
84         return locked[_owner];
85     }
86     
87     modifier onlyDirector {
88         // Director can lock themselves out to complete decentralization of Oyster network
89         // An alternative is that another smart contract could become the decentralized director
90         require(!directorLock);
91         
92         // Only the director is permitted
93         require(msg.sender == director);
94         _;
95     }
96     
97     modifier onlyDirectorForce {
98         // Only the director is permitted
99         require(msg.sender == director);
100         _;
101     }
102     
103     /**
104      * Transfers the director to a new address
105      */
106     function transferDirector(address newDirector) public onlyDirectorForce {
107         director = newDirector;
108     }
109     
110     /**
111      * Withdraw funds from the contract
112      */
113     function withdrawFunds() public onlyDirectorForce {
114         director.transfer(this.balance);
115     }
116     
117     /**
118      * Permanently lock out the director to decentralize Oyster
119      * Invocation is discretionary because Oyster might be better suited to
120      * transition to an artificially intelligent smart contract director
121      */
122     function selfLock() public payable onlyDirector {
123         // Prevents accidental lockout
124         require(msg.value == 10 ether);
125         
126         // Permanently lock out the director
127         directorLock = true;
128     }
129     
130     /**
131      * Director can alter the broker fee rate
132      */
133     function amendFee(uint256 feeAmountSet) public onlyDirector returns (bool success) {
134         feeAmount = feeAmountSet;
135         return true;
136     }
137     
138     /**
139      * Director can alter the upper and lower bounds of SHL locking capacity
140      */
141     function amendRetention(uint256 retentionMinSet, uint256 retentionMaxSet) public onlyDirector returns (bool success) {
142         // Set retentionMin
143         retentionMin = retentionMinSet;
144         
145         // Set retentionMax
146         retentionMax = retentionMaxSet;
147         return true;
148     }
149     
150     /**
151      * Director can alter the upper and lower bounds of SHL locking duration
152      */
153     function amendLock(uint256 lockMinSet, uint256 lockMaxSet) public onlyDirector returns (bool success) {
154         // Set lockMin
155         lockMin = lockMinSet;
156         
157         // Set lockMax
158         lockMax = lockMaxSet;
159         return true;
160     }
161     
162     /**
163      * Oyster Protocol Function
164      * More information at https://oyster.ws/ShellWhitepaper.pdf
165      * 
166      * Lock an address
167      *
168      * @param _duration the time duration that the SHL should remain locked
169      */
170     function lock(uint256 _duration) public returns (bool success) {
171         // The address must be previously unlocked
172         require(locked[msg.sender] == 0);
173         
174         // An address must have at least retentionMin to be locked
175         require(balances[msg.sender] >= retentionMin);
176         
177         // Prevent addresses with large balances from getting locked
178         require(balances[msg.sender] <= retentionMax);
179         
180         // Enforce minimum lock duration
181         require(_duration >= lockMin);
182         
183         // Enforce maximum lock duration
184         require(_duration <= lockMax);
185         
186         // Set locked state to true
187         locked[msg.sender] = block.timestamp + _duration;
188         
189         // Add to lockedSupply
190         lockedSupply += balances[msg.sender];
191         
192         // Execute an event reflecting the change
193         Lock(msg.sender, balances[msg.sender], locked[msg.sender]);
194         return true;
195     }
196     
197     /**
198      * Oyster Protocol Function
199      * More information at https://oyster.ws/ShellWhitepaper.pdf
200      * 
201      * Claim all SHL from a locked address
202      *
203      * @param _payout the address of the website owner
204      * @param _fee the address of the broker node
205      */
206     function claim(address _payout, address _fee) public returns (bool success) {
207         // The claimed address must have already been locked
208         require(locked[msg.sender] <= block.timestamp && locked[msg.sender] != 0);
209         
210         // The payout and fee addresses must be different
211         require(_payout != _fee);
212         
213         // The claimed address cannot pay itself
214         require(msg.sender != _payout);
215         
216         // The claimed address cannot pay itself
217         require(msg.sender != _fee);
218         
219         // Check if the locked address has enough
220         require(balances[msg.sender] >= retentionMin);
221         
222         // Save this for an assertion in the future
223         uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];
224         
225         // Calculate amount to be paid to _payout
226         uint256 payAmount = balances[msg.sender] - feeAmount;
227         
228         // Take from lockedSupply
229         lockedSupply -= balances[msg.sender];
230         
231         // Reset locked address balance to zero
232         balances[msg.sender] = 0;
233         
234         // Pay the website owner that invoked the web node that found the SHL seed key
235         balances[_payout] += payAmount;
236         
237         // Pay the broker node that unlocked the SHL
238         balances[_fee] += feeAmount;
239         
240         // Execute events to reflect the changes
241         Claim(msg.sender, _payout, _fee);
242         Transfer(msg.sender, _payout, payAmount);
243         Transfer(msg.sender, _fee, feeAmount);
244         
245         // Failsafe logic that should never be false
246         assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);
247         return true;
248     }
249     
250     /**
251      * Crowdsale function
252      */
253     function () public payable {
254         // Prevent ETH from getting sent to contract
255         require(false);
256     }
257 
258     /**
259      * Internal transfer, can be called by this contract only
260      */
261     function _transfer(address _from, address _to, uint _value) internal {
262         // Sending addresses cannot be locked
263         require(locked[_from] == 0);
264         
265         // If the receiving address is locked, it cannot exceed retentionMax
266         if (locked[_to] > 0) {
267             require(balances[_to] + _value <= retentionMax);
268         }
269         
270         // Prevent transfer to 0x0 address, use burn() instead
271         require(_to != 0x0);
272         
273         // Check if the sender has enough
274         require(balances[_from] >= _value);
275         
276         // Check for overflows
277         require(balances[_to] + _value > balances[_to]);
278         
279         // Save this for an assertion in the future
280         uint256 previousBalances = balances[_from] + balances[_to];
281         
282         // Subtract from the sender
283         balances[_from] -= _value;
284         
285         // Add the same to the recipient
286         balances[_to] += _value;
287         Transfer(_from, _to, _value);
288         
289         // Failsafe logic that should never be false
290         assert(balances[_from] + balances[_to] == previousBalances);
291     }
292 
293     /**
294      * Transfer tokens
295      *
296      * Send `_value` tokens to `_to` from your account
297      *
298      * @param _to the address of the recipient
299      * @param _value the amount to send
300      */
301     function transfer(address _to, uint256 _value) public {
302         _transfer(msg.sender, _to, _value);
303     }
304 
305     /**
306      * Transfer tokens from other address
307      *
308      * Send `_value` tokens to `_to` in behalf of `_from`
309      *
310      * @param _from the address of the sender
311      * @param _to the address of the recipient
312      * @param _value the amount to send
313      */
314     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
315         // Check allowance
316         require(_value <= allowance[_from][msg.sender]);
317         allowance[_from][msg.sender] -= _value;
318         _transfer(_from, _to, _value);
319         return true;
320     }
321 
322     /**
323      * Set allowance for other address
324      *
325      * Allows `_spender` to spend no more than `_value` tokens on your behalf
326      *
327      * @param _spender the address authorized to spend
328      * @param _value the max amount they can spend
329      */
330     function approve(address _spender, uint256 _value) public returns (bool success) {
331         // Locked addresses cannot be approved
332         require(locked[msg.sender] == 0);
333         
334         allowance[msg.sender][_spender] = _value;
335         Approval(msg.sender, _spender, _value);
336         return true;
337     }
338 
339     /**
340      * Set allowance for other address and notify
341      *
342      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
343      *
344      * @param _spender the address authorized to spend
345      * @param _value the max amount they can spend
346      * @param _extraData some extra information to send to the approved contract
347      */
348     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
349         tokenRecipient spender = tokenRecipient(_spender);
350         if (approve(_spender, _value)) {
351             spender.receiveApproval(msg.sender, _value, this, _extraData);
352             return true;
353         }
354     }
355 
356     /**
357      * Destroy tokens
358      *
359      * Remove `_value` tokens from the system irreversibly
360      *
361      * @param _value the amount of money to burn
362      */
363     function burn(uint256 _value) public returns (bool success) {
364         // Locked addresses cannot be burnt
365         require(locked[msg.sender] == 0);
366         
367         // Check if the sender has enough
368         require(balances[msg.sender] >= _value);
369         
370         // Subtract from the sender
371         balances[msg.sender] -= _value;
372         
373         // Updates totalSupply
374         totalSupply -= _value;
375         Burn(msg.sender, _value);
376         return true;
377     }
378 
379     /**
380      * Destroy tokens from other account
381      *
382      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
383      *
384      * @param _from the address of the sender
385      * @param _value the amount of money to burn
386      */
387     function burnFrom(address _from, uint256 _value) public returns (bool success) {
388         // Locked addresses cannot be burnt
389         require(locked[_from] == 0);
390         
391         // Check if the targeted balance is enough
392         require(balances[_from] >= _value);
393         
394         // Check allowance
395         require(_value <= allowance[_from][msg.sender]);
396         
397         // Subtract from the targeted balance
398         balances[_from] -= _value;
399         
400         // Subtract from the sender's allowance
401         allowance[_from][msg.sender] -= _value;
402         
403         // Update totalSupply
404         totalSupply -= _value;
405         Burn(_from, _value);
406         return true;
407     }
408 }