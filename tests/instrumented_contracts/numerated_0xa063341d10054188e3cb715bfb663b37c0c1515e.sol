1 pragma solidity ^0.5.1;
2 
3 contract ERC20Interface {
4 
5     function totalSupply() public view returns (uint);
6     function balanceOf(address tokenOwner) public view returns (uint balance);
7     function transfer(address to, uint tokens) public returns (bool success);
8     
9     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
10     function approve(address spender, uint tokens) public returns (bool success);
11     function transferFrom(address from, address to, uint tokens) public returns (bool success);
12     
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens); 
15 
16 }
17 
18 contract DiagonToken is ERC20Interface {
19     
20     string public name = "Diagon Coin";
21     string public symbol = "DGN";
22     uint public decimals = 6;
23     
24     uint public supply;
25     address public founder;
26     
27     mapping(address => uint) public balances;
28     
29     mapping(address => mapping(address => uint)) allowed;
30     
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33     
34     constructor () public {
35         supply = 40000000000000;
36         founder = msg.sender;
37         balances[founder] = supply;
38     }
39     
40     function allowance(address tokenOwner, address spender) view public returns(uint) {
41         return allowed[tokenOwner][spender];
42     }
43     
44     function approve(address spender, uint tokens) public returns(bool) {
45         require(balances[msg.sender] >= tokens);
46         require(tokens > 0);
47         
48         allowed[msg.sender][spender] = tokens;
49         emit Approval(msg.sender, spender, tokens);
50         return true;
51     }
52     
53     function transferFrom(address from, address to, uint tokens) public returns(bool){
54         require(allowed[from][to] >= tokens);
55         require(balances[from] >= tokens);
56         
57         balances[from] -= tokens;
58         balances[to] += tokens;
59         
60         allowed[from][to] -= tokens;
61         
62         return true;
63     }
64     
65     function totalSupply() public view returns (uint){
66         return supply;
67     }
68     
69     function balanceOf(address tokenOwner) public view returns (uint balance) {
70         return balances[tokenOwner];
71     }
72     
73     function transfer(address to, uint tokens) public returns (bool success) {
74         require(balances[msg.sender] >= tokens && tokens > 0);
75         
76         balances[to] += tokens;
77         balances[msg.sender] -= tokens;
78         emit Transfer(msg.sender, to, tokens);
79         return true;
80     }
81     
82 }
83 
84 contract FiatContract {
85     function ETH(uint _id) public view returns (uint256);
86     function USD(uint _id) public view returns (uint256);
87     function EUR(uint _id) public view returns (uint256);
88     function GBP(uint _id) public view returns (uint256);
89     function updatedAt(uint _id) public view returns (uint);
90 }
91 
92 contract DiagonICO is DiagonToken {
93 
94     address public admin;
95     address payable public deposit;
96     FiatContract public fiatPrice;
97     
98     // Token price: 1DGN = 0.2 USD
99     uint public tokenPrice;
100     uint public psTokenPrice;
101     
102     uint public hardCap;
103     
104     uint public raisedAmount;
105     
106     uint public saleStart = 1568628000;
107     
108     uint public saleEnd = 1582588799;
109     
110     uint public coinTradeStart = saleEnd; // Tokens transferable in a week after salesEnd
111     
112     uint public maxInvestment;
113     uint public minInvestment;
114     
115     
116     enum State { beforeStart, running, afterEnd, halted }
117     State public icoState;
118     
119     modifier onlyAdmin() {
120         require(msg.sender == admin);
121         _;
122     }
123     
124     event Invest(address investor, uint value, uint tokens);
125     
126     constructor(address payable _deposit) public {
127         deposit = _deposit;
128         admin = msg.sender;
129         fiatPrice = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
130 
131         uint256 ethCent = fiatPrice.USD(0);
132 
133         tokenPrice = ethCent * 20;
134         hardCap = ethCent * 450000000;
135         maxInvestment = ethCent * 450000000;
136         minInvestment = ethCent * 2000;
137 
138         icoState = State.beforeStart;
139     }
140 
141     function tokenBalance() public view returns (uint) {
142         return (balances[msg.sender]);
143     }
144 
145     function erc20Address() public view returns (address) {
146         address erc20Adr = msg.sender;
147         return erc20Adr;
148     }
149     
150     // ICO Emergency Stop
151     function halt() public onlyAdmin {
152         icoState = State.halted;
153     }
154     
155     // Restart ICO
156     function unhalt() public onlyAdmin{
157         icoState = State.running;
158     }
159     
160     function changeDepositAddress(address payable newDeposit) public onlyAdmin {
161         deposit = newDeposit;
162     }
163     
164     function getCurrentState() public view returns(State) {
165         if(icoState == State.halted) {
166             return State.halted;
167         }else if(block.timestamp < saleStart){
168             return State.beforeStart;
169         } else if(block.timestamp >= saleStart && block.timestamp <= saleEnd){
170             return State.running;
171         } else {
172             return State.afterEnd;
173         }
174     }
175     
176     function invest() payable public returns(bool){
177         // Invest only in ICO running state
178         icoState = getCurrentState();
179         
180         require(icoState == State.running);
181         
182         require(msg.value >= minInvestment && msg.value <= maxInvestment);
183         
184         uint tokens = msg.value / tokenPrice;
185 
186         // HardCap not reached
187         require(raisedAmount + msg.value <= hardCap);
188 
189         raisedAmount += msg.value;
190     
191         // Add tokens to investor's balance from founder balance
192         balances[msg.sender] += tokens;
193         balances[founder] -= tokens;
194     
195         deposit.transfer(msg.value); // Transfer ETH to the deposit address
196     
197         emit Invest(msg.sender, msg.value, tokens);
198     
199         return true;
200     }
201     
202     // Burning all unsold token
203     function burn() public returns(bool){
204         require(msg.sender == admin);
205         icoState = getCurrentState();
206         require(icoState == State.afterEnd);
207         balances[founder] = 0;
208     }
209     
210     // Invest function from an external address
211     function () payable external {
212         invest();
213     }
214     
215     function transfer(address to, uint value) public returns(bool){
216         if (block.timestamp < coinTradeStart) {
217             require(msg.sender == admin);
218             super.transfer(to, value);
219         } else {
220             require(block.timestamp > coinTradeStart);
221             super.transfer(to, value);
222         }
223     }
224     
225     function transferFrom(address _from, address _to, uint _value) public returns(bool){
226         require(block.timestamp > coinTradeStart);
227         super.transferFrom(_from, _to, _value);
228     }
229 }