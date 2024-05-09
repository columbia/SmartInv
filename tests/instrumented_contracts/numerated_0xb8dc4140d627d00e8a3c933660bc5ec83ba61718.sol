1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4     //internals
5     function sub(uint a, uint b) internal pure returns (uint) {
6         require(b <= a);
7         return a - b;
8     }
9 
10     function add(uint a, uint b) internal pure returns (uint) {
11         uint c = a + b;
12         require(c>=a && c>=b);
13         return c;
14     }
15 }
16 
17 contract Owned {
18     address public owner;
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23     function Owned() public {
24         owner = msg.sender;
25     }
26 }
27 
28 /// @title Simple Tokens
29 /// Simple Tokens that can be minted by their owner
30 contract SimpleToken is Owned {
31     using SafeMath for uint256;
32     
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 
36     // This creates a mapping with all balances
37     mapping (address => uint256) public balanceOf;
38     // Another array with spending allowances
39     mapping (address => mapping (address => uint256)) public allowance;
40     // The total supply of the token
41     uint256 public totalSupply;
42 
43     // Some variables for nice wallet integration
44     string public name = "CryptoGold";          // Set the name for display purposes
45     string public symbol = "CGC" ;             // Set the symbol for display purposes
46     uint8 public decimals = 6;                // Amount of decimals for display purposes
47 
48     // Send coins
49     function transfer(address _to, uint256 _value) public returns (bool success) {
50         require(_to != 0x0);
51         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
52         balanceOf[_to] = balanceOf[_to].add(_value);
53         emit Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_to != 0x0);
59         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
60         balanceOf[_from] = balanceOf[_from].sub(_value);
61         balanceOf[_to] = balanceOf[_to].add(_value);
62         emit Transfer(_from, _to, _value);
63         return true;
64     }
65 
66     // Approve that others can transfer _value tokens for the msg.sender
67     function approve(address _spender, uint256 _value) public returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         emit Approval(msg.sender, _spender, _value);
70         return true;
71     }
72     
73     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
74         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
75         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
76         return true;
77     }
78     
79     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
80         uint oldValue = allowance[msg.sender][_spender];
81         if (_subtractedValue > oldValue) {
82             allowance[msg.sender][_spender] = 0;
83         } else {
84             allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
85         }
86         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
87         return true;
88     }
89 
90 }
91 
92 /// @title Multisignature Mintable Token - Allows minting of Tokens by a 2-2-Multisignature
93 /// @author Henning Kopp - <kopp@blockchain-beratung.de>
94 contract MultiSigMint is SimpleToken {
95 
96     // Address change event
97     event newOwner(address indexed oldAddress, address indexed newAddress);
98     event newNotary(address indexed oldAddress, address indexed newAddress);    
99     event Mint(address indexed minter, uint256 value);
100     event Burn(address indexed burner, uint256 value);
101 
102     // The address of the notary
103     address public notary;
104 
105     uint256 proposedMintAmnt = 0;
106     uint256 proposedBurnAmnt = 0;
107 
108     address proposeOwner = 0x0;
109     address proposeNotary = 0x0;
110 
111     function MultiSigMint(address _notary) public {
112         require(_notary != 0x0);
113         require(msg.sender != _notary);
114         notary = _notary;
115     }
116 
117     modifier onlyNotary {
118         require(msg.sender == notary);
119         _;
120     }
121 
122     /* Allows the owner to propose the minting of tokens.
123      * tokenamount is the amount of tokens to be minted.
124      */
125     function proposeMinting(uint256 _tokenamount) external onlyOwner returns (bool) {
126         require(_tokenamount > 0);
127         proposedMintAmnt = _tokenamount;
128         return true;
129     }
130 
131     /* Allows the notary to confirm the minting of tokens.
132      * tokenamount is the amount of tokens to be minted.
133      */
134     function confirmMinting(uint256 _tokenamount) external onlyNotary returns (bool) {
135         if (_tokenamount == proposedMintAmnt) {
136             proposedMintAmnt = 0; // reset the amount
137             balanceOf[owner] = balanceOf[owner].add(_tokenamount);
138             totalSupply = totalSupply.add(_tokenamount);
139             emit Mint(owner, _tokenamount);
140             emit Transfer(0x0, owner, _tokenamount);
141             return true;
142         } else {
143             proposedMintAmnt = 0; // reset the amount
144             return false;
145         }
146     }
147 
148     /* Allows the owner to propose the burning of tokens.
149      * tokenamount is the amount of tokens to be burned.
150      */
151     function proposeBurning(uint256 _tokenamount) external onlyOwner returns (bool) {
152         require(_tokenamount > 0);
153         proposedBurnAmnt = _tokenamount;
154         return true;
155     }
156 
157     /* Allows the notary to confirm the burning of tokens.
158      * tokenamount is the amount of tokens to be burning.
159      */
160     function confirmBurning(uint256 _tokenamount) external onlyNotary returns (bool) {
161         if (_tokenamount == proposedBurnAmnt) {
162             proposedBurnAmnt = 0; // reset the amount
163             balanceOf[owner] = balanceOf[owner].sub(_tokenamount);
164             totalSupply = totalSupply.sub(_tokenamount);
165             emit Burn(owner, _tokenamount);
166             emit Transfer(owner, 0x0, _tokenamount);
167             return true;
168         } else {
169             proposedBurnAmnt = 0; // reset the amount
170             return false;
171         }
172     }
173 
174     /* Owner can propose an address change for owner
175     The notary has to confirm that address
176     */
177     function proposeNewOwner(address _newAddress) external onlyOwner {
178         proposeOwner = _newAddress;
179     }
180     function confirmNewOwner(address _newAddress) external onlyNotary returns (bool) {
181         if (proposeOwner == _newAddress && _newAddress != 0x0 && _newAddress != notary) {
182             proposeOwner = 0x0;
183             emit newOwner(owner, _newAddress);
184             owner = _newAddress;
185             return true;
186         } else {
187             proposeOwner = 0x0;
188             return false;
189         }
190     }
191     
192     /* Owner can propose an address change for notary
193     The notary has to confirm that address
194     */
195     function proposeNewNotary(address _newAddress) external onlyOwner {
196         proposeNotary = _newAddress;
197     }
198     function confirmNewNotary(address _newAddress) external onlyNotary returns (bool) {
199         if (proposeNotary == _newAddress && _newAddress != 0x0 && _newAddress != owner) {
200             proposeNotary = 0x0;
201             emit newNotary(notary, _newAddress);
202             notary = _newAddress;
203             return true;
204         } else {
205             proposeNotary = 0x0;
206             return false;
207         }
208     }
209 }
210 
211 /// @title Contract with fixed parameters for deployment
212 /// @author Henning Kopp - <kopp@blockchain-beratung.de>
213 contract GoldToken is MultiSigMint {
214     function GoldToken(address _notary) public MultiSigMint(_notary) {}
215 }