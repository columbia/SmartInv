1 pragma solidity ^0.4.19;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract AtomicSwap {
18   struct Swap {
19     uint expiration;
20     address initiator;
21     address participant;
22     uint256 value;
23     bool isToken;
24     address token;
25     bool exists;
26   }
27 
28   event InitiateSwap(address _initiator, address _participant, uint _expiration, bytes20 _hash, address _token, bool _isToken, uint256 _value);
29   event RedeemSwap(address indexed _participant, bytes20 indexed _hash, bytes32 _secret);
30   event RefundSwap(address _initiator, address _participant, bytes20 _hash);
31   // maps the redeemer and bytes20 hash to a swap    
32   mapping(address => mapping(bytes20 => Swap)) public swaps;
33 
34   function initiate(uint _expiration, bytes20 _hash, address _participant, address _token, bool _isToken, uint256 _value) payable public {
35     Swap storage s = swaps[_participant][_hash];
36     // make sure you aren't overwriting a pre-existing swap
37     // (so the original initiator can't rewrite the terms)
38     require (s.exists == false);
39     // don't allow the creation of already expired swaps
40     require (now < _expiration);
41 
42     if (_isToken) {
43       // require that the sender has allowed the tokens to be withdrawn from their account
44       ERC20 token = ERC20(_token);
45       require(token.allowance(msg.sender, this) == _value);
46       token.transferFrom(msg.sender, this, _value);
47     }
48     // create the new swap
49     swaps[_participant][_hash] = Swap(_expiration, msg.sender, _participant, _isToken ? _value : msg.value, _isToken, _token, true);
50     InitiateSwap(msg.sender, _participant, _expiration, _hash, _token, _isToken, _isToken ? _value : msg.value);
51   }
52 
53   function redeem(bytes32 _secret) public {
54     // get a swap from the mapping. we can do it directly because there is no way to 
55     // fake the secret.
56     bytes20 hash = ripemd160(_secret);
57     Swap storage s = swaps[msg.sender][hash];
58     
59     // make sure the swap was not redeemed or refunded
60     require(s.exists);
61     // make sure the swap did not expire already
62     require(now < s.expiration);
63     
64     // clean up and send
65     s.exists = false;
66     if (s.isToken) {
67       ERC20 token = ERC20(s.token);
68       token.transfer(msg.sender, s.value);
69     } else {
70       msg.sender.transfer(s.value);
71     }
72 
73     RedeemSwap(msg.sender, hash, _secret);
74   }
75 
76   function refund(bytes20 _hash, address _participant) public {
77     Swap storage s = swaps[_participant][_hash];
78     // don't allow refund if swap did not expire
79     require(now > s.expiration);
80     // don't allow refunds if the caller is not the initator
81     require(msg.sender == s.initiator);
82     // make sure the swap was not redeemed or refunded
83     require(s.exists);
84 
85     s.exists = false;
86     if (s.isToken) {
87       ERC20 token = ERC20(s.token);
88       token.transfer(msg.sender, s.value);
89     } else {
90       msg.sender.transfer(s.value);
91     }
92 
93     RefundSwap(msg.sender, s.participant, _hash);
94   }
95 }