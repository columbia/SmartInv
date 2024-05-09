1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     function Owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         assert(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address _newOwner) public onlyOwner {
17         require(_newOwner != owner);
18         newOwner = _newOwner;
19     }
20 
21     function acceptOwnership() public {
22         require(msg.sender == newOwner);
23         OwnerUpdate(owner, newOwner);
24         owner = newOwner;
25         newOwner = 0x0;
26     }
27 
28     event OwnerUpdate(address _prevOwner, address _newOwner);
29 }
30 
31 contract IERC20Token {
32   function totalSupply() constant returns (uint256 totalSupply);
33   function balanceOf(address _owner) constant returns (uint256 balance) {}
34   function transfer(address _to, uint256 _value) returns (bool success) {}
35   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
36   function approve(address _spender, uint256 _value) returns (bool success) {}
37   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
38 
39   event Transfer(address indexed _from, address indexed _to, uint256 _value);
40   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 
44 contract VestingContract is Owned {
45     
46     address public withdrawalAddress;
47     address public tokenAddress;
48     
49     uint public lastBlockClaimed;
50     uint public blockDelay;
51     uint public reward;
52     
53     event ClaimExecuted(uint _amount, uint _blockNumber, address _destination);
54     
55     function VestingContract() {
56         
57         lastBlockClaimed = 4216530;
58         blockDelay = 152470;
59         reward = 1333333000000000000000000;
60         
61         tokenAddress = 0x2C974B2d0BA1716E644c1FC59982a89DDD2fF724;
62     }
63     
64     function claimReward() public onlyOwner {
65         require(block.number >= lastBlockClaimed + blockDelay);
66         uint withdrawalAmount;
67         if (IERC20Token(tokenAddress).balanceOf(address(this)) > reward) {
68             withdrawalAmount = reward;
69         }else {
70             withdrawalAmount = IERC20Token(tokenAddress).balanceOf(address(this));
71         }
72         IERC20Token(tokenAddress).transfer(withdrawalAddress, withdrawalAmount);
73         lastBlockClaimed += blockDelay;
74         ClaimExecuted(withdrawalAmount, block.number, withdrawalAddress);
75     }
76     
77     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) public onlyOwner {
78         require(_tokenAddress != tokenAddress);
79         
80         IERC20Token(_tokenAddress).transfer(_to, _amount);
81     }
82     
83     //
84     // Setters
85     //
86 
87     function setWithdrawalAddress(address _newAddress) public onlyOwner {
88         withdrawalAddress = _newAddress;
89     }
90     
91     function setBlockDelay(uint _newBlockDelay) public onlyOwner {
92         blockDelay = _newBlockDelay;
93     }
94     
95     //
96     // Getters
97     //
98     
99     function getTokenBalance() public constant returns(uint) {
100         return IERC20Token(tokenAddress).balanceOf(address(this));
101     }
102 }