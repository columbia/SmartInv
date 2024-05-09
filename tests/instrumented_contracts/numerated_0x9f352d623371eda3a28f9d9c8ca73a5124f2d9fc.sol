1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public constant returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 
108 
109 
110 
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public constant returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * approve should be called when allowed[_spender] == 0. To increment
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    */
188   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
195     uint oldValue = allowed[msg.sender][_spender];
196     if (_subtractedValue > oldValue) {
197       allowed[msg.sender][_spender] = 0;
198     } else {
199       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200     }
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205 }
206 
207 
208 
209 
210 /**
211  * @title SafeMath
212  * @dev Math operations with safety checks that throw on error
213  */
214 library SafeMath {
215   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
216     uint256 c = a * b;
217     assert(a == 0 || c / a == b);
218     return c;
219   }
220 
221   function div(uint256 a, uint256 b) internal constant returns (uint256) {
222     // assert(b > 0); // Solidity automatically throws when dividing by 0
223     uint256 c = a / b;
224     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225     return c;
226   }
227 
228   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
229     assert(b <= a);
230     return a - b;
231   }
232 
233   function add(uint256 a, uint256 b) internal constant returns (uint256) {
234     uint256 c = a + b;
235     assert(c >= a);
236     return c;
237   }
238 }
239 
240 
241 
242 contract NoteToken is StandardToken, Ownable {
243     using SafeMath for uint256;
244 
245     string public constant NAME = "Note Token";
246     string public constant SYMBOL = "NOTE";
247     uint256 public tokensLeft;
248     uint256 public endTime;
249     address compositionAddress;
250 
251     modifier beforeEndTime() {
252         require(now < endTime);
253         _;
254     }
255 
256     modifier afterEndTime() {
257         require(now > endTime);
258         _;
259     }
260     event TokensBought(uint256 _num, uint256 _tokensLeft);
261     event TokensReturned(uint256 _num, uint256 _tokensLeft);
262 
263     function NoteToken(uint256 _endTime) public {
264         totalSupply = 5000;
265         tokensLeft = totalSupply;
266 
267         endTime = _endTime;
268     }
269 
270     function purchaseNotes(uint256 _numNotes) beforeEndTime() external payable {
271         require(_numNotes <= 100);
272         require(_numNotes <= tokensLeft);
273         require(_numNotes == (msg.value / 0.001 ether));
274 
275         balances[msg.sender] = balances[msg.sender].add(_numNotes);
276         tokensLeft = tokensLeft.sub(_numNotes);
277 
278         emit TokensBought(_numNotes, tokensLeft);
279     }
280 
281     function returnNotes(uint256 _numNotes) beforeEndTime() external {
282         require(_numNotes <= balances[msg.sender]);
283         
284         uint256 refund = _numNotes * 0.001 ether;
285         balances[msg.sender] = balances[msg.sender].sub(_numNotes);
286         tokensLeft = tokensLeft.add(_numNotes);
287         msg.sender.transfer(refund);
288         emit TokensReturned(_numNotes, tokensLeft);
289     }
290 
291     function setCompositionAddress(address _compositionAddress) onlyOwner() external {
292         require(compositionAddress == address(0));
293 
294         compositionAddress = _compositionAddress;
295     }
296 
297     function transferToComposition(address _from, uint256 _value) beforeEndTime() public returns (bool) {
298         require(msg.sender == compositionAddress);
299         require(_value <= balances[_from]);
300 
301         balances[_from] = balances[_from].sub(_value);
302         balances[compositionAddress] = balances[compositionAddress].add(_value);
303         Transfer(_from, compositionAddress, _value);
304         return true;
305     }
306 
307     function end() afterEndTime() external {
308         selfdestruct(compositionAddress);
309     }
310 }