1 pragma solidity ^0.4.13;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed  sig,
60         address  indexed  guy,
61         bytes32  indexed  foo,
62         bytes32  indexed  bar,
63         uint              wad,
64         bytes             fax
65     ) anonymous;
66 
67     modifier note {
68         bytes32 foo;
69         bytes32 bar;
70 
71         assembly {
72             foo := calldataload(4)
73             bar := calldataload(36)
74         }
75 
76         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
77 
78         _;
79     }
80 }
81 
82 contract DSStop is DSNote, DSAuth {
83 
84     bool public stopped;
85 
86     modifier stoppable {
87         require(!stopped);
88         _;
89     }
90     function stop() public auth note {
91         stopped = true;
92     }
93     function start() public auth note {
94         stopped = false;
95     }
96 
97 }
98 
99 /**
100  * Math operations with safety checks
101  */
102 library SafeMath {
103   function mul(uint a, uint b) internal returns (uint) {
104     uint c = a * b;
105     assert(a == 0 || c / a == b);
106     return c;
107   }
108 
109   function div(uint a, uint b) internal returns (uint) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint a, uint b) internal returns (uint) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint a, uint b) internal returns (uint) {
122     uint c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 
127   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
128     return a >= b ? a : b;
129   }
130 
131   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
132     return a < b ? a : b;
133   }
134 
135   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
136     return a >= b ? a : b;
137   }
138 
139   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
140     return a < b ? a : b;
141   }
142 }
143 
144 contract RewardSharedPool is DSStop {
145     using SafeMath for uint256;
146 
147     uint public maxReward      = 1000000 ether;
148 
149     uint public consumed   = 0;
150 
151     mapping(address => bool) public consumers;
152 
153     modifier onlyConsumer {
154         require(msg.sender == owner || consumers[msg.sender]);
155         _;
156     }
157 
158     function RewardSharedPool()
159     {
160     }
161 
162     function consume(uint amount) onlyConsumer public returns (bool)
163     {
164         require(available(amount));
165 
166         consumed = consumed.add(amount);
167 
168         Consume(msg.sender, amount);
169 
170         return true;
171     }
172 
173     function available(uint amount) constant public returns (bool)
174     {
175         return consumed.add(amount) <= maxReward;
176     }
177 
178     function changeMaxReward(uint _maxReward) auth public
179     {
180         maxReward = _maxReward;
181     }
182 
183     function addConsumer(address consumer) public auth
184     {
185         consumers[consumer] = true;
186 
187         ConsumerAddition(consumer);
188     }
189 
190     function removeConsumer(address consumer) public auth
191     {
192         consumers[consumer] = false;
193 
194         ConsumerRemoval(consumer);
195     }
196 
197     event Consume(address indexed _sender, uint _value);
198     event ConsumerAddition(address indexed _consumer);
199     event ConsumerRemoval(address indexed _consumer);
200 }