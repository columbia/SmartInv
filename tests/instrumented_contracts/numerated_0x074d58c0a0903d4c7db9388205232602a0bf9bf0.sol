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
11 }
12 
13 /**
14  * A simple resolver intended for use with token contracts. Only allows the
15  * owner of a node to set its address, and returns the ERC20 JSON ABI for all
16  * ABI queries.
17  * 
18  * Also acts as the registrar for 'thetoken.eth' to simplify setting up new tokens.
19  */
20 contract TokenResolver {
21     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
22     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
23     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
24     bytes32 constant ROOT_NODE = 0x637f12e7cd6bed65eeceee34d35868279778fc56c3e5e951f46b801fb78a2d26;
25     bytes TOKEN_JSON_ABI = '[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"name","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"totalSupply","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"decimals","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"symbol","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"}]';
26     
27     event AddrChanged(bytes32 indexed node, address a);
28 
29     AbstractENS ens = AbstractENS(0x314159265dD8dbb310642f98f50C066173C1259b);
30     mapping(bytes32=>address) addresses;
31     address owner;
32 
33     modifier only_node_owner(bytes32 node) {
34         require(ens.owner(node) == msg.sender || owner == msg.sender);
35         _;
36     }
37     
38     modifier only_owner() {
39         require(owner == msg.sender);
40         _;
41     }
42     
43     function setOwner(address newOwner) only_owner {
44         owner = newOwner;
45     }
46 
47     function newToken(string name, address addr) only_owner {
48         var label = sha3(name);
49         var node = sha3(ROOT_NODE, label);
50         
51         ens.setSubnodeOwner(ROOT_NODE, label, this);
52         ens.setResolver(node, this);
53         addresses[node] = addr;
54         AddrChanged(node, addr);
55     }
56     
57     function setSubnodeOwner(bytes22 label, address newOwner) only_owner {
58         ens.setSubnodeOwner(ROOT_NODE, label, newOwner);
59     }
60 
61     function TokenResolver() {
62         owner = msg.sender;
63     }
64 
65     /**
66      * Returns true if the resolver implements the interface specified by the provided hash.
67      * @param interfaceID The ID of the interface to check for.
68      * @return True if the contract implements the requested interface.
69      */
70     function supportsInterface(bytes4 interfaceID) constant returns (bool) {
71         return interfaceID == ADDR_INTERFACE_ID ||
72                interfaceID == ABI_INTERFACE_ID ||
73                interfaceID == INTERFACE_META_ID;
74     }
75 
76     /**
77      * Returns the address associated with an ENS node.
78      * @param node The ENS node to query.
79      * @return The associated address.
80      */
81     function addr(bytes32 node) constant returns (address ret) {
82         ret = addresses[node];
83     }
84 
85     /**
86      * Sets the address associated with an ENS node.
87      * May only be called by the owner of that node in the ENS registry.
88      * @param node The node to update.
89      * @param addr The address to set.
90      */
91     function setAddr(bytes32 node, address addr) only_node_owner(node) {
92         addresses[node] = addr;
93         AddrChanged(node, addr);
94     }
95 
96     /**
97      * Returns the ABI associated with an ENS node.
98      * Defined in EIP205.
99      * @param node The ENS node to query
100      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
101      * @return contentType The content type of the return value
102      * @return data The ABI data
103      */
104     function ABI(bytes32 node, uint256 contentTypes) constant returns (uint256 contentType, bytes data) {
105         node;
106         if(contentTypes & 1 == 1) {
107             // JSON ABI
108             contentType = 1;
109             data = TOKEN_JSON_ABI;
110             return;
111         }
112         contentType = 0;
113     }
114 }