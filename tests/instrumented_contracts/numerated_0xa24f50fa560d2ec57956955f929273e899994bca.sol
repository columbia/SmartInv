1 pragma solidity ^0.4.16;
2 
3 /**
4  * Welcome to the Telegram chat http://www.devsolidity.io/
5  */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11  
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal constant returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract Token {
39     uint256 public totalSupply;
40     function balanceOf(address who) public constant returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     function allowance(address owner, address spender) public constant returns (uint256);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) onlyOwner {
81     require(newOwner != address(0));      
82     owner = newOwner;
83   }
84 
85 }
86 
87 contract StandardToken is Token, Ownable {
88     using SafeMath for uint256;
89     mapping (address => mapping (address => uint256)) internal allowed;
90 
91   mapping(address => uint256) balances;
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public constant returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
170     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 contract XZEN is StandardToken {
189     using SafeMath for uint256;
190 
191     string public constant name = "XZEN PreToken";
192     string public constant symbol = "XZNP";
193     uint256 public constant decimals = 18;
194     uint256 public constant tokenCreationCapPreICO =  55000000*10**decimals;
195     address public multiSigWallet = 0x51cf183cbe4e4c80297c49ff5017770fdd95c06d;
196     address public teamWallet = 0x2BeB722Dc6E80D0C61e63240ca44B8a6D538e3Ae;
197 
198     // 1 ETH = 300 , 1 token = 0.01 USD Date: 13.11.2017
199     uint public oneTokenInWei = 31847133757962;
200     uint startDate = 1510592400;
201 
202     function XZEN() {
203         owner = teamWallet;
204         balances[teamWallet] = 55000000*10**decimals;
205         totalSupply = totalSupply.add(balances[teamWallet]);
206         Transfer(0x0, teamWallet, balances[teamWallet]);
207     }
208 
209     function () payable {
210         createTokens();
211     }
212 
213     function createTokens() internal  {
214         uint multiplier = 10 ** decimals;
215         uint256 tokens = (msg.value.mul(multiplier) / oneTokenInWei);
216         // First day bonus 5%
217         if(now <= startDate + 1 days) {
218             tokens += tokens / 100 * 5;  
219         }
220         if (balances[teamWallet] < tokens) revert();
221         balances[teamWallet] -= tokens;        
222         balances[msg.sender] += tokens;
223         
224         // send eth to multiSigWallet
225         multiSigWallet.transfer(msg.value);
226         Transfer(teamWallet, msg.sender, tokens);
227     }
228 
229     function setEthPrice(uint _tokenPrice) external onlyOwner {
230         oneTokenInWei = _tokenPrice;
231     }
232     
233     function replaceMultisig(address newMultisig) external onlyOwner {
234         multiSigWallet = newMultisig;
235     }
236 
237 }