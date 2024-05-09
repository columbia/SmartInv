1 pragma solidity ^0.5.9;
2 
3 contract StoredIPFSHashes {
4 
5     struct StateHashBatch {
6         string contractHash;
7         string event_id;
8         uint new_privileges;
9         uint new_firings;
10         uint sold_resold_ratio;
11     }
12     
13     event Update(
14         string contractHash,
15         uint sold_resold_ratio
16     );
17     
18     address protocol;
19     
20     constructor() public {
21         protocol = msg.sender;
22     }
23     
24     modifier onlyProtocol() {
25         if (msg.sender == protocol) {
26             _;
27         }
28     } 
29     
30     StateHashBatch[] public all_hashes;
31     
32     function registerHash(
33         string memory _contractHash, 
34         string memory _event_id, 
35         uint _new_privileges, 
36         uint _new_firings,
37         uint _sold_resold_ratio) public onlyProtocol {
38             all_hashes.push(StateHashBatch(_contractHash, _event_id, _new_privileges, _new_firings, _sold_resold_ratio));
39             emit Update(_contractHash, _sold_resold_ratio);
40         }
41 }