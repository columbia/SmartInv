1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public constant returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 library SafeERC20 {
48   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
49     assert(token.transfer(to, value));
50   }
51 
52   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
53     assert(token.transferFrom(from, to, value));
54   }
55 
56   function safeApprove(ERC20 token, address spender, uint256 value) internal {
57     assert(token.approve(spender, value));
58   }
59 }
60 
61 library SafeMath {
62   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
63     uint256 c = a * b;
64     assert(a == 0 || c / a == b);
65     return c;
66   }
67 
68   function div(uint256 a, uint256 b) internal constant returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   function add(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public constant returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 contract ERC20WithDecimals is ERC20 {
95   function decimals() public returns (uint8);
96 }
97 
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110 
111     // SafeMath.sub will throw if there is not enough balance.
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public constant returns (uint256 balance) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142 
143     uint256 _allowance = allowed[_from][msg.sender];
144 
145     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
146     // require (_value <= _allowance);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = _allowance.sub(_value);
151     Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
178     return allowed[_owner][_spender];
179   }
180 
181   /**
182    * approve should be called when allowed[_spender] == 0. To increment
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    */
187   function increaseApproval (address _spender, uint _addedValue)
188     returns (bool success) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   function decreaseApproval (address _spender, uint _subtractedValue)
195     returns (bool success) {
196     uint oldValue = allowed[msg.sender][_spender];
197     if (_subtractedValue > oldValue) {
198       allowed[msg.sender][_spender] = 0;
199     } else {
200       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201     }
202     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206 }
207 
208 contract PenisBlack is StandardToken, Ownable {
209   using SafeERC20 for ERC20WithDecimals;
210   string public constant name = "PenisBlack";
211   string public constant symbol = "PNB";
212   uint8 public constant decimals = 2;
213   uint public constant maxTotalSupply = 0xbeeeeeeeeeeeeef;
214   /*
215    * Upgrade your tokens to the new, Penis Token, Black Edition.
216    * Trade in your old, weak tokens, for something bigger and more satisfying.
217    *
218    * As part of our built-in token giveaway, you can trade in any existing
219    * tokens, at an exchange rate of one PNB per token. It's the same price
220    * for any token
221    */
222   function tradeIn(address smellyOldToken, uint amount) public returns (bool) {
223     // Prior to calling this, you'll need to call approve(thisAddress, value)
224     // on the old token
225     ERC20WithDecimals oldToken = ERC20WithDecimals(smellyOldToken);
226     oldToken.safeTransferFrom(msg.sender, owner, amount);
227 
228     uint pnbCount = amount * (uint(10) ** decimals) / (uint(10) ** oldToken.decimals());
229 
230     require(totalSupply.add(pnbCount) < maxTotalSupply);
231     totalSupply = totalSupply.add(pnbCount);
232     balances[msg.sender] = balances[msg.sender].add(pnbCount);
233     Transfer(0x0, msg.sender, pnbCount);
234     return true;
235   }
236 }