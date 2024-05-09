1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (_a == 0) {
29       return 0;
30     }
31 
32     c = _a * _b;
33     assert(c / _a == _b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     // assert(_b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = _a / _b;
43     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
44     return _a / _b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     assert(_b <= _a);
52     return _a - _b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
59     c = _a + _b;
60     assert(c >= _a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) internal balances;
73 
74   uint256 internal totalSupply_;
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
89     require(_value <= balances[msg.sender]);
90     require(_to != address(0));
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
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address _owner, address _spender)
117     public view returns (uint256);
118 
119   function transferFrom(address _from, address _to, uint256 _value)
120     public returns (bool);
121 
122   function approve(address _spender, uint256 _value) public returns (bool);
123   event Approval(
124     address indexed owner,
125     address indexed spender,
126     uint256 value
127   );
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * https://github.com/ethereum/EIPs/issues/20
135  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amount of tokens to be transferred
147    */
148   function transferFrom(
149     address _from,
150     address _to,
151     uint256 _value
152   )
153     public
154     returns (bool)
155   {
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158     require(_to != address(0));
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     emit Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(
189     address _owner,
190     address _spender
191    )
192     public
193     view
194     returns (uint256)
195   {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint256 _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(
231     address _spender,
232     uint256 _subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     uint256 oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue >= oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247 }
248 
249 contract APO is StandardToken {
250     string public constant name = "Apollon Token";
251     string public constant symbol = "APO";
252     uint8 public constant decimals = 18;
253     uint public INITIAL_SUPPLY = 2500000000 * (10 ** uint256(decimals));
254 
255     constructor() public {
256         totalSupply_ = INITIAL_SUPPLY;
257         balances[msg.sender] = INITIAL_SUPPLY;
258     }
259     
260 }