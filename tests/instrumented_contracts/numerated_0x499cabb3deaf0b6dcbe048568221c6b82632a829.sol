1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
13   {
14     if (a == 0 || b == 0) 
15     {
16       return 0;
17     }
18     c = a * b;
19     require(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) 
27   {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     require(c >= a && c >=b);
48     return c;
49   }
50 }
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20Extended {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   function allowance(address owner, address spender) public view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public returns (bool);
62   function approve(address spender, uint256 value) public returns (bool);
63 
64 }
65 
66 contract MintableToken is ERC20Extended{
67 
68   using SafeMath for uint256;
69   address public  owner;
70   uint256 private totalSupply_;
71   bool    public  mintingFinished = false;
72   
73   event Transfer(address indexed from, address indexed to, uint256 value);
74   event Approval(address indexed owner,address indexed spender,uint256 value);
75   event OwnershipRenounced(address indexed previousOwner);
76   event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
77   event Burn(address indexed burner, uint256 value);
78   event Mint(address indexed to, uint256 amount);
79   event MintFinished();
80 
81   mapping(address => uint256) balances;
82   mapping (address => mapping (address => uint256)) internal allowed;
83   modifier canMint() {require(!mintingFinished);_;}
84   modifier hasMintPermission() { require(msg.sender == owner); _;}
85   modifier onlyOwner() { require(msg.sender == owner);_;}
86 
87   constructor() public {owner = msg.sender;}
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) public onlyOwner 
94   {
95     require(newOwner != address(0));
96     emit OwnershipTransferred(owner, newOwner);
97     owner = newOwner;
98   }
99 
100   /**
101    * @dev Allows the current owner to relinquish control of the contract.
102    */
103   function renounceOwnership() public onlyOwner 
104   {
105     emit OwnershipRenounced(owner);
106     owner = address(0);
107   }
108 
109   /**
110   * @dev total number of tokens in existence
111   */
112   function totalSupply() public view returns (uint256) 
113   {
114     return totalSupply_;
115   }
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) public returns (bool) 
123   {
124     require(_to != address(0));
125     require(_value <= balances[msg.sender]);
126 
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     emit Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param _owner The address to query the the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address _owner) public view returns (uint256) 
139   {
140     return balances[_owner];
141   }
142   
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from,address _to,uint256 _value) public returns (bool)
150   {
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     emit Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) 
173   {
174     allowed[msg.sender][_spender] = _value;
175     emit Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(address _owner,address _spender) public view returns (uint256)
186   {
187     return allowed[_owner][_spender];
188   }
189 
190   /**
191    * @dev Increase the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To increment
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _addedValue The amount of tokens to increase the allowance by.
199    */
200   function increaseApproval(address _spender,uint _addedValue) public returns (bool)
201   {
202     allowed[msg.sender][_spender] = (
203     allowed[msg.sender][_spender].add(_addedValue));
204     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 
208   /**
209    * @dev Decrease the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To decrement
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _subtractedValue The amount of tokens to decrease the allowance by.
217    */
218   function decreaseApproval(address _spender,uint _subtractedValue) public returns (bool)
219   {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Burns a specific amount of tokens.
232    * @param _value The amount of token to be burned.
233    */
234   function burn(uint256 _value) public 
235   {
236     _burn(msg.sender, _value);
237   }
238 
239   function _burn(address _who, uint256 _value) internal 
240   {
241     require(_value <= balances[_who]);
242     // no need to require value <= totalSupply, since that would imply the
243     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
244 
245     balances[_who] = balances[_who].sub(_value);
246     totalSupply_ = totalSupply_.sub(_value);
247     emit Burn(_who, _value);
248     emit Transfer(_who, address(0), _value);
249   }
250 
251  /**
252    * @dev Burns a specific amount of tokens from the target address and decrements allowance
253    * @param _from address The address which you want to send tokens from
254    * @param _value uint256 The amount of token to be burned
255    */
256   function burnFrom(address _from, uint256 _value) public 
257   {
258     require(_value <= allowed[_from][msg.sender]);
259     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
260     // this function needs to emit an event with the updated approval.
261     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262     _burn(_from, _value);
263   }
264 
265   /**
266    * @dev Function to mint tokens
267    * @param _to The address that will receive the minted tokens.
268    * @param _amount The amount of tokens to mint.
269    * @return A boolean that indicates if the operation was successful.
270    */
271   function mint(address _to,uint256 _amount) hasMintPermission canMint public returns (bool)
272   {
273     totalSupply_ = totalSupply_.add(_amount);
274     balances[_to] = balances[_to].add(_amount);
275     emit Mint(_to, _amount);
276     emit Transfer(address(0), _to, _amount);
277     return true;
278   }
279 
280   /**
281    * @dev Function to stop minting new tokens.
282    * @return True if the operation was successful.
283    */
284   function finishMinting() onlyOwner canMint public returns (bool) 
285   {
286     mintingFinished = true;
287     emit MintFinished();
288     return true;
289   }
290 
291 }
292 
293 contract VIVACoin is MintableToken {
294     string public symbol = "VIVA";
295     string public  name = "VIVA COIN";
296     uint8 public decimals = 8;
297 }