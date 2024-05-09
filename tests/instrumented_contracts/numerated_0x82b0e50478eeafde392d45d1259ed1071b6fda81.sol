1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) constant returns (uint256);
36   function transfer(address to, uint256 value);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) constant returns (uint256);
42   function transferFrom(address from, address to, uint256 value);
43   function approve(address spender, uint256 value);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   /**
53   * @dev transfer token for a specified address
54   * @param _to The address to transfer to.
55   * @param _value The amount to be transferred.
56   */
57   function transfer(address _to, uint256 _value) {
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61   }
62 
63   /**
64   * @dev Gets the balance of the specified address.
65   * @param _owner The address to query the the balance of.
66   * @return An uint256 representing the amount owned by the passed address.
67   */
68   function balanceOf(address _owner) constant returns (uint256 balance) {
69     return balances[_owner];
70   }
71 
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) allowed;
77 
78 
79   /**
80    * @dev Transfer tokens from one address to another
81    * @param _from address The address which you want to send tokens from
82    * @param _to address The address which you want to transfer to
83    * @param _value uint256 the amout of tokens to be transfered
84    */
85   function transferFrom(address _from, address _to, uint256 _value) {
86     var _allowance = allowed[_from][msg.sender];
87 
88     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
89     // if (_value > _allowance) throw;
90 
91     balances[_to] = balances[_to].add(_value);
92     balances[_from] = balances[_from].sub(_value);
93     allowed[_from][msg.sender] = _allowance.sub(_value);
94     Transfer(_from, _to, _value);
95   }
96 
97   /**
98    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
99    * @param _spender The address which will spend the funds.
100    * @param _value The amount of tokens to be spent.
101    */
102   function approve(address _spender, uint256 _value) {
103 
104     // To change the approve amount you first have to reduce the addresses`
105     //  allowance to zero by calling `approve(_spender, 0)` if it is not
106     //  already 0 to mitigate the race condition described here:
107     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
109 
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112   }
113 
114   /**
115    * @dev Function to check the amount of tokens that an owner allowed to a spender.
116    * @param _owner address The address which owns the funds.
117    * @param _spender address The address which will spend the funds.
118    * @return A uint256 specifing the amount of tokens still avaible for the spender.
119    */
120   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }
123 
124 }
125 
126 
127 contract DNAToken is StandardToken {
128 
129   string public name = "DNA Token";
130   string public symbol = "DNA";
131   uint256 public decimals = 18;
132   uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
133 
134   /**
135    * @dev Contructor that gives msg.sender all of existing tokens.
136    */
137   function DNAToken() {
138     totalSupply = INITIAL_SUPPLY;
139     balances[msg.sender] = INITIAL_SUPPLY;
140   }
141 
142 }