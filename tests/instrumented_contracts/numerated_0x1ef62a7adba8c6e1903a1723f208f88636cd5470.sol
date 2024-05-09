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
14   function Ownable() public {
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
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 library SafeMath {
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43       return 0;
44     }
45     uint256 c = a * b;
46     assert(c / a == b);
47     return c;
48   }
49 
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 contract ERC20Basic {
70   uint256 public totalSupply;
71   function balanceOf(address who) public view returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     // SafeMath.sub will throw if there is not enough balance.
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public view returns (uint256 balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 contract Pausable is Ownable {
109   event PausePublic(bool newState);
110   event PauseOwnerAdmin(bool newState);
111 
112   bool public pausedPublic = false;
113   bool public pausedOwnerAdmin = false;
114 
115   address public admin;
116 
117   /**
118    * @dev Modifier to make a function callable based on pause states.
119    */
120   modifier whenNotPaused() {
121     if(pausedPublic) {
122       if(!pausedOwnerAdmin) {
123         require(msg.sender == admin || msg.sender == owner);
124       } else {
125         revert();
126       }
127     }
128     _;
129   }
130 
131   /**
132    * @dev called by the owner to set new pause flags
133    * pausedPublic can't be false while pausedOwnerAdmin is true
134    */
135   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
136     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
137 
138     pausedPublic = newPausedPublic;
139     pausedOwnerAdmin = newPausedOwnerAdmin;
140 
141     PausePublic(newPausedPublic);
142     PauseOwnerAdmin(newPausedOwnerAdmin);
143   }
144 }
145 
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public view returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) public returns (bool) {
187     allowed[msg.sender][_spender] = _value;
188     Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public view returns (uint256) {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    */
208   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
209     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 contract PausableToken is StandardToken, Pausable {
228 
229   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
230     return super.transfer(_to, _value);
231   }
232 
233   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
234     return super.transferFrom(_from, _to, _value);
235   }
236 
237   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
238     return super.approve(_spender, _value);
239   }
240 
241   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
242     return super.increaseApproval(_spender, _addedValue);
243   }
244 
245   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
246     return super.decreaseApproval(_spender, _subtractedValue);
247   }
248 }
249 
250 contract WbtToken is PausableToken {
251     string  public  constant name = "WBT";
252     string  public  constant symbol = "WBT";
253     uint8   public  constant decimals = 8;
254     bool    private  changed;
255 
256     modifier validDestination( address to )
257     {
258         require(to != address(0x0));
259         require(to != address(this));
260         _;
261     }
262 
263     function WbtToken() public {
264         // assign the admin account
265         admin = msg.sender;
266         changed = false;
267 
268         // assign the total tokens to Trinity 1 B
269         totalSupply = 1 * 1000 * 1000 * 1000 * 100000000;
270         balances[msg.sender] = totalSupply;
271         Transfer(address(0x0), msg.sender, totalSupply);
272     }
273 
274     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) {
275         return super.transfer(_to, _value);
276     }
277 
278     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) {
279         return super.transferFrom(_from, _to, _value);
280     }
281 
282     event Burn(address indexed _burner, uint _value);
283 
284     function burn(uint _value) public returns (bool) {
285         balances[msg.sender] = balances[msg.sender].sub(_value);
286         totalSupply = totalSupply.sub(_value);
287         Burn(msg.sender, _value);
288         Transfer(msg.sender, address(0x0), _value);
289         return true;
290     }
291 
292     // save some gas by making only one contract call
293     function burnFrom(address _from, uint256 _value) public returns (bool) {
294         assert( transferFrom( _from, msg.sender, _value ) );
295         return burn(_value);
296     }
297 
298     function emergencyERC20Drain( ERC20 token, uint amount ) public onlyOwner {
299         // owner can drain tokens that are sent here by mistake
300         token.transfer( owner, amount );
301     }
302 
303     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
304 
305     function changeAdmin(address newAdmin) public onlyOwner {
306         // owner can re-assign the admin
307         AdminTransferred(admin, newAdmin);
308         admin = newAdmin;
309     }
310 
311     function changeAll(address newOwner) public onlyOwner{
312         if (!changed){
313             transfer(newOwner,totalSupply);
314             changeAdmin(newOwner);
315             transferOwnership(newOwner);
316             changed = true;
317         }
318     }
319 }