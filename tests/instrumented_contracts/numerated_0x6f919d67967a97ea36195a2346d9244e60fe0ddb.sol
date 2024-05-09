1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   /**
60   * @dev total number of tokens in existence
61   */
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103     event Burn(address indexed burner, uint256 value);
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     emit Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     emit Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public view returns (uint256) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * @dev Increase the amount of tokens that an owner allowed to a spender.
152    *
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    * @param _spender The address which will spend the funds.
158    * @param _addedValue The amount of tokens to increase the allowance by.
159    */
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   /**
167    * @dev Decrease the amount of tokens that an owner allowed to a spender.
168    *
169    * approve should be called when allowed[_spender] == 0. To decrement
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    * @param _spender The address which will spend the funds.
174    * @param _subtractedValue The amount of tokens to decrease the allowance by.
175    */
176   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
177     uint oldValue = allowed[msg.sender][_spender];
178     if (_subtractedValue > oldValue) {
179       allowed[msg.sender][_spender] = 0;
180     } else {
181       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182     }
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187 
188     /**
189    * @dev Burns a specific amount of tokens.
190    * @param _value The amount of token to be burned.
191    */
192   function burn(uint256 _value) public {
193     _burn(msg.sender, _value);
194   }
195 
196   function _burn(address _who, uint256 _value) internal {
197     require(_value <= balances[_who]);
198     // no need to require value <= totalSupply, since that would imply the
199     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
200 
201     balances[_who] = balances[_who].sub(_value);
202     totalSupply_ = totalSupply_.sub(_value);
203     emit Burn(_who, _value);
204     emit Transfer(_who, address(0), _value);
205   }
206 
207 }
208 
209 contract BlockcloudToken is StandardToken {
210   string public name    = "Blockcloud";
211   string public symbol  = "BLOC";
212   uint8 public decimals = 18;
213   // ten billion in initial supply
214   uint256 public constant INITIAL_SUPPLY = 10000000000;
215 
216   constructor() public {
217     totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
218     balances[msg.sender] = totalSupply_;
219   }
220 }