1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     function setOwner(address _owner) public onlyOwner {
12         owner = _owner;
13     }
14 
15     function getOwner() public view returns (address) {
16         return owner;
17     }
18 
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23 
24 }
25 
26 contract Delegate {
27 
28     function mint(address _sender, address _to) public returns (bool);
29 
30     function approve(address _sender, address _to, uint256 _tokenId) public returns (bool);
31 
32     function setApprovalForAll(address _sender, address _operator, bool _approved) public returns (bool);
33 
34     function transferFrom(address _sender, address _from, address _to, uint256 _tokenId) public returns (bool);
35     
36     function safeTransferFrom(address _sender, address _from, address _to, uint256 _tokenId) public returns (bool);
37 
38     function safeTransferFrom(address _sender, address _from, address _to, uint256 _tokenId, bytes memory _data) public returns (bool);
39 
40 }
41 
42 contract ImTokenCardBack is Delegate, Ownable {
43 
44     mapping(address => bool) public claimed;
45     mapping(address => bool) public approvedSenders;
46     bool public canClaim = false;
47 
48     function setCanClaim(bool can) public onlyOwner {
49         canClaim = can;
50     }
51     
52     function setApprovedSender(address _sender, bool _approved) public onlyOwner {
53         approvedSenders[_sender] = _approved;
54     }
55 
56     function mint(address _sender, address _to) public returns (bool) {
57         require(approvedSenders[_sender], "sender must be approved");
58         require(canClaim, "can't claim");
59         require(!claimed[_to], "one card back per user");
60         claimed[_to] = true;
61         return true;
62     }
63 
64     function approve(address, address, uint256) public returns (bool) {
65         return true;
66     }
67 
68     function setApprovalForAll(address, address, bool) public returns (bool) {
69         return true;
70     }
71 
72     function transferFrom(address, address, address, uint256) public returns (bool) {
73         return true;
74     }
75     
76     function safeTransferFrom(address, address, address, uint256) public returns (bool) {
77         return true;
78     }
79 
80     function safeTransferFrom(address, address, address, uint256, bytes memory) public returns (bool) {
81         return true;
82     }
83 
84 }