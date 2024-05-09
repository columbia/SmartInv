1 //IG - A unprecedented  prediction market of based decentralization network.
2 //Website:IGToken.net
3 
4 pragma solidity ^0.4.22;
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ForeignToken {
31     function balanceOf(address _owner) constant public returns (uint256);
32     function transfer(address _to, uint256 _value) public returns (bool);
33 }
34 
35 contract ERC20Basic {
36     uint256 public totalSupply;
37     function balanceOf(address who) public constant returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 is ERC20Basic {
43     function allowance(address owner, address spender) public constant returns (uint256);
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45     function approve(address spender, uint256 value) public returns (bool);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 interface Token { 
50     function distr(address _to, uint256 _value) external returns (bool);
51     function totalSupply() constant external returns (uint256 supply);
52     function balanceOf(address _owner) constant external returns (uint256 balance);
53 }
54 
55 contract IG is ERC20 {
56     
57     using SafeMath for uint256;
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     mapping (address => bool) public blacklist;
63 
64     string public constant name = "IG";
65     string public constant symbol = "IG";
66     uint public constant decimals = 18;
67     
68     uint256 public totalSupply = 10000000000e18;
69     uint256 public totalDistributed = 9000000000e18;
70     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
71     uint256 public value = 10000e18;
72 
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75     
76     event Distr(address indexed to, uint256 amount);
77     event DistrFinished();
78     
79     event Burn(address indexed burner, uint256 value);
80 
81     bool public distributionFinished = false;
82     
83     modifier canDistr() {
84         require(!distributionFinished);
85         _;
86     }
87     
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92     
93     modifier onlyWhitelist() {
94         require(blacklist[msg.sender] == false);
95         _;
96     }
97     
98     function IG() public {
99         owner = msg.sender;
100         balances[owner] = totalDistributed;
101     }
102     
103     function transferOwnership(address newOwner) onlyOwner public {
104         if (newOwner != address(0)) {
105             owner = newOwner;
106         }
107     }
108     
109     function finishDistribution() onlyOwner canDistr public returns (bool) {
110         distributionFinished = true;
111         emit DistrFinished();
112         return true;
113     }
114     
115     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
116         totalDistributed = totalDistributed.add(_amount);
117         totalRemaining = totalRemaining.sub(_amount);
118         balances[_to] = balances[_to].add(_amount);
119         emit Distr(_to, _amount);
120         emit Transfer(address(0), _to, _amount);
121         return true;
122         
123         if (totalDistributed >= totalSupply) {
124             distributionFinished = true;
125         }
126     }
127     
128     function () external payable {
129         getTokens();
130      }
131     
132     function getTokens() payable canDistr onlyWhitelist public {
133         if (value > totalRemaining) {
134             value = totalRemaining;
135         }
136         
137         require(value <= totalRemaining);
138         
139         address investor = msg.sender;
140         uint256 toGive = value;
141         
142         distr(investor, toGive);
143         
144         if (toGive > 0) {
145             blacklist[investor] = true;
146         }
147 
148         if (totalDistributed >= totalSupply) {
149             distributionFinished = true;
150         }
151         
152         value = value.div(100000).mul(99999);
153     }
154 
155     function balanceOf(address _owner) constant public returns (uint256) {
156         return balances[_owner];
157     }
158 
159     modifier onlyPayloadSize(uint size) {
160         assert(msg.data.length >= size + 4);
161         _;
162     }
163     
164     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
165         require(_to != address(0));
166         require(_amount <= balances[msg.sender]);
167         
168         balances[msg.sender] = balances[msg.sender].sub(_amount);
169         balances[_to] = balances[_to].add(_amount);
170         emit Transfer(msg.sender, _to, _amount);
171         return true;
172     }
173     
174     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
175         require(_to != address(0));
176         require(_amount <= balances[_from]);
177         require(_amount <= allowed[_from][msg.sender]);
178         
179         balances[_from] = balances[_from].sub(_amount);
180         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
181         balances[_to] = balances[_to].add(_amount);
182         emit Transfer(_from, _to, _amount);
183         return true;
184     }
185     
186     function approve(address _spender, uint256 _value) public returns (bool success) {
187         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
188         allowed[msg.sender][_spender] = _value;
189         emit Approval(msg.sender, _spender, _value);
190         return true;
191     }
192     
193     function allowance(address _owner, address _spender) constant public returns (uint256) {
194         return allowed[_owner][_spender];
195     }
196     
197     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
198         ForeignToken t = ForeignToken(tokenAddress);
199         uint bal = t.balanceOf(who);
200         return bal;
201     }
202     
203     function withdraw() onlyOwner public {
204         uint256 etherBalance = address(this).balance;
205         owner.transfer(etherBalance);
206     }
207     
208     function burn(uint256 _value) onlyOwner public {
209         require(_value <= balances[msg.sender]);
210 
211         address burner = msg.sender;
212         balances[burner] = balances[burner].sub(_value);
213         totalSupply = totalSupply.sub(_value);
214         totalDistributed = totalDistributed.sub(_value);
215         emit Burn(burner, _value);
216     }
217     
218     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
219         ForeignToken token = ForeignToken(_tokenContract);
220         uint256 amount = token.balanceOf(address(this));
221         return token.transfer(owner, amount);
222     }
223 }