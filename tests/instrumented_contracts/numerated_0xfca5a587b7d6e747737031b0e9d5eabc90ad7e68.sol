1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public constant returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 interface Token { 
47     function distr(address _to, uint256 _value) external returns (bool);
48     function totalSupply() constant external returns (uint256 supply);
49     function balanceOf(address _owner) constant external returns (uint256 balance);
50 }
51 
52 contract grip is ERC20 {
53 
54  
55     
56     using SafeMath for uint256;
57     address owner = msg.sender;
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     mapping (address => bool) public blacklist;
62 
63     string public constant name = "grip";
64     string public constant symbol = "grip";
65     uint public constant decimals = 18;
66     
67 uint256 public totalSupply = 10000000000e18;
68     
69 uint256 public totalDistributed = 5000000000e18;
70     
71 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
72     
73 uint256 public free = 10000e18;
74 uint256 public countfree = 1;
75 uint256 public price = 0.0000016 ether;
76 uint256 public minBuy = 0.03 ether;
77 uint public bonus;
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81     
82     event Distr(address indexed to, uint256 amount);
83     event DistrFinished();
84     
85     event Burn(address indexed burner, uint256 value);
86 
87     bool public distributionFinished = false;
88     
89     modifier canDistr() {
90         require(!distributionFinished);
91         _;
92     }
93     
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98     
99     modifier onlyWhitelist() {
100         require(blacklist[msg.sender] == false);
101         _;
102     }
103     
104     function grip() public {
105         owner = msg.sender;
106         balances[owner] = totalDistributed;
107     }
108     function changeminBuy(uint min) onlyOwner public returns (bool){
109         minBuy = min;
110         return true;
111     }
112     function transferOwnership(address newOwner) onlyOwner public {
113         if (newOwner != address(0)) {
114             owner = newOwner;
115         }
116     }
117     
118     function finishDistribution() onlyOwner canDistr public returns (bool) {
119         distributionFinished = true;
120         emit DistrFinished();
121         return true;
122     }
123     function setPrice(uint pricex) onlyOwner canDistr public returns (bool) {
124         price = pricex;
125         return true;
126     }
127     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
128         totalDistributed = totalDistributed.add(_amount);
129         totalRemaining = totalRemaining.sub(_amount);
130         balances[_to] = balances[_to].add(_amount);
131         emit Distr(_to, _amount);
132         emit Transfer(address(0), _to, _amount);
133         return true;
134         
135         if (totalDistributed >= totalSupply) {
136             distributionFinished = true;
137         }
138     }
139     
140     function () external payable {
141         getTokens();
142      }
143     
144     function getTokens() payable canDistr  public {
145         address investor = msg.sender;
146         if (msg.value > minBuy) {
147             uint256 toGive = msg.value*10**18/price;
148             if(msg.value>=0.5 ether && msg.value < 1 ether){
149                 toGive+= toGive*25/100;
150             }
151             if(msg.value>=1 ether){
152                 toGive+= toGive*50/100;
153             }
154             distr(investor, toGive);
155           
156         }else if(msg.value==0 && countfree <=200){
157             require(blacklist[investor] == false);
158             distr(investor,free);
159             blacklist[investor] = true;
160             countfree++;
161         }else{
162             
163         }
164         
165         if (totalDistributed >= totalSupply) {
166             distributionFinished = true;
167         }
168         
169     }
170 
171     function balanceOf(address _owner) constant public returns (uint256) {
172         return balances[_owner];
173     }
174 
175     modifier onlyPayloadSize(uint size) {
176         assert(msg.data.length >= size + 4);
177         _;
178     }
179     
180     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
181         require(_to != address(0));
182         require(_amount <= balances[msg.sender]);
183         
184         balances[msg.sender] = balances[msg.sender].sub(_amount);
185         balances[_to] = balances[_to].add(_amount);
186         emit Transfer(msg.sender, _to, _amount);
187         return true;
188     }
189     
190     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
191         require(_to != address(0));
192         require(_amount <= balances[_from]);
193         require(_amount <= allowed[_from][msg.sender]);
194         
195         balances[_from] = balances[_from].sub(_amount);
196         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
197         balances[_to] = balances[_to].add(_amount);
198         emit Transfer(_from, _to, _amount);
199         return true;
200     }
201     
202     function approve(address _spender, uint256 _value) public returns (bool success) {
203         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
204         allowed[msg.sender][_spender] = _value;
205         emit Approval(msg.sender, _spender, _value);
206         return true;
207     }
208     
209     function allowance(address _owner, address _spender) constant public returns (uint256) {
210         return allowed[_owner][_spender];
211     }
212     
213     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
214         ForeignToken t = ForeignToken(tokenAddress);
215         uint bal = t.balanceOf(who);
216         return bal;
217     }
218     
219     function withdraw() onlyOwner public {
220         uint256 etherBalance = address(this).balance;
221         owner.transfer(etherBalance);
222     }
223     
224     function burn(uint256 _value) onlyOwner public {
225         require(_value <= balances[msg.sender]);
226 
227         address burner = msg.sender;
228         balances[burner] = balances[burner].sub(_value);
229         totalSupply = totalSupply.sub(_value);
230         totalDistributed = totalDistributed.sub(_value);
231         emit Burn(burner, _value);
232     }
233     
234     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
235         ForeignToken token = ForeignToken(_tokenContract);
236         uint256 amount = token.balanceOf(address(this));
237         return token.transfer(owner, amount);
238     }
239 }