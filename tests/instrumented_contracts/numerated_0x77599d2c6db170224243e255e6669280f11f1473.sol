1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Opacity {
6   // Public variables of OPQ
7   string public name;
8   string public symbol;
9   uint8 public decimals;
10   uint256 public totalSupply;
11   uint256 public funds;
12   address public director;
13   bool public directorLock;
14   uint256 public claimAmount;
15   uint256 public payAmount;
16   uint256 public feeAmount;
17   uint256 public epoch;
18   uint256 public retentionMax;
19 
20   // Array definitions
21   mapping (address => uint256) public balances;
22   mapping (address => mapping (address => uint256)) public allowance;
23   mapping (address => bool) public buried;
24   mapping (address => uint256) public claimed;
25 
26   // ERC20 event
27   event Transfer(address indexed _from, address indexed _to, uint256 _value);
28 
29   // ERC20 event
30   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 
32   // This notifies clients about the amount burnt
33   event Burn(address indexed _from, uint256 _value);
34 
35   // This notifies clients about an address getting buried
36   event Bury(address indexed _target, uint256 _value);
37 
38   // This notifies clients about a claim being made on a buried address
39   event Claim(address indexed _target, address indexed _payout, address indexed _fee);
40 
41   /**
42    * Constructor function
43    *
44    * Initializes contract
45    */
46   function Opacity() public payable {
47     director = msg.sender;
48     name = "Opacity";
49     symbol = "OPQ";
50     decimals = 18;
51     directorLock = false;
52     funds = 0;
53     totalSupply = 130000000 * 10 ** uint256(decimals);
54 
55     // Assign reserved OPQ supply to the director
56     balances[director] = totalSupply;
57 
58     // Define default values for Opacity functions
59     claimAmount = 5 * 10 ** (uint256(decimals) - 1);
60     payAmount = 4 * 10 ** (uint256(decimals) - 1);
61     feeAmount = 1 * 10 ** (uint256(decimals) - 1);
62 
63     // Seconds in a year
64     epoch = 31536000;
65 
66     // Maximum time for a sector to remain stored
67     retentionMax = 40 * 10 ** uint256(decimals);
68   }
69 
70   /**
71    * ERC20 balance function
72    */
73   function balanceOf(address _owner) public constant returns (uint256 balance) {
74     return balances[_owner];
75   }
76 
77   modifier onlyDirector {
78     // Director can lock themselves out to complete decentralization of Opacity
79     // An alternative is that another smart contract could become the decentralized director
80     require(!directorLock);
81 
82     // Only the director is permitted
83     require(msg.sender == director);
84     _;
85   }
86 
87   modifier onlyDirectorForce {
88     // Only the director is permitted
89     require(msg.sender == director);
90     _;
91   }
92 
93   /**
94    * Transfers the director to a new address
95    */
96   function transferDirector(address newDirector) public onlyDirectorForce {
97     director = newDirector;
98   }
99 
100   /**
101    * Withdraw funds from the contract
102    */
103   function withdrawFunds() public onlyDirectorForce {
104     director.transfer(this.balance);
105   }
106 
107   /**
108    * Permanently lock out the director to decentralize Opacity
109    * Invocation is discretionary because Opacity might be better suited to
110    * transition to an artificially intelligent smart contract director
111    */
112   function selfLock() public payable onlyDirector {
113 
114     // Prevents accidental lockout
115     require(msg.value == 10 ether);
116 
117     // Permanently lock out the director
118     directorLock = true;
119   }
120 
121   /**
122    * Director can alter the storage-peg and broker fees
123    */
124   function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet, uint8 accuracy) public onlyDirector returns (bool success) {
125     require(claimAmountSet == (payAmountSet + feeAmountSet));
126     require(payAmountSet < claimAmountSet);
127     require(feeAmountSet < claimAmountSet);
128     require(claimAmountSet > 0);
129     require(payAmountSet > 0);
130     require(feeAmountSet > 0);
131 
132     claimAmount = claimAmountSet * 10 ** (uint256(decimals) - accuracy);
133     payAmount = payAmountSet * 10 ** (uint256(decimals) - accuracy);
134     feeAmount = feeAmountSet * 10 ** (uint256(decimals) - accuracy);
135     return true;
136   }
137 
138   /**
139    * Director can alter the epoch time
140    */
141   function amendEpoch(uint256 epochSet) public onlyDirector returns (bool success) {
142     // Set the epoch
143     epoch = epochSet;
144     return true;
145   }
146 
147   /**
148    * Director can alter the maximum time of storage retention
149    */
150   function amendRetention(uint8 retentionSet, uint8 accuracy) public onlyDirector returns (bool success) {
151     // Set retentionMax
152     retentionMax = retentionSet * 10 ** (uint256(decimals) - accuracy);
153     return true;
154   }
155 
156   /**
157    * Bury an address
158    *
159    * When an address is buried; only claimAmount can be withdrawn once per epoch
160    */
161   function bury() public returns (bool success) {
162     // The address must be previously unburied
163     require(!buried[msg.sender]);
164 
165     // An address must have at least claimAmount to be buried
166     require(balances[msg.sender] >= claimAmount);
167 
168     // Prevent addresses with large balances from getting buried
169     require(balances[msg.sender] <= retentionMax);
170 
171     // Set buried state to true
172     buried[msg.sender] = true;
173 
174     // Set the initial claim clock to 1
175     claimed[msg.sender] = 1;
176 
177     // Execute an event reflecting the change
178     emit Bury(msg.sender, balances[msg.sender]);
179     return true;
180   }
181 
182   /**
183    * Claim OPQ from a buried address
184    *
185    * If a prior claim wasn't made during the current epoch, then claimAmount can be withdrawn
186    *
187    * @param _payout the address of the website owner
188    * @param _fee the address of the broker node
189    */
190   function claim(address _payout, address _fee) public returns (bool success) {
191     // The claimed address must have already been buried
192     require(buried[msg.sender]);
193 
194     // The payout and fee addresses must be different
195     require(_payout != _fee);
196 
197     // The claimed address cannot pay itself
198     require(msg.sender != _payout);
199 
200     // The claimed address cannot pay itself
201     require(msg.sender != _fee);
202 
203     // It must be either the first time this address is being claimed or atleast epoch in time has passed
204     require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);
205 
206     // Check if the buried address has enough
207     require(balances[msg.sender] >= claimAmount);
208 
209     // Reset the claim clock to the current block time
210     claimed[msg.sender] = block.timestamp;
211 
212     // Save this for an assertion in the future
213     uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];
214 
215     // Remove claimAmount from the buried address
216     balances[msg.sender] -= claimAmount;
217 
218     // Pay the website owner that invoked the web node that found the OPQ seed key
219     balances[_payout] += payAmount;
220 
221     // Pay the broker node that unlocked the OPQ
222     balances[_fee] += feeAmount;
223 
224     // Execute events to reflect the changes
225     emit Claim(msg.sender, _payout, _fee);
226     emit Transfer(msg.sender, _payout, payAmount);
227     emit Transfer(msg.sender, _fee, feeAmount);
228 
229     // Failsafe logic that should never be false
230     assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);
231     return true;
232   }
233 
234   /**
235    * Internal transfer, can be called by this contract only
236    */
237   function _transfer(address _from, address _to, uint _value) internal {
238     // Sending addresses cannot be buried
239     require(!buried[_from]);
240 
241     // If the receiving address is buried, it cannot exceed retentionMax
242     if (buried[_to]) {
243       require(balances[_to] + _value <= retentionMax);
244     }
245 
246     // Prevent transfer to 0x0 address, use burn() instead
247     require(_to != 0x0);
248 
249     // Check if the sender has enough
250     require(balances[_from] >= _value);
251 
252     // Check for overflows
253     require(balances[_to] + _value > balances[_to]);
254 
255     // Save this for an assertion in the future
256     uint256 previousBalances = balances[_from] + balances[_to];
257 
258     // Subtract from the sender
259     balances[_from] -= _value;
260 
261     // Add the same to the recipient
262     balances[_to] += _value;
263     emit Transfer(_from, _to, _value);
264 
265     // Failsafe logic that should never be false
266     assert(balances[_from] + balances[_to] == previousBalances);
267   }
268 
269   /**
270    * Transfer tokens
271    *
272    * Send `_value` tokens to `_to` from your account
273    *
274    * @param _to the address of the recipient
275    * @param _value the amount to send
276    */
277   function transfer(address _to, uint256 _value) public {
278     _transfer(msg.sender, _to, _value);
279   }
280 
281   /**
282    * Transfer tokens from other address
283    *
284    * Send `_value` tokens to `_to` in behalf of `_from`
285    *
286    * @param _from the address of the sender
287    * @param _to the address of the recipient
288    * @param _value the amount to send
289    */
290   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
291     // Check allowance
292     require(_value <= allowance[_from][msg.sender]);
293     allowance[_from][msg.sender] -= _value;
294     _transfer(_from, _to, _value);
295     return true;
296   }
297 
298   /**
299    * Set allowance for other address
300    *
301    * Allows `_spender` to spend no more than `_value` tokens on your behalf
302    *
303    * @param _spender the address authorized to spend
304    * @param _value the max amount they can spend
305    */
306   function approve(address _spender, uint256 _value) public returns (bool success) {
307     // Buried addresses cannot be approved
308     require(!buried[msg.sender]);
309 
310     allowance[msg.sender][_spender] = _value;
311     emit Approval(msg.sender, _spender, _value);
312     return true;
313   }
314 
315   /**
316    * Set allowance for other address and notify
317    *
318    * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
319    *
320    * @param _spender the address authorized to spend
321    * @param _value the max amount they can spend
322    * @param _extraData some extra information to send to the approved contract
323    */
324   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
325     tokenRecipient spender = tokenRecipient(_spender);
326     if (approve(_spender, _value)) {
327       spender.receiveApproval(msg.sender, _value, this, _extraData);
328       return true;
329     }
330   }
331 
332   /**
333    * Destroy tokens
334    *
335    * Remove `_value` tokens from the system irreversibly
336    *
337    * @param _value the amount of money to burn
338    */
339   function burn(uint256 _value) public returns (bool success) {
340     // Buried addresses cannot be burnt
341     require(!buried[msg.sender]);
342 
343     // Check if the sender has enough
344     require(balances[msg.sender] >= _value);
345 
346     // Subtract from the sender
347     balances[msg.sender] -= _value;
348 
349     // Updates totalSupply
350     totalSupply -= _value;
351     emit Burn(msg.sender, _value);
352     return true;
353   }
354 
355   /**
356    * Destroy tokens from other account
357    *
358    * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
359    *
360    * @param _from the address of the sender
361    * @param _value the amount of money to burn
362    */
363   function burnFrom(address _from, uint256 _value) public returns (bool success) {
364     // Buried addresses cannot be burnt
365     require(!buried[_from]);
366 
367     // Check if the targeted balance is enough
368     require(balances[_from] >= _value);
369 
370     // Check allowance
371     require(_value <= allowance[_from][msg.sender]);
372 
373     // Subtract from the targeted balance
374     balances[_from] -= _value;
375 
376     // Subtract from the sender's allowance
377     allowance[_from][msg.sender] -= _value;
378 
379     // Update totalSupply
380     totalSupply -= _value;
381     emit Burn(_from, _value);
382     return true;
383   }
384 }