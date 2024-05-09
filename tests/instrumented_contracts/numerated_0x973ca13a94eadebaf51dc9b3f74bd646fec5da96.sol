1 pragma solidity ^0.4.0;
2 
3 contract Bounty {
4     struct Talk {
5         uint balance;
6         mapping(address => uint) witnessedPresenter;
7         mapping(address => bool) witnessedBy;
8     }
9     
10     event TalkBounty (bytes32 title);
11     
12     mapping(bytes32 => Talk) public talks;
13     
14     modifier onlywitness {
15         require(msg.sender == 0x07114957EdBcCc1DA265ea2Aa420a1a22e6afF58
16         || msg.sender == 0x75427E62EB560447165a54eEf9B6367d87F98418);
17         _;
18     }
19     
20     function add(bytes32 title) payable {
21         talks[title].balance += msg.value;
22         TalkBounty(title);
23     }
24     
25     function witness(bytes32 title, address presenter) onlywitness returns (uint) {
26         if (talks[title].witnessedBy[msg.sender]) {
27             revert();
28         }
29         talks[title].witnessedBy[msg.sender] = true;
30         talks[title].witnessedPresenter[presenter] += 1;
31         return talks[title].witnessedPresenter[presenter];
32     }
33     
34     function claim(bytes32 title) {
35         if (talks[title].witnessedPresenter[msg.sender] < 2) {
36             revert();
37         }
38         uint amount = talks[title].balance;
39         talks[title].balance = 0;
40         msg.sender.transfer(amount);
41     }
42 }