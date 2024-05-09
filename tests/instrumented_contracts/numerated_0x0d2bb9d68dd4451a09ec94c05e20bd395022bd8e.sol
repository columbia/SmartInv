1 /**
2  *Submitted for verification at Etherscan.io on 2020-25-08
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 // File: contracts/zeppelin-solidity-1.4/Ownable.sol
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 // File: contracts/zeppelin-solidity-1.4/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   uint256 public totalSupply;
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: contracts/zeppelin-solidity-1.4/SafeMath.sol
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92 
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 contract Pausable is Ownable {
101     bool public isPaused;
102     
103     event Pause(address _owner, uint _timestamp);
104     event Unpause(address _owner, uint _timestamp);
105     
106     modifier whenPaused {
107         require(isPaused);
108         _;
109     }
110     
111     modifier whenNotPaused {
112         require(!isPaused);
113         _;
114     }
115     
116     function pause() public onlyOwner whenNotPaused {
117         isPaused = true;
118         Pause(msg.sender, now);
119     }
120     
121     function unpause() public onlyOwner whenPaused {
122         isPaused = false;
123         Unpause(msg.sender, now);
124     }
125 }
126 
127 contract Whitelist is Ownable {
128     
129     bool public whitelistToggle = false;
130     
131     mapping(address => bool) whitelistedAccounts;
132     
133     modifier onlyWhitelisted(address from, address to) {
134         if(whitelistToggle){
135             require(whitelistedAccounts[from]);
136             require(whitelistedAccounts[to]);
137         }
138         _;
139     }
140     
141     event Whitelisted(address account);
142     event UnWhitelisted(address account);
143     
144     event ToggleWhitelist(address sender, uint timestamp);
145     event UntoggleWhitelist(address sender, uint timestamp);
146     
147     function addWhitelist(address account) public onlyOwner returns(bool) {
148         whitelistedAccounts[account] = true;
149         Whitelisted(account);
150     }
151         
152     function removeWhitelist(address account) public onlyOwner returns(bool) {
153         whitelistedAccounts[account] = false;
154         UnWhitelisted(account);
155     }
156     
157     function toggle() external onlyOwner {
158         whitelistToggle = true;
159         ToggleWhitelist(msg.sender, now);
160     }
161     
162     function untoggle() external onlyOwner {
163         whitelistToggle = false;
164         UntoggleWhitelist(msg.sender, now);
165     }
166     
167     function isWhiteListed(address account) public view returns(bool){
168         return whitelistedAccounts[account];
169     }
170     
171 }
172 
173 // File: contracts/zeppelin-solidity-1.4/BasicToken.sol
174 
175 /**
176  * @title Basic token
177  * @dev Basic version of StandardToken, with no allowances.
178  */
179 contract BasicToken is ERC20Basic, Pausable, Whitelist {
180   using SafeMath for uint256;
181 
182   mapping(address => uint256) balances;
183 
184   /**
185   * @dev transfer token for a specified address
186   * @param _to The address to transfer to.
187   * @param _value The amount to be transferred.
188   */
189   function transfer(address _to, uint256 _value) public whenNotPaused onlyWhitelisted(msg.sender, _to) returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[msg.sender]);
192 
193     // SafeMath.sub will throw if there is not enough balance.
194     balances[msg.sender] = balances[msg.sender].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param _owner The address to query the the balance of.
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address _owner) public view returns (uint256 balance) {
206     return balances[_owner];
207   }
208 
209 }
210 
211 // File: contracts/zeppelin-solidity-1.4/ERC20.sol
212 
213 /**
214  * @title ERC20 interface
215  * @dev see https://github.com/ethereum/EIPs/issues/20
216  */
217 contract ERC20 is ERC20Basic {
218   function allowance(address owner, address spender) public view returns (uint256);
219   function transferFrom(address from, address to, uint256 value) public returns (bool);
220   function approve(address spender, uint256 value) public returns (bool);
221   event Approval(address indexed owner, address indexed spender, uint256 value);
222 }
223 
224 // File: contracts/zeppelin-solidity-1.4/StandardToken.sol
225 
226 /**
227  * @title Standard ERC20 token
228  *
229  * @dev Implementation of the basic standard token.
230  * @dev https://github.com/ethereum/EIPs/issues/20
231  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
232  */
233 contract StandardToken is ERC20, BasicToken {
234 
235   mapping (address => mapping (address => uint256)) internal allowed;
236 
237 
238   /**
239    * @dev Transfer tokens from one address to another
240    * @param _from address The address which you want to send tokens from
241    * @param _to address The address which you want to transfer to
242    * @param _value uint256 the amount of tokens to be transferred
243    */
244   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused onlyWhitelisted(msg.sender, _to) returns (bool) {
245     require(_to != address(0));
246     require(_value <= balances[_from]);
247     require(_value <= allowed[_from][msg.sender]);
248 
249     balances[_from] = balances[_from].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
252     Transfer(_from, _to, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258    *
259    * Beware that changing an allowance with this method brings the risk that someone may use both the old
260    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
261    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
262    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263    * @param _spender The address which will spend the funds.
264    * @param _value The amount of tokens to be spent.
265    */
266   function approve(address _spender, uint256 _value) public returns (bool) {
267     allowed[msg.sender][_spender] = _value;
268     Approval(msg.sender, _spender, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Function to check the amount of tokens that an owner allowed to a spender.
274    * @param _owner address The address which owns the funds.
275    * @param _spender address The address which will spend the funds.
276    * @return A uint256 specifying the amount of tokens still available for the spender.
277    */
278   function allowance(address _owner, address _spender) public view returns (uint256) {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    */
288   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
295     uint oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 
307 contract CRYPTOBUCKS is StandardToken {
308   using SafeMath for uint256;
309 
310   string public name;
311   string public symbol;
312   uint256 public decimals;
313   
314   mapping (address => bool) burners;
315   uint256 public totalBurned;
316   
317   function CRYPTOBUCKS() public {
318      name = "CRYPTOBUCKS";
319      symbol = "CBUCKS";
320      decimals = 2;
321      totalSupply = 1000000000000;
322      totalBurned = 0;
323      
324      balances[msg.sender] = 1000000000000;
325   }
326   
327   event Burned(address indexed owner, uint256 indexed value, uint256 indexed timestamp);
328   event AssignedBurner(address indexed burner, uint256 indexed timestamp);
329   
330   function addBurner(address _burner) public onlyOwner returns (bool) {
331       require(burners[_burner] == false);
332       burners[_burner] = true;
333       
334       AssignedBurner(_burner, now);
335   }
336   
337   function burn(uint256 _amount) public returns (bool) {
338       require(burners[msg.sender] == true);
339       require(balances[msg.sender] >= _amount);
340       
341       balances[msg.sender] = balances[msg.sender].sub(_amount);
342       totalSupply = totalSupply.sub(_amount);
343       totalBurned = totalBurned.add(_amount);
344       
345       Burned(msg.sender, _amount, now);
346   }
347 
348 }