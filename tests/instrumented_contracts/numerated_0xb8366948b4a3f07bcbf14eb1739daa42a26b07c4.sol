1 pragma solidity 0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 /**
30  * @title ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/20
32  */
33 contract ERC20 {
34   function totalSupply() public view returns (uint256);
35 
36   function balanceOf(address _who) public view returns (uint256);
37 
38   function allowance(address _owner, address _spender)
39     public view returns (uint256);
40 
41   function transfer(address _to, uint256 _value) public returns (bool);
42 
43   function approve(address _spender, uint256 _value)
44     public returns (bool);
45 
46   function transferFrom(address _from, address _to, uint256 _value)
47     public returns (bool);
48 
49   event Transfer(
50     address indexed from,
51     address indexed to,
52     uint256 value
53   );
54 
55   event Approval(
56     address indexed owner,
57     address indexed spender,
58     uint256 value
59   );
60 }
61 
62 /**
63  * @title Standard ERC20 token
64  *
65  * @dev Implementation of the basic standard token.
66  * https://github.com/ethereum/EIPs/issues/20
67  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
68  */
69 contract StandardToken is ERC20 {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   mapping (address => mapping (address => uint256)) internal allowed;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev Total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256) {
91     return balances[_owner];
92   }
93 
94   /**
95    * @dev Function to check the amount of tokens that an owner allowed to a spender.
96    * @param _owner address The address which owns the funds.
97    * @param _spender address The address which will spend the funds.
98    * @return A uint256 specifying the amount of tokens still available for the spender.
99    */
100   function allowance(
101     address _owner,
102     address _spender
103    )
104     public
105     view
106     returns (uint256)
107   {
108     return allowed[_owner][_spender];
109   }
110 
111   /**
112   * @dev Transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_value <= balances[msg.sender]);
118     require(_to != address(0));
119 
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     emit Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     emit Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(
148     address _from,
149     address _to,
150     uint256 _value
151   )
152     public
153     returns (bool)
154   {
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157     require(_to != address(0));
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Increase the amount of tokens that an owner allowed to a spender.
168    * approve should be called when allowed[_spender] == 0. To increment
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _addedValue The amount of tokens to increase the allowance by.
174    */
175   function increaseApproval(
176     address _spender,
177     uint256 _addedValue
178   )
179     public
180     returns (bool)
181   {
182     allowed[msg.sender][_spender] = (
183       allowed[msg.sender][_spender].add(_addedValue));
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    * approve should be called when allowed[_spender] == 0. To decrement
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _subtractedValue The amount of tokens to decrease the allowance by.
196    */
197   function decreaseApproval(
198     address _spender,
199     uint256 _subtractedValue
200   )
201     public
202     returns (bool)
203   {
204     uint256 oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue >= oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 contract VALOBIT is StandardToken { 
217   string public name="VALOBIT";
218   string public symbol="VBIT";
219   uint8 public decimals=18;
220   uint256 public constant INITIAL_SUPPLY = 1600000000 * (10 ** uint256(decimals));
221 
222   /**
223    * @dev Constructor that gives msg.sender all of existing tokens.
224    */
225   constructor() public {
226     totalSupply_ = INITIAL_SUPPLY;
227     balances[msg.sender] = INITIAL_SUPPLY;
228     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
229   }
230 }