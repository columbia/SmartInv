1 pragma solidity ^0.4.19;
2 
3 /*
4 @title Address Handle Service aka AHS
5 @author Ghilia Weldesselasie, founder of D-OZ and genius extraordinaire
6 @twitter: @ghiliweld, my DMs are open so slide through if you trynna chat ;)
7 
8 This is a simple alternative to ENS I made cause ENS was too complicated
9 for me to understand which seemed odd since it should be simple in my opinion.
10 
11 Please donate if you like it, all the proceeds go towards funding D-OZ, my project.
12 */
13 
14 contract Ownable {
15     address public owner;
16 
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24     function Ownable() public {
25         owner = msg.sender;
26     }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 
46 }
47 
48 
49 contract HandleLogic is Ownable {
50 
51     uint256 public price; // price in Wei
52 
53     mapping (bytes32 => mapping (bytes32 => address)) public handleIndex; // base => handle => address
54     mapping (bytes32 => bool) public baseRegistred; // tracks if a base is registered or not
55     mapping (address => mapping (bytes32 => bool)) public ownsBase; // tracks who owns a base and returns a bool
56 
57     event NewBase(bytes32 _base, address indexed _address);
58     event NewHandle(bytes32 _base, bytes32 _handle, address indexed _address);
59     event BaseTransfered(bytes32 _base, address indexed _to);
60 
61     function registerBase(bytes32 _base) public payable {
62         require(msg.value >= price); // you have to pay the price
63         require(!baseRegistred[_base]); // the base can't already be registered
64         baseRegistred[_base] = true; // registers base
65         ownsBase[msg.sender][_base] = true; // you now own the base
66         NewBase(_base, msg.sender);
67     }
68 
69     function registerHandle(bytes32 _base, bytes32 _handle, address _addr) public {
70         require(baseRegistred[_base]); // the base must exist
71         require(_addr != address(0)); // no uninitialized addresses
72         require(ownsBase[msg.sender][_base]); // msg.sender must own the base
73         handleIndex[_base][_handle] = _addr; // an address gets tied to your AHS handle
74         NewHandle(_base, _handle, msg.sender);
75     }
76 
77     function transferBase(bytes32 _base, address _newAddress) public {
78         require(baseRegistred[_base]); // the base must exist
79         require(_newAddress != address(0)); // no uninitialized addresses
80         require(ownsBase[msg.sender][_base]); // .sender must own the base
81         ownsBase[msg.sender][_base] = false; // relinquish your ownership of the base...
82         ownsBase[_newAddress][_base] = true; // ... and give it to someone else
83         BaseTransfered(_base, msg.sender);
84     }
85 
86     //get price of a base
87     function getPrice() public view returns(uint256) {
88         return price;
89     }
90 
91     // search for an address in the handleIndex mapping
92     function findAddress(bytes32 _base, bytes32 _handle) public view returns(address) {
93         return handleIndex[_base][_handle];
94     }
95 
96     // check if a base is registered
97     function isRegistered(bytes32 _base) public view returns(bool) {
98         return baseRegistred[_base];
99     }
100 
101     // check if an address owns a base
102     function doesOwnBase(bytes32 _base, address _addr) public view returns(bool) {
103         return ownsBase[_addr][_base];
104     }
105 }
106 
107 
108 contract AHS is HandleLogic {
109 
110     function AHS(uint256 _price, bytes32 _ethBase, bytes32 _weldBase) public {
111         price = _price;
112         getBaseQuick(_ethBase);
113         getBaseQuick(_weldBase);
114     }
115 
116     function () public payable {} // donations are optional
117 
118     function getBaseQuick(bytes32 _base) public {
119         require(msg.sender == owner); // Only I can call this function
120         require(!baseRegistred[_base]); // the base can't be registered yet, stops me from snatching someone else's base
121         baseRegistred[_base] = true; // I register the base
122         ownsBase[owner][_base] = true; // the ownership gets passed on to me
123         NewBase(_base, msg.sender);
124     }
125 
126     function withdraw() public {
127         require(msg.sender == owner); // Only I can call this function
128         owner.transfer(this.balance);
129     }
130 
131     function changePrice(uint256 _price) public {
132         require(msg.sender == owner); // Only I can call this function
133         price = _price;
134     }
135 
136 }