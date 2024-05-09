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
45 contract FreedomStreaming is ERC20
46 {
47     
48     using SafeMath
49     for uint256;
50     
51     string public constant name = "Freedom Token";
52 
53     string public constant symbol = "FDM";
54 
55     uint8 public constant decimals = 18;
56 
57     uint256 public constant totalsupply = 1000000000000000000000000000;
58       
59     mapping(address => uint256) balances;
60 
61     mapping(address => mapping(address => uint256)) allowed;
62     
63     address owner = 0x963cb5e7190FA77435AFe61FBb8C2dDB073e42c2;
64     
65     event supply(uint256 bnumber);
66 
67     event events(string _name);
68 
69     uint256 _price_tokn;
70     
71     bool stopped = true;
72 
73     uint256 no_of_tokens;
74     
75     enum Stages {
76         NOTSTARTED,
77         PREICO,
78         ICO,
79         PAUSED,
80         ENDED
81     }
82     
83     Stages public stage;
84     
85     bool ico_ended = false;
86 
87     modifier onlyOwner() {
88         if (msg.sender != owner) {
89             revert();
90         }
91         _;
92     }
93    
94     function FreedomStreaming() public
95     {
96         balances[owner] = 350000000000000000000000000;      
97         balances[address(this)] = 650000000000000000000000000;
98         stage = Stages.NOTSTARTED;
99     }
100     
101     function () public payable
102     {
103         if(!ico_ended && !stopped && msg.value >= 0.01 ether)
104         {
105             no_of_tokens = SafeMath.mul(msg.value , _price_tokn); 
106             if(balances[address(this)] >= no_of_tokens )
107             {
108         
109               balances[address(this)] =SafeMath.sub(balances[address(this)],no_of_tokens);
110               balances[msg.sender] = SafeMath.add(balances[msg.sender],no_of_tokens);
111               Transfer(address(this), msg.sender, no_of_tokens);
112               owner.transfer(this.balance); 
113    
114             }
115             else
116             {
117                 revert();
118             }
119         
120         }
121       else
122        {
123            revert();
124        }
125    }
126     
127     function totalSupply() public constant returns(uint256) {
128        return totalsupply;
129     }
130     
131      function balanceOf(address sender) public constant returns(uint256 balance) {
132         return balances[sender];
133     }
134 
135     
136     function transfer(address _to, uint256 _amount) public returns(bool success) {
137         if (balances[msg.sender] >= _amount &&
138             _amount > 0 &&
139             balances[_to] + _amount > balances[_to]) {
140          
141             balances[msg.sender] = SafeMath.sub(balances[msg.sender],_amount);
142             balances[_to] = SafeMath.add(balances[_to],_amount);
143             Transfer(msg.sender, _to, _amount);
144 
145             return true;
146         } else {
147             return false;
148         }
149     }
150     
151     
152     function pauseICOs() external onlyOwner {
153         stage = Stages.PAUSED;
154         stopped = true;
155     }
156 
157     
158     function Start_Resume_ICO() external onlyOwner {
159         stage = Stages.ICO;
160         stopped = false;
161         _price_tokn = 10000;
162     }
163     
164     
165      function Start_Resume_PreICO() external onlyOwner
166      {
167          stage = Stages.PREICO;
168          stopped = false;
169          _price_tokn = 12000;
170      }
171      
172      function end_ICOs() external onlyOwner
173      {
174          ico_ended = true;
175          stage = Stages.ENDED;
176      }
177     
178    
179     function transferFrom(
180         address _from,
181         address _to,
182         uint256 _amount
183     ) public returns(bool success) {
184 
185             require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);    
186                 
187             balances[_from] = SafeMath.sub(balances[_from],_amount);
188             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _amount);
189             balances[_to] = SafeMath.add(balances[_to], _amount);
190             Transfer(_from, _to, _amount);
191             
192             return true;
193        
194     }
195 
196   function approve(address _spender, uint256 _value) public returns (bool) {
197 
198     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
199 
200     allowed[msg.sender][_spender] = _value;
201     Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
206         return allowed[_owner][_spender];
207     }
208 
209     function drain() external onlyOwner {
210         owner.transfer(this.balance);
211     }
212 
213     function drainToken() external onlyOwner
214     {
215         require(ico_ended);
216         
217         balances[owner] = SafeMath.add(balances[owner],balances[address(this)]);
218         Transfer(address(this), owner, balances[address(this)]);
219         balances[address(this)] = 0;
220     }
221     
222 
223 }