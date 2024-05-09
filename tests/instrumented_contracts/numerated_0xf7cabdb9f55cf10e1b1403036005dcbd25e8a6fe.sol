1 pragma solidity ^0.4.19;
2 
3 /**
4  * EIP-20 standard token interface, as defined at
5  * ttps://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6  */
7 contract Token {
8     function name() public constant returns (string);
9     function symbol() public constant returns (string);
10     function decimals() public constant returns (uint8);
11     function totalSupply() public constant returns (uint256);
12     function balanceOf(address _owner) public constant returns (uint256);
13     function transfer(address _to, uint256 _value) public returns (bool);
14     function transferFrom(address _from, address _to, uint256 _value)
15         public returns (bool);
16     function approve(address _spender, uint256 _value) public returns (bool);
17     function allowance(address _owner, address _spender)
18         public constant returns (uint256);
19     
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(
22         address indexed _owner, address indexed _spender, uint256 _value);
23 }
24 
25 /**
26  * Allows one to lock EIP-20 tokens until certain time arrives.
27  * Copyright © 2018 by ABDK Consulting https://abdk.consulting/
28  * Author: Mikhail Vladimirov <mikhail.vladimirov[at]gmail.com>
29  */
30 contract TokenTimeLock {
31     /**
32      * Create new Token Time Lock with given donation address.
33      *
34      * @param _donationAddress donation address
35      */
36     function TokenTimeLock (address _donationAddress) public {
37         donationAddress = _donationAddress;
38     }
39 
40     /**
41      * Lock given amount of given EIP-20 tokens until given time arrives, after
42      * this time allow the tokens to be transferred to given beneficiary.  This
43      * contract should be allowed to transfer at least given amount of tokens
44      * from msg.sender.
45      *
46      * @param _token EIP-20 token contract managing tokens to be locked
47      * @param _beneficiary beneficiary to receive tokens after unlock time
48      * @param _amount amount of tokens to be locked
49      * @param _unlockTime unlock time
50      *
51      * @return time lock ID
52      */
53     function lock (
54         Token _token, address _beneficiary, uint256 _amount,
55         uint256 _unlockTime) public returns (uint256) {
56         require (_amount > 0);
57 
58         uint256 id = nextLockID++;
59 
60         TokenTimeLockInfo storage lockInfo = locks [id];
61 
62         lockInfo.token = _token;
63         lockInfo.beneficiary = _beneficiary;
64         lockInfo.amount = _amount;
65         lockInfo.unlockTime = _unlockTime;
66 
67         Lock (id, _token, _beneficiary, _amount, _unlockTime);
68 
69         require (_token.transferFrom (msg.sender, this, _amount));
70 
71         return id;
72     }
73 
74     /**
75      * Unlock tokens locked under time lock with given ID and transfer them to
76      * corresponding beneficiary.
77      *
78      * @param _id time lock ID to unlock tokens locked under
79      */
80     function unlock (uint256 _id) public {
81         TokenTimeLockInfo memory lockInfo = locks [_id];
82         delete locks [_id];
83 
84         require (lockInfo.amount > 0);
85         require (lockInfo.unlockTime <= block.timestamp);
86 
87         Unlock (_id);
88 
89         require (
90             lockInfo.token.transfer (
91                 lockInfo.beneficiary, lockInfo.amount));
92     }
93 
94     /**
95      * If you like this contract, you may send some ether to this address and
96      * it will be used to develop more useful contracts available to everyone.
97      */
98     address public donationAddress;
99 
100     /**
101      * Next time lock ID to be used.
102      */
103     uint256 private nextLockID = 0;
104 
105     /**
106      * Maps time lock ID to TokenTimeLockInfo structure encapsulating time lock
107      * information.
108      */
109     mapping (uint256 => TokenTimeLockInfo) public locks;
110 
111     /**
112      * Encapsulates information abount time lock.
113      */
114     struct TokenTimeLockInfo {
115         /**
116          * EIP-20 token contract managing locked tokens.
117          */
118         Token token;
119 
120         /**
121          * Beneficiary to receive tokens once they are unlocked.
122          */
123         address beneficiary;
124 
125         /**
126          * Amount of locked tokens.
127          */
128         uint256 amount;
129 
130         /**
131          * Unlock time.
132          */
133         uint256 unlockTime;
134     }
135 
136     /**
137      * Logged when tokens were time locked.
138      *
139      * @param id time lock ID
140      * @param token EIP-20 token contract managing locked tokens
141      * @param beneficiary beneficiary to receive tokens once they are unlocked
142      * @param amount amount of locked tokens
143      * @param unlockTime unlock time
144      */
145     event Lock (
146         uint256 indexed id, Token indexed token, address indexed beneficiary,
147         uint256 amount, uint256 unlockTime);
148 
149     /**
150      * Logged when tokens were unlocked and sent to beneficiary.
151      *
152      * @param id time lock ID
153      */
154     event Unlock (uint256 indexed id);
155 }