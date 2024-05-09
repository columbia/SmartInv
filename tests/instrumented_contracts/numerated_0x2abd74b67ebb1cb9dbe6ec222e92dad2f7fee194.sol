1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(
232     address _spender,
233     uint _subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 contract MultiOwnable {
251     mapping (address => bool) owners;
252     address unremovableOwner;
253 
254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255     event OwnershipExtended(address indexed host, address indexed guest);
256     event OwnershipRemoved(address indexed removedOwner);
257 
258     modifier onlyOwner() {
259         require(owners[msg.sender]);
260         _;
261     }
262 
263     constructor() public {
264         owners[msg.sender] = true;
265         unremovableOwner = msg.sender;
266     }
267 
268     function addOwner(address guest) onlyOwner public {
269         require(guest != address(0));
270         owners[guest] = true;
271         emit OwnershipExtended(msg.sender, guest);
272     }
273 
274     function removeOwner(address removedOwner) onlyOwner public {
275         require(removedOwner != address(0));
276         require(unremovableOwner != removedOwner);
277         delete owners[removedOwner];
278         emit OwnershipRemoved(removedOwner);
279     }
280 
281     function transferOwnership(address newOwner) onlyOwner public {
282         require(newOwner != address(0));
283         require(unremovableOwner != msg.sender);
284         owners[newOwner] = true;
285         delete owners[msg.sender];
286         emit OwnershipTransferred(msg.sender, newOwner);
287     }
288 
289     function isOwner(address addr) public view returns(bool){
290         return owners[addr];
291     }
292 }
293 
294 contract FCT is StandardToken, MultiOwnable {
295 
296     using SafeMath for uint256;
297 
298     uint256 public constant TOTAL_CAP = 2200000000;
299 
300     string public constant name = "FirmaChain Token";
301     string public constant symbol = "FCT";
302     uint256 public constant decimals = 18;
303 
304     bool isTransferable = false;
305 
306     constructor() public {
307         totalSupply_ = TOTAL_CAP.mul(10 ** decimals);
308         balances[msg.sender] = totalSupply_;
309         emit Transfer(address(0), msg.sender, balances[msg.sender]);
310     }
311 
312     function unlock() external onlyOwner {
313         isTransferable = true;
314     }
315 
316     function lock() external onlyOwner {
317         isTransferable = false;
318     }
319 
320     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
321         require(isTransferable || owners[msg.sender]);
322         return super.transferFrom(_from, _to, _value);
323     }
324 
325     function transfer(address _to, uint256 _value) public returns (bool) {
326         require(isTransferable || owners[msg.sender]);
327         return super.transfer(_to, _value);
328     }
329 
330     // NOTE: _amount of 1 FCT is 10 ** decimals
331     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
332         require(_to != address(0));
333 
334         totalSupply_ = totalSupply_.add(_amount);
335         balances[_to] = balances[_to].add(_amount);
336 
337         emit Mint(_to, _amount);
338         emit Transfer(address(0), _to, _amount);
339 
340         return true;
341     }
342 
343     // NOTE: _amount of 1 FCT is 10 ** decimals
344     function burn(uint256 _amount) onlyOwner public {
345         require(_amount <= balances[msg.sender]);
346 
347         totalSupply_ = totalSupply_.sub(_amount);
348         balances[msg.sender] = balances[msg.sender].sub(_amount);
349 
350         emit Burn(msg.sender, _amount);
351         emit Transfer(msg.sender, address(0), _amount);
352     }
353 
354     event Mint(address indexed _to, uint256 _amount);
355     event Burn(address indexed _from, uint256 _amount);
356 }