1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 
76 contract token { function transfer(address receiver, uint amount){  } }
77 
78 contract SendTokensContract is Ownable {
79   using SafeMath for uint;
80   mapping (address => uint) public bals;
81   mapping (address => uint) public releaseTimes;
82   mapping (address => bytes32[]) public referenceCodes;
83   mapping (bytes32 => address[]) public referenceAddresses;
84   address public addressOfTokenUsedAsReward;
85   token tokenReward;
86 
87   event TokensSent
88     (address to, uint256 value, uint256 timeStamp, bytes32 referenceCode);
89 
90   function setTokenReward(address _tokenContractAddress) public onlyOwner {
91     tokenReward = token(_tokenContractAddress);
92     addressOfTokenUsedAsReward = _tokenContractAddress;
93   }
94 
95   function sendTokens(address _to, 
96     uint _value, 
97     uint _timeStamp, 
98     bytes32 _referenceCode) public onlyOwner {
99     bals[_to] = bals[_to].add(_value);
100     releaseTimes[_to] = _timeStamp;
101     referenceCodes[_to].push(_referenceCode);
102     referenceAddresses[_referenceCode].push(_to);
103     emit TokensSent(_to, _value, _timeStamp, _referenceCode);
104   }
105 
106   function getReferenceCodesOfAddress(address _addr) public constant 
107   returns (bytes32[] _referenceCodes) {
108     return referenceCodes[_addr];
109   }
110 
111   function getReferenceAddressesOfCode(bytes32 _code) public constant
112   returns (address[] _addresses) {
113     return referenceAddresses[_code];
114   }
115 
116   function withdrawTokens() public {
117     require(bals[msg.sender] > 0);
118     require(now >= releaseTimes[msg.sender]);
119     tokenReward.transfer(msg.sender,bals[msg.sender]);
120     bals[msg.sender] = 0;
121   }
122 }