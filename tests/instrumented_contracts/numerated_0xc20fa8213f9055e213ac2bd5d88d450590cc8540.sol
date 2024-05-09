1 pragma solidity ^0.4.17;
2 
3 // File: installed_contracts/zeppelin/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: installed_contracts/zeppelin/contracts/token/ERC20Basic.sol
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public constant returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 // File: installed_contracts/zeppelin/contracts/token/BasicToken.sol
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 // File: installed_contracts/zeppelin/contracts/token/ERC20.sol
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public constant returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: installed_contracts/zeppelin/contracts/token/StandardToken.sol
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121 
122     uint256 _allowance = allowed[_from][msg.sender];
123 
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // require (_value <= _allowance);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval (address _spender, uint _addedValue)
167     returns (bool success) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   function decreaseApproval (address _spender, uint _subtractedValue)
174     returns (bool success) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 // File: contracts/MANEToken.sol
188 
189 contract MANEToken is StandardToken {
190 
191   string public name = "ManeCoin";
192   string public symbol = "MANE";
193   uint8 public constant decimals = 18;
194 
195   function MANEToken(address tokenHolder) {
196     totalSupply = 982451653 ether;
197     balances[tokenHolder] = totalSupply;
198   }
199 }