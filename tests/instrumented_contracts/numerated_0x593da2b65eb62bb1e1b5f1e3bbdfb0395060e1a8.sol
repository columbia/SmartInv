1 pragma solidity ^ 0.4.18;
2 
3 contract ERC20 {
4   uint256 public totalsupply;
5   function totalSupply() public constant returns(uint256 _totalSupply);
6   function balanceOf(address who) public constant returns (uint256);
7   function allowance(address owner, address spender) public constant returns (uint256);
8   function transferFrom(address from, address to, uint256 value) public returns (bool ok);
9   function approve(address spender, uint256 value) public returns (bool ok);
10   function transfer(address to, uint256 value) public returns (bool ok);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) pure internal returns(uint256) {
21         uint256 c = a * b;
22         assert(a == 0 || c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) pure internal returns(uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) pure internal returns(uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) pure internal returns(uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract ShipBloc is ERC20 {
46     
47     using SafeMath
48     for uint256;
49     
50     
51     string public constant name = "ShipBloc Token";
52 
53     string public constant symbol = "SBLOC";
54 
55     uint8 public constant decimals = 18;
56 
57     uint256 public constant totalsupply = 82500000 * (10 ** 18);
58     uint256 public constant teamAllocated = 14025000 * (10 ** 18);
59     uint256 public constant maxPreSale1Token = 15000000 * (10 ** 18);
60     uint256 public constant maxPreSale2Token = 30000000 * (10 ** 18);
61     uint256 public totalUsedTokens = 0;
62       
63     mapping(address => uint256) balances;
64 
65     mapping(address => mapping(address => uint256)) allowed;
66     
67     address owner = 0x1067c593a9981eFF4a56056dD775627CBe9D9107;
68     
69     event supply(uint256 bnumber);
70 
71     event events(string _name);
72     
73     uint256 public no_of_tokens;
74     
75     uint preICO1Start;
76     uint preICO1End;
77     uint preICO2Start;
78     uint preICO2End;
79     uint ICOStart;
80     uint ICOEnd;
81     
82     enum Stages {
83         NOTSTARTED,
84         PREICO1,
85         PREICO2,
86         ICO,
87         ENDED
88     }
89     
90     mapping(uint => Stages) stage;
91 
92     modifier onlyOwner() {
93         if (msg.sender != owner) {
94             revert();
95         }
96         _;
97     }
98    
99     function ShipBloc(uint _preICO1Start,uint _preICO1End,uint _preICO2Start,uint _preICO2End,uint _ICOStart,uint _ICOEnd) public {
100         balances[owner] = teamAllocated;      
101         balances[address(this)] = SafeMath.sub(totalsupply,teamAllocated);
102         stage[0]=Stages.NOTSTARTED;
103         stage[1667]=Stages.PREICO1;
104         stage[1000]=Stages.PREICO2;
105         stage[715]=Stages.ICO;
106         stage[1]=Stages.ENDED;
107         preICO1Start=_preICO1Start;
108         preICO1End=_preICO1End;
109         preICO2Start=_preICO2Start;
110         preICO2End=_preICO2End;
111         ICOStart=_ICOStart;
112         ICOEnd=_ICOEnd;
113     }
114     
115     function () public payable {
116         require(msg.value != 0);
117         
118         uint256 _price_tokn = checkStage();
119         require(stage[_price_tokn] != Stages.NOTSTARTED && stage[_price_tokn] != Stages.ENDED);
120         
121         no_of_tokens = SafeMath.mul(msg.value , _price_tokn); 
122         
123         require(balances[address(this)] >= no_of_tokens);
124         
125         totalUsedTokens = SafeMath.add(totalUsedTokens,no_of_tokens);
126         balances[address(this)] =SafeMath.sub(balances[address(this)],no_of_tokens);
127         balances[msg.sender] = SafeMath.add(balances[msg.sender],no_of_tokens);
128         Transfer(address(this), msg.sender, no_of_tokens);
129         owner.transfer(this.balance);
130    }
131     
132     function totalSupply() public constant returns(uint256) {
133        return totalsupply;
134     }
135     
136      function balanceOf(address sender) public constant returns(uint256 balance) {
137         return balances[sender];
138     }
139 
140     
141     function transfer(address _to, uint256 _amount) public returns(bool success) {
142         require(_to != address(0));
143         require(stage[checkStage()] == Stages.ENDED);
144         if (balances[msg.sender] >= _amount &&
145             _amount > 0) {
146          
147             balances[msg.sender] = SafeMath.sub(balances[msg.sender],_amount);
148             balances[_to] = SafeMath.add(balances[_to],_amount);
149             Transfer(msg.sender, _to, _amount);
150 
151             return true;
152         } else {
153             return false;
154         }
155     }
156     
157     function checkStage() internal view returns(uint) {
158         uint currentBlock = block.number;
159         if (currentBlock < preICO1Start){
160             return 0;    
161         } else if (currentBlock < preICO1End) {
162             require(maxPreSale1Token>totalUsedTokens);
163             return 1667;    
164         } else if (currentBlock < preICO2Start) {
165             return 0;    
166         } else if (currentBlock < preICO2End) {
167             require(maxPreSale2Token>totalUsedTokens);
168             return 1000;    
169         } else if (currentBlock < ICOStart) {
170             return 0;
171         } else if (currentBlock < ICOEnd) {
172             return 715;    
173         }
174         return 1;
175     }
176     
177     function getStageandPrice() public view returns(uint,uint){
178         return (checkStage(),uint(stage[checkStage()]));
179     }
180    
181     function transferFrom(
182         address _from,
183         address _to,
184         uint256 _amount
185     ) public returns(bool success) {
186             require(_from != address(0) && _to != address(0));
187             require(stage[checkStage()] == Stages.ENDED);
188             require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);    
189                 
190             balances[_from] = SafeMath.sub(balances[_from],_amount);
191             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _amount);
192             balances[_to] = SafeMath.add(balances[_to], _amount);
193             Transfer(_from, _to, _amount);
194             
195             return true;
196        
197     }
198 
199     function approve(address _spender, uint256 _value) public returns (bool) {
200         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
201         allowed[msg.sender][_spender] = _value;
202         Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
207         return allowed[_owner][_spender];
208     }
209 
210     function drain() external onlyOwner {
211         owner.transfer(this.balance);
212     }
213 
214     function drainToken() external onlyOwner {
215         require(stage[checkStage()] == Stages.ENDED);
216         balances[owner] = SafeMath.add(balances[owner],balances[address(this)]);
217         Transfer(address(this), owner, balances[address(this)]);
218         balances[address(this)] = 0;
219     }
220 
221 }