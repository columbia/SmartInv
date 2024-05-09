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
17   a) Added an emergency transfer function to transfer tokens to the contract owner.
18   b) Removed crowdsale logic according to the MintToken standard to improve neatness and legibility of the token contract.
19   c) Added the 'Frozen' broadcast event.
20   d) Changed name, symbol, decimal, etc, parameters to lower-case according to the convention. Adjust format parameters.
21   e) Added a global parameter to the smart contact to prevent exchanges trading Sharder tokens before officially partnering.
22   f) Added address mapping to facilitate the exchange of current ERC-20 tokens to the Sharder Chain token when it goes live.
23   g) Added Lockup and lock-up query functionality.
24 
25   Sharder-Token-v1.0 has expired. The deprecated code is available in the sharder-token-v1.0' branch.
26 */
27 pragma solidity ^0.4.18;
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two numbers, throws on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         assert(c / a == b);
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two numbers, truncating the quotient.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // assert(b > 0); // Solidity automatically throws when dividing by 0
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53         return c;
54     }
55 
56     /**
57     * @dev Add two numbers, throws on overflow.
58     */
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         assert(b <= a);
70         return a - b;
71     }
72 }
73   
74 /**
75 * @title Sharder Token v2.0. SS (Sharder) is an upgrade from SS (Sharder Storage).
76 * @author Ben-<xy@sharder.org>, Community Contributor: Nick Parrin-<parrin@protonmail.com>
77 * @dev ERC-20: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
78 */
79 contract SharderToken {
80     using SafeMath for uint256;
81     string public name = "Sharder";
82     string public symbol = "SS";
83     uint8 public decimals = 18;
84 
85     /// +--------------------------------------------------------------+
86     /// |                 SS (Sharder) Token Issue Plan                |
87     /// +--------------------------------------------------------------+
88     /// |                    First Round (Crowdsale)                   |
89     /// +--------------------------------------------------------------+
90     /// |     Total Sale    |      Airdrop      |  Community Reserve   |
91     /// +--------------------------------------------------------------+
92     /// |     250,000,000   |     50,000,000    |     50,000,000       |
93     /// +--------------------------------------------------------------+
94     /// | Team Reserve (50,000,000 SS): Issue in 3 year period         |
95     /// +--------------------------------------------------------------+
96     /// | System Reward (100,000,000 SS): Reward by Sharder Chain Auto |
97     /// +--------------------------------------------------------------+
98     
99     // Total Supply of Sharder Tokens
100     uint256 public totalSupply = 350000000000000000000000000;
101 
102     // Multi-dimensional mapping to keep allow transfers between addresses
103     mapping (address => mapping (address => uint256)) public allowance;
104     
105     // Mapping to retrieve balance of a specific address
106     mapping (address => uint256) public balanceOf;
107 
108     /// The owner of contract
109     address public owner;
110 
111     /// The admin account of contract
112     address public admin;
113 
114     // Mapping of addresses that are locked up
115     mapping (address => bool) internal accountLockup;
116 
117     // Mapping that retrieves the current lockup time for a specific address
118     mapping (address => uint256) public accountLockupTime;
119     
120     // Mapping of addresses that are frozen
121     mapping (address => bool) public frozenAccounts;
122     
123     // Mapping of holder addresses (index)
124     mapping (address => uint256) internal holderIndex;
125 
126     // Array of holder addressses
127     address[] internal holders;
128 
129     ///First round tokens whether isssued.
130     bool internal firstRoundTokenIssued = false;
131 
132     /// Contract pause state
133     bool public paused = true;
134 
135     /// Issue event index starting from 0.
136     uint256 internal issueIndex = 0;
137 
138     // Emitted when a function is invocated without the specified preconditions.
139     event InvalidState(bytes msg);
140 
141     // This notifies clients about the token issued.
142     event Issue(uint256 issueIndex, address addr, uint256 ethAmount, uint256 tokenAmount);
143 
144     // This notifies clients about the amount to transfer
145     event Transfer(address indexed from, address indexed to, uint256 value);
146 
147     // This notifies clients about the amount to approve
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149 
150     // This notifies clients about the amount burnt
151     event Burn(address indexed from, uint256 value);
152 
153     // This notifies clients about the account frozen
154     event FrozenFunds(address target, bool frozen);
155 
156     // This notifies clients about the pause
157     event Pause();
158 
159     // This notifies clients about the unpause
160     event Unpause();
161 
162     /*
163      * MODIFIERS
164      */
165     modifier onlyOwner {
166         require(msg.sender == owner);
167         _;
168     }
169 
170     modifier onlyAdmin {
171         require(msg.sender == owner || msg.sender == admin);
172         _;
173     }
174 
175     /**
176      * @dev Modifier to make a function callable only when account not frozen.
177      */
178     modifier isNotFrozen {
179         require(frozenAccounts[msg.sender] != true && now > accountLockupTime[msg.sender]);
180         _;
181     }
182 
183     /**
184      * @dev Modifier to make a function callable only when the contract is not paused.
185      */
186     modifier isNotPaused() {
187         require((msg.sender == owner && paused) || (msg.sender == admin && paused) || !paused);
188         _;
189     }
190 
191     /**
192      * @dev Modifier to make a function callable only when the contract is paused.
193      */
194     modifier isPaused() {
195         require(paused);
196         _;
197     }
198 
199     /**
200      * @dev Internal transfer, only can be called by this contract
201      * @param _from The address to transfer from.
202      * @param _to The address to transfer to.
203      * @param _value The amount to transfer between addressses.
204      */
205     function _transfer(address _from, address _to, uint256 _value) internal isNotFrozen isNotPaused {
206         // Prevent transfer to 0x0 address. Use burn() instead
207         require(_to != 0x0);
208         // Check if the sender has enough
209         require(balanceOf[_from] >= _value);
210         // Check for overflows
211         require(balanceOf[_to] + _value > balanceOf[_to]);
212         // Save this for an assertion in the future
213         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
214         // Subtract from the sender
215         balanceOf[_from] -= _value;
216         // Add the same to the recipient
217         balanceOf[_to] += _value;
218         // Update Token holders
219         addOrUpdateHolder(_from);
220         addOrUpdateHolder(_to);
221         // Send the Transfer Event
222         Transfer(_from, _to, _value);
223         // Asserts are used to use static analysis to find bugs in your code. They should never fail
224         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
225     }
226 
227     /**
228      * @dev Transfer to a specific address
229      * @param _to The address to transfer to.
230      * @param _transferTokensWithDecimal The amount to be transferred.
231     */
232     function transfer(address _to, uint256 _transferTokensWithDecimal) public {
233         _transfer(msg.sender, _to, _transferTokensWithDecimal);
234     }
235 
236     /**
237      * @dev Transfer tokens from one address to another
238      * @param _from address The address which you want to send tokens from
239      * @param _to address The address which you want to transfer to
240      * @param _transferTokensWithDecimal uint the amout of tokens to be transfered
241     */
242     function transferFrom(address _from, address _to, uint256 _transferTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
243         require(_transferTokensWithDecimal <= allowance[_from][msg.sender]);
244         // Check allowance
245         allowance[_from][msg.sender] -= _transferTokensWithDecimal;
246         _transfer(_from, _to, _transferTokensWithDecimal);
247         return true;
248     }
249 
250     /**
251      * @dev Allows `_spender` to spend no more (allowance) than `_approveTokensWithDecimal` tokens in your behalf
252      *
253      * !!Beware that changing an allowance with this method brings the risk that someone may use both the old
254      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      * @param _spender The address authorized to spend.
258      * @param _approveTokensWithDecimal the max amount they can spend.
259      */
260     function approve(address _spender, uint256 _approveTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
261         allowance[msg.sender][_spender] = _approveTokensWithDecimal;
262         Approval(msg.sender, _spender, _approveTokensWithDecimal);
263         return true;
264     }
265 
266     /**
267      * @dev Destroy tokens and remove `_value` tokens from the system irreversibly
268      * @param _burnedTokensWithDecimal The amount of tokens to burn. !!IMPORTANT is 18 DECIMALS
269     */
270     function burn(uint256 _burnedTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
271         require(balanceOf[msg.sender] >= _burnedTokensWithDecimal);
272         /// Check if the sender has enough
273         balanceOf[msg.sender] -= _burnedTokensWithDecimal;
274         /// Subtract from the sender
275         totalSupply -= _burnedTokensWithDecimal;
276         Burn(msg.sender, _burnedTokensWithDecimal);
277         return true;
278     }
279 
280     /**
281      * @dev Destroy tokens (`_value`) from the system irreversibly on behalf of `_from`.
282      * @param _from The address of the sender.
283      * @param _burnedTokensWithDecimal The amount of tokens to burn. !!! IMPORTANT is 18 DECIMALS
284     */
285     function burnFrom(address _from, uint256 _burnedTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
286         require(balanceOf[_from] >= _burnedTokensWithDecimal);
287         /// Check if the targeted balance is enough
288         require(_burnedTokensWithDecimal <= allowance[_from][msg.sender]);
289         /// Check allowance
290         balanceOf[_from] -= _burnedTokensWithDecimal;
291         /// Subtract from the targeted balance
292         allowance[_from][msg.sender] -= _burnedTokensWithDecimal;
293         /// Subtract from the sender's allowance
294         totalSupply -= _burnedTokensWithDecimal;
295         Burn(_from, _burnedTokensWithDecimal);
296         return true;
297     }
298 
299     /**
300      * @dev Add holder address into `holderIndex` mapping and to the `holders` array.
301      * @param _holderAddr The address of the holder
302     */
303     function addOrUpdateHolder(address _holderAddr) internal {
304         // Check and add holder to array
305         if (holderIndex[_holderAddr] == 0) {
306             holderIndex[_holderAddr] = holders.length++;
307             holders[holderIndex[_holderAddr]] = _holderAddr;
308         }
309     }
310 
311     /**
312      * CONSTRUCTOR
313      * @dev Initialize the Sharder Token v2.0
314      */
315     function SharderToken() public {
316         owner = msg.sender;
317         admin = msg.sender;
318     }
319 
320     /**
321      * @dev Allows the current owner to transfer control of the contract to a newOwner.
322      * @param _newOwner The address to transfer ownership to.
323      */
324     function transferOwnership(address _newOwner) public onlyOwner {
325         require(_newOwner != address(0));
326         owner = _newOwner;
327     }
328 
329     /**
330     * @dev Set admin account to manage contract.
331     */
332     function setAdmin(address _address) public onlyOwner {
333         admin = _address;
334     }
335 
336     /**
337     * @dev Issue first round tokens to `owner` address.
338     */
339     function issueFirstRoundToken() public onlyOwner {
340         require(!firstRoundTokenIssued);
341 
342         balanceOf[owner] = balanceOf[owner].add(totalSupply);
343         Issue(issueIndex++, owner, 0, totalSupply);
344         addOrUpdateHolder(owner);
345         firstRoundTokenIssued = true;
346     }
347 
348     /**
349      * @dev Issue tokens for reserve.
350      * @param _issueTokensWithDecimal The amount of reserve tokens. !!IMPORTANT is 18 DECIMALS
351     */
352     function issueReserveToken(uint256 _issueTokensWithDecimal) onlyOwner public {
353         balanceOf[owner] = balanceOf[owner].add(_issueTokensWithDecimal);
354         totalSupply = totalSupply.add(_issueTokensWithDecimal);
355         Issue(issueIndex++, owner, 0, _issueTokensWithDecimal);
356     }
357 
358     /**
359     * @dev Freeze or Unfreeze an address
360     * @param _address address that will be frozen or unfrozen
361     * @param _frozenStatus status indicating if the address will be frozen or unfrozen.
362     */
363     function changeFrozenStatus(address _address, bool _frozenStatus) public onlyAdmin {
364         frozenAccounts[_address] = _frozenStatus;
365     }
366 
367     /**
368     * @dev Lockup account till the date. Can't lock-up again when this account locked already.
369     * 1 year = 31536000 seconds, 0.5 year = 15768000 seconds
370     */
371     function lockupAccount(address _address, uint256 _lockupSeconds) public onlyAdmin {
372         require((accountLockup[_address] && now > accountLockupTime[_address]) || !accountLockup[_address]);
373         // lock-up account
374         accountLockupTime[_address] = now + _lockupSeconds;
375         accountLockup[_address] = true;
376     }
377 
378     /**
379     * @dev Get the cuurent SS holder count.
380     */
381     function getHolderCount() public view returns (uint256 _holdersCount){
382         return holders.length - 1;
383     }
384 
385     /**
386     * @dev Get the current SS holder addresses.
387     */
388     function getHolders() public onlyAdmin view returns (address[] _holders){
389         return holders;
390     }
391 
392     /**
393     * @dev Pause the contract by only the owner. Triggers Pause() Event.
394     */
395     function pause() onlyAdmin isNotPaused public {
396         paused = true;
397         Pause();
398     }
399 
400     /**
401     * @dev Unpause the contract by only he owner. Triggers the Unpause() Event.
402     */
403     function unpause() onlyAdmin isPaused public {
404         paused = false;
405         Unpause();
406     }
407 
408     /**
409     * @dev Change the symbol attribute of the contract by the Owner.
410     * @param _symbol Short name of the token, symbol.
411     */
412     function setSymbol(string _symbol) public onlyOwner {
413         symbol = _symbol;
414     }
415 
416     /**
417     * @dev Change the name attribute of the contract by the Owner.
418     * @param _name Name of the token, full name.
419     */
420     function setName(string _name) public onlyOwner {
421         name = _name;
422     }
423 
424     /// @dev This default function rejects anyone to purchase the SS (Sharder) token. Crowdsale has finished.
425     function() public payable {
426         revert();
427     }
428 
429 }