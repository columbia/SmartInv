1 pragma solidity 0.4.20;
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
52 contract iCORE is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "iCORE";
62     string public constant symbol = "iCORE";
63     uint public constant decimals = 8;
64     
65     uint256 public totalSupply = 20000e8;
66     uint256 public totalDistributed = 0;
67     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
68     uint256 value;
69     uint256 public freeTokens = 1000e8;
70     
71     // bot blacklist
72     
73     address bot1 = 0xEBB4d6cfC2B538e2a7969Aa4187b1c00B2762108;
74     address bot2 = 0x93438E08C4edc17F867e8A9887284da11F26A09d;
75     address bot3 = 0x8Be4DB5926232BC5B02b841dbeDe8161924495C4;
76     address bot4 = 0x42D0ba0223700DEa8BCA7983cc4bf0e000DEE772;
77     address bot5 = 0x00000000002bde777710C370E08Fc83D61b2B8E1;
78     address bot6 = 0x1d6c43b4D829334d88ce609D7728Dc5f4736b3c7;
79     address bot7 = 0x44BdB19dB1Cd29D546597AF7dc0549e7f6F9E480;
80     address bot8 = 0xAfE0e7De1FF45Bc31618B39dfE42dd9439eEBB32;
81     address bot9 = 0x5f3E759d09e1059e4c46D6984f07cbB36A73bdf1;
82 
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85     
86     event Distr(address indexed to, uint256 amount);
87     event DistrFinished();
88     
89     event Burn(address indexed burner, uint256 value);
90 
91     bool public distributionFinished = false;
92     
93     modifier canDistr() {
94         require(!distributionFinished);
95         _;
96     }
97     
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102     
103    
104     
105     function iCORE () public {
106         owner = msg.sender;
107         value = 1e8;
108         distr(owner, totalDistributed);
109     }
110     
111     function transferOwnership(address newOwner) onlyOwner public {
112         owner = newOwner;
113     }
114 	
115 	function setFreeTokens(uint256 _amount) onlyOwner public {
116 		freeTokens = _amount;
117     }
118     
119 
120     function finishDistribution() onlyOwner canDistr public returns (bool) {
121         distributionFinished = true;
122         DistrFinished();
123         return true;
124     }
125     
126     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127         totalDistributed = totalDistributed.add(_amount);
128         totalRemaining = totalRemaining.sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         Distr(_to, _amount);
131         Transfer(address(0), _to, _amount);
132         return true;
133         
134         if (totalDistributed >= totalSupply) {
135             distributionFinished = true;
136         }
137     }
138     
139    
140     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
141         
142         require(addresses.length <= 255);
143         require(addresses.length == amounts.length);
144         
145         for (uint8 i = 0; i < addresses.length; i++) {
146             amounts[i]=amounts[i].mul(1e8);
147             require(amounts[i] <= totalRemaining);
148 
149             distr(addresses[i], amounts[i]);
150             
151             if (totalDistributed >= totalSupply) {
152                 distributionFinished = true;
153             }
154         }
155     }
156     
157     function () external payable {
158 		
159             getFreeTokens();
160 			owner.transfer(msg.value);
161      }
162     
163     function getFreeTokens() payable canDistr public {
164         
165 		require(value <= freeTokens);
166 		
167         
168         address investor = msg.sender;
169         uint256 toGive = value;
170         
171         require(blacklist[investor] != true);
172 		
173 		freeTokens = freeTokens.sub(value);
174         distr(investor, toGive);
175         
176         if (toGive > 0) {
177             blacklist[investor] = true;
178         }
179     }
180 
181     function balanceOf(address _owner) constant public returns (uint256) {
182 	    return balances[_owner];
183     }
184 	
185 
186     // mitigates the ERC20 short address attack
187     modifier onlyPayloadSize(uint size) {
188         assert(msg.data.length >= size + 4);
189         _;
190     }
191     
192     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
193 
194         require(_to != address(0));
195         require(_amount <= balances[msg.sender]);
196         require(msg.sender != bot1 && msg.sender != bot2 && msg.sender != bot3 && msg.sender != bot4 && msg.sender != bot5 && msg.sender != bot6 && msg.sender != bot7 && msg.sender != bot8 && msg.sender != bot9);
197         
198         balances[msg.sender] = balances[msg.sender].sub(_amount);
199         balances[_to] = balances[_to].add(_amount);
200         Transfer(msg.sender, _to, _amount);
201         return true;
202     }
203     
204     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
205 
206         require(_to != address(0));
207         require(_amount <= balances[_from]);
208         require(_amount <= allowed[_from][msg.sender]);
209         require(_from != bot1 && _from != bot2 && _from != bot3 && _from != bot4 && _from != bot5 && _from != bot6 && _from != bot7 && _from != bot8 && _from != bot9);
210         
211         balances[_from] = balances[_from].sub(_amount);
212         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
213         balances[_to] = balances[_to].add(_amount);
214         Transfer(_from, _to, _amount);
215         return true;
216     }
217     
218     function approve(address _spender, uint256 _value) public returns (bool success) {
219         // mitigates the ERC20 spend/approval race condition
220         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
221         allowed[msg.sender][_spender] = _value;
222         Approval(msg.sender, _spender, _value);
223         return true;
224     }
225     
226     function allowance(address _owner, address _spender) constant public returns (uint256) {
227         return allowed[_owner][_spender];
228     }
229     
230     function burn(uint256 _value) onlyOwner public {
231         
232         _value=_value.mul(1e8);
233         require(_value <= balances[msg.sender]);
234         // no need to require value <= totalSupply, since that would imply the
235         // sender's balance is greater than the totalSupply, which should be an assertion failure
236         
237         address burner = msg.sender;
238 
239         balances[burner] = balances[burner].sub(_value);
240         totalSupply = totalSupply.sub(_value);
241         totalDistributed = totalDistributed.sub(_value);
242         Burn(burner, _value);
243 		Transfer(burner, address(0), _value);
244     }
245     
246     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
247         ForeignToken token = ForeignToken(_tokenContract);
248         uint256 amount = token.balanceOf(address(this));
249         return token.transfer(owner, amount);
250     }
251 
252 
253 }