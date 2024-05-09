1 pragma solidity ^0.4.22;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a / b;
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 contract ForeignToken {
29     function balanceOf(address _owner) constant public returns (uint256);
30     function transfer(address _to, uint256 _value) public returns (bool);
31 }
32 
33 contract ERC20Basic {
34     uint256 public totalSupply;
35     function balanceOf(address who) public constant returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41     function allowance(address owner, address spender) public constant returns (uint256);
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 interface Token { 
48     function distr(address _to, uint256 _value) external returns (bool);
49     function totalSupply() constant external returns (uint256 supply);
50     function balanceOf(address _owner) constant external returns (uint256 balance);
51 }
52 
53 contract Mintloot is ERC20 {
54 
55  
56     
57     using SafeMath for uint256;
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     mapping (address => bool) public blacklist;
63 
64     string public constant name = "Mintloot Token";
65     string public constant symbol = "ML";
66     uint public constant decimals = 18;
67     
68 uint256 public totalSupply = 10000000000e18;
69     
70 uint256 public totalDistributed = 7000000000e18;
71     
72 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
73     
74 uint256 public value = 35000e18;
75 
76 
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80     
81     event Distr(address indexed to, uint256 amount);
82     event DistrFinished();
83     
84     event Burn(address indexed burner, uint256 value);
85 
86     bool public distributionFinished = false;
87     
88     modifier canDistr() {
89         require(!distributionFinished);
90         _;
91     }
92     
93     modifier onlyOwner() {
94         require(msg.sender == owner);
95         _;
96     }
97     
98     modifier onlyWhitelist() {
99         require(blacklist[msg.sender] == false);
100         _;
101     }
102     
103     function Mintloot() public {
104         owner = msg.sender;
105         balances[owner] = totalDistributed;
106     }
107     
108     function transferOwnership(address newOwner) onlyOwner public {
109         if (newOwner != address(0)) {
110             owner = newOwner;
111         }
112     }
113     
114     function finishDistribution() onlyOwner canDistr public returns (bool) {
115         distributionFinished = true;
116         emit DistrFinished();
117         return true;
118     }
119     
120     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
121         totalDistributed = totalDistributed.add(_amount);
122         totalRemaining = totalRemaining.sub(_amount);
123         balances[_to] = balances[_to].add(_amount);
124         emit Distr(_to, _amount);
125         emit Transfer(address(0), _to, _amount);
126         return true;
127         
128         if (totalDistributed >= totalSupply) {
129             distributionFinished = true;
130         }
131     }
132     
133     function () external payable {
134         getTokens();
135      }
136     
137     function getTokens() payable canDistr onlyWhitelist public {
138         if (value > totalRemaining) {
139             value = totalRemaining;
140         }
141         
142         require(value <= totalRemaining);
143         
144         address investor = msg.sender;
145         uint256 toGive = value;
146         
147         distr(investor, toGive);
148         
149         if (toGive > 0) {
150             blacklist[investor] = true;
151         }
152 
153         if (totalDistributed >= totalSupply) {
154             distributionFinished = true;
155         }
156         
157         value = value.div(100000).mul(99999);
158     }
159 
160     function balanceOf(address _owner) constant public returns (uint256) {
161         return balances[_owner];
162     }
163 
164     modifier onlyPayloadSize(uint size) {
165         assert(msg.data.length >= size + 4);
166         _;
167     }
168     
169     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
170         require(_to != address(0));
171         require(_amount <= balances[msg.sender]);
172         
173         balances[msg.sender] = balances[msg.sender].sub(_amount);
174         balances[_to] = balances[_to].add(_amount);
175         emit Transfer(msg.sender, _to, _amount);
176         return true;
177     }
178     
179     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
180         require(_to != address(0));
181         require(_amount <= balances[_from]);
182         require(_amount <= allowed[_from][msg.sender]);
183         
184         balances[_from] = balances[_from].sub(_amount);
185         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
186         balances[_to] = balances[_to].add(_amount);
187         emit Transfer(_from, _to, _amount);
188         return true;
189     }
190     
191     function approve(address _spender, uint256 _value) public returns (bool success) {
192         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
193         allowed[msg.sender][_spender] = _value;
194         emit Approval(msg.sender, _spender, _value);
195         return true;
196     }
197     
198     function allowance(address _owner, address _spender) constant public returns (uint256) {
199         return allowed[_owner][_spender];
200     }
201     
202     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
203         ForeignToken t = ForeignToken(tokenAddress);
204         uint bal = t.balanceOf(who);
205         return bal;
206     }
207     
208     function withdraw() onlyOwner public {
209         uint256 etherBalance = address(this).balance;
210         owner.transfer(etherBalance);
211     }
212     
213     function burn(uint256 _value) onlyOwner public {
214         require(_value <= balances[msg.sender]);
215 
216         address burner = msg.sender;
217         balances[burner] = balances[burner].sub(_value);
218         totalSupply = totalSupply.sub(_value);
219         totalDistributed = totalDistributed.sub(_value);
220         emit Burn(burner, _value);
221     }
222     
223     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
224         ForeignToken token = ForeignToken(_tokenContract);
225         uint256 amount = token.balanceOf(address(this));
226         return token.transfer(owner, amount);
227     }
228 }