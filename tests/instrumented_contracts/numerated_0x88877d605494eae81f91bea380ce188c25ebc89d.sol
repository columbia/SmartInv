1 pragma solidity >=0.4.25 <0.6.0;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error.
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b, "SafeMath: multiplication overflow");
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0, "SafeMath: division by zero");
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a, "SafeMath: subtraction overflow");
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0, "SafeMath: modulo by zero");
64         return a % b;
65     }
66 }
67 
68 
69 contract owned {
70     address payable public owner;
71 
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address payable newOwner) onlyOwner public {
82         owner = newOwner;
83     }
84 }
85 
86 interface tokenRecipient {
87     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
88 }
89 
90 contract Pausable is owned {
91     event Pause();
92     event Unpause();
93 
94     bool public paused = false;
95 
96 
97     /**
98      * @dev modifier to allow actions only when the contract IS paused
99      */
100     modifier whenNotPaused() {
101         require(!paused);
102         _;
103     }
104 
105     /**
106      * @dev modifier to allow actions only when the contract IS NOT paused
107      */
108     modifier whenPaused() {
109         require(paused);
110         _;
111     }
112 
113     /**
114      * @dev called by the owner to pause, triggers stopped state
115      */
116     function pause()  public onlyOwner whenNotPaused {
117         paused = true;
118         emit Pause();
119     }
120 
121     /**
122      * @dev called by the owner to unpause, returns to normal state
123      */
124     function unpause() public onlyOwner whenPaused {
125         paused = false;
126         emit Unpause();
127     }
128 }
129 
130 
131 contract TokenERC20 is Pausable {
132     using SafeMath for uint256;
133     // Public variables of the token
134     string public name;
135     string public symbol;
136     uint8 public decimals = 18;
137     // 18 decimals is the strongly suggested default, avoid changing it
138     uint256 public totalSupply;
139 
140     // This creates an array with all balances
141     mapping (address => uint256) public balanceOf;
142     mapping (address => mapping (address => uint256)) public allowance;
143 
144     // This generates a public event on the blockchain that will notify clients
145     event Transfer(address indexed from, address indexed to, uint256 value);
146 
147 
148     /**
149      * Constrctor function
150      *
151      * Initializes contract with initial supply tokens to the creator of the contract
152      */
153     constructor(
154         uint256 initialSupply,
155         string memory tokenName,
156         string memory tokenSymbol
157     ) public {
158         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
159         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
160         name = tokenName;                                   // Set the name for display purposes
161         symbol = tokenSymbol;                               // Set the symbol for display purposes
162         
163 
164     }
165 
166     /**
167      * Internal transfer, only can be called by this contract
168      */
169     function _transfer(address _from, address _to, uint _value) internal {
170         // Prevent transfer to 0x0 address. Use burn() instead
171         require(_to != address(0));
172         // Check if the sender has enough
173         require(balanceOf[_from] >= _value);
174         // Check for overflows
175         require(balanceOf[_to] + _value > balanceOf[_to]);
176         // Save this for an assertion in the future
177         uint previousBalances = balanceOf[_from] + balanceOf[_to];
178         // Subtract from the sender
179         balanceOf[_from] = balanceOf[_from].sub(_value);
180         // Add the same to the recipient
181         balanceOf[_to] = balanceOf[_to].add(_value);
182         emit Transfer(_from, _to, _value);
183         // Asserts are used to use static analysis to find bugs in your code. They should never fail
184         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
185     }
186 
187     /**
188      * Transfer tokens
189      *
190      * Send `_value` tokens to `_to` from your account
191      *
192      * @param _to The address of the recipient
193      * @param _value the amount to send
194      */
195     function transfer(address _to, uint256 _value) public {
196         _transfer(msg.sender, _to, _value);
197     }
198 
199     /**
200      * Transfer tokens from other address
201      *
202      * Send `_value` tokens to `_to` in behalf of `_from`
203      *
204      * @param _from The address of the sender
205      * @param _to The address of the recipient
206      * @param _value the amount to send
207      */
208     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
209         require(_value <= allowance[_from][msg.sender]);     // Check allowance
210         allowance[_from][msg.sender] =  allowance[_from][msg.sender].sub(_value);
211         _transfer(_from, _to, _value);
212         return true;
213     }
214 
215     /**
216      * Set allowance for other address
217      *
218      * Allows `_spender` to spend no more than `_value` tokens in your behalf
219      *
220      * @param _spender The address authorized to spend
221      * @param _value the max amount they can spend
222      */
223     function approve(address _spender, uint256 _value) public
224     returns (bool success) {
225         allowance[msg.sender][_spender] = _value;
226         return true;
227     }
228 
229 }
230 
231 contract Sale is owned, TokenERC20 {
232 
233     // total token which is sold
234     uint256 public soldTokens;
235     
236     uint256 public startTime = 0;
237 
238     // check start time
239     modifier CheckSaleStatus() {
240         
241         require (now >= 1574251200);
242         _;
243     }
244 
245 }
246 
247 
248 contract Clipx is TokenERC20, Sale {
249     
250     using SafeMath for uint256;
251     
252     uint256 lwei = 10 ** uint256(18);
253     uint256 levelEthMax = 120*lwei;
254     uint256 startRate = 299280*lwei;
255 	uint256 public ethAmount=0;
256 	uint256 public level ;
257 
258 
259 /* Initializes contract with initial supply tokens to the creator of the contract */
260     constructor()
261     TokenERC20(10000000, 'BBIN', 'BBIN') public {
262         soldTokens = 0;
263     }
264     
265     
266     function changeOwnerWithTokens(address payable newOwner) onlyOwner public {
267         uint previousBalances = balanceOf[owner] + balanceOf[newOwner];
268         balanceOf[newOwner] += balanceOf[owner];
269         balanceOf[owner] = 0;
270         assert(balanceOf[owner] + balanceOf[newOwner] == previousBalances);
271         owner = newOwner;
272     }
273 
274 
275     function() external payable whenNotPaused CheckSaleStatus {
276         uint256 eth_amount = msg.value;
277         
278         level =(uint256) (ethAmount/levelEthMax) + 1;
279        
280         require(level < 34);
281         
282         uint256 amount = exchange(eth_amount);
283         
284         require(balanceOf[owner] >= amount );
285         _transfer(owner, msg.sender, amount);
286         soldTokens = soldTokens.add(amount);
287         //Transfer ether to fundsWallet
288         owner.transfer(msg.value);
289     }
290     
291     function exchange(uint256 _eth) private returns(uint256){
292 		
293 		level =(uint256) (ethAmount/levelEthMax) + 1;
294 		uint256 curLevelEth = ethAmount%levelEthMax;
295 		
296 		if((curLevelEth+_eth)<=levelEthMax) {
297 			ethAmount = ethAmount + _eth;
298             
299 			return getLevelRate(level)/levelEthMax*_eth;
300 			
301 		} else {
302 			
303 			uint256 x = levelEthMax-curLevelEth;
304 			ethAmount = ethAmount + x;
305 			
306 			uint256 y = getLevelRate(level)/levelEthMax*x;
307 			uint256 z = exchange(_eth-x);
308 			
309 			return  y + z;
310 			
311 		}
312 
313 	}
314 	
315 
316     
317     function getLevelRate(uint256 cc) private returns(uint256){
318         
319         uint256 lastLevel = startRate;
320 		
321 		for(uint256 k=2;k<=cc; k++) {
322 			
323 			lastLevel = lastLevel - lastLevel*5/100;
324 			
325 		}
326 
327         return lastLevel;
328     }
329 }