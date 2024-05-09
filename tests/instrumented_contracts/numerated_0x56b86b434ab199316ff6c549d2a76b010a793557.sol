1 pragma solidity ^0.4.21;
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
100 contract standardToken is ERC20Token {
101     mapping (address => uint256) balances;
102     mapping (address => mapping (address => uint256)) allowances;
103     
104 
105     function balanceOf(address _owner) constant public returns (uint256) {
106         return balances[_owner];
107     }
108 
109     /* Transfers tokens from your address to other */
110     function transfer(address _to, uint256 _value) 
111         public 
112         returns (bool success) 
113     {
114         require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance
115         require (balances[_to] + _value >= balances[_to]);  // Throw if owerflow detected
116         balances[msg.sender] -= _value;                     // Deduct senders balance
117         balances[_to] += _value;                            // Add recivers blaance
118         emit Transfer(msg.sender, _to, _value);                  // Raise Transfer event
119         return true;
120     }
121 
122     /* Approve other address to spend tokens on your account */
123     function approve(address _spender, uint256 _value) public returns (bool success) {
124         require(balances[msg.sender] >= _value);
125         allowances[msg.sender][_spender] = _value;          // Set allowance
126         emit Approval(msg.sender, _spender, _value);             // Raise Approval event
127         return true;
128     }
129 
130     /* Approve and then communicate the approved contract in a single tx */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
132         tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract
133         approve(_spender, _value);                                      // Set approval to contract for _value
134         spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
135         return true;
136     }
137 
138     /* A contract attempts to get the coins */
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
140         require (balances[_from] >= _value);                // Throw if sender does not have enough balance
141         require (balances[_to] + _value >= balances[_to]);  // Throw if overflow detected
142         require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance
143         balances[_from] -= _value;                          // Deduct senders balance
144         balances[_to] += _value;                            // Add recipient blaance
145         allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address
146         emit Transfer(_from, _to, _value);                       // Raise Transfer event
147         return true;
148     }
149 
150     /* Get the amount of allowed tokens to spend */
151     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
152         return allowances[_owner][_spender];
153     }
154 
155 }
156 
157 contract EOBIToken is standardToken,Owned {
158     using SafeMath for uint;
159 
160     string public name="EOBI Token";
161     string public symbol="EOBI";
162     uint256 public decimals=18;
163     
164     uint256 public totalSupply = 0;
165     uint256 public topTotalSupply = 35*10**8*10**decimals;
166     uint256 public privateTotalSupply = percent(10);
167     uint256 public privateSupply = 0;
168     address public walletAddress;
169 
170     uint256 public exchangeRate = 10**5;
171     
172     bool public ICOStart;
173     
174     /// @dev Fallback to calling deposit when ether is sent directly to contract.
175     function() public payable {
176         if(ICOStart){
177             depositToken(msg.value);
178         }
179     }
180     
181     /// @dev initial function
182     function EOBIToken() public {
183         owner=msg.sender;
184         ICOStart = true;
185     }
186     
187     /// @dev calcute the tokens
188     function percent(uint256 _percentage) internal view returns (uint256) {
189         return _percentage.mul(topTotalSupply).div(100);
190     }
191     
192     /// @dev Buys tokens with Ether.
193     function depositToken(uint256 _value) internal {
194         uint256 tokenAlloc = buyPriceAt() * _value;
195         require(tokenAlloc != 0);
196         privateSupply = privateSupply.add(tokenAlloc);
197         require (privateSupply <= privateTotalSupply);
198         mintTokens(msg.sender, tokenAlloc);
199     }
200     
201     /// @dev Issue new tokens
202     function mintTokens(address _to, uint256 _amount) internal {
203         require (balances[_to] + _amount >= balances[_to]);     // Check for overflows
204         balances[_to] = balances[_to].add(_amount);             // Set minted coins to target
205         totalSupply = totalSupply.add(_amount);
206         require(totalSupply <= topTotalSupply);
207         emit Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
208     }
209     
210     /// @dev Calculate exchange
211     function buyPriceAt() internal constant returns(uint256) {
212         return exchangeRate;
213     }
214     
215     /// @dev change exchange rate
216     function changeExchangeRate(uint256 _rate) public onlyOwner {
217         exchangeRate = _rate;
218     }
219     
220     /// @dev set initial message
221     function setVaribles(string _name, string _symbol, uint256 _decimals) public onlyOwner {
222         name = _name;
223         symbol = _symbol;
224         decimals = _decimals;
225         topTotalSupply = 35*10**8*10**decimals;
226         require(totalSupply <= topTotalSupply);
227         privateTotalSupply = percent(10);
228         require(privateSupply <= privateTotalSupply);
229     }
230     
231     /// @dev change ICO State
232     function ICOState(bool _start) public onlyOwner {
233         ICOStart = _start;
234     }
235     
236     /// @dev withDraw Ether to a Safe Wallet
237     function withDraw(address _etherAddress) public payable onlyOwner {
238         require (_etherAddress != address(0));
239         address contractAddress = this;
240         _etherAddress.transfer(contractAddress.balance);
241     }
242     
243     /// @dev allocate Token
244     function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {
245         require (_owners.length == _values.length);
246         for(uint256 i = 0; i < _owners.length ; i++){
247             address owner = _owners[i];
248             uint256 value = _values[i];
249             mintTokens(owner, value);
250         }
251     }
252 }