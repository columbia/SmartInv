1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public ownerAddress;
35   address public transferCreditBotAddress;
36   address public twitterBotAddress;
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40   constructor() public {
41     ownerAddress = msg.sender;
42   }
43 
44   modifier onlyOwner() {
45     require(msg.sender == ownerAddress);
46     _;
47   }
48 
49   modifier onlyTransferCreditBot() {
50       require(msg.sender == transferCreditBotAddress);
51       _;
52   }
53 
54   modifier onlyTwitterBot() {
55         require(msg.sender == twitterBotAddress);
56         _;
57     }
58 
59   function setTransferCreditBot(address _newTransferCreditBot) public onlyOwner {
60         require(_newTransferCreditBot != address(0));
61         transferCreditBotAddress = _newTransferCreditBot;
62     }
63 
64   function setTwitterBot(address _newTwitterBot) public onlyOwner {
65         require(_newTwitterBot != address(0));
66         twitterBotAddress = _newTwitterBot;
67     }
68 
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     emit OwnershipTransferred(ownerAddress, newOwner);
72     ownerAddress = newOwner;
73   }
74 
75 }
76 
77 contract EtherZaarTwitter is Ownable {
78 
79   using SafeMath for uint256;
80 
81   event addressRegistration(uint256 twitterId, address ethereumAddress);
82   event Transfer(uint256 receiverTwitterId, uint256 senderTwitterId, uint256 ethereumAmount);
83   event Withdraw(uint256 twitterId, uint256 ethereumAmount);
84   event EthereumDeposit(uint256 twitterId, address ethereumAddress, uint256 ethereumAmount);
85   event TransferCreditDeposit(uint256 twitterId, uint256 transferCredits);
86 
87   mapping (uint256 => address) public twitterIdToEthereumAddress;
88   mapping (uint256 => uint256) public twitterIdToEthereumBalance;
89   mapping (uint256 => uint256) public twitterIdToTransferCredits;
90 
91   function _addEthereumAddress(uint256 _twitterId, address _ethereumAddress) external onlyTwitterBot {
92     twitterIdToEthereumAddress[_twitterId] = _ethereumAddress;
93 
94     emit addressRegistration(_twitterId, _ethereumAddress);
95   }
96 
97   function _depositEthereum(uint256 _twitterId) external payable{
98       twitterIdToEthereumBalance[_twitterId] += msg.value;
99       emit EthereumDeposit(_twitterId, twitterIdToEthereumAddress[_twitterId], msg.value);
100   }
101 
102   function _depositTransferCredits(uint256 _twitterId, uint256 _transferCredits) external onlyTransferCreditBot{
103       twitterIdToTransferCredits[_twitterId] += _transferCredits;
104       emit TransferCreditDeposit(_twitterId, _transferCredits);
105   }
106 
107   function _transferEthereum(uint256 _senderTwitterId, uint256 _receiverTwitterId, uint256 _ethereumAmount) external onlyTwitterBot {
108       require(twitterIdToEthereumBalance[_senderTwitterId] >= _ethereumAmount);
109       require(twitterIdToTransferCredits[_senderTwitterId] > 0);
110 
111       twitterIdToEthereumBalance[_senderTwitterId] = twitterIdToEthereumBalance[_senderTwitterId] - _ethereumAmount;
112       twitterIdToTransferCredits[_senderTwitterId] = twitterIdToTransferCredits[_senderTwitterId] - 1;
113       twitterIdToEthereumBalance[_receiverTwitterId] += _ethereumAmount;
114 
115       emit Transfer(_receiverTwitterId, _senderTwitterId, _ethereumAmount);
116   }
117 
118   function _withdrawEthereum(uint256 _twitterId) external {
119       require(twitterIdToEthereumBalance[_twitterId] > 0);
120       require(twitterIdToEthereumAddress[_twitterId] == msg.sender);
121 
122       uint256 transferAmount = twitterIdToEthereumBalance[_twitterId];
123       twitterIdToEthereumBalance[_twitterId] = 0;
124 
125       (msg.sender).transfer(transferAmount);
126 
127       emit Withdraw(_twitterId, transferAmount);
128   }
129 
130   function _sendEthereum(uint256 _twitterId) external onlyTwitterBot {
131       require(twitterIdToEthereumBalance[_twitterId] > 0);
132       require(twitterIdToTransferCredits[_twitterId] > 0);
133 
134       twitterIdToTransferCredits[_twitterId] = twitterIdToTransferCredits[_twitterId] - 1;
135       uint256 sendAmount = twitterIdToEthereumBalance[_twitterId];
136       twitterIdToEthereumBalance[_twitterId] = 0;
137 
138       (twitterIdToEthereumAddress[_twitterId]).transfer(sendAmount);
139 
140       emit Withdraw(_twitterId, sendAmount);
141   }
142 }