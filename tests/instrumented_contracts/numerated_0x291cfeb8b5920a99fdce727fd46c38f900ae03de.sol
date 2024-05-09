1 pragma solidity ^0.4.23;
2 
3 contract HTLC {
4   address funder;
5   address beneficiary;
6   bytes32 public secret;
7   bytes32 public hashSecret;
8   uint public unlockTime;
9 
10   constructor(address beneficiary_, bytes32 hashSecret_, uint lockTime) public {
11     beneficiary = beneficiary_;
12     hashSecret = hashSecret_;
13     unlockTime = now + lockTime * 1 minutes;
14   }
15 
16   function() public payable {
17     if (funder == 0) {
18       funder = msg.sender;
19     }
20     if (msg.sender != funder) {
21       revert();
22     }
23   }
24 
25   function resolve(bytes32 secret_) public {
26     if (sha256(secret_) != hashSecret) {
27       revert();
28     }
29     secret = secret_;
30     beneficiary.transfer(address(this).balance);
31   }
32 
33   function refund() public {
34     if (now < unlockTime) {
35       revert();
36     }
37     funder.transfer(address(this).balance);
38   }
39 }