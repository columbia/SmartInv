1 pragma solidity ^0.4.18;
2 
3 // BlackBox2.0 - Secure Ether & Token Storage
4 // Rinkeby test contract: 0x21ED89693fF7e91c757DbDD9Aa30448415aa8156
5 
6 // token interface
7 contract Token {
8     function balanceOf(address _owner) constant public returns (uint balance);
9     function allowance(address _user, address _spender) constant public returns (uint amount);
10     function transfer(address _to, uint _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
12 }
13 
14 // owned by contract creator
15 contract Owned {
16     address public owner = msg.sender;
17     bool public restricted = true;
18 
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23     
24     // restrict external contract calls
25     modifier onlyCompliant {
26         if (restricted) require(tx.origin == msg.sender);
27         _;
28     }
29     
30     function transferOwnership(address newOwner) public onlyOwner {
31         owner = newOwner;
32     }
33     
34     function changeRestrictions() public onlyOwner {
35         restricted = !restricted;
36     }
37     
38     function kill() public onlyOwner {
39         selfdestruct(owner);
40     }
41 }
42 
43 // helper functions for hashing
44 contract Encoder {
45     enum Algorithm { sha, keccak }
46 
47     /// @dev generateProofSet - function for off-chain proof derivation
48     /// @param seed Secret used to secure the proof-set
49     /// @param caller Address of the caller, or account that verifies the proof-set
50     /// @param receiver Address of the encoded recepient
51     /// @param tokenAddress Address of the token to transfer from the caller
52     /// @param algorithm Hash algorithm to use for generating proof-set
53     function generateProofSet(
54         string seed,
55         address caller,
56         address receiver,
57         address tokenAddress,
58         Algorithm algorithm
59     ) pure public returns(bytes32 hash, bytes32 operator, bytes32 check, address check_receiver, address check_token) {
60         (hash, operator, check) = _escrow(seed, caller, receiver, tokenAddress, algorithm);
61         bytes32 key = hash_seed(seed, algorithm);
62         check_receiver = address(hash_data(key, algorithm)^operator);
63         if (check_receiver == 0) check_receiver = caller;
64         if (tokenAddress != 0) check_token = address(check^key^blind(receiver, algorithm));
65     }
66 
67     // internal function for generating the proof-set
68     function _escrow(
69         string seed, 
70         address caller,
71         address receiver,
72         address tokenAddress,
73         Algorithm algorithm
74     ) pure internal returns(bytes32 index, bytes32 operator, bytes32 check) {
75         require(caller != receiver && caller != 0);
76         bytes32 x = hash_seed(seed, algorithm);
77         if (algorithm == Algorithm.sha) {
78             index = sha256(x, caller);
79             operator = sha256(x)^bytes32(receiver);
80             check = x^sha256(receiver);
81         } else {
82             index = keccak256(x, caller);
83             operator = keccak256(x)^bytes32(receiver);
84             check = x^keccak256(receiver);
85         }
86         if (tokenAddress != 0) {
87             check ^= bytes32(tokenAddress);
88         }
89     }
90     
91     // internal function for hashing the seed
92     function hash_seed(
93         string seed, 
94         Algorithm algorithm
95     ) pure internal returns(bytes32) {
96         if (algorithm == Algorithm.sha) return sha256(seed);
97         else return keccak256(seed);
98     }
99     
100    // internal function for hashing bytes
101     function hash_data(
102         bytes32 key, 
103         Algorithm algorithm
104     ) pure internal returns(bytes32) {
105         if (algorithm == Algorithm.sha) return sha256(key);
106         else return keccak256(key);
107     }
108     
109     // internal function for hashing an address
110     function blind(
111         address addr,
112         Algorithm algorithm
113     ) pure internal returns(bytes32) {
114         if (algorithm == Algorithm.sha) return sha256(addr);
115         else return keccak256(addr);
116     }
117     
118 }
119 
120 
121 contract BlackBox is Owned, Encoder {
122 
123     // struct of proof set
124     struct Proof {
125         uint256 balance;
126         bytes32 operator;
127         bytes32 check;
128     }
129     
130     // mappings
131     mapping(bytes32 => Proof) public proofs;
132     mapping(bytes32 => bool) public used;
133     mapping(address => uint) private deposits;
134 
135     // events
136     event ProofVerified(string _key, address _prover, uint _value);
137     event Locked(bytes32 _hash, bytes32 _operator, bytes32 _check);
138     event WithdrawTokens(address _token, address _to, uint _value);
139     event ClearedDeposit(address _to, uint value);
140     event TokenTransfer(address _token, address _from, address _to, uint _value);
141 
142     /// @dev lock - store a proof-set
143     /// @param _hash Hash Key used to index the proof
144     /// @param _operator A derived operator to encode the intended recipient
145     /// @param _check A derived operator to check recipient, or a decode the token address
146     function lock(
147         bytes32 _hash,
148         bytes32 _operator,
149         bytes32 _check
150     ) public payable {
151         // protect invalid entries on value transfer
152         if (msg.value > 0) {
153             require(_hash != 0 && _operator != 0 && _check != 0);
154         }
155         // check existence
156         require(!used[_hash]);
157         // lock the ether
158         proofs[_hash].balance = msg.value;
159         proofs[_hash].operator = _operator;
160         proofs[_hash].check = _check;
161         // track unique keys
162         used[_hash] = true;
163         Locked(_hash, _operator, _check);
164     }
165 
166     /// @dev unlock - verify a proof to transfer the locked funds
167     /// @param _seed Secret used to derive the proof set
168     /// @param _value Optional token value to transfer if the proof-set maps to a token transfer
169     /// @param _algo Hash algorithm type
170     function unlock(
171         string _seed,
172         uint _value,
173         Algorithm _algo
174     ) public onlyCompliant {
175         bytes32 hash = 0;
176         bytes32 operator = 0;
177         bytes32 check = 0;
178         // calculate the proof
179         (hash, operator, check) = _escrow(_seed, msg.sender, 0, 0, _algo);
180         require(used[hash]);
181         // get balance to send to decoded receiver
182         uint balance = proofs[hash].balance;
183         address receiver = address(proofs[hash].operator^operator);
184         address _token = address(proofs[hash].check^hash_seed(_seed, _algo)^blind(receiver, _algo));
185         delete proofs[hash];
186         if (receiver == 0) receiver = msg.sender;
187         // send balance and deposits
188         clearDeposits(receiver, balance);
189         ProofVerified(_seed, msg.sender, balance);
190 
191         // check for token transfer
192         if (_token != 0) {
193             Token token = Token(_token);
194             uint tokenBalance = token.balanceOf(msg.sender);
195             uint allowance = token.allowance(msg.sender, this);
196             // check the balance to send to the receiver
197             if (_value == 0 || _value > tokenBalance) _value = tokenBalance;
198             if (allowance > 0 && _value > 0) {
199                 if (_value > allowance) _value = allowance;
200                 TokenTransfer(_token, msg.sender, receiver, _value);
201                 require(token.transferFrom(msg.sender, receiver, _value));
202             }
203         }
204     }
205     
206     /// @dev withdrawTokens - withdraw tokens from contract
207     /// @param _token Address of token that this contract holds
208     function withdrawTokens(address _token) public onlyOwner {
209         Token token = Token(_token);
210         uint256 value = token.balanceOf(this);
211         require(token.transfer(msg.sender, value));
212         WithdrawTokens(_token, msg.sender, value);
213     }
214     
215     /// @dev clearDeposits - internal function to send ether
216     /// @param _for Address of recipient
217     /// @param _value Value of proof balance
218     function clearDeposits(address _for, uint _value) internal {
219         uint deposit = deposits[msg.sender];
220         if (deposit > 0) delete deposits[msg.sender];
221         if (deposit + _value > 0) {
222             if (!_for.send(deposit+_value)) {
223                 require(msg.sender.send(deposit+_value));
224             }
225             ClearedDeposit(_for, deposit+_value);
226         }
227     }
228     
229     function allowance(address _token, address _from) public view returns(uint _allowance) {
230         Token token = Token(_token);
231         _allowance = token.allowance(_from, this);
232     }
233     
234     // store deposits for msg.sender
235     function() public payable {
236         require(msg.value > 0);
237         deposits[msg.sender] += msg.value;
238     }
239     
240 }