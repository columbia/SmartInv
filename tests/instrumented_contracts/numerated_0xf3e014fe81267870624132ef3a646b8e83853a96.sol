1 pragma solidity 0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 /**
76  * @title Contactable token
77  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
78  * contact information.
79  */
80 contract Contactable is Ownable{
81 
82     string public contactInformation;
83 
84     /**
85      * @dev Allows the owner to set a string with their contact information.
86      * @param info The contact information to attach to the contract.
87      */
88     function setContactInformation(string info) onlyOwner public {
89          contactInformation = info;
90      }
91 }
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   uint256 public totalSupply;
100   function balanceOf(address who) public constant returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public constant returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 contract LockableToken is ERC20 {
117     function addToTimeLockedList(address addr) external returns (bool);
118 }
119 
120 contract VinToken is Contactable {
121     using SafeMath for uint;
122 
123     string constant public name = "VIN";
124     string constant public symbol = "VIN";
125     uint constant public decimals = 18;
126     uint constant public totalSupply = (10 ** 9) * (10 ** decimals); // 1 000 000 000 VIN
127     uint constant public lockPeriod1 = 2 years;
128     uint constant public lockPeriod2 = 24 weeks;
129     uint constant public lockPeriodForBuyers = 12 weeks;
130 
131     mapping (address => uint) balances;
132     mapping (address => mapping (address => uint)) allowed;
133     bool public isActivated = false;
134     mapping (address => bool) public whitelistedBeforeActivation;
135     mapping (address => bool) public isPresaleBuyer;
136     address public saleAddress;
137     address public founder1Address;
138     address public founder2Address;
139     uint public icoEndTime;
140     uint public icoStartTime;
141 
142     event Transfer(address indexed from, address indexed to, uint256 value);
143     event Approval(address indexed owner, address indexed spender, uint value);
144 
145     function VinToken(
146         address _founder1Address,
147         address _founder2Address,
148         uint _icoStartTime,
149         uint _icoEndTime
150         ) public 
151     {
152         require(_founder1Address != 0x0);
153         require(_founder2Address != 0x0);
154         require(_icoEndTime > _icoStartTime);
155         founder1Address = _founder1Address;
156         founder2Address = _founder2Address;
157         icoStartTime = _icoStartTime;
158         icoEndTime = _icoEndTime;
159         balances[owner] = totalSupply;
160         whitelistedBeforeActivation[owner] = true;
161     }
162 
163     modifier whenActivated() {
164         require(isActivated || whitelistedBeforeActivation[msg.sender]);
165         _;
166     }
167     
168     modifier isLockTimeEnded(address from){
169         if (from == founder1Address) {
170             require(now > icoEndTime + lockPeriod1);
171         } else if (from == founder2Address) {
172             require(now > icoEndTime + lockPeriod2);
173         } else if (isPresaleBuyer[from]) {
174             require(now > icoEndTime + lockPeriodForBuyers);
175         }
176         _;
177     }
178 
179     modifier onlySaleConract(){
180         require(msg.sender == saleAddress);
181         _;
182     }
183 
184     /**
185     * @dev transfer token for a specified address
186     * @param _to The address to transfer to.
187     * @param _value The amount to be transferred.
188     */
189     function transfer(address _to, uint _value) external isLockTimeEnded(msg.sender) whenActivated returns (bool) {
190         require(_to != 0x0);
191     
192         balances[msg.sender] = balances[msg.sender].sub(_value);
193         balances[_to] = balances[_to].add(_value);
194         Transfer(msg.sender, _to, _value);
195         return true;
196     }
197 
198     /**
199     * @dev Gets the balance of the specified address.
200     * @param _owner The address to query the the balance of.
201     * @return An uint representing the amount owned by the passed address.
202     */
203     function balanceOf(address _owner) external constant returns (uint balance) {
204         return balances[_owner];
205     }
206 
207     /**
208      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209      *
210      * Beware that changing an allowance with this method brings the risk that someone may use both the old
211      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214      * @param _spender The address which will spend the funds.
215      * @param _value The amount of tokens to be spent.
216      */
217     function approve(address _spender, uint _value) external whenActivated returns (bool) {
218         allowed[msg.sender][_spender] = _value;
219         Approval(msg.sender, _spender, _value);
220         return true;
221     }
222 
223     /**
224      * @dev Function to check the amount of tokens that an owner allowed to a spender.
225      * @param _owner address The address which owns the funds.
226      * @param _spender address The address which will spend the funds.
227      * @return A uint specifying the amount of tokens still available for the spender.
228      */
229     function allowance(address _owner, address _spender) external constant returns (uint remaining) {
230         return allowed[_owner][_spender];
231     }
232 
233     /**
234      * @dev Transfer tokens from one address to another
235      * @param _from address The address which you want to send tokens from
236      * @param _to address The address which you want to transfer to
237      * @param _value uint the amount of tokens to be transferred
238      */
239     function transferFrom(address _from, address _to, uint _value) external isLockTimeEnded(_from) whenActivated returns (bool) {
240         require(_to != 0x0);
241         uint _allowance = allowed[_from][msg.sender];
242 
243         balances[_from] = balances[_from].sub(_value);
244         balances[_to] = balances[_to].add(_value);
245         
246         // _allowance.sub(_value) will throw if _value > _allowance
247         allowed[_from][msg.sender] = _allowance.sub(_value);
248         Transfer(_from, _to, _value);
249 
250         return true;
251     }
252 
253     /**
254      * approve should be called when allowed[_spender] == 0. To increment
255      * allowed value is better to use this function to avoid 2 calls (and wait until
256      * the first transaction is mined)
257      * From MonolithDAO Token.sol
258      */
259     function increaseApproval(address _spender, uint _addedValue) external whenActivated returns (bool) {
260         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
261         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262         return true;
263     }
264 
265     function decreaseApproval(address _spender, uint _subtractedValue) external whenActivated returns (bool) {
266         uint oldValue = allowed[msg.sender][_spender];
267         if (_subtractedValue > oldValue) {
268             allowed[msg.sender][_spender] = 0;
269         } else {
270             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271         }
272         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273         return true;
274     }
275 
276     /**
277      * Activation of the token allows all tokenholders to operate with the token
278      */
279     function activate() external onlyOwner returns (bool) {
280         isActivated = true;
281         return true;
282     }
283 
284     /**
285      * allows to add and exclude addresses from whitelistedBeforeActivation list for owner
286      * @param isWhitelisted is true for adding address into whitelist, false - to exclude
287      */
288     function editWhitelist(address _address, bool isWhitelisted) external onlyOwner returns (bool) {
289         whitelistedBeforeActivation[_address] = isWhitelisted;
290         return true;        
291     }
292 
293     function addToTimeLockedList(address addr) external onlySaleConract returns (bool) {
294         require(addr != 0x0);
295         isPresaleBuyer[addr] = true;
296         return true;
297     }
298 
299     function setSaleAddress(address newSaleAddress) external onlyOwner returns (bool) {
300         require(newSaleAddress != 0x0);
301         saleAddress = newSaleAddress;
302         return true;
303     }
304 
305     function setIcoEndTime(uint newTime) external onlyOwner returns (bool) {
306         require(newTime > icoStartTime);
307         icoEndTime = newTime;
308         return true;
309     }
310 }