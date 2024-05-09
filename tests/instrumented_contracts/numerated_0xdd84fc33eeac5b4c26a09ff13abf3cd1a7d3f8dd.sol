1 pragma solidity 0.4.25;
2 // ----------------------------------------------------------------------------
3 // 'SCALE' contract
4 //
5 // Symbol      : SCALE
6 // Name        : Scalecoin
7 // Total supply: 21,000,000
8 // Decimals    : 18
9 //
10 // Copyright (c) 2018 Scale Blockchain
11 // Contract designed by: GDO Infotech Pvt Ltd (https://GDO.co.in) 
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
48         address public owner;
49         using SafeMath for uint256;
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
60         function transferOwnership(address newOwner) onlyOwner public {
61             owner = newOwner;
62         }
63     }
64     
65     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ; }
66     
67     contract TokenERC20 {
68         // Public variables of the token
69         using SafeMath for uint256;
70         string public name = "Scalecoin";
71         string public symbol = "SCALE";
72         uint8 public decimals = 18;         // 18 decimals is the strongly suggested default, avoid changing it
73         uint256 public totalSupply          = 21000000 * (1 ether);   
74         uint256 public tokensForCrowdsale   = 20000000 * (1 ether);
75         uint256 public tokensForTeam        = 4000000  * (1 ether);
76         uint256 public tokensForOwner       = 1000000  * (1 ether);
77         
78         address public teamWallet = 0x824C6785d5bD0b883E0E550649203796675F0012
79 
80 ;
81     
82         // This creates an array with all balances
83         mapping (address => uint256) public balanceOf;
84         mapping (address => mapping (address => uint256)) public allowance;
85     
86         // This generates a public event on the blockchain that will notify clients
87         event Transfer(address indexed from, address indexed to, uint256 value);
88     
89         // This notifies clients about the amount burnt
90         event Burn(address indexed from, uint256 value);
91     
92         /**
93          * Constrctor function
94          *
95          * Initializes contract with initial supply tokens to the creator of the contract
96          */
97         constructor() public {
98              
99             balanceOf[this] = tokensForCrowdsale;          // 16 Million will remain in contract for crowdsale
100             balanceOf[teamWallet] = tokensForTeam;         // 4 Million will be allocated to Team
101             balanceOf[msg.sender] = tokensForOwner;        // 1 Million will be sent to contract owner
102 
103         }
104     
105         /**
106          * Internal transfer, only can be called by this contract
107          */
108         function _transfer(address _from, address _to, uint _value) internal {
109             // Prevent transfer to 0x0 address. Use burn() instead
110             require(_to != 0x0);
111             // Check if the sender has enough
112             require(balanceOf[_from] >= _value);
113             // Check for overflows
114             require(balanceOf[_to].add(_value) > balanceOf[_to]);
115             // Save this for an assertion in the future
116             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
117             // Subtract from the sender
118             balanceOf[_from] = balanceOf[_from].sub(_value);
119             // Add the same to the recipient
120             balanceOf[_to] = balanceOf[_to].add(_value);
121             emit Transfer(_from, _to, _value);
122             // Asserts are used to use static analysis to find bugs in your code. They should never fail
123             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
124         }
125     
126         /**
127          * Transfer tokens
128          *
129          * Send `_value` tokens to `_to` from your account
130          *
131          * @param _to The address of the recipient
132          * @param _value the amount to send
133          */
134         function transfer(address _to, uint256 _value) public {
135             _transfer(msg.sender, _to, _value);
136         }
137     
138         /**
139          * Transfer tokens from other address
140          *
141          * Send `_value` tokens to `_to` in behalf of `_from`
142          *
143          * @param _from The address of the sender
144          * @param _to The address of the recipient
145          * @param _value the amount to send
146          */
147         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
148             require(_value <= allowance[_from][msg.sender]);     // Check allowance
149             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
150             _transfer(_from, _to, _value);
151             return true;
152         }
153     
154         /**
155          * Set allowance for other address
156          *
157          * Allows `_spender` to spend no more than `_value` tokens in your behalf
158          *
159          * @param _spender The address authorized to spend
160          * @param _value the max amount they can spend
161          */
162         function approve(address _spender, uint256 _value) public
163             returns (bool success) {
164             allowance[msg.sender][_spender] = _value;
165             return true;
166         }
167     
168         /**
169          * Set allowance for other address and notify
170          *
171          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
172          *
173          * @param _spender The address authorized to spend
174          * @param _value the max amount they can spend
175          * @param _extraData some extra information to send to the approved contract
176          */
177         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
178             public
179             returns (bool success) {
180             tokenRecipient spender = tokenRecipient(_spender);
181             if (approve(_spender, _value)) {
182                 spender.receiveApproval(msg.sender, _value, this, _extraData);
183                 return true;
184             }
185         }
186     
187         /**
188          * Destroy tokens
189          *
190          * Remove `_value` tokens from the system irreversibly
191          *
192          * @param _value the amount of money to burn
193          */
194         function burn(uint256 _value) public returns (bool success) {
195             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
196             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
197             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
198            emit Burn(msg.sender, _value);
199             return true;
200         }
201     
202         /**
203          * Destroy tokens from other account
204          *
205          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
206          *
207          * @param _from the address of the sender
208          * @param _value the amount of money to burn
209          */
210         function burnFrom(address _from, uint256 _value) public returns (bool success) {
211             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
212             require(_value <= allowance[_from][msg.sender]);    // Check allowance
213             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
214             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
215             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
216           emit  Burn(_from, _value);
217             return true;
218         }
219     }
220     
221     /******************************************/
222     /*       ADVANCED TOKEN STARTS HERE       */
223     /******************************************/
224     
225     contract Scalecoin is owned, TokenERC20 {
226 
227         using SafeMath for uint256;
228         uint256 public startTime = 0; //client wants ICO run Infinite time, so startTimeStamp 0
229         uint256 public endTime = 9999999999999999999999; //and entTimeStamp higher number
230         uint256 public exchangeRate = 20000; // this is how many tokens for 1 Ether
231         uint256 public tokensSold = 0; // how many tokens sold in crowdsale
232         
233         mapping (address => bool) public frozenAccount;
234     
235         /* This generates a public event on the blockchain that will notify clients */
236         event FrozenFunds(address target, bool frozen);
237     
238         /* Initializes contract with initial supply tokens to the creator of the contract */
239         constructor() TokenERC20() public {}
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
260             tokensSold = tokensSold.add(token);
261             _transfer(this, msg.sender, token);              // makes the transfers
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
272         //It will transfer allocated amount to the smart contract
273         function startIco(uint256 start,uint256 end, uint256 exchangeRateInWei, uint256 TokensAllocationForICO) onlyOwner public {
274             require(start < end);
275             uint256 tokenAmount = TokensAllocationForICO.mul(1 ether);
276             require(balanceOf[msg.sender] > tokenAmount);
277             startTime=start;
278             endTime=end;
279             exchangeRate = exchangeRateInWei;
280             approve(this,tokenAmount);
281             transfer(this,tokenAmount);
282         }       
283         
284         //Stops an ICO.
285         //It will also transfer remaining tokens to owner
286         function stopICO() onlyOwner public{
287             endTime = 0;
288             uint256 tokenAmount=balanceOf[this];
289             _transfer(this, msg.sender, tokenAmount);
290         }
291         
292         //function to check wheter ICO is running or not.
293         function isICORunning() public view returns(bool){
294             if(endTime > now && startTime < now){
295                 return true;                
296             }else{
297                 return false;
298             }
299         }
300         
301         //Function to set ICO Exchange rate. 
302         function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
303             exchangeRate=newExchangeRate;
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
314             uint256 amount=address(this).balance;
315             owner.transfer(amount);
316         }
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