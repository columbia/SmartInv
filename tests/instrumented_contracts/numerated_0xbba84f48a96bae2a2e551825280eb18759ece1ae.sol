1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-25
3 */
4 
5 pragma solidity ^0.4.20;
6 
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) balances;
60 
61   uint256 totalSupply_;
62 
63   /**
64   * @dev total number of tokens in existence
65   */
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public view returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[_from]);
118     require(_value <= allowed[_from][msg.sender]);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * @dev Increase the amount of tokens that an owner allowed to a spender.
155    *
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    * @param _spender The address which will spend the funds.
161    * @param _addedValue The amount of tokens to increase the allowance by.
162    */
163   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   /**
170    * @dev Decrease the amount of tokens that an owner allowed to a spender.
171    *
172    * approve should be called when allowed[_spender] == 0. To decrement
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    * @param _spender The address which will spend the funds.
177    * @param _subtractedValue The amount of tokens to decrease the allowance by.
178    */
179   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
180     uint oldValue = allowed[msg.sender][_spender];
181     if (_subtractedValue > oldValue) {
182       allowed[msg.sender][_spender] = 0;
183     } else {
184       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185     }
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190 }
191 
192 contract SWCToken is StandardToken {
193   string public name    = "SWC Token";
194   string public symbol  = "SWC";
195   uint8 public decimals = 18;
196 
197   // 0.3 billion in initial supply
198   uint256 public constant INITIAL_SUPPLY = 300000000;
199 
200   function SWCToken() public {
201     totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
202     balances[msg.sender] = totalSupply_;
203   }
204 }