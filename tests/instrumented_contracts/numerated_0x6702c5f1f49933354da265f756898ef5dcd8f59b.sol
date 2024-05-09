1 pragma solidity ^0.4.15;
2 
3 /**
4  * Standard ERC20 token
5  *
6  * https://github.com/ethereum/EIPs/issues/20
7  * Based on code by FirstBlood:
8  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
9  *
10  * This is the token contract for Dealbox. It utilizes Majoolr's TokenLib library
11  * to reduce custom source code surface area and increase overall security.
12  * Majoolr provides smart contract services and security reviews for contract
13  * deployments in addition to working on open source projects in the Ethereum
14  * Community.
15  * For further information: dlbx.io, majoolr.io
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
26 contract DLBXToken {
27   using TokenLib for TokenLib.TokenStorage;
28 
29   TokenLib.TokenStorage token;
30 
31   function DLBXToken(address owner,
32                     string name, //DealBox Token
33                     string symbol, //DLBX
34                     uint8 decimals, //0
35                     uint256 initialSupply, //500000000
36                     bool allowMinting) //false
37   {
38     token.init(owner, name, symbol, decimals, initialSupply, allowMinting);
39   }
40 
41   /*EVENTS*/
42   event Transfer(address indexed from, address indexed to, uint256 value);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44   event OwnerChange(address from, address to);
45   event Burn(address indexed burner, uint256 value);
46   event MintingClosed(bool mintingClosed);
47 
48   /*FUNCTIONS*/
49 
50   function owner() constant returns (address) {
51     return token.owner;
52   }
53 
54   function name() constant returns (string) {
55     return token.name;
56   }
57 
58   function symbol() constant returns (string) {
59     return token.symbol;
60   }
61 
62   function decimals() constant returns (uint8) {
63     return token.decimals;
64   }
65 
66   function initialSupply() constant returns (uint256) {
67     return token.INITIAL_SUPPLY;
68   }
69 
70   function totalSupply() constant returns (uint256) {
71     return token.totalSupply;
72   }
73 
74   function balanceOf(address who) constant returns (uint256) {
75     return token.balanceOf(who);
76   }
77 
78   function allowance(address owner, address spender) constant returns (uint256) {
79     return token.allowance(owner, spender);
80   }
81 
82   function transfer(address to, uint value) returns (bool ok) {
83     return token.transfer(to, value);
84   }
85 
86   function transferFrom(address from, address to, uint value) returns (bool ok) {
87     return token.transferFrom(from, to, value);
88   }
89 
90   function approve(address spender, uint value) returns (bool ok) {
91     return token.approve(spender, value);
92   }
93 
94   function changeOwner(address newOwner) returns (bool ok) {
95     return token.changeOwner(newOwner);
96   }
97 
98   function burnToken(uint256 amount) returns (bool ok) {
99     return token.burnToken(amount);
100   }
101 }
102 
103 library TokenLib {
104   using BasicMathLib for uint256;
105 
106   struct TokenStorage {
107     mapping (address => uint256) balances;
108     mapping (address => mapping (address => uint256)) allowed;
109 
110     string name;
111     string symbol;
112     uint256 totalSupply;
113     uint256 INITIAL_SUPPLY;
114     address owner;
115     uint8 decimals;
116     bool stillMinting;
117   }
118 
119   event Transfer(address indexed from, address indexed to, uint256 value);
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121   event OwnerChange(address from, address to);
122   event Burn(address indexed burner, uint256 value);
123   event MintingClosed(bool mintingClosed);
124 
125   /// @dev Called by the Standard Token upon creation.
126   /// @param self Stored token from token contract
127   /// @param _name Name of the new token
128   /// @param _symbol Symbol of the new token
129   /// @param _decimals Decimal places for the token represented
130   /// @param _initial_supply The initial token supply
131   /// @param _allowMinting True if additional tokens can be created, false otherwise
132   function init(TokenStorage storage self,
133                 address _owner,
134                 string _name,
135                 string _symbol,
136                 uint8 _decimals,
137                 uint256 _initial_supply,
138                 bool _allowMinting)
139   {
140     require(self.INITIAL_SUPPLY == 0);
141     self.name = _name;
142     self.symbol = _symbol;
143     self.totalSupply = _initial_supply;
144     self.INITIAL_SUPPLY = _initial_supply;
145     self.decimals = _decimals;
146     self.owner = _owner;
147     self.stillMinting = _allowMinting;
148     self.balances[_owner] = _initial_supply;
149   }
150 
151   /// @dev Transfer tokens from caller's account to another account.
152   /// @param self Stored token from token contract
153   /// @param _to Address to send tokens
154   /// @param _value Number of tokens to send
155   /// @return True if completed
156   function transfer(TokenStorage storage self, address _to, uint256 _value) returns (bool) {
157     bool err;
158     uint256 balance;
159 
160     (err,balance) = self.balances[msg.sender].minus(_value);
161     require(!err);
162     self.balances[msg.sender] = balance;
163     //It's not possible to overflow token supply
164     self.balances[_to] = self.balances[_to] + _value;
165     Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /// @dev Authorized caller transfers tokens from one account to another
170   /// @param self Stored token from token contract
171   /// @param _from Address to send tokens from
172   /// @param _to Address to send tokens to
173   /// @param _value Number of tokens to send
174   /// @return True if completed
175   function transferFrom(TokenStorage storage self,
176                         address _from,
177                         address _to,
178                         uint256 _value)
179                         returns (bool)
180   {
181     var _allowance = self.allowed[_from][msg.sender];
182     bool err;
183     uint256 balanceOwner;
184     uint256 balanceSpender;
185 
186     (err,balanceOwner) = self.balances[_from].minus(_value);
187     require(!err);
188 
189     (err,balanceSpender) = _allowance.minus(_value);
190     require(!err);
191 
192     self.balances[_from] = balanceOwner;
193     self.allowed[_from][msg.sender] = balanceSpender;
194     self.balances[_to] = self.balances[_to] + _value;
195 
196     Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /// @dev Retrieve token balance for an account
201   /// @param self Stored token from token contract
202   /// @param _owner Address to retrieve balance of
203   /// @return balance The number of tokens in the subject account
204   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint256 balance) {
205     return self.balances[_owner];
206   }
207 
208   /// @dev Authorize an account to send tokens on caller's behalf
209   /// @param self Stored token from token contract
210   /// @param _spender Address to authorize
211   /// @param _value Number of tokens authorized account may send
212   /// @return True if completed
213   function approve(TokenStorage storage self, address _spender, uint256 _value) returns (bool) {
214     self.allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /// @dev Remaining tokens third party spender has to send
220   /// @param self Stored token from token contract
221   /// @param _owner Address of token holder
222   /// @param _spender Address of authorized spender
223   /// @return remaining Number of tokens spender has left in owner's account
224   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint256 remaining) {
225     return self.allowed[_owner][_spender];
226   }
227 
228   /// @dev Authorize third party transfer by increasing/decreasing allowed rather than setting it
229   /// @param self Stored token from token contract
230   /// @param _spender Address to authorize
231   /// @param _valueChange Increase or decrease in number of tokens authorized account may send
232   /// @param _increase True if increasing allowance, false if decreasing allowance
233   /// @return True if completed
234   function approveChange (TokenStorage storage self, address _spender, uint256 _valueChange, bool _increase)
235                           returns (bool)
236   {
237     uint256 _newAllowed;
238     bool err;
239 
240     if(_increase) {
241       (err, _newAllowed) = self.allowed[msg.sender][_spender].plus(_valueChange);
242       require(!err);
243 
244       self.allowed[msg.sender][_spender] = _newAllowed;
245     } else {
246       if (_valueChange > self.allowed[msg.sender][_spender]) {
247         self.allowed[msg.sender][_spender] = 0;
248       } else {
249         _newAllowed = self.allowed[msg.sender][_spender] - _valueChange;
250         self.allowed[msg.sender][_spender] = _newAllowed;
251       }
252     }
253 
254     Approval(msg.sender, _spender, _newAllowed);
255     return true;
256   }
257 
258   /// @dev Change owning address of the token contract, specifically for minting
259   /// @param self Stored token from token contract
260   /// @param _newOwner Address for the new owner
261   /// @return True if completed
262   function changeOwner(TokenStorage storage self, address _newOwner) returns (bool) {
263     require((self.owner == msg.sender) && (_newOwner > 0));
264 
265     self.owner = _newOwner;
266     OwnerChange(msg.sender, _newOwner);
267     return true;
268   }
269 
270   /// @dev Mints additional tokens, new tokens go to owner
271   /// @param self Stored token from token contract
272   /// @param _amount Number of tokens to mint
273   /// @return True if completed
274   function mintToken(TokenStorage storage self, uint256 _amount) returns (bool) {
275     require((self.owner == msg.sender) && self.stillMinting);
276     uint256 _newAmount;
277     bool err;
278 
279     (err, _newAmount) = self.totalSupply.plus(_amount);
280     require(!err);
281 
282     self.totalSupply =  _newAmount;
283     self.balances[self.owner] = self.balances[self.owner] + _amount;
284     Transfer(0x0, self.owner, _amount);
285     return true;
286   }
287 
288   /// @dev Permanent stops minting
289   /// @param self Stored token from token contract
290   /// @return True if completed
291   function closeMint(TokenStorage storage self) returns (bool) {
292     require(self.owner == msg.sender);
293 
294     self.stillMinting = false;
295     MintingClosed(true);
296     return true;
297   }
298 
299   /// @dev Permanently burn tokens
300   /// @param self Stored token from token contract
301   /// @param _amount Amount of tokens to burn
302   /// @return True if completed
303   function burnToken(TokenStorage storage self, uint256 _amount) returns (bool) {
304       uint256 _newBalance;
305       bool err;
306 
307       (err, _newBalance) = self.balances[msg.sender].minus(_amount);
308       require(!err);
309 
310       self.balances[msg.sender] = _newBalance;
311       self.totalSupply = self.totalSupply - _amount;
312       Burn(msg.sender, _amount);
313       Transfer(msg.sender, 0x0, _amount);
314       return true;
315   }
316 }
317 
318 library BasicMathLib {
319   event Err(string typeErr);
320 
321   /// @dev Multiplies two numbers and checks for overflow before returning.
322   /// Does not throw but rather logs an Err event if there is overflow.
323   /// @param a First number
324   /// @param b Second number
325   /// @return err False normally, or true if there is overflow
326   /// @return res The product of a and b, or 0 if there is overflow
327   function times(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
328     assembly{
329       res := mul(a,b)
330       switch or(iszero(b), eq(div(res,b), a))
331       case 0 {
332         err := 1
333         res := 0
334       }
335     }
336     if (err)
337       Err("times func overflow");
338   }
339 
340   /// @dev Divides two numbers but checks for 0 in the divisor first.
341   /// Does not throw but rather logs an Err event if 0 is in the divisor.
342   /// @param a First number
343   /// @param b Second number
344   /// @return err False normally, or true if `b` is 0
345   /// @return res The quotient of a and b, or 0 if `b` is 0
346   function dividedBy(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
347     assembly{
348       switch iszero(b)
349       case 0 {
350         res := div(a,b)
351         mstore(add(mload(0x40),0x20),res)
352         return(mload(0x40),0x40)
353       }
354     }
355     Err("tried to divide by zero");
356     return (true, 0);
357   }
358 
359   /// @dev Adds two numbers and checks for overflow before returning.
360   /// Does not throw but rather logs an Err event if there is overflow.
361   /// @param a First number
362   /// @param b Second number
363   /// @return err False normally, or true if there is overflow
364   /// @return res The sum of a and b, or 0 if there is overflow
365   function plus(uint256 a, uint256 b) constant returns (bool err, uint256 res) {
366     assembly{
367       res := add(a,b)
368       switch and(eq(sub(res,b), a), or(gt(res,b),eq(res,b)))
369       case 0 {
370         err := 1
371         res := 0
372       }
373     }
374     if (err)
375       Err("plus func overflow");
376   }
377 
378   /// @dev Subtracts two numbers and checks for underflow before returning.
379   /// Does not throw but rather logs an Err event if there is underflow.
380   /// @param a First number
381   /// @param b Second number
382   /// @return err False normally, or true if there is underflow
383   /// @return res The difference between a and b, or 0 if there is underflow
384   function minus(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
385     assembly{
386       res := sub(a,b)
387       switch eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1)
388       case 0 {
389         err := 1
390         res := 0
391       }
392     }
393     if (err)
394       Err("minus func underflow");
395   }
396 }