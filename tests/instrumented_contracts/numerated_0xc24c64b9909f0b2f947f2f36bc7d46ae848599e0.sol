1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33 
34   /** 
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = (0x34c49f0Bf5616c77435509707D42441F4B2613cc);
40   }
41 
42 
43   /**
44    * @dev Throws if called by any account other than the owner. 
45    */
46   modifier onlyOwner() {
47     if (msg.sender != owner) {
48       revert();
49     }
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to. 
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     if (newOwner != address(0)) {
60       owner = newOwner;
61     }
62   }
63 
64 }
65 
66 contract Token{
67   function transfer(address to, uint value) public returns (bool);
68 }
69 
70 contract NortonDropper is Ownable {
71 
72     function multisend(address _tokenAddr, address[] _to, uint256[] _value) public
73     returns (bool _success) {
74         assert(_to.length == _value.length);
75         assert(_to.length <= 150);
76         // loop through to addresses and send value to every address specified
77         for (uint8 i = 0; i < _to.length; i++) {
78                 assert((Token(_tokenAddr).transfer(_to[i], _value[i])) == true);
79             }
80             return true;
81         }
82 }