1 /**
2  * Math operations with safety checks
3  */
4 library SafeMath {
5   function mul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint a, uint b) internal returns (uint) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 contract Token {
52     /* This is a slight change to the ERC20 base standard.
53     function totalSupply() constant returns (uint256 supply);
54     is replaced with:
55     uint256 public totalSupply;
56     This automatically creates a getter function for the totalSupply.
57     This is moved to the base contract since public getter functions are not
58     currently recognised as an implementation of the matching abstract
59     function by the compiler.
60     */
61     /// total amount of tokens
62     uint256 public totalSupply;
63 
64     /// @param _owner The address from which the balance will be retrieved
65     /// @return The balance
66     function balanceOf(address _owner) constant returns (uint256 balance);
67 
68     /// @notice send `_value` token to `_to` from `msg.sender`
69     /// @param _to The address of the recipient
70     /// @param _value The amount of token to be transferred
71     /// @return Whether the transfer was successful or not
72     function transfer(address _to, uint256 _value) returns (bool success);
73 
74     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
75     /// @param _from The address of the sender
76     /// @param _to The address of the recipient
77     /// @param _value The amount of token to be transferred
78     /// @return Whether the transfer was successful or not
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
80 
81     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
82     /// @param _spender The address of the account able to transfer the tokens
83     /// @param _value The amount of tokens to be approved for transfer
84     /// @return Whether the approval was successful or not
85     function approve(address _spender, uint256 _value) returns (bool success);
86 
87     /// @param _owner The address of the account owning tokens
88     /// @param _spender The address of the account able to transfer the tokens
89     /// @return Amount of remaining tokens allowed to spent
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
91 
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 }
95 
96 /*
97 You should inherit from StandardToken or, for a token like you would want to
98 deploy in something like Mist, see HumanStandardToken.sol.
99 (This implements ONLY the standard functions and NOTHING else.
100 If you deploy this, you won't have anything useful.)
101 
102 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
103 .*/
104 
105 contract StandardToken is Token {
106     using SafeMath for uint256;
107 
108     function transfer(address _to, uint256 _value) returns (bool success) {
109         //Default assumes totalSupply can't be over max (2^256 - 1).
110         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
111         //Replace the if with this one instead.
112         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
113         if (balances[msg.sender] >= _value && _value > 0) {
114             balances[msg.sender] = balances[msg.sender].sub(_value);
115             balances[_to] = balances[_to].add(_value);
116             Transfer(msg.sender, _to, _value);
117             return true;
118         } else { return false; }
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
122         //same as above. Replace this line with the following if you want to protect against wrapping uints.
123         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
124         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
125             balances[_to] = balances[_to].add(_value);
126             balances[_from] = balances[_from].sub(_value);
127             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128             Transfer(_from, _to, _value);
129             return true;
130         } else { return false; }
131     }
132 
133     function balanceOf(address _owner) constant returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     function approve(address _spender, uint256 _value) returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144       return allowed[_owner][_spender];
145     }
146 
147     mapping (address => uint256) balances;
148     mapping (address => mapping (address => uint256)) allowed;
149 }
150 
151 contract LTHToken is StandardToken {
152 
153     function () {
154         //if ether is sent to this address, send it back.
155         throw;
156     }
157 
158     /* Public variables of the token */
159 
160     /*
161     NOTE:
162     The following variables are OPTIONAL vanities. One does not have to include them.
163     They allow one to customise the token contract & in no way influences the core functionality.
164     Some wallets/interfaces might not even bother to look at this information.
165     */
166     string public name='LutherChain';                   
167     uint8 public decimals=8;                
168     string public symbol='LTH';                
169     string public version = 'H0.1';
170 
171     function LTHToken() {
172         balances[msg.sender] = 100000000000000000;               // Give the creator all initial tokens
173         totalSupply = 100000000000000000;                        // Update total supply
174     }
175 
176     /* Approves and then calls the receiving contract */
177     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
178         allowed[msg.sender][_spender] = _value;
179         Approval(msg.sender, _spender, _value);
180 
181         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
182         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
183         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
184         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
185         return true;
186     }
187 }