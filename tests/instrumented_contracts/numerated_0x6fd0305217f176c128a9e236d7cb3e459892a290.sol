1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     if (newOwner != address(0)) {
34       owner = newOwner;
35     }
36   }
37 
38 }
39 
40 contract BigbomPrivateSaleList is Ownable {
41     mapping(address=>uint) public addressCap;
42 
43     function BigbomPrivateSaleList() public  {}
44 
45     event ListAddress( address _user, uint _amount, uint _time );
46 
47     // Owner can delist by setting amount = 0.
48     // Onwer can also change it at any time
49     function listAddress( address _user, uint _amount ) public onlyOwner {
50         require(_user != address(0x0));
51 
52         addressCap[_user] = _amount;
53         ListAddress( _user, _amount, now );
54     }
55 
56     // an optimization in case of network congestion
57     function listAddresses( address[] _users, uint[] _amount ) public onlyOwner {
58         require(_users.length == _amount.length );
59         for( uint i = 0 ; i < _users.length ; i++ ) {
60             listAddress( _users[i], _amount[i] );
61         }
62     }
63 
64     function getCap( address _user ) public constant returns(uint) {
65         return addressCap[_user];
66     }
67 
68 }