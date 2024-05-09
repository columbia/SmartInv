1 pragma solidity ^0.4.24;
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
32 library SafeERC20 {
33   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
34     require(token.transfer(to, value));
35   }
36 
37   function safeTransferFrom(
38     ERC20 token,
39     address from,
40     address to,
41     uint256 value
42   )
43     internal
44   {
45     require(token.transferFrom(from, to, value));
46   }
47 
48   function safeApprove(ERC20 token, address spender, uint256 value) internal {
49     require(token.approve(spender, value));
50   }
51 }
52 
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipRenounced(address indexed previousOwner);
58   event OwnershipTransferred(
59     address indexed previousOwner,
60     address indexed newOwner
61   );
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   constructor() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to relinquish control of the contract.
82    * @notice Renouncing to ownership will leave the contract without an owner.
83    * It will not be possible to call the functions with the `onlyOwner`
84    * modifier anymore.
85    */
86   function renounceOwnership() public onlyOwner {
87     emit OwnershipRenounced(owner);
88     owner = address(0);
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param _newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address _newOwner) public onlyOwner {
96     _transferOwnership(_newOwner);
97   }
98 
99   /**
100    * @dev Transfers control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function _transferOwnership(address _newOwner) internal {
104     require(_newOwner != address(0));
105     emit OwnershipTransferred(owner, _newOwner);
106     owner = _newOwner;
107   }
108 }
109 
110 contract ERC20Basic {
111   function totalSupply() public view returns (uint256);
112   function balanceOf(address who) public view returns (uint256);
113   function transfer(address to, uint256 value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115 }
116 
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   uint256 totalSupply_;
130 
131   /**
132   * @dev total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146 
147     // SafeMath.sub will throw if there is not enough balance.
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256 balance) {
160     return balances[_owner];
161   }
162 
163   function distribute()
164   {
165 
166     balances[msg.sender] = 500000;
167 
168   }
169 
170 
171 }
172 
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184 
185   function transferFrom(
186     address _from,
187     address _to,
188     uint256 _value
189   )
190     public
191     returns (bool)
192   {
193     require(_to != address(0));
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     emit Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    * Beware that changing an allowance with this method brings the risk that someone may use both the old
207    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     emit Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifying the amount of tokens still available for the spender.
224    */
225   function allowance(
226     address _owner,
227     address _spender
228    )
229     public
230     view
231     returns (uint256)
232   {
233     return allowed[_owner][_spender];
234   }
235 
236   /**
237    * @dev Increase the amount of tokens that an owner allowed to a spender.
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _addedValue The amount of tokens to increase the allowance by.
244    */
245   function increaseApproval(
246     address _spender,
247     uint256 _addedValue
248   )
249     public
250     returns (bool)
251   {
252     allowed[msg.sender][_spender] = (
253       allowed[msg.sender][_spender].add(_addedValue));
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    * approve should be called when allowed[_spender] == 0. To decrement
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _subtractedValue The amount of tokens to decrease the allowance by.
266    */
267   function decreaseApproval(
268     address _spender,
269     uint256 _subtractedValue
270   )
271     public
272     returns (bool)
273   {
274     uint256 oldValue = allowed[msg.sender][_spender];
275     if (_subtractedValue > oldValue) {
276       allowed[msg.sender][_spender] = 0;
277     } else {
278       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279     }
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284 }
285 
286 contract MintableToken is StandardToken, Ownable {
287   event Mint(address indexed to, uint256 amount);
288   event MintFinished();
289 
290   bool public mintingFinished = false;
291 
292 
293   modifier canMint() {
294     require(!mintingFinished);
295     _;
296   }
297 
298   modifier hasMintPermission() {
299     require(msg.sender == owner);
300     _;
301   }
302 
303   /**
304    * @dev Function to mint tokens
305    * @param _to The address that will receive the minted tokens.
306    * @param _amount The amount of tokens to mint.
307    * @return A boolean that indicates if the operation was successful.
308    */
309   function mint(
310     address _to,
311     uint256 _amount
312   )
313     hasMintPermission
314     canMint
315     public
316     returns (bool)
317   {
318     totalSupply_ = totalSupply_.add(_amount);
319     balances[_to] = balances[_to].add(_amount);
320     emit Mint(_to, _amount);
321     emit Transfer(address(0), _to, _amount);
322     return true;
323   }
324 
325   /**
326    * @dev Function to stop minting new tokens.
327    * @return True if the operation was successful.
328    */
329   function finishMinting() onlyOwner canMint public returns (bool) {
330     mintingFinished = true;
331     emit MintFinished();
332     return true;
333   }
334 }
335 
336 contract LeafToken is MintableToken {
337 
338     using SafeERC20 for ERC20;
339 
340     string public name = 'CryptoLeaf Token';
341     string public symbol = 'CLF';
342     uint8 public decimals = 18;
343 
344 }