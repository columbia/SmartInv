1 pragma solidity 0.4.24;
2 
3 contract Delegate {
4 
5     function mint(address _sender, address _to) public returns (bool);
6 
7     function approve(address _sender, address _to, uint256 _tokenId) public returns (bool);
8 
9     function setApprovalForAll(address _sender, address _operator, bool _approved) public returns (bool);
10 
11     function transferFrom(address _sender, address _from, address _to, uint256 _tokenId) public returns (bool);
12     
13     function safeTransferFrom(address _sender, address _from, address _to, uint256 _tokenId) public returns (bool);
14 
15     function safeTransferFrom(address _sender, address _from, address _to, uint256 _tokenId, bytes memory _data) public returns (bool);
16 
17 }
18 
19 contract Ownable {
20 
21     address public owner;
22 
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     function setOwner(address _owner) public onlyOwner {
28         owner = _owner;
29     }
30 
31     function getOwner() public view returns (address) {
32         return owner;
33     }
34 
35     modifier onlyOwner {
36         require(msg.sender == owner);
37         _;
38     }
39 
40 }
41 
42 
43 contract BasicMintable is Delegate, Ownable {
44 
45     mapping(address => bool) public minters;
46 
47     function setCanMint(address minter, bool canMint) public onlyOwner {
48         minters[minter] = canMint;
49     }
50 
51     bool public canAnyMint = true;
52 
53     function setCanAnyMint(bool canMint) public onlyOwner {
54         canAnyMint = canMint;
55     }
56 
57     function mint(address _sender, address) public returns (bool) {
58         require(canAnyMint, "no minting possible");
59         return minters[_sender];
60     }
61 
62     function approve(address, address, uint256) public returns (bool) {
63         return true;
64     }
65 
66     function setApprovalForAll(address, address, bool) public returns (bool) {
67         return true;
68     }
69 
70     function transferFrom(address, address, address, uint256) public returns (bool) {
71         return true;
72     }
73     
74     function safeTransferFrom(address, address, address, uint256) public returns (bool) {
75         return true;
76     }
77 
78     function safeTransferFrom(address, address, address, uint256, bytes memory) public returns (bool) {
79         return true;
80     }
81 
82 }