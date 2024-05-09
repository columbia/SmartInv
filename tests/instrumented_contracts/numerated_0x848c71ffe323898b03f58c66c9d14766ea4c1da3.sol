1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * 
6  * 
7  * Token Details:-
8  * Name: CRYPTOLANCERS
9  * Symbol: CLT
10  * Decimals: 18
11  * Total Supply: 100.000.000
12  * 
13  */
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
27     // benefit is lost if 'b' is also tested.
28     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29     if (a == 0) {
30       return 0;
31     }
32 
33     c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37   
38   
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     // uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return a / b;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74 
75   address public owner;
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81    constructor() public {
82     owner = address(0xEFeAc37a6a5Fb3630313742a2FADa6760C6FF653);
83   }
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner)public onlyOwner {
98     require(newOwner != address(0));
99     owner = newOwner;
100   }
101 }
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/179
107  */
108 contract ERC20Basic is Ownable {
109   uint256 public totalSupply;
110   function balanceOf(address who) public constant returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123   mapping (address => bool) public frozenAccount;
124 
125   event FrozenFunds(
126       address target, 
127       bool frozen
128       );
129       
130   event Burn(
131         address indexed burner, 
132         uint256 value
133         );
134         
135         
136       /**
137    * @dev Function to burn tokens
138    * @param _who The address from which to burn tokens
139    * @param _amount The amount of tokens to burn
140    * 
141    */
142    function burnTokens(address _who, uint256 _amount) public onlyOwner {
143        require(balances[_who] >= _amount);
144        
145        balances[_who] = balances[_who].sub(_amount);
146        
147        totalSupply = totalSupply.sub(_amount);
148        
149        emit Burn(_who, _amount);
150        emit Transfer(_who, address(0), _amount);
151    }
152 
153 
154     /**
155      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
156      * @param target Address to be frozen
157      * @param freeze either to freeze it or not
158      */
159     function freezeAccount(address target, bool freeze) onlyOwner public {
160         frozenAccount[target] = freeze;
161         emit FrozenFunds(target, freeze);
162     }
163     
164   /**
165   * @dev transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value)public returns (bool) {
170     require(!frozenAccount[msg.sender]);
171     
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner)public constant returns (uint256 balance) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 /**
190  * @title ERC20 interface
191  * @dev see https://github.com/ethereum/EIPs/issues/20
192  */
193 contract ERC20 is ERC20Basic {
194   function allowance(address owner, address spender)
195     public view returns (uint256);
196 
197   function transferFrom(address from, address to, uint256 value)
198     public returns (bool);
199 
200   function approve(address spender, uint256 value) public returns (bool);
201   event Approval(
202     address indexed owner,
203     address indexed spender,
204     uint256 value
205   );
206 }
207 
208 /**
209  * @title Standard ERC20 token
210  *
211  * @dev Implementation of the basic standard token.
212  * @dev https://github.com/ethereum/EIPs/issues/20
213  */
214 contract AdvanceToken is ERC20, BasicToken {
215 
216   mapping (address => mapping (address => uint256)) internal allowed;
217   
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param _from address The address which you want to send tokens from
222    * @param _to address The address which you want to transfer to
223    * @param _value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(
226     address _from,
227     address _to,
228     uint256 _value
229   )
230     public
231     returns (bool)
232   {
233     require(_to != address(0));
234     require(_value <= balances[_from]);
235     require(_value <= allowed[_from][msg.sender]);
236     require(!frozenAccount[_from]);                     // Check if sender is frozen
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241     emit Transfer(_from, _to, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     allowed[msg.sender][_spender] = _value;
257     emit Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(
268     address _owner,
269     address _spender
270    )
271     public
272     view
273     returns (uint256)
274   {
275     return allowed[_owner][_spender];
276   }
277 
278   /**
279    * @dev Increase the amount of tokens that an owner allowed to a spender.
280    *
281    * approve should be called when allowed[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseApproval(
289     address _spender,
290     uint _addedValue
291   )
292     public
293     returns (bool)
294   {
295     allowed[msg.sender][_spender] = (
296       allowed[msg.sender][_spender].add(_addedValue));
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301   /**
302    * @dev Decrease the amount of tokens that an owner allowed to a spender.
303    *
304    * approve should be called when allowed[_spender] == 0. To decrement
305    * allowed value is better to use this function to avoid 2 calls (and wait until
306    * the first transaction is mined)
307    * From MonolithDAO Token.sol
308    * @param _spender The address which will spend the funds.
309    * @param _subtractedValue The amount of tokens to decrease the allowance by.
310    */
311   function decreaseApproval(
312     address _spender,
313     uint _subtractedValue
314   )
315     public
316     returns (bool)
317   {
318     uint oldValue = allowed[msg.sender][_spender];
319     if (_subtractedValue > oldValue) {
320       allowed[msg.sender][_spender] = 0;
321     } else {
322       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
323     }
324     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
325     return true;
326   }
327 
328 }
329 
330 
331 contract CRYPTOLANCERSToken is AdvanceToken {
332 
333   string public constant name = "CRYPTOLANCERS";
334   string public constant symbol = "CLT";
335   uint256 public constant decimals = 18;
336 
337   uint256 public constant INITIAL_SUPPLY = 100000000 * 10**decimals;
338 
339   /**
340    * @dev Upon deplyment the the total supply will be credited to the owner
341    */
342   constructor() public {
343     totalSupply = INITIAL_SUPPLY;
344     balances[0xEFeAc37a6a5Fb3630313742a2FADa6760C6FF653] = totalSupply;
345  }
346 }