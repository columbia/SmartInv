1 pragma solidity ^0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * See https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender)
73     public view returns (uint256);
74 
75   function transferFrom(address from, address to, uint256 value)
76     public returns (bool);
77 
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(
80     address indexed owner,
81     address indexed spender,
82     uint256 value
83   );
84 }
85 
86 
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances.
90  */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96   uint256 totalSupply_;
97 
98   /**
99   * @dev Total number of tokens in existence
100   */
101   function totalSupply() public view returns (uint256) {
102     return totalSupply_;
103   }
104 
105   /**
106   * @dev Transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[msg.sender]);
113 
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     emit Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   /**
121   * @dev Gets the balance of the specified address.
122   * @param _owner The address to query the the balance of.
123   * @return An uint256 representing the amount owned by the passed address.
124   */
125   function balanceOf(address _owner) public view returns (uint256) {
126     return balances[_owner];
127   }
128 
129 }
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * https://github.com/ethereum/EIPs/issues/20
136  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(
150     address _from,
151     address _to,
152     uint256 _value
153   )
154     public
155     returns (bool)
156   {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     emit Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(
190     address _owner,
191     address _spender
192    )
193     public
194     view
195     returns (uint256)
196   {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * @dev Increase the amount of tokens that an owner allowed to a spender.
202    * approve should be called when allowed[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _addedValue The amount of tokens to increase the allowance by.
208    */
209   function increaseApproval(
210     address _spender,
211     uint256 _addedValue
212   )
213     public
214     returns (bool)
215   {
216     allowed[msg.sender][_spender] = (
217       allowed[msg.sender][_spender].add(_addedValue));
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222   /**
223    * @dev Decrease the amount of tokens that an owner allowed to a spender.
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(
232     address _spender,
233     uint256 _subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     uint256 oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 
251 // ----------------------------------------------------------------------------
252 // Contract function to receive approval and execute function in one call
253 //
254 // Borrowed from MiniMeToken
255 // ----------------------------------------------------------------------------
256 contract ApproveAndCallFallBack {
257     function receiveApproval(address from, uint256 value, address token, bytes data) public;
258 }
259 
260 contract PunchToken is StandardToken {
261     string public symbol;
262     string public  name;
263     uint8 public decimals;
264 
265     // ------------------------------------------------------------------------
266     // Constructor
267     // ------------------------------------------------------------------------
268     constructor() public {
269         symbol = "PUN";
270         name = "Punch Token";
271         decimals = 18;
272         totalSupply_ = 60000000000000000000000000000;
273         balances[0xC3F6110EbA4d001bAB48E05dbC48166d1624402b] = totalSupply_;
274         emit Transfer(address(0), 0xC3F6110EbA4d001bAB48E05dbC48166d1624402b, totalSupply_);
275     }
276 
277     // ------------------------------------------------------------------------
278     // Token owner can approve for spender to transferFrom(...) tokens
279     // from the token owner's account. The spender contract function
280     // receiveApproval(...) is then executed
281     // ------------------------------------------------------------------------
282     function approveAndCall(address _spender, uint256 _value, bytes data) public returns (bool) {
283 		approve(_spender,_value);
284         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, data);
285         return true;
286     }
287 
288     // ------------------------------------------------------------------------
289     // Don't accept ETH
290     // ------------------------------------------------------------------------
291     function () public payable {
292         revert();
293     }
294 }