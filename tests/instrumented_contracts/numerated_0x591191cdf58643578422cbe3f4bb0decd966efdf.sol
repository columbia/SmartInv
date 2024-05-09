1 pragma solidity 0.4.18;
2 
3 
4 /*
5  * https://github.com/OpenZeppelin/zeppelin-solidity
6  *
7  * The MIT License (MIT)
8  * Copyright (c) 2016 Smart Contract Solutions, Inc.
9  */
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 
40 /*
41  * https://github.com/OpenZeppelin/zeppelin-solidity
42  *
43  * The MIT License (MIT)
44  * Copyright (c) 2016 Smart Contract Solutions, Inc.
45  */
46 contract Ownable {
47     address public owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53      * account.
54      */
55     function Ownable() public {
56         owner = msg.sender;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     /**
68      * @dev Allows the current owner to transfer control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function transferOwnership(address newOwner) public onlyOwner {
72         require(newOwner != address(0));
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 }
77 
78 
79 /**
80  * @title Token pools registry
81  * @dev Allows to register multiple pools of token with lockup period
82  * @author Wojciech Harzowski (https://github.com/harzo)
83  * @author Jakub Stefanski (https://github.com/jstefanski)
84  */
85 contract TokenPool is Ownable {
86 
87     using SafeMath for uint256;
88 
89     /**
90      * @dev Represents registered pool
91      */
92     struct Pool {
93         uint256 availableAmount;
94         uint256 lockTimestamp;
95     }
96 
97     /**
98      * @dev Address of mintable token instance
99      */
100     MintableToken public token;
101 
102     /**
103      * @dev Indicates available token amounts for each pool
104      */
105     mapping (string => Pool) private pools;
106 
107     modifier onlyNotZero(uint256 amount) {
108         require(amount != 0);
109         _;
110     }
111 
112     modifier onlySufficientAmount(string poolId, uint256 amount) {
113         require(amount <= pools[poolId].availableAmount);
114         _;
115     }
116 
117     modifier onlyUnlockedPool(string poolId) {
118         /* solhint-disable not-rely-on-time */
119         require(block.timestamp > pools[poolId].lockTimestamp);
120         /* solhint-enable not-rely-on-time */
121         _;
122     }
123 
124     modifier onlyUniquePool(string poolId) {
125         require(pools[poolId].availableAmount == 0);
126         _;
127     }
128 
129     modifier onlyValid(address _address) {
130         require(_address != address(0));
131         _;
132     }
133 
134     function TokenPool(MintableToken _token)
135         public
136         onlyValid(_token)
137     {
138         token = _token;
139     }
140 
141     /**
142      * @dev New pool registered
143      * @param poolId string The unique pool id
144      * @param amount uint256 The amount of available tokens
145      */
146     event PoolRegistered(string poolId, uint256 amount);
147 
148     /**
149      * @dev Pool locked until the specified timestamp
150      * @param poolId string The unique pool id
151      * @param lockTimestamp uint256 The lock timestamp as Unix Epoch (seconds from 1970)
152      */
153     event PoolLocked(string poolId, uint256 lockTimestamp);
154 
155     /**
156      * @dev Tokens transferred from pool
157      * @param poolId string The unique pool id
158      * @param amount uint256 The amount of transferred tokens
159      */
160     event PoolTransferred(string poolId, address to, uint256 amount);
161 
162     /**
163      * @dev Register a new pool and mint its tokens
164      * @param poolId string The unique pool id
165      * @param availableAmount uint256 The amount of available tokens
166      * @param lockTimestamp uint256 The optional lock timestamp as Unix Epoch (seconds from 1970),
167      *                              leave zero if not applicable
168      */
169     function registerPool(string poolId, uint256 availableAmount, uint256 lockTimestamp)
170         public
171         onlyOwner
172         onlyNotZero(availableAmount)
173         onlyUniquePool(poolId)
174     {
175         pools[poolId] = Pool({
176             availableAmount: availableAmount,
177             lockTimestamp: lockTimestamp
178         });
179 
180         token.mint(this, availableAmount);
181 
182         PoolRegistered(poolId, availableAmount);
183 
184         if (lockTimestamp > 0) {
185             PoolLocked(poolId, lockTimestamp);
186         }
187     }
188 
189     /**
190      * @dev Transfer given amount of tokens to specified address
191      * @param to address The address to transfer to
192      * @param poolId string The unique pool id
193      * @param amount uint256 The amount of tokens to transfer
194      */
195     function transfer(string poolId, address to, uint256 amount)
196         public
197         onlyOwner
198         onlyValid(to)
199         onlyNotZero(amount)
200         onlySufficientAmount(poolId, amount)
201         onlyUnlockedPool(poolId)
202     {
203         pools[poolId].availableAmount = pools[poolId].availableAmount.sub(amount);
204         require(token.transfer(to, amount));
205 
206         PoolTransferred(poolId, to, amount);
207     }
208 
209     /**
210      * @dev Get available amount of tokens in the specified pool
211      * @param poolId string The unique pool id
212      * @return The available amount of tokens in the specified pool
213      */
214     function getAvailableAmount(string poolId)
215         public
216         view
217         returns (uint256)
218     {
219         return pools[poolId].availableAmount;
220     }
221 
222     /**
223      * @dev Get lock timestamp of the pool or zero
224      * @param poolId string The unique pool id
225      * @return The lock expiration timestamp of the pool or zero if not specified
226      */
227     function getLockTimestamp(string poolId)
228         public
229         view
230         returns (uint256)
231     {
232         return pools[poolId].lockTimestamp;
233     }
234 }
235 
236 
237 /**
238  * https://github.com/OpenZeppelin/zeppelin-solidity
239  *
240  * The MIT License (MIT)
241  * Copyright (c) 2016 Smart Contract Solutions, Inc.
242  */
243 contract ERC20Basic {
244     uint256 public totalSupply;
245     function balanceOf(address who) public view returns (uint256);
246     function transfer(address to, uint256 value) public returns (bool);
247     event Transfer(address indexed from, address indexed to, uint256 value);
248 }
249 
250 
251 /**
252  * @title Mintable token interface
253  * @author Wojciech Harzowski (https://github.com/harzo)
254  * @author Jakub Stefanski (https://github.com/jstefanski)
255  */
256 contract MintableToken is ERC20Basic {
257     function mint(address to, uint256 amount) public;
258 }