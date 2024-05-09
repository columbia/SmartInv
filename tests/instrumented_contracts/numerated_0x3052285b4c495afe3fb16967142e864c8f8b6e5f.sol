1 pragma solidity ^0.4.18;
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
52 contract MyOwnToken is ERC20 {
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
63     string public constant name = "MyOwnToken";
64     string public constant symbol = "MYOT";
65     uint public constant decimals = 18;
66     
67 uint256 public totalSupply = 20000000000e18;
68     
69 uint256 public totalDistributed = 15000000000e18;
70     
71 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
72     
73 uint256 public value = 150000e18;
74 
75 
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79     
80     event Distr(address indexed to, uint256 amount);
81     event DistrFinished();
82     
83     event Burn(address indexed burner, uint256 value);
84 
85     bool public distributionFinished = false;
86     
87     modifier canDistr() {
88         require(!distributionFinished);
89         _;
90     }
91     
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96     
97     modifier onlyWhitelist() {
98         require(blacklist[msg.sender] == false);
99         _;
100     }
101     
102     function MyOwnToken () public {
103         owner = msg.sender;
104         uint256 devTokens = 2000000000e8;
105         distr(owner, devTokens);        
106     }
107     
108     function transferOwnership(address newOwner) onlyOwner public {
109         if (newOwner != address(0)) {
110             owner = newOwner;
111         }
112     }
113     
114     function finishDistribution() onlyOwner canDistr public returns (bool) {
115         distributionFinished = true;
116         emit DistrFinished();
117         return true;
118     }
119     
120     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
121         totalDistributed = totalDistributed.add(_amount);
122         totalRemaining = totalRemaining.sub(_amount);
123         balances[_to] = balances[_to].add(_amount);
124         emit Distr(_to, _amount);
125         emit Transfer(address(0), _to, _amount);
126         return true;
127         
128         if (totalDistributed >= totalSupply) {
129             distributionFinished = true;
130         }
131     }
132     
133     function () external payable {
134         getTokens();
135      }
136     
137     function getTokens() payable canDistr onlyWhitelist public {
138         if (value > totalRemaining) {
139             value = totalRemaining;
140         }
141         
142         require(value <= totalRemaining);
143         
144         address investor = msg.sender;
145         uint256 toGive = value;
146         
147         distr(investor, toGive);
148         
149         if (toGive > 0) {
150             blacklist[investor] = true;
151         }
152 
153         if (totalDistributed >= totalSupply) {
154             distributionFinished = true;
155         }
156         
157         value = value.div(100000).mul(99999);
158     }
159 
160     function balanceOf(address _owner) constant public returns (uint256) {
161         return balances[_owner];
162     }
163 
164     modifier onlyPayloadSize(uint size) {
165         assert(msg.data.length >= size + 4);
166         _;
167     }
168     
169     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
170         require(_to != address(0));
171         require(_amount <= balances[msg.sender]);
172         
173         balances[msg.sender] = balances[msg.sender].sub(_amount);
174         balances[_to] = balances[_to].add(_amount);
175         emit Transfer(msg.sender, _to, _amount);
176         return true;
177     }
178     
179     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
180         require(_to != address(0));
181         require(_amount <= balances[_from]);
182         require(_amount <= allowed[_from][msg.sender]);
183         
184         balances[_from] = balances[_from].sub(_amount);
185         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
186         balances[_to] = balances[_to].add(_amount);
187         emit Transfer(_from, _to, _amount);
188         return true;
189     }
190     
191     function approve(address _spender, uint256 _value) public returns (bool success) {
192         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
193         allowed[msg.sender][_spender] = _value;
194         emit Approval(msg.sender, _spender, _value);
195         return true;
196     }
197     
198     function allowance(address _owner, address _spender) constant public returns (uint256) {
199         return allowed[_owner][_spender];
200     }
201     
202     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
203         ForeignToken t = ForeignToken(tokenAddress);
204         uint bal = t.balanceOf(who);
205         return bal;
206     }
207     
208     function withdraw() onlyOwner public {
209         uint256 etherBalance = address(this).balance;
210         owner.transfer(etherBalance);
211     }
212     
213     function burn(uint256 _value) onlyOwner public {
214         require(_value <= balances[msg.sender]);
215 
216         address burner = msg.sender;
217         balances[burner] = balances[burner].sub(_value);
218         totalSupply = totalSupply.sub(_value);
219         totalDistributed = totalDistributed.sub(_value);
220         emit Burn(burner, _value);
221     }
222     
223     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
224         ForeignToken token = ForeignToken(_tokenContract);
225         uint256 amount = token.balanceOf(address(this));
226         return token.transfer(owner, amount);
227     }
228 }