1 pragma solidity ^0.4.24;
2  
3 contract AccessChain {
4     mapping (address => uint256) public balanceOf;
5  
6     string public name = "AccessChain";
7     string public symbol = "ASIC";
8     uint8 public decimals = 18;
9  
10     uint256 public totalSupply = 12000000
11     * (uint256(10) ** decimals);
12  
13     event Transfer(address indexed from, address indexed to, uint256 value);
14  
15     constructor() public {
16         balanceOf[msg.sender] = totalSupply;
17         emit Transfer(address(0), msg.sender, totalSupply);
18     }
19  
20     function transfer(address to, uint256 value) public returns (bool success) {
21         require(balanceOf[msg.sender] >= value);
22  
23         balanceOf[msg.sender] -= value;  // deduct from sender's balance
24         balanceOf[to] += value;          // add to recipient's balance
25         emit Transfer(msg.sender, to, value);
26         return true;
27     }
28  
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30  
31     mapping(address => mapping(address => uint256)) public allowance;
32  
33     function approve(address spender, uint256 value)
34         public
35         returns (bool success)
36     {
37         allowance[msg.sender][spender] = value;
38         emit Approval(msg.sender, spender, value);
39         return true;
40     }
41  
42     function transferFrom(address from, address to, uint256 value)
43         public
44         returns (bool success)
45     {
46         require(value <= balanceOf[from]);
47         require(value <= allowance[from][msg.sender]);
48  
49         balanceOf[from] -= value;
50         balanceOf[to] += value;
51         allowance[from][msg.sender] -= value;
52         emit Transfer(from, to, value);
53         return true;
54     }
55 }