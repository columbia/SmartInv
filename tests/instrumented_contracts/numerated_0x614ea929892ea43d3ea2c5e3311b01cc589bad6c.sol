1 pragma solidity ^0.4.15;
2 
3 /**
4  * Standard ERC20 token
5  *
6  * https://github.com/ethereum/EIPs/issues/20
7  * Based on code by FirstBlood:
8  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
9  *
10  * This is the token contract for Ethino, the first and only ERC20 Ethereum Casino.
11  * It utilizes Majoolr's TokenLib library to reduce custom source code surface
12  * area and increase overall security. Majoolr provides smart contract services
13  * and security reviews for contract deployments in addition to working on open
14  * source projects in the Ethereum community.
15  * For further information: ethino.com, majoolr.io
16  *
17  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
18  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
19  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
20  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
21  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
22  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
23  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
24  */
25 
26 contract ENOToken {
27   using TokenLib for TokenLib.TokenStorage;
28 
29   TokenLib.TokenStorage token;
30 
31   //This instance is for the ropsten testnet
32   function ENOToken(address owner, //0x10b98123f84703A5CB884d27058D3415e03f2f71
33                     string name, //Ethino
34                     string symbol, //ENO
35                     uint8 decimals, //18
36                     uint256 initialSupply, //20000000000000000000000000
37                     bool allowMinting) //false
38   {
39     token.init(owner, name, symbol, decimals, initialSupply, allowMinting);
40   }
41 
42   function owner() constant returns (address) {
43     return token.owner;
44   }
45 
46   function name() constant returns (string) {
47     return token.name;
48   }
49 
50   function symbol() constant returns (string) {
51     return token.symbol;
52   }
53 
54   function decimals() constant returns (uint8) {
55     return token.decimals;
56   }
57 
58   function initialSupply() constant returns (uint256) {
59     return token.INITIAL_SUPPLY;
60   }
61 
62   function totalSupply() constant returns (uint256) {
63     return token.totalSupply;
64   }
65 
66   function balanceOf(address who) constant returns (uint256) {
67     return token.balanceOf(who);
68   }
69 
70   function allowance(address owner, address spender) constant returns (uint256) {
71     return token.allowance(owner, spender);
72   }
73 
74   function transfer(address to, uint value) returns (bool ok) {
75     return token.transfer(to, value);
76   }
77 
78   function transferFrom(address from, address to, uint value) returns (bool ok) {
79     return token.transferFrom(from, to, value);
80   }
81 
82   function approve(address spender, uint value) returns (bool ok) {
83     return token.approve(spender, value);
84   }
85 
86   function changeOwner(address newOwner) returns (bool ok) {
87     return token.changeOwner(newOwner);
88   }
89 
90   function burnToken(uint256 amount) returns (bool ok) {
91     return token.burnToken(amount);
92   }
93 }
94 
95 pragma solidity ^0.4.15;
96 
97 /**
98  * @title TokenLib
99  * @author Majoolr.io
100  *
101  * version 1.1.0
102  * Copyright (c) 2017 Majoolr, LLC
103  * The MIT License (MIT)
104  * https://github.com/Majoolr/ethereum-libraries/blob/master/LICENSE
105  *
106  * The Token Library provides functionality to create a variety of ERC20 tokens.
107  * See https://github.com/Majoolr/ethereum-contracts for an example of how to
108  * create a basic ERC20 token.
109  *
110  * Majoolr works on open source projects in the Ethereum community with the
111  * purpose of testing, documenting, and deploying reusable code onto the
112  * blockchain to improve security and usability of smart contracts. Majoolr
113  * also strives to educate non-profits, schools, and other community members
114  * about the application of blockchain technology.
115  * For further information: majoolr.io
116  *
117  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
118  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
119  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
120  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
121  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
122  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
123  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
124  */
125 
126 library TokenLib {
127   using BasicMathLib for uint256;
128 
129   struct TokenStorage {
130     mapping (address => uint256) balances;
131     mapping (address => mapping (address => uint256)) allowed;
132 
133     string name;
134     string symbol;
135     uint256 totalSupply;
136     uint256 INITIAL_SUPPLY;
137     address owner;
138     uint8 decimals;
139     bool stillMinting;
140   }
141 
142   event Transfer(address indexed from, address indexed to, uint256 value);
143   event Approval(address indexed owner, address indexed spender, uint256 value);
144   event OwnerChange(address from, address to);
145   event Burn(address indexed burner, uint256 value);
146   event MintingClosed(bool mintingClosed);
147 
148   /// @dev Called by the Standard Token upon creation.
149   /// @param self Stored token from token contract
150   /// @param _name Name of the new token
151   /// @param _symbol Symbol of the new token
152   /// @param _decimals Decimal places for the token represented
153   /// @param _initial_supply The initial token supply
154   /// @param _allowMinting True if additional tokens can be created, false otherwise
155   function init(TokenStorage storage self,
156                 address _owner,
157                 string _name,
158                 string _symbol,
159                 uint8 _decimals,
160                 uint256 _initial_supply,
161                 bool _allowMinting)
162   {
163     require(self.INITIAL_SUPPLY == 0);
164     self.name = _name;
165     self.symbol = _symbol;
166     self.totalSupply = _initial_supply;
167     self.INITIAL_SUPPLY = _initial_supply;
168     self.decimals = _decimals;
169     self.owner = _owner;
170     self.stillMinting = _allowMinting;
171     self.balances[_owner] = _initial_supply;
172   }
173 
174   /// @dev Transfer tokens from caller's account to another account.
175   /// @param self Stored token from token contract
176   /// @param _to Address to send tokens
177   /// @param _value Number of tokens to send
178   /// @return True if completed
179   function transfer(TokenStorage storage self, address _to, uint256 _value) returns (bool) {
180     bool err;
181     uint256 balance;
182 
183     (err,balance) = self.balances[msg.sender].minus(_value);
184     require(!err);
185     self.balances[msg.sender] = balance;
186     //It's not possible to overflow token supply
187     self.balances[_to] = self.balances[_to] + _value;
188     Transfer(msg.sender, _to, _value);
189     return true;
190   }
191 
192   /// @dev Authorized caller transfers tokens from one account to another
193   /// @param self Stored token from token contract
194   /// @param _from Address to send tokens from
195   /// @param _to Address to send tokens to
196   /// @param _value Number of tokens to send
197   /// @return True if completed
198   function transferFrom(TokenStorage storage self,
199                         address _from,
200                         address _to,
201                         uint256 _value)
202                         returns (bool)
203   {
204     var _allowance = self.allowed[_from][msg.sender];
205     bool err;
206     uint256 balanceOwner;
207     uint256 balanceSpender;
208 
209     (err,balanceOwner) = self.balances[_from].minus(_value);
210     require(!err);
211 
212     (err,balanceSpender) = _allowance.minus(_value);
213     require(!err);
214 
215     self.balances[_from] = balanceOwner;
216     self.allowed[_from][msg.sender] = balanceSpender;
217     self.balances[_to] = self.balances[_to] + _value;
218 
219     Transfer(_from, _to, _value);
220     return true;
221   }
222 
223   /// @dev Retrieve token balance for an account
224   /// @param self Stored token from token contract
225   /// @param _owner Address to retrieve balance of
226   /// @return balance The number of tokens in the subject account
227   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint256 balance) {
228     return self.balances[_owner];
229   }
230 
231   /// @dev Authorize an account to send tokens on caller's behalf
232   /// @param self Stored token from token contract
233   /// @param _spender Address to authorize
234   /// @param _value Number of tokens authorized account may send
235   /// @return True if completed
236   function approve(TokenStorage storage self, address _spender, uint256 _value) returns (bool) {
237     self.allowed[msg.sender][_spender] = _value;
238     Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /// @dev Remaining tokens third party spender has to send
243   /// @param self Stored token from token contract
244   /// @param _owner Address of token holder
245   /// @param _spender Address of authorized spender
246   /// @return remaining Number of tokens spender has left in owner's account
247   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint256 remaining) {
248     return self.allowed[_owner][_spender];
249   }
250 
251   /// @dev Authorize third party transfer by increasing/decreasing allowed rather than setting it
252   /// @param self Stored token from token contract
253   /// @param _spender Address to authorize
254   /// @param _valueChange Increase or decrease in number of tokens authorized account may send
255   /// @param _increase True if increasing allowance, false if decreasing allowance
256   /// @return True if completed
257   function approveChange (TokenStorage storage self, address _spender, uint256 _valueChange, bool _increase)
258                           returns (bool)
259   {
260     uint256 _newAllowed;
261     bool err;
262 
263     if(_increase) {
264       (err, _newAllowed) = self.allowed[msg.sender][_spender].plus(_valueChange);
265       require(!err);
266 
267       self.allowed[msg.sender][_spender] = _newAllowed;
268     } else {
269       if (_valueChange > self.allowed[msg.sender][_spender]) {
270         self.allowed[msg.sender][_spender] = 0;
271       } else {
272         _newAllowed = self.allowed[msg.sender][_spender] - _valueChange;
273         self.allowed[msg.sender][_spender] = _newAllowed;
274       }
275     }
276 
277     Approval(msg.sender, _spender, _newAllowed);
278     return true;
279   }
280 
281   /// @dev Change owning address of the token contract, specifically for minting
282   /// @param self Stored token from token contract
283   /// @param _newOwner Address for the new owner
284   /// @return True if completed
285   function changeOwner(TokenStorage storage self, address _newOwner) returns (bool) {
286     require((self.owner == msg.sender) && (_newOwner > 0));
287 
288     self.owner = _newOwner;
289     OwnerChange(msg.sender, _newOwner);
290     return true;
291   }
292 
293   /// @dev Mints additional tokens, new tokens go to owner
294   /// @param self Stored token from token contract
295   /// @param _amount Number of tokens to mint
296   /// @return True if completed
297   function mintToken(TokenStorage storage self, uint256 _amount) returns (bool) {
298     require((self.owner == msg.sender) && self.stillMinting);
299     uint256 _newAmount;
300     bool err;
301 
302     (err, _newAmount) = self.totalSupply.plus(_amount);
303     require(!err);
304 
305     self.totalSupply =  _newAmount;
306     self.balances[self.owner] = self.balances[self.owner] + _amount;
307     Transfer(0x0, self.owner, _amount);
308     return true;
309   }
310 
311   /// @dev Permanent stops minting
312   /// @param self Stored token from token contract
313   /// @return True if completed
314   function closeMint(TokenStorage storage self) returns (bool) {
315     require(self.owner == msg.sender);
316 
317     self.stillMinting = false;
318     MintingClosed(true);
319     return true;
320   }
321 
322   /// @dev Permanently burn tokens
323   /// @param self Stored token from token contract
324   /// @param _amount Amount of tokens to burn
325   /// @return True if completed
326   function burnToken(TokenStorage storage self, uint256 _amount) returns (bool) {
327       uint256 _newBalance;
328       bool err;
329 
330       (err, _newBalance) = self.balances[msg.sender].minus(_amount);
331       require(!err);
332 
333       self.balances[msg.sender] = _newBalance;
334       self.totalSupply = self.totalSupply - _amount;
335       Burn(msg.sender, _amount);
336       Transfer(msg.sender, 0x0, _amount);
337       return true;
338   }
339 }
340 pragma solidity ^0.4.13;
341 
342 /**
343  * @title Basic Math Library
344  * @author Majoolr.io
345  *
346  * version 1.1.0
347  * Copyright (c) 2017 Majoolr, LLC
348  * The MIT License (MIT)
349  * https://github.com/Majoolr/ethereum-libraries/blob/master/LICENSE
350  *
351  * The Basic Math Library is inspired by the Safe Math library written by
352  * OpenZeppelin at https://github.com/OpenZeppelin/zeppelin-solidity/ .
353  * Majoolr works on open source projects in the Ethereum community with the
354  * purpose of testing, documenting, and deploying reusable code onto the
355  * blockchain to improve security and usability of smart contracts. Majoolr
356  * also strives to educate non-profits, schools, and other community members
357  * about the application of blockchain technology.
358  * For further information: majoolr.io, openzeppelin.org
359  *
360  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
361  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
362  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
363  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
364  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
365  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
366  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
367  */
368 
369 library BasicMathLib {
370   event Err(string typeErr);
371 
372   /// @dev Multiplies two numbers and checks for overflow before returning.
373   /// Does not throw but rather logs an Err event if there is overflow.
374   /// @param a First number
375   /// @param b Second number
376   /// @return err False normally, or true if there is overflow
377   /// @return res The product of a and b, or 0 if there is overflow
378   function times(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
379     assembly{
380       res := mul(a,b)
381       switch or(iszero(b), eq(div(res,b), a))
382       case 0 {
383         err := 1
384         res := 0
385       }
386     }
387     if (err)
388       Err("times func overflow");
389   }
390 
391   /// @dev Divides two numbers but checks for 0 in the divisor first.
392   /// Does not throw but rather logs an Err event if 0 is in the divisor.
393   /// @param a First number
394   /// @param b Second number
395   /// @return err False normally, or true if `b` is 0
396   /// @return res The quotient of a and b, or 0 if `b` is 0
397   function dividedBy(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
398     assembly{
399       switch iszero(b)
400       case 0 {
401         res := div(a,b)
402         mstore(add(mload(0x40),0x20),res)
403         return(mload(0x40),0x40)
404       }
405     }
406     Err("tried to divide by zero");
407     return (true, 0);
408   }
409 
410   /// @dev Adds two numbers and checks for overflow before returning.
411   /// Does not throw but rather logs an Err event if there is overflow.
412   /// @param a First number
413   /// @param b Second number
414   /// @return err False normally, or true if there is overflow
415   /// @return res The sum of a and b, or 0 if there is overflow
416   function plus(uint256 a, uint256 b) constant returns (bool err, uint256 res) {
417     assembly{
418       res := add(a,b)
419       switch and(eq(sub(res,b), a), or(gt(res,b),eq(res,b)))
420       case 0 {
421         err := 1
422         res := 0
423       }
424     }
425     if (err)
426       Err("plus func overflow");
427   }
428 
429   /// @dev Subtracts two numbers and checks for underflow before returning.
430   /// Does not throw but rather logs an Err event if there is underflow.
431   /// @param a First number
432   /// @param b Second number
433   /// @return err False normally, or true if there is underflow
434   /// @return res The difference between a and b, or 0 if there is underflow
435   function minus(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
436     assembly{
437       res := sub(a,b)
438       switch eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1)
439       case 0 {
440         err := 1
441         res := 0
442       }
443     }
444     if (err)
445       Err("minus func underflow");
446   }
447 }