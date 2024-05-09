1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     /**
8      * Events
9      */
10     event ChangedOwner(address indexed new_owner);
11 
12     /**
13      * Functionality
14      */
15 
16     function Owned() {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function changeOwner(address _newOwner) onlyOwner external {
26         newOwner = _newOwner;
27     }
28 
29     function acceptOwnership() external {
30         if (msg.sender == newOwner) {
31             owner = newOwner;
32             newOwner = 0x0;
33             ChangedOwner(owner);
34         }
35     }
36 }
37 
38 // basic functionality from token contract
39 contract Token {
40     function transferFrom(address from, address to, uint amount) returns (bool);
41     function transfer(address to, uint amount) returns(bool);
42     function balanceOf(address addr) constant returns(uint);
43 }
44 
45 
46 contract BatchTransfer is Owned {    
47     uint public nonce;
48     Token public token;
49 
50     // some events to assist in contract readability
51     event Batch(uint256 indexed nonce);
52     event Complete();
53 
54     function batchTransfer(uint n, uint256[] bits) public onlyOwner {
55         require(n == nonce);
56 
57         nonce += 1;
58         uint256 lomask = (1 << 96) - 1;
59         uint sum = 0;
60         for (uint i=0; i<bits.length; i++) {
61             address a = address(bits[i]>>96);
62             uint value = bits[i]&lomask;
63             token.transfer(a, value);
64         }
65         Batch(n);
66     }
67 
68     function setToken(address tokenAddress) public onlyOwner {
69         token = Token(tokenAddress);
70     }
71 
72     function reset() public onlyOwner {
73         nonce = 0;
74         Complete();
75     }
76 
77     // refund all tokens back to owner
78     function refund() public onlyOwner {
79         uint256 balance = token.balanceOf(this);
80         token.transfer(owner, balance);
81     }
82 
83     function getBalance() public constant returns (uint256 balance) {
84         return token.balanceOf(this);
85     }
86 }