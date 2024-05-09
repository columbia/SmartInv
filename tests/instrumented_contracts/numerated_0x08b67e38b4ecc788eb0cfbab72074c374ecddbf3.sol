1 pragma solidity ^0.4.20;
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
47     function distr(address _to, uint256 _value) public returns (bool);
48     function totalSupply() constant public returns (uint256 supply);
49     function balanceOf(address _owner) constant public returns (uint256 balance);
50 }
51 
52 contract Bitlike is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "Bitlike";
62     string public constant symbol = "BLike";
63     uint public constant decimals = 4;
64     
65     uint256 public totalSupply = 760000000e4;
66     uint256 public totalDistributed = 6500000e4;
67     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
68     uint256 public value;
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     
73     event Distr(address indexed to, uint256 amount);
74     event DistrFinished();
75     
76     event Burn(address indexed burner, uint256 value);
77 
78     bool public distributionFinished = false;
79     
80     modifier canDistr() {
81         require(!distributionFinished);
82         _;
83     }
84     
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89     
90    
91     
92     function Bitlike () public {
93         owner = msg.sender;
94         value = 6500e4;
95         distr(owner, totalDistributed);
96     }
97     
98     function transferOwnership(address newOwner) onlyOwner public {
99         if (newOwner != address(0)) {
100             owner = newOwner;
101         }
102     }
103     
104    
105 
106    
107 
108     function finishDistribution() onlyOwner canDistr public returns (bool) {
109         distributionFinished = true;
110         DistrFinished();
111         return true;
112     }
113     
114     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
115         totalDistributed = totalDistributed.add(_amount);
116         totalRemaining = totalRemaining.sub(_amount);
117         balances[_to] = balances[_to].add(_amount);
118         Distr(_to, _amount);
119         Transfer(address(0), _to, _amount);
120         return true;
121         
122         if (totalDistributed >= totalSupply) {
123             distributionFinished = true;
124         }
125     }
126     
127     function airdrop(address[] addresses) onlyOwner canDistr public {
128         
129         require(addresses.length <= 255);
130         require(value <= totalRemaining);
131         
132         for (uint i = 0; i < addresses.length; i++) {
133             require(value <= totalRemaining);
134             distr(addresses[i], value);
135         }
136 	
137         if (totalDistributed >= totalSupply) {
138             distributionFinished = true;
139         }
140     }
141     
142     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
143         
144         require(addresses.length <= 255);
145         require(amount <= totalRemaining);
146         
147         for (uint i = 0; i < addresses.length; i++) {
148             require(amount <= totalRemaining);
149             distr(addresses[i], amount);
150         }
151 	
152         if (totalDistributed >= totalSupply) {
153             distributionFinished = true;
154         }
155     }
156     
157     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
158 
159         require(addresses.length <= 255);
160         require(addresses.length == amounts.length);
161         
162         for (uint8 i = 0; i < addresses.length; i++) {
163             require(amounts[i] <= totalRemaining);
164             distr(addresses[i], amounts[i]);
165             
166             if (totalDistributed >= totalSupply) {
167                 distributionFinished = true;
168             }
169         }
170     }
171     
172     function () external payable {
173             getTokens();
174      }
175     
176     function getTokens() payable canDistr public {
177         
178         if (value > totalRemaining) {
179             value = totalRemaining;
180         }
181         
182         require(value <= totalRemaining);
183         
184         address investor = msg.sender;
185         uint256 toGive = value;
186         
187         distr(investor, toGive);
188         
189         if (toGive > 0) {
190             blacklist[investor] = true;
191         }
192 
193         if (totalDistributed >= totalSupply) {
194             distributionFinished = true;
195         }
196         
197      
198     }
199 
200     function balanceOf(address _owner) constant public returns (uint256) {
201 	    return balances[_owner];
202     }
203 
204    
205     modifier onlyPayloadSize(uint size) {
206         assert(msg.data.length >= size + 4);
207         _;
208     }
209     
210     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
211 
212         require(_to != address(0));
213         require(_amount <= balances[msg.sender]);
214         
215         balances[msg.sender] = balances[msg.sender].sub(_amount);
216         balances[_to] = balances[_to].add(_amount);
217         Transfer(msg.sender, _to, _amount);
218         return true;
219     }
220     
221     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
222 
223         require(_to != address(0));
224         require(_amount <= balances[_from]);
225         require(_amount <= allowed[_from][msg.sender]);
226         
227         balances[_from] = balances[_from].sub(_amount);
228         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
229         balances[_to] = balances[_to].add(_amount);
230         Transfer(_from, _to, _amount);
231         return true;
232     }
233     
234     function approve(address _spender, uint256 _value) public returns (bool success) {
235        
236         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
237         allowed[msg.sender][_spender] = _value;
238         Approval(msg.sender, _spender, _value);
239         return true;
240     }
241     
242     function allowance(address _owner, address _spender) constant public returns (uint256) {
243         return allowed[_owner][_spender];
244     }
245     
246     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
247         ForeignToken t = ForeignToken(tokenAddress);
248         uint bal = t.balanceOf(who);
249         return bal;
250     }
251     
252     function withdraw() onlyOwner public {
253         uint256 etherBalance = this.balance;
254         owner.transfer(etherBalance);
255     }
256     
257     function burn(uint256 _value) onlyOwner public {
258         require(_value <= balances[msg.sender]);
259         
260 
261         address burner = msg.sender;
262         balances[burner] = balances[burner].sub(_value);
263         totalSupply = totalSupply.sub(_value);
264         totalDistributed = totalDistributed.sub(_value);
265         Burn(burner, _value);
266     }
267     
268     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
269         ForeignToken token = ForeignToken(_tokenContract);
270         uint256 amount = token.balanceOf(address(this));
271         return token.transfer(owner, amount);
272     }
273 
274 
275 }