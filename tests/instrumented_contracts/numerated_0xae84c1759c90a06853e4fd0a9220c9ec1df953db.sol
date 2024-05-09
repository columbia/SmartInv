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
29 contract FivePercent {
30 	using SafeMath for uint256;
31 
32 	address public constant marketingAddress = 0xbacd82fd2a77128274f68983f82c8372e06a1472;
33 
34 	mapping (address => uint256) deposited;
35 	mapping (address => uint256) withdrew;
36 	mapping (address => uint256) refearned;
37 	mapping (address => uint256) blocklock;
38 
39 	uint256 public totalDepositedWei = 0;
40 	uint256 public totalWithdrewWei = 0;
41 
42 	function() payable external
43 	{
44 		uint256 marketingPerc = msg.value.mul(5).div(100);
45 
46 		marketingAddress.transfer(marketingPerc);
47 		
48 		if (deposited[msg.sender] != 0)
49 		{
50 			address investor = msg.sender;
51 			uint256 depositsPercents = deposited[msg.sender].mul(5).div(100).mul(block.number-blocklock[msg.sender]).div(5900);
52 			investor.transfer(depositsPercents);
53 
54 			withdrew[msg.sender] += depositsPercents;
55 			totalWithdrewWei = totalWithdrewWei.add(depositsPercents);
56 		}
57 
58 		address referrer = bytesToAddress(msg.data);
59 		uint256 refPerc = msg.value.mul(5).div(100);
60 		
61 		if (referrer > 0x0 && referrer != msg.sender)
62 		{
63 			referrer.transfer(refPerc);
64 
65 			refearned[referrer] += refPerc;
66 		}
67 
68 		blocklock[msg.sender] = block.number;
69 		deposited[msg.sender] += msg.value;
70 
71 		totalDepositedWei = totalDepositedWei.add(msg.value);
72 	}
73 
74 	function userDepositedWei(address _address) public view returns (uint256)
75 	{
76 		return deposited[_address];
77     }
78 
79 	function userWithdrewWei(address _address) public view returns (uint256)
80 	{
81 		return withdrew[_address];
82     }
83 
84 	function userDividendsWei(address _address) public view returns (uint256)
85 	{
86 		return deposited[_address].mul(5).div(100).mul(block.number-blocklock[_address]).div(5900);
87     }
88 
89 	function userReferralsWei(address _address) public view returns (uint256)
90 	{
91 		return refearned[_address];
92     }
93 
94 	function bytesToAddress(bytes bys) private pure returns (address addr)
95 	{
96 		assembly {
97 			addr := mload(add(bys, 20))
98 		}
99 	}
100 }