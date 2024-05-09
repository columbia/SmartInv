1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14    constructor() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     emit OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 
41 library SafeMath {
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     if (a == 0) {
44       return 0;
45     }
46     uint256 c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 
71 contract ERC20Basic {
72   uint256 public totalSupply;
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 contract StandardToken is ERC20, BasicToken {
120 
121   mapping (address => mapping (address => uint256)) internal allowed;
122 
123 
124   /**
125    * @dev Transfer tokens from one address to another
126    * @param _from address The address which you want to send tokens from
127    * @param _to address The address which you want to transfer to
128    * @param _value uint256 the amount of tokens to be transferred
129    */
130   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value <= balances[_from]);
133     require(_value <= allowed[_from][msg.sender]);
134 
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138     emit Transfer(_from, _to, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144    *
145    * Beware that changing an allowance with this method brings the risk that someone may use both the old
146    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint256 _value) public returns (bool) {
153     allowed[msg.sender][_spender] = _value;
154     emit Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param _owner address The address which owns the funds.
161    * @param _spender address The address which will spend the funds.
162    * @return A uint256 specifying the amount of tokens still available for the spender.
163    */
164   function allowance(address _owner, address _spender) public view returns (uint256) {
165     return allowed[_owner][_spender];
166   }
167 
168   /**
169    * approve should be called when allowed[_spender] == 0. To increment
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    */
174   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
175     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
181     uint oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 
193 contract Pausable is Ownable {
194   event PausePublic(bool newState);
195   event PauseOwnerAdmin(bool newState);
196 
197   bool public pausedPublic = false;
198   bool public pausedOwnerAdmin = false;
199 
200   address public admin;
201 
202   /**
203    * @dev Modifier to make a function callable based on pause states.
204    */
205   modifier whenNotPaused() {
206     if(pausedPublic) {
207       if(!pausedOwnerAdmin) {
208         require(msg.sender == admin || msg.sender == owner);
209       } else {
210         revert();
211       }
212     }
213     _;
214   }
215 
216   /**
217    * @dev called by the owner to set new pause flags
218    * pausedPublic can't be false while pausedOwnerAdmin is true
219    */
220   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
221     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
222 
223     pausedPublic = newPausedPublic;
224     pausedOwnerAdmin = newPausedOwnerAdmin;
225 
226     emit PausePublic(newPausedPublic);
227     emit PauseOwnerAdmin(newPausedOwnerAdmin);
228   }
229 }
230 
231 
232 contract PausableToken is StandardToken, Pausable {
233 
234   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
235     return super.transfer(_to, _value);
236   }
237 
238   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
239     return super.transferFrom(_from, _to, _value);
240   }
241 
242   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
243     return super.approve(_spender, _value);
244   }
245 
246   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
247     return super.increaseApproval(_spender, _addedValue);
248   }
249 
250   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
251     return super.decreaseApproval(_spender, _subtractedValue);
252   }
253 }
254 
255 
256 contract LptToken is PausableToken {
257     string  public  constant name = "LaplaceToken";
258     string  public  constant symbol = "LPT";
259     uint8   public  constant decimals = 8;
260     bool    private  changed;
261 
262     modifier validDestination( address to )
263     {
264         require(to != address(0x0));
265         require(to != address(this));
266         _;
267     }
268 
269     constructor() public {
270         // assign the admin account
271         admin = msg.sender;
272         changed = false;
273 
274         // assign the total tokens to Lpt 1 B
275         totalSupply =  1 * 1000 * 1000 * 1000 * 100000000;
276         balances[msg.sender] = totalSupply;
277         emit Transfer(address(0x0), msg.sender, totalSupply);
278     }
279 
280     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) {
281         return super.transfer(_to, _value);
282     }
283 
284     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) {
285         return super.transferFrom(_from, _to, _value);
286     }
287 
288     event Burn(address indexed _burner, uint _value);
289 
290     function burn(uint _value) public returns (bool) {
291         balances[msg.sender] = balances[msg.sender].sub(_value);
292         totalSupply = totalSupply.sub(_value);
293         emit Burn(msg.sender, _value);
294         emit Transfer(msg.sender, address(0x0), _value);
295         return true;
296     }
297 
298     // save some gas by making only one contract call
299     function burnFrom(address _from, uint256 _value) public returns (bool) {
300         assert( transferFrom( _from, msg.sender, _value ) );
301         return burn(_value);
302     }
303 
304     function emergencyERC20Drain( ERC20 token, uint amount ) public onlyOwner {
305         // owner can drain tokens that are sent here by mistake
306         token.transfer( owner, amount );
307     }
308 
309     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
310 
311     function changeAdmin(address newAdmin) public onlyOwner {
312         // owner can re-assign the admin
313         emit AdminTransferred(admin, newAdmin);
314         admin = newAdmin;
315     }
316 
317     function changeAll(address newOwner) public onlyOwner{
318         if (!changed){
319             transfer(newOwner,totalSupply);
320             changeAdmin(newOwner);
321             transferOwnership(newOwner);
322             changed = true;
323         }
324     }
325 }