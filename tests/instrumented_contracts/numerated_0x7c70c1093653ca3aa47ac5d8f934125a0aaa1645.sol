1 pragma solidity ^0.4.19;
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
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 
54 
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address _who) public view returns (uint256);
58   function transfer(address _to, uint256 _value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address _owner, address _spender)
66     public view returns (uint256);
67 
68   function transferFrom(address _from, address _to, uint256 _value)
69     public returns (bool);
70 
71   function approve(address _spender, uint256 _value) public returns (bool);
72   event Approval(
73     address indexed owner,
74     address indexed spender,
75     uint256 value
76   );
77 }
78 
79 
80 
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) internal balances;
85 
86   uint256 internal totalSupply_;
87 
88   /**
89   * @dev Total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev Transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_value <= balances[msg.sender]);
102     require(_to != address(0));
103 
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * https://github.com/ethereum/EIPs/issues/20
128  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amount of tokens to be transferred
140    */
141   function transferFrom(
142     address _from,
143     address _to,
144     uint256 _value
145   )
146     public
147     returns (bool)
148   {
149     require(_value <= balances[_from]);
150     require(_value <= allowed[_from][msg.sender]);
151     require(_to != address(0));
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     Transfer(_from, _to, _value);
157     return true;
158   }
159   
160   modifier legalBatchTransfer(uint256[] _values) {
161       uint256 sumOfValues = 0;
162       for(uint i = 0; i < _values.length; i++) {
163           sumOfValues = sumOfValues.add(_values[i]);
164       }
165       if(sumOfValues.mul(10 ** 8) > balanceOf(msg.sender)) {
166           revert();
167       }
168       _;
169   }
170   
171   function multiValueBatchTransfer(address[] _recipients, uint256[] _values) public legalBatchTransfer(_values) returns(bool){
172       require(_recipients.length == _values.length && _values.length <= 100);
173       for(uint i = 0; i < _recipients.length; i++) {
174         balances[msg.sender] = balances[msg.sender].sub(_values[i].mul(10 ** 8));
175         balances[_recipients[i]] = balances[_recipients[i]].add(_values[i].mul(10 ** 8));
176         Transfer(msg.sender, _recipients[i], _values[i].mul(10 ** 8));
177       }
178       return true;
179   }
180   
181   function singleValueBatchTransfer(address[] _recipients, uint256 _value) public returns(bool) {
182       require(balanceOf(msg.sender) >= _recipients.length.mul(_value.mul(10 ** 8)));
183       for(uint i = 0; i < _recipients.length; i++) {
184         balances[msg.sender] = balances[msg.sender].sub(_value.mul(10 ** 8));
185         balances[_recipients[i]] = balances[_recipients[i]].add(_value.mul(10 ** 8));
186         Transfer(msg.sender, _recipients[i], _value.mul(10 ** 8));
187       }
188       return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     allowed[msg.sender][_spender] = _value;
202     Approval(msg.sender, _spender, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(
213     address _owner,
214     address _spender
215    )
216     public
217     view
218     returns (uint256)
219   {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(
233     address _spender,
234     uint256 _addedValue
235   )
236     public
237     returns (bool)
238   {
239     allowed[msg.sender][_spender] = (
240       allowed[msg.sender][_spender].add(_addedValue));
241     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245   /**
246    * @dev Decrease the amount of tokens that an owner allowed to a spender.
247    * approve should be called when allowed[_spender] == 0. To decrement
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _subtractedValue The amount of tokens to decrease the allowance by.
253    */
254   function decreaseApproval(
255     address _spender,
256     uint256 _subtractedValue
257   )
258     public
259     returns (bool)
260   {
261     uint256 oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue >= oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 
273 
274 contract SHNZ2 is StandardToken {
275     
276     string public name;
277     string public symbol;
278     uint8 public decimals;
279     uint256 public totalSupply;
280     
281     function SHNZ2() {
282         name = "Shizzle Nizzle 2";
283         symbol = "SHNZ2";
284         decimals = 8;
285         totalSupply = 100000000000e8;
286         balances[0x7e826E85CbA4d3AAaa1B484f53BE01D10F527Fd6] = totalSupply;
287         Transfer(address(this), 0x7e826E85CbA4d3AAaa1B484f53BE01D10F527Fd6, totalSupply);
288     }
289 }