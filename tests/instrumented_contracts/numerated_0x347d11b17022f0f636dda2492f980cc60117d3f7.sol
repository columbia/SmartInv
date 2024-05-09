1 pragma solidity ^0.4.24;
2 
3  
4 
5 contract owned {
6 
7     address public owner;
8 
9  
10 
11     constructor() public {
12 
13         owner = msg.sender;
14 
15     }
16 
17  
18 
19     modifier onlyOwner {
20 
21         require(msg.sender == owner);
22 
23         _;
24 
25     }
26 
27  
28 
29     function transferOwnership(address newOwner) onlyOwner public {
30 
31         owner = newOwner;
32 
33     }
34 
35 }
36 
37  
38 
39 interface tokenRecipient  { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
40 
41  
42 
43 contract TokenERC20 {
44 
45     // Public variables of the token
46 
47     string public name = 'Universal Medical Coin';
48 
49     string public symbol = 'UMC';
50 
51     uint8 public decimals = 18;
52 
53     // 18 decimals is the strongly suggested default, avoid changing it
54 
55     uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);
56 
57  
58 
59     // This creates an array with all balances
60 
61     mapping (address => uint256) public balanceOf;
62 
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     // This generates a public event on the blockchain that will notify clients
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69  
70     // This notifies clients about the amount burnt
71 
72     event Burn(address indexed from, uint256 value);
73 
74     constructor() internal {
75         
76         balanceOf[msg.sender] = totalSupply;
77         
78     }
79 
80 
81     /**
82 
83      * Internal transfer, only can be called by this contract
84 
85      */
86 
87     function _transfer(address _from, address _to, uint _value) internal {
88 
89         // Prevent transfer to 0x0 address. Use burn() instead
90 
91         require(_to != 0x0);
92 
93         // Check if the sender has enough
94 
95         require(balanceOf[_from] >= _value);
96 
97         // Check for overflows
98 
99         require(balanceOf[_to] + _value > balanceOf[_to]);
100 
101         // Save this for an assertion in the future
102 
103         uint previousBalances = balanceOf[_from] + balanceOf[_to];
104 
105         // Subtract from the sender
106 
107         balanceOf[_from] -= _value;
108 
109         // Add the same to the recipient
110 
111         balanceOf[_to] += _value;
112 
113         emit Transfer(_from, _to, _value);
114 
115         // Asserts are used to use static analysis to find bugs in your code. They should never fail
116 
117         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
118 
119     }
120 
121  
122 
123     /**
124 
125      * Transfer tokens
126 
127      *
128 
129      * Send `_value` tokens to `_to` from your account
130 
131      *
132 
133      * @param _to The address of the recipient
134 
135      * @param _value the amount to send
136 
137      */
138 
139     function transfer(address _to, uint256 _value) public {
140 
141         _transfer(msg.sender, _to, _value);
142 
143     }
144 
145  
146 
147     /**
148 
149      * Transfer tokens from other address
150 
151      *
152 
153      * Send `_value` tokens to `_to` in behalf of `_from`
154 
155      *
156 
157      * @param _from The address of the sender
158 
159      * @param _to The address of the recipient
160 
161      * @param _value the amount to send
162 
163      */
164 
165     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
166 
167         require(_value <= allowance[_from][msg.sender]);     // Check allowance
168 
169         allowance[_from][msg.sender] -= _value;
170 
171         _transfer(_from, _to, _value);
172 
173         return true;
174 
175     }
176 
177  
178 
179     /**
180 
181      * Set allowance for other address
182 
183      *
184 
185      * Allows `_spender` to spend no more than `_value` tokens in your behalf
186 
187      *
188 
189      * @param _spender The address authorized to spend
190 
191      * @param _value the max amount they can spend
192 
193      */
194 
195     function approve(address _spender, uint256 _value) public
196 
197         returns (bool success) {
198 
199         allowance[msg.sender][_spender] = _value;
200 
201         return true;
202 
203     }
204 
205  
206 
207     /**
208 
209      * Set allowance for other address and notify
210 
211      *
212 
213      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
214 
215      *
216 
217      * @param _spender The address authorized to spend
218 
219      * @param _value the max amount they can spend
220 
221      * @param _extraData some extra information to send to the approved contract
222 
223      */
224 
225     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
226 
227         public
228 
229         returns (bool success) {
230 
231         tokenRecipient spender = tokenRecipient(_spender);
232 
233         if (approve(_spender, _value)) {
234 
235             spender.receiveApproval(msg.sender, _value, this, _extraData);
236 
237             return true;
238 
239         }
240 
241     }
242 
243  
244 
245     /**
246 
247      * Destroy tokens
248 
249      *
250 
251      * Remove `_value` tokens from the system irreversibly
252 
253      *
254 
255      * @param _value the amount of money to burn
256 
257      */
258 
259     function burn(uint256 _value) public returns (bool success) {
260 
261         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
262 
263         balanceOf[msg.sender] -= _value;            // Subtract from the sender
264 
265         totalSupply -= _value;                      // Updates totalSupply
266 
267         emit Burn(msg.sender, _value);
268 
269         return true;
270 
271     }
272 
273  
274 
275     /**
276 
277      * Destroy tokens from other account
278 
279      *
280 
281      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
282 
283      *
284 
285      * @param _from the address of the sender
286 
287      * @param _value the amount of money to burn
288 
289      */
290 
291     function burnFrom(address _from, uint256 _value) public returns (bool success) {
292 
293         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
294 
295         require(_value <= allowance[_from][msg.sender]);    // Check allowance
296 
297         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
298 
299         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
300 
301         totalSupply -= _value;                              // Update totalSupply
302 
303         emit Burn(_from, _value);
304 
305         return true;
306 
307     }
308 
309 }
310 
311  
312 
313 /******************************************/
314 
315 /*       ADVANCED TOKEN STARTS HERE       */
316 
317 /******************************************/
318 
319  
320 
321 contract MyAdvancedToken is owned, TokenERC20 {
322 
323  
324 
325     uint256 public sellPrice;
326 
327     uint256 public buyPrice;
328 
329  
330 
331     mapping (address => bool) public frozenAccount;
332 
333  
334 
335     /* This generates a public event on the blockchain that will notify clients */
336 
337     event FrozenFunds(address target, bool frozen);
338 
339 
340 
341     /* Internal transfer, only can be called by this contract */
342 
343     function _transfer(address _from, address _to, uint _value) internal {
344 
345         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
346 
347         require (balanceOf[_from] >= _value);               // Check if the sender has enough
348 
349         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
350 
351         require(!frozenAccount[_from]);                     // Check if sender is frozen
352 
353         require(!frozenAccount[_to]);                       // Check if recipient is frozen
354 
355         balanceOf[_from] -= _value;                         // Subtract from the sender
356 
357         balanceOf[_to] += _value;                           // Add the same to the recipient
358 
359         emit Transfer(_from, _to, _value);
360 
361     }
362 
363 
364     /// @notice Create `mintedAmount` tokens and send it to `target`
365 
366     /// @param target Address to receive the tokens
367 
368     /// @param mintedAmount the amount of tokens it will receive
369 
370     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
371 
372         balanceOf[target] += mintedAmount;
373 
374         totalSupply += mintedAmount;
375 
376         emit Transfer(0, this, mintedAmount);
377 
378         emit Transfer(this, target, mintedAmount);
379 
380     }
381 
382 
383     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
384 
385     /// @param target Address to be frozen
386 
387     /// @param freeze either to freeze it or not
388 
389     function freezeAccount(address target, bool freeze) onlyOwner public {
390 
391         frozenAccount[target] = freeze;
392 
393         emit FrozenFunds(target, freeze);
394 
395     }
396 
397  
398 
399 }