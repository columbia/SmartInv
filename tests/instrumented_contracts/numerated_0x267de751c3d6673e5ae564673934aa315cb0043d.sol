1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) public returns (bool) {
21     require(_to != address(0));
22     require(_value <= balances[msg.sender]);
23 
24     // SafeMath.sub will throw if there is not enough balance.
25     balances[msg.sender] = balances[msg.sender].sub(_value);
26     balances[_to] = balances[_to].add(_value);
27     Transfer(msg.sender, _to, _value);
28     return true;
29   }
30 
31   /**
32   * @dev Gets the balance of the specified address.
33   * @param _owner The address to query the the balance of.
34   * @return An uint256 representing the amount owned by the passed address.
35   */
36   function balanceOf(address _owner) public view returns (uint256 balance) {
37     return balances[_owner];
38   }
39 
40 }
41 
42 contract ERC20 is ERC20Basic {
43   function allowance(address owner, address spender) public view returns (uint256);
44   function transferFrom(address from, address to, uint256 value) public returns (bool);
45   function approve(address spender, uint256 value) public returns (bool);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 library SafeMath {
87   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88     if (a == 0) {
89       return 0;
90     }
91     uint256 c = a * b;
92     assert(c / a == b);
93     return c;
94   }
95 
96   function div(uint256 a, uint256 b) internal pure returns (uint256) {
97     // assert(b > 0); // Solidity automatically throws when dividing by 0
98     uint256 c = a / b;
99     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100     return c;
101   }
102 
103   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104     assert(b <= a);
105     return a - b;
106   }
107 
108   function add(uint256 a, uint256 b) internal pure returns (uint256) {
109     uint256 c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130 
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) public view returns (uint256) {
161     return allowed[_owner][_spender];
162   }
163 
164   /**
165    * @dev Increase the amount of tokens that an owner allowed to a spender.
166    *
167    * approve should be called when allowed[_spender] == 0. To increment
168    * allowed value is better to use this function to avoid 2 calls (and wait until
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    * @param _spender The address which will spend the funds.
172    * @param _addedValue The amount of tokens to increase the allowance by.
173    */
174   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
175     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   /**
181    * @dev Decrease the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To decrement
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _subtractedValue The amount of tokens to decrease the allowance by.
189    */
190   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
191     uint oldValue = allowed[msg.sender][_spender];
192     if (_subtractedValue > oldValue) {
193       allowed[msg.sender][_spender] = 0;
194     } else {
195       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196     }
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201 }
202 
203 contract MintableToken is StandardToken, Ownable {
204   event Mint(address indexed to, uint256 amount);
205   event MintFinished();
206 
207   bool public mintingFinished = false;
208 
209 
210   modifier canMint() {
211     require(!mintingFinished);
212     _;
213   }
214 
215   /**
216    * @dev Function to mint tokens
217    * @param _to The address that will receive the minted tokens.
218    * @param _amount The amount of tokens to mint.
219    * @return A boolean that indicates if the operation was successful.
220    */
221   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
222     totalSupply = totalSupply.add(_amount);
223     balances[_to] = balances[_to].add(_amount);
224     Mint(_to, _amount);
225     Transfer(address(0), _to, _amount);
226     return true;
227   }
228 
229   /**
230    * @dev Function to stop minting new tokens.
231    * @return True if the operation was successful.
232    */
233   function finishMinting() onlyOwner canMint public returns (bool) {
234     mintingFinished = true;
235     MintFinished();
236     return true;
237   }
238 }
239 
240 contract LANCToken is MintableToken {
241 
242   string public name = "LanceChain Token";
243   string public symbol = "LANC";
244   uint public decimals = 18;
245   
246 }