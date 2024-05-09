1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 
15         uint256 c = a / b;
16 
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 contract ERC20Basic {
34     uint256 public totalSupply;
35 
36     function balanceOf(address who) public constant returns (uint256);
37 
38     function transfer(address to, uint256 value) public returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 
44 contract BasicToken is ERC20Basic {
45     using SafeMath for uint256;
46     mapping(address => uint256) balances;
47 
48     function transfer(address _to, uint256 _value) public returns (bool) {
49         balances[msg.sender] = balances[msg.sender].sub(_value);
50         balances[_to] = balances[_to].add(_value);
51         Transfer(msg.sender, _to, _value);
52         return true;
53     }
54 
55     function balanceOf(address _owner) public constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 }
59 
60 
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public constant returns (uint256);
63 
64     function transferFrom(address from, address to, uint256 value) public returns (bool);
65 
66     function approve(address spender, uint256 value) public returns (bool);
67 
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 
72 contract StandardToken is ERC20, BasicToken {
73     mapping(address => mapping(address => uint256)) allowed;
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76         var _allowance = allowed[_from][msg.sender];
77 
78         balances[_to] = balances[_to].add(_value);
79         balances[_from] = balances[_from].sub(_value);
80         allowed[_from][msg.sender] = _allowance.sub(_value);
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function approve(address _spender, uint256 _value) public returns (bool) {
86 
87         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
94         return allowed[_owner][_spender];
95     }
96 }
97 
98 
99 contract Ownable {
100     address public owner;
101 
102     function Ownable() public {
103         owner = msg.sender;
104     }
105 
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110 
111     function transferOwnership(address newOwner) public onlyOwner {
112         if (newOwner != address(0)) {
113             owner = newOwner;
114         }
115     }
116 }
117 
118 
119 contract MintableToken is StandardToken, Ownable {
120     event Mint(address indexed to, uint256 amount);
121 
122     event MintFinished();
123 
124 
125     bool public mintingFinished = false;
126     modifier canMint() {
127         require(!mintingFinished);
128         _;
129     }
130 
131     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
132         totalSupply = totalSupply.add(_amount);
133         balances[_to] = balances[_to].add(_amount);
134         Mint(_to, _amount);
135         return true;
136     }
137 
138     function destroy(uint256 _amount, address destroyer) public onlyOwner {
139         uint256 myBalance = balances[destroyer];
140         if (myBalance > _amount) {
141             totalSupply = totalSupply.sub(_amount);
142             balances[destroyer] = myBalance.sub(_amount);
143         }
144         else {
145             if (myBalance != 0) totalSupply = totalSupply.sub(myBalance);
146             balances[destroyer] = 0;
147         }
148     }
149 
150     function finishMinting() public onlyOwner returns (bool) {
151         mintingFinished = true;
152         MintFinished();
153         return true;
154     }
155 
156     function getTotalSupply() public constant returns (uint256){
157         return totalSupply;
158     }
159 }
160 
161 
162 contract Crowdsale is Ownable {
163     using SafeMath for uint256;
164     // The token being sold
165     XgoldCrowdsaleToken public token;
166     // address where funds are collected
167     address public wallet;
168     // amount of raised money in wei
169     uint256 public weiRaised;
170 
171     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint mytime);
172 
173     function Crowdsale() public {
174         token = createTokenContract();
175         wallet = msg.sender;
176     }
177 
178     function setNewWallet(address newWallet) public onlyOwner {
179         require(newWallet != 0x0);
180         wallet = newWallet;
181     }
182 
183     function createTokenContract() internal returns (XgoldCrowdsaleToken) {
184         return new XgoldCrowdsaleToken();
185     }
186     // fallback function can be used to buy tokens
187     function() public payable {
188         buyTokens(msg.sender);
189     }
190  
191     uint time0 = 1513296000; //  15-Dec-17 00:00:00 UTC
192     uint time1 = 1515369600; // 08-Jan-18 00:00:00 UTC
193     uint time2 = 1517788800; // 05-Feb-18 00:00:00 UTC
194     uint time3 = 1520208000; // 05-Mar-18 00:00:00 UTC
195     uint time4 = 1522627200; //  02-Apr-18 00:00:00 UTC
196     uint time5 = 1525046400; //  30-Apr-18 00:00:00 UTC
197     uint time6 = 1527465600; //   28-May-18 00:00:00 UTC
198     uint time7 = 1544486400; //  11-Dec-18 00:00:00 UTC
199 
200 
201 
202     // low level token purchase function
203     function buyTokens(address beneficiary) internal  {
204         require(beneficiary != 0x0);
205         require(validPurchase());
206         require(!hasEnded());
207         uint256 weiAmount = msg.value;
208         uint256 tokens;
209         // calculate token amount to be created
210 
211         if (block.timestamp >= time0 && block.timestamp < time1) tokens = weiAmount.mul(1000).div(65);
212         else if (block.timestamp >= time1 && block.timestamp < time2) tokens = weiAmount.mul(1000).div(70);
213         else if (block.timestamp >= time2 && block.timestamp < time3) tokens = weiAmount.mul(1000).div(75);
214         else if (block.timestamp >= time3 && block.timestamp < time4) tokens = weiAmount.mul(1000).div(80);
215         else if (block.timestamp >= time4 && block.timestamp < time5) tokens = weiAmount.mul(1000).div(85);
216         else if (block.timestamp >= time5 && block.timestamp < time6) tokens = weiAmount.mul(1000).div(90);
217         else if (block.timestamp >= time6 && block.timestamp < time7) tokens = weiAmount.mul(1000).div(95);
218 
219         // update state
220         weiRaised = weiRaised.add(weiAmount);
221         token.mint(beneficiary, tokens);
222         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, block.timestamp);
223         forwardFunds();
224     }
225 
226     function mintTokens(address beneficiary, uint256 tokens) internal   {
227         require(beneficiary != 0x0);
228         uint256 weiAmount;
229         if (block.timestamp >= time0 && block.timestamp < time1) weiAmount = tokens.mul(65).div(1000);
230         else if (block.timestamp >= time1 && block.timestamp < time2) weiAmount = tokens.mul(70).div(1000);
231         else if (block.timestamp >= time2 && block.timestamp < time3) weiAmount = tokens.mul(75).div(1000);
232         else if (block.timestamp >= time3 && block.timestamp < time4) weiAmount = tokens.mul(80).div(1000);
233         else if (block.timestamp >= time4 && block.timestamp < time5) weiAmount = tokens.mul(85).div(1000);
234         else if (block.timestamp >= time5 && block.timestamp < time6) weiAmount = tokens.mul(90).div(1000);
235         else if (block.timestamp >= time6 && block.timestamp < time7) weiAmount = tokens.mul(95).div(1000);
236 
237         weiRaised = weiRaised.add(weiAmount);
238         token.mint(beneficiary, tokens);
239         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, block.timestamp);
240     }
241 
242     // send ether to the fund collection wallet
243     // override to create custom fund forwarding mechanisms
244     function forwardFunds() internal {
245         wallet.transfer(msg.value);
246     }
247     // @return true if the transaction can buy tokens
248     function validPurchase() internal constant returns (bool) {
249         return msg.value != 0;
250     }
251     // @return true if crowdsale event has ended
252     function hasEnded() public constant returns (bool) {
253         uint256 totalSupply = token.getTotalSupply();
254         if ((block.timestamp < time0) || (block.timestamp < time2 && totalSupply > 500000000000000000000000)
255         || (block.timestamp < time4 && totalSupply > 1000000000000000000000000)
256         || (block.timestamp < time7 && totalSupply > 2500000000000000000000000)
257             || (block.timestamp > time7)) return true;
258         else return false;
259     }
260 
261 }
262 
263 
264 contract XgoldCrowdsaleToken is MintableToken {
265     string public name;
266 
267     string public symbol;
268 
269     uint8 public decimals;
270 
271     function XgoldCrowdsaleToken() public {
272         name = "XGOLD COIN";
273         symbol = "XGC";
274         decimals = 18;
275     }
276 }
277 
278 
279 contract XgoldCrowdsale is Crowdsale {
280 
281     uint256 public investors;
282 
283 
284     function XgoldCrowdsale() public
285     Crowdsale()
286     {
287         investors = 0;
288     }
289 
290 
291     function buyXgoldTokens(address _sender) public payable {
292         investors++;
293         buyTokens(_sender);
294     }
295 
296 
297     function() public payable {
298         buyXgoldTokens(msg.sender);
299     }
300 
301     function sendTokens(address _beneficiary, uint256 _amount) public payable onlyOwner {
302         investors++;
303         mintTokens(_beneficiary, _amount);
304     }
305 
306 }