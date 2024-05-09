1 /* 
2 Based on a contract built by Vlad and Vitalik for Ether signal
3 If you need a license, refer to WTFPL.
4 */
5 
6 contract EtherVote {
7     event LogVote(bytes32 indexed proposalHash, bool pro, address addr);
8     function vote(bytes32 proposalHash, bool pro) {
9         // don't accept ether
10         if (msg.value > 0) throw;
11         // Log the vote
12         LogVote(proposalHash, pro, msg.sender);
13     }
14 }