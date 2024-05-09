1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 /**
45  * @title ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/20
47  */
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) constant returns (uint256);
50   function transferFrom(address from, address to, uint256 value) returns (bool);
51   function approve(address spender, uint256 value) returns (bool);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances. 
58  */
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63 
64   /**
65   * @dev transfer token for a specified address
66   * @param _to The address to transfer to.
67   * @param _value The amount to be transferred.
68   */
69   function transfer(address _to, uint256 _value) returns (bool) {
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     Transfer(msg.sender, _to, _value);
73     return true;
74   }
75 
76   /**
77   * @dev Gets the balance of the specified address.
78   * @param _owner The address to query the the balance of. 
79   * @return An uint256 representing the amount owned by the passed address.
80   */
81   function balanceOf(address _owner) constant returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 /**
88  * @title Standard ERC20 token
89  *
90  * @dev Implementation of the basic standard token.
91  * @dev https://github.com/ethereum/EIPs/issues/20
92  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
93  */
94 contract StandardToken is ERC20, BasicToken {
95 
96   mapping (address => mapping (address => uint256)) allowed;
97 
98 
99   /**
100    * @dev Transfer tokens from one address to another
101    * @param _from address The address which you want to send tokens from
102    * @param _to address The address which you want to transfer to
103    * @param _value uint256 the amout of tokens to be transfered
104    */
105   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
106     var _allowance = allowed[_from][msg.sender];
107 
108     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
109     // require (_value <= _allowance);
110 
111     balances[_to] = balances[_to].add(_value);
112     balances[_from] = balances[_from].sub(_value);
113     allowed[_from][msg.sender] = _allowance.sub(_value);
114     Transfer(_from, _to, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
120    * @param _spender The address which will spend the funds.
121    * @param _value The amount of tokens to be spent.
122    */
123   function approve(address _spender, uint256 _value) returns (bool) {
124 
125     // To change the approve amount you first have to reduce the addresses`
126     //  allowance to zero by calling `approve(_spender, 0)` if it is not
127     //  already 0 to mitigate the race condition described here:
128     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
130 
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param _owner address The address which owns the funds.
139    * @param _spender address The address which will spend the funds.
140    * @return A uint256 specifing the amount of tokens still avaible for the spender.
141    */
142   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
143     return allowed[_owner][_spender];
144   }
145 
146 }
147 
148 /**
149  * @title ApprovedTokenDone
150  * Created specifically for TokenDone.io
151  */
152 contract ApprovedTokenDone is StandardToken {
153 	string public name = '2020';
154 	string public symbol = '2020';
155 	uint public decimals = 3;
156 	uint public initialSupply = 100000000000;
157 	string public publisher = 'TokenDone.io';
158 	uint public CreationTime;
159 	
160 	function ApprovedTokenDone() {
161 		totalSupply = initialSupply;
162     	balances[0xe90fFFd34aEcFE44db61a6efD85663296094A09c] = initialSupply;
163 		CreationTime = now;
164 	}
165 }