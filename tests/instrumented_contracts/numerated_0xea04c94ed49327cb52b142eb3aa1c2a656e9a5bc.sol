1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract Destructible is Ownable {
67 
68   function Destructible() public payable { }
69 
70   /**
71    * @dev Transfers the current balance to the owner and terminates the contract.
72    */
73   function destroy() onlyOwner public {
74     selfdestruct(owner);
75   }
76 
77   function destroyAndSend(address _recipient) onlyOwner public {
78     selfdestruct(_recipient);
79   }
80 }
81 
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public constant returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
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
105     Transfer(msg.sender, _to, _value);
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
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) public constant returns (uint256);
122   function transferFrom(address from, address to, uint256 value) public returns (bool);
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 contract StandardToken is ERC20, BasicToken {
128 
129   mapping (address => mapping (address => uint256)) allowed;
130 
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140 
141     uint256 _allowance = allowed[_from][msg.sender];
142 
143     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
144     // require (_value <= _allowance);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = _allowance.sub(_value);
149     Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint256 specifying the amount of tokens still available for the spender.
174    */
175   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
176     return allowed[_owner][_spender];
177   }
178 
179   /**
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    */
185   function increaseApproval (address _spender, uint _addedValue) public
186     returns (bool success) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   function decreaseApproval (address _spender, uint _subtractedValue) public
193     returns (bool success) {
194     uint oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204 }
205 
206 contract MintableToken is StandardToken, Ownable {
207   event Mint(address indexed to, uint256 amount);
208   event MintFinished();
209 
210   bool public mintingFinished = false;
211 
212 
213   modifier canMint() {
214     require(!mintingFinished);
215     _;
216   }
217 
218   /**
219    * @dev Function to mint tokens
220    * @param _to The address that will receive the minted tokens.
221    * @param _amount The amount of tokens to mint.
222    * @return A boolean that indicates if the operation was successful.
223    */
224   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
225     totalSupply = totalSupply.add(_amount);
226     balances[_to] = balances[_to].add(_amount);
227     Mint(_to, _amount);
228     Transfer(0x0, _to, _amount);
229     return true;
230   }
231 
232   /**
233    * @dev Function to stop minting new tokens.
234    * @return True if the operation was successful.
235    */
236   function finishMinting() onlyOwner public returns (bool) {
237     mintingFinished = true;
238     MintFinished();
239     return true;
240   }
241 }
242 
243 contract TimeLockedToken is MintableToken
244 {
245 
246   /**
247    * @dev Timestamp after which tokens can be transferred.
248    */
249   uint256 public unlockTime = 0;
250 
251   /**
252    * @dev Checks whether it can transfer or otherwise throws.
253    */
254   modifier canTransfer() {
255     require(unlockTime == 0 || block.timestamp > unlockTime);
256     _;
257   }
258 
259   /**
260    * @dev Sets the date and time since which tokens can be transfered.
261    * It can only be moved back, and not in the past.
262    * @param _unlockTime New unlock timestamp.
263    */
264   function setUnlockTime(uint256 _unlockTime) public onlyOwner {
265     require(unlockTime == 0 || _unlockTime < unlockTime);
266     require(_unlockTime >= block.timestamp);
267 
268     unlockTime = _unlockTime;
269   }
270 
271   /**
272    * @dev Checks modifier and allows transfer if tokens are not locked.
273    * @param _to The address that will recieve the tokens.
274    * @param _value The amount of tokens to be transferred.
275    */
276   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
277     return super.transfer(_to, _value);
278   }
279 
280   /**
281   * @dev Checks modifier and allows transfer if tokens are not locked.
282   * @param _from The address that will send the tokens.
283   * @param _to The address that will recieve the tokens.
284   * @param _value The amount of tokens to be transferred.
285   */
286   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
287     return super.transferFrom(_from, _to, _value);
288   }
289 
290 }
291 
292 contract DemeterToken is TimeLockedToken, Destructible
293 {
294   string public name = "Demeter";
295   string public symbol = "DMT";
296   uint256 public decimals = 18;
297 }