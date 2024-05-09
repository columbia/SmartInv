1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value <= balances[msg.sender]);
62 
63     // SafeMath.sub will throw if there is not enough balance.
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79 }
80 
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) public constant returns (uint256);
88   function transferFrom(address from, address to, uint256 value) public returns (bool);
89   function approve(address spender, uint256 value) public returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    */
156   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
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
174 
175 /**
176  * @title Ownable
177  * @dev The Ownable contract has an owner address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Ownable {
181   address public owner;
182 
183 
184   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() {
192     owner = msg.sender;
193   }
194 
195 
196   /**
197    * @dev Throws if called by any account other than the owner.
198    */
199   modifier onlyOwner() {
200     require(msg.sender == owner);
201     _;
202   }
203 
204 
205   /**
206    * @dev Allows the current owner to transfer control of the contract to a newOwner.
207    * @param newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address newOwner) onlyOwner public {
210     require(newOwner != address(0));
211     OwnershipTransferred(owner, newOwner);
212     owner = newOwner;
213   }
214 
215 }
216 
217 /**
218  * @title Math
219  * @dev Assorted math operations
220  */
221 
222 library Math {
223   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
224     return a >= b ? a : b;
225   }
226 
227   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
228     return a < b ? a : b;
229   }
230 
231   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
232     return a >= b ? a : b;
233   }
234 
235   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
236     return a < b ? a : b;
237   }
238 }
239 
240 contract GreedTokenICO is StandardToken, Ownable {
241     using SafeMath for uint256;
242     using Math for uint256;
243 
244     string public name = "GREED TOKEN";
245     string public symbol = "GREED";
246     uint256 public decimals = 18;
247 
248     uint256 public constant EXCHANGE_RATE = 700; 
249     uint256 constant TOP_MULT = 1000 * (uint256(10) ** decimals);
250     uint256 public bonusMultiplier = 1000 * (uint256(10) ** decimals);
251     
252     uint256 public totalSupply = 3140000000 * (uint256(10) ** decimals);
253     uint256 public startTimestamp = 1510398671; // timestamp after which ICO will start
254     uint256 public durationSeconds = 2682061; // up to 2017-12-12 12:12:12
255 
256     address public icoWallet = 0xf34175829b0fc596814009df978c77b5cb47b24f;
257 	address public vestContract = 0xfbadbf0a1296d2da94e59d76107c61581d393196;		
258 
259     uint256 public totalRaised; // total ether raised (in wei)
260     uint256 public totalContributors;
261     uint256 public totalTokensSold;
262 
263     uint256 public icoSupply;
264     uint256 public vestSupply;
265     
266     bool public icoOpen = false;
267     bool public icoFinished = false;
268 
269 
270     function GreedTokenICO () public {
271         // Supply of tokens to be distributed 
272         icoSupply = totalSupply.mul(10).div(100); // 10% of supply
273         vestSupply = totalSupply.mul(90).div(100); // 90% of supply
274         
275         // Transfer the tokens to ICO and Vesting Contract
276         // Other tokens will be vested at the end of ICO
277         balances[icoWallet] = icoSupply;
278         balances[vestContract] = vestSupply;
279          
280         Transfer(0x0, icoWallet, icoSupply);
281         Transfer(0x0, vestContract, vestSupply);
282     }
283 
284     function() public isIcoOpen payable {
285         require(msg.value > 0);
286         
287         uint256 valuePlus = 50000000000000000; // 0.05 ETH
288         uint256 ONE_ETH = 1000000000000000000;
289         uint256 tokensLeft = balances[icoWallet];
290         uint256 ethToPay = msg.value;
291         uint256 tokensBought;
292 
293         if (msg.value >= valuePlus) {
294             tokensBought = msg.value.mul(EXCHANGE_RATE).mul(bonusMultiplier).div(ONE_ETH);
295 	        if (tokensBought > tokensLeft) {
296 		        ethToPay = tokensLeft.mul(ONE_ETH).div(bonusMultiplier).div(EXCHANGE_RATE);
297 		        tokensBought = tokensLeft;
298 		        icoFinished = true;
299 		        icoOpen = false;
300 	        }
301 		} else {
302             tokensBought = msg.value.mul(EXCHANGE_RATE);
303 	        if (tokensBought > tokensLeft) {
304 		        ethToPay = tokensLeft.div(EXCHANGE_RATE);
305 		        tokensBought = tokensLeft;
306 		        icoFinished = true;
307 		        icoOpen = false;
308 	        }
309 		}
310 
311         icoWallet.transfer(ethToPay);
312         totalRaised = totalRaised.add(ethToPay);
313         totalContributors = totalContributors.add(1);
314         totalTokensSold = totalTokensSold.add(tokensBought);
315 
316         balances[icoWallet] = balances[icoWallet].sub(tokensBought);
317         balances[msg.sender] = balances[msg.sender].add(tokensBought);
318         Transfer(icoWallet, msg.sender, tokensBought);
319 
320         uint256 refund = msg.value.sub(ethToPay);
321         if (refund > 0) {
322             msg.sender.transfer(refund);
323         }
324 
325         bonusMultiplier = TOP_MULT.sub(totalRaised);
326 
327         if (bonusMultiplier < ONE_ETH) {
328 		        icoFinished = true;
329 		        icoOpen = false;
330         }
331         
332 
333     }
334 
335     function transfer(address _to, uint _value) public isIcoFinished returns (bool) {
336         return super.transfer(_to, _value);
337     }
338 
339     function transferFrom(address _from, address _to, uint _value) public isIcoFinished returns (bool) {
340         return super.transferFrom(_from, _to, _value);
341     }
342 
343     modifier isIcoOpen() {
344         uint256 blocktime = now;
345 
346         require(icoFinished == false);        
347         require(blocktime >= startTimestamp);
348         require(blocktime <= (startTimestamp + durationSeconds));
349         require(totalTokensSold < icoSupply);
350 
351         if (icoOpen == false && icoFinished == false) {
352             icoOpen = true;
353         }
354 
355         _;
356     }
357 
358     modifier isIcoFinished() {
359         uint256 blocktime = now;
360         
361         require(blocktime >= startTimestamp);
362         require(icoFinished == true || totalTokensSold >= icoSupply || (blocktime >= (startTimestamp + durationSeconds)));
363         if (icoFinished == false) {
364             icoFinished = true;
365             icoOpen = false;
366         }
367         _;
368     }
369     
370     function endICO() public isIcoFinished onlyOwner {
371     
372         uint256 tokensLeft;
373         
374         // Tokens left will be transfered to second token sale
375         tokensLeft = balances[icoWallet];
376 		balances[vestContract] = balances[vestContract].add(tokensLeft);
377 		vestSupply = vestSupply.add(tokensLeft);
378 		balances[icoWallet] = 0;
379         Transfer(icoWallet, vestContract, tokensLeft);
380     }
381     
382 }