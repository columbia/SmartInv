1 pragma solidity ^0.4.20;
2 
3 contract FiatContract {
4   function USD(uint _id) constant returns (uint256);
5 }
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient {
25     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
26 }
27 
28 contract TokenERC20 {
29     // Public variables of the token
30     string public name;
31     string public symbol;
32     uint8 public decimals = 18;
33     // 18 decimals is the strongly suggested default, avoid changing it
34     uint256 public totalSupply;
35 
36     // This creates an array with all balances
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     // This generates a public event on the blockchain that will notify clients
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     // This notifies clients about the amount burnt
44     event Burn(address indexed from, uint256 value);
45 
46     /**
47      * Constrctor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     constructor(
52         uint256 initialSupply,
53         string tokenName,
54         string tokenSymbol
55     ) public {
56         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
58         name = tokenName;                                   // Set the name for display purposes
59         symbol = tokenSymbol;                               // Set the symbol for display purposes
60     }
61 
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint _value) internal {
66         // Prevent transfer to 0x0 address. Use burn() instead
67         require(_to != 0x0);
68         // Check if the sender has enough
69         require(balanceOf[_from] >= _value);
70         // Check for overflows
71         require(balanceOf[_to] + _value > balanceOf[_to]);
72         // Save this for an assertion in the future
73         uint previousBalances = balanceOf[_from] + balanceOf[_to];
74         // Subtract from the sender
75         balanceOf[_from] -= _value;
76         // Add the same to the recipient
77         balanceOf[_to] += _value;
78         
79         emit Transfer(_from, _to, _value);
80         // Asserts are used to use static analysis to find bugs in your code. They should never fail
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public {
93         _transfer(msg.sender, _to, _value);
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` in behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public
121         returns (bool success) {
122         allowance[msg.sender][_spender] = _value;
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address and notify
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      * @param _extraData some extra information to send to the approved contract
134      */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
136         public
137         returns (bool success) {
138         tokenRecipient spender = tokenRecipient(_spender);
139         if (approve(_spender, _value)) {
140             spender.receiveApproval(msg.sender, _value, this, _extraData);
141             return true;
142         }
143     }
144 
145 }
146 
147 /******************************************/
148 /*       ADVANCED TOKEN STARTS HERE       */
149 /******************************************/
150 
151 contract BimCoinToken is owned, TokenERC20 {
152 
153     FiatContract private fiatService;
154     uint256 public buyPrice;
155     bool private useFiatService;
156     bool private onSale;
157     uint256 private buyPriceInCent;
158     uint256 private etherPerCent;
159     uint256 constant TOKENS_PER_DOLLAR = 100000;
160     uint256 storageAmount;
161     address store;
162 
163     mapping (address => bool) public frozenAccount;
164 
165     /* This generates a public event on the blockchain that will notify clients */
166     event FrozenFunds(address target, bool frozen);
167 
168     /* Initializes contract with initial supply tokens to the creator of the contract */
169     constructor(
170         uint256 initialSupply,
171         string tokenName,
172         string tokenSymbol,
173         bool _useFiatContract
174     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
175         fiatService = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
176         useFiatService = _useFiatContract;
177         buyPriceInCent = 100;
178         onSale = true;
179         storageAmount = (2 * (initialSupply * 10 ** uint256(decimals)))/10;
180         store = msg.sender;
181     }
182 
183     /* Internal transfer, only can be called by this contract */
184     function _transfer(address _from, address _to, uint _value) internal {
185         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
186         require (balanceOf[_from] >= _value);               // Check if the sender has enough
187         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
188         require(!frozenAccount[_from]);                     // Check if sender is frozen
189         require(!frozenAccount[_to]);                       // Check if recipient is frozen
190         balanceOf[_from] -= _value;                         // Subtract from the sender
191         balanceOf[_to] += _value;                           // Add the same to the recipient
192         emit Transfer(_from, _to, _value);
193     }
194 
195     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
196     /// @param target Address to be frozen
197     /// @param freeze either to freeze it or not
198     function freezeAccount(address target, bool freeze) onlyOwner public {
199         frozenAccount[target] = freeze;
200         emit FrozenFunds(target, freeze);
201     }
202 
203     /// @notice Allow users to buy tokens for `newBuyPrice` eth
204     /// @param newBuyPrice Price users can buy from the contract
205     function setPrice(uint256 newBuyPrice) onlyOwner public {
206         buyPrice = newBuyPrice;
207     }
208     
209     /// @notice Allow users to buy tokens for `newBuyPrice` eth
210     /// @param newBuyPrice Price users can buy from the contract
211     function setPriceInCents(uint256 newBuyPrice) onlyOwner public {
212         buyPriceInCent = newBuyPrice;
213     }
214     
215     /// @notice Buy tokens from contract by sending ether
216     function () payable public {
217         buy();
218     }
219 
220     /// @notice Buy tokens from contract by sending ether
221     function buy() payable public {
222         require(onSale);
223         
224         uint256 price = getPrice();
225         
226         uint amount = msg.value * TOKENS_PER_DOLLAR * 10 ** uint256(decimals) / price;               // calculates the amount
227         
228         require(balanceOf[owner] - amount >= storageAmount);
229         
230         store.transfer(msg.value);
231         
232         _transfer(owner, msg.sender, amount);              // makes the transfers
233     }
234     
235     function getPrice() private view returns (uint256){
236         if(useFiatService){
237             return fiatService.USD(0) * buyPriceInCent;
238         }else{
239             return etherPerCent * buyPriceInCent;
240         }
241     }
242     
243     function setUseService(bool status) external onlyOwner{
244         useFiatService = status;
245     }
246     
247     function setEtherCentPrice(uint256 _newValue) external onlyOwner {
248         etherPerCent = (10 ** uint256(decimals))/(_newValue);
249     }
250     
251     function setStore(address _newValue) external onlyOwner {
252         store = _newValue;
253     }
254     
255     function toggleSale(bool _value) external onlyOwner {
256         onSale = _value;
257     }
258     
259     function withdraw() external onlyOwner {
260         uint balance = address(this).balance;
261         if(balance > 0){
262             store.transfer(balance);
263         }
264     }
265 }