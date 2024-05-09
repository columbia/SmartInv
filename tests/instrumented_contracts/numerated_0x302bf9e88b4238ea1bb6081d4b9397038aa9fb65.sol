1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5     //  function assert(bool assertion) internal { 
6     //   if (!assertion) { 
7     //      throw; 
8     //   } 
9     //  }      // assert no longer needed once solidity is on 0.4.10 */
10     
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34   
35   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a >= b ? a : b;
37   }
38 
39   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
40     return a < b ? a : b;
41   }
42 
43   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a >= b ? a : b;
45   }
46 
47   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
48     return a < b ? a : b;
49   }
50 }
51 
52 contract ERC20Basic {
53   uint256 public totalSupply;
54   function balanceOf(address who) constant returns (uint256);
55   function transfer(address to, uint256 value) returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) constant returns (uint256);
61   function transferFrom(address from, address to, uint256 value) returns (bool);
62   function approve(address spender, uint256 value) returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) returns (bool) {
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of. 
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 
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
140    * @return A uint256 specifing the amount of tokens still available for the spender.
141    */
142   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
143     return allowed[_owner][_spender];
144   }
145 
146 }
147 
148 contract SmileToken is StandardToken {
149 
150   string public name = "SMILECOIN";
151   string public symbol = "SMILECOIN";
152   uint256 public decimals = 3;
153   uint256 public INITIAL_SUPPLY = 10001;
154 
155   /**
156    * @dev Contructor that gives msg.sender all of existing tokens. 
157    */
158   function SmileToken() {
159     totalSupply = INITIAL_SUPPLY;
160     balances[msg.sender] = INITIAL_SUPPLY;
161   }
162 
163 }