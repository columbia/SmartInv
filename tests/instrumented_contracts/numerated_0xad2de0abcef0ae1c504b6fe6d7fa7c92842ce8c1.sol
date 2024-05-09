1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20Basic {
35   function totalSupply() public view returns (uint256);
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender) public view returns (uint256);
43   function transferFrom(address from, address to, uint256 value) public returns (bool);
44   function approve(address spender, uint256 value) public returns (bool);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   /**
60   * @dev total number of tokens in existence
61   */
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 contract StandardToken is ERC20, BasicToken {
94  using SafeMath for uint256;
95  mapping (address => mapping (address => uint256)) internal allowed;
96 
97 
98   /**
99    * @dev Transfer tokens from one address to another
100    * @param _from address The address which you want to send tokens from
101    * @param _to address The address which you want to transfer to
102    * @param _value uint256 the amount of tokens to be transferred
103    */
104   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[_from]);
107     require(_value <= allowed[_from][msg.sender]);
108 
109     balances[_from] = balances[_from].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112     Transfer(_from, _to, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
118    *
119    * Beware that changing an allowance with this method brings the risk that someone may use both the old
120    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
121    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
122    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) public returns (bool) {
127     allowed[msg.sender][_spender] = _value;
128     Approval(msg.sender, _spender, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param _owner address The address which owns the funds.
135    * @param _spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(address _owner, address _spender) public view returns (uint256) {
139     return allowed[_owner][_spender];
140   }
141 
142   /**
143    * @dev Increase the amount of tokens that an owner allowed to a spender.
144    *
145    * approve should be called when allowed[_spender] == 0. To increment
146    * allowed value is better to use this function to avoid 2 calls (and wait until
147    * the first transaction is mined)
148    * From MonolithDAO Token.sol
149    * @param _spender The address which will spend the funds.
150    * @param _addedValue The amount of tokens to increase the allowance by.
151    */
152   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
153     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
154     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155     return true;
156   }
157 
158   /**
159    * @dev Decrease the amount of tokens that an owner allowed to a spender.
160    *
161    * approve should be called when allowed[_spender] == 0. To decrement
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    * @param _spender The address which will spend the funds.
166    * @param _subtractedValue The amount of tokens to decrease the allowance by.
167    */
168   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
169     uint oldValue = allowed[msg.sender][_spender];
170     if (_subtractedValue > oldValue) {
171       allowed[msg.sender][_spender] = 0;
172     } else {
173       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174     }
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179 }
180 
181 contract StopTheFakesPromo is StandardToken {
182     
183     string public constant Token_Description = "StopTheFakes.io: 5% BONUS. This token allows its holder to receive an additional bonus of 5% during the main token sale. More information in our telegram group.";
184     string public constant name = "StopTheFakes Promo";
185     string public constant symbol = "STFPR";
186     uint8 public constant decimals = 18;
187 
188     uint256 public constant INITIAL_SUPPLY = 3000000 ether;
189 
190     function StopTheFakesPromo() public {
191         totalSupply_ = INITIAL_SUPPLY;
192         balances[msg.sender] = INITIAL_SUPPLY;
193         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
194     }
195 
196 }