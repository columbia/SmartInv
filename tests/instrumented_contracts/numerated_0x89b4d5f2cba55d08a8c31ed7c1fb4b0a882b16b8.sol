1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   constructor() public {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));      
69     owner = newOwner;
70   }
71 
72 }
73 
74 
75 contract ERC20Basic {
76   uint256 public totalSupply;
77   function balanceOf(address who) public constant returns (uint256);
78   function transfer(address to, uint256 value) public returns (bool);
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) public returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of. 
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public constant returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 contract StandardToken is ERC20, BasicToken {
121 
122   mapping (address => mapping (address => uint256)) allowed;
123 
124 
125   /**
126    * @dev Transfer tokens from one address to another
127    * @param _from address The address which you want to send tokens from
128    * @param _to address The address which you want to transfer to
129    * @param _value uint256 the amount of tokens to be transferred
130    */
131   function transferFrom(address _from, address _to, uint256 _value)public  returns (bool) {
132     require(_to != address(0));
133 
134     uint _allowance = allowed[_from][msg.sender];
135 
136     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
137     // require (_value <= _allowance);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = _allowance.sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint256 _value) public returns (bool) {
152 
153     // To change the approve amount you first have to reduce the addresses`
154     //  allowance to zero by calling `approve(_spender, 0)` if it is not
155     //  already 0 to mitigate the race condition described here:
156     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
158 
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public returns (uint256 remaining) {
171     return allowed[_owner][_spender];
172   }
173   
174   /**
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until 
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    */
180   function increaseApproval (address _spender, uint _addedValue) public
181     returns (bool success) {
182     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187   function decreaseApproval (address _spender, uint _subtractedValue) public
188     returns (bool success) {
189     uint oldValue = allowed[msg.sender][_spender];
190     if (_subtractedValue > oldValue) {
191       allowed[msg.sender][_spender] = 0;
192     } else {
193       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194     }
195     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199 }
200 
201 contract BurnableToken is StandardToken {
202 
203     /**
204      * @dev Burns a specific amount of tokens.
205      * @param _value The amount of token to be burned.
206      */
207     function burn(uint _value)
208         public
209     {
210         require(_value > 0);
211 
212         address burner = msg.sender;
213         balances[burner] = balances[burner].sub(_value);
214         totalSupply = totalSupply.sub(_value);
215         emit Burn(burner, _value);
216     }
217 
218     event Burn(address indexed burner, uint indexed value);
219 }
220 
221 contract MintableToken is StandardToken, Ownable {
222   event Mint(address indexed to, uint256 amount);
223   event MintFinished();
224 
225   bool public mintingFinished = false;
226 
227 
228   modifier canMint() {
229     require(!mintingFinished);
230     _;
231   }
232 
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will receive the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
240     totalSupply = totalSupply.add(_amount);
241     balances[_to] = balances[_to].add(_amount);
242     emit Mint(_to, _amount);
243     emit Transfer(0x0, _to, _amount);
244     return true;
245   }
246 
247     /**
248   * @dev transfer token for a specified address
249   * @param _to The address to transfer to.
250   * @param _value The amount to be transferred.
251   */
252   function move(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
253     require(_to != address(0));
254 
255     balances[_from] = balances[_from].sub(_value);
256     balances[_to] = balances[_to].add(_value);
257     emit Transfer(_from, _to, _value);
258     
259     return true;
260   }
261   
262   
263   /**
264    * @dev Function to stop minting new tokens.
265    * @return True if the operation was successful.
266    */
267   function finishMinting() public onlyOwner returns (bool) {
268     mintingFinished = true;
269     emit MintFinished();
270     return true;
271   }
272 }
273 
274 
275 
276 
277 
278 
279 contract TokenRecipient {
280 
281     function tokenFallback(address sender, uint256 _value, bytes _extraData) public constant returns (bool) {}
282 
283 }
284 
285 
286 
287 
288 
289 contract GMToken is MintableToken, BurnableToken {
290 
291     string public constant name = "GameMax";
292     string public constant symbol = "GM";
293     uint8 public constant decimals = 3;
294 
295 
296 
297     // --------------------------------------------------------
298 
299     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
300         bool result = super.transferFrom(_from, _to, _value);
301         return result;
302     }
303 
304    
305 
306     function transfer(address _to, uint256 _value) public  returns (bool) {
307         bool result = super.transfer(_to, _value);
308         return result;
309     }
310 
311 
312     function mint(address _to, uint256 _amount)public  onlyOwner canMint returns (bool) {
313         bool result = super.mint(_to, _amount);
314         return result;
315     }
316 
317     function burn(uint256 _value) public {
318         super.burn(_value);
319     }
320 
321     // --------------------------------------------------------
322 
323     function transferAndCall(address _recipient, uint256 _amount, bytes _data) public {
324         require(_recipient != address(0));
325         require(_amount <= balances[msg.sender]);
326 
327         balances[msg.sender] = balances[msg.sender].sub(_amount);
328         balances[_recipient] = balances[_recipient].add(_amount);
329 
330         require(TokenRecipient(_recipient).tokenFallback(msg.sender, _amount, _data));
331         emit Transfer(msg.sender, _recipient, _amount);
332     }
333 
334 }