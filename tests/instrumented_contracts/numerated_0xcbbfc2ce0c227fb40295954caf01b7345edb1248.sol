1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b,"");
25 
26         return c;
27     }
28   
29     /**
30     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b > 0,""); // Solidity only automatically asserts when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36   
37         return c;
38     }
39   
40     /**
41     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a,"");
45         uint256 c = a - b;
46 
47         return c;
48     }
49   
50     /**
51     * @dev Adds two numbers, reverts on overflow.
52     */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a,"");
56 
57         return c;
58     }
59   
60     /**
61     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
62     * reverts when dividing by zero.
63     */
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0,"");
66         return a % b;
67     }
68 }
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76     address private _owner;
77   
78   
79     event OwnershipRenounced(address indexed previousOwner);
80     event OwnershipTransferred(
81       address indexed previousOwner,
82       address indexed newOwner
83     );
84   
85   
86     /**
87      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88      * account.
89      */
90     constructor() public {
91         _owner = msg.sender;
92     }
93   
94     /**
95      * @return the address of the owner.
96      */
97     function owner() public view returns(address) {
98         return _owner;
99     }
100   
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOwner() {
105         require(isOwner(),"owner required");
106         _;
107     }
108   
109     /**
110      * @return true if `msg.sender` is the owner of the contract.
111      */
112     function isOwner() public view returns(bool) {
113         return msg.sender == _owner;
114     }
115   
116     /**
117      * @dev Allows the current owner to relinquish control of the contract.
118      * @notice Renouncing to ownership will leave the contract without an owner.
119      * It will not be possible to call the functions with the `onlyOwner`
120      * modifier anymore.
121      */
122     function renounceOwnership() public onlyOwner {
123         emit OwnershipRenounced(_owner);
124         _owner = address(0);
125     }
126   
127     /**
128      * @dev Allows the current owner to transfer control of the contract to a newOwner.
129      * @param newOwner The address to transfer ownership to.
130      */
131     function transferOwnership(address newOwner) public onlyOwner {
132         _transferOwnership(newOwner);
133     }
134   
135     /**
136      * @dev Transfers control of the contract to a newOwner.
137      * @param newOwner The address to transfer ownership to.
138      */
139     function _transferOwnership(address newOwner) internal {
140         require(newOwner != address(0),"");
141         emit OwnershipTransferred(_owner, newOwner);
142         _owner = newOwner;
143     }
144 }
145 
146 
147 contract EIP20Interface {
148     /* This is a slight change to the ERC20 base standard.
149     function totalSupply() constant returns (uint256 supply);
150     is replaced with:
151     uint256 public totalSupply;
152     This automatically creates a getter function for the totalSupply.
153     This is moved to the base contract since public getter functions are not
154     currently recognised as an implementation of the matching abstract
155     function by the compiler.
156     */
157     /// total amount of tokens
158     uint256 public totalSupply;
159 
160     /// @param _owner The address from which the balance will be retrieved
161     /// @return The balance
162     function balanceOf(address _owner) public view returns (uint256 balance);
163 
164     /// @notice send `_value` token to `_to` from `msg.sender`
165     /// @param _to The address of the recipient
166     /// @param _value The amount of token to be transferred
167     /// @return Whether the transfer was successful or not
168     function transfer(address _to, uint256 _value) public returns (bool success);
169 
170     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
171     /// @param _from The address of the sender
172     /// @param _to The address of the recipient
173     /// @param _value The amount of token to be transferred
174     /// @return Whether the transfer was successful or not
175     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
176 
177     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
178     /// @param _spender The address of the account able to transfer the tokens
179     /// @param _value The amount of tokens to be approved for transfer
180     /// @return Whether the approval was successful or not
181     function approve(address _spender, uint256 _value) public returns (bool success);
182 
183     /// @param _owner The address of the account owning tokens
184     /// @param _spender The address of the account able to transfer the tokens
185     /// @return Amount of remaining tokens allowed to spent
186     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
187 
188     // solhint-disable-next-line no-simple-event-func-name  
189     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
190     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
191 }
192 
193 
194 contract CryptojoyTokenSeller is Ownable {
195     using SafeMath for uint;
196 
197     uint8 public constant decimals = 18;
198     
199     uint public miningSupply; // minable part
200 
201     uint constant MAGNITUDE = 10**6;
202     uint constant LOG1DOT5 = 405465; // log(1.5) under MAGNITUDE
203     uint constant THREE_SECOND= 15 * MAGNITUDE / 10; // 1.5 under MAGNITUDE
204 
205     uint public a; // paremeter a of the price fuction price = a*log(t)+b, 18 decimals
206     uint public b; // paremeter b of the price fuction price = a*log(t)+b, 18 decimals
207     uint public c; // paremeter exchange rate of eth 
208     uint public blockInterval; // number of blocks where the token price is fixed
209     uint public startBlockNumber; // The starting block that the token can be mint.
210 
211     address public platform;
212     uint public lowerBoundaryETH; // Refuse incoming ETH lower than this value
213     uint public upperBoundaryETH; // Refuse incoming ETH higher than this value
214 
215     uint public supplyPerInterval; // miningSupply / MINING_INTERVAL
216     uint public miningInterval;
217     uint public tokenMint = 0;
218 
219 
220     EIP20Interface public token;
221 
222 
223     /// @dev sets boundaries for incoming tx
224     /// @dev from FoMo3Dlong
225     modifier isWithinLimits(uint _eth) {
226         require(_eth >= lowerBoundaryETH, "pocket lint: not a valid currency");
227         require(_eth <= upperBoundaryETH, "no vitalik, no");
228         _;
229     }
230 
231     /// @dev Initialize the token mint parameters
232     /// @dev Can only be excuted once.
233     constructor(
234         address tokenAddress, 
235         uint _miningInterval,
236         uint _supplyPerInterval,
237         uint _a, 
238         uint _b, 
239         uint _c,
240         uint _blockInterval, 
241         uint _startBlockNumber,
242         address _platform,
243         uint _lowerBoundaryETH,
244         uint _upperBoundaryETH) 
245         public {
246         
247         require(_lowerBoundaryETH < _upperBoundaryETH, "Lower boundary is larger than upper boundary!");
248 
249         token = EIP20Interface(tokenAddress);
250 
251         a = _a;
252         b = _b;
253         c = _c;
254         blockInterval = _blockInterval;
255         startBlockNumber = _startBlockNumber;
256 
257         platform = _platform;
258         lowerBoundaryETH = _lowerBoundaryETH;
259         upperBoundaryETH = _upperBoundaryETH;
260 
261         miningInterval = _miningInterval;
262         supplyPerInterval = _supplyPerInterval;
263     }
264 
265     function changeWithdraw(address _platform) public onlyOwner {
266         platform = _platform;
267     }
268 
269     function changeRate(uint _c) public onlyOwner {
270         c = _c;
271     }
272 
273     function withdraw(address _to) public onlyOwner returns (bool success) {
274         uint remainBalance = token.balanceOf(address(this));
275         return token.transfer(_to, remainBalance);
276     }
277 
278     /// @dev Mint token based on the current token price.
279     /// @dev The token number is limited during each interval.
280     function buy() public isWithinLimits(msg.value) payable {
281        
282         uint currentStage = getCurrentStage(); // from 1 to MINING_INTERVAL
283        
284         require(tokenMint < currentStage.mul(supplyPerInterval), "No token avaiable");
285        
286         uint currentPrice = calculatePrice(currentStage); // 18 decimal
287        
288         uint amountToBuy = msg.value.mul(10**uint(decimals)).div(currentPrice);
289         
290         if(tokenMint.add(amountToBuy) > currentStage.mul(supplyPerInterval)) {
291             amountToBuy = currentStage.mul(supplyPerInterval).sub(tokenMint);
292             token.transfer(msg.sender, amountToBuy);
293             tokenMint = tokenMint.add(amountToBuy);
294             uint refund = msg.value.sub(amountToBuy.mul(currentPrice).div(10**uint(decimals)));
295             msg.sender.transfer(refund);          
296             platform.transfer(msg.value.sub(refund)); 
297         } else {
298             token.transfer(msg.sender, amountToBuy);
299             tokenMint = tokenMint.add(amountToBuy);
300             platform.transfer(msg.value);
301         }
302     }
303 
304     function() public payable {
305         buy();
306     }
307 
308     /// @dev Shows the remaining token of the current token mint phase
309     function tokenRemain() public view returns (uint) {
310         uint currentStage = getCurrentStage();
311         return currentStage * supplyPerInterval - tokenMint;
312     }
313 
314     /// @dev Get the current token mint phase between 1 and MINING_INTERVAL
315     function getCurrentStage() public view returns (uint) {
316         require(block.number >= startBlockNumber, "Not started yet");
317         uint currentStage = (block.number.sub(startBlockNumber)).div(blockInterval) + 1;
318         if (currentStage <= miningInterval) {
319             return currentStage;
320         } else {
321             return miningInterval;
322         }
323     }
324 
325     /// @dev Return the price of one token during the nth stage
326     /// @param stage Current stage from 1 to 365
327     /// @return Price per token
328     function calculatePrice(uint stage) public view returns (uint) {
329         return a.mul(log(stage.mul(MAGNITUDE))).div(MAGNITUDE).add(b).div(c);
330     }
331 
332     /// @dev Return the e based logarithm of x demonstrated by Vitalik
333     /// @param input The actual input (>=1) times MAGNITUDE
334     /// @return result The actual output times MAGNITUDE
335     function log(uint input) internal pure returns (uint) {
336         uint x = input;
337         require(x >= MAGNITUDE, "");
338         if (x == MAGNITUDE) {
339             return 0;
340         }
341         uint result = 0;
342         while (x >= THREE_SECOND) {
343             result += LOG1DOT5;
344             x = x * 2 / 3;
345         }
346         
347         x = x - MAGNITUDE;
348         uint y = x;
349         uint i = 1;
350         while (i < 10) {
351             result = result + (y / i);
352             i += 1;
353             y = y * x / MAGNITUDE;
354             result = result - (y / i);
355             i += 1;
356             y = y * x / MAGNITUDE;
357         }
358         
359         return result;
360     }
361 }