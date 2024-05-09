1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   /**
9    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10    * account.
11    */
12   constructor() public {
13     owner = msg.sender;
14   }
15 
16 
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 library SafeMath {
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     if (a == 0) {
41       return 0;
42     }
43     uint256 c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 contract ERC20Basic {
68   uint256 public totalSupply;
69   function balanceOf(address who) public view returns (uint256);
70   function transfer(address to, uint256 value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 contract Pausable is Ownable {
107   event PausePublic(bool newState);
108   event PauseOwnerAdmin(bool newState);
109 
110   bool public pausedPublic = false;
111   bool public pausedOwnerAdmin = false;
112 
113   address public admin;
114 
115   /**
116    * @dev Modifier to make a function callable based on pause states.
117    */
118   modifier whenNotPaused() {
119     if(pausedPublic) {
120       if(!pausedOwnerAdmin) {
121         require(msg.sender == admin || msg.sender == owner);
122       } else {
123         revert();
124       }
125     }
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to set new pause flags
131    * pausedPublic can't be false while pausedOwnerAdmin is true
132    */
133   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
134     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
135 
136     pausedPublic = newPausedPublic;
137     pausedOwnerAdmin = newPausedOwnerAdmin;
138 
139     emit PausePublic(newPausedPublic);
140     emit PauseOwnerAdmin(newPausedOwnerAdmin);
141   }
142 }
143 
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public view returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     emit Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    */
206   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223 }
224 
225 contract PausableToken is StandardToken, Pausable {
226 
227   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
228     return super.transfer(_to, _value);
229   }
230 
231   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
232     return super.transferFrom(_from, _to, _value);
233   }
234 
235   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
236     return super.approve(_spender, _value);
237   }
238 
239   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
240     return super.increaseApproval(_spender, _addedValue);
241   }
242 
243   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
244     return super.decreaseApproval(_spender, _subtractedValue);
245   }
246 }
247 
248 contract IGTToken is PausableToken {
249     string  public  constant name = "International Gold Token";
250     string  public  constant symbol = "IGT";
251     uint8   public  constant decimals = 8;
252     bool    private  changed;
253 
254     modifier validDestination( address to )
255     {
256         require(to != address(0x0));
257         require(to != address(this));
258         _;
259     }
260 
261     constructor() public {
262         // assign the admin account
263         admin = msg.sender;
264         changed = false;
265 
266         // assign the total tokens to Trinity 1 B
267         totalSupply = 10 * 1000 * 1000 * 1000 * 100000000;
268         balances[msg.sender] = totalSupply;
269         emit Transfer(address(0x0), msg.sender, totalSupply);
270     }
271 
272     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) {
273         return super.transfer(_to, _value);
274     }
275 
276     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) {
277         return super.transferFrom(_from, _to, _value);
278     }
279 
280     event Burn(address indexed _burner, uint _value);
281 
282     function burn(uint _value) public returns (bool) {
283         balances[msg.sender] = balances[msg.sender].sub(_value);
284         totalSupply = totalSupply.sub(_value);
285         emit Burn(msg.sender, _value);
286         emit Transfer(msg.sender, address(0x0), _value);
287         return true;
288     }
289 
290     // save some gas by making only one contract call
291     function burnFrom(address _from, uint256 _value) public returns (bool) {
292         assert( transferFrom( _from, msg.sender, _value ) );
293         return burn(_value);
294     }
295 
296     function emergencyERC20Drain( ERC20 token, uint amount ) public onlyOwner {
297         // owner can drain tokens that are sent here by mistake
298         token.transfer( owner, amount );
299     }
300 
301     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
302 
303     function changeAdmin(address newAdmin) public onlyOwner {
304         // owner can re-assign the admin
305         emit AdminTransferred(admin, newAdmin);
306         admin = newAdmin;
307     }
308 
309     function changeAll(address newOwner) public onlyOwner{
310         if (!changed){
311             transfer(newOwner,totalSupply);
312             changeAdmin(newOwner);
313             transferOwnership(newOwner);
314             changed = true;
315         }
316     }
317 }