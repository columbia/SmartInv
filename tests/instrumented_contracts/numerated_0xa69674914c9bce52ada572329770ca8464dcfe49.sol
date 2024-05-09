1 pragma solidity ^0.4.26;
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
52 contract AKACommunity is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "AKA Coin";
62     string public constant symbol = "AKA";
63     uint public constant decimals = 18;
64     
65     uint256 public totalSupply = 77000000000e18;
66     
67     uint256 public totalDistributed = 0;
68     
69     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
70     
71     uint256 public value = 170000e18;
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
98     constructor () public {
99         owner = msg.sender;
100         uint256 devTokens = 53900000000e18;
101         distr(owner, devTokens);        
102     }
103     
104     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
105         totalDistributed = totalDistributed.add(_amount);
106         totalRemaining = totalRemaining.sub(_amount);
107         balances[_to] = balances[_to].add(_amount);
108         emit Distr(_to, _amount);
109         emit Transfer(address(0), _to, _amount);
110         return true;
111         
112         if (totalDistributed >= totalSupply) {
113             distributionFinished = true;
114         }
115     }
116     
117     function () external payable {
118         getTokens();
119      }
120     
121     function getTokens() payable canDistr onlyWhitelist public {
122         if (value > totalRemaining) {
123             value = totalRemaining;
124         }
125         
126         require(value <= totalRemaining);
127         
128         address investor = msg.sender;
129         uint256 toGive = value;
130         
131         distr(investor, toGive);
132         
133         if (toGive > 0) {
134             blacklist[investor] = true;
135         }
136 
137         if (totalDistributed >= totalSupply) {
138             distributionFinished = true;
139         }
140         
141         value = value.div(100000).mul(99999);
142     }
143 
144     function balanceOf(address _owner) constant public returns (uint256) {
145         return balances[_owner];
146     }
147 
148     modifier onlyPayloadSize(uint size) {
149         assert(msg.data.length >= size + 4);
150         _;
151     }
152     
153     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
154         require(_to != address(0));
155         require(_amount <= balances[msg.sender]);
156         
157         balances[msg.sender] = balances[msg.sender].sub(_amount);
158         balances[_to] = balances[_to].add(_amount);
159         emit Transfer(msg.sender, _to, _amount);
160         return true;
161     }
162     
163     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
164         for (uint256 i = 0; i < receivers.length; i++) {
165         transfer(receivers[i], amounts[i]);
166         }
167     }
168     
169     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
170         require(_to != address(0));
171         require(_amount <= balances[_from]);
172         require(_amount <= allowed[_from][msg.sender]);
173         
174         balances[_from] = balances[_from].sub(_amount);
175         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
176         balances[_to] = balances[_to].add(_amount);
177         emit Transfer(_from, _to, _amount);
178         return true;
179     }
180     
181     function approve(address _spender, uint256 _value) public returns (bool success) {
182         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
183         allowed[msg.sender][_spender] = _value;
184         emit Approval(msg.sender, _spender, _value);
185         return true;
186     }
187     
188     function allowance(address _owner, address _spender) constant public returns (uint256) {
189         return allowed[_owner][_spender];
190     }
191     
192     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
193         ForeignToken t = ForeignToken(tokenAddress);
194         uint bal = t.balanceOf(who);
195         return bal;
196     }
197     
198     function withdraw() onlyOwner public {
199         uint256 etherBalance = address(this).balance;
200         owner.transfer(etherBalance);
201     }
202     
203     function burn(uint256 _value) onlyOwner public {
204         require(_value <= balances[msg.sender]);
205 
206         address burner = msg.sender;
207         balances[burner] = balances[burner].sub(_value);
208         totalSupply = totalSupply.sub(_value);
209         totalDistributed = totalDistributed.sub(_value);
210         emit Burn(burner, _value);
211     }
212     
213     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
214         ForeignToken token = ForeignToken(_tokenContract);
215         uint256 amount = token.balanceOf(address(this));
216         return token.transfer(owner, amount);
217     }
218 }