1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity >=0.8.0;
3 
4 /**
5  * @title Swap
6  * @dev Main Swap contract that burns old token and mints new token for given user
7  */
8 
9 contract Owned {
10         address public owner;      
11 
12         constructor() {
13             owner = msg.sender;
14         }
15 
16         modifier onlyOwner {
17             assert(msg.sender == owner);
18             _;
19         }
20         
21         /* This function is used to transfer adminship to new owner
22          * @param  _newOwner - address of new admin or owner        
23          */
24 
25         function transferOwnership(address _newOwner) onlyOwner public {
26             assert(_newOwner != address(0)); 
27             owner = _newOwner;
28         }          
29 }
30 
31 contract Swapper is Owned
32 {
33     
34     ERC20 public oldToken;
35     ERC20 public newToken;
36     Burner public  burner;
37     
38     event SwapExecuted(address user, uint256 amount);
39 
40     struct VestingUnit {
41         uint256 amount;
42         uint256 timestamp;
43     }
44         
45     uint256 public approvalDeadline;
46 
47     mapping(address => VestingUnit[]) public holdersVestingData;
48     
49     function claim() public {
50         VestingUnit[] memory vestingUnits = holdersVestingData[msg.sender];
51         uint sum = 0;
52         for(uint i = 0; i < vestingUnits.length; i++) {
53             uint256 finalClaimableTime = vestingUnits[i].timestamp + findTimeMultipler(i) * 30 days + 2 weeks;
54             if(finalClaimableTime < block.timestamp){
55                 continue;
56             }
57             if(vestingUnits[i].amount > 0 && vestingUnits[i].timestamp < block.timestamp) {
58                 sum += vestingUnits[i].amount;
59                 delete holdersVestingData[msg.sender][i];
60             }
61         }
62         newToken.transfer(msg.sender, sum);
63     }
64     
65     function amountClaimable(address holder) public view returns(uint256) {
66         VestingUnit[] memory vestingUnits = holdersVestingData[holder];
67         uint sum = 0;
68         for(uint i = 0; i < vestingUnits.length; i++) {
69              uint256 finalClaimableTime = vestingUnits[i].timestamp + findTimeMultipler(i) * 30 days + 2 weeks;
70             if(finalClaimableTime < block.timestamp){
71                 continue;
72             }
73             if(vestingUnits[i].amount > 0 && vestingUnits[i].timestamp < block.timestamp) {
74                 sum += vestingUnits[i].amount;
75             }
76         }
77         return sum;
78     }
79      
80     constructor(
81         address _oldToken,
82         address _newToken,
83         address _burner,
84         uint256 _approvalDeadline
85 
86     ) {
87         approvalDeadline = _approvalDeadline;
88         oldToken = ERC20(_oldToken);
89         newToken = ERC20(_newToken);
90         burner = Burner(_burner);
91 
92     }
93 
94 
95     function updateApprovalDeadline(uint256 _approvalDeadline) onlyOwner public {
96         approvalDeadline = _approvalDeadline;
97     }
98     
99     function energencyWithdraw(uint256 _amount) onlyOwner public {
100         newToken.transfer(msg.sender,_amount);
101     }
102     
103 	function SwapNow(uint256 _val) public {
104 	    require(approvalDeadline > block.timestamp,"deadline reached");
105 	    require(oldToken.allowance(msg.sender, address(this)) >= _val,"allowance lower"); 
106 	    oldToken.transferFrom(msg.sender, address(burner), _val);
107 	    burner.burn(_val);
108 	    newToken.transfer(msg.sender, _val / 10);
109 	    
110 	    setVestingData(_val);
111 
112 	    emit SwapExecuted(msg.sender, _val);
113 	}
114 	
115 	function calculateCutPerMonth(uint256 totalAmount) private pure returns (uint256){
116 	    return totalAmount * 75/1000;
117 	}
118 	
119 	
120 	function setVestingData(uint256 _val) private {
121 	    	  
122 	    uint256 amount = calculateCutPerMonth(_val);
123 	    uint256 finalChunkAmount = _val - _val/10;
124 	    for(uint256 i=0; i < 11; i++){
125 	        uint256 vestingTimestamp = block.timestamp + 90 days + 30 days * i;
126 	        VestingUnit memory vestingData  = VestingUnit({amount:amount,timestamp:vestingTimestamp});
127 	        holdersVestingData[msg.sender].push(vestingData);
128 	        finalChunkAmount -= amount;
129 	    }
130 	    
131 	    holdersVestingData[msg.sender].push(VestingUnit({amount:finalChunkAmount,timestamp:block.timestamp + 90 days + 30 days * 11}));
132 	}
133 	
134 	
135 	function findTimeMultipler(uint256 i) private pure returns(uint256){
136 	    if((i+1)%12 == 0){
137 	        return 0 ;
138 	    }
139 	    else{
140 	        return 12 - (i+1)%12;
141 	    }
142 	}
143 	
144 
145 	function remainingClaim(address _holder) view public returns(uint256) {
146 	    VestingUnit[] memory vestingUnits = holdersVestingData[_holder];
147         uint sum = 0;
148         for(uint i = 0; i < vestingUnits.length; i++) {
149             if(vestingUnits[i].amount > 0) {
150                 sum += vestingUnits[i].amount;
151             }
152         }
153         return sum;
154 	}
155 }
156 contract Burner is Owned {
157     ERC20 oldToken;
158     
159     function returnOwnership(address _newOwner) public onlyOwner {
160         oldToken.transferOwnership(_newOwner);
161     }
162     
163     constructor(address _oldToken) {
164         oldToken = ERC20(_oldToken);
165     }
166     
167     function burn(uint256 _val) public {
168         oldToken.burn(_val);
169     }
170 }
171 
172 
173 interface ERC20 {
174     function transferOwnership(address _newOwner) external;
175     
176     function transferFrom(
177          address _from,
178          address _to,
179          uint256 _amount
180      ) external returns (bool success);
181     
182     
183     function allowance(address owner, address spender) external view returns (uint256);
184     
185     function burn(uint256 _value) external;
186     
187     function transfer(address recipient, uint256 amount) external returns (bool);
188 
189 }