1 pragma solidity ^0.4.24;
2 contract random{
3     using SafeMath for uint;
4     
5     uint256 constant private FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;
6     
7     address[] private authorities;
8     mapping (address => bool) private authorized;
9     //This is adminstrator address ,only the administartor can add the authorized address or remove it
10     address private adminAddress=0x154210143d7814F8A60b957f3CDFC35357fFC89C;
11 
12      modifier onlyAuthorized {
13         require(authorized[msg.sender]);
14         _;
15     }
16 
17      modifier onlyAuthorizedAdmin {
18         require(adminAddress == msg.sender);
19         _;
20     }
21     modifier targetAuthorized(address target) {
22         require(authorized[target]);
23         _;
24     }
25 
26     modifier targetNotAuthorized(address target) {
27         require(!authorized[target]);
28         _;
29     }
30 
31     //################Event#######################################
32     event LOG_RANDOM(uint256 indexed roundIndex  ,uint256 randomNumber);
33     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
34     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
35 
36 
37     //################Authorized function#########################
38     function addAuthorizedAddress(address target)
39         public
40         onlyAuthorizedAdmin
41         targetNotAuthorized(target)
42     {
43         authorized[target] = true;
44         authorities.push(target);
45         emit LogAuthorizedAddressAdded(target, msg.sender);
46     }
47 
48     ///  Removes authorizion of an address.
49     /// @param target Address to remove authorization from.
50     function removeAuthorizedAddress(address target)
51         public
52         onlyAuthorizedAdmin
53         targetAuthorized(target)
54     {
55         delete authorized[target];
56         for (uint i = 0; i < authorities.length; i++) {
57             if (authorities[i] == target) {
58                 authorities[i] = authorities[authorities.length - 1];
59                 authorities.length -= 1;
60                 break;
61             }
62         }
63         emit LogAuthorizedAddressRemoved(target, msg.sender);
64     }
65 
66     //################Random number generate function#########################
67     function rand(uint min, uint max,address tokenAddress, uint256 roundIndex)
68       public  
69       onlyAuthorized
70       returns(uint256) 
71       {
72         uint256 factor = FACTOR * 100 / max;
73    
74   
75         uint256 seed = uint256(keccak256(abi.encodePacked(
76             (roundIndex).add
77             (block.timestamp).add
78             (block.difficulty).add
79             ((uint256(keccak256(abi.encodePacked(tokenAddress)))) / (now)).add
80             (block.gaslimit).add
81             (block.number)
82             
83         )));
84        
85         uint256 r=uint256(uint256(seed) / factor)  % max +min;
86 
87          emit LOG_RANDOM(roundIndex,r);
88          return(r);
89        
90 }
91     
92 }
93 
94 
95 library SafeMath {
96 
97   function mul(uint a, uint b) internal pure returns (uint) {
98     if (a == 0) {
99       return 0;
100     }
101     uint c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   function div(uint a, uint b) internal pure returns (uint) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     uint c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return c;
111   }
112 
113   function sub(uint a, uint b) internal pure returns (uint) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   function add(uint a, uint b) internal pure returns (uint) {
119     uint c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 }