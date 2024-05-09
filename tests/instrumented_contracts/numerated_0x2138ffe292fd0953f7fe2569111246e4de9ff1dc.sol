1 pragma solidity ^0.4.15;
2 
3 /*
4 
5     Crypto Market Prices via Ethereum Smart Contract
6 
7     A community driven smart contract that lets your contracts use fiat
8     amounts in USD, EURO, and GBP. Need to charge $10.50 for a contract call?
9     With this contract, you can convert ETH and other crypto's.
10 
11     Repo: https://github.com/hunterlong/marketprice
12     Look at repo for more token examples
13 
14     Examples:
15 
16       MarketPrice price = MarketPrice(CONTRACT_ADDRESS);
17 
18       uint256 ethCent = price.USD(0);        // returns $0.01 worth of ETH in USD.
19       uint256 weiAmount = ethCent * 2500     // returns $25.00 worth of ETH in USD
20       require(msg.value == weiAmount);       // require $25.00 worth of ETH as a payment
21 
22     @author Hunter Long
23 */
24 
25 contract MarketPrice {
26 
27     mapping(uint => Token) public tokens;
28 
29     address public sender;
30     address public creator;
31 
32     event NewPrice(uint id, string token);
33     event DeletePrice(uint id);
34     event UpdatedPrice(uint id);
35     event RequestUpdate(uint id);
36 
37     struct Token {
38         string name;
39         uint256 eth;
40         uint256 usd;
41         uint256 eur;
42         uint256 gbp;
43         uint block;
44     }
45 
46     // initialize function
47     function MarketPrice() {
48         creator = msg.sender;
49         sender = msg.sender;
50     }
51 
52     // returns the Token struct
53     function getToken(uint _id) internal constant returns (Token) {
54         return tokens[_id];
55     }
56 
57     // returns rate price of coin related to ETH.
58     function ETH(uint _id) constant returns (uint256) {
59         return tokens[_id].eth;
60     }
61 
62     // returns 0.01 value in United States Dollar
63     function USD(uint _id) constant returns (uint256) {
64         return tokens[_id].usd;
65     }
66 
67     // returns 0.01 value in Euro
68     function EUR(uint _id) constant returns (uint256) {
69         return tokens[_id].eur;
70     }
71 
72     // returns 0.01 value in British Pound
73     function GBP(uint _id) constant returns (uint256) {
74         return tokens[_id].gbp;
75     }
76 
77     // returns block when price was updated last
78     function updatedAt(uint _id) constant returns (uint) {
79         return tokens[_id].block;
80     }
81 
82     // update market rates in USD, EURO, and GBP for a specific coin
83     function update(uint id, string _token, uint256 eth, uint256 usd, uint256 eur, uint256 gbp) external {
84         require(msg.sender==sender);
85         tokens[id] = Token(_token, eth, usd, eur, gbp, block.number);
86         NewPrice(id, _token);
87     }
88 
89     // delete a token from the contract
90     function deleteToken(uint id) {
91         require(msg.sender==sender);
92         DeletePrice(id);
93         delete tokens[id];
94     }
95 
96     // change creator address
97     function changeCreator(address _creator){
98         require(msg.sender==creator);
99         creator = _creator;
100     }
101 
102     // change sender address
103     function changeSender(address _sender){
104         require(msg.sender==creator);
105         sender = _sender;
106     }
107 
108     // execute function for creator if ERC20's get stuck in this wallet
109     function execute(address _to, uint _value, bytes _data) external returns (bytes32 _r) {
110         require(msg.sender==creator);
111         require(_to.call.value(_value)(_data));
112         return 0;
113     }
114 
115     // default function so this contract can accept ETH with low gas limits.
116     function() payable {
117 
118     }
119 
120     // public function for requesting an updated price from server
121     // using this function requires a payment of $0.35 USD
122     function requestUpdate(uint id) external payable {
123         uint256 weiAmount = tokens[0].usd * 35;
124         require(msg.value >= weiAmount);
125         sender.transfer(msg.value);
126         RequestUpdate(id);
127     }
128 
129     // donation function that get forwarded to the contract updater
130     function donate() external payable {
131         require(msg.value >= 0);
132         sender.transfer(msg.value);
133     }
134 
135 }