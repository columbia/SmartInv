1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 
78 
79 
80 /**
81  * @title Claimable
82  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
83  * This allows the new owner to accept the transfer.
84  */
85 contract Claimable is Ownable {
86     address public pendingOwner;
87 
88     /**
89      * @dev Modifier throws if called by any account other than the pendingOwner.
90      */
91     modifier onlyPendingOwner() {
92         require(msg.sender == pendingOwner);
93         _;
94     }
95 
96     /**
97      * @dev Allows the current owner to set the pendingOwner address.
98      * @param newOwner The address to transfer ownership to.
99      */
100     function transferOwnership(address newOwner) onlyOwner public {
101         pendingOwner = newOwner;
102     }
103 
104     /**
105      * @dev Allows the pendingOwner address to finalize the transfer.
106      */
107     function claimOwnership() onlyPendingOwner public {
108         OwnershipTransferred(owner, pendingOwner);
109         owner = pendingOwner;
110         pendingOwner = address(0);
111     }
112 }
113 
114 
115 
116 contract CrowdFunding is Claimable {
117     using SafeMath for uint256;
118 
119     // =================================================================================================================
120     //                                      Members
121     // =================================================================================================================
122 
123     // the wallet of the beneficiary
124     address public walletBeneficiary;
125 
126     // amount of raised money in wei
127     uint256 public weiRaised;
128 
129     // indicate if the crowd funding is ended
130     bool public isFinalized = false;
131 
132     // =================================================================================================================
133     //                                      Modifiers
134     // =================================================================================================================
135 
136     modifier isNotFinalized() {
137         require(!isFinalized);
138         _;
139     }
140 
141     // =================================================================================================================
142     //                                      Events
143     // =================================================================================================================
144 
145     event DonateAdded(address indexed _from, address indexed _to,uint256 _amount);
146 
147     event Finalized();
148 
149     event ClaimBalance(address indexed _grantee, uint256 _amount);
150 
151     // =================================================================================================================
152     //                                      Constructors
153     // =================================================================================================================
154 
155     function CrowdFunding(address _walletBeneficiary) public {
156         require(_walletBeneficiary != address(0));
157         walletBeneficiary = _walletBeneficiary;
158     }
159 
160     // =================================================================================================================
161     //                                      Public Methods
162     // =================================================================================================================
163 
164     function deposit() onlyOwner isNotFinalized external payable {
165     }
166 
167     function() external payable {
168         donate();
169     }
170 
171     function donate() public payable {
172         require(!isFinalized);
173 
174         uint256 weiAmount = msg.value;
175         
176         // transfering the donator funds to the beneficiary
177         weiRaised = weiRaised.add(weiAmount);
178         walletBeneficiary.transfer(weiAmount);
179         DonateAdded(msg.sender, walletBeneficiary, weiAmount);
180 
181         // transfering the owner funds to the beneficiary with the same amount of the donator
182         if(this.balance >= weiAmount) {
183             weiRaised = weiRaised.add(weiAmount);
184             walletBeneficiary.transfer(weiAmount);
185             DonateAdded(address(this), walletBeneficiary, weiAmount);
186         } else {
187 
188             weiRaised = weiRaised.add(this.balance);
189             // if not enough funds in the owner contract - transfer the remaining balance
190             walletBeneficiary.transfer(this.balance);
191             DonateAdded(address(this), walletBeneficiary, this.balance);
192         }
193     }
194 
195     // allow the owner to claim his the contract balance at any time
196     function claimBalanceByOwner(address beneficiary) onlyOwner isNotFinalized public {
197         require(beneficiary != address(0));
198 
199         uint256 weiAmount = this.balance;
200         beneficiary.transfer(weiAmount);
201 
202         ClaimBalance(beneficiary, weiAmount);
203     }
204 
205     function finalizeDonation(address beneficiary) onlyOwner isNotFinalized public {
206         require(beneficiary != address(0));
207 
208         claimBalanceByOwner(beneficiary);
209         isFinalized = true;
210 
211         Finalized();
212     }
213 }