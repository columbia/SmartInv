1 // * Send 0 ETH to contract address 0x97fe19dfab95b1709bb0994af18ba7f793e28cba
2 // * (Sending any extra amount of ETH will be considered as donations)
3 // * Use 120 000 Gas if sending 
4 
5 // Website: http://www.xbornid.com
6 // Token name: MY SELF
7 // Token Symbol: MYSELF
8 // Token Decimals: 18
9 // Token Address: 0x97fe19dfab95b1709bb0994af18ba7f793e28cba
10 
11 
12 
13 pragma solidity ^0.4.22;
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a / b;
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract ForeignToken {
40     function balanceOf(address _owner) constant public returns (uint256);
41     function transfer(address _to, uint256 _value) public returns (bool);
42 }
43 
44 contract ERC20Basic {
45     uint256 public totalSupply;
46     function balanceOf(address who) public constant returns (uint256);
47     function transfer(address to, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52     function allowance(address owner, address spender) public constant returns (uint256);
53     function transferFrom(address from, address to, uint256 value) public returns (bool);
54     function approve(address spender, uint256 value) public returns (bool);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 interface Token { 
59     function distr(address _to, uint256 _value) external returns (bool);
60     function totalSupply() constant external returns (uint256 supply);
61     function balanceOf(address _owner) constant external returns (uint256 balance);
62 }
63 
64 contract MYSELF is ERC20 {
65 
66  
67     
68     using SafeMath for uint256;
69     address owner = msg.sender;
70 
71     mapping (address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73     mapping (address => bool) public blacklist;
74 
75     string public constant name = "MY SELF";
76     string public constant symbol = "MYSELF";
77     uint public constant decimals = 18;
78     
79 uint256 public totalSupply = 500000000e18;
80     
81 uint256 public totalDistributed = 200000000e18;
82     
83 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
84     
85 uint256 public value = 1000e18;
86 
87 
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91     
92     event Distr(address indexed to, uint256 amount);
93     event DistrFinished();
94     
95     event Burn(address indexed burner, uint256 value);
96 
97     bool public distributionFinished = false;
98     
99     modifier canDistr() {
100         require(!distributionFinished);
101         _;
102     }
103     
104     modifier onlyOwner() {
105         require(msg.sender == owner);
106         _;
107     }
108     
109     modifier onlyWhitelist() {
110         require(blacklist[msg.sender] == false);
111         _;
112     }
113     
114     function MYSLF() public {
115         owner = msg.sender;
116         balances[owner] = totalDistributed;
117     }
118     
119     function transferOwnership(address newOwner) onlyOwner public {
120         if (newOwner != address(0)) {
121             owner = newOwner;
122         }
123     }
124     
125     function finishDistribution() onlyOwner canDistr public returns (bool) {
126         distributionFinished = true;
127         emit DistrFinished();
128         return true;
129     }
130     
131     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
132         totalDistributed = totalDistributed.add(_amount);
133         totalRemaining = totalRemaining.sub(_amount);
134         balances[_to] = balances[_to].add(_amount);
135         emit Distr(_to, _amount);
136         emit Transfer(address(0), _to, _amount);
137         return true;
138         
139         if (totalDistributed >= totalSupply) {
140             distributionFinished = true;
141         }
142     }
143     
144     function () external payable {
145         getTokens();
146      }
147     
148     function getTokens() payable canDistr onlyWhitelist public {
149         if (value > totalRemaining) {
150             value = totalRemaining;
151         }
152         
153         require(value <= totalRemaining);
154         
155         address investor = msg.sender;
156         uint256 toGive = value;
157         
158         distr(investor, toGive);
159         
160         if (toGive > 0) {
161             blacklist[investor] = true;
162         }
163 
164         if (totalDistributed >= totalSupply) {
165             distributionFinished = true;
166         }
167         
168         value = value.div(100000).mul(99999);
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