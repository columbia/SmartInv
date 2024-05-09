1 /* 
2 @Charity Cash Coin
3 @2019 by Phoenex Team
4  */
5 pragma solidity ^0.4.22;
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ForeignToken {
32     function balanceOf(address _owner) constant public returns (uint256);
33     function transfer(address _to, uint256 _value) public returns (bool);
34 }
35 
36 contract ERC20Basic {
37     uint256 public totalSupply;
38     function balanceOf(address who) public constant returns (uint256);
39     function transfer(address to, uint256 value) public returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 contract ERC20 is ERC20Basic {
44     function allowance(address owner, address spender) public constant returns (uint256);
45     function transferFrom(address from, address to, uint256 value) public returns (bool);
46     function approve(address spender, uint256 value) public returns (bool);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 interface Token { 
51     function distr(address _to, uint256 _value) external returns (bool);
52     function totalSupply() constant external returns (uint256 supply);
53     function balanceOf(address _owner) constant external returns (uint256 balance);
54 }
55 
56 contract CharityCashCoin is ERC20 {
57 
58  
59     
60     using SafeMath for uint256;
61     address owner = msg.sender;
62 
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     mapping (address => bool) public blacklist;
66 
67     string public constant name = "CharityCashCoin";
68     string public constant symbol = "CRUX";
69     uint public constant decimals = 8;
70     
71 uint256 public totalSupply = 5000000000e8;
72     
73 uint256 public totalDistributed = 1000000000e8;
74     
75 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
76     
77 uint256 public value = 50000e8;
78 
79 
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83     
84     event Distr(address indexed to, uint256 amount);
85     event DistrFinished();
86     
87     event Burn(address indexed burner, uint256 value);
88 
89     bool public distributionFinished = false;
90     
91     modifier canDistr() {
92         require(!distributionFinished);
93         _;
94     }
95     
96     modifier onlyOwner() {
97         require(msg.sender == owner);
98         _;
99     }
100     
101     modifier onlyWhitelist() {
102         require(blacklist[msg.sender] == false);
103         _;
104     }
105     
106     function CharityCashCoin() public {
107         owner = msg.sender;
108         balances[owner] = totalDistributed;
109     }
110     
111     function transferOwnership(address newOwner) onlyOwner public {
112         if (newOwner != address(0)) {
113             owner = newOwner;
114         }
115     }
116     
117     function finishDistribution() onlyOwner canDistr public returns (bool) {
118         distributionFinished = true;
119         emit DistrFinished();
120         return true;
121     }
122     
123     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
124         totalDistributed = totalDistributed.add(_amount);
125         totalRemaining = totalRemaining.sub(_amount);
126         balances[_to] = balances[_to].add(_amount);
127         emit Distr(_to, _amount);
128         emit Transfer(address(0), _to, _amount);
129         return true;
130         
131         if (totalDistributed >= totalSupply) {
132             distributionFinished = true;
133         }
134     }
135     
136     function () external payable {
137         getTokens();
138      }
139     
140     function getTokens() payable canDistr onlyWhitelist public {
141         if (value > totalRemaining) {
142             value = totalRemaining;
143         }
144         
145         require(value <= totalRemaining);
146         
147         address investor = msg.sender;
148         uint256 toGive = value;
149         
150         distr(investor, toGive);
151         
152         if (toGive > 0) {
153             blacklist[investor] = true;
154         }
155 
156         if (totalDistributed >= totalSupply) {
157             distributionFinished = true;
158         }
159         
160         value = value.div(100000).mul(99999);
161     }
162 
163     function balanceOf(address _owner) constant public returns (uint256) {
164         return balances[_owner];
165     }
166 
167     modifier onlyPayloadSize(uint size) {
168         assert(msg.data.length >= size + 4);
169         _;
170     }
171     
172     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
173         require(_to != address(0));
174         require(_amount <= balances[msg.sender]);
175         
176         balances[msg.sender] = balances[msg.sender].sub(_amount);
177         balances[_to] = balances[_to].add(_amount);
178         emit Transfer(msg.sender, _to, _amount);
179         return true;
180     }
181     
182     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
183         require(_to != address(0));
184         require(_amount <= balances[_from]);
185         require(_amount <= allowed[_from][msg.sender]);
186         
187         balances[_from] = balances[_from].sub(_amount);
188         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
189         balances[_to] = balances[_to].add(_amount);
190         emit Transfer(_from, _to, _amount);
191         return true;
192     }
193     
194     function approve(address _spender, uint256 _value) public returns (bool success) {
195         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
196         allowed[msg.sender][_spender] = _value;
197         emit Approval(msg.sender, _spender, _value);
198         return true;
199     }
200     
201     function allowance(address _owner, address _spender) constant public returns (uint256) {
202         return allowed[_owner][_spender];
203     }
204     
205     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
206         ForeignToken t = ForeignToken(tokenAddress);
207         uint bal = t.balanceOf(who);
208         return bal;
209     }
210     
211     function withdraw() onlyOwner public {
212         uint256 etherBalance = address(this).balance;
213         owner.transfer(etherBalance);
214     }
215     
216     function burn(uint256 _value) onlyOwner public {
217         require(_value <= balances[msg.sender]);
218 
219         address burner = msg.sender;
220         balances[burner] = balances[burner].sub(_value);
221         totalSupply = totalSupply.sub(_value);
222         totalDistributed = totalDistributed.sub(_value);
223         emit Burn(burner, _value);
224     }
225     
226     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
227         ForeignToken token = ForeignToken(_tokenContract);
228         uint256 amount = token.balanceOf(address(this));
229         return token.transfer(owner, amount);
230     }
231 }