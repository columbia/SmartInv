1 /**
2  * ERC-20 Standard Token Smart Contract implementation.
3  * 
4  * Copyright © 2017 by Hive Project Ltd.
5  *
6  * Licensed under the Apache License, Version 2.0 (the "License").
7  * You may not use this file except in compliance with the License.
8  *
9  * Unless required by applicable law or agreed to in writing, software
10  * distributed under the License is distributed on an "AS IS" BASIS,
11  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
12  */
13 
14 pragma solidity ^0.4.11;
15 
16 /**
17  * ERC-20 Standard Token Smart Contract Interface.
18  *
19  * Copyright © 2017 by Hive Project Ltd.
20  *
21  * Licensed under the Apache License, Version 2.0 (the "License").
22  * You may not use this file except in compliance with the License.
23  *
24  * Unless required by applicable law or agreed to in writing, software
25  * distributed under the License is distributed on an "AS IS" BASIS,
26  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
27  */
28 
29 
30 /**
31  * ERC-20 standard token interface, as defined
32  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
33  */
34 contract ERC20Interface {
35   /**
36    * Get total number of tokens in circulation.
37    */
38   uint256 public totalSupply;
39 
40   /**
41    * @dev Get number of tokens currently belonging to given owner.
42    *
43    * @param _owner address to get number of tokens currently belonging to the
44    *         owner of
45    * @return number of tokens currently belonging to the owner of given address
46    */
47   function balanceOf (address _owner) constant returns (uint256 balance);
48 
49   /**
50    * @dev Transfer given number of tokens from message sender to given recipient.
51    *
52    * @param _to address to transfer tokens to the owner of
53    * @param _value number of tokens to transfer to the owner of given address
54    * @return true if tokens were transferred successfully, false otherwise
55    */
56   function transfer (address _to, uint256 _value) returns (bool success);
57 
58   /**
59    * @dev Transfer given number of tokens from given owner to given recipient.
60    *
61    * @param _from address to transfer tokens from the owner of
62    * @param _to address to transfer tokens to the owner of
63    * @param _value number of tokens to transfer from given owner to given
64    *         recipient
65    * @return true if tokens were transferred successfully, false otherwise
66    */
67   function transferFrom (address _from, address _to, uint256 _value)
68   returns (bool success);
69 
70   /**
71    * @dev Allow given spender to transfer given number of tokens from message sender.
72    *
73    * @param _spender address to allow the owner of to transfer tokens from
74    *         message sender
75    * @param _value number of tokens to allow to transfer
76    * @return true if token transfer was successfully approved, false otherwise
77    */
78   function approve (address _spender, uint256 _value) returns (bool success);
79 
80   /**
81    * @dev Tell how many tokens given spender is currently allowed to transfer from
82    * given owner.
83    *
84    * @param _owner address to get number of tokens allowed to be transferred
85    *        from the owner of
86    * @param _spender address to get number of tokens allowed to be transferred
87    *        by the owner of
88    * @return number of tokens given spender is currently allowed to transfer
89    *         from given owner
90    */
91   function allowance (address _owner, address _spender) constant
92   returns (uint256 remaining);
93 
94   /**
95    * @dev Logged when tokens were transferred from one owner to another.
96    *
97    * @param _from address of the owner, tokens were transferred from
98    * @param _to address of the owner, tokens were transferred to
99    * @param _value number of tokens transferred
100    */
101   event Transfer (address indexed _from, address indexed _to, uint256 _value);
102 
103   /**
104    * @dev Logged when owner approved his tokens to be transferred by some spender.
105    *
106    * @param _owner owner who approved his tokens to be transferred
107    * @param _spender spender who were allowed to transfer the tokens belonging
108    *        to the owner
109    * @param _value number of tokens belonging to the owner, approved to be
110    *        transferred by the spender
111    */
112   event Approval (
113     address indexed _owner, address indexed _spender, uint256 _value);
114 }
115 
116 
117 contract Owned {
118     address public owner;
119     address public newOwner;
120 
121     function Owned() {
122         owner = msg.sender;
123     }
124 
125     modifier ownerOnly {
126         assert(msg.sender == owner);
127         _;
128     }
129 
130     /**
131      * @dev Transfers ownership. New owner has to accept in order ownership change to take effect
132      */
133     function transferOwnership(address _newOwner) public ownerOnly {
134         require(_newOwner != owner);
135         newOwner = _newOwner;
136     }
137 
138     /**
139      * @dev Accepts transferred ownership
140      */
141     function acceptOwnership() public {
142         require(msg.sender == newOwner);
143         OwnerUpdate(owner, newOwner);
144         owner = newOwner;
145         newOwner = 0x0;
146     }
147 
148     event OwnerUpdate(address _prevOwner, address _newOwner);
149 }
150 
151 /**
152  * Safe Math Smart Contract.  
153  * 
154  * Copyright © 2017 by Hive Project Ltd.
155  *
156  * Licensed under the Apache License, Version 2.0 (the "License").
157  * You may not use this file except in compliance with the License.
158  *
159  * Unless required by applicable law or agreed to in writing, software
160  * distributed under the License is distributed on an "AS IS" BASIS,
161  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
162  */
163  
164 
165 /**
166  * Provides methods to safely add, subtract and multiply uint256 numbers.
167  */
168 contract SafeMath {
169  
170   /**
171    * @dev Add two uint256 values, throw in case of overflow.
172    *
173    * @param a first value to add
174    * @param b second value to add
175    * @return x + y
176    */
177     function add(uint256 a, uint256 b) internal constant returns (uint256) {
178         uint256 c = a + b;
179         assert(c >= a);
180         return c;
181     }
182 
183   /**
184    * @dev Subtract one uint256 value from another, throw in case of underflow.
185    *
186    * @param a value to subtract from
187    * @param b value to subtract
188    * @return a - b
189    */
190     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
191         assert(b <= a);
192         return a - b;
193     }
194 
195 
196   /**
197    * @dev Multiply two uint256 values, throw in case of overflow.
198    *
199    * @param a first value to multiply
200    * @param b second value to multiply
201    * @return c = a * b
202    */
203     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
204         uint256 c = a * b;
205         assert(a == 0 || c / a == b);
206         return c;
207     }
208 
209  /**
210    * @dev Divide two uint256 values, throw in case of overflow.
211    *
212    * @param a first value to divide
213    * @param b second value to divide
214    * @return c = a / b
215    */
216         function div(uint256 a, uint256 b) internal constant returns (uint256) {
217         uint256 c = a / b;
218         return c;
219     }
220 }
221 
222 /*
223  * TokenRecepient
224  *
225  * Copyright © 2017 by Hive Project Ltd.
226  *
227  * Licensed under the Apache License, Version 2.0 (the "License").
228  * You may not use this file except in compliance with the License.
229  *
230  * Unless required by applicable law or agreed to in writing, software
231  * distributed under the License is distributed on an "AS IS" BASIS,
232  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
233  */
234 
235 
236 contract TokenRecipient {
237     /**
238      * receive approval
239      */
240     function receiveApproval(address _from, uint256 _value, address _to, bytes _extraData);
241 }
242 
243 /**
244  * Standard Token Smart Contract that implements ERC-20 token interface
245  */
246 contract HVNToken is ERC20Interface, SafeMath, Owned {
247 
248     mapping (address => uint256) balances;
249     mapping (address => mapping (address => uint256)) allowed;
250     string public constant name = "Hive Project Token";
251     string public constant symbol = "HVN";
252     uint8 public constant decimals = 8;
253     string public version = '0.0.2';
254 
255     bool public transfersFrozen = false;
256 
257     /**
258      * Protection against short address attack
259      */
260     modifier onlyPayloadSize(uint numwords) {
261         assert(msg.data.length == numwords * 32 + 4);
262         _;
263     }
264 
265     /**
266      * Check if transfers are on hold - frozen
267      */
268     modifier whenNotFrozen(){
269         if (transfersFrozen) revert();
270         _;
271     }
272 
273 
274     function HVNToken() ownerOnly {
275         totalSupply = 50000000000000000;
276         balances[owner] = totalSupply;
277     }
278 
279 
280     /**
281      * Freeze token transfers.
282      */
283     function freezeTransfers () ownerOnly {
284         if (!transfersFrozen) {
285             transfersFrozen = true;
286             Freeze (msg.sender);
287         }
288     }
289 
290 
291     /**
292      * Unfreeze token transfers.
293      */
294     function unfreezeTransfers () ownerOnly {
295         if (transfersFrozen) {
296             transfersFrozen = false;
297             Unfreeze (msg.sender);
298         }
299     }
300 
301 
302     /**
303      * Transfer sender's tokens to a given address
304      */
305     function transfer(address _to, uint256 _value) whenNotFrozen onlyPayloadSize(2) returns (bool success) {
306         require(_to != 0x0);
307 
308         balances[msg.sender] = sub(balances[msg.sender], _value);
309         balances[_to] += _value;
310         Transfer(msg.sender, _to, _value);
311         return true;
312     }
313 
314 
315     /**
316      * Transfer _from's tokens to _to's address
317      */
318     function transferFrom(address _from, address _to, uint256 _value) whenNotFrozen onlyPayloadSize(3) returns (bool success) {
319         require(_to != 0x0);
320         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
321 
322         balances[_from] = sub(balances[_from], _value);
323         balances[_to] += _value;
324         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
325         Transfer(_from, _to, _value);
326         return true;
327     }
328 
329 
330     /**
331      * Returns number of tokens owned by given address.
332      */
333     function balanceOf(address _owner) constant returns (uint256 balance) {
334         return balances[_owner];
335     }
336 
337 
338     /**
339      * Sets approved amount of tokens for spender.
340      */
341     function approve(address _spender, uint256 _value) returns (bool success) {
342         require(_value == 0 || allowed[msg.sender][_spender] == 0);
343         allowed[msg.sender][_spender] = _value;
344         Approval(msg.sender, _spender, _value);
345         return true;
346     }
347 
348 
349     /**
350      * Approve and then communicate the approved contract in a single transaction
351      */
352     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
353         TokenRecipient spender = TokenRecipient(_spender);
354         if (approve(_spender, _value)) {
355             spender.receiveApproval(msg.sender, _value, this, _extraData);
356             return true;
357         }
358     }
359 
360 
361     /**
362      * Returns number of allowed tokens for given address.
363      */
364     function allowance(address _owner, address _spender) onlyPayloadSize(2) constant returns (uint256 remaining) {
365         return allowed[_owner][_spender];
366     }
367 
368 
369     /**
370      * Peterson's Law Protection
371      * Claim tokens
372      */
373     function claimTokens(address _token) ownerOnly {
374         if (_token == 0x0) {
375             owner.transfer(this.balance);
376             return;
377         }
378 
379         HVNToken token = HVNToken(_token);
380         uint balance = token.balanceOf(this);
381         token.transfer(owner, balance);
382 
383         Transfer(_token, owner, balance);
384     }
385 
386 
387     event Freeze (address indexed owner);
388     event Unfreeze (address indexed owner);
389 }