1 pragma solidity ^0.5.8;
2 
3 contract Registry {
4     struct Entry {
5         uint64 lenData;
6         mapping (uint32=>address) data;
7         address owner;
8         bool uploaded;
9     }
10     mapping(uint256=>Entry) public entries;
11     uint256 public numEntries = 0;
12 
13     function addEntry(uint64 lenData) public returns(uint256) {
14         entries[numEntries] = Entry(lenData, msg.sender, false);
15         numEntries += 1;
16         return numEntries - 1;
17     }
18 
19     function finalize(uint256 entryId) public {
20         require(entries[entryId].owner == msg.sender);
21         entries[entryId].uploaded = true;
22     }
23     
24     function storeDataAsContract(bytes memory data) internal returns (address) {
25         address result;
26         assembly {
27             let length := mload(data)
28             mstore(data, 0x58600c8038038082843982f3)
29             result := create(0, add(data, 20), add(12, length))
30         }
31         require(result != address(0x0));
32         return result;
33     }
34     
35     function addChunk(uint256 entryId, uint32 chunkIndex, bytes memory chunkData) public {
36         require(entries[entryId].owner == msg.sender);
37         entries[entryId].data[chunkIndex] = storeDataAsContract(chunkData);
38     }
39 
40     function get(uint256 entryId, uint32 chunkIndex) public view returns(bytes memory result) {
41         require(entries[entryId].uploaded);
42         address _addr = entries[entryId].data[chunkIndex];
43         assembly {
44             // retrieve the size of the code, this needs assembly
45             let size := extcodesize(_addr)
46             // allocate output byte array - this could also be done without assembly
47             // by using o_code = new bytes(size)
48             result := mload(0x40)
49             // new "memory end" including padding
50             mstore(0x40, add(result, and(add(add(size, 0x20), 0x1f), not(0x1f))))
51             // store length in memory
52             mstore(result, size)
53             // actually retrieve the code, this needs assembly
54             extcodecopy(_addr, add(result, 0x20), 0, size)            
55         }
56     }
57 
58     function getLen(uint256 entry) public view returns(uint64 length) {
59         return entries[entry].lenData;
60     }
61 }