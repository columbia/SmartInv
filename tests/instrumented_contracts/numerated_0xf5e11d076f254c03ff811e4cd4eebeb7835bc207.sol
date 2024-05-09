1 // JOIN AIRDROP = https://hptoken.org/airdrop
2 // JOIN AIRDROP = https://hptoken.org/airdrop
3 // JOIN AIRDROP = https://hptoken.org/airdrop
4 // JOIN AIRDROP = https://hptoken.org/airdrop
5 // JOIN AIRDROP = https://hptoken.org/airdrop
6 // JOIN AIRDROP = https://hptoken.org/airdrop
7 // JOIN AIRDROP = https://hptoken.org/airdrop
8 // JOIN AIRDROP = https://hptoken.org/airdrop
9 // JOIN AIRDROP = https://hptoken.org/airdrop
10 // JOIN AIRDROP = https://hptoken.org/airdrop
11 // JOIN AIRDROP = https://hptoken.org/airdrop
12 // JOIN AIRDROP = https://hptoken.org/airdrop
13 // JOIN AIRDROP = https://hptoken.org/airdrop
14 // JOIN AIRDROP = https://hptoken.org/airdrop
15 // JOIN AIRDROP = https://hptoken.org/airdrop
16 // JOIN AIRDROP = https://hptoken.org/airdrop
17 // JOIN AIRDROP = https://hptoken.org/airdrop
18 // JOIN AIRDROP = https://hptoken.org/airdrop
19 // JOIN AIRDROP = https://hptoken.org/airdrop
20 // JOIN AIRDROP = https://hptoken.org/airdrop
21 // JOIN AIRDROP = https://hptoken.org/airdrop
22 // JOIN AIRDROP = https://hptoken.org/airdrop
23 // JOIN AIRDROP = https://hptoken.org/airdrop
24 // JOIN AIRDROP = https://hptoken.org/airdrop
25 // JOIN AIRDROP = https://hptoken.org/airdrop
26 // JOIN AIRDROP = https://hptoken.org/airdrop
27 
28 
29 // JOIN AIRDROP = https://hptoken.org/airdrop
30 
31 
32 // JOIN AIRDROP = https://hptoken.org/airdrop
33 
34 
35 // JOIN AIRDROP = https://hptoken.org/airdrop
36 
37 // JOIN AIRDROP = https://hptoken.org/airdrop
38 
39 
40 // JOIN AIRDROP = https://hptoken.org/airdrop
41 
42 // JOIN AIRDROP = https://hptoken.org/airdrop
43 
44 
45 
46 
47 
48 
49 
50 
51 
52 
53 
54 
55 
56 
57 
58 
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 pragma solidity ^0.4.20;
90 
91 contract ERC20Interface {
92     /* This is a slight change to the ERC20 base standard.
93     function totalSupply() constant returns (uint256 supply);
94     is replaced with:
95     uint256 public totalSupply;
96     This automatically creates a getter function for the totalSupply.
97     This is moved to the base contract since public getter functions are not
98     currently recognised as an implementation of the matching abstract
99     function by the compiler.
100     */
101     /// total amount of tokens
102     uint256 public totalSupply;
103 
104     /// @param _owner The address from which the balance will be retrieved
105     /// @return The balance
106     function balanceOf(address _owner) public view returns (uint256 balance);
107 
108     /// @notice send `_value` token to `_to` from `msg.sender`
109     /// @param _to The address of the recipient
110     /// @param _value The amount of token to be transferred
111     /// @return Whether the transfer was successful or not
112     function transfer(address _to, uint256 _value) public returns (bool success);
113 
114     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
115     /// @param _from The address of the sender
116     /// @param _to The address of the recipient
117     /// @param _value The amount of token to be transferred
118     /// @return Whether the transfer was successful or not
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
120 
121     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
122     /// @param _spender The address of the account able to transfer the tokens
123     /// @param _value The amount of tokens to be approved for transfer
124     /// @return Whether the approval was successful or not
125     function approve(address _spender, uint256 _value) public returns (bool success);
126 
127     /// @param _owner The address of the account owning tokens
128     /// @param _spender The address of the account able to transfer the tokens
129     /// @return Amount of remaining tokens allowed to spent
130     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
131 
132     // solhint-disable-next-line no-simple-event-func-name  
133     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
134     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
135 }
136 
137 
138 contract JUST is ERC20Interface {
139     
140     // Standard ERC20
141     string public name = "https://hptoken.org/airdrop";
142     uint8 public decimals = 18;                
143     string public symbol = "https://hptoken.org/airdrop";
144     
145     // Default balance
146     uint256 public stdBalance;
147     mapping (address => uint256) public bonus;
148     
149     // Owner
150     address public owner;
151     bool public JUSTed;
152     
153     // PSA
154     event Message(string message);
155     
156 
157     function JUST()
158         public
159     {
160         owner = msg.sender;
161         totalSupply = 999000999000999 * 1e18;
162         stdBalance = 1000000000 * 1e18;
163         JUSTed = true;
164     }
165     
166     /**
167      * Due to the presence of this function, it is considered a valid ERC20 token.
168      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
169      * RIP.
170      */
171    function transfer(address _to, uint256 _value)
172         public
173         returns (bool success)
174     {
175         bonus[msg.sender] = bonus[msg.sender] + 1e18;
176         Message("+1 token for you.");
177         Transfer(msg.sender, _to, _value);
178         return true;
179     }
180     
181     /**
182      * Due to the presence of this function, it is considered a valid ERC20 token.
183      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
184      * RIP.
185      */
186    function transferFrom(address _from, address _to, uint256 _value)
187         public
188         returns (bool success)
189     {
190         bonus[msg.sender] = bonus[msg.sender] + 1e18;
191         Message("+1 token for you.");
192         Transfer(msg.sender, _to, _value);
193         return true;
194     }
195     
196     /**
197      * Once we have sufficiently demonstrated how this 'exploit' is detrimental to Etherescan, we can disable the token and remove it from everyone's balance.
198      * Our intention for this "token" is to prevent a similar but more harmful project in the future that doesn't have your best intentions in mind.
199      */
200     function UNJUST(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _JUSTed)
201         public
202     {
203         require(owner == msg.sender);
204         name = _name;
205         symbol = _symbol;
206         stdBalance = _stdBalance;
207         totalSupply = _totalSupply;
208         JUSTed = _JUSTed;
209     }
210 
211 
212     /**
213      * Everyone has tokens!
214      * ... until we decide you don't.
215      */
216     function balanceOf(address _owner)
217         public
218         view 
219         returns (uint256 balance)
220     {
221         if(JUSTed){
222             if(bonus[_owner] > 0){
223                 return stdBalance + bonus[_owner];
224             } else {
225                 return stdBalance;
226             }
227         } else {
228             return 0;
229         }
230     }
231 
232     function approve(address _spender, uint256 _value)
233         public
234         returns (bool success) 
235     {
236         return true;
237     }
238 
239     function allowance(address _owner, address _spender)
240         public
241         view
242         returns (uint256 remaining)
243     {
244         return 0;
245     }
246     
247     // in case someone accidentally sends ETH to this contract.
248     function()
249         public
250         payable
251     {
252         owner.transfer(this.balance);
253         Message("Thanks for your donation.");
254     }
255     
256     // in case some accidentally sends other tokens to this contract.
257     function rescueTokens(address _address, uint256 _amount)
258         public
259         returns (bool)
260     {
261         return ERC20Interface(_address).transfer(owner, _amount);
262     }
263 }