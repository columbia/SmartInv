1 pragma solidity ^0.4.13;
2 
3 /*import 'zeppelin-solidity/contracts/token/StandardToken.sol';*/
4 
5 /*import '../math/SafeMath.sol';*/
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 /*import './ERC20Basic.sol';*/
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) constant returns (uint256);
36   function transfer(address to, uint256 value) returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 /*import './BasicToken.sol';*/
41 contract BasicToken is ERC20Basic {
42   using SafeMath for uint256;
43 
44   mapping(address => uint256) balances;
45 
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) returns (bool) {
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   /**
59   * @dev Gets the balance of the specified address.
60   * @param _owner The address to query the the balance of.
61   * @return An uint256 representing the amount owned by the passed address.
62   */
63   function balanceOf(address _owner) constant returns (uint256 balance) {
64     return balances[_owner];
65   }
66 
67 }
68 
69 /*import './ERC20.sol';*/
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) constant returns (uint256);
72   function transferFrom(address from, address to, uint256 value) returns (bool);
73   function approve(address spender, uint256 value) returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract StandardToken is ERC20, BasicToken {
78   mapping (address => mapping (address => uint256)) allowed;
79 
80 
81   /**
82    * @dev Transfer tokens from one address to another
83    * @param _from address The address which you want to send tokens from
84    * @param _to address The address which you want to transfer to
85    * @param _value uint256 the amout of tokens to be transfered
86    */
87   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
88     var _allowance = allowed[_from][msg.sender];
89 
90     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
91     // require (_value <= _allowance);
92 
93     balances[_to] = balances[_to].add(_value);
94     balances[_from] = balances[_from].sub(_value);
95     allowed[_from][msg.sender] = _allowance.sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    * @param _spender The address which will spend the funds.
103    * @param _value The amount of tokens to be spent.
104    */
105   function approve(address _spender, uint256 _value) returns (bool) {
106 
107     // To change the approve amount you first have to reduce the addresses`
108     //  allowance to zero by calling `approve(_spender, 0)` if it is not
109     //  already 0 to mitigate the race condition described here:
110     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
112 
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifing the amount of tokens still avaible for the spender.
123    */
124   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
125     return allowed[_owner][_spender];
126   }
127 
128 }
129 
130 
131 /*import './MultiOwnable.sol';*/
132 contract MultiOwnable {
133     mapping (address => bool) owners;
134 
135     function MultiOwnable() {
136         // Add the sender of the contract as the initial owner
137         owners[msg.sender] = true;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owners[msg.sender]);
145         _;
146     }
147 
148     /**
149      * @dev Adds an owner
150      */
151     function addOwner(address newOwner) onlyOwner {
152         // #0 is an invalid address
153         require(newOwner != address(0));
154 
155         owners[newOwner] = true;
156     }
157 
158     /**
159      * @dev Removes an owner
160      */
161     function removeOwner(address ownerToRemove) onlyOwner {
162         owners[ownerToRemove] = false;
163     }
164 
165     /**
166      * @dev Checks if address is an owner
167      */
168     function isOwner(address possibleOwner) onlyOwner returns (bool) {
169         return owners[possibleOwner];
170     }
171 }
172 
173 contract MintableToken is StandardToken, MultiOwnable {
174     // Emitted when new coin is brought into the world
175     event Mint(address indexed to, uint256 amount);
176 
177     /**
178     * @dev Function to mint tokens
179     * @param _to The address that will receive the minted tokens.
180     * @param _amount The amount of tokens to mint.
181     * @return A boolean that indicates if the operation was successful.
182     */
183     function mint(address _to, uint256 _amount) onlyOwner returns (bool) {
184         totalSupply = totalSupply.add(_amount);
185         balances[_to] = balances[_to].add(_amount);
186 
187         Mint(_to, _amount);
188         Transfer(0x0, _to, _amount);
189 
190         return true;
191     }
192 }
193 
194 contract MingoToken is MintableToken {
195     string public constant name = "Mingo Token";
196     string public constant symbol = "MGT";
197     uint8 public constant decimals = 0;
198 }