1 pragma solidity ^0.4.24;
2 
3 contract BulletinBoard {
4     event PostMade(
5         address indexed poster,
6         string note,
7         bytes32 hash,
8         uint256 listIndex,
9         uint256 blocknum
10     );
11     
12     struct Post {
13         address poster;
14         string note;
15         bytes32 hash;
16         uint256 listIndex;
17         uint256 blocknum;
18     }
19 
20     mapping(bytes32 => Post) public posts;
21     bytes32[] public postList;
22     
23     address ZERO_ADDRESS = address(0);
24 
25     constructor() public {
26         string memory testPost = "pizza is yummy 123";
27         bytes32 testHash = keccak256(abi.encodePacked(testPost));
28         string memory testNote = "secret note, shh";
29         require(makePost(testHash, testNote) == 0, "Error making post!");
30     }
31 
32     function makePost(
33         bytes32 hash,
34         string note
35     ) public returns (uint256 listIndex) {
36         require(
37             posts[hash].poster == ZERO_ADDRESS,
38             "A post with this hash was already made!"
39         );
40         posts[hash] = Post({
41             poster: msg.sender,
42             note: note,
43             hash: hash,
44             listIndex: postList.length,
45             blocknum: block.number
46         });
47         postList.push(hash);
48         listIndex = postList.length - 1;
49         emit PostMade(msg.sender, note, hash, listIndex, block.number);
50         return listIndex;
51     }
52 
53     function getNumPosts() public view returns (uint256) {
54         return postList.length;
55     }
56 }