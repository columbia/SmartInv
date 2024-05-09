1 pragma solidity ^0.4.19;
2 
3 //vicent nos & enrique santos
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
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() internal {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 //////////////////////////////////////////////////////////////
78 //                                                          //
79 //  MineBlocks, ERC20  //
80 //                                                          //
81 //////////////////////////////////////////////////////////////
82 
83 
84 contract MineBlocks is Ownable {
85   uint256 public totalSupply;
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   mapping(address => uint256) holded;
91 
92   event Transfer(address indexed from, address indexed to, uint256 value);
93 
94  event Approval(address indexed owner, address indexed spender, uint256 value);
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104 
105     // SafeMath.sub will throw if there is not enough balance.
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     holded[_to]=block.number;
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     holded[_to]=block.number;
139     balances[_to] = balances[_to].add(_value);
140 
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     Transfer(_from, _to, _value);
143     return true;
144   }
145 
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210     string public constant standard = "ERC20 MineBlocks";
211 
212     /* Public variables for the ERC20 token, defined when calling the constructor */
213     string public name;
214     string public symbol;
215     uint8 public constant decimals = 8; // hardcoded to be a constant
216 
217     // Contract variables and constants
218     uint256 public constant minPrice = 10e12;
219     uint256 public buyPrice = minPrice;
220 
221     uint256 public tokenReward = 0;
222     // constant to simplify conversion of token amounts into integer form
223     uint256 private constant tokenUnit = uint256(10)**decimals;
224     
225     // Spread in parts per 100 millions, such that expressing percentages is 
226     // just to append the postfix 'e6'. For example, 4.53% is: spread = 4.53e6
227     address public mineblocksAddr = 0x0d518b5724C6aee0c7F1B2eB1D89d62a2a7b1b58;
228 
229     //Declare logging events
230     event LogDeposit(address sender, uint amount);
231 
232     /* Initializes contract with initial supply tokens to the creator of the contract */
233     function MineBlocks(uint256 initialSupply, string tokenName, string tokenSymbol) public {
234         balances[msg.sender] = initialSupply; // Give the creator all initial tokens
235         totalSupply = initialSupply;  // Update total supply
236         name = tokenName;             // Set the name for display purposes
237         symbol = tokenSymbol;         // Set the symbol for display purposes
238 
239     }
240 
241     function () public payable {
242         buy();   // Allow to buy tokens sending ether direcly to contract
243     }
244     
245 
246     modifier status() {
247         _;  // modified function code should go before prices update
248 
249 		if(balances[this]>900000000000000){
250 			buyPrice=1500000000000000;
251 		}else if(balances[this]>800000000000000 && balances[this]<=900000000000000){
252 
253 			buyPrice=2000000000000000;
254 		}else if(balances[this]>700000000000000 && balances[this]<=800000000000000){
255 
256 			buyPrice=2500000000000000;
257 		}else if(balances[this]>600000000000000 && balances[this]<=700000000000000){
258 
259 			buyPrice=3000000000000000;
260 		}else{
261 
262 			buyPrice=4000000000000000;
263 		}
264 
265         
266     }
267 
268     function deposit() public payable status returns(bool success) {
269         // Check for overflows;
270         assert (this.balance + msg.value >= this.balance); // Check for overflows
271    		tokenReward=this.balance/totalSupply;
272         //executes event to reflect the changes
273         LogDeposit(msg.sender, msg.value);
274         
275         return true;
276     }
277 
278 	function withdrawReward() public status{
279 
280 		
281 		   if(block.number-holded[msg.sender]>172800){ //1 month
282 
283 			holded[msg.sender]=block.number;
284 
285 			//send eth to owner address
286 			msg.sender.transfer(tokenReward*balances[msg.sender]);
287 			
288 			//executes event ro register the changes
289 			LogWithdrawal(msg.sender, tokenReward*balances[msg.sender]);
290 
291 		}
292 	}
293 
294 
295 	event LogWithdrawal(address receiver, uint amount);
296 	
297 	function withdraw(uint value) public onlyOwner {
298 		//send eth to owner address
299 		msg.sender.transfer(value);
300 		//executes event ro register the changes
301 		LogWithdrawal(msg.sender, value);
302 	}
303 
304     function buy() public payable status{
305         require (msg.sender.balance >= msg.value);  // Check if the sender has enought eth to buy
306         assert (msg.sender.balance + msg.value >= msg.sender.balance); //check for overflows
307          
308         uint256 tokenAmount = (msg.value / buyPrice)*tokenUnit ;  // calculates the amount
309 
310         this.transfer(msg.sender, tokenAmount);
311         mineblocksAddr.transfer(msg.value);
312     }
313 
314 
315     /* Approve and then communicate the approved contract in a single tx */
316     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner returns (bool success) {    
317 
318         tokenRecipient spender = tokenRecipient(_spender);
319 
320         if (approve(_spender, _value)) {
321             spender.receiveApproval(msg.sender, _value, this, _extraData);
322             return true;
323         }
324     }
325 }
326 
327 
328 contract tokenRecipient {
329     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public ; 
330 }