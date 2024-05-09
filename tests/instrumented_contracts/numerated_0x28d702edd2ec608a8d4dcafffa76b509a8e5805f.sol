1 /*
2 This file is XaronToken Contract
3 */
4 
5 pragma solidity ^0.5.1;
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a * b;
38     assert(a == 0 || c / a == b);
39     return a * b;
40   }
41 
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a / b;
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65 
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
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
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) allowed;
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 The amout of tokens to be transfered
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     uint256 _allowance = allowed[_from][msg.sender];
112 
113     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
114     // require (_value <= _allowance);
115 
116     balances[_to] = balances[_to].add(_value);
117     balances[_from] = balances[_from].sub(_value);
118     allowed[_from][msg.sender] = _allowance.sub(_value);
119     emit Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128   function approve(address _spender, uint256 _value) public returns (bool) {
129 
130     // To change the approve amount you first have to reduce the addresses`
131     // allowance to zero by calling `approve(_spender, 0)` if it is not
132     // already 0 to mitigate the race condition described here:
133     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
135 
136     allowed[msg.sender][_spender] = _value;
137     emit Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifing the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
148     return allowed[_owner][_spender];
149   }
150 
151 }
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159 
160   address public owner;
161 
162   /**
163    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
164    * account.
165    */
166   constructor () public {
167     owner = msg.sender;
168   }
169 
170   /**
171    * @dev Throws if called by any account other than the owner.
172    */
173   modifier onlyOwner() {
174     require(msg.sender == owner);
175     _;
176   }
177 
178   /**
179    * @dev Allows the current owner to transfer control of the contract to a newOwner.
180    * @param newOwner The address to transfer ownership to.
181    */
182   function transferOwnership(address newOwner) public onlyOwner {
183     require(newOwner != address(0));
184     owner = newOwner;
185   }
186 
187 }
188 
189 /**
190  * @title Mintable token
191  * @dev Simple ERC20 Token example, with mintable token creation
192  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
193  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
194  */
195 contract MintableToken is StandardToken, Ownable {
196 
197   event MintFinished();
198 
199   bool public mintingFinished = false;
200 
201   modifier canMint() {
202     require(!mintingFinished);
203     _;
204   }
205 
206   /**
207    * @dev Function to mint tokens
208    * @param _to The address that will recieve the minted tokens.
209    * @param _amount The amount of tokens to mint.
210    * @return A boolean that indicates if the operation was successful.
211    */
212   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
213     totalSupply = totalSupply.add(_amount);
214     balances[_to] = balances[_to].add(_amount);
215     emit Transfer(address(0), _to, _amount);
216     return true;
217   }
218 
219   /**
220    * @dev Function to stop minting new tokens.
221    * @return A boolean that indicates if the operation was successful.
222    */
223   function finishMinting() public onlyOwner returns (bool) {
224     mintingFinished = true;
225     emit MintFinished();
226     return true;
227   }
228 
229 }
230 
231 contract XaronToken is MintableToken {
232 
233     string public constant name = "Xaron";
234 
235     string public constant symbol = "XARON";
236 
237     uint32 public constant decimals = 8;
238 
239 }