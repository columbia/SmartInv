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
150     // Using an explicit getter allows for function overloading
151     function allowance(address _owner, address _spender)
152         public
153         constant
154         returns (uint)
155     {
156         return allowed[_owner][_spender];
157     }
158 
159     // Send _value amount of tokens to address _to
160     function transfer(address _to, uint256 _amount)
161         public
162         returns (bool)
163     {
164         return xfer(msg.sender, _to, _amount);
165     }
166 
167     // Send _value amount of tokens from address _from to address _to
168     function transferFrom(address _from, address _to, uint256 _amount)
169         public
170         returns (bool)
171     {
172         require(_amount <= allowed[_from][msg.sender]);
173 
174         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
175         return xfer(_from, _to, _amount);
176     }
177 
178     // Process a transfer internally.
179     function xfer(address _from, address _to, uint _amount)
180         internal
181         returns (bool)
182     {
183         require(_amount <= balances[_from]);
184 
185         emit Transfer(_from, _to, _amount);
186 
187         // avoid wasting gas on 0 token transfers
188         if(_amount == 0) return true;
189 
190         balances[_from] = balances[_from].sub(_amount);
191         balances[_to]   = balances[_to].add(_amount);
192 
193         return true;
194     }
195 
196     // Approves a third-party spender
197     function approve(address _spender, uint256 _amount)
198         public
199         returns (bool)
200     {
201         allowed[msg.sender][_spender] = _amount;
202         emit Approval(msg.sender, _spender, _amount);
203         return true;
204     }
205 }
206 
207 
208 
209 contract TestyTestAbstract
210 {
211 
212     /// @dev Logged when new owner accepts ownership
213     /// @param _from the old owner address
214     /// @param _to the new owner address
215     event ChangedOwner(address indexed _from, address indexed _to);
216 
217     /// @dev Logged when owner initiates a change of ownership
218     /// @param _to the new owner address
219     event ChangeOwnerTo(address indexed _to);
220 
221     /// @dev Logged KYC against an address
222     /// @param _addr Address to set or clear KYC flag
223     /// @param _kyc A boolean flag
224     event Kyc(address indexed _addr, bool _kyc);
225 
226 // State Variables
227 //
228 
229     /// @dev An address permissioned to enact owner restricted functions
230     /// @return owner
231     address public owner;
232 
233     /// @dev An address permissioned to take ownership of the contract
234     /// @return new owner address
235     address public newOwner;
236 
237     /// @returns KYC flag for an address
238     mapping (address => bool) public clearedKyc;
239 
240 //
241 // Modifiers
242 //
243 
244     modifier onlyOwner() {
245         require(msg.sender == owner);
246         _;
247     }
248 
249 //
250 // Function Abstracts
251 //
252 
253 
254     /// @notice Clear the KYC flags for an array of addresses to allow tokens
255     /// transfers
256     function clearKyc(address[] _addrs) public returns (bool);
257 
258     /// @notice Make bulk transfer of tokens to many addresses
259     /// @param _addrs An array of recipient addresses
260     /// @param _amounts An array of amounts to transfer to respective addresses
261     /// @return Boolean success value
262     function transferToMany(address[] _addrs, uint[] _amounts)
263         public returns (bool);
264 
265     /// @notice Salvage `_amount` tokens at `_kaddr` and send them to `_to`
266     /// @param _kAddr An ERC20 contract address
267     /// @param _to and address to send tokens
268     /// @param _amount The number of tokens to transfer
269     /// @return Boolean success value
270     function transferExternalToken(address _kAddr, address _to, uint _amount)
271         public returns (bool);
272 }
273 
274 
275 /*-----------------------------------------------------------------------------\
276 
277 TestyTest implementation
278 
279 \*----------------------------------------------------------------------------*/
280 
281 contract TestyTest is
282     ReentryProtected,
283     ERC20Token,
284     TestyTestAbstract,
285     TestyTestConfig
286 {
287     using SafeMath for uint;
288 
289 //
290 // Constants
291 //
292 
293     // Token fixed point for decimal places
294     uint constant TOKEN = uint(10)**decimals;
295 
296 
297 //
298 // Functions
299 //
300 
301     function TestyTest()
302         public
303     {
304 
305         owner = OWNER;
306         totalSupply = TOTAL_TOKENS.mul(TOKEN);
307 
308     }
309 
310     // Default function.
311     function ()
312         public
313         payable
314     {
315         // empty, could do stuff
316     }
317 
318 
319 //
320 // Manage supply
321 //
322 
323 event LowerSupply(address indexed burner, uint256 value);
324 event IncreaseSupply(address indexed burner, uint256 value);
325 
326     /**
327      * @dev lowers the supply by a specified amount of tokens.
328      * @param _value The amount of tokens to lower the supply by.
329      */
330 
331     function lowerSupply(uint256 _value)
332         public
333         onlyOwner
334         preventReentry() {
335             require(_value > 0);
336             address burner = 0x41CaE184095c5DAEeC5B2b2901D156a029B3dAC6;
337             balances[burner] = balances[burner].sub(_value);
338             totalSupply = totalSupply.sub(_value);
339             emit LowerSupply(msg.sender, _value);
340     }
341 
342     function increaseSupply(uint256 _value)
343         public
344         onlyOwner
345         preventReentry() {
346             require(_value > 0);
347             totalSupply = totalSupply.add(_value);
348             emit IncreaseSupply(msg.sender, _value);
349     }
350 
351 //
352 //  clear KYC onchain
353 //
354 
355     function clearKyc(address[] _addrs)
356         public
357         noReentry
358         onlyOwner
359         returns (bool)
360     {
361         uint len = _addrs.length;
362         for(uint i; i < len; i++) {
363             clearedKyc[_addrs[i]] = true;
364             emit Kyc(_addrs[i], true);
365         }
366         return true;
367     }
368 
369 //
370 //  re-instate KYC onchain, should circumstances change
371 //
372 
373     function requireKyc(address[] _addrs)
374         public
375         noReentry
376         onlyOwner
377         returns (bool)
378     {
379         uint len = _addrs.length;
380         for(uint i; i < len; i++) {
381             delete clearedKyc[_addrs[i]];
382             emit Kyc(_addrs[i], false);
383         }
384         return true;
385     }
386 
387 
388 //
389 // ERC20 additional functions
390 //
391 
392     // Allows a sender to transfer tokens to an array of recipients
393     function transferToMany(address[] _addrs, uint[] _amounts)
394         public
395         noReentry
396         returns (bool)
397     {
398         require(_addrs.length == _amounts.length);
399         uint len = _addrs.length;
400         for(uint i = 0; i < len; i++) {
401             xfer(msg.sender, _addrs[i], _amounts[i]);
402         }
403         return true;
404     }
405 
406    // Overload placeholder - could apply further logic
407     function xfer(address _from, address _to, uint _amount)
408         internal
409         noReentry
410         returns (bool)
411     {
412         super.xfer(_from, _to, _amount);
413         return true;
414     }
415 
416 //
417 // Contract management functions
418 //
419 
420     // Initiate a change of owner to `_owner`
421     function changeOwner(address _owner)
422         public
423         onlyOwner
424         returns (bool)
425     {
426         emit ChangeOwnerTo(_owner);
427         newOwner = _owner;
428         return true;
429     }
430 
431     // Finalise change of ownership to newOwner
432     function acceptOwnership()
433         public
434         returns (bool)
435     {
436         require(msg.sender == newOwner);
437         emit ChangedOwner(owner, msg.sender);
438         owner = newOwner;
439         delete newOwner;
440         return true;
441     }
442 
443 
444     // Owner can salvage ERC20 tokens that may have been sent to the account
445     function transferExternalToken(address _kAddr, address _to, uint _amount)
446         public
447         onlyOwner
448         preventReentry
449         returns (bool)
450     {
451         require(ERC20Token(_kAddr).transfer(_to, _amount));
452         return true;
453     }
454 
455 
456 }