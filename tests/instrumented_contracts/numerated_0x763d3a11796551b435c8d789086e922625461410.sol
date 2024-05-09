1 pragma solidity ^0.4.16;
2 
3   contract ERC20 {
4      function totalSupply() constant returns (uint256 totalsupply);
5      function balanceOf(address _owner) constant returns (uint256 balance);
6      function transfer(address _to, uint256 _value) returns (bool success);
7      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8      function approve(address _spender, uint256 _value) returns (bool success);
9      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10      event Transfer(address indexed _from, address indexed _to, uint256 _value);
11      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12   }
13   
14   contract TCASH is ERC20 {
15      string public constant symbol = "TCASH";
16      string public constant name = "Tcash";
17      uint8 public constant decimals = 8;
18      uint256 _totalSupply = 88000000 * 10**8;
19      
20 
21      address public owner;
22   
23      mapping(address => uint256) balances;
24   
25      mapping(address => mapping (address => uint256)) allowed;
26      
27   
28      function TCASH() {
29          owner = msg.sender;
30          balances[owner] = 88000000 * 10**8;
31      }
32      
33      modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37      
38      
39     function distributeTCASH(address[] addresses) onlyOwner {
40          for (uint i = 0; i < addresses.length; i++) {
41              balances[owner] -= 245719916000;
42              balances[addresses[i]] += 245719916000;
43              Transfer(owner, addresses[i], 245719916000);
44          }
45      }
46      
47   
48      function totalSupply() constant returns (uint256 totalsupply) {
49          totalsupply = _totalSupply;
50      }
51   
52 
53      function balanceOf(address _owner) constant returns (uint256 balance) {
54         return balances[_owner];
55      }
56  
57      function transfer(address _to, uint256 _amount) returns (bool success) {
58          if (balances[msg.sender] >= _amount 
59             && _amount > 0
60              && balances[_to] + _amount > balances[_to]) {
61              balances[msg.sender] -= _amount;
62              balances[_to] += _amount;
63              Transfer(msg.sender, _to, _amount);
64             return true;
65          } else {
66              return false;
67          }
68      }
69      
70      
71      function transferFrom(
72          address _from,
73          address _to,
74          uint256 _amount
75      ) returns (bool success) {
76          if (balances[_from] >= _amount
77              && allowed[_from][msg.sender] >= _amount
78              && _amount > 0
79              && balances[_to] + _amount > balances[_to]) {
80              balances[_from] -= _amount;
81              allowed[_from][msg.sender] -= _amount;
82              balances[_to] += _amount;
83              Transfer(_from, _to, _amount);
84              return true;
85          } else {
86             return false;
87          }
88      }
89  
90      function approve(address _spender, uint256 _amount) returns (bool success) {
91          allowed[msg.sender][_spender] = _amount;
92         Approval(msg.sender, _spender, _amount);
93          return true;
94      }
95   
96      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97          return allowed[_owner][_spender];
98     }
99   }
100 
101 contract TcashCrowdsale {
102     address public founder;
103     address public target;
104     uint256 public weiRaised;
105     uint256 public tokenIssued;
106     uint256 public contributors;
107     TCASH public tokenReward;
108     uint256 public phase = 0;
109     bool public halted = false;
110     bool crowdsaleClosed = false;
111 
112     uint256[10] public priceToken = [
113         2600,
114         2500,
115         2400,
116         2300,
117         2200,
118         2100,
119         2000,
120         2000,
121         2000,
122         2000
123     ];
124 
125     uint256 public constant HARDCAP = 20000 ether;
126     uint256 public constant MULTIPLIER = 10 ** 10;
127 
128      /*
129      * MODIFIERS
130      */
131      modifier onlyFounder() {
132         require(msg.sender == founder);
133         _;
134      }
135 
136     /**
137      * Constrctor function
138      *
139      * Setup the escrow account address, all ethers will be sent to this address.
140      *
141      *
142      * addressOfToken address Of Token Used As Reward
143      *
144      */
145     function TcashCrowdsale (
146         address _target,
147         address addressOfToken
148     ) {
149         require(msg.sender != 0x0);
150         require(_target != 0x0);
151         require(addressOfToken != 0x0);
152         target = _target;
153         founder = msg.sender;
154         tokenReward = TCASH(addressOfToken);
155     }
156 
157     function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
158       uint256 c = a + b;
159       require(c >= a);
160       return c;
161     }
162 
163     function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
164       uint256 c = a * b;
165       require(a == 0 || c / a == b);
166       return c;
167     }
168 
169     function safeDiv(uint256 a, uint256 b) internal constant returns (uint256) {
170       // require(b > 0); // Solidity automatically throws when dividing by 0
171       uint256 c = a / b;
172       // require(a == b * c + a % b); // There is no case in which this doesn't hold
173       return c;
174     }
175 
176     /**
177      * Fallback function
178      *
179      * The function without name is the default function that is
180      * called whenever anyone sends funds to a contract
181      */
182     function () payable {
183         buyToken(msg.sender);
184     }
185 
186     function buyToken(address receiver) payable {
187         require(!halted);
188         require(!crowdsaleClosed);
189         require(receiver != 0x0);
190         require(receiver != target);
191         require(msg.value >= 0.01 ether);
192         require(weiRaised <= HARDCAP);
193         uint256 weiAmount = msg.value;
194         uint256 tokens = computeTokenAmount(weiAmount);
195         if (tokenReward.transfer(receiver, tokens)) {
196            tokenIssued = safeAdd(tokenIssued, tokens);
197         } else {
198            revert();
199         }
200         weiRaised = safeAdd(weiRaised, weiAmount);
201         contributors = safeAdd(contributors, 1);
202         if (!target.send(weiAmount)) {
203            revert();
204         }
205     }
206 
207     function price() constant returns (uint256 tokens) {
208         tokens = priceToken[phase];
209     }
210 
211     function computeTokenAmount(uint256 weiAmount) internal constant returns (uint256 tokens) {
212         tokens = safeMul(safeDiv(weiAmount, MULTIPLIER), priceToken[phase]);
213     }
214 
215     /**
216      * Emergency Stop crowdsale.
217      *
218      */
219     function halt() onlyFounder {
220         halted = true;
221     }
222 
223     /**
224      * Resume crowdsale.
225      *
226      */
227     function unhalt() onlyFounder {
228         halted = false;
229     }
230 
231     /**
232      * set crowdsale phase
233      *
234      */
235     function setPhase(uint256 nPhase) onlyFounder {
236         require((nPhase < priceToken.length) && (nPhase >= 0));
237         phase = nPhase;
238     }
239 
240     /**
241      * Withdraw unsale Token
242      *
243      */
244     function tokenWithdraw(address receiver, uint256 tokens) onlyFounder {
245         require(receiver != 0x0);
246         require(tokens > 0);
247         if (!tokenReward.transfer(receiver, tokens)) {
248            revert();
249         }
250     }
251 
252     /**
253      * close Crowdsale
254      *
255      * Close the crowdsale
256      */
257     function closeCrowdsale() onlyFounder {
258         crowdsaleClosed = true;
259     }
260 
261 }