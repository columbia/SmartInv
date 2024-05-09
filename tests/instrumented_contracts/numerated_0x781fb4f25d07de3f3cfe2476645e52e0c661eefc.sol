1 pragma solidity ^0.4.22;
2 
3 // 
4 // Send 0 ETH to this contract address 
5 // you will get a free CCN
6 // every wallet address can only claim 1x
7 //
8 // Telegram : http://t.me/ccn_network
9 
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 contract CryptoCurrencyNetworkToken {
36     function balanceOf(address _owner) constant public returns (uint256);
37     function transfer(address _to, uint256 _value) public returns (bool);
38 }
39 
40 contract ERC20Basic {
41     uint256 public totalSupply;
42     function balanceOf(address who) public constant returns (uint256);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48     function allowance(address owner, address spender) public constant returns (uint256);
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50     function approve(address spender, uint256 value) public returns (bool);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 interface Token { 
55     function distr(address _to, uint256 _value) external returns (bool);
56     function totalSupply() constant external returns (uint256 supply);
57     function balanceOf(address _owner) constant external returns (uint256 balance);
58 }
59 
60 contract CryptoCurrencyNetwork is ERC20 {
61 
62  
63     
64     using SafeMath for uint256;
65     address owner = msg.sender;
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     mapping (address => bool) public blacklist;
70 
71     string public constant name = "CryptoCurrencyNetwork";
72     string public constant symbol = "CCN";
73     uint public constant decimals = 18;
74     
75 uint256 public totalSupply = 100000000e18;
76     
77 uint256 public totalDistributed = 15000000e18;
78     
79 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
80     
81 uint256 public value = 500e18;
82 
83 
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87     
88     event Distr(address indexed to, uint256 amount);
89     event DistrFinished();
90     
91     event Burn(address indexed burner, uint256 value);
92 
93     bool public distributionFinished = false;
94     
95     modifier canDistr() {
96         require(!distributionFinished);
97         _;
98     }
99     
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104     
105     modifier onlyWhitelist() {
106         require(blacklist[msg.sender] == false);
107         _;
108     }
109     
110     function CCN() public {
111         owner = msg.sender;
112         balances[owner] = totalDistributed;
113     }
114     
115     function transferOwnership(address newOwner) onlyOwner public {
116         if (newOwner != address(0)) {
117             owner = newOwner;
118         }
119     }
120     
121     function finishDistribution() onlyOwner canDistr public returns (bool) {
122         distributionFinished = true;
123         emit DistrFinished();
124         return true;
125     }
126     
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
144     function getTokens() payable canDistr onlyWhitelist public {
145         if (value > totalRemaining) {
146             value = totalRemaining;
147         }
148         
149         require(value <= totalRemaining);
150         
151         address investor = msg.sender;
152         uint256 toGive = value;
153         
154         distr(investor, toGive);
155         
156         if (toGive > 0) {
157             blacklist[investor] = true;
158         }
159 
160         if (totalDistributed >= totalSupply) {
161             distributionFinished = true;
162         }
163         
164         value = value.div(100000).mul(99999);
165     }
166 
167     function balanceOf(address _owner) constant public returns (uint256) {
168         return balances[_owner];
169     }
170 
171     modifier onlyPayloadSize(uint size) {
172         assert(msg.data.length >= size + 4);
173         _;
174     }
175     
176     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
177         require(_to != address(0));
178         require(_amount <= balances[msg.sender]);
179         
180         balances[msg.sender] = balances[msg.sender].sub(_amount);
181         balances[_to] = balances[_to].add(_amount);
182         emit Transfer(msg.sender, _to, _amount);
183         return true;
184     }
185     
186     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
187         require(_to != address(0));
188         require(_amount <= balances[_from]);
189         require(_amount <= allowed[_from][msg.sender]);
190         
191         balances[_from] = balances[_from].sub(_amount);
192         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
193         balances[_to] = balances[_to].add(_amount);
194         emit Transfer(_from, _to, _amount);
195         return true;
196     }
197     
198     function approve(address _spender, uint256 _value) public returns (bool success) {
199         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
200         allowed[msg.sender][_spender] = _value;
201         emit Approval(msg.sender, _spender, _value);
202         return true;
203     }
204     
205     function allowance(address _owner, address _spender) constant public returns (uint256) {
206         return allowed[_owner][_spender];
207     }
208     
209     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
210         CryptoCurrencyNetworkToken t = CryptoCurrencyNetworkToken(tokenAddress);
211         uint bal = t.balanceOf(who);
212         return bal;
213     }
214     
215     function withdraw() onlyOwner public {
216         uint256 etherBalance = address(this).balance;
217         owner.transfer(etherBalance);
218     }
219     
220     function burn(uint256 _value) onlyOwner public {
221         require(_value <= balances[msg.sender]);
222 
223         address burner = msg.sender;
224         balances[burner] = balances[burner].sub(_value);
225         totalSupply = totalSupply.sub(_value);
226         totalDistributed = totalDistributed.sub(_value);
227         emit Burn(burner, _value);
228     }
229     
230     function withdrawCryptoCurrencyNetworkTokens(address _tokenContract) onlyOwner public returns (bool) {
231         CryptoCurrencyNetworkToken token = CryptoCurrencyNetworkToken(_tokenContract);
232         uint256 amount = token.balanceOf(address(this));
233         return token.transfer(owner, amount);
234     }
235 }