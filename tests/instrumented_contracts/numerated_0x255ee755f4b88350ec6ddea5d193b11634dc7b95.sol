1 pragma solidity ^0.4.24;
2 
3 // @notice Contract to create posts
4 contract DReddit {
5 
6     enum Ballot { NONE, UPVOTE, DOWNVOTE }
7 
8     struct Post {
9         uint creationDate;   
10         bytes description;   
11         address owner;
12         uint upvotes;  
13         uint downvotes;
14         mapping(address => Ballot) voters;
15     }
16 
17     Post[] public posts;
18 
19     event NewPost (
20         uint indexed postId,
21         address owner,
22         bytes description
23     );
24 
25     event Vote(
26         uint indexed postId,
27         address voter,
28         uint8 vote
29     );
30 
31     // @notice Number of posts created
32     // @return Num of posts
33     function numPosts()
34         public
35         view
36         returns(uint)
37     {
38         return posts.length;
39     }
40 
41     // @notice Create Post
42     // @param _description IPFS hash of the content of the post
43     function create(bytes _description)
44         public
45     {
46         uint postId = posts.length++;
47         posts[postId] = Post({
48             creationDate: block.timestamp,
49             description: _description,
50             owner: msg.sender,
51             upvotes: 0,
52             downvotes: 0
53         });
54         emit NewPost(postId, msg.sender, _description);
55     }
56 
57     // @notice Vote on a post
58     // @param _postId Id of the post to up/downvote
59     // @param _vote Vote selection: 0 -> none, 1 -> upvote, 2 -> downvote
60     function vote(uint _postId, uint8 _vote)
61         public
62     {
63         Post storage p = posts[_postId];
64         require(p.creationDate != 0, "Post does not exist");
65         require(p.voters[msg.sender] == Ballot.NONE, "You already voted on this post");
66 
67         Ballot b = Ballot(_vote);
68         if (b == Ballot.UPVOTE) {
69             p.upvotes++;
70         } else {
71             p.downvotes++;
72         }
73         p.voters[msg.sender] = b;
74 
75         emit Vote(_postId, msg.sender, _vote);
76     }
77 
78     // @notice Determine if the sender can vote on a post
79     // @param _postId Id of the post
80     // @return bool that indicates if the sender can vote or not
81     function canVote(uint _postId)
82         public
83         view
84         returns (bool)
85     {
86         if(_postId > posts.length - 1) return false;
87 
88         Post storage p = posts[_postId];    
89         return (p.voters[msg.sender] == Ballot.NONE);
90     }
91 
92     // @notice Obtain vote for specific post
93     // @param _postId Id of the post
94     // @return uint that represents the vote: 0 -> none, 1 -> upvote, 2 -> downvote
95     function getVote(uint _postId)
96         public
97         view
98         returns (uint8)
99     {
100         Post storage p = posts[_postId];
101         return uint8(p.voters[msg.sender]);
102     }
103 
104 }