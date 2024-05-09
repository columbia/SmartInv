1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 
248 contract LieMiToken is StandardToken {
249     string public name = "LieMiToken";
250     string public symbol = "LMI";
251     uint8 public decimals = 18;
252     uint public INITIAL_SUPPLY = 100000000;
253     
254     constructor() public {
255       totalSupply_ = INITIAL_SUPPLY;
256       balances[msg.sender] = INITIAL_SUPPLY;
257     }
258 }