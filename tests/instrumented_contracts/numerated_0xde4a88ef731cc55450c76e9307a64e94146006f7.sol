1 pragma solidity 0.4.24;
2 
3 
4 contract DSAuthority {
5     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
6 }
7 
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 
15 contract DSAuth is DSAuthEvents {
16     DSAuthority  public  authority;
17     address      public  owner;
18 
19     constructor() public {
20         owner = msg.sender;
21         emit LogSetOwner(msg.sender);
22     }
23 
24     function setOwner(address owner_)
25         public
26         auth
27     {
28         owner = owner_;
29         emit LogSetOwner(owner);
30     }
31 
32     function setAuthority(DSAuthority authority_)
33         public
34         auth
35     {
36         authority = authority_;
37         emit LogSetAuthority(authority);
38     }
39 
40     modifier auth {
41         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
42         _;
43     }
44 
45     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
46         if (src == address(this)) {
47             return true;
48         } else if (src == owner) {
49             return true;
50         } else if (authority == DSAuthority(0)) {
51             return false;
52         } else {
53             return authority.canCall(src, this, sig);
54         }
55     }
56 }
57 
58 
59 contract DSGuardEvents {
60     event LogPermit(
61         bytes32 indexed src,
62         bytes32 indexed dst,
63         bytes32 indexed sig
64     );
65 
66     event LogForbid(
67         bytes32 indexed src,
68         bytes32 indexed dst,
69         bytes32 indexed sig
70     );
71 }
72 
73 
74 contract DSGuard is DSAuth, DSAuthority, DSGuardEvents {
75     bytes32 constant public ANY = bytes32(uint(-1));
76 
77     mapping (bytes32 => mapping (bytes32 => mapping (bytes32 => bool))) acl;
78 
79     function canCall(
80         address src_, address dst_, bytes4 sig
81     ) public view returns (bool) {
82         var src = bytes32(src_);
83         var dst = bytes32(dst_);
84 
85         return acl[src][dst][sig]
86             || acl[src][dst][ANY]
87             || acl[src][ANY][sig]
88             || acl[src][ANY][ANY]
89             || acl[ANY][dst][sig]
90             || acl[ANY][dst][ANY]
91             || acl[ANY][ANY][sig]
92             || acl[ANY][ANY][ANY];
93     }
94 
95     function permit(bytes32 src, bytes32 dst, bytes32 sig) public auth {
96         acl[src][dst][sig] = true;
97         LogPermit(src, dst, sig);
98     }
99 
100     function forbid(bytes32 src, bytes32 dst, bytes32 sig) public auth {
101         acl[src][dst][sig] = false;
102         LogForbid(src, dst, sig);
103     }
104 
105     function permit(address src, address dst, bytes32 sig) public {
106         permit(bytes32(src), bytes32(dst), sig);
107     }
108     function forbid(address src, address dst, bytes32 sig) public {
109         forbid(bytes32(src), bytes32(dst), sig);
110     }
111 
112 }
113 
114 
115 contract DSGuardFactory {
116     mapping (address => bool)  public  isGuard;
117 
118     function newGuard() public returns (DSGuard guard) {
119         guard = new DSGuard();
120         guard.setOwner(msg.sender);
121         isGuard[guard] = true;
122     }
123 }