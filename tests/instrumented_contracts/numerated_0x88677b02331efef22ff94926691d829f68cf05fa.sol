1 pragma solidity ^0.4.13;
2 
3 //  potprotocol.com
4 //  Decentralized Coffee Pot Control Protocol Contract 
5 //  move along, nothing to see here, only the copy-pasted stuff
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public view returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   /**
51   * @dev transfer token for a specified address
52   * @param _to The address to transfer to.
53   * @param _value The amount to be transferred.
54   */
55   function transfer(address _to, uint256 _value) public returns (bool) {
56     require(_to != address(0));
57     require(_value <= balances[msg.sender]);
58 
59     // SafeMath.sub will throw if there is not enough balance.
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   /**
67   * @dev Gets the balance of the specified address.
68   * @param _owner The address to query the the balance of.
69   * @return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address _owner) public view returns (uint256 balance) {
72     return balances[_owner];
73   }
74 
75 }
76 
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) public view returns (uint256);
79   function transferFrom(address from, address to, uint256 value) public returns (bool);
80   function approve(address spender, uint256 value) public returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract Ownable {
85   address public owner;
86 
87 
88   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90 
91   /**
92    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
93    * account.
94    */
95   function Ownable() public {
96     owner = msg.sender;
97   }
98 
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address newOwner) public onlyOwner {
114     require(newOwner != address(0));
115     OwnershipTransferred(owner, newOwner);
116     owner = newOwner;
117   }
118 
119 }
120 
121 contract Pausable is Ownable {
122     using SafeMath for uint256;
123 
124     event Pause();
125     event Unpause();
126 
127     bool public paused = false;
128  
129 
130     modifier whenNotPaused() {
131         require(!paused || msg.sender == address(this));
132         _;
133     }
134 
135     /**
136      * @dev Modifier to make a function callable only when the contract is paused.
137      */
138     modifier whenPaused() {
139         require(paused);
140         _;
141     }
142 
143     /**
144      * @dev called by the owner to pause, triggers stopped state
145      */
146     function pause() onlyOwner whenNotPaused public {
147         require(msg.sender != address(0));
148         paused = true;
149         Pause();
150     }
151 
152     /**
153      * @dev called by the owner to unpause, returns to normal state
154      */
155     function unpause() onlyOwner whenPaused public {
156         require(msg.sender != address(0));
157         paused = false;
158         Unpause();
159     }
160 }
161 
162 
163 
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167   event Burn(address indexed burner, uint256 value);
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    */
219   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
226     uint256 oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235   
236 
237     /**
238      * @dev Burns a specific amount of tokens.
239      * @param _value The amount of token to be burned.
240      */
241     function burn(uint256 _value) public {
242         require(_value <= balances[msg.sender]);
243         // no need to require value <= totalSupply, since that would imply the
244         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
245     
246         address burner = msg.sender;
247         balances[burner] = balances[burner].sub(_value);
248         totalSupply = totalSupply.sub(_value);
249         Burn(burner, _value);
250     }
251 
252 }
253 
254 contract PausableToken is StandardToken, Pausable {
255   using SafeMath for uint256;
256   /**
257  * @dev StandardToken modified with pausable transfers.
258  **/
259 
260   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
261     return super.transfer(_to, _value);
262   }
263 
264   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
265     return super.transferFrom(_from, _to, _value);
266   }
267 
268   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
269     return super.approve(_spender, _value);
270   }
271 
272   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
273     return super.increaseApproval(_spender, _addedValue);
274   }
275 
276   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
277     return super.decreaseApproval(_spender, _subtractedValue);
278 }
279 
280 
281 }
282 contract PotToken is PausableToken {
283 
284     using SafeMath for uint256;
285     address owner = msg.sender;
286     bool public stop = false;
287     uint256 public totalContribution = 0;
288     uint256 public constant fundingStartTime = 1522587600;                           // crowdsale start time
289     uint256 public constant fundingEndTime = 5404107600;                            // crowdsale end time
290     uint256 public constant tokensPerEthPrice = 200;                                 // token per eth
291     
292     function name() public pure returns (string) { return "Decentralized Coffee Pot Control Protocol"; }
293     function symbol() public pure returns (string) { return "DCPCP"; }
294     function decimals() public  pure  returns (uint8) { return 18; }
295     
296     function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }
297 
298     
299     function getStats() public constant returns (uint256, uint256) { 
300         return (totalContribution, totalSupply);
301     }
302     
303     
304     function stopIt() public onlyOwner returns (bool) {
305         require(!stop);
306         stop = true;
307         return true;
308     }
309         
310     
311     function() external payable {
312         require(!(msg.value == 0)
313         && (!stop)
314         && (now >= fundingStartTime)
315         && (now <= fundingEndTime));
316         uint256 rewardTransferAmount = 0;
317       
318         totalContribution =  (totalContribution.add(msg.value));
319         rewardTransferAmount = (msg.value.mul(tokensPerEthPrice));
320         totalSupply = (totalSupply.add(rewardTransferAmount));
321         balances[msg.sender] = (balances[msg.sender].add(rewardTransferAmount));
322         owner.transfer(msg.value);
323         
324         Transfer(address(this), msg.sender, rewardTransferAmount);
325     }
326 }