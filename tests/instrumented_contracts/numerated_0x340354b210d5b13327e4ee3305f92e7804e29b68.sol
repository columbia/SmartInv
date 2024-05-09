1 pragma solidity ^0.4.24;
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
18     constructor() public {
19         owner = msg.sender;
20         emit LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         emit LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         emit LogSetAuthority(authority);
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
76         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
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
99 contract ERC20Events {
100     event Approval(address indexed src, address indexed guy, uint wad);
101     event Transfer(address indexed src, address indexed dst, uint wad);
102 }
103 
104 contract ERC20 is ERC20Events {
105     function totalSupply() public view returns (uint);
106     function balanceOf(address guy) public view returns (uint);
107     function allowance(address src, address guy) public view returns (uint);
108 
109     function approve(address guy, uint wad) public returns (bool);
110     function transfer(address dst, uint wad) public returns (bool);
111     function transferFrom(
112         address src, address dst, uint wad
113     ) public returns (bool);
114 }
115 
116 /// @dev The token controller contract must implement these functions
117 contract TokenController {
118     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
119     /// @param _owner The address that sent the ether to create tokens
120     /// @return True if the ether is accepted, false if it throws
121     function proxyPayment(address _owner) payable public returns (bool);
122 
123     /// @notice Notifies the controller about a token transfer allowing the
124     ///  controller to react if desired
125     /// @param _from The origin of the transfer
126     /// @param _to The destination of the transfer
127     /// @param _amount The amount of the transfer
128     /// @return False if the controller does not authorize the transfer
129     function onTransfer(address _from, address _to, uint _amount) public returns (bool);
130 
131     /// @notice Notifies the controller about an approval allowing the
132     ///  controller to react if desired
133     /// @param _owner The address that calls `approve()`
134     /// @param _spender The spender in the `approve()` call
135     /// @param _amount The amount in the `approve()` call
136     /// @return False if the controller does not authorize the approval
137     function onApprove(address _owner, address _spender, uint _amount) public returns (bool);
138 }
139 
140 
141 contract Controlled {
142     /// @notice The address of the controller is the only address that can call
143     ///  a function with this modifier
144     modifier onlyController { if (msg.sender != controller) throw; _; }
145 
146     address public controller;
147 
148     constructor() public { controller = msg.sender;}
149 
150     /// @notice Changes the controller of the contract
151     /// @param _newController The new controller of the contract
152     function changeController(address _newController) onlyController public {
153         controller = _newController;
154     }
155 }
156 
157 contract TransferController is DSStop, TokenController {
158     
159     function changeController(address _token, address _newController) public auth {
160         Controlled(_token).changeController(_newController);
161     }
162 
163     function proxyPayment(address _owner) payable public returns (bool)
164     {
165         return false;
166     }
167 
168     function onTransfer(address _from, address _to, uint _amount) public returns (bool)
169     {
170         return stopped;
171     }
172 
173     function onApprove(address _owner, address _spender, uint _amount) public returns (bool)
174     {
175         return true;
176     }
177 }