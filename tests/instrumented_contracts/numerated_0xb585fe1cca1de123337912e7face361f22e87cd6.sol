1 /**
2  * Source Code first verified at https://etherscan.io on Saturday, March 2, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.0;
6 
7 interface PriceWatcherI
8 {
9     function getUSDcentsPerETH() external view returns (uint256 _USDcentsPerETH);
10 }
11 
12 
13 contract PriceWatcherPlaceholder is PriceWatcherI
14 {
15     function getUSDcentsPerETH() external view returns (uint256 _USDcentsPerETH)
16     {
17         return 12345;
18         // $123.45 per ETH
19     }
20 }
21 
22 contract Ownable {
23     address public owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26     /**
27      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28      * account.
29      */
30     constructor() public{
31         owner = msg.sender;
32     }
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40     /**
41      * @dev Allows the current owner to transfer control of the contract to a newOwner.
42      * @param newOwner The address to transfer ownership to.
43      */
44     function transferOwnership(address newOwner) onlyOwner public {
45         require(newOwner != address(0));
46         emit OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48     }
49 }
50 
51 
52 contract Super100 is Ownable
53 {
54     // Constants
55     uint256 public TOKEN_PRICE_USD_CENTS;
56     uint256 public totalSupply;
57     uint256 public AMOUNT_OF_FREE_TOKENS;
58     address payable public root;
59     address payable public bank;
60     uint256 public REFERRER_COMMISSION_PERCENTAGE;
61     uint256 public ROOT_COMMISSION_PERCENTAGE;
62     PriceWatcherI public priceWatcher;
63 
64     // State variables
65     mapping(address => uint256) private balances;
66     address[] public participants;
67     mapping(address => address payable) public address_to_referrer;
68     mapping(address => address[]) public address_to_referrals;
69 
70     constructor(address _priceWatcherContract, uint256 _tokenPriceUSDcents, uint256 _totalSupply, uint256 _amountOfFreeTokens, address payable _root, address payable _bank, uint256 _referrerCommissionPercentage, uint256 _rootCommissionPercentage) public
71     {
72         if (_priceWatcherContract == address(0x0))
73         {
74             priceWatcher = new PriceWatcherPlaceholder();
75         }
76         else
77         {
78             priceWatcher = PriceWatcherI(_priceWatcherContract);
79         }
80 
81         TOKEN_PRICE_USD_CENTS = _tokenPriceUSDcents;
82         totalSupply = _totalSupply;
83         AMOUNT_OF_FREE_TOKENS = _amountOfFreeTokens;
84         root = _root;
85         bank = _bank;
86         REFERRER_COMMISSION_PERCENTAGE = _referrerCommissionPercentage;
87         ROOT_COMMISSION_PERCENTAGE = _rootCommissionPercentage;
88 
89         // The root address is its own referrer
90         address_to_referrer[root] = root;
91 
92         // Mint all the tokens and assign them to the root address
93         balances[root] = totalSupply;
94         emit Transfer(address(0x0), root, totalSupply);
95     }
96 
97     function transferManually(address payable beneficiary, address payable referrer) external onlyOwner() {
98         address_to_referrer[beneficiary] = referrer;
99         address_to_referrals[referrer].push(beneficiary);
100         balances[root] -= 1;
101         balances[beneficiary] += 1;
102         participants.push(beneficiary);
103         emit Transfer(root, beneficiary, 1);
104     }
105 
106     function getTokenPriceETH() public view returns (uint256)
107     {
108         // Fetch the current ETH exchange rate
109         uint256 USDcentsPerETH = priceWatcher.getUSDcentsPerETH();
110 
111         // Use the exchange rate to calculate the current token price in ETH
112         return (1 ether) * TOKEN_PRICE_USD_CENTS / USDcentsPerETH;
113     }
114 
115     function buyTokens(address payable _referrer) external payable
116     {
117         uint256 tokensBought;
118         uint256 totalValueOfTokensBought;
119 
120         uint256 tokenPriceWei = getTokenPriceETH();
121 
122         // If there are still free tokens available
123         if (participants.length < AMOUNT_OF_FREE_TOKENS)
124         {
125             tokensBought = 1;
126             totalValueOfTokensBought = 0;
127 
128             // Only 1 free token per address
129             require(address_to_referrer[msg.sender] == address(0x0));
130         }
131 
132         // If there are no free tokens available
133         else
134         {
135             tokensBought = msg.value / tokenPriceWei;
136 
137             // Limit the bought tokens to the amount of tokens still for sale
138             if (tokensBought > balances[root])
139             {
140                 tokensBought = balances[root];
141             }
142 
143             totalValueOfTokensBought = tokensBought * tokenPriceWei;
144         }
145 
146         // If 0 tokens are being purchased, cancel this transaction
147         require(tokensBought > 0);
148 
149         // Return the change
150         msg.sender.transfer(msg.value - totalValueOfTokensBought);
151 
152         // If we haven't seen this buyer before
153         if (address_to_referrer[msg.sender] == address(0x0))
154         {
155             // Referrer must have owned at least 1 token
156             require(address_to_referrer[_referrer] != address(0x0));
157 
158             // Add them to the particpants list and the referral tree
159             address_to_referrer[msg.sender] = _referrer;
160             address_to_referrals[_referrer].push(msg.sender);
161             participants.push(msg.sender);
162         }
163 
164         // If we have seen this buyer before
165         else
166         {
167             // Referrer must be the same as their previous referrer
168             require(_referrer == address_to_referrer[msg.sender]);
169         }
170 
171         // Transfer the bought tokens from root to the buyer
172         balances[root] -= tokensBought;
173         balances[msg.sender] += tokensBought;
174         emit Transfer(root, msg.sender, tokensBought);
175 
176         // Transfer commission to the referrer
177         uint256 commissionForReferrer = totalValueOfTokensBought * REFERRER_COMMISSION_PERCENTAGE / 100;
178         _referrer.transfer(commissionForReferrer);
179 
180         // Transfer commission to the root
181         uint256 commissionForRoot = totalValueOfTokensBought * ROOT_COMMISSION_PERCENTAGE / 100;
182         root.transfer(commissionForRoot);
183 
184         // Transfer the remaining ETH to the bank
185         bank.transfer(totalValueOfTokensBought - commissionForReferrer - commissionForRoot);
186     }
187 
188     function amountOfReferralsMade(address _byReferrer) external view returns (uint256)
189     {
190         return address_to_referrals[_byReferrer].length;
191     }
192 
193     function amountOfTokensForSale() external view returns (uint256)
194     {
195         return balances[root];
196     }
197 
198     function amountOfFreeTokensAvailable() external view returns (uint256)
199     {
200         if (participants.length < AMOUNT_OF_FREE_TOKENS)
201         {
202             return AMOUNT_OF_FREE_TOKENS - participants.length;
203         }
204         else
205         {
206             return 0;
207         }
208     }
209 
210     // ERC20 implementation
211     string public constant name = "Super100";
212     string public constant symbol = "S100";
213     uint8 public constant decimals = 0;
214 
215     mapping(address => mapping(address => uint256)) private allowed;
216 
217     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
218     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
219 
220     function balanceOf(address _who) external view returns (uint256)
221     {
222         return balances[_who];
223     }
224 
225     function allowance(address _owner, address _spender) external view returns (uint256)
226     {
227         return allowed[_owner][_spender];
228     }
229 
230     function transfer(address _to, uint256 _amount) external returns (bool)
231     {
232         require(balances[msg.sender] >= _amount);
233         balances[msg.sender] -= _amount;
234         balances[_to] += _amount;
235         emit Transfer(msg.sender, _to, _amount);
236         return true;
237     }
238 
239     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool)
240     {
241         require(allowed[_from][msg.sender] >= _amount);
242         require(balances[_from] >= _amount);
243         allowed[_from][msg.sender] -= _amount;
244         balances[_from] -= _amount;
245         balances[_to] += _amount;
246         emit Transfer(_from, _to, _amount);
247         emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
248         return true;
249     }
250 
251     function approve(address _spender, uint256 _amount) external returns (bool)
252     {
253         allowed[msg.sender][_spender] = _amount;
254         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258     function increaseAllowance(address _spender, uint256 _addedAmount) public returns (bool)
259     {
260         require(allowed[msg.sender][_spender] + _addedAmount >= _addedAmount);
261         allowed[msg.sender][_spender] += _addedAmount;
262         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263         return true;
264     }
265 
266     function decreaseAllowance(address _spender, uint256 _subtractedAmount) public returns (bool)
267     {
268         require(allowed[msg.sender][_spender] >= _subtractedAmount);
269         allowed[msg.sender][_spender] -= _subtractedAmount;
270         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271         return true;
272     }
273 }