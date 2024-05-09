1 pragma solidity 0.5.3;
2 // ----------------------------------------------------------------------------
3 // 'MICA' contract
4 //
5 // Deployed to :0x7f1637fAcaCe03069D3cf1C29015a353B89243f8
6 // Symbol      : MICA
7 // Name        : MICATOKEN
8 // Total supply: 65,000,000,000
9 // Decimals    : 18
10 //
11 
12 // ----------------------------------------------------------------------------
13    
14     /**
15      * @title SafeMath
16      * @dev Math operations with safety checks that throw on error
17      */
18     library SafeMath {
19       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21           return 0;
22         }
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26       }
27     
28       function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33       }
34     
35       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38       }
39     
40       function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44       }
45     }
46     
47     contract owned {
48         address payable public owner;
49     	using SafeMath for uint256;
50     	
51         constructor() public {
52             owner = msg.sender;
53         }
54     
55         modifier onlyOwner {
56             require(msg.sender == owner);
57             _;
58         }
59     
60         function transferOwnership(address payable newOwner) onlyOwner public {
61             owner = newOwner;
62         }
63     }
64     
65     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external ; }
66     
67     contract TokenERC20 {
68         // Public variables of the token
69         using SafeMath for uint256;
70     	string public name = "MICATOKEN";
71         string public symbol = "MICA";
72         uint8 public decimals = 18;         // 18 decimals is the strongly suggested default, avoid changing it
73         uint256 public totalSupply          = 65000000000 * (1 ether);   
74         uint256 public tokensForCrowdsale   = 50000000000 * (1 ether);
75         uint256 public tokensForTeam        = 5000000000  * (1 ether);
76         uint256 public tokensForOwner       = 10000000000  * (1 ether);
77         
78 		address public teamWallet = 0x7f1637fAcaCe03069D3cf1C29015a353B89243f8;
79     
80         // This creates an array with all balances
81         mapping (address => uint256) public balanceOf;
82         mapping (address => mapping (address => uint256)) public allowance;
83     
84         // This generates a public event on the blockchain that will notify clients
85         event Transfer(address indexed from, address indexed to, uint256 value);
86     
87         // This notifies clients about the amount burnt
88         event Burn(address indexed from, uint256 value);
89     
90         /**
91          * Constrctor function
92          *
93          * Initializes contract with initial supply tokens to the creator of the contract
94          */
95         constructor() public {
96 			 
97             balanceOf[address(this)] = tokensForCrowdsale;          // 50 Billion will remain in contract for crowdsale
98             balanceOf[teamWallet] = tokensForTeam;         // 5 Billion will be allocated to Team
99             balanceOf[msg.sender] = tokensForOwner;        // 10 Billon will be sent to contract owner
100 
101             //emiiting events for loggin purpose
102             emit Transfer(address(0), address(this), tokensForCrowdsale);
103             emit Transfer(address(0), teamWallet, tokensForTeam);
104             emit Transfer(address(0), address(msg.sender), tokensForOwner);
105         }
106     
107         /**
108          * Internal transfer, only can be called by this contract
109          */
110         function _transfer(address _from, address _to, uint _value) internal {
111             // Prevent transfer to 0x0 address. Use burn() instead
112             require(_to != address(0x0));
113             // Check if the sender has enough
114             require(balanceOf[_from] >= _value);
115             // Check for overflows
116             require(balanceOf[_to].add(_value) > balanceOf[_to]);
117             // Save this for an assertion in the future
118             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
119             // Subtract from the sender
120             balanceOf[_from] = balanceOf[_from].sub(_value);
121             // Add the same to the recipient
122             balanceOf[_to] = balanceOf[_to].add(_value);
123             emit Transfer(_from, _to, _value);
124             // Asserts are used to use static analysis to find bugs in your code. They should never fail
125             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
126         }
127     
128         /**
129          * Transfer tokens
130          *
131          * Send `_value` tokens to `_to` from your account
132          *
133          * @param _to The address of the recipient
134          * @param _value the amount to send
135          */
136         function transfer(address _to, uint256 _value) public {
137             _transfer(msg.sender, _to, _value);
138         }
139     
140         /**
141          * Transfer tokens from other address
142          *
143          * Send `_value` tokens to `_to` in behalf of `_from`
144          *
145          * @param _from The address of the sender
146          * @param _to The address of the recipient
147          * @param _value the amount to send
148          */
149         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
150             require(_value <= allowance[_from][msg.sender]);     // Check allowance
151             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
152             _transfer(_from, _to, _value);
153             return true;
154         }
155     
156         /**
157          * Set allowance for other address
158          *
159          * Allows `_spender` to spend no more than `_value` tokens in your behalf
160          *
161          * @param _spender The address authorized to spend
162          * @param _value the max amount they can spend
163          */
164         function approve(address _spender, uint256 _value) public
165             returns (bool success) {
166             allowance[msg.sender][_spender] = _value;
167             return true;
168         }
169     
170         /**
171          * Set allowance for other address and notify
172          *
173          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
174          *
175          * @param _spender The address authorized to spend
176          * @param _value the max amount they can spend
177          * @param _extraData some extra information to send to the approved contract
178          */
179         function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
180             public
181             returns (bool success) {
182             tokenRecipient spender = tokenRecipient(_spender);
183             if (approve(_spender, _value)) {
184                 spender.receiveApproval(msg.sender, _value, address(this), _extraData);
185                 return true;
186             }
187         }
188     
189         /**
190          * Destroy tokens
191          *
192          * Remove `_value` tokens from the system irreversibly
193          *
194          * @param _value the amount of money to burn
195          */
196         function burn(uint256 _value) public returns (bool success) {
197             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
198             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
199             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
200            emit Burn(msg.sender, _value);
201             return true;
202         }
203     
204         /**
205          * Destroy tokens from other account
206          *
207          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
208          *
209          * @param _from the address of the sender
210          * @param _value the amount of money to burn
211          */
212         function burnFrom(address _from, uint256 _value) public returns (bool success) {
213             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
214             require(_value <= allowance[_from][msg.sender]);    // Check allowance
215             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
216             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
217             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
218           emit  Burn(_from, _value);
219             return true;
220         }
221     }
222     
223     /******************************************/
224     /*       ADVANCED TOKEN STARTS HERE       */
225     /******************************************/
226     
227     contract MICATOKEN is owned, TokenERC20 {
228 
229     	using SafeMath for uint256;
230     	uint256 public startTime = 0; //client wants ICO run Infinite time, so startTimeStamp 0
231     	uint256 public endTime = 9999999999999999999999; //and entTimeStamp higher number
232 		uint256 public exchangeRate = 50000000; // this is how many tokens for 1 Ether
233 		uint256 public tokensSold = 0; // how many tokens sold in crowdsale
234 		
235         mapping (address => bool) public frozenAccount;
236     
237         /* This generates a public event on the blockchain that will notify clients */
238         event FrozenFunds(address target, bool frozen);
239     
240         /* Initializes contract with initial supply tokens to the creator of the contract */
241         constructor() TokenERC20() public {}
242 
243         /* Internal transfer, only can be called by this contract */
244         function _transfer(address _from, address _to, uint _value) internal {
245             require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead
246             require(!frozenAccount[_from]);                     // Check if sender is frozen
247             require(!frozenAccount[_to]);                       // Check if recipient is frozen
248             //overflow and undeflow is secured by SafeMath library
249             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
250             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
251             emit Transfer(_from, _to, _value);
252         }
253         
254         //@dev fallback function, only accepts ether if ICO is running or Reject
255         function () payable external {
256             require(endTime > now && startTime < now, 'ICO is not running');
257             uint256 ethervalueWEI=msg.value;
258             // calculate token amount to be sent
259             uint256 token = ethervalueWEI.mul(exchangeRate); //weiamount * price
260             tokensSold = tokensSold.add(token);
261             _transfer(address(this), msg.sender, token);     // makes the transfers
262             forwardEherToOwner();
263         }
264         
265         //Automatocally forwards ether from smart contract to owner address
266         function forwardEherToOwner() internal {
267             owner.transfer(msg.value); 
268           }
269         
270         //function to start an ICO.
271         //It requires: start and end timestamp, exchange rate in Wei, and token amounts to allocate for the ICO
272 		//It will transfer allocated amount to the smart contract
273 		function startIco(uint256 start_,uint256 end_, uint256 exchangeRateInWei, uint256 TokensAllocationForICO) onlyOwner public {
274 			require(start_ < end_);
275 			uint256 tokenAmount = TokensAllocationForICO.mul(1 ether);
276 			require(balanceOf[msg.sender] > tokenAmount);
277 			startTime=start_;
278 			endTime=end_;
279 			exchangeRate = exchangeRateInWei;
280 			transfer(address(this),tokenAmount);
281         }    	
282         
283         //Stops an ICO.
284         //It will also transfer remaining tokens to owner
285 		function stopICO() onlyOwner public{
286             endTime = 0;
287             uint256 tokenAmount=balanceOf[address(this)];
288             _transfer(address(this), msg.sender, tokenAmount);
289         }
290         
291         //function to check wheter ICO is running or not.
292         function isICORunning() public view returns(bool){
293             if(endTime > now && startTime < now){
294                 return true;                
295             }else{
296                 return false;
297             }
298         }
299         
300         //Function to set ICO Exchange rate. 
301     	function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
302 			exchangeRate=newExchangeRate;
303         }
304         
305         //Just in case, owner wants to transfer Tokens from contract to owner address
306         function manualWithdrawToken(uint256 _amount) onlyOwner public {
307             uint256 tokenAmount = _amount.mul(1 ether);
308             _transfer(address(this), msg.sender, tokenAmount);
309           }
310           
311         //Just in case, owner wants to transfer Ether from contract to owner address
312         function manualWithdrawEther()onlyOwner public{
313 			uint256 amount=address(this).balance;
314 			owner.transfer(amount);
315 		}
316 		
317         /// @notice Create `mintedAmount` tokens and send it to `target`
318         /// @param target Address to receive the tokens
319         /// @param mintedAmount the amount of tokens it will receive
320         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
321             balanceOf[target] = balanceOf[target].add(mintedAmount);
322             totalSupply = totalSupply.add(mintedAmount);
323            emit Transfer(address(0), address(this), mintedAmount);
324            emit Transfer(address(this), target, mintedAmount);
325         }
326     
327         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
328         /// @param target Address to be frozen
329         /// @param freeze either to freeze it or not
330         function freezeAccount(address target, bool freeze) onlyOwner public {
331             frozenAccount[target] = freeze;
332           emit  FrozenFunds(target, freeze);
333         }
334 
335 
336 
337     }