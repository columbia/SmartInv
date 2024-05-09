1 pragma solidity ^0.4.8;
2 
3  
4 
5 // ----------------------------------------------------------------------------------------------
6 
7 // Sample fixed supply token contract
8 
9 // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
10 
11 // ----------------------------------------------------------------------------------------------
12 
13  
14 
15 // ERC Token Standard #20 Interface
16 
17 // https://github.com/ethereum/EIPs/issues/20
18 
19 contract ERC20Interface {
20 
21     // Get the total token supply
22 
23     function totalSupply() constant returns (uint256 totalSupply);
24 
25  
26 
27     // Get the account balance of another account with address _owner
28 
29     function balanceOf(address _owner) constant returns (uint256 balance);
30 
31  
32 
33     // Send _value amount of tokens to address _to
34 
35     function transfer(address _to, uint256 _value) returns (bool success);
36 
37  
38 
39     // Send _value amount of tokens from address _from to address _to
40 
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
42 
43  
44 
45     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
46 
47     // If this function is called again it overwrites the current allowance with _value.
48 
49     // this function is required for some DEX functionality
50 
51     function approve(address _spender, uint256 _value) returns (bool success);
52 
53  
54 
55     // Returns the amount which _spender is still allowed to withdraw from _owner
56 
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
58 
59  
60 
61     // Triggered when tokens are transferred.
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64 
65  
66 
67     // Triggered whenever approve(address _spender, uint256 _value) is called.
68 
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71 }
72 
73  
74 
75 contract FixedSupplyToken is ERC20Interface {
76 
77     string public constant symbol = "SPCD";
78 
79     string public constant name = "Space Dollars";
80 
81     uint8 public constant decimals = 4;
82 
83     uint256 _totalSupply = 1000000000;
84 
85     
86 
87     // Owner of this contract
88 
89     address public owner;
90 
91  
92 
93     // Balances for each account
94 
95     mapping(address => uint256) balances;
96 
97  
98 
99     // Owner of account approves the transfer of an amount to another account
100 
101     mapping(address => mapping (address => uint256)) allowed;
102 
103  
104 
105     // Functions with this modifier can only be executed by the owner
106 
107     modifier onlyOwner() {
108 
109         if (msg.sender != owner) {
110 
111             throw;
112 
113         }
114 
115         _;
116 
117     }
118 
119  
120 
121     // Constructor
122 
123     function FixedSupplyToken() {
124 
125         owner = msg.sender;
126 
127         balances[owner] = _totalSupply;
128 
129     }
130 
131  
132 
133     function totalSupply() constant returns (uint256 totalSupply) {
134 
135         totalSupply = _totalSupply;
136 
137     }
138 
139  
140 
141     // What is the balance of a particular account?
142 
143     function balanceOf(address _owner) constant returns (uint256 balance) {
144 
145         return balances[_owner];
146 
147     }
148 
149  
150 
151     // Transfer the balance from owner's account to another account
152 
153     function transfer(address _to, uint256 _amount) returns (bool success) {
154 
155         if (balances[msg.sender] >= _amount 
156 
157             && _amount > 0
158 
159             && balances[_to] + _amount > balances[_to]) {
160 
161             balances[msg.sender] -= _amount;
162 
163             balances[_to] += _amount;
164 
165             Transfer(msg.sender, _to, _amount);
166 
167             return true;
168 
169         } else {
170 
171             return false;
172 
173         }
174 
175     }
176 
177  
178 
179     // Send _value amount of tokens from address _from to address _to
180 
181     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
182 
183     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
184 
185     // fees in sub-currencies; the command should fail unless the _from account has
186 
187     // deliberately authorized the sender of the message via some mechanism; we propose
188 
189     // these standardized APIs for approval:
190 
191     function transferFrom(
192 
193         address _from,
194 
195         address _to,
196 
197         uint256 _amount
198 
199     ) returns (bool success) {
200 
201         if (balances[_from] >= _amount
202 
203             && allowed[_from][msg.sender] >= _amount
204 
205             && _amount > 0
206 
207             && balances[_to] + _amount > balances[_to]) {
208 
209             balances[_from] -= _amount;
210 
211             allowed[_from][msg.sender] -= _amount;
212 
213             balances[_to] += _amount;
214 
215             Transfer(_from, _to, _amount);
216 
217             return true;
218 
219         } else {
220 
221             return false;
222 
223         }
224 
225     }
226 
227  
228 
229     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
230 
231     // If this function is called again it overwrites the current allowance with _value.
232 
233     function approve(address _spender, uint256 _amount) returns (bool success) {
234 
235         allowed[msg.sender][_spender] = _amount;
236 
237         Approval(msg.sender, _spender, _amount);
238 
239         return true;
240 
241     }
242 
243  
244 
245     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
246 
247         return allowed[_owner][_spender];
248 
249     }
250 
251 }