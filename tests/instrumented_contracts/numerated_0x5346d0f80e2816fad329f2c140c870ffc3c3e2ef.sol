1 pragma solidity ^0.5.8;
2 /*
3   This file is part of The Colony Network.
4 
5   The Colony Network is free software: you can redistribute it and/or modify
6   it under the terms of the GNU General Public License as published by
7   the Free Software Foundation, either version 3 of the License, or
8   (at your option) any later version.
9 
10   The Colony Network is distributed in the hope that it will be useful,
11   but WITHOUT ANY WARRANTY; without even the implied warranty of
12   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13   GNU General Public License for more details.
14 
15   You should have received a copy of the GNU General Public License
16   along with The Colony Network. If not, see <http://www.gnu.org/licenses/>.
17 */
18 
19 
20 
21 /*
22   This file is part of The Colony Network.
23 
24   The Colony Network is free software: you can redistribute it and/or modify
25   it under the terms of the GNU General Public License as published by
26   the Free Software Foundation, either version 3 of the License, or
27   (at your option) any later version.
28 
29   The Colony Network is distributed in the hope that it will be useful,
30   but WITHOUT ANY WARRANTY; without even the implied warranty of
31   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
32   GNU General Public License for more details.
33 
34   You should have received a copy of the GNU General Public License
35   along with The Colony Network. If not, see <http://www.gnu.org/licenses/>.
36 */
37 
38 
39 
40 // This program is free software: you can redistribute it and/or modify
41 // it under the terms of the GNU General Public License as published by
42 // the Free Software Foundation, either version 3 of the License, or
43 // (at your option) any later version.
44 
45 // This program is distributed in the hope that it will be useful,
46 // but WITHOUT ANY WARRANTY; without even the implied warranty of
47 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
48 // GNU General Public License for more details.
49 
50 // You should have received a copy of the GNU General Public License
51 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
52 
53 
54 
55 contract DSAuthority {
56     function canCall(
57         address src, address dst, bytes4 sig
58     ) public view returns (bool);
59 }
60 
61 contract DSAuthEvents {
62     event LogSetAuthority (address indexed authority);
63     event LogSetOwner     (address indexed owner);
64 }
65 
66 contract DSAuth is DSAuthEvents {
67     DSAuthority  public  authority;
68     address      public  owner;
69 
70     constructor() public {
71         owner = msg.sender;
72         emit LogSetOwner(msg.sender);
73     }
74 
75     function setOwner(address owner_)
76         public
77         auth
78     {
79         owner = owner_;
80         emit LogSetOwner(owner);
81     }
82 
83     function setAuthority(DSAuthority authority_)
84         public
85         auth
86     {
87         authority = authority_;
88         emit LogSetAuthority(address(authority));
89     }
90 
91     modifier auth {
92         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
93         _;
94     }
95 
96     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
97         if (src == address(this)) {
98             return true;
99         } else if (src == owner) {
100             return true;
101         } else if (authority == DSAuthority(0)) {
102             return false;
103         } else {
104             return authority.canCall(src, address(this), sig);
105         }
106     }
107 }
108 
109 // ignore-file-swc-101 This is due to ConsenSys/truffle-security#245 and the bad-line reporting associated with it
110 // (It's really the abi.encodepacked later)
111 
112 contract Resolver is DSAuth {
113   mapping (bytes4 => address) public pointers;
114 
115   function register(string memory signature, address destination) public
116   auth
117   {
118     pointers[stringToSig(signature)] = destination;
119   }
120 
121   function lookup(bytes4 sig) public view returns(address) {
122     return pointers[sig];
123   }
124 
125   function stringToSig(string memory signature) public pure returns(bytes4) {
126     return bytes4(keccak256(abi.encodePacked(signature)));
127   }
128 }
129 
130 
131 
132 contract EtherRouter is DSAuth {
133   Resolver public resolver;
134 
135   function() external payable {
136     if (msg.sig == 0) {
137       return;
138     }
139     // Contracts that want to receive Ether with a plain "send" have to implement
140     // a fallback function with the payable modifier. Contracts now throw if no payable
141     // fallback function is defined and no function matches the signature.
142     // However, 'send' only provides 2300 gas, which is not enough for EtherRouter
143     // so we shortcut it here.
144     //
145     // Note that this means we can never have a fallback function that 'does' stuff.
146     // but those only really seem to be ICOs, to date. To be explicit, there is a hard
147     // decision to be made here. Either:
148     // 1. Contracts that use 'send' or 'transfer' cannot send money to Colonies/ColonyNetwork
149     // 2. We commit to never using a fallback function that does anything.
150     //
151     // We have decided on option 2 here. In the future, if we wish to have such a fallback function
152     // for a Colony, it could be in a separate extension contract.
153 
154     // Get routing information for the called function
155     address destination = resolver.lookup(msg.sig);
156 
157     // Make the call
158     assembly {
159       let size := extcodesize(destination)
160       if eq(size, 0) { revert(0,0) }
161 
162       calldatacopy(mload(0x40), 0, calldatasize)
163       let result := delegatecall(gas, destination, mload(0x40), calldatasize, mload(0x40), 0) // ignore-swc-113
164       // as their addresses are controlled by the Resolver which we trust
165       returndatacopy(mload(0x40), 0, returndatasize)
166       switch result
167       case 1 { return(mload(0x40), returndatasize) }
168       default { revert(mload(0x40), returndatasize) }
169     }
170   }
171 
172   function setResolver(address _resolver) public
173   auth
174   {
175     resolver = Resolver(_resolver);
176   }
177 }