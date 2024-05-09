1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.20;
4 
5 contract Inscripigeons {
6 
7     error MaxSupplyReached();
8     error InvalidValue();
9     error RequestingTooMany();
10     error TransferFailed();
11     error OnlyOwner();
12     error AlreadyClaimed();
13     error InvalidSnapshotProof();
14 
15     event Mint(address indexed minter, uint256 indexed amount, uint256 startID);
16 
17     uint256 public TOTAL_SUPPLY = 0;
18     uint256 public PRICE = 0.003 * 1 ether;
19     uint256 public immutable MAX_SUPPLY = 4900;
20 
21     address OWNER;
22 
23     modifier onlyOwner() {
24         if (msg.sender != OWNER) {
25             revert OnlyOwner();
26         }
27         _;
28     }
29 
30     constructor () {
31         OWNER = msg.sender;
32     }
33 
34     function setPrice(uint256 _PRICE) external onlyOwner {
35         PRICE = _PRICE;
36     }
37 
38     function mint(uint256 amount) external payable {
39         if (TOTAL_SUPPLY == MAX_SUPPLY) { revert MaxSupplyReached(); }
40         if ((TOTAL_SUPPLY + amount) > MAX_SUPPLY) { revert RequestingTooMany(); }
41         if ((PRICE * amount) != msg.value) { revert InvalidValue(); }
42         
43 
44         (bool success,) = address(OWNER).call{value: msg.value}("");
45         if (!success) {
46             revert TransferFailed();
47         }
48 
49         emit Mint(msg.sender, amount, TOTAL_SUPPLY);
50         
51         unchecked {
52             TOTAL_SUPPLY += amount;
53         }
54     }
55 
56     function withdraw() external onlyOwner {
57         (bool success,) = address(OWNER).call{value: address(this).balance}("");
58         if (!success) {
59             revert TransferFailed();
60         }
61     }
62 }