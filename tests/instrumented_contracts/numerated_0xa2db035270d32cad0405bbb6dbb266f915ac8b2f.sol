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
99 // Token standard API
100 // https://github.com/ethereum/EIPs/issues/20
101 
102 contract ERC20 {
103     function totalSupply() public view returns (uint supply);
104     function balanceOf( address who ) public view returns (uint value);
105     function allowance( address owner, address spender ) public view returns (uint _allowance);
106 
107     function transfer( address to, uint value) public returns (bool ok);
108     function transferFrom( address from, address to, uint value) public returns (bool ok);
109     function approve( address spender, uint value ) public returns (bool ok);
110 
111     event Transfer( address indexed from, address indexed to, uint value);
112     event Approval( address indexed owner, address indexed spender, uint value);
113 }
114 
115 contract TokenTransferGuard {
116     function onTokenTransfer(address _from, address _to, uint _amount) public returns (bool);
117 }
118 
119 contract AGT2ATNSwap is DSStop, TokenTransferGuard {
120     ERC20 public AGT;
121     ERC20 public ATN;
122 
123     uint public gasRequired;
124 
125     function AGT2ATNSwap(address _agt, address _atn)
126     {
127         AGT = ERC20(_agt);
128         ATN = ERC20(_atn);
129     }
130 
131     function tokenFallback(address _from, uint256 _value, bytes _data) public
132     {
133         tokenFallback(_from, _value);
134     }
135 
136     function tokenFallback(address _from, uint256 _value) public
137     {
138         if(msg.sender == address(AGT))
139         {
140             require(ATN.transfer(_from, _value));
141 
142             TokenSwap(_from, _value);
143         }
144     }
145 
146     function onTokenTransfer(address _from, address _to, uint _amount) public returns (bool)
147     {
148         if (_to == address(this))
149         {
150             if (msg.gas < gasRequired) return false;
151 
152             if (stopped) return false;
153 
154             if (ATN.balanceOf(this) < _amount) return false;
155         }
156 
157         return true;
158     }
159 
160     function changeGasRequired(uint _gasRequired) public auth {
161         gasRequired = _gasRequired;
162         ChangeGasReuired(_gasRequired);
163     }
164 
165     /// @notice This method can be used by the controller to extract mistakenly
166     ///  sent tokens to this contract.
167     /// @param _token The address of the token contract that you want to recover
168     ///  set to 0 in case you want to extract ether.
169     function claimTokens(address _token) public auth {
170         if (_token == 0x0) {
171             owner.transfer(this.balance);
172             return;
173         }
174         
175         ERC20 token = ERC20(_token);
176         
177         uint256 balance = token.balanceOf(this);
178         
179         token.transfer(owner, balance);
180         ClaimedTokens(_token, owner, balance);
181     }
182 
183     event TokenSwap(address indexed _from, uint256 _value);
184     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
185 
186     event ChangeGasReuired(uint _gasRequired);
187 }