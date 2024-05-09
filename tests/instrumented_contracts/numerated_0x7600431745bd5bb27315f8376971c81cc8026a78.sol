1 pragma solidity ^0.4.15;
2 
3 contract BMICOAffiliateProgramm
4 {
5 	function add_referral(address referral, string promo, uint256 amount) external returns(address, uint256, uint256);
6 }
7 
8 contract BMPre_ICO {
9 	mapping (address => uint256) public holders;
10 	mapping (address => uint256) public holdersBonus;
11 	uint256 public amount_investments = 0;
12 	uint256 public amount_bonus = 0;
13 	uint256 public countHolders = 0;
14 
15 	uint256 public preIcoStart = 1503219600; //20.08.2017 12:00 MSK
16 	uint256 public preIcoEnd = 1504990800; //10.00.2017 00:00 MSK
17 	uint256 public lastCallstopPreICO = 1503219600;
18 
19 	uint256 public minSizeInvest = 100 finney;
20 
21 	address public owner;
22 	address public affiliate;
23 	BMICOAffiliateProgramm contractAffiliate;
24 
25 	event Investment(address holder, uint256 value);
26 	event EndPreICO(uint256 EndDate);
27 
28 	function BMPre_ICO()
29 	{
30 		owner = msg.sender;
31 		affiliate = address(0x0);
32 	}
33 
34 	modifier isOwner()
35 	{
36 		assert(msg.sender == owner);
37 		_;
38 	}
39 
40 	function changeOwner(address new_owner) isOwner {
41 		assert(new_owner!=address(0x0));
42 		assert(new_owner!=address(this));
43 		owner = new_owner;
44 	}
45 
46 	function setAffiliateContract(address new_address) isOwner {
47 		assert(new_address!=address(0x0));
48 		assert(new_address!=address(this));
49 		affiliate = new_address;
50 		contractAffiliate = BMICOAffiliateProgramm(new_address);
51 	}
52 
53 	function getDataHolders(address holder) external constant returns(uint256)
54 	{
55 		return holders[holder];
56 	}
57 
58 	function getDataHoldersRefBonus(address holder) external constant returns(uint256)
59 	{
60 		return holdersBonus[holder];
61 	}
62 
63 	uint256 public stopBlock = 0;
64 
65 	function stopPreIco_step1() {
66 		assert(now - lastCallstopPreICO > 12 hours);
67 		lastCallstopPreICO = now;
68 
69 		stopBlock = block.number + 5;
70 	}
71 
72 	function stopPreIco_step2()
73 	{
74 		if (stopBlock != 0 && stopBlock < block.number)
75 		{
76 			bytes32 hash = block.blockhash(stopBlock);
77 			if (uint256(hash) > 0)
78 			{
79 				uint8 value = uint8(uint256(sha3(hash, msg.sender)) % 100);
80 				uint8 limit = uint8((amount_investments*100)/100000000000000000000000);
81 
82 				if(value < limit)
83 				{
84 					if(preIcoEnd - now > 1 days)
85 					{
86 						preIcoEnd -= 1 days;
87 					}
88 					EndPreICO(preIcoEnd);
89 				}
90 			}
91 			stopBlock = 0;
92 		}
93 	}
94 
95 	function sendInvestmentsToOwner() isOwner {
96 		assert(now >= preIcoEnd);
97 		owner.transfer(this.balance);
98 	}
99 
100 	function buy(string promo) payable {
101 		assert(now < preIcoEnd);
102 		assert(now >= preIcoStart);
103 		assert(msg.value>=minSizeInvest);
104 
105 		if(holders[msg.sender] == 0){
106 			countHolders += 1;
107 		}
108 		holders[msg.sender] += msg.value;
109 		amount_investments += msg.value;
110 		Investment(msg.sender, msg.value);
111 
112 		if(affiliate != address(0x0)){
113 			var (partner_address, partner_bonus, referral_bonus) = contractAffiliate.add_referral(msg.sender, promo, msg.value);
114 			if(partner_bonus > 0 && partner_address != address(0x0)){
115 				holdersBonus[partner_address] += msg.value;
116 				amount_bonus += msg.value;
117 			}
118 			if(referral_bonus > 0){
119 				holdersBonus[msg.sender] = referral_bonus;
120 				amount_bonus += referral_bonus;
121 			}
122 		}
123 		stopPreIco_step2();
124 	}
125 
126 	function () payable {
127 		buy('');
128 	}
129 }