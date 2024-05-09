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
70 // Dividends implementation interface
71 // ----------------------------------------------------------------------------
72 contract DividendsDistributor {
73     function totalDividends() public constant returns (uint);
74     function totalUndistributedDividends() public constant returns (uint);
75     function totalDistributedDividends() public constant returns (uint);
76     function totalPaidDividends() public constant returns (uint);
77     function balanceOf(address tokenOwner) public constant returns (uint balance);
78     function distributeDividendsOnTransferFrom(address from, address to, uint tokens) public returns (bool success);
79     function withdrawDividends() public returns(bool success);
80 
81     event DividendsDistributed(address indexed tokenOwner, uint dividends);
82     event DividendsPaid(address indexed tokenOwner, uint dividends);
83 }
84 
85 // ----------------------------------------------------------------------------
86 // Contract function to receive approval and execute function in one call
87 //
88 // Borrowed from MiniMeToken
89 // ----------------------------------------------------------------------------
90 contract ApproveAndCallFallBack {
91     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
92 }
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and an
96 // initial fixed supply
97 // ----------------------------------------------------------------------------
98 contract AHF_Token is ERC20Interface, Owned {
99     string public constant symbol = "AHF";
100     string public constant name = "Ahedgefund Sagl Token";
101     uint8 public constant decimals = 18;
102     uint private constant _totalSupply = 130000000 * 10**uint(decimals);
103 
104     mapping(address => uint) balances;
105     mapping(address => mapping(address => uint)) allowed;
106 
107     address public dividendsDistributor;
108     address public controller;
109     
110     // Flag that determines if the token is transferable or not.
111     bool public transfersEnabled;
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     constructor() public {
116         balances[owner] = _totalSupply;
117         transfersEnabled = true;
118         emit Transfer(address(0), owner, _totalSupply);
119     }
120 
121 
122     function setDividendsDistributor(address _newDividendsDistributor) public onlyOwner {
123         dividendsDistributor = _newDividendsDistributor;
124     }
125 
126     /// @notice Changes the controller of the contract
127     /// @param _newController The new controller of the contract
128     function setController(address _newController) public onlyOwner {
129         controller = _newController;
130     }
131     
132     // ------------------------------------------------------------------------
133     // Total supply
134     // ------------------------------------------------------------------------
135     function totalSupply() public constant returns (uint) {
136         return _totalSupply  - balances[address(0)];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Get the token balance for account `tokenOwner`
142     // ------------------------------------------------------------------------
143     function balanceOf(address tokenOwner) public constant returns (uint balance) {
144         return balances[tokenOwner];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for `spender` to transferFrom(...) `tokens`
150     // from the token owner's account
151     //
152     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
153     // recommends that there are no checks for the approval double-spend attack
154     // as this should be implemented in user interfaces 
155     // ------------------------------------------------------------------------
156     function approve(address _spender, uint _amount) public returns (bool success) {
157         require(transfersEnabled);
158 
159         // Alerts the token controller of the approve function call
160         if (isContract(controller)) {
161             require(TokenController(controller).onApprove(msg.sender, _spender, allowed[msg.sender][_spender], _amount));
162         }
163 
164         allowed[msg.sender][_spender] = _amount;
165         emit Approval(msg.sender, _spender, _amount);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Returns the amount of tokens approved by the owner that can be
172     // transferred to the spender's account
173     // ------------------------------------------------------------------------
174     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
175         return allowed[tokenOwner][spender];
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Transfer the balance from token owner's account to `to` account
181     // - Owner's account must have sufficient balance to transfer
182     // - 0 value transfers are allowed
183     // ------------------------------------------------------------------------
184     function transfer(address _to, uint _amount) public returns (bool success) {
185         require(transfersEnabled);
186         doTransfer(msg.sender, _to, _amount);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Transfer `tokens` from the `from` account to the `to` account
193     // 
194     // The calling account must already have sufficient tokens approve(...)-d
195     // for spending from the `from` account and
196     // - From account must have sufficient balance to transfer
197     // - Spender must have sufficient allowance to transfer
198     // - 0 value transfers are allowed
199     // ------------------------------------------------------------------------
200     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
201         require(transfersEnabled);
202 
203         // The standard ERC 20 transferFrom functionality
204         require(allowed[_from][msg.sender] >= _amount);
205         allowed[_from][msg.sender] -= _amount;
206         doTransfer(_from, _to, _amount);
207         return true;
208     }
209 
210 
211     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
212     ///  its behalf, and then a function is triggered in the contract that is
213     ///  being approved, `_spender`. This allows users to use their tokens to
214     ///  interact with contracts in one function call instead of two
215     /// @param _spender The address of the contract able to transfer the tokens
216     /// @param _amount The amount of tokens to be approved for transfer
217     /// @return True if the function call was successful
218     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
219     ) public returns (bool success) {
220         require(approve(_spender, _amount));
221 
222         ApproveAndCallFallBack(_spender).receiveApproval(
223             msg.sender,
224             _amount,
225             this,
226             _extraData
227         );
228 
229         return true;
230     }
231 
232     // ------------------------------------------------------------------------
233     // Don't accept ETH
234     // ------------------------------------------------------------------------
235     function () public payable {
236         revert();
237     }
238 
239 
240     /// @dev This is the actual transfer function in the token contract, it can
241     ///  only be called by other functions in this contract.
242     /// @param _from The address holding the tokens being transferred
243     /// @param _to The address of the recipient
244     /// @param _amount The amount of tokens to be transferred
245     /// @return True if the transfer was successful
246     function doTransfer(address _from, address _to, uint _amount) internal {
247            if (_amount == 0) {
248                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
249                return;
250            }
251 
252            // Do not allow transfer to 0x0 or the token contract itself
253            require((_to != 0) && (_to != address(this)));
254 
255            // If the amount being transfered is more than the balance of the
256            //  account the transfer throws
257            uint previousBalanceFrom = balanceOf(_from);
258 
259            require(previousBalanceFrom >= _amount);
260 
261            // Alerts the token controller of the transfer
262            if (isContract(controller)) {
263                require(TokenController(controller).onTransfer(_from, _to, _amount));
264            }
265 
266            // First update the balance array with the new value for the address
267            //  sending the tokens
268            balances[_from] = previousBalanceFrom - _amount;
269 
270            // Then update the balance array with the new value for the address
271            //  receiving the tokens
272            uint previousBalanceTo = balanceOf(_to);
273            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
274            balances[_to] = previousBalanceTo + _amount;
275 
276            // An event to make the transfer easy to find on the blockchain
277            emit Transfer(_from, _to, _amount);
278            
279            if (isContract(dividendsDistributor)) {
280                 require(DividendsDistributor(dividendsDistributor).distributeDividendsOnTransferFrom(_from, _to, _amount));
281             }
282     }
283 
284     /// @notice Enables token holders to transfer their tokens freely if true
285     /// @param _transfersEnabled True if transfers are allowed in the clone
286     function enableTransfers(bool _transfersEnabled) public onlyOwner {
287         transfersEnabled = _transfersEnabled;
288     }
289 
290     /// @dev Internal function to determine if an address is a contract
291     /// @param _addr The address being queried
292     /// @return True if `_addr` is a contract
293     function isContract(address _addr) constant internal returns(bool) {
294         uint size;
295         if (_addr == 0) return false;
296         assembly {
297             size := extcodesize(_addr)
298         }
299         return size>0;
300     }
301 
302     /// @notice This method can be used by the owner to extract mistakenly
303     ///  sent tokens to this contract.
304     /// @param _token The address of the token contract that you want to recover
305     ///  set to 0 in case you want to extract ether.
306     function claimTokens(address _token) public onlyOwner {
307         if (_token == 0x0) {
308             owner.transfer(address(this).balance);
309             return;
310         }
311 
312         ERC20Interface token = ERC20Interface(_token);
313         uint balance = token.balanceOf(this);
314         token.transfer(owner, balance);
315         emit ClaimedTokens(_token, owner, balance);
316     }
317     
318     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
319 }