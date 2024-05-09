1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to relinquish control of the contract.
34    */
35   function renounceOwnership() public onlyOwner {
36     emit OwnershipRenounced(owner);
37     owner = address(0);
38   }
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param _newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address _newOwner) public onlyOwner {
45     _transferOwnership(_newOwner);
46   }
47 
48   /**
49    * @dev Transfers control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function _transferOwnership(address _newOwner) internal {
53     require(_newOwner != address(0));
54     emit OwnershipTransferred(owner, _newOwner);
55     owner = _newOwner;
56   }
57 }
58 
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 library SafeMath {
67 
68   /**
69   * @dev Multiplies two numbers, throws on overflow.
70   */
71   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
72     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
73     // benefit is lost if 'b' is also tested.
74     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
75     if (a == 0) {
76       return 0;
77     }
78 
79     c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     // uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return a / b;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   uint256 totalSupply_;
118 
119   /**
120   * @dev total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131   function transfer(address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[msg.sender]);
134 
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     emit Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) public view returns (uint256) {
147     return balances[_owner];
148   }
149 
150 }
151 
152 contract ERC20 is ERC20Basic {
153   function allowance(address owner, address spender)
154     public view returns (uint256);
155 
156   function transferFrom(address from, address to, uint256 value)
157     public returns (bool);
158 
159   function approve(address spender, uint256 value) public returns (bool);
160   event Approval(
161     address indexed owner,
162     address indexed spender,
163     uint256 value
164   );
165 }
166 
167 contract StandardToken is ERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) internal allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(
179     address _from,
180     address _to,
181     uint256 _value
182   )
183     public
184     returns (bool)
185   {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     emit Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    *
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     emit Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(
220     address _owner,
221     address _spender
222    )
223     public
224     view
225     returns (uint256)
226   {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * @dev Increase the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To increment
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _addedValue The amount of tokens to increase the allowance by.
239    */
240   function increaseApproval(
241     address _spender,
242     uint _addedValue
243   )
244     public
245     returns (bool)
246   {
247     allowed[msg.sender][_spender] = (
248       allowed[msg.sender][_spender].add(_addedValue));
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   /**
254    * @dev Decrease the amount of tokens that an owner allowed to a spender.
255    *
256    * approve should be called when allowed[_spender] == 0. To decrement
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _subtractedValue The amount of tokens to decrease the allowance by.
262    */
263   function decreaseApproval(
264     address _spender,
265     uint _subtractedValue
266   )
267     public
268     returns (bool)
269   {
270     uint oldValue = allowed[msg.sender][_spender];
271     if (_subtractedValue > oldValue) {
272       allowed[msg.sender][_spender] = 0;
273     } else {
274       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
275     }
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280 }
281 
282 contract MintableToken is StandardToken, Ownable {
283   event Mint(address indexed to, uint256 amount);
284   event MintFinished();
285 
286   bool public mintingFinished = false;
287 
288 
289   modifier canMint() {
290     require(!mintingFinished);
291     _;
292   }
293 
294   modifier hasMintPermission() {
295     require(msg.sender == owner);
296     _;
297   }
298 
299   /**
300    * @dev Function to mint tokens
301    * @param _to The address that will receive the minted tokens.
302    * @param _amount The amount of tokens to mint.
303    * @return A boolean that indicates if the operation was successful.
304    */
305   function mint(
306     address _to,
307     uint256 _amount
308   )
309     hasMintPermission
310     canMint
311     public
312     returns (bool)
313   {
314     totalSupply_ = totalSupply_.add(_amount);
315     balances[_to] = balances[_to].add(_amount);
316     emit Mint(_to, _amount);
317     emit Transfer(address(0), _to, _amount);
318     return true;
319   }
320 
321   /**
322    * @dev Function to stop minting new tokens.
323    * @return True if the operation was successful.
324    */
325   function finishMinting() onlyOwner canMint public returns (bool) {
326     mintingFinished = true;
327     emit MintFinished();
328     return true;
329   }
330 }
331 
332 contract GoldenThalerToken is MintableToken {
333 
334     string public constant name = 'GoldenThaler Token';
335     string public constant symbol = 'GTA';
336     uint8 public constant decimals = 18;
337 }