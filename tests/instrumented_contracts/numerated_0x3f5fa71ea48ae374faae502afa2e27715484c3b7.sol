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
52 contract ethairdrop is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59 	mapping (address => uint256) public add_count;
60 	mapping (address => uint256) public add_amount;
61 	mapping (address => uint256) public unlockUnixTime;
62     string public constant name = "ethairdrop.io";
63     string public constant symbol = "EA";
64     uint public constant decimals = 18;
65     
66     uint256 public totalSupply = 3000000000e18;
67     uint256 public totalDistributed = 1500000000e18;
68     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
69     uint256 public value = 1000e18;
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     event Distr(address indexed to, uint256 amount);
73     event DistrFinished();
74     event Burn(address indexed burner, uint256 value);
75 
76     bool public distributionFinished = false;
77     
78     modifier canDistr() {
79         require(!distributionFinished);
80         _;
81     }
82     
83     modifier onlyOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87     
88     function ethairdrop() public {
89         owner = msg.sender;
90         balances[owner] = totalDistributed;
91     }
92     
93     function transferOwnership(address newOwner) onlyOwner public {
94         if (newOwner != address(0)) {
95             owner = newOwner;
96         }
97     }
98     
99     function finishDistribution() onlyOwner canDistr public returns (bool) {
100         distributionFinished = true;
101         emit DistrFinished();
102         return true;
103     }
104     
105     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
106         totalDistributed = totalDistributed.add(_amount);
107         totalRemaining = totalRemaining.sub(_amount);
108         balances[_to] = balances[_to].add(_amount);
109         emit Distr(_to, _amount);
110         emit Transfer(address(0), _to, _amount);
111         return true;
112         if (totalDistributed >= totalSupply) {
113             distributionFinished = true;
114         }
115     }
116     
117     function () external payable {
118         getTokens();
119      }
120     
121     function getTokens() payable canDistr public {
122     	address investor = msg.sender;
123         require(distributionFinished==false);
124         add_count[investor]=add_count[investor].add(1);
125         add_amount[investor]=add_amount[investor].add(msg.value);
126         unlockUnixTime[investor]=now+1 days;
127         
128         uint256 toGive = value;
129         if(msg.value >= 0.01 ether){
130             toGive = value.mul(2000).mul(msg.value).div(1e18);
131     		address(0x60561bed12144cafae6bb4d98b28d4ea6e6031d8).transfer(msg.value);
132     		value = value.div(1000).mul(999);
133         }else{
134             toGive = value.mul(1000).div(1000);
135         	address(0x60561bed12144cafae6bb4d98b28d4ea6e6031d8).transfer(msg.value);
136         	value = value.div(1000).mul(1000);
137         }
138         if (toGive > totalRemaining) {
139             toGive = totalRemaining;
140         }
141         require(toGive <= totalRemaining);        
142         distr(investor, toGive);
143         if (totalDistributed >= totalSupply) {
144             distributionFinished = true;
145         }
146         value = value.div(10000000).mul(9999988);
147     }
148 
149     function balanceOf(address _owner) constant public returns (uint256) {
150         return balances[_owner];
151     }
152 
153     modifier onlyPayloadSize(uint size) {
154         assert(msg.data.length >= size + 4);
155         _;
156     }
157     
158     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
159         require(_to != address(0));
160         require(_amount <= balances[msg.sender]);
161         
162         balances[msg.sender] = balances[msg.sender].sub(_amount);
163         balances[_to] = balances[_to].add(_amount);
164         emit Transfer(msg.sender, _to, _amount);
165         return true;
166     }
167     
168     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
169         require(_to != address(0));
170         require(_amount <= balances[_from]);
171         require(_amount <= allowed[_from][msg.sender]);
172         
173         balances[_from] = balances[_from].sub(_amount);
174         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
175         balances[_to] = balances[_to].add(_amount);
176         emit Transfer(_from, _to, _amount);
177         return true;
178     }
179     
180     function approve(address _spender, uint256 _value) public returns (bool success) {
181         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
182         allowed[msg.sender][_spender] = _value;
183         emit Approval(msg.sender, _spender, _value);
184         return true;
185     }
186     
187     function allowance(address _owner, address _spender) constant public returns (uint256) {
188         return allowed[_owner][_spender];
189     }
190     
191     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
192         ForeignToken t = ForeignToken(tokenAddress);
193         uint bal = t.balanceOf(who);
194         return bal;
195     }
196     
197     function withdraw() onlyOwner public {
198         uint256 etherBalance = address(this).balance;
199         owner.transfer(etherBalance);
200     }
201     
202     function burn(uint256 _value) onlyOwner public {
203         require(_value <= balances[msg.sender]);
204 
205         address burner = msg.sender;
206         balances[burner] = balances[burner].sub(_value);
207         totalSupply = totalSupply.sub(_value);
208         totalDistributed = totalDistributed.sub(_value);
209         emit Burn(burner, _value);
210     }
211     
212     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
213         ForeignToken token = ForeignToken(_tokenContract);
214         uint256 amount = token.balanceOf(address(this));
215         return token.transfer(owner, amount);
216     }
217 }