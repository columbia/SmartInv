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
57 // File: contracts/whitelisting/BasicTokenWhitelist.sol
58 
59 contract BasicTokenWhitelist is TokenWhitelist {
60     constructor() public {
61         auctioneer = msg.sender;
62     }
63 }