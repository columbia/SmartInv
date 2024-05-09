1 pragma solidity ^0.5.0;
2 
3 interface PriceWatcherI
4 {
5     function getUSDcentsPerETH() external view returns (uint256 _USDcentsPerETH);
6 }
7 
8 
9 contract PriceWatcherPlaceholder is PriceWatcherI
10 {
11     function getUSDcentsPerETH() external view returns (uint256 _USDcentsPerETH)
12     {
13         return 12345; // $123.45 per ETH
14     }
15 }
16 
17 contract SuperLaunch
18 {
19     // Constants
20     uint256 public TOKEN_PRICE_USD_CENTS;
21     uint256 public totalSupply;
22     uint256 public AMOUNT_OF_FREE_TOKENS;
23     address payable public root;
24     address payable public bank;
25     uint256 public REFERRER_COMMISSION_PERCENTAGE;
26     uint256 public ROOT_COMMISSION_PERCENTAGE;
27     PriceWatcherI public priceWatcher;
28 
29     // State variables
30     mapping(address => uint256) private balances;
31     address[] public participants;
32     mapping(address => address payable) public address_to_referrer;
33     mapping(address => address[]) public address_to_referrals;
34 
35     constructor(address _priceWatcherContract, uint256 _tokenPriceUSDcents, uint256 _totalSupply, uint256 _amountOfFreeTokens, address payable _root, address payable _bank, uint256 _referrerCommissionPercentage, uint256 _rootCommissionPercentage) public
36     {
37         if (_priceWatcherContract == address(0x0))
38         {
39             priceWatcher = new PriceWatcherPlaceholder();
40         }
41         else
42         {
43             priceWatcher = PriceWatcherI(_priceWatcherContract);
44         }
45 
46         TOKEN_PRICE_USD_CENTS = _tokenPriceUSDcents;
47         totalSupply = _totalSupply;
48         AMOUNT_OF_FREE_TOKENS = _amountOfFreeTokens;
49         root = _root;
50         bank = _bank;
51         REFERRER_COMMISSION_PERCENTAGE = _referrerCommissionPercentage;
52         ROOT_COMMISSION_PERCENTAGE = _rootCommissionPercentage;
53 
54         // The root address is its own referrer
55         address_to_referrer[root] = root;
56 
57         // Mint all the tokens and assign them to the root address
58         balances[root] = totalSupply;
59         emit Transfer(address(0x0), root, totalSupply);
60     }
61 
62     function getTokenPriceETH() public view returns (uint256)
63     {
64         // Fetch the current ETH exchange rate
65         uint256 USDcentsPerETH = priceWatcher.getUSDcentsPerETH();
66 
67         // Use the exchange rate to calculate the current token price in ETH
68         return (1 ether) * TOKEN_PRICE_USD_CENTS / USDcentsPerETH;
69     }
70 
71     function buyTokens(address payable _referrer) external payable
72     {
73         uint256 tokensBought;
74         uint256 totalValueOfTokensBought;
75 
76         uint256 tokenPriceWei = getTokenPriceETH();
77 
78         // If there are still free tokens available
79         if (participants.length < AMOUNT_OF_FREE_TOKENS)
80         {
81             tokensBought = 1;
82             totalValueOfTokensBought = 0;
83 
84             // Only 1 free token per address
85             require(address_to_referrer[msg.sender] == address(0x0));
86         }
87 
88         // If there are no free tokens available
89         else
90         {
91             tokensBought = msg.value / tokenPriceWei;
92 
93             // Limit the bought tokens to the amount of tokens still for sale
94             if (tokensBought > balances[root])
95             {
96                 tokensBought = balances[root];
97             }
98 
99             totalValueOfTokensBought = tokensBought * tokenPriceWei;
100         }
101 
102         // If 0 tokens are being purchased, cancel this transaction
103         require(tokensBought > 0);
104 
105         // Return the change
106         msg.sender.transfer(msg.value - totalValueOfTokensBought);
107 
108         // If we haven't seen this buyer before
109         if (address_to_referrer[msg.sender] == address(0x0))
110         {
111             // Referrer must have owned at least 1 token
112             require(address_to_referrer[_referrer] != address(0x0));
113 
114             // Add them to the particpants list and the referral tree
115             address_to_referrer[msg.sender] = _referrer;
116             address_to_referrals[_referrer].push(msg.sender);
117             participants.push(msg.sender);
118         }
119 
120         // If we have seen this buyer before
121         else
122         {
123             // Referrer must be the same as their previous referrer
124             require(_referrer == address_to_referrer[msg.sender]);
125         }
126 
127         // Transfer the bought tokens from root to the buyer
128         balances[root] -= tokensBought;
129         balances[msg.sender] += tokensBought;
130         emit Transfer(root, msg.sender, tokensBought);
131 
132         // Transfer commission to the referrer
133         uint256 commissionForReferrer = totalValueOfTokensBought * REFERRER_COMMISSION_PERCENTAGE / 100;
134         _referrer.transfer(commissionForReferrer);
135 
136         // Transfer commission to the root
137         uint256 commissionForRoot = totalValueOfTokensBought * ROOT_COMMISSION_PERCENTAGE / 100;
138         root.transfer(commissionForRoot);
139 
140         // Transfer the remaining ETH to the bank
141         bank.transfer(totalValueOfTokensBought - commissionForReferrer - commissionForRoot);
142     }
143 
144     function amountOfReferralsMade(address _byReferrer) external view returns (uint256)
145     {
146         return address_to_referrals[_byReferrer].length;
147     }
148 
149     function amountOfTokensForSale() external view returns (uint256)
150     {
151         return balances[root];
152     }
153 
154     function amountOfFreeTokensAvailable() external view returns (uint256)
155     {
156         if (participants.length < AMOUNT_OF_FREE_TOKENS)
157         {
158             return AMOUNT_OF_FREE_TOKENS - participants.length;
159         }
160         else
161         {
162             return 0;
163         }
164     }
165 
166     // ERC20 implementation
167     string public constant name = "SuperLaunch";
168     string public constant symbol = "SLX";
169     uint8 public constant decimals = 0;
170 
171     mapping (address => mapping (address => uint256)) private allowed;
172 
173     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
174     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
175 
176     function balanceOf(address _who) external view returns (uint256)
177     {
178         return balances[_who];
179     }
180     function allowance(address _owner, address _spender) external view returns (uint256)
181     {
182         return allowed[_owner][_spender];
183     }
184 
185     function transfer(address _to, uint256 _amount) external returns (bool)
186     {
187         require(balances[msg.sender] >= _amount);
188         balances[msg.sender] -= _amount;
189         balances[_to] += _amount;
190         emit Transfer(msg.sender, _to, _amount);
191         return true;
192     }
193     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool)
194     {
195         require(allowed[_from][msg.sender] >= _amount);
196         require(balances[_from] >= _amount);
197         allowed[_from][msg.sender] -= _amount;
198         balances[_from] -= _amount;
199         balances[_to] += _amount;
200         emit Transfer(_from, _to, _amount);
201         emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
202         return true;
203     }
204     function approve(address _spender, uint256 _amount) external returns (bool)
205     {
206         allowed[msg.sender][_spender] = _amount;
207         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210     function increaseAllowance(address _spender, uint256 _addedAmount) public returns (bool)
211     {
212         require(allowed[msg.sender][_spender] + _addedAmount >= _addedAmount);
213         allowed[msg.sender][_spender] += _addedAmount;
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217     function decreaseAllowance(address _spender, uint256 _subtractedAmount) public returns (bool)
218     {
219         require(allowed[msg.sender][_spender] >= _subtractedAmount);
220         allowed[msg.sender][_spender] -= _subtractedAmount;
221         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 }