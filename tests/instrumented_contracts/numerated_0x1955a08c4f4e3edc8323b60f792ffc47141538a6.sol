1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title MyFriendships
5  * @dev A contract for managing one's friendships.
6  */
7 contract MyFriendships {
8     address public me;
9     uint public numberOfFriends;
10     address public latestFriend;
11     
12     mapping(address => bool) myFriends;
13 
14     /**
15     * @dev Create a contract to keep track of my friendships.
16     */
17     function MyFriendships() public {
18         me = msg.sender;
19     }
20  
21     /**
22     * @dev Start an exciting new friendship with me.
23     */
24     function becomeFriendsWithMe () public {
25         require(msg.sender != me); // I won't be friends with myself.
26         myFriends[msg.sender] = true;
27         latestFriend = msg.sender;
28         numberOfFriends++;
29     }
30     
31     /**
32     * @dev Am I friends with this address?
33     */
34     function friendsWith (address addr) public view returns (bool) {
35         return myFriends[addr];
36     }
37 }