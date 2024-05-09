1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36      * @dev Allows the current owner to relinquish control of the contract.
37      * @notice Renouncing to ownership will leave the contract without an owner.
38      * It will not be possible to call the functions with the `onlyOwner`
39      * modifier anymore.
40      */
41     function renounceOwnership() public onlyOwner {
42         emit OwnershipRenounced(owner);
43         owner = address(0);
44     }
45 
46     /**
47      * @dev Allows the current owner to transfer control of the contract to a newOwner.
48      * @param _newOwner The address to transfer ownership to.
49      */
50     function transferOwnership(address _newOwner) public onlyOwner {
51         _transferOwnership(_newOwner);
52     }
53 
54     /**
55      * @dev Transfers control of the contract to a newOwner.
56      * @param _newOwner The address to transfer ownership to.
57      */
58     function _transferOwnership(address _newOwner) internal {
59         require(_newOwner != address(0));
60         emit OwnershipTransferred(owner, _newOwner);
61         owner = _newOwner;
62     }
63 }
64 
65 
66 /**
67  * @title KYC contract interface
68  */
69 contract KYC {
70     
71     /**
72      * Get KYC expiration timestamp in second.
73      *
74      * @param _who Account address
75      * @return KYC expiration timestamp in second
76      */
77     function expireOf(address _who) external view returns (uint256);
78 
79     /**
80      * Get KYC level.
81      * Level is ranging from 0 (lowest, no KYC) to 255 (highest, toughest).
82      *
83      * @param _who Account address
84      * @return KYC level
85      */
86     function kycLevelOf(address _who) external view returns (uint8);
87 
88     /**
89      * Get encoded nationalities (country list).
90      * The uint256 is represented by 256 bits (0 or 1).
91      * Every bit can represent a country.
92      * For each listed country, set the corresponding bit to 1.
93      * To do so, up to 256 countries can be encoded in an uint256 variable.
94      * Further, if country blacklist of an ICO was encoded by the same way,
95      * it is able to use bitwise AND to check whether the investor can invest
96      * the ICO by the crowdsale.
97      *
98      * @param _who Account address
99      * @return Encoded nationalities
100      */
101     function nationalitiesOf(address _who) external view returns (uint256);
102 
103     /**
104      * Set KYC status to specific account address.
105      *
106      * @param _who Account address
107      * @param _expiresAt Expire timestamp in seconds
108      * @param _level KYC level
109      * @param _nationalities Encoded nationalities
110      */
111     function setKYC(
112         address _who, uint256 _expiresAt, uint8 _level, uint256 _nationalities) 
113         external;
114 
115     event KYCSet (
116         address indexed _setter,
117         address indexed _who,
118         uint256 _expiresAt,
119         uint8 _level,
120         uint256 _nationalities
121     );
122 }
123 
124 
125 /**
126  * @title Fusions KYC contract
127  */
128 contract FusionsKYC is KYC, Ownable {
129 
130     struct KYCStatus {
131         uint256 expires;
132         uint8 kycLevel;
133         uint256 nationalities;
134     }
135 
136     mapping(address => KYCStatus) public kycStatuses;
137 
138     function expireOf(address _who) 
139         external view returns (uint256)
140     {
141         return kycStatuses[_who].expires;
142     }
143 
144     function kycLevelOf(address _who)
145         external view returns (uint8)
146     {
147         return kycStatuses[_who].kycLevel;
148     }
149 
150     function nationalitiesOf(address _who) 
151         external view returns (uint256)
152     {
153         return kycStatuses[_who].nationalities;
154     }    
155     
156     function setKYC(
157         address _who, 
158         uint256 _expiresAt,
159         uint8 _level,
160         uint256 _nationalities
161     )
162         external
163         onlyOwner
164     {
165         require(
166             _who != address(0),
167             "Failed to set expiration due to address is 0x0."
168         );
169 
170         emit KYCSet(
171             msg.sender,
172             _who,
173             _expiresAt,
174             _level,
175             _nationalities
176         );
177 
178         kycStatuses[_who].expires = _expiresAt;
179         kycStatuses[_who].kycLevel = _level;
180         kycStatuses[_who].nationalities = _nationalities;
181     }
182 }