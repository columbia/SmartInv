1 // This program is free software: you can redistribute it and/or modify
2 // it under the terms of the GNU General Public License as published by
3 // the Free Software Foundation, either version 3 of the License, or
4 // (at your option) any later version.
5 
6 // This program is distributed in the hope that it will be useful,
7 // but WITHOUT ANY WARRANTY; without even the implied warranty of
8 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9 // GNU General Public License for more details.
10 
11 // You should have received a copy of the GNU General Public License
12 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
13 
14 pragma solidity ^0.4.13;
15 
16 contract DSAuthority {
17     function canCall(
18         address src, address dst, bytes4 sig
19     ) public view returns (bool);
20 }
21 
22 contract DSAuthEvents {
23     event LogSetAuthority (address indexed authority);
24     event LogSetOwner     (address indexed owner);
25 }
26 
27 contract DSAuth is DSAuthEvents {
28     DSAuthority  public  authority;
29     address      public  owner;
30 
31     function DSAuth() public {
32         owner = msg.sender;
33         LogSetOwner(msg.sender);
34     }
35 
36     function setOwner(address owner_)
37         public
38         auth
39     {
40         owner = owner_;
41         LogSetOwner(owner);
42     }
43 
44     function setAuthority(DSAuthority authority_)
45         public
46         auth
47     {
48         authority = authority_;
49         LogSetAuthority(authority);
50     }
51 
52     modifier auth {
53         require(isAuthorized(msg.sender, msg.sig));
54         _;
55     }
56 
57     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
58         if (src == address(this)) {
59             return true;
60         } else if (src == owner) {
61             return true;
62         } else if (authority == DSAuthority(0)) {
63             return false;
64         } else {
65             return authority.canCall(src, this, sig);
66         }
67     }
68 }
69 
70 // Token standard API
71 // https://github.com/ethereum/EIPs/issues/20
72 
73 contract ERC20 {
74     function totalSupply() public view returns (uint supply);
75     function balanceOf( address who ) public view returns (uint value);
76     function allowance( address owner, address spender ) public view returns (uint _allowance);
77 
78     function transfer( address to, uint value) public returns (bool ok);
79     function transferFrom( address from, address to, uint value) public returns (bool ok);
80     function approve( address spender, uint value ) public returns (bool ok);
81 
82     event Transfer( address indexed from, address indexed to, uint value);
83     event Approval( address indexed owner, address indexed spender, uint value);
84 }
85 
86 /// @dev The token controller contract must implement these functions
87 contract TokenController {
88     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
89     /// @param _owner The address that sent the ether to create tokens
90     /// @return True if the ether is accepted, false if it throws
91     function proxyPayment(address _owner) payable public returns(bool);
92 
93     /// @notice Notifies the controller about a token transfer allowing the
94     ///  controller to react if desired
95     /// @param _from The origin of the transfer
96     /// @param _to The destination of the transfer
97     /// @param _amount The amount of the transfer
98     /// @return False if the controller does not authorize the transfer
99     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
100 
101     /// @notice Notifies the controller about an approval allowing the
102     ///  controller to react if desired
103     /// @param _owner The address that calls `approve()`
104     /// @param _spender The spender in the `approve()` call
105     /// @param _amount The amount in the `approve()` call
106     /// @return False if the controller does not authorize the approval
107     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
108 }
109 
110 contract Controlled {
111     /// @notice The address of the controller is the only address that can call
112     ///  a function with this modifier
113     modifier onlyController { if (msg.sender != controller) throw; _; }
114 
115     address public controller;
116 
117     function Controlled() { controller = msg.sender;}
118 
119     /// @notice Changes the controller of the contract
120     /// @param _newController The new controller of the contract
121     function changeController(address _newController) onlyController {
122         controller = _newController;
123     }
124 }
125 
126 contract TokenTransferGuard {
127     function onTokenTransfer(address _from, address _to, uint _amount) public returns (bool);
128 }
129 
130 contract SwapController is DSAuth, TokenController {
131     Controlled public controlled;
132 
133     TokenTransferGuard[] guards;
134 
135     function SwapController(address _token, address[] _guards)
136     {
137         controlled = Controlled(_token);
138 
139         for (uint i=0; i<_guards.length; i++) {
140             addGuard(_guards[i]);
141         }
142     }
143 
144     function changeController(address _newController) public auth {
145         controlled.changeController(_newController);
146     }
147 
148     function proxyPayment(address _owner) payable public returns (bool)
149     {
150         return false;
151     }
152 
153     function onTransfer(address _from, address _to, uint _amount) public returns (bool)
154     {
155         for (uint i=0; i<guards.length; i++)
156         {
157             if (!guards[i].onTokenTransfer(_from, _to, _amount))
158             {
159                 return false;
160             }
161         }
162 
163         return true;
164     }
165 
166     function onApprove(address _owner, address _spender, uint _amount) public returns (bool)
167     {
168         return true;
169     }
170 
171     function addGuard(address _guard) public auth
172     {
173         guards.push(TokenTransferGuard(_guard));
174     }
175 }