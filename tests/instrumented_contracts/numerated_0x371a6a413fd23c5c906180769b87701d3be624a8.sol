1 pragma solidity 0.5.4;
2 
3 
4 interface IWhitelist {
5     function approved(address user) external view returns (bool);
6 }
7 
8 contract Whitelist is IWhitelist {
9     mapping(address => bool) public approved;
10     mapping(address => bool) public admins;
11     address public owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     modifier onlyAdmin() {
21         require(admins[msg.sender]);
22         _;
23     }
24 
25     constructor() public {
26         owner = msg.sender;
27         admins[msg.sender] = true;
28     }
29 
30     function addAdmin(address user) external onlyOwner {
31         if (!admins[user]) {
32             admins[user] = true;
33         }
34     }
35 
36     function removeAdmin(address user) external onlyOwner {
37         if (admins[user]) {
38             admins[user] = false;
39         }
40     }
41 
42     function add(address user) external onlyAdmin {
43         if (!approved[user]) {
44             approved[user] = true;
45         }
46     }
47 
48     function add(address[] calldata users) external onlyAdmin {
49         for (uint256 i = 0; i < users.length; ++i) {
50             if (!approved[users[i]]) {
51                 approved[users[i]] = true;
52             }
53         }
54     }
55 
56     function remove(address user) external onlyAdmin {
57         if (approved[user]) {
58             approved[user] = false;
59         }
60     }
61 
62     function remove(address[] calldata users) external onlyAdmin {
63         for (uint256 i = 0; i < users.length; ++i) {
64             if (approved[users[i]]) {
65                 approved[users[i]] = false;
66             }
67         }
68     }
69 
70     function transferOwnership(address _owner) external onlyOwner {
71         require(_owner != address(0));
72 
73         emit OwnershipTransferred(owner, _owner);
74 
75         owner = _owner;
76     }
77 }