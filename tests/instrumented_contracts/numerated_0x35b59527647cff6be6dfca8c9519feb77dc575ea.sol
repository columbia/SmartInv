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
40 contract BigbomContributorWhiteList is Ownable {
41     mapping(address=>uint) public addressMinCap;
42     mapping(address=>uint) public addressMaxCap;
43 
44     function BigbomContributorWhiteList() public  {}
45 
46     event ListAddress( address _user, uint _mincap, uint _maxcap, uint _time );
47 
48     // Owner can delist by setting cap = 0.
49     // Onwer can also change it at any time
50     function listAddress( address _user, uint _mincap, uint _maxcap ) public onlyOwner {
51         require(_mincap <= _maxcap);
52         require(_user != address(0x0));
53 
54         addressMinCap[_user] = _mincap;
55         addressMaxCap[_user] = _maxcap;
56         ListAddress( _user, _mincap, _maxcap, now );
57     }
58 
59     // an optimization in case of network congestion
60     function listAddresses( address[] _users, uint[] _mincap, uint[] _maxcap ) public  onlyOwner {
61         require(_users.length == _mincap.length );
62         require(_users.length == _maxcap.length );
63         for( uint i = 0 ; i < _users.length ; i++ ) {
64             listAddress( _users[i], _mincap[i], _maxcap[i] );
65         }
66     }
67 
68     function getMinCap( address _user ) public constant returns(uint) {
69         return addressMinCap[_user];
70     }
71     function getMaxCap( address _user ) public constant returns(uint) {
72         return addressMaxCap[_user];
73     }
74 
75 }