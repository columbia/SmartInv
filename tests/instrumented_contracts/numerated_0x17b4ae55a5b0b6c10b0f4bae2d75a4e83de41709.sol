1 pragma solidity ^0.4.21;
2 
3 /* ********************************************************** */
4 
5 library Util {
6 
7     struct Object {
8         bool isObject;
9         bool isActive;
10         bool isRejected;
11         uint index;
12         bytes32 badge;
13     }
14 
15     struct List {
16         mapping(address => Object) registry;
17         uint length;
18     }
19 
20     function add(List storage list, address _addr, bytes32 _badge) internal {
21         list.registry[_addr].isObject = true;
22         list.registry[_addr].index = list.length;
23         list.registry[_addr].badge = _badge;
24         list.length++;
25     }
26 
27     function remove(List storage list, address _addr) internal {
28         list.registry[_addr].isObject = false;
29     }
30     /* ********************************************************** */
31 
32     function activate(List storage list, address _addr) internal {
33         list.registry[_addr].isActive = true;
34     }
35 
36     function deactivate(List storage list, address _addr) internal {
37         list.registry[_addr].isActive = false;
38     }
39 
40     /* ********************************************************** */
41 
42     function accept(List storage list, address _addr) internal {
43         list.registry[_addr].isRejected = false;
44     }
45 
46     function reject(List storage list, address _addr) internal {
47         list.registry[_addr].isRejected = true;
48     }
49 
50     /* ********************************************************** */
51 
52     function isObject(List storage list, address _addr) view internal returns (bool) {
53         return list.registry[_addr].isObject;
54     }
55 
56     function isActive(List storage list, address _addr) view internal returns (bool) {
57         return list.registry[_addr].isActive;
58     }
59 
60     function isRejected(List storage list, address _addr) view internal returns (bool) {
61         return list.registry[_addr].isRejected;
62     }
63 
64     function indexOf(List storage list, address _addr) view internal returns (uint) {
65         return list.registry[_addr].index;
66     }
67 
68     function getBadge(List storage list, address _addr) view internal returns (bytes32) {
69         return list.registry[_addr].badge;
70     }
71 
72     function length(List storage list) view internal returns (uint) {
73         return list.length;
74     }
75 }
76 
77 /* ********************************************************** */
78 
79 contract CanYaDao {
80 
81     bytes32 private constant BADGE_ADMIN = "Admin";
82     bytes32 private constant BADGE_MOD = "Mod";
83     bytes32 public currentBadge = "Pioneer";
84 
85     Util.List private _admins;
86     Util.List private _mods;
87     Util.List private _providers;
88 
89     /* ********************************************************** */
90 
91     modifier onlyAdmins() {
92         require(Util.isObject(_admins, msg.sender) == true);
93         _;
94     }
95 
96     modifier onlyMods() {
97         require(Util.isObject(_mods, msg.sender) == true);
98         _;
99     }
100 
101     /* ********************************************************** */
102 
103     event onAdminAdded(address _addr);
104     event onAdminRemoved(address _addr);
105 
106     event onModAdded(address _addr);
107     event onModRemoved(address _addr);
108 
109     event onProviderAdded(address _addr);
110     event onProviderRemoved(address _addr);
111 
112     event onProviderActivated(address _addr);
113     event onProviderDeactivated(address _addr);
114 
115     event onProviderAccepted(address _addr);
116     event onProviderRejected(address _addr);
117 
118     /* ********************************************************** */
119 
120     function CanYaDao() public {
121         Util.add(_admins, msg.sender, BADGE_ADMIN);
122         Util.add(_mods, msg.sender, BADGE_ADMIN);
123     }
124 
125     /* ********************************************************** */
126 
127     function addAdmin(address _addr) onlyAdmins public {
128         if ( Util.isObject(_admins, _addr) == false ) {
129             Util.add(_admins, _addr, BADGE_ADMIN);
130             emit onAdminAdded(_addr);
131             addMod(_addr);
132         }
133     }
134 
135     function removeAdmin(address _addr) onlyAdmins public {
136         if ( Util.isObject(_admins, _addr) == true ) {
137             Util.remove(_admins, _addr);
138             emit onAdminRemoved(_addr);
139             removeMod(_addr);
140         }
141     }
142 
143     function isAdmin(address _addr) public view returns (bool) {
144         return Util.isObject(_admins, _addr);
145     }
146 
147     /* ********************************************************** */
148 
149     function addMod(address _addr) onlyAdmins public {
150         if ( Util.isObject(_mods, _addr) == false ) {
151             Util.add(_mods, _addr, BADGE_ADMIN);
152             emit onModAdded(_addr);
153         }
154     }
155 
156     function removeMod(address _addr) onlyAdmins public {
157         if ( Util.isObject(_mods, _addr) == true ) {
158             Util.remove(_mods, _addr);
159             emit onModRemoved(_addr);
160         }
161     }
162 
163     function isMod(address _addr) public view returns (bool) {
164         return Util.isObject(_mods, _addr);
165     }
166 
167     /* ********************************************************** */
168 
169     function addProvider(address _addr) onlyMods public {
170         if ( Util.isObject(_providers, _addr) == true ) revert();
171         Util.add(_providers, _addr, currentBadge);
172         emit onProviderAdded(_addr);
173     }
174 
175     function removeProvider(address _addr) onlyMods public {
176         if ( Util.isObject(_providers, _addr) == false ) revert();
177         Util.remove(_providers, _addr);
178         emit onProviderRemoved(_addr);
179     }
180 
181     function activateProvider(address _addr) onlyMods public {
182         if ( Util.isActive(_providers, _addr) == true ) revert(); 
183         Util.activate(_providers, _addr);
184         emit onProviderActivated(_addr);
185     }
186 
187     function deactivateProvider(address _addr) onlyMods public {
188         if ( Util.isActive(_providers, _addr) == false ) revert(); 
189         Util.deactivate(_providers, _addr);
190         emit onProviderDeactivated(_addr);
191     }
192 
193     function acceptProvider(address _addr) onlyMods public {
194         if ( Util.isRejected(_providers, _addr) == false ) revert(); 
195         Util.accept(_providers, _addr);
196         emit onProviderAccepted(_addr);
197     }
198 
199     function rejectProvider(address _addr) onlyMods public {
200         if ( Util.isRejected(_providers, _addr) == true ) revert(); 
201         Util.reject(_providers, _addr);
202         emit onProviderRejected(_addr);
203     }
204 
205     function isProvider(address _addr) public view returns (bool) {
206         return Util.isObject(_providers, _addr);
207     }
208 
209     function isActive(address _addr) public view returns (bool) {
210         return Util.isActive(_providers, _addr);
211     }
212 
213     function isRejected(address _addr) public view returns (bool) {
214         return Util.isRejected(_providers, _addr);
215     }
216 
217     function indexOfProvider(address _addr) public view returns (uint) {
218         return Util.indexOf(_providers, _addr);
219     }
220 
221     function getProviderBadge(address _addr) public view returns (bytes32) {
222         return Util.getBadge(_providers, _addr);
223     }
224 
225     function sizeOfProviders() public view returns (uint) {
226         return Util.length(_providers);
227     }
228 
229     /* ********************************************************** */
230 
231     function setCurrentBadge(bytes32 _badge) onlyAdmins public {
232         currentBadge = _badge;
233     }
234 
235     function () public payable {
236         revert();
237     }
238 }