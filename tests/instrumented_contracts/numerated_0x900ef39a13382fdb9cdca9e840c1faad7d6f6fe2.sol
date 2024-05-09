1 // proxy.sol - execute actions atomically through the proxy's identity
2 
3 // Copyright (C) 2017  DappHub, LLC
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 pragma solidity ^0.4.13;
19 
20 contract DSAuthority {
21     function canCall(
22         address src, address dst, bytes4 sig
23     ) public view returns (bool);
24 }
25 
26 contract DSAuthEvents {
27     event LogSetAuthority (address indexed authority);
28     event LogSetOwner     (address indexed owner);
29 }
30 
31 contract DSAuth is DSAuthEvents {
32     DSAuthority  public  authority;
33     address      public  owner;
34 
35     function DSAuth() public {
36         owner = msg.sender;
37         LogSetOwner(msg.sender);
38     }
39 
40     function setOwner(address owner_)
41         public
42         auth
43     {
44         owner = owner_;
45         LogSetOwner(owner);
46     }
47 
48     function setAuthority(DSAuthority authority_)
49         public
50         auth
51     {
52         authority = authority_;
53         LogSetAuthority(authority);
54     }
55 
56     modifier auth {
57         require(isAuthorized(msg.sender, msg.sig));
58         _;
59     }
60 
61     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
62         if (src == address(this)) {
63             return true;
64         } else if (src == owner) {
65             return true;
66         } else if (authority == DSAuthority(0)) {
67             return false;
68         } else {
69             return authority.canCall(src, this, sig);
70         }
71     }
72 }
73 
74 contract DSNote {
75     event LogNote(
76         bytes4   indexed  sig,
77         address  indexed  guy,
78         bytes32  indexed  foo,
79         bytes32  indexed  bar,
80         uint              wad,
81         bytes             fax
82     ) anonymous;
83 
84     modifier note {
85         bytes32 foo;
86         bytes32 bar;
87 
88         assembly {
89             foo := calldataload(4)
90             bar := calldataload(36)
91         }
92 
93         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
94 
95         _;
96     }
97 }
98 
99 // DSProxyCache
100 // This global cache stores addresses of contracts previously deployed
101 // by a proxy. This saves gas from repeat deployment of the same
102 // contracts and eliminates blockchain bloat.
103 
104 // By default, all proxies deployed from the same factory store
105 // contracts in the same cache. The cache a proxy instance uses can be
106 // changed.  The cache uses the sha3 hash of a contract's bytecode to
107 // lookup the address
108 contract DSProxyCache {
109     mapping(bytes32 => address) cache;
110 
111     function read(bytes _code) public view returns (address) {
112         bytes32 hash = keccak256(_code);
113         return cache[hash];
114     }
115 
116     function write(bytes _code) public returns (address target) {
117         assembly {
118             target := create(0, add(_code, 0x20), mload(_code))
119             switch iszero(extcodesize(target))
120             case 1 {
121                 // throw if contract failed to deploy
122                 revert(0, 0)
123             }
124         }
125         bytes32 hash = keccak256(_code);
126         cache[hash] = target;
127     }
128 }