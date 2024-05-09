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
21 contract InternationalFinancialAsset is SafeMath {
22     mapping(address => uint) public balances;
23     mapping (address => mapping (address => uint256)) public allowance;
24     
25     string public name = "International Financial Asset";
26     string public symbol = "IFA";
27     uint8 public decimals = 18;
28     uint256 public totalSupply = 500000000000000000000000000;
29     
30     event Transfer(address indexed from, address indexed to, uint value);
31     event Burn(address indexed from, uint256 value);
32     
33     constructor() public { balances[msg.sender] = totalSupply; }
34 
35     function isContract(address ethAddress) private view returns (bool) {
36         uint length;
37         assembly { length := extcodesize(ethAddress) }
38         return (length > 0);
39     }
40     
41     function transfer(address to, uint value) public returns (bool success) {
42         require(value > 0);
43         balances[msg.sender] = safeSub(balances[msg.sender], value);
44         balances[to] = safeAdd(balances[to], value);
45         if(isContract(to)) {
46             ITokenRecipient receiver = ITokenRecipient(to);
47             receiver.tokenFallback(msg.sender, value);
48         }
49         emit Transfer(msg.sender, to, value);
50         return true;
51     }
52     
53     function approve(address spender, uint256 value) public returns (bool success) {
54         require(value > 0);
55         allowance[msg.sender][spender] = value;
56         return true;
57     }
58     
59     function transferFrom(address fromAddress, address toAddress, uint256 value) public returns (bool success) {
60         require(uint256(toAddress) != 0 && value > 0);
61         balances[fromAddress] = safeSub(balances[fromAddress], value);
62         balances[toAddress] = safeAdd(balances[toAddress], value);
63         allowance[fromAddress][msg.sender] = safeSub(allowance[fromAddress][msg.sender], value);
64         emit Transfer(fromAddress, toAddress, value);
65         return true;
66     }
67     
68     function burn(uint256 value) public returns (bool success) {
69         require(value > 0);
70         balances[msg.sender] = safeSub(balances[msg.sender], value);
71         totalSupply = safeSub(totalSupply,value); 
72         emit Burn(msg.sender, value);
73         return true;
74     }
75     
76     function balanceOf(address ethAddress) public view returns (uint balance) {
77         return balances[ethAddress];
78     }
79 }