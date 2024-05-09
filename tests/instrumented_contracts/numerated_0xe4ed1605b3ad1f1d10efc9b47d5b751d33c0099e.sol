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
25 contract BasicToken is ERC20Basic {
26   using SafeMath for uint256;
27 
28   mapping(address => uint256) balances;
29 
30   uint256 totalSupply_;
31 
32   /**
33   * @dev Total number of tokens in existence
34   */
35   function totalSupply() public view returns (uint256) {
36     return totalSupply_;
37   }
38 
39   /**
40   * @dev Transfer token for a specified address
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
97    * Beware that changing an allowance with this method brings the risk that someone may use both the old
98    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
99    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
100    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101    * @param _spender The address which will spend the funds.
102    * @param _value The amount of tokens to be spent.
103    */
104   function approve(address _spender, uint256 _value) public returns (bool) {
105     allowed[msg.sender][_spender] = _value;
106     emit Approval(msg.sender, _spender, _value);
107     return true;
108   }
109 
110   /**
111    * @dev Function to check the amount of tokens that an owner allowed to a spender.
112    * @param _owner address The address which owns the funds.
113    * @param _spender address The address which will spend the funds.
114    * @return A uint256 specifying the amount of tokens still available for the spender.
115    */
116   function allowance(
117     address _owner,
118     address _spender
119    )
120     public
121     view
122     returns (uint256)
123   {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * @dev Increase the amount of tokens that an owner allowed to a spender.
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    * @param _spender The address which will spend the funds.
134    * @param _addedValue The amount of tokens to increase the allowance by.
135    */
136   function increaseApproval(
137     address _spender,
138     uint256 _addedValue
139   )
140     public
141     returns (bool)
142   {
143     allowed[msg.sender][_spender] = (
144       allowed[msg.sender][_spender].add(_addedValue));
145     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 
149   /**
150    * @dev Decrease the amount of tokens that an owner allowed to a spender.
151    * approve should be called when allowed[_spender] == 0. To decrement
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    * @param _spender The address which will spend the funds.
156    * @param _subtractedValue The amount of tokens to decrease the allowance by.
157    */
158   function decreaseApproval(
159     address _spender,
160     uint256 _subtractedValue
161   )
162     public
163     returns (bool)
164   {
165     uint256 oldValue = allowed[msg.sender][_spender];
166     if (_subtractedValue > oldValue) {
167       allowed[msg.sender][_spender] = 0;
168     } else {
169       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
170     }
171     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175 }
176 
177 contract TrtContract is StandardToken{
178   address public owner;
179   string public name = 'TravelToken';
180   string public symbol = 'TRT';
181   uint8 public decimals = 8;
182   uint256 constant total = 1000000000000000000; // 10 billions
183 
184   constructor() public {
185     owner = msg.sender;
186     totalSupply_ = total;
187     balances[owner] = total;
188   }
189 
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