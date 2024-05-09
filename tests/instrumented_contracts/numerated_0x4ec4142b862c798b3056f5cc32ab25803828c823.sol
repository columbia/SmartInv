1 pragma solidity 0.4.20;
2 
3 // No deps verison.
4 
5 /**
6  * @title ERC20
7  * @dev A standard interface for tokens.
8  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
9  */
10 contract ERC20 {
11   
12     /// @dev Returns the total token supply
13     function totalSupply() public constant returns (uint256 supply);
14 
15     /// @dev Returns the account balance of the account with address _owner
16     function balanceOf(address _owner) public constant returns (uint256 balance);
17 
18     /// @dev Transfers _value number of tokens to address _to
19     function transfer(address _to, uint256 _value) public returns (bool success);
20 
21     /// @dev Transfers _value number of tokens from address _from to address _to
22     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
23 
24     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
25     function approve(address _spender, uint256 _value) public returns (bool success);
26 
27     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
28     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
29 
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33 }
34 
35 /// @title Owned
36 /// @author Adrià Massanet <adria@codecontext.io>
37 /// @notice The Owned contract has an owner address, and provides basic 
38 ///  authorization control functions, this simplifies & the implementation of
39 ///  user permissions; this contract has three work flows for a change in
40 ///  ownership, the first requires the new owner to validate that they have the
41 ///  ability to accept ownership, the second allows the ownership to be
42 ///  directly transfered without requiring acceptance, and the third allows for
43 ///  the ownership to be removed to allow for decentralization 
44 contract Owned {
45 
46     address public owner;
47     address public newOwnerCandidate;
48 
49     event OwnershipRequested(address indexed by, address indexed to);
50     event OwnershipTransferred(address indexed from, address indexed to);
51     event OwnershipRemoved();
52 
53     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
54     function Owned() public {
55         owner = msg.sender;
56     }
57 
58     /// @dev `owner` is the only address that can call a function with this
59     /// modifier
60     modifier onlyOwner() {
61         require (msg.sender == owner);
62         _;
63     }
64     
65     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
66     ///  be called first by the current `owner` then `acceptOwnership()` must be
67     ///  called by the `newOwnerCandidate`
68     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
69     ///  new owner
70     /// @param _newOwnerCandidate The address being proposed as the new owner
71     function proposeOwnership(address _newOwnerCandidate) public onlyOwner {
72         newOwnerCandidate = _newOwnerCandidate;
73         OwnershipRequested(msg.sender, newOwnerCandidate);
74     }
75 
76     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
77     ///  transfer of ownership
78     function acceptOwnership() public {
79         require(msg.sender == newOwnerCandidate);
80 
81         address oldOwner = owner;
82         owner = newOwnerCandidate;
83         newOwnerCandidate = 0x0;
84 
85         OwnershipTransferred(oldOwner, owner);
86     }
87 
88     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
89     ///  be called and it will immediately assign ownership to the `newOwner`
90     /// @notice `owner` can step down and assign some other address to this role
91     /// @param _newOwner The address of the new owner
92     function changeOwnership(address _newOwner) public onlyOwner {
93         require(_newOwner != 0x0);
94 
95         address oldOwner = owner;
96         owner = _newOwner;
97         newOwnerCandidate = 0x0;
98 
99         OwnershipTransferred(oldOwner, owner);
100     }
101 
102     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
103     ///  be called and it will immediately assign ownership to the 0x0 address;
104     ///  it requires a 0xdece be input as a parameter to prevent accidental use
105     /// @notice Decentralizes the contract, this operation cannot be undone 
106     /// @param _dac `0xdac` has to be entered for this function to work
107     function removeOwnership(address _dac) public onlyOwner {
108         require(_dac == 0xdac);
109         owner = 0x0;
110         newOwnerCandidate = 0x0;
111         OwnershipRemoved();     
112     }
113 } 
114 
115 /// @dev `Escapable` is a base level contract built off of the `Owned`
116 ///  contract; it creates an escape hatch function that can be called in an
117 ///  emergency that will allow designated addresses to send any ether or tokens
118 ///  held in the contract to an `escapeHatchDestination` as long as they were
119 ///  not blacklisted
120 contract Escapable is Owned {
121     address public escapeHatchCaller;
122     address public escapeHatchDestination;
123     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
124 
125     /// @notice The Constructor assigns the `escapeHatchDestination` and the
126     ///  `escapeHatchCaller`
127     /// @param _escapeHatchCaller The address of a trusted account or contract
128     ///  to call `escapeHatch()` to send the ether in this contract to the
129     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
130     ///  cannot move funds out of `escapeHatchDestination`
131     /// @param _escapeHatchDestination The address of a safe location (usu a
132     ///  Multisig) to send the ether held in this contract; if a neutral address
133     ///  is required, the WHG Multisig is an option:
134     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
135     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) public {
136         escapeHatchCaller = _escapeHatchCaller;
137         escapeHatchDestination = _escapeHatchDestination;
138     }
139 
140     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
141     ///  are the only addresses that can call a function with this modifier
142     modifier onlyEscapeHatchCallerOrOwner {
143         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
144         _;
145     }
146 
147     /// @notice Creates the blacklist of tokens that are not able to be taken
148     ///  out of the contract; can only be done at the deployment, and the logic
149     ///  to add to the blacklist will be in the constructor of a child contract
150     /// @param _token the token contract address that is to be blacklisted 
151     function blacklistEscapeToken(address _token) internal {
152         escapeBlacklist[_token] = true;
153         EscapeHatchBlackistedToken(_token);
154     }
155 
156     /// @notice Checks to see if `_token` is in the blacklist of tokens
157     /// @param _token the token address being queried
158     /// @return False if `_token` is in the blacklist and can't be taken out of
159     ///  the contract via the `escapeHatch()`
160     function isTokenEscapable(address _token) view public returns (bool) {
161         return !escapeBlacklist[_token];
162     }
163 
164     /// @notice The `escapeHatch()` should only be called as a last resort if a
165     /// security issue is uncovered or something unexpected happened
166     /// @param _token to transfer, use 0x0 for ether
167     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
168         require(escapeBlacklist[_token]==false);
169 
170         uint256 balance;
171 
172         /// @dev Logic for ether
173         if (_token == 0x0) {
174             balance = this.balance;
175             escapeHatchDestination.transfer(balance);
176             EscapeHatchCalled(_token, balance);
177             return;
178         }
179         /// @dev Logic for tokens
180         ERC20 token = ERC20(_token);
181         balance = token.balanceOf(this);
182         require(token.transfer(escapeHatchDestination, balance));
183         EscapeHatchCalled(_token, balance);
184     }
185 
186     /// @notice Changes the address assigned to call `escapeHatch()`
187     /// @param _newEscapeHatchCaller The address of a trusted account or
188     ///  contract to call `escapeHatch()` to send the value in this contract to
189     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
190     ///  cannot move funds out of `escapeHatchDestination`
191     function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {
192         escapeHatchCaller = _newEscapeHatchCaller;
193     }
194 
195     event EscapeHatchBlackistedToken(address token);
196     event EscapeHatchCalled(address token, uint amount);
197 }
198 
199 // TightlyPacked is cheaper if you need to store input data and if amount is less than 12 bytes.
200 // Normal is cheaper if you don't need to store input data or if amounts are greater than 12 bytes.
201 contract UnsafeMultiplexor is Escapable(0, 0) {
202     function init(address _escapeHatchCaller, address _escapeHatchDestination) public {
203         require(escapeHatchCaller == 0);
204         require(_escapeHatchCaller != 0);
205         require(_escapeHatchDestination != 0);
206         escapeHatchCaller = _escapeHatchCaller;
207         escapeHatchDestination = _escapeHatchDestination;
208     }
209     
210     modifier sendBackLeftEther() {
211         uint balanceBefore = this.balance - msg.value;
212         _;
213         uint leftovers = this.balance - balanceBefore;
214         if (leftovers > 0) {
215             msg.sender.transfer(leftovers);
216         }
217     }
218     
219     function multiTransferTightlyPacked(bytes32[] _addressAndAmount) sendBackLeftEther() payable public returns(bool) {
220         for (uint i = 0; i < _addressAndAmount.length; i++) {
221             _unsafeTransfer(address(_addressAndAmount[i] >> 96), uint(uint96(_addressAndAmount[i])));
222         }
223         return true;
224     }
225 
226     function multiTransfer(address[] _address, uint[] _amount) sendBackLeftEther() payable public returns(bool) {
227         for (uint i = 0; i < _address.length; i++) {
228             _unsafeTransfer(_address[i], _amount[i]);
229         }
230         return true;
231     }
232 
233     function multiCallTightlyPacked(bytes32[] _addressAndAmount) sendBackLeftEther() payable public returns(bool) {
234         for (uint i = 0; i < _addressAndAmount.length; i++) {
235             _unsafeCall(address(_addressAndAmount[i] >> 96), uint(uint96(_addressAndAmount[i])));
236         }
237         return true;
238     }
239 
240     function multiCall(address[] _address, uint[] _amount) sendBackLeftEther() payable public returns(bool) {
241         for (uint i = 0; i < _address.length; i++) {
242             _unsafeCall(_address[i], _amount[i]);
243         }
244         return true;
245     }
246 
247     function _unsafeTransfer(address _to, uint _amount) internal {
248         require(_to != 0);
249         _to.send(_amount);
250     }
251 
252     function _unsafeCall(address _to, uint _amount) internal {
253         require(_to != 0);
254         _to.call.value(_amount)();
255     }
256 }