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
117 contract SpaceKIMToken is BurnableToken {
118   string public constant name = "Space KIM Token";
119   string public constant symbol = "KIM";
120   uint32 public constant decimals = 0;
121   uint256 public constant INITIAL_SUPPLY = 37900000;
122   function SpaceKIMToken() public {
123     totalSupply = INITIAL_SUPPLY;
124     balances[msg.sender] = INITIAL_SUPPLY;
125   }
126 }
127 
128 contract Crowdsale is Ownable {
129 
130   using SafeMath for uint;
131 
132   SpaceKIMToken public token = new SpaceKIMToken();
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
174     multisig = 0x381b16397eF8fB8FFF65F6d3B6E5979C9d38fe40;
175     restricted = 0x381b16397eF8fB8FFF65F6d3B6E5979C9d38fe40;
176     minAmount = 0.01 * 1 ether;
177     rate = 10000;
178 
179     saleStartDate = 1515974400; // 15.01.2018 00:00 GMT Main START
180     saleFinishDate = 1517961600; // 07.02.2017 00:00 GMT Main END
181     //Bounty first
182     olympStartDate = 1518134400; // 09.02.2018 00:00 GMT Olymp START
183     olympEndDate = 1519516800; // 25.02.2018 00:00 GMT Olymp END
184     //Bounty second
185     endCrowdsaleDate = 1519948800; // 02.03.2018 00:00 GMT Close Contract
186 
187     percentsTeamTokens = 20;
188     percentsBountySecondTokens = 5;
189     percentsPreSaleTokens = 30;
190     percentsOlympicTokens = 15;
191   }
192 
193   function calculateTokens(uint value) internal constant returns (uint) {
194     uint tokens = rate.mul(value).div(1 ether);
195     if(getStatus() == 1){
196       tokens += tokens.div(2);
197     }
198     return tokens;
199   }
200 
201   // 0 - stop
202   // 1 - preSale
203   // 2 - sale
204   // 3 - Bounty First
205   // 4 - Olympic games
206   // 5 - Bounty Second
207   function getStatus() internal constant returns (uint8) {
208     if(now > endCrowdsaleDate) {
209       return 0;
210     } else if(now > olympEndDate && now < endCrowdsaleDate) {
211       return 5;
212     } else if(now > olympStartDate && now < olympEndDate) {
213       return 4;
214     } else if(now > saleFinishDate && now < olympStartDate) {
215       return 3;
216     } else if(now > saleStartDate && now < saleFinishDate) {
217       return 2;
218     } else if(statusPreSale == 1){
219       return 1;
220     } else {
221       return 0;
222     }
223   }
224 
225   function holdTokensOnStage() public view returns (uint) {
226     uint _totalSupply = token.totalSupply();
227     uint _percents = 100;
228     uint curState = getStatus();
229     if(curState == 5) {
230       _percents = percentsTeamTokens;//20
231     } else if(curState == 4) {
232       _percents = percentsTeamTokens.add(percentsBountySecondTokens);//20+5
233     } else if(curState == 3) {
234       _percents = percentsTeamTokens.add(percentsBountySecondTokens).add(percentsOlympicTokens);//20+5+15
235     } else if(curState == 2) {
236       _percents = percentsTeamTokens.add(percentsBountySecondTokens).add(percentsOlympicTokens);//20+5+15
237     } else if(curState == 1) {
238       _percents = _percents.sub(percentsPreSaleTokens);//70
239     }
240     return _totalSupply.mul(_percents).div(100);
241   }
242 
243   function onBalance() public view returns (uint) {
244     return token.balanceOf(this);
245   }
246 
247   function availableTokensOnCurrentStage() public view returns (uint) {
248     uint _currentHolder = token.balanceOf(this);
249     uint _minTokens = holdTokensOnStage();
250     return _currentHolder.sub(_minTokens);
251   }
252 
253   function getStatusInfo() public view returns (string) {
254     uint curState = getStatus();
255     if(now > endCrowdsaleDate) {
256       return "Crowdsale is over";
257     } else if(curState == 5) {
258       return "Now Bounty #2 token distribution is active";
259     } else if(curState == 4) {
260       return "Now Olympic Special (ICO #2) is active";
261     } else if(curState == 3) {
262       return "Now Bounty #1 token distribution is active";
263     } else if(curState == 2) {
264       return "Now ICO #1 is active";
265     } else if(curState == 1) {
266       return "Now Pre-ICO is active";
267     } else {
268       return "The sale of tokens is stopped";
269     }
270   }
271 
272   function setStatus(uint8 newStatus) public onlyOwner {
273     require(newStatus == 1 || newStatus == 0);
274     statusPreSale = newStatus;
275   }
276 
277   function burnTokens() public onlyOwner {
278     require(now > endCrowdsaleDate);
279     uint _totalSupply = token.totalSupply();
280     uint _teamTokens = _totalSupply.mul(percentsTeamTokens).div(100);
281     token.transfer(restricted, _teamTokens);
282     uint _burnTokens = token.balanceOf(this);
283     token.burn(_burnTokens);
284   }
285 
286   function sendTokens(address to, uint tokens) public onlyOwner {
287     uint curState = getStatus();
288     require(curState == 5 || curState == 3);
289     uint _minTokens = holdTokensOnStage();
290     require(token.balanceOf(this).sub(tokens) >=  _minTokens);
291     token.transfer(to, tokens);
292   }
293 
294   function createTokens() public saleIsOn isUnderHardCap checkMinAmount payable {
295     uint tokens = calculateTokens(msg.value);
296     multisig.transfer(msg.value);
297     token.transfer(msg.sender, tokens);
298   }
299 
300   function() external payable {
301     createTokens();
302   }
303 }