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
101     uint256 public FoundationAddressFreezeTime;
102     address public FoundationAddress;
103     address public TeamAddress;
104     modifier FoundationAccountNeedFreezeOneYear(address _address) {
105         if(_address == FoundationAddress) {
106             require(now >= FoundationAddressFreezeTime + 1 years);
107         }
108         _;
109     }
110 
111 }
112 contract standardToken is ERC20Token, limitedFactor {
113     mapping (address => uint256) balances;
114     mapping (address => mapping (address => uint256)) allowances;
115 
116     function balanceOf(address _owner) constant public returns (uint256) {
117         return balances[_owner];
118     }
119 
120     /* Transfers tokens from your address to other */
121     function transfer(address _to, uint256 _value) public FoundationAccountNeedFreezeOneYear(msg.sender) returns (bool success) {
122         require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance
123         require (balances[_to] + _value >= balances[_to]);  // Throw if owerflow detected
124         balances[msg.sender] -= _value;                     // Deduct senders balance
125         balances[_to] += _value;                            // Add recivers blaance
126         Transfer(msg.sender, _to, _value);                  // Raise Transfer event
127         return true;
128     }
129 
130     /* Approve other address to spend tokens on your account */
131     function approve(address _spender, uint256 _value) public returns (bool success) {
132         require(balances[msg.sender] >= _value);
133         allowances[msg.sender][_spender] = _value;          // Set allowance
134         Approval(msg.sender, _spender, _value);             // Raise Approval event
135         return true;
136     }
137 
138     /* Approve and then communicate the approved contract in a single tx */
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
140         tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract
141         approve(_spender, _value);                                      // Set approval to contract for _value
142         spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
143         return true;
144     }
145 
146     /* A contract attempts to get the coins */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
148         require (balances[_from] >= _value);                // Throw if sender does not have enough balance
149         require (balances[_to] + _value >= balances[_to]);  // Throw if overflow detected
150         require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance
151         balances[_from] -= _value;                          // Deduct senders balance
152         balances[_to] += _value;                            // Add recipient blaance
153         allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address
154         Transfer(_from, _to, _value);                       // Raise Transfer event
155         return true;
156     }
157 
158     /* Get the amount of allowed tokens to spend */
159     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
160         return allowances[_owner][_spender];
161     }
162 
163 }
164 
165 contract NSilkRoadCoinToken is standardToken,Owned {
166     using SafeMath for uint;
167 
168     string constant public name="NSilkRoadCoinToken";
169     string constant public symbol="NSRC";
170     uint256 constant public decimals=6;
171     
172     uint256 public totalSupply = 0;
173     uint256 constant public topTotalSupply = 21*10**7*10**decimals;
174     uint256 public FoundationSupply = percent(30);
175 	uint256 public TeamSupply = percent(25);
176     uint256 public ownerSupply = topTotalSupply - FoundationSupply - TeamSupply;
177     
178     /// @dev Fallback to calling deposit when ether is sent directly to contract.
179     function() public payable {}
180     
181     /// @dev initial function
182     function NSilkRoadCoinToken() public {
183         owner = msg.sender;
184         mintTokens(owner, ownerSupply);
185     }
186     
187     /// @dev Issue new tokens
188     function mintTokens(address _to, uint256 _amount) internal {
189         require (balances[_to] + _amount >= balances[_to]);     // Check for overflows
190         balances[_to] = balances[_to].add(_amount);             // Set minted coins to target
191         totalSupply = totalSupply.add(_amount);
192         require(totalSupply <= topTotalSupply);
193         Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
194     }
195     
196     /// @dev Get time
197     function getTime() internal constant returns(uint256) {
198         return now;
199     }
200     
201     /// @dev set initial message
202     function setInitialVaribles(
203         address _FoundationAddress,
204         address _TeamAddress
205         )
206         public
207         onlyOwner 
208     {
209         FoundationAddress = _FoundationAddress;
210         TeamAddress = _TeamAddress;
211     }
212     
213     /// @dev withDraw Ether to a Safe Wallet
214     function withDraw(address _walletAddress) public payable onlyOwner {
215         require (_walletAddress != address(0));
216         _walletAddress.transfer(this.balance);
217     }
218     
219     /// @dev allocate Token
220     function transferMultiAddress(address[] _recivers, uint256[] _values) public onlyOwner {
221         require (_recivers.length == _values.length);
222         for(uint256 i = 0; i < _recivers.length ; i++){
223             address reciver = _recivers[i];
224             uint256 value = _values[i];
225             require (balances[msg.sender] >= value);           // Throw if sender has insufficient balance
226             require (balances[reciver] + value >= balances[reciver]);  // Throw if owerflow detected
227             balances[msg.sender] -= value;                     // Deduct senders balance
228             balances[reciver] += value;                            // Add recivers blaance
229             Transfer(msg.sender, reciver, value);                  // Raise Transfer event
230         }
231     }
232     
233     /// @dev calcute the tokens
234     function percent(uint256 percentage) internal pure returns (uint256) {
235         return percentage.mul(topTotalSupply).div(100);
236     }
237     
238     /// @dev allocate token for Foundation Address
239     function allocateFoundationToken() public onlyOwner {
240         require(TeamAddress != address(0));
241         require(balances[FoundationAddress] == 0);
242         mintTokens(FoundationAddress, FoundationSupply);
243         FoundationAddressFreezeTime = now;
244     }
245     
246     /// @dev allocate token for Team Address
247     function allocateTeamToken() public onlyOwner {
248         require(TeamAddress != address(0));
249         require(balances[TeamAddress] == 0);
250         mintTokens(TeamAddress, TeamSupply);
251     }
252 }