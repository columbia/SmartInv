1 pragma solidity ^0.4.18;
2 
3 // Owned contract
4 // ----------------------------------------------------------------------------
5 contract Owned {
6     address public owner;
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11     function Owned() public {
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
101     using SafeMath for uint;
102     
103     uint256 public totalSupply = 0;
104     uint256 public topTotalSupply = 18*10**8*10**18;
105     uint256 public teamSupply = percent(15);
106     uint256 public teamAlloacting = 0;
107     uint256 internal teamReleasetokenEachMonth = 5 * teamSupply / 100;
108     uint256 public creationInvestmentSupply = percent(15);
109     uint256 public creationInvestmenting = 0;
110     uint256 public ICOtotalSupply = percent(30);
111     uint256 public ICOSupply = 0;
112     uint256 public communitySupply = percent(20);
113     uint256 public communityAllocating = 0;
114     uint256 public angelWheelFinanceSupply = percent(20);
115     uint256 public angelWheelFinancing = 0;
116     address public walletAddress;
117     uint256 public teamAddressFreezeTime = startTimeRoundOne;
118     address public teamAddress;
119     uint256 internal teamAddressTransfer = 0;
120     uint256 public exchangeRateRoundOne = 16000;
121     uint256 public exchangeRateRoundTwo = 10000;
122     uint256 internal startTimeRoundOne = 1526313600;
123     uint256 internal stopTimeRoundOne =  1528991999;
124     
125     modifier teamAccountNeedFreeze18Months(address _address) {
126         if(_address == teamAddress) {
127             require(now >= teamAddressFreezeTime + 1.5 years);
128         }
129         _;
130     }
131     
132     modifier releaseToken (address _user, uint256 _time, uint256 _value) {
133         if (_user == teamAddress){
134             require (teamAddressTransfer + _value <= calcReleaseToken(_time)); 
135         }
136         _;
137     }
138     
139     function calcReleaseToken (uint256 _time) internal view returns (uint256) {
140         uint256 _timeDifference = _time - (teamAddressFreezeTime + 1.5 years);
141         return _timeDifference / (3600 * 24 * 30) * teamReleasetokenEachMonth;
142     } 
143     
144      /// @dev calcute the tokens
145     function percent(uint256 percentage) internal view returns (uint256) {
146         return percentage.mul(topTotalSupply).div(100);
147     }
148 
149 }
150 
151 contract standardToken is ERC20Token, limitedFactor {
152     mapping (address => uint256) balances;
153     mapping (address => mapping (address => uint256)) allowances;
154 
155     function balanceOf(address _owner) constant public returns (uint256) {
156         return balances[_owner];
157     }
158 
159     /* Transfers tokens from your address to other */
160     function transfer(address _to, uint256 _value) 
161         public 
162         teamAccountNeedFreeze18Months(msg.sender) 
163         releaseToken(msg.sender, now, _value)
164         returns (bool success) 
165     {
166         require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance
167         require (balances[_to] + _value >= balances[_to]);  // Throw if owerflow detected
168         balances[msg.sender] -= _value;                     // Deduct senders balance
169         balances[_to] += _value;                            // Add recivers blaance
170         if (msg.sender == teamAddress) {
171             teamAddressTransfer += _value;
172         }
173         emit Transfer(msg.sender, _to, _value);                  // Raise Transfer event
174         return true;
175     }
176 
177     /* Approve other address to spend tokens on your account */
178     function approve(address _spender, uint256 _value) public returns (bool success) {
179         require(balances[msg.sender] >= _value);
180         allowances[msg.sender][_spender] = _value;          // Set allowance
181         emit Approval(msg.sender, _spender, _value);             // Raise Approval event
182         return true;
183     }
184 
185     /* Approve and then communicate the approved contract in a single tx */
186     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
187         tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract
188         approve(_spender, _value);                                      // Set approval to contract for _value
189         spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
190         return true;
191     }
192 
193     /* A contract attempts to get the coins */
194     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
195         require (balances[_from] >= _value);                // Throw if sender does not have enough balance
196         require (balances[_to] + _value >= balances[_to]);  // Throw if overflow detected
197         require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance
198         balances[_from] -= _value;                          // Deduct senders balance
199         balances[_to] += _value;                            // Add recipient blaance
200         allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address
201         emit Transfer(_from, _to, _value);                       // Raise Transfer event
202         return true;
203     }
204 
205     /* Get the amount of allowed tokens to spend */
206     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
207         return allowances[_owner][_spender];
208     }
209 
210 }
211 
212 contract MMChainToken is standardToken,Owned {
213     using SafeMath for uint;
214 
215     string constant public name="MONEY MONSTER";
216     string constant public symbol="MM";
217     uint256 constant public decimals=6;
218     
219     bool public ICOStart;
220     
221     /// @dev Fallback to calling deposit when ether is sent directly to contract.
222     function() public payable {
223         require (ICOStart);
224         depositToken(msg.value);
225     }
226     
227     /// @dev initial function
228     function MMChainToken() public {
229         owner=msg.sender;
230         ICOStart = true;
231     }
232     
233     /// @dev Buys tokens with Ether.
234     function depositToken(uint256 _value) internal {
235         uint256 tokenAlloc = buyPriceAt(getTime()) * _value;
236         require(tokenAlloc != 0);
237         ICOSupply = ICOSupply.add(tokenAlloc);
238         require (ICOSupply <= ICOtotalSupply);
239         mintTokens(msg.sender, tokenAlloc);
240         forwardFunds();
241     }
242     
243     /// @dev internal function
244     function forwardFunds() internal {
245         if (walletAddress != address(0)){
246             walletAddress.transfer(msg.value);
247         }
248     }
249     
250     /// @dev Issue new tokens
251     function mintTokens(address _to, uint256 _amount) internal {
252         require (balances[_to] + _amount >= balances[_to]);     // Check for overflows
253         balances[_to] = balances[_to].add(_amount);             // Set minted coins to target
254         totalSupply = totalSupply.add(_amount);
255         require(totalSupply <= topTotalSupply);
256         emit Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
257     }
258     
259     /// @dev Calculate exchange
260     function buyPriceAt(uint256 _time) internal constant returns(uint256) {
261         if (_time >= startTimeRoundOne && _time <= stopTimeRoundOne) {
262             return exchangeRateRoundOne;
263         }  else {
264             return 0;
265         }
266     }
267     
268     /// @dev Get time
269     function getTime() internal constant returns(uint256) {
270         return now;
271     }
272     
273     /// @dev set initial message
274     function setInitialVaribles(address _walletAddress, address _teamAddress) public onlyOwner {
275         walletAddress = _walletAddress;
276         teamAddress = _teamAddress;
277     }
278     
279     /// @dev withDraw Ether to a Safe Wallet
280     function withDraw(address _etherAddress) public payable onlyOwner {
281         require (_etherAddress != address(0));
282         address contractAddress = this;
283         _etherAddress.transfer(contractAddress.balance);
284     }
285     
286     /// @dev allocate Token
287     function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {
288         require (_owners.length == _values.length);
289         for(uint256 i = 0; i < _owners.length ; i++){
290             address owner = _owners[i];
291             uint256 value = _values[i];
292             mintTokens(owner, value);
293         }
294     }
295     
296     /// @dev allocate token for Team Address
297     function allocateTeamToken() public onlyOwner {
298         require(balances[teamAddress] == 0);
299         mintTokens(teamAddress, teamSupply);
300         teamAddressFreezeTime = now;
301     }
302     
303     function allocateCommunityToken (address[] _commnityAddress, uint256[] _amount) public onlyOwner {
304         communityAllocating = mintMultiToken(_commnityAddress, _amount, communityAllocating);
305         require (communityAllocating <= communitySupply);
306     }
307     /// @dev allocate token for Private Address
308     function allocateCreationInvestmentingToken(address[] _creationInvestmentingingAddress, uint256[] _amount) public onlyOwner {
309         creationInvestmenting = mintMultiToken(_creationInvestmentingingAddress, _amount, creationInvestmenting);
310         require (creationInvestmenting <= creationInvestmentSupply);
311     }
312     
313     /// @dev allocate token for contributors Address
314     function allocateAngelWheelFinanceToken(address[] _angelWheelFinancingAddress, uint256[] _amount) public onlyOwner {
315         //require(balances[contributorsAddress] == 0);
316         angelWheelFinancing = mintMultiToken(_angelWheelFinancingAddress, _amount, angelWheelFinancing);
317         require (angelWheelFinancing <= angelWheelFinanceSupply);
318     }
319     
320     function mintMultiToken (address[] _multiAddr, uint256[] _multiAmount, uint256 _target) internal returns (uint256){
321         require (_multiAddr.length == _multiAmount.length);
322         for(uint256 i = 0; i < _multiAddr.length ; i++){
323             address owner = _multiAddr[i];
324             uint256 value = _multiAmount[i];
325             _target = _target.add(value);
326             mintTokens(owner, value);
327         }
328         return _target;
329     }
330 }