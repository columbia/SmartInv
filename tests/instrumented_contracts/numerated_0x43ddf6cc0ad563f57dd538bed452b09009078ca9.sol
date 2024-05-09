1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev Adds onlyOwner modifier. Subcontracts should implement checkOwner to check if caller is owner.
6  */
7 contract Ownable {
8     modifier onlyOwner() {
9         checkOwner();
10         _;
11     }
12 
13     function checkOwner() internal;
14 }
15 
16 /**
17  * @title Pausable
18  * @dev Base contract which allows children to implement an emergency stop mechanism.
19  */
20 contract Pausable is Ownable {
21     event Pause();
22     event Unpause();
23 
24     bool public paused = false;
25 
26 
27     /**
28      * @dev Modifier to make a function callable only when the contract is not paused.
29      */
30     modifier whenNotPaused() {
31         require(!paused);
32         _;
33     }
34 
35     /**
36      * @dev Modifier to make a function callable only when the contract is paused.
37      */
38     modifier whenPaused() {
39         require(paused);
40         _;
41     }
42 
43     /**
44      * @dev called by the owner to pause, triggers stopped state
45      */
46     function pause() onlyOwner whenNotPaused public {
47         paused = true;
48         Pause();
49     }
50 
51     /**
52      * @dev called by the owner to unpause, returns to normal state
53      */
54     function unpause() onlyOwner whenPaused public {
55         paused = false;
56         Unpause();
57     }
58 }
59 
60 /**
61  * @title OwnableImpl
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract OwnableImpl is Ownable {
66     address public owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     function OwnableImpl() public {
75         owner = msg.sender;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     function checkOwner() internal {
82         require(msg.sender == owner);
83     }
84 
85     /**
86      * @dev Allows the current owner to transfer control of the contract to a newOwner.
87      * @param newOwner The address to transfer ownership to.
88      */
89     function transferOwnership(address newOwner) onlyOwner public {
90         require(newOwner != address(0));
91         OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93     }
94 }
95 
96 /**
97  * @title Read-only ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ReadOnlyToken {
101     uint256 public totalSupply;
102     function balanceOf(address who) public constant returns (uint256);
103     function allowance(address owner, address spender) public constant returns (uint256);
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract Token is ReadOnlyToken {
111   function transfer(address to, uint256 value) public returns (bool);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 contract MintableToken is Token {
119     event Mint(address indexed to, uint256 amount);
120 
121     function mint(address _to, uint256 _amount) public returns (bool);
122 }
123 
124 /**
125  * @title SafeMath
126  * @dev Math operations with safety checks that throw on error
127  * @dev this version copied from zeppelin-solidity, constant changed to pure
128  */
129 library SafeMath {
130     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131         if (a == 0) {
132             return 0;
133         }
134         uint256 c = a * b;
135         assert(c / a == b);
136         return c;
137     }
138 
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         // assert(b > 0); // Solidity automatically throws when dividing by 0
141         uint256 c = a / b;
142         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143         return c;
144     }
145 
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         assert(b <= a);
148         return a - b;
149     }
150 
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         assert(c >= a);
154         return c;
155     }
156 }
157 
158 contract ReadOnlyTokenImpl is ReadOnlyToken {
159     mapping(address => uint256) balances;
160     mapping(address => mapping(address => uint256)) internal allowed;
161 
162     /**
163     * @dev Gets the balance of the specified address.
164     * @param _owner The address to query the the balance of.
165     * @return An uint256 representing the amount owned by the passed address.
166     */
167     function balanceOf(address _owner) public constant returns (uint256 balance) {
168         return balances[_owner];
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param _owner address The address which owns the funds.
174      * @param _spender address The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
178         return allowed[_owner][_spender];
179     }
180 }
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * @dev https://github.com/ethereum/EIPs/issues/20
187  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract TokenImpl is Token, ReadOnlyTokenImpl {
190   using SafeMath for uint256;
191 
192   /**
193   * @dev transfer token for a specified address
194   * @param _to The address to transfer to.
195   * @param _value The amount to be transferred.
196   */
197   function transfer(address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[msg.sender]);
200 
201     // SafeMath.sub will throw if there is not enough balance.
202     balances[msg.sender] = balances[msg.sender].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     emitTransfer(msg.sender, _to, _value);
205     return true;
206   }
207 
208   function emitTransfer(address _from, address _to, uint256 _value) internal {
209     Transfer(_from, _to, _value);
210   }
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
219     require(_to != address(0));
220     require(_value <= balances[_from]);
221     require(_value <= allowed[_from][msg.sender]);
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     emitTransfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    *
233    * Beware that changing an allowance with this method brings the risk that someone may use both the old
234    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint256 _value) public returns (bool) {
241     allowed[msg.sender][_spender] = _value;
242     Approval(msg.sender, _spender, _value);
243     return true;
244   }
245 
246   /**
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    */
252   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
259     uint oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue > oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269 }
270 
271 contract MintableTokenImpl is TokenImpl, MintableToken, Ownable {
272     /**
273      * @dev Function to mint tokens
274      * @param _to The address that will receive the minted tokens.
275      * @param _amount The amount of tokens to mint.
276      * @return A boolean that indicates if the operation was successful.
277      */
278     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
279         totalSupply = totalSupply.add(_amount);
280         balances[_to] = balances[_to].add(_amount);
281         emitMint(_to, _amount);
282         emitTransfer(address(0), _to, _amount);
283         return true;
284     }
285 
286     function emitMint(address _to, uint256 _value) internal {
287         Mint(_to, _value);
288     }
289 }
290 
291 contract FinalToken is Pausable, OwnableImpl, MintableTokenImpl {
292     string public constant name = "SET";
293     string public constant symbol = "SET";
294     uint8 public constant decimals = 18;
295 
296     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
297         return super.transfer(_to, _value);
298     }
299 
300     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
301         return super.transferFrom(_from, _to, _value);
302     }
303 
304     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
305         return super.approve(_spender, _value);
306     }
307 
308     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
309         return super.increaseApproval(_spender, _addedValue);
310     }
311 
312     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
313         return super.decreaseApproval(_spender, _subtractedValue);
314     }
315 }