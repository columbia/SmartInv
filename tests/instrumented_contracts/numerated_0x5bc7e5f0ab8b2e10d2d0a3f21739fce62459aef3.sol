1 /*
2 file:   Hut34ENTRP.sol
3 ver:    0.1.0
4 author: Darryl Morris
5 date:   19-12-2017
6 email:  o0ragman0o AT gmail.com
7 (c) Darryl Morris 2017
8 
9 A collated contract set for the receipt of funds and production and transfer
10 of ERC20 tokens as specified by Hut34.
11 
12 License
13 -------
14 This software is distributed in the hope that it will be useful,
15 but WITHOUT ANY WARRANTY; without even the implied warranty of
16 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
17 See MIT Licence for further details.
18 <https://opensource.org/licenses/MIT>.
19 
20 -------------
21 Release Notes
22 -------------
23 * Reissuence of Hut34 ENT tokens as ENTRP tokens due to post sale offchain
24 bulk transfer tool bug, and desire to update ticker / symbol.
25 
26 Dedications
27 -------------
28 * With love to Isabella and Molly from your dad
29 * xx to Edie, Robin, William and Charlotte x
30 */
31 
32 pragma solidity ^0.4.17;
33 
34 contract Hut34Config
35 {
36     // ERC20 token name
37     string  public constant name            = "Hut34 Entropy Token";
38     
39     // ERC20 trading symbol
40     string  public constant symbol          = "ENTRP";
41 
42     // ERC20 decimal places
43     uint8   public constant decimals        = 18;
44 
45     // Total supply (* in unit ENT *)
46     uint    public constant TOTAL_TOKENS    = 100000000;
47 
48     // Contract owner at time of deployment.
49     address public constant OWNER           = 0xdA3780Cff2aE3a59ae16eC1734DEec77a7fd8db2;
50 
51     // A Hut34 address to own tokens
52     address public constant HUT34_RETAIN    = 0x3135F4acA3C1Ad4758981500f8dB20EbDc5A1caB;
53     
54     // A Hut34 address to accept raised funds
55     address public constant HUT34_WALLET    = 0xA70d04dC4a64960c40CD2ED2CDE36D76CA4EDFaB;
56     
57     // Percentage of tokens to be vested over 2 years. 20%
58     uint    public constant VESTED_PERCENT  = 20;
59 
60     // Vesting period
61     uint    public constant VESTING_PERIOD  = 26 weeks;
62 
63     // Origional Token sale contract with misallocated post token sale whitelist, see https://medium.com/@hut34project/entropy-token-reissuance-f37a8574c05c
64     address public constant REPLACES        = 0x9901ed1e649C4a77C7Fff3dFd446ffE3464da747;
65 }
66 
67 
68 library SafeMath
69 {
70     // a add to b
71     function add(uint a, uint b) internal pure returns (uint c) {
72         c = a + b;
73         assert(c >= a);
74     }
75     
76     // a subtract b
77     function sub(uint a, uint b) internal pure returns (uint c) {
78         c = a - b;
79         assert(c <= a);
80     }
81     
82     // a multiplied by b
83     function mul(uint a, uint b) internal pure returns (uint c) {
84         c = a * b;
85         assert(a == 0 || c / a == b);
86     }
87     
88     // a divided by b
89     function div(uint a, uint b) internal pure returns (uint c) {
90         assert(b != 0);
91         c = a / b;
92     }
93 }
94 
95 
96 contract ERC20Token
97 {
98     using SafeMath for uint;
99 
100 /* Constants */
101 
102     // none
103     
104 /* State variable */
105 
106     /// @return The Total supply of tokens
107     uint public totalSupply;
108     
109     /// @return Tokens owned by an address
110     mapping (address => uint) balances;
111     
112     /// @return Tokens spendable by a thridparty
113     mapping (address => mapping (address => uint)) allowed;
114 
115 /* Events */
116 
117     // Triggered when tokens are transferred.
118     event Transfer(
119         address indexed _from,
120         address indexed _to,
121         uint256 _amount);
122 
123     // Triggered whenever approve(address _spender, uint256 _amount) is called.
124     event Approval(
125         address indexed _owner,
126         address indexed _spender,
127         uint256 _amount);
128 
129 /* Modifiers */
130 
131     // none
132     
133 /* Functions */
134 
135     // Using an explicit getter allows for function overloading    
136     function balanceOf(address _addr)
137         public
138         view
139         returns (uint)
140     {
141         return balances[_addr];
142     }
143     
144     // Using an explicit getter allows for function overloading    
145     function allowance(address _owner, address _spender)
146         public
147         constant
148         returns (uint)
149     {
150         return allowed[_owner][_spender];
151     }
152 
153     // Send _value amount of tokens to address _to
154     function transfer(address _to, uint256 _amount)
155         public
156         returns (bool)
157     {
158         return xfer(msg.sender, _to, _amount);
159     }
160 
161     // Send _value amount of tokens from address _from to address _to
162     function transferFrom(address _from, address _to, uint256 _amount)
163         public
164         returns (bool)
165     {
166         require(_amount <= allowed[_from][msg.sender]);
167         
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
169         return xfer(_from, _to, _amount);
170     }
171 
172     // Process a transfer internally.
173     function xfer(address _from, address _to, uint _amount)
174         internal
175         returns (bool)
176     {
177         require(_amount <= balances[_from]);
178 
179         Transfer(_from, _to, _amount);
180         
181         // avoid wasting gas on 0 token transfers
182         if(_amount == 0) return true;
183         
184         balances[_from] = balances[_from].sub(_amount);
185         balances[_to]   = balances[_to].add(_amount);
186         
187         return true;
188     }
189 
190     // Approves a third-party spender
191     function approve(address _spender, uint256 _amount)
192         public
193         returns (bool)
194     {
195         allowed[msg.sender][_spender] = _amount;
196         Approval(msg.sender, _spender, _amount);
197         return true;
198     }
199 }
200 
201 
202 contract Hut34ENTRPAbstract
203 {
204     /// @dev Logged when new owner accepts ownership
205     /// @param _from the old owner address
206     /// @param _to the new owner address
207     event ChangedOwner(address indexed _from, address indexed _to);
208     
209     /// @dev Logged when owner initiates a change of ownership
210     /// @param _to the new owner address
211     event ChangeOwnerTo(address indexed _to);
212     
213     /// @dev Logged when vested tokens are released back to HUT32_WALLET
214     /// @param _releaseDate The official release date (even if released at
215     /// later date)
216     event VestingReleased(uint _releaseDate);
217 
218 //
219 // Constants
220 //
221 
222     // The Hut34 vesting 'psudo-address' for transferring and releasing vested
223     // tokens to the Hut34 Wallet. The address is UTF8 encoding of the
224     // string and can only be accessed by the 'releaseVested()' function.
225     // `0x48757433342056657374696e6700000000000000`
226     address public constant HUT34_VEST_ADDR = address(bytes20("Hut34 Vesting"));
227 
228 //
229 // State Variables
230 //
231 
232     /// @dev An address permissioned to enact owner restricted functions
233     /// @return owner
234     address public owner;
235     
236     /// @dev An address permissioned to take ownership of the contract
237     /// @return new owner address
238     address public newOwner;
239 
240     /// @returns Date of next vesting release
241     uint public nextReleaseDate;
242 
243 //
244 // Modifiers
245 //
246 
247     modifier onlyOwner() {
248         require(msg.sender == owner);
249         _;
250     }
251 
252 //
253 // Function Abstracts
254 //
255 
256 
257     /// @notice Make bulk transfer of tokens to many addresses
258     /// @param _addrs An array of recipient addresses
259     /// @param _amounts An array of amounts to transfer to respective addresses
260     /// @return Boolean success value
261     function transferToMany(address[] _addrs, uint[] _amounts)
262         public returns (bool);
263 
264     /// @notice Release vested tokens after a maturity date
265     /// @return Boolean success value
266     function releaseVested() public returns (bool);
267 
268     /// @notice Salvage `_amount` tokens at `_kaddr` and send them to `_to`
269     /// @param _kAddr An ERC20 contract address
270     /// @param _to and address to send tokens
271     /// @param _amount The number of tokens to transfer
272     /// @return Boolean success value
273     function transferExternalToken(address _kAddr, address _to, uint _amount)
274         public returns (bool);
275 }
276 
277 
278 /*-----------------------------------------------------------------------------\
279 
280  Hut34ENTRP implimentation
281 
282 \*----------------------------------------------------------------------------*/
283 
284 contract Hut34ENTRP is 
285     ERC20Token,
286     Hut34ENTRPAbstract,
287     Hut34Config
288 {
289     using SafeMath for uint;
290 
291 //
292 // Constants
293 //
294 
295     // Token fixed point for decimal places
296     uint constant TOKEN = uint(10)**decimals; 
297 
298     // Calculate vested tokens
299     uint public constant VESTED_TOKENS =
300             TOTAL_TOKENS * TOKEN * VESTED_PERCENT / 100;
301             
302 //
303 // Functions
304 //
305 
306     function Hut34ENTRP()
307         public
308     {
309         // Run sanity checks
310         require(TOTAL_TOKENS != 0);
311         require(OWNER != 0x0);
312         require(HUT34_RETAIN != 0x0);
313         require(HUT34_WALLET != 0x0);
314         require(bytes(name).length != 0);
315         require(bytes(symbol).length != 0);
316 
317         owner = OWNER;
318         totalSupply = TOTAL_TOKENS.mul(TOKEN);
319 
320         // Mint the total supply into Hut34 token holding address
321         balances[HUT34_RETAIN] = totalSupply;
322         Transfer(0x0, HUT34_RETAIN, totalSupply);
323 
324         // Transfer vested tokens to vesting account
325         xfer(HUT34_RETAIN, HUT34_VEST_ADDR, VESTED_TOKENS);
326 
327         // Set first vesting release date
328         nextReleaseDate = now.add(VESTING_PERIOD);
329     }
330 
331     // Releases vested tokens back to Hut34 wallet
332     function releaseVested()
333         public
334         returns (bool)
335     {
336         require(now > nextReleaseDate);
337         VestingReleased(nextReleaseDate);
338         nextReleaseDate = nextReleaseDate.add(VESTING_PERIOD);
339         return xfer(HUT34_VEST_ADDR, HUT34_RETAIN, VESTED_TOKENS / 4);
340     }
341 
342 //
343 // ERC20 additional and overloaded functions
344 //
345 
346     // Allows a sender to transfer tokens to an array of recipients
347     function transferToMany(address[] _addrs, uint[] _amounts)
348         public
349         returns (bool)
350     {
351         require(_addrs.length == _amounts.length);
352         uint len = _addrs.length;
353         for(uint i = 0; i < len; i++) {
354             xfer(msg.sender, _addrs[i], _amounts[i]);
355         }
356         return true;
357     }
358     
359 //
360 // Contract management functions
361 //
362 
363     // Initiate a change of owner to `_owner`
364     function changeOwner(address _owner)
365         public
366         onlyOwner
367         returns (bool)
368     {
369         ChangeOwnerTo(_owner);
370         newOwner = _owner;
371         return true;
372     }
373     
374     // Finalise change of ownership to newOwner
375     function acceptOwnership()
376         public
377         returns (bool)
378     {
379         require(msg.sender == newOwner);
380         ChangedOwner(owner, msg.sender);
381         owner = newOwner;
382         delete newOwner;
383         return true;
384     }
385 
386     // Owner can salvage ERC20 tokens that may have been sent to the account
387     function transferExternalToken(address _kAddr, address _to, uint _amount)
388         public
389         onlyOwner
390         returns (bool) 
391     {
392         require(ERC20Token(_kAddr).transfer(_to, _amount));
393         return true;
394     }
395 }