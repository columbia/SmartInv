1 pragma solidity ^0.4.18;
2 
3 // Owned contract
4 // ----------------------------------------------------------------------------
5 contract Owned {
6     address owner;
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11     function owned() public {
12         owner = msg.sender;
13     }
14 
15     function changeOwner(address _newOwner) public onlyOwner{
16         owner = _newOwner;
17     }
18 }
19 
20 
21 // Safe maths, borrowed from OpenZeppelin
22 // ----------------------------------------------------------------------------
23 library SafeMath {
24 
25   function mul(uint a, uint b) internal pure returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint a, uint b) internal pure returns (uint) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint a, uint b) internal pure returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint a, uint b) internal pure returns (uint) {
44     uint c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 
49 }
50 
51 contract tokenRecipient {
52   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
53 }
54 
55 contract ERC20Token {
56     /* This is a slight change to the ERC20 base standard.
57     function totalSupply() constant returns (uint256 supply);
58     is replaced with:
59     uint256 public totalSupply;
60     This automatically creates a getter function for the totalSupply.
61     This is moved to the base contract since public getter functions are not
62     currently recognised as an implementation of the matching abstract
63     function by the compiler.
64     */
65     /// total amount of tokens
66     uint256 public totalSupply;
67 
68     /// @param _owner The address from which the balance will be retrieved
69     /// @return The balance
70     function balanceOf(address _owner) constant public returns (uint256 balance);
71 
72     /// @notice send `_value` token to `_to` from `msg.sender`
73     /// @param _to The address of the recipient
74     /// @param _value The amount of token to be transferred
75     /// @return Whether the transfer was successful or not
76     function transfer(address _to, uint256 _value) public returns (bool success);
77 
78     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
79     /// @param _from The address of the sender
80     /// @param _to The address of the recipient
81     /// @param _value The amount of token to be transferred
82     /// @return Whether the transfer was successful or not
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
84 
85     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
86     /// @param _spender The address of the account able to transfer the tokens
87     /// @param _value The amount of tokens to be approved for transfer
88     /// @return Whether the approval was successful or not
89     function approve(address _spender, uint256 _value) public returns (bool success);
90 
91     /// @param _owner The address of the account owning tokens
92     /// @param _spender The address of the account able to transfer the tokens
93     /// @return Amount of remaining tokens allowed to spent
94     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
95 
96     event Transfer(address indexed _from, address indexed _to, uint256 _value);
97     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98 }
99 
100 contract limitedFactor {
101     uint256 public startTime;
102     uint256 public stopTime;
103     address public walletAddress;
104     address public teamAddress;
105     address public contributorsAddress;
106     bool public tokenFrozen = true;
107     modifier teamAccountNeedFreezeOneYear(address _address) {
108         if(_address == teamAddress) {
109             require(now > startTime + 1 years);
110         }
111         _;
112     }
113     
114     modifier TokenUnFreeze() {
115         require(!tokenFrozen);
116         _;
117     } 
118 }
119 contract standardToken is ERC20Token, limitedFactor {
120     mapping (address => uint256) balances;
121     mapping (address => mapping (address => uint256)) allowances;
122 
123     function balanceOf(address _owner) constant public returns (uint256) {
124         return balances[_owner];
125     }
126 
127     /* Transfers tokens from your address to other */
128     function transfer(address _to, uint256 _value) public TokenUnFreeze teamAccountNeedFreezeOneYear(msg.sender) returns (bool success) {
129         require (balances[msg.sender] > _value);           // Throw if sender has insufficient balance
130         require (balances[_to] + _value > balances[_to]);  // Throw if owerflow detected
131         balances[msg.sender] -= _value;                     // Deduct senders balance
132         balances[_to] += _value;                            // Add recivers blaance
133         Transfer(msg.sender, _to, _value);                  // Raise Transfer event
134         return true;
135     }
136 
137     /* Approve other address to spend tokens on your account */
138     function approve(address _spender, uint256 _value) public TokenUnFreeze returns (bool success) {
139         allowances[msg.sender][_spender] = _value;          // Set allowance
140         Approval(msg.sender, _spender, _value);             // Raise Approval event
141         return true;
142     }
143 
144     /* Approve and then communicate the approved contract in a single tx */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public TokenUnFreeze returns (bool success) {
146         tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract
147         approve(_spender, _value);                                      // Set approval to contract for _value
148         spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
149         return true;
150     }
151 
152     /* A contract attempts to get the coins */
153     function transferFrom(address _from, address _to, uint256 _value) public TokenUnFreeze returns (bool success) {
154         require (balances[_from] > _value);                // Throw if sender does not have enough balance
155         require (balances[_to] + _value > balances[_to]);  // Throw if overflow detected
156         require (_value > allowances[_from][msg.sender]);  // Throw if you do not have allowance
157         balances[_from] -= _value;                          // Deduct senders balance
158         balances[_to] += _value;                            // Add recipient blaance
159         allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address
160         Transfer(_from, _to, _value);                       // Raise Transfer event
161         return true;
162     }
163 
164     /* Get the amount of allowed tokens to spend */
165     function allowance(address _owner, address _spender) constant public TokenUnFreeze returns (uint256 remaining) {
166         return allowances[_owner][_spender];
167     }
168 
169 }
170 
171 contract FansChainToken is standardToken,Owned {
172     using SafeMath for uint;
173 
174     string constant public name="FansChain";
175     string constant public symbol="FSC";
176     uint256 constant public decimals=18;
177     
178     uint256 public totalSupply = 0;
179     uint256 constant public topTotalSupply = 24*10**7*10**decimals;
180     uint256 public teamSupply = percent(25);
181     uint256 public privateFundSupply = percent(25);
182     uint256 public privateFundingSupply = 0;
183     uint256 public ICOtotalSupply = percent(20);
184     uint256 public ICOSupply = 0;
185     uint256 public ContributorsSupply = percent(30);
186     uint256 public exchangeRate;
187     
188     
189     
190     /// @dev Fallback to calling deposit when ether is sent directly to contract.
191     function() public payable {
192         depositToken(msg.value);
193     }
194     
195     
196     function FansChainToken() public {
197         owner=msg.sender;
198     }
199     
200     /// @dev Buys tokens with Ether.
201     function depositToken(uint256 _value) internal {
202         uint256 tokenAlloc = buyPriceAt(getTime()) * _value;
203         ICOSupply = ICOSupply.add(tokenAlloc);
204         require (ICOSupply < ICOtotalSupply);
205         mintTokens (msg.sender, tokenAlloc);
206         forwardFunds();
207     }
208     
209     function forwardFunds() internal {
210         require(walletAddress != address(0));
211         walletAddress.transfer(msg.value);
212     }
213     
214     /// @dev Issue new tokens
215     function mintTokens(address _to, uint256 _amount) internal {
216         require (balances[_to] + _amount > balances[_to]);      // Check for overflows
217         balances[_to] = balances[_to].add(_amount);             // Set minted coins to target
218         totalSupply = totalSupply.add(_amount);
219         Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
220     }
221     
222     /// @dev Calculate exchange
223     function buyPriceAt(uint256 _time) internal constant returns(uint256) {
224         if (_time >= startTime && _time <= stopTime) {
225             return exchangeRate;
226         } else {
227             return 0;
228         }
229     }
230     
231     /// @dev Get time
232     function getTime() internal constant returns(uint256) {
233         return now;
234     }
235     
236     /// @dev set initial message
237     function setInitialVaribles(
238         uint256 _icoStartTime, 
239         uint256 _icoStopTime,
240         uint256 _exchangeRate,
241         address _walletAddress,
242         address _teamAddress,
243         address _contributorsAddress
244         )
245         public
246         onlyOwner {
247             startTime = _icoStartTime;
248             stopTime = _icoStopTime;
249             exchangeRate=_exchangeRate;
250             walletAddress = _walletAddress;
251             teamAddress = _teamAddress;
252             contributorsAddress = _contributorsAddress;
253         }
254     
255     /// @dev withDraw Ether to a Safe Wallet
256     function withDraw() public payable onlyOwner {
257         require (msg.sender != address(0));
258         require (getTime() > stopTime);
259         walletAddress.transfer(this.balance);
260     }
261     
262     /// @dev unfreeze if ICO succeed
263     function unfreezeTokenTransfer(bool _freeze) public onlyOwner {
264         tokenFrozen = !_freeze;
265     }
266     
267     /// @dev allocate Token
268     function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {
269         require (_owners.length == _values.length);
270         for(uint256 i = 0; i < _owners.length ; i++){
271             address owner = _owners[i];
272             uint256 value = _values[i];
273             ICOSupply = ICOSupply.add(value);
274             require(totalSupply < ICOtotalSupply);
275             mintTokens(owner, value);
276         }
277     }
278     
279     /// @dev calcute the tokens
280     function percent(uint256 percentage) internal  pure returns (uint256) {
281         return percentage.mul(topTotalSupply).div(100);
282     }
283      
284      /// @dev allocate token for Team Address
285     function allocateTeamToken() public onlyOwner {
286         mintTokens(teamAddress, teamSupply);
287     }
288     
289     /// @dev allocate token for Private Address
290     function allocatePrivateToken(address[] _privateFundingAddress, uint256[] _amount) public onlyOwner {
291         require (_privateFundingAddress.length == _amount.length);
292         for(uint256 i = 0; i < _privateFundingAddress.length ; i++){
293             address owner = _privateFundingAddress[i];
294             uint256 value = _amount[i];
295             privateFundingSupply = privateFundingSupply.add(value);
296             require(privateFundingSupply <= privateFundSupply);
297             mintTokens(owner, value);
298         }
299     }
300     
301     /// @dev allocate token for contributors Address
302     function allocateContributorsToken() public onlyOwner {
303         mintTokens(contributorsAddress, ContributorsSupply);
304     }
305 }