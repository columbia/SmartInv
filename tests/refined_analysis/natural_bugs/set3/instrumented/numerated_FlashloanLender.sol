1 pragma solidity ^0.5.16;
2 import "./CCollateralCapErc20.sol";
3 import "./CErc20.sol";
4 import "./Comptroller.sol";
5 
6 interface CERC20Interface {
7     function underlying() external view returns (address);
8 }
9 
10 contract FlashloanLender is ERC3156FlashLenderInterface {
11     /**
12      * @notice underlying token to cToken mapping
13      */
14     mapping(address => address) public underlyingToCToken;
15 
16     /**
17      * @notice C.R.E.A.M. comptroller address
18      */
19     address public comptroller;
20 
21     address public owner;
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner, "not owner");
28         _;
29     }
30 
31     constructor(address _comptroller, address _owner) public {
32         comptroller = _comptroller;
33         owner = _owner;
34         initialiseUnderlyingMapping();
35     }
36 
37     function maxFlashLoan(address token) external view returns (uint256) {
38         address cToken = underlyingToCToken[token];
39         uint256 amount = 0;
40         if (cToken != address(0)) {
41             amount = CCollateralCapErc20(cToken).maxFlashLoan();
42         }
43         return amount;
44     }
45 
46     function flashFee(address token, uint256 amount) external view returns (uint256) {
47         address cToken = underlyingToCToken[token];
48         require(cToken != address(0), "cannot find cToken of this underlying in the mapping");
49         return CCollateralCapErc20(cToken).flashFee(amount);
50     }
51 
52     function flashLoan(
53         ERC3156FlashBorrowerInterface receiver,
54         address token,
55         uint256 amount,
56         bytes calldata data
57     ) external returns (bool) {
58         address cToken = underlyingToCToken[token];
59         require(cToken != address(0), "cannot find cToken of this underlying in the mapping");
60         return CCollateralCapErc20(cToken).flashLoan(receiver, msg.sender, amount, data);
61     }
62 
63     function transferOwnership(address newOwner) external onlyOwner {
64         require(newOwner != address(0), "new owner cannot be zero address");
65         owner = newOwner;
66     }
67 
68     function updateUnderlyingMapping(CToken[] calldata cTokens) external onlyOwner returns (bool) {
69         uint256 cTokenLength = cTokens.length;
70         for (uint256 i = 0; i < cTokenLength; i++) {
71             CToken cToken = cTokens[i];
72             address underlying = CErc20(address(cToken)).underlying();
73             underlyingToCToken[underlying] = address(cToken);
74         }
75         return true;
76     }
77 
78     function removeUnderlyingMapping(CToken[] calldata cTokens) external onlyOwner returns (bool) {
79         uint256 cTokenLength = cTokens.length;
80         for (uint256 i = 0; i < cTokenLength; i++) {
81             CToken cToken = cTokens[i];
82             address underlying = CErc20(address(cToken)).underlying();
83             underlyingToCToken[underlying] = address(0);
84         }
85         return true;
86     }
87 
88     /*** Internal Functions ***/
89 
90     function compareStrings(string memory a, string memory b) private pure returns (bool) {
91         return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
92     }
93 
94     function initialiseUnderlyingMapping() internal {
95         CToken[] memory cTokens = Comptroller(comptroller).getAllMarkets();
96         uint256 cTokenLength = cTokens.length;
97         for (uint256 i = 0; i < cTokenLength; i++) {
98             CToken cToken = cTokens[i];
99             if (compareStrings(cToken.symbol(), "crETH")) {
100                 continue;
101             }
102             address underlying = CErc20(address(cToken)).underlying();
103             underlyingToCToken[underlying] = address(cToken);
104         }
105     }
106 }
