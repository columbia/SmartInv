1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity ^0.5.16;
4 
5 interface IERC165 {
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 contract IERC721 is IERC165 {
10     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
11     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
12     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
13 
14     function balanceOf(address owner) public view returns (uint256 balance);
15     function ownerOf(uint256 tokenId) public view returns (address owner);
16     function approve(address to, uint256 tokenId) public;
17     function getApproved(uint256 tokenId) public view returns (address operator);
18     function setApprovalForAll(address operator, bool _approved) public;
19     function isApprovedForAll(address owner, address operator) public view returns (bool);
20     function transferFrom(address from, address to, uint256 tokenId) public;
21     function safeTransferFrom(address from, address to, uint256 tokenId) public;
22     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
23 }
24 
25 contract Ownable {
26   address public owner;
27 
28     constructor() public {
29     owner = msg.sender;
30   }
31 
32 
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   function transferOwnership(address newOwner) onlyOwner public {
39     if (newOwner != address(0)) {
40       owner = newOwner;
41     }
42   }
43 
44 }
45 
46 contract _1000eye_sale is Ownable {
47 
48     event Sale1000(uint256 indexed tokenId,address indexed owner);
49     
50     address[] public sales;
51 
52     uint256 public totalsale;
53     IERC721 public erc721_1000;
54 
55     uint256 constant ALEN=1000;
56 
57     constructor(address _1000eye)
58         public
59     {
60          erc721_1000=IERC721(_1000eye);
61     }
62     
63     function  buy() external 
64      payable {
65         require(msg.value==1 ether, "MUST_1_ETHER_ONLY");
66         require(totalsale<ALEN, "1000EYE_SOLD_OUT");
67 
68         totalsale=sales.push(msg.sender);
69         erc721_1000.safeTransferFrom(erc721_1000.ownerOf(totalsale), msg.sender,totalsale);
70         emit Sale1000(totalsale,msg.sender);
71 
72     }
73 
74     function collect(address bene) external onlyOwner {
75         uint256 balance=address(this).balance;
76         (bool success, ) =address(uint160(bene)).call.value(balance)("");
77         require(success,"ERR contract transfer eth to pool fail,maybe gas fail");
78     }
79 
80 }