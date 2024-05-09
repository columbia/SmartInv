1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances. 
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) returns (bool) {
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71   /**
72   * @dev Gets the balance of the specified address.
73   * @param _owner The address to query the the balance of. 
74   * @return An uint256 representing the amount owned by the passed address.
75   */
76   function balanceOf(address _owner) constant returns (uint256 balance) {
77     return balances[_owner];
78   }
79 
80 }
81 
82 
83 
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) returns (bool);
92   function approve(address spender, uint256 value) returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) allowed;
109 
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amout of tokens to be transfered
116    */
117   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
118     var _allowance = allowed[_from][msg.sender];
119 
120     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
121     // require (_value <= _allowance);
122 
123     balances[_to] = balances[_to].add(_value);
124     balances[_from] = balances[_from].sub(_value);
125     allowed[_from][msg.sender] = _allowance.sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) returns (bool) {
136 
137     // To change the approve amount you first have to reduce the addresses`
138     //  allowance to zero by calling `approve(_spender, 0)` if it is not
139     //  already 0 to mitigate the race condition described here:
140     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
142 
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifing the amount of tokens still avaible for the spender.
153    */
154   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 
161 /**
162  * @title Tulips
163  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
164  * Note they can later distribute these tokens as they wish using `transfer` and other
165  * `StandardToken` functions.
166  */
167 contract Tulips is StandardToken {
168 
169   string public name = "Tulip Bulbs";
170   string public symbol = "TULIP";
171   uint256 public decimals = 8;
172 
173   // 
174   uint256 public INITIAL_SUPPLY = 10*1000*1000*100000000;
175 
176   /**
177    * @dev Contructor that gives msg.sender all of existing tokens. 
178    */
179   function Tulips() {
180     totalSupply = INITIAL_SUPPLY;
181     balances[msg.sender] = INITIAL_SUPPLY;
182   }
183 }