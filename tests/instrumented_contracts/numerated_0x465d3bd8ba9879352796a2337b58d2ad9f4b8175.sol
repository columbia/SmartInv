1 /**
2  * Smart contract holds Ethereum and Edgeless tokens.
3  * Ethereum is used to fund authorized casino wallets which is responsible for
4  * approving withdrawal and sending deposits to casino smart contract.
5  * Edgeless tokens is used to fund casino bankroll for users who chooses
6  * to deposit not an EDG token but crypto like BTC, ETH, etc.
7  * author: Rytis Grincevičius
8  * */
9  
10 pragma solidity ^0.5.10;
11 
12 contract SafeMath {
13     function safeSub(uint a, uint b) internal pure returns (uint) {
14         assert(b <= a);
15         return a - b;
16     }
17 
18     function safeSub(int a, int b) internal pure returns (int) {
19         if (b < 0) assert(a - b > a);
20         else assert(a - b <= a);
21         return a - b;
22     }
23 
24     function safeAdd(uint a, uint b) internal pure returns (uint) {
25         uint c = a + b;
26         assert(c >= a && c >= b);
27         return c;
28     }
29 
30     function safeMul(uint a, uint b) internal pure returns (uint) {
31         uint c = a * b;
32         assert(a == 0 || c / a == b);
33         return c;
34     }
35 }
36 
37 contract ERC20Token {
38     function transfer(address receiver, uint amount) public returns (bool) {
39         (receiver);
40         (amount);
41         return false;
42     }
43 
44     function balanceOf(address holder) public returns (uint) {
45         (holder);
46         return 0;
47     }
48 }
49 
50 contract Casino {
51     mapping(address => bool) public authorized;
52 }
53 
54 contract Owned {
55   address public owner;
56   modifier onlyOwner {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   constructor() internal {
62     owner = msg.sender;
63   }
64 
65   function changeOwner(address newOwner) onlyOwner public {
66     owner = newOwner;
67   }
68 }
69 
70 contract BankWallet is SafeMath, Owned {
71     Casino public edgelessCasino;
72     
73     mapping(address => uint) public tokenToLimit; 
74     
75     bool public paused = false;
76 
77     event Transfer(address _token, address _receiver, uint _amount);
78     event Withdrawal(address _token, address _receiver, uint _amount);
79     event Paused(bool _paused);
80 
81     constructor(address _casino) public {
82         edgelessCasino = Casino(_casino);
83         owner = msg.sender;
84     }
85 
86     /**
87      * Allow ether to be received.
88      */
89     function () external payable {}
90     
91     /**
92      * @param _token      Asset contract (0x0 for eth) to transfer 
93      * @param _receiver   Asset receiver wallet address
94      * @param _amount     How much to transfer
95      */
96     function transfer(address _token, address _receiver, uint _amount) public onlyActive onlyAuthorized returns (bool _success) {
97         require(tokenToLimit[_token] == 0 || tokenToLimit[_token] >= _amount, "Amount exceeds transfer limit for asset.");
98         _success = _transfer(_token, _receiver, _amount);
99         if (_success) {
100             emit Transfer(_token, _receiver, _amount);
101         }
102     }
103 
104     /**
105      * Allow owner to withdraw assets.
106      * @param _token      Asset contract (0x0 for eth) to transfer 
107      * @param _receiver   Asset receiver wallet address
108      * @param _amount     How much to transfer
109      */
110     function adminTransfer(address _token, address _receiver, uint _amount) public onlyOwner returns (bool _success) {
111         _success = _transfer(_token, _receiver, _amount);
112         if (_success) {
113             emit Withdrawal(_token, _receiver, _amount);
114         }
115     }
116     
117     /**
118      * @param _token      Asset contract (0x0 for eth) to transfer 
119      * @param _receiver   Asset receiver wallet address
120      * @param _amount     How much to transfer
121      */ 
122     function _transfer(address _token, address _receiver, uint _amount) internal returns (bool _success) {
123         require(_receiver != address(0), "Please use valid receiver wallet address.");
124         _success = false;
125         if (_token == address (0)) {
126             require(_amount <= address(this).balance, "Eth balance is too small.");
127             assert(_success = address(uint160(_receiver)).send(_amount));
128         } else {
129             ERC20Token __token = ERC20Token(_token);
130             require(_amount <= __token.balanceOf(address(this)), "Asset balance is too small.");
131             _success = __token.transfer(_receiver, _amount);
132         }
133     }
134     
135     /**
136      * Set how much of asset can contract transfer with single transaction.
137      * @param _token address of token or 0x0 if its eth.
138      * @param _limit limit of maximum amount for one transaction. 
139      */
140     function setTokenLimit(address _token, uint _limit) public onlyOwner {
141         tokenToLimit[_token] = _limit;
142     }
143     
144     /**
145      * Pause contract in case of emergency or upgrade.
146      */ 
147     function pause() public onlyActive onlyAuthorized {
148         paused = true;
149         emit Paused(paused);
150     }
151 
152     /**
153      * Resume transfers from contract.
154      */ 
155     function activate() public onlyPaused onlyOwner {
156         paused = false;
157         emit Paused(paused);
158     }
159     
160     modifier onlyAuthorized {
161         require(edgelessCasino.authorized(msg.sender), "Sender is not authorized.");
162         _;
163     }
164     
165     modifier onlyPaused {
166         require(paused == true, "Contract is not paused.");
167         _;
168     }
169 
170     modifier onlyActive {
171         require(paused == false, "Contract is paused.");
172         _;
173     }
174 }