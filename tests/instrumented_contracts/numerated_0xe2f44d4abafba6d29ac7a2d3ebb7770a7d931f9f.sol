1 pragma solidity 0.5.10;
2 
3 contract ResurgentUnion {
4     mapping (address => uint256) public balanceOf;
5 
6     string public name = "REU";
7     string public symbol = "REU";
8     uint8 public decimals = 18;
9     uint256 public totalSupply = 300000000 * (uint256(10) ** decimals);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 
13     constructor() public {
14         balanceOf[msg.sender] = totalSupply;
15         emit Transfer(address(0), msg.sender, totalSupply);
16     }
17 
18     function transfer(address to, uint256 value) public returns (bool success) {
19         require(balanceOf[msg.sender] >= value);
20         balanceOf[msg.sender] -= value;
21         balanceOf[to] += value;
22         emit Transfer(msg.sender, to, value);
23         return true;
24     }
25 
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     mapping(address => mapping(address => uint256)) public allowance;
29 
30     function approve(address spender, uint256 value)
31         public
32         returns (bool success)
33     {
34         allowance[msg.sender][spender] = value;
35         emit Approval(msg.sender, spender, value);
36         return true;
37     }
38 
39     function transferFrom(address from, address to, uint256 value)
40         public
41         returns (bool success)
42     {
43         require(value <= balanceOf[from]);
44         require(value <= allowance[from][msg.sender]);
45 
46         balanceOf[from] -= value;
47         balanceOf[to] += value;
48         allowance[from][msg.sender] -= value;
49         emit Transfer(from, to, value);
50         return true;
51     }
52 }