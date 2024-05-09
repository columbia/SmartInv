1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   /**
5    * SafeMath mul function
6    * @dev function for safe multiply
7    **/
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   
14   /**
15    * SafeMath div function
16    **/
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21   
22   /**
23    * SafeMath sub function
24    **/
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29   
30   /**
31    * SafeMath add function 
32    **/
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simple version of ERC20 interface
43  * @notice https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public constant returns (uint256);
48   function transfer(address to, uint256 value) public  returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 /**
53  * @title BasicToken
54  * @dev Basic version of Token, with no allowances.
55  */
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58   mapping(address => uint256) balances;
59 
60   /**
61    * BasicToken transfer function
62    * @dev transfer token for a specified address
63    * @param _to address to transfer to.
64    * @param _value amount to be transferred.
65    */
66   function transfer(address _to, uint256 _value) public returns (bool) {
67     //Safemath functions will throw if value is invalid
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     emit Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75    * BasicToken balanceOf function 
76    * @dev Gets the balance of the specified address.
77    * @param _owner address to get balance of.
78    * @return uint256 amount owned by the address.
79    */
80   function balanceOf(address _owner) public constant returns (uint256 bal) {
81     return balances[_owner];
82   }
83 }
84 
85 /**
86  *  @title ERC20 interface
87  *  @notice https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @title Token
98  * @dev Token to meet the ERC20 standard
99  * @notice https://github.com/ethereum/EIPs/issues/20
100  */
101 contract Token is ERC20, BasicToken {
102   mapping (address => mapping (address => uint256)) allowed;
103   
104   /**
105    * Token transferFrom function
106    * @dev Transfer tokens from one address to another
107    * @param _from address to send tokens from
108    * @param _to address to transfer to
109    * @param _value amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     uint256 _allowance = allowed[_from][msg.sender];
113     // Safe math functions will throw if value invalid
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     emit Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * Token approve function
123    * @dev Approve address to spend amount of tokens
124    * @param _spender address to spend the funds.
125    * @param _value amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128     // To change the approve amount you first have to reduce the addresses`
129     // allowance to zero by calling `approve(_spender, 0)` if it is not
130     // already 0 to mitigate the race condition described here:
131     // @notice https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     emit Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * Token allowance method
141    * @dev Check that owners tokens is allowed to send to spender
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 }
150 
151 /**
152  * @title IDEC Token
153  * @dev ERC20 Token with standard token functions.
154  */
155 contract IDECToken is Token {
156   string public constant NAME = "IDEC Token";
157   string public constant SYMBOL = "IDEC";
158   uint256 public constant DECIMALS = 2;
159 
160   uint256 public constant INITIAL_SUPPLY = 500000000 * 10**2;
161 
162   /**
163    * IDEC Token Constructor
164    * @dev Create and issue tokens to msg.sender.
165    */
166   constructor() public {
167     totalSupply = INITIAL_SUPPLY;
168     balances[msg.sender] = INITIAL_SUPPLY;
169   }
170 }