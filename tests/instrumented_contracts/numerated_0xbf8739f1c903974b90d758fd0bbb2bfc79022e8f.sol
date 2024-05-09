1 contract SBOXToken {
2 
3 
4    /// @return total amount of tokens
5 
6    function totalSupply() constant returns (uint256 supply) {}
7 
8 
9    /// @param _owner The address from which the balance will be retrieved
10 
11    /// @return The balance
12 
13    function balanceOf(address _owner) constant returns (uint256 balance) {}
14 
15 
16    /// @notice send `_value` token to `_to` from `msg.sender`
17 
18    /// @param _to The address of the recipient
19 
20    /// @param _value The amount of token to be transferred
21 
22    /// @return Whether the transfer was successful or not
23 
24    function transfer(address _to, uint256 _value) returns (bool success) {}
25 
26 
27    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28 
29    /// @param _from The address of the sender
30 
31    /// @param _to The address of the recipient
32 
33    /// @param _value The amount of token to be transferred
34 
35    /// @return Whether the transfer was successful or not
36 
37    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
38 
39 
40    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
41 
42    /// @param _spender The address of the account able to transfer the tokens
43 
44    /// @param _value The amount of wei to be approved for transfer
45 
46    /// @return Whether the approval was successful or not
47 
48    function approve(address _spender, uint256 _value) returns (bool success) {}
49 
50 
51    /// @param _owner The address of the account owning tokens
52 
53    /// @param _spender The address of the account able to transfer the tokens
54 
55    /// @return Amount of remaining tokens allowed to spent
56 
57    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
58 
59 
60    event Transfer(address indexed _from, address indexed _to, uint256 _value);
61 
62    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 
64 
65 }
66 
67 
68 contract StandardToken is SBOXToken {
69 
70 
71    function transfer(address _to, uint256 _value) returns (bool success) {
72 
73        //Use below omit if total supply doesn’t wrap
74 
75        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
76 
77        if (balances[msg.sender] >= _value && _value > 0) {
78 
79            balances[msg.sender] -= _value;
80 
81            balances[_to] += _value;
82 
83            Transfer(msg.sender, _to, _value);
84 
85            return true;
86 
87        } else { return false; }
88 
89    }
90 
91 
92    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93 
94        //Replace above line with the following omit to protect against wrapping uints
95 
96        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
97 
98        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
99 
100            balances[_to] += _value;
101 
102            balances[_from] -= _value;
103 
104            allowed[_from][msg.sender] -= _value;
105 
106            Transfer(_from, _to, _value);
107 
108            return true;
109 
110        } else { return false; }
111 
112    }
113 
114 
115    function balanceOf(address _owner) constant returns (uint256 balance) {
116 
117        return balances[_owner];
118 
119    }
120 
121 
122    function approve(address _spender, uint256 _value) returns (bool success) {
123 
124        allowed[msg.sender][_spender] = _value;
125 
126        Approval(msg.sender, _spender, _value);
127 
128        return true;
129 
130    }
131 
132 
133    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
134 
135      return allowed[_owner][_spender];
136 
137    }
138 
139 
140    mapping (address => uint256) balances;
141 
142    mapping (address => mapping (address => uint256)) allowed;
143 
144    uint256 public totalSupply;
145 
146 }
147 
148 
149 //name this contract whatever you'd like
150 
151 contract SandBoxERC20 is StandardToken {
152 
153 
154    function () {
155 
156        //if ether is sent to this address, send it back.
157 
158        throw;
159 
160    }
161 
162 
163    /* Public variables of the token */
164 
165 
166    /*
167 
168    NOTE: The following variables are OPTIONAL 
169 
170    They allow customised token contract & in no way influences the core functionality.
171 
172    Some wallets/interfaces might not even bother to look at this information.
173 
174    */
175 
176    string public name;                   //fancy name: eg SandBox
177 
178    uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
179 
180    string public symbol;                 //An identifier: eg SBX
181 
182    string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
183 
184 // Main TOKEN VALUES and VARIBLES BELOW
185 
186 //make sure this function name matches the contract name above SandBoxERC20
187 
188    function SandBoxERC20(
189 
190        ) {
191 
192        balances[msg.sender] = 500000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
193 
194        totalSupply = 500000000000000000000000000;                        // Update total supply (100000 for example)
195 
196        name = "SandBox";                                   // Set the name for display purposes
197 
198        decimals = 18;                            // Amount of decimals for display purposes
199 
200        symbol = "SBOX";                               // Set the symbol for display purposes
201 
202    }
203 
204 
205    /* Approves and then calls the receiving contract */
206 
207    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
208 
209        allowed[msg.sender][_spender] = _value;
210 
211        Approval(msg.sender, _spender, _value);
212 
213 
214        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
215 
216        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
217 
218        //it is assumed that when does this that the call *should* succeed, otherwise need to use approve instead.
219 
220        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
221 
222        return true;
223 
224    }
225 
226 }