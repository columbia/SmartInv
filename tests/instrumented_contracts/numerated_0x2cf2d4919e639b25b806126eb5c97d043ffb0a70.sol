1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   uint256 totalSupply_;
16 
17   /**
18   * @dev total number of tokens in existence
19   */
20   function totalSupply() public view returns (uint256) {
21     return totalSupply_;
22   }
23 
24   /**
25   * @dev transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_to != address(0));
31     require(_value <= balances[msg.sender]);
32 
33     balances[msg.sender] = balances[msg.sender].sub(_value);
34     balances[_to] = balances[_to].add(_value);
35     emit Transfer(msg.sender, _to, _value);
36     return true;
37   }
38 
39   /**
40   * @dev Gets the balance of the specified address.
41   * @param _owner The address to query the the balance of.
42   * @return An uint256 representing the amount owned by the passed address.
43   */
44   function balanceOf(address _owner) public view returns (uint256) {
45     return balances[_owner];
46   }
47 
48 }
49 
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender)
52     public view returns (uint256);
53 
54   function transferFrom(address from, address to, uint256 value)
55     public returns (bool);
56 
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(
59     address indexed owner,
60     address indexed spender,
61     uint256 value
62   );
63 }
64 
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     if (a == 0) {
72       return 0;
73     }
74     c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     // uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return a / b;
87   }
88 
89   /**
90   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
101     c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106 
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(
119     address _from,
120     address _to,
121     uint256 _value
122   )
123     public
124     returns (bool)
125   {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     emit Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     emit Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(
160     address _owner,
161     address _spender
162    )
163     public
164     view
165     returns (uint256)
166   {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * @dev Increase the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _addedValue The amount of tokens to increase the allowance by.
179    */
180   function increaseApproval(
181     address _spender,
182     uint _addedValue
183   )
184     public
185     returns (bool)
186   {
187     allowed[msg.sender][_spender] = (
188       allowed[msg.sender][_spender].add(_addedValue));
189     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(
204     address _spender,
205     uint _subtractedValue
206   )
207     public
208     returns (bool)
209   {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 contract ScienceToken is StandardToken {
223 
224   string public constant name = "Science-Token";
225   string public constant symbol = "ST";
226   uint8 public constant decimals = 8;
227 
228   uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
229 
230   constructor() public {
231     totalSupply_ = INITIAL_SUPPLY;
232     balances[msg.sender] = INITIAL_SUPPLY;
233     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
234   }
235 
236 }