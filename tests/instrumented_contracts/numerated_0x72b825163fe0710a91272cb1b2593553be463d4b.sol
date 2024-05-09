1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract MultiOwnable{
47 
48   mapping(address => bool) public owners;
49   uint internal ownersLength_;
50 
51   modifier onlyOwner() {
52     require(owners[msg.sender]);
53     _;
54   }
55   
56   event AddOwner(address indexed sender, address indexed owner);
57   event RemoveOwner(address indexed sender, address indexed owner);
58 
59   function addOwner_(address _for) internal returns(bool) {
60     if(!owners[_for]) {
61       ownersLength_ += 1;
62       owners[_for] = true;
63       emit AddOwner(msg.sender, _for);
64       return true;
65     }
66     return false;
67   }
68 
69   function addOwner(address _for) onlyOwner external returns(bool) {
70     return addOwner_(_for);
71   }
72 
73   function removeOwner_(address _for) internal returns(bool) {
74     if((owners[_for]) && (ownersLength_ > 1)){
75       ownersLength_ -= 1;
76       owners[_for] = false;
77       emit RemoveOwner(msg.sender, _for);
78       return true;
79     }
80     return false;
81   }
82 
83   function removeOwner(address _for) onlyOwner external returns(bool) {
84     return removeOwner_(_for);
85   }
86 
87 }
88 
89 contract IERC20{
90   function allowance(address owner, address spender) external view returns (uint);
91   function transferFrom(address from, address to, uint value) external returns (bool);
92   function approve(address spender, uint value) external returns (bool);
93   function totalSupply() external view returns (uint);
94   function balanceOf(address who) external view returns (uint);
95   function transfer(address to, uint value) external returns (bool);
96   
97   event Transfer(address indexed from, address indexed to, uint value);
98   event Approval(address indexed owner, address indexed spender, uint value);
99 }
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract ERC20 is IERC20{
110   using SafeMath for uint;
111 
112   mapping(address => uint) internal balances;
113   mapping (address => mapping (address => uint)) internal allowed;
114 
115   uint internal totalSupply_;
116 
117 
118   /**
119   * @dev total number of tokens in existence
120   */
121   function totalSupply() external view returns (uint) {
122     return totalSupply_;
123   }
124 
125   /**
126    * @dev Transfer tokens from one address to another
127    * @param _from address The address which you want to send tokens from
128    * @param _to address The address which you want to transfer to
129    * @param _value The amount of tokens to be transferred
130    */
131   function transfer_(address _from, address _to, uint _value) internal returns (bool) {
132     if(_from != _to) {
133       uint _bfrom = balances[_from];
134       uint _bto = balances[_to];
135       require(_to != address(0));
136       require(_value <= _bfrom);
137       balances[_from] = _bfrom.sub(_value);
138       balances[_to] = _bto.add(_value);
139     }
140     emit Transfer(_from, _to, _value);
141     return true;
142   }
143 
144 
145   /**
146   * @dev transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint _value) external returns (bool) {
151     return transfer_(msg.sender, _to, _value);
152   }
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint the amount of tokens to be transferred
159    */
160   function transferFrom(address _from, address _to, uint _value) external returns (bool) {
161     uint _allowed = allowed[_from][msg.sender];
162     require(_value <= _allowed);
163     allowed[_from][msg.sender] = _allowed.sub(_value);
164     return transfer_(_from, _to, _value);
165   }
166 
167   /**
168   * @dev Gets the balance of the specified address.
169   * @param _owner The address to query the the balance of.
170   * @return An uint representing the amount owned by the passed address.
171   */
172   function balanceOf(address _owner) external view returns (uint balance) {
173     return balances[_owner];
174   }
175 
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint _value) external returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     emit Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint specifying the amount of tokens still available for the spender.
198    */
199   function allowance(address _owner, address _spender) external view returns (uint) {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(address _spender, uint _addedValue) external returns (bool) {
214     uint _allowed = allowed[msg.sender][_spender];
215     _allowed = _allowed.add(_addedValue);
216     allowed[msg.sender][_spender] = _allowed;
217     emit Approval(msg.sender, _spender, _allowed);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {
232     uint _allowed = allowed[msg.sender][_spender];
233     if (_subtractedValue > _allowed) {
234       _allowed = 0;
235     } else {
236       _allowed = _allowed.sub(_subtractedValue);
237     }
238     allowed[msg.sender][_spender] = _allowed;
239     emit Approval(msg.sender, _spender, _allowed);
240     return true;
241   }
242 
243 }
244 
245 
246 
247 contract Mediatoken is ERC20, MultiOwnable {
248   using SafeMath for uint;
249   uint constant DECIMAL_MULTIPLIER = 10 ** 18;
250   string public name = "Aitanasecret insta mediatoken utility token";
251   string public symbol = "@Aitanasecret_mediatoken";
252   uint8 public decimals = 18;
253 
254   uint mintSupply_;
255 
256   
257   function mint_(address _for, uint _value) internal returns(bool) {
258     require (mintSupply_ >= _value);
259     mintSupply_ = mintSupply_.sub(_value);
260     balances[_for] = balances[_for].add(_value);
261     totalSupply_ = totalSupply_.add(_value);
262     emit Transfer(address(0), _for, _value);
263     return true;
264   }
265 
266   function mint(address _for, uint _value) external onlyOwner returns(bool) {
267     return mint_(_for, _value);
268   }
269   
270   
271   function mintSupply() external view returns(uint) {
272     return mintSupply_;
273   }
274 
275   constructor() public {
276     mintSupply_ = 2000 * DECIMAL_MULTIPLIER;
277     addOwner_(0x47FC2e245b983A92EB3359F06E31F34B107B6EF6);
278     addOwner_(msg.sender);
279   }
280 }