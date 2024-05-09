1 // File: solidity/solidity/Owned.sol
2 
3 pragma solidity ^0.4.10;
4 
5 contract Owned {
6     address public owner;
7 
8     event OwnerUpdate(address _prevOwner, address _newOwner);
9 
10     function Owned() {
11         owner = msg.sender;
12     }
13 
14     // allows execution by the owner only
15     modifier ownerOnly {
16         assert(msg.sender == owner);
17         _;
18     }
19 
20     /*
21         allows transferring the contract ownership
22         can only be called by the contract owner
23     */
24     function setOwner(address _newOwner) public ownerOnly {
25         require(_newOwner != owner);
26         address prevOwner = owner;
27         owner = _newOwner;
28         OwnerUpdate(prevOwner, owner);
29     }
30 }
31 
32 // File: solidity/solidity/ERC20TokenInterface.sol
33 
34 pragma solidity ^0.4.10;
35 
36 /*
37     ERC20 Standard Token interface
38 */
39 contract ERC20TokenInterface {
40     // these functions aren't abstract since the compiler doesn't recognize automatically generated getter functions as functions
41     function totalSupply() public constant returns (uint256 totalSupply) {}
42     function balanceOf(address _owner) public constant returns (uint256 balance) {}
43     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
44 
45     function transfer(address _to, uint256 _value) public returns (bool success);
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
47     function approve(address _spender, uint256 _value) public returns (bool success);
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 // File: solidity/solidity/ERC20Token.sol
54 
55 pragma solidity ^0.4.10;
56 
57 
58 /*
59     ERC20 Standard Token implementation
60 */
61 contract ERC20Token is ERC20TokenInterface {
62     string public standard = 'Token 0.1';
63     string public name = '';
64     string public symbol = '';
65     uint256 public totalSupply = 0;
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 
72     function ERC20Token(string _name, string _symbol) {
73         name = _name;
74         symbol = _symbol;
75     }
76 
77     // validates an address - currently only checks that it isn't null
78     modifier validAddress(address _address) {
79         assert(_address != 0x0);
80         _;
81     }
82 
83     /*
84         send coins
85         note that the function slightly deviates from the ERC20 standard and will throw on any error rather then return a boolean return value to minimize user errors
86     */
87     function transfer(address _to, uint256 _value)
88         public
89         validAddress(_to)
90         returns (bool success)
91     {
92         require(_value <= balanceOf[msg.sender]); // balance check
93         assert(balanceOf[_to] + _value >= balanceOf[_to]); // overflow protection
94 
95         balanceOf[msg.sender] -= _value;
96         balanceOf[_to] += _value;
97         Transfer(msg.sender, _to, _value);
98         return true;
99     }
100 
101     /*
102         an account/contract attempts to get the coins
103         note that the function slightly deviates from the ERC20 standard and will throw on any error rather then return a boolean return value to minimize user errors
104     */
105     function transferFrom(address _from, address _to, uint256 _value)
106         public
107         validAddress(_from)
108         validAddress(_to)
109         returns (bool success)
110     {
111         require(_value <= balanceOf[_from]); // balance check
112         require(_value <= allowance[_from][msg.sender]); // allowance check
113         assert(balanceOf[_to] + _value >= balanceOf[_to]); // overflow protection
114 
115         balanceOf[_from] -= _value;
116         balanceOf[_to] += _value;
117         allowance[_from][msg.sender] -= _value;
118         Transfer(_from, _to, _value);
119         return true;
120     }
121 
122     /*
123         allow another account/contract to spend some tokens on your behalf
124         note that the function slightly deviates from the ERC20 standard and will throw on any error rather then return a boolean return value to minimize user errors
125 
126         also, to minimize the risk of the approve/transferFrom attack vector
127         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
128         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
129     */
130     function approve(address _spender, uint256 _value)
131         public
132         validAddress(_spender)
133         returns (bool success)
134     {
135         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
136         require(_value == 0 || allowance[msg.sender][_spender] == 0);
137 
138         allowance[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 }
143 
144 // File: solidity/solidity/BancorEventsInterface.sol
145 
146 pragma solidity ^0.4.10;
147 
148 /*
149     Bancor events interface
150 */
151 contract BancorEventsInterface {
152     event NewToken(address _token);
153     event TokenOwnerUpdate(address indexed _token, address _prevOwner, address _newOwner);
154     event TokenChangerUpdate(address indexed _token, address _prevChanger, address _newChanger);
155     event TokenTransfer(address indexed _token, address indexed _from, address indexed _to, uint256 _value);
156     event TokenApproval(address indexed _token, address indexed _owner, address indexed _spender, uint256 _value);
157     event TokenChange(address indexed _sender, address indexed _fromToken, address indexed _toToken, address _changer, uint256 _amount, uint256 _return);
158 
159     function newToken() public;
160     function tokenOwnerUpdate(address _prevOwner, address _newOwner) public;
161     function tokenChangerUpdate(address _prevChanger, address _newChanger) public;
162     function tokenTransfer(address _from, address _to, uint256 _value) public;
163     function tokenApproval(address _owner, address _spender, uint256 _value) public;
164     function tokenChange(address _fromToken, address _toToken, address _changer, uint256 _amount, uint256 _return) public;
165 }
166 
167 // File: solidity/solidity/SmartToken.sol
168 
169 pragma solidity ^0.4.10;
170 
171 
172 
173 
174 
175 /*
176     Smart Token v0.1
177 */
178 contract SmartToken is Owned, ERC20Token {
179     string public version = '0.1';
180     uint8 public numDecimalUnits = 0;   // for display purposes only
181     address public events = 0x0;        // bancor events contract address
182     address public changer = 0x0;       // changer contract address
183     bool public transfersEnabled = true;
184 
185     // events, can be used to listen to the contract directly, as opposed to through the events contract
186     event ChangerUpdate(address _prevChanger, address _newChanger);
187 
188     /*
189         _name               token name
190         _symbol             token short symbol, 1-6 characters
191         _numDecimalUnits    for display purposes only
192         _formula            address of a bancor formula contract
193         _events             optional, address of a bancor events contract
194     */
195     function SmartToken(string _name, string _symbol, uint8 _numDecimalUnits, address _events)
196         ERC20Token(_name, _symbol)
197     {
198         require(bytes(_name).length != 0 && bytes(_symbol).length >= 1 && bytes(_symbol).length <= 6); // validate input
199 
200         numDecimalUnits = _numDecimalUnits;
201         events = _events;
202         if (events == 0x0)
203             return;
204 
205         BancorEventsInterface eventsContract = BancorEventsInterface(events);
206         eventsContract.newToken();
207     }
208 
209     // allows execution only when transfers aren't disabled
210     modifier transfersAllowed {
211         assert(transfersEnabled);
212         _;
213     }
214 
215     // allows execution by the owner if there's no changer defined or by the changer contract if a changer is defined
216     modifier managerOnly {
217         assert((changer == 0x0 && msg.sender == owner) ||
218                (changer != 0x0 && msg.sender == changer)); // validate state & permissions
219         _;
220     }
221 
222     function setOwner(address _newOwner)
223         public
224         ownerOnly
225         validAddress(_newOwner)
226     {
227         address prevOwner = owner;
228         super.setOwner(_newOwner);
229         if (events == 0x0)
230             return;
231 
232         BancorEventsInterface eventsContract = BancorEventsInterface(events);
233         eventsContract.tokenOwnerUpdate(prevOwner, owner);
234     }
235 
236     /*
237         sets the number of display decimal units
238         can only be called by the token owner
239 
240         _numDecimalUnits    new number of decimal units
241     */
242     function setNumDecimalUnits(uint8 _numDecimalUnits) public ownerOnly {
243         numDecimalUnits = _numDecimalUnits;
244     }
245 
246     /*
247         disables/enables transfers
248         can only be called by the token owner (if no changer is defined) or the changer contract (if a changer is defined)
249 
250         _disable    true to disable transfers, false to enable them
251     */
252     function disableTransfers(bool _disable) public managerOnly {
253         transfersEnabled = !_disable;
254     }
255 
256     /*
257         increases the token supply and sends the new tokens to an account
258         can only be called by the token owner (if no changer is defined) or the changer contract (if a changer is defined)
259 
260         _to         account to receive the new amount
261         _amount     amount to increase the supply by
262     */
263     function issue(address _to, uint256 _amount)
264         public
265         managerOnly
266         validAddress(_to)
267         returns (bool success)
268     {
269          // validate input
270         require(_to != address(this) && _amount != 0);
271          // supply overflow protection
272         assert(totalSupply + _amount >= totalSupply);
273         // target account balance overflow protection
274         assert(balanceOf[_to] + _amount >= balanceOf[_to]);
275 
276         totalSupply += _amount;
277         balanceOf[_to] += _amount;
278         dispatchTransfer(this, _to, _amount);
279         return true;
280     }
281 
282     /*
283         removes tokens from an account and decreases the token supply
284         can only be called by the token owner (if no changer is defined) or the changer contract (if a changer is defined)
285 
286         _from       account to remove the new amount from
287         _amount     amount to decrease the supply by
288     */
289     function destroy(address _from, uint256 _amount)
290         public
291         managerOnly
292         validAddress(_from)
293         returns (bool success)
294     {
295         require(_from != address(this) && _amount != 0 && _amount <= balanceOf[_from]); // validate input
296 
297         totalSupply -= _amount;
298         balanceOf[_from] -= _amount;
299         dispatchTransfer(_from, this, _amount);
300         return true;
301     }
302 
303     /*
304         sets a changer contract address
305         can only be called by the token owner (if no changer is defined) or the changer contract (if a changer is defined)
306         the changer can be set to null to transfer ownership from the changer to the owner
307 
308         _changer            new changer contract address (can also be set to 0x0 to remove the current changer)
309     */
310     function setChanger(address _changer) public managerOnly returns (bool success) {
311         require(_changer != changer);
312         address prevChanger = changer;
313         changer = _changer;
314         dispatchChangerUpdate(prevChanger, changer);
315         return true;
316     }
317 
318     // ERC20 standard method overrides with some extra functionality
319 
320     // send coins
321     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
322         assert(super.transfer(_to, _value));
323 
324         // transferring to the contract address destroys tokens
325         if (_to == address(this)) {
326             balanceOf[_to] -= _value;
327             totalSupply -= _value;
328         }
329 
330         if (events == 0x0)
331             return;
332 
333         BancorEventsInterface eventsContract = BancorEventsInterface(events);
334         eventsContract.tokenTransfer(msg.sender, _to, _value);
335         return true;
336     }
337 
338     // an account/contract attempts to get the coins
339     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
340         assert(super.transferFrom(_from, _to, _value));
341 
342         // transferring to the contract address destroys tokens
343         if (_to == address(this)) {
344             balanceOf[_to] -= _value;
345             totalSupply -= _value;
346         }
347 
348         if (events == 0x0)
349             return;
350 
351         BancorEventsInterface eventsContract = BancorEventsInterface(events);
352         eventsContract.tokenTransfer(_from, _to, _value);
353         return true;
354     }
355 
356     // allow another account/contract to spend some tokens on your behalf
357     function approve(address _spender, uint256 _value) public returns (bool success) {
358         assert(super.approve(_spender, _value));
359         if (events == 0x0)
360             return true;
361 
362         BancorEventsInterface eventsContract = BancorEventsInterface(events);
363         eventsContract.tokenApproval(msg.sender, _spender, _value);
364         return true;
365     }
366 
367     // utility
368 
369     function dispatchChangerUpdate(address _prevChanger, address _newChanger) private {
370         ChangerUpdate(_prevChanger, _newChanger);
371         if (events == 0x0)
372             return;
373 
374         BancorEventsInterface eventsContract = BancorEventsInterface(events);
375         eventsContract.tokenChangerUpdate(_prevChanger, _newChanger);
376     }
377 
378     function dispatchTransfer(address _from, address _to, uint256 _value) private {
379         Transfer(_from, _to, _value);
380         if (events == 0x0)
381             return;
382 
383         BancorEventsInterface eventsContract = BancorEventsInterface(events);
384         eventsContract.tokenTransfer(_from, _to, _value);
385     }
386 
387     // fallback
388     function() {
389         assert(false);
390     }
391 }
