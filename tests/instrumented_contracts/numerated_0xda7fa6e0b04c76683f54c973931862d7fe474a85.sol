1 pragma solidity ^0.4.0;
2 
3 contract AbstractENS {
4     function owner(bytes32 node) constant returns(address);
5     function resolver(bytes32 node) constant returns(address);
6     function ttl(bytes32 node) constant returns(uint64);
7     function setOwner(bytes32 node, address owner);
8     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
9     function setResolver(bytes32 node, address resolver);
10     function setTTL(bytes32 node, uint64 ttl);
11 
12     event Transfer(bytes32 indexed node, address owner);
13     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
14     event NewResolver(bytes32 indexed node, address resolver);
15     event NewTTL(bytes32 indexed node, uint64 ttl);
16 }
17 
18 contract ReverseRegistrar {
19     AbstractENS public ens;
20     bytes32 public rootNode;
21     
22     /**
23      * @dev Constructor
24      * @param ensAddr The address of the ENS registry.
25      * @param node The node hash that this registrar governs.
26      */
27     function ReverseRegistrar(address ensAddr, bytes32 node) {
28         ens = AbstractENS(ensAddr);
29         rootNode = node;
30     }
31 
32     /**
33      * @dev Transfers ownership of the reverse ENS record associated with the
34      *      calling account.
35      * @param owner The address to set as the owner of the reverse record in ENS.
36      * @return The ENS node hash of the reverse record.
37      */
38     function claim(address owner) returns (bytes32 node) {
39         var label = sha3HexAddress(msg.sender);
40         ens.setSubnodeOwner(rootNode, label, owner);
41         return sha3(rootNode, label);
42     }
43 
44     /**
45      * @dev Returns the node hash for a given account's reverse records.
46      * @param addr The address to hash
47      * @return The ENS node hash.
48      */
49     function node(address addr) constant returns (bytes32 ret) {
50         return sha3(rootNode, sha3HexAddress(addr));
51     }
52 
53     /**
54      * @dev An optimised function to compute the sha3 of the lower-case
55      *      hexadecimal representation of an Ethereum address.
56      * @param addr The address to hash
57      * @return The SHA3 hash of the lower-case hexadecimal encoding of the
58      *         input address.
59      */
60     function sha3HexAddress(address addr) private returns (bytes32 ret) {
61         assembly {
62             let lookup := 0x3031323334353637383961626364656600000000000000000000000000000000
63             let i := 40
64         loop:
65             i := sub(i, 1)
66             mstore8(i, byte(and(addr, 0xf), lookup))
67             addr := div(addr, 0x10)
68             i := sub(i, 1)
69             mstore8(i, byte(and(addr, 0xf), lookup))
70             addr := div(addr, 0x10)
71             jumpi(loop, i)
72             ret := sha3(0, 40)
73         }
74     }
75 }