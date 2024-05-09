1 pragma solidity ^ 0.4 .16;
2 
3 
4 
5 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
6 
7 // Sample fixed supply token contract
8 
9 // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
10 
11 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal constant returns(uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal constant returns(uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 
44 // ERC Token Standard #20 Interface
45 
46 //https://github.com/ethereum/EIPs/issues/20
47 
48 contract ERC20Interface {
49 
50      // Get the total token supply
51 
52     
53     function totalSupply() constant returns(uint256 _totalSupply);
54 
55     
56 
57     // Get the account balance of another account with address _owner
58 
59     
60     function balanceOf(address _owner) constant returns(uint256 balance);
61 
62     
63 
64      // Send _value amount of tokens to address _to
65 
66     
67     function transfer(address _to, uint256 _value) returns(bool success);
68 
69      // Send _value amount of tokens from address _from to address _to
70 
71 
72     function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
73 
74  // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
75  // If this function is called again it overwrites the current allowance with _value.
76 
77 // this function is required for some DEX functionality
78 
79  
80     function approve(address _spender, uint256 _value) returns(bool success);
81 
82    // Returns the amount which _spender is still allowed to withdraw from _owner
83 
84 
85     function allowance(address _owner, address _spender) constant returns(uint256 remaining);
86 
87    // Triggered when tokens are transferred.
88 
89    
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91 
92     // Triggered whenever approve(address _spender, uint256 _value) is called.
93 
94     
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 
97 }
98 
99 
100 
101 contract FreeCatalugnaCoin is ERC20Interface {
102     using SafeMath
103     for uint256;
104 
105     
106     string public constant name = "Free Catalugna Coin";  // Name of Token
107     
108     string public constant symbol = "FCC";     // Symbol of Token
109 
110   uint8 public constant decimals = 18;    // Amount of decimals for display purposes  
111 
112  uint256 _totalSupply = 10000000 * 10 **18;  // 10 Million token total supply......muliplied with 10 power 18 because of decimals of 4 precision
113 
114     
115     uint256 public constant RATE = 1000;        // 1 Ether = 1000 tokens
116 
117     // Owner of this contract
118     address public owner;
119 
120    // Balances for each account
121    mapping(address => uint256) balances;
122    
123    // Owner of account approves the transfer of an amount to another account
124 
125    mapping(address => mapping(address => uint256)) allowed;
126 
127 // Functions with this modifier can only be executed by the owner
128 
129     modifier onlyOwner() {
130      if (msg.sender != owner) {
131          revert();
132             }
133             _;
134          }
135     uint256 tokens;
136    
137     // This is the Constructor
138     
139     function FreeCatalugnaCoin() {
140        
141         owner = msg.sender;
142         balances[owner] = _totalSupply;
143     }
144     
145      function() payable {
146         buyTokens();
147     }
148     
149     function buyTokens() payable {
150 
151         require(msg.value > 0 );
152          tokens = msg.value.mul(RATE);
153         balances[msg.sender] = balances[msg.sender].add(tokens);
154         balances[owner] = balances[owner].sub(tokens);
155         
156         owner.transfer(msg.value);
157     }
158 
159 /* 
160 
161   function FixedSupplyToken() {
162 
163       owner = msg.sender;
164 
165      balances[owner] = _totalSupply;
166         
167     } */
168 
169     function totalSupply() constant returns(uint256) {
170        return _totalSupply;
171     }
172 
173 // What is the balance of a particular account?
174 
175     function balanceOf(address _owner) constant returns(uint256 balance) {
176 
177         return balances[_owner];
178 
179     }
180 // Transfer the balance from owner&#39;s account to another account
181   /* Send coins during transactions*/
182 
183     function transfer(address _to, uint256 _amount) returns(bool success) {
184 
185         if (balances[msg.sender] >= _amount &&  balances[_to] + _amount > balances[_to]) {
186 
187             balances[msg.sender] -= _amount;
188 
189             balances[_to] += _amount;
190 
191             Transfer(msg.sender, _to, _amount);
192 
193             return true;
194 
195         } else {
196 
197             return false;
198 
199         }
200 
201     }
202 // Send _value amount of tokens from address _from to address _to
203  // The transferFrom method is used for a withdraw workflow, allowing contracts to send
204  // tokens on your behalf, for example to &quot;deposit&quot; to a contract address and/or to charge
205 
206 // fees in sub-currencies; the command should fail unless the _from account has
207 // deliberately authorized the sender of the message via some mechanism; we propose
208  // these standardized APIs for approval:
209 
210     function transferFrom(
211 
212        address _from,
213 
214       address _to,
215 
216        uint256 _amount
217 
218        ) returns(bool success) {
219 
220         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount &&  _amount > 0 && balances[_to] + _amount > balances[_to]) {
221 
222             balances[_from] -= _amount;
223 
224             allowed[_from][msg.sender] -= _amount;
225 
226             balances[_to] += _amount;
227 
228             Transfer(_from, _to, _amount);
229 
230             return true;
231 } else 
232 {
233  return false;
234         }
235 
236          }
237 
238     
239 
240     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
241 
242    // If this function is called again it overwrites the current allowance with _value.
243 
244     function approve(address _spender, uint256 _amount) returns(bool success) {
245 
246      
247         allowed[msg.sender][_spender] = _amount;
248 
249         Approval(msg.sender, _spender, _amount);
250 
251       
252         return true;
253 
254     }
255 
256     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
257 
258           
259             return allowed[_owner][_spender];
260     }
261     
262     // Failsafe drain only owner can call this function
263     function drain() onlyOwner {
264           owner.transfer(this.balance);
265     }
266 }