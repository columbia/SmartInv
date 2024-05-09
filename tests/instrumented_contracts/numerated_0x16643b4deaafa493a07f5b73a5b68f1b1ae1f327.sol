1 contract Ownable {
2   address public owner;
3 
4 
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 
8   /**
9    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10    * account.
11    */
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16 
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 
39 
40 contract Curatable is Ownable {
41   address public curator;
42 
43 
44   event CurationRightsTransferred(address indexed previousCurator, address indexed newCurator);
45 
46 
47   /**
48    * @dev The Curatable constructor sets the original `curator` of the contract to the sender
49    * account.
50    */
51   function Curatable() public {
52     owner = msg.sender;
53     curator = owner;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the curator.
59    */
60   modifier onlyCurator() {
61     require(msg.sender == curator);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newCurator The address to transfer ownership to.
69    */
70   function transferCurationRights(address newCurator) public onlyOwner {
71     require(newCurator != address(0));
72     CurationRightsTransferred(curator, newCurator);
73     curator = newCurator;
74   }
75 
76 }
77 
78 contract Whitelist is Curatable {
79     mapping (address => bool) public whitelist;
80 
81 
82     function Whitelist() public {
83     }
84 
85 
86     function addInvestor(address investor) external onlyCurator {
87         require(investor != 0x0 && !whitelist[investor]);
88         whitelist[investor] = true;
89     }
90 
91 
92     function removeInvestor(address investor) external onlyCurator {
93         require(investor != 0x0 && whitelist[investor]);
94         whitelist[investor] = false;
95     }
96 
97 
98     function isWhitelisted(address investor) constant external returns (bool result) {
99         return whitelist[investor];
100     }
101 
102 }