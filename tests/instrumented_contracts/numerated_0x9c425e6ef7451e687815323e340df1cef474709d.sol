1 /*
2  file:   Trullion.sol
3  ver:    0.0.1_deploy
4  author: Trivillon
5  date:   24-Nov-2018
6  email:  support@Trullion.tech
7 
8  Licence
9  -------
10  (c) 2018 Everus-Trullion 
11    
12  Release Notes
13  -------------
14  * Trullion  Based in Kualalumpur, Malaysia , we're blessed with strong rule of law, and great beaches. Welcome to Trullion.
15 
16  * This contract is TRU, GOLD as an ERC20 token.
17 
18  * see https://Everus.org/ for further information
19 
20 */
21 
22 pragma solidity ^0.4.17;
23 
24 
25 contract TRUConfig
26 {
27     // ERC20 token name
28     string  public constant name            = "Trullion-e";
29 
30     // ERC20 trading symbol
31     string  public constant symbol          = "Tru-e";
32 
33     // Contract owner at time of deployment.
34     address public constant OWNER = 0x262f01741f2b6e6fda97bce85a6756a89c099e43;
35 
36     // Contract 2nd admin
37     address public constant ADMIN_TOO  = 0x262f01741f2b6e6fda97bce85a6756a89c099e43;
38 
39     // Opening Supply
40     uint    public constant TOTAL_TOKENS    = 0 ;
41 
42     // ERC20 decimal places
43     uint8   public constant decimals        = 8;
44 
45 
46 }
47 
48 
49 library SafeMath
50 {
51     // a add to b
52     function add(uint a, uint b) internal pure returns (uint c) {
53         c = a + b;
54         assert(c >= a);
55     }
56 
57     // a subtract b
58     function sub(uint a, uint b) internal pure returns (uint c) {
59         c = a - b;
60         assert(c <= a);
61     }
62 
63     // a multiplied by b
64     function mul(uint a, uint b) internal pure returns (uint c) {
65         c = a * b;
66         assert(a == 0 || c / a == b);
67     }
68 
69     // a divided by b
70     function div(uint a, uint b) internal pure returns (uint c) {
71         assert(b != 0);
72         c = a / b;
73     }
74 }
75 
76 
77 contract ReentryProtected
78 {
79     // The reentry protection state mutex.
80     bool __reMutex;
81 
82     // Sets and clears mutex in order to block function reentry
83     modifier preventReentry() {
84         require(!__reMutex);
85         __reMutex = true;
86         _;
87         delete __reMutex;
88     }
89 
90     // Blocks function entry if mutex is set
91     modifier noReentry() {
92         require(!__reMutex);
93         _;
94     }
95 }
96 
97 
98 contract ERC20Token
99 {
100     using SafeMath for uint;
101 
102 /* Constants */
103 
104     // none
105 
106 /* State variable */
107 
108     /// @return The Total supply of tokens
109     uint public totalSupply;
110 
111     /// @return Tokens owned by an address
112     mapping (address => uint) balances;
113 
114     /// @return Tokens spendable by a thridparty
115     mapping (address => mapping (address => uint)) allowed;
116 
117 /* Events */
118 
119     // Triggered when tokens are transferred.
120     event Transfer(
121         address indexed _from,
122         address indexed _to,
123         uint256 _amount);
124 
125     // Triggered whenever approve(address _spender, uint256 _amount) is called.
126     event Approval(
127         address indexed _owner,
128         address indexed _spender,
129         uint256 _amount);
130 
131 /* Modifiers */
132 
133     // none
134 
135 /* Functions */
136 
137     // Using an explicit getter allows for function overloading
138     function balanceOf(address _addr)
139         public
140         view
141         returns (uint)
142     {
143         return balances[_addr];
144     }
145 
146     // Quick checker on total supply
147     function currentSupply()
148         public
149         view
150         returns (uint)
151     {
152         return totalSupply;
153     }
154 
155 
156     // Using an explicit getter allows for function overloading
157     function allowance(address _owner, address _spender)
158         public
159         returns (uint)
160     {
161         return allowed[_owner][_spender];
162     }
163 
164     // Send _value amount of tokens to address _to
165     function transfer(address _to, uint256 _amount)
166         public
167         returns (bool)
168     {
169         return xfer(msg.sender, _to, _amount);
170     }
171 
172     // Send _value amount of tokens from address _from to address _to
173     function transferFrom(address _from, address _to, uint256 _amount)
174         public
175         returns (bool)
176     {
177         require(_amount <= allowed[_from][msg.sender]);
178 
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
180         return xfer(_from, _to, _amount);
181     }
182 
183     // Process a transfer internally.
184     function xfer(address _from, address _to, uint _amount)
185         internal
186         returns (bool)
187     {
188         require(_amount <= balances[_from]);
189 
190         emit Transfer(_from, _to, _amount);
191 
192         // avoid wasting gas on 0 token transfers
193         if(_amount == 0) return true;
194 
195         balances[_from] = balances[_from].sub(_amount);
196         balances[_to]   = balances[_to].add(_amount);
197 
198         return true;
199     }
200 
201     // Approves a third-party spender
202     function approve(address _spender, uint256 _amount)
203         public
204         returns (bool)
205     {
206         allowed[msg.sender][_spender] = _amount;
207         emit Approval(msg.sender, _spender, _amount);
208         return true;
209     }
210 }
211 
212 
213 
214 contract TRUAbstract
215 {
216 
217     /// @dev Logged when new owner accepts ownership
218     /// @param _from the old owner address
219     /// @param _to the new owner address
220     event ChangedOwner(address indexed _from, address indexed _to);
221 
222     /// @dev Logged when owner initiates a change of ownership
223     /// @param _to the new owner address
224     event ChangeOwnerTo(address indexed _to);
225 
226     /// @dev Logged when new adminToo accepts the role
227     /// @param _from the old owner address
228     /// @param _to the new owner address
229     event ChangedAdminToo(address indexed _from, address indexed _to);
230 
231     /// @dev Logged when owner initiates a change of ownership
232     /// @param _to the new owner address
233     event ChangeAdminToo(address indexed _to);
234 
235 // State Variables
236 //
237     /// @dev An address permissioned to enact owner restricted functions
238     /// @return owner
239     address public owner;
240 
241     /// @dev An address permissioned to take ownership of the contract
242     /// @return new owner address
243     address public newOwner;
244 
245     /// @dev An address used in the withdrawal process
246     /// @return adminToo
247     address public adminToo;
248 
249     /// @dev An address permissioned to become the withdrawal process address
250     /// @return new admin address
251     address public newAdminToo;
252 
253 //
254 // Modifiers
255 //
256 
257     modifier onlyOwner() {
258         require(msg.sender == owner);
259         _;
260     }
261 
262 //
263 // Function Abstracts
264 //
265 
266 
267     /// @notice Make bulk transfer of tokens to many addresses (Automic drop)
268     /// @param _addrs An array of recipient addresses
269     /// @param _amounts An array of amounts to transfer to respective addresses
270     /// @return Boolean success value
271  
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
287 BTCR implementation
288 
289 \*----------------------------------------------------------------------------*/
290 
291 contract TRU is
292     ReentryProtected,
293     ERC20Token,
294    TRUAbstract,
295    TRUConfig
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
311     constructor()
312         public
313     {
314 
315         owner = OWNER;
316         adminToo = ADMIN_TOO;
317         totalSupply = TOTAL_TOKENS.mul(TOKEN);
318         balances[owner] = totalSupply;
319 
320     }
321 
322     // Default function.
323     function ()
324         public
325         payable
326     {
327         // nothing to see here, folks....
328     }
329 
330 
331 //
332 // Manage supply
333 //
334 
335 event DecreaseSupply(address indexed burner, uint256 value);
336 event IncreaseSupply(address indexed burner, uint256 value);
337 
338     /**
339      * @dev lowers the supply by a specified amount of tokens.
340      * @param _value The amount of tokens to lower the supply by.
341      */
342 
343     function decreaseSupply(uint256 _value)
344         public
345         onlyOwner {
346             require(_value > 0);
347             address burner = adminToo;
348             balances[burner] = balances[burner].sub(_value);
349             totalSupply = totalSupply.sub(_value);
350             emit DecreaseSupply(msg.sender, _value);
351     }
352 
353     function increaseSupply(uint256 _value)
354         public
355         onlyOwner {
356             require(_value > 0);
357             totalSupply = totalSupply.add(_value);
358             balances[owner] = balances[owner].add(_value);
359             emit IncreaseSupply(msg.sender, _value);
360     }
361 
362 
363 
364 
365 //
366 // ERC20 additional functions
367 //
368 
369     // Allows a sender to transfer tokens to an array of recipients
370     function transferToMany(address[] _addrs, uint[] _amounts)
371         public
372         noReentry
373         returns (bool)
374     {
375         require(_addrs.length == _amounts.length);
376         uint len = _addrs.length;
377         for(uint i = 0; i < len; i++) {
378             xfer(msg.sender, _addrs[i], _amounts[i]);
379         }
380         return true;
381     }
382 
383    // Overload placeholder - could apply further logic
384     function xfer(address _from, address _to, uint _amount)
385         internal
386         noReentry
387         returns (bool)
388     {
389         super.xfer(_from, _to, _amount);
390         return true;
391     }
392 
393 //
394 // Contract management functions
395 //
396 
397     // Initiate a change of owner to `_owner`
398     function changeOwner(address _owner)
399         public
400         onlyOwner
401         returns (bool)
402     {
403         emit ChangeOwnerTo(_owner);
404         newOwner = _owner;
405         return true;
406     }
407 
408     // Finalise change of ownership to newOwner
409     function acceptOwnership()
410         public
411         returns (bool)
412     {
413         require(msg.sender == newOwner);
414         emit ChangedOwner(owner, msg.sender);
415         owner = newOwner;
416         delete newOwner;
417         return true;
418     }
419 
420     // Initiate a change of 2nd admin to _adminToo
421     function changeAdminToo(address _adminToo)
422         public
423         onlyOwner
424         returns (bool)
425     {
426         emit ChangeAdminToo(_adminToo);
427         newAdminToo = _adminToo;
428         return true;
429     }
430 
431     // Finalise change of 2nd admin to newAdminToo
432     function acceptAdminToo()
433         public
434         returns (bool)
435     {
436         require(msg.sender == newAdminToo);
437         emit ChangedAdminToo(adminToo, msg.sender);
438         adminToo = newAdminToo;
439         delete newAdminToo;
440         return true;
441     }
442 
443 
444 
445     // Owner can salvage ERC20 tokens that may have been sent to the account
446     function transferExternalToken(address _kAddr, address _to, uint _amount)
447         public
448         onlyOwner
449         preventReentry
450         returns (bool)
451     {
452         require(ERC20Token(_kAddr).transfer(_to, _amount));
453         return true;
454     }
455 
456 
457 }