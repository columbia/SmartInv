1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract IInvestorList {
11     string public constant ROLE_REGD = "regd";
12     string public constant ROLE_REGCF = "regcf";
13     string public constant ROLE_REGS = "regs";
14     string public constant ROLE_UNKNOWN = "unknown";
15 
16     function inList(address addr) public view returns (bool);
17     function addAddress(address addr, string role) public;
18     function getRole(address addr) public view returns (string);
19     function hasRole(address addr, string role) public view returns (bool);
20 }
21 
22 contract Ownable {
23     address public owner;
24     address public newOwner;
25 
26     /**
27      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28      * account.
29      */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     /**
43      * @dev Starts the 2-step process of changing ownership. The new owner
44      * must then call `acceptOwnership()`.
45      */
46     function changeOwner(address _newOwner) public onlyOwner {
47         newOwner = _newOwner;
48     }
49 
50     /**
51      * @dev Completes the process of transferring ownership to a new owner.
52      */
53     function acceptOwnership() public {
54         if (msg.sender == newOwner) {
55             owner = newOwner;
56             newOwner = 0;
57         }
58     }
59 
60 }
61 
62 contract InvestorList is Ownable, IInvestorList {
63     event AddressAdded(address addr, string role);
64     event AddressRemoved(address addr, string role);
65 
66     mapping (address => string) internal investorList;
67 
68     /**
69      * @dev Throws if called by any account that's not investorListed.
70      * @param role string
71      */
72     modifier validRole(string role) {
73         require(
74             keccak256(bytes(role)) == keccak256(bytes(ROLE_REGD)) ||
75             keccak256(bytes(role)) == keccak256(bytes(ROLE_REGCF)) ||
76             keccak256(bytes(role)) == keccak256(bytes(ROLE_REGS)) ||
77             keccak256(bytes(role)) == keccak256(bytes(ROLE_UNKNOWN))
78         );
79         _;
80     }
81 
82     /**
83      * @dev Getter to determine if address is in investorList.
84      * @param addr address
85      * @return true if the address was added to the investorList, false if the address was already in the investorList
86      */
87     function inList(address addr)
88         public
89         view
90         returns (bool)
91     {
92         if (bytes(investorList[addr]).length != 0) {
93             return true;
94         } else {
95             return false;
96         }
97     }
98 
99     /**
100      * @dev Getter for address role if address is in list.
101      * @param addr address
102      * @return string for address role
103      */
104     function getRole(address addr)
105         public
106         view
107         returns (string)
108     {
109         require(inList(addr));
110         return investorList[addr];
111     }
112 
113     /**
114      * @dev Returns a boolean indicating if the given address is in the list
115      *      with the given role.
116      * @param addr address to check
117      * @param role role to check
118      * @ return boolean for whether the address is in the list with the role
119      */
120     function hasRole(address addr, string role)
121         public
122         view
123         returns (bool)
124     {
125         return keccak256(bytes(role)) == keccak256(bytes(investorList[addr]));
126     }
127 
128     /**
129      * @dev Add single address to the investorList.
130      * @param addr address
131      * @param role string
132      */
133     function addAddress(address addr, string role)
134         onlyOwner
135         validRole(role)
136         public
137     {
138         investorList[addr] = role;
139         emit AddressAdded(addr, role);
140     }
141 
142     /**
143      * @dev Add multiple addresses to the investorList.
144      * @param addrs addresses
145      * @param role string
146      */
147     function addAddresses(address[] addrs, string role)
148         onlyOwner
149         validRole(role)
150         public
151     {
152         for (uint256 i = 0; i < addrs.length; i++) {
153             addAddress(addrs[i], role);
154         }
155     }
156 
157     /**
158      * @dev Remove single address from the investorList.
159      * @param addr address
160      */
161     function removeAddress(address addr)
162         onlyOwner
163         public
164     {
165         // removeRole(addr, ROLE_WHITELISTED);
166         require(inList(addr));
167         string memory role = investorList[addr];
168         investorList[addr] = "";
169         emit AddressRemoved(addr, role);
170     }
171 
172     /**
173      * @dev Remove multiple addresses from the investorList.
174      * @param addrs addresses
175      */
176     function removeAddresses(address[] addrs)
177         onlyOwner
178         public
179     {
180         for (uint256 i = 0; i < addrs.length; i++) {
181             if (inList(addrs[i])) {
182                 removeAddress(addrs[i]);
183             }
184         }
185     }
186 
187 }
188 
189 interface ISecuritySale {
190     function setLive(bool newLiveness) external;
191     function setInvestorList(address _investorList) external;
192 }
193 
194 contract SecuritySale is Ownable {
195 
196     bool public live;        // sale is live right now
197     IInvestorList public investorList; // approved contributors
198 
199     event SaleLive(bool liveness);
200     event EtherIn(address from, uint amount);
201     event StartSale();
202     event EndSale();
203 
204     constructor() public {
205         live = false;
206     }
207 
208     function setInvestorList(address _investorList) public onlyOwner {
209         investorList = IInvestorList(_investorList);
210     }
211 
212     function () public payable {
213         require(live);
214         require(investorList.inList(msg.sender));
215         emit EtherIn(msg.sender, msg.value);
216     }
217 
218     // set liveness
219     function setLive(bool newLiveness) public onlyOwner {
220         if(live && !newLiveness) {
221             live = false;
222             emit EndSale();
223         }
224         else if(!live && newLiveness) {
225             live = true;
226             emit StartSale();
227         }
228     }
229 
230     // withdraw all of the Ether to owner
231     function withdraw() public onlyOwner {
232         msg.sender.transfer(address(this).balance);
233     }
234 
235     // withdraw some of the Ether to owner
236     function withdrawSome(uint value) public onlyOwner {
237         require(value <= address(this).balance);
238         msg.sender.transfer(value);
239     }
240 
241     // withdraw tokens to owner
242     function withdrawTokens(address token) public onlyOwner {
243         ERC20Basic t = ERC20Basic(token);
244         require(t.transfer(msg.sender, t.balanceOf(this)));
245     }
246 
247     // send received tokens to anyone
248     function sendReceivedTokens(address token, address sender, uint amount) public onlyOwner {
249         ERC20Basic t = ERC20Basic(token);
250         require(t.transfer(sender, amount));
251     }
252 }