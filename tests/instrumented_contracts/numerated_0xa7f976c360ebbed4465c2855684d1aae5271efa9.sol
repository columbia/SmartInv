1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4 
5     address public owner = msg.sender;
6     address public potentialOwner;
7 
8     modifier onlyOwner {
9       require(msg.sender == owner);
10       _;
11     }
12 
13     modifier onlyPotentialOwner {
14       require(msg.sender == potentialOwner);
15       _;
16     }
17 
18     event NewOwner(address old, address current);
19     event NewPotentialOwner(address old, address potential);
20 
21     function setOwner(address _new)
22       onlyOwner
23     {
24       NewPotentialOwner(owner, _new);
25       potentialOwner = _new;
26       // owner = _new;
27     }
28 
29     function confirmOwnership()
30       onlyPotentialOwner
31     {
32       NewOwner(owner, potentialOwner);
33       owner = potentialOwner;
34       potentialOwner = 0;
35     }
36 }
37 
38 /**
39  * Math operations with safety checks
40  */
41 contract SafeMath {
42   function mul(uint a, uint b) internal returns (uint) {
43     uint c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function div(uint a, uint b) internal returns (uint) {
49     assert(b > 0);
50     uint c = a / b;
51     assert(a == b * c + a % b);
52     return c;
53   }
54 
55   function sub(uint a, uint b) internal returns (uint) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint a, uint b) internal returns (uint) {
61     uint c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 contract AbstractToken {
68     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
69     function totalSupply() constant returns (uint256) {}
70     function balanceOf(address owner) constant returns (uint256 balance);
71     function transfer(address to, uint256 value) returns (bool success);
72     function transferFrom(address from, address to, uint256 value) returns (bool success);
73     function approve(address spender, uint256 value) returns (bool success);
74     function allowance(address owner, address spender) constant returns (uint256 remaining);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78     event Issuance(address indexed to, uint256 value);
79 }
80 
81 
82 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
83 contract StandardToken is AbstractToken {
84 
85     /*
86      *  Data structures
87      */
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90     uint256 public totalSupply;
91 
92     /*
93      *  Read and write storage functions
94      */
95     /// @dev Transfers sender's tokens to a given address. Returns success.
96     /// @param _to Address of token receiver.
97     /// @param _value Number of tokens to transfer.
98     function transfer(address _to, uint256 _value) returns (bool success) {
99         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
100             balances[msg.sender] -= _value;
101             balances[_to] += _value;
102             Transfer(msg.sender, _to, _value);
103             return true;
104         }
105         else {
106             return false;
107         }
108     }
109 
110     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
111     /// @param _from Address from where tokens are withdrawn.
112     /// @param _to Address to where tokens are sent.
113     /// @param _value Number of tokens to transfer.
114     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
115       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
116             balances[_to] += _value;
117             balances[_from] -= _value;
118             allowed[_from][msg.sender] -= _value;
119             Transfer(_from, _to, _value);
120             return true;
121         }
122         else {
123             return false;
124         }
125     }
126 
127     /// @dev Returns number of tokens owned by given address.
128     /// @param _owner Address of token owner.
129     function balanceOf(address _owner) constant returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133     /// @dev Sets approved amount of tokens for spender. Returns success.
134     /// @param _spender Address of allowed account.
135     /// @param _value Number of approved tokens.
136     function approve(address _spender, uint256 _value) returns (bool success) {
137         allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     /*
143      * Read storage functions
144      */
145     /// @dev Returns number of allowed tokens for given address.
146     /// @param _owner Address of token owner.
147     /// @param _spender Address of token spender.
148     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149       return allowed[_owner][_spender];
150     }
151 }
152 
153 
154 /// @title Token contract - Implements Standard Token Interface for TrueFlip.
155 /// @author Zerion - <inbox@zerion.io>
156 contract TrueFlipToken is StandardToken, SafeMath, Owned {
157     /*
158      * External contracts
159      */
160     address public mintAddress;
161     /*
162      * Token meta data
163      */
164     string constant public name = "TrueFlip";
165     string constant public symbol = "TFL";
166     uint8 constant public decimals = 8;
167 
168     // 1 050 000 TFL tokens were minted during PreICO
169     // 13 650 000 TFL tokens can be minted during ICO
170     // 2 100 000 TFL tokens can be minted for Advisory
171     // 4 200 000 TFL tokens can be minted for Team
172     // Overall, 21 000 000 TFL tokens can be minted
173     uint constant public maxSupply = 21000000 * 10 ** 8;
174 
175     // Only true until finalize function is called.
176     bool public mintingAllowed = true;
177     // Address where minted tokens are reserved
178     address constant public mintedTokens = 0x6049604960496049604960496049604960496049;
179 
180     modifier onlyMint() {
181         // Only minter is allowed to proceed.
182         require(msg.sender == mintAddress);
183         _;
184     }
185 
186     /// @dev Function to change address that is allowed to do emission.
187     /// @param newAddress Address of new emission contract.
188     function setMintAddress(address newAddress)
189         public
190         onlyOwner
191         returns (bool)
192     {
193         if (mintAddress == 0x0)
194             mintAddress = newAddress;
195     }
196 
197     /// @dev Contract constructor function sets initial token balances.
198     function TrueFlipToken(address ownerAddress)
199     {
200         owner = ownerAddress;
201         balances[mintedTokens] = mul(1050000, 10 ** 8);
202         totalSupply = balances[mintedTokens];
203     }
204 
205     function mint(address beneficiary, uint amount, bool transfer)
206         external
207         onlyMint
208         returns (bool success)
209     {
210         require(mintingAllowed == true);
211         require(add(totalSupply, amount) <= maxSupply);
212         totalSupply = add(totalSupply, amount);
213         if (transfer) {
214             balances[beneficiary] = add(balances[beneficiary], amount);
215         } else {
216             balances[mintedTokens] = add(balances[mintedTokens], amount);
217             if (beneficiary != 0) {
218                 allowed[mintedTokens][beneficiary] = amount;
219             }
220         }
221         return true;
222     }
223 
224     function finalize()
225         public
226         onlyMint
227         returns (bool success)
228     {
229         mintingAllowed = false;
230         return true;
231     }
232 
233     function requestWithdrawal(address beneficiary, uint amount)
234         public
235         onlyOwner
236     {
237         allowed[mintedTokens][beneficiary] = amount;
238     }
239 
240     function withdrawTokens()
241         public
242     {
243         transferFrom(mintedTokens, msg.sender, allowance(mintedTokens, msg.sender));
244     }
245 }