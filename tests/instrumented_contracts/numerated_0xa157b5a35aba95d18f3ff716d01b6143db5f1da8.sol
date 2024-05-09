1 pragma solidity ^0.4.11;
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
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) constant returns (uint256);
36   function transfer(address to, uint256 value) returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) constant returns (uint256);
42   function transferFrom(address from, address to, uint256 value) returns (bool);
43   function approve(address spender, uint256 value) returns (bool);
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
57   function transfer(address _to, uint256 _value) returns (bool) {
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   /**
65   * @dev Gets the balance of the specified address.
66   * @param _owner The address to query the the balance of. 
67   * @return An uint256 representing the amount owned by the passed address.
68   */
69   function balanceOf(address _owner) constant returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73 }
74 
75 contract StandardToken is ERC20, BasicToken {
76 
77   mapping (address => mapping (address => uint256)) allowed;
78 
79 
80   /**
81    * @dev Transfer tokens from one address to another
82    * @param _from address The address which you want to send tokens from
83    * @param _to address The address which you want to transfer to
84    * @param _value uint256 the amout of tokens to be transfered
85    */
86   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
87     var _allowance = allowed[_from][msg.sender];
88 
89     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
90     // require (_value <= _allowance);
91 
92     balances[_to] = balances[_to].add(_value);
93     balances[_from] = balances[_from].sub(_value);
94     allowed[_from][msg.sender] = _allowance.sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   /**
100    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
101    * @param _spender The address which will spend the funds.
102    * @param _value The amount of tokens to be spent.
103    */
104   function approve(address _spender, uint256 _value) returns (bool) {
105 
106     // To change the approve amount you first have to reduce the addresses`
107     //  allowance to zero by calling `approve(_spender, 0)` if it is not
108     //  already 0 to mitigate the race condition described here:
109     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
111 
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifing the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127 }
128 
129 contract CrowdsaleToken is StandardToken {
130  
131   string public constant name = "HolyEthereumCoin";
132   string public constant symbol = "HEC";
133   uint public constant decimals = 3;
134   // replace with your fund collection multisig address 
135   address public constant multisig = 0x04867292A47c5837759dfe13BC70bD30aA01050D; 
136  
137  
138   // 1 ether = 500 example tokens 
139   uint public constant PRICE = 250;
140  
141   function () payable {
142     createTokens(msg.sender);
143   }
144   
145   function createTokens(address recipient) payable {
146     if (msg.value == 0) {
147       throw;
148     }
149  
150     uint tokens = msg.value.mul(getPrice());
151     totalSupply = totalSupply.add(tokens);
152  
153     balances[recipient] = balances[recipient].add(tokens);
154  
155     if (!multisig.send(msg.value)) {
156       throw;
157     }
158   }
159   
160   // replace this with any other price function
161   function getPrice() constant returns (uint result) {
162     return PRICE;
163   }
164 }