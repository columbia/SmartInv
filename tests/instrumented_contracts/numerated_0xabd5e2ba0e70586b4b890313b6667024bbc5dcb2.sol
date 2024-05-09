1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface LW0 {
5     function emitMint(address _to, string memory _tier) external;
6     function getPrice() external view returns (uint256);
7     function getAllowedTokensInBulk() external view returns (address[] memory, uint256[] memory);
8     function getRoyaltyRecipient() external view returns (address);
9 }
10 
11 interface IERC20 {                                                                                     
12     function transfer(address _to, uint256 _amount) external returns (bool);                                       
13     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);         
14     function balanceOf(address _owner) external view returns (uint256);                                 
15     function approve(address _spender, uint256 _amount) external returns (bool);                        
16     function allowance(address _owner, address _spender) external view returns (uint256);               
17 }                                                                                                       
18 
19 contract LW0Minter {
20 
21     address private owner;
22     address private ERC721ContractAddress;
23     
24     LW0 ERC721Contract;
25 
26     constructor(address _ERC721ContractAddress) {
27         owner = msg.sender;
28         ERC721ContractAddress = _ERC721ContractAddress;
29         ERC721Contract = LW0(ERC721ContractAddress);
30     }
31 
32     function manualMint(address _to, string memory _tier) public {
33         require(_to != address(0), "LW0: zero address");
34         require(msg.sender == owner, "Only owner can mint");
35         ERC721Contract.emitMint(_to, _tier);
36     }
37 
38     function mint(address _to) public payable {
39         require(_to != address(0), "LW0: zero address");
40         uint256 price = ERC721Contract.getPrice();
41         require(msg.value >= price, "Not enough ETH sent");
42         ERC721Contract.emitMint(_to, '');
43         payable(ERC721Contract.getRoyaltyRecipient()).transfer(msg.value);
44     }                                                                                                   
45 
46     function mintWithToken(address _to, address _token) public {
47         require(_to != address(0), "LW0: zero address");
48         IERC20 token = IERC20(_token);
49         (address[] memory allowedTokens, uint256[] memory allowedTokenAmounts) = ERC721Contract.getAllowedTokensInBulk();
50         uint256 tokenIndex = 0;
51         for (uint256 i = 0; i < allowedTokens.length; i++) {
52             if (allowedTokens[i] == _token) {
53                 tokenIndex = i;
54                 break;
55             }
56         }
57         require(allowedTokenAmounts[tokenIndex] > 0, "Token not allowed");
58         token.transferFrom(msg.sender, ERC721Contract.getRoyaltyRecipient(), allowedTokenAmounts[tokenIndex]);
59         ERC721Contract.emitMint(_to, '');
60     }
61 
62     function freeMint(address _to) public {
63         require(_to != address(0), "LW0: zero address");
64         require(msg.sender == owner, "Only owner can mint");
65         ERC721Contract.emitMint(_to, '');
66     }
67 }