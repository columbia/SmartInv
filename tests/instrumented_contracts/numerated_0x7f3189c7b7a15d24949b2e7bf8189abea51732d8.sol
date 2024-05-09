1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.8;
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 /*
50 You should inherit from StandardToken or, for a token like you would want to
51 deploy in something like Mist, see HumanStandardToken.sol.
52 (This implements ONLY the standard functions and NOTHING else.
53 If you deploy this, you won't have anything useful.)
54 
55 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
56 .*/
57 
58 contract StandardToken is Token {
59 
60     function transfer(address _to, uint256 _value) returns (bool success) {
61         //Default assumes totalSupply can't be over max (2^256 - 1).
62         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
63         //Replace the if with this one instead.
64         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
65         if (balances[msg.sender] >= _value && _value > 0) {
66             balances[msg.sender] -= _value;
67             balances[_to] += _value;
68             Transfer(msg.sender, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
74         //same as above. Replace this line with the following if you want to protect against wrapping uints.
75         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
76         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
77             balances[_to] += _value;
78             balances[_from] -= _value;
79             allowed[_from][msg.sender] -= _value;
80             Transfer(_from, _to, _value);
81             return true;
82         } else { return false; }
83     }
84 
85     function balanceOf(address _owner) constant returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89     function approve(address _spender, uint256 _value) returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
96       return allowed[_owner][_spender];
97     }
98 
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101 }
102 /*
103 
104   Contract to implement ERC20 tokens for the crowdfunding of the Rouge Project (RGX tokens).
105   They are based on StandardToken from (https://github.com/ConsenSys/Tokens).
106 
107   Differences with standard ERC20 tokens :
108 
109    - The tokens can be bought by sending ether to the contract address (funding procedure).
110      The price is hardcoded: 1 token = 1 finney (0.001 eth).
111      A minimum contribution can be set by the owner.
112 
113    - The funding can only occur if the current date is superior to the startFunding parameter timestamp.
114      At anytime, the creator can change this token parameter, effectively closing the funding.
115 
116    - The owner can also freeze part of his tokens to not be part of the funding procedure.
117 
118    - At the creation, a discountMultiplier is saved which can be used later on 
119      by other contracts (eg to use the tokens as a voucher).
120 
121 */
122 
123 
124 contract RGXToken is StandardToken {
125     
126     /* ERC20 */
127     string public name;
128     string public symbol;
129     uint8 public decimals = 0;
130     string public version = 'v1';
131     
132     /* RGX */
133     address owner; 
134     uint public fundingStart;
135     uint256 public minContrib = 1;
136     uint256 public frozenSupply = 0;
137     uint8 public discountMultiplier;
138     
139     modifier fundingOpen() {
140         require(now >= fundingStart);
141         _;
142     }
143     
144     modifier onlyBy(address _account) {
145         require(msg.sender == _account);
146         _;
147     }
148     
149     function () payable fundingOpen() { 
150 
151         require(msg.sender != owner);
152         
153         uint256 _value = msg.value / 1 finney;
154 
155         require(_value >= minContrib); 
156         
157         require(balances[owner] >= (_value - frozenSupply) && _value > 0); 
158         
159         balances[owner] -= _value;
160         balances[msg.sender] += _value;
161         Transfer(owner, msg.sender, _value);
162         
163     }
164     
165     function RGXToken (
166                        string _name,
167                        string _symbol,
168                        uint256 _initialAmount,
169                        uint _fundingStart,
170                        uint8 _discountMultiplier
171                        ) {
172         name = _name;
173         symbol = _symbol;
174         owner = msg.sender;
175         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
176         totalSupply = _initialAmount;                        // Update total supply
177         fundingStart = _fundingStart;                        // timestamp before no funding can occur
178         discountMultiplier = _discountMultiplier;
179     }
180     
181     function isFundingOpen() constant returns (bool yes) {
182         return (now >= fundingStart);
183     }
184     
185     function freezeSupply(uint256 _value) onlyBy(owner) {
186         require(balances[owner] >= _value);
187         frozenSupply = _value;
188     }
189     
190     function setMinimum(uint256 _value) onlyBy(owner) {
191         minContrib = _value;
192     }
193     
194     function timeFundingStart(uint _fundingStart) onlyBy(owner) {
195         fundingStart = _fundingStart;
196     }
197 
198     function withdraw() onlyBy(owner) {
199         msg.sender.transfer(this.balance);
200     }
201     
202     function kill() onlyBy(owner) {
203         selfdestruct(owner);
204     }
205 
206 }