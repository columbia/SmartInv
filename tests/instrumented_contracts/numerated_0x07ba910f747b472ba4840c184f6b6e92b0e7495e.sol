1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) constant returns (uint256);
37   function transfer(address to, uint256 value);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39   event Burn(address indexed from, uint256 value);
40 }
41 
42 
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) constant returns (uint256);
45   function transferFrom(address from, address to, uint256 value);
46   function approve(address spender, uint256 value);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) {
62       
63     require ( balances[msg.sender] >= _value);           // Check if the sender has enough
64     require (balances[_to] + _value >= balances[_to]);   // Check for overflows
65 
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69   }
70   
71   // burn tokens from sender balance
72   function burn(uint256 _value) {
73       
74     require ( balances[msg.sender] >= _value);           // Check if the sender has enough
75 
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     Burn(msg.sender, _value);
78   }
79   
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 
93 contract StandardToken is ERC20, BasicToken {
94 
95   mapping (address => mapping (address => uint256)) allowed;
96 
97 
98   /**
99    * @dev Transfer tokens from one address to another
100    * @param _from address The address which you want to send tokens from
101    * @param _to address The address which you want to transfer to
102    * @param _value uint256 the amout of tokens to be transfered
103    */
104   function transferFrom(address _from, address _to, uint256 _value) {
105     var _allowance = allowed[_from][msg.sender];
106 
107     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
108     // if (_value > _allowance) throw;
109 
110     balances[_to] = balances[_to].add(_value);
111     balances[_from] = balances[_from].sub(_value);
112     allowed[_from][msg.sender] = _allowance.sub(_value);
113     Transfer(_from, _to, _value);
114   }
115 
116   /**
117    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
118    * @param _spender The address which will spend the funds.
119    * @param _value The amount of tokens to be spent.
120    */
121   function approve(address _spender, uint256 _value) {
122 
123     // To change the approve amount you first have to reduce the addresses`
124     //  allowance to zero by calling `approve(_spender, 0)` if it is not
125     //  already 0 to mitigate the race condition described here:
126     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127     require((_value == 0) && (allowed[msg.sender][_spender] == 0)) ;
128 
129     allowed[msg.sender][_spender] = _value;
130     Approval(msg.sender, _spender, _value);
131   }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifing the amount of tokens still avaible for the spender.
138    */
139   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
140     return allowed[_owner][_spender];
141   }
142 
143 }
144 
145 contract Ownable {
146   address public owner;
147 
148 
149   /**
150    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
151    * account.
152    */
153   function Ownable() {
154     owner = msg.sender;
155   }
156 
157 
158   /**
159    * @dev Throws if called by any account other than the owner.
160    */
161   modifier onlyOwner() {
162     require(msg.sender == owner) ;
163     
164     _;
165   }
166 
167 
168   /**
169    * @dev Allows the current owner to transfer control of the contract to a newOwner.
170    * @param newOwner The address to transfer ownership to.
171    */
172   function transferOwnership(address newOwner) onlyOwner {
173     if (newOwner != address(0)) {
174       owner = newOwner;
175     }
176   }
177 
178 }
179 
180 contract MintableToken is StandardToken, Ownable {
181   event Mint(address indexed to, uint256 amount);
182   event MintFinished();
183   string public name = "Crystal Clear Token";
184   string public symbol = "CCT";
185   uint256 public decimals = 18;
186 
187   bool public mintingFinished = false;
188 
189 
190   modifier canMint() {
191     require(!mintingFinished) ;
192     _;
193   }
194 
195   function MintableToken(){
196     mint(msg.sender,10000000000000000000000000);
197     finishMinting();
198   }
199     
200   /**
201    * @dev Function to mint tokens
202    * @param _to The address that will recieve the minted tokens.
203    * @param _amount The amount of tokens to mint.
204    * @return A boolean that indicates if the operation was successful.
205    */
206   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
207     totalSupply = totalSupply.add(_amount);
208     balances[_to] = balances[_to].add(_amount);
209     Mint(_to, _amount);
210     return true;
211   }
212   
213 
214   /**
215    * @dev Function to stop minting new tokens.
216    * @return True if the operation was successful.
217    */
218   function finishMinting() onlyOwner returns (bool) {
219     mintingFinished = true;
220     MintFinished();
221     return true;
222   }
223 }