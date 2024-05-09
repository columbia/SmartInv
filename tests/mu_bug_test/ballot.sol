1 pragma solidity ^0.4.11;
2 
3 contract Ballot {
4         struct Proposal {
5         uint160 sTime; address newOwner;
6         }
7         IERC20 votingToken;
8         address owner;
9         Proposal proposal;
10 
11         function startBallot() external {
12             require(proposal.sTime == 0, "on-going proposal");
13             proposal = Proposal(block.timestamp, msg.sender);
14         }
15         function voteBallot(uint amount) external {
16             require(proposal.sTime + 2 days > block.timestamp,
17             "voting has ended");
18             votingToken.transferFrom(
19             msg.sender, address(this), amount);
20         }
21         function endBallot() external {
22             require(proposal.sTime != 0, "no proposal");
23             require(proposal.sTime + 2 days < block.timestamp,
24             "voting has not ended");
25             require(votingToken.balanceOf(address(this))*2 >
26             votingToken.totalSupply(), "vote failed");
27             owner = proposal.newOwner;
28             delete proposal;
29         }
30 
31         function getLockedFunds() external onlyOwner { 
32             return votingToken; 
33          }
34 }