1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9  
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
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public view returns (uint256) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * approve should be called when allowed[_spender] == 0. To increment
151    * allowed value is better to use this function to avoid 2 calls (and wait until
152    * the first transaction is mined)
153    * From MonolithDAO Token.sol
154    */
155   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
156     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 
161   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 }
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180   address public admin;
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183   event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() public {
190     owner = msg.sender;
191     admin = owner;
192   }
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner || msg.sender == admin);
199     _;
200   }
201 
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to.
205    */
206   function transferOwnership(address newOwner) public onlyOwner {
207     require(newOwner != address(0));
208     OwnershipTransferred(owner, newOwner);
209     owner = newOwner;
210   }
211 
212   function transferAdminship(address newAdmin) public onlyOwner {
213     require(newAdmin != address(0));
214     OwnershipTransferred(admin, newAdmin);
215     admin = newAdmin;
216   }
217 }
218 
219 /**
220  * @title Pausable
221  * @dev Base contract which allows children to implement an emergency stop mechanism.
222  */
223 contract Pausable is Ownable {
224     event Pause(bool _paused);
225     bool public paused = false;
226 
227     /**
228     * @dev Modifier to make a function callable based on pause states.
229     */
230     modifier whenNotPaused() {
231         require(!paused);
232         _;
233     }
234 
235     /**
236     * @dev called by the owner to set new pause flags
237     */
238     function pause() onlyOwner public {
239         paused = !paused;
240         Pause(paused);
241     }
242 
243 }
244 
245 contract PausableToken is StandardToken, Pausable {
246     mapping (address => uint256) public lockMap;
247     event Lock(address _target, uint256 _value);
248 
249     modifier lockValid( address _target, uint256 _value)
250     {
251        require(!paused);
252        require(balances[_target] >= _value + lockMap[_target]);
253         _;
254     }
255 
256     //This is a lock bin operation
257     function lock(address _target, uint256 _value) onlyOwner  returns (bool) {
258         lockMap[_target] = _value;
259         Lock(_target, _value);
260         return true;
261     }
262 
263     function getLock(address _target) returns (uint256) {
264         return lockMap[_target];
265     }
266 
267   function transfer(address _to, uint256 _value) public lockValid(msg.sender, _value) returns (bool) {
268     return super.transfer(_to, _value);
269   }
270 
271   function transferFrom(address _from, address _to, uint256 _value) public lockValid(_from, _value) returns (bool) {
272     return super.transferFrom(_from, _to, _value);
273   }
274 
275   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
276     return super.approve(_spender, _value);
277   }
278 
279   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
280     return super.increaseApproval(_spender, _addedValue);
281   }
282 
283   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
284     return super.decreaseApproval(_spender, _subtractedValue);
285   }
286 }
287 
288 
289 contract KangChain is PausableToken {
290     string  public  constant name = "KangChain";
291     string  public  constant symbol = "KANG";
292     uint8   public  constant decimals = 18;
293     uint256 public constant decimalFactor = 10 ** uint256(decimals);
294     uint256 public totalSupply = 500000000 * decimalFactor;
295 
296     modifier validDestination( address _to )
297     {
298         require(_to != address(0x0));
299         require(_to != address(this));
300         _;
301     }
302 
303     function KangChain() public {
304         // assign the total tokens to KangChain
305         balances[msg.sender] = totalSupply;
306         Transfer(address (0x0), msg.sender, totalSupply);
307     }
308 
309     function transfer(address _to, uint _value) public validDestination(_to) returns (bool) {
310          return super.transfer(_to, _value);
311     }
312 
313     function transferFrom(address _from, address _to, uint _value) public validDestination(_to) returns (bool) {
314         return super.transferFrom(_from, _to, _value);
315     }
316 
317     //This is an additional batch transfer procedure
318     function transferBatch(address[] _tagAddrs, uint[] _values) public returns (bool) {
319        require(_tagAddrs.length == _values.length);
320        uint count = 0;
321        for (uint i = 0; i<_tagAddrs.length; i++) {
322           require(_tagAddrs[i] != address(0x0));
323           require(_tagAddrs[i] != address(this));
324           require(_values[i] > 0);
325           count += _values[i];
326        }
327        require(balances[msg.sender] >= count);
328        
329        for (uint j = 0; j<_tagAddrs.length; j++) {
330           super.transfer(_tagAddrs[j], _values[j]);
331        }
332       return true;
333 
334     }
335     
336     //Contract is destroyed
337     function kill() public onlyOwner {
338         selfdestruct(owner);
339     }
340 }