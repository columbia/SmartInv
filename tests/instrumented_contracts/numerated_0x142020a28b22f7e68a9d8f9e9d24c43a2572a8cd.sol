1 pragma solidity ^0.4.18;
2 /*
3 Author:     www.purplethrone.com
4 Email:      aziz@purplethrone.com
5 
6 
7 */
8 // Math contract to avoid overflow and underflow of variables
9 contract SafeMath {
10 
11     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
12       uint256 z = x + y;
13       assert((z >= x) && (z >= y));
14       return z;
15     }
16 
17     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
18       assert(x >= y);
19       uint256 z = x - y;
20       return z;
21     }
22 
23     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
24       uint256 z = x * y;
25       assert((x == 0)||(z/x == y));
26       return z;
27     }
28 
29 }
30 // Abstracct of ERC20 Token
31 contract Token {
32     uint256 public totalSupply;
33     function balanceOf(address _owner) constant returns (uint256 balance);
34     function transfer(address _to, uint256 _value) returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
36     function approve(address _spender, uint256 _value) returns (bool success);
37     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 
43 /*  Implementation of ERC20 token standard functions */
44 contract StandardToken is Token {
45 
46     function transfer(address _to, uint256 _value) returns (bool success) {
47       if (balances[msg.sender] >= _value && _value > 0) {
48         balances[msg.sender] -= _value;
49         balances[_to] += _value;
50         Transfer(msg.sender, _to, _value);
51         return true;
52       } else {
53         return false;
54       }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59         balances[_to] += _value;
60         balances[_from] -= _value;
61         allowed[_from][msg.sender] -= _value;
62         Transfer(_from, _to, _value);
63         return true;
64       } else {
65         return false;
66       }
67     }
68 
69     function balanceOf(address _owner) constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
80       return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85 }
86 
87 contract Ownable {
88   address public owner;
89 
90 /**
91 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92 * account.
93 */
94 function Ownable() {
95   owner = msg.sender;
96 }
97 /**
98 * @dev Throws if called by any account other than the owner.
99 */
100 modifier onlyOwner() {
101   require(msg.sender == owner);
102 _;
103 }
104 /**
105 * @dev Allows the current owner to transfer control of the contract to a newOwner.
106 * @param newOwner The address to transfer ownership to.
107 */
108 function transferOwnership(address newOwner) onlyOwner {
109   if (newOwner != address(0)) {
110       owner = newOwner;
111   }
112 }
113 
114 }
115 
116 
117 contract PPCToken is StandardToken,Ownable, SafeMath {
118 
119     // crowdsale parameters
120     string  public constant name = "PPCCoin";
121     string  public constant symbol = "PPC";
122     uint256 public constant decimals = 18;
123     string  public version = "1.0";
124     address public constant ethFundDeposit= 0x20D9053d3f7fccC069c9a8e7dDEf5374CD22b6C8;                         // Deposit address for ETH
125     bool public emergencyFlag;                                      //  Switched to true in  crownsale end  state
126     uint256 public fundingStartBlock;                              //   Starting blocknumber
127     uint256 public fundingEndBlock;                               //    Ending blocknumber
128     uint256 public constant minTokenPurchaseAmount= .008 ether;  //     Minimum purchase
129     uint256 public constant tokenPreSaleRate=800;    // PPCCoin per 1 ETH during presale
130     uint256 public constant tokenCrowdsaleRate=500; //  PPCCoin per 1 ETH during crowdsale
131     uint256 public constant tokenCreationPreSaleCap =  10 * (10**6) * 10**decimals;// 10 million token cap for presale
132     uint256 public constant tokenCreationCap =  100 * (10**6) * 10**decimals;      //  100 million token generated
133     uint256 public constant preSaleBlockNumber = 169457;
134     uint256 public finalBlockNumber =370711;
135 
136 
137     // events
138     event CreatePPC(address indexed _to, uint256 _value);// Return address of buyer and purchase token
139     event Mint(address indexed _to,uint256 _value);     //  Reutn address to which we send the mint token and token assigned.
140     // Constructor
141     function PPCToken(){
142       emergencyFlag = false;                             // False at initialization will be false during ICO
143       fundingStartBlock = block.number;                 //  Current deploying block number is the starting block number for ICO
144       fundingEndBlock=safeAdd(fundingStartBlock,finalBlockNumber);  //   Ending time depending upon the block number
145     }
146 
147     /**
148     * @dev creates new PPC tokens
149     *      It is a internal function it will be called by fallback function or buyToken functions.
150     */
151     function createTokens() internal  {
152       if (emergencyFlag) revert();                     //  Revert when the sale is over before time and emergencyFlag is true.
153       if (block.number > fundingEndBlock) revert();   //   If the blocknumber exceed the ending block it will revert
154       if (msg.value<minTokenPurchaseAmount)revert();  //    If someone send 0.08 ether it will fail
155       uint256 tokenExchangeRate=tokenRate();        //     It will get value depending upon block number and presale cap
156       uint256 tokens = safeMult(msg.value, tokenExchangeRate);//  Calculating number of token for sender
157       totalSupply = safeAdd(totalSupply, tokens);            //   Add token to total supply
158       if(totalSupply>tokenCreationCap)revert();             //    Check the total supply if it is more then hardcap it will throw
159       balances[msg.sender] += tokens;                      //     Adding token to sender account
160       forwardfunds();                                     //      forwardfunds to the owner
161       CreatePPC(msg.sender, tokens);                      //      Logs sender address and  token creation
162     }
163 
164     /**
165     * @dev people can access contract and choose buyToken function to get token
166     *It is used by using myetherwallet
167     *It is a payable function it will be called by sender.
168     */
169     function buyToken() payable external{
170       createTokens();   // This will call the internal createToken function to get token
171     }
172 
173     /**
174     * @dev      it is a internal function called by create function to get the amount according to the blocknumber.
175     * @return   It will return the token price at a particular time.
176     */
177     function tokenRate() internal returns (uint256 _tokenPrice){
178       // It is a presale it will return price for presale
179       if(block.number<safeAdd(fundingStartBlock,preSaleBlockNumber)&&(totalSupply<tokenCreationPreSaleCap)){
180           return tokenPreSaleRate;
181         }else
182             return tokenCrowdsaleRate;
183     }
184 
185     /**
186     * @dev     it will  assign token to a particular address by owner only
187     * @param   _to the address whom you want to send token to
188     * @param   _amount the amount you want to send
189     * @return  It will return true if success.
190     */
191     function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
192       if (emergencyFlag) revert();
193       totalSupply = safeAdd(totalSupply,_amount);// Add the minted token to total suppy
194       if(totalSupply>tokenCreationCap)revert();
195       balances[_to] +=_amount;                 //   Adding token to the input address
196       Mint(_to, _amount);                     //    Log the mint with address and token given to particular address
197       return true;
198     }
199 
200     /**
201     * @dev     it will change the ending date of ico and access by owner only
202     * @param   _newBlock enter the future blocknumber
203     * @return  It will return the blocknumber
204     */
205     function changeEndBlock(uint256 _newBlock) external onlyOwner returns (uint256 _endblock )
206     {   // we are expecting that owner will input number greater than current block.
207         require(_newBlock > fundingStartBlock);
208         fundingEndBlock = _newBlock;         // New block is assigned to extend the Crowd Sale time
209         return fundingEndBlock;
210     }
211 
212     /**
213     * @dev   it will let Owner withdrawn ether at any time during the ICO
214     **/
215     function drain() external onlyOwner {
216         if (!ethFundDeposit.send(this.balance)) revert();// It will revert if transfer fails.
217     }
218 
219     
220     
221     // Automate the ETH drain
222     
223     function forwardfunds() internal {
224          if (!ethFundDeposit.send(this.balance)) revert(); // It will revert if transfer fails.
225         
226         
227     }
228     
229     /**
230     * @dev  it will let Owner Stop the crowdsale and mint function to work.
231     *
232     */
233     
234     function emergencyToggle() external onlyOwner{
235       emergencyFlag = !emergencyFlag;
236     }
237 
238     // Fallback function let user send ether without calling the buy function.
239     function() payable {
240       createTokens();
241 
242     }
243 
244 
245 }