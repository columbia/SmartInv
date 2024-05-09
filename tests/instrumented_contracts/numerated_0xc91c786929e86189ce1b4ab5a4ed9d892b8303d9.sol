1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 
4 contract Token {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) constant returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 /*
49 You should inherit from StandardToken or, for a token like you would want to
50 deploy in something like Mist, see HumanStandardToken.sol.
51 (This implements ONLY the standard functions and NOTHING else.
52 If you deploy this, you won't have anything useful.)
53 
54 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
55 .*/
56 
57 contract StandardToken is Token {
58 
59     function transfer(address _to, uint256 _value) returns (bool success) {
60         //Default assumes totalSupply can't be over max (2^256 - 1).
61         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
62         //Replace the if with this one instead.
63         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[msg.sender] >= _value && _value > 0) {
65             balances[msg.sender] -= _value;
66             balances[_to] += _value;
67             Transfer(msg.sender, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
73         //same as above. Replace this line with the following if you want to protect against wrapping uints.
74         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
75         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
76             balances[_to] += _value;
77             balances[_from] -= _value;
78             allowed[_from][msg.sender] -= _value;
79             Transfer(_from, _to, _value);
80             return true;
81         } else { return false; }
82     }
83 
84     function balanceOf(address _owner) constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95       return allowed[_owner][_spender];
96     }
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100 }
101 /*
102 
103   Contract to implement ERC20 tokens for the crowdfunding of the Rouge Project (RGX tokens).
104   They are based on StandardToken from (https://github.com/ConsenSys/Tokens).
105 
106   Differences with standard ERC20 tokens :
107 
108    - The tokens can be bought by sending ether to the contract address (funding procedure).
109      The price is hardcoded: 1 token = 1 finney (0.001 eth).
110 
111    - The funding can only occur if the current date is superior to the startFunding parameter timestamp.
112      At anytime, the creator can change this token parameter, effectively closing the funding.
113 
114    - The owner can also freeze part of his tokens to not be part of the funding procedure.
115 
116    - At the creation, a discountMultiplier is saved which can be used later on 
117      by other contracts (eg to use the tokens as a voucher).
118 
119 */
120 
121 contract RGXToken is StandardToken {
122     
123     /* ERC20 */
124     string public name;
125     string public symbol;
126     uint8 public decimals = 0;
127     string public version = 'v0.9';
128     
129     /* RGX */
130     address owner; 
131     uint public fundingStart;
132     uint256 public frozenSupply = 0;
133     uint8 public discountMultiplier;
134     
135     modifier fundingOpen() {
136         require(now >= fundingStart);
137         _;
138     }
139     
140     modifier onlyBy(address _account) {
141         require(msg.sender == _account);
142         _;
143     }
144     
145     function () payable fundingOpen() { 
146 
147         require(msg.sender != owner);
148         
149         uint256 _value = msg.value / 1 finney;
150         
151         require(balances[owner] >= (_value - frozenSupply) && _value > 0); 
152         
153         balances[owner] -= _value;
154         balances[msg.sender] += _value;
155         Transfer(owner, msg.sender, _value);
156         
157     }
158     
159     function RGXToken (
160                        string _name,
161                        string _symbol,
162                        uint256 _initialAmount,
163                        uint _fundingStart,
164                        uint8 _discountMultiplier
165                        ) {
166         name = _name;
167         symbol = _symbol;
168         owner = msg.sender;
169         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
170         totalSupply = _initialAmount;                        // Update total supply
171         fundingStart = _fundingStart;                        // timestamp before no funding can occur
172         discountMultiplier = _discountMultiplier;
173     }
174     
175     function isFundingOpen() constant returns (bool yes) {
176         return (now >= fundingStart);
177     }
178     
179     function freezeSupply(uint256 _value) onlyBy(owner) {
180         require(balances[owner] >= _value);
181         frozenSupply = _value;
182     }
183     
184     function timeFundingStart(uint _fundingStart) onlyBy(owner) {
185         fundingStart = _fundingStart;
186     }
187 
188     function withdraw() onlyBy(owner) {
189         msg.sender.transfer(this.balance);
190     }
191     
192     function kill() onlyBy(owner) {
193         selfdestruct(owner);
194     }
195 
196 }