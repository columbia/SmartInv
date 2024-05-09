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
27  * Copyright © 2018 by Oleksii Vynogradov
28  * Author: Oleksii Vynogradov <alex[at]cfc.io>
29  */
30 contract CradTimeLock {
31     /**
32      * Create new Token Time Lock with given owner address.
33      *
34      * @param _owner owner address
35      */
36     function CradTimeLock (address _owner) public {
37         owner = _owner;
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
57         require (msg.sender == owner);
58 
59         uint256 id = nextLockID++;
60 
61         TokenTimeLockInfo storage lockInfo = locks [id];
62 
63         lockInfo.token = _token;
64         lockInfo.beneficiary = _beneficiary;
65         lockInfo.amount = _amount;
66         lockInfo.unlockTime = _unlockTime;
67 
68         emit Lock (id, _token, _beneficiary, _amount, _unlockTime);
69 
70         require (_token.transferFrom (msg.sender, this, _amount));
71 
72         return id;
73     }
74 
75     /**
76      * Unlock tokens locked under time lock with given ID and transfer them to
77      * corresponding beneficiary.
78      *
79      * @param _id time lock ID to unlock tokens locked under
80      */
81     function unlock (uint256 _id) public {
82         TokenTimeLockInfo memory lockInfo = locks [_id];
83         delete locks [_id];
84 
85         require (lockInfo.amount > 0);
86         require (lockInfo.unlockTime <= block.timestamp);
87         require (msg.sender == owner);
88 
89         emit Unlock (_id);
90 
91         require (
92             lockInfo.token.transfer (
93                 lockInfo.beneficiary, lockInfo.amount));
94     }
95 
96     /**
97      * If you like this contract, you may send some ether to this address and
98      * it will be used to develop more useful contracts available to everyone.
99      */
100     address public owner;
101 
102     /**
103      * Next time lock ID to be used.
104      */
105     uint256 private nextLockID = 0;
106 
107     /**
108      * Maps time lock ID to TokenTimeLockInfo structure encapsulating time lock
109      * information.
110      */
111     mapping (uint256 => TokenTimeLockInfo) public locks;
112 
113     /**
114      * Encapsulates information abount time lock.
115      */
116     struct TokenTimeLockInfo {
117         /**
118          * EIP-20 token contract managing locked tokens.
119          */
120         Token token;
121 
122         /**
123          * Beneficiary to receive tokens once they are unlocked.
124          */
125         address beneficiary;
126 
127         /**
128          * Amount of locked tokens.
129          */
130         uint256 amount;
131 
132         /**
133          * Unlock time.
134          */
135         uint256 unlockTime;
136     }
137 
138     /**
139      * Logged when tokens were time locked.
140      *
141      * @param id time lock ID
142      * @param token EIP-20 token contract managing locked tokens
143      * @param beneficiary beneficiary to receive tokens once they are unlocked
144      * @param amount amount of locked tokens
145      * @param unlockTime unlock time
146      */
147     event Lock (
148         uint256 indexed id, Token indexed token, address indexed beneficiary,
149         uint256 amount, uint256 unlockTime);
150 
151     /**
152      * Logged when tokens were unlocked and sent to beneficiary.
153      *
154      * @param id time lock ID
155      */
156     event Unlock (uint256 indexed id);
157 }