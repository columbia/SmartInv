1 pragma solidity ^0.4.2;
2 
3 contract SpiceMembers {
4     enum MemberLevel { None, Member, Manager, Director }
5     struct Member {
6         uint id;
7         MemberLevel level;
8         bytes32 info;
9     }
10 
11     mapping (address => Member) member;
12 
13     address public owner;
14     mapping (uint => address) public memberAddress;
15     uint public memberCount;
16 
17     event TransferOwnership(address indexed sender, address indexed owner);
18     event AddMember(address indexed sender, address indexed member);
19     event RemoveMember(address indexed sender, address indexed member);
20     event SetMemberLevel(address indexed sender, address indexed member, MemberLevel level);
21     event SetMemberInfo(address indexed sender, address indexed member, bytes32 info);
22 
23     function SpiceMembers() {
24         owner = msg.sender;
25 
26         memberCount = 1;
27         memberAddress[memberCount] = owner;
28         member[owner] = Member(memberCount, MemberLevel.None, 0);
29     }
30 
31     modifier onlyOwner {
32         if (msg.sender != owner) throw;
33         _;
34     }
35 
36     modifier onlyManager {
37         if (msg.sender != owner && memberLevel(msg.sender) < MemberLevel.Manager) throw;
38         _;
39     }
40 
41     function transferOwnership(address _target) onlyOwner {
42         // If new owner has no memberId, create one
43         if (member[_target].id == 0) {
44             memberCount++;
45             memberAddress[memberCount] = _target;
46             member[_target] = Member(memberCount, MemberLevel.None, 0);
47         }
48         owner = _target;
49         TransferOwnership(msg.sender, owner);
50     }
51 
52     function addMember(address _target) onlyManager {
53         // Make sure trying to add an existing member throws an error
54         if (memberLevel(_target) != MemberLevel.None) throw;
55 
56         // If added member has no memberId, create one
57         if (member[_target].id == 0) {
58             memberCount++;
59             memberAddress[memberCount] = _target;
60             member[_target] = Member(memberCount, MemberLevel.None, 0);
61         }
62 
63         // Set memberLevel to initial value with basic access
64         member[_target].level = MemberLevel.Member;
65         AddMember(msg.sender, _target);
66     }
67 
68     function removeMember(address _target) {
69         // Make sure trying to remove a non-existing member throws an error
70         if (memberLevel(_target) == MemberLevel.None) throw;
71         // Make sure members are only allowed to delete members lower than their level
72         if (msg.sender != owner && memberLevel(msg.sender) <= memberLevel(_target)) throw;
73 
74         member[_target].level = MemberLevel.None;
75         RemoveMember(msg.sender, _target);
76     }
77 
78     function setMemberLevel(address _target, MemberLevel level) {
79         // Make sure all levels are larger than None but not higher than Director
80         if (level == MemberLevel.None || level > MemberLevel.Director) throw;
81         // Make sure the _target is currently already a member
82         if (memberLevel(_target) == MemberLevel.None) throw;
83         // Make sure the new level is lower level than we are (we cannot overpromote)
84         if (msg.sender != owner && memberLevel(msg.sender) <= level) throw;
85         // Make sure the member is currently on lower level than we are
86         if (msg.sender != owner && memberLevel(msg.sender) <= memberLevel(_target)) throw;
87 
88         member[_target].level = level;
89         SetMemberLevel(msg.sender, _target, level);
90     }
91 
92     function setMemberInfo(address _target, bytes32 info) {
93         // Make sure the target is currently already a member
94         if (memberLevel(_target) == MemberLevel.None) throw;
95         // Make sure the member is currently on lower level than we are
96         if (msg.sender != owner && msg.sender != _target && memberLevel(msg.sender) <= memberLevel(_target)) throw;
97 
98         member[_target].info = info;
99         SetMemberInfo(msg.sender, _target, info);
100     }
101 
102     function memberId(address _target) constant returns (uint) {
103         return member[_target].id;
104     }
105 
106     function memberLevel(address _target) constant returns (MemberLevel) {
107         return member[_target].level;
108     }
109 
110     function memberInfo(address _target) constant returns (bytes32) {
111         return member[_target].info;
112     }
113 }