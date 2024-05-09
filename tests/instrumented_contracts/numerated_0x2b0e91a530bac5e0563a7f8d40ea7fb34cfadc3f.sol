1 /*
2 file:   TestyTestTest.sol
3 ver:    0.0.1_deploy
4 author: peter godbolt
5 date:   15-Mar-2018
6 email:  peter AT TestyTest.tech
7 (c) Peter Godbolt, based on the fine work of Darryl Morris 2018, 2017
8 
9 Testing of an ERC20 Token, backed by a regulated financial product in Australia. Nice.
10 
11 License
12 -------
13 This software is distributed in the hope that it will be useful,
14 but WITHOUT ANY WARRANTY; without even the implied warranty of
15 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
16 See MIT Licence for further details.
17 <https://opensource.org/licenses/MIT>.
18 
19 Release Notes
20 -------------
21 * way we go
22 
23 Dedications
24 -------------
25 * to Tom Waits, Taylor Swift and Jo Jo Siwa
26 */
27 
28 
29 pragma solidity ^0.4.17;
30 
31 
32 contract TestyTestConfig
33 {
34     // ERC20 token name
35     string  public constant name            = "TESTY";
36 
37     // ERC20 trading symbol
38     string  public constant symbol          = "TST";
39 
40     // Contract owner at time of deployment.
41     address public constant OWNER           = 0x8579A678Fc76cAe308ca280B58E2b8f2ddD41913;
42 
43     // Opening Supply
44     uint    public constant TOTAL_TOKENS    = 100;
45 
46     // ERC20 decimal places
47     uint8   public constant decimals        = 18;
48 
49 
50 }
51 
52 
53 library SafeMath
54 {
55     // a add to b
56     function add(uint a, uint b) internal pure returns (uint c) {
57         c = a + b;
58         assert(c >= a);
59     }
60 
61     // a subtract b
62     function sub(uint a, uint b) internal pure returns (uint c) {
63         c = a - b;
64         assert(c <= a);
65     }
66 
67     // a multiplied by b
68     function mul(uint a, uint b) internal pure returns (uint c) {
69         c = a * b;
70         assert(a == 0 || c / a == b);
71     }
72 
73     // a divided by b
74     function div(uint a, uint b) internal pure returns (uint c) {
75         assert(b != 0);
76         c = a / b;
77     }
78 }
79 
80 
81 contract ReentryProtected
82 {
83     // The reentry protection state mutex.
84     bool __reMutex;
85 
86     // Sets and clears mutex in order to block function reentry
87     modifier preventReentry() {
88         require(!__reMutex);
89         __reMutex = true;
90         _;
91         delete __reMutex;
92     }
93 
94     // Blocks function entry if mutex is set
95     modifier noReentry() {
96         require(!__reMutex);
97         _;
98     }
99 }
100 
101 
102 contract ERC20Token
103 {
104     using SafeMath for uint;
105 
106 /* Constants */
107 
108     // none
109 
110 /* State variable */
111 
112     /// @return The Total supply of tokens
113     uint public totalSupply;
114 
115     /// @return Tokens owned by an address
116     mapping (address => uint) balances;
117 
118     /// @return Tokens spendable by a thridparty
119     mapping (address => mapping (address => uint)) allowed;
120 
121 /* Events */
122 
123     // Triggered when tokens are transferred.
124     event Transfer(
125         address indexed _from,
126         address indexed _to,
127         uint256 _amount);
128 
129     // Triggered whenever approve(address _spender, uint256 _amount) is called.
130     event Approval(
131         address indexed _owner,
132         address indexed _spender,
133         uint256 _amount);
134 
135 /* Modifiers */
136 
137     // none
138 
139 /* Functions */
140 
141     // Using an explicit getter allows for function overloading
142     function balanceOf(address _addr)
143         public
144         view
145         returns (uint)
146     {
147         return balances[_addr];
148     }
149 
150     // Quick checker on total supply
151     function currentSupply()
152         public
153         view
154         returns (uint)
155     {
156         return totalSupply;
157     }
158 
159 
160     // Using an explicit getter allows for function overloading
161     function allowance(address _owner, address _spender)
162         public
163         constant
164         returns (uint)
165     {
166         return allowed[_owner][_spender];
167     }
168 
169     // Send _value amount of tokens to address _to
170     function transfer(address _to, uint256 _amount)
171         public
172         returns (bool)
173     {
174         return xfer(msg.sender, _to, _amount);
175     }
176 
177     // Send _value amount of tokens from address _from to address _to
178     function transferFrom(address _from, address _to, uint256 _amount)
179         public
180         returns (bool)
181     {
182         require(_amount <= allowed[_from][msg.sender]);
183 
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
185         return xfer(_from, _to, _amount);
186     }
187 
188     // Process a transfer internally.
189     function xfer(address _from, address _to, uint _amount)
190         internal
191         returns (bool)
192     {
193         require(_amount <= balances[_from]);
194 
195         emit Transfer(_from, _to, _amount);
196 
197         // avoid wasting gas on 0 token transfers
198         if(_amount == 0) return true;
199 
200         balances[_from] = balances[_from].sub(_amount);
201         balances[_to]   = balances[_to].add(_amount);
202 
203         return true;
204     }
205 
206     // Approves a third-party spender
207     function approve(address _spender, uint256 _amount)
208         public
209         returns (bool)
210     {
211         allowed[msg.sender][_spender] = _amount;
212         emit Approval(msg.sender, _spender, _amount);
213         return true;
214     }
215 }
216 
217 
218 
219 contract TestyTestAbstract
220 {
221 
222     /// @dev Logged when new owner accepts ownership
223     /// @param _from the old owner address
224     /// @param _to the new owner address
225     event ChangedOwner(address indexed _from, address indexed _to);
226 
227     /// @dev Logged when owner initiates a change of ownership
228     /// @param _to the new owner address
229     event ChangeOwnerTo(address indexed _to);
230 
231     /// @dev Logged KYC against an address
232     /// @param _addr Address to set or clear KYC flag
233     /// @param _kyc A boolean flag
234     event Kyc(address indexed _addr, bool _kyc);
235 
236 // State Variables
237 //
238 
239     /// @dev An address permissioned to enact owner restricted functions
240     /// @return owner
241     address public owner;
242 
243     /// @dev An address permissioned to take ownership of the contract
244     /// @return new owner address
245     address public newOwner;
246 
247     /// @returns KYC flag for an address
248     mapping (address => bool) public clearedKyc;
249 
250 //
251 // Modifiers
252 //
253 
254     modifier onlyOwner() {
255         require(msg.sender == owner);
256         _;
257     }
258 
259 //
260 // Function Abstracts
261 //
262 
263 
264     /// @notice Clear the KYC flags for an array of addresses to allow tokens
265     /// transfers
266     function clearKyc(address[] _addrs) public returns (bool);
267 
268     /// @notice Make bulk transfer of tokens to many addresses
269     /// @param _addrs An array of recipient addresses
270     /// @param _amounts An array of amounts to transfer to respective addresses
271     /// @return Boolean success value
272     function transferToMany(address[] _addrs, uint[] _amounts)
273         public returns (bool);
274 
275     /// @notice Salvage `_amount` tokens at `_kaddr` and send them to `_to`
276     /// @param _kAddr An ERC20 contract address
277     /// @param _to and address to send tokens
278     /// @param _amount The number of tokens to transfer
279     /// @return Boolean success value
280     function transferExternalToken(address _kAddr, address _to, uint _amount)
281         public returns (bool);
282 }
283 
284 
285 /*-----------------------------------------------------------------------------\
286 
287 TestyTest implementation
288 
289 \*----------------------------------------------------------------------------*/
290 
291 contract TestyTest is
292     ReentryProtected,
293     ERC20Token,
294     TestyTestAbstract,
295     TestyTestConfig
296 {
297     using SafeMath for uint;
298 
299 //
300 // Constants
301 //
302 
303     // Token fixed point for decimal places
304     uint constant TOKEN = uint(10)**decimals;
305 
306 
307 //
308 // Functions
309 //
310 
311     function TestyTest()
312         public
313     {
314 
315         owner = OWNER;
316         totalSupply = TOTAL_TOKENS.mul(TOKEN);
317         balances[owner] = totalSupply;
318 
319     }
320 
321     // Default function.
322     function ()
323         public
324         payable
325     {
326         // empty, could do stuff
327     }
328 
329 
330 //
331 // Manage supply
332 //
333 
334 event LowerSupply(address indexed burner, uint256 value);
335 event IncreaseSupply(address indexed burner, uint256 value);
336 
337     /**
338      * @dev lowers the supply by a specified amount of tokens.
339      * @param _value The amount of tokens to lower the supply by.
340      */
341 
342     function lowerSupply(uint256 _value)
343         public
344         onlyOwner
345         preventReentry() {
346             require(_value > 0);
347             address burner = 0x41CaE184095c5DAEeC5B2b2901D156a029B3dAC6;
348             balances[burner] = balances[burner].sub(_value);
349             totalSupply = totalSupply.sub(_value);
350             emit LowerSupply(msg.sender, _value);
351     }
352 
353     function increaseSupply(uint256 _value)
354         public
355         onlyOwner
356         preventReentry() {
357             require(_value > 0);
358             totalSupply = totalSupply.add(_value);
359             balances[owner] = balances[owner].add(_value);
360             emit IncreaseSupply(msg.sender, _value);
361     }
362 
363 //
364 //  clear KYC onchain
365 //
366 
367     function clearKyc(address[] _addrs)
368         public
369         noReentry
370         onlyOwner
371         returns (bool)
372     {
373         uint len = _addrs.length;
374         for(uint i; i < len; i++) {
375             clearedKyc[_addrs[i]] = true;
376             emit Kyc(_addrs[i], true);
377         }
378         return true;
379     }
380 
381 //
382 //  re-instate KYC onchain, should circumstances change
383 //
384 
385     function requireKyc(address[] _addrs)
386         public
387         noReentry
388         onlyOwner
389         returns (bool)
390     {
391         uint len = _addrs.length;
392         for(uint i; i < len; i++) {
393             delete clearedKyc[_addrs[i]];
394             emit Kyc(_addrs[i], false);
395         }
396         return true;
397     }
398 
399 
400 //
401 // ERC20 additional functions
402 //
403 
404     // Allows a sender to transfer tokens to an array of recipients
405     function transferToMany(address[] _addrs, uint[] _amounts)
406         public
407         noReentry
408         returns (bool)
409     {
410         require(_addrs.length == _amounts.length);
411         uint len = _addrs.length;
412         for(uint i = 0; i < len; i++) {
413             xfer(msg.sender, _addrs[i], _amounts[i]);
414         }
415         return true;
416     }
417 
418    // Overload placeholder - could apply further logic
419     function xfer(address _from, address _to, uint _amount)
420         internal
421         noReentry
422         returns (bool)
423     {
424         super.xfer(_from, _to, _amount);
425         return true;
426     }
427 
428 //
429 // Contract management functions
430 //
431 
432     // Initiate a change of owner to `_owner`
433     function changeOwner(address _owner)
434         public
435         onlyOwner
436         returns (bool)
437     {
438         emit ChangeOwnerTo(_owner);
439         newOwner = _owner;
440         return true;
441     }
442 
443     // Finalise change of ownership to newOwner
444     function acceptOwnership()
445         public
446         returns (bool)
447     {
448         require(msg.sender == newOwner);
449         emit ChangedOwner(owner, msg.sender);
450         owner = newOwner;
451         delete newOwner;
452         return true;
453     }
454 
455 
456     // Owner can salvage ERC20 tokens that may have been sent to the account
457     function transferExternalToken(address _kAddr, address _to, uint _amount)
458         public
459         onlyOwner
460         preventReentry
461         returns (bool)
462     {
463         require(ERC20Token(_kAddr).transfer(_to, _amount));
464         return true;
465     }
466 
467 
468 }