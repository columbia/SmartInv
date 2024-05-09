1 pragma solidity 0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) returns (bool);
23   function approve(address spender, uint256 value) returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title Basic token
30  * @dev Basic version of StandardToken, with no allowances. 
31  */
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34 
35   mapping(address => uint256) balances;
36 
37   /**
38   * @dev transfer token for a specified address
39   * @param _to The address to transfer to.
40   * @param _value The amount to be transferred.
41   */
42   function transfer(address _to, uint256 _value) returns (bool) {
43     balances[msg.sender] = balances[msg.sender].sub(_value);
44     balances[_to] = balances[_to].add(_value);
45     Transfer(msg.sender, _to, _value);
46     return true;
47   }
48 
49   /**
50   * @dev Gets the balance of the specified address.
51   * @param _owner The address to query the the balance of. 
52   * @return An uint256 representing the amount owned by the passed address.
53   */
54   function balanceOf(address _owner) constant returns (uint256 balance) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() {
75     owner = msg.sender;
76   }
77 
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address newOwner) onlyOwner {
93     if (newOwner != address(0)) {
94       owner = newOwner;
95     }
96   }
97 
98 }
99 
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that throw on error
103  */
104 library SafeMath {
105   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
106     uint256 c = a * b;
107     assert(a == 0 || c / a == b);
108     return c;
109   }
110 
111   function div(uint256 a, uint256 b) internal constant returns (uint256) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     uint256 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return c;
116   }
117 
118   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
119     assert(b <= a);
120     return a - b;
121   }
122 
123   function add(uint256 a, uint256 b) internal constant returns (uint256) {
124     uint256 c = a + b;
125     assert(c >= a);
126     return c;
127   }
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
149     var _allowance = allowed[_from][msg.sender];
150 
151     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
152     // require (_value <= _allowance);
153 
154     balances[_to] = balances[_to].add(_value);
155     balances[_from] = balances[_from].sub(_value);
156     allowed[_from][msg.sender] = _allowance.sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) returns (bool) {
167 
168     // To change the approve amount you first have to reduce the addresses`
169     //  allowance to zero by calling `approve(_spender, 0)` if it is not
170     //  already 0 to mitigate the race condition described here:
171     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
173 
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifing the amount of tokens still avaible for the spender.
184    */
185   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
186     return allowed[_owner][_spender];
187   }
188 
189 }
190 
191 contract EtherGold is StandardToken, Ownable
192 {
193     string public name = "ETHER GOLD";
194     string public symbol = "EG9";
195 
196     uint public decimals = 8;
197 
198     uint private INITIAL_SUPPLY = 18 * 10**16;    //  1 800 000 000 or 1.8 Billions
199     
200     function EtherGold()
201     {
202         owner = msg.sender;
203         totalSupply = INITIAL_SUPPLY;
204         balances[owner] = INITIAL_SUPPLY;
205     }
206 }