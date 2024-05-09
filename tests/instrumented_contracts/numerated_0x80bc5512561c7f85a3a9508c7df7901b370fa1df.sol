1 pragma solidity ^0.4.15;
2 
3 /**
4  * Standard ERC20 token
5  *
6  * https://github.com/ethereum/EIPs/issues/20
7  * Based on code by FirstBlood:
8  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
9  *
10  * This is the token contract for trade.io, join the trading revolution.
11  * It utilizes Majoolr's TokenLib library to reduce custom source code surface
12  * area and increase overall security. Majoolr provides smart contract services
13  * and security reviews for contract deployments in addition to working on open
14  * source projects in the Ethereum community.
15  * For further information: trade.io, majoolr.io
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
26 contract TIOToken {
27   using TokenLib for TokenLib.TokenStorage;
28 
29   TokenLib.TokenStorage token;
30 
31   function TIOToken(address owner,
32                     string name, //TradeToken
33                     string symbol, //TIO
34                     uint8 decimals, //18
35                     uint256 initialSupply, // 555000000000000000000000000
36                     bool allowMinting) //false
37   {
38     token.init(owner, name, symbol, decimals, initialSupply, allowMinting);
39   }
40 
41   function owner() constant returns (address) {
42     return token.owner;
43   }
44 
45   function name() constant returns (string) {
46     return token.name;
47   }
48 
49   function symbol() constant returns (string) {
50     return token.symbol;
51   }
52 
53   function decimals() constant returns (uint8) {
54     return token.decimals;
55   }
56 
57   function initialSupply() constant returns (uint256) {
58     return token.INITIAL_SUPPLY;
59   }
60 
61   function totalSupply() constant returns (uint256) {
62     return token.totalSupply;
63   }
64 
65   function balanceOf(address who) constant returns (uint256) {
66     return token.balanceOf(who);
67   }
68 
69   function allowance(address owner, address spender) constant returns (uint256) {
70     return token.allowance(owner, spender);
71   }
72 
73   function transfer(address to, uint value) returns (bool ok) {
74     return token.transfer(to, value);
75   }
76 
77   function transferFrom(address from, address to, uint value) returns (bool ok) {
78     return token.transferFrom(from, to, value);
79   }
80 
81   function approve(address spender, uint value) returns (bool ok) {
82     return token.approve(spender, value);
83   }
84 
85   function changeOwner(address newOwner) returns (bool ok) {
86     return token.changeOwner(newOwner);
87   }
88 
89   function burnToken(uint256 amount) returns (bool ok) {
90     return token.burnToken(amount);
91   }
92 }
93 
94 library TokenLib {
95   using BasicMathLib for uint256;
96 
97   struct TokenStorage {
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100 
101     string name;
102     string symbol;
103     uint256 totalSupply;
104     uint256 INITIAL_SUPPLY;
105     address owner;
106     uint8 decimals;
107     bool stillMinting;
108   }
109 
110   event Transfer(address indexed from, address indexed to, uint256 value);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112   event OwnerChange(address from, address to);
113   event Burn(address indexed burner, uint256 value);
114   event MintingClosed(bool mintingClosed);
115 
116   /// @dev Called by the Standard Token upon creation.
117   /// @param self Stored token from token contract
118   /// @param _name Name of the new token
119   /// @param _symbol Symbol of the new token
120   /// @param _decimals Decimal places for the token represented
121   /// @param _initial_supply The initial token supply
122   /// @param _allowMinting True if additional tokens can be created, false otherwise
123   function init(TokenStorage storage self,
124                 address _owner,
125                 string _name,
126                 string _symbol,
127                 uint8 _decimals,
128                 uint256 _initial_supply,
129                 bool _allowMinting)
130   {
131     require(self.INITIAL_SUPPLY == 0);
132     self.name = _name;
133     self.symbol = _symbol;
134     self.totalSupply = _initial_supply;
135     self.INITIAL_SUPPLY = _initial_supply;
136     self.decimals = _decimals;
137     self.owner = _owner;
138     self.stillMinting = _allowMinting;
139     self.balances[_owner] = _initial_supply;
140   }
141 
142   /// @dev Transfer tokens from caller's account to another account.
143   /// @param self Stored token from token contract
144   /// @param _to Address to send tokens
145   /// @param _value Number of tokens to send
146   /// @return True if completed
147   function transfer(TokenStorage storage self, address _to, uint256 _value) returns (bool) {
148     bool err;
149     uint256 balance;
150 
151     (err,balance) = self.balances[msg.sender].minus(_value);
152     require(!err);
153     self.balances[msg.sender] = balance;
154     //It's not possible to overflow token supply
155     self.balances[_to] = self.balances[_to] + _value;
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /// @dev Authorized caller transfers tokens from one account to another
161   /// @param self Stored token from token contract
162   /// @param _from Address to send tokens from
163   /// @param _to Address to send tokens to
164   /// @param _value Number of tokens to send
165   /// @return True if completed
166   function transferFrom(TokenStorage storage self,
167                         address _from,
168                         address _to,
169                         uint256 _value)
170                         returns (bool)
171   {
172     var _allowance = self.allowed[_from][msg.sender];
173     bool err;
174     uint256 balanceOwner;
175     uint256 balanceSpender;
176 
177     (err,balanceOwner) = self.balances[_from].minus(_value);
178     require(!err);
179 
180     (err,balanceSpender) = _allowance.minus(_value);
181     require(!err);
182 
183     self.balances[_from] = balanceOwner;
184     self.allowed[_from][msg.sender] = balanceSpender;
185     self.balances[_to] = self.balances[_to] + _value;
186 
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /// @dev Retrieve token balance for an account
192   /// @param self Stored token from token contract
193   /// @param _owner Address to retrieve balance of
194   /// @return balance The number of tokens in the subject account
195   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint256 balance) {
196     return self.balances[_owner];
197   }
198 
199   /// @dev Authorize an account to send tokens on caller's behalf
200   /// @param self Stored token from token contract
201   /// @param _spender Address to authorize
202   /// @param _value Number of tokens authorized account may send
203   /// @return True if completed
204   function approve(TokenStorage storage self, address _spender, uint256 _value) returns (bool) {
205     self.allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /// @dev Remaining tokens third party spender has to send
211   /// @param self Stored token from token contract
212   /// @param _owner Address of token holder
213   /// @param _spender Address of authorized spender
214   /// @return remaining Number of tokens spender has left in owner's account
215   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint256 remaining) {
216     return self.allowed[_owner][_spender];
217   }
218 
219   /// @dev Authorize third party transfer by increasing/decreasing allowed rather than setting it
220   /// @param self Stored token from token contract
221   /// @param _spender Address to authorize
222   /// @param _valueChange Increase or decrease in number of tokens authorized account may send
223   /// @param _increase True if increasing allowance, false if decreasing allowance
224   /// @return True if completed
225   function approveChange (TokenStorage storage self, address _spender, uint256 _valueChange, bool _increase)
226                           returns (bool)
227   {
228     uint256 _newAllowed;
229     bool err;
230 
231     if(_increase) {
232       (err, _newAllowed) = self.allowed[msg.sender][_spender].plus(_valueChange);
233       require(!err);
234 
235       self.allowed[msg.sender][_spender] = _newAllowed;
236     } else {
237       if (_valueChange > self.allowed[msg.sender][_spender]) {
238         self.allowed[msg.sender][_spender] = 0;
239       } else {
240         _newAllowed = self.allowed[msg.sender][_spender] - _valueChange;
241         self.allowed[msg.sender][_spender] = _newAllowed;
242       }
243     }
244 
245     Approval(msg.sender, _spender, _newAllowed);
246     return true;
247   }
248 
249   /// @dev Change owning address of the token contract, specifically for minting
250   /// @param self Stored token from token contract
251   /// @param _newOwner Address for the new owner
252   /// @return True if completed
253   function changeOwner(TokenStorage storage self, address _newOwner) returns (bool) {
254     require((self.owner == msg.sender) && (_newOwner > 0));
255 
256     self.owner = _newOwner;
257     OwnerChange(msg.sender, _newOwner);
258     return true;
259   }
260 
261   /// @dev Mints additional tokens, new tokens go to owner
262   /// @param self Stored token from token contract
263   /// @param _amount Number of tokens to mint
264   /// @return True if completed
265   function mintToken(TokenStorage storage self, uint256 _amount) returns (bool) {
266     require((self.owner == msg.sender) && self.stillMinting);
267     uint256 _newAmount;
268     bool err;
269 
270     (err, _newAmount) = self.totalSupply.plus(_amount);
271     require(!err);
272 
273     self.totalSupply =  _newAmount;
274     self.balances[self.owner] = self.balances[self.owner] + _amount;
275     Transfer(0x0, self.owner, _amount);
276     return true;
277   }
278 
279   /// @dev Permanent stops minting
280   /// @param self Stored token from token contract
281   /// @return True if completed
282   function closeMint(TokenStorage storage self) returns (bool) {
283     require(self.owner == msg.sender);
284 
285     self.stillMinting = false;
286     MintingClosed(true);
287     return true;
288   }
289 
290   /// @dev Permanently burn tokens
291   /// @param self Stored token from token contract
292   /// @param _amount Amount of tokens to burn
293   /// @return True if completed
294   function burnToken(TokenStorage storage self, uint256 _amount) returns (bool) {
295       uint256 _newBalance;
296       bool err;
297 
298       (err, _newBalance) = self.balances[msg.sender].minus(_amount);
299       require(!err);
300 
301       self.balances[msg.sender] = _newBalance;
302       self.totalSupply = self.totalSupply - _amount;
303       Burn(msg.sender, _amount);
304       Transfer(msg.sender, 0x0, _amount);
305       return true;
306   }
307 }
308 
309 library BasicMathLib {
310   event Err(string typeErr);
311 
312   /// @dev Multiplies two numbers and checks for overflow before returning.
313   /// Does not throw but rather logs an Err event if there is overflow.
314   /// @param a First number
315   /// @param b Second number
316   /// @return err False normally, or true if there is overflow
317   /// @return res The product of a and b, or 0 if there is overflow
318   function times(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
319     assembly{
320       res := mul(a,b)
321       switch or(iszero(b), eq(div(res,b), a))
322       case 0 {
323         err := 1
324         res := 0
325       }
326     }
327     if (err)
328       Err("times func overflow");
329   }
330 
331   /// @dev Divides two numbers but checks for 0 in the divisor first.
332   /// Does not throw but rather logs an Err event if 0 is in the divisor.
333   /// @param a First number
334   /// @param b Second number
335   /// @return err False normally, or true if `b` is 0
336   /// @return res The quotient of a and b, or 0 if `b` is 0
337   function dividedBy(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
338     assembly{
339       switch iszero(b)
340       case 0 {
341         res := div(a,b)
342         mstore(add(mload(0x40),0x20),res)
343         return(mload(0x40),0x40)
344       }
345     }
346     Err("tried to divide by zero");
347     return (true, 0);
348   }
349 
350   /// @dev Adds two numbers and checks for overflow before returning.
351   /// Does not throw but rather logs an Err event if there is overflow.
352   /// @param a First number
353   /// @param b Second number
354   /// @return err False normally, or true if there is overflow
355   /// @return res The sum of a and b, or 0 if there is overflow
356   function plus(uint256 a, uint256 b) constant returns (bool err, uint256 res) {
357     assembly{
358       res := add(a,b)
359       switch and(eq(sub(res,b), a), or(gt(res,b),eq(res,b)))
360       case 0 {
361         err := 1
362         res := 0
363       }
364     }
365     if (err)
366       Err("plus func overflow");
367   }
368 
369   /// @dev Subtracts two numbers and checks for underflow before returning.
370   /// Does not throw but rather logs an Err event if there is underflow.
371   /// @param a First number
372   /// @param b Second number
373   /// @return err False normally, or true if there is underflow
374   /// @return res The difference between a and b, or 0 if there is underflow
375   function minus(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
376     assembly{
377       res := sub(a,b)
378       switch eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1)
379       case 0 {
380         err := 1
381         res := 0
382       }
383     }
384     if (err)
385       Err("minus func underflow");
386   }
387 }