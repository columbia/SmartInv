1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 contract Raindrop is Ownable {
44 
45   // Event for when an address is authenticated
46   event AuthenticateEvent(
47       uint partnerId,
48       address indexed from,
49       uint value
50       );
51 
52   // Event for when an address is whitelisted to authenticate
53   event WhitelistEvent(
54       uint partnerId,
55       address target,
56       bool whitelist
57       );
58 
59   address public hydroContract = 0x0;
60 
61   mapping (uint => mapping (address => bool)) public whitelist;
62   mapping (uint => mapping (address => partnerValues)) public partnerMap;
63   mapping (uint => mapping (address => hydroValues)) public hydroPartnerMap;
64 
65   struct partnerValues {
66       uint value;
67       uint challenge;
68   }
69 
70   struct hydroValues {
71       uint value;
72       uint timestamp;
73   }
74 
75   function setHydroContractAddress(address _addr) public onlyOwner {
76       hydroContract = _addr;
77   }
78 
79   /* Function to whitelist partner address. Can only be called by owner */
80   function whitelistAddress(address _target, bool _whitelistBool, uint _partnerId) public onlyOwner {
81       whitelist[_partnerId][_target] = _whitelistBool;
82       emit WhitelistEvent(_partnerId, _target, _whitelistBool);
83   }
84 
85   /* Function to authenticate user
86      Restricted to whitelisted partners */
87   function authenticate(address _sender, uint _value, uint _challenge, uint _partnerId) public {
88       require(msg.sender == hydroContract);
89       require(whitelist[_partnerId][_sender]);         // Make sure the sender is whitelisted
90       require(hydroPartnerMap[_partnerId][_sender].value == _value);
91       updatePartnerMap(_sender, _value, _challenge, _partnerId);
92       emit AuthenticateEvent(_partnerId, _sender, _value);
93   }
94 
95   function checkForValidChallenge(address _sender, uint _partnerId) public view returns (uint value){
96       if (hydroPartnerMap[_partnerId][_sender].timestamp > block.timestamp){
97           return hydroPartnerMap[_partnerId][_sender].value;
98       }
99       return 1;
100   }
101 
102   /* Function to update the hydroValuesMap. Called exclusively from the Hydro API */
103   function updateHydroMap(address _sender, uint _value, uint _partnerId) public onlyOwner {
104       hydroPartnerMap[_partnerId][_sender].value = _value;
105       hydroPartnerMap[_partnerId][_sender].timestamp = block.timestamp + 1 days;
106   }
107 
108   /* Function called by Hydro API to check if the partner has validated
109    * The partners value and data must match and it must be less than a day since the last authentication
110    */
111   function validateAuthentication(address _sender, uint _challenge, uint _partnerId) public constant returns (bool _isValid) {
112       if (partnerMap[_partnerId][_sender].value == hydroPartnerMap[_partnerId][_sender].value
113       && block.timestamp < hydroPartnerMap[_partnerId][_sender].timestamp
114       && partnerMap[_partnerId][_sender].challenge == _challenge) {
115           return true;
116       }
117       return false;
118   }
119 
120   /* Function to update the partnerValuesMap with their amount and challenge string */
121   function updatePartnerMap(address _sender, uint _value, uint _challenge, uint _partnerId) internal {
122       partnerMap[_partnerId][_sender].value = _value;
123       partnerMap[_partnerId][_sender].challenge = _challenge;
124   }
125 
126 }