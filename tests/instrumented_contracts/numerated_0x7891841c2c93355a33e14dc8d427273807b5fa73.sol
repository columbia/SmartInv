1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     /**
31     * @dev Add two numbers, throws on overflow.
32     */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 }
47   
48 contract SoinToken {
49     using SafeMath for uint256;
50     string public name = "Soin";
51     string public symbol = "SOIN";
52     uint8 public decimals = 18;
53     
54     // Total Supply of Soin Tokens
55     uint256 public totalSupply = 30000000000000000000000000000;
56 
57     // Multi-dimensional mapping to keep allow transfers between addresses
58     mapping (address => mapping (address => uint256)) public allowance;
59     
60     // Mapping to retrieve balance of a specific address
61     mapping (address => uint256) public balanceOf;
62 
63     /// The owner of contract
64     address public owner;
65 
66     /// The admin account of contract
67     address public admin;
68 
69     // Mapping of addresses that are locked up
70     mapping (address => bool) internal accountLockup;
71 
72     // Mapping that retrieves the current lockup time for a specific address
73     mapping (address => uint256) public accountLockupTime;
74     
75     // Mapping of addresses that are frozen
76     mapping (address => bool) public frozenAccounts;
77     
78     // Mapping of holder addresses (index)
79     mapping (address => uint256) internal holderIndex;
80 
81     // Array of holder addressses
82     address[] internal holders;
83 
84     ///First round tokens whether isssued.
85     bool internal firstRoundTokenIssued = false;
86 
87     /// Contract pause state
88     bool public paused = true;
89 
90     /// Issue event index starting from 0.
91     uint256 internal issueIndex = 0;
92 
93     // Emitted when a function is invocated without the specified preconditions.
94     event InvalidState(bytes msg);
95 
96     // This notifies clients about the token issued.
97     event Issue(uint256 issueIndex, address addr, uint256 ethAmount, uint256 tokenAmount);
98 
99     // This notifies clients about the amount to transfer
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     // This notifies clients about the amount to approve
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 
105     // This notifies clients about the amount burnt
106     event Burn(address indexed from, uint256 value);
107 
108     // This notifies clients about the account frozen
109     event FrozenFunds(address target, bool frozen);
110 
111     // This notifies clients about the pause
112     event Pause();
113 
114     // This notifies clients about the unpause
115     event Unpause();
116 
117     /*
118      * MODIFIERS
119      */
120     modifier onlyOwner {
121         require(msg.sender == owner);
122         _;
123     }
124 
125     modifier onlyAdmin {
126         require(msg.sender == owner || msg.sender == admin);
127         _;
128     }
129 
130     /**
131      * @dev Modifier to make a function callable only when account not frozen.
132      */
133     modifier isNotFrozen {
134         require(frozenAccounts[msg.sender] != true && now > accountLockupTime[msg.sender]);
135         _;
136     }
137 
138     /**
139      * @dev Modifier to make a function callable only when the contract is not paused.
140      */
141     modifier isNotPaused() {
142         require((msg.sender == owner && paused) || (msg.sender == admin && paused) || !paused);
143         _;
144     }
145 
146     /**
147      * @dev Modifier to make a function callable only when the contract is paused.
148      */
149     modifier isPaused() {
150         require(paused);
151         _;
152     }
153 
154     /**
155      * @dev Internal transfer, only can be called by this contract
156      * @param _from The address to transfer from.
157      * @param _to The address to transfer to.
158      * @param _value The amount to transfer between addressses.
159      */
160     function _transfer(address _from, address _to, uint256 _value) internal isNotFrozen isNotPaused {
161         // Prevent transfer to 0x0 address. Use burn() instead
162         require(_to != 0x0);
163         // Check if the sender has enough
164         require(balanceOf[_from] >= _value);
165         // Check for overflows
166         require(balanceOf[_to] + _value > balanceOf[_to]);
167         // Save this for an assertion in the future
168         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
169         // Subtract from the sender
170         balanceOf[_from] -= _value;
171         // Add the same to the recipient
172         balanceOf[_to] += _value;
173         // Update Token holders
174         addOrUpdateHolder(_from);
175         addOrUpdateHolder(_to);
176         // Send the Transfer Event
177         Transfer(_from, _to, _value);
178         // Asserts are used to use static analysis to find bugs in your code. They should never fail
179         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
180     }
181 
182     /**
183      * @dev Transfer to a specific address
184      * @param _to The address to transfer to.
185      * @param _transferTokensWithDecimal The amount to be transferred.
186     */
187     function transfer(address _to, uint256 _transferTokensWithDecimal) public {
188         _transfer(msg.sender, _to, _transferTokensWithDecimal);
189     }
190 
191     /**
192      * @dev Transfer tokens from one address to another
193      * @param _from address The address which you want to send tokens from
194      * @param _to address The address which you want to transfer to
195      * @param _transferTokensWithDecimal uint the amout of tokens to be transfered
196     */
197     function transferFrom(address _from, address _to, uint256 _transferTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
198         require(_transferTokensWithDecimal <= allowance[_from][msg.sender]);
199         // Check allowance
200         allowance[_from][msg.sender] -= _transferTokensWithDecimal;
201         _transfer(_from, _to, _transferTokensWithDecimal);
202         return true;
203     }
204 
205     /**
206      * @dev Allows `_spender` to spend no more (allowance) than `_approveTokensWithDecimal` tokens in your behalf
207      *
208      * !!Beware that changing an allowance with this method brings the risk that someone may use both the old
209      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      * @param _spender The address authorized to spend.
213      * @param _approveTokensWithDecimal the max amount they can spend.
214      */
215     function approve(address _spender, uint256 _approveTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
216         allowance[msg.sender][_spender] = _approveTokensWithDecimal;
217         Approval(msg.sender, _spender, _approveTokensWithDecimal);
218         return true;
219     }
220 
221     /**
222      * @dev Destroy tokens and remove `_value` tokens from the system irreversibly
223      * @param _burnedTokensWithDecimal The amount of tokens to burn. !!IMPORTANT is 18 DECIMALS
224     */
225     function burn(uint256 _burnedTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
226         require(balanceOf[msg.sender] >= _burnedTokensWithDecimal);
227         /// Check if the sender has enough
228         balanceOf[msg.sender] -= _burnedTokensWithDecimal;
229         /// Subtract from the sender
230         totalSupply -= _burnedTokensWithDecimal;
231         Burn(msg.sender, _burnedTokensWithDecimal);
232         return true;
233     }
234 
235     /**
236      * @dev Destroy tokens (`_value`) from the system irreversibly on behalf of `_from`.
237      * @param _from The address of the sender.
238      * @param _burnedTokensWithDecimal The amount of tokens to burn. !!! IMPORTANT is 18 DECIMALS
239     */
240     function burnFrom(address _from, uint256 _burnedTokensWithDecimal) public isNotFrozen isNotPaused returns (bool success) {
241         require(balanceOf[_from] >= _burnedTokensWithDecimal);
242         /// Check if the targeted balance is enough
243         require(_burnedTokensWithDecimal <= allowance[_from][msg.sender]);
244         /// Check allowance
245         balanceOf[_from] -= _burnedTokensWithDecimal;
246         /// Subtract from the targeted balance
247         allowance[_from][msg.sender] -= _burnedTokensWithDecimal;
248         /// Subtract from the sender's allowance
249         totalSupply -= _burnedTokensWithDecimal;
250         Burn(_from, _burnedTokensWithDecimal);
251         return true;
252     }
253 
254     /**
255      * @dev Add holder address into `holderIndex` mapping and to the `holders` array.
256      * @param _holderAddr The address of the holder
257     */
258     function addOrUpdateHolder(address _holderAddr) internal {
259         // Check and add holder to array
260         if (holderIndex[_holderAddr] == 0) {
261             holderIndex[_holderAddr] = holders.length++;
262             holders[holderIndex[_holderAddr]] = _holderAddr;
263         }
264     }
265 
266     /**
267      * CONSTRUCTOR
268      * @dev Initialize the Soin Token
269      */
270     function SoinToken() public {
271         owner = msg.sender;
272         admin = msg.sender;
273     }
274 
275     /**
276      * @dev Allows the current owner to transfer control of the contract to a newOwner.
277      * @param _newOwner The address to transfer ownership to.
278      */
279     function transferOwnership(address _newOwner) public onlyOwner {
280         require(_newOwner != address(0));
281         owner = _newOwner;
282     }
283 
284     /**
285     * @dev Set admin account to manage contract.
286     */
287     function setAdmin(address _address) public onlyOwner {
288         admin = _address;
289     }
290 
291     /**
292     * @dev Issue first round tokens to `owner` address.
293     */
294     function issueFirstRoundToken() public onlyOwner {
295         require(!firstRoundTokenIssued);
296 
297         balanceOf[owner] = balanceOf[owner].add(totalSupply);
298         Issue(issueIndex++, owner, 0, totalSupply);
299         addOrUpdateHolder(owner);
300         firstRoundTokenIssued = true;
301     }
302 
303     /**
304      * @dev Issue tokens for reserve.
305      * @param _issueTokensWithDecimal The amount of reserve tokens. !!IMPORTANT is 18 DECIMALS
306     */
307     function issueReserveToken(uint256 _issueTokensWithDecimal) onlyOwner public {
308         balanceOf[owner] = balanceOf[owner].add(_issueTokensWithDecimal);
309         totalSupply = totalSupply.add(_issueTokensWithDecimal);
310         Issue(issueIndex++, owner, 0, _issueTokensWithDecimal);
311     }
312 
313     /**
314     * @dev Freeze or Unfreeze an address
315     * @param _address address that will be frozen or unfrozen
316     * @param _frozenStatus status indicating if the address will be frozen or unfrozen.
317     */
318     function changeFrozenStatus(address _address, bool _frozenStatus) public onlyAdmin {
319         frozenAccounts[_address] = _frozenStatus;
320     }
321 
322     /**
323     * @dev Lockup account till the date. Can't lock-up again when this account locked already.
324     * 1 year = 31536000 seconds, 0.5 year = 15768000 seconds
325     */
326     function lockupAccount(address _address, uint256 _lockupSeconds) public onlyAdmin {
327         require((accountLockup[_address] && now > accountLockupTime[_address]) || !accountLockup[_address]);
328         // lock-up account
329         accountLockupTime[_address] = now + _lockupSeconds;
330         accountLockup[_address] = true;
331     }
332 
333     /**
334     * @dev Get the cuurent Soin holder count.
335     */
336     function getHolderCount() public view returns (uint256 _holdersCount){
337         return holders.length - 1;
338     }
339 
340     /**
341     * @dev Get the current Soin holder addresses.
342     */
343     function getHolders() public onlyAdmin view returns (address[] _holders){
344         return holders;
345     }
346 
347     /**
348     * @dev Pause the contract by only the owner. Triggers Pause() Event.
349     */
350     function pause() onlyAdmin isNotPaused public {
351         paused = true;
352         Pause();
353     }
354 
355     /**
356     * @dev Unpause the contract by only he owner. Triggers the Unpause() Event.
357     */
358     function unpause() onlyAdmin isPaused public {
359         paused = false;
360         Unpause();
361     }
362 
363     /**
364     * @dev Change the symbol attribute of the contract by the Owner.
365     * @param _symbol Short name of the token, symbol.
366     */
367     function setSymbol(string _symbol) public onlyOwner {
368         symbol = _symbol;
369     }
370 
371     /**
372     * @dev Change the name attribute of the contract by the Owner.
373     * @param _name Name of the token, full name.
374     */
375     function setName(string _name) public onlyOwner {
376         name = _name;
377     }
378 
379     /// @dev This default function rejects anyone to purchase the SOIN (Soin) token. Crowdsale has finished.
380     function() public payable {
381         revert();
382     }
383 
384 }