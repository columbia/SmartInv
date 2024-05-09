1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-27
3 */
4 
5 pragma solidity ^0.5.16;
6 pragma experimental ABIEncoderV2;
7 
8 contract OBEE {
9     
10     string public constant name = "Obee Network";
11 
12     
13     string public constant symbol = "OBEE";
14 
15     
16     uint8 public constant decimals = 18;
17 
18     
19     uint public constant totalSupply = 12000000000e18; 
20 
21     
22     mapping (address => mapping (address => uint96)) internal allowances;
23 
24     
25     mapping (address => uint96) internal balances;
26 
27     
28     mapping (address => address) public delegates;
29 
30     
31     struct Checkpoint {
32         uint32 fromBlock;
33         uint96 votes;
34     }
35 
36     
37     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
38 
39     
40     mapping (address => uint32) public numCheckpoints;
41 
42     
43     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
44 
45    
46     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
47 
48    
49     mapping (address => uint) public nonces;
50 
51     
52     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
53 
54     
55     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
56 
57     
58     event Transfer(address indexed from, address indexed to, uint256 amount);
59 
60     
61     event Approval(address indexed owner, address indexed spender, uint256 amount);
62 
63   
64     constructor(address account) public {
65         balances[account] = uint96(totalSupply);
66         emit Transfer(address(0), account, totalSupply);
67     }
68 
69  
70     function allowance(address account, address spender) external view returns (uint) {
71         return allowances[account][spender];
72     }
73 
74 
75     function approve(address spender, uint rawAmount) external returns (bool) {
76         uint96 amount;
77         if (rawAmount == uint(-1)) {
78             amount = uint96(-1);
79         } else {
80             amount = safe96(rawAmount, "OBEE::approve: amount exceeds 96 bits");
81         }
82 
83         allowances[msg.sender][spender] = amount;
84 
85         emit Approval(msg.sender, spender, amount);
86         return true;
87     }
88 
89 
90     function balanceOf(address account) external view returns (uint) {
91         return balances[account];
92     }
93 
94 
95     function transfer(address dst, uint rawAmount) external returns (bool) {
96         uint96 amount = safe96(rawAmount, "OBEE::transfer: amount exceeds 96 bits");
97         _transferTokens(msg.sender, dst, amount);
98         return true;
99     }
100 
101     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
102         address spender = msg.sender;
103         uint96 spenderAllowance = allowances[src][spender];
104         uint96 amount = safe96(rawAmount, "OBEE::approve: amount exceeds 96 bits");
105 
106         if (spender != src && spenderAllowance != uint96(-1)) {
107             uint96 newAllowance = sub96(spenderAllowance, amount, "OBEE::transferFrom: transfer amount exceeds spender allowance");
108             allowances[src][spender] = newAllowance;
109 
110             emit Approval(src, spender, newAllowance);
111         }
112 
113         _transferTokens(src, dst, amount);
114         return true;
115     }
116 
117 
118     function delegate(address delegatee) public {
119         return _delegate(msg.sender, delegatee);
120     }
121 
122 
123     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
124         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
125         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
126         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
127         address signatory = ecrecover(digest, v, r, s);
128         require(signatory != address(0), "OBEE::delegateBySig: invalid signature");
129         require(nonce == nonces[signatory]++, "OBEE::delegateBySig: invalid nonce");
130         require(now <= expiry, "OBEE::delegateBySig: signature expired");
131         return _delegate(signatory, delegatee);
132     }
133 
134 
135     function getCurrentVotes(address account) external view returns (uint96) {
136         uint32 nCheckpoints = numCheckpoints[account];
137         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
138     }
139 
140 
141     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
142         require(blockNumber < block.number, "OBEE::getPriorVotes: not yet determined");
143 
144         uint32 nCheckpoints = numCheckpoints[account];
145         if (nCheckpoints == 0) {
146             return 0;
147         }
148 
149     
150         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
151             return checkpoints[account][nCheckpoints - 1].votes;
152         }
153 
154         // Next check implicit zero balance
155         if (checkpoints[account][0].fromBlock > blockNumber) {
156             return 0;
157         }
158 
159         uint32 lower = 0;
160         uint32 upper = nCheckpoints - 1;
161         while (upper > lower) {
162             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
163             Checkpoint memory cp = checkpoints[account][center];
164             if (cp.fromBlock == blockNumber) {
165                 return cp.votes;
166             } else if (cp.fromBlock < blockNumber) {
167                 lower = center;
168             } else {
169                 upper = center - 1;
170             }
171         }
172         return checkpoints[account][lower].votes;
173     }
174 
175     function _delegate(address delegator, address delegatee) internal {
176         address currentDelegate = delegates[delegator];
177         uint96 delegatorBalance = balances[delegator];
178         delegates[delegator] = delegatee;
179 
180         emit DelegateChanged(delegator, currentDelegate, delegatee);
181 
182         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
183     }
184 
185     function _transferTokens(address src, address dst, uint96 amount) internal {
186         require(src != address(0), "OBEE::_transferTokens: cannot transfer from the zero address");
187         require(dst != address(0), "OBEE::_transferTokens: cannot transfer to the zero address");
188 
189         balances[src] = sub96(balances[src], amount, "OBEE::_transferTokens: transfer amount exceeds balance");
190         balances[dst] = add96(balances[dst], amount, "OBEE::_transferTokens: transfer amount overflows");
191         emit Transfer(src, dst, amount);
192 
193         _moveDelegates(delegates[src], delegates[dst], amount);
194     }
195 
196     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
197         if (srcRep != dstRep && amount > 0) {
198             if (srcRep != address(0)) {
199                 uint32 srcRepNum = numCheckpoints[srcRep];
200                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
201                 uint96 srcRepNew = sub96(srcRepOld, amount, "OBEE::_moveVotes: vote amount underflows");
202                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
203             }
204 
205             if (dstRep != address(0)) {
206                 uint32 dstRepNum = numCheckpoints[dstRep];
207                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
208                 uint96 dstRepNew = add96(dstRepOld, amount, "OBEE::_moveVotes: vote amount overflows");
209                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
210             }
211         }
212     }
213 
214     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
215       uint32 blockNumber = safe32(block.number, "OBEE::_writeCheckpoint: block number exceeds 32 bits");
216 
217       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
218           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
219       } else {
220           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
221           numCheckpoints[delegatee] = nCheckpoints + 1;
222       }
223 
224       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
225     }
226 
227     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
228         require(n < 2**32, errorMessage);
229         return uint32(n);
230     }
231 
232     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
233         require(n < 2**96, errorMessage);
234         return uint96(n);
235     }
236 
237     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
238         uint96 c = a + b;
239         require(c >= a, errorMessage);
240         return c;
241     }
242 
243     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
244         require(b <= a, errorMessage);
245         return a - b;
246     }
247 
248     function getChainId() internal pure returns (uint) {
249         uint256 chainId;
250         assembly { chainId := chainid() }
251         return chainId;
252     }
253 }