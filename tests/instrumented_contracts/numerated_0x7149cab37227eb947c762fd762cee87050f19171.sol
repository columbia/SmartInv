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
17 contract AtomicTokenSwap {
18     struct Swap {
19         uint expiration;
20         address initiator;
21         address participant;
22         address token;
23         uint256 value;
24         bool exists;
25     }
26 
27     // maps the bytes20 hash to a swap    
28     mapping(address => mapping(bytes20 => Swap)) public swaps;
29     
30     // creates a new swap
31     function initiate(uint _expiration, bytes20 _hash, address _participant, address _token, uint256 _value) public {
32         Swap storage s = swaps[_participant][_hash];
33         
34         // make sure you aren't overwriting a pre-existing swap
35         // (so the original initiator can't rewrite the terms)
36         require(s.exists == false);
37 
38         // require that the sender has allowed the tokens to be withdrawn from their account
39         ERC20 token = ERC20(_token);
40         require(token.allowance(msg.sender, this) == _value);
41         token.transferFrom(msg.sender, this, _value);
42 
43         // create the new swap
44         swaps[_participant][_hash] = Swap(_expiration, msg.sender, _participant, _token, _value, true);
45     }
46     
47     function redeem(bytes32 _secret) public {
48         // get a swap from the mapping. we can do it directly because there is no way to 
49         // fake the secret.
50         bytes20 hash = ripemd160(_secret);
51         Swap storage s = swaps[msg.sender][hash];
52         
53         // make sure it's the right sender
54         require(msg.sender == s.participant);
55         // make sure the swap did not expire already
56         require(now < s.expiration);
57         // make sure the swap was not redeemed or refunded
58         require(s.exists);
59         // clean up and send
60         s.exists = false;
61         ERC20 token = ERC20(s.token);
62         token.transfer(msg.sender, s.value);
63     }
64     
65     function refund(bytes20 _hash, address _participant) public {
66         Swap storage s = swaps[_participant][_hash];
67         require(now > s.expiration);
68         require(msg.sender == s.initiator);
69         // make sure the swap was not redeemed or refunded
70         require(s.exists);
71 
72         s.exists = false;
73         ERC20 token = ERC20(s.token);
74         token.transfer(msg.sender, s.value);
75     }
76 }