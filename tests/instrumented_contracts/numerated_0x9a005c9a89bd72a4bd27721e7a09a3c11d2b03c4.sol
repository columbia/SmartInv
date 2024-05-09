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
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) public constant returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) public constant returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner public {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract LimitedTransferToken is ERC20 {
81 
82   /**
83    * @dev Checks whether it can transfer or otherwise throws.
84    */
85   modifier canTransfer(address _sender, uint256 _value) {
86    require(_value <= transferableTokens(_sender, uint64(now)));
87    _;
88   }
89 
90   /**
91    * @dev Checks modifier and allows transfer if tokens are not locked.
92    * @param _to The address that will receive the tokens.
93    * @param _value The amount of tokens to be transferred.
94    */
95   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
96     return super.transfer(_to, _value);
97   }
98 
99   /**
100   * @dev Checks modifier and allows transfer if tokens are not locked.
101   * @param _from The address that will send the tokens.
102   * @param _to The address that will receive the tokens.
103   * @param _value The amount of tokens to be transferred.
104   */
105   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
106     return super.transferFrom(_from, _to, _value);
107   }
108 
109   /**
110    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
111    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
112    * specific logic for limiting token transferability for a holder over time.
113    */
114   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
115     return balanceOf(holder);
116   }
117 }
118 
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131 
132     // SafeMath.sub will throw if there is not enough balance.
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param _owner The address to query the the balance of.
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address _owner) public constant returns (uint256 balance) {
145     return balances[_owner];
146   }
147 
148 }
149 
150 contract StandardToken is ERC20, BasicToken {
151 
152   mapping (address => mapping (address => uint256)) allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163 
164     uint256 _allowance = allowed[_from][msg.sender];
165 
166     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
167     // require (_value <= _allowance);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = _allowance.sub(_value);
172     Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) public returns (bool) {
187     allowed[msg.sender][_spender] = _value;
188     Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    */
208   function increaseApproval (address _spender, uint _addedValue)
209     returns (bool success) {
210     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   function decreaseApproval (address _spender, uint _subtractedValue)
216     returns (bool success) {
217     uint oldValue = allowed[msg.sender][_spender];
218     if (_subtractedValue > oldValue) {
219       allowed[msg.sender][_spender] = 0;
220     } else {
221       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222     }
223     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227 }
228 
229 contract MintableToken is StandardToken, Ownable {
230   event Mint(address indexed to, uint256 amount);
231   event MintFinished();
232 
233   bool public mintingFinished = false;
234 
235 
236   modifier canMint() {
237     require(!mintingFinished);
238     _;
239   }
240 
241   /**
242    * @dev Function to mint tokens
243    * @param _to The address that will receive the minted tokens.
244    * @param _amount The amount of tokens to mint.
245    * @return A boolean that indicates if the operation was successful.
246    */
247   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
248     totalSupply = totalSupply.add(_amount);
249     balances[_to] = balances[_to].add(_amount);
250     Mint(_to, _amount);
251     Transfer(0x0, _to, _amount);
252     return true;
253   }
254 
255   /**
256    * @dev Function to stop minting new tokens.
257    * @return True if the operation was successful.
258    */
259   function finishMinting() onlyOwner public returns (bool) {
260     mintingFinished = true;
261     MintFinished();
262     return true;
263   }
264 }
265 
266 contract StarterCoin is MintableToken, LimitedTransferToken {
267 
268     string public constant name = "StarterCoin";
269     string public constant symbol = "STAC";
270     uint8 public constant decimals = 18;
271 
272     uint256 public endTimeICO;
273     address public bountyWallet;
274 
275     function StarterCoin(uint256 _endTimeICO, address _bountyWallet) {
276         endTimeICO = _endTimeICO;
277         bountyWallet = _bountyWallet;
278     }
279 
280     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
281         // allow transfers after the end of ICO
282         return (time > endTimeICO) || (holder == bountyWallet) ? balanceOf(holder) : 0;
283     }
284 
285 }