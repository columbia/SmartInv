1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63   mapping(address => uint256) balances;
64   uint256 totalSupply_;
65   /**
66   * @dev total number of tokens in existence
67   */
68   function totalSupply() public view returns (uint256) {
69     return totalSupply_;
70   }
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     emit Transfer(msg.sender, _to, _value);
82     return true;
83   }
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256) {
90     return balances[_owner];
91   }
92 }
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender)
99     public view returns (uint256);
100   function transferFrom(address from, address to, uint256 value)
101     public returns (bool);
102   function approve(address spender, uint256 value) public returns (bool);
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * @dev https://github.com/ethereum/EIPs/issues/20
114  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract StandardToken is ERC20, BasicToken {
117   mapping (address => mapping (address => uint256)) internal allowed;
118   /**
119    * @dev Transfer tokens from one address to another
120    * @param _from address The address which you want to send tokens from
121    * @param _to address The address which you want to transfer to
122    * @param _value uint256 the amount of tokens to be transferred
123    */
124   function transferFrom(
125     address _from,
126     address _to,
127     uint256 _value
128   )
129     public
130     returns (bool)
131   {
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138     emit Transfer(_from, _to, _value);
139     return true;
140   }
141   /**
142    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    *
144    * Beware that changing an allowance with this method brings the risk that someone may use both the old
145    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint256 _value) public returns (bool) {
152     allowed[msg.sender][_spender] = _value;
153     emit Approval(msg.sender, _spender, _value);
154     return true;
155   }
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158    * @param _owner address The address which owns the funds.
159    * @param _spender address The address which will spend the funds.
160    * @return A uint256 specifying the amount of tokens still available for the spender.
161    */
162   function allowance(
163     address _owner,
164     address _spender
165    )
166     public
167     view
168     returns (uint256)
169   {
170     return allowed[_owner][_spender];
171   }
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(
183     address _spender,
184     uint _addedValue
185   )
186     public
187     returns (bool)
188   {
189     allowed[msg.sender][_spender] = (
190       allowed[msg.sender][_spender].add(_addedValue));
191     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(
205     address _spender,
206     uint _subtractedValue
207   )
208     public
209     returns (bool)
210   {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 }
221 contract MultiOwnable {
222     mapping (address => bool) owners;
223     address unremovableOwner;
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225     event OwnershipExtended(address indexed host, address indexed guest);
226     event OwnershipRemoved(address indexed removedOwner);
227     modifier onlyOwner() {
228         require(owners[msg.sender]);
229         _;
230     }
231     constructor() public {
232         owners[msg.sender] = true;
233         unremovableOwner = msg.sender;
234     }
235     function addOwner(address guest) onlyOwner public {
236         require(guest != address(0));
237         owners[guest] = true;
238         emit OwnershipExtended(msg.sender, guest);
239     }
240     function removeOwner(address removedOwner) onlyOwner public {
241         require(removedOwner != address(0));
242         require(unremovableOwner != removedOwner);
243         delete owners[removedOwner];
244         emit OwnershipRemoved(removedOwner);
245     }
246     function transferOwnership(address newOwner) onlyOwner public {
247         require(newOwner != address(0));
248         require(unremovableOwner != msg.sender);
249         owners[newOwner] = true;
250         delete owners[msg.sender];
251         emit OwnershipTransferred(msg.sender, newOwner);
252     }
253     function isOwner(address addr) public view returns(bool){
254         return owners[addr];
255     }
256 }
257 contract LBK is StandardToken, MultiOwnable {
258     using SafeMath for uint256;
259     uint256 public constant TOTAL_CAP = 5000000000;
260     string public constant name = "Legal Block Token";
261     string public constant symbol = "LBK";
262     uint256 public constant decimals = 18;
263     bool isTransferable = false;
264     constructor() public {
265         totalSupply_ = TOTAL_CAP.mul(10 ** decimals);
266         balances[msg.sender] = totalSupply_;
267         emit Transfer(address(0), msg.sender, balances[msg.sender]);
268     }
269     function unlock() external onlyOwner {
270         isTransferable = true;
271     }
272     function lock() external onlyOwner {
273         isTransferable = false;
274     }
275     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
276         require(isTransferable || owners[msg.sender]);
277         return super.transferFrom(_from, _to, _value);
278     }
279     function transfer(address _to, uint256 _value) public returns (bool) {
280         require(isTransferable || owners[msg.sender]);
281         return super.transfer(_to, _value);
282     }
283     // NOTE: _amount of 1 LBK is 10 ** decimals
284     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
285         require(_to != address(0));
286         totalSupply_ = totalSupply_.add(_amount);
287         balances[_to] = balances[_to].add(_amount);
288         emit Mint(_to, _amount);
289         emit Transfer(address(0), _to, _amount);
290         return true;
291     }
292     // NOTE: _amount of 1 LBK is 10 ** decimals
293     function burn(uint256 _amount) onlyOwner public {
294         require(_amount <= balances[msg.sender]);
295         totalSupply_ = totalSupply_.sub(_amount);
296         balances[msg.sender] = balances[msg.sender].sub(_amount);
297         emit Burn(msg.sender, _amount);
298         emit Transfer(msg.sender, address(0), _amount);
299     }
300     event Mint(address indexed _to, uint256 _amount);
301     event Burn(address indexed _from, uint256 _amount);
302 }