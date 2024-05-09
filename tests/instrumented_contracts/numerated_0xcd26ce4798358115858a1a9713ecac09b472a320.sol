1 pragma solidity ^0.4.19;
2 
3 
4 contract ERC20 {
5   // We want to be able to recover & donate any tokens sent to the contract.
6   function balanceOf(address _who) public view returns (uint256);
7   function transfer(address _to, uint256 _value) public returns (bool);
8 }
9 
10 
11 contract theCyberInterface {
12   // The utility contract can call the following methods of theCyber.
13   function newMember(uint8 _memberId, bytes32 _memberName, address _memberAddress) public;
14   function proclaimInactive(uint8 _memberId) public;
15   function heartbeat() public;
16   function revokeMembership(uint8 _memberId) public;
17   function getMembershipStatus(address _memberAddress) public view returns (bool member, uint8 memberId);
18   function getMemberInformation(uint8 _memberId) public view returns (bytes32 memberName, string memberKey, uint64 memberSince, uint64 inactiveSince, address memberAddress);
19   function maxMembers() public pure returns(uint16);
20   function inactivityTimeout() public pure returns(uint64);
21   function donationAddress() public pure returns(address);
22 }
23 
24 
25 contract theCyberMemberUtilities {
26   // This contract provides a set of helper functions that members of theCyber
27   // may call in order to perform more advanced operations. In order to interact
28   // with theCyber, the contract must first be assigned as a member.
29 
30   event MembershipStatusSet(bool isMember, uint8 memberId);
31   event FundsDonated(uint256 value);
32   event TokensDonated(address tokenContractAddress, uint256 value);
33 
34   // Set the address and interface of theCyber.
35   address private constant THECYBERADDRESS_ = 0x97A99C819544AD0617F48379840941eFbe1bfAE1;
36   theCyberInterface theCyber = theCyberInterface(THECYBERADDRESS_);
37 
38   // Set up variables for checking the contract's membership status.
39   bool private isMember_;
40   uint8 private memberId_;
41 
42   // The max members, inactivity timeout, and the donation address are pulled
43   // from theCyber inside the constructor function.
44   uint16 private maxMembers_;
45   uint64 private inactivityTimeout_;
46   address private donationAddress_;
47 
48   // Batch operations on all members utilize incrementing member ids.
49   uint8 private nextInactiveMemberIndex_;
50   uint8 private nextRevokedMemberIndex_;
51 
52   // Methods of the utility contract can only be called by a valid member.
53   modifier membersOnly() {
54     // Only allow transactions originating from a valid member address.
55     bool member;
56     (member,) = theCyber.getMembershipStatus(msg.sender);
57     require(member);
58     _;
59   }
60 
61   // In the constructor function, set up the max members, the inactivity
62   // timeout, and the donation address.
63   function theCyberMemberUtilities() public {
64     // Set the maximum number of members.
65     maxMembers_ = theCyber.maxMembers();
66 
67     // Set the inactivity timeout.
68     inactivityTimeout_ = theCyber.inactivityTimeout();
69 
70     // Set the donation address.
71     donationAddress_ = theCyber.donationAddress();
72 
73     // Set the initial membership status to false.
74     isMember_ = false;
75 
76     // Start the inactive member index at 0.
77     nextInactiveMemberIndex_ = 0;
78 
79     // Start the revoked member index at 0.
80     nextRevokedMemberIndex_ = 0;
81   }
82 
83   // Set the member id of the utility contract prior to calling batch methods.
84   function setMembershipStatus() public membersOnly {
85     // Set the membership status and member id of the utility contract.
86     (isMember_,memberId_) = theCyber.getMembershipStatus(this);
87 
88     // Log the membership status of the utility contract.
89     MembershipStatusSet(isMember_, memberId_);
90   }
91 
92   // The utility contract must be able to heartbeat if it is marked as inactive.
93   function heartbeat() public membersOnly {
94     // Heartbeat the utility contract.
95     theCyber.heartbeat();
96   }
97 
98   // Revoke a membership and immediately assign the membership to a new member.
99   function revokeAndSetNewMember(uint8 _memberId, bytes32 _memberName, address _memberAddress) public membersOnly {
100     // Revoke the membership (provided it has been inactive for long enough).
101     theCyber.revokeMembership(_memberId);
102 
103     // Assign a new member to the membership (provided the new member is valid).
104     theCyber.newMember(_memberId, _memberName, _memberAddress);
105   }
106 
107   // Mark all members (except this contract & msg.sender) as inactive.
108   function proclaimAllInactive() public membersOnly returns (bool complete) {
109     // The utility contract must be a member (and therefore have a member id).
110     require(isMember_);
111 
112     // Get the memberId of the calling member.
113     uint8 callingMemberId;
114     (,callingMemberId) = theCyber.getMembershipStatus(msg.sender);
115 
116     // Initialize variables for checking the status of each membership.
117     uint64 inactiveSince;
118     address memberAddress;
119     
120     // Pick up where the function last left off in assigning new members.
121     uint8 i = nextInactiveMemberIndex_;
122 
123     // make sure that the loop triggers at least once.
124     require(msg.gas > 175000);
125 
126     // Loop through members as long as sufficient gas remains.
127     while (msg.gas > 170000) {
128       // Make sure that the target membership is owned and active.
129       (,,,inactiveSince,memberAddress) = theCyber.getMemberInformation(i);
130       if ((i != memberId_) && (i != callingMemberId) && (memberAddress != address(0)) && (inactiveSince == 0)) {
131         // Mark the member as inactive.
132         theCyber.proclaimInactive(i);
133       }
134       // Increment the index to point to the next member id.
135       i++;
136 
137       // exit once the index overflows.
138       if (i == 0) {
139         break;
140       }
141     }
142 
143     // Set the index where the function left off.
144     nextInactiveMemberIndex_ = i;
145     return (i == 0);
146   }
147 
148   // Allow members to circumvent the safety measure against self-inactivation.
149   function inactivateSelf() public membersOnly {
150     // Get the memberId of the calling member.
151     uint8 memberId;
152     (,memberId) = theCyber.getMembershipStatus(msg.sender);
153 
154     // Inactivate the membership (provided it is not already marked inactive).
155     theCyber.proclaimInactive(memberId);
156   }
157 
158   // Revoke all memberships (except those of the utility contract & msg.sender)
159   // that have been inactive for longer than the inactivity timeout.
160   function revokeAllVulnerable() public membersOnly returns (bool complete) {
161     // The utility contract must be a member (and therefore have a member id).
162     require(isMember_);
163 
164     // Get the memberId of the calling member.
165     uint8 callingMemberId;
166     (,callingMemberId) = theCyber.getMembershipStatus(msg.sender);
167 
168     // Initialize variables for checking the status of each membership.
169     uint64 inactiveSince;
170     address memberAddress;
171     
172     // Pick up where the function last left off in assigning new members.
173     uint8 i = nextRevokedMemberIndex_;
174 
175     // make sure that the loop triggers at least once.
176     require(msg.gas > 175000);
177 
178     // Loop through members as long as sufficient gas remains.
179     while (msg.gas > 175000) {
180       // Make sure that the target membership is owned and inactive long enough.
181       (,,,inactiveSince,memberAddress) = theCyber.getMemberInformation(i);
182       if ((i != memberId_) && (i != callingMemberId) && (memberAddress != address(0)) && (inactiveSince != 0) && (now >= inactiveSince + inactivityTimeout_)) {
183         // Revoke the member.
184         theCyber.revokeMembership(i);
185       }
186       // Increment the index to point to the next member id.
187       i++;
188 
189       // exit once the index overflows.
190       if (i == 0) {
191         break;
192       }
193     }
194 
195     // Set the index where the function left off.
196     nextRevokedMemberIndex_ = i;
197     return (i == 0);
198   }
199 
200   // Allow members to circumvent the safety measure against self-revokation.
201   function revokeSelf() public membersOnly {
202     // Get the memberId of the calling member.
203     uint8 memberId;
204     (,memberId) = theCyber.getMembershipStatus(msg.sender);
205 
206     // Revoke the membership (provided it has been inactive for long enough).
207     theCyber.revokeMembership(memberId);
208   }
209 
210   // The contract is not payable by design, but could end up with a balance as
211   // a recipient of a selfdestruct / coinbase of a mined block.
212   function donateFunds() public membersOnly {
213     // Log the donation of any funds that have made their way into the contract.
214     FundsDonated(this.balance);
215 
216     // Send all available funds to the donation address.
217     donationAddress_.transfer(this.balance);
218   }
219 
220   // We also want to be able to access any tokens that are sent to the contract.
221   function donateTokens(address _tokenContractAddress) public membersOnly {
222     // Make sure that we didn't pass in the current contract address by mistake.
223     require(_tokenContractAddress != address(this));
224 
225     // Log the donation of any tokens that have been sent into the contract.
226     TokensDonated(_tokenContractAddress, ERC20(_tokenContractAddress).balanceOf(this));
227 
228     // Send all available tokens at the given contract to the donation address.
229     ERC20(_tokenContractAddress).transfer(donationAddress_, ERC20(_tokenContractAddress).balanceOf(this));
230   }
231 
232   // The donation address for lost ether / ERC20 tokens should match theCyber's.
233   function donationAddress() public view returns(address) {
234     return donationAddress_;
235   }
236 }