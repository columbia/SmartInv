1 contract Friends {
2     address public owner;
3     mapping (address => Friend) public friends;
4     uint defaultPayout = .1 ether;
5     
6     struct Friend {
7         bool isFriend;
8         bool hasWithdrawn;
9     }
10     
11     modifier onlyOwner {
12         require(msg.sender==owner);
13         _;
14     }
15     
16     function Friends() {
17         owner = msg.sender;
18     }
19     
20     function deposit() payable {
21         
22     }
23     
24     function addFriend(address _f) onlyOwner {
25         friends[_f].isFriend = true;
26     }
27     
28     function withdraw() {
29         require (friends[msg.sender].isFriend && !friends[msg.sender].hasWithdrawn);
30         friends[msg.sender].hasWithdrawn = true;
31         msg.sender.send(defaultPayout);
32     }
33     
34     function ownerWithdrawAll() onlyOwner {
35         owner.send(this.balance);
36     }
37 }