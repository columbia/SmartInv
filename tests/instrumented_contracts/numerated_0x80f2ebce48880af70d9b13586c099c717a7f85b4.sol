1 library SafeMath {
2   function mul(uint256 a, uint256 b) constant public returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) constant public returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) constant public returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) constant public returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     if(msg.sender == owner){
45       _;
46     }
47     else{
48       revert();
49     }
50   }
51 
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) onlyOwner public{
58     if (newOwner != address(0)) {
59       owner = newOwner;
60     }
61   }
62 
63 }
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) constant public returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) constant public returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances. 
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) balances;
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of. 
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) constant public returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amout of tokens to be transfered
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     var _allowance = allowed[_from][msg.sender];
124 
125     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
126     // require (_value <= _allowance);
127 
128     balances[_to] = balances[_to].add(_value);
129     balances[_from] = balances[_from].sub(_value);
130     allowed[_from][msg.sender] = _allowance.sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141 
142     // To change the approve amount you first have to reduce the addresses`
143     //  allowance to zero by calling `approve(_spender, 0)` if it is not
144     //  already 0 to mitigate the race condition described here:
145     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147 
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifing the amount of tokens still avaible for the spender.
158    */
159   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163 }
164 
165 
166 contract MintableToken is StandardToken, Ownable {
167   event Mint(address indexed to, uint256 amount);
168   event MintFinished();
169 
170   bool public mintingFinished = false;
171 
172 
173   modifier canMint() {
174     if(!mintingFinished){
175       _;
176     }
177     else{
178       revert();
179     }
180   }
181 
182   /**
183    * @dev Function to mint tokens
184    * @param _to The address that will recieve the minted tokens.
185    * @param _amount The amount of tokens to mint.
186    * @return A boolean that indicates if the operation was successful.
187    */
188   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
189     totalSupply = totalSupply.add(_amount);
190     balances[_to] = balances[_to].add(_amount);
191     Mint(_to, _amount);
192     return true;
193   }
194 
195   /**
196    * @dev Function to stop minting new tokens.
197    * @return True if the operation was successful.
198    */
199   function finishMinting() onlyOwner public returns (bool) {
200     mintingFinished = true;
201     MintFinished();
202     return true;
203   }
204 }
205 
206 contract CoinI{
207     
208     uint256 public totalSupply ;
209 }
210 contract IcoI{
211     
212     function getAllTimes() public constant returns(uint256,uint256,uint256);
213     function getCabCoinsAmount()  public constant returns(uint256);
214     uint256 public minimumGoal; 
215 }
216 
217 contract CABCoin is MintableToken{
218     
219 	
220 	string public constant name = "CabCoin";
221 	string public constant symbol = "CAB";
222 	uint8 public constant decimals = 18;
223 	
224 	uint256 public constant TEAM_SHARE_PERCENTAGE = 16;
225 
226   uint256 public constant maxTokenSupply = (10**18)*(10**9) ; 
227   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
228       
229   	if(totalSupply.add(_amount)<maxTokenSupply){
230   	    
231   	  bool status = super.mint(_to,_amount);
232   	  Transfer(address(0), _to, _amount);
233   	  return status;
234   	}
235   	else{
236   		return false; 
237   	}
238   	
239   	return true;
240   }
241   
242   function getMaxTokenAvaliable() constant public  returns(uint256) {
243   	return (maxTokenSupply.sub(totalSupply)).mul(100-TEAM_SHARE_PERCENTAGE).div(100);
244   }
245 }