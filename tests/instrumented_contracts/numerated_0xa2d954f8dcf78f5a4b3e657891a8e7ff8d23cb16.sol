1 pragma solidity ^0.4.25;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     constructor() public {
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
23         emit OwnerUpdate(owner, newOwner);
24         owner = newOwner;
25         newOwner = 0x0;
26     }
27 
28     event OwnerUpdate(address _prevOwner, address _newOwner);
29 }
30 
31 contract SafeMath {
32     
33     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
34 
35     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
36         require(x <= MAX_UINT256 - y);
37         return x + y;
38     }
39 
40     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
41         require(x >= y);
42         return x - y;
43     }
44 
45     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
46         if (y == 0) {
47             return 0;
48         }
49         require(x <= (MAX_UINT256 / y));
50         return x * y;
51     }
52 }
53 
54 interface MintableTokenInterface {
55     function mint(address _to, uint256 _amount) external;
56 }
57 
58 contract MintingContract is Owned, SafeMath{
59     
60     address public tokenAddress;
61     uint256 public tokensAlreadyMinted;
62 
63     enum state { crowdsaleMinting, additionalMinting, disabled}
64     state public mintingState; 
65 
66     uint256 public crowdsaleMintingCap;
67     uint256 public tokenTotalSupply;
68     
69     constructor() public {
70         tokensAlreadyMinted = 0;
71         crowdsaleMintingCap = 22000000 * 10 ** 18;
72         tokenTotalSupply = 44000000 * 10 ** 18;
73     }
74 
75     function doCrowdsaleMinting(address _destination, uint _tokensToMint) public onlyOwner {
76         require(mintingState == state.crowdsaleMinting);
77         require(safeAdd(tokensAlreadyMinted, _tokensToMint) <= crowdsaleMintingCap);
78 
79         MintableTokenInterface(tokenAddress).mint(_destination, _tokensToMint);
80         tokensAlreadyMinted = safeAdd(tokensAlreadyMinted, _tokensToMint);
81     }
82     function doAdditionalMinting(address _destination, uint _tokensToMint) public {
83         require(mintingState == state.additionalMinting);
84         require(safeAdd(tokensAlreadyMinted, _tokensToMint) <= tokenTotalSupply);
85 
86         MintableTokenInterface(tokenAddress).mint(_destination, _tokensToMint);
87         tokensAlreadyMinted = safeAdd(tokensAlreadyMinted, _tokensToMint);
88     }
89     
90     function finishCrowdsaleMinting() onlyOwner public {
91         mintingState = state.additionalMinting;
92     }
93     
94     function disableMinting() onlyOwner public {
95         mintingState = state.disabled;
96     }
97 
98     function setTokenAddress(address _tokenAddress) onlyOwner public {
99         tokenAddress = _tokenAddress;
100     }
101     
102  
103 }