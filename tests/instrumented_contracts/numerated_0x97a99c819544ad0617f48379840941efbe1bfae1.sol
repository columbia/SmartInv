1 pragma solidity ^0.4.19;
2 
3 
4 contract SupportedContract {
5   // Members can call any contract that exposes a `theCyberMessage` method.
6   function theCyberMessage(string) public;
7 }
8 
9 
10 contract ERC20 {
11   // We want to be able to recover & donate any tokens sent to the contract.
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14 }
15 
16 
17 contract theCyber {
18   // theCyber is a decentralized club. It does not support equity memberships,
19   // payment of dues, or payouts to the members. Instead, it is meant to enable
20   // dapps that allow members to communicate with one another or that provide
21   // arbitrary incentives or special access to the club's members. To become a
22   // member of theCyber, you must be added by an existing member. Furthermore,
23   // existing memberships can be revoked if a given member becomes inactive for
24   // too long. Total membership is capped and unique addresses are required.
25 
26   event NewMember(uint8 indexed memberId, bytes32 memberName, address indexed memberAddress);
27   event NewMemberName(uint8 indexed memberId, bytes32 newMemberName);
28   event NewMemberKey(uint8 indexed memberId, string newMemberKey);
29   event MembershipTransferred(uint8 indexed memberId, address newMemberAddress);
30   event MemberProclaimedInactive(uint8 indexed memberId, uint8 indexed proclaimingMemberId);
31   event MemberHeartbeated(uint8 indexed memberId);
32   event MembershipRevoked(uint8 indexed memberId, uint8 indexed revokingMemberId);
33   event BroadcastMessage(uint8 indexed memberId, string message);
34   event DirectMessage(uint8 indexed memberId, uint8 indexed toMemberId, string message);
35   event Call(uint8 indexed memberId, address indexed contractAddress, string message);
36   event FundsDonated(uint8 indexed memberId, uint256 value);
37   event TokensDonated(uint8 indexed memberId, address tokenContractAddress, uint256 value);
38 
39   // There can only be 256 members (member number 0 to 255) in theCyber.
40   uint16 private constant MAXMEMBERS_ = 256;
41 
42   // A membership that has been marked as inactive for 90 days may be revoked.
43   uint64 private constant INACTIVITYTIMEOUT_ = 90 days;
44 
45   // Set the ethereum tip jar (ethereumfoundation.eth) as the donation address.
46   address private constant DONATIONADDRESS_ = 0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359;
47 
48   // A member has a name, a public key, a date they joined, and a date they were
49   // marked as inactive (which is equial to 0 if they are currently active).
50   struct Member {
51     bool member;
52     bytes32 name;
53     string pubkey;
54     uint64 memberSince;
55     uint64 inactiveSince;
56   }
57 
58   // Set up a fixed array of members indexed by member id.
59   Member[MAXMEMBERS_] internal members_;
60 
61   // Map addresses to booleans designating that they control the membership.
62   mapping (address => bool) internal addressIsMember_;
63 
64   // Map addresses to member ids.
65   mapping (address => uint8) internal addressToMember_;
66 
67   // Map member ids to addresses that own the membership.
68   mapping (uint => address) internal memberToAddress_;
69 
70   // Most methods of the contract, like adding new members or revoking existing
71   // inactive members, can only be called by a valid member.
72   modifier membersOnly() {
73     // Only allow transactions originating from a designated member address.
74     require(addressIsMember_[msg.sender]);
75     _;
76   }
77 
78   // In the constructor function, set up the contract creator as the first
79   // member so that other new members can be added.
80   function theCyber() public {
81     // Log the addition of the first member (contract creator).
82     NewMember(0, "", msg.sender);
83 
84     // Set up the member: status, name, key, member since & inactive since.
85     members_[0] = Member(true, bytes32(""), "", uint64(now), 0);
86     
87     // Set up the address associated with the member.
88     memberToAddress_[0] = msg.sender;
89 
90     // Point the address to member's id.
91     addressToMember_[msg.sender] = 0;
92 
93     // Grant members-only access to the new member.
94     addressIsMember_[msg.sender] = true;
95   }
96 
97   // Existing members can designate new users by specifying an unused member id
98   // and address. The new member's initial member name should also be supplied.
99   function newMember(uint8 _memberId, bytes32 _memberName, address _memberAddress) public membersOnly {
100     // Members need a non-null address.
101     require(_memberAddress != address(0));
102 
103     // Existing members (that have not fallen inactive) cannot be replaced.
104     require (!members_[_memberId].member);
105 
106     // One address cannot hold more than one membership.
107     require (!addressIsMember_[_memberAddress]);
108 
109     // Log the addition of a new member: (member id, name, address).
110     NewMember(_memberId, _memberName, _memberAddress);
111 
112     // Set up the member: status, name, `member since` & `inactive since`.
113     members_[_memberId] = Member(true, _memberName, "", uint64(now), 0);
114     
115     // Set up the address associated with the member id.
116     memberToAddress_[_memberId] = _memberAddress;
117 
118     // Point the address to the member id.
119     addressToMember_[_memberAddress] = _memberId;
120 
121     // Grant members-only access to the new member.
122     addressIsMember_[_memberAddress] = true;
123   }
124 
125   // Members can set a name (encoded as a hex value) that will be associated
126   // with their membership.
127   function changeName(bytes32 _newMemberName) public membersOnly {
128     // Log the member's name change: (member id, new name).
129     NewMemberName(addressToMember_[msg.sender], _newMemberName);
130 
131     // Change the member's name.
132     members_[addressToMember_[msg.sender]].name = _newMemberName;
133   }
134 
135   // Members can set a public key that will be used for verifying signed
136   // messages from the member or encrypting messages intended for the member.
137   function changeKey(string _newMemberKey) public membersOnly {
138     // Log the member's key change: (member id, new member key).
139     NewMemberKey(addressToMember_[msg.sender], _newMemberKey);
140 
141     // Change the member's public key.
142     members_[addressToMember_[msg.sender]].pubkey = _newMemberKey;
143   }
144 
145   // Members can transfer their membership to a new address; when they do, the
146   // fields on the membership are all reset.
147   function transferMembership(address _newMemberAddress) public membersOnly {
148     // Members need a non-null address.
149     require(_newMemberAddress != address(0));
150 
151     // Memberships cannot be transferred to existing members.
152     require (!addressIsMember_[_newMemberAddress]);
153 
154     // Log transfer of membership: (member id, new address).
155     MembershipTransferred(addressToMember_[msg.sender], _newMemberAddress);
156     
157     // Revoke members-only access for the old member.
158     delete addressIsMember_[msg.sender];
159     
160     // Reset fields on the membership.
161     members_[addressToMember_[msg.sender]].memberSince = uint64(now);
162     members_[addressToMember_[msg.sender]].inactiveSince = 0;
163     members_[addressToMember_[msg.sender]].name = bytes32("");
164     members_[addressToMember_[msg.sender]].pubkey = "";
165     
166     // Replace the address associated with the member id.
167     memberToAddress_[addressToMember_[msg.sender]] = _newMemberAddress;
168 
169     // Point the new address to the member id and clean up the old pointer.
170     addressToMember_[_newMemberAddress] = addressToMember_[msg.sender];
171     delete addressToMember_[msg.sender];
172 
173     // Grant members-only access to the new member.
174     addressIsMember_[_newMemberAddress] = true;
175   }
176 
177   // As a mechanism to remove members that are no longer active due to lost keys
178   // or a lack of engagement, other members may proclaim them as inactive.
179   function proclaimInactive(uint8 _memberId) public membersOnly {
180     // Members must exist and be currently active to proclaim inactivity.
181     require(members_[_memberId].member);
182     require(memberIsActive(_memberId));
183     
184     // Members cannot proclaim themselves as inactive (safety measure).
185     require(addressToMember_[msg.sender] != _memberId);
186 
187     // Log proclamation of inactivity: (inactive member id, member id, time).
188     MemberProclaimedInactive(_memberId, addressToMember_[msg.sender]);
189     
190     // Set the `inactiveSince` field on the inactive member.
191     members_[_memberId].inactiveSince = uint64(now);
192   }
193 
194   // Members that have erroneously been marked as inactive may send a heartbeat
195   // to prove that they are still active, voiding the `inactiveSince` property.
196   function heartbeat() public membersOnly {
197     // Log that the member has heartbeated and is still active.
198     MemberHeartbeated(addressToMember_[msg.sender]);
199 
200     // Designate member as active by voiding their `inactiveSince` field.
201     members_[addressToMember_[msg.sender]].inactiveSince = 0;
202   }
203 
204   // If a member has been marked inactive for the duration of the inactivity
205   // timeout, another member may revoke their membership and delete them.
206   function revokeMembership(uint8 _memberId) public membersOnly {
207     // Members must exist in order to be revoked.
208     require(members_[_memberId].member);
209 
210     // Members must be designated as inactive.
211     require(!memberIsActive(_memberId));
212 
213     // Members cannot revoke themselves (safety measure).
214     require(addressToMember_[msg.sender] != _memberId);
215 
216     // Members must be inactive for the duration of the inactivity timeout.
217     require(now >= members_[_memberId].inactiveSince + INACTIVITYTIMEOUT_);
218 
219     // Log that the membership has been revoked.
220     MembershipRevoked(_memberId, addressToMember_[msg.sender]);
221 
222     // Revoke members-only access for the member.
223     delete addressIsMember_[memberToAddress_[_memberId]];
224 
225     // Delete the pointer linking the address to the member id.
226     delete addressToMember_[memberToAddress_[_memberId]];
227     
228     // Delete the address associated with the member id.
229     delete memberToAddress_[_memberId];
230 
231     // Finally, delete the member.
232     delete members_[_memberId];
233   }
234 
235   // While most messaging is intended to occur off-chain using supplied keys,
236   // members can also broadcast a message as an on-chain event.
237   function broadcastMessage(string _message) public membersOnly {
238     // Log the message.
239     BroadcastMessage(addressToMember_[msg.sender], _message);
240   }
241 
242   // In addition, members can send direct messagees as an on-chain event. These
243   // messages are intended to be encrypted using the recipient's public key.
244   function directMessage(uint8 _toMemberId, string _message) public membersOnly {
245     // Log the message.
246     DirectMessage(addressToMember_[msg.sender], _toMemberId, _message);
247   }
248 
249   // Members can also pass a message to any contract that supports it (via the
250   // `theCyberMessage(string)` function), designated by the contract address.
251   function passMessage(address _contractAddress, string _message) public membersOnly {
252     // Log that another contract has been called and passed a message.
253     Call(addressToMember_[msg.sender], _contractAddress, _message);
254 
255     // call the method of the target contract and pass in the message.
256     SupportedContract(_contractAddress).theCyberMessage(_message);
257   }
258 
259   // The contract is not payable by design, but could end up with a balance as
260   // a recipient of a selfdestruct / coinbase of a mined block.
261   function donateFunds() public membersOnly {
262     // Log the donation of any funds that have made their way into the contract.
263     FundsDonated(addressToMember_[msg.sender], this.balance);
264 
265     // Send all available funds to the donation address.
266     DONATIONADDRESS_.transfer(this.balance);
267   }
268 
269   // We also want to be able to access any tokens that are sent to the contract.
270   function donateTokens(address _tokenContractAddress) public membersOnly {
271     // Make sure that we didn't pass in the current contract address by mistake.
272     require(_tokenContractAddress != address(this));
273 
274     // Log the donation of any tokens that have been sent into the contract.
275     TokensDonated(addressToMember_[msg.sender], _tokenContractAddress, ERC20(_tokenContractAddress).balanceOf(this));
276 
277     // Send all available tokens at the given contract to the donation address.
278     ERC20(_tokenContractAddress).transfer(DONATIONADDRESS_, ERC20(_tokenContractAddress).balanceOf(this));
279   }
280 
281   function getMembershipStatus(address _memberAddress) public view returns (bool member, uint8 memberId) {
282     return (
283       addressIsMember_[_memberAddress],
284       addressToMember_[_memberAddress]
285     );
286   }
287 
288   function getMemberInformation(uint8 _memberId) public view returns (bytes32 memberName, string memberKey, uint64 memberSince, uint64 inactiveSince, address memberAddress) {
289     return (
290       members_[_memberId].name,
291       members_[_memberId].pubkey,
292       members_[_memberId].memberSince,
293       members_[_memberId].inactiveSince,
294       memberToAddress_[_memberId]
295     );
296   }
297 
298   function maxMembers() public pure returns(uint16) {
299     return MAXMEMBERS_;
300   }
301 
302   function inactivityTimeout() public pure returns(uint64) {
303     return INACTIVITYTIMEOUT_;
304   }
305 
306   function donationAddress() public pure returns(address) {
307     return DONATIONADDRESS_;
308   }
309 
310   function memberIsActive(uint8 _memberId) internal view returns (bool) {
311     return (members_[_memberId].inactiveSince == 0);
312   }
313 }