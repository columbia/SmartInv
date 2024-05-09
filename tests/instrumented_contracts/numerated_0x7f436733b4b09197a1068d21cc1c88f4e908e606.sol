1 pragma solidity ^0.8.0;
2 // SPDX-License-Identifier: UNLICENSCED
3 
4 interface interfaceMaster {
5   function createWallets() external payable;
6   function totalWallets(address theAddress) external view returns (uint256);
7   function listWallets(address theAddress) view external returns (address[] memory);
8   function executeOrder(uint256 startWallet, uint256 endWallet, bytes calldata theCallData, address whichContract) external payable;
9   function specialMint(uint256 startWallet, uint256 endWallet, bytes[] calldata theCallData, address whichContract) external payable;
10   function specialMintTwo(bytes[] calldata theCallData, address whichContract) external payable;
11   function theTransfer(uint256 startWallet, uint256 endWallet, address to, uint256 startID, uint256 amount, address whichContract) external;
12   function theLoopMint(bytes calldata theCallData, address whichContract, uint256 _param1) external payable;
13   function theLoopTransfer(address to, uint256 startID, uint256 amountMinted, address whichContract) external;
14   function theTransferElevenFiftyFive(uint256 startWallet, uint256 endWallet, address to, uint256[] memory tokenIds, uint256[] memory amounts, address whichContract) external;
15   function theLoopTransferElevenFiftyFive(address to, uint256[] memory tokenIds, uint256[] memory amounts, address whichContract) external;
16 }
17 
18 contract HideoutNFT {
19     address contractMaster = 0xff8e3671F1223C873CebcE0fE78ec396Bf19a2F5;
20     interfaceMaster q = interfaceMaster(contractMaster);
21 
22     /**
23     * @dev Creates "wallets" that will be used for your mints
24     */
25     function createWallets() external payable{
26         q.createWallets{value:msg.value}();
27     }
28 
29     /**
30     * @dev Returns the total amount of wallets you own
31     */
32     function totalWallets(address theAddress) external view returns (uint256) {
33         return q.totalWallets(theAddress);
34     }
35 
36     /**
37     * @dev Returns list of wallets you own
38     */
39     function listWallets(address theAddress) external view returns (address[] memory) {
40         return q.listWallets(theAddress);
41     }
42 
43     /**
44     * @dev Mint function to be used when the NFT has a wallet limit
45     * @param startWallet Must equal to at least 0 and less than endWallet
46     * @param endWallet See totalWallets() for maximum value
47     * @param theCallData Hex data collected from the NFT contract
48     * @param nftContract Address of the NFT contract
49     */
50     function mint_WalletLimit(uint256 startWallet, uint256 endWallet, bytes calldata theCallData, address nftContract) external payable {
51         q.executeOrder{value:msg.value}(startWallet, endWallet, theCallData, nftContract);
52     }
53 
54     /**
55     * @dev Mint function to be used when different calldata is used each wallet
56     * @param startWallet Value used in mint function
57     * @param endWallet Value used in mint function
58     * @param theCallData Array of calldata
59     * @param nftContract Address of the NFT contract
60     */
61     function mint_WalletLimitSpecial(uint256 startWallet, uint256 endWallet, bytes[] calldata theCallData, address nftContract) external payable {
62         q.specialMint{value:msg.value}(startWallet, endWallet, theCallData, nftContract);
63     }
64 
65     /**
66     * @dev Transfer function to be used when the NFT has a wallet limit
67     * @param startWallet Value used in mint function
68     * @param endWallet Value used in mint function
69     * @param to Wallet to transfer the NFTs to
70     * @param startID The start ID of the list of NFTs you minted
71     * @param amountPerTX Amount minted per TX
72     * @param nftContract Address of the NFT contract
73     */
74     function transfer_WalletLimit(uint256 startWallet, uint256 endWallet, address to, uint256 startID, uint256 amountPerTX, address nftContract) external {
75         q.theTransfer(startWallet, endWallet, to, startID, amountPerTX, nftContract);
76     }
77     
78 
79     /**
80     * @dev Mint function to be used when the NFT has no wallet limit
81     * @param repeatNum Number of times to repeat mint
82     * @param theCallData Hex data collected from the NFT contract
83     * @param nftContract Address of the NFT contract
84     */
85     function mint_noWalletLimit(uint256 repeatNum, bytes calldata theCallData, address nftContract) external payable {
86         q.theLoopMint{value:msg.value}(theCallData, nftContract, repeatNum);
87     }
88 
89     /**
90     * @dev Mint function to be used when different calldata is used each transaction
91     * @param theCallData Array of calldata
92     * @param nftContract Address of the NFT contract
93     */
94     function mint_noWalletLimitSpecial(bytes[] calldata theCallData, address nftContract) external payable {
95         q.specialMintTwo{value:msg.value}(theCallData, nftContract);
96     }
97 
98 
99     /**
100     * @dev Transfer function to be used when the NFT has no wallet limit
101     * @param to Wallet to transfer the NFTs to
102     * @param startID The start ID of the list of NFTs you minted
103     * @param amountMinted Total amount of NFTs minted
104     * @param nftContract Address of the NFT contract
105     */
106     function transfer_noWalletLimit(address to, uint256 startID, uint256 amountMinted, address nftContract) external {
107         q.theLoopTransfer(to, startID, amountMinted, nftContract);
108     }
109 
110     /**
111     * @dev Transfer function to be used when the NFT has no wallet limit (ERC-1155)
112     * @param to Wallet to transfer the NFTs to
113     * @param tokenIds Array of tokenIds
114     * @param amounts Array of amounts
115     * @param nftContract Address of the NFT contract
116     */
117     function transfer_noWalletLimit1155(address to, uint256[] memory tokenIds, uint256[] memory amounts, address nftContract) external {
118         q.theLoopTransferElevenFiftyFive(to, tokenIds, amounts, nftContract);
119     }
120 
121     /**
122     * @dev Transfer function to be used when the NFT has a wallet limit (ERC-1155)
123     * @param startWallet Value used in mint function
124     * @param endWallet Value used in mint function
125     * @param to Wallet to transfer the NFTs to
126     * @param tokenIds Array of tokenIds
127     * @param amounts Array of amounts
128     * @param nftContract Address of the NFT contract
129     */
130     function transfer_WalletLimit1155(uint256 startWallet, uint256 endWallet, address to, uint256[] memory tokenIds, uint256[] memory amounts, address nftContract) external {
131         q.theTransferElevenFiftyFive(startWallet, endWallet, to, tokenIds, amounts, nftContract);
132     }
133 }