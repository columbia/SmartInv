1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
5     if (_a == 0) {
6       return 0;
7     }
8     c = _a * _b;
9     assert(c / _a == _b);
10     return c;
11   }
12 
13   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     return _a / _b;
15   }
16 
17   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
18     assert(_b <= _a);
19     return _a - _b;
20   }
21 
22   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
23     c = _a + _b;
24     assert(c >= _a);
25     return c;
26   }
27 }
28 
29 contract SmartRock {
30     using SafeMath for uint256;
31     uint constant public MINIMUM_INVEST = 1000000000000000 wei;
32     uint constant public MAXIMUM_INVEST = 50000000000000000000 wei;
33     uint constant public PERCENT_STEP1 = 250000000000000000000 wei;
34     uint constant public PERCENT_STEP2 = 500000000000000000000 wei;
35     uint constant public PERCENT_STEP3 = 750000000000000000000 wei;
36     uint constant public PERCENT_STEP4 = 1000000000000000000000 wei;
37     mapping (address => uint256) blocksData;
38     mapping (address => uint256) deposits;
39     mapping (address => uint256) referals;
40     mapping (address => uint256) referalsData;
41     address ad = 0x4F51785F0Fb33f869728dA547181a8F20F8c433E;
42     address income = 0x15781b8d632A1B158B85d98418E2CA0219D6f675;
43     
44 	function() payable public {
45 	    get();
46 	}
47 	
48 	function get() payable public {
49 	    require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.001 ether");
50 	    require(msg.value <= MAXIMUM_INVEST, "Too big amount, max 1 ether");
51 	    uint256 refPercent;
52 	    uint256 refpay;
53 	    uint256 percent;
54 	    percent = getPercent();
55 	    
56 	    if(deposits[msg.sender] != 0 && now > blocksData[msg.sender] + 1200) {
57     	    uint256 paymount;
58     	    paymount = deposits[msg.sender].mul(percent).div(10000).mul(getBlockTime(msg.sender)).div(86400);
59 	        msg.sender.transfer(paymount);
60 	        
61 	        if(referals[msg.sender] != 0) {
62 	            refpay = referals[msg.sender].mul(percent).div(10000).mul(2).div(100).mul(getRefTime(msg.sender)).div(86400);
63             	referalsData[msg.sender] = now;
64             	msg.sender.transfer(refpay);
65 	        }
66 	    } 
67 	    
68 	    deposits[msg.sender] += msg.value; 
69 	    blocksData[msg.sender] = now;
70 	    address ref = bytesToAddress(msg.data);
71 	    
72 	    ad.transfer(msg.value.div(100).mul(10));
73 	    income.transfer(msg.value.div(100).mul(5));
74 	    
75 	    if (ref > 0x0 && ref != msg.sender) {
76             if(referals[ref] != 0) {
77             	refpay = referals[ref].mul(percent).div(10000).mul(2).div(100).mul(getRefTime(ref)).div(86400);
78             	ref.transfer(refpay);
79             }
80             
81             referals[ref] += msg.value;
82             referalsData[ref] = now;
83             refPercent = msg.value.mul(3).div(100);  
84             ref.transfer(refPercent);
85             deposits[msg.sender] += msg.value.mul(1).div(100); 
86 	    }
87 	}
88 	
89     function getBalance() public view returns(uint) {
90         return address(this).balance;
91     }
92 
93     function getPercent() public view returns(uint256) {
94         uint256 balance = getBalance();
95         uint256 percent = 0;
96         if(balance > PERCENT_STEP4)
97             percent = 400; 
98         if(balance < PERCENT_STEP3)
99             percent = 350; 
100         if(balance < PERCENT_STEP2)
101             percent = 325; 
102         if(balance < PERCENT_STEP1)
103             percent = 300;
104    
105         return percent;
106     }
107     
108     function getBlockTime(address addr) public view returns(uint256) {
109         return now - blocksData[addr];
110     }
111 
112     function getRefTime(address addr) public view returns(uint256) {
113         return now - referalsData[addr];
114     }
115 
116 	function bytesToAddress(bytes bys) private pure returns (address addr) {
117 		assembly {
118 			addr := mload(add(bys, 20))
119 		}
120 	}
121 }