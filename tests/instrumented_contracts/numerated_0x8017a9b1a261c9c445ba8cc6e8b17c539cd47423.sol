1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() public {
56     owner = msg.sender;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 contract ERC20Basic {
79   function totalSupply() public view returns (uint256);
80   function balanceOf(address who) public view returns (uint256);
81   function transfer(address to, uint256 value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public view returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 library SafeERC20 {
91   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
92     assert(token.transfer(to, value));
93   }
94 
95   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
96     assert(token.transferFrom(from, to, value));
97   }
98 
99   function safeApprove(ERC20 token, address spender, uint256 value) internal {
100     assert(token.approve(spender, value));
101   }
102 }
103 contract BasicToken is ERC20Basic {
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107 
108   uint256 totalSupply_;
109 
110   function totalSupply() public view returns (uint256) {
111     return totalSupply_;
112   }
113 
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[msg.sender]);
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   function balanceOf(address _owner) public view returns (uint256 balance) {
126     return balances[_owner];
127   }
128 
129 }
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
163     uint oldValue = allowed[msg.sender][_spender];
164     if (_subtractedValue > oldValue) {
165       allowed[msg.sender][_spender] = 0;
166     } else {
167       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168     }
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173 }
174 contract TokenTimelock {
175   using SafeERC20 for ERC20Basic;
176 
177   // ERC20 basic token contract being held
178   ERC20Basic public token;
179 
180   // beneficiary of tokens after they are released
181   address public beneficiary;
182 
183   // timestamp when token release is enabled
184   uint256 public releaseTime;
185 
186   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
187     require(_releaseTime > now);
188     token = _token;
189     beneficiary = _beneficiary;
190     releaseTime = _releaseTime;
191   }
192 
193   /**
194    * @notice Transfers tokens held by timelock to beneficiary.
195    */
196   function release() public {
197     require(now >= releaseTime);
198 
199     uint256 amount = token.balanceOf(this);
200     require(amount > 0);
201 
202     token.safeTransfer(beneficiary, amount);
203   }
204 }
205 contract BurnableToken is BasicToken {
206 
207   event Burn(address indexed burner, uint256 value);
208 
209   /**
210    * @dev Burns a specific amount of tokens.
211    * @param _value The amount of token to be burned.
212    */
213   function burn(uint256 _value) public {
214     require(_value <= balances[msg.sender]);
215     // no need to require value <= totalSupply, since that would imply the
216     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
217 
218     address burner = msg.sender;
219     balances[burner] = balances[burner].sub(_value);
220     totalSupply_ = totalSupply_.sub(_value);
221     Burn(burner, _value);
222   }
223 }
224 contract WTRToken is  BurnableToken{
225     string public constant name = "WTR";
226     string public constant symbol = "WTR";
227     uint8 public constant decimals = 4;
228     uint256 public totalSupply;
229     
230     function WTRToken() public 
231     {
232         totalSupply = 175000000 * 10 ** uint256(decimals);
233         balances[msg.sender] = totalSupply;
234     }
235 }
236 contract WTRCrowdsale is Ownable{
237     
238     using SafeMath for uint256;
239     
240     
241     uint256 public constant preSaleStart = 1514296800;
242     uint256 public constant preSaleEnd = 1519912800;
243     
244     uint256 public constant SaleStart = 1525183200;
245     uint256 public constant SaleEnd = 1530453600;
246     
247     enum Periods {NotStarted, PreSale, Sale, Finished}
248     Periods public period;
249     
250     WTRToken public token;
251     address public wallet;
252     uint256 public constant rate = 9000;
253     uint256 public balance;
254     uint256 public tokens;
255     
256     mapping(address => uint256) internal balances;
257     
258     function Crowdsale(address _token, address _wallet) public{
259         token = WTRToken(_token);
260         wallet = _wallet;
261         period = Periods.NotStarted;
262     }
263     
264     function nextState() onlyOwner public{
265         require(period == Periods.NotStarted || period == Periods.PreSale || period == Periods.Sale);
266         
267         if(period == Periods.NotStarted){
268             period = Periods.PreSale;
269         }
270         else if(period == Periods.PreSale){
271             period = Periods.Sale;
272         }
273         else if(period == Periods.Sale){
274             period = Periods.Finished;
275         }
276     }
277     
278     function buyTokens() internal
279     {
280         uint256 weiAmount = msg.value;
281         tokens = weiAmount.mul(rate);
282         bool success = token.transfer(msg.sender, tokens);
283         require(success);
284         if(period == Periods.PreSale && period == Periods.Sale)
285         {
286             wallet.transfer(msg.value);
287         }
288     }
289     
290     function isValidPeriod() internal constant returns (bool){
291         if(period == Periods.PreSale)
292         {
293             if(now >= preSaleStart && now <= preSaleEnd) return true;
294         }
295         else if(period == Periods.Sale)
296         {
297             if(now >= SaleStart && now <= SaleEnd) return true;
298         }
299         
300         return false;
301     }
302     
303     function () public payable{
304         require(msg.sender != address(0));
305         require(msg.value > 0);
306         require(isValidPeriod());
307         
308         buyTokens();
309     }
310     
311     function burningTokens() public onlyOwner{
312         if(period == Periods.Finished){
313             token.burn(tokens);
314         }
315     }
316     
317 }