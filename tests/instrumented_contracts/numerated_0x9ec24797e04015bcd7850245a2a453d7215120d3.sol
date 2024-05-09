1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113 
114     uint256 _allowance = allowed[_from][msg.sender];
115 
116     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117     // require (_value <= _allowance);
118 
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowed[_from][msg.sender] = _allowance.sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    *
129    * Beware that changing an allowance with this method brings the risk that someone may use both the old
130    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152   /**
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval (address _spender, uint _addedValue)
159     returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval (address _spender, uint _subtractedValue)
166     returns (bool success) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 
180 
181 contract PlayBetsToken is StandardToken {
182 
183   string public constant name = "Play Bets Token";
184   string public constant symbol = "PLT";
185   uint256 public constant decimals = 18;
186   uint256 public constant INITIAL_SUPPLY = 300 * 1e6 * 1 ether;
187 
188   function PlayBetsToken() public {
189     totalSupply = INITIAL_SUPPLY;
190     balances[msg.sender] = INITIAL_SUPPLY;
191   }
192 }
193 
194 /**
195  * @title Ownable
196  * @dev The Ownable contract has an owner address, and provides basic authorization control
197  * functions, this simplifies the implementation of "user permissions".
198  */
199 contract Ownable {
200   address public owner;
201 
202 
203   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205 
206   /**
207    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
208    * account.
209    */
210   function Ownable() {
211     owner = msg.sender;
212   }
213 
214 
215   /**
216    * @dev Throws if called by any account other than the owner.
217    */
218   modifier onlyOwner() {
219     require(msg.sender == owner);
220     _;
221   }
222 
223 
224   /**
225    * @dev Allows the current owner to transfer control of the contract to a newOwner.
226    * @param newOwner The address to transfer ownership to.
227    */
228   function transferOwnership(address newOwner) onlyOwner public {
229     require(newOwner != address(0));
230     OwnershipTransferred(owner, newOwner);
231     owner = newOwner;
232   }
233 
234 }
235 
236 
237 contract PlayBetsPreSale is Ownable {
238     string public constant name = "PlayBets Closed Pre-Sale";
239 
240     using SafeMath for uint256;
241 
242     PlayBetsToken public token;
243     address public beneficiary;
244 
245     uint256 public tokensPerEth;
246 
247     uint256 public weiRaised = 0;
248     uint256 public tokensSold = 0;
249     uint256 public investorCount = 0;
250 
251     uint public startTime;
252     uint public endTime;
253 
254     bool public crowdsaleFinished = false;
255 
256     event GoalReached(uint256 raised, uint256 tokenAmount);
257     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
258 
259     modifier onlyAfter(uint time) {
260         require(currentTime() > time);
261         _;
262     }
263 
264     modifier onlyBefore(uint time) {
265         require(currentTime() < time);
266         _;
267     }
268 
269     function PlayBetsPreSale (
270         address _tokenAddr,
271         address _beneficiary,
272 
273         uint256 _tokensPerEth,
274 
275         uint _startTime,
276         uint _duration
277     ) {
278         token = PlayBetsToken(_tokenAddr);
279         beneficiary = _beneficiary;
280 
281         tokensPerEth = _tokensPerEth;
282 
283         startTime = _startTime;
284         endTime = _startTime + _duration * 1 days;
285     }
286 
287     function () payable {
288         require(msg.value >= 0.01 * 1 ether);
289         doPurchase();
290     }
291 
292     function withdraw(uint256 _value) onlyOwner {
293         beneficiary.transfer(_value);
294     }
295 
296     function finishCrowdsale() onlyOwner {
297         token.transfer(beneficiary, token.balanceOf(this));
298         crowdsaleFinished = true;
299     }
300 
301     function doPurchase() private onlyAfter(startTime) onlyBefore(endTime) {
302         
303         require(!crowdsaleFinished);
304         require(msg.sender != address(0));
305 
306         uint256[5] memory _bonusPattern = [ uint256(120), 115, 110, 105, 100];
307         uint[4] memory _periodPattern = [ uint(24), 24 * 2, 24 * 7, 24 * 14];
308 
309         uint256 tokenCount = tokensPerEth * msg.value;
310 
311         uint calcPeriod = startTime;
312         uint prevPeriod = 0;
313         uint256 _now = currentTime();
314 
315         for(uint8 i = 0; i < _periodPattern.length; ++i) {
316             calcPeriod = startTime.add(_periodPattern[i] * 1 hours);
317 
318             if (prevPeriod < _now && _now <= calcPeriod) {
319                 tokenCount = tokenCount.mul(_bonusPattern[i]).div(100);
320                 break;
321             }
322             prevPeriod = calcPeriod;
323         }
324 
325         uint256 _wei = msg.value;
326         uint256 _availableTokens = token.balanceOf(this);
327 
328         if (_availableTokens < tokenCount) {
329           uint256 expectingTokenCount = tokenCount;
330           tokenCount = _availableTokens;
331           _wei = msg.value.mul(tokenCount).div(expectingTokenCount);
332           msg.sender.transfer(msg.value.sub(_wei));
333         }
334 
335         if (token.balanceOf(msg.sender) == 0) {
336             investorCount++;
337         }
338         token.transfer(msg.sender, tokenCount);
339 
340         weiRaised = weiRaised.add(_wei);
341         tokensSold = tokensSold.add(tokenCount);
342 
343 
344         NewContribution(msg.sender, tokenCount, _wei);
345 
346         if (token.balanceOf(this) == 0) {
347             GoalReached(weiRaised, tokensSold);
348         }
349     }
350 
351     function manualSell(address _sender, uint256 _value) external onlyOwner {
352         token.transfer(_sender, _value);
353         tokensSold = tokensSold.add(_value);
354     }
355 
356     function currentTime() internal constant returns(uint256) {
357         return now;
358     }
359 }