1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev Adds onlyOwner modifier. Subcontracts should implement checkOwner to check if caller is owner.
6  */
7 contract Ownable {
8     modifier onlyOwner() {
9         checkOwner();
10         _;
11     }
12 
13     function checkOwner() internal;
14 }
15 
16 /**
17  * @title OwnableImpl
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract OwnableImpl is Ownable {
22     address public owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     /**
27      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28      * account.
29      */
30     function OwnableImpl() public {
31         owner = msg.sender;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     function checkOwner() internal {
38         require(msg.sender == owner);
39     }
40 
41     /**
42      * @dev Allows the current owner to transfer control of the contract to a newOwner.
43      * @param newOwner The address to transfer ownership to.
44      */
45     function transferOwnership(address newOwner) onlyOwner public {
46         require(newOwner != address(0));
47         emit OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 }
51 
52 /**
53  * @title Secured
54  * @dev Adds only(role) modifier. Subcontracts should implement checkRole to check if caller is allowed to do action.
55  */
56 contract Secured {
57     modifier only(string role) {
58         require(msg.sender == getRole(role));
59         _;
60     }
61 
62     function getRole(string role) constant public returns (address);
63 }
64 
65 contract SecuredImpl is Ownable, Secured {
66 	mapping(string => address) users;
67 	event RoleTransferred(address indexed previousUser, address indexed newUser, string role);
68 
69 	function getRole(string role) constant public returns (address) {
70 		return users[role];
71 	}
72 
73 	function transferRole(string role, address to) onlyOwner public {
74 		require(to != address(0));
75 		emit RoleTransferred(users[role], to, role);
76 		users[role] = to;
77 	}
78 }
79 
80 contract Factory {
81     event TokenCreated(address addr);
82     event SaleCreated(address addr);
83 
84     function createICO(bytes token, bytes sale) public {
85         address tokenAddress = create(token);
86         emit TokenCreated(tokenAddress);
87         address saleAddress = create(sale);
88         emit SaleCreated(saleAddress);
89         SecuredImpl(tokenAddress).transferRole("minter", saleAddress);
90         OwnableImpl(tokenAddress).transferOwnership(msg.sender);
91         OwnableImpl(saleAddress).transferOwnership(msg.sender);
92     }
93 
94     function create(bytes code) internal returns (address addr) {
95         assembly {
96             addr := create(0, add(code,0x20), mload(code))
97             switch extcodesize(addr) case 0 {revert(0, 0)} default {}
98         }
99     }
100 }