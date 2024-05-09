1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  E:\Source\Mozo-NG\smart-contracts\mozo\contracts\MozoXToken.sol
6 // flattened :  Tuesday, 06-Nov-18 08:44:30 UTC
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract Operationable {
57     /**
58      * @dev Get owner
59      */
60 	function getOwner() public view returns(address);
61 	
62     /**
63      * @dev Get ERC20 tokens
64      */
65 	function getERC20() public view returns(OwnerStandardERC20);
66 	/*
67 	 * @dev check whether is operation wallet
68 	*/
69 	function isOperationWallet(address _wallet) public view returns(bool);
70 }
71 
72 contract Owner {
73     /**
74     * @dev Get smart contract's owner
75     * @return The owner of the smart contract
76     */
77     function owner() public view returns (address);
78     
79     //check address is a valid owner (owner or coOwner)
80     function isValidOwner(address _address) public view returns(bool);
81 
82 }
83 
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     // SafeMath.sub will throw if there is not enough balance.
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256 balance) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender) public view returns (uint256);
127   function transferFrom(address from, address to, uint256 value) public returns (bool);
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 contract OwnerERC20 is ERC20Basic, Owner {
133 }
134 
135 contract ERC20Exchangable is Operationable{
136     //Buy event
137     // _from Bought address
138     // _to Received address
139     // _value Number of tokens
140 	event Buy(address indexed _from, address indexed _to, uint _value);
141 
142     //Sold event
143     // _operation Operational Wallet
144     // _hash Previous transaction hash of initial blockchain
145     // _from Bought address
146     // _to Received address
147     // _value Number of tokens
148     // _fee Fee
149 	event Sold(address indexed _operation, bytes32 _hash, address indexed _from, address indexed _to, uint _value, uint _fee);
150 	
151     /**
152      * @notice This method called by ERC20 smart contract
153      * @dev Buy ERC20 tokens in other blockchain
154      * @param _from Bought address
155      * @param _to The address in other blockchain to transfer tokens to.
156      * @param _value Number of tokens
157      */
158 	function autoBuyERC20(address _from, address _to, uint _value) public;
159     
160     /**
161      * @dev called by Bridge or operational wallet (multisig or none) when a bought event occurs,it will transfer ERC20 tokens to receiver address
162      * @param _hash Transaction hash in other blockchain
163      * @param _from bought address 
164      * @param _to The received address 
165      * @param _value Number of tokens
166      */
167     function sold(bytes32 _hash, address _from, address _to, uint _value) public returns(bool);
168 
169     /**
170      * @dev called by Bridge when a bought event occurs, it will transfer ERC20 tokens to receiver address
171      * @param _hash Transaction hash in other blockchain
172      * @param _from bought address 
173      * @param _to The received address 
174      * @param _value Number of tokens
175      */
176     function soldWithFee(bytes32 _hash, address _from, address _to, uint _value) public returns(bool);
177 }
178 contract OwnerStandardERC20 is ERC20, Owner {
179 }
180 
181 contract StandardToken is ERC20, BasicToken {
182 
183   mapping (address => mapping (address => uint256)) internal allowed;
184 
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
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
206    *
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(address _owner, address _spender) public view returns (uint256) {
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
240   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
241     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Decrease the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
257     uint oldValue = allowed[msg.sender][_spender];
258     if (_subtractedValue > oldValue) {
259       allowed[msg.sender][_spender] = 0;
260     } else {
261       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
262     }
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267 }
268 
269 contract MozoXToken is StandardToken, OwnerERC20 {
270     //token name
271     string public constant name = "Mozo Extension Token";
272 
273     //token symbol
274     string public constant symbol = "MOZOX";
275 
276     //token symbol
277     uint8 public constant decimals = 2;
278 
279     //owner of contract
280     address public owner_;
281     ERC20Exchangable public treasury;
282 
283     modifier onlyOwner() {
284         require(msg.sender == owner_);
285         _;
286     }
287 
288 
289     /**
290      * @notice Should provide _totalSupply = No. tokens * 100
291     */
292     constructor() public {
293         owner_ = msg.sender;
294         // constructor
295         totalSupply_ = 50000000000000;
296         //assign all tokens to owner
297         balances[msg.sender] = totalSupply_;
298         emit Transfer(0x0, msg.sender, totalSupply_);
299     }
300     
301     /**
302      * @dev Set treasury smart contract
303      * @param _treasury Address of smart contract
304     */
305     function setTreasury(address _treasury) public onlyOwner {
306         treasury = ERC20Exchangable(_treasury);
307     }
308 
309     /**
310     * @dev Get smart contract's owner
311     */
312     function owner() public view returns (address) {
313         return owner_;
314     }
315 
316     function isValidOwner(address _address) public view returns(bool) {
317         if (_address == owner_) {
318             return true;
319         }
320         return false;
321     }  
322     
323     /**
324     * @dev batch transferring token
325     * @notice Sender should check whether he has enough tokens to be transferred
326     * @param _recipients List of recipients addresses 
327     * @param _values Values to be transferred
328     */
329     function batchTransfer(address[] _recipients, uint[] _values) public {
330         require(_recipients.length == _values.length);
331         uint length = _recipients.length;
332         for (uint i = 0; i < length; i++) {
333             transfer(_recipients[i], _values[i]);
334         }
335     }
336     
337     /**
338      * @dev transfer token to Treasury smart contract and exchange to Mozo ERC20 tokens
339      * @param _to The address to transfer to.
340      * @param _value The amount to be transferred.
341     */
342     function soldMozo(address _to, uint _value) public returns(bool) {
343         require(_to != address(0));
344         if(transfer(treasury, _value)) {
345             treasury.autoBuyERC20(msg.sender, _to, _value);
346             return true;
347         }
348         return false;
349     }
350 }