1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0 || b == 0){
10         return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65     
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   /**
73   * @dev Gets the balance of the specified address.
74   * @param _owner The address to query the the balance of.
75   * @return An uint256 representing the amount owned by the passed address.
76   */
77   function balanceOf(address _owner) public view returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
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
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amout of tokens to be transfered
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_from != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_to] = balances[_to].add(_value);
119     balances[_from] = balances[_from].sub(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) public returns (bool) {
131 
132     // To change the approve amount you first have to reduce the addresses`
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134     //  already 0 to mitigate the race condition described here:
135     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
137 
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifing the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256) {
150     return allowed[_owner][_spender];
151   }
152 
153 }
154 /**
155  * @title Ownable
156  * @dev The Ownable contract has an owner address, and provides basic authorization control
157  * functions, this simplifies the implementation of "user permissions".
158  */
159 contract Ownable {
160   address public owner;
161 
162 
163   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
164 
165 
166   /**
167    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
168    * account.
169    */
170   function Ownable() public {
171     owner = msg.sender;
172   }
173 
174 
175   /**
176    * @dev Throws if called by any account other than the owner.
177    */
178   modifier onlyOwner() {
179     require(msg.sender == owner);
180     _;
181   }
182 
183 
184   /**
185    * @dev Allows the current owner to transfer control of the contract to a newOwner.
186    * @param newOwner The address to transfer ownership to.
187    */
188   function transferOwnership(address newOwner) public onlyOwner {
189     require(newOwner != address(0));
190     OwnershipTransferred(owner, newOwner);
191     owner = newOwner;
192   }
193 
194 }
195 
196 /**
197  * @title Pausable
198  * @dev Base contract which allows children to implement an emergency stop mechanism.
199  */
200 contract Pausable is Ownable {
201   event PausePublic(bool newState);
202   event PauseOwnerAdmin(bool newState);
203 
204   bool public pausedPublic = true;
205   bool public pausedOwnerAdmin = false;
206 
207   address public admin;
208 
209   /**
210    * @dev Modifier to make a function callable based on pause states.
211    */
212   modifier whenNotPaused() {
213     if(pausedPublic) {
214       if(!pausedOwnerAdmin) {
215         require(msg.sender == admin || msg.sender == owner);
216       } else {
217         revert();
218       }
219     }
220     _;
221   }
222 
223   /**
224    * @dev called by the owner to set new pause flags
225    * pausedPublic can't be false while pausedOwnerAdmin is true
226    */
227   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
228     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
229 
230     pausedPublic = newPausedPublic;
231     pausedOwnerAdmin = newPausedOwnerAdmin;
232 
233     PausePublic(newPausedPublic);
234     PauseOwnerAdmin(newPausedOwnerAdmin);
235   }
236 }
237 
238 contract PausableToken is StandardToken, Pausable {
239 
240   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
241     return super.transfer(_to, _value);
242   }
243 
244   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
245     return super.transferFrom(_from, _to, _value);
246   }
247 
248   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
249     return super.approve(_spender, _value);
250   }
251 }
252 
253 
254 /**
255  * @title SimpleToken
256  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
257  * Note they can later distribute these tokens as they wish using `transfer` and other
258  * `StandardToken` functions.
259  */
260 contract AITA is PausableToken {
261     string  public  constant name = "AITAToken";
262     string  public  constant symbol = "AITAerc";
263     uint8   public  constant decimals = 12;
264 
265     // mitigates the ERC20 short address attack
266     modifier onlyPayloadSize(uint size) {
267         assert(msg.data.length >= size + 4);
268         _;
269     }
270     modifier validDestination( address to )
271     {
272         require(to != address(0x0));
273         require(to != address(this));
274         _;
275     }
276 
277     function AITA( address _admin, uint256 _totalTokenAmount ) 
278     {
279         // assign the admin account
280         admin = _admin;
281 
282         // assign the total tokens to AITA
283         totalSupply = _totalTokenAmount;
284         balances[msg.sender] = _totalTokenAmount;
285         Transfer(address(0x0), msg.sender, _totalTokenAmount);
286     }
287 
288     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) validDestination(_to) public returns (bool) 
289     {
290         return super.transfer(_to, _value);
291     }
292 
293     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) validDestination(_to) public returns (bool) 
294     {
295         return super.transferFrom(_from, _to, _value);
296     }
297 
298     event Burn(address indexed _burner, uint _value);
299 
300     function burn(uint _value) public returns (bool)
301     {
302         balances[msg.sender] = balances[msg.sender].sub(_value);
303         totalSupply = totalSupply.sub(_value);
304         Burn(msg.sender, _value);
305         Transfer(msg.sender, address(0x0), _value);
306         return true;
307     }
308 
309     // save some gas by making only one contract call
310     function burnFrom(address _from, uint256 _value) public returns (bool) 
311     {
312         assert( transferFrom( _from, msg.sender, _value ) );
313         return burn(_value);
314     }
315 
316     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
317         // owner can drain tokens that are sent here by mistake
318         token.transfer( owner, amount );
319     }
320 
321     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
322 
323     function changeAdmin(address newAdmin) onlyOwner {
324         // owner can re-assign the admin
325         AdminTransferred(admin, newAdmin);
326         admin = newAdmin;
327     }
328 }