1 pragma solidity 0.4.15;
2 
3 /*
4 
5     Crypto Market Prices via Ethereum Smart Contract
6 
7     A community driven smart contract that lets your contracts use fiat
8     amounts in USD, EURO, and GBP. Need to charge $10.50 for a contract call?
9     With this contract, you can convert ETH and other crypto's.
10 
11     Repo: https://github.com/hunterlong/fiatcontract
12     Website: https://fiatcontract.com
13 
14     Examples:
15 
16       FiatContract price = FiatContract(CONTRACT_ADDRESS);
17 
18       uint256 ethCent = price.USD(0);        // returns $0.01 worth of ETH in USD.
19       uint256 weiAmount = ethCent * 2500     // returns $25.00 worth of ETH in USD
20       require(msg.value == weiAmount);       // require $25.00 worth of ETH as a payment
21       
22     Please look at Repo or Website to get Currency ID values.
23 
24     @author Hunter Long
25 */
26 
27 contract FiatContract {
28 
29     mapping(uint => Token) public tokens;
30 
31     address public sender;
32     address public creator;
33 
34     event NewPrice(uint id, string token);
35     event DeletePrice(uint id);
36     event UpdatedPrice(uint id);
37     event RequestUpdate(uint id);
38     event Donation(address from);
39 
40     struct Token {
41         string name;
42         uint256 eth;
43         uint256 usd;
44         uint256 eur;
45         uint256 gbp;
46         uint block;
47     }
48 
49     // initialize function
50     function FiatContract() {
51         creator = msg.sender;
52         sender = msg.sender;
53     }
54 
55     // returns the Token struct
56     function getToken(uint _id) internal constant returns (Token) {
57         return tokens[_id];
58     }
59 
60     // returns rate price of coin related to ETH.
61     function ETH(uint _id) constant returns (uint256) {
62         return tokens[_id].eth;
63     }
64 
65     // returns 0.01 value in United States Dollar
66     function USD(uint _id) constant returns (uint256) {
67         return tokens[_id].usd;
68     }
69 
70     // returns 0.01 value in Euro
71     function EUR(uint _id) constant returns (uint256) {
72         return tokens[_id].eur;
73     }
74 
75     // returns 0.01 value in British Pound
76     function GBP(uint _id) constant returns (uint256) {
77         return tokens[_id].gbp;
78     }
79 
80     // returns block when price was updated last
81     function updatedAt(uint _id) constant returns (uint) {
82         return tokens[_id].block;
83     }
84 
85     // update market rates in USD, EURO, and GBP for a specific coin
86     function update(uint id, string _token, uint256 eth, uint256 usd, uint256 eur, uint256 gbp) external {
87         require(msg.sender==sender);
88         tokens[id] = Token(_token, eth, usd, eur, gbp, block.number);
89         NewPrice(id, _token);
90     }
91 
92     // delete a token from the contract
93     function deleteToken(uint id) {
94         require(msg.sender==creator);
95         DeletePrice(id);
96         delete tokens[id];
97     }
98 
99     // change creator address
100     function changeCreator(address _creator){
101         require(msg.sender==creator);
102         creator = _creator;
103     }
104 
105     // change sender address
106     function changeSender(address _sender){
107         require(msg.sender==creator);
108         sender = _sender;
109     }
110 
111     // execute function for creator if ERC20's get stuck in this wallet
112     function execute(address _to, uint _value, bytes _data) external returns (bytes32 _r) {
113         require(msg.sender==creator);
114         require(_to.call.value(_value)(_data));
115         return 0;
116     }
117 
118     // default function so this contract can accept ETH with low gas limits.
119     function() payable {
120 
121     }
122 
123     // public function for requesting an updated price from server
124     // using this function requires a payment of $0.35 USD
125     function requestUpdate(uint id) external payable {
126         uint256 weiAmount = tokens[0].usd * 35;
127         require(msg.value >= weiAmount);
128         sender.transfer(msg.value);
129         RequestUpdate(id);
130     }
131 
132     // donation function that get forwarded to the contract updater
133     function donate() external payable {
134         require(msg.value >= 0);
135         sender.transfer(msg.value);
136         Donation(msg.sender);
137     }
138 
139 }