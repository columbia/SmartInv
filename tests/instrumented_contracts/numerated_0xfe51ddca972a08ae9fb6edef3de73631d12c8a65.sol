1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.2;
4 
5 interface IUniswap {
6     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
7 }
8 
9 interface IERC721 {
10 
11     function mint(address to, uint32 _assetType, uint256 _value, uint32 _customDetails) external returns (bool success);
12     function assetsByType(uint256 _typeId) external view returns (uint64 _maxAmount, uint64 _mintedAmount, uint64 _coinIndex, string memory copyright);
13     function tradeCoins(uint256 coinIndex) external view returns (address _tokenAddress, string memory _symbol, string memory _name);
14 
15 }
16 contract Ownable {
17 
18     address private owner;
19     
20     event OwnerSet(address indexed oldOwner, address indexed newOwner);
21     
22     modifier onlyOwner() {
23         require(msg.sender == owner, "Caller is not owner");
24         _;
25     }
26 
27     constructor() {
28         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
29         emit OwnerSet(address(0), owner);
30     }
31 
32 
33     function changeOwner(address newOwner) public onlyOwner {
34         emit OwnerSet(owner, newOwner);
35         owner = newOwner;
36     }
37 
38     function getOwner() external view returns (address) {
39         return owner;
40     }
41 }
42 
43 contract POLN3DSeller is Ownable {
44     
45     address public nftAddress;
46     IUniswap public uniswapRouter;
47     address payable public sellingWallet;
48     uint256 slippage = 2;
49     
50     mapping(uint => uint) public assets;
51     
52     constructor() {
53         sellingWallet = payable(0xAD334543437EF71642Ee59285bAf2F4DAcBA613F);
54         nftAddress = 0xB20217bf3d89667Fa15907971866acD6CcD570C8;
55         uniswapRouter = IUniswap(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
56         assets[47] = 1000000000;
57 
58     }
59     
60     function getPrice(uint _assetType) public view returns (uint256) {
61         address[] memory path = new address[](2);
62         path[0] = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // USDT
63         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
64         uint256[] memory uprices = uniswapRouter.getAmountsOut(assets[_assetType], path);
65         return uprices[1];
66     }
67     
68     function calcMaxSlippage(uint256 _amount) public view returns (uint256) {
69         return (_amount - ((_amount * slippage) / 100));
70     }
71 
72     function buyWithEth(uint256 assetType, uint256 assetDetails) public payable returns (bool) {
73         IERC721 nft = IERC721(nftAddress);
74         (, , uint64 _coinIndex, ) = nft.assetsByType(assetType);
75         require(_coinIndex == 1 , "Invalid coin");
76         require(assets[assetType] != 0, "Invalid asset");
77         address[] memory path = new address[](2);
78         path[0] = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // USDT
79         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
80         uint256 aIn = assets[assetType];
81         uint256[] memory uprices = uniswapRouter.getAmountsOut(aIn, path);
82         uint256 sellingPrice = uprices[1];
83         require(msg.value >= (calcMaxSlippage(sellingPrice)), 'Invalid amount');
84         require(sellingWallet.send(msg.value));
85         require(nft.mint(msg.sender, uint32(assetType), sellingPrice, uint32(assetDetails)), "Not possible to mint this type of asset");
86         return true;
87     }
88     
89     function setPrice(uint256 _assetId, uint256 _newPrice) public onlyOwner {
90         assets[_assetId] = _newPrice;
91     }
92     
93     function setSlippage(uint256 _slippage) public onlyOwner {
94         slippage = _slippage;
95     }
96 
97     
98     
99 }