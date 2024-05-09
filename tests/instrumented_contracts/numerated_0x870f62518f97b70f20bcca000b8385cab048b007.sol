1 pragma solidity 0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns(uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns(uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract ERC20 {
37     function totalSupply()public view returns(uint total_Supply);
38     function balanceOf(address who)public view returns(uint256);
39     function allowance(address owner, address spender)public view returns(uint);
40     function transferFrom(address from, address to, uint value)public returns(bool ok);
41     function approve(address spender, uint value)public returns(bool ok);
42     function transfer(address to, uint value)public returns(bool ok);
43     event Transfer(address indexed from, address indexed to, uint value);
44     event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 
48 contract IDMONEY is ERC20
49 {
50     using SafeMath for uint256;
51         // Name of the token
52         string public constant name = "IDMONEY";
53 
54     // Symbol of token
55     string public constant symbol = "IDM";
56     uint8 public constant decimals = 18;
57     uint public _totalsupply = 35000000 * 10 ** 18; // 35 Million IDM Coins
58     uint256 constant public _price_tokn = 0.00075 ether;
59     uint256 no_of_tokens;
60     uint256 bonus_token;
61     uint256 total_token;
62     uint256 tokensold;
63     uint256 public total_token_sold;
64     bool stopped = false;
65  
66     address public owner;
67     address superAdmin = 0x1313d38e988526A43Ab79b69d4C94dD16f4c9936;
68     address socialOne = 0x52d4bcF6F328492453fAfEfF9d6Eb73D26766Cff;
69     address socialTwo = 0xbFe47a096486B564783f261B324e198ad84Fb8DE;
70     address founderOne = 0x5AD7cdD7Cd67Fe7EB17768F04425cf35a91587c9;
71     address founderTwo = 0xA90ab8B8Cfa553CC75F9d2C24aE7148E44Cd0ABa;
72     address founderThree = 0xd2fdE07Ee7cB86AfBE59F4efb9fFC1528418CC0E;
73     address storage1 = 0x5E948d1C6f7C76853E43DbF1F01dcea5263011C5;
74     
75     mapping(address => uint) balances;
76     mapping(address => bool) public refund;              //checks the refund status
77     mapping(address => bool) public whitelisted;         //checks the whitelist status of the address
78     mapping(address => uint256) public deposited;        //checks the actual ether given by investor
79     mapping(address => uint256) public tokensinvestor;   //checks number of tokens for investor
80     mapping(address => mapping(address => uint)) allowed;
81 
82     uint constant public minimumInvestment = 1 ether; // 1 ether is minimum minimumInvestment
83     uint bonus;
84     uint c;
85     uint256 lefttokens;
86 
87     enum Stages {
88         NOTSTARTED,
89         ICO,
90         PAUSED,
91         ENDED
92     }
93     Stages public stage;
94 
95      modifier atStage(Stages _stage) {
96         require (stage == _stage);
97             // Contract not in expected state
98          _;
99     }
100     
101      modifier onlyOwner() {
102         require (msg.sender == owner);
103         _;
104     }
105     
106      modifier onlySuperAdmin() {
107         require (msg.sender == superAdmin);
108         _;
109     }
110 
111     function IDMONEY() public
112     {
113         owner = msg.sender;
114         balances[superAdmin] = 2700000 * 10 ** 18;  // 2.7 million given to superAdmin
115         balances[socialOne] = 3500000 * 10 ** 18;  // 3.5 million given to socialOne
116         balances[socialTwo] = 3500000 * 10 ** 18;  // 3.5 million given to socialTwo
117         balances[founderOne] = 2100000 * 10 ** 18; // 2.1 million given to FounderOne
118         balances[founderTwo] = 2100000 * 10 ** 18; // 2.1 million given to FounderTwo
119         balances[founderThree] = 2100000 * 10 ** 18; //2.1 million given to founderThree
120         balances[storage1] = 9000000 * 10 ** 18; // 9 million given to storage1
121         stage = Stages.NOTSTARTED;
122         Transfer(0, superAdmin, balances[superAdmin]);
123         Transfer(0, socialOne, balances[socialOne]);
124         Transfer(0, socialTwo, balances[socialTwo]);
125         Transfer(0, founderOne, balances[founderOne]);
126         Transfer(0, founderTwo, balances[founderTwo]);
127         Transfer(0, founderThree, balances[founderThree]);
128         Transfer(0, storage1, balances[storage1]);
129     }
130 
131     function () public payable atStage(Stages.ICO)
132     {
133         require(msg.value >= minimumInvestment);
134         require(!stopped && msg.sender != owner);
135 
136         no_of_tokens = ((msg.value).div(_price_tokn)).mul(10 ** 18);
137         tokensold = (tokensold).add(no_of_tokens);
138         deposited[msg.sender] = deposited[msg.sender].add(msg.value);
139         bonus = bonuscal();
140         bonus_token = ((no_of_tokens).mul(bonus)).div(100);  // bonus
141         total_token = no_of_tokens + bonus_token;
142         total_token_sold = (total_token_sold).add(total_token);
143         tokensinvestor[msg.sender] = tokensinvestor[msg.sender].add(total_token);
144 
145 
146     }
147 
148     //calculation for the bonus for 1 million tokens
149     function bonuscal() private returns(uint)
150     {
151        
152         c = tokensold / 10 ** 23;
153         if (c == 0) 
154         {
155            return  90;
156 
157         }
158          return (90 - (c * 10));
159     }
160 
161     function start_ICO() external onlyOwner atStage(Stages.NOTSTARTED)
162     {
163         stage = Stages.ICO;
164         stopped = false;
165         balances[address(this)] = 10000000 * 10 ** 18; // 10 million to smart contract initially
166         Transfer(0, address(this), balances[address(this)]);
167     }
168 
169 
170     function enablerefund(address refundaddress) external onlyOwner
171     {
172         require(!whitelisted[refundaddress]);
173         refund[refundaddress] = true;
174     }
175 
176     //refund of the Non whitelisted
177     function claimrefund(address investor) public
178     {
179         require(refund[investor]);
180         uint256 depositedValue = deposited[investor];
181         deposited[investor] = 0;
182         investor.transfer(depositedValue);
183         tokensinvestor[investor] = 0;
184         // Refunded(investor, depositedValue);
185     }
186 
187     // called by the owner, pause ICO
188     function PauseICO() external onlyOwner atStage(Stages.ICO) {
189         stopped = true;
190         stage = Stages.PAUSED;
191     }
192 
193     // called by the owner , resumes ICO
194     function releaseICO() external onlyOwner atStage(Stages.PAUSED)
195     {
196         stopped = false;
197         stage = Stages.ICO;
198     }
199 
200 
201     function setWhiteListAddresses(address _investor) external onlyOwner{
202         whitelisted[_investor] = true;
203     }
204 
205     //Investor can claim his tokens within two weeks of ICO end using this function
206     //It can be also used to claim on behalf of any investor
207     function claimTokensICO(address receiver) public
208     // isValidPayload
209     {
210         //   if (receiver == 0)
211         //   receiver = msg.sender;
212         require(whitelisted[receiver]);
213         require(tokensinvestor[receiver] > 0);
214         uint256 tokensclaim = tokensinvestor[receiver];
215         balances[address(this)] = (balances[address(this)]).sub(tokensclaim);
216         balances[receiver] = (balances[receiver]).add(tokensclaim);
217         tokensinvestor[receiver] = 0;
218         Transfer(address(this), receiver, balances[receiver]);
219     }
220 
221     function end_ICO() external onlySuperAdmin atStage(Stages.ICO)
222     {
223         stage = Stages.ENDED;
224         lefttokens = balances[address(this)];
225         balances[superAdmin]=(balances[superAdmin]).add(lefttokens);
226         balances[address(this)] = 0;
227         Transfer(address(this), superAdmin, lefttokens);
228 
229     }
230 
231     // what is the total supply of the ech tokens
232     function totalSupply() public view returns(uint256 total_Supply) {
233         total_Supply = _totalsupply;
234     }
235 
236     // What is the balance of a particular account?
237     function balanceOf(address _owner)public view returns(uint256 balance) {
238         return balances[_owner];
239     }
240 
241     // Send _value amount of tokens from address _from to address _to
242     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
243     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
244     // fees in sub-currencies; the command should fail unless the _from account has
245     // deliberately authorized the sender of the message via some mechanism; we propose
246     // these standardized APIs for approval:
247     function transferFrom(address _from, address _to, uint256 _amount)public returns(bool success) {
248         require(_to != 0x0);
249         require(_amount >= 0);
250         balances[_from] = (balances[_from]).sub(_amount);
251         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
252         balances[_to] = (balances[_to]).add(_amount);
253         Transfer(_from, _to, _amount);
254         return true;
255     }
256 
257     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
258     // If this function is called again it overwrites the current allowance with _value.
259     function approve(address _spender, uint256 _amount)public returns(bool success) {
260         require(_spender != 0x0);
261         allowed[msg.sender][_spender] = _amount;
262         Approval(msg.sender, _spender, _amount);
263         return true;
264     }
265 
266     function allowance(address _owner, address _spender)public view returns(uint256 remaining) {
267         require(_owner != 0x0 && _spender != 0x0);
268         return allowed[_owner][_spender];
269     }
270 
271     // Transfer the balance from owner's account to another account
272     function transfer(address _to, uint256 _amount)public returns(bool success) {
273         require(_to != 0x0);
274         require(balances[msg.sender] >= _amount && _amount >= 0);
275         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
276         balances[_to] = (balances[_to]).add(_amount);
277         Transfer(msg.sender, _to, _amount);
278         return true;
279     }
280 
281  
282 
283     //In case the ownership needs to be transferred
284     function transferOwnership(address newOwner)public onlySuperAdmin
285     {
286         require(newOwner != 0x0);
287         owner = newOwner;
288     }
289 
290 
291     function drain() external onlyOwner {
292         superAdmin.transfer(this.balance);
293     }
294 
295 }