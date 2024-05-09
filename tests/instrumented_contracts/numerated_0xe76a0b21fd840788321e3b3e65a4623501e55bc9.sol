1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 /**
31  * @title ERC20Basic
32  * @dev Simpler version of ERC20 interface
33  * @dev see https://github.com/ethereum/EIPs/issues/179
34  */
35 contract ERC20Basic {
36   function totalSupply() public view returns (uint256);
37   function balanceOf(address who) public view returns (uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 /**
43  * @title ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/20
45  */
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) public view returns (uint256);
48   function transferFrom(address from, address to, uint256 value) public returns (bool);
49   function approve(address spender, uint256 value) public returns (bool);
50   event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   uint256 totalSupply_;
63 
64   /**
65   * @dev total number of tokens in existence
66   */
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     emit Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) internal allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amount of tokens to be transferred
113    */
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[_from]);
117     require(_value <= allowed[_from][msg.sender]);
118 
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122     emit Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    *
129    * Beware that changing an allowance with this method brings the risk that someone may use both the old
130    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     emit Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) public view returns (uint256) {
149     return allowed[_owner][_spender];
150   }
151 
152   /**
153    * @dev Increase the amount of tokens that an owner allowed to a spender.
154    *
155    * approve should be called when allowed[_spender] == 0. To increment
156    * allowed value is better to use this function to avoid 2 calls (and wait until
157    * the first transaction is mined)
158    * From MonolithDAO Token.sol
159    * @param _spender The address which will spend the funds.
160    * @param _addedValue The amount of tokens to increase the allowance by.
161    */
162   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
163     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168   /**
169    * @dev Decrease the amount of tokens that an owner allowed to a spender.
170    *
171    * approve should be called when allowed[_spender] == 0. To decrement
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    * @param _spender The address which will spend the funds.
176    * @param _subtractedValue The amount of tokens to decrease the allowance by.
177    */
178   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
179     uint oldValue = allowed[msg.sender][_spender];
180     if (_subtractedValue > oldValue) {
181       allowed[msg.sender][_spender] = 0;
182     } else {
183       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184     }
185     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189 }
190 
191 /**
192  * @title Burnable Token
193  * @dev Token that can be irreversibly burned (destroyed).
194  */
195 contract BurnableToken is BasicToken {
196 
197   event Burn(address indexed burner, uint256 value);
198 
199   /**
200    * @dev Burns a specific amount of tokens.
201    * @param _value The amount of token to be burned.
202    */
203   function burn(uint256 _value) public {
204     require(_value <= balances[msg.sender]);
205     // no need to require value <= totalSupply, since that would imply the
206     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
207 
208     address burner = msg.sender;
209     balances[burner] = balances[burner].sub(_value);
210     totalSupply_ = totalSupply_.sub(_value);
211     emit Burn(burner, _value);
212     emit Transfer(burner, address(0), _value);
213   }
214 }
215 
216 /** 
217  * Detailed
218  */
219 contract MyCoin is StandardToken,BurnableToken {
220     string public name = "DoraCoin";
221     string public symbol = "DOR";
222     uint256 public decimals = 18;
223     uint256 public INITIAL_SUPPLY = 51000000 * (10 ** uint256(decimals));
224 
225     function MyCoin() public {
226         totalSupply_ = INITIAL_SUPPLY;
227         balances[msg.sender] = INITIAL_SUPPLY;
228         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
229     }
230 }