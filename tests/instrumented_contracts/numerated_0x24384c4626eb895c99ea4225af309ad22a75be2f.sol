1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Owned contract with safe ownership pass.
5  *
6  * Note: all the non constant functions return false instead of throwing in case if state change
7  * didn't happen yet.
8  */
9 contract Owned {
10     /**
11      * Contract owner address
12      */
13     address public contractOwner;
14 
15     /**
16      * Contract owner address
17      */
18     address public pendingContractOwner;
19 
20     function Owned() {
21         contractOwner = msg.sender;
22     }
23 
24     /**
25     * @dev Owner check modifier
26     */
27     modifier onlyContractOwner() {
28         if (contractOwner == msg.sender) {
29             _;
30         }
31     }
32 
33     /**
34      * @dev Destroy contract and scrub a data
35      * @notice Only owner can call it
36      */
37     function destroy() onlyContractOwner {
38         suicide(msg.sender);
39     }
40 
41     /**
42      * Prepares ownership pass.
43      *
44      * Can only be called by current owner.
45      *
46      * @param _to address of the next owner. 0x0 is not allowed.
47      *
48      * @return success.
49      */
50     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
51         if (_to  == 0x0) {
52             return false;
53         }
54 
55         pendingContractOwner = _to;
56         return true;
57     }
58 
59     /**
60      * Finalize ownership pass.
61      *
62      * Can only be called by pending owner.
63      *
64      * @return success.
65      */
66     function claimContractOwnership() returns(bool) {
67         if (pendingContractOwner != msg.sender) {
68             return false;
69         }
70 
71         contractOwner = pendingContractOwner;
72         delete pendingContractOwner;
73 
74         return true;
75     }
76 }
77 
78 contract ERC20Interface {
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed from, address indexed spender, uint256 value);
81     string public symbol;
82 
83     function totalSupply() constant returns (uint256 supply);
84     function balanceOf(address _owner) constant returns (uint256 balance);
85     function transfer(address _to, uint256 _value) returns (bool success);
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
87     function approve(address _spender, uint256 _value) returns (bool success);
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
89 }
90 
91 /**
92  * @title Generic owned destroyable contract
93  */
94 contract Object is Owned {
95     /**
96     *  Common result code. Means everything is fine.
97     */
98     uint constant OK = 1;
99     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
100 
101     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
102         for(uint i=0;i<tokens.length;i++) {
103             address token = tokens[i];
104             uint balance = ERC20Interface(token).balanceOf(this);
105             if(balance != 0)
106                 ERC20Interface(token).transfer(_to,balance);
107         }
108         return OK;
109     }
110 
111     function checkOnlyContractOwner() internal constant returns(uint) {
112         if (contractOwner == msg.sender) {
113             return OK;
114         }
115 
116         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
117     }
118 }
119 
120 
121 /**
122  * @title Events History universal multi contract.
123  *
124  * Contract serves as an Events storage for any type of contracts.
125  * Events appear on this contract address but their definitions provided by calling contracts.
126  *
127  * Note: all the non constant functions return false instead of throwing in case if state change
128  * didn't happen yet.
129  */
130 contract MultiEventsHistory is Object {
131     // Authorized calling contracts.
132     mapping(address => bool) public isAuthorized;
133 
134     /**
135      * Authorize new caller contract.
136      *
137      * @param _caller address of the new caller.
138      *
139      * @return success.
140      */
141     function authorize(address _caller) onlyContractOwner() returns(bool) {
142         if (isAuthorized[_caller]) {
143             return false;
144         }
145         isAuthorized[_caller] = true;
146         return true;
147     }
148 
149     /**
150      * Reject access.
151      *
152      * @param _caller address of the caller.
153      */
154     function reject(address _caller) onlyContractOwner() {
155         delete isAuthorized[_caller];
156     }
157 
158     /**
159      * Event emitting fallback.
160      *
161      * Can be and only called by authorized caller.
162      * Delegate calls back with provided msg.data to emit an event.
163      *
164      * Throws if call failed.
165      */
166     function () {
167         if (!isAuthorized[msg.sender]) {
168             return;
169         }
170         // Internal Out Of Gas/Throw: revert this transaction too;
171         // Recursive Call: safe, all changes already made.
172         if (!msg.sender.delegatecall(msg.data)) {
173             throw;
174         }
175     }
176 }