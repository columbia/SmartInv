1 pragma solidity ^0.4.18;
2 
3 /*
4  * Ownable
5  * Base contract with an owner.
6  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
7  */
8 contract Ownable {
9     address public owner;
10 
11     function Ownable() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner() {
16         if (msg.sender != owner) {
17             revert();
18         }
19         _;
20     }
21 
22     function transferOwnership(address newOwner) internal onlyOwner {
23         if (newOwner != address(0)) {
24             owner = newOwner;
25         }
26     }
27 }
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 /**
61  * @title TradeFeeCalculator - Returns the calculated Fee Based on the Trade Value   
62  * @dev Fee Calculation contract. All the units are dealt at wei level.
63  * @author Dinesh
64  */
65 contract TradeFeeCalculator is Ownable { 
66     using SafeMath for uint256; 
67     
68     // array to store optional fee by category: 0 - Base Token Fee, 1 - Ether Fee, 2 - External token Fee
69     // its numbers and its for every 1 token/1 Ether (should be only wei values)
70     uint256[3] public exFees;
71     
72     /**
73      * @dev constructor sets up owner
74      */
75     function TradeFeeCalculator() public {
76         // set up the owner
77         owner = msg.sender; 
78     }
79     
80     /**
81      * @dev function updates the fees charged by the exchange. Fees will be mentioned per Ether (3792 Wand) 
82      * @param _baseTokenFee is for the trades who pays fees in Native Tokens
83      */
84     function updateFeeSchedule(uint256 _baseTokenFee, uint256 _etherFee, uint256 _normalTokenFee) public onlyOwner {
85         // Base token fee should not exceed 1 ether worth of tokens (ex: 3792 wand = 1 ether), since 1 ether is our fee unit
86         require(_baseTokenFee >= 0 && _baseTokenFee <=  1 * 1 ether);
87         
88         // If the incoming trade is on Ether, then fee should not exceed 1 Ether
89         require(_etherFee >= 0 && _etherFee <=  1 * 1 ether);
90        
91         // If the incoming trade is on diffrent coins and if the exchange should allow diff tokens as fee, then 
92         // input must be in wei converted value to suppport decimal - Special Case 
93         /** Caution: Max value check must be done by Owner who is updating this value */
94         require(_normalTokenFee >= 0);
95         require(exFees.length == 3);
96         
97         // Stores the fee structure
98         exFees[0] = _baseTokenFee;  
99         exFees[1] = _etherFee; 
100         exFees[2] = _normalTokenFee; 
101     }
102     
103     /**
104      * @dev function to calculate transaction fees for given value and token
105      * @param _value is the given trade overall value
106      * @param _feeIndex indicates token pay options
107      * @return calculated trade fee
108      * Caution: _value is expected to be in wei units and it works for single token payment
109      */
110     function calcTradeFee(uint256 _value, uint256 _feeIndex) public view returns (uint256) {
111         require(_feeIndex >= 0 && _feeIndex <= 2);
112         require(_value > 0 && _value >=  1* 1 ether);
113         require(exFees.length == 3 && exFees[_feeIndex] > 0 );
114         
115         //Calculation Formula TotalFees = (_value * exFees[_feeIndex])/ (1 ether) 
116         uint256 _totalFees = (_value.mul(exFees[_feeIndex])).div(1 ether);
117         
118         // Calculated total fee must be gretae than 0 for a given base fee > 0
119         require(_totalFees > 0);
120         
121         return _totalFees;
122     } 
123     
124     /**
125      * @dev function to calculate transaction fees for given list of values and tokens
126      * @param _values is the list of given trade overall values
127      * @param _feeIndexes indicates list token pay options for each value 
128      * @return list of calculated trade fees each value
129      * Caution: _values is expected to be in wei units and it works for multiple token payment
130      */
131     function calcTradeFeeMulti(uint256[] _values, uint256[] _feeIndexes) public view returns (uint256[]) {
132         require(_values.length > 0); 
133         require(_feeIndexes.length > 0);  
134         require(_values.length == _feeIndexes.length); 
135         require(exFees.length == 3);
136         
137         uint256[] memory _totalFees = new uint256[](_values.length);
138         // For Every token Value 
139         for (uint256 i = 0; i < _values.length; i++){  
140             _totalFees[i] =  calcTradeFee(_values[i], _feeIndexes[i]);
141         }
142         require(_totalFees.length > 0);
143         require(_values.length == _totalFees.length);  
144         return _totalFees;
145     }
146 }