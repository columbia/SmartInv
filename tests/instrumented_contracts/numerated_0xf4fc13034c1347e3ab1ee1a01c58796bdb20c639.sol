1 pragma solidity ^0.4.19;
2 
3 contract Leaderboard {
4     struct User {
5         address user;
6         uint balance;
7         string name;
8     }
9     
10     User[3] public leaderboard;
11     
12     address owner;
13     
14     function Leaderboard() public {
15         owner = msg.sender;
16     }
17     
18     function addScore(string name) public payable returns (bool) {
19         if (leaderboard[2].balance >= msg.value)
20             // user didn't make it into top 3
21             return false;
22         for (uint i=0; i<3; i++) {
23             if (leaderboard[i].balance < msg.value) {
24                 // resort
25                 if (leaderboard[i].user != msg.sender) {
26                     bool duplicate = false;
27                     for (uint j=i+1; j<3; j++) {
28                         if (leaderboard[j].user == msg.sender) {
29                             duplicate = true;
30                             delete leaderboard[j];
31                         }
32                         if (duplicate)
33                             leaderboard[j] = leaderboard[j+1];
34                         else
35                             leaderboard[j] = leaderboard[j-1];
36                     }
37                 }
38                 // add new highscore
39                 leaderboard[i] = User({
40                     user: msg.sender,
41                     balance: msg.value,
42                     name: name
43                 });
44                 return true;
45             }
46             if (leaderboard[i].user == msg.sender)
47                 // user is alrady in list with higher or equal score
48                 return false;
49         }
50     }
51     
52     function withdrawBalance() public {
53         owner.transfer(this.balance);
54     }
55     
56     function getUser(uint index) public view returns(address, uint, string) {
57         return (leaderboard[index].user, leaderboard[index].balance, leaderboard[index].name);
58     }
59 }