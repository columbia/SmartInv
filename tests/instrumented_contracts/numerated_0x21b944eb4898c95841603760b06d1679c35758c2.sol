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
21     function safeDiv(uint a, uint b) pure internal returns (uint) {
22     assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint c = a / b;
24      assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 }
28 contract ERC20 {
29   uint256 public totalsupply;
30   function totalSupply() public constant returns(uint256 _totalSupply);
31   function balanceOf(address who) public constant returns (uint256);
32   function allowance(address owner, address spender) public constant returns (uint256);
33   function transferFrom(address from, address to, uint256 value) public returns (bool ok);
34   function approve(address spender, uint256 value) public returns (bool ok);
35   function transfer(address to, uint256 value) public returns (bool ok);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 contract Mari is ERC20, SafeMath
41 {
42     // Name of the token
43     string public constant name = "Mari";
44 
45     // Symbol of token
46     string public constant symbol = "MAR";
47 
48     uint8 public constant decimals = 18;
49     uint public totalsupply = 2000000 * 10 ** 18; //
50     address public owner;
51     uint256 public _price_tokn = 483 ;
52     uint256 no_of_tokens;
53     bool stopped = true;
54     uint256 startdate;
55     uint256 enddate;
56     mapping(address => uint) balances;
57     mapping(address => mapping(address => uint)) allowed;
58 
59     
60      enum Stages {
61         NOTSTARTED,
62         ICO,
63         PAUSED,
64         ENDED
65     }
66     Stages public stage;
67     
68     modifier atStage(Stages _stage) {
69         if (stage != _stage)
70             // Contract not in expected state
71             revert();
72         _;
73     }
74     
75      modifier onlyOwner() {
76         if (msg.sender != owner) {
77             revert();
78         }
79         _;
80     }
81     function Mari() public
82     {
83         owner = msg.sender;
84         balances[owner] = 1750000 * 10 **18;
85         balances[address(this)] = 250000 *10**18;
86         stage = Stages.NOTSTARTED;
87         Transfer(0, owner, balances[owner]);
88         Transfer(0, owner, balances[address(this)]);
89     }
90   
91     function () public payable atStage(Stages.ICO)
92     {
93         require(!stopped && msg.sender != owner && now <= enddate);
94         no_of_tokens = safeMul(msg.value , _price_tokn);
95         transferTokens(msg.sender,no_of_tokens);
96     }
97     
98      function start_ICO() public onlyOwner 
99       {
100           stage = Stages.ICO;
101           stopped = false;
102           startdate = now;
103           enddate = startdate + 30 days;
104      }
105     
106     // called by the owner, pause ICO
107     function StopICO() external onlyOwner {
108         stopped = true;
109         stage = Stages.PAUSED;
110     }
111 
112     // called by the owner , resumes ICO
113     function releaseICO() external onlyOwner {
114         stopped = false;
115         stage = Stages.ICO;
116     }
117     
118      function end_ICO() external onlyOwner
119      {
120          stage = Stages.ENDED;
121          totalsupply = safeSub(totalsupply , balances[address(this)]);
122          balances[address(this)] = 0;
123          Transfer(address(this), 0 , balances[address(this)]);
124          
125      }
126 
127 
128     function totalSupply() public constant returns(uint256 _totalSupply)
129     {
130         return totalsupply;
131     }
132     
133     function balanceOf(address sender) public constant returns (uint256)
134     {
135         return balances[sender];
136     }
137     
138     function transferFrom(
139         address _from,
140         address _to,
141         uint256 _amount
142     ) public returns(bool success) {
143         if (balances[_from] >= _amount &&
144             allowed[_from][msg.sender] >= _amount &&
145             _amount > 0 &&
146             balances[_to] + _amount > balances[_to]) {
147             balances[_from] -= _amount;
148             allowed[_from][msg.sender] -= _amount;
149             balances[_to] += _amount;
150             Transfer(_from, _to, _amount);
151             return true;
152         } else {
153             return false;
154         }
155     }
156     
157     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
158     // If this function is called again it overwrites the current allowance with _value.
159     function approve(address _spender, uint256 _amount) public returns(bool success) {
160         allowed[msg.sender][_spender] = _amount;
161         Approval(msg.sender, _spender, _amount);
162         return true;
163     }
164 
165     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
166         return allowed[_owner][_spender];
167     }
168       // Transfer the balance from owner's account to another account
169     function transfer(address _to, uint256 _amount) public returns(bool success) {
170         if (balances[msg.sender] >= _amount &&
171             _amount > 0 &&
172             balances[_to] + _amount > balances[_to]) {
173          
174             balances[msg.sender] -= _amount;
175             balances[_to] += _amount;
176             Transfer(msg.sender, _to, _amount);
177 
178           
179 
180             return true;
181         } else {
182             return false;
183         }
184     }
185     
186           // Transfer the balance from owner's account to another account
187     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
188         if (balances[address(this)] >= _amount &&
189             _amount > 0 &&
190             balances[_to] + _amount > balances[_to]) {
191          
192             balances[address(this)] -= _amount;
193             balances[_to] += _amount;
194             Transfer(address(this), _to, _amount);
195 
196             return true;
197         } else {
198             return false;
199         }
200     }
201     
202      function drain() external onlyOwner {
203         owner.transfer(this.balance);
204     }
205     
206     
207     
208 }