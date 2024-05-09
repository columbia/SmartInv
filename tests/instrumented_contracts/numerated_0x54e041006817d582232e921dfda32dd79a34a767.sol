1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address _owner, address _spender)
21     public view returns (uint256);
22 
23   function transferFrom(address _from, address _to, uint256 _value)
24     public returns (bool);
25 
26   function approve(address _spender, uint256 _value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 contract Alice {
35   enum DealState {
36     Uninitialized,
37     Initialized,
38     PaymentSentToBob,
39     PaymentSentToAlice
40   }
41 
42   struct Deal {
43     bytes20 dealHash;
44     DealState state;
45   }
46 
47   mapping (bytes32 => Deal) public deals;
48 
49   constructor() public { }
50 
51   function initEthDeal(
52     bytes32 _dealId,
53     address _bob,
54     bytes20 _aliceHash,
55     bytes20 _bobHash
56   ) external payable {
57     require(_bob != 0x0 && msg.value > 0 && deals[_dealId].state == DealState.Uninitialized);
58     bytes20 dealHash = ripemd160(abi.encodePacked(
59       msg.sender,
60       _aliceHash,
61       _bob,
62       _bobHash,
63       msg.value,
64       address(0)
65     ));
66     deals[_dealId] = Deal(
67       dealHash,
68       DealState.Initialized
69     );
70   }
71 
72   function initErc20Deal(
73     bytes32 _dealId,
74     uint _amount,
75     address _bob,
76     bytes20 _aliceHash,
77     bytes20 _bobHash,
78     address _tokenAddress
79   ) external {
80     require(_bob != 0x0 && _tokenAddress != 0x0 && _amount > 0 && deals[_dealId].state == DealState.Uninitialized);
81     bytes20 dealHash = ripemd160(abi.encodePacked(
82       msg.sender,
83       _aliceHash,
84       _bob,
85       _bobHash,
86       _amount,
87       _tokenAddress
88     ));
89     deals[_dealId] = Deal(
90       dealHash,
91       DealState.Initialized
92     );
93     ERC20 token = ERC20(_tokenAddress);
94     assert(token.transferFrom(msg.sender, address(this), _amount));
95   }
96 
97   function aliceClaimsPayment(
98     bytes32 _dealId,
99     uint _amount,
100     address _tokenAddress,
101     address _bob,
102     bytes20 _aliceHash,
103     bytes _bobSecret
104   ) external {
105     require(deals[_dealId].state == DealState.Initialized);
106     bytes20 dealHash = ripemd160(abi.encodePacked(
107       msg.sender,
108       _aliceHash,
109       _bob,
110       ripemd160(abi.encodePacked(sha256(abi.encodePacked(_bobSecret)))),
111       _amount,
112       _tokenAddress
113     ));
114     require(dealHash == deals[_dealId].dealHash);
115 
116     deals[_dealId].state = DealState.PaymentSentToAlice;
117     if (_tokenAddress == 0x0) {
118       msg.sender.transfer(_amount);
119     } else {
120       ERC20 token = ERC20(_tokenAddress);
121       assert(token.transfer(msg.sender, _amount));
122     }
123   }
124 
125   function bobClaimsPayment(
126     bytes32 _dealId,
127     uint _amount,
128     address _tokenAddress,
129     address _alice,
130     bytes20 _bobHash,
131     bytes _aliceSecret
132   ) external {
133     require(deals[_dealId].state == DealState.Initialized);
134     bytes20 dealHash = ripemd160(abi.encodePacked(
135       _alice,
136       ripemd160(abi.encodePacked(sha256(abi.encodePacked(_aliceSecret)))),
137       msg.sender,
138       _bobHash,
139       _amount,
140       _tokenAddress
141     ));
142     require(dealHash == deals[_dealId].dealHash);
143     deals[_dealId].state = DealState.PaymentSentToBob;
144     if (_tokenAddress == 0x0) {
145       msg.sender.transfer(_amount);
146     } else {
147       ERC20 token = ERC20(_tokenAddress);
148       assert(token.transfer(msg.sender, _amount));
149     }
150   }
151 }