1 pragma solidity 0.4.18;
2 
3 /*
4     contract CryptogeneToken
5 */
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) public constant returns (uint256);
47   function transferFrom(address from, address to, uint256 value) public returns (bool);
48   function approve(address spender, uint256 value) public returns (bool);
49   event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public constant returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86   mapping (address => mapping (address => uint256)) internal allowed;
87 
88 
89   /**
90    * @dev Transfer tokens from one address to another
91    * @param _from address The address which you want to send tokens from
92    * @param _to address The address which you want to transfer to
93    * @param _value uint256 the amount of tokens to be transferred
94    */
95   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[_from]);
98     require(_value <= allowed[_from][msg.sender]);
99 
100     balances[_from] = balances[_from].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103     Transfer(_from, _to, _value);
104     return true;
105   }
106 
107   /**
108    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
109    *
110    * Beware that changing an allowance with this method brings the risk that someone may use both the old
111    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
112    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
113    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114    * @param _spender The address which will spend the funds.
115    * @param _value The amount of tokens to be spent.
116    */
117   function approve(address _spender, uint256 _value) public returns (bool) {
118     allowed[msg.sender][_spender] = _value;
119     Approval(msg.sender, _spender, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Function to check the amount of tokens that an owner allowed to a spender.
125    * @param _owner address The address which owns the funds.
126    * @param _spender address The address which will spend the funds.
127    * @return A uint256 specifying the amount of tokens still available for the spender.
128    */
129   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
130     return allowed[_owner][_spender];
131   }
132 
133   /**
134    * approve should be called when allowed[_spender] == 0. To increment
135    * allowed value is better to use this function to avoid 2 calls (and wait until
136    * the first transaction is mined)
137    * From MonolithDAO Token.sol
138    */
139   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
140     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144 
145   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
146     uint oldValue = allowed[msg.sender][_spender];
147     if (_subtractedValue > oldValue) {
148       allowed[msg.sender][_spender] = 0;
149     } else {
150       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
151     }
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156 }
157 
158 contract BurnableToken is StandardToken {
159 
160     event Burn(address indexed burner, uint256 value);
161 
162     /**
163      * @dev Burns a specific amount of tokens.
164      * @param _value The amount of token to be burned.
165      */
166     function burn(uint256 _value) public {
167         require(_value > 0);
168         require(_value <= balances[msg.sender]);
169         // no need to require value <= totalSupply, since that would imply the
170         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
171 
172         address burner = msg.sender;
173         balances[burner] = balances[burner].sub(_value);
174         totalSupply = totalSupply.sub(_value);
175         Burn(burner, _value);
176     }
177 }
178 
179 contract CryptogeneToken is StandardToken, BurnableToken {
180   string public constant name = "CryptogeneToken";
181   string public constant symbol = "XGT";
182   uint256 public constant decimals = 18;
183   uint256 public constant INITIAL_SUPPLY = 50000001 * (10 ** uint256(decimals));
184 
185   /**
186    * @dev Contructor that gives msg.sender all of existing tokens.
187    */
188   function CryptogeneToken() public {
189     totalSupply = INITIAL_SUPPLY;
190     balances[msg.sender] = INITIAL_SUPPLY;
191   }
192 }