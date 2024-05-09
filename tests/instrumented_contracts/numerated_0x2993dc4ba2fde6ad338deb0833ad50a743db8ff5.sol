1 pragma solidity 0.5.10;
2 
3 contract StdContract {
4     mapping (address => uint256) public balanceOf;
5 
6     string public name = "AOKA";
7     string public symbol = "AOKA";
8     uint8 public decimals = 18;
9     address public genesisAddress = address(0xaC08A8eF16D1C875f2A829368A0FdEBc4e9fA7Ef);
10     uint256 public totalSupply = 10000000 * (uint256(10) ** decimals);
11     
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     constructor() public {
15         balanceOf[genesisAddress] = totalSupply;
16         emit Transfer(address(0), genesisAddress, totalSupply);
17     }
18 
19     function transfer(address to, uint256 value) public returns (bool success) {
20         require(balanceOf[msg.sender] >= value);
21         balanceOf[msg.sender] -= value;
22         balanceOf[to] += value;
23         emit Transfer(msg.sender, to, value);
24         return true;
25     }
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 
29     mapping(address => mapping(address => uint256)) public allowance;
30 
31     function approve(address spender, uint256 value)
32         public
33         returns (bool success)
34     {
35         allowance[msg.sender][spender] = value;
36         emit Approval(msg.sender, spender, value);
37         return true;
38     }
39 
40     function transferFrom(address from, address to, uint256 value)
41         public
42         returns (bool success)
43     {
44         require(value <= balanceOf[from]);
45         require(value <= allowance[from][msg.sender]);
46 
47         balanceOf[from] -= value;
48         balanceOf[to] += value;
49         allowance[from][msg.sender] -= value;
50         emit Transfer(from, to, value);
51         return true;
52     }
53 }