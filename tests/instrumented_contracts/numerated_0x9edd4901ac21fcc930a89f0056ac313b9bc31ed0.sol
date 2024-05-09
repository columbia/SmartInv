1 /*
2 @MiracleToken MIRC token
3 */
4 
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
56 contract MiracleToken is ERC20 {
57     
58     using SafeMath for uint256;
59     address owner = msg.sender;
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     mapping (address => bool) public blacklist;
64 
65     string public constant name = "Miracle Token";
66     string public constant symbol = "MIRC";
67     uint public constant decimals = 18;
68     
69     uint256 public totalSupply = 6660000000e18;
70     uint256 public totalDistributed = 6160000000e18;
71     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
72     uint256 public value = 10000e18;
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76     
77     event Distr(address indexed to, uint256 amount);
78     event DistrFinished();
79     
80     event Burn(address indexed burner, uint256 value);
81 
82     bool public distributionFinished = false;
83     
84     modifier canDistr() {
85         require(!distributionFinished);
86         _;
87     }
88     
89     modifier onlyOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93     
94     modifier onlyWhitelist() {
95         require(blacklist[msg.sender] == false);
96         _;
97     }
98     
99     function MiracleToken() public {
100         owner = msg.sender;
101         balances[owner] = totalDistributed;
102     }
103     
104     function transferOwnership(address newOwner) onlyOwner public {
105         if (newOwner != address(0)) {
106             owner = newOwner;
107         }
108     }
109     
110     function finishDistribution() onlyOwner canDistr public returns (bool) {
111         distributionFinished = true;
112         emit DistrFinished();
113         return true;
114     }
115     
116     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
117         totalDistributed = totalDistributed.add(_amount);
118         totalRemaining = totalRemaining.sub(_amount);
119         balances[_to] = balances[_to].add(_amount);
120         emit Distr(_to, _amount);
121         emit Transfer(address(0), _to, _amount);
122         return true;
123         
124         if (totalDistributed >= totalSupply) {
125             distributionFinished = true;
126         }
127     }
128     
129     function () external payable {
130         getTokens();
131      }
132     
133     function getTokens() payable canDistr onlyWhitelist public {
134         if (value > totalRemaining) {
135             value = totalRemaining;
136         }
137         
138         require(value <= totalRemaining);
139         
140         address investor = msg.sender;
141         uint256 toGive = value;
142         
143         distr(investor, toGive);
144         
145         if (toGive > 0) {
146             blacklist[investor] = true;
147         }
148 
149         if (totalDistributed >= totalSupply) {
150             distributionFinished = true;
151         }
152         
153         value = value.div(50000).mul(49999);
154     }
155 
156     function balanceOf(address _owner) constant public returns (uint256) {
157         return balances[_owner];
158     }
159 
160     modifier onlyPayloadSize(uint size) {
161         assert(msg.data.length >= size + 4);
162         _;
163     }
164     
165     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
166         require(_to != address(0));
167         require(_amount <= balances[msg.sender]);
168         
169         balances[msg.sender] = balances[msg.sender].sub(_amount);
170         balances[_to] = balances[_to].add(_amount);
171         emit Transfer(msg.sender, _to, _amount);
172         return true;
173     }
174     
175     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
176         require(_to != address(0));
177         require(_amount <= balances[_from]);
178         require(_amount <= allowed[_from][msg.sender]);
179         
180         balances[_from] = balances[_from].sub(_amount);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
182         balances[_to] = balances[_to].add(_amount);
183         emit Transfer(_from, _to, _amount);
184         return true;
185     }
186     
187     function approve(address _spender, uint256 _value) public returns (bool success) {
188         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193     
194     function allowance(address _owner, address _spender) constant public returns (uint256) {
195         return allowed[_owner][_spender];
196     }
197     
198     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
199         ForeignToken t = ForeignToken(tokenAddress);
200         uint bal = t.balanceOf(who);
201         return bal;
202     }
203     
204     function withdraw() onlyOwner public {
205         uint256 etherBalance = address(this).balance;
206         owner.transfer(etherBalance);
207     }
208     
209     function burn(uint256 _value) onlyOwner public {
210         require(_value <= balances[msg.sender]);
211 
212         address burner = msg.sender;
213         balances[burner] = balances[burner].sub(_value);
214         totalSupply = totalSupply.sub(_value);
215         totalDistributed = totalDistributed.sub(_value);
216         emit Burn(burner, _value);
217     }
218     
219     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
220         ForeignToken token = ForeignToken(_tokenContract);
221         uint256 amount = token.balanceOf(address(this));
222         return token.transfer(owner, amount);
223     }
224 }