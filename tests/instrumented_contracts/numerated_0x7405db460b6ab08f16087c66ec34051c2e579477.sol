1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6   function Ownable() public {
7     owner = msg.sender;
8   }
9   modifier onlyOwner() {
10     require(msg.sender == owner);
11     _;
12   }
13   function transferOwnership(address newOwner) public onlyOwner {
14     require(newOwner != address(0));
15     OwnershipTransferred(owner, newOwner);
16     owner = newOwner;
17   }
18 }
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a / b;
30     return c;
31   }
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) public view returns (uint256);
50   function transferFrom(address from, address to, uint256 value) public returns (bool);
51   function approve(address spender, uint256 value) public returns (bool);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56   mapping(address => uint256) balances;
57   function transfer(address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59     require(_value <= balances[msg.sender]);
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 }
69 contract StandardToken is ERC20, BasicToken {
70   mapping (address => mapping (address => uint256)) internal allowed;
71   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[_from]);
74     require(_value <= allowed[_from][msg.sender]);
75     balances[_from] = balances[_from].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78     Transfer(_from, _to, _value);
79     return true;
80   }
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84     return true;
85   }
86   function allowance(address _owner, address _spender) public view returns (uint256) {
87     return allowed[_owner][_spender];
88   }
89   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
90     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
91     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
92     return true;
93   }
94   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
95     uint oldValue = allowed[msg.sender][_spender];
96     if (_subtractedValue > oldValue) {
97       allowed[msg.sender][_spender] = 0;
98     } else {
99       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
100     }
101     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 }
105 
106 contract BurnableToken is StandardToken {
107   event Burn(address indexed burner, uint256 value);
108   function burn(uint256 _value) public {
109     require(_value > 0);
110     require(_value <= balances[msg.sender]);
111     address burner = msg.sender;
112     balances[burner] = balances[burner].sub(_value);
113     totalSupply = totalSupply.sub(_value);
114     Burn(burner, _value);
115   }
116 }
117 contract SpaceTRUMPLToken is BurnableToken {
118   string public constant name = "Space TRUMPL Token";
119   string public constant symbol = "TRUMP";
120   uint32 public constant decimals = 0;
121   uint256 public constant INITIAL_SUPPLY = 38440000;
122   function SpaceTRUMPLToken() public {
123     totalSupply = INITIAL_SUPPLY;
124     balances[msg.sender] = INITIAL_SUPPLY;
125   }
126 }
127 
128 contract Crowdsale is Ownable {
129 
130   using SafeMath for uint;
131 
132   SpaceTRUMPLToken public token = new SpaceTRUMPLToken();
133 
134   address multisig;
135   address restricted;
136 
137   uint statusPreSale = 0;
138 
139   uint rate;
140   uint minAmount;
141 
142   uint saleStartDate;
143   uint saleFinishDate;
144 
145   uint olympStartDate;
146   uint olympEndDate;
147 
148   uint percentsTeamTokens;
149   uint percentsPreSaleTokens;
150   uint percentsBountySecondTokens;
151   uint percentsOlympicTokens;
152 
153   uint endCrowdsaleDate;
154 
155   modifier saleIsOn() {
156     uint curState = getStatus();
157     require(curState != 0 && curState != 5 && curState != 3);
158     _;
159   }
160 
161   modifier isUnderHardCap() {
162     uint _availableTokens = token.balanceOf(this);
163     uint _tokens = calculateTokens(msg.value);
164     uint _minTokens = holdTokensOnStage();
165     require(_availableTokens.sub(_tokens) >= _minTokens);
166     _;
167   }
168 
169   modifier checkMinAmount() {
170     require(msg.value >= minAmount);
171     _;
172   }
173   function Crowdsale() public {
174     multisig = 0x19d1858e8E5f959863EF5a04Db54d3CaE1B58730;
175     restricted = 0x19d1858e8E5f959863EF5a04Db54d3CaE1B58730;
176     minAmount = 0.01 * 1 ether;
177     rate = 10000;
178     //Pre-ICO Dates:
179 
180     saleStartDate = 1517832000; // 5 February 2018 12:00 UTC START
181     saleFinishDate = 1518696000; // 15 February 2018 12:00 UTC END
182     //ICO Dates:
183     olympStartDate = 1518696060; // 15 February 2018 12:01 UTC START
184     olympEndDate = 1521979200; // 25 march  2018 12:00 UTC END
185     //Bounty second
186     endCrowdsaleDate = 1521979260; // 25 march  2018 12:10 UTC Close Contract
187 
188     percentsTeamTokens = 20;
189     percentsBountySecondTokens = 5;
190     percentsPreSaleTokens = 30;
191     percentsOlympicTokens = 15;
192   }
193 
194   function calculateTokens(uint value) internal constant returns (uint) {
195     uint tokens = rate.mul(value).div(1 ether);
196     if(getStatus() == 1){
197       tokens += tokens.div(2);
198     }
199     return tokens;
200   }
201 
202   // 0 - stop
203   // 1 - preSale
204   // 2 - sale
205   // 3 - Bounty First
206   // 4 - Olympic games
207   // 5 - Bounty Second
208   function getStatus() internal constant returns (uint8) {
209     if(now > endCrowdsaleDate) {
210       return 0;
211     } else if(now > olympEndDate && now < endCrowdsaleDate) {
212       return 5;
213     } else if(now > olympStartDate && now < olympEndDate) {
214       return 4;
215     } else if(now > saleFinishDate && now < olympStartDate) {
216       return 3;
217     } else if(now > saleStartDate && now < saleFinishDate) {
218       return 2;
219     } else if(statusPreSale == 1){
220       return 1;
221     } else {
222       return 0;
223     }
224   }
225 
226   function holdTokensOnStage() public view returns (uint) {
227     uint _totalSupply = token.totalSupply();
228     uint _percents = 100;
229     uint curState = getStatus();
230     if(curState == 5) {
231       _percents = percentsTeamTokens;//20
232     } else if(curState == 4) {
233       _percents = percentsTeamTokens.add(percentsBountySecondTokens);//20+5
234     } else if(curState == 3) {
235       _percents = percentsTeamTokens.add(percentsBountySecondTokens).add(percentsOlympicTokens);//20+5+15
236     } else if(curState == 2) {
237       _percents = percentsTeamTokens.add(percentsBountySecondTokens).add(percentsOlympicTokens);//20+5+15
238     } else if(curState == 1) {
239       _percents = _percents.sub(percentsPreSaleTokens);//70
240     }
241     return _totalSupply.mul(_percents).div(100);
242   }
243 
244   function onBalance() public view returns (uint) {
245     return token.balanceOf(this);
246   }
247 
248   function availableTokensOnCurrentStage() public view returns (uint) {
249     uint _currentHolder = token.balanceOf(this);
250     uint _minTokens = holdTokensOnStage();
251     return _currentHolder.sub(_minTokens);
252   }
253 
254   function getStatusInfo() public view returns (string) {
255     uint curState = getStatus();
256     if(now > endCrowdsaleDate) {
257       return "Crowdsale is over";
258     } else if(curState == 5) {
259       return "Now Bounty #2 token distribution is active";
260     } else if(curState == 4) {
261       return "Now Olympic Special (ICO #2) is active";
262     } else if(curState == 3) {
263       return "Now Bounty #1 token distribution is active";
264     } else if(curState == 2) {
265       return "Now ICO #1 is active";
266     } else if(curState == 1) {
267       return "Now Pre-ICO is active";
268     } else {
269       return "The sale of tokens is stopped";
270     }
271   }
272 
273   function setStatus(uint8 newStatus) public onlyOwner {
274     require(newStatus == 1 || newStatus == 0);
275     statusPreSale = newStatus;
276   }
277 
278   function burnTokens() public onlyOwner {
279     require(now > endCrowdsaleDate);
280     uint _totalSupply = token.totalSupply();
281     uint _teamTokens = _totalSupply.mul(percentsTeamTokens).div(100);
282     token.transfer(restricted, _teamTokens);
283     uint _burnTokens = token.balanceOf(this);
284     token.burn(_burnTokens);
285   }
286 
287   function sendTokens(address to, uint tokens) public onlyOwner {
288     uint curState = getStatus();
289     require(curState == 5 || curState == 3);
290     uint _minTokens = holdTokensOnStage();
291     require(token.balanceOf(this).sub(tokens) >=  _minTokens);
292     token.transfer(to, tokens);
293   }
294 
295   function createTokens() public saleIsOn isUnderHardCap checkMinAmount payable {
296     uint tokens = calculateTokens(msg.value);
297     multisig.transfer(msg.value);
298     token.transfer(msg.sender, tokens);
299   }
300 
301   function() external payable {
302     createTokens();
303   }
304 }