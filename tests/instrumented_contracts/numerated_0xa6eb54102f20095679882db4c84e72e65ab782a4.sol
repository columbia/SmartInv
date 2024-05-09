1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) public constant returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title Basic token
27  * @dev Basic version of StandardToken, with no allowances.
28  */
29 contract BasicToken is ERC20Basic {
30   using SafeMath for uint256;
31 
32   mapping(address => uint256) balances;
33 
34    /**
35    * @dev Fix for the ERC20 short address attack.
36    */
37   modifier onlyPayloadSize(uint size) {
38      require(msg.data.length >= size + 4);
39      _;
40   }
41 
42   /**
43   * @dev transfer token for a specified address
44   * @param _to The address to transfer to.
45   * @param _value The amount to be transferred.
46   */
47   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32)  public returns (bool) {
48     require (_to != address(0));
49     require (_value > 0);
50     require (balances[msg.sender] >= _value); // Check if the sender has enough
51     //require (balances[_to] + _value > balances[_to]); // Check for overflows
52 
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   /**
60   * @dev Gets the balance of the specified address.
61   * @param _owner The address to query the the balance of.
62   * @return An uint256 representing the amount owned by the passed address.
63   */
64   function balanceOf(address _owner) public constant returns (uint256 balance) {
65     return balances[_owner];
66   }
67 
68 }
69 
70 /**
71  * @title Standard ERC20 token
72  *
73  * @dev Implementation of the basic standard token.
74  * @dev https://github.com/ethereum/EIPs/issues/20
75  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
76  */
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) allowed;
80 
81 
82   /**
83    * @dev Transfer tokens from one address to another
84    * @param _from address The address which you want to send tokens from
85    * @param _to address The address which you want to transfer to
86    * @param _value uint256 the amount of tokens to be transferred
87    */
88   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32)  public returns (bool) {
89     require(_to != address(0));
90     require (_value > 0);
91     require (balances[_from] >= _value); // Check if the sender has enough
92     //require (balances[_to] + _value > balances[_to]); // Check for overflows
93     require (_value <= allowed[_from][msg.sender]); // Check allowance  
94 
95     uint256 _allowance = allowed[_from][msg.sender];
96 
97     balances[_from] = balances[_from].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     allowed[_from][msg.sender] = _allowance.sub(_value);
100     Transfer(_from, _to, _value);
101     return true;
102   }
103 
104   /**
105    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
106    *
107    * Beware that changing an allowance with this method brings the risk that someone may use both the old
108    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111    * @param _spender The address which will spend the funds.
112    * @param _value The amount of tokens to be spent.
113    */
114   function approve(address _spender, uint256 _value) public returns (bool) {
115   	require((_value == 0) || (allowed[msg.sender][_spender] == 0));
116 
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Function to check the amount of tokens that an owner allowed to a spender.
124    * @param _owner address The address which owns the funds.
125    * @param _spender address The address which will spend the funds.
126    * @return A uint256 specifying the amount of tokens still available for the spender.
127    */
128   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
129     return allowed[_owner][_spender];
130   }
131 
132 }
133 
134 
135 /**
136  * @title Ownable
137  * @dev The Ownable contract has an owner address, and provides basic authorization control
138  * functions, this simplifies the implementation of "user permissions".
139  */
140 contract Ownable {
141   address public owner;
142 
143   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145   /**
146    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147    * account.
148    */
149   function Ownable() {
150     owner = msg.sender;
151   }
152 
153   /**
154    * @dev Throws if called by any account other than the owner.
155    */
156   modifier onlyOwner() {
157     require(msg.sender == owner);
158     _;
159   }
160 
161   /**
162    * @dev Allows the current owner to transfer control of the contract to a newOwner.
163    * @param newOwner The address to transfer ownership to.
164    */
165   function transferOwnership(address newOwner) onlyOwner public {
166     require(newOwner != address(0));
167     OwnershipTransferred(owner, newOwner);
168     owner = newOwner;
169   }
170 
171 }
172 
173 library SafeMath {
174   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
175     uint256 c = a * b;
176     assert(a == 0 || c / a == b);
177     return c;
178   }
179 
180   function div(uint256 a, uint256 b) internal constant returns (uint256) {
181     // assert(b > 0); // Solidity automatically throws when dividing by 0
182     uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184     return c;
185   }
186 
187   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
188     assert(b <= a);
189     return a - b;
190   }
191 
192   function add(uint256 a, uint256 b) internal constant returns (uint256) {
193     uint256 c = a + b;
194     assert(c >= a);
195     return c;
196   }
197 }
198 
199 
200 // This is just a contract of a MagnaChain Token.
201 // It is a ERC20 token
202 contract MagnaChain is StandardToken, Ownable{
203     
204     string public version = "1.0";
205     string public name = "MagnaChain";
206     string public symbol = "MGC";
207     uint8 public  decimals = 8;
208 
209     mapping(address=>uint256)  lockedBalance;
210     mapping(address=>uint)     timeRelease; 
211     
212     uint256 internal constant INITIAL_SUPPLY = 40 * 100 * (10**6) * (10 **8);
213     uint256 internal constant MAX_TIME = 60*60*24*365*5;
214 
215     event Burn(address indexed burner, uint256 value);
216     event Lock(address indexed locker, uint256 value, uint releaseTime);
217     event UnLock(address indexed unlocker, uint256 value);
218     
219     // constructor
220     function MagnaChain() { 
221         balances[msg.sender] = INITIAL_SUPPLY;
222         totalSupply = INITIAL_SUPPLY;
223     }
224 
225     //balance of locked
226     function lockedOf(address _owner) public constant returns (uint256 balance) {
227         return lockedBalance[_owner];
228     }
229 
230     //release time of locked
231     function unlockTimeOf(address _owner) public constant returns (uint timelimit) {
232         return timeRelease[_owner];
233     }
234 
235     // transfer to and lock it
236     function transferAndLock(address _to, uint256 _value, uint _releaseTime) onlyPayloadSize(3 * 32) public returns (bool success) {
237         require(_to != address(0));
238         require(_value <= balances[msg.sender]);
239         require(_value > 0);
240         require(_releaseTime > now && _releaseTime <= now + MAX_TIME);
241 
242         // SafeMath.sub will throw if there is not enough balance.
243         balances[msg.sender] = balances[msg.sender].sub(_value);
244        
245         //if preLock can release 
246         uint preRelease = timeRelease[_to];
247         if (preRelease <= now && preRelease != 0x0) {
248             balances[_to] = balances[_to].add(lockedBalance[_to]);
249             lockedBalance[_to] = 0;
250         }
251 
252         lockedBalance[_to] = lockedBalance[_to].add(_value);
253         timeRelease[_to] =  _releaseTime >= timeRelease[_to] ? _releaseTime : timeRelease[_to]; 
254         Transfer(msg.sender, _to, _value);
255         Lock(_to, _value, _releaseTime);
256         return true;
257     }
258 
259    /**
260    * @notice Transfers tokens held by lock.
261    */
262    function unlock() public constant returns (bool success){
263         uint256 amount = lockedBalance[msg.sender];
264         require(amount > 0);
265         require(now >= timeRelease[msg.sender]);
266 
267         balances[msg.sender] = balances[msg.sender].add(amount);
268         lockedBalance[msg.sender] = 0;
269         timeRelease[msg.sender] = 0;
270 
271         Transfer(address(0), msg.sender, amount);
272         UnLock(msg.sender, amount);
273 
274         return true;
275 
276     }
277 
278     /**
279      * @dev Burns a specific amount of tokens.
280      * @param _value The amount of token to be burned.
281      */
282     function burn(uint256 _value) public returns (bool success) {
283         require(_value > 0);
284         require(_value <= balances[msg.sender]);
285     
286         address burner = msg.sender;
287         balances[burner] = balances[burner].sub(_value);
288         totalSupply = totalSupply.sub(_value);
289         Burn(burner, _value);
290         return true;
291     }
292 }