1 pragma solidity 0.4.15;
2 
3 
4 // This contract is meant as a "singleton" forwarding contract.
5 // Eventually, it will be able to forward any transaction to
6 // Any contract that is built to accept it.
7 contract TxRelay {
8 
9     // Note: This is a local nonce.
10     // Different from the nonce defined w/in protocol.
11     mapping(address => uint) nonce;
12 
13     // This mapping specifies a whitelist of allowed senders for transactions.
14     // There can be one whitelist per ethereum account, which is the owner of that
15     // whitelist. Users can specify which whitelist they want to use when signing
16     // a transaction. They can use their own whitelist, a whitelist belonging
17     // to another account, or skip using a whitelist by specifying the zero address.
18     mapping(address => mapping(address => bool)) public whitelist;
19 
20     /*
21      * @dev Relays meta transactions
22      * @param sigV, sigR, sigS ECDSA signature on some data to be forwarded
23      * @param destination Location the meta-tx should be forwarded to
24      * @param data The bytes necessary to call the function in the destination contract.
25      * Note: The first encoded argument in data must be address of the signer. This means
26      * that all functions called from this relay must take an address as the first parameter.
27      */
28     function relayMetaTx(
29         uint8 sigV,
30         bytes32 sigR,
31         bytes32 sigS,
32         address destination,
33         bytes data,
34         address listOwner
35     ) public {
36 
37         // only allow senders from the whitelist specified by the user,
38         // 0x0 means no whitelist.
39         require(listOwner == 0x0 || whitelist[listOwner][msg.sender]);
40 
41         address claimedSender = getAddress(data);
42         // use EIP 191
43         // 0x19 :: version :: relay :: whitelistOwner :: nonce :: destination :: data
44         bytes32 h = keccak256(byte(0x19), byte(0), this, listOwner, nonce[claimedSender], destination, data);
45         address addressFromSig = ecrecover(h, sigV, sigR, sigS);
46 
47         require(claimedSender == addressFromSig);
48 
49         nonce[claimedSender]++; //if we are going to do tx, update nonce
50 
51         require(destination.call(data));
52     }
53 
54     /*
55      * @dev Gets an address encoded as the first argument in transaction data
56      * @param b The byte array that should have an address as first argument
57      * @returns a The address retrieved from the array
58      (Optimization based on work by tjade273)
59      */
60     function getAddress(bytes b) public constant returns (address a) {
61         if (b.length < 36) return address(0);
62         assembly {
63             let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
64             a := and(mask, mload(add(b, 36)))
65             // 36 is the offset of the first parameter of the data, if encoded properly.
66             // 32 bytes for the length of the bytes array, and 4 bytes for the function signature.
67         }
68     }
69 
70     /*
71      * @dev Returns the local nonce of an account.
72      * @param add The address to return the nonce for.
73      * @return The specific-to-this-contract nonce of the address provided
74      */
75     function getNonce(address add) public constant returns (uint) {
76         return nonce[add];
77     }
78 
79     /*
80      * @dev Adds a number of addresses to a specific whitelist. Only
81      * the owner of a whitelist can add to it.
82      * @param sendersToUpdate the addresses to add to the whitelist
83      */
84     function addToWhitelist(address[] sendersToUpdate) public {
85         updateWhitelist(sendersToUpdate, true);
86     }
87 
88     /*
89      * @dev Removes a number of addresses from a specific whitelist. Only
90      * the owner of a whitelist can remove from it.
91      * @param sendersToUpdate the addresses to add to the whitelist
92      */
93     function removeFromWhitelist(address[] sendersToUpdate) public {
94         updateWhitelist(sendersToUpdate, false);
95     }
96 
97     /*
98      * @dev Internal logic to update a whitelist
99      * @param sendersToUpdate the addresses to add to the whitelist
100      * @param newStatus whether to add or remove addresses
101      */
102     function updateWhitelist(address[] sendersToUpdate, bool newStatus) private {
103         for (uint i = 0; i < sendersToUpdate.length; i++) {
104             whitelist[msg.sender][sendersToUpdate[i]] = newStatus;
105         }
106     }
107 }