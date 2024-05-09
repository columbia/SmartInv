1 pragma solidity ^0.4.18;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**
17   * @dev Integer division of two numbers, truncating the quotient.
18   */
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     // uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return a / b;
24   }
25 
26   /**
27   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 contract ERC20Basic {
45   function totalSupply() public view returns (uint256);
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) public view returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   uint256 totalSupply_;
64 
65   /**
66   * @dev total number of tokens in existence
67   */
68   function totalSupply() public view returns (uint256) {
69     return totalSupply_;
70   }
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79     require(_value <= balances[msg.sender]);
80 
81     // SafeMath.sub will throw if there is not enough balance.
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     emit Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of.
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) public view returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }
98 /**
99  * @title Standard ERC20 token
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     emit Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) public returns (bool) {
130     allowed[msg.sender][_spender] = _value;
131     emit Approval(msg.sender, _spender, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Function to check the amount of tokens that an owner allowed to a spender.
137    * @param _owner address The address which owns the funds.
138    * @param _spender address The address which will spend the funds.
139    * @return A uint256 specifying the amount of tokens still available for the spender.
140    */
141   function allowance(address _owner, address _spender) public view returns (uint256) {
142     return allowed[_owner][_spender];
143   }
144 
145   /**
146    * @dev Increase the amount of tokens that an owner allowed to a spender.
147    *
148    * approve should be called when allowed[_spender] == 0. To increment
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * @param _spender The address which will spend the funds.
152    * @param _addedValue The amount of tokens to increase the allowance by.
153    */
154   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   /**
161    * @dev Decrease the amount of tokens that an owner allowed to a spender.
162    *
163    * approve should be called when allowed[_spender] == 0. To decrement
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * @param _spender The address which will spend the funds.
167    * @param _subtractedValue The amount of tokens to decrease the allowance by.
168    */
169   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
170     uint oldValue = allowed[msg.sender][_spender];
171     if (_subtractedValue > oldValue) {
172       allowed[msg.sender][_spender] = 0;
173     } else {
174       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175     }
176     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180 }
181 
182 // VDGToken
183 contract VDGToken is StandardToken {
184   string public name = "VeriDocGlobal";
185   string public symbol = "VDG";
186   uint public decimals = 0;
187   uint public INITIAL_SUPPLY = 50000000000;
188 
189   function VDGToken() public {
190     totalSupply_ = INITIAL_SUPPLY;
191     balances[msg.sender] = INITIAL_SUPPLY;
192   }
193 }