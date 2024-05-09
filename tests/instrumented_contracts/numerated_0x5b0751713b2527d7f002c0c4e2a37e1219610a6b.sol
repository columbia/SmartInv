1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) public returns (bool) {
21     require(_to != address(0));
22     require(_value <= balances[msg.sender]);
23 
24     // SafeMath.sub will throw if there is not enough balance.
25     balances[msg.sender] = balances[msg.sender].sub(_value);
26     balances[_to] = balances[_to].add(_value);
27     Transfer(msg.sender, _to, _value);
28     return true;
29   }
30 
31   /**
32   * @dev Gets the balance of the specified address.
33   * @param _owner The address to query the the balance of.
34   * @return An uint256 representing the amount owned by the passed address.
35   */
36   function balanceOf(address _owner) public view returns (uint256 balance) {
37     return balances[_owner];
38   }
39 
40 }
41 
42 contract ERC20 is ERC20Basic {
43   function allowance(address owner, address spender) public view returns (uint256);
44   function transferFrom(address from, address to, uint256 value) public returns (bool);
45   function approve(address spender, uint256 value) public returns (bool);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 contract Pausable is Ownable {
87     using SafeMath for uint256;
88 
89     event Pause();
90     event Unpause();
91 
92     bool public paused = false;
93     address public crowdsale;
94 
95     /*
96     * @dev Freezing certain number of tokens bought during bonus.
97     */
98     mapping (address => uint256) public frozen;
99     uint public unfreezeTimestamp;
100 
101     function Pausable() public {
102         unfreezeTimestamp = now + 60 days; //default 60 days from contract deploy date as a defensive mechanism. Will be updated once the crowdsale starts.
103     }
104 
105     function setUnfreezeTimestamp(uint _unfreezeTimestamp) onlyOwner public {
106         require(now < _unfreezeTimestamp);
107         unfreezeTimestamp = _unfreezeTimestamp;
108     }
109 
110     function increaseFrozen(address _owner,uint256 _incrementalAmount) public returns (bool)  {
111         require(msg.sender == crowdsale || msg.sender == owner);
112         require(_incrementalAmount>0);
113         frozen[_owner] = frozen[_owner].add(_incrementalAmount);
114         return true;
115     }
116 
117     function decreaseFrozen(address _owner,uint256 _incrementalAmount) public returns (bool)  {
118         require(msg.sender == crowdsale || msg.sender == owner);
119         require(_incrementalAmount>0);
120         frozen[_owner] = frozen[_owner].sub(_incrementalAmount);
121         return true;
122     }
123 
124     function setCrowdsale(address _crowdsale) onlyOwner public {
125         crowdsale=_crowdsale;
126     }
127 
128     /**
129      * @dev Modifier to make a function callable only when there are unfrozen tokens.
130      */
131     modifier frozenTransferCheck(address _to, uint256 _value, uint256 balance) {
132         if (now < unfreezeTimestamp){
133             require(_value <= balance.sub(frozen[msg.sender]) );
134         }
135         _;
136     }
137 
138     modifier frozenTransferFromCheck(address _from, address _to, uint256 _value, uint256 balance) {
139         if(now < unfreezeTimestamp) {
140             require(_value <= balance.sub(frozen[_from]) );
141         }
142         _;
143     }
144 
145     /**
146      * @dev Modifier to make a function callable only when the contract is not paused. [Exception: crowdsale contract]
147      */
148     modifier whenNotPaused() {
149         require(!paused || msg.sender == crowdsale);
150         _;
151     }
152 
153     /**
154      * @dev Modifier to make a function callable only when the contract is paused.
155      */
156     modifier whenPaused() {
157         require(paused);
158         _;
159     }
160 
161     /**
162      * @dev called by the owner to pause, triggers stopped state
163      */
164     function pause() onlyOwner whenNotPaused public {
165         require(msg.sender != address(0));
166         paused = true;
167         Pause();
168     }
169 
170     /**
171      * @dev called by the owner to unpause, returns to normal state
172      */
173     function unpause() onlyOwner whenPaused public {
174         require(msg.sender != address(0));
175         paused = false;
176         Unpause();
177     }
178 }
179 
180 library SafeMath {
181   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182     if (a == 0) {
183       return 0;
184     }
185     uint256 c = a * b;
186     assert(c / a == b);
187     return c;
188   }
189 
190   function div(uint256 a, uint256 b) internal pure returns (uint256) {
191     // assert(b > 0); // Solidity automatically throws when dividing by 0
192     uint256 c = a / b;
193     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194     return c;
195   }
196 
197   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198     assert(b <= a);
199     return a - b;
200   }
201 
202   function add(uint256 a, uint256 b) internal pure returns (uint256) {
203     uint256 c = a + b;
204     assert(c >= a);
205     return c;
206   }
207 }
208 
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212   event Burn(address indexed burner, uint256 value);
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[_from]);
223     require(_value <= allowed[_from][msg.sender]);
224 
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    *
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param _spender The address which will spend the funds.
240    * @param _value The amount of tokens to be spent.
241    */
242   function approve(address _spender, uint256 _value) public returns (bool) {
243     allowed[msg.sender][_spender] = _value;
244     Approval(msg.sender, _spender, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(address _owner, address _spender) public view returns (uint256) {
255     return allowed[_owner][_spender];
256   }
257 
258   /**
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    */
264   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
265     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
271     uint oldValue = allowed[msg.sender][_spender];
272     if (_subtractedValue > oldValue) {
273       allowed[msg.sender][_spender] = 0;
274     } else {
275       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
276     }
277     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280   
281 
282 
283     /**
284      * @dev Burns a specific amount of tokens.
285      * @param _value The amount of token to be burned.
286      */
287     function burn(uint256 _value) public {
288         require(_value <= balances[msg.sender]);
289         // no need to require value <= totalSupply, since that would imply the
290         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
291     
292         address burner = msg.sender;
293         balances[burner] = balances[burner].sub(_value);
294         totalSupply = totalSupply.sub(_value);
295         Burn(burner, _value);
296     }
297 
298 }
299 
300 contract PausableToken is StandardToken, Pausable {
301   using SafeMath for uint256;
302 
303   function transfer(address _to, uint256 _value) public whenNotPaused frozenTransferCheck(_to, _value, balances[msg.sender]) returns (bool) {
304     return super.transfer(_to, _value);
305   }
306 
307   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused frozenTransferFromCheck(_from, _to, _value, balances[_from]) returns (bool) {
308     return super.transferFrom(_from, _to, _value);
309   }
310 
311   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
312     return super.approve(_spender, _value);
313   }
314 
315   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
316     return super.increaseApproval(_spender, _addedValue);
317   }
318 
319   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
320     return super.decreaseApproval(_spender, _subtractedValue);
321   }
322 }
323 
324 contract HorseToken is PausableToken {
325 
326     string public constant name = "Horse";
327     string public constant symbol = "HORSE";
328     uint public constant decimals = 18;
329 
330     uint256 public constant INITIAL_SUPPLY = 125000000*(10**decimals); // 125 million x 18 decimals to represent in wei
331 
332     /**
333      * @dev Contructor that gives msg.sender all of existing tokens.
334      */
335     function HorseToken() public {
336         totalSupply = INITIAL_SUPPLY;
337         balances[msg.sender] = INITIAL_SUPPLY;
338         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
339     }
340 }