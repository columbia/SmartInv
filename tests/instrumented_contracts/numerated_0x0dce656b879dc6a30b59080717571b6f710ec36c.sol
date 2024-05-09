1 pragma solidity ^0.4.20;
2 
3 
4 contract Token {
5 
6     /// @return total amount of tokens
7 
8     function totalSupply() constant returns (uint256 supply) {}
9 
10     /// @param _owner The address from which the balance will be retrieved
11 
12     /// @return The balance
13 
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17 
18     /// @param _to The address of the recipient
19 
20     /// @param _value The amount of token to be transferred
21 
22     /// @return Whether the transfer was successful or not
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {}
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27 
28     /// @param _from The address of the sender
29 
30     /// @param _to The address of the recipient
31 
32     /// @param _value The amount of token to be transferred
33 
34     /// @return Whether the transfer was successful or not
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
37 
38     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
39 
40     /// @param _spender The address of the account able to transfer the tokens
41 
42     /// @param _value The amount of wei to be approved for transfer
43 
44     /// @return Whether the approval was successful or not
45 
46     function approve(address _spender, uint256 _value) returns (bool success) {}
47 
48     /// @param _owner The address of the account owning tokens
49 
50     /// @param _spender The address of the account able to transfer the tokens
51 
52     /// @return Amount of remaining tokens allowed to spent
53 
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
55 
56     event Transfer(address indexed _from, address indexed _to, uint256 _value);
57 
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 
60 }
61 
62 contract StandardToken is Token {
63 
64     function transfer(address _to, uint256 _value) returns (bool success) {
65 
66         //Default assumes totalSupply can't be over max (2^256 - 1).
67 
68         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
69 
70         //Replace the if with this one instead.
71 
72         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
73 
74         if (balances[msg.sender] >= _value && _value > 0) {
75 
76             balances[msg.sender] -= _value;
77 
78             balances[_to] += _value;
79 
80             Transfer(msg.sender, _to, _value);
81 
82             return true;
83 
84         } else { return false; }
85 
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89 
90         //same as above. Replace this line with the following if you want to protect against wrapping uints.
91 
92         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
93 
94         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
95 
96             balances[_to] += _value;
97 
98             balances[_from] -= _value;
99 
100             allowed[_from][msg.sender] -= _value;
101 
102             Transfer(_from, _to, _value);
103 
104             return true;
105 
106         } else { return false; }
107 
108     }
109 
110     function balanceOf(address _owner) constant returns (uint256 balance) {
111 
112         return balances[_owner];
113 
114     }
115 
116     function approve(address _spender, uint256 _value) returns (bool success) {
117 
118         allowed[msg.sender][_spender] = _value;
119 
120         Approval(msg.sender, _spender, _value);
121 
122         return true;
123 
124     }
125 
126     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127 
128       return allowed[_owner][_spender];
129 
130     }
131 
132     mapping (address => uint256) balances;
133 
134     mapping (address => mapping (address => uint256)) allowed;
135 
136     uint256 public totalSupply;
137 
138 }
139 
140 //name this contract whatever you'd like
141 
142 contract ERC20Token is StandardToken {
143 
144     function () {
145 
146         //if ether is sent to this address, send it back.
147 
148         throw;
149 
150     }
151 
152     /* Public variables of the token */
153 
154     /*
155 
156     NOTE:
157 
158     The following variables are OPTIONAL vanities. One does not have to include them.
159 
160     They allow one to customise the token contract & in no way influences the core functionality.
161 
162     Some wallets/interfaces might not even bother to look at this information.
163 
164     */
165 
166     string public name;                   //fancy name: eg Simon Bucks
167 
168     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
169 
170     string public symbol;                 //An identifier: eg SBX
171 
172     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
173 
174 //
175 
176 // CHANGE THESE VALUES FOR YOUR TOKEN
177 
178 //
179 
180 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
181 
182     function ERC20Token(
183 
184         ) {
185 
186         balances[msg.sender] = 10000000;               // Give the creator all initial tokens (100000 for example)
187 
188         totalSupply = 10000000;                        // Update total supply (100000 for example)
189 
190         name = "Surfing USA Prize Token";                                   // Set the name for display purposes
191 
192         decimals = 1;                            // Amount of decimals for display purposes
193 
194         symbol = "PRIZE";                               // Set the symbol for display purposes
195 
196     }
197 
198     /* Approves and then calls the receiving contract */
199 
200     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
201 
202         allowed[msg.sender][_spender] = _value;
203 
204         Approval(msg.sender, _spender, _value);
205 
206         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
207 
208         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
209 
210         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
211 
212         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
213 
214         return true;
215 
216     }
217 
218 }