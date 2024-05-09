1 /**
2  * Overflow aware uint math functions.
3  *
4  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
5  */
6 contract SafeMath {
7   //internals
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeSub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function safeAdd(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c>=a && c>=b);
22     return c;
23   }
24 
25   function assert(bool assertion) internal {
26     if (!assertion) throw;
27   }
28 }
29 
30 /**
31  * ERC 20 token
32  *
33  * https://github.com/ethereum/EIPs/issues/20
34  */
35 contract Token {
36 
37     /// @return total amount of tokens
38     function totalSupply() constant returns (uint256 supply) {}
39 
40     /// @param _owner The address from which the balance will be retrieved
41     /// @return The balance
42     function balanceOf(address _owner) constant returns (uint256 balance) {}
43 
44     /// @notice send `_value` token to `_to` from `msg.sender`
45     /// @param _to The address of the recipient
46     /// @param _value The amount of token to be transferred
47     /// @return Whether the transfer was successful or not
48     function transfer(address _to, uint256 _value) returns (bool success) {}
49 
50     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
51     /// @param _from The address of the sender
52     /// @param _to The address of the recipient
53     /// @param _value The amount of token to be transferred
54     /// @return Whether the transfer was successful or not
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
56 
57     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
58     /// @param _spender The address of the account able to transfer the tokens
59     /// @param _value The amount of wei to be approved for transfer
60     /// @return Whether the approval was successful or not
61     function approve(address _spender, uint256 _value) returns (bool success) {}
62 
63     /// @param _owner The address of the account owning tokens
64     /// @param _spender The address of the account able to transfer the tokens
65     /// @return Amount of remaining tokens allowed to spent
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71 }
72 
73 /**
74  * ERC 20 token
75  *
76  * https://github.com/ethereum/EIPs/issues/20
77  */
78 contract StandardToken is Token {
79 
80     /**
81      * Reviewed:
82      * - Interger overflow = OK, checked
83      */
84     function transfer(address _to, uint256 _value) returns (bool success) {
85         //Default assumes totalSupply can't be over max (2^256 - 1).
86         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
87         //Replace the if with this one instead.
88         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
89         //if (balances[msg.sender] >= _value && _value > 0) {
90             balances[msg.sender] -= _value;
91             balances[_to] += _value;
92             Transfer(msg.sender, _to, _value);
93             return true;
94         } else { return false; }
95     }
96 
97     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
98         //same as above. Replace this line with the following if you want to protect against wrapping uints.
99         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
100         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
101             balances[_to] += _value;
102             balances[_from] -= _value;
103             allowed[_from][msg.sender] -= _value;
104             Transfer(_from, _to, _value);
105             return true;
106         } else { return false; }
107     }
108 
109     function balanceOf(address _owner) constant returns (uint256 balance) {
110         return balances[_owner];
111     }
112 
113     function approve(address _spender, uint256 _value) returns (bool success) {
114         allowed[msg.sender][_spender] = _value;
115         Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120       return allowed[_owner][_spender];
121     }
122 
123     mapping(address => uint256) balances;
124 
125     mapping (address => mapping (address => uint256)) allowed;
126 
127     uint256 public totalSupply;
128 }
129 
130 contract NapoleonXToken is StandardToken, SafeMath {
131     // Constant token specific fields
132     string public constant name = "NapoleonX Token";
133     string public constant symbol = "NPX";
134     // no decimals allowed
135     uint8 public decimals = 2;
136     uint public INITIAL_SUPPLY = 95000000;
137     
138     /* this napoleonXAdministrator address is where token.napoleonx.eth resolves to */
139     address napoleonXAdministrator;
140     
141     /* ICO end time in seconds 14 mars 2018 */
142     uint public endTime;
143     
144     event TokenAllocated(address investor, uint tokenAmount);
145     // MODIFIERS
146     modifier only_napoleonXAdministrator {
147         require(msg.sender == napoleonXAdministrator);
148         _;
149     }
150 
151     modifier is_not_earlier_than(uint x) {
152         require(now >= x);
153         _;
154     }
155     modifier is_earlier_than(uint x) {
156         require(now < x);
157         _;
158     }
159     function isEqualLength(address[] x, uint[] y) internal returns (bool) { return x.length == y.length; }
160     modifier onlySameLengthArray(address[] x, uint[] y) {
161         require(isEqualLength(x,y));
162         _;
163     }
164 	
165     function NapoleonXToken(uint setEndTime) {
166         napoleonXAdministrator = msg.sender;
167         endTime = setEndTime;
168     }
169 	
170     // we here repopulate the greenlist using the historic commitments from www.napoleonx.ai website
171     function populateWhitelisted(address[] whitelisted, uint[] tokenAmount) only_napoleonXAdministrator onlySameLengthArray(whitelisted, tokenAmount) is_earlier_than(endTime) {
172         for (uint i = 0; i < whitelisted.length; i++) {
173 			uint previousAmount = balances[whitelisted[i]];
174 			balances[whitelisted[i]] = tokenAmount[i];
175 			totalSupply = totalSupply-previousAmount+tokenAmount[i];
176             TokenAllocated(whitelisted[i], tokenAmount[i]);
177         }
178     }
179     
180     function changeFounder(address newAdministrator) only_napoleonXAdministrator {
181         napoleonXAdministrator = newAdministrator;
182     }
183  
184     function getICOStage() public constant returns(string) {
185          if (now < endTime){
186             return "Presale ended, standard ICO running";
187          }
188          if (now >= endTime){
189             return "ICO finished";
190          }
191     }
192 }