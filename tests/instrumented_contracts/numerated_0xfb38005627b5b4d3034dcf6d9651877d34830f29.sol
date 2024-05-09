1 pragma solidity 0.4.18;
2 /*
3 Author:     www.inncretech.com
4 Email:      aasim AT inncretech.com  vishal AT inncretech.com
5 
6 GLXCoin  Token public sale contract
7 For details, please visit: https://ico.glx.com/
8 
9 */
10 // Math contract to avoid overflow and underflow of variables
11 contract SafeMath {
12 
13     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
14       uint256 z = x + y;
15       assert((z >= x) && (z >= y));
16       return z;
17     }
18 
19     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
20       assert(x >= y);
21       uint256 z = x - y;
22       return z;
23     }
24 
25     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
26       uint256 z = x * y;
27       assert((x == 0)||(z/x == y));
28       return z;
29     }
30 
31 }
32 // Abstracct of ERC20 Token
33 contract Token {
34     uint256 public totalSupply;
35     function balanceOf(address _owner) constant returns (uint256 balance);
36     function transfer(address _to, uint256 _value) returns (bool success);
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
38     function approve(address _spender, uint256 _value) returns (bool success);
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 
45 /*  Implementation of ERC20 token standard functions */
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49       if (balances[msg.sender] >= _value && _value > 0) {
50         balances[msg.sender] -= _value;
51         balances[_to] += _value;
52         Transfer(msg.sender, _to, _value);
53         return true;
54       } else {
55         return false;
56       }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
61         balances[_to] += _value;
62         balances[_from] -= _value;
63         allowed[_from][msg.sender] -= _value;
64         Transfer(_from, _to, _value);
65         return true;
66       } else {
67         return false;
68       }
69     }
70 
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82       return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87 }
88 
89 contract Ownable {
90   address public owner;
91 
92 /**
93 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94 * account.
95 */
96 function Ownable() {
97   owner = msg.sender;
98 }
99 /**
100 * @dev Throws if called by any account other than the owner.
101 */
102 modifier onlyOwner() {
103   require(msg.sender == owner);
104 _;
105 }
106 /**
107 * @dev Allows the current owner to transfer control of the contract to a newOwner.
108 * @param newOwner The address to transfer ownership to.
109 */
110 function transferOwnership(address newOwner) onlyOwner {
111   if (newOwner != address(0)) {
112       owner = newOwner;
113   }
114 }
115 
116 }
117 
118 
119 contract GLXToken is StandardToken,Ownable, SafeMath {
120 
121     // crowdsale parameters
122     string  public constant name = "GLXCoin";
123     string  public constant symbol = "GLXC";
124     uint256 public constant decimals = 18;
125     string  public version = "1.0";
126     address public constant ethFundDeposit= 0xeE9b66740EcF1a3e583e61B66C5b8563882b5d12;                         // Deposit address for ETH
127     bool public emergencyFlag;                                      //  Switched to true in  crownsale end  state
128     uint256 public fundingStartBlock;                              //   Starting blocknumber
129     uint256 public fundingEndBlock;                               //    Ending blocknumber
130     uint256 public constant minTokenPurchaseAmount= .008 ether;  //     Minimum purchase
131     uint256 public constant tokenPreSaleRate=875;    // GLXCoin per 1 ETH during presale
132     uint256 public constant tokenCrowdsaleRate=700; //  GLXCoin per 1 ETH during crowdsale
133     uint256 public constant tokenCreationPreSaleCap =  10 * (10**6) * 10**decimals;// 10 million token cap for presale
134     uint256 public constant tokenCreationCap =  50 * (10**6) * 10**decimals;      //  50 million token generated
135     uint256 public constant preSaleBlockNumber = 169457;
136     uint256 public finalBlockNumber =360711;
137 
138 
139     // events
140     event CreateGLX(address indexed _to, uint256 _value);// Return address of buyer and purchase token
141     event Mint(address indexed _to,uint256 _value);     //  Reutn address to which we send the mint token and token assigned.
142     // Constructor
143     function GLXToken(){
144       emergencyFlag = false;                             // False at initialization will be false during ICO
145       fundingStartBlock = block.number;                 //  Current deploying block number is the starting block number for ICO
146       fundingEndBlock=safeAdd(fundingStartBlock,finalBlockNumber);  //   Ending time depending upon the block number
147     }
148 
149     /**
150     * @dev creates new GLX tokens
151     *      It is a internal function it will be called by fallback function or buyToken functions.
152     */
153     function createTokens() internal  {
154       if (emergencyFlag) revert();                     //  Revert when the sale is over before time and emergencyFlag is true.
155       if (block.number > fundingEndBlock) revert();   //   If the blocknumber exceed the ending block it will revert
156       if (msg.value<minTokenPurchaseAmount)revert();  //    If someone send 0.08 ether it will fail
157       uint256 tokenExchangeRate=tokenRate();        //     It will get value depending upon block number and presale cap
158       uint256 tokens = safeMult(msg.value, tokenExchangeRate);//  Calculating number of token for sender
159       totalSupply = safeAdd(totalSupply, tokens);            //   Add token to total supply
160       if(totalSupply>tokenCreationCap)revert();             //    Check the total supply if it is more then hardcap it will throw
161       balances[msg.sender] += tokens;                      //     Adding token to sender account
162       CreateGLX(msg.sender, tokens);                      //      Logs sender address and  token creation
163     }
164 
165     /**
166     * @dev people can access contract and choose buyToken function to get token
167     *It is used by using myetherwallet
168     *It is a payable function it will be called by sender.
169     */
170     function buyToken() payable external{
171       createTokens();   // This will call the internal createToken function to get token
172     }
173 
174     /**
175     * @dev      it is a internal function called by create function to get the amount according to the blocknumber.
176     * @return   It will return the token price at a particular time.
177     */
178     function tokenRate() internal returns (uint256 _tokenPrice){
179       // It is a presale it will return price for presale
180       if(block.number<safeAdd(fundingStartBlock,preSaleBlockNumber)&&(totalSupply<tokenCreationPreSaleCap)){
181           return tokenPreSaleRate;
182         }else
183             return tokenCrowdsaleRate;
184     }
185 
186     /**
187     * @dev     it will  assign token to a particular address by owner only
188     * @param   _to the address whom you want to send token to
189     * @param   _amount the amount you want to send
190     * @return  It will return true if success.
191     */
192     function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
193       if (emergencyFlag) revert();
194       totalSupply = safeAdd(totalSupply,_amount);// Add the minted token to total suppy
195       if(totalSupply>tokenCreationCap)revert();
196       balances[_to] +=_amount;                 //   Adding token to the input address
197       Mint(_to, _amount);                     //    Log the mint with address and token given to particular address
198       return true;
199     }
200 
201     /**
202     * @dev     it will change the ending date of ico and access by owner only
203     * @param   _newBlock enter the future blocknumber
204     * @return  It will return the blocknumber
205     */
206     function changeEndBlock(uint256 _newBlock) external onlyOwner returns (uint256 _endblock )
207     {   // we are expecting that owner will input number greater than current block.
208         require(_newBlock > fundingStartBlock);
209         fundingEndBlock = _newBlock;         // New block is assigned to extend the Crowd Sale time
210         return fundingEndBlock;
211     }
212 
213     /**
214     * @dev   it will let Owner withdrawn ether at any time during the ICO
215     **/
216     function drain() external onlyOwner {
217         if (!ethFundDeposit.send(this.balance)) revert();// It will revert if transfer fails.
218     }
219 
220     /**
221     * @dev  it will let Owner Stop the crowdsale and mint function to work.
222     *
223     */
224     function emergencyToggle() external onlyOwner{
225       emergencyFlag = !emergencyFlag;
226     }
227 
228     // Fallback function let user send ether without calling the buy function.
229     function() payable {
230       createTokens();
231 
232     }
233 
234 
235 }