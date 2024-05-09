1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 
43 contract ElecWhitelist is Ownable {
44     // cap is in wei. The value of 1 is just a stub.
45     // after kyc registration ends, we change it to the actual value with setUsersCap
46     /// Currenty we set the cap to 1 ETH and the owner is able to change it in the future by call function: setUsersCap
47     uint public communityusersCap = 1067*(10**15);
48     mapping(address=>uint) public addressCap;
49 
50     function ElecWhitelist() public {}
51 
52     event ListAddress( address _user, uint _cap, uint _time );
53 
54     // Owner can remove by setting cap = 0.
55     // Onwer can also change it at any time
56     function listAddress( address _user, uint _cap ) public onlyOwner {
57         addressCap[_user] = _cap;
58         ListAddress( _user, _cap, now );
59     }
60 
61     // an optimization in case of network congestion
62     function listAddresses( address[] _users, uint[] _cap ) public onlyOwner {
63         require(_users.length == _cap.length );
64         for( uint i = 0 ; i < _users.length ; i++ ) {
65             listAddress( _users[i], _cap[i] );
66         }
67     }
68 
69     function setUsersCap( uint _cap ) public  onlyOwner {
70         communityusersCap = _cap;
71     }
72 
73     function getCap( address _user ) public constant returns(uint) {
74         uint cap = addressCap[_user];
75         if( cap == 1 ) return communityusersCap;
76         else return cap;
77     }
78 
79     function destroy() public onlyOwner {
80         selfdestruct(owner);
81     }
82 }