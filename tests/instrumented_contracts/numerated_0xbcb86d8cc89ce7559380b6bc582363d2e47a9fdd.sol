1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     // SafeMath.sub will throw if there is not enough balance.
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 
117 
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 contract DINTToken is StandardToken {
215     using SafeMath for uint256;
216 
217     string public name = "DINT Coin";
218     string public symbol = "DINT";
219     uint256 public decimals = 18;
220 
221     uint256 public totalSupply = 20*1000000 ether;
222     uint256 public totalRaised; // total ether raised (in wei)
223 
224     uint256 public startTimestamp; // timestamp after which ICO will start
225     uint256 public durationSeconds = 30*60*60*24; // 1 months
226 
227     uint256 public maxCap; // the ICO ether max cap (in wei)
228 
229     uint256 public minAmount = 1 ether; // Minimum Transaction Amount(1 DIC)
230 
231     uint256 public coinsPerETH = 682;
232 
233     mapping(uint => uint) public weeklyRewards;
234 
235     /**
236      * Address which will receive raised funds 
237      * and owns the total supply of tokens
238      */
239     address public fundsWallet;
240 
241     function DINTToken() {
242         fundsWallet = 0x1660225Ed0229d1B1e62e56c5A9a9e19e004Ea4a;
243         startTimestamp = 1526169600;
244 
245         balances[fundsWallet] = totalSupply;
246         Transfer(0x0, fundsWallet, totalSupply);
247     }
248 
249     function() isIcoOpen checkMin payable{
250         totalRaised = totalRaised.add(msg.value);
251 
252         uint256 tokenAmount = calculateTokenAmount(msg.value);
253         balances[fundsWallet] = balances[fundsWallet].sub(tokenAmount);
254         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
255 
256         Transfer(fundsWallet, msg.sender, tokenAmount);
257 
258         // immediately transfer ether to fundsWallet
259         fundsWallet.transfer(msg.value);
260     }
261 
262     function calculateTokenAmount(uint256 weiAmount) constant returns(uint256) {
263         uint256 tokenAmount = weiAmount.mul(coinsPerETH);
264         // setting rewards is possible only for 4 weeks
265         for (uint i = 1; i <= 4; i++) {
266             if (now <= startTimestamp +  (i*7 days)) {
267                 return tokenAmount.mul(100+weeklyRewards[i]).div(100);    
268             }
269         }
270         return tokenAmount;
271     }
272 
273     function adminAddICO(uint256 _startTimestamp, uint256 _durationSeconds, 
274         uint256 _coinsPerETH, uint256 _maxCap, uint _week1Rewards,
275         uint _week2Rewards, uint _week3Rewards, uint _week4Rewards) isOwner{
276 
277         startTimestamp = _startTimestamp;
278         durationSeconds = _durationSeconds;
279         coinsPerETH = _coinsPerETH;
280         maxCap = _maxCap * 1 ether;
281 
282         weeklyRewards[1] = _week1Rewards;
283         weeklyRewards[2] = _week2Rewards;
284         weeklyRewards[3] = _week3Rewards;
285         weeklyRewards[4] = _week4Rewards;
286 
287         // reset totalRaised
288         totalRaised = 0;
289     }
290 
291     modifier isIcoOpen() {
292         require(now >= startTimestamp);
293         require(now <= (startTimestamp + durationSeconds));
294         require(totalRaised <= maxCap);
295         _;
296     }
297 
298     modifier checkMin(){
299         require(msg.value.mul(coinsPerETH) >= minAmount);
300         _;
301     }
302 
303     modifier isOwner(){
304         require(msg.sender == fundsWallet);
305         _;
306     }
307 }