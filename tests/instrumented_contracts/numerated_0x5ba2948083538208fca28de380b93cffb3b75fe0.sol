1 //TheEthadams's Prod Ready.
2 //https://rinkeby.etherscan.io/address/0x8d4665fe98968707da5042be347060e673da98f1#code
3 
4 pragma solidity ^0.4.22;
5 
6 
7 interface tokenRecipient {
8   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
9  }
10 
11 
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 
42 contract TokenERC20 {
43 
44     using SafeMath for uint256;
45     // Public variables of the token
46     string public name;
47     string public symbol;
48     uint8 public decimals = 18;
49     // 18 decimals
50     uint256 public totalSupply = 500000000 * 10 ** uint256(decimals);
51 
52     //Address founder
53     address public owner;
54 
55     //Address Development.
56     address public development = 0x23556CF8E8997f723d48Ab113DAbed619E7a9786;
57 
58     //Start timestamp
59     //End timestamp
60     uint public startTime;
61     uint public icoDays;
62     uint public stopTime;
63 
64     // This creates an array with all balances
65     mapping (address => uint256) public balanceOf;
66     mapping (address => mapping (address => uint256)) public allowance;
67 
68     // This generates a public event on the blockchain that will notify clients
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     // This notifies clients about the amount burnt
72     event Burn(address indexed from, uint256 value);
73     /**
74      * Constructor function
75      *
76      * Initializes contract with initial supply tokens to the creator of the contract
77      */
78     constructor(
79         string tokenName,
80         string tokenSymbol
81     ) public {
82         totalSupply = totalSupply;  // Update total supply.
83         balanceOf[msg.sender] = 150000000 * 10 ** uint256(decimals);
84         //Give this contract some token balances.
85         balanceOf[this] = 350000000 * 10 ** uint256(decimals);
86         //Set the name for display purposes
87         name = tokenName;
88         //Set the symbol for display purposes
89         symbol = tokenSymbol;
90         //Assign owner.
91         owner = msg.sender;
92     }
93 
94     /**
95      * Internal transfer, only can be called by this contract
96      */
97     function _transfer(address _from, address _to, uint _value) internal {
98         // Prevent transfer to 0x0 address. Use burn() instead
99         require(_to != 0x0);
100         // Check if the sender has enough
101         require(balanceOf[_from] >= _value);
102         // Check for overflows
103         require(balanceOf[_to] + _value > balanceOf[_to]);
104         // Save this for an assertion in the future
105         uint previousBalances = balanceOf[_from] + balanceOf[_to];
106         // Subtract from the sender
107         balanceOf[_from] -= _value;
108         // Add the same to the recipient
109         balanceOf[_to] += _value;
110         emit Transfer(_from, _to, _value);
111         // Asserts are used to use static analysis to find bugs in your code. They should never fail
112         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
113     }
114 
115     modifier onlyDeveloper() {
116       require(msg.sender == development);
117       _;
118     }
119 
120     modifier onlyOwner {
121         require(msg.sender == owner);
122         _;
123     }
124 
125     /**
126      * Transfer tokens
127      *
128      * Send `_value` tokens to `_to` from your account
129      *
130      * @param _to The address of the recipient
131      * @param _value the amount to send
132      */
133     function transfer(address _to, uint256 _value) public {
134       require(now >= stopTime);//Transfer only after ICO.
135         _transfer(msg.sender, _to, _value);
136     }
137 
138     /**
139      * Transfer tokens from other address
140      *
141      * Send `_value` tokens to `_to` in behalf of `_from`
142      *
143      * @param _from The address of the sender
144      * @param _to The address of the recipient
145      * @param _value the amount to send
146      */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
148         require(_value <= allowance[_from][msg.sender]);     // Check allowance
149         allowance[_from][msg.sender] -= _value;
150         if(now < stopTime){
151           require(_from == owner);//Only owner can move the tokens before ICO is over.
152           _transfer(_from, _to, _value);
153         } else {
154         _transfer(_from, _to, _value);
155         }
156         return true;
157     }
158 
159     /**
160      * Set allowance for other address
161      *
162      * Allows `_spender` to spend no more than `_value` tokens in your behalf
163      *
164      * @param _spender The address authorized to spend
165      * @param _value the max amount they can spend
166      */
167     function approve(address _spender, uint256 _value) public
168         returns (bool success) {
169         allowance[msg.sender][_spender] = _value;
170         return true;
171     }
172 
173     /**
174      * Set allowance for other address and notify
175      *
176      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
177      *
178      * @param _spender The address authorized to spend
179      * @param _value the max amount they can spend
180      * @param _extraData some extra information to send to the approved contract
181      */
182     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
183         public
184         returns (bool success) {
185         tokenRecipient spender = tokenRecipient(_spender);
186         if (approve(_spender, _value)) {
187             spender.receiveApproval(msg.sender, _value, this, _extraData);
188             return true;
189         }
190     }
191 
192     /**
193      * Destroy tokens
194      *
195      * Remove `_value` tokens from the system irreversibly
196      *
197      * @param _value the amount of money to burn
198      */
199     function burn(uint256 _value) public returns (bool success) {
200         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
201         balanceOf[msg.sender] -= _value;            // Subtract from the sender
202         totalSupply -= _value;                      // Updates totalSupply
203         emit Burn(msg.sender, _value);
204         return true;
205     }
206 
207     /**
208      * Destroy tokens from other account
209      *
210      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
211      *
212      * @param _from the address of the sender
213      * @param _value the amount of money to burn
214      */
215     function burnFrom(address _from, uint256 _value) public returns (bool success) {
216         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
217         require(_value <= allowance[_from][msg.sender]);    // Check allowance
218         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
219         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
220         totalSupply -= _value;                              // Update totalSupply
221         emit Burn(_from, _value);
222         return true;
223     }
224 }
225 
226 /******************************************/
227 /*       ADVANCED TOKEN STARTS HERE       */
228 /******************************************/
229 
230 contract OffGridParadise is TokenERC20 {
231 
232     uint256 public buyPrice;
233     bool private isKilled; //Changed to true if the contract is killed.
234 
235     mapping (address => bool) public frozenAccount;
236 
237     /* This generates a public event on the blockchain that will notify clients */
238     event FrozenFunds(address target, bool frozen);
239 
240 
241     /* Initializes contract with initial supply tokens to the creator of the contract */
242     constructor (
243         string tokenName,
244         string tokenSymbol
245     ) TokenERC20(tokenName, tokenSymbol) public {
246       //Initializes the timestamps
247       startTime = now;
248       isKilled  = false;
249       //This is the PRE-ICO price.Assuming the price of ethereum is $600per Ether.
250       setPrice(13300);
251     }
252 
253     /* Internal transfer, only can be called by this contract */
254     function _transfer(address _from, address _to, uint _value) internal {
255         require (_to != 0x0);                               // Prevent transfer to 0x0 address(Number greater than Zero).
256         require (balanceOf[_from] >= _value);               // Check if the sender has enough //Use burn() instead
257         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
258         require(!frozenAccount[_from]);                     // Check if sender is frozen
259         require(!frozenAccount[_to]);                       // Check if recipient is frozen
260         balanceOf[_from] -= _value;                         // Subtract from the sender
261         balanceOf[_to] += _value;                           // Add the same to the recipient
262         emit Transfer(_from, _to, _value);
263     }
264 
265 
266     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
267     /// @param target Address to be frozen
268     /// @param freeze either to freeze it or not
269     function freezeAccount(address target, bool freeze) onlyDeveloper public {
270         require(target != development);
271         frozenAccount[target] = freeze;
272         emit FrozenFunds(target, freeze);
273     }
274 
275     //Buy tokens from the contract by sending ethers.
276     function buyTokens () payable public {
277       require(isKilled == false);
278       require(msg.sender != development);
279       require(msg.sender != owner);
280       uint amount = msg.value * buyPrice;
281       owner.transfer(msg.value);
282       _transfer(this, msg.sender, amount);
283     }
284 
285     //Buy tokens from the contract by sending ethers(Fall Back Function).
286     function () payable public {
287       require(isKilled == false);
288       require(msg.sender != development);
289       require(msg.sender != owner);
290       uint amount = msg.value * buyPrice;
291       owner.transfer(msg.value);
292       if(balanceOf[this] > amount){
293       _transfer(this, msg.sender, amount);
294       } else {
295       _transfer(owner,msg.sender,amount);
296       }
297     }
298 
299     function setPrice(uint256 newBuyingPrice) onlyOwner public {
300       buyPrice = newBuyingPrice;
301     }
302 
303     function setStopTime(uint icodays) onlyOwner public {
304       //Minutes in a day is 1440
305       icoDays = icodays * 1 days;//Production Purposes.
306       stopTime = startTime + icoDays;
307     }
308 
309     //Transfer transferOwnership
310     function transferOwnership(address newOwner) onlyOwner public  {
311       owner = newOwner;
312   }
313     //Stop the contract.
314   function killContract() onlyOwner public {
315       isKilled = true;
316   }
317 
318 }