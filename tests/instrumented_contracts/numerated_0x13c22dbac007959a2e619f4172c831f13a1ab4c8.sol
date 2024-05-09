1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4   
5   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6     assert(b <= a);
7     return a - b;
8   }
9 
10   function add(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a + b;
12     assert(c >= a);
13     return c;
14   }
15 }
16 
17 contract ForeignToken {
18     function balanceOf(address _owner) constant public returns (uint256);
19     function transfer(address _to, uint256 _value) public returns (bool);
20 }
21 
22 contract ERC20Basic {
23     uint256 public totalSupply;
24     function balanceOf(address who) public constant returns (uint256);
25     function transfer(address to, uint256 value) public returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 
29 contract ERC20 is ERC20Basic {
30     function allowance(address owner, address spender) public constant returns (uint256);
31     function transferFrom(address from, address to, uint256 value) public returns (bool);
32     function approve(address spender, uint256 value) public returns (bool);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 interface Token { 
37     function distr(address _to, uint256 _value) public returns (bool);
38     function totalSupply() constant public returns (uint256 supply);
39     function balanceOf(address _owner) constant public returns (uint256 balance);
40 }
41 
42 contract adaCoin is ERC20 {
43     
44     using SafeMath for uint256;
45     address owner = msg.sender;
46 
47     mapping (address => uint256) balances;
48     mapping (address => mapping (address => uint256)) allowed;
49     mapping (address => bool) public blacklist;
50 
51     string public constant name = "ada";
52     string public constant symbol = "ada";
53     uint public constant decimals = 8;
54     
55     uint256 public totalSupply = 45000000000e8;
56     uint256 public totalDistributed = 100000000e8;
57     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
58     uint256 public value;
59 
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62     
63     event Distr(address indexed to, uint256 amount);
64     event DistrFinished();
65     
66     bool public distributionFinished = false;
67     
68     modifier canDistr() {
69         require(!distributionFinished);
70         _;
71     }
72     
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77     
78     modifier onlyWhitelist() {
79         require(blacklist[msg.sender] == false);
80         _;
81     }
82     
83     function adaCoin () public {
84         owner = msg.sender;
85         value = 50000e8;
86         distr(owner, totalDistributed);
87     }
88     
89     function transferOwnership(address newOwner) onlyOwner public {
90         if (newOwner != address(0)) {
91             owner = newOwner;
92         }
93     }
94     
95     function enableWhitelist(address[] addresses) onlyOwner public {
96         for (uint i = 0; i < addresses.length; i++) {
97             blacklist[addresses[i]] = false;
98         }
99     }
100 
101     function disableWhitelist(address[] addresses) onlyOwner public {
102         for (uint i = 0; i < addresses.length; i++) {
103             blacklist[addresses[i]] = true;
104         }
105     }
106 
107     function finishDistribution() onlyOwner canDistr public returns (bool) {
108         distributionFinished = true;
109         DistrFinished();
110         return true;
111     }
112     
113     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
114         totalDistributed = totalDistributed.add(_amount);
115         totalRemaining = totalRemaining.sub(_amount);
116         balances[_to] = balances[_to].add(_amount);
117         Distr(_to, _amount);
118         Transfer(address(0), _to, _amount);
119         return true;
120         
121         if (totalDistributed >= totalSupply) {
122             distributionFinished = true;
123         }
124     }
125     
126     function airdrop(address[] addresses) onlyOwner canDistr public {
127         
128         require(addresses.length <= 255);
129         require(value <= totalRemaining);
130         
131         for (uint i = 0; i < addresses.length; i++) {
132             require(value <= totalRemaining);
133             distr(addresses[i], value);
134         }
135 	
136         if (totalDistributed >= totalSupply) {
137             distributionFinished = true;
138         }
139     }
140     
141     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
142         
143         require(addresses.length <= 255);
144         require(amount <= totalRemaining);
145         
146         for (uint i = 0; i < addresses.length; i++) {
147             require(amount <= totalRemaining);
148             distr(addresses[i], amount);
149         }
150 	
151         if (totalDistributed >= totalSupply) {
152             distributionFinished = true;
153         }
154     }
155     
156     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
157 
158         require(addresses.length <= 255);
159         require(addresses.length == amounts.length);
160         
161         for (uint8 i = 0; i < addresses.length; i++) {
162             require(amounts[i] <= totalRemaining);
163             distr(addresses[i], amounts[i]);
164             
165             if (totalDistributed >= totalSupply) {
166                 distributionFinished = true;
167             }
168         }
169     }
170     
171     function () external payable {
172             getTokens();
173      }
174     
175     function getTokens() payable canDistr onlyWhitelist public {
176         
177         if (value > totalRemaining) {
178             value = totalRemaining;
179         }
180         
181         require(value <= totalRemaining);
182         
183         address investor = msg.sender;
184         uint256 toGive = value;
185         
186         distr(investor, toGive);
187         
188         if (toGive > 0) {
189             blacklist[investor] = true;
190         }
191 
192         if (totalDistributed >= totalSupply) {
193             distributionFinished = true;
194         }
195         
196         
197     }
198 
199     function balanceOf(address _owner) constant public returns (uint256) {
200 	    return balances[_owner];
201     }
202 
203     // mitigates the ERC20 short address attack
204     modifier onlyPayloadSize(uint size) {
205         assert(msg.data.length >= size + 4);
206         _;
207     }
208     
209     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
210 
211         require(_to != address(0));
212         require(_amount <= balances[msg.sender]);
213         
214         balances[msg.sender] = balances[msg.sender].sub(_amount);
215         balances[_to] = balances[_to].add(_amount);
216         Transfer(msg.sender, _to, _amount);
217         return true;
218     }
219     
220     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
221 
222         require(_to != address(0));
223         require(_amount <= balances[_from]);
224         require(_amount <= allowed[_from][msg.sender]);
225         
226         balances[_from] = balances[_from].sub(_amount);
227         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
228         balances[_to] = balances[_to].add(_amount);
229         Transfer(_from, _to, _amount);
230         return true;
231     }
232     
233     function approve(address _spender, uint256 _value) public returns (bool success) {
234         allowed[msg.sender][_spender] = _value;
235         Approval(msg.sender, _spender, _value);
236         return true;
237     }
238     
239     function allowance(address _owner, address _spender) constant public returns (uint256) {
240         return allowed[_owner][_spender];
241     }
242     
243     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
244         ForeignToken t = ForeignToken(tokenAddress);
245         uint bal = t.balanceOf(who);
246         return bal;
247     }
248     
249     function withdraw() onlyOwner public {
250         uint256 etherBalance = this.balance;
251         owner.transfer(etherBalance);
252     }
253     
254    
255     
256     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
257         ForeignToken token = ForeignToken(_tokenContract);
258         uint256 amount = token.balanceOf(address(this));
259         return token.transfer(owner, amount);
260     }
261     
262     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
263         allowed[msg.sender][_spender] = _value;
264         Approval(msg.sender, _spender, _value);
265         
266         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
267         return true;
268     }
269 
270 }