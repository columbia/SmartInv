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
50     // string public constant name = "Abc Token";
51     string public constant name = "ShipBloc Token";
52 
53     // string public constant symbol = "ABCT";
54     string public constant symbol = "SBLOC";
55 
56     uint8 public constant decimals = 18;
57 
58     uint256 public constant totalsupply = 82500000 * (10 ** 18);
59     uint256 public constant teamAllocated = 14025000 * (10 ** 18);
60     uint256 public constant maxPreSale1Token = 15000000 * (10 ** 18);
61     uint256 public constant maxPreSale2Token = 30000000 * (10 ** 18);
62     uint256 public totalUsedTokens = 0;
63       
64     mapping(address => uint256) balances;
65 
66     mapping(address => mapping(address => uint256)) allowed;
67     
68     address owner = 0xA7A58F56258F9a6540e4A8ebfde617F752A56094;
69     
70     event supply(uint256 bnumber);
71 
72     event events(string _name);
73     
74     uint256 public no_of_tokens;
75     
76     uint preICO1Start;
77     uint preICO1End;
78     uint preICO2Start;
79     uint preICO2End;
80     uint ICOStart;
81     uint ICOEnd;
82     
83     enum Stages {
84         NOTSTARTED,
85         PREICO1,
86         PREICO2,
87         ICO,
88         ENDED
89     }
90     
91     mapping(uint => Stages) stage;
92 
93     modifier onlyOwner() {
94         if (msg.sender != owner) {
95             revert();
96         }
97         _;
98     }
99    
100     function ShipBloc(uint _preICO1Start,uint _preICO1End,uint _preICO2Start,uint _preICO2End,uint _ICOStart,uint _ICOEnd) public {
101         balances[owner] = teamAllocated;      
102         balances[address(this)] = SafeMath.sub(totalsupply,teamAllocated);
103         stage[0]=Stages.NOTSTARTED;
104         stage[1667]=Stages.PREICO1;
105         stage[1000]=Stages.PREICO2;
106         stage[715]=Stages.ICO;
107         stage[1]=Stages.ENDED;
108         preICO1Start=_preICO1Start;
109         preICO1End=_preICO1End;
110         preICO2Start=_preICO2Start;
111         preICO2End=_preICO2End;
112         ICOStart=_ICOStart;
113         ICOEnd=_ICOEnd;
114     }
115     
116     function () public payable {
117         require(msg.value != 0);
118         uint256 _price_tokn = checkStage();
119         if(stage[_price_tokn] != Stages.NOTSTARTED && stage[_price_tokn] != Stages.ENDED) {
120             no_of_tokens = SafeMath.mul(msg.value , _price_tokn); 
121             if(balances[address(this)] >= no_of_tokens ) {
122                 totalUsedTokens = SafeMath.add(totalUsedTokens,no_of_tokens);
123                 balances[address(this)] =SafeMath.sub(balances[address(this)],no_of_tokens);
124                 balances[msg.sender] = SafeMath.add(balances[msg.sender],no_of_tokens);
125                 Transfer(address(this), msg.sender, no_of_tokens);
126                 owner.transfer(this.balance);
127             } else {
128                 revert();
129             }
130         } else {
131             revert();
132         }
133    }
134     
135     function totalSupply() public constant returns(uint256) {
136        return totalsupply;
137     }
138     
139      function balanceOf(address sender) public constant returns(uint256 balance) {
140         return balances[sender];
141     }
142 
143     
144     function transfer(address _to, uint256 _amount) public returns(bool success) {
145         require(stage[checkStage()] == Stages.ENDED);
146         if (balances[msg.sender] >= _amount &&
147             _amount > 0 &&
148             balances[_to] + _amount > balances[_to]) {
149          
150             balances[msg.sender] = SafeMath.sub(balances[msg.sender],_amount);
151             balances[_to] = SafeMath.add(balances[_to],_amount);
152             Transfer(msg.sender, _to, _amount);
153 
154             return true;
155         } else {
156             return false;
157         }
158     }
159     
160     function checkStage() internal view returns(uint) {
161         uint currentBlock = block.number;
162         if (currentBlock < preICO1Start){
163             return 0;    
164         } else if (currentBlock < preICO1End) {
165             require(maxPreSale1Token>totalUsedTokens);
166             return 1667;    
167         } else if (currentBlock < preICO2Start) {
168             return 0;    
169         } else if (currentBlock < preICO2End) {
170             require(maxPreSale2Token>totalUsedTokens);
171             return 1000;    
172         } else if (currentBlock < ICOStart) {
173             return 0;
174         } else if (currentBlock < ICOEnd) {
175             return 715;    
176         }
177         return 1;
178     }
179     
180     function getStageandPrice() public view returns(uint,uint){
181         return (checkStage(),uint(stage[checkStage()]));
182     }
183    
184     function transferFrom(
185         address _from,
186         address _to,
187         uint256 _amount
188     ) public returns(bool success) {
189             require(stage[checkStage()] == Stages.ENDED);
190             require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);    
191                 
192             balances[_from] = SafeMath.sub(balances[_from],_amount);
193             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _amount);
194             balances[_to] = SafeMath.add(balances[_to], _amount);
195             Transfer(_from, _to, _amount);
196             
197             return true;
198        
199     }
200 
201     function approve(address _spender, uint256 _value) public returns (bool) {
202         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
203         allowed[msg.sender][_spender] = _value;
204         Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
209         return allowed[_owner][_spender];
210     }
211 
212     function drain() external onlyOwner {
213         owner.transfer(this.balance);
214     }
215 
216     function drainToken() external onlyOwner {
217         require(stage[checkStage()] == Stages.ENDED);
218         balances[owner] = SafeMath.add(balances[owner],balances[address(this)]);
219         Transfer(address(this), owner, balances[address(this)]);
220         balances[address(this)] = 0;
221     }
222 
223 }