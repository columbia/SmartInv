1 pragma solidity ^0.4.4;
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
75 
76         if (balances[msg.sender] >= _value && _value > 0) {
77 
78             balances[msg.sender] -= _value;
79 
80             balances[_to] += _value;
81 
82             Transfer(msg.sender, _to, _value);
83 
84             return true;
85 
86         } else { return false; }
87 
88     }
89 
90 
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
92 
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
110 
111     function balanceOf(address _owner) constant returns (uint256 balance) {
112 
113         return balances[_owner];
114 
115     }
116 
117 
118     function approve(address _spender, uint256 _value) returns (bool success) {
119 
120         allowed[msg.sender][_spender] = _value;
121 
122         Approval(msg.sender, _spender, _value);
123 
124         return true;
125 
126     }
127 
128 
129     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
130 
131       return allowed[_owner][_spender];
132 
133     }
134 
135 
136     mapping (address => uint256) balances;
137 
138     mapping (address => mapping (address => uint256)) allowed;
139 
140     uint256 public totalSupply;
141 
142 }
143 
144 
145 
146 
147 contract ERC20Token is StandardToken {
148 
149 
150     function () {
151 
152 
153         throw;
154 
155     }
156 
157     string public name;                   
158 
159     uint8 public decimals;                
160 
161     string public symbol;                 
162 
163     string public version = 'H1.0';       
164 
165 
166     function ERC20Token(
167 
168         ) {
169 
170         balances[msg.sender] = 210000000000000000000000000;              
171 
172         totalSupply = 210000000000000000000000000;                        
173 
174         name = "DougCash";                                  
175 
176         decimals = 18;                          
177 
178         symbol = "DOUG";                            
179 
180     }
181 
182 
183  
184     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
185 
186         allowed[msg.sender][_spender] = _value;
187 
188         Approval(msg.sender, _spender, _value);
189 
190 
191         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
192 
193         return true;
194 
195     }
196 
197 }