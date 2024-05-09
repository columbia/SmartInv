1 pragma solidity ^0.4.21;
2 
3 // Owned contract
4 // ----------------------------------------------------------------------------
5 contract Owned {
6     
7     /// 'owner' is the only address that can call a function with 
8     /// this modifier
9     address public owner;
10     address internal newOwner;
11     
12     ///@notice The constructor assigns the message sender to be 'owner'
13     function Owned() public {
14         owner = msg.sender;
15     }
16     
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21     
22     event updateOwner(address _oldOwner, address _newOwner);
23     
24     ///change the owner
25     function changeOwner(address _newOwner) public onlyOwner returns(bool) {
26         require(owner != _newOwner);
27         newOwner = _newOwner;
28         return true;
29     }
30     
31     /// accept the ownership
32     function acceptNewOwner() public returns(bool) {
33         require(msg.sender == newOwner);
34         emit updateOwner(owner, newOwner);
35         owner = newOwner;
36         return true;
37     }
38 }
39 
40 // Safe maths, borrowed from OpenZeppelin
41 // ----------------------------------------------------------------------------
42 library SafeMath {
43 
44   function mul(uint a, uint b) internal pure returns (uint) {
45     uint c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function div(uint a, uint b) internal pure returns (uint) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint a, uint b) internal pure returns (uint) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint a, uint b) internal pure returns (uint) {
63     uint c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 
68 }
69 
70 contract tokenRecipient {
71   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
72 }
73 
74 contract ERC20Token {
75     /* This is a slight change to the ERC20 base standard.
76     function totalSupply() constant returns (uint256 supply);
77     is replaced with:
78     uint256 public totalSupply;
79     This automatically creates a getter function for the totalSupply.
80     This is moved to the base contract since public getter functions are not
81     currently recognised as an implementation of the matching abstract
82     function by the compiler.
83     */
84     /// total amount of tokens
85     uint256 public totalSupply;
86 
87     /// @param _owner The address from which the balance will be retrieved
88     /// @return The balance
89     function balanceOf(address _owner) constant public returns (uint256 balance);
90 
91     /// @notice send `_value` token to `_to` from `msg.sender`
92     /// @param _to The address of the recipient
93     /// @param _value The amount of token to be transferred
94     /// @return Whether the transfer was successful or not
95     function transfer(address _to, uint256 _value) public returns (bool success);
96 
97     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
98     /// @param _from The address of the sender
99     /// @param _to The address of the recipient
100     /// @param _value The amount of token to be transferred
101     /// @return Whether the transfer was successful or not
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
103 
104     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
105     /// @param _spender The address of the account able to transfer the tokens
106     /// @param _value The amount of tokens to be approved for transfer
107     /// @return Whether the approval was successful or not
108     function approve(address _spender, uint256 _value) public returns (bool success);
109 
110     /// @param _owner The address of the account owning tokens
111     /// @param _spender The address of the account able to transfer the tokens
112     /// @return Amount of remaining tokens allowed to spent
113     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
114 
115     event Transfer(address indexed _from, address indexed _to, uint256 _value);
116     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
117 }
118 
119 contract standardToken is ERC20Token {
120     mapping (address => uint256) balances;
121     mapping (address => mapping (address => uint256)) allowances;
122 
123     function balanceOf(address _owner) constant public returns (uint256) {
124         return balances[_owner];
125     }
126 
127     /* Transfers tokens from your address to other */
128     function transfer(address _to, uint256 _value) 
129         public 
130         returns (bool success) 
131     {
132         require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance
133         require (balances[_to] + _value >= balances[_to]);  // Throw if owerflow detected
134         balances[msg.sender] -= _value;                     // Deduct senders balance
135         balances[_to] += _value;                            // Add recivers blaance
136         emit Transfer(msg.sender, _to, _value);             // Raise Transfer event
137         return true;
138     }
139 
140     /* Approve other address to spend tokens on your account */
141     function approve(address _spender, uint256 _value) public returns (bool success) {
142         require(balances[msg.sender] >= _value);
143         allowances[msg.sender][_spender] = _value;          // Set allowance
144         emit Approval(msg.sender, _spender, _value);        // Raise Approval event
145         return true;
146     }
147 
148     /* Approve and then communicate the approved contract in a single tx */
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
150         tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract
151         approve(_spender, _value);                                      // Set approval to contract for _value
152         spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
153         return true;
154     }
155 
156     /* A contract attempts to get the coins */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
158         require (balances[_from] >= _value);                // Throw if sender does not have enough balance
159         require (balances[_to] + _value >= balances[_to]);  // Throw if overflow detected
160         require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance
161         balances[_from] -= _value;                          // Deduct senders balance
162         balances[_to] += _value;                            // Add recipient blaance
163         allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address
164         emit Transfer(_from, _to, _value);                  // Raise Transfer event
165         return true;
166     }
167 
168     /* Get the amount of allowed tokens to spend */
169     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
170         return allowances[_owner][_spender];
171     }
172 
173 }
174 
175 contract FactoringChain is standardToken, Owned {
176     using SafeMath for uint;
177     
178     string public name="Factoring Chain";
179     string public symbol="ECDS";
180     uint256 public decimals=18;
181     uint256 public totalSupply = 0;
182     uint256 public topTotalSupply = 365*10**8*10**decimals;
183     /// @dev Fallback to calling deposit when ether is sent directly to contract.
184     function() public payable {
185         revert();
186     }
187     
188     /// @dev initial function
189     function FactoringChain(address _tokenAlloc) public {
190         owner=msg.sender;
191         balances[_tokenAlloc] = topTotalSupply;
192         totalSupply = topTotalSupply;
193         emit Transfer(0x0, _tokenAlloc, topTotalSupply); 
194     }
195 }