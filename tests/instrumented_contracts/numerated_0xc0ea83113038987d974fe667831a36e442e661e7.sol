1 pragma solidity 0.5.11;
2 
3 contract ITokenRecipient {
4   function tokenFallback(address from, uint value) public;
5 }
6 
7 contract SafeMath {
8 	uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
9 
10 	function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
11         if (x > MAX_UINT256 - y) revert();
12 		return x + y;
13 	}
14 
15 	function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
16         if (x < y) revert();
17         return x - y;
18 	}
19 }
20 
21 contract LibfxToken is SafeMath {
22     mapping(address => uint) public balances;
23     mapping (address => mapping (address => uint256)) public allowance;
24     
25     string public name = "Libfx";
26     string public symbol = "Libfx";
27     uint8 public decimals = 18;
28     uint256 public totalSupply = 35000000000000000000000000;
29     
30     event Transfer(address indexed from, address indexed to, uint value);
31     event Burn(address indexed from, uint256 value);
32     
33     constructor() public { balances[msg.sender] = totalSupply; }
34 
35     function transfer(address to, uint value) public returns (bool success) {
36         require(value > 0);
37         balances[msg.sender] = safeSub(balances[msg.sender], value);
38         balances[to] = safeAdd(balances[to], value);
39         emit Transfer(msg.sender, to, value);
40         return true;
41     }
42     
43     function approve(address spender, uint256 value) public returns (bool success) {
44         require(value > 0);
45         allowance[msg.sender][spender] = value;
46         return true;
47     }
48     
49     function transferFrom(address fromAddress, address toAddress, uint256 value) public returns (bool success) {
50         require(uint256(toAddress) != 0 && value > 0);
51         balances[fromAddress] = safeSub(balances[fromAddress], value);
52         balances[toAddress] = safeAdd(balances[toAddress], value);
53         allowance[fromAddress][msg.sender] = safeSub(allowance[fromAddress][msg.sender], value);
54         emit Transfer(fromAddress, toAddress, value);
55         return true;
56     }
57     
58     function burn(uint256 value) public returns (bool success) {
59         require(value > 0);
60         balances[msg.sender] = safeSub(balances[msg.sender], value);
61         totalSupply = safeSub(totalSupply,value); 
62         emit Burn(msg.sender, value);
63         return true;
64     }
65     
66     function balanceOf(address ethAddress) public view returns (uint balance) {
67         return balances[ethAddress];
68     }
69 }