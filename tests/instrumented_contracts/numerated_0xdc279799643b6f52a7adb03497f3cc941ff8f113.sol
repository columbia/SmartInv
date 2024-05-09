1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Basic token
17  * @dev Basic version of StandardToken, with no allowances.
18  */
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
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
33     // SafeMath.sub will throw if there is not enough balance.
34     balances[msg.sender] = balances[msg.sender].sub(_value);
35     balances[_to] = balances[_to].add(_value);
36     Transfer(msg.sender, _to, _value);
37     return true;
38   }
39 
40   /**
41   * @dev Gets the balance of the specified address.
42   * @param _owner The address to query the the balance of.
43   * @return An uint256 representing the amount owned by the passed address.
44   */
45   function balanceOf(address _owner) public view returns (uint256 balance) {
46     return balances[_owner];
47   }
48 
49 }
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender) public view returns (uint256);
57   function transferFrom(address from, address to, uint256 value) public returns (bool);
58   function approve(address spender, uint256 value) public returns (bool);
59   event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 /**
63  * @title Standard ERC20 token
64  *
65  * @dev Implementation of the basic standard token.
66  * @dev https://github.com/ethereum/EIPs/issues/20
67  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
68  */
69 contract StandardToken is ERC20, BasicToken {
70 
71   mapping (address => mapping (address => uint256)) internal allowed;
72 
73 
74   /**
75    * @dev Transfer tokens from one address to another
76    * @param _from address The address which you want to send tokens from
77    * @param _to address The address which you want to transfer to
78    * @param _value uint256 the amount of tokens to be transferred
79    */
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value <= allowed[_from][msg.sender]);
84 
85     balances[_from] = balances[_from].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88     Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   /**
93    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
94    *
95    * Beware that changing an allowance with this method brings the risk that someone may use both the old
96    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
97    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
98    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
99    * @param _spender The address which will spend the funds.
100    * @param _value The amount of tokens to be spent.
101    */
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   /**
109    * @dev Function to check the amount of tokens that an owner allowed to a spender.
110    * @param _owner address The address which owns the funds.
111    * @param _spender address The address which will spend the funds.
112    * @return A uint256 specifying the amount of tokens still available for the spender.
113    */
114   function allowance(address _owner, address _spender) public view returns (uint256) {
115     return allowed[_owner][_spender];
116   }
117 
118   /**
119    * @dev Increase the amount of tokens that an owner allowed to a spender.
120    *
121    * approve should be called when allowed[_spender] == 0. To increment
122    * allowed value is better to use this function to avoid 2 calls (and wait until
123    * the first transaction is mined)
124    * From MonolithDAO Token.sol
125    * @param _spender The address which will spend the funds.
126    * @param _addedValue The amount of tokens to increase the allowance by.
127    */
128   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
129     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
130     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133 
134   /**
135    * @dev Decrease the amount of tokens that an owner allowed to a spender.
136    *
137    * approve should be called when allowed[_spender] == 0. To decrement
138    * allowed value is better to use this function to avoid 2 calls (and wait until
139    * the first transaction is mined)
140    * From MonolithDAO Token.sol
141    * @param _spender The address which will spend the funds.
142    * @param _subtractedValue The amount of tokens to decrease the allowance by.
143    */
144   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
145     uint oldValue = allowed[msg.sender][_spender];
146     if (_subtractedValue > oldValue) {
147       allowed[msg.sender][_spender] = 0;
148     } else {
149       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
150     }
151     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154 
155 }
156 
157 /**
158  * @title SafeMath
159  * @dev Math operations with safety checks that throw on error
160  */
161 library SafeMath {
162   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163     if (a == 0) {
164       return 0;
165     }
166     uint256 c = a * b;
167     assert(c / a == b);
168     return c;
169   }
170 
171   function div(uint256 a, uint256 b) internal pure returns (uint256) {
172     // assert(b > 0); // Solidity automatically throws when dividing by 0
173     uint256 c = a / b;
174     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175     return c;
176   }
177 
178   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179     assert(b <= a);
180     return a - b;
181   }
182 
183   function add(uint256 a, uint256 b) internal pure returns (uint256) {
184     uint256 c = a + b;
185     assert(c >= a);
186     return c;
187   }
188 }
189 
190 
191 contract TradeBitToken is StandardToken {
192     string public name = "TradeBit Token";
193     string public symbol = "TBT";
194     uint public decimals = 18;
195 
196     /**
197     * @dev Constructor that gives msg.sender all of existing tokens.
198     */
199     function TradeBitToken() public {
200         totalSupply = 500000000 * (10 ** uint256(decimals)); // 500M tokens total supply
201         balances[msg.sender] = totalSupply;
202     }
203 }