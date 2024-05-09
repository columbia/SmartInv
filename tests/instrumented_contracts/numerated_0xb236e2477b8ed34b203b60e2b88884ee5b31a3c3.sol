1 pragma solidity 0.4.19;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38   address public owner;
39 
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public {
49     owner = msg.sender;
50   }
51 
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     require(newOwner != address(0));
68     OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72 }
73 
74 contract ERC20Basic {
75   uint256 public totalSupply;
76   function balanceOf(address who) public view returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) public view returns (uint256);
83   function transferFrom(address from, address to, uint256 value) public returns (bool);
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 contract StandardToken is ERC20, BasicToken {
121 
122   mapping (address => mapping (address => uint256)) internal allowed;
123 
124 
125   /**
126    * @dev Transfer tokens from one address to another
127    * @param _from address The address which you want to send tokens from
128    * @param _to address The address which you want to transfer to
129    * @param _value uint256 the amount of tokens to be transferred
130    */
131   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135 
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    *
146    * Beware that changing an allowance with this method brings the risk that someone may use both the old
147    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifying the amount of tokens still available for the spender.
164    */
165   function allowance(address _owner, address _spender) public view returns (uint256) {
166     return allowed[_owner][_spender];
167   }
168 
169   /**
170    * approve should be called when allowed[_spender] == 0. To increment
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    */
175   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
176     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
182     uint oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue > oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192 }
193 
194 contract UCCoin is StandardToken, Ownable {
195 
196     string public constant name = "UC Coin";
197     string public constant symbol = "UCN";
198     uint8 public constant decimals = 8;
199 
200     uint256 public INITIAL_TOKEN_SUPPLY = 500000000 * (10 ** uint256(decimals));
201 
202     function MAX_UCCOIN_SUPPLY() public view returns (uint256) {
203         return totalSupply.div(10 ** uint256(decimals));
204     }
205 
206     function UCCoin() public {
207         totalSupply = INITIAL_TOKEN_SUPPLY;
208         balances[msg.sender] = totalSupply;
209     }
210 }
211 
212 contract UCCoinSales is UCCoin {
213 
214     uint256 public weiRaised;
215 
216     uint256 public UCCOIN_PER_ETHER = 1540;
217     uint256 public MINIMUM_SELLING_UCCOIN = 150;
218 
219     bool public shouldStopCoinSelling = true;
220 
221     mapping(address => uint256) public contributions;
222     mapping(address => bool) public blacklistAddresses;
223 
224     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
225     event UcCoinPriceChanged(uint256 value, uint256 updated);
226     event UcCoinMinimumSellingChanged(uint256 value, uint256 updated);
227     event UCCoinSaleIsOn(uint256 updated);
228     event UCCoinSaleIsOff(uint256 updated);
229 
230     function UCCoinSales() public {
231 
232     }
233     // users can buy UC Coin
234     function() payable external {
235         buyUcCoins();
236     }
237     // users can buy UC Coin
238     function buyUcCoins() payable public {
239         require(msg.sender != address(0));
240 
241         bool didSetUcCoinValue = UCCOIN_PER_ETHER > 0;
242         require(!shouldStopCoinSelling && didSetUcCoinValue);
243         require(blacklistAddresses[tx.origin] != true);
244 
245         uint256 weiAmount = msg.value;
246 
247         uint256 tokens = getUcCoinTokenPerEther().mul(msg.value).div(1 ether);
248 
249         require(tokens >= getMinimumSellingUcCoinToken());
250         require(balances[owner] >= tokens);
251 
252         weiRaised = weiRaised.add(weiAmount);
253 
254         balances[owner] = balances[owner].sub(tokens);
255         balances[msg.sender] = balances[msg.sender].add(tokens);
256         // send fund...
257         owner.transfer(msg.value);
258 
259         contributions[msg.sender] = contributions[msg.sender].add(msg.value);
260 
261         TokenPurchase(msg.sender, weiAmount, tokens);
262     }
263 
264     // convert UC amount per ether -> Token amount per ether
265     function getUcCoinTokenPerEther() internal returns (uint256) {
266         return UCCOIN_PER_ETHER * (10 ** uint256(decimals));
267     }
268     // convert minium UC amount to purchase -> minimum Token amount to purchase
269     function getMinimumSellingUcCoinToken() internal returns (uint256) {
270         return MINIMUM_SELLING_UCCOIN * (10 ** uint256(decimals));
271     }
272 
273     // the contract owner sends tokens to the target address
274     function sendTokens(address target, uint256 tokenAmount) external onlyOwner returns (bool) {
275         require(target != address(0));
276         require(balances[owner] >= tokenAmount);
277         balances[owner] = balances[owner].sub(tokenAmount);
278         balances[target] = balances[target].add(tokenAmount);
279 
280         Transfer(msg.sender, target, tokenAmount);
281     }
282     // the contract owner can set the coin value per 1 ether
283     function setUCCoinPerEther(uint256 coinAmount) external onlyOwner returns (uint256) {
284         require(UCCOIN_PER_ETHER != coinAmount);
285         require(coinAmount >= MINIMUM_SELLING_UCCOIN);
286         
287         UCCOIN_PER_ETHER = coinAmount;
288         UcCoinPriceChanged(UCCOIN_PER_ETHER, now);
289 
290         return UCCOIN_PER_ETHER;
291     }
292     // the contract owner can set the minimum coin value to purchase
293     function setMinUCCoinSellingValue(uint256 coinAmount) external onlyOwner returns (uint256) {
294         MINIMUM_SELLING_UCCOIN = coinAmount;
295         UcCoinMinimumSellingChanged(MINIMUM_SELLING_UCCOIN, now);
296 
297         return MINIMUM_SELLING_UCCOIN;
298     }
299     // the contract owner can add a target address in the blacklist. if true, this means the target address should be blocked.
300     function addUserIntoBlacklist(address target) external onlyOwner returns (address) {
301         return setBlacklist(target, true);
302     }
303     // the contract owner can delete a target address from the blacklist. if the value is false, this means the target address is not blocked anymore.
304     function removeUserFromBlacklist(address target) external onlyOwner returns (address) {
305         return setBlacklist(target, false);
306     }
307     // set up true or false for a target address
308     function setBlacklist(address target, bool shouldBlock) internal onlyOwner returns (address) {
309         blacklistAddresses[target] = shouldBlock;
310         return target;
311     }  
312     // if true, token sale is not available
313     function setStopSelling() external onlyOwner {
314         shouldStopCoinSelling = true;
315         UCCoinSaleIsOff(now);
316     }
317     // if false, token sale is available
318     function setContinueSelling() external onlyOwner {
319         shouldStopCoinSelling = false;
320         UCCoinSaleIsOn(now);
321     }
322 
323     // the contract owner can push all remain UC Coin to the target address.
324     function pushAllRemainToken(address target) external onlyOwner {
325         uint256 remainAmount = balances[msg.sender];
326         balances[msg.sender] = balances[msg.sender].sub(remainAmount);
327         balances[target] = balances[target].add(remainAmount);
328 
329         Transfer(msg.sender, target, remainAmount);
330     }
331     // check target Address contribution
332     function getBuyerContribution(address target) onlyOwner public returns (uint256 contribute) {
333         return contributions[target];
334     }
335 }