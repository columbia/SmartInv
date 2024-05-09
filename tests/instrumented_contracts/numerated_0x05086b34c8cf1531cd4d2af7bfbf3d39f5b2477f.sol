1 pragma solidity ^0.4.16;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that throw on error
53  */
54 library SafeMath32 {
55 
56   /**
57   * @dev Multiplies two numbers, throws on overflow.
58   */
59   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
60     if (a == 0) {
61       return 0;
62     }
63     uint32 c = a * b;
64     assert(c / a == b);
65     return c;
66   }
67 
68   /**
69   * @dev Integer division of two numbers, truncating the quotient.
70   */
71   function div(uint32 a, uint32 b) internal pure returns (uint32) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint32 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   /**
79   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
80   */
81   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
82     assert(b <= a);
83     return a - b;
84   }
85 
86   /**
87   * @dev Adds two numbers, throws on overflow.
88   */
89   function add(uint32 a, uint32 b) internal pure returns (uint32) {
90     uint32 c = a + b;
91     assert(c >= a);
92     return c;
93   }
94 }
95 
96 
97 /**
98  * @title SafeMath
99  * @dev Math operations with safety checks that throw on error
100  */
101 library SafeMath8 {
102 
103   /**
104   * @dev Multiplies two numbers, throws on overflow.
105   */
106   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
107     if (a == 0) {
108       return 0;
109     }
110     uint8 c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint8 a, uint8 b) internal pure returns (uint8) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     uint8 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return c;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint8 a, uint8 b) internal pure returns (uint8) {
137     uint8 c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154   /**
155    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
156    * account.
157    */
158   function Ownable() public {
159     owner = msg.sender;
160   }
161 
162 
163   /**
164    * @dev Throws if called by any account other than the owner.
165    */
166   modifier onlyOwner() {
167     require(msg.sender == owner);
168     _;
169   }
170 
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address newOwner) public onlyOwner {
177     require(newOwner != address(0));
178     OwnershipTransferred(owner, newOwner);
179     owner = newOwner;
180   }
181 
182 }
183 contract ERC20Basic {
184   uint256 public totalSupply;
185   function balanceOf(address who) public constant returns (uint256);
186   function transfer(address to, uint256 value) public returns (bool);
187   event Transfer(address indexed from, address indexed to, uint256 value);
188 }
189 
190 contract BasicToken is ERC20Basic {
191   using SafeMath for uint256;
192   mapping(address => uint256) balances;
193   
194 
195   function transfer(address _to, uint256 _value) public returns (bool) {
196     require(_to != address(0));
197     require(_value > 0 && _value <= balances[msg.sender]);
198     
199     balances[msg.sender] = balances[msg.sender].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     
202     emit Transfer(msg.sender, _to, _value);
203     return true;
204   }
205   
206   function balanceOf(address _owner) public constant returns (uint256 balance) {
207     return balances[_owner];
208   }
209 }
210 
211 contract ERC20 is ERC20Basic {
212   function allowance(address owner, address spender) public constant returns (uint256);
213   function transferFrom(address from, address to, uint256 value) public returns (bool);
214   function approve(address spender, uint256 value) public returns (bool);
215   event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 contract StandardToken is ERC20, BasicToken {
219   mapping (address => mapping (address => uint256)) internal allowed;
220   
221   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
222     require(_to != address(0));
223     require(_value > 0 && _value <= balances[_from]);
224     require(_value <= allowed[_from][msg.sender]);
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     
229     emit Transfer(_from, _to, _value);
230     return true;
231   }
232   
233   function approve(address _spender, uint256 _value) public returns (bool) {
234     allowed[msg.sender][_spender] = _value;
235     emit Approval(msg.sender, _spender, _value);
236     return true;
237   }
238   
239   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
240     return allowed[_owner][_spender];
241   }
242 }
243 
244 contract Pausable is Ownable {
245   event Pause();
246   event Unpause();
247   bool public paused = false;
248  
249   modifier whenNotPaused() {
250     require(!paused);
251     _;
252   }
253   
254   modifier whenPaused() {
255     require(paused);
256     _;
257   }
258  
259   function pause() onlyOwner whenNotPaused public {
260     paused = true;
261     Pause();
262   }
263   
264   function unpause() onlyOwner whenPaused public {
265     paused = false;
266     Unpause();
267   }
268 }
269 
270 contract PausableToken is StandardToken, Pausable {
271   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
272     return super.transfer(_to, _value);
273   }
274   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
275     return super.transferFrom(_from, _to, _value);
276   }
277   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
278     return super.approve(_spender, _value);
279   }
280 }
281 /**
282  * 
283  * 
284  */
285 contract MyBridgeToken is Ownable, PausableToken {
286     
287     using SafeMath for uint256;
288     
289     string public name = 'MyBridgeToken';
290     string public symbol = 'MBT';
291     string public version = '1.0.2';
292     uint8 public decimals = 18;
293     
294     constructor (uint256 initialSupply) public {
295         totalSupply = initialSupply * 10 ** uint256(decimals);
296         balances[msg.sender] = totalSupply;
297     }
298     
299     function () public payable {
300         revert();
301     }
302     
303     
304 }