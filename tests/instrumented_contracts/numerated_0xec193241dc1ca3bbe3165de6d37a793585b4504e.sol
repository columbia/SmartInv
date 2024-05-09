1 pragma solidity ^0.4.24;
2 
3  
4 
5 contract owned {
6 
7     address public owner;
8 
9     function owned() public {
10 
11         owner = msg.sender;
12 
13     }
14 
15     modifier onlyOwner {
16 
17         require(msg.sender == owner);
18 
19         _;
20 
21     }
22 
23  
24 
25     function transferOwnership(address newOwner) onlyOwner public {
26 
27         owner = newOwner;
28 
29     }
30 
31 }
32 
33  
34 
35 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
36 
37  
38 
39 contract TokenERC20 {
40 
41     // Public variables of the token
42 
43     string public name = 'Every Media Coin';
44 
45     string public symbol = 'EVE';
46 
47     uint256 public decimals = 18;
48 
49 
50     uint256 public totalSupply = 100000000 * (10 ** decimals);
51 
52  
53 
54     // This creates an array with all balances
55 
56     mapping (address => uint256) public balanceOf;
57 
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60  
61 
62     // This generates a public event on the blockchain that will notify clients
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66  
67 
68     // This notifies clients about the amount burnt
69 
70     event Burn(address indexed from, uint256 value);
71 
72  
73 
74     /**
75 
76      * Constrctor function
77 
78      *
79 
80      * Initializes contract with initial supply tokens to the creator of the contract
81 
82      */
83 
84     // function TokenERC20(
85 
86     //     uint256 initialSupply,
87 
88     //     string tokenName,
89 
90     //     string tokenSymbol
91 
92     // ) public {
93 
94     //     totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
95 
96     //     balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
97 
98     //     name = tokenName;                                   // Set the name for display purposes
99 
100     //     symbol = tokenSymbol;                               // Set the symbol for display purposes
101 
102     // }
103 
104  
105 
106     /**
107 
108      * Internal transfer, only can be called by this contract
109 
110      */
111 
112     function _transfer(address _from, address _to, uint _value) internal {
113 
114         // Prevent transfer to 0x0 address. Use burn() instead
115 
116         require(_to != 0x0);
117 
118         // Check if the sender has enough
119 
120         require(balanceOf[_from] >= _value);
121 
122         // Check for overflows
123 
124         require(balanceOf[_to] + _value > balanceOf[_to]);
125 
126         // Save this for an assertion in the future
127 
128         uint previousBalances = balanceOf[_from] + balanceOf[_to];
129 
130         // Subtract from the sender
131 
132         balanceOf[_from] -= _value;
133 
134         // Add the same to the recipient
135 
136         balanceOf[_to] += _value;
137 
138         Transfer(_from, _to, _value);
139 
140         // Asserts are used to use static analysis to find bugs in your code. They should never fail
141 
142         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
143 
144     }
145 
146  
147 
148     /**
149 
150      * Transfer tokens
151 
152      *
153 
154      * Send `_value` tokens to `_to` from your account
155 
156      *
157 
158      * @param _to The address of the recipient
159 
160      * @param _value the amount to send
161 
162      */
163 
164     function transfer(address _to, uint256 _value) public {
165 
166         _transfer(msg.sender, _to, _value);
167 
168     }
169 
170  
171 
172     /**
173 
174      * Transfer tokens from other address
175 
176      *
177 
178      * Send `_value` tokens to `_to` in behalf of `_from`
179 
180      *
181 
182      * @param _from The address of the sender
183 
184      * @param _to The address of the recipient
185 
186      * @param _value the amount to send
187 
188      */
189 
190     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
191 
192         require(_value <= allowance[_from][msg.sender]);     // Check allowance
193 
194         allowance[_from][msg.sender] -= _value;
195 
196         _transfer(_from, _to, _value);
197 
198         return true;
199 
200     }
201 
202  
203 
204     /**
205 
206      * Set allowance for other address
207 
208      *
209 
210      * Allows `_spender` to spend no more than `_value` tokens in your behalf
211 
212      *
213 
214      * @param _spender The address authorized to spend
215 
216      * @param _value the max amount they can spend
217 
218      */
219 
220     function approve(address _spender, uint256 _value) public
221 
222         returns (bool success) {
223 
224         allowance[msg.sender][_spender] = _value;
225 
226         return true;
227 
228     }
229 
230  
231 
232     /**
233 
234      * Set allowance for other address and notify
235 
236      *
237 
238      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
239 
240      *
241 
242      * @param _spender The address authorized to spend
243 
244      * @param _value the max amount they can spend
245 
246      * @param _extraData some extra information to send to the approved contract
247 
248      */
249 
250     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
251 
252         public
253 
254         returns (bool success) {
255 
256         tokenRecipient spender = tokenRecipient(_spender);
257 
258         if (approve(_spender, _value)) {
259 
260             spender.receiveApproval(msg.sender, _value, this, _extraData);
261 
262             return true;
263 
264         }
265 
266     }
267 
268  
269 
270     /**
271 
272      * Destroy tokens
273 
274      *
275 
276      * Remove `_value` tokens from the system irreversibly
277 
278      *
279 
280      * @param _value the amount of money to burn
281 
282      */
283 
284     function burn(uint256 _value) public returns (bool success) {
285 
286         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
287 
288         balanceOf[msg.sender] -= _value;            // Subtract from the sender
289 
290         totalSupply -= _value;                      // Updates totalSupply
291 
292         Burn(msg.sender, _value);
293 
294         return true;
295 
296     }
297 
298  
299 
300     /**
301 
302      * Destroy tokens from other account
303 
304      *
305 
306      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
307 
308      *
309 
310      * @param _from the address of the sender
311 
312      * @param _value the amount of money to burn
313 
314      */
315 
316     function burnFrom(address _from, uint256 _value) public returns (bool success) {
317 
318         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
319 
320         require(_value <= allowance[_from][msg.sender]);    // Check allowance
321 
322         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
323 
324         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
325 
326         totalSupply -= _value;                              // Update totalSupply
327 
328         Burn(_from, _value);
329 
330         return true;
331 
332     }
333 
334 }
335 
336  
337 
338 /******************************************/
339 
340 /*       ADVANCED TOKEN STARTS HERE       */
341 
342 /******************************************/
343 
344  
345 
346 contract MyAdvancedToken is owned, TokenERC20 {
347 
348  
349 
350     mapping (address => bool) public frozenAccount;
351 
352  
353 
354     /* This generates a public event on the blockchain that will notify clients */
355 
356     event FrozenFunds(address target, bool frozen);
357     
358     constructor() public {
359         balanceOf[msg.sender] = totalSupply;
360     }
361 
362  
363     /* Internal transfer, only can be called by this contract */
364 
365     function _transfer(address _from, address _to, uint _value) internal {
366 
367         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
368 
369         require (balanceOf[_from] >= _value);               // Check if the sender has enough
370 
371         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
372 
373         require(!frozenAccount[_from]);                     // Check if sender is frozen
374 
375         require(!frozenAccount[_to]);                       // Check if recipient is frozen
376 
377         balanceOf[_from] -= _value;                         // Subtract from the sender
378 
379         balanceOf[_to] += _value;                           // Add the same to the recipient
380 
381         Transfer(_from, _to, _value);
382 
383     }
384 
385  
386 
387     /// @notice Create `mintedAmount` tokens and send it to `target`
388 
389     /// @param target Address to receive the tokens
390 
391     /// @param mintedAmount the amount of tokens it will receive
392 
393     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
394 
395         balanceOf[target] += mintedAmount;
396 
397         totalSupply += mintedAmount;
398 
399         Transfer(0, this, mintedAmount);
400 
401         Transfer(this, target, mintedAmount);
402 
403     }
404 
405  
406 
407     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
408 
409     /// @param target Address to be frozen
410 
411     /// @param freeze either to freeze it or not
412 
413     function freezeAccount(address target, bool freeze) onlyOwner public {
414 
415         frozenAccount[target] = freeze;
416 
417         FrozenFunds(target, freeze);
418 
419     }
420 
421  
422  
423 
424 }