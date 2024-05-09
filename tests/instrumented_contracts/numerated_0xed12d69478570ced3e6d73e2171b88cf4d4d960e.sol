1 pragma solidity 0.4.18;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) pure internal returns(uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) pure  internal returns(uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) pure internal returns(uint) {
16         uint c = a + b;
17         assert(c >= a && c >= b);
18         return c;
19     }
20     
21     
22 }
23 
24 
25 contract ERC20 {
26 
27     uint public totalSupply;
28 
29     function balanceOf(address who) public constant returns(uint256);
30 
31     function allowance(address owner, address spender) public constant returns(uint);
32 
33     function transferFrom(address from, address to, uint value) public  returns(bool ok);
34 
35     function approve(address spender, uint value) public returns(bool ok);
36 
37     function transfer(address to, uint value) public returns(bool ok);
38 
39     event Transfer(address indexed from, address indexed to, uint value);
40 
41     event Approval(address indexed owner, address indexed spender, uint value);
42 
43 }
44 contract BeefLedger is ERC20, SafeMath
45 {
46       string public constant name = "BeefLedger";
47   
48     	// Symbol of token
49       string public constant symbol = "BLT"; 
50       uint8 public constant decimals = 6;  // decimal places
51     
52       uint public totalSupply = 888888888 * 10**6 ; // total supply includes decimal upto 6 places
53       
54       mapping(address => uint) balances;
55      
56       mapping (address => mapping (address => uint)) allowed;
57       address owner;
58       // ico dates
59       uint256 pre_date;
60       uint256 ico_first;
61       uint256 ico_second;
62       uint token_supply_forperiod;
63       bool ico_status = false;
64        bool stopped = false;
65       uint256 price_token;
66       event MESSAGE(string m);
67        event ADDRESS(address addres, uint balance);
68       
69        // Functions with this modifier can only be executed by the owner
70       modifier onlyOwner() {
71          if (msg.sender != owner) {
72            revert();
73           }
74          _;
75         }
76       
77       function BeefLedger() public
78       {
79           owner = msg.sender;
80        }
81       
82        // Emergency Pause and Release is called by Owner in case of Emergency
83     
84     function emergencyPause() external onlyOwner{
85         stopped = true;
86     }
87      
88      function releasePause() external onlyOwner{
89          stopped = false;
90      }
91      
92       function start_ICO() public onlyOwner
93       {
94           ico_status = true;
95           stopped = false;
96           pre_date = now + 1 days;
97           ico_first = pre_date + 70 days;
98           ico_second = ico_first + 105 days;
99           token_supply_forperiod = 488888889 *10**6; 
100           balances[address(this)] = token_supply_forperiod;
101       }
102       function endICOs() public onlyOwner
103       {
104            ico_status = false;
105           uint256 balowner = 399999999 * 10 **6;
106            balances[owner] = balances[address(this)] + balowner;
107            balances[address(this)] = 0;
108          Transfer(address(this), msg.sender, balances[owner]);
109       }
110 
111 
112     function () public payable{ 
113       require (!stopped && msg.sender != owner && ico_status);
114        if(now <= pre_date)
115          {
116              
117              price_token =  .0001167 ether;
118          }
119          else if(now > pre_date && now <= ico_first)
120          {
121              
122              price_token =  .0001667 ether;
123          }
124          else if(now > ico_first && now <= ico_second)
125          {
126              
127              price_token =  .0002167 ether;
128          }
129        
130 else {
131     revert();
132 }
133        
134          uint no_of_tokens = (msg.value * 10 **6 ) / price_token ;
135           require(balances[address(this)] >= no_of_tokens);
136               
137           balances[address(this)] = safeSub(balances[address(this)], no_of_tokens);
138           balances[msg.sender] = safeAdd(balances[msg.sender], no_of_tokens);
139         Transfer(address(this), msg.sender, no_of_tokens);
140               owner.transfer(this.balance);
141 
142     }
143    
144    
145    
146     // erc20 function to return total supply
147     function totalSupply() public constant returns(uint) {
148        return totalSupply;
149     }
150     
151     // erc20 function to return balance of give address
152     function balanceOf(address sender) public constant returns(uint256 balance) {
153         return balances[sender];
154     }
155 
156     // Transfer the balance from owner's account to another account
157     function transfer(address _to, uint256 _amount) public returns(bool success) {
158         if (_to == 0x0) revert(); // Prevent transfer to 0x0 address. Use burn() instead
159         if (balances[msg.sender] < _amount) revert(); // Check if the sender has enough
160 
161         if (safeAdd(balances[_to], _amount) < balances[_to]) revert(); // Check for overflows
162        
163         balances[msg.sender] = safeSub(balances[msg.sender], _amount); // Subtract from the sender
164         balances[_to] = safeAdd(balances[_to], _amount); // Add the same to the recipient
165         Transfer(msg.sender, _to, _amount); // Notify anyone listening that this transfer took place
166         
167         return true;
168     }
169 
170     // Send _value amount of tokens from address _from to address _to
171     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
172     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
173     // fees in sub-currencies; the command should fail unless the _from account has
174     // deliberately authorized the sender of the message via some mechanism; we propose
175     // these standardized APIs for approval:
176 
177     function transferFrom(
178         address _from,
179         address _to,
180         uint256 _amount
181     ) public returns(bool success) {
182         if (balances[_from] >= _amount &&
183             allowed[_from][msg.sender] >= _amount &&
184             _amount > 0 &&
185             safeAdd(balances[_to], _amount) > balances[_to]) {
186             balances[_from] = safeSub(balances[_from], _amount);
187             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _amount);
188             balances[_to] = safeAdd(balances[_to], _amount);
189             Transfer(_from, _to, _amount);
190             return true;
191         } else {
192             return false;
193         }
194     }
195     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
196     // If this function is called again it overwrites the current allowance with _value.
197     function approve(address _spender, uint256 _amount) public returns(bool success) {
198         allowed[msg.sender][_spender] = _amount;
199         Approval(msg.sender, _spender, _amount);
200         return true;
201     }
202 
203     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
204         return allowed[_owner][_spender];
205     }
206 
207 function transferOwnership(address _newowner) external onlyOwner{
208     uint new_bal = balances[msg.sender];
209     owner = _newowner;
210     balances[owner]= new_bal;
211     balances[msg.sender] = 0;
212 }
213    function drain() external onlyOwner {
214        
215         owner.transfer(this.balance);
216     }
217     
218   }