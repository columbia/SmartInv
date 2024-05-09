1 pragma solidity ^0.4.21;
2 
3 /*  ChiMarket is a contract that allows for buying and selling of CHI tokens for
4     used in the Aethia game (see https://aethia.co). The contract is designed to
5     discover the price of CHI (in ETH) through market forces (i.e. supply and
6     demand). The contract dynamically determines the price for each trade such that
7     the value of ETH and the value of CHI held by the contract are always the same.
8     
9     This mechanism guarantees that you can always buy and sell any amount of CHI,
10     although the price might be outrageously high or low, depending on the amount
11     you are trying to buy/sell.
12     
13     The contract provides to functions that can be used to query how much ETH
14     the contract is willing to pay for your CHI, or how much ETH you'll need to 
15     buy CHI. You can call those functions without generating a transaction,
16     for example in the "Read Smart Contract" tab on Etherscan. This will give 
17     you an estimate only, because the price might change by the time your TX confirms. 
18     To avoid price surprises, this contract only supports limit buy and sells.
19     
20     Limit buy and sell functions are used to convert CHI/ETH into ETH/CHI. limitSell
21     also takes a limit argument, which is the lowest amount of ETH you are willing
22     to accept for your trade. On the buy side, you should send more ETH than rrequired
23     to provide a cushin. You will always get the exact current price, the 
24     limit argument is just to provide safety in case price changes dramatically.
25     If you send extra ETH, the excess will be returned to you in the same TX.
26 */
27 
28 // Interface to ERC721 functions used in this contract
29 interface ERC20token {
30     function balanceOf(address who) external view returns (uint256);
31     function transfer(address to, uint256 value) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function transferFrom(address from, address to, uint256 value) external returns (bool);
34 }
35 // Interface to ERC721 functions used in this contract
36 interface ERC721Token {
37     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
38 }
39 
40 contract ChiMarket {
41     ERC20token ChiToken = ERC20token(0x71E1f8E809Dc8911FCAC95043bC94929a36505A5);
42     address owner;
43     uint256 market_halfspread;
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function ChiMarket() public {
51         owner = msg.sender;
52     }
53 
54     // Calculate the amount of ETH the contract pays out on a SELL
55     function calcSELLoffer(uint256 chi_amount) public view returns(uint256){
56         uint256 eth_balance = address(this).balance;
57         uint256 chi_balance = ChiToken.balanceOf(this);
58         uint256 eth_amount;
59         require(eth_balance > 0 && chi_balance > 0);
60 
61         require(chi_balance + chi_amount >= chi_balance); // don't allow overflow
62         eth_amount = (chi_amount * eth_balance) / (chi_balance + chi_amount);
63         require(1000 * eth_amount >= eth_amount); // don't allow overflow
64         eth_amount = ((1000 - market_halfspread) * eth_amount) / 1000;
65         return eth_amount;
66     }
67 
68     // Calculate the amount of ETH the contract requires on a BUY
69     // When this function is called from a payable function, the balance is updated
70     // already, so we need to subtract it through _offset_eth. Otherwise _offset_eth
71     // should be set to 0.
72     function calcBUYoffer(uint256 _chi_amount, uint256 _offset_eth) public view returns(uint256){
73         require(address(this).balance > _offset_eth); // no overflow
74         uint256 eth_balance = address(this).balance - _offset_eth;
75         uint256 chi_balance = ChiToken.balanceOf(this);
76         uint256 eth_amount;
77         require(eth_balance > 0 && chi_balance > 0);
78         require(chi_balance > _chi_amount); // must have enough CHI
79         
80         require(chi_balance - _chi_amount <= chi_balance); // don't allow overflow
81         eth_amount = (_chi_amount * eth_balance) / (chi_balance - _chi_amount);
82         require(1000 * eth_amount >= eth_amount); // don't allow overflow
83         eth_amount = (1000 * eth_amount) / (1000 - market_halfspread);
84         return eth_amount;
85     }
86 
87     // CHI buying function
88     // All of the ETH included in the TX is converted to CHI
89     // requires at least _min_chi_amount of CHI for that ETH, otherwise TX fails
90     function limitBuy(uint256 _chi_amount) public payable{
91         require(_chi_amount > 0);
92         uint256 eth_amount = calcBUYoffer(_chi_amount, msg.value);
93         require(eth_amount <= msg.value);
94         uint256 return_ETH_amount = msg.value - eth_amount;
95         require(return_ETH_amount < msg.value);
96 
97         if(return_ETH_amount > 0){
98             msg.sender.transfer(return_ETH_amount); // return extra ETH
99         }
100         require(ChiToken.transfer(msg.sender, _chi_amount)); // send CHI tokens
101     }
102 
103     // CHI selling function.
104     // sell _chi_amount of CHI
105     // require at least _min_eth_amount for that CHI, otherwise TX fails
106     // Make sure to set CHI allowance before calling this function
107     function limitSell(uint256 _chi_amount, uint256 _min_eth_amount) public {
108         require(ChiToken.allowance(msg.sender, this) >= _chi_amount);
109         uint256 eth_amount = calcSELLoffer(_chi_amount);
110         require(eth_amount >= _min_eth_amount);
111         require(eth_amount > 0);
112 
113         require(ChiToken.transferFrom(msg.sender, this, _chi_amount));
114         msg.sender.transfer(eth_amount);
115     }
116 
117     // Allows owner to move CHI (e.g. to an updated contract), also to rescue 
118     // other ERC20 tokens sent by mistake.    
119     function moveERC20Tokens(address _tokenContract, address _to, uint _val) public onlyOwner {
120         ERC20token token = ERC20token(_tokenContract);
121         require(token.transfer(_to, _val));
122     }
123 
124     // Hopefully this doesn't get used, but it allows for gotchi rescue if someone sends
125     // their gotchi (or a cat) to the contract by mistake.
126     function moveERC721Tokens(address _tokenContract, address _to, uint256 _tid) public onlyOwner {
127         ERC721Token token = ERC721Token(_tokenContract);
128         token.transferFrom(this, _to, _tid);
129     }
130 
131     // Allows the owner to move ether, for example to an updated contract  
132     function moveEther(address _target, uint256 _amount) public onlyOwner {
133         require(_amount <= address(this).balance);
134         _target.transfer(_amount);
135     }
136 
137     // Set the market spread (actually it's half of the spread).    
138     function setSpread(uint256 _halfspread) public onlyOwner {
139         require(_halfspread <= 50);
140         market_halfspread = _halfspread;        
141     }
142  
143     // Allows for deposit of ETH and CHI at the same time (to avoid temporary imbalance
144     // in the market)
145     function depositBoth(uint256 _chi_amount) public payable onlyOwner {
146         require(ChiToken.allowance(msg.sender, this) >= _chi_amount);
147         require(ChiToken.transferFrom(msg.sender, this, _chi_amount));
148     }
149 
150     // Allows for withdrawal of ETH and CHI at the same time (to avoid temporary imbalance
151     // in the market)
152     function withdrawBoth(uint256 _chi_amount, uint256 _eth_amount) public onlyOwner {
153         uint256 eth_balance = address(this).balance;
154         uint256 chi_balance = ChiToken.balanceOf(this);
155         require(_chi_amount <= chi_balance);
156         require(_eth_amount <= eth_balance);
157         
158         msg.sender.transfer(_eth_amount);
159         require(ChiToken.transfer(msg.sender, _chi_amount));
160     }
161  
162     // change the owner
163     function setOwner(address _owner) public onlyOwner {
164         owner = _owner;    
165     }
166 
167     // empty fallback payable to allow ETH deposits to the contract    
168     function() public payable{
169     }
170 }