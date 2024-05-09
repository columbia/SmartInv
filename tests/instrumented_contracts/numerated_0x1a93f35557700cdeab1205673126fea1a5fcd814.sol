1 pragma solidity ^0.4.22;
2 
3 // ----------------------------------------------------------------------------
4 // 'EDROP Token'
5 //
6 // NAME     : EDROP Token
7 // Symbol   : EDT
8 // Total supply: 2,000,000,000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 library SafeMath {
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a * b;
19     assert(a == 0 || c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b;
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract ForeignToken {
41     function balanceOf(address _owner) constant public returns (uint256);
42     function transfer(address _to, uint256 _value) public returns (bool);
43 }
44 
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) public constant returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 interface Token { 
60     function distr(address _to, uint256 _value) external returns (bool);
61     function totalSupply() constant external returns (uint256 supply);
62     function balanceOf(address _owner) constant external returns (uint256 balance);
63 }
64 
65 contract EDROP is ERC20 {
66     
67     using SafeMath for uint256;
68     address owner = msg.sender;
69 
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 	mapping (address => uint256) public add_count;
73 	mapping (address => uint256) public add_amount;
74 	mapping (address => uint256) public unlockUnixTime;
75     string public constant name = "EDROP Token";
76     string public constant symbol = "EDT";
77     uint public constant decimals = 18;
78     
79     uint256 public totalSupply = 2000000000e18;
80     uint256 public totalDistributed = 1000000000e18;
81     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
82     uint256 public value = 1000e18;
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85     event Distr(address indexed to, uint256 amount);
86     event DistrFinished();
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
101     function EDROP() public {
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
125         if (totalDistributed >= totalSupply) {
126             distributionFinished = true;
127         }
128     }
129     
130     function () external payable {
131         getTokens();
132      }
133     
134     function getTokens() payable canDistr public {
135     	address investor = msg.sender;
136         require(distributionFinished==false);
137         add_count[investor]=add_count[investor].add(1);
138         add_amount[investor]=add_amount[investor].add(msg.value);
139         unlockUnixTime[investor]=now+1 days;
140         
141         uint256 toGive = value;
142         if(msg.value >= 0.01 ether){
143             toGive = value.mul(2000).mul(msg.value).div(1e18);
144     		address(0x911803a47B97eca798a3e1D04C2Bf43c496A2C65).transfer(msg.value);
145     		value = value.div(1000).mul(999);
146         }else{
147             toGive = value.mul(1000).div(1000);
148         	address(0x911803a47B97eca798a3e1D04C2Bf43c496A2C65).transfer(msg.value);
149         	value = value.div(1000).mul(1000);
150         }
151         if (toGive > totalRemaining) {
152             toGive = totalRemaining;
153         }
154         require(toGive <= totalRemaining);        
155         distr(investor, toGive);
156         if (totalDistributed >= totalSupply) {
157             distributionFinished = true;
158         }
159         value = value.div(10000000).mul(9999988);
160     }
161 
162     function balanceOf(address _owner) constant public returns (uint256) {
163         return balances[_owner];
164     }
165 
166     modifier onlyPayloadSize(uint size) {
167         assert(msg.data.length >= size + 4);
168         _;
169     }
170     
171     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
172         require(_to != address(0));
173         require(_amount <= balances[msg.sender]);
174         
175         balances[msg.sender] = balances[msg.sender].sub(_amount);
176         balances[_to] = balances[_to].add(_amount);
177         emit Transfer(msg.sender, _to, _amount);
178         return true;
179     }
180     
181     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
182         require(_to != address(0));
183         require(_amount <= balances[_from]);
184         require(_amount <= allowed[_from][msg.sender]);
185         
186         balances[_from] = balances[_from].sub(_amount);
187         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
188         balances[_to] = balances[_to].add(_amount);
189         emit Transfer(_from, _to, _amount);
190         return true;
191     }
192     
193     function approve(address _spender, uint256 _value) public returns (bool success) {
194         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
195         allowed[msg.sender][_spender] = _value;
196         emit Approval(msg.sender, _spender, _value);
197         return true;
198     }
199     
200     function allowance(address _owner, address _spender) constant public returns (uint256) {
201         return allowed[_owner][_spender];
202     }
203     
204     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
205         ForeignToken t = ForeignToken(tokenAddress);
206         uint bal = t.balanceOf(who);
207         return bal;
208     }
209     
210     function withdraw() onlyOwner public {
211         uint256 etherBalance = address(this).balance;
212         owner.transfer(etherBalance);
213     }
214     
215     function burn(uint256 _value) onlyOwner public {
216         require(_value <= balances[msg.sender]);
217 
218         address burner = msg.sender;
219         balances[burner] = balances[burner].sub(_value);
220         totalSupply = totalSupply.sub(_value);
221         totalDistributed = totalDistributed.sub(_value);
222         emit Burn(burner, _value);
223     }
224     
225     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
226         ForeignToken token = ForeignToken(_tokenContract);
227         uint256 amount = token.balanceOf(address(this));
228         return token.transfer(owner, amount);
229     }
230 }