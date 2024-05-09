1 pragma solidity ^0.4.22;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
5 }
6 
7 // copy from openzeppelin-solidity/contracts/math/SafeMath.sol
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     if (a == 0) {
19       return 0;
20     }
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   constructor() public  {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public  onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is Ownable {
99   event Pause();
100   event Unpause();
101 
102   bool public paused = false;
103 
104 
105   /**
106    * @dev modifier to allow actions only when the contract IS paused
107    */
108   modifier whenNotPaused() {
109     require(!paused);
110     _;
111   }
112 
113   /**
114    * @dev modifier to allow actions only when the contract IS NOT paused
115    */
116   modifier whenPaused {
117     require(paused);
118     _;
119   }
120 
121   /**
122    * @dev called by the owner to pause, triggers stopped state
123    */
124   function pause() external onlyOwner whenNotPaused returns (bool) {
125     paused = true;
126     emit Pause();
127     return true;
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() external onlyOwner whenPaused returns (bool) {
134     paused = false;
135     emit Unpause();
136     return true;
137   }
138 }
139 
140 contract BGCGToken is Pausable {
141 
142   using SafeMath for SafeMath;
143 
144   string public name = "Blockchain Game Coalition Gold";
145   string public symbol = "BGCG";
146   uint8 public decimals = 18;
147   uint256 public totalSupply = 10000000000 * 10 ** uint256(decimals); // 10 billion tokens
148 
149  
150   mapping (address => uint256) public balanceOf;
151   mapping (address => mapping (address => uint256)) public allowance;
152 
153   
154 
155   event Transfer(address indexed from, address indexed to, uint256 value);
156   event Approval(address indexed owner, address indexed spender, uint256 value);
157   event Burn(address indexed from, uint256 value);
158 
159  mapping (address => bool) public frozenAccount;
160  event FrozenFunds(address target, bool frozen);
161 
162 
163 
164  constructor() public payable {
165     balanceOf[msg.sender] = totalSupply;
166     owner = msg.sender;
167   }
168 
169   //make this contract can receive ETH 
170   function() public payable {
171        
172     }
173 
174   
175 //only owner can withdraw all contract's ETH  
176   function withdraw() public onlyOwner {
177       owner.transfer(address(this).balance); 
178     }
179 
180 //msg.sender approve he's allowance to _spender
181   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
182     require(!frozenAccount[msg.sender]);
183     require(!frozenAccount[_spender]);
184    
185     allowance[msg.sender][_spender] = _value;
186 
187     emit Approval(msg.sender,_spender, _value);
188 
189     return true;
190   }
191 
192    
193   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public whenNotPaused returns (bool success) {
194     tokenRecipient spender = tokenRecipient(_spender);
195     if (approve(_spender, _value)) {
196       spender.receiveApproval(msg.sender, _value, this, _extraData);
197       return true;
198       }
199   }
200 
201   
202   function burn(uint256 _value) public whenNotPaused returns (bool success) {
203     require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
204     require(totalSupply >= _value );
205     require( _value > 0 );
206 
207     balanceOf[msg.sender] = SafeMath.sub( balanceOf[msg.sender],_value);            // Subtract from the sender
208     totalSupply = SafeMath.sub(totalSupply, _value);                      // Updates totalSupply
209     emit Burn(msg.sender, _value);
210     return true;
211   }
212 
213   
214   function burnFrom(address _from, uint256 _value) public whenNotPaused returns (bool success) {
215     require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
216     require(_value <= allowance[_from][msg.sender]);    // Check allowance
217     require(totalSupply >= _value );
218     require( _value > 0 );
219 
220     balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);                         // Subtract from the targeted balance
221     allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);             // Subtract from the sender's allowance
222     totalSupply = SafeMath.sub(totalSupply, _value);                              // Update totalSupply
223     emit Burn(_from, _value);
224     return true;
225   }
226 
227 
228 
229 // Send `_value` tokens to `_to` from msg.sender
230  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
231     require( _value > 0 );
232     require(_to != address(0)); 
233     require(msg.sender != _to );// forbit to transfer to himself
234     require(balanceOf[msg.sender] >= _value);
235     require(SafeMath.add(balanceOf[_to],_value) > balanceOf[_to]);  //SafeMath pretect not overflow
236 
237 
238     require(!frozenAccount[msg.sender]);
239     require(!frozenAccount[_to]);
240     
241     uint256 previousBalances = balanceOf[msg.sender] + balanceOf[_to]; 
242 
243     balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender],_value);
244     balanceOf[_to] = SafeMath.add(balanceOf[_to],_value);
245     emit Transfer(msg.sender, _to, _value);
246 
247     // Asserts are used to use static analysis to find bugs in your code. They should never fail
248     assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
249 
250     return true;
251   }
252 
253 //Send `_value` tokens to `_to` from '_from' address,the '_value' can't larger then allowance by '_from' who set to 'msg.sender' 
254 function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
255     require( _value > 0 );
256     require(_to != address(0));
257     require(_from != address(0));
258   
259     require(_value <= balanceOf[_from]);
260     require(_value <= allowance[_from][msg.sender]);
261     require(SafeMath.add(balanceOf[_to],_value) > balanceOf[_to]); //SafeMath pretect not overflow
262 
263     require(!frozenAccount[_from]);
264     require(!frozenAccount[_to]);
265 
266     balanceOf[_from] = SafeMath.sub(balanceOf[_from],_value);
267     balanceOf[_to] = SafeMath.add(balanceOf[_to],_value);
268     allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender],_value);
269     emit Transfer(_from, _to, _value);
270     return true;
271   }
272 
273 //freeze  or unfreeze account
274   function freezeAccount(address target, bool freeze) public onlyOwner {
275     require(target != address(0));
276     frozenAccount[target] = freeze;
277     emit FrozenFunds(target, freeze);
278  }
279 
280 //only the contract owner can mint token
281   function mintToken(address target, uint256 mintedAmount) public whenNotPaused onlyOwner {
282         require( mintedAmount > 0 );
283         require(target != address(0));
284         
285         require(SafeMath.add(balanceOf[target],mintedAmount) >= balanceOf[target]);
286         require(SafeMath.add(totalSupply,mintedAmount) >= totalSupply);
287 
288         balanceOf[target] = SafeMath.add(balanceOf[target],mintedAmount);
289         totalSupply = SafeMath.add(totalSupply,mintedAmount);
290 
291         emit Transfer(owner, target, mintedAmount);
292  }
293 
294 }