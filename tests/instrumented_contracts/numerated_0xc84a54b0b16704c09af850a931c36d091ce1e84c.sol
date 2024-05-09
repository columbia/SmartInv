1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract ERC20Basic {
30   function totalSupply() public view returns (uint256);
31   function balanceOf(address who) public view returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 /**
37  * @title Basic token
38  * @dev Basic version of StandardToken, with no allowances.
39  */
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42 
43   mapping(address => uint256) balances;
44 
45   uint256 totalSupply_;
46 
47   /**
48   * @dev Total number of tokens in existence
49   */
50   function totalSupply() public view returns (uint256) {
51     return totalSupply_;
52   }
53 
54   /**
55   * @dev Transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value <= balances[msg.sender]);
62 
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     emit Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of.
72   * @return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) public view returns (uint256) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender)
86     public view returns (uint256);
87 
88   function transferFrom(address from, address to, uint256 value)
89     public returns (bool);
90 
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(
93     address indexed owner,
94     address indexed spender,
95     uint256 value
96   );
97 }
98 
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(
111     address _from,
112     address _to,
113     uint256 _value
114   )
115     public
116     returns (bool)
117   {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     emit Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     emit Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(
152     address _owner,
153     address _spender
154    )
155     public
156     view
157     returns (uint256)
158   {
159     return allowed[_owner][_spender];
160   }
161 
162   /**
163    * @dev Increase the amount of tokens that an owner allowed to a spender.
164    *
165    * approve should be called when allowed[_spender] == 0. To increment
166    * allowed value is better to use this function to avoid 2 calls (and wait until
167    * the first transaction is mined)
168    * From MonolithDAO Token.sol
169    * @param _spender The address which will spend the funds.
170    * @param _addedValue The amount of tokens to increase the allowance by.
171    */
172   function increaseApproval(
173     address _spender,
174     uint256 _addedValue
175   )
176     public
177     returns (bool)
178   {
179     allowed[msg.sender][_spender] = (
180       allowed[msg.sender][_spender].add(_addedValue));
181     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185   /**
186    * @dev Decrease the amount of tokens that an owner allowed to a spender.
187    *
188    * approve should be called when allowed[_spender] == 0. To decrement
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    * @param _spender The address which will spend the funds.
193    * @param _subtractedValue The amount of tokens to decrease the allowance by.
194    */
195   function decreaseApproval(
196     address _spender,
197     uint256 _subtractedValue
198   )
199     public
200     returns (bool)
201   {
202     uint256 oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 }
212 
213 contract YOLottoken is StandardToken {
214   uint public INITIAL_SUPPLY = 21000000;
215   string public name = 'YOLottoken';
216   string public symbol = 'YOL';
217   uint256 public decimals = 18;
218 
219   constructor() public {
220     totalSupply_ = INITIAL_SUPPLY * 10 ** decimals;
221     balances[msg.sender] = totalSupply_;
222   }
223 }