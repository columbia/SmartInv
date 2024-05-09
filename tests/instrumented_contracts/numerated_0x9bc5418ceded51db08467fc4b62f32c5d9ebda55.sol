1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract Alice {
27   enum DealState {
28     Uninitialized,
29     Initialized,
30     PaymentSentToBob,
31     PaymentSentToAlice
32   }
33 
34   struct Deal {
35     bytes20 dealHash;
36     DealState state;
37   }
38 
39   mapping (bytes32 => Deal) public deals;
40 
41   function Alice() { }
42 
43   function initEthDeal(
44     bytes32 _dealId,
45     address _bob,
46     bytes20 _aliceHash,
47     bytes20 _bobHash
48   ) external payable {
49     require(_bob != 0x0 && msg.value > 0 && deals[_dealId].state == DealState.Uninitialized);
50     bytes20 dealHash = ripemd160(
51       msg.sender,
52       _aliceHash,
53       _bob,
54       _bobHash,
55       msg.value,
56       address(0)
57     );
58     deals[_dealId] = Deal(
59       dealHash,
60       DealState.Initialized
61     );
62   }
63 
64   function initErc20Deal(
65     bytes32 _dealId,
66     uint _amount,
67     address _bob,
68     bytes20 _aliceHash,
69     bytes20 _bobHash,
70     address _tokenAddress
71   ) external {
72     require(_bob != 0x0 && _tokenAddress != 0x0 && _amount > 0 && deals[_dealId].state == DealState.Uninitialized);
73     bytes20 dealHash = ripemd160(
74       msg.sender,
75       _aliceHash,
76       _bob,
77       _bobHash,
78       _amount,
79       _tokenAddress
80     );
81     deals[_dealId] = Deal(
82       dealHash,
83       DealState.Initialized
84     );
85     ERC20 token = ERC20(_tokenAddress);
86     assert(token.transferFrom(msg.sender, address(this), _amount));
87   }
88 
89   function aliceClaimsPayment(
90     bytes32 _dealId,
91     uint _amount,
92     address _tokenAddress,
93     address _bob,
94     bytes20 _aliceHash,
95     bytes _bobSecret
96   ) external {
97     require(deals[_dealId].state == DealState.Initialized);
98     bytes20 dealHash = ripemd160(
99       msg.sender,
100       _aliceHash,
101       _bob,
102       ripemd160(sha256(_bobSecret)),
103       _amount,
104       _tokenAddress
105     );
106     require(dealHash == deals[_dealId].dealHash);
107 
108     deals[_dealId].state = DealState.PaymentSentToAlice;
109     if (_tokenAddress == 0x0) {
110       msg.sender.transfer(_amount);
111     } else {
112       ERC20 token = ERC20(_tokenAddress);
113       assert(token.transfer(msg.sender, _amount));
114     }
115   }
116 
117   function bobClaimsPayment(
118     bytes32 _dealId,
119     uint _amount,
120     address _tokenAddress,
121     address _alice,
122     bytes20 _bobHash,
123     bytes _aliceSecret
124   ) external {
125     require(deals[_dealId].state == DealState.Initialized);
126     bytes20 dealHash = ripemd160(
127       _alice,
128       ripemd160(sha256(_aliceSecret)),
129       msg.sender,
130       _bobHash,
131       _amount,
132       _tokenAddress
133     );
134     require(dealHash == deals[_dealId].dealHash);
135     deals[_dealId].state = DealState.PaymentSentToBob;
136     if (_tokenAddress == 0x0) {
137       msg.sender.transfer(_amount);
138     } else {
139       ERC20 token = ERC20(_tokenAddress);
140       assert(token.transfer(msg.sender, _amount));
141     }
142   }
143 }