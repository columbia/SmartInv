1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient {
4 function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
5 }
6 
7 contract ERC20 {
8 
9 string public name;
10 string public symbol;
11 uint8 public decimals = 18;
12 uint256 public totalSupply;
13 
14 mapping (address => uint256) public balanceOf;
15 mapping (address => mapping (address => uint256)) public allowance;
16 
17 event Transfer(address indexed from, address indexed to, uint256 value);
18 
19 function ERC20(
20 uint256 initialSupply,
21 string tokenName,
22 string tokenSymbol
23 ) public {
24 totalSupply = initialSupply * 10 ** uint256(decimals); 
25 balanceOf[msg.sender] = totalSupply; 
26 name = tokenName; 
27 symbol = tokenSymbol; 
28 }
29 
30 function _transfer(address _from, address _to, uint _value) internal {
31 require(_to != 0x0);
32 require(balanceOf[_from] >= _value);
33 require(balanceOf[_to] + _value > balanceOf[_to]);
34 
35 uint previousBalances = balanceOf[_from] + balanceOf[_to];
36 balanceOf[_from] -= _value;
37 balanceOf[_to] += _value;
38 Transfer(_from, _to, _value);
39 
40 assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
41 }
42 
43 
44 function transfer(address _to, uint256 _value) public {
45 _transfer(msg.sender, _to, _value);
46 }
47 
48 
49 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
50 require(_value <= allowance[_from][msg.sender]); // Check allowance
51 allowance[_from][msg.sender] -= _value;
52 _transfer(_from, _to, _value);
53 return true;
54 }
55 
56 
57 function approve(address _spender, uint256 _value) public
58 returns (bool success) {
59 allowance[msg.sender][_spender] = _value;
60 return true;
61 }
62 
63 function approveAndCall(address _spender, uint256 _value, bytes _extraData)
64 public
65 returns (bool success) {
66 tokenRecipient spender = tokenRecipient(_spender);
67 if (approve(_spender, _value)) {
68 spender.receiveApproval(msg.sender, _value, this, _extraData);
69 return true;
70 }
71 }
72 
73 }
74 contract Clout is ERC20 {
75 
76 function Clout() ERC20(100000000, "Clout", "Clout") public {}
77 function multisend(address[] dests, uint256[] values) public returns (uint256) {
78 uint256 i = 0;
79 while (i < dests.length) {
80 transfer(dests[i], values[i]);
81 i += 1;
82 }
83 return(i);
84 }
85 
86 }