1 // Copyright 2016 The go-ethereum Authors
2 // This file is part of the go-ethereum library.
3 //
4 // The go-ethereum library is free software: you can redistribute it and/or modify
5 // it under the terms of the GNU Lesser General Public License as published by
6 // the Free Software Foundation, either version 3 of the License, or
7 // (at your option) any later version.
8 //
9 // The go-ethereum library is distributed in the hope that it will be useful,
10 // but WITHOUT ANY WARRANTY; without even the implied warranty of
11 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
12 // GNU Lesser General Public License for more details.
13 //
14 // You should have received a copy of the GNU Lesser General Public License
15 // along with the go-ethereum library. If not, see <http://www.gnu.org/licenses/>.
16 
17 // ReleaseOracle is an Ethereum contract to store the current and previous
18 // versions of the go-ethereum implementation. Its goal is to allow Geth to
19 // check for new releases automatically without the need to consult a central
20 // repository.
21 //
22 // The contract takes a vote based approach on both assigning authorised signers
23 // as well as signing off on new Geth releases.
24 //
25 // Note, when a signer is demoted, the currently pending release is auto-nuked.
26 // The reason is to prevent suprises where a demotion actually tilts the votes
27 // in favor of one voter party and pushing out a new release as a consequence of
28 // a simple demotion.
29 contract ReleaseOracle {
30   // Votes is an internal data structure to count votes on a specific proposal
31   struct Votes {
32     address[] pass; // List of signers voting to pass a proposal
33     address[] fail; // List of signers voting to fail a proposal
34   }
35 
36   // Version is the version details of a particular Geth release
37   struct Version {
38     uint32  major;  // Major version component of the release
39     uint32  minor;  // Minor version component of the release
40     uint32  patch;  // Patch version component of the release
41     bytes20 commit; // Git SHA1 commit hash of the release
42 
43     uint64  time;  // Timestamp of the release approval
44     Votes   votes; // Votes that passed this release
45   }
46 
47   // Oracle authorization details
48   mapping(address => bool) authorised; // Set of accounts allowed to vote on updating the contract
49   address[]                voters;     // List of addresses currently accepted as signers
50 
51   // Various proposals being voted on
52   mapping(address => Votes) authProps; // Currently running user authorization proposals
53   address[]                 authPend;  // List of addresses being voted on (map indexes)
54 
55   Version   verProp;  // Currently proposed release being voted on
56   Version[] releases; // All the positively voted releases
57 
58   // isSigner is a modifier to authorize contract transactions.
59   modifier isSigner() {
60     if (authorised[msg.sender]) {
61       _
62     }
63   }
64 
65   // Constructor to assign the initial set of signers.
66   function ReleaseOracle(address[] signers) {
67     // If no signers were specified, assign the creator as the sole signer
68     if (signers.length == 0) {
69       authorised[msg.sender] = true;
70       voters.push(msg.sender);
71       return;
72     }
73     // Otherwise assign the individual signers one by one
74     for (uint i = 0; i < signers.length; i++) {
75       authorised[signers[i]] = true;
76       voters.push(signers[i]);
77     }
78   }
79 
80   // signers is an accessor method to retrieve all te signers (public accessor
81   // generates an indexed one, not a retreive-all version).
82   function signers() constant returns(address[]) {
83     return voters;
84   }
85 
86   // authProposals retrieves the list of addresses that authorization proposals
87   // are currently being voted on.
88   function authProposals() constant returns(address[]) {
89     return authPend;
90   }
91 
92   // authVotes retrieves the current authorization votes for a particular user
93   // to promote him into the list of signers, or demote him from there.
94   function authVotes(address user) constant returns(address[] promote, address[] demote) {
95     return (authProps[user].pass, authProps[user].fail);
96   }
97 
98   // currentVersion retrieves the semantic version, commit hash and release time
99   // of the currently votec active release.
100   function currentVersion() constant returns (uint32 major, uint32 minor, uint32 patch, bytes20 commit, uint time) {
101     if (releases.length == 0) {
102       return (0, 0, 0, 0, 0);
103     }
104     var release = releases[releases.length - 1];
105 
106     return (release.major, release.minor, release.patch, release.commit, release.time);
107   }
108 
109   // proposedVersion retrieves the semantic version, commit hash and the current
110   // votes for the next proposed release.
111   function proposedVersion() constant returns (uint32 major, uint32 minor, uint32 patch, bytes20 commit, address[] pass, address[] fail) {
112     return (verProp.major, verProp.minor, verProp.patch, verProp.commit, verProp.votes.pass, verProp.votes.fail);
113   }
114 
115   // promote pitches in on a voting campaign to promote a new user to a signer
116   // position.
117   function promote(address user) {
118     updateSigner(user, true);
119   }
120 
121   // demote pitches in on a voting campaign to demote an authorised user from
122   // its signer position.
123   function demote(address user) {
124     updateSigner(user, false);
125   }
126 
127   // release votes for a particular version to be included as the next release.
128   function release(uint32 major, uint32 minor, uint32 patch, bytes20 commit) {
129     updateRelease(major, minor, patch, commit, true);
130   }
131 
132   // nuke votes for the currently proposed version to not be included as the next
133   // release. Nuking doesn't require a specific version number for simplicity.
134   function nuke() {
135     updateRelease(0, 0, 0, 0, false);
136   }
137 
138   // updateSigner marks a vote for changing the status of an Ethereum user, either
139   // for or against the user being an authorised signer.
140   function updateSigner(address user, bool authorize) internal isSigner {
141     // Gather the current votes and ensure we don't double vote
142     Votes votes = authProps[user];
143     for (uint i = 0; i < votes.pass.length; i++) {
144       if (votes.pass[i] == msg.sender) {
145         return;
146       }
147     }
148     for (i = 0; i < votes.fail.length; i++) {
149       if (votes.fail[i] == msg.sender) {
150         return;
151       }
152     }
153     // If no authorization proposal is open, add the user to the index for later lookups
154     if (votes.pass.length == 0 && votes.fail.length == 0) {
155       authPend.push(user);
156     }
157     // Cast the vote and return if the proposal cannot be resolved yet
158     if (authorize) {
159       votes.pass.push(msg.sender);
160       if (votes.pass.length <= voters.length / 2) {
161         return;
162       }
163     } else {
164       votes.fail.push(msg.sender);
165       if (votes.fail.length <= voters.length / 2) {
166         return;
167       }
168     }
169     // Proposal resolved in our favor, execute whatever we voted on
170     if (authorize && !authorised[user]) {
171       authorised[user] = true;
172       voters.push(user);
173     } else if (!authorize && authorised[user]) {
174       authorised[user] = false;
175 
176       for (i = 0; i < voters.length; i++) {
177         if (voters[i] == user) {
178           voters[i] = voters[voters.length - 1];
179           voters.length--;
180 
181           delete verProp; // Nuke any version proposal (no suprise releases!)
182           break;
183         }
184       }
185     }
186     // Finally delete the resolved proposal, index and garbage collect
187     delete authProps[user];
188 
189     for (i = 0; i < authPend.length; i++) {
190       if (authPend[i] == user) {
191         authPend[i] = authPend[authPend.length - 1];
192         authPend.length--;
193         break;
194       }
195     }
196   }
197 
198   // updateRelease votes for a particular version to be included as the next release,
199   // or for the currently proposed release to be nuked out.
200   function updateRelease(uint32 major, uint32 minor, uint32 patch, bytes20 commit, bool release) internal isSigner {
201     // Skip nuke votes if no proposal is pending
202     if (!release && verProp.votes.pass.length == 0) {
203       return;
204     }
205     // Mark a new release if no proposal is pending
206     if (verProp.votes.pass.length == 0) {
207       verProp.major  = major;
208       verProp.minor  = minor;
209       verProp.patch  = patch;
210       verProp.commit = commit;
211     }
212     // Make sure positive votes match the current proposal
213     if (release && (verProp.major != major || verProp.minor != minor || verProp.patch != patch || verProp.commit != commit)) {
214       return;
215     }
216     // Gather the current votes and ensure we don't double vote
217     Votes votes = verProp.votes;
218     for (uint i = 0; i < votes.pass.length; i++) {
219       if (votes.pass[i] == msg.sender) {
220         return;
221       }
222     }
223     for (i = 0; i < votes.fail.length; i++) {
224       if (votes.fail[i] == msg.sender) {
225         return;
226       }
227     }
228     // Cast the vote and return if the proposal cannot be resolved yet
229     if (release) {
230       votes.pass.push(msg.sender);
231       if (votes.pass.length <= voters.length / 2) {
232         return;
233       }
234     } else {
235       votes.fail.push(msg.sender);
236       if (votes.fail.length <= voters.length / 2) {
237         return;
238       }
239     }
240     // Proposal resolved in our favor, execute whatever we voted on
241     if (release) {
242       verProp.time = uint64(now);
243       releases.push(verProp);
244       delete verProp;
245     } else {
246       delete verProp;
247     }
248   }
249 }