1 pragma solidity ^0.4.4;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56   function transfer(address _to, uint256 _value) public returns (bool) {
57     require(_to != address(0));
58     require(_value <= balances[msg.sender]);
59 
60     // SafeMath.sub will throw if there is not enough balance.
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of.
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) public view returns (uint256 balance) {
73     return balances[_owner];
74   }
75 }
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) internal allowed;
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
90     require(_value <= balances[_from]);
91     require(_value <= allowed[_from][msg.sender]);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    *
103    * Beware that changing an allowance with this method brings the risk that someone may use both the old
104    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
105    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
106    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107    * @param _spender The address which will spend the funds.
108    * @param _value The amount of tokens to be spent.
109    */
110   function approve(address _spender, uint256 _value) public returns (bool) {
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
118    * @param _owner address The address which owns the funds.
119    * @param _spender address The address which will spend the funds.
120    * @return A uint256 specifying the amount of tokens still available for the spender.
121    */
122   function allowance(address _owner, address _spender) public view returns (uint256) {
123     return allowed[_owner][_spender];
124   }
125 
126   /**
127    * @dev Increase the amount of tokens that an owner allowed to a spender.
128    *
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    * @param _spender The address which will spend the funds.
134    * @param _addedValue The amount of tokens to increase the allowance by.
135    */
136   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
137     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
138     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142   /**
143    * @dev Decrease the amount of tokens that an owner allowed to a spender.
144    *
145    * approve should be called when allowed[_spender] == 0. To decrement
146    * allowed value is better to use this function to avoid 2 calls (and wait until
147    * the first transaction is mined)
148    * From MonolithDAO Token.sol
149    * @param _spender The address which will spend the funds.
150    * @param _subtractedValue The amount of tokens to decrease the allowance by.
151    */
152   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
153     uint oldValue = allowed[msg.sender][_spender];
154     if (_subtractedValue > oldValue) {
155       allowed[msg.sender][_spender] = 0;
156     } else {
157       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
158     }
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 }
163 
164 contract USCD is StandardToken {
165   string public name = "USCD";
166   string public symbol = "USCD";
167   uint8 public decimals = 8;
168   uint256 public INITIAL_SUPPLY = 10000000 * 10**uint(decimals);
169 
170   function USCD() public{
171     totalSupply = INITIAL_SUPPLY;
172     balances[msg.sender] = INITIAL_SUPPLY;
173   }
174 }