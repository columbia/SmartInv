1 pragma solidity ^0.4.15;
2 
3 /*
4 author : dungeon
5 
6 A contract for doing pools with only one contract.
7 */
8 
9 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
10 contract ERC20 {
11   function transfer(address _to, uint256 _value) returns (bool success);
12   function balanceOf(address _owner) constant returns (uint256 balance);
13 }
14 
15 contract Controller {
16     //The addy of the developer
17     address public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
18 
19     modifier onlyOwner {
20         require(msg.sender == developer);
21         _;
22     }
23 }
24 
25 contract SanityPools is Controller {
26 
27     //mapping of the pool's index with the corresponding balances
28     mapping (uint256 => mapping (address => uint256)) balances;
29     //Array of 100 pools max
30     Pool[100] pools;
31     //Index of the active pool
32     uint256 index_active = 0;
33     //Allows an emergency withdraw after 1 week after the buy : 7*24*60*60 / 15.3 (mean time for mining a block)
34     uint256 public week_in_blocs = 39529;
35 
36     modifier validIndex(uint256 _index){
37         require(_index <= index_active);
38         _;
39     }
40 
41     struct Pool {
42         string name;
43         //0 means there is no min/max amount
44         uint256 min_amount;
45         uint256 max_amount;
46         //
47         address sale;
48         ERC20 token;
49         // Record ETH value of tokens currently held by contract for the pool.
50         uint256 pool_eth_value;
51         // Track whether the pool has bought the tokens yet.
52         bool bought_tokens;
53         uint256 buy_block;
54     }
55 
56     //Functions reserved for the owner
57     function createPool(string _name, uint256 _min, uint256 _max) onlyOwner {
58         require(index_active < 100);
59         //Creates a new struct and saves in storage
60         pools[index_active] = Pool(_name, _min, _max, 0x0, ERC20(0x0), 0, false, 0);
61         //updates the active index
62         index_active += 1;
63     }
64 
65     function setSale(uint256 _index, address _sale) onlyOwner validIndex(_index) {
66         Pool storage pool = pools[_index];
67         require(pool.sale == 0x0);
68         pool.sale = _sale;
69     }
70 
71     function setToken(uint256 _index, address _token) onlyOwner validIndex(_index) {
72         Pool storage pool = pools[_index];
73         pool.token = ERC20(_token);
74     }
75 
76     function buyTokens(uint256 _index) onlyOwner validIndex(_index) {
77         Pool storage pool = pools[_index];
78         require(pool.pool_eth_value >= pool.min_amount);
79         require(pool.pool_eth_value <= pool.max_amount || pool.max_amount == 0);
80         require(!pool.bought_tokens);
81         //Prevent burning of ETH by mistake
82         require(pool.sale != 0x0);
83         //Registers the buy block number
84         pool.buy_block = block.number;
85         // Record that the contract has bought the tokens.
86         pool.bought_tokens = true;
87         // Transfer all the funds to the crowdsale address.
88         pool.sale.transfer(pool.pool_eth_value);
89     }
90 
91     function emergency_withdraw(uint256 _index, address _token) onlyOwner validIndex(_index) {
92         //Allows to withdraw all the tokens after a certain amount of time, in the case
93         //of an unplanned situation
94         Pool storage pool = pools[_index];
95         require(block.number >= (pool.buy_block + week_in_blocs));
96         ERC20 token = ERC20(_token);
97         uint256 contract_token_balance = token.balanceOf(address(this));
98         require (contract_token_balance != 0);
99         // Send the funds.  Throws on failure to prevent loss of funds.
100         require(token.transfer(msg.sender, contract_token_balance));
101     }
102 
103     function change_delay(uint256 _delay) onlyOwner {
104         week_in_blocs = _delay;
105     }
106 
107     //Functions accessible to everyone
108     function getPoolName(uint256 _index) validIndex(_index) constant returns (string) {
109         Pool storage pool = pools[_index];
110         return pool.name;
111     }
112 
113     function refund(uint256 _index) validIndex(_index) {
114         Pool storage pool = pools[_index];
115         //Can't refund if tokens were bought
116         require(!pool.bought_tokens);
117         uint256 eth_to_withdraw = balances[_index][msg.sender];
118         //Updates the user's balance prior to sending ETH to prevent recursive call.
119         balances[_index][msg.sender] = 0;
120         //Updates the pool ETH value
121         pool.pool_eth_value -= eth_to_withdraw;
122         msg.sender.transfer(eth_to_withdraw);
123     }
124 
125     function withdraw(uint256 _index) validIndex(_index) {
126         Pool storage pool = pools[_index];
127         // Disallow withdraw if tokens haven't been bought yet.
128         require(pool.bought_tokens);
129         uint256 contract_token_balance = pool.token.balanceOf(address(this));
130         // Disallow token withdrawals if there are no tokens to withdraw.
131         require(contract_token_balance != 0);
132         // Store the user's token balance in a temporary variable.
133         uint256 tokens_to_withdraw = (balances[_index][msg.sender] * contract_token_balance) / pool.pool_eth_value;
134         // Update the value of tokens currently held by the contract.
135         pool.pool_eth_value -= balances[_index][msg.sender];
136         // Update the user's balance prior to sending to prevent recursive call.
137         balances[_index][msg.sender] = 0;
138         //The 1% fee
139         uint256 fee = tokens_to_withdraw / 100;
140         // Send the funds.  Throws on failure to prevent loss of funds.
141         require(pool.token.transfer(msg.sender, tokens_to_withdraw - fee));
142         // Send the fee to the developer.
143         require(pool.token.transfer(developer, fee));
144     }
145 
146     function contribute(uint256 _index) validIndex(_index) payable {
147         Pool storage pool = pools[_index];
148         require(!pool.bought_tokens);
149         //Check if the contribution is within the limits or if there is no max amount
150         require(pool.pool_eth_value+msg.value <= pool.max_amount || pool.max_amount == 0);
151         //Update the eth held by the pool
152         pool.pool_eth_value += msg.value;
153         //Updates the user's balance
154         balances[_index][msg.sender] += msg.value;
155     }
156 }