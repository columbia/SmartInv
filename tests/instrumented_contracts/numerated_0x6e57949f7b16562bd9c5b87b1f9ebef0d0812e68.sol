1 pragma solidity ^0.5.2;
2 
3 contract FiatContract {
4 
5     mapping(uint => Token) public tokens;
6 
7     address payable public sender;
8     address public creator;
9 
10     event NewPrice(uint id, string token);
11     event DeletePrice(uint id);
12     event UpdatedPrice(uint id);
13     event RequestUpdate(uint id);
14     event Donation(address from);
15 
16     struct Token {
17         string name;
18         uint256 eth;
19         uint256 usd;
20         uint256 eur;
21         uint256 mxn;
22         uint timestamp;
23     }
24 
25     // initialize function
26     constructor(address payable _sender)public {
27         creator = msg.sender;
28         sender = _sender; //here can hardcode the address of account in server
29     }
30 
31     // returns the Token struct
32     function getToken(uint _id) internal view returns  (Token memory) {
33         return  tokens[_id];
34     }
35 
36     // returns rate price of coin related to ETH.
37     function ETH(uint _id) public view returns  (uint256) {
38         return tokens[_id].eth;
39     }
40 
41     // returns 0.01 value in United States Dollar
42     function USD(uint _id) public view returns (uint256) {
43         return tokens[_id].usd;
44     }
45 
46     // returns 0.01 value in Euro
47     function EUR(uint _id) public view returns (uint256) {
48         return tokens[_id].eur;
49     }
50 
51     // returns 0.01 value in Mexican pesos
52     function MXN(uint _id) public view returns (uint256) {
53         return tokens[_id].mxn;
54     }
55 
56     // returns block when price was updated last
57     function updatedAt(uint _id)public view returns (uint) {
58         return tokens[_id].timestamp;
59     }
60 
61     // update market rates in USD, EURO, and MXN for a specific coin
62     function update(uint id, string calldata _token, uint256 eth, uint256 usd, uint256 eur, uint256 mxn) external {
63         require(msg.sender==sender);
64         tokens[id] = Token(_token, eth, usd, eur, mxn, now);
65         emit NewPrice(id, _token);
66     }
67     /**
68      * 1 criptocrew= $30,000 MXN
69      * 1 criptocrew =~ $1,500 USD
70      * 1 criptocrew =~ $1,390 EUR 
71      * 1 criptocrew =~ 15 ETH
72      */
73 
74     // delete a token from the contract
75     function deleteToken(uint id) public {
76         require(msg.sender==creator);
77         emit DeletePrice(id);
78         delete tokens[id];
79     }
80 
81     // change creator address
82     function changeCreator(address _creator)public{
83         require(msg.sender==creator);
84         creator = _creator;
85     }
86 
87     // change sender address
88     function changeSender(address payable _sender)public{
89         require(msg.sender==creator);
90         sender = _sender;
91     }
92 
93 
94     // default function so this contract can accept ETH with low gas limits.
95     function() external payable {
96 
97     }
98 
99     // public function for requesting an updated price from server
100     // using this function requires a payment of $0.35 USD
101     function requestUpdate(uint id) external payable {
102         uint256 weiAmount = tokens[0].usd * 35;
103         require(msg.value >= weiAmount);
104         sender.transfer(address(this).balance);
105         emit RequestUpdate(id);
106     }
107 
108     // donation function that get forwarded to the contract updater
109     function donate() external payable {
110         require(msg.value >= 0);
111         sender.transfer(address(this).balance);
112         emit Donation(msg.sender);
113     }
114 
115 }