1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 // The NOTES ERC20 Token. There is a delay before addresses that are not added to the "activeGroup" can transfer tokens. 
46 // That delay ends when admin calls the "activate()" function.
47 // Otherwise it is a generic ERC20 standard token, based originally on the BAT token
48 // https://etherscan.io/address/0x0d8775f648430679a709e98d2b0cb6250d2887ef#code
49 
50 // The standard ERC20 Token interface
51 contract Token {
52     uint256 public totalSupply;
53     function balanceOf(address _owner) constant returns (uint256 balance);
54     function transfer(address _to, uint256 _value) returns (bool success);
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
56     function approve(address _spender, uint256 _value) returns (bool success);
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 // NOTES Token Implementation - transfers are prohibited unless switched on by admin
63 contract Notes is Token {
64 
65     using SafeMath for uint256;
66 
67     //// CONSTANTS
68 
69     // Number of NOTES (800 million)
70     uint256 public constant TOTAL_SUPPLY = 2000 * (10**6) * 10**uint256(decimals);
71 
72     // Token Metadata
73     string public constant name = "NOTES";
74     string public constant symbol = "NOTES";
75     uint8 public constant decimals = 18;
76     string public version = "1.0";
77 
78     //// PROPERTIES
79 
80     address admin;
81     bool public activated = false;
82     mapping (address => bool) public activeGroup;
83     mapping (address => uint256) public balances;
84     mapping (address => mapping (address => uint256)) allowed;
85 
86     //// MODIFIERS
87 
88     modifier active()
89     {
90         require(activated || activeGroup[msg.sender]);
91         _;
92     }
93 
94     modifier onlyAdmin()
95     {
96         require(msg.sender == admin);
97         _;
98     }
99 
100     //// CONSTRUCTOR
101 
102     function Notes(address fund, address _admin)
103     {
104         admin = _admin;
105         totalSupply = TOTAL_SUPPLY;
106         balances[fund] = TOTAL_SUPPLY;    // Deposit all to fund
107         Transfer(address(this), fund, TOTAL_SUPPLY);
108         activeGroup[fund] = true;  // Allow the fund to transfer
109     }
110 
111     //// ADMIN FUNCTIONS
112 
113     function addToActiveGroup(address a) onlyAdmin {
114         activeGroup[a] = true;
115     }
116 
117     function activate() onlyAdmin {
118         activated = true;
119     }
120 
121     //// TOKEN FUNCTIONS
122 
123     function transfer(address _to, uint256 _value) active returns (bool success) {
124         require(_to != address(0));
125         require(_value > 0);
126         require(balances[msg.sender] >= _value);
127         balances[msg.sender] = balances[msg.sender].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         Transfer(msg.sender, _to, _value);
130         return true;
131     }
132 
133     function transferFrom(address _from, address _to, uint256 _value) active returns (bool success) {
134         require(_to != address(0));
135         require(balances[_from] >= _value);
136         require(allowed[_from][msg.sender] >= _value && _value > 0);
137         balances[_to] = balances[_to].add(_value);
138         balances[_from] = balances[_from].sub(_value);
139         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140         Transfer(_from, _to, _value);
141         return true;
142     }
143 
144     function balanceOf(address _owner) constant returns (uint256 balance) {
145         return balances[_owner];
146     }
147 
148     function approve(address _spender, uint256 _value) active returns (bool success) {
149         allowed[msg.sender][_spender] = _value;
150         Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
155         return allowed[_owner][_spender];
156     }
157 
158 }
159 
160 // The Choon smart contract. A state channel on the streaming service distributes cryptographically signed vouchers to artists on demand.
161 // Those artists can then cash those vouchers into NOTES via this contract.
162 // A solo artist could cash the NOTES directly to an address, or a band could cash them to a Smart Record Contract.
163 // The Smart Record contract would then distribute the NOTES to the individual artists, according to its terms.
164 
165 contract Choon  {
166 
167     using SafeMath for uint256;
168 
169     // Events
170     event VoucherCashed(address indexed to, uint256 value);
171 
172     // Notes Contract
173     address notesContract;
174 
175     // The address of the state channel authority that signs the vouchers
176     address choonAuthority;
177 
178     // The contract admin
179     address admin;
180 
181     // The total Notes payments to each address
182     mapping(address => uint256) public payments;
183 
184     // Used to kill the contract in case it needs to be replaced with a new one
185     bool active = true;
186 
187     // Modifiers
188     modifier onlyAdmin()
189     {
190         require(msg.sender == admin);
191         _;
192     }
193 
194     modifier isActive()
195     {
196         require(active);
197         _;
198     }
199 
200     // Constructor
201     function Choon(address _notesContract, address _choonAuthority, address _admin)
202     {
203         notesContract = _notesContract;
204         choonAuthority = _choonAuthority;
205         admin = _admin;
206     }
207 
208     function setActive(bool _active) onlyAdmin external {
209         active = _active;
210     }
211 
212     function setAuthority(address _authority) onlyAdmin external {
213         choonAuthority = _authority;
214     }
215 
216     function shutdown() onlyAdmin external {
217         active = false;
218         // Transfer all remaining Notes to admin
219         uint256 balance = Notes(notesContract).balanceOf(address(this));
220         Notes(notesContract).transfer(admin, balance);
221     }
222 
223     /// @dev Remit a voucher to Choon to get paid Notes
224     // Note that the voucher always updates the *total* lifetime balance of the beneficiary.
225     // This contract tracks what has been paid out so far, so it then knows how much to pay.
226     // This prevents double-spending of vouchers.
227     function remit(address receiver, uint256 balance, bytes sig) external isActive {
228         // Ensure that the voucher sig is valid and from the choonAuthority
229         require(verifyBalanceProof(receiver, balance, sig));
230         // Compute the NOTES owed due to this voucher and pay the beneficiary (receiver).
231         uint priorBalance = payments[receiver];
232         uint owed = balance.sub(priorBalance);
233         require(owed > 0);
234         payments[receiver] = balance;
235         Notes(notesContract).transfer(receiver, owed);
236         VoucherCashed(receiver, owed);
237     }
238 
239     function verifyBalanceProof(address receiver, uint256 balance, bytes sig) private returns (bool) {
240         bytes memory prefix = "\x19Choon:\n32";
241         bytes32 message_hash = keccak256(prefix, receiver, balance);
242         address signer = ecverify(message_hash, sig);
243         return (signer == choonAuthority);
244     }
245 
246     // ECVerify function, from µRaiden and others
247     function ecverify(bytes32 hash, bytes signature) private returns (address signature_address) {
248         require(signature.length == 65);
249 
250         bytes32 r;
251         bytes32 s;
252         uint8 v;
253 
254         // The signature format is a compact form of:
255         //   {bytes32 r}{bytes32 s}{uint8 v}
256         // Compact means, uint8 is not padded to 32 bytes.
257         assembly {
258             r := mload(add(signature, 32))
259             s := mload(add(signature, 64))
260 
261         // Here we are loading the last 32 bytes, including 31 bytes of 's'.
262             v := byte(0, mload(add(signature, 96)))
263         }
264 
265         // Version of signature should be 27 or 28, but 0 and 1 are also possible
266         if (v < 27) {
267             v += 27;
268         }
269 
270         require(v == 27 || v == 28);
271 
272         signature_address = ecrecover(hash, v, r, s);
273 
274         // ecrecover returns zero on error
275         require(signature_address != 0x0);
276 
277         return signature_address;
278     }
279 
280 }