1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8     function totalSupply() public constant returns (uint);
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 // ----------------------------------------------------------------------------
20 // Owned contract
21 // ----------------------------------------------------------------------------
22 contract Owned {
23     address public owner;
24     address public newOwner;
25 
26     event OwnershipTransferred(address indexed _from, address indexed _to);
27 
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         newOwner = _newOwner;
39     }
40 
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         emit OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45         newOwner = address(0);
46     }
47 }
48 
49 /// @dev The token controller contract must implement these functions
50 contract TokenController {
51     /// @notice Notifies the controller about a token transfer allowing the
52     ///  controller to react if desired
53     /// @param _from The origin of the transfer
54     /// @param _to The destination of the transfer
55     /// @param _amount The amount of the transfer
56     /// @return False if the controller does not authorize the transfer
57     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
58 
59     /// @notice Notifies the controller about an approval allowing the
60     ///  controller to react if desired
61     /// @param _owner The address that calls `approve()`
62     /// @param _spender The spender in the `approve()` call
63     /// @param _amount_old The current allowed amount in the `approve()` call
64     /// @param _amount_new The amount in the `approve()` call
65     /// @return False if the controller does not authorize the approval
66     function onApprove(address _owner, address _spender, uint _amount_old, uint _amount_new) public returns(bool);
67 }
68 
69 // ----------------------------------------------------------------------------
70 // Contract function to receive approval and execute function in one call
71 //
72 // Borrowed from MiniMeToken
73 // ----------------------------------------------------------------------------
74 contract ApproveAndCallFallBack {
75     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
76 }
77 
78 // ----------------------------------------------------------------------------
79 // ERC20 Token, with the addition of symbol, name and decimals and an
80 // initial fixed supply
81 // ----------------------------------------------------------------------------
82 contract SNcoin_Token is ERC20Interface, Owned {
83     string public constant symbol = "SNcoin";
84     string public constant name = "scientificcoin";
85     uint8 public constant decimals = 18;
86     uint private constant _totalSupply = 100000000 * 10**uint(decimals);
87 
88     mapping(address => uint) balances;
89     mapping(address => mapping(address => uint)) allowed;
90 
91     struct LimitedBalance {
92         uint8 limitType;
93         uint initial;
94     }
95     mapping(address => LimitedBalance) limited_balances;
96     uint8 public constant limitDefaultType = 0;
97     uint8 public constant limitTeamType = 1;
98     uint8 public constant limitBranchType = 2;
99     uint8 private constant limitTeamIdx = 0;
100     uint8 private constant limitBranchIdx = 1;
101     uint8[limitBranchType] private limits;
102     uint8 private constant limitTeamInitial = 90;
103     uint8 private constant limitBranchInitial = 90;
104     uint8 private constant limitTeamStep = 3;
105     uint8 private constant limitBranchStep = 10;
106 
107     address public controller;
108     
109     // Flag that determines if the token is transferable or not.
110     bool public transfersEnabled;
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     constructor() public {
115         balances[owner] = _totalSupply;
116         transfersEnabled = true;
117         limits[limitTeamIdx] = limitTeamInitial;
118         limits[limitBranchIdx] = limitBranchInitial;
119         emit Transfer(address(0), owner, _totalSupply);
120     }
121 
122 
123     /// @notice Changes the controller of the contract
124     /// @param _newController The new controller of the contract
125     function setController(address _newController) public onlyOwner {
126         controller = _newController;
127     }
128     
129     function limitOfTeam() public constant returns (uint8 limit) {
130         return 100 - limits[limitTeamIdx];
131     }
132 
133     function limitOfBranch() public constant returns (uint8 limit) {
134         return 100 - limits[limitBranchIdx];
135     }
136 
137     function getLimitTypeOf(address tokenOwner) public constant returns (uint8 limitType) {
138         return limited_balances[tokenOwner].limitType;
139     }
140 
141     function getLimitedBalanceOf(address tokenOwner) public constant returns (uint balance) {
142        if (limited_balances[tokenOwner].limitType > 0) {
143            require(limited_balances[tokenOwner].limitType <= limitBranchType);
144            uint minimumLimit = (limited_balances[tokenOwner].initial * limits[limited_balances[tokenOwner].limitType - 1])/100;
145            require(balances[tokenOwner] >= minimumLimit);
146            return balances[tokenOwner] - minimumLimit;
147        }
148        return balanceOf(tokenOwner);
149     }
150 
151     function incrementLimitTeam() public onlyOwner returns (bool success) {
152         require(transfersEnabled);
153 
154         uint8 previousLimit = limits[limitTeamIdx];
155         if ( previousLimit - limitTeamStep >= 100) {
156             limits[limitTeamIdx] = 0;
157         } else {
158             limits[limitTeamIdx] = previousLimit - limitTeamStep;
159         }
160 
161         return true;
162     }
163 
164     function incrementLimitBranch() public onlyOwner returns (bool success) {
165         require(transfersEnabled);
166 
167         uint8 previousLimit = limits[limitBranchIdx];
168         if ( previousLimit - limitBranchStep >= 100) {
169             limits[limitBranchIdx] = 0;
170         } else {
171             limits[limitBranchIdx] = previousLimit - limitBranchStep;
172         }
173 
174         return true;
175     }
176 
177     // ------------------------------------------------------------------------
178     // Total supply
179     // ------------------------------------------------------------------------
180     function totalSupply() public constant returns (uint) {
181         return _totalSupply  - balances[address(0)];
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Get the token balance for account `tokenOwner`
187     // ------------------------------------------------------------------------
188     function balanceOf(address tokenOwner) public constant returns (uint balance) {
189         return balances[tokenOwner];
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Token owner can approve for `spender` to transferFrom(...) `tokens`
195     // from the token owner's account
196     //
197     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
198     // recommends that there are no checks for the approval double-spend attack
199     // as this should be implemented in user interfaces 
200     // ------------------------------------------------------------------------
201     function approve(address _spender, uint _amount) public returns (bool success) {
202         require(transfersEnabled);
203 
204         // Alerts the token controller of the approve function call
205         if (controller != 0) {
206             require(TokenController(controller).onApprove(msg.sender, _spender, allowed[msg.sender][_spender], _amount));
207         }
208 
209         allowed[msg.sender][_spender] = _amount;
210         emit Approval(msg.sender, _spender, _amount);
211         return true;
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Returns the amount of tokens approved by the owner that can be
217     // transferred to the spender's account
218     // ------------------------------------------------------------------------
219     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
220         return allowed[tokenOwner][spender];
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Transfer the balance from token owner's account to `to` account
226     // - Owner's account must have sufficient balance to transfer
227     // - 0 value transfers are allowed
228     // ------------------------------------------------------------------------
229     function transfer(address _to, uint _amount) public returns (bool success) {
230         require(transfersEnabled);
231         doTransfer(msg.sender, _to, _amount);
232         return true;
233     }
234 
235 
236     // ------------------------------------------------------------------------
237     // Transfer `tokens` from the `from` account to the `to` account
238     // 
239     // The calling account must already have sufficient tokens approve(...)-d
240     // for spending from the `from` account and
241     // - From account must have sufficient balance to transfer
242     // - Spender must have sufficient allowance to transfer
243     // - 0 value transfers are allowed
244     // ------------------------------------------------------------------------
245     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
246         require(transfersEnabled);
247 
248         // The standard ERC 20 transferFrom functionality
249         require(allowed[_from][msg.sender] >= _amount);
250         allowed[_from][msg.sender] -= _amount;
251         doTransfer(_from, _to, _amount);
252         return true;
253     }
254 
255 
256     // ------------------------------------------------------------------------
257     // Transfer the balance from token owner's account to `to` account
258     // - Owner's account must have sufficient balance to transfer
259     // - 0 value transfers are allowed
260     // ------------------------------------------------------------------------
261     function transferToTeam(address _to, uint _amount) public onlyOwner returns (bool success) {
262         require(transfersEnabled);
263         transferToLimited(msg.sender, _to, _amount, limitTeamType);
264 
265         return true;
266     }
267 
268 
269     // ------------------------------------------------------------------------
270     // Transfer the balance from token owner's account to `to` account
271     // - Owner's account must have sufficient balance to transfer
272     // - 0 value transfers are allowed
273     // ------------------------------------------------------------------------
274     function transferToBranch(address _to, uint _amount) public onlyOwner returns (bool success) {
275         require(transfersEnabled);
276         transferToLimited(msg.sender, _to, _amount, limitBranchType);
277 
278         return true;
279     }
280 
281 
282     // ------------------------------------------------------------------------
283     // Transfer the balance from token owner's account to `to` account
284     // - Owner's account must have sufficient balance to transfer
285     // - 0 value transfers are allowed
286     // ------------------------------------------------------------------------
287     function transferToLimited(address _from, address _to, uint _amount, uint8 _limitType) internal {
288         require((_limitType >= limitTeamType) && (_limitType <= limitBranchType));
289         require((limited_balances[_to].limitType == 0) || (limited_balances[_to].limitType == _limitType));
290 
291         doTransfer(_from, _to, _amount);
292 
293         uint previousLimitedBalanceInitial = limited_balances[_to].initial;
294         require(previousLimitedBalanceInitial + _amount >= previousLimitedBalanceInitial); // Check for overflow
295         limited_balances[_to].initial = previousLimitedBalanceInitial + _amount;
296         limited_balances[_to].limitType = _limitType;
297     }
298 
299     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
300     ///  its behalf, and then a function is triggered in the contract that is
301     ///  being approved, `_spender`. This allows users to use their tokens to
302     ///  interact with contracts in one function call instead of two
303     /// @param _spender The address of the contract able to transfer the tokens
304     /// @param _amount The amount of tokens to be approved for transfer
305     /// @return True if the function call was successful
306     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
307     ) public returns (bool success) {
308         require(approve(_spender, _amount));
309 
310         ApproveAndCallFallBack(_spender).receiveApproval(
311             msg.sender,
312             _amount,
313             this,
314             _extraData
315         );
316 
317         return true;
318     }
319 
320     // ------------------------------------------------------------------------
321     // Don't accept ETH
322     // ------------------------------------------------------------------------
323     function () public payable {
324         revert();
325     }
326 
327 
328     /// @dev This is the actual transfer function in the token contract, it can
329     ///  only be called by other functions in this contract.
330     /// @param _from The address holding the tokens being transferred
331     /// @param _to The address of the recipient
332     /// @param _amount The amount of tokens to be transferred
333     /// @return True if the transfer was successful
334     function doTransfer(address _from, address _to, uint _amount) internal {
335            if (_amount == 0) {
336                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
337                return;
338            }
339 
340            // Do not allow transfer to 0x0 or the token contract itself
341            require((_to != 0) && (_to != address(this)));
342 
343            // If the amount being transfered is more than the balance of the
344            //  account the transfer throws
345            uint previousBalanceFrom = balanceOf(_from);
346 
347            require(previousBalanceFrom >= _amount);
348 
349            // Alerts the token controller of the transfer
350            if (controller != 0) {
351                require(TokenController(controller).onTransfer(_from, _to, _amount));
352            }
353 
354            // First update the balance array with the new value for the address
355            //  sending the tokens
356            balances[_from] = previousBalanceFrom - _amount;
357            
358            if (limited_balances[_from].limitType > 0) {
359                require(limited_balances[_from].limitType <= limitBranchType);
360                uint minimumLimit = (limited_balances[_from].initial * limits[limited_balances[_from].limitType - 1])/100;
361                require(balances[_from] >= minimumLimit);
362            }
363 
364            // Then update the balance array with the new value for the address
365            //  receiving the tokens
366            uint previousBalanceTo = balanceOf(_to);
367            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
368            balances[_to] = previousBalanceTo + _amount;
369 
370            // An event to make the transfer easy to find on the blockchain
371            emit Transfer(_from, _to, _amount);
372     }
373 
374     /// @notice Enables token holders to transfer their tokens freely if true
375     /// @param _transfersEnabled True if transfers are allowed in the clone
376     function enableTransfers(bool _transfersEnabled) public onlyOwner {
377         transfersEnabled = _transfersEnabled;
378     }
379 
380     /// @notice This method can be used by the owner to extract mistakenly
381     ///  sent tokens to this contract.
382     /// @param _token The address of the token contract that you want to recover
383     ///  set to 0 in case you want to extract ether.
384     function claimTokens(address _token) public onlyOwner {
385         if (_token == 0x0) {
386             owner.transfer(address(this).balance);
387             return;
388         }
389 
390         ERC20Interface token = ERC20Interface(_token);
391         uint balance = token.balanceOf(this);
392         token.transfer(owner, balance);
393         emit ClaimedTokens(_token, owner, balance);
394     }
395     
396     event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
397 }