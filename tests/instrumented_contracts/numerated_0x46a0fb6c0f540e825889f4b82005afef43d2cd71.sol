1 pragma solidity ^0.4.17;
2 
3 contract ArchiveCreation {
4    struct Archive {
5      string projectNameToken;
6    }
7 
8    mapping (bytes32 => Archive) registry;
9    bytes32[] records;
10    address private owner_;
11 
12    function ArchiveCreation() {
13      owner_ = msg.sender;
14    }
15 
16    function signArchive(bytes32 hash, string projectNameToken) public {
17 	   if (owner_ == msg.sender) {
18 	     records.push(hash);
19 	     registry[hash] = Archive(projectNameToken);
20 	   }
21    }
22 
23    function getRecords() public view returns (bytes32[]) {
24      return records;
25    }
26 
27    function getRecordNameToken(bytes32 hash) public view returns (string) {
28      return registry[hash].projectNameToken;
29    }
30 }