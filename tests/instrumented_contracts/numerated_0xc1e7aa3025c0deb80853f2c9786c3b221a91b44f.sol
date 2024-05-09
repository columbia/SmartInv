1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/RBACInterface.sol
46 
47 /// @title RBACInterface
48 /// @notice The interface for Role-Based Access Control.
49 contract RBACInterface {
50     function hasRole(address addr, string role) public view returns (bool);
51 }
52 
53 // File: contracts/RBAC.sol
54 
55 /// @title RBAC
56 /// @notice A simple implementation of Role-Based Access Control.
57 contract RBAC is RBACInterface, Ownable {
58 
59     string constant ROLE_ADMIN = "rbac__admin";
60 
61     mapping(address => mapping(string => bool)) internal roles;
62 
63     event RoleAdded(address indexed addr, string role);
64     event RoleRemoved(address indexed addr, string role);
65 
66     /// @notice Check if an address has a role.
67     /// @param addr The address.
68     /// @param role The role.
69     /// @return A boolean indicating whether the address has the role.
70     function hasRole(address addr, string role) public view returns (bool) {
71         return roles[addr][role];
72     }
73 
74     /// @notice Add a role to an address. Only the owner or an admin can add a
75     /// role.
76     /// @dev Requires caller to be the owner or have the role "rbac__admin".
77     /// @param addr The address.
78     /// @param role The role.
79     function addRole(address addr, string role) public onlyOwnerOrAdmin {
80         roles[addr][role] = true;
81         emit RoleAdded(addr, role);
82     }
83 
84     /// @notice Remove a role from an address. Only the owner or an admin can
85     /// remove a role.
86     /// @dev Requires caller to be the owner or have the role "rbac__admin".
87     /// @param addr The address.
88     /// @param role The role.
89     function removeRole(address addr, string role) public onlyOwnerOrAdmin {
90         roles[addr][role] = false;
91         emit RoleRemoved(addr, role);
92     }
93 
94     modifier onlyOwnerOrAdmin() {
95         require(msg.sender == owner || hasRole(msg.sender, ROLE_ADMIN), "Access denied: missing role");
96         _;
97     }
98 }