1 contract Token {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) constant returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) returns (bool success);
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30 
31     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success);
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 /*
46 You should inherit from StandardToken or, for a token like you would want to
47 deploy in something like Mist, see HumanStandardToken.sol.
48 (This implements ONLY the standard functions and NOTHING else.
49 If you deploy this, you won't have anything useful.)
50 
51 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
52 .*/
53 
54 
55 contract StandardToken is Token {
56 
57     function transfer(address _to, uint256 _value) returns (bool success) {
58         //Default assumes totalSupply can't be over max (2^256 - 1).
59         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
60         //Replace the if with this one instead.
61         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
62         if (balances[msg.sender] >= _value && _value > 0) {
63             balances[msg.sender] -= _value;
64             balances[_to] += _value;
65             Transfer(msg.sender, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         //same as above. Replace this line with the following if you want to protect against wrapping uints.
72         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
73         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
74             balances[_to] += _value;
75             balances[_from] -= _value;
76             allowed[_from][msg.sender] -= _value;
77             Transfer(_from, _to, _value);
78             return true;
79         } else { return false; }
80     }
81 
82     function balanceOf(address _owner) constant returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86     function approve(address _spender, uint256 _value) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93       return allowed[_owner][_spender];
94     }
95 
96     mapping (address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98 }
99 /*
100 
101   Contract to implement ERC20 tokens for the crowdfunding of the Rouge Project (RGX tokens).
102   They are based on StandardToken from (https://github.com/ConsenSys/Tokens).
103 
104   Differences with standard ERC20 tokens :
105 
106    - The tokens can be bought by sending ether to the contract address (funding procedure).
107      The price is hardcoded: 1 token = 1 finney (0.001 eth).
108 
109    - The funding can only occur if the current date is superior to the startFunding parameter timestamp.
110      At anytime, the creator can change this token parameter, effectively closing the funding.
111 
112    - The owner can also freeze part of his tokens to not be part of the funding procedure.
113 
114    - At the creation, a discountMultiplier is saved which can be used later on 
115      by other contracts (eg to use the tokens as a voucher).
116 
117 */
118 
119 
120 contract RGXToken is StandardToken {
121     
122     /* ERC20 */
123     string public name;
124     string public symbol;
125     uint8 public decimals = 0;
126     string public version = 'v0.9';
127     
128     /* RGX */
129     address owner; 
130     uint public fundingStart;
131     uint256 public frozenSupply = 0;
132     uint8 public discountMultiplier;
133     
134     modifier fundingOpen() {
135         require(now >= fundingStart);
136         _;
137     }
138     
139     modifier onlyBy(address _account) {
140         require(msg.sender == _account);
141         _;
142     }
143     
144     function () payable fundingOpen() { 
145 
146         require(msg.sender != owner);
147         
148         uint256 _value = msg.value / 1 finney;
149         
150         require(balances[owner] >= (_value - frozenSupply) && _value > 0); 
151         
152         balances[owner] -= _value;
153         balances[msg.sender] += _value;
154         Transfer(owner, msg.sender, _value);
155         
156     }
157     
158     function RGXToken (
159                        string _name,
160                        string _symbol,
161                        uint256 _initialAmount,
162                        uint _fundingStart,
163                        uint8 _discountMultiplier
164                        ) {
165         name = _name;
166         symbol = _symbol;
167         owner = msg.sender;
168         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
169         totalSupply = _initialAmount;                        // Update total supply
170         fundingStart = _fundingStart;                        // timestamp before no funding can occur
171         discountMultiplier = _discountMultiplier;
172     }
173     
174     function isFundingOpen() constant returns (bool yes) {
175         return (now >= fundingStart);
176     }
177     
178     function freezeSupply(uint256 _value) onlyBy(owner) {
179         require(balances[owner] >= _value);
180         frozenSupply = _value;
181     }
182     
183     function timeFundingStart(uint _fundingStart) onlyBy(owner) {
184         fundingStart = _fundingStart;
185     }
186 
187     function withdraw() onlyBy(owner) {
188         msg.sender.transfer(this.balance);
189     }
190     
191     function kill() onlyBy(owner) {
192         selfdestruct(owner);
193     }
194 
195 }