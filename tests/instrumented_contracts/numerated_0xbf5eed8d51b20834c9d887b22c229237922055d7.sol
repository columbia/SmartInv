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
46     mapping (address => uint256) balances;
47 
48     function transfer(address _to, uint256 _value) public returns (bool) {
49         balances[msg.sender] = balances[msg.sender].sub(_value);
50         balances[_to] = balances[_to].add(_value);
51         Transfer(msg.sender, _to, _value);
52         return true;
53     }
54 
55     function balanceOf(address _owner) public  constant returns (uint256 balance) {
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
73     mapping (address => mapping (address => uint256)) allowed;
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
155 }
156 
157 
158 contract Crowdsale is Ownable {
159     using SafeMath for uint256;
160     // The token being sold
161     ObizcoinCrowdsaleToken public token;
162     // address where funds are collected
163     address public wallet;
164     // amount of raised money in wei
165     uint256 public weiRaised;
166 
167     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint mytime);
168 
169     function Crowdsale()public {
170         token = createTokenContract();
171         wallet = msg.sender;
172     }
173 
174     function setNewWallet(address newWallet) public onlyOwner {
175         require(newWallet != 0x0);
176         wallet = newWallet;
177     }
178 
179     function createTokenContract() internal returns (ObizcoinCrowdsaleToken) {
180         return new ObizcoinCrowdsaleToken();
181     }
182     // fallback function can be used to buy tokens
183     function() public payable {
184         buyTokens(msg.sender);
185     }
186 
187     function profitSharing() payable public {
188         uint256 weiAmount = msg.value;
189         uint256 ballanceOfHolder;
190         for (uint i = 0; i < holders.length; i++)
191         {
192             ballanceOfHolder = token.balanceOf(holders[i]);
193             if (ballanceOfHolder > 0) {
194                 holders[i].transfer(ballanceOfHolder.mul(weiAmount).div(token.totalSupply()));
195             }
196         }
197     }
198 
199     function destroyMyToken(uint256 amount) public onlyOwner {
200         token.destroy(amount.mul(1000000000000000000), msg.sender);
201     }
202 
203     uint time0 = 1512970200; // now; // 11th dec, 2017 at 05:30 hrs UTC
204     //uint time0 = block.timestamp;
205     uint time1 = time0 + 15 days;
206 
207     uint time2 = time1 + 44 days + 5 hours + 5 minutes; // 24th Jan,2018 at 11:00 hrs UTC
208 
209     uint time3 = time0 + 49 days;
210 
211     uint time4 = time3 + 1 weeks;
212 
213     uint time5 = time3 + 2 weeks;
214 
215     uint time6 = time3 + 3 weeks;
216 
217     uint time7 = time2 + 34 days;
218 
219     // low level token purchase function
220     function buyTokens(address beneficiary) public payable {
221         require(beneficiary != 0x0);
222         require(validPurchase());
223         require(!hasEnded());
224         uint256 weiAmount = msg.value;
225         uint256 tokens;
226         // calculate token amount to be created
227 
228         if (block.timestamp >= time0 && block.timestamp < time2) tokens = weiAmount.mul(11000);
229         else if (block.timestamp >= time3 && block.timestamp < time7) tokens = weiAmount.mul(10000);
230 
231         // update state
232         weiRaised = weiRaised.add(weiAmount);
233         token.mint(beneficiary, tokens);
234         addNewHolder(beneficiary);
235         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, block.timestamp);
236         forwardFunds();
237     }
238 
239     function mintTokens(address beneficiary, uint256 tokens) internal {
240         uint256 weiAmount;
241         if (block.timestamp >= time0 && block.timestamp < time2) weiAmount = tokens.div(11000);
242         else if (block.timestamp >= time3 && block.timestamp < time7) weiAmount = tokens.div(10000);
243 
244         weiRaised = weiRaised.add(weiAmount);
245         token.mint(beneficiary, tokens);
246         addNewHolder(beneficiary);
247         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, block.timestamp);
248     }
249 
250     // send ether to the fund collection wallet
251     // override to create custom fund forwarding mechanisms
252     function forwardFunds() internal {
253         wallet.transfer(msg.value);
254     }
255     // @return true if the transaction can buy tokens
256     function validPurchase() internal constant returns (bool) {
257         return msg.value != 0;
258     }
259     // @return true if crowdsale event has ended
260     function hasEnded() public constant returns (bool) {
261         return block.timestamp < time0 || (block.timestamp > time2 && block.timestamp < time3) || block.timestamp > time7;
262     }
263 
264     mapping (address => bool) isHolder;
265 
266     address[] public holders;
267 
268     function addNewHolder(address newHolder) internal {
269         if (!isHolder[newHolder]) {
270             holders.push(newHolder);
271             isHolder[newHolder] = true;
272         }
273     }
274 }
275 
276 
277 contract ObizcoinCrowdsaleToken is MintableToken {
278     string public name;
279 
280     string public symbol;
281 
282     uint8 public decimals;
283 
284     function ObizcoinCrowdsaleToken() public {
285         name = "OBZ ICO TOKEN SALE";
286         symbol = "OBZ";
287         decimals = 18;
288     }
289 }
290 
291 
292 contract ObizcoinCrowdsale is Crowdsale {
293 
294     uint256 public investors;
295 
296     ProfitSharingObizcoin public profitSharingContract;
297 
298     function ObizcoinCrowdsale () public
299     Crowdsale()
300     {
301         investors = 0;
302         profitSharingContract = new ProfitSharingObizcoin();
303     }
304 
305 
306     function buyObizcoinTokens(address _sender) public payable {
307         investors++;
308         buyTokens(_sender);
309     }
310 
311     function mintObizcoinTokens(address beneficiary, uint256 tokens) public onlyOwner {
312         investors++;
313         mintTokens(beneficiary, tokens.mul(1000000000000000000));
314     }
315 
316     function() public payable {
317         buyObizcoinTokens(msg.sender);
318     }
319 
320 }
321 
322 
323 contract ProfitSharingObizcoin is Ownable {
324 
325     ObizcoinCrowdsale crowdsale;
326 
327     function ProfitSharingObizcoin()public {
328         crowdsale = ObizcoinCrowdsale(msg.sender);
329     }
330 
331     function() public payable {
332         crowdsale.profitSharing.value(msg.value)();
333     }
334 }