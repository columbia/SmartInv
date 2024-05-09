1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     if (a == 0) {
11       return 0;
12     }
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     // uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return a / b;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 contract ERC20Basic {
48   function totalSupply() public view returns (uint256);
49   function balanceOf(address who) public view returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender)
57     public view returns (uint256);
58 
59   function transferFrom(address from, address to, uint256 value)
60     public returns (bool);
61 
62   function approve(address spender, uint256 value) public returns (bool);
63   event Approval(
64     address indexed owner,
65     address indexed spender,
66     uint256 value
67   );
68 }
69 
70 
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amount of tokens to be transferred
122    */
123   function transferFrom(
124     address _from,
125     address _to,
126     uint256 _value
127   )
128     public
129     returns (bool)
130   {
131     require(_to != address(0));
132     require(_value <= balances[_from]);
133     require(_value <= allowed[_from][msg.sender]);
134 
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138     emit Transfer(_from, _to, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144    *
145    * Beware that changing an allowance with this method brings the risk that someone may use both the old
146    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint256 _value) public returns (bool) {
153     allowed[msg.sender][_spender] = _value;
154     emit Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param _owner address The address which owns the funds.
161    * @param _spender address The address which will spend the funds.
162    * @return A uint256 specifying the amount of tokens still available for the spender.
163    */
164   function allowance(
165     address _owner,
166     address _spender
167    )
168     public
169     view
170     returns (uint256)
171   {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(
186     address _spender,
187     uint _addedValue
188   )
189     public
190     returns (bool)
191   {
192     allowed[msg.sender][_spender] = (
193       allowed[msg.sender][_spender].add(_addedValue));
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(
209     address _spender,
210     uint _subtractedValue
211   )
212     public
213     returns (bool)
214   {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 
228 contract BITMONEY is StandardToken {
229 
230   string public constant name = "BITMONEY"; // solium-disable-line uppercase
231   string public constant symbol = "BTM"; // solium-disable-line uppercase
232   uint8 public constant decimals = 18; // solium-disable-line uppercase
233 
234   uint256 public constant INITIAL_SUPPLY = 15000000000000000000000000000;
235 
236   /**
237    * @dev Constructor that gives msg.sender all of existing tokens.
238    */
239   constructor() public {
240     totalSupply_ = INITIAL_SUPPLY;
241     balances[msg.sender] = INITIAL_SUPPLY;
242     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
243   }
244 
245 }