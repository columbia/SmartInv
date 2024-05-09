1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   constructor() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   uint256 totalSupply_;
100 
101   /**
102   * @dev total number of tokens in existence
103   */
104   function totalSupply() public view returns (uint256) {
105     return totalSupply_;
106   }
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     emit Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256 balance) {
130     return balances[_owner];
131   }
132 
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     emit Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     emit Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 contract MintableToken is StandardToken, Ownable {
223   event Mint(address indexed to, uint256 amount);
224   event MintFinished();
225 
226   bool public mintingFinished = false;
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
239   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
240     totalSupply_ = totalSupply_.add(_amount);
241     balances[_to] = balances[_to].add(_amount);
242     emit Mint(_to, _amount);
243     emit Transfer(address(0), _to, _amount);
244     return true;
245   }
246 
247   /**
248    * @dev Function to stop minting new tokens.
249    * @return True if the operation was successful.
250    */
251   function finishMinting() onlyOwner canMint public returns (bool) {
252     mintingFinished = true;
253     emit MintFinished();
254     return true;
255   }
256 }
257 
258 contract KikkeliToken is MintableToken {
259     string public name = "Kikkeli";
260     string public symbol = "KIK";
261     uint8 public decimals = 18;
262 
263     bool public transfersEnabled = false;
264     event TransfersEnabled();
265 
266     // Disable transfers until after the sale
267     modifier whenTransfersEnabled() {
268         require(transfersEnabled);
269         _;
270     }
271 
272     modifier whenTransfersNotEnabled() {
273         require(!transfersEnabled);
274         _;
275     }
276 
277     function enableTransfers() onlyOwner whenTransfersNotEnabled public {
278         transfersEnabled = true;
279         emit TransfersEnabled();
280     }
281 
282     function transfer(address to, uint256 value) public whenTransfersEnabled returns (bool) {
283         return super.transfer(to, value);
284     }
285 
286     function transferFrom(address from, address to, uint256 value) public whenTransfersEnabled returns (bool) {
287         return super.transferFrom(from, to, value);
288     }
289 
290     // Approves and then calls the receiving contract
291     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
292         allowed[msg.sender][_spender] = _value;
293         emit Approval(msg.sender, _spender, _value);
294 
295         // call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
296         // receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
297         // it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
298 
299         // solium-disable-next-line security/no-low-level-calls
300         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
301         return true;
302     }
303 }