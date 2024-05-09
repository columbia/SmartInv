1 pragma solidity 0.4.18;
2 
3 
4 
5 
6 contract MiniMeToken {
7 function generateTokens(address to, uint256 amount) public returns (bool);
8 function changeController(address controller) public;
9 }
10 
11 
12 
13 
14 contract StoppableAirdrop {
15 MiniMeToken public airdropToken;
16 address public owner;
17 
18 
19 
20 
21 bool public stopped;
22 
23 
24 
25 
26 mapping (address => bool) dropped;
27 
28 
29 
30 
31 function StoppableAirdrop(MiniMeToken _airdropToken, address _owner) {
32 airdropToken = _airdropToken;
33 owner = _owner;
34 stopped = true;
35 }
36 
37 
38 
39 
40 function () external {
41 drop();
42 }
43 
44 
45 
46 
47 function drop() public {
48 require(!dropped[msg.sender]);
49 require(!stopped);
50 dropped[msg.sender] = true;
51 
52 
53 
54 
55 require(airdropToken.generateTokens(msg.sender, 10 ** 18));
56 }
57 
58 
59 
60 
61 function setStopped(bool _stop) public {
62 require(msg.sender == owner);
63 stopped = _stop;
64 }
65 
66 
67 
68 
69 function claimController() public {
70 require(msg.sender == owner);
71 airdropToken.changeController(owner);
72 }
73 }