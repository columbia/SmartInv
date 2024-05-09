1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract TokenRecipient {
55     event ReceivedEther(address indexed sender, uint amount);
56     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
57 
58     /**
59      * @dev Receive tokens and generate a log event
60      * @param from Address from which to transfer tokens
61      * @param value Amount of tokens to transfer
62      * @param token Address of token
63      * @param extraData Additional data to log
64      */
65     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
66         ERC20 t = ERC20(token);
67         require(t.transferFrom(from, this, value));
68         ReceivedTokens(from, value, token, extraData);
69     }
70 
71     /**
72      * @dev Receive Ether and generate a log event
73      */
74     function () payable public {
75         ReceivedEther(msg.sender, msg.value);
76     }
77 }
78 
79 contract AuthenticatedProxy is TokenRecipient {
80 
81     /* Address which owns this proxy. */
82     address public user;
83 
84     /* Associated registry with contract authentication information. */
85     ProxyRegistry public registry;
86 
87     /* Whether access has been revoked. */
88     bool public revoked;
89 
90     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
91     enum HowToCall { Call, DelegateCall }
92 
93     /* Event fired when the proxy access is revoked or unrevoked. */
94     event Revoked(bool revoked);
95 
96     /**
97      * Create an AuthenticatedProxy
98      *
99      * @param addrUser Address of user on whose behalf this proxy will act
100      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
101      */
102     function AuthenticatedProxy(address addrUser, ProxyRegistry addrRegistry) public {
103         user = addrUser;
104         registry = addrRegistry;
105     }
106 
107     /**
108      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
109      *
110      * @dev Can be called by the user only
111      * @param revoke Whether or not to revoke access
112      */
113     function setRevoke(bool revoke)
114         public
115     {
116         require(msg.sender == user);
117         revoked = revoke;
118         Revoked(revoke);
119     }
120 
121     /**
122      * Execute a message call from the proxy contract
123      *
124      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
125      * @param dest Address to which the call will be sent
126      * @param howToCall Which kind of call to make
127      * @param calldata Calldata to send
128      * @return Result of the call (success or failure)
129      */
130     function proxy(address dest, HowToCall howToCall, bytes calldata)
131         public
132         returns (bool result)
133     {
134         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
135         if (howToCall == HowToCall.Call) {
136             result = dest.call(calldata);
137         } else if (howToCall == HowToCall.DelegateCall) {
138             result = dest.delegatecall(calldata);
139         }
140         return result;
141     }
142 
143     /**
144      * Execute a message call and assert success
145      * 
146      * @dev Same functionality as `proxy`, just asserts the return value
147      * @param dest Address to which the call will be sent
148      * @param howToCall What kind of call to make
149      * @param calldata Calldata to send
150      */
151     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
152         public
153     {
154         require(proxy(dest, howToCall, calldata));
155     }
156 
157 }
158 
159 contract ProxyRegistry is Ownable {
160 
161     /* Authenticated proxies by user. */
162     mapping(address => AuthenticatedProxy) public proxies;
163 
164     /* Contracts pending access. */
165     mapping(address => uint) public pending;
166 
167     /* Contracts allowed to call those proxies. */
168     mapping(address => bool) public contracts;
169 
170     /* Delay period for adding an authenticated contract.
171        This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),
172        a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
173        plenty of time to notice and transfer their assets.
174     */
175     uint public DELAY_PERIOD = 2 weeks;
176 
177     /**
178      * Start the process to enable access for specified contract. Subject to delay period.
179      *
180      * @dev ProxyRegistry owner only
181      * @param addr Address to which to grant permissions
182      */
183     function startGrantAuthentication (address addr)
184         public
185         onlyOwner
186     {
187         require(!contracts[addr] && pending[addr] == 0);
188         pending[addr] = now;
189     }
190 
191     /**
192      * End the process to nable access for specified contract after delay period has passed.
193      *
194      * @dev ProxyRegistry owner only
195      * @param addr Address to which to grant permissions
196      */
197     function endGrantAuthentication (address addr)
198         public
199         onlyOwner
200     {
201         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
202         pending[addr] = 0;
203         contracts[addr] = true;
204     }
205 
206     /**
207      * Revoke access for specified contract. Can be done instantly.
208      *
209      * @dev ProxyRegistry owner only
210      * @param addr Address of which to revoke permissions
211      */    
212     function revokeAuthentication (address addr)
213         public
214         onlyOwner
215     {
216         contracts[addr] = false;
217     }
218 
219     /**
220      * Register a proxy contract with this registry
221      *
222      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
223      * @return New AuthenticatedProxy contract
224      */
225     function registerProxy()
226         public
227         returns (AuthenticatedProxy proxy)
228     {
229         require(proxies[msg.sender] == address(0));
230         proxy = new AuthenticatedProxy(msg.sender, this);
231         proxies[msg.sender] = proxy;
232         return proxy;
233     }
234 
235 }
236 
237 contract WyvernProxyRegistry is ProxyRegistry {
238 
239     string public constant name = "Project Wyvern Proxy Registry";
240 
241     /* Whether the initial auth address has been set. */
242     bool public initialAddressSet = false;
243 
244     /** 
245      * Grant authentication to the initial Exchange protocol contract
246      *
247      * @dev No delay, can only be called once - after that the standard registry process with a delay must be used
248      * @param authAddress Address of the contract to grant authentication
249      */
250     function grantInitialAuthentication (address authAddress)
251         onlyOwner
252         public
253     {
254         require(!initialAddressSet);
255         initialAddressSet = true;
256         contracts[authAddress] = true;
257     }
258 
259 }