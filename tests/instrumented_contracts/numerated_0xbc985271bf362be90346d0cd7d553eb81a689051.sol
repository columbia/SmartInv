1 pragma solidity ^0.4.22;
2 
3 // ----------------------------------------------------------------------------
4 // MoneyCash
5 //
6 // Symbol      : MCASH
7 // Name        : MoneyCash
8 // Total supply: 100000000
9 // Decimals    : 18
10 // ----------------------------------------------------------------------------
11 
12 // Send 0 ETH to this contract address
13 // You will get free MCASH
14 // Each wallet address can only claim 1 time 
15 
16 
17 
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46 }
47     
48 contract ForeignToken {
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
73 contract MoneyCash is ERC20 {
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
84     string public constant name = "MoneyCash";
85     string public constant symbol = "MCASH";
86     uint public constant decimals = 18;
87     
88 uint256 public totalSupply = 100000000e18;
89     
90 uint256 public totalDistributed = 30000000e18;
91     
92 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
93     
94 uint256 public value = 150e18;
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
123     function MCASH() onlyOwner public {
124         owner = msg.sender;
125         balances[owner] = totalDistributed;
126     }
127     
128     function finishDistribution() onlyOwner canDistr public returns (bool) {
129         distributionFinished = true;
130         emit DistrFinished();
131         return true;
132     }
133     
134     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
135         totalDistributed = totalDistributed.add(_amount);
136         totalRemaining = totalRemaining.sub(_amount);
137         balances[_to] = balances[_to].add(_amount);
138         emit Distr(_to, _amount);
139         emit Transfer(address(0), _to, _amount);
140         return true;
141         
142         if (totalDistributed >= totalSupply) {
143             distributionFinished = true;
144         }
145     }
146     
147     function () external payable {
148         getTokens();
149      }
150     
151     function getTokens() payable canDistr onlyWhitelist public {
152         if (value > totalRemaining) {
153             value = totalRemaining;
154         }
155         
156         require(value <= totalRemaining);
157         
158         address investor = msg.sender;
159         uint256 toGive = value;
160         
161         distr(investor, toGive);
162         
163         if (toGive > 0) {
164             blacklist[investor] = true;
165         }
166 
167         if (totalDistributed >= totalSupply) {
168             distributionFinished = true;
169         }
170         
171         value = value.div(100000).mul(99999);
172     }
173 
174     function balanceOf(address _owner) constant public returns (uint256) {
175         return balances[_owner];
176     }
177 
178     modifier onlyPayloadSize(uint size) {
179         assert(msg.data.length >= size + 4);
180         _;
181     }
182     
183     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
184         require(_to != address(0));
185         require(_amount <= balances[msg.sender]);
186         
187         balances[msg.sender] = balances[msg.sender].sub(_amount);
188         balances[_to] = balances[_to].add(_amount);
189         emit Transfer(msg.sender, _to, _amount);
190         return true;
191     }
192     
193     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
194         require(_to != address(0));
195         require(_amount <= balances[_from]);
196         require(_amount <= allowed[_from][msg.sender]);
197         
198         balances[_from] = balances[_from].sub(_amount);
199         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
200         balances[_to] = balances[_to].add(_amount);
201         emit Transfer(_from, _to, _amount);
202         return true;
203     }
204     
205     function approve(address _spender, uint256 _value) public returns (bool success) {
206         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
207         allowed[msg.sender][_spender] = _value;
208         emit Approval(msg.sender, _spender, _value);
209         return true;
210     }
211     
212     function allowance(address _owner, address _spender) constant public returns (uint256) {
213         return allowed[_owner][_spender];
214     }
215     
216     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
217         ForeignToken t = ForeignToken(tokenAddress);
218         uint bal = t.balanceOf(who);
219         return bal;
220     }
221     
222     function withdraw() onlyOwner public {
223         uint256 etherBalance = address(this).balance;
224         owner.transfer(etherBalance);
225     }
226     
227     function burn(uint256 _value) onlyOwner public {
228         require(_value <= balances[msg.sender]);
229 
230         address burner = msg.sender;
231         balances[burner] = balances[burner].sub(_value);
232         totalSupply = totalSupply.sub(_value);
233         totalDistributed = totalDistributed.sub(_value);
234         emit Burn(burner, _value);
235     }
236     
237     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
238         ForeignToken token = ForeignToken(_tokenContract);
239         uint256 amount = token.balanceOf(address(this));
240         return token.transfer(owner, amount);
241     }
242 }