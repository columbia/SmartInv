1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Kryptor Token by EdooPAD Inc.
5 // An ERC20 standard
6 //
7 // author: EdooPAD Inc.
8 // Contact: william@edoopad.com 
9 
10 contract ERC20Interface {
11     // Get the total token supply
12     function totalSupply() public constant returns (uint256 _totalSupply);
13  
14     // Get the account balance of another account with address _owner
15     function balanceOf(address _owner) public constant returns (uint256 balance);
16  
17     // Send _value amount of tokens to address _to
18     function transfer(address _to, uint256 _value) public returns (bool success);
19   
20     // Triggered when tokens are transferred.
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22  
23     // Triggered whenever approve(address _spender, uint256 _value) is called.
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 }
26  
27 contract Kryptor is ERC20Interface {
28     uint public constant decimals = 10;
29 
30     string public constant symbol = "Kryptor";
31     string public constant name = "Kryptor";
32 
33     uint private constant icoSupplyRatio = 30;  // percentage of _icoSupply in _totalSupply. Preset: 30%
34     uint private constant bonusRatio = 20;   // sale bonus percentage
35     uint private constant bonusBound = 10;  // First 10% of totalSupply get bonus
36     uint private constant initialPrice = 5000; // Initially, 5000 Kryptor = 1 ETH
37 
38     bool public _selling = true;
39     uint public _totalSupply = 10 ** 19; // total supply is 10^19 unit, equivalent to 10^9 Kryptor
40     uint public _originalBuyPrice = (10 ** 18) / (initialPrice * 10**decimals); // original buy in wei of one unit. Ajustable.
41 
42     // Owner of this contract
43     address public owner;
44  
45     // Balances Kryptor for each account
46     mapping(address => uint256) balances;
47     
48     // _icoSupply is the avalable unit. Initially, it is _totalSupply
49     // uint public _icoSupply = _totalSupply - (_totalSupply * bonusBound)/100 * bonusRatio;
50     uint public _icoSupply = (_totalSupply * icoSupplyRatio) / 100;
51     
52     // amount of units with bonus
53     uint public bonusRemain = (_totalSupply * bonusBound) / 100;//10% _totalSupply
54     
55     /* Functions with this modifier can only be executed by the owner
56      */
57     modifier onlyOwner() {
58         if (msg.sender != owner) {
59             revert();
60         }
61         _;
62     }
63 
64     /* Functions with this modifier can only be executed by users except owners
65      */
66     modifier onlyNotOwner() {
67         if (msg.sender == owner) {
68             revert();
69         }
70         _;
71     }
72 
73     /* Functions with this modifier check on sale status
74      * Only allow sale if _selling is on
75      */
76     modifier onSale() {
77         if (!_selling || (_icoSupply <= 0) ) { 
78             revert();
79         }
80         _;
81     }
82 
83     /* Functions with this modifier check the validity of original buy price
84      */
85     modifier validOriginalBuyPrice() {
86         if(_originalBuyPrice <= 0) {
87             revert();
88         }
89         _;
90     }
91 
92     ///  Fallback function allows to buy ether.
93     function()
94         public
95         payable
96     {
97         buy();
98     }
99 
100     /// @dev Constructor
101     function Kryptor() 
102         public {
103         owner = msg.sender;
104         balances[owner] = _totalSupply;
105     }
106     
107     /// @dev Gets totalSupply
108     /// @return Total supply
109     function totalSupply()
110         public 
111         constant 
112         returns (uint256) {
113         return _totalSupply;
114     }
115  
116     /// @dev Gets account's balance
117     /// @param _addr Address of the account
118     /// @return Account balance
119     function balanceOf(address _addr) 
120         public
121         constant 
122         returns (uint256) {
123         return balances[_addr];
124     }
125  
126     /// @dev Transfers the balance from Multisig wallet to an account
127     /// @param _to Recipient address
128     /// @param _amount Transfered amount in unit
129     /// @return Transfer status
130     function transfer(address _to, uint256 _amount)
131         public 
132         returns (bool) {
133         // if sender's balance has enough unit and amount > 0, 
134         //      and the sum is not overflow,
135         // then do transfer 
136         if ( (balances[msg.sender] >= _amount) &&
137              (_amount > 0) && 
138              (balances[_to] + _amount > balances[_to]) ) {  
139 
140             balances[msg.sender] -= _amount;
141             balances[_to] += _amount;
142             Transfer(msg.sender, _to, _amount);
143             
144             return true;
145 
146         } else {
147             return false;
148         }
149     }
150 
151     /// @dev Enables sale 
152     function turnOnSale() onlyOwner 
153         public {
154         _selling = true;
155     }
156 
157     /// @dev Disables sale
158     function turnOffSale() onlyOwner 
159         public {
160         _selling = false;
161     }
162 
163     /// @dev Gets selling status
164     function isSellingNow() 
165         public 
166         constant
167         returns (bool) {
168         return _selling;
169     }
170 
171     /// @dev Updates buy price (owner ONLY)
172     /// @param newBuyPrice New buy price (in unit)
173     function setBuyPrice(uint newBuyPrice) onlyOwner 
174         public {
175         _originalBuyPrice = newBuyPrice;
176     }
177     
178     /*
179      *  Exchange wei for Kryptor.
180      *  modifier _icoSupply > 0
181      *  if requestedCoin > _icoSupply 
182      *      revert
183      *  
184      *  Buy transaction must follow this policy:
185      *      if requestedCoin < bonusRemain
186      *          actualCoin = requestedCoin + 20%requestedCoin
187      *          bonusRemain -= requestedCoin
188      *          _icoSupply -= requestedCoin
189      *      else
190      *          actualCoin = requestedCoin + 20%bonusRemain
191      *          _icoSupply -= requested
192      *          bonusRemain = 0
193      *
194      *   Return: 
195      *       amount: actual amount of units sold.
196      *
197      *   NOTE: msg.value is in wei
198      */ 
199     /// @dev Buys Kryptor
200     /// @return Amount of actual sold units 
201     function buy() payable onlyNotOwner validOriginalBuyPrice onSale 
202         public
203         returns (uint256 amount) {
204         // convert buy amount in wei to number of unit want to buy
205         uint requestedUnits = msg.value / _originalBuyPrice ;
206         
207         //check requestedUnits > _icoSupply
208         if(requestedUnits > _icoSupply){
209             revert();
210         }
211         
212         // amount of Kryptor bought
213         uint actualSoldUnits = 0;
214 
215         // If bonus is available and requested amount of units is less than bonus amount
216         if (requestedUnits < bonusRemain) {
217             // calculate actual sold units with bonus to the requested amount of units
218             actualSoldUnits = requestedUnits + ((requestedUnits*bonusRatio) / 100); 
219             // decrease _icoSupply
220             _icoSupply -= requestedUnits;
221             
222             // decrease available bonus amount
223             bonusRemain -= requestedUnits;
224         }
225         else {
226             // calculate actual sold units with bonus - if available - to the requested amount of units
227             actualSoldUnits = requestedUnits + (bonusRemain * bonusRatio) / 100;
228             
229             // otherwise, decrease _icoSupply by the requested amount
230             _icoSupply -= requestedUnits;
231 
232             // no more bonus
233             bonusRemain = 0;
234         }
235 
236         // prepare transfer data
237         balances[owner] -= actualSoldUnits;
238         balances[msg.sender] += actualSoldUnits;
239 
240         //transfer ETH to owner
241         owner.transfer(msg.value);
242         
243         // submit transfer
244         Transfer(owner, msg.sender, actualSoldUnits);
245 
246         return actualSoldUnits;
247     }
248     
249     /// @dev Withdraws Ether in contract (Owner only)
250     function withdraw() onlyOwner 
251         public 
252         returns (bool) {
253         return owner.send(this.balance);
254     }
255 }