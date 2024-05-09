1 pragma solidity 0.4.24;
2 // ----------------------------------------------------------------------------
3 // 'Ezoow' contract
4 //
5 // Deployed to : 0x7acA75682eDd35355917B8bdDD85fc0821b3cc8f
6 // Symbol      : EZW
7 // Name        : Ezoow
8 // Total supply: 15,000,000,000
9 // Decimals    : 18
10 //
11 // Copyright (c) 2018 Ezoow Inc. (https://ezoow.com) The MIT Licence.
12 // Contract designed by: GDO Infotech Pvt Ltd (https://GDO.co.in) 
13 // ----------------------------------------------------------------------------
14    
15     /**
16      * @title SafeMath
17      * @dev Math operations with safety checks that throw on error
18      */
19     library SafeMath {
20       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22           return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27       }
28     
29       function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34       }
35     
36       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39       }
40     
41       function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45       }
46     }
47     
48     contract owned {
49         address public owner;
50     	using SafeMath for uint256;
51     	
52         constructor() public {
53             owner = msg.sender;
54         }
55     
56         modifier onlyOwner {
57             require(msg.sender == owner);
58             _;
59         }
60     
61         function transferOwnership(address newOwner) onlyOwner public {
62             owner = newOwner;
63         }
64     }
65     
66     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ; }
67     
68     contract TokenERC20 {
69         // Public variables of the token
70         using SafeMath for uint256;
71     	string public name = "EZOOW";
72         string public symbol = "EZW";
73         uint8 public decimals = 18;         // 18 decimals is the strongly suggested default, avoid changing it
74         uint256 public totalSupply          = 15000000000 * (1 ether);   
75         uint256 public tokensForCrowdsale   = 10000000000 * (1 ether);
76         uint256 public tokensForTeam        = 4000000000  * (1 ether);
77         uint256 public tokensForOwner       = 1000000000  * (1 ether);
78         
79 		address public teamWallet = 0x7acA75682eDd35355917B8bdDD85fc0821b3cc8f;
80     
81         // This creates an array with all balances
82         mapping (address => uint256) public balanceOf;
83         mapping (address => mapping (address => uint256)) public allowance;
84     
85         // This generates a public event on the blockchain that will notify clients
86         event Transfer(address indexed from, address indexed to, uint256 value);
87     
88         // This notifies clients about the amount burnt
89         event Burn(address indexed from, uint256 value);
90     
91         /**
92          * Constrctor function
93          *
94          * Initializes contract with initial supply tokens to the creator of the contract
95          */
96         constructor() public {
97 			 
98             balanceOf[this] = tokensForCrowdsale;          // 10 Billion will remain in contract for crowdsale
99             balanceOf[teamWallet] = tokensForTeam;         // 4 Billion will be allocated to Team
100             balanceOf[msg.sender] = tokensForOwner;        // 1 Billon will be sent to contract owner
101 
102         }
103     
104         /**
105          * Internal transfer, only can be called by this contract
106          */
107         function _transfer(address _from, address _to, uint _value) internal {
108             // Prevent transfer to 0x0 address. Use burn() instead
109             require(_to != 0x0);
110             // Check if the sender has enough
111             require(balanceOf[_from] >= _value);
112             // Check for overflows
113             require(balanceOf[_to].add(_value) > balanceOf[_to]);
114             // Save this for an assertion in the future
115             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
116             // Subtract from the sender
117             balanceOf[_from] = balanceOf[_from].sub(_value);
118             // Add the same to the recipient
119             balanceOf[_to] = balanceOf[_to].add(_value);
120             emit Transfer(_from, _to, _value);
121             // Asserts are used to use static analysis to find bugs in your code. They should never fail
122             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
123         }
124     
125         /**
126          * Transfer tokens
127          *
128          * Send `_value` tokens to `_to` from your account
129          *
130          * @param _to The address of the recipient
131          * @param _value the amount to send
132          */
133         function transfer(address _to, uint256 _value) public {
134             _transfer(msg.sender, _to, _value);
135         }
136     
137         /**
138          * Transfer tokens from other address
139          *
140          * Send `_value` tokens to `_to` in behalf of `_from`
141          *
142          * @param _from The address of the sender
143          * @param _to The address of the recipient
144          * @param _value the amount to send
145          */
146         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
147             require(_value <= allowance[_from][msg.sender]);     // Check allowance
148             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
149             _transfer(_from, _to, _value);
150             return true;
151         }
152     
153         /**
154          * Set allowance for other address
155          *
156          * Allows `_spender` to spend no more than `_value` tokens in your behalf
157          *
158          * @param _spender The address authorized to spend
159          * @param _value the max amount they can spend
160          */
161         function approve(address _spender, uint256 _value) public
162             returns (bool success) {
163             allowance[msg.sender][_spender] = _value;
164             return true;
165         }
166     
167         /**
168          * Set allowance for other address and notify
169          *
170          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
171          *
172          * @param _spender The address authorized to spend
173          * @param _value the max amount they can spend
174          * @param _extraData some extra information to send to the approved contract
175          */
176         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
177             public
178             returns (bool success) {
179             tokenRecipient spender = tokenRecipient(_spender);
180             if (approve(_spender, _value)) {
181                 spender.receiveApproval(msg.sender, _value, this, _extraData);
182                 return true;
183             }
184         }
185     
186         /**
187          * Destroy tokens
188          *
189          * Remove `_value` tokens from the system irreversibly
190          *
191          * @param _value the amount of money to burn
192          */
193         function burn(uint256 _value) public returns (bool success) {
194             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
195             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
196             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
197            emit Burn(msg.sender, _value);
198             return true;
199         }
200     
201         /**
202          * Destroy tokens from other account
203          *
204          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
205          *
206          * @param _from the address of the sender
207          * @param _value the amount of money to burn
208          */
209         function burnFrom(address _from, uint256 _value) public returns (bool success) {
210             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
211             require(_value <= allowance[_from][msg.sender]);    // Check allowance
212             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
213             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
214             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
215           emit  Burn(_from, _value);
216             return true;
217         }
218     }
219     
220     /******************************************/
221     /*       ADVANCED TOKEN STARTS HERE       */
222     /******************************************/
223     
224     contract Ezoow is owned, TokenERC20 {
225 
226     	using SafeMath for uint256;
227     	uint256 public startTime = 0; //client wants ICO run Infinite time, so startTimeStamp 0
228     	uint256 public endTime = 9999999999999999999999; //and entTimeStamp higher number
229 		uint256 public exchangeRate = 20000000; // this is how many tokens for 1 Ether
230 		uint256 public tokensSold = 0; // how many tokens sold in crowdsale
231 		
232         mapping (address => bool) public frozenAccount;
233     
234         /* This generates a public event on the blockchain that will notify clients */
235         event FrozenFunds(address target, bool frozen);
236     
237         /* Initializes contract with initial supply tokens to the creator of the contract */
238         constructor() TokenERC20() public {}
239 
240         /* Internal transfer, only can be called by this contract */
241         function _transfer(address _from, address _to, uint _value) internal {
242             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
243             require (balanceOf[_from] >= _value);               // Check if the sender has enough
244             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
245             require(!frozenAccount[_from]);                     // Check if sender is frozen
246             require(!frozenAccount[_to]);                       // Check if recipient is frozen
247             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
248             balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
249             emit Transfer(_from, _to, _value);
250         }
251         
252         //@dev fallback function, only accepts ether if ICO is running or Reject
253         function () payable public {
254             require(endTime > now);
255             require(startTime < now);
256             uint ethervalueWEI=msg.value;
257             // calculate token amount to be sent
258             uint256 token = ethervalueWEI.mul(exchangeRate); //weiamount * price
259             tokensSold = tokensSold.add(token);
260             _transfer(this, msg.sender, token);              // makes the transfers
261             forwardEherToOwner();
262         }
263         
264         //Automatocally forwards ether from smart contract to owner address
265         function forwardEherToOwner() internal {
266             owner.transfer(msg.value); 
267           }
268         
269         //function to start an ICO.
270         //It requires: start and end timestamp, exchange rate in Wei, and token amounts to allocate for the ICO
271 		//It will transfer allocated amount to the smart contract
272 		function startIco(uint256 start,uint256 end, uint256 exchangeRateInWei, uint256 TokensAllocationForICO) onlyOwner public {
273 			require(start < end);
274 			uint256 tokenAmount = TokensAllocationForICO.mul(1 ether);
275 			require(balanceOf[msg.sender] > tokenAmount);
276 			startTime=start;
277 			endTime=end;
278 			exchangeRate = exchangeRateInWei;
279 			approve(this,tokenAmount);
280 			transfer(this,tokenAmount);
281         }    	
282         
283         //Stops an ICO.
284         //It will also transfer remaining tokens to owner
285 		function stopICO() onlyOwner public{
286             endTime = 0;
287             uint256 tokenAmount=balanceOf[this];
288             _transfer(this, msg.sender, tokenAmount);
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
308             _transfer(this, msg.sender, tokenAmount);
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
323            emit Transfer(0, this, mintedAmount);
324            emit Transfer(this, target, mintedAmount);
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