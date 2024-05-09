1 pragma solidity ^0.5.0;
2 
3 contract DOSAddressBridgeInterface {
4     function getProxyAddress() public view returns(address);
5 }
6 
7 contract CommitReveal {
8     struct Participant {
9         uint secret;
10         bytes32 commitment;
11         bool revealed;
12     }
13 
14     struct Campaign {
15         uint startBlock;
16         uint commitDuration;  // in blocks
17         uint revealDuration;  // in blocks
18         uint revealThreshold;
19         uint commitNum;
20         uint revealNum;
21         uint generatedRandom;
22         mapping(address => Participant) participants;
23         mapping(bytes32 => bool) commitments;
24     }
25 
26     Campaign[] public campaigns;
27     DOSAddressBridgeInterface public addressBridge;
28 
29     modifier checkCommit(uint _cid, bytes32 _commitment) {
30         Campaign storage c = campaigns[_cid];
31         require(_cid != 0 &&
32                 block.number >= c.startBlock &&
33                 block.number < c.startBlock + c.commitDuration,
34                 "not-in-commit");
35         require(_commitment != "", "empty-commitment");
36         require(!c.commitments[_commitment], "duplicate-commitment");
37         _;
38     }
39     modifier checkReveal(uint _cid) {
40         Campaign storage c = campaigns[_cid];
41         require(_cid != 0 &&
42                 block.number >= c.startBlock + c.commitDuration &&
43                 block.number < c.startBlock + c.commitDuration + c.revealDuration,
44                 "not-in-reveal");
45         _;
46     }
47     modifier checkFinish(uint _cid) {
48         Campaign storage c = campaigns[_cid];
49         require(_cid != 0 &&
50                 block.number >= c.startBlock + c.commitDuration + c.revealDuration,
51                 "commit-reveal-not-finished");
52         _;
53     }
54     modifier onlyFromProxy() {
55         require(msg.sender == addressBridge.getProxyAddress(), "not-from-dos-proxy");
56         _;
57     }
58 
59     event LogStartCommitReveal(uint cid, uint startBlock, uint commitDuration, uint revealDuration, uint revealThreshold);
60     event LogCommit(uint cid, address from, bytes32 commitment);
61     event LogReveal(uint cid, address from, uint secret);
62     event LogRandom(uint cid, uint random);
63     event LogRandomFailure(uint cid, uint commitNum, uint revealNum, uint revealThreshold);
64 
65     constructor(address _bridgeAddr) public {
66         // campaigns[0] is not used.
67         campaigns.length++;
68         addressBridge = DOSAddressBridgeInterface(_bridgeAddr);
69     }
70 
71     // Returns new campaignId.
72     function startCommitReveal(
73         uint _startBlock,
74         uint _commitDuration,
75         uint _revealDuration,
76         uint _revealThreshold
77     )
78         public
79         onlyFromProxy
80         returns(uint)
81     {
82         uint newCid = campaigns.length;
83         campaigns.push(Campaign(_startBlock, _commitDuration, _revealDuration, _revealThreshold, 0, 0, 0));
84         emit LogStartCommitReveal(newCid, _startBlock, _commitDuration, _revealDuration, _revealThreshold);
85         return newCid;
86     }
87 
88     function commit(uint _cid, bytes32 _secretHash) public checkCommit(_cid, _secretHash) {
89         Campaign storage c = campaigns[_cid];
90         c.commitments[_secretHash] = true;
91         c.participants[msg.sender] = Participant(0, _secretHash, false);
92         c.commitNum++;
93         emit LogCommit(_cid, msg.sender, _secretHash);
94     }
95 
96     function reveal(uint _cid, uint _secret) public checkReveal(_cid) {
97         Campaign storage c = campaigns[_cid];
98         Participant storage p = c.participants[msg.sender];
99         require(!p.revealed && keccak256(abi.encodePacked(_secret)) == p.commitment,
100                 "revealed-secret-not-match-commitment");
101         p.secret = _secret;
102         p.revealed = true;
103         c.revealNum++;
104         c.generatedRandom ^= _secret;
105         emit LogReveal(_cid, msg.sender, _secret);
106     }
107 
108     // Return value of 0 representing invalid random output.
109     function getRandom(uint _cid) public checkFinish(_cid) returns (uint) {
110         Campaign storage c = campaigns[_cid];
111         if (c.revealNum >= c.revealThreshold) {
112             emit LogRandom(_cid, c.generatedRandom);
113             return c.generatedRandom;
114         } else{
115             emit LogRandomFailure(_cid, c.commitNum, c.revealNum, c.revealThreshold);
116             return 0;
117         }
118     }
119 }