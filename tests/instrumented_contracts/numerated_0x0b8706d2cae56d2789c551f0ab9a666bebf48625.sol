1 pragma solidity ^0.4.20;
2 
3 contract Token {
4 
5 
6     /// @return total amount of tokens
7 
8     function totalSupply() constant returns (uint256 supply) {}
9 
10 
11     /// @param _owner The address from which the balance will be retrieved
12 
13     /// @return The balance
14 
15     function balanceOf(address _owner) constant returns (uint256 balance) {}
16 
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19 
20     /// @param _to The address of the recipient
21 
22     /// @param _value The amount of token to be transferred
23 
24     /// @return Whether the transfer was successful or not
25 
26     function transfer(address _to, uint256 _value) returns (bool success) {}
27 
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30 
31     /// @param _from The address of the sender
32 
33     /// @param _to The address of the recipient
34 
35     /// @param _value The amount of token to be transferred
36 
37     /// @return Whether the transfer was successful or not
38 
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
40 
41 
42     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
43 
44     /// @param _spender The address of the account able to transfer the tokens
45 
46     /// @param _value The amount of wei to be approved for transfer
47 
48     /// @return Whether the approval was successful or not
49 
50     function approve(address _spender, uint256 _value) returns (bool success) {}
51 
52 
53     /// @param _owner The address of the account owning tokens
54 
55     /// @param _spender The address of the account able to transfer the tokens
56 
57     /// @return Amount of remaining tokens allowed to spent
58 
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
60 
61 
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63 
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 
66 
67 }
68 
69 
70 contract StandardToken is Token {
71 
72 
73     function transfer(address _to, uint256 _value) returns (bool success) {
74 
75         //Default assumes totalSupply can't be over max (2^256 - 1).
76 
77         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
78 
79         //Replace the if with this one instead.
80 
81         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
82 
83         if (balances[msg.sender] >= _value && _value > 0) {
84 
85             balances[msg.sender] -= _value;
86 
87             balances[_to] += _value;
88 
89             Transfer(msg.sender, _to, _value);
90 
91             return true;
92 
93         } else { return false; }
94 
95     }
96 
97 
98     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99 
100         //same as above. Replace this line with the following if you want to protect against wrapping uints.
101 
102         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
103 
104         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
105 
106             balances[_to] += _value;
107 
108             balances[_from] -= _value;
109 
110             allowed[_from][msg.sender] -= _value;
111 
112             Transfer(_from, _to, _value);
113 
114             return true;
115 
116         } else { return false; }
117 
118     }
119 
120 
121     function balanceOf(address _owner) constant returns (uint256 balance) {
122 
123         return balances[_owner];
124 
125     }
126 
127 
128     function approve(address _spender, uint256 _value) returns (bool success) {
129 
130         allowed[msg.sender][_spender] = _value;
131 
132         Approval(msg.sender, _spender, _value);
133 
134         return true;
135 
136     }
137 
138 
139     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
140 
141       return allowed[_owner][_spender];
142 
143     }
144 
145 
146     mapping (address => uint256) balances;
147 
148     mapping (address => mapping (address => uint256)) allowed;
149 
150     uint256 public totalSupply;
151 
152 }
153 
154 
155 //name this contract whatever you'd like
156 
157 contract ERC20Token is StandardToken {
158 
159 
160     function () {
161 
162         //if ether is sent to this address, send it back.
163 
164         throw;
165 
166     }
167 
168 
169     /* Public variables of the token */
170 
171 
172     /*
173 
174     NOTE:
175 
176     The following variables are OPTIONAL vanities. One does not have to include them.
177 
178     They allow one to customise the token contract & in no way influences the core functionality.
179 
180     Some wallets/interfaces might not even bother to look at this information.
181 
182     */
183 
184     string public name;                   //fancy name: eg Simon Bucks
185 
186     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
187 
188     string public symbol;                 //An identifier: eg SBX
189 
190     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
191 
192 
193 //
194 
195 // CHANGE THESE VALUES FOR YOUR TOKEN
196 
197 //
198 
199 
200 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
201 
202 
203     function ERC20Token(
204 
205         ) {
206 
207         balances[msg.sender] = 3000000000000000;               // Give the creator all initial tokens (100000 for example)
208 
209         totalSupply = 3000000000000000;                        // Update total supply (100000 for example)
210 
211         name = "CRYPTONITE";                                   // Set the name for display purposes
212 
213         decimals = 8;                            // Amount of decimals for display purposes
214 
215         symbol = "CRYP";                               // Set the symbol for display purposes
216 
217     }
218 
219 
220     /* Approves and then calls the receiving contract */
221 
222     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
223 
224         allowed[msg.sender][_spender] = _value;
225 
226         Approval(msg.sender, _spender, _value);
227 
228 
229         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
230 
231         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
232 
233         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
234 
235         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
236 
237         return true;
238 
239     }
240 
241 }