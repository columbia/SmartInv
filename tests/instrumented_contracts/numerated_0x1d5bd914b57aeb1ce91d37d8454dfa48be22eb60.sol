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
45 
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         //Default assumes totalSupply can't be over max (2^256 - 1).
50         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
51         //Replace the if with this one instead.
52         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53         if (balances[msg.sender] >= _value && _value > 0) {
54             balances[msg.sender] -= _value;
55             balances[_to] += _value;
56             Transfer(msg.sender, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         //same as above. Replace this line with the following if you want to protect against wrapping uints.
63         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
65             balances[_to] += _value;
66             balances[_from] -= _value;
67             allowed[_from][msg.sender] -= _value;
68             Transfer(_from, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89 }
90 
91 /*
92 
93   Contract to implement ERC20 tokens for the crowdfunding of the Rouge Project (RGX tokens).
94   They are based on StandardToken from (https://github.com/ConsenSys/Tokens).
95 
96   Differences with standard ERC20 tokens :
97 
98    - The tokens can be bought by sending ether to the contract address (funding procedure).
99      The price is hardcoded: 1 token = 1 finney (0.001 eth).
100 
101    - The funding can only occur if the current date is superior to the startFunding parameter timestamp.
102      At anytime, the creator can change this token parameter, effectively closing the funding.
103 
104    - The owner can also freeze part of his tokens to not be part of the funding procedure.
105 
106    - At the creation, a discountMultiplier is saved which can be used later on 
107      by other contracts (eg to use the tokens as a voucher).
108 
109 */
110 
111 contract RGXToken is StandardToken {
112     
113     /* ERC20 */
114     string public name;
115     string public symbol;
116     uint8 public decimals = 0;
117     string public version = 'v0.9';
118     
119     /* RGX */
120     address owner; 
121     uint public fundingStart;
122     uint256 public frozenSupply = 0;
123     uint8 public discountMultiplier;
124     
125     modifier fundingOpen() {
126         require(now >= fundingStart);
127         _;
128     }
129     
130     modifier onlyBy(address _account) {
131         require(msg.sender == _account);
132         _;
133     }
134     
135     function () payable fundingOpen() { 
136 
137         require(msg.sender != owner);
138         
139         uint256 _value = msg.value / 1 finney;
140         
141         require(balances[owner] >= (_value - frozenSupply) && _value > 0); 
142         
143         balances[owner] -= _value;
144         balances[msg.sender] += _value;
145         Transfer(owner, msg.sender, _value);
146         
147     }
148     
149     function RGXToken (
150                        string _name,
151                        string _symbol,
152                        uint256 _initialAmount,
153                        uint _fundingStart,
154                        uint8 _discountMultiplier
155                        ) {
156         name = _name;
157         symbol = _symbol;
158         owner = msg.sender;
159         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
160         totalSupply = _initialAmount;                        // Update total supply
161         fundingStart = _fundingStart;                        // timestamp before no funding can occur
162         discountMultiplier = _discountMultiplier;
163     }
164     
165     function isFundingOpen() constant returns (bool yes) {
166         return (now >= fundingStart);
167     }
168     
169     function freezeSupply(uint256 _value) onlyBy(owner) {
170         require(balances[owner] >= _value);
171         frozenSupply = _value;
172     }
173     
174     function timeFundingStart(uint _fundingStart) onlyBy(owner) {
175         fundingStart = _fundingStart;
176     }
177 
178     function withdraw() onlyBy(owner) {
179         msg.sender.transfer(this.balance);
180     }
181     
182     function kill() onlyBy(owner) {
183         selfdestruct(owner);
184     }
185 
186 }
187 /*
188 You should inherit from StandardToken or, for a token like you would want to
189 deploy in something like Mist, see HumanStandardToken.sol.
190 (This implements ONLY the standard functions and NOTHING else.
191 If you deploy this, you won't have anything useful.)
192 
193 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
194 .*/