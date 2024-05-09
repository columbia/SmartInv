1 pragma solidity ^0.4.13;
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
51     require(_value <= balances[msg.sender]);
52 
53     // SafeMath.sub will throw if there is not enough balance.
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59 
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public view returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) internal allowed;
81 
82 
83   /**
84    * @dev Transfer tokens from one address to another
85    * @param _from address The address which you want to send tokens from
86    * @param _to address The address which you want to transfer to
87    * @param _value uint256 the amount of tokens to be transferred
88    */
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   /**
102    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
103    *
104    * Beware that changing an allowance with this method brings the risk that someone may use both the old
105    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
106    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
107    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108    * @param _spender The address which will spend the funds.
109    * @param _value The amount of tokens to be spent.
110    */
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) public view returns (uint256) {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * @dev Increase the amount of tokens that an owner allowed to a spender.
129    *
130    * approve should be called when allowed[_spender] == 0. To increment
131    * allowed value is better to use this function to avoid 2 calls (and wait until
132    * the first transaction is mined)
133    * From MonolithDAO Token.sol
134    * @param _spender The address which will spend the funds.
135    * @param _addedValue The amount of tokens to increase the allowance by.
136    */
137   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143   /**
144    * @dev Decrease the amount of tokens that an owner allowed to a spender.
145    *
146    * approve should be called when allowed[_spender] == 0. To decrement
147    * allowed value is better to use this function to avoid 2 calls (and wait until
148    * the first transaction is mined)
149    * From MonolithDAO Token.sol
150    * @param _spender The address which will spend the funds.
151    * @param _subtractedValue The amount of tokens to decrease the allowance by.
152    */
153   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
154     uint oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue > oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159     }
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164 }
165 
166 contract CryptoHuntToken is StandardToken {
167 
168     string public constant name = "CryptoHunt Token";
169     string public constant symbol = "CH";
170     uint8 public constant decimals = 12;
171     uint public INITIAL_SUPPLY = 500000000000000000000;
172 
173     function CryptoHuntToken() public {
174         totalSupply = INITIAL_SUPPLY;
175         balances[msg.sender] = INITIAL_SUPPLY;
176     }
177 }