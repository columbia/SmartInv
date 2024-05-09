1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 contract KyberContributorWhitelist is Ownable {
44     // 7 wei is a dummy cap. Will be set by owner to a real cap after registration ends.
45     uint public slackUsersCap = 7;
46     mapping(address=>uint) public addressCap;
47 
48     function KyberContributorWhitelist() {}
49 
50     event ListAddress( address _user, uint _cap, uint _time );
51 
52     // Owner can delist by setting cap = 0.
53     // Onwer can also change it at any time
54     function listAddress( address _user, uint _cap ) onlyOwner {
55         addressCap[_user] = _cap;
56         ListAddress( _user, _cap, now );
57     }
58 
59     // an optimasition in case of network congestion
60     function listAddresses( address[] _users, uint[] _cap ) onlyOwner {
61         require(_users.length == _cap.length );
62         for( uint i = 0 ; i < _users.length ; i++ ) {
63             listAddress( _users[i], _cap[i] );
64         }
65     }
66 
67     function setSlackUsersCap( uint _cap ) onlyOwner {
68         slackUsersCap = _cap;
69     }
70 
71     function getCap( address _user ) constant returns(uint) {
72         uint cap = addressCap[_user];
73 
74         if( cap == 1 ) return slackUsersCap;
75         else return cap;
76     }
77 
78     function destroy() onlyOwner {
79         selfdestruct(owner);
80     }
81 }