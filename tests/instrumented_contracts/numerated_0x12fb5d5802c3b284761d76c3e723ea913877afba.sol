1 pragma solidity ^0.4.15;
2 
3 /*
4 Copyright (c) 2016 Smart Contract Solutions, Inc.
5 
6 Permission is hereby granted, free of charge, to any person obtaining
7 a copy of this software and associated documentation files (the
8 "Software"), to deal in the Software without restriction, including
9 without limitation the rights to use, copy, modify, merge, publish,
10 distribute, sublicense, and/or sell copies of the Software, and to
11 permit persons to whom the Software is furnished to do so, subject to
12 the following conditions:
13 
14 The above copyright notice and this permission notice shall be included
15 in all copies or substantial portions of the Software.
16 
17 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
18 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
19 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
20 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
21 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
22 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
23 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
24 */
25 
26 contract owned {
27     address public owner;
28 
29     function owned() public {
30         owner = msg.sender;
31     }
32 
33     modifier onlyOwner {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     function transferOwnership(address newOwner) public onlyOwner {
39         owner = newOwner;
40     }
41 }
42 
43 contract basicToken {
44     function balanceOf(address) public view returns (uint256);
45     function transfer(address, uint256) public returns (bool);
46     function transferFrom(address, address, uint256) public returns (bool);
47     function approve(address, uint256) public returns (bool);
48     function allowance(address, address) public view returns (uint256);
49 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 contract ERC20Standard is basicToken{
55 
56     mapping (address => mapping (address => uint256)) allowed;
57     mapping (address => uint256) public balances;
58 
59     /* Send coins */
60     function transfer(address _to, uint256 _value) public returns (bool success){
61         require (_to != 0x0);                               // Prevent transfer to 0x0 address
62         require (balances[msg.sender] > _value);            // Check if the sender has enough
63         require (balances[_to] + _value > balances[_to]);   // Check for overflows
64         _transfer(msg.sender, _to, _value);                 // Perform actually transfer
65         Transfer(msg.sender, _to, _value);                  // Trigger Transfer event
66         return true;
67     }
68 
69     /* Use admin powers to send from a users account */
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
71         require (_to != 0x0);                               // Prevent transfer to 0x0 address
72         require (balances[msg.sender] > _value);            // Check if the sender has enough
73         require (balances[_to] + _value > balances[_to]);   // Check for overflows
74         require (allowed[_from][msg.sender] >= _value);     // Only allow if sender is allowed to do this
75         _transfer(msg.sender, _to, _value);                 // Perform actually transfer
76         Transfer(msg.sender, _to, _value);                  // Trigger Transfer event
77         return true;
78     }
79 
80     /* Internal transfer, only can be called by this contract */
81     function _transfer(address _from, address _to, uint _value) internal {
82         balances[_from] -= _value;                          // Subtract from the sender
83         balances[_to] += _value;                            // Add the same to the recipient
84     }
85 
86     /* Get balance of an account */
87     function balanceOf(address _owner) public view returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     /* Approve an address to have admin power to use transferFrom */
92     function approve(address _spender, uint256 _value) public returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
99         return allowed[_owner][_spender];
100     }
101 
102 }
103 
104 contract HydroToken is ERC20Standard, owned{
105     event Authenticate(uint partnerId, address indexed from, uint value);     // Event for when an address is authenticated
106     event Whitelist(uint partnerId, address target, bool whitelist);          // Event for when an address is whitelisted to authenticate
107     event Burn(address indexed burner, uint256 value);                        // Event for when tokens are burned
108 
109     struct partnerValues {
110         uint value;
111         uint challenge;
112     }
113 
114     struct hydrogenValues {
115         uint value;
116         uint timestamp;
117     }
118 
119     string public name = "Hydro";
120     string public symbol = "HYDRO";
121     uint8 public decimals = 18;
122     uint256 public totalSupply;
123 
124     /* This creates an array of all whitelisted addresses
125      * Must be whitelisted to be able to utilize auth
126      */
127     mapping (uint => mapping (address => bool)) public whitelist;
128     mapping (uint => mapping (address => partnerValues)) public partnerMap;
129     mapping (uint => mapping (address => hydrogenValues)) public hydroPartnerMap;
130 
131     /* Initializes contract with initial supply tokens to the creator of the contract */
132     function HydroToken() public {
133         totalSupply = 11111111111 * 10**18;
134         balances[msg.sender] = totalSupply;                 // Give the creator all initial tokens
135     }
136 
137     /* Function to whitelist partner address. Can only be called by owner */
138     function whitelistAddress(address _target, bool _whitelistBool, uint _partnerId) public onlyOwner {
139         whitelist[_partnerId][_target] = _whitelistBool;
140         Whitelist(_partnerId, _target, _whitelistBool);
141     }
142 
143     /* Function to authenticate user
144        Restricted to whitelisted partners */
145     function authenticate(uint _value, uint _challenge, uint _partnerId) public {
146         require(whitelist[_partnerId][msg.sender]);         // Make sure the sender is whitelisted
147         require(balances[msg.sender] > _value);             // Check if the sender has enough
148         require(hydroPartnerMap[_partnerId][msg.sender].value == _value);
149         updatePartnerMap(msg.sender, _value, _challenge, _partnerId);
150         transfer(owner, _value);
151         Authenticate(_partnerId, msg.sender, _value);
152     }
153 
154     function burn(uint256 _value) public onlyOwner {
155         require(balances[msg.sender] > _value);
156         balances[msg.sender] -= _value;
157         totalSupply -= _value;
158         Burn(msg.sender, _value);
159     }
160 
161     function checkForValidChallenge(address _sender, uint _partnerId) public view returns (uint value){
162         if (hydroPartnerMap[_partnerId][_sender].timestamp > block.timestamp){
163             return hydroPartnerMap[_partnerId][_sender].value;
164         }
165         return 1;
166     }
167 
168     /* Function to update the partnerValuesMap with their amount and challenge string */
169     function updatePartnerMap(address _sender, uint _value, uint _challenge, uint _partnerId) internal {
170         partnerMap[_partnerId][_sender].value = _value;
171         partnerMap[_partnerId][_sender].challenge = _challenge;
172     }
173 
174     /* Function to update the hydrogenValuesMap. Called exclusively from the Hydro API */
175     function updateHydroMap(address _sender, uint _value, uint _partnerId) public onlyOwner {
176         hydroPartnerMap[_partnerId][_sender].value = _value;
177         hydroPartnerMap[_partnerId][_sender].timestamp = block.timestamp + 1 days;
178     }
179 
180     /* Function called by Hydro API to check if the partner has validated
181      * The partners value and data must match and it must be less than a day since the last authentication
182      */
183     function validateAuthentication(address _sender, uint _challenge, uint _partnerId) public constant returns (bool _isValid) {
184         if (partnerMap[_partnerId][_sender].value == hydroPartnerMap[_partnerId][_sender].value
185         && block.timestamp < hydroPartnerMap[_partnerId][_sender].timestamp
186         && partnerMap[_partnerId][_sender].challenge == _challenge){
187             return true;
188         }
189         return false;
190     }
191 }