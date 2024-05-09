1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4 
5   /**
6    * @dev set `owner` of the contract to the sender
7    */
8   address public owner = msg.sender;
9 
10   /**
11    * @dev Throws if called by any account other than the owner.
12    */
13   modifier onlyOwner() {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   /**
19    * @dev Allows the current owner to transfer control of the contract to a newOwner.
20    * @param newOwner The address to transfer ownership to.
21    */
22   function transferOwnership(address newOwner) public onlyOwner {
23     require(newOwner != address(0));      
24     owner = newOwner;
25   }
26 
27 }
28 
29 contract Data is Ownable {
30 
31     // node => its parent
32     mapping (address => address) private parent;
33 
34     // node => its status
35     mapping (address => uint8) public statuses;
36 
37     // node => sum of all his child deposits in USD cents
38     mapping (address => uint) public referralDeposits;
39 
40     // client => balance in wei*10^(-6) available for withdrawal
41     mapping(address => uint256) private balances;
42 
43     // investor => balance in wei*10^(-6) available for withdrawal
44     mapping(address => uint256) private investorBalances;
45 
46     function parentOf(address _addr) public constant returns (address) {
47         return parent[_addr];
48     }
49 
50     function balanceOf(address _addr) public constant returns (uint256) {
51         return balances[_addr] / 1000000;
52     }
53 
54     function investorBalanceOf(address _addr) public constant returns (uint256) {
55         return investorBalances[_addr] / 1000000;
56     }
57 
58     /**
59      * @dev The Data constructor to set up the first depositer
60      */
61     function Data() public {
62         // DirectorOfRegion - 7
63         statuses[msg.sender] = 7;
64     }
65 
66     function addBalance(address _addr, uint256 amount) onlyOwner public {
67         balances[_addr] += amount;
68     }
69 
70     function subtrBalance(address _addr, uint256 amount) onlyOwner public {
71         require(balances[_addr] >= amount);
72         balances[_addr] -= amount;
73     }
74 
75     function addInvestorBalance(address _addr, uint256 amount) onlyOwner public {
76         investorBalances[_addr] += amount;
77     }
78 
79     function subtrInvestorBalance(address _addr, uint256 amount) onlyOwner public {
80         require(investorBalances[_addr] >= amount);
81         investorBalances[_addr] -= amount;
82     }
83 
84     function addReferralDeposit(address _addr, uint256 amount) onlyOwner public {
85         referralDeposits[_addr] += amount;
86     }
87 
88     function setStatus(address _addr, uint8 _status) onlyOwner public {
89         statuses[_addr] = _status;
90     }
91 
92     function setParent(address _addr, address _parent) onlyOwner public {
93         parent[_addr] = _parent;
94     }
95 
96 }