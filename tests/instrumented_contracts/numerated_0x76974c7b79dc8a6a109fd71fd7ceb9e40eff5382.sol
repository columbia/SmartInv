1 pragma solidity ^0.4.18;
2 
3 interface IERC20 {
4   function balanceOf(address who) view public returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7   function allowance(address owner, address spender) view public returns (uint256);
8   function transferFrom(address from, address to, uint256 value) public returns (bool);
9   function approve(address spender, uint256 value) public returns (bool);
10   event Approval(address indexed owner, address indexed spender, uint256 value); 
11 }
12 
13 
14 contract BasicToken is IERC20 {
15   using SafeMath for uint256;
16   mapping(address => uint256) balances;
17   mapping (address => mapping (address => uint256)) allowed;
18 
19  /**
20   * @dev Gets the balance of the specified address.
21   * @param _owner The address to query the the balance of.
22   * @return An uint256 representing the amount owned by the passed address.
23   */
24   function balanceOf(address _owner) public view returns (uint256 balance) {
25     return balances[_owner];
26   }
27 
28   /**
29    * @dev Function to check the amount of tokens that an owner allowed to a spender.
30    * @param _owner address The address which owns the funds.
31    * @param _spender address The address which will spend the funds.
32    * @return A uint256 specifying the amount of tokens still available for the spender.
33    */
34   function allowance(address _owner, address _spender) public view returns (uint256) {
35     return allowed[_owner][_spender];
36   }
37 
38   /**
39   * @dev transfer token for a specified address
40   * @param _to The address to transfer to.
41   * @param _value The amount to be transferred.
42   */
43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_to != address(0));
45     require(_value <= balances[msg.sender]);
46 
47     // SafeMath.sub will throw if there is not enough balance.
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   /**
55    * @dev Transfer tokens from one address to another
56    * @param _from address The address which you want to send tokens from
57    * @param _to address The address which you want to transfer to
58    * @param _value uint256 the amount of tokens to be transferred
59    */
60   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[_from]);
63     require(_value <= allowed[_from][msg.sender]);
64 
65     balances[_from] = balances[_from].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
68     Transfer(_from, _to, _value);
69     return true;
70   }
71 
72   /**
73    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
74    *
75    * Beware that changing an allowance with this method brings the risk that someone may use both the old
76    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
77    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
78    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79    * @param _spender The address which will spend the funds.
80    * @param _value The amount of tokens to be spent.
81    */
82   function approve(address _spender, uint256 _value) public returns (bool) {
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88   /**
89    * @dev Increase the amount of tokens that an owner allowed to a spender.
90    *
91    * approve should be called when allowed[_spender] == 0. To increment
92    * allowed value is better to use this function to avoid 2 calls (and wait until
93    * the first transaction is mined)
94    * From MonolithDAO Token.sol
95    * @param _spender The address which will spend the funds.
96    * @param _addedValue The amount of tokens to increase the allowance by.
97    */
98   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101     return true;
102   }
103 
104   /**
105    * @dev Decrease the amount of tokens that an owner allowed to a spender.
106    *
107    * approve should be called when allowed[_spender] == 0. To decrement
108    * allowed value is better to use this function to avoid 2 calls (and wait until
109    * the first transaction is mined)
110    * From MonolithDAO Token.sol
111    * @param _spender The address which will spend the funds.
112    * @param _subtractedValue The amount of tokens to decrease the allowance by.
113    */
114   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
115     uint oldValue = allowed[msg.sender][_spender];
116     if (_subtractedValue > oldValue) {
117       allowed[msg.sender][_spender] = 0;
118     } else {
119       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
120     }
121     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122     return true;
123   }
124 
125 }
126 
127 /**
128  * @title SafeMath
129  * @dev Math operations with safety checks that throw on error
130  */
131 library SafeMath {
132   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a * b;
134     assert(a == 0 || c / a == b);
135     return c;
136   }
137 
138   function div(uint256 a, uint256 b) internal pure returns (uint256) {
139     // assert(b > 0); // Solidity automatically throws when dividing by 0
140     uint256 c = a / b;
141     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142     return c;
143   }
144 
145   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146     assert(b <= a);
147     return a - b;
148   }
149 
150   function add(uint256 a, uint256 b) internal pure returns (uint256) {
151     uint256 c = a + b;
152     assert(c >= a);
153     return c;
154   }
155 }
156 
157 contract DOWToken is BasicToken {
158 
159 using SafeMath for uint256;
160 
161 string public name = "DOW";                                   // Name of the token
162 string public symbol = "dow";                                 // Symbol of the token
163 uint8 public decimals = 18;                                   // Decimals
164 uint256 public constant totalSupply = 2000000000 * 10**18;    // Total number of tokens generated
165 address public founderMultiSigAddress;                        // Multi sign address of founder 
166 
167 // Notifications
168 event ChangeFoundersWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
169   
170 /**
171  * @dev Intialize the variabes
172  * @param _founderAddress Ethereum Address of the founder
173  */
174 function DOWToken (address _founderAddress) public {
175   require(_founderAddress != address(0));
176   founderMultiSigAddress = _founderAddress;
177   balances[founderMultiSigAddress] = totalSupply;
178   Transfer(address(0), founderMultiSigAddress, totalSupply);
179 }
180 
181 /**
182  * @dev `changeFounderMultiSigAddress` is used to change the founder's address
183  * @param _newFounderMultiSigAddress New ethereum address of the founder 
184  */   
185 function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) public {
186   require(_newFounderMultiSigAddress != address(0));
187   require(msg.sender == founderMultiSigAddress);
188   founderMultiSigAddress = _newFounderMultiSigAddress;
189   ChangeFoundersWalletAddress(now, founderMultiSigAddress);
190 }
191 
192 }