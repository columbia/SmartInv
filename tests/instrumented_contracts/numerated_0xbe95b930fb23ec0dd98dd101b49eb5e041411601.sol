1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @author Kelvin Fichter (@kelvinfichter)
6  * @notice Simple contract for making hash commitments.
7  */
8 contract CommitMe {
9     
10     /*
11      * Structs
12      */
13 
14     struct Commitment {
15         address creator;
16         uint256 block;
17         uint256 timestamp;
18     }
19 
20 
21     /*
22      * Public Variables
23      */
24 
25     mapping (bytes32 => Commitment) public commitments;
26 
27 
28     /*
29      * Public Functions
30      */
31 
32     /**
33      * @notice Allows a user to create a commitment.
34      * @param _hash Hash of the committed data.
35      */
36     function commit(bytes32 _hash) public {
37         Commitment storage commitment = commitments[_hash];
38         
39         require(
40             !commitmentExists(_hash),
41             "Commitment with that hash already exists, try adding a salt."
42         );
43 
44         commitment.creator = msg.sender;
45         commitment.block = block.number;
46         commitment.timestamp = block.timestamp;
47     }
48 
49     /**
50      * @notice Checks if a message was committed.
51      * @param _message Message to check.
52      * @return Commitment corresponding to the given message.
53      */
54     function verify(
55         bytes memory _message
56     )
57         public
58         view
59         returns (Commitment memory)
60     {
61         bytes32 hash = keccak256(_message);
62         Commitment memory commitment = commitments[hash];
63 
64         require(
65             commitmentExists(hash),
66             "Commitment with that hash does not exist."
67         );
68 
69         return commitment;
70     }
71 
72 
73     /*
74      * Private Functions
75      */
76 
77     /**
78      * @notice Checks if a specific commitment has been made.
79      * @param _hash Hash of the commitment to check.
80      * @return `true` if the commitment has been made, `false` otherwise.
81      */
82     function commitmentExists(bytes32 _hash) private view returns (bool) {
83         return commitments[_hash].creator != address(0);
84     }
85 }