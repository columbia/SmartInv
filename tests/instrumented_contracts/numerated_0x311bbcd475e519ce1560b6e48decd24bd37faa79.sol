1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 /**
15  * @title Basic token
16  * @dev Basic version of StandardToken, with no allowances.
17  */
18 contract BasicToken is ERC20Basic {
19   using SafeMath for uint256;
20 
21   mapping(address => uint256) balances;
22 
23   /**
24   * @dev transfer token for a specified address
25   * @param _to The address to transfer to.
26   * @param _value The amount to be transferred.
27   */
28   function transfer(address _to, uint256 _value) public returns (bool) {
29     require(_to != address(0));
30     require(_value <= balances[msg.sender]);
31 
32     // SafeMath.sub will throw if there is not enough balance.
33     balances[msg.sender] = balances[msg.sender].sub(_value);
34     balances[_to] = balances[_to].add(_value);
35     Transfer(msg.sender, _to, _value);
36     return true;
37   }
38 
39   /**
40   * @dev Gets the balance of the specified address.
41   * @param _owner The address to query the the balance of.
42   * @return An uint256 representing the amount owned by the passed address.
43   */
44   function balanceOf(address _owner) public view returns (uint256 balance) {
45     return balances[_owner];
46   }
47 
48 }
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62  * @title Standard ERC20 token
63  *
64  * @dev Implementation of the basic standard token.
65  * @dev Based on code by FirstBlood
66  */
67 contract StandardToken is ERC20, BasicToken {
68 
69   mapping (address => mapping (address => uint256)) internal allowed;
70 
71 
72   /**
73    * @dev Transfer tokens from one address to another
74    * @param _from address The address which you want to send tokens from
75    * @param _to address The address which you want to transfer to
76    * @param _value uint256 the amount of tokens to be transferred
77    */
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   /**
91    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
92    *
93    * Beware that changing an allowance with this method brings the risk that someone may use both the old
94    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
95    * @param _spender The address which will spend the funds.
96    * @param _value The amount of tokens to be spent.
97    */
98   function approve(address _spender, uint256 _value) public returns (bool) {
99     allowed[msg.sender][_spender] = _value;
100     Approval(msg.sender, _spender, _value);
101     return true;
102   }
103 
104   /**
105    * @dev Function to check the amount of tokens that an owner allowed to a spender.
106    * @param _owner address The address which owns the funds.
107    * @param _spender address The address which will spend the funds.
108    * @return A uint256 specifying the amount of tokens still available for the spender.
109    */
110   function allowance(address _owner, address _spender) public view returns (uint256) {
111     return allowed[_owner][_spender];
112   }
113 
114   /**
115    * @dev Increase the amount of tokens that an owner allowed to a spender.
116    *
117    * approve should be called when allowed[_spender] == 0. To increment
118    * allowed value is better to use this function to avoid 2 calls (and wait until
119    * the first transaction is mined)
120    * From MonolithDAO Token.sol
121    * @param _spender The address which will spend the funds.
122    * @param _addedValue The amount of tokens to increase the allowance by.
123    */
124   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
125     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
126     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127     return true;
128   }
129 
130   /**
131    * @dev Decrease the amount of tokens that an owner allowed to a spender.
132    *
133    * approve should be called when allowed[_spender] == 0. To decrement
134    * allowed value is better to use this function to avoid 2 calls (and wait until
135    * the first transaction is mined)
136    * From MonolithDAO Token.sol
137    * @param _spender The address which will spend the funds.
138    * @param _subtractedValue The amount of tokens to decrease the allowance by.
139    */
140   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
141     uint oldValue = allowed[msg.sender][_spender];
142     if (_subtractedValue > oldValue) {
143       allowed[msg.sender][_spender] = 0;
144     } else {
145       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146     }
147     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151 }
152 
153 /**
154  * @title SafeMath
155  * @dev Math operations with safety checks that throw on error
156  */
157 library SafeMath {
158   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159     if (a == 0) {
160       return 0;
161     }
162     uint256 c = a * b;
163     assert(c / a == b);
164     return c;
165   }
166 
167   function div(uint256 a, uint256 b) internal pure returns (uint256) {
168     // assert(b > 0); // Solidity automatically throws when dividing by 0
169     uint256 c = a / b;
170     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171     return c;
172   }
173 
174   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175     assert(b <= a);
176     return a - b;
177   }
178 
179   function add(uint256 a, uint256 b) internal pure returns (uint256) {
180     uint256 c = a + b;
181     assert(c >= a);
182     return c;
183   }
184 }
185 
186 
187 contract LIVEToken is StandardToken {
188     string public name = "LIVE Token";
189     string public symbol = "LVT";
190     uint public decimals = 0;
191 
192     /**
193     * @dev Constructor that gives msg.sender all of existing tokens.
194     */
195     function LIVEToken() public {
196         totalSupply = 5000000000 * (10 ** uint256(decimals)); // 5B tokens total supply
197         balances[msg.sender] = totalSupply;
198     }
199 }