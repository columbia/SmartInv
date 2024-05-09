1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38   address public owner;
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46 
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) onlyOwner external {
64     require(newOwner != address(0));
65     // OwnershipTransferred(owner, newOwner);
66    emit OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 library Locklist {
73   
74   struct List {
75     mapping(address => bool) registry;
76   }
77   
78   function add(List storage list, address _addr)
79     internal
80   {
81     list.registry[_addr] = true;
82   }
83 
84   function remove(List storage list, address _addr)
85     internal
86   {
87     list.registry[_addr] = false;
88   }
89 
90   function check(List storage list, address _addr)
91     view
92     internal
93     returns (bool)
94   {
95     return list.registry[_addr];
96   }
97 }
98 
99 contract Locklisted is Ownable  {
100 
101   Locklist.List private _list;
102   
103   modifier onlyLocklisted() {
104     require(Locklist.check(_list, msg.sender) == true);
105     _;
106   }
107 
108   event AddressAdded(address _addr);
109   event AddressRemoved(address _addr);
110   
111   function LocklistedAddress()
112   public
113   {
114     Locklist.add(_list, msg.sender);
115   }
116 
117   function LocklistAddressenable(address _addr) onlyOwner
118     public
119   {
120     Locklist.add(_list, _addr);
121     emit AddressAdded(_addr);
122   }
123 
124   function LocklistAddressdisable(address _addr) onlyOwner
125     public
126   {
127     Locklist.remove(_list, _addr);
128    emit AddressRemoved(_addr);
129   }
130   
131   function LocklistAddressisListed(address _addr) public view  returns (bool)  {
132       return Locklist.check(_list, _addr);
133   }
134 }
135 
136 interface IERC20 {
137   
138   function balanceOf(address _owner) public view returns (uint256);
139   function allowance(address _owner, address _spender) public view returns (uint256);
140   function transfer(address _to, uint256 _value) public returns (bool);
141   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
142   function approve(address _spender, uint256 _value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 
148 
149 
150 
151 
152 contract StandardToken is IERC20, Locklisted {
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155    
156   using SafeMath for uint256;
157   uint256 public totalSupply;
158 
159   mapping(address => uint256) balances;
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     require(!LocklistAddressisListed(_to));
168     require(_to != address(0));
169     require(_value <= balances[msg.sender]);
170     
171     // SafeMath.sub will throw if there is not enough balance.
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174    emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256 balance) {
184     return balances[_owner];
185   } 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
193     require(!LocklistAddressisListed(_to));
194     require(_to != address(0));
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201    emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    *
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217    emit Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Function to check the amount of tokens that an owner allowed to a spender.
223    * @param _owner address The address which owns the funds.
224    * @param _spender address The address which will spend the funds.
225    * @return A uint256 specifying the amount of tokens still available for the spender.
226    */
227   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
228     return allowed[_owner][_spender];
229   }
230 
231   /**
232    * approve should be called when allowed[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    */
237   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
238     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
239    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 
257 
258 
259 
260 /**
261  * @title Mintable token
262  * @dev Simple ERC20 Token example, with mintable token creation
263  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
264  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
265  */
266 
267 contract MintableToken is Ownable, StandardToken {
268   event Mint(address indexed to, uint256 amount);
269   event MintFinished();
270   
271   string public constant name = "Vertex Market";
272   string public constant symbol = "VTEX";
273   uint8 public constant decimals = 5;  // 18 is the most common number of decimal places
274   bool public mintingFinished = false;
275   
276   // This notifies clients about the amount burnt
277    event Burn(address indexed from, uint256 value);
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     require(!LocklistAddressisListed(_to));
292     totalSupply = totalSupply.add(_amount);
293     require(totalSupply <= 30000000000000);
294     balances[_to] = balances[_to].add(_amount);
295     emit  Mint(_to, _amount);
296     emit Transfer(address(0), _to, _amount);
297     
298     return true;
299   }
300 
301   /**
302    * @dev Function to stop minting new tokens.
303    * @return True if the operation was successful.
304    */
305   function finishMinting() onlyOwner canMint public returns (bool) {
306     mintingFinished = true;
307     emit MintFinished();
308     return true;
309   }
310   
311   function burn(uint256 _value) onlyOwner public {
312     require(_value <= balances[msg.sender]);
313     address burner = msg.sender;
314     balances[burner] = balances[burner].sub(_value);
315     totalSupply = totalSupply.sub(_value);
316     Burn(burner, _value);
317 }
318   
319 
320 }
321 
322 
323 
324 
325 //Change and check days and discounts
326 contract Vertex_Token is  MintableToken {
327     using SafeMath for uint256;
328 
329     // The token being sold
330     MintableToken  token;
331 
332    
333 
334     
335     // total supply of tokens
336     function totalTokenSupply()  internal returns (uint256) {
337         return token.totalSupply();
338     }
339 }