1 pragma solidity ^0.4.25;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that revert on error
6 */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 // Setup Movecoin contract interface
68 contract ERC20MOVEInterface {
69     function balanceOf(address owner) public view returns (uint256);
70     function allowance(address owner, address spender) public view returns (uint256);
71     function burnFrom(address from, uint256 value) public;
72 }
73 
74 // CO2 Certificate "struct"
75 contract CO2Certificate {
76     using SafeMath for uint256;
77 
78     uint256 private _burnedTokens;
79     uint256 private _certifiedKilometers;
80     string  private _ownerName;
81 
82     constructor (uint256 burnedTokens, uint256 certifiedKilometers, string ownerName) public {
83         require (burnedTokens > 0, "You must burn at least one token");
84         require (certifiedKilometers >= 0, "Certified Kilometers must be positive");
85         
86         _burnedTokens = burnedTokens;
87         _certifiedKilometers = certifiedKilometers;
88         _ownerName = ownerName;
89     }
90 
91     // Getters
92     function getBurnedTokens() public view returns(uint256) {
93         return _burnedTokens;
94     }
95 
96     function getCertifiedKilometers() public view returns(uint256) {
97         return _certifiedKilometers;
98     }
99 
100     function getOwnerName() public view returns(string) {
101         return _ownerName;
102     }
103 
104 }
105 
106 // Smart contract for certificate authority
107 contract MovecoinCertificationAuthority {
108     using SafeMath for uint256;
109 
110     // Mapping address to CO2Certificate
111     mapping (address => address) private _certificates;
112     
113     // Internal addresses
114     address private _owner;
115     address private _moveAddress;
116 
117     // Events
118     event certificateIssued(uint256 tokens, uint256 kilometers, string ownerName, address certificateAddress);
119 
120     modifier onlymanager()
121     {
122         require(msg.sender == _owner, "Only Manager can access this function");
123         _;
124     }
125 
126     // When deploying the contract you must specify the address of the ERC20 MOVE Token and the address of the owner
127     constructor (address moveAddress) public {
128         require(moveAddress != address(0), "MOVE ERC20 Address cannot be null");
129         _owner = msg.sender;
130         _moveAddress = moveAddress;
131     }
132 
133     /**
134     * @dev Allows the current owner to transfer control of the contract to a new manager.
135     * @param newManager The address to transfer ownership to.
136     */
137     function transferManager(address newManager) public onlymanager {
138         require(newManager != address(0), "Manager cannot be null");
139         _owner = newManager;
140     }
141 
142     /**
143     * @dev Get issued certificate for that address
144     * @param certOwner the certificate owner address
145     */
146     function getCertificateAddress(address certOwner) public view returns (address) {
147         require(certOwner != address(0), "Certificate owner cannot be null");
148         return _certificates[certOwner];
149     } 
150 
151     /**
152     * @dev Get issued certificate data for that address
153     * @param certOwner the certificate owner address
154     */
155     function getCertificateData(address certOwner) public view returns (uint256, uint256, string) {
156         require(certOwner != address(0), "Certificate owner cannot be null");
157 
158         CO2Certificate cert = CO2Certificate(_certificates[certOwner]);
159 
160         return (
161             cert.getBurnedTokens(),
162             cert.getCertifiedKilometers(),
163             cert.getOwnerName()
164         );
165     }
166 
167     // Notice: certificateReceiver must allow MovecoinCertificationAuthority to burn his tokens using approve ERC20 function
168     function issueNewCertificate(
169         address certificateReceiver,
170         uint256 tokensToBurn, 
171         uint256 kilomitersToCertify, 
172         string certificateReceiverName
173     ) public onlymanager {
174 
175         // Initialize movecoin contract
176         ERC20MOVEInterface movecoin = ERC20MOVEInterface(_moveAddress);
177 
178         // Check if the receiver really haves tokens
179         require(tokensToBurn <= movecoin.balanceOf(certificateReceiver), "Certificate receiver must have tokens");
180 
181         // Check if we are allowed to move this tokens
182         require(
183             tokensToBurn <= movecoin.allowance(certificateReceiver, this),
184             "CO2 Contract is not allowed to burn tokens in behalf of certificate receiver"
185         );
186 
187         // Finally Burn tokens
188         movecoin.burnFrom(certificateReceiver, tokensToBurn);
189 
190         // Issue new certificate if burned tokens succeed
191         address Certificate = new CO2Certificate(tokensToBurn, kilomitersToCertify, certificateReceiverName);
192         _certificates[certificateReceiver] = Certificate;
193 
194         emit certificateIssued(tokensToBurn, kilomitersToCertify, certificateReceiverName, Certificate);
195     }
196 
197 }