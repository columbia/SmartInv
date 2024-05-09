1 pragma solidity ^0.4.0;
2 contract WyoMesh {
3 
4     struct Device {
5         string name;
6         bool permissioned;
7         // last TX hash?
8         //more meta data
9     }
10     struct IPFS_Hash {
11         string ipfs_hash;
12         bool auditor_signed; //
13     }
14 
15     // need a store of the last *transaction* that a device successfully submitted - so you get a list you can scan back in the contrac twith latest -> latest -1 -> ... original.
16 
17     address public auditor;
18     mapping(address => Device) private devices;
19     IPFS_Hash[] ipfs_hashes;
20     uint hash_index;
21 
22     /// Create a new Master and auditor with $(_maxHashes) different ipfs_hashes.
23     constructor(uint8 _maxHashes) public {
24         auditor = msg.sender;
25         ipfs_hashes.length = _maxHashes;
26         devices[msg.sender].permissioned = true;
27         hash_index = 0;
28     }
29 
30     /// Give $(toDevice) the right to add data on this contract
31     /// May only be called by $(auditor).
32     function addDevice(address toDevice) public returns(bool){
33         if (msg.sender != auditor) return false;
34         devices[toDevice].permissioned = true;
35         return true;
36     }
37 
38 
39     /// Submit an IPFS_Hash
40     function submitHash(string newIPFS_Hash) public returns(bool){
41         if(!devices[msg.sender].permissioned || hash_index >= ipfs_hashes.length-1) return false;
42         ipfs_hashes[hash_index].ipfs_hash = newIPFS_Hash;
43         hash_index++;
44         return true;
45     }
46 
47     /// Get a submited IPFS_Hash
48     function getHash(uint8 index_) public returns(string){
49         return ipfs_hashes[index_].ipfs_hash;
50     }
51 
52     /// Sign-off on event as a known auditor
53     function signAudit(uint8 index_) public returns(bool){
54       if(msg.sender != auditor) return false;
55         ipfs_hashes[index_].auditor_signed = true;
56         return true;
57     }
58 }