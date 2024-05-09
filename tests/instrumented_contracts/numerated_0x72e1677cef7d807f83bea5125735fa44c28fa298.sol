1 pragma solidity 0.4.26;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw an error.
29  * Based off of https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
30  */
31 library SafeMath {
32     /*
33      * Internal functions
34      */
35 
36     function mul(uint256 a, uint256 b)
37         internal
38         pure
39         returns (uint256)
40     {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         assert(c / a == b);
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b)
50         internal
51         pure
52         returns (uint256)
53     {
54         uint256 c = a / b;
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b)
59         internal
60         pure
61         returns (uint256) 
62     {
63         assert(b <= a);
64         return a - b;
65     }
66 
67     function add(uint256 a, uint256 b)
68         internal
69         pure
70         returns (uint256) 
71     {
72         uint256 c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }
77 
78 /**
79  * @title Standard ERC20 token
80  *
81  * @dev Implementation of the basic standard token.
82  * @dev https://github.com/ethereum/EIPs/issues/20
83  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
84 */
85 contract StandardToken is ERC20 {
86     using SafeMath for uint256;
87     address private owner;
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89     event MintFinished();
90     
91     bool public mintingFinished = false;
92 
93   mapping(address => uint256) balances;
94   
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100   /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) onlyOwner public returns (bool) {
106     require(_to != address(0));
107     require(_value <= balances[msg.sender]);
108 
109     // SafeMath.sub will throw if there is not enough balance.
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     emit Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public view returns (uint256 balance) {
122     return balances[_owner];
123   }
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) onlyOwner public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) onlyOwner public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    */
178   function increaseApproval (address _spender, uint _addedValue) onlyOwner public returns (bool) {
179     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184   function decreaseApproval (address _spender, uint _subtractedValue) onlyOwner public returns (bool) {
185     uint oldValue = allowed[msg.sender][_spender];
186     if (_subtractedValue > oldValue) {
187       allowed[msg.sender][_spender] = 0;
188     } else {
189       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190     }
191     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194   
195     /**
196    * @dev Function to transfer token ownership. 
197    */
198   function transferOwnership(address newOwner) public onlyOwner {
199     require(newOwner != address(0));
200     emit OwnershipTransferred(owner, newOwner);
201     owner = newOwner;
202   }
203   
204     modifier canMint() {
205     require(!mintingFinished);
206     _;
207   }
208   
209     /**
210    * @dev Function to stop minting new guild member tokens.
211    * @return True if the operation was successful.
212    */
213   function finishMinting() onlyOwner canMint public returns (bool) {
214     mintingFinished = true;
215     emit MintFinished();
216     return true;
217   }
218 }
219  
220  /**
221  * @title Mintable Tribute Token
222  * @dev Simple ERC20 Token example, with mintable token creation and amendable tribute system
223  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
224  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
225  */
226 contract MintableTributeToken is StandardToken {
227   event Mint(address indexed to, uint256 amount);
228   event MintFinished();
229   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
230   string public symbol;
231   string public name;
232   uint8 public decimals;
233   uint public totalSupply;
234   address public owner;
235   uint public tribute;
236   address public guild;
237   uint8 private amount;
238 
239   bool public mintingFinished = false;
240 
241 constructor(string memory _symbol, string memory _name, uint _totalSupply, address _owner, uint _tribute, address _guild) public {
242     	symbol = _symbol;
243     	name = _name;
244     	decimals = 0;
245     	totalSupply = _totalSupply;
246     	owner = _owner;
247     	tribute = _tribute;
248         guild = _guild;
249     	balances[_owner] = _totalSupply;
250     	emit Transfer(address(0), _owner, _totalSupply);
251 }
252 
253   modifier canMint() {
254     require(!mintingFinished);
255     _;
256   }
257   
258   modifier onlyOwner() {
259     require(msg.sender == owner);
260     _;
261   }
262   
263   /**
264    * @dev Function to update tribute amount for guild token mint. 
265    */
266   function updateTribute(uint _tribute) onlyOwner public {
267     	tribute = _tribute;
268 	}
269     	
270   /**
271    * @dev Function to update guild address for tribute transfer. 
272    */	
273   function updateGuild(address _guild) onlyOwner public {
274     	guild = _guild;
275 	}
276   
277   /**
278    * @dev Function to mint new guild tokens after tribute attached.
279    * @return A boolean that indicates if the operation was successful.
280    */
281   function mint() canMint payable public returns (bool) {
282     require(address(this).balance == tribute, "tribute must be funded");
283     address(guild).transfer(address(this).balance);
284     amount = 1;
285     totalSupply = totalSupply.add(amount);
286     balances[msg.sender] = balances[msg.sender].add(amount);
287     emit Mint(msg.sender, amount);
288     emit Transfer(address(0), msg.sender, amount);
289     return true;
290   }
291 
292   /**
293    * @dev Function to stop minting new guild member tokens.
294    * @return True if the operation was successful.
295    */
296   function finishMinting() onlyOwner canMint public returns (bool) {
297     mintingFinished = true;
298     emit MintFinished();
299     return true;
300   }
301   
302   /**
303    * @dev Function to transfer token ownership. 
304    */
305   function transferOwnership(address newOwner) public onlyOwner {
306     require(newOwner != address(0));
307     emit OwnershipTransferred(owner, newOwner);
308     owner = newOwner;
309 }
310 }
311 
312 contract Factory {
313 
314     /*
315      *  Events
316      */
317     event ContractInstantiation(address sender, address instantiation);
318 
319     /*
320      *  Storage
321      */
322     mapping(address => bool) public isInstantiation;
323     mapping(address => address[]) public instantiations;
324 
325     /*
326      * Public functions
327      */
328     /// @dev Returns number of instantiations by creator.
329     /// @param creator Contract creator.
330     /// @return Returns number of instantiations by creator.
331     function getInstantiationCount(address creator)
332         public
333         view
334         returns (uint)
335     {
336         return instantiations[creator].length;
337     }
338 
339     /*
340      * Internal functions
341      */
342     /// @dev Registers contract in factory registry.
343     /// @param instantiation Address of contract instantiation.
344     function register(address instantiation)
345         internal
346     {
347         isInstantiation[instantiation] = true;
348         instantiations[msg.sender].push(instantiation);
349         emit ContractInstantiation(msg.sender, instantiation);
350     }
351 }