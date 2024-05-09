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
65 contract StandardToken is ERC20, BasicToken {
66 
67   mapping (address => mapping (address => uint256)) internal allowed;
68 
69 
70   /**
71    * @dev Transfer tokens from one address to another
72    * @param _from address The address which you want to send tokens from
73    * @param _to address The address which you want to transfer to
74    * @param _value uint256 the amount of tokens to be transferred
75    */
76   function transferFrom(
77     address _from,
78     address _to,
79     uint256 _value
80   )
81     public
82     returns (bool)
83   {
84     require(_to != address(0));
85     require(_value <= balances[_from]);
86     require(_value <= allowed[_from][msg.sender]);
87 
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91     emit Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    *
98    * Beware that changing an allowance with this method brings the risk that someone may use both the old
99    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
100    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
101    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102    * @param _spender The address which will spend the funds.
103    * @param _value The amount of tokens to be spent.
104    */
105   function approve(address _spender, uint256 _value) public returns (bool) {
106     allowed[msg.sender][_spender] = _value;
107     emit Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Function to check the amount of tokens that an owner allowed to a spender.
113    * @param _owner address The address which owns the funds.
114    * @param _spender address The address which will spend the funds.
115    * @return A uint256 specifying the amount of tokens still available for the spender.
116    */
117   function allowance(
118     address _owner,
119     address _spender
120    )
121     public
122     view
123     returns (uint256)
124   {
125     return allowed[_owner][_spender];
126   }
127 
128   /**
129    * @dev Increase the amount of tokens that an owner allowed to a spender.
130    *
131    * approve should be called when allowed[_spender] == 0. To increment
132    * allowed value is better to use this function to avoid 2 calls (and wait until
133    * the first transaction is mined)
134    * From MonolithDAO Token.sol
135    * @param _spender The address which will spend the funds.
136    * @param _addedValue The amount of tokens to increase the allowance by.
137    */
138   function increaseApproval(
139     address _spender,
140     uint _addedValue
141   )
142     public
143     returns (bool)
144   {
145     allowed[msg.sender][_spender] = (
146       allowed[msg.sender][_spender].add(_addedValue));
147     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151   /**
152    * @dev Decrease the amount of tokens that an owner allowed to a spender.
153    *
154    * approve should be called when allowed[_spender] == 0. To decrement
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    * @param _spender The address which will spend the funds.
159    * @param _subtractedValue The amount of tokens to decrease the allowance by.
160    */
161   function decreaseApproval(
162     address _spender,
163     uint _subtractedValue
164   )
165     public
166     returns (bool)
167   {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178 }
179 
180 contract HongZhangCoin is StandardToken {
181   string public name = "HongZhangCoin"; 
182   string public symbol = "HZ";
183   uint public decimals = 18;
184   uint public INITIAL_SUPPLY = 60000 * 10000 * (10 ** decimals);
185 
186   constructor() public {
187     totalSupply_ = INITIAL_SUPPLY;
188     balances[msg.sender] = INITIAL_SUPPLY;
189   }
190 }
191 
192 library SafeMath {
193 
194   /**
195   * @dev Multiplies two numbers, throws on overflow.
196   */
197   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
198     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
199     // benefit is lost if 'b' is also tested.
200     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
201     if (a == 0) {
202       return 0;
203     }
204 
205     c = a * b;
206     assert(c / a == b);
207     return c;
208   }
209 
210   /**
211   * @dev Integer division of two numbers, truncating the quotient.
212   */
213   function div(uint256 a, uint256 b) internal pure returns (uint256) {
214     // assert(b > 0); // Solidity automatically throws when dividing by 0
215     // uint256 c = a / b;
216     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217     return a / b;
218   }
219 
220   /**
221   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
222   */
223   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224     assert(b <= a);
225     return a - b;
226   }
227 
228   /**
229   * @dev Adds two numbers, throws on overflow.
230   */
231   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
232     c = a + b;
233     assert(c >= a);
234     return c;
235   }
236 }