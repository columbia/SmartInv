1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender)
12     public view returns (uint256);
13 
14   function transferFrom(address from, address to, uint256 value)
15     public returns (bool);
16 
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 contract BasicToken is ERC20 {
26   using SafeMath for uint256;
27 
28   mapping(address => uint256) balances;
29 
30   uint256 totalSupply_;
31 
32   /**
33   * @dev total number of tokens in existence
34   */
35   function totalSupply() public view returns (uint256) {
36     return totalSupply_;
37   }
38 
39   /**
40   * @dev transfer token for a specified address
41   * @param _to The address to transfer to.
42   * @param _value The amount to be transferred.
43   */
44   function transfer(address _to, uint256 _value) public returns (bool) {
45     require(_to != address(0));
46     require(_value <= balances[msg.sender]);
47 
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     emit Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   /**
55   * @dev Gets the balance of the specified address.
56   * @param _owner The address to query the the balance of.
57   * @return An uint256 representing the amount owned by the passed address.
58   */
59   function balanceOf(address _owner) public view returns (uint256) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
72     // benefit is lost if 'b' is also tested.
73     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74     if (a == 0) {
75       return 0;
76     }
77 
78     c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   /**
84   * @dev Integer division of two numbers, truncating the quotient.
85   */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     // uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return a / b;
91   }
92 
93   /**
94   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95   */
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   /**
102   * @dev Adds two numbers, throws on overflow.
103   */
104   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
105     c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 contract StandardToken is BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(
123     address _from,
124     address _to,
125     uint256 _value
126   )
127     public
128     returns (bool)
129   {
130     require(_to != address(0));
131     require(_value <= balances[_from]);
132     require(_value <= allowed[_from][msg.sender]);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137     emit Transfer(_from, _to, _value);
138     return true;
139   }
140 
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
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifying the amount of tokens still available for the spender.
162    */
163   function allowance(
164     address _owner,
165     address _spender
166    )
167     public
168     view
169     returns (uint256)
170   {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(
185     address _spender,
186     uint _addedValue
187   )
188     public
189     returns (bool)
190   {
191     allowed[msg.sender][_spender] = (
192       allowed[msg.sender][_spender].add(_addedValue));
193     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   /**
198    * @dev Decrease the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To decrement
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _subtractedValue The amount of tokens to decrease the allowance by.
206    */
207   function decreaseApproval(
208     address _spender,
209     uint _subtractedValue
210   )
211     public
212     returns (bool)
213   {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 contract RespectCoin is StandardToken {
227 
228   string public constant name = "RespectCoin"; // solium-disable-line uppercase
229   string public constant symbol = "RSP"; // solium-disable-line uppercase
230   uint8 public constant decimals = 18; // solium-disable-line uppercase
231 
232   uint256 public constant INITIAL_SUPPLY = 21000000 * (10 ** uint256(decimals));
233 
234   /**
235    * @dev Constructor that gives msg.sender all of existing tokens.
236    */
237   constructor() public {
238     totalSupply_ = INITIAL_SUPPLY;
239     balances[msg.sender] = INITIAL_SUPPLY;
240     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
241   }
242 }