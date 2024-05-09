1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // MINIMAL ERC20 INTERFACE FOR QANX TRANSFERABILITY
5 interface TransferableERC20 {
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
8 }
9 
10 contract Signed {
11 
12     // THE ADDRESSES PERMITTED TO SIGN WITHDRAWAL REQUESTS UP TO X AMOUNT
13     mapping(address => uint256) internal signers;
14 
15     // SET NO LIMIT SIGNER ON DEPLOYMENT
16     constructor() {
17         signers[msg.sender] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
18     }
19 
20     // METHOD TO SET WITHDRAWAL SIGNER ADDRESSES
21     function setSigner(address signer, uint256 limit) external {
22         require(signer != address(0) && signers[msg.sender] == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
23         signers[signer] = limit;
24     }
25 
26     // METHOD TO VERIFY WITHDRAWAL SIGNATURE OF A GIVEN TXID & AMOUNT
27     function verifySignature(bytes32 txid, bytes memory signature, uint256 amount) internal view returns (bool) {
28 
29         // SIGNATURE VARIABLES FOR ECRECOVER
30         bytes32 r;
31         bytes32 vs;
32 
33         // SPLIT SIGNATURE INTO r + vs
34         assembly {
35             r := mload(add(signature, 32))
36             vs := mload(add(signature, 64))
37         }
38 
39         // DETERMINE s AND v FROM vs
40         bytes32 s = vs & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
41         uint8 v = 27 + uint8(uint256(vs) >> 255);
42 
43         // RECOVER & VERIFY SIGNER IDENTITY RELATED TO AMOUNT
44         return amount < signers[ecrecover(txid, v, r, s)];
45     }
46 }
47 
48 contract BridgeQANX is Signed {
49 
50     // POINTS TO THE OFFICIAL QANX CONTRACT
51     TransferableERC20 private _qanx = TransferableERC20(0xAAA7A10a8ee237ea61E8AC46C50A8Db8bCC1baaa);
52 
53     // STORES NONCES FOR CROSS-CHAIN TRANSFERS (msg.sender => depositChainId => withdrawChainId = nonce)
54     mapping(address => mapping(uint256 => mapping(uint256 => uint256))) private _nonces;
55 
56     // FETCH NONCE OF SENDER BASED ON CHAIN IDS
57     function getNonce(address sender, uint256 depositChainId, uint256 withdrawChainId) external view returns (uint256) {
58         return _nonces[sender][depositChainId][withdrawChainId];
59     }
60 
61     // SEND IN TOKENS ON THE SOURCE CHAIN OF THE BRIDGE
62     function bridgeSend(address beneficiary, uint256 amount, uint256 withdrawChainId) external returns (bytes32) {
63 
64         // CALCULATE TXID AND INCREMENT NONCE
65         bytes32 txid = keccak256(abi.encode(msg.sender, block.chainid, withdrawChainId, _nonces[msg.sender][block.chainid][withdrawChainId]++, beneficiary, amount));
66 
67         // TRANSFER TOKENS FROM MSG SENDER TO THIS CONTRACT FOR THE AMOUNT TO BE BRIDGED
68         require(_qanx.transferFrom(msg.sender, address(this), amount));
69 
70         // RETURN TXID
71         return txid;
72     }
73 
74     // WITHDRAW TOKENS ON THE TARGET CHAIN OF THE BRIDGE
75     function bridgeWithdraw(address beneficiary, uint256 amount, uint256 depositChainId, bytes calldata signature) external returns (bool) {
76 
77         // CALCULATE TXID AND INCREMENT NONCE
78         bytes32 txid = keccak256(abi.encode(msg.sender, depositChainId, block.chainid, _nonces[msg.sender][depositChainId][block.chainid]++, beneficiary, amount));
79         
80         // VERIFY SIGNATURE
81         require(verifySignature(txid, signature, amount), "ERR_SIG");
82 
83         // COLLECT FEE
84         uint256 fee = amount / 100 * feePercentage;
85         feesCollected += fee;
86 
87         // TRANSFER TOKENS TO BENEFICIARY
88         require(_qanx.transfer(beneficiary, amount - fee), "ERR_TXN");
89         return true;
90     }
91 
92     // FEE PERCENTAGE AND TOTAL COLLECTED FEES
93     uint256 private feePercentage;
94     uint256 private feesCollected;
95 
96     // FEE TRANSPARENCY FUNCTION
97     function getFeeInfo() external view returns (uint256[2] memory) {
98         return [feePercentage, feesCollected];
99     }
100 
101     // SETTER FOR FEE PERCENTAGE (MAX 5%)
102     function setFeePercentage(uint8 _feePercentage) external {
103         require(signers[msg.sender] > 0 && _feePercentage <= 5);
104         feePercentage = _feePercentage;
105     }
106 
107     // METHOD TO WITHDRAW TOTAL COLLECTED FEES SO FAR
108     function withdrawFees(address beneficiary) external {
109         require(signers[msg.sender] > 0);
110         require(_qanx.transfer(beneficiary, feesCollected), "ERR_TXN");
111         feesCollected = 0;
112     }
113 }