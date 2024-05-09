1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
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
52 // 转0.01, 递减
53 contract SHE is ERC20 {
54 
55     using SafeMath for uint256;
56     address owner = msg.sender;
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     mapping (address => bool) public blacklist;
61 
62     string public constant name = "SHE";
63     string public constant symbol = "SHE";
64     uint public constant decimals = 18;
65 
66     uint256 public totalSupply = 1000000000e18;
67     uint256 public totalDistributed = 700000000e18;
68     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
69     uint256 public value = 8000e18;
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 
74     event Distr(address indexed to, uint256 amount);
75     event DistrFinished();
76 
77     event Burn(address indexed burner, uint256 value);
78 
79     bool public distributionFinished = false;
80 
81     modifier canDistr() {
82         require(!distributionFinished);
83         _;
84     }
85 
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     modifier onlyWhitelist() {
92         require(blacklist[msg.sender] == false);
93         _;
94     }
95 
96     modifier valueAccepted() {
97         require(msg.value%(1*10**16)==0);   // 0.01
98         _;
99     }
100 
101     constructor() public {
102         owner = msg.sender;
103         balances[owner] = totalDistributed;
104     }
105 
106     function transferOwnership(address newOwner) onlyOwner public {
107         if (newOwner != address(0)) {
108             owner = newOwner;
109         }
110     }
111 
112     function finishDistribution() onlyOwner canDistr public returns (bool) {
113         distributionFinished = true;
114         emit DistrFinished();
115         return true;
116     }
117 
118     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
119         totalDistributed = totalDistributed.add(_amount);
120         totalRemaining = totalRemaining.sub(_amount);
121         balances[_to] = balances[_to].add(_amount);
122         emit Distr(_to, _amount);
123         emit Transfer(address(0), _to, _amount);
124         return true;
125 
126         if (totalDistributed >= totalSupply) {
127             distributionFinished = true;
128         }
129     }
130 
131     function () external payable {
132         getTokens();
133     }
134 
135     function getTokens() payable canDistr onlyWhitelist valueAccepted public {
136         if (value > totalRemaining) {
137             value = totalRemaining;
138         }
139 
140         require(value <= totalRemaining);
141 
142         address investor = msg.sender;
143         uint256 toGive = value;
144 
145         distr(investor, toGive);
146 
147         if (toGive > 0) {
148             blacklist[investor] = true;
149         }
150 
151         if (totalDistributed >= totalSupply) {
152             distributionFinished = true;
153         }
154 
155         value = value.div(100000).mul(99999);
156 
157         uint256 etherBalance = this.balance;
158         if (etherBalance > 0) {
159             owner.transfer(etherBalance);
160         }
161 
162     }
163 
164     function balanceOf(address _owner) constant public returns (uint256) {
165         return balances[_owner];
166     }
167 
168     modifier onlyPayloadSize(uint size) {
169         assert(msg.data.length >= size + 4);
170         _;
171     }
172 
173     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
174         require(_to != address(0));
175         require(_amount <= balances[msg.sender]);
176 
177         balances[msg.sender] = balances[msg.sender].sub(_amount);
178         balances[_to] = balances[_to].add(_amount);
179         emit Transfer(msg.sender, _to, _amount);
180         return true;
181     }
182 
183     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
184         require(_to != address(0));
185         require(_amount <= balances[_from]);
186         require(_amount <= allowed[_from][msg.sender]);
187 
188         balances[_from] = balances[_from].sub(_amount);
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
190         balances[_to] = balances[_to].add(_amount);
191         emit Transfer(_from, _to, _amount);
192         return true;
193     }
194 
195     function approve(address _spender, uint256 _value) public returns (bool success) {
196         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
197         allowed[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     function allowance(address _owner, address _spender) constant public returns (uint256) {
203         return allowed[_owner][_spender];
204     }
205 
206     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
207         ForeignToken t = ForeignToken(tokenAddress);
208         uint bal = t.balanceOf(who);
209         return bal;
210     }
211 
212     function withdraw() onlyOwner public {
213         uint256 etherBalance = address(this).balance;
214         owner.transfer(etherBalance);
215     }
216 
217     function burn(uint256 _value) onlyOwner public {
218         require(_value <= balances[msg.sender]);
219 
220         address burner = msg.sender;
221         balances[burner] = balances[burner].sub(_value);
222         totalSupply = totalSupply.sub(_value);
223         totalDistributed = totalDistributed.sub(_value);
224         emit Burn(burner, _value);
225     }
226 
227     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
228         ForeignToken token = ForeignToken(_tokenContract);
229         uint256 amount = token.balanceOf(address(this));
230         return token.transfer(owner, amount);
231     }
232 }