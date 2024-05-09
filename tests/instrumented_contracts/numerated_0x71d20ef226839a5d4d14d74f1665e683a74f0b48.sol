1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
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
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract ERC20Token {
54   using SafeMath for uint256;
55 
56   event Transfer(address indexed from, address indexed to, uint256 value);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 
59   mapping(address => uint256) internal balances_;
60   mapping (address => mapping (address => uint256)) internal allowed_;
61 
62   uint256 internal totalSupply_;
63   string public name;
64   string public symbol;
65   uint8 public decimals;
66 
67   function ERC20Token(
68     string tokenName,
69     string tokenSymbol,
70     uint8 tokenDecimals,
71     uint256 tokenSupply,
72     address initAddress,
73     uint256 initBalance
74   ) public {
75     name = tokenName;
76     symbol = tokenSymbol;
77     decimals = tokenDecimals;
78     totalSupply_ = tokenSupply * 10 ** uint256(decimals);
79     if (initBalance > 0) {
80         uint256 ib = initBalance * 10 ** uint256(decimals);
81         require(ib <= totalSupply_);
82         balances_[initAddress] = ib;
83         if (ib < totalSupply_) {
84             balances_[msg.sender] = totalSupply_.sub(ib);
85         }
86     } else {
87         balances_[msg.sender] = totalSupply_;
88     }
89   }
90 
91   /**
92   * @dev total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances_[_owner];
105   }
106 
107   /**
108    * @dev Function to check the amount of tokens that an owner allowed_ to a spender.
109    * @param _owner address The address which owns the funds.
110    * @param _spender address The address which will spend the funds.
111    * @return A uint256 specifying the amount of tokens still available for the spender.
112    */
113   function allowance(address _owner, address _spender) public view returns (uint256) {
114     return allowed_[_owner][_spender];
115   }
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances_[msg.sender]);
125 
126     balances_[msg.sender] = balances_[msg.sender].sub(_value);
127     balances_[_to] = balances_[_to].add(_value);
128     emit Transfer(msg.sender, _to, _value);
129     return true;
130   }
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances_[_from]);
142     require(_value <= allowed_[_from][msg.sender]);
143 
144     balances_[_from] = balances_[_from].sub(_value);
145     balances_[_to] = balances_[_to].add(_value);
146     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
147     emit Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed_[msg.sender][_spender] = _value;
163     emit Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 }