1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6         return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract INFLIVERC20 {
28     function totalSupply() public view returns (uint total_Supply);
29     function balanceOf (address who) public view returns (uint256);
30     function allowance (address IFVOwner, address spender) public view returns (uint);
31     function transferFrom (address from, address to, uint value) public returns (bool ok);
32     function approve (address spender, uint value) public returns (bool ok);
33     function transfer (address to, uint value) public returns (bool ok);
34     event    Transfer (address indexed from, address indexed to, uint value);
35     event    Approval (address indexed IFVOwner, address indexed spender, uint value);
36 }
37 
38 
39 contract INFLIV is INFLIVERC20 { 
40     
41     using SafeMath for uint256;
42     
43     string  public constant name        = "INFLIV";                             // Name of the token
44     string  public constant symbol      = "IFV";                                // Symbol of token
45     uint8   public constant decimals    = 18;
46     
47     uint    public _totalsupply         = 70000000 * 10 ** 18;                  // 70 million Total Supply
48     uint256 maxPublicSale               = 22000000 * 10 ** 18;                  // 22 million Public Sale
49                                    
50     uint256 public PricePre             = 6000;                                 // 1 Ether = 6000 tokens in Pre-ICO
51     uint256 public PriceICO1            = 3800;                                 // 1 Ether = 3800 tokens in ICO Phase 1
52     uint256 public PriceICO2            = 2600;                                 // 1 Ether = 2600 tokens in ICO Phase 2
53     uint256 public PublicPrice          = 1800;                                 // 1 Ether = 1800 tokens in Public Sale
54     uint256 public PreStartTimeStamp;
55     uint256 public PreEndTimeStamp;
56     uint256 input_token;
57     uint256 bonus_token;
58     uint256 total_token;
59     uint256 ICO1;
60     uint256 ICO2;
61     uint256 public ETHReceived;                                                 // Total ETH received in the contract
62     mapping (address => uint) balances;
63     mapping (address => mapping(address => uint)) allowed;
64     
65     address public IFVOwner;                                                    // Owner of this contract
66     bool stopped = false;
67 
68     enum CurrentStages {
69         NOTSTARTED,
70         PRE,
71         ICO,
72         PAUSED,
73         ENDED
74     }
75     
76     CurrentStages public stage;
77     
78     modifier atStage(CurrentStages _stage) {
79         if (stage != _stage)
80             // Contract not in expected state
81             revert();
82         _;
83     }
84     
85     modifier onlyOwner() {
86         if (msg.sender != IFVOwner) {
87             revert();
88         }
89         _;
90     }
91 
92     function INFLIV() public {
93         IFVOwner            = msg.sender;
94         balances[IFVOwner]  = 48000000 * 10 ** 18;                              // 28 million to owner & 20 million to referral bonus
95         balances[address(this)] = maxPublicSale;
96         stage               = CurrentStages.NOTSTARTED;
97         Transfer (0, IFVOwner, balances[IFVOwner]);
98         Transfer (0, address(this), balances[address(this)]);
99     }
100   
101     function () public payable {
102         require(stage != CurrentStages.ENDED);
103         require(!stopped && msg.sender != IFVOwner);
104             if(stage == CurrentStages.PRE && now <= PreEndTimeStamp) { 
105                     require (ETHReceived <= 1500 ether);                        // Hardcap
106                     ETHReceived     = (ETHReceived).add(msg.value);
107                     input_token     = ((msg.value).mul(PricePre)); 
108                     bonus_token     = ((input_token).mul(50)).div(100);         // 50% bonus in Pre-ICO
109                     total_token     = input_token + bonus_token;
110                     transferTokens (msg.sender, total_token);
111             }
112             else if (now <= ICO2) {
113                     
114                 if(now < ICO1)
115                 {
116                     input_token     = (msg.value).mul(PriceICO1);
117                     bonus_token     = ((input_token).mul(25)).div(100);         // 25% bonus in ICO Phase 1
118                     total_token     = input_token + bonus_token;
119                     transferTokens (msg.sender, total_token);
120                 }   
121                 else if(now >= ICO1 && now < ICO2)
122                 {
123                     input_token     = (msg.value).mul(PriceICO2);
124                     bonus_token     = ((input_token).mul(10)).div(100);         // 10% bonus in ICO Phase 2
125                     total_token     = input_token + bonus_token;
126                     transferTokens (msg.sender, total_token);
127                 }
128             }
129             else
130             {
131                     input_token     = (msg.value).mul(PublicPrice);
132                     transferTokens (msg.sender, input_token);
133             }
134     }
135      
136     function start_ICO() public onlyOwner atStage(CurrentStages.NOTSTARTED)
137     {
138         stage                   = CurrentStages.PRE;
139         stopped                 = false;
140         PreStartTimeStamp       = now;
141         PreEndTimeStamp         = now + 20 days;
142         ICO1                    = PreEndTimeStamp + 20 days;
143         ICO2                    = ICO1 + 20 days;
144     }
145     
146     function PauseICO() external onlyOwner
147     {
148         stopped = true;
149     }
150 
151     function ResumeICO() external onlyOwner
152     {
153         stopped = false;
154     }
155    
156     function end_ICO() external onlyOwner atStage(CurrentStages.PRE)
157     {
158         require (now > ICO2);
159         stage                       = CurrentStages.ENDED;
160         _totalsupply                = (_totalsupply).sub(balances[address(this)]);
161         balances[address(this)]     = 0;
162         Transfer (address(this), 0 , balances[address(this)]);
163     }
164     
165     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
166         require (_to != 0x0);
167         require (balances[_from]    >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
168         balances[_from]             = (balances[_from]).sub(_amount);
169         allowed[_from][msg.sender]  = (allowed[_from][msg.sender]).sub(_amount);
170         balances[_to]               = (balances[_to]).add(_amount);
171         Transfer (_from, _to, _amount);
172         return true;
173     }
174 
175     function transfer(address _to, uint256 _amount) public returns (bool success) {
176         require (_to != 0x0);
177         require (balances[msg.sender]       >= _amount && _amount >= 0);
178         balances[msg.sender]                = (balances[msg.sender]).sub(_amount);
179         balances[_to]                       = (balances[_to]).add(_amount);
180         Transfer (msg.sender, _to, _amount);
181         return true;
182     }
183     
184     function transferTokens(address _to, uint256 _amount) private returns (bool success) {
185         require (_to != 0x0);       
186         require (balances[address(this)]    >= _amount && _amount > 0);
187         balances[address(this)]             = (balances[address(this)]).sub(_amount);
188         balances[_to]                       = (balances[_to]).add(_amount);
189         Transfer (address(this), _to, _amount);
190         return true;
191     }
192  
193     function withdrawETH() external onlyOwner {
194         IFVOwner.transfer(this.balance);
195     }
196     
197     function approve(address _spender, uint256 _amount) public returns (bool success) {
198         require (_spender != 0x0);
199         allowed[msg.sender][_spender] = _amount;
200         Approval (msg.sender, _spender, _amount);
201         return true;
202     }
203   
204     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
205         require (_owner != 0x0 && _spender !=0x0);
206         return allowed[_owner][_spender];
207     }
208 
209     function totalSupply() public view returns (uint256 total_Supply) {
210         total_Supply                = _totalsupply;
211     }
212     
213     function balanceOf(address _owner) public view returns (uint256 balance) {
214         return balances[_owner];
215     }
216 }