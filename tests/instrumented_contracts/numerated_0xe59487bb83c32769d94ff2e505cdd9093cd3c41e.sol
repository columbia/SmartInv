1 pragma solidity ^0.4.13;
2 
3 contract ChainedHashLogger{
4 
5     address public owner;
6     bytes32 public name;      
7 
8     mapping(address=>bool) public delegatinglist;
9 
10     modifier onlyAuthorized(){
11         require(isdelegatinglisted(msg.sender));
12         _;
13     }
14 
15     event blockHash(bytes32 _indexName, bytes32 _proofOfPerfBlockHash, bytes32 _previousTransactionHash);
16     event Authorized(address authorized, uint timestamp);
17     event Revoked(address authorized, uint timestamp);
18  
19     constructor(bytes32 _name) public{
20         owner = msg.sender;
21         delegatinglist[owner] = true;
22         name = _name;
23     }
24 
25     function authorize(address authorized) public onlyAuthorized {
26         delegatinglist[authorized] = true;
27         emit Authorized(authorized, now);
28     }
29 
30     // also if not in the list..
31     function revoke(address authorized) public onlyAuthorized {
32         delegatinglist[authorized] = false;
33         emit Revoked(authorized, now);
34     }
35 
36     function authorizeMany(address[50] authorized) public onlyAuthorized {
37         for(uint i = 0; i < authorized.length; i++) {
38             authorize(authorized[i]);
39         }
40     }
41 
42     function isdelegatinglisted(address authorized) public view returns(bool) {
43       return delegatinglist[authorized];
44     }
45 
46     function hashDataBlock(string jsonBlock) public pure returns(bytes32) {
47       return(sha256(abi.encodePacked(jsonBlock)));
48     }
49 
50     function obfuscatedHashDataBlock(bytes32 jsonBlockHash,bytes16 secret) public pure returns(bytes32) {
51       return(sha256(abi.encodePacked(jsonBlockHash,secret)));
52     }
53 
54     function addChainedHash(bytes32 _indexName, bytes32 _proofOfPerfBlockHash, bytes32 _previousTransactionHash) public onlyAuthorized {
55         emit blockHash(_indexName, _proofOfPerfBlockHash, _previousTransactionHash);
56     }
57 
58 }