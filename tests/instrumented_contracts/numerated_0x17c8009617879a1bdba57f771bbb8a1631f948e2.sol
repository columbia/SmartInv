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
14 pragma solidity ^0.4.20;
15 
16 contract DSNote {
17     event LogNote(
18         bytes4   indexed  sig,
19         address  indexed  guy,
20         bytes32  indexed  foo,
21         bytes32  indexed  bar,
22 	    uint	 wad,
23         bytes    fax
24     ) anonymous;
25 
26     modifier note {
27         bytes32 foo;
28         bytes32 bar;
29 
30         assembly {
31             foo := calldataload(4)
32             bar := calldataload(36)
33         }
34 
35         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
36 
37         _;
38     }
39 }
40 
41 contract DSAuthority {
42     function canCall(
43         address src, address dst, bytes4 sig
44     ) public view returns (bool);
45 }
46 
47 contract DSAuthEvents {
48     event LogSetAuthority (address indexed authority);
49     event LogSetOwner     (address indexed owner);
50 }
51 
52 contract DSAuth is DSAuthEvents {
53     DSAuthority  public  authority;
54     address      public  owner;
55 
56     function DSAuth() public {
57         owner = msg.sender;
58         LogSetOwner(msg.sender);
59     }
60 
61     function setOwner(address owner_)
62         public
63         auth
64     {
65         owner = owner_;
66         LogSetOwner(owner);
67     }
68 
69     function setAuthority(DSAuthority authority_)
70         public
71         auth
72     {
73         authority = authority_;
74         LogSetAuthority(authority);
75     }
76 
77     modifier auth {
78         require(isAuthorized(msg.sender, msg.sig));
79         _;
80     }
81 
82     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
83         if (src == address(this)) {
84             return true;
85         } else if (src == owner) {
86             return true;
87         } else if (authority == DSAuthority(0)) {
88             return false;
89         } else {
90             return authority.canCall(src, this, sig);
91         }
92     }
93 }
94 
95 contract DSStop is DSAuth, DSNote {
96 
97     bool public stopped;
98 
99     modifier stoppable {
100         require (!stopped);
101         _;
102     }
103     function stop() public auth note {
104         stopped = true;
105     }
106     function start() public auth note {
107         stopped = false;
108     }
109 
110 }
111 
112 contract DSMath {
113     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
114         require((z = x + y) >= x);
115     }
116 
117     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
118         require((z = x - y) <= x);
119     }
120 }
121 
122 
123 contract EIP20Interface {
124     uint256 public totalSupply;
125     function balanceOf(address _owner) public view returns (uint256 balance);
126     function transfer(address _to, uint256 _value) public returns (bool success);
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
128     function approve(address _spender, uint256 _value) public returns (bool success);
129     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
130     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
131     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
132 }
133 
134 contract DSTokenBase is EIP20Interface, DSMath {
135     mapping (address => uint256)                       _balances;
136     mapping (address => mapping (address => uint256))  _approvals;
137 
138     function balanceOf(address _owner) public view returns (uint256 balance) {
139         return _balances[_owner];
140     }
141 
142     function transfer(address _to, uint256 _value) public returns (bool success){
143         _balances[msg.sender] = sub(_balances[msg.sender], _value);
144         _balances[_to] = add(_balances[_to], _value);
145         
146         Transfer(msg.sender, _to, _value);
147         
148         return true;
149     }
150 
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
152         if (_from != msg.sender) {
153             _approvals[_from][msg.sender] = sub(_approvals[_from][msg.sender], _value);
154         }
155         _balances[_from] = sub(_balances[_from], _value);
156         _balances[_to] = add(_balances[_to], _value);
157         
158         Transfer(_from, _to, _value);
159         
160         return true;
161     }
162 
163     function approve(address _spender, uint256 _value) public returns (bool success){
164         _approvals[msg.sender][_spender] = _value;
165         
166         Approval(msg.sender, _spender, _value);
167         
168         return true;
169     }
170 
171     function allowance(address _owner, address _spender) public view returns (uint256 remaining){
172         return _approvals[_owner][_spender];
173     }
174 }
175 
176  contract FUXEToken is DSTokenBase, DSStop {
177        string   public  name = "FUXECoin";
178        string   public  symbol = "FUX";
179        uint256  public  decimals = 18; // standard token precision. override to customize
180 
181      function FUXEToken() public {
182          totalSupply = 100000000 * 10 ** uint256(decimals);
183          _balances[msg.sender] = totalSupply;
184      }
185 
186      function transfer(address dst, uint wad) public stoppable note returns (bool) {
187          return super.transfer(dst, wad);
188      }
189      
190      function transferFrom(
191          address src, address dst, uint wad
192      ) public stoppable note returns (bool) {
193          return super.transferFrom(src, dst, wad);
194      }
195      
196      function approve(address guy, uint wad) public stoppable note returns (bool) {
197          return super.approve(guy, wad);
198      }
199  }