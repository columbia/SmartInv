1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SMILE Token
5  * @author Alex Papageorgiou - <alex.ppg@protonmail.com>
6  * @notice The Smile Token token & airdrop contract which conforms to EIP-20 & partially ERC-223
7  */
8 contract SMILE {
9 
10     /**
11      * Constant EIP-20 / ERC-223 variables & getters
12      */
13 
14     string constant public name = "Smile Token";
15     string constant public symbol = "SMILE";
16     uint256 constant public decimals = 18;
17     uint256 constant public totalSupply = 100000000 * (10 ** decimals);
18 
19     /**
20      * A variable to store the contract creator
21      */
22 
23     address public creator;
24 
25     /**
26      * A variable to declare whether distribution is on-going
27      */
28 
29     bool public distributionFinished = false;
30 
31     /**
32      * Classic EIP-20 / ERC-223 mappings and getters
33      */
34 
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     /**
39      *      EIP-20 Events. As the ERC-223 Transfer overlaps with EIP-20,
40      *      observers are unable to track both. In order to be compatible,
41      *      the ERC-223 Event spec is not integrated.
42      */
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46     event Mint(address indexed to, uint value);
47 
48     /**
49      *      Ensures that the caller is the owner of the
50      *      contract and that the address to withdraw from
51      *      is not the contract itself.
52      */
53 
54     modifier canWithdraw(address _tokenAddress) {
55         assert(msg.sender == creator && _tokenAddress != address(this));
56         _;
57     }
58 
59     /**
60      *      Ensures that the caller is the owner of the
61      *      contract and that the distribution is still
62      *      in effect.
63      */
64 
65     modifier canDistribute() {
66         assert(msg.sender == creator && !distributionFinished);
67         _;
68     }
69 
70     /**
71      * Contract constructor which assigns total supply to caller & assigns caller as creator
72      */
73 
74     constructor() public {
75         creator = msg.sender;
76         balanceOf[msg.sender] = totalSupply;
77         emit Mint(msg.sender, totalSupply);
78     }
79 
80     /**
81      * Partial SafeMath library import of safe substraction
82      * @param _a Minuend: The number to substract from
83      * @param _b Subtrahend: The number that is to be subtracted
84      */
85 
86     function safeSub(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
87         assert((c = _a - _b) <= _a);
88     }
89 
90     /**
91      * Partial SafeMath library import of safe multiplication
92      * @param _a Multiplicand: The number to multiply
93      * @param _b Multiplier: The number to multiply by
94      */
95 
96     function safeMul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
97         // Automatic failure on division by zero
98         assert((c = _a * _b) / _a == _b);
99     }
100 
101     /**
102      * EIP-20 Transfer implementation
103      * @param _to The address to send tokens to
104      * @param _value The amount of tokens to send
105      */
106 
107     function transfer(address _to, uint256 _value) public returns (bool) {
108         // Prevent accidental transfers to the default 0x0 address
109         assert(_to != 0x0);
110         bytes memory empty;
111         if (isContract(_to)) {
112             return transferToContract(_to, _value, empty);
113         } else {
114             return transferToAddress(_to, _value);
115         }
116     }
117 
118     /**
119      * ERC-223 Transfer implementation
120      * @param _to The address to send tokens to
121      * @param _value The amount of tokens to send
122      * @param _data Any accompanying data for contract transfers
123      */
124 
125     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
126         // Prevent accidental transfers to the default 0x0 address
127         assert(_to != 0x0);
128         if (isContract(_to)) {
129             return transferToContract(_to, _value, _data);
130         } else {
131             return transferToAddress(_to, _value);
132         }
133     }
134 
135     /**
136      * EIP-20 Transfer From implementation
137      * @param _from The address to transfer tokens from
138      * @param _to The address to transfer tokens to
139      * @param _value The amount of tokens to transfer
140      */
141 
142     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143         allowance[_from][_to] = safeSub(allowance[_from][_to], _value);
144         balanceOf[_from] = safeSub(balanceOf[_from], _value);
145         balanceOf[_to] += _value;
146         emit Transfer(_from, _to, _value);
147         return true;
148     }
149 
150     /**
151      * EIP-20 Approve implementation (Susceptible to Race Condition, mitigation optional)
152      * @param _spender The address to delegate spending rights to
153      * @param _value The amount of tokens to delegate
154      */
155 
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowance[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * ERC-223 Transfer to Contract implementation
164      * @param _to The contract address to send tokens to
165      * @param _value The amount of tokens to send
166      * @param _data Any accompanying data to relay to the contract
167      */
168 
169     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool) {
170         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
171         balanceOf[_to] += _value;
172         SMILE interfaceProvider = SMILE(_to);
173         interfaceProvider.tokenFallback(msg.sender, _value, _data);
174         emit Transfer(msg.sender, _to, _value);
175         return true;
176     }
177 
178     /**
179      * ERC-223 Token Fallback interface implementation
180      * @param _from The address that initiated the transfer
181      * @param _value The amount of tokens transferred
182      * @param _data Any accompanying data to relay to the contract
183      */
184 
185     function tokenFallback(address _from, uint256 _value, bytes _data) public {}
186 
187     /**
188      * 
189      *      Partial ERC-223 Transfer to Address implementation.
190      *      The bytes parameter is intentioanlly dropped as it
191      *      is not utilized.
192      *
193      * @param _to The address to send tokens to
194      * @param _value The amount of tokens to send
195      */
196 
197     function transferToAddress(address _to, uint256 _value) private returns (bool) {
198         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
199         balanceOf[_to] += _value;
200         emit Transfer(msg.sender, _to, _value);
201         return true;
202     }
203 
204     /**
205      * ERC-223 Contract check implementation
206      * @param _addr The address to check contract existance in
207      */
208 
209     function isContract(address _addr) private view returns (bool) {
210         uint256 length;
211         assembly {
212             length := extcodesize(_addr)
213         }
214         // NE is more gas efficient than GT
215         return (length != 0);
216     }
217 
218     /**
219      * Implementation of a multi-user distribution function
220      * @param _addresses The array of addresses to transfer to
221      * @param _value The amount of tokens to transfer to each
222      */
223 
224     function distributeSMILE(address[] _addresses, uint256 _value) canDistribute external {
225          for (uint256 i = 0; i < _addresses.length; i++) {
226              balanceOf[_addresses[i]] += _value;
227              emit Transfer(msg.sender, _addresses[i], _value);
228          }
229          // Can be removed in one call instead of each time within the loop
230          balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], safeMul(_value, _addresses.length));
231     }
232 
233     /**
234      * Implementation to retrieve accidentally sent EIP-20 compliant tokens
235      * @param _token The contract address of the EIP-20 compliant token
236      */
237 
238     function retrieveERC(address _token) external canWithdraw(_token) {
239         SMILE interfaceProvider = SMILE(_token);
240         // By default, the whole balance of the contract is sent to the caller
241         interfaceProvider.transfer(msg.sender, interfaceProvider.balanceOf(address(this)));
242     }
243 
244     /**
245      *      Absence of payable modifier is intentional as
246      *      it causes accidental Ether transfers to throw.
247      */
248 
249     function() public {}
250 }