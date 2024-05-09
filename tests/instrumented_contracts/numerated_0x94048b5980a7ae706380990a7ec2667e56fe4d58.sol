1 pragma solidity ^0.5.2;
2 
3 // File: @gnosis.pm/dx-contracts/contracts/base/AuctioneerManaged.sol
4 
5 contract AuctioneerManaged {
6     // auctioneer has the power to manage some variables
7     address public auctioneer;
8 
9     function updateAuctioneer(address _auctioneer) public onlyAuctioneer {
10         require(_auctioneer != address(0), "The auctioneer must be a valid address");
11         auctioneer = _auctioneer;
12     }
13 
14     // > Modifiers
15     modifier onlyAuctioneer() {
16         // Only allows auctioneer to proceed
17         // R1
18         // require(msg.sender == auctioneer, "Only auctioneer can perform this operation");
19         require(msg.sender == auctioneer, "Only the auctioneer can nominate a new one");
20         _;
21     }
22 }
23 
24 // File: @gnosis.pm/dx-contracts/contracts/base/TokenWhitelist.sol
25 
26 contract TokenWhitelist is AuctioneerManaged {
27     // Mapping that stores the tokens, which are approved
28     // Only tokens approved by auctioneer generate frtToken tokens
29     // addressToken => boolApproved
30     mapping(address => bool) public approvedTokens;
31 
32     event Approval(address indexed token, bool approved);
33 
34     /// @dev for quick overview of approved Tokens
35     /// @param addressesToCheck are the ERC-20 token addresses to be checked whether they are approved
36     function getApprovedAddressesOfList(address[] calldata addressesToCheck) external view returns (bool[] memory) {
37         uint length = addressesToCheck.length;
38 
39         bool[] memory isApproved = new bool[](length);
40 
41         for (uint i = 0; i < length; i++) {
42             isApproved[i] = approvedTokens[addressesToCheck[i]];
43         }
44 
45         return isApproved;
46     }
47     
48     function updateApprovalOfToken(address[] memory token, bool approved) public onlyAuctioneer {
49         for (uint i = 0; i < token.length; i++) {
50             approvedTokens[token[i]] = approved;
51             emit Approval(token[i], approved);
52         }
53     }
54 
55 }
56 
57 // File: contracts/whitelisting/FixedPriceOracle.sol
58 
59 /**
60  * @title An Ether-ERC20 token price oracle with an unmutable price
61  * 
62  * @dev The prices are initialized when configuring the contract, then you 
63  *  freeze the contract disallowing any further modification.
64  */
65 
66 contract FixedPriceOracle {
67     mapping(address => Price) public prices;
68     bool public frozen;
69     address public owner;
70     TokenWhitelist public whitelist;
71 
72     modifier onlyOwner() {
73         require(msg.sender == owner, "Only the owner can do the operation");
74         _;
75     }
76 
77     modifier notFrozen() {
78         require(!frozen, "The contract is frozen, not changes are allowed");
79         _;
80     }
81 
82     struct Price {
83         uint numerator;
84         uint denominator;
85     }
86 
87     event PriceSet(address indexed token, uint numerator, uint denominator);
88 
89     event Freeze();
90 
91     constructor(address whitelistAddress) public {
92         owner = msg.sender;
93         whitelist = TokenWhitelist(whitelistAddress);
94     }
95 
96     function hasReliablePrice(address token) public view returns (bool) {
97         return prices[token].denominator != 0;
98     }
99 
100     function getPrice(address token) public view returns (uint, uint) {
101         bool approvedToken = whitelist.approvedTokens(token);
102 
103         if (approvedToken) {
104             return getPriceValue(token);
105         } else {
106             return (0, 0);
107         }
108 
109     }
110 
111     function getPriceValue(address token) public view returns (uint, uint) {
112         Price memory price = prices[token];
113         return (price.numerator, price.denominator);
114     }
115 
116     function setPrices(address[] memory tokens, uint[] memory numerators, uint[] memory denominators)
117         public
118         onlyOwner
119         notFrozen
120     {
121         for (uint i = 0; i < tokens.length; i++) {
122             address token = tokens[i];
123             uint numerator = numerators[i];
124             uint denominator = denominators[i];
125 
126             prices[token] = Price(numerator, denominator);
127             emit PriceSet(token, numerator, denominator);
128         }
129     }
130 
131     function setPrice(address token, uint numerator, uint denominator) public onlyOwner notFrozen {
132         prices[token] = Price(numerator, denominator);
133         emit PriceSet(token, numerator, denominator);
134     }
135 
136     function freeze() public onlyOwner {
137         frozen = true;
138         emit Freeze();
139     }
140 }