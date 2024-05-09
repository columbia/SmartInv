1 pragma solidity ^0.4.19;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Basic token
28  * @dev Basic version of StandardToken, with no allowances.
29  */
30 contract BasicToken is ERC20Basic {
31   using SafeMath for uint256;
32 
33   mapping(address => uint256) balances;
34 
35   /**
36   * @dev transfer token for a specified address
37   * @param _to The address to transfer to.
38   * @param _value The amount to be transferred.
39   */
40   function transfer(address _to, uint256 _value) public returns (bool) {
41     require(_to != address(0));
42     require(_value <= balances[msg.sender]);
43 
44     // SafeMath.sub will throw if there is not enough balance.
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   /**
52   * @dev Gets the balance of the specified address.
53   * @param _owner The address to query the the balance of.
54   * @return An uint256 representing the amount owned by the passed address.
55   */
56   function balanceOf(address _owner) public view returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 
63 
64 /**
65  * @title Standard ERC20 token
66  *
67  * @dev Implementation of the basic standard token.
68  * @dev https://github.com/ethereum/EIPs/issues/20
69  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
70  */
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) internal allowed;
74 
75 
76   /**
77    * @dev Transfer tokens from one address to another
78    * @param _from address The address which you want to send tokens from
79    * @param _to address The address which you want to transfer to
80    * @param _value uint256 the amount of tokens to be transferred
81    */
82   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[_from]);
85     require(_value <= allowed[_from][msg.sender]);
86 
87     balances[_from] = balances[_from].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90     Transfer(_from, _to, _value);
91     return true;
92   }
93 
94   /**
95    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
96    *
97    * Beware that changing an allowance with this method brings the risk that someone may use both the old
98    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
99    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
100    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101    * @param _spender The address which will spend the funds.
102    * @param _value The amount of tokens to be spent.
103    */
104   function approve(address _spender, uint256 _value) public returns (bool) {
105     allowed[msg.sender][_spender] = _value;
106     Approval(msg.sender, _spender, _value);
107     return true;
108   }
109 
110   /**
111    * @dev Function to check the amount of tokens that an owner allowed to a spender.
112    * @param _owner address The address which owns the funds.
113    * @param _spender address The address which will spend the funds.
114    * @return A uint256 specifying the amount of tokens still available for the spender.
115    */
116   function allowance(address _owner, address _spender) public view returns (uint256) {
117     return allowed[_owner][_spender];
118   }
119 
120   /**
121    * @dev Increase the amount of tokens that an owner allowed to a spender.
122    *
123    * approve should be called when allowed[_spender] == 0. To increment
124    * allowed value is better to use this function to avoid 2 calls (and wait until
125    * the first transaction is mined)
126    * From MonolithDAO Token.sol
127    * @param _spender The address which will spend the funds.
128    * @param _addedValue The amount of tokens to increase the allowance by.
129    */
130   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
131     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
132     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136   /**
137    * @dev Decrease the amount of tokens that an owner allowed to a spender.
138    *
139    * approve should be called when allowed[_spender] == 0. To decrement
140    * allowed value is better to use this function to avoid 2 calls (and wait until
141    * the first transaction is mined)
142    * From MonolithDAO Token.sol
143    * @param _spender The address which will spend the funds.
144    * @param _subtractedValue The amount of tokens to decrease the allowance by.
145    */
146   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
147     uint oldValue = allowed[msg.sender][_spender];
148     if (_subtractedValue > oldValue) {
149       allowed[msg.sender][_spender] = 0;
150     } else {
151       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
152     }
153     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157 }
158 
159 
160 /**
161  * @title SafeMath
162  * @dev Math operations with safety checks that throw on error
163  */
164 library SafeMath {
165   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166     if (a == 0) {
167       return 0;
168     }
169     uint256 c = a * b;
170     assert(c / a == b);
171     return c;
172   }
173 
174   function div(uint256 a, uint256 b) internal pure returns (uint256) {
175     // assert(b > 0); // Solidity automatically throws when dividing by 0
176     uint256 c = a / b;
177     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178     return c;
179   }
180 
181   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182     assert(b <= a);
183     return a - b;
184   }
185 
186   function add(uint256 a, uint256 b) internal pure returns (uint256) {
187     uint256 c = a + b;
188     assert(c >= a);
189     return c;
190   }
191 }
192 
193 
194 
195 /// @title TPKToken - Token code for the TPK Project
196 contract TPKToken is StandardToken {
197 
198     using SafeMath for uint;
199     string public constant name = "Topthinken";
200     string public constant symbol = "TPK";
201     uint public constant decimals = 18;
202 
203     uint constant million=1000000e18;
204     //total token supply: 680million
205     uint constant totalToken = 680*million;
206 
207     //@notice  Constructor of TPKToken
208     function TPKToken() public {
209       totalSupply = totalToken;
210       balances[msg.sender] = totalSupply;
211     }
212 
213 }