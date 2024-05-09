1 pragma solidity ^0.4.25; 
2 
3 
4 
5 contract EtherGarden{
6 
7 	mapping (uint256 => uint256) public VegetablesTradeBalance;
8  	mapping (address => mapping (uint256 => uint256)) public OwnerVegetableStartGrowing;
9  	mapping (address => mapping (uint256 => uint256)) public OwnerVegetableFieldSize;
10 	mapping (address => address) public Referrals;
11 
12 	uint256 VegetableCount=4;
13 	uint256 minimum=0.0001 ether;
14 	uint256 growingSpeed=86400; //1 day
15 	uint256 public FreeFieldSize=50;
16 
17 	bool public initialized=false;
18 	address public coOwner;
19 	
20 	
21     /**
22      * @dev Сonstructor Sets the original roles of the contract 
23      */
24      
25     constructor() public {
26         coOwner=msg.sender;
27     }
28 	
29     /**
30      * @dev Modifiers
31      */	
32 	 
33     modifier onlyOwner() {
34         require(msg.sender == coOwner);
35         _;
36     }
37     modifier isInitialized() {
38         require(initialized);
39         _;
40     }	
41 
42     /**
43      * @dev Market functions
44      */		
45 
46     function sellVegetables(uint256 _VegetableId) public isInitialized {
47         require(_VegetableId < VegetableCount);
48 		
49 		uint256 value=vegetablesValue(_VegetableId);
50         if (value>0) {
51 			uint256 price=SafeMath.mul(vegetablePrice(_VegetableId),value);
52 			uint256 fee=devFee(price);
53 			
54 			OwnerVegetableStartGrowing[msg.sender][_VegetableId]=now;
55 			VegetablesTradeBalance[_VegetableId]=SafeMath.add(VegetablesTradeBalance[_VegetableId],value);
56 			
57 			coOwner.transfer(fee);
58 			msg.sender.transfer(SafeMath.sub(price,fee));
59 		}
60     }	 
61 	
62     function buyField(uint256 _VegetableId, address _referral) public payable isInitialized {
63         require(_VegetableId < VegetableCount);
64 		require(msg.value > minimum);
65 		
66 		uint256 acres=SafeMath.div(msg.value,fieldPrice(msg.value));
67         
68 		if (OwnerVegetableStartGrowing[msg.sender][_VegetableId]>0)
69 			sellVegetables(_VegetableId);
70 		
71 		OwnerVegetableStartGrowing[msg.sender][_VegetableId]=now;
72 		OwnerVegetableFieldSize[msg.sender][_VegetableId]=SafeMath.add(OwnerVegetableFieldSize[msg.sender][_VegetableId],acres);
73 		VegetablesTradeBalance[_VegetableId]=SafeMath.add(VegetablesTradeBalance[_VegetableId],acres);
74 		
75         uint256 fee=devFee(msg.value);
76 		coOwner.transfer(fee);
77 		
78 		if (address(_referral)>0 && address(_referral)!=msg.sender && Referrals[msg.sender]==address(0)) {
79 			Referrals[msg.sender]=_referral;
80 		}
81 		if (Referrals[msg.sender]!=address(0)) {
82 		    address refAddr=Referrals[msg.sender];
83 			refAddr.transfer(fee);
84 		}
85 		
86     }
87 	 
88 	function reInvest(uint256 _VegetableId) public isInitialized {
89 		require(_VegetableId < VegetableCount);
90 		uint256 value=vegetablesValue(_VegetableId);
91 		require(value>0);
92 		
93 		OwnerVegetableFieldSize[msg.sender][_VegetableId]=SafeMath.add(OwnerVegetableFieldSize[msg.sender][_VegetableId],value);
94 		OwnerVegetableStartGrowing[msg.sender][_VegetableId]=now;
95 	}
96 	
97     function getFreeField(uint256 _VegetableId) public isInitialized {
98 		require(OwnerVegetableFieldSize[msg.sender][_VegetableId]==0);
99 		OwnerVegetableFieldSize[msg.sender][_VegetableId]=FreeFieldSize;
100 		OwnerVegetableStartGrowing[msg.sender][_VegetableId]=now;
101 		
102     }
103 	
104     function initMarket(uint256 _init_value) public payable onlyOwner{
105         require(!initialized);
106         initialized=true;
107 
108 		for (uint256 vegetableId=0; vegetableId<VegetableCount; vegetableId++)
109 			VegetablesTradeBalance[vegetableId]=_init_value;
110     }	
111 	
112     /**
113      * @dev Views
114      */		
115 	 
116     function vegetablePrice(uint256 _VegetableId) public view returns(uint256){
117 		return SafeMath.div(SafeMath.div(address(this).balance,VegetableCount),VegetablesTradeBalance[_VegetableId]);
118     }
119 
120     function vegetablesValue(uint256 _VegetableId) public view returns(uint256){
121 		//1 acre gives 1 vegetable per day
122 		return SafeMath.div(SafeMath.mul(OwnerVegetableFieldSize[msg.sender][_VegetableId], SafeMath.sub(now,OwnerVegetableStartGrowing[msg.sender][_VegetableId])),growingSpeed);		
123     }	
124 	
125     function fieldPrice(uint256 subValue) public view returns(uint256){
126 	    uint256 CommonTradeBalance;
127 		
128 		for (uint256 vegetableId=0; vegetableId<VegetableCount; vegetableId++)
129 			CommonTradeBalance=SafeMath.add(CommonTradeBalance,VegetablesTradeBalance[vegetableId]);
130 		
131 		return SafeMath.div(SafeMath.sub(address(this).balance,subValue), CommonTradeBalance);
132     }
133 	
134 	function devFee(uint256 _amount) internal pure returns(uint256){
135         return SafeMath.div(SafeMath.mul(_amount,4),100);
136     }
137 	
138 }
139 
140 library SafeMath {
141 
142   /**
143   * @dev Multiplies two numbers, throws on overflow.
144   */
145   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146     if (a == 0) {
147       return 0;
148     }
149     uint256 c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   /**
155   * @dev Integer division of two numbers, truncating the quotient.
156   */
157   function div(uint256 a, uint256 b) internal pure returns (uint256) {
158     // assert(b > 0); // Solidity automatically throws when dividing by 0
159     uint256 c = a / b;
160     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161     return c;
162   }
163 
164   /**
165   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
166   */
167   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168     assert(b <= a);
169     return a - b;
170   }
171 
172   /**
173   * @dev Adds two numbers, throws on overflow.
174   */
175   function add(uint256 a, uint256 b) internal pure returns (uint256) {
176     uint256 c = a + b;
177     assert(c >= a);
178     return c;
179   }
180 }