1 pragma solidity ^0.4.11;
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
43 
44 contract KyberContirbutorWhitelist is Ownable {
45     mapping(address=>uint) addressCap;
46     
47     function KyberContirbutorWhitelist() {}
48     
49     event ListAddress( address _user, uint _cap, uint _time );
50     
51     // Owner can delist by setting cap = 0.
52     // Onwer can also change it at any time
53     function listAddress( address _user, uint _cap ) onlyOwner {
54         addressCap[_user] = _cap;
55         ListAddress( _user, _cap, now );
56     }
57     
58     function getCap( address _user ) constant returns(uint) {
59         return addressCap[_user];
60     }
61 }
62 
63 contract KyberContirbutorWhitelistOptimized is KyberContirbutorWhitelist {
64     uint public slackUsersCap = 7;
65     
66     function KyberContirbutorWhitelistOptimized() {}
67     
68     function listAddresses( address[] _users, uint[] _cap ) onlyOwner {
69         require(_users.length == _cap.length );
70         for( uint i = 0 ; i < _users.length ; i++ ) {
71             listAddress( _users[i], _cap[i] );   
72         }
73     }
74     
75     function setSlackUsersCap( uint _cap ) onlyOwner {
76         slackUsersCap = _cap;        
77     }
78     
79     function getCap( address _user ) constant returns(uint) {
80         uint cap = super.getCap(_user);
81         
82         if( cap == 1 ) return slackUsersCap;
83         else return cap;
84     }
85 }