1 pragma solidity ^0.4.13;
2 
3 
4 //Math operations with safety checks that throw on error
5 library SafeMath {
6 // multiplication
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 //division
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 //subtraction
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 //addition
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public constant returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   /**
45   * @dev transfer token for a specified address
46   * @param _to The address to transfer to.
47   * @param _value The amount to be transferred.
48   */
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51 
52     // SafeMath.sub will throw if there is not enough balance.
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   /**
60   * @dev Gets the balance of the specified address.
61   * @param _owner The address to query the the balance of.
62   * @return An uint256 representing the amount owned by the passed address.
63   */
64   function balanceOf(address _owner) public constant returns (uint256 balance) {
65     return balances[_owner];
66   }
67 
68 }
69 
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) public constant returns (uint256);
72   function transferFrom(address from, address to, uint256 value) public returns (bool);
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) allowed;
80 
81 
82   /**
83    * @dev Transfer tokens from one address to another
84    * @param _from address The address which you want to send tokens from
85    * @param _to address The address which you want to transfer to
86    * @param _value uint256 the amount of tokens to be transferred
87    */
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90 
91     uint256 _allowance = allowed[_from][msg.sender];
92 
93     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
94     // require (_value <= _allowance);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = _allowance.sub(_value);
99     Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   /**
104    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
105    *
106    * Beware that changing an allowance with this method brings the risk that someone may use both the old
107    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
108    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
109    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110    * @param _spender The address which will spend the funds.
111    * @param _value The amount of tokens to be spent.
112    */
113   function approve(address _spender, uint256 _value) public returns (bool) {
114     allowed[msg.sender][_spender] = _value;
115     Approval(msg.sender, _spender, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Function to check the amount of tokens that an owner allowed to a spender.
121    * @param _owner address The address which owns the funds.
122    * @param _spender address The address which will spend the funds.
123    * @return A uint256 specifying the amount of tokens still available for the spender.
124    */
125   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
126     return allowed[_owner][_spender];
127   }
128 
129   /**
130    * approve should be called when allowed[_spender] == 0. To increment
131    * allowed value is better to use this function to avoid 2 calls (and wait until
132    * the first transaction is mined)
133    * From MonolithDAO Token.sol
134    */
135   function increaseApproval (address _spender, uint _addedValue)
136     returns (bool success) {
137     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
138     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142   function decreaseApproval (address _spender, uint _subtractedValue)
143     returns (bool success) {
144     uint oldValue = allowed[msg.sender][_spender];
145     if (_subtractedValue > oldValue) {
146       allowed[msg.sender][_spender] = 0;
147     } else {
148       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149     }
150     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151     return true;
152   }
153 
154 }
155 //the main DXBCToken contract
156 contract KKCToken is StandardToken {
157   string public constant name = "kakachain";
158   string public constant symbol = "kakac";
159   uint8 public constant decimals = 18;
160 
161   uint256 public constant total=  500000000* (10 ** uint256(decimals));
162 
163   function  KKCToken(address wallet) {
164     balances[wallet] = total;
165     totalSupply = total;
166   }
167 
168 }