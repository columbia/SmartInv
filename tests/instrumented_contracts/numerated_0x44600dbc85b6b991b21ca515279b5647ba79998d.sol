1 pragma solidity 0.4.24;
2 // ----------------------------------------------------------------------------
3 // 'TruckingCoin' contract
4 //
5 // Deployed to : 0xbd93cb8ee8511a62035Bfe6aB72D5f74CE7Af8e5
6 // Symbol      : XTK
7 // Name        : TruckingCoin
8 // Total supply: 500 billion
9 // Decimals    : 18
10 //
11 // Copyright (c) 2018 Trade Safe LLC (https://xtkcoin.com) The MIT Licence.
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
71     	string public name;
72         string public symbol;
73         uint8 public decimals = 18;
74         // 18 decimals is the strongly suggested default, avoid changing it
75         uint256 public totalSupply;
76     
77         // This creates an array with all balances
78         mapping (address => uint256) public balanceOf;
79         mapping (address => mapping (address => uint256)) public allowance;
80     
81         // This generates a public event on the blockchain that will notify clients
82         event Transfer(address indexed from, address indexed to, uint256 value);
83     
84         // This notifies clients about the amount burnt
85         event Burn(address indexed from, uint256 value);
86     
87         /**
88          * Constrctor function
89          *
90          * Initializes contract with initial supply tokens to the creator of the contract
91          */
92         constructor(
93             uint256 initialSupply,
94             string tokenName,
95             string tokenSymbol
96         ) public {
97             totalSupply = initialSupply.mul(1 ether);  // only works with 18 decimal. If any other, then change it accordingly
98             balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
99             name = tokenName;                                   // Set the name for display purposes
100             symbol = tokenSymbol;                               // Set the symbol for display purposes
101         }
102     
103         /**
104          * Internal transfer, only can be called by this contract
105          */
106         function _transfer(address _from, address _to, uint _value) internal {
107             // Prevent transfer to 0x0 address. Use burn() instead
108             require(_to != 0x0);
109             // Check if the sender has enough
110             require(balanceOf[_from] >= _value);
111             // Check for overflows
112             require(balanceOf[_to].add(_value) > balanceOf[_to]);
113             // Save this for an assertion in the future
114             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
115             // Subtract from the sender
116             balanceOf[_from] = balanceOf[_from].sub(_value);
117             // Add the same to the recipient
118             balanceOf[_to] = balanceOf[_to].add(_value);
119             emit Transfer(_from, _to, _value);
120             // Asserts are used to use static analysis to find bugs in your code. They should never fail
121             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
122         }
123     
124         /**
125          * Transfer tokens
126          *
127          * Send `_value` tokens to `_to` from your account
128          *
129          * @param _to The address of the recipient
130          * @param _value the amount to send
131          */
132         function transfer(address _to, uint256 _value) public {
133             _transfer(msg.sender, _to, _value);
134         }
135     
136         /**
137          * Transfer tokens from other address
138          *
139          * Send `_value` tokens to `_to` in behalf of `_from`
140          *
141          * @param _from The address of the sender
142          * @param _to The address of the recipient
143          * @param _value the amount to send
144          */
145         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
146             require(_value <= allowance[_from][msg.sender]);     // Check allowance
147             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
148             _transfer(_from, _to, _value);
149             return true;
150         }
151     
152         /**
153          * Set allowance for other address
154          *
155          * Allows `_spender` to spend no more than `_value` tokens in your behalf
156          *
157          * @param _spender The address authorized to spend
158          * @param _value the max amount they can spend
159          */
160         function approve(address _spender, uint256 _value) public
161             returns (bool success) {
162             allowance[msg.sender][_spender] = _value;
163             return true;
164         }
165     
166         /**
167          * Set allowance for other address and notify
168          *
169          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
170          *
171          * @param _spender The address authorized to spend
172          * @param _value the max amount they can spend
173          * @param _extraData some extra information to send to the approved contract
174          */
175         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
176             public
177             returns (bool success) {
178             tokenRecipient spender = tokenRecipient(_spender);
179             if (approve(_spender, _value)) {
180                 spender.receiveApproval(msg.sender, _value, this, _extraData);
181                 return true;
182             }
183         }
184     
185         /**
186          * Destroy tokens
187          *
188          * Remove `_value` tokens from the system irreversibly
189          *
190          * @param _value the amount of money to burn
191          */
192         function burn(uint256 _value) public returns (bool success) {
193             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
194             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
195             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
196            emit Burn(msg.sender, _value);
197             return true;
198         }
199     
200         /**
201          * Destroy tokens from other account
202          *
203          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
204          *
205          * @param _from the address of the sender
206          * @param _value the amount of money to burn
207          */
208         function burnFrom(address _from, uint256 _value) public returns (bool success) {
209             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
210             require(_value <= allowance[_from][msg.sender]);    // Check allowance
211             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
212             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
213             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
214           emit  Burn(_from, _value);
215             return true;
216         }
217     }
218     
219     /******************************************/
220     /*       ADVANCED TOKEN STARTS HERE       */
221     /******************************************/
222     
223     contract TruckingCoin is owned, TokenERC20 {
224 
225     	using SafeMath for uint256;
226     	uint256 public startTime = 0; //client wants ICO run Infinite time, so startTimeStamp 0
227     	uint256 public endTime = 9999999999999999999999; //and entTimeStamp higher number
228 		uint256 public exchangeRate = 5000; // this is howmany tokens for 1 Ether
229         mapping (address => bool) public frozenAccount;
230     
231         /* This generates a public event on the blockchain that will notify clients */
232         event FrozenFunds(address target, bool frozen);
233     
234         /* Initializes contract with initial supply tokens to the creator of the contract */
235         constructor(
236             uint256 initialSupply,
237             string tokenName,
238             string tokenSymbol
239         ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
240 
241         /* Internal transfer, only can be called by this contract */
242         function _transfer(address _from, address _to, uint _value) internal {
243             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
244             require (balanceOf[_from] >= _value);               // Check if the sender has enough
245             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
246             require(!frozenAccount[_from]);                     // Check if sender is frozen
247             require(!frozenAccount[_to]);                       // Check if recipient is frozen
248             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
249             balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
250             emit Transfer(_from, _to, _value);
251         }
252         
253         //@dev fallback function, only accepts ether if ICO is running or Reject
254         function () payable public {
255             require(endTime > now);
256             require(startTime < now);
257             uint ethervalueWEI=msg.value;
258             // calculate token amount to be sent
259             uint256 token = ethervalueWEI.mul(exchangeRate); //weiamount * price
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
301         //The amount must be in WEI
302     	function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
303 			exchangeRate=newExchangeRate;
304         }
305         
306         //Just in case, owner wants to transfer Tokens from contract to owner address
307         function manualWithdrawToken(uint256 _amount) onlyOwner public {
308             uint256 tokenAmount = _amount.mul(1 ether);
309             _transfer(this, msg.sender, tokenAmount);
310           }
311           
312         //Just in case, owner wants to transfer Ether from contract to owner address
313         function manualWithdrawEther()onlyOwner public{
314 			uint256 amount=address(this).balance;
315 			owner.transfer(amount);
316 		}
317 		
318         /// @notice Create `mintedAmount` tokens and send it to `target`
319         /// @param target Address to receive the tokens
320         /// @param mintedAmount the amount of tokens it will receive
321         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
322             balanceOf[target] = balanceOf[target].add(mintedAmount);
323             totalSupply = totalSupply.add(mintedAmount);
324            emit Transfer(0, this, mintedAmount);
325            emit Transfer(this, target, mintedAmount);
326         }
327     
328         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
329         /// @param target Address to be frozen
330         /// @param freeze either to freeze it or not
331         function freezeAccount(address target, bool freeze) onlyOwner public {
332             frozenAccount[target] = freeze;
333           emit  FrozenFunds(target, freeze);
334         }
335 
336 
337 
338     }