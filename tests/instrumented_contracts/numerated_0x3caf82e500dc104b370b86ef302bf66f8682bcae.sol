1 contract Owned {
2     address public owner;
3     address public newOwner;
4 
5     function Owned() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         assert(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address _newOwner) public onlyOwner {
15         require(_newOwner != owner);
16         newOwner = _newOwner;
17     }
18 
19     function acceptOwnership() public {
20         require(msg.sender == newOwner);
21         emit OwnerUpdate(owner, newOwner);
22         owner = newOwner;
23         newOwner = 0x0;
24     }
25 
26     event OwnerUpdate(address _prevOwner, address _newOwner);
27 }
28 
29 contract IERC20Token {
30   function totalSupply() constant returns (uint256 totalSupply);
31   function balanceOf(address _owner) constant returns (uint256 balance) {}
32   function transfer(address _to, uint256 _value) returns (bool success) {}
33   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
34   function approve(address _spender, uint256 _value) returns (bool success) {}
35   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
36 
37   event Transfer(address indexed _from, address indexed _to, uint256 _value);
38   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 
42 contract VestingContract is Owned {
43     
44     address public withdrawalAddress;
45     address public tokenAddress;
46     
47     uint public lastBlockClaimed;
48     uint public blockDelay;
49     uint public level;
50     
51     event ClaimExecuted(uint _amount, uint _blockNumber, address _destination);
52     
53     function VestingContract() public {
54         
55         lastBlockClaimed = 6402520; 
56         blockDelay = 175680; 
57         level = 1;
58         tokenAddress = 0x574F84108a98c575794F75483d801d1d5DC861a5;
59     }
60     
61     function claimReward() public onlyOwner {
62         require(block.number >= lastBlockClaimed + blockDelay);
63         uint withdrawalAmount;
64         if (IERC20Token(tokenAddress).balanceOf(address(this)) > getReward()) {
65             withdrawalAmount = getReward();
66         }else {
67             withdrawalAmount = IERC20Token(tokenAddress).balanceOf(address(this));
68         }
69         IERC20Token(tokenAddress).transfer(withdrawalAddress, withdrawalAmount);
70         level += 1;
71         lastBlockClaimed += blockDelay;
72         emit ClaimExecuted(withdrawalAmount, block.number, withdrawalAddress);
73     }
74     
75     function getReward() internal returns (uint){
76         if (level == 1) { return  3166639968300000000000000; }
77         else if (level == 2) { return 3166639968300000000000000; }
78         else if (level == 3) { return 3166639968300000000000000; }
79         else if (level == 4) { return 3166639968300000000000000; }
80         else if (level == 5) { return 3166639968300000000000000; }
81         else if (level == 6) { return 3166639968300000000000000; }
82         else if (level == 7) { return 3166639968300000000000000; }
83         else if (level == 8) { return 3166639968300000000000000; }
84         else if (level == 9) { return 3166639968300000000000000; }
85         else if (level == 10) { return 3166639968300000000000000; }
86         else if (level == 11) { return 0;}
87         else {return 0;}
88     }
89     
90     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) public onlyOwner {
91         require(_tokenAddress != tokenAddress);
92         
93         IERC20Token(_tokenAddress).transfer(_to, _amount);
94     }
95     
96     //
97     // Setters
98     //
99 
100     function setWithdrawalAddress(address _newAddress) public onlyOwner {
101         withdrawalAddress = _newAddress;
102     }
103     
104     function setBlockDelay(uint _newBlockDelay) public onlyOwner {
105         blockDelay = _newBlockDelay;
106     }
107     
108     //
109     // Getters
110     //
111     
112     function getTokenBalance() public constant returns(uint) {
113         return IERC20Token(tokenAddress).balanceOf(address(this));
114     }
115 }