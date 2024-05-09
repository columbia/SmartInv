1 /**
2  * Website: www.SafeInvest.co
3  *
4  * RECOMMENDED GAS LIMIT: 200000
5  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
6  */
7 
8 pragma solidity 0.4.25;
9 
10 
11 library SafeMath {
12 
13 
14     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
15         if (_a == 0) {
16             return 0;
17         }
18 
19         uint256 c = _a * _b;
20         require(c / _a == _b);
21 
22         return c;
23     }
24 
25     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26         require(_b > 0);
27         uint256 c = _a / _b;
28 
29         return c;
30     }
31 
32     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
33         require(_b <= _a);
34         uint256 c = _a - _b;
35 
36         return c;
37     }
38 
39     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
40         uint256 c = _a + _b;
41         require(c >= _a);
42 
43         return c;
44     }
45 
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b != 0);
48         return a % b;
49     }
50 }
51 
52 contract SafeInvest {
53     
54 	using SafeMath for uint;
55 
56     address public owner;
57     address marketing = 0x906Bd47Fcf07F82B98F28d1e572cA8D2273AA7CD;
58     address admin = 0x1675bEACF5EB5e4e5955121b411Cd3Bc175989a8;
59 
60     mapping (address => uint) deposit;
61     mapping (address => uint) checkpoint;
62     mapping (address => bool) commission; 
63 
64     mapping (address => address) referrers;
65 
66     event LogInvestment(address indexed _addr, uint _value);
67     event LogPayment(address indexed _addr, uint _value);
68 	event LogReferralPayment(address indexed _referral, address indexed _referrer, uint _value);
69 
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     function renounceOwnership() external {
75         require(msg.sender == owner);
76         owner = 0x0;
77     }
78 
79     function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {
80         assembly {
81             parsedreferrer := mload(add(_source,0x14))
82         }
83         return parsedreferrer;
84     }
85 
86     function() external payable {
87         if (msg.value >= 0 && msg.value < 0.0000002 ether) {
88             withdraw(0);
89         } 
90 		else if (msg.value == 0.0000002 ether){
91             moneyBack();
92         } 
93 		else {
94             invest();
95         }		
96     }
97 	
98     function invest() public payable {
99         require(msg.value >= 0.01 ether);
100 		
101         if (deposit[msg.sender] > 0) {
102             withdraw(msg.value);
103         }
104 		
105         if (msg.data.length == 20) {
106             address _referrer = bytesToAddress(bytes(msg.data));
107 			if (_referrer != msg.sender) {
108 				referrers[msg.sender] = _referrer;
109 			}
110         }		
111 		
112 		checkpoint[msg.sender] = block.timestamp;
113 		deposit[msg.sender] = deposit[msg.sender].add(msg.value);
114 		
115 		emit LogInvestment(msg.sender, msg.value);
116 	}		
117 
118     function withdraw(uint _msgValue) internal {
119 		if (!commission[msg.sender]) {
120 			firstWithdraw(deposit[msg.sender]+_msgValue);
121 		} else if (_msgValue > 0) {
122 			payCommissions(_msgValue);
123 		}
124 		
125         uint _payout = getPayout(msg.sender);
126 
127         if (_payout > 0) {
128             msg.sender.transfer(_payout);
129             emit LogPayment(msg.sender, _payout);
130         }
131 		
132 		checkpoint[msg.sender] = block.timestamp;
133     }
134 	
135 	function firstWithdraw(uint _deposit) internal {	
136 		commission[msg.sender] = true;
137 		payCommissions(_deposit);
138 	}
139 	
140 	function moneyBack() internal {
141 		require(!commission[msg.sender]);
142 		require(deposit[msg.sender] > 0);
143 		require((block.timestamp.sub(checkpoint[msg.sender])).div(7 days) < 7);
144 		
145 		msg.sender.transfer(deposit[msg.sender]);
146 		
147 		deposit[msg.sender] = 0;
148 		commission[msg.sender] = false;
149 	}
150 
151 	function payCommissions(uint _deposit) internal {	
152 		uint _admFee = _deposit.mul(3).div(100); 
153 		uint _marketingFee = _deposit.div(10); 
154         if (referrers[msg.sender] > 0) {
155 			uint _refFee = _deposit.mul(5).div(100);
156 			referrers[msg.sender].transfer(_refFee);
157 			emit LogReferralPayment(msg.sender, referrers[msg.sender], _refFee);
158 		}
159 		
160 		admin.transfer(_admFee);
161 		marketing.transfer(_marketingFee);
162 	}
163 		
164     function getPayout(address _address) public view returns(uint) {
165 		uint rate = getInterest(_address);
166 		return (deposit[_address].mul(rate).div(100)).mul(block.timestamp.sub(checkpoint[_address])).div(1 days);
167     }
168 	
169     function getInterest(address _address) internal view returns(uint) {
170         if (deposit[_address]<= 3 ether) {
171             return 4; 
172         } else if (deposit[_address] <= 6 ether) {
173             return 5; 
174         } else {
175             return 6; 
176         }
177     }	
178 
179 
180 }