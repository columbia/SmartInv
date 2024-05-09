1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a / b;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 
26 contract AltcoinToken {
27     function balanceOf(address _owner) constant public returns (uint256);
28     function transfer(address _to, uint256 _value) public returns (bool);
29 }
30 
31 contract ERC20Basic {
32     uint256 public totalSupply;
33     function balanceOf(address who) public constant returns (uint256);
34     function transfer(address to, uint256 value) public returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39     function allowance(address owner, address spender) public constant returns (uint256);
40     function transferFrom(address from, address to, uint256 value) public returns (bool);
41     function approve(address spender, uint256 value) public returns (bool);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract ADC is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52  mapping (address => bool) public blacklist;
53 
54     string public constant name = "AdsCoin";      
55     string public constant symbol = "ADC";       
56     uint public constant decimals = 8;           
57     uint256 public totalSupply = 2400000000e8;  
58  
59  uint256 public tokenPerETH = 500000e8;
60  uint256 public valueToGive = 1000e8;
61     uint256 public totalDistributed = 2400000000e8;       
62  uint256 public totalRemaining = totalSupply.sub(totalDistributed); 
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66     
67     event Distr(address indexed to, uint256 amount);
68     event DistrFinished();
69     
70     event Burn(address indexed burner, uint256 value);
71 
72     bool public distributionFinished = false;
73     
74     modifier canDistr() {
75         require(!distributionFinished);
76         _;
77     }
78     
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83     
84     function ADC() public {
85         owner=msg.sender;
86         balances[owner]=totalDistributed;
87     }
88     
89     function transferOwnership(address newOwner) onlyOwner public {
90         if (newOwner != address(0)) {
91             owner = newOwner;
92         }
93     }
94 
95     function finishDistribution() onlyOwner canDistr public returns (bool) {
96         distributionFinished = true;
97         emit DistrFinished();
98         return true;
99     }
100     
101     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
102         totalDistributed = totalDistributed.add(_amount);   
103   totalRemaining = totalRemaining.sub(_amount);  
104         balances[_to] = balances[_to].add(_amount);
105         emit Distr(_to, _amount);
106         emit Transfer(address(0), _to, _amount);
107 
108         return true;
109     }
110            
111     function () external payable {
112   address investor = msg.sender;
113   uint256 invest = msg.value;
114         
115   if(invest == 0){
116    require(valueToGive <= totalRemaining);
117    require(blacklist[investor] == false);
118    
119    uint256 toGive = valueToGive;
120    distr(investor, toGive);
121    
122             blacklist[investor] = true;
123         
124    valueToGive = valueToGive.div(10000).mul(9999);
125   }
126   
127   if(invest > 0){
128    buyToken(investor, invest);
129   }
130  }
131  
132  function buyToken(address _investor, uint256 _invest) canDistr public {
133   uint256 toGive = tokenPerETH.mul(_invest) / 1 ether;
134   uint256 bonus = 0;
135   
136   if(_invest >= 1 ether/100 && _invest < 1 ether/10){ //if 0,05
137    bonus = toGive*5/100;
138   }  
139   if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
140    bonus = toGive*10/100;
141   }  
142   if(_invest >= 1 ether){ //if 1
143    bonus = toGive*100/100;
144   }  
145   toGive = toGive.add(bonus);
146   
147   require(toGive <= totalRemaining);
148   
149   distr(_investor, toGive);
150  }
151     
152     function balanceOf(address _owner) constant public returns (uint256) {
153         return balances[_owner];
154     }
155 
156     modifier onlyPayloadSize(uint size) {
157         assert(msg.data.length >= size + 4);
158         _;
159     }
160     
161     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
162 
163         require(_to != address(0));
164         require(_amount <= balances[msg.sender]);
165         
166         balances[msg.sender] = balances[msg.sender].sub(_amount);
167         balances[_to] = balances[_to].add(_amount);
168         emit Transfer(msg.sender, _to, _amount);
169         return true;
170     }
171     
172     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
173 
174         require(_to != address(0));
175         require(_amount <= balances[_from]);
176         require(_amount <= allowed[_from][msg.sender]);
177         
178         balances[_from] = balances[_from].sub(_amount);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
180         balances[_to] = balances[_to].add(_amount);
181         emit Transfer(_from, _to, _amount);
182         return true;
183     }
184     
185     function approve(address _spender, uint256 _value) public returns (bool success) {
186         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
187         allowed[msg.sender][_spender] = _value;
188         emit Approval(msg.sender, _spender, _value);
189         return true;
190     }
191     
192     function allowance(address _owner, address _spender) constant public returns (uint256) {
193         return allowed[_owner][_spender];
194     }
195     
196     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
197         AltcoinToken t = AltcoinToken(tokenAddress);
198         uint bal = t.balanceOf(who);
199         return bal;
200     }
201     
202     function withdraw() onlyOwner public {
203         address myAddress = this;
204         uint256 etherBalance = myAddress.balance;
205         owner.transfer(etherBalance);
206     }
207     
208     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
209         AltcoinToken token = AltcoinToken(_tokenContract);
210         uint256 amount = token.balanceOf(address(this));
211         return token.transfer(owner, amount);
212     }
213  
214  function burn(uint256 _value) onlyOwner public {
215         require(_value <= balances[msg.sender]);
216         
217         address burner = msg.sender;
218         balances[burner] = balances[burner].sub(_value);
219         totalSupply = totalSupply.sub(_value);
220         totalDistributed = totalDistributed.sub(_value);
221         emit Burn(burner, _value);
222     }
223  
224  function burnFrom(uint256 _value, address _burner) onlyOwner public {
225         require(_value <= balances[_burner]);
226         
227         balances[_burner] = balances[_burner].sub(_value);
228         totalSupply = totalSupply.sub(_value);
229         totalDistributed = totalDistributed.sub(_value);
230         emit Burn(_burner, _value);
231     }
232 }