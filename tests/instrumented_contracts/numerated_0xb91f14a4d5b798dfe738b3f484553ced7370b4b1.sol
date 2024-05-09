1 pragma solidity ^0.4.17;
2 
3 interface BlacklistInterface {
4 
5     event Blacklisted(bytes32 indexed node);
6     event Unblacklisted(bytes32 indexed node);
7     
8     function blacklist(bytes32 node) public;
9     function unblacklist(bytes32 node) public;
10     function isPermitted(bytes32 node) public view returns (bool);
11 
12 }
13 
14 contract Ownable {
15 
16     address public owner;
17 
18     modifier onlyOwner {
19         require(isOwner(msg.sender));
20         _;
21     }
22 
23     function Ownable() public {
24         owner = msg.sender;
25     }
26 
27     function transferOwnership(address newOwner) public onlyOwner {
28         owner = newOwner;
29     }
30 
31     function isOwner(address addr) public view returns (bool) {
32         return owner == addr;
33     }
34 }
35 
36 contract Blacklist is BlacklistInterface, Ownable {
37 
38     mapping (bytes32 => bool) blacklisted;
39     
40     /**
41      * @dev Add a node to the blacklist.
42      * @param node The node to add to the blacklist.
43      */
44     function blacklist(bytes32 node) public onlyOwner {
45         blacklisted[node] = true;
46         Blacklisted(node);
47     }
48     
49     /** 
50      * @dev Remove a node from the blacklist.
51      * @param node The node to remove from the blacklist.
52      */
53     function unblacklist(bytes32 node) public onlyOwner {
54         blacklisted[node] = false;
55         Unblacklisted(node);
56     }
57     
58     /**
59      *  @dev Return true if the node is permitted, false otherwise. Every nodes, except the blacklisted ones, are permitted.
60      *  @param node The node.
61      */
62     function isPermitted(bytes32 node) public view returns (bool) {
63         return !blacklisted[node];
64     }
65 }