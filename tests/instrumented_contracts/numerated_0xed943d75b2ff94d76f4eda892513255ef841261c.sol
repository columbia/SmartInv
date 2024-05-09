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
44 
45 
46 contract KyberContirbutorWhitelist is Ownable {
47     mapping(address=>uint) addressCap;
48     
49     function KyberContirbutorWhitelist() {}
50     
51     event ListAddress( address _user, uint _cap, uint _time );
52     
53     // Owner can delist by setting cap = 0.
54     // Onwer can also change it at any time
55     function listAddress( address _user, uint _cap ) onlyOwner {
56         addressCap[_user] = _cap;
57         ListAddress( _user, _cap, now );
58     }
59     
60     function getCap( address _user ) constant returns(uint) {
61         return addressCap[_user];
62     }
63 }