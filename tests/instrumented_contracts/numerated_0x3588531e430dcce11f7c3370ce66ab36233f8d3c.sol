1 /*
2 file:   AUDR.sol
3 ver:    0.0.1_deploy
4 author: OnRamp Technologies Pty Ltd
5 date:   18-Sep-2018
6 email:  support@onramp.tech
7 
8 Licence
9 -------
10 (c) 2018 OnRamp Technologies Pty Ltd
11 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and sell copies of the Software (or any combination of that), and to permit persons to whom the Software is furnished to do so, subject to the following fundamental conditions:
12 1. The above copyright notice and this permission notice must be included in all copies or substantial portions of the Software.
13 2. Subject only to the extent to which applicable law cannot be excluded, modified or limited:
14 2.1	The Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and non-infringement of third party rights.
15 2.2	In no event will the authors, copyright holders or other persons in any way associated with any of them be liable for any claim, damages or other liability, whether in an action of contract, tort, fiduciary duties or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software (including, without limitation, for any direct, indirect, special, consequential or other damages, in any case, whether for any lost profits, business interruption, loss of information or programs or other data or otherwise) even if any of the authors, copyright holders or other persons associated with any of them is expressly advised of the possibility of such damages.
16 2.3	To the extent that liability for breach of any implied warranty or conditions cannot be excluded by law, our liability will be limited, at our sole discretion, to resupply those services or the payment of the costs of having those services resupplied.
17 The Software includes small (not substantial) portions of other software which was available under the MIT License.  Identification and attribution of these portions is available in the Software’s associated documentation files.
18 
19 Release Notes
20 -------------
21 * Onramp.tech tokenises real assets. Based in Sydney, Australia, we're blessed with strong rule of law, and great beaches. Welcome to OnRamp.
22 
23 * This contract is AUDR - providing a regulated fiat to cryptoverse on/off ramp - Applicants apply, if successful send AUD fiat, will receive ERC20 AUDR tokens in their Ethereum wallet.
24 
25 * see https://onramp.tech/ for further information
26 
27 Dedications
28 -------------
29 * In every wood, in every spring, there is a different green. x CREW x
30 
31 */
32 
33 
34 pragma solidity ^0.4.17;
35 
36 
37 contract AUDRConfig
38 {
39     // ERC20 token name
40     string  public constant name            = "AUD Ramp";
41 
42     // ERC20 trading symbol
43     string  public constant symbol          = "AUDR";
44 
45     // Contract owner at time of deployment.
46     address public constant OWNER           = 0x8579A678Fc76cAe308ca280B58E2b8f2ddD41913;
47 
48     // Contract 2nd admin
49     address public constant ADMIN_TOO           = 0xE7e10A474b7604Cfaf5875071990eF46301c209c;
50 
51     // Opening Supply
52     uint    public constant TOTAL_TOKENS    = 10;
53 
54     // ERC20 decimal places
55     uint8   public constant decimals        = 18;
56 
57 
58 }
59 
60 
61 library SafeMath
62 {
63     // a add to b
64     function add(uint a, uint b) internal pure returns (uint c) {
65         c = a + b;
66         assert(c >= a);
67     }
68 
69     // a subtract b
70     function sub(uint a, uint b) internal pure returns (uint c) {
71         c = a - b;
72         assert(c <= a);
73     }
74 
75     // a multiplied by b
76     function mul(uint a, uint b) internal pure returns (uint c) {
77         c = a * b;
78         assert(a == 0 || c / a == b);
79     }
80 
81     // a divided by b
82     function div(uint a, uint b) internal pure returns (uint c) {
83         assert(b != 0);
84         c = a / b;
85     }
86 }
87 
88 
89 contract ReentryProtected
90 {
91     // The reentry protection state mutex.
92     bool __reMutex;
93 
94     // Sets and clears mutex in order to block function reentry
95     modifier preventReentry() {
96         require(!__reMutex);
97         __reMutex = true;
98         _;
99         delete __reMutex;
100     }
101 
102     // Blocks function entry if mutex is set
103     modifier noReentry() {
104         require(!__reMutex);
105         _;
106     }
107 }
108 
109 
110 contract ERC20Token
111 {
112     using SafeMath for uint;
113 
114 /* Constants */
115 
116     // none
117 
118 /* State variable */
119 
120     /// @return The Total supply of tokens
121     uint public totalSupply;
122 
123     /// @return Tokens owned by an address
124     mapping (address => uint) balances;
125 
126     /// @return Tokens spendable by a thridparty
127     mapping (address => mapping (address => uint)) allowed;
128 
129 /* Events */
130 
131     // Triggered when tokens are transferred.
132     event Transfer(
133         address indexed _from,
134         address indexed _to,
135         uint256 _amount);
136 
137     // Triggered whenever approve(address _spender, uint256 _amount) is called.
138     event Approval(
139         address indexed _owner,
140         address indexed _spender,
141         uint256 _amount);
142 
143 /* Modifiers */
144 
145     // none
146 
147 /* Functions */
148 
149     // Using an explicit getter allows for function overloading
150     function balanceOf(address _addr)
151         public
152         view
153         returns (uint)
154     {
155         return balances[_addr];
156     }
157 
158     // Quick checker on total supply
159     function currentSupply()
160         public
161         view
162         returns (uint)
163     {
164         return totalSupply;
165     }
166 
167 
168     // Using an explicit getter allows for function overloading
169     function allowance(address _owner, address _spender)
170         public
171         constant
172         returns (uint)
173     {
174         return allowed[_owner][_spender];
175     }
176 
177     // Send _value amount of tokens to address _to
178     function transfer(address _to, uint256 _amount)
179         public
180         returns (bool)
181     {
182         return xfer(msg.sender, _to, _amount);
183     }
184 
185     // Send _value amount of tokens from address _from to address _to
186     function transferFrom(address _from, address _to, uint256 _amount)
187         public
188         returns (bool)
189     {
190         require(_amount <= allowed[_from][msg.sender]);
191 
192         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
193         return xfer(_from, _to, _amount);
194     }
195 
196     // Process a transfer internally.
197     function xfer(address _from, address _to, uint _amount)
198         internal
199         returns (bool)
200     {
201         require(_amount <= balances[_from]);
202 
203         emit Transfer(_from, _to, _amount);
204 
205         // avoid wasting gas on 0 token transfers
206         if(_amount == 0) return true;
207 
208         balances[_from] = balances[_from].sub(_amount);
209         balances[_to]   = balances[_to].add(_amount);
210 
211         return true;
212     }
213 
214     // Approves a third-party spender
215     function approve(address _spender, uint256 _amount)
216         public
217         returns (bool)
218     {
219         allowed[msg.sender][_spender] = _amount;
220         emit Approval(msg.sender, _spender, _amount);
221         return true;
222     }
223 }
224 
225 
226 
227 contract AUDRAbstract
228 {
229 
230     /// @dev Logged when new owner accepts ownership
231     /// @param _from the old owner address
232     /// @param _to the new owner address
233     event ChangedOwner(address indexed _from, address indexed _to);
234 
235     /// @dev Logged when owner initiates a change of ownership
236     /// @param _to the new owner address
237     event ChangeOwnerTo(address indexed _to);
238 
239     /// @dev Logged when new adminToo accepts the role
240     /// @param _from the old owner address
241     /// @param _to the new owner address
242     event ChangedAdminToo(address indexed _from, address indexed _to);
243 
244     /// @dev Logged when owner initiates a change of ownership
245     /// @param _to the new owner address
246     event ChangeAdminToo(address indexed _to);
247 
248 // State Variables
249 //
250 
251     /// @dev An address permissioned to enact owner restricted functions
252     /// @return owner
253     address public owner;
254 
255     /// @dev An address permissioned to take ownership of the contract
256     /// @return new owner address
257     address public newOwner;
258 
259     /// @dev An address used in the withdrawal process
260     /// @return adminToo
261     address public adminToo;
262 
263     /// @dev An address permissioned to become the withdrawal process address
264     /// @return new admin address
265     address public newAdminToo;
266 
267 //
268 // Modifiers
269 //
270 
271     modifier onlyOwner() {
272         require(msg.sender == owner);
273         _;
274     }
275 
276 //
277 // Function Abstracts
278 //
279 
280 
281     /// @notice Make bulk transfer of tokens to many addresses
282     /// @param _addrs An array of recipient addresses
283     /// @param _amounts An array of amounts to transfer to respective addresses
284     /// @return Boolean success value
285     function transferToMany(address[] _addrs, uint[] _amounts)
286         public returns (bool);
287 
288     /// @notice Salvage `_amount` tokens at `_kaddr` and send them to `_to`
289     /// @param _kAddr An ERC20 contract address
290     /// @param _to and address to send tokens
291     /// @param _amount The number of tokens to transfer
292     /// @return Boolean success value
293     function transferExternalToken(address _kAddr, address _to, uint _amount)
294         public returns (bool);
295 }
296 
297 
298 /*-----------------------------------------------------------------------------\
299 
300 AUDR implementation
301 
302 \*----------------------------------------------------------------------------*/
303 
304 contract AUDR is
305     ReentryProtected,
306     ERC20Token,
307     AUDRAbstract,
308     AUDRConfig
309 {
310     using SafeMath for uint;
311 
312 //
313 // Constants
314 //
315 
316     // Token fixed point for decimal places
317     uint constant TOKEN = uint(10)**decimals;
318 
319 
320 //
321 // Functions
322 //
323 
324     constructor()
325         public
326     {
327 
328         owner = OWNER;
329         adminToo = ADMIN_TOO;
330         totalSupply = TOTAL_TOKENS.mul(TOKEN);
331         balances[owner] = totalSupply;
332 
333     }
334 
335     // Default function.
336     function ()
337         public
338         payable
339     {
340         // nothing to see here, folks....
341     }
342 
343 
344 //
345 // Manage supply
346 //
347 
348 event LowerSupply(address indexed burner, uint256 value);
349 event IncreaseSupply(address indexed burner, uint256 value);
350 
351     /**
352      * @dev lowers the supply by a specified amount of tokens.
353      * @param _value The amount of tokens to lower the supply by.
354      */
355 
356     function lowerSupply(uint256 _value)
357         public
358         onlyOwner {
359             require(_value > 0);
360             address burner = adminToo;
361             balances[burner] = balances[burner].sub(_value);
362             totalSupply = totalSupply.sub(_value);
363             emit LowerSupply(msg.sender, _value);
364     }
365 
366     function increaseSupply(uint256 _value)
367         public
368         onlyOwner {
369             require(_value > 0);
370             totalSupply = totalSupply.add(_value);
371             balances[owner] = balances[owner].add(_value);
372             emit IncreaseSupply(msg.sender, _value);
373     }
374 
375 
376 
377 
378 //
379 // ERC20 additional functions
380 //
381 
382     // Allows a sender to transfer tokens to an array of recipients
383     function transferToMany(address[] _addrs, uint[] _amounts)
384         public
385         noReentry
386         returns (bool)
387     {
388         require(_addrs.length == _amounts.length);
389         uint len = _addrs.length;
390         for(uint i = 0; i < len; i++) {
391             xfer(msg.sender, _addrs[i], _amounts[i]);
392         }
393         return true;
394     }
395 
396    // Overload placeholder - could apply further logic
397     function xfer(address _from, address _to, uint _amount)
398         internal
399         noReentry
400         returns (bool)
401     {
402         super.xfer(_from, _to, _amount);
403         return true;
404     }
405 
406 //
407 // Contract management functions
408 //
409 
410     // Initiate a change of owner to `_owner`
411     function changeOwner(address _owner)
412         public
413         onlyOwner
414         returns (bool)
415     {
416         emit ChangeOwnerTo(_owner);
417         newOwner = _owner;
418         return true;
419     }
420 
421     // Finalise change of ownership to newOwner
422     function acceptOwnership()
423         public
424         returns (bool)
425     {
426         require(msg.sender == newOwner);
427         emit ChangedOwner(owner, msg.sender);
428         owner = newOwner;
429         delete newOwner;
430         return true;
431     }
432 
433     // Initiate a change of 2nd admin to _adminToo
434     function changeAdminToo(address _adminToo)
435         public
436         onlyOwner
437         returns (bool)
438     {
439         emit ChangeAdminToo(_adminToo);
440         newAdminToo = _adminToo;
441         return true;
442     }
443 
444     // Finalise change of 2nd admin to newAdminToo
445     function acceptAdminToo()
446         public
447         returns (bool)
448     {
449         require(msg.sender == newAdminToo);
450         emit ChangedAdminToo(adminToo, msg.sender);
451         adminToo = newAdminToo;
452         delete newAdminToo;
453         return true;
454     }
455 
456 
457 
458     // Owner can salvage ERC20 tokens that may have been sent to the account
459     function transferExternalToken(address _kAddr, address _to, uint _amount)
460         public
461         onlyOwner
462         preventReentry
463         returns (bool)
464     {
465         require(ERC20Token(_kAddr).transfer(_to, _amount));
466         return true;
467     }
468 
469 
470 }