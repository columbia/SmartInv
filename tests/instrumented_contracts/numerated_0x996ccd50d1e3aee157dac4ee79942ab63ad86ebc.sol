1 /*
2   Copyright 2017 Sharder Foundation.
3 
4   Licensed under the Apache License, Version 2.0 (the "License");
5   you may not use this file except in compliance with the License.
6   You may obtain a copy of the License at
7 
8   http://www.apache.org/licenses/LICENSE-2.0
9 
10   Unless required by applicable law or agreed to in writing, software
11   distributed under the License is distributed on an "AS IS" BASIS,
12   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13   See the License for the specific language governing permissions and
14   limitations under the License.
15 
16   ################ Sharder-Token-v2.0 ###############
17     a) Adding the emergency transfer functionality for owner.
18     b) Removing the logic of crowdsale according to standard MintToken in order to improve the neatness and
19     legibility of the Sharder smart contract coding.
20     c) Adding the broadcast event 'Frozen'.
21     d) Changing the parameters of name, symbol, decimal, etc. to lower-case according to convention. Adjust format of input paramters.
22     e) The global parameter is added to our smart contact in order to avoid that the exchanges trade Sharder tokens
23     before officials partnering with Sharder.
24     f) Add holder array to facilitate the exchange of the current ERC-20 token to the Sharder Chain token later this year
25     when Sharder Chain is online.
26     g) Lockup and lock-up query functions.
27     The deplyed online contract you can found at: https://etherscan.io/address/XXXXXX
28 
29     Sharder-Token-v1.0 is expired. You can check the code and get the details on branch 'sharder-token-v1.0'.
30 */
31 pragma solidity ^0.4.18;
32 
33 /**
34  * Math operations with safety checks
35  */
36 library SafeMath {
37     function mul(uint a, uint b) internal pure returns (uint) {
38         uint c = a * b;
39         assert(a == 0 || c / a == b);
40         return c;
41     }
42 
43     function div(uint a, uint b) internal pure returns (uint) {
44         // assert(b > 0); // Solidity automatically throws when dividing by 0
45         uint c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47         return c;
48     }
49 
50     function sub(uint a, uint b) internal pure returns (uint) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     function add(uint a, uint b) internal pure returns (uint) {
56         uint c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 
61     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
62         return a >= b ? a : b;
63     }
64 
65     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
66         return a < b ? a : b;
67     }
68 
69     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a >= b ? a : b;
71     }
72 
73     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a < b ? a : b;
75     }
76 }
77 
78 /**
79 * @title Sharder Token v2.0. SS(Sharder) is upgrade from SS(Sharder Storage).
80 * @author Ben - <xy@sharder.org>.
81 * @dev ERC-20: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
82 */
83 contract SharderToken {
84     using SafeMath for uint;
85     string public name = "Sharder";
86     string public symbol = "SS";
87     uint8 public  decimals = 18;
88 
89     /// +--------------------------------------------------------------+
90     /// |                 SS(Sharder) Token Issue Plan                 |
91     /// +--------------------------------------------------------------+
92     /// |                    First Round(Crowdsale)                    |
93     /// +--------------------------------------------------------------+
94     /// |     Total Sale    |      Airdrop      |  Community Reserve   |
95     /// +--------------------------------------------------------------+
96     /// |     250,000,000   |     50,000,000    |     50,000,000       |
97     /// +--------------------------------------------------------------+
98     /// | Team Reserve(50,000,000 SS): Issue in 3 years period         |
99     /// +--------------------------------------------------------------+
100     /// | System Reward(100,000,000 SS): Reward by Sharder Chain Auto  |
101     /// +--------------------------------------------------------------+
102     uint256 public totalSupply = 350000000000000000000000000;
103 
104     mapping (address => mapping (address => uint256)) public allowance;
105     mapping (address => uint256) public balanceOf;
106 
107     /// The owner of contract
108     address public owner;
109 
110     /// The admin account of contract
111     address public admin;
112 
113     mapping (address => bool) internal accountLockup;
114     mapping (address => uint) public accountLockupTime;
115     mapping (address => bool) public frozenAccounts;
116 
117     mapping (address => uint) internal holderIndex;
118     address[] internal holders;
119 
120     ///First round tokens whether isssued.
121     bool internal firstRoundTokenIssued = false;
122 
123     /// Contract pause state
124     bool public paused = true;
125 
126     /// Issue event index starting from 0.
127     uint256 internal issueIndex = 0;
128 
129     // Emitted when a function is invocated without the specified preconditions.
130     event InvalidState(bytes msg);
131 
132     // This notifies clients about the token issued.
133     event Issue(uint issueIndex, address addr, uint ethAmount, uint tokenAmount);
134 
135     // This notifies clients about the amount to transfer
136     event Transfer(address indexed from, address indexed to, uint256 value);
137 
138     // This notifies clients about the amount to approve
139     event Approval(address indexed owner, address indexed spender, uint value);
140 
141     // This notifies clients about the amount burnt
142     event Burn(address indexed from, uint256 value);
143 
144     // This notifies clients about the account frozen
145     event FrozenFunds(address target, bool frozen);
146 
147     // This notifies clients about the pause
148     event Pause();
149 
150     // This notifies clients about the unpause
151     event Unpause();
152 
153 
154     /*
155      * MODIFIERS
156      */
157     modifier onlyOwner {
158         require(msg.sender == owner);
159         _;
160     }
161 
162     modifier onlyAdmin {
163         require(msg.sender == owner || msg.sender == admin);
164         _;
165     }
166 
167     /**
168      * @dev Modifier to make a function callable only when account not frozen.
169      */
170     modifier isNotFrozen {
171         require(frozenAccounts[msg.sender] != true && now > accountLockupTime[msg.sender]);
172         _;
173     }
174 
175     /**
176      * @dev Modifier to make a function callable only when the contract is not paused.
177      */
178     modifier isNotPaused() {
179         require((msg.sender == owner && paused) || (msg.sender == admin && paused) || !paused);
180         _;
181     }
182 
183     /**
184      * @dev Modifier to make a function callable only when the contract is paused.
185      */
186     modifier isPaused() {
187         require(paused);
188         _;
189     }
190 
191     /**
192      * Internal transfer, only can be called by this contract
193      */
194     function _transfer(address _from, address _to, uint _value) internal isNotFrozen isNotPaused {
195         // Prevent transfer to 0x0 address. Use burn() instead
196         require(_to != 0x0);
197         // Check if the sender has enough
198         require(balanceOf[_from] >= _value);
199         // Check for overflows
200         require(balanceOf[_to] + _value > balanceOf[_to]);
201         // Save this for an assertion in the future
202         uint previousBalances = balanceOf[_from] + balanceOf[_to];
203         // Subtract from the sender
204         balanceOf[_from] -= _value;
205         // Add the same to the recipient
206         balanceOf[_to] += _value;
207         // Update holders
208         addOrUpdateHolder(_from);
209         addOrUpdateHolder(_to);
210 
211         Transfer(_from, _to, _value);
212 
213         // Asserts are used to use static analysis to find bugs in your code. They should never fail
214         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
215     }
216 
217     /**
218      * @dev transfer token for a specified address
219      * @param _to The address to transfer to.
220      * @param _transferTokensWithDecimal The amount to be transferred.
221     */
222     function transfer(address _to, uint _transferTokensWithDecimal) public {
223         _transfer(msg.sender, _to, _transferTokensWithDecimal);
224     }
225 
226     /**
227      * @dev Transfer tokens from one address to another
228      * @param _from address The address which you want to send tokens from
229      * @param _to address The address which you want to transfer to
230      * @param _transferTokensWithDecimal uint the amout of tokens to be transfered
231     */
232     function transferFrom(address _from, address _to, uint _transferTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
233         require(_transferTokensWithDecimal <= allowance[_from][msg.sender]);
234         // Check allowance
235         allowance[_from][msg.sender] -= _transferTokensWithDecimal;
236         _transfer(_from, _to, _transferTokensWithDecimal);
237         return true;
238     }
239 
240     /**
241      * Set allowance for other address
242      * Allows `_spender` to spend no more than `_approveTokensWithDecimal` tokens in your behalf
243      *
244      * @param _spender The address authorized to spend
245      * @param _approveTokensWithDecimal the max amount they can spend
246      */
247     function approve(address _spender, uint256 _approveTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
248         allowance[msg.sender][_spender] = _approveTokensWithDecimal;
249         Approval(msg.sender, _spender, _approveTokensWithDecimal);
250         return true;
251     }
252 
253     /**
254      * Destroy tokens
255      * Remove `_value` tokens from the system irreversibly
256      * @param _burnedTokensWithDecimal the amount of reserve tokens. !!IMPORTANT is 18 DECIMALS
257     */
258     function burn(uint256 _burnedTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
259         require(balanceOf[msg.sender] >= _burnedTokensWithDecimal);
260         /// Check if the sender has enough
261         balanceOf[msg.sender] -= _burnedTokensWithDecimal;
262         /// Subtract from the sender
263         totalSupply -= _burnedTokensWithDecimal;
264         Burn(msg.sender, _burnedTokensWithDecimal);
265         return true;
266     }
267 
268     /**
269      * Destroy tokens from other account
270      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
271      * @param _from the address of the sender
272      * @param _burnedTokensWithDecimal the amount of reserve tokens. !!! IMPORTANT is 18 DECIMALS
273     */
274     function burnFrom(address _from, uint256 _burnedTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
275         require(balanceOf[_from] >= _burnedTokensWithDecimal);
276         /// Check if the targeted balance is enough
277         require(_burnedTokensWithDecimal <= allowance[_from][msg.sender]);
278         /// Check allowance
279         balanceOf[_from] -= _burnedTokensWithDecimal;
280         /// Subtract from the targeted balance
281         allowance[_from][msg.sender] -= _burnedTokensWithDecimal;
282         /// Subtract from the sender's allowance
283         totalSupply -= _burnedTokensWithDecimal;
284         Burn(_from, _burnedTokensWithDecimal);
285         return true;
286     }
287 
288     /**
289      * Add holder addr into arrays.
290      * @param _holderAddr the address of the holder
291     */
292     function addOrUpdateHolder(address _holderAddr) internal {
293         // Check and add holder to array
294         if (holderIndex[_holderAddr] == 0) {
295             holderIndex[_holderAddr] = holders.length++;
296         }
297         holders[holderIndex[_holderAddr]] = _holderAddr;
298     }
299 
300     /**
301      * CONSTRUCTOR
302      * @dev Initialize the Sharder Token v2.0
303      */
304     function SharderToken() public {
305         owner = msg.sender;
306         admin = msg.sender;
307     }
308 
309     /**
310      * @dev Allows the current owner to transfer control of the contract to a newOwner.
311      * @param _newOwner The address to transfer ownership to.
312      */
313     function transferOwnership(address _newOwner) public onlyOwner {
314         require(_newOwner != address(0));
315         owner = _newOwner;
316     }
317 
318     /**
319     * @dev Set admin account to manage contract.
320     */
321     function setAdmin(address _address) public onlyOwner {
322         admin = _address;
323     }
324 
325     /**
326     * @dev Issue first round tokens to `owner` address.
327     */
328     function issueFirstRoundToken() public onlyOwner {
329         require(!firstRoundTokenIssued);
330 
331         balanceOf[owner] = balanceOf[owner].add(totalSupply);
332         Issue(issueIndex++, owner, 0, totalSupply);
333         addOrUpdateHolder(owner);
334         firstRoundTokenIssued = true;
335     }
336 
337     /**
338      * @dev Issue tokens for reserve.
339      * @param _issueTokensWithDecimal the amount of reserve tokens. !!IMPORTANT is 18 DECIMALS
340     */
341     function issueReserveToken(uint256 _issueTokensWithDecimal) onlyOwner public {
342         balanceOf[owner] = balanceOf[owner].add(_issueTokensWithDecimal);
343         totalSupply = totalSupply.add(_issueTokensWithDecimal);
344         Issue(issueIndex++, owner, 0, _issueTokensWithDecimal);
345     }
346 
347     /**
348     * @dev Frozen or unfrozen account.
349     */
350     function changeFrozenStatus(address _address, bool _frozenStatus) public onlyAdmin {
351         frozenAccounts[_address] = _frozenStatus;
352     }
353 
354     /**
355     * @dev Lockup account till the date. Can't lock-up again when this account locked already.
356     * 1 year = 31536000 seconds, 0.5 year = 15768000 seconds
357     */
358     function lockupAccount(address _address, uint _lockupSeconds) public onlyAdmin {
359         require((accountLockup[_address] && now > accountLockupTime[_address]) || !accountLockup[_address]);
360         // lock-up account
361         accountLockupTime[_address] = now + _lockupSeconds;
362         accountLockup[_address] = true;
363     }
364 
365     /**
366     * @dev Get the cuurent ss holder count.
367     */
368     function getHolderCount() public constant returns (uint _holdersCount){
369         return holders.length - 1;
370     }
371 
372     /*
373     * @dev Get the current ss holder addresses.
374     */
375     function getHolders() public onlyAdmin constant returns (address[] _holders){
376         return holders;
377     }
378 
379     /**
380      * @dev called by the owner to pause, triggers stopped state
381     */
382     function pause() onlyAdmin isNotPaused public {
383         paused = true;
384         Pause();
385     }
386 
387     /**
388      * @dev called by the owner to unpause, returns to normal state
389     */
390     function unpause() onlyAdmin isPaused public {
391         paused = false;
392         Unpause();
393     }
394 
395     function setSymbol(string _symbol) public onlyOwner {
396         symbol = _symbol;
397     }
398 
399     function setName(string _name) public onlyOwner {
400         name = _name;
401     }
402 
403     /// @dev This default function reject anyone to purchase the SS(Sharder) token after crowdsale finished.
404     function() public payable {
405         revert();
406     }
407 
408 }