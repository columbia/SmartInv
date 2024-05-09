1 pragma solidity ^0.4;
2 
3 
4 contract ERC20 {
5     uint public totalSupply;
6     function balanceOf(address _account) public constant returns (uint balance);
7     function transfer(address _to, uint _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
9     function approve(address _spender, uint _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint remaining);
11     event Transfer(address indexed _from, address indexed _to, uint _value);
12     event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 
16 contract Token is ERC20 {
17     // Balances for trading
18     // Default balance - 0
19     mapping(address => uint256) public balances;
20     mapping(address => uint256) public FreezeBalances;
21     mapping(address => mapping (address => uint)) allowed;
22 
23     // Total amount of supplied tokens
24     uint256 public totalSupply;
25     uint256 public preSaleSupply;
26     uint256 public ICOSupply;
27     uint256 public userGrowsPoolSupply;
28     uint256 public auditSupply;
29     uint256 public bountySupply;
30 
31     // Total tokens remind balance
32     uint256 public totalTokensRemind;
33 
34     // Information about token
35     string public constant name = "AdMine";
36     string public constant symbol = "MCN";
37     address public owner;
38     uint8 public decimals = 5;
39 
40     // If function has this modifier, only owner can execute this function
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     uint public unfreezeTime;
47     uint public AdmineTeamTokens;
48     uint public AdmineAdvisorTokens;
49 
50 
51     function Token() public {
52         owner = msg.sender;
53         // 100 миллионов токенов  = 100 000 000
54         // 100 000 000 * 10^5 = 10000000000000
55         totalSupply = 10000000000000;
56 
57         // Pre Sale supply calculate 5%
58         preSaleSupply = totalSupply * 5 / 100;
59 
60         // ICO supply calculate 60%
61         ICOSupply = totalSupply * 60 / 100;
62 
63         // User growth pool 10%
64         userGrowsPoolSupply = totalSupply * 10 / 100;
65 
66         // AdMine team tokens 15%
67         AdmineTeamTokens = totalSupply * 15 / 100;
68 
69         // Admine advisors tokens supply 6%
70         AdmineAdvisorTokens = totalSupply * 6 / 100;
71 
72         // Audit tokens supply 2%
73         auditSupply = totalSupply * 2 / 100;
74 
75         // Bounty tokens supply 2%
76         bountySupply = totalSupply * 2 / 100;
77 
78         totalTokensRemind = totalSupply;
79         balances[owner] = totalSupply;
80         unfreezeTime = now + 1 years;
81 
82         freeze(0x01306bfbC0C20BEADeEc30000F634d08985D87de, AdmineTeamTokens);
83     }
84 
85     // Transfere tokens to audit partners (2%)
86     function transferAuditTokens(address _to, uint256 _amount) public onlyOwner {
87         require(auditSupply>=_amount);
88         balances[owner] -= _amount;
89         balances[_to] += _amount;
90         auditSupply -= _amount;
91         totalTokensRemind -= _amount;
92     }
93 
94     // Transfer tokens to bounty partners (2%)
95     function transferBountyTokens(address _to, uint256 _amount) public onlyOwner {
96         require(bountySupply>=_amount);
97         balances[owner] -= _amount;
98         balances[_to] += _amount;
99         bountySupply -= _amount;
100         totalTokensRemind -= _amount;
101     }
102 
103     function returnBountyTokens(address _from, uint256 _amount) public onlyOwner {
104         require(balances[_from]>=_amount);
105         balances[owner] += _amount;
106         balances[_from] -= _amount;
107         bountySupply += _amount;
108         totalTokensRemind += _amount;
109     }
110 
111     // Transfer tokens to AdMine users pool (10%)
112     function transferUserGrowthPoolTokens(address _to, uint256 _amount) public onlyOwner {
113         require(userGrowsPoolSupply>=_amount);
114         balances[owner] -= _amount;
115         balances[_to] += _amount;
116         userGrowsPoolSupply -= _amount;
117         totalTokensRemind -= _amount;
118     }
119 
120     function returnUserGrowthPoolTokens(address _from, uint256 _amount) public onlyOwner {
121         require(balances[_from]>=_amount);
122         balances[owner] += _amount;
123         balances[_from] -= _amount;
124         userGrowsPoolSupply += _amount;
125         totalTokensRemind += _amount;
126     }
127 
128     // Transfer tokens to advisors (6%)
129     function transferAdvisorTokens(address _to, uint256 _amount) public onlyOwner {
130         require(AdmineAdvisorTokens>=_amount);
131         balances[owner] -= _amount;
132         balances[_to] += _amount;
133         AdmineAdvisorTokens -= _amount;
134         totalTokensRemind -= _amount;
135     }
136 
137     function returnAdvisorTokens(address _from, uint256 _amount) public onlyOwner {
138         require(balances[_from]>=_amount);
139         balances[owner] += _amount;
140         balances[_from] -= _amount;
141         AdmineAdvisorTokens += _amount;
142         totalTokensRemind += _amount;
143     }
144 
145     // Transfer tokens to ico partners (60%)
146     function transferIcoTokens(address _to, uint256 _amount) public onlyOwner {
147         require(ICOSupply>=_amount);
148         balances[owner] -= _amount;
149         balances[_to] += _amount;
150         ICOSupply -= _amount;
151         totalTokensRemind -= _amount;
152     }
153 
154     function returnIcoTokens(address _from, uint256 _amount) public onlyOwner {
155         require(balances[_from]>=_amount);
156         balances[owner] += _amount;
157         balances[_from] -= _amount;
158         ICOSupply += _amount;
159         totalTokensRemind += _amount;
160     }
161 
162     // Transfer tokens to pre sale partners (5%)
163     function transferPreSaleTokens(address _to, uint256 _amount) public onlyOwner {
164         require(preSaleSupply>=_amount);
165         balances[owner] -= _amount;
166         balances[_to] += _amount;
167         preSaleSupply -= _amount;
168         totalTokensRemind -= _amount;
169     }
170 
171     function returnPreSaleTokens(address _from, uint256 _amount) public onlyOwner {
172         require(balances[_from]>=_amount);
173         balances[owner] += _amount;
174         balances[_from] -= _amount;
175         preSaleSupply += _amount;
176         totalTokensRemind += _amount;
177     }
178 
179     // Erase unsold pre sale tokens
180     function eraseUnsoldPreSaleTokens() public onlyOwner {
181         balances[owner] -= preSaleSupply;
182         preSaleSupply = 0;
183         totalTokensRemind -= preSaleSupply;
184     }
185 
186     function transferUserTokensTo(address _from, address _to, uint256 _amount) public onlyOwner {
187         require(balances[_from] >= _amount && _amount > 0);
188         balances[_from] -= _amount;
189         balances[_to] += _amount;
190         Transfer(_from, _to, _amount);
191     }
192 
193     // Chech trade balance of account
194     function balanceOf(address _account) public constant returns (uint256 balance) {
195         return balances[_account];
196     }
197 
198     // Transfer tokens from your account to other account
199     function transfer(address _to, uint _value) public  returns (bool success) {
200         require(_to != 0x0);                               // Prevent transfer to 0x0 address.
201         require(balances[msg.sender] >= _value);           // Check if the sender has enough
202         balances[msg.sender] -= _value;                    // Subtract from the sender
203         balances[_to] += _value;                           // Add the same to the recipient
204         Transfer(msg.sender, _to, _value);
205         return true;
206     }
207 
208     // Transfer tokens from account (_from) to another account (_to)
209     function transferFrom(address _from, address _to, uint256 _amount) public  returns(bool) {
210         require(_amount <= allowed[_from][msg.sender]);
211         if (balances[_from] >= _amount && _amount > 0) {
212             balances[_from] -= _amount;
213             balances[_to] += _amount;
214             allowed[_from][msg.sender] -= _amount;
215             Transfer(_from, _to, _amount);
216             return true;
217         }
218         else {
219             return false;
220         }
221     }
222 
223     function approve(address _spender, uint _value) public  returns (bool success){
224         allowed[msg.sender][_spender] = _value;
225         Approval(msg.sender, _spender, _value);
226         return true;
227     }
228 
229     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
230         return allowed[_owner][_spender];
231     }
232 
233     function add_tokens(address _to, uint256 _amount) public onlyOwner {
234         balances[owner] -= _amount;
235         balances[_to] += _amount;
236         totalTokensRemind -= _amount;
237     }
238 
239 
240     // вызвать эту функцию через  год -когда нужно будет разморозить
241     function all_unfreeze() public onlyOwner {
242         require(now >= unfreezeTime);
243         // сюда записать те адреса которые морозили в конструткоре
244         unfreeze(0x01306bfbC0C20BEADeEc30000F634d08985D87de);
245     }
246 
247     function unfreeze(address _user) internal {
248         uint amount = FreezeBalances[_user];
249         balances[_user] += amount;
250     }
251 
252 
253     function freeze(address _user, uint256 _amount) public onlyOwner {
254         balances[owner] -= _amount;
255         FreezeBalances[_user] += _amount;
256 
257     }
258 
259 }