1 pragma solidity ^0.4.24;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2018 Decentralization Authority MDAO.
6  * Released under the MIT License.
7  *
8  * Zitetags - A Zeronet registrar, for managing Namecoin (.bit) addresses used 
9  *            by Zeronet users/clients to simplify addressing of requested 
10  *            zites (0net websites), by NOT having to enter the full 
11  *            Bitcoin (address) public key.
12  * 
13  *            For example, D14na's zite has a Bitcoin public key of
14  *            [ 1D14naQY4s65YR6xrJDBHk9ufj2eLbK49C ], but can be referenced 
15  *            using any of the following zitetag variations:
16  *                1. d14na
17  *                2. #d14na
18  *                3. d14na.bit
19  * 
20  *            NOTE: The following prefixes may sometimes be applied:
21  *                      1. zero://
22  *                      2. http://127.0.0.1:43110/
23  *                      3. https://0net.io/
24  *               
25  *
26  * Version 18.10.21
27  *
28  * Web    : https://d14na.org
29  * Email  : support@d14na.org
30  */
31 
32 
33 /*******************************************************************************
34  *
35  * SafeMath
36  */
37 library SafeMath {
38     function add(uint a, uint b) internal pure returns (uint c) {
39         c = a + b;
40         require(c >= a);
41     }
42     function sub(uint a, uint b) internal pure returns (uint c) {
43         require(b <= a);
44         c = a - b;
45     }
46     function mul(uint a, uint b) internal pure returns (uint c) {
47         c = a * b;
48         require(a == 0 || c / a == b);
49     }
50     function div(uint a, uint b) internal pure returns (uint c) {
51         require(b > 0);
52         c = a / b;
53     }
54 }
55 
56 
57 /*******************************************************************************
58  *
59  * ERC Token Standard #20 Interface
60  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
61  */
62 contract ERC20Interface {
63     function totalSupply() public constant returns (uint);
64     function balanceOf(address tokenOwner) public constant returns (uint balance);
65     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
66     function transfer(address to, uint tokens) public returns (bool success);
67     function approve(address spender, uint tokens) public returns (bool success);
68     function transferFrom(address from, address to, uint tokens) public returns (bool success);
69 
70     event Transfer(address indexed from, address indexed to, uint tokens);
71     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
72 }
73 
74 
75 /*******************************************************************************
76  * Zer0netDb Interface
77  */
78 contract Zer0netDbInterface {
79     /* Interface getters. */
80     function getAddress(bytes32 _key) external view returns (address);
81     function getBool(bytes32 _key)    external view returns (bool);
82     function getBytes(bytes32 _key)   external view returns (bytes);
83     function getInt(bytes32 _key)     external view returns (int);
84     function getString(bytes32 _key)  external view returns (string);
85     function getUint(bytes32 _key)    external view returns (uint);
86 
87     /* Interface setters. */
88     function setAddress(bytes32 _key, address _value) external;
89     function setBool(bytes32 _key, bool _value) external;
90     function setBytes(bytes32 _key, bytes _value) external;
91     function setInt(bytes32 _key, int _value) external;
92     function setString(bytes32 _key, string _value) external;
93     function setUint(bytes32 _key, uint _value) external;
94 
95     /* Interface deletes. */
96     function deleteAddress(bytes32 _key) external;
97     function deleteBool(bytes32 _key) external;
98     function deleteBytes(bytes32 _key) external;
99     function deleteInt(bytes32 _key) external;
100     function deleteString(bytes32 _key) external;
101     function deleteUint(bytes32 _key) external;
102 }
103 
104 
105 /*******************************************************************************
106  * Owned contract
107  */
108 contract Owned {
109     address public owner;
110     address public newOwner;
111 
112     event OwnershipTransferred(address indexed _from, address indexed _to);
113 
114     constructor() public {
115         owner = msg.sender;
116     }
117 
118     modifier onlyOwner {
119         require(msg.sender == owner);
120         _;
121     }
122 
123     function transferOwnership(address _newOwner) public onlyOwner {
124         newOwner = _newOwner;
125     }
126 
127     function acceptOwnership() public {
128         require(msg.sender == newOwner);
129 
130         emit OwnershipTransferred(owner, newOwner);
131 
132         owner = newOwner;
133 
134         newOwner = address(0);
135     }
136 }
137 
138 
139 /*******************************************************************************
140  *
141  * @notice Zitetags Registrar Contract.
142  *
143  * @dev Zitetags are Namecoin (.bit) addresses that are used
144  *      (similar to Twitter hashtags and traditional domain names) as a
145  *      convenient alternative to users/clients when entering a 
146  *      zite's Bitcoin public key.
147  */
148 contract Zitetags is Owned {
149     using SafeMath for uint;
150 
151     /* Initialize version number. */
152     uint public version;
153 
154     /* Initialize Zer0net Db contract. */
155     Zer0netDbInterface public zer0netDb;
156 
157     /* Initialize zitetag update notification/log event. */
158     event ZitetagUpdate(
159         bytes32 indexed zitetagId, 
160         string zitetag, 
161         string info
162     );
163 
164     /* Constructor. */
165     constructor() public {
166         /* Set the version number. */
167         version = now;
168 
169         /* Initialize Zer0netDb (eternal) storage database contract. */
170         // NOTE We hard-code the address here, since it should never change.
171         zer0netDb = Zer0netDbInterface(0xE865Fe1A1A3b342bF0E2fcB11fF4E3BCe58263af);
172     }
173 
174     /**
175      * @dev Only allow access to an authorized Zer0net administrator.
176      */
177     modifier onlyAuthBy0Admin() {
178         /* Verify write access is only permitted to authorized accounts. */
179         require(zer0netDb.getBool(keccak256(
180             abi.encodePacked(msg.sender, '.has.auth.for.zitetags'))) == true);
181 
182         _;      // function code is inserted here
183     }
184 
185     /**
186      * @notice Retrieves the registration info for the given zitetag.
187      * 
188      * @dev Use the calculated hash to query the eternal database 
189      *      for the `_zitetag` info.
190      */
191     function getInfo(string _zitetag) external view returns (string) {
192         /* Calculate the zitetag's hash. */
193         bytes32 hash = keccak256(abi.encodePacked('zitetag.', _zitetag));
194         
195         /* Retrieve the zitetag's info. */
196         string memory info = zer0netDb.getString(hash);
197 
198         /* Return info. */
199         return (info);
200     }
201 
202     /**
203      * @notice Set the zitetag's registration info.
204      * 
205      * @dev Calculate the `_zitetag` hash and use it to store the
206      *      registration details in the eternal database.
207      * 
208      *      NOTE: JSON will be the object type for registration details.
209      */
210     function setInfo(
211         string _zitetag, 
212         string _info
213     ) onlyAuthBy0Admin external returns (bool success) {
214         /* Calculate the zitetag's hash. */
215         bytes32 hash = keccak256(abi.encodePacked('zitetag.', _zitetag));
216         
217         /* Set the zitetag's info. */
218         zer0netDb.setString(hash, _info);
219 
220         /* Emit event notification. */
221         emit ZitetagUpdate(hash, _zitetag, _info);
222 
223         /* Return success. */
224         return true;
225     }
226 
227     /**
228      * THIS CONTRACT DOES NOT ACCEPT DIRECT ETHER
229      */
230     function () public payable {
231         /* Cancel this transaction. */
232         revert('Oops! Direct payments are NOT permitted here.');
233     }
234 
235     /**
236      * Transfer Any ERC20 Token
237      *
238      * @notice Owner can transfer out any accidentally sent ERC20 tokens.
239      *
240      * @dev Provides an ERC20 interface, which allows for the recover
241      *      of any accidentally sent ERC20 tokens.
242      */
243     function transferAnyERC20Token(
244         address tokenAddress, uint tokens
245     ) public onlyOwner returns (bool success) {
246         return ERC20Interface(tokenAddress).transfer(owner, tokens);
247     }
248 }