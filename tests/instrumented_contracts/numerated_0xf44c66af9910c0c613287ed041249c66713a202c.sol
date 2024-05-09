1 pragma solidity ^0.4.24;
2  
3 contract PubgSwap {
4     mapping (address => uint256) public balanceOf;
5  
6     string public name = "PubgSwap";
7     string public symbol = "PWAP";
8     uint8 public decimals = 18;
9  
10     uint256 public totalSupply = 2500000 * (uint256(10) ** decimals);
11  
12     event Transfer(address indexed from, address indexed to, uint256 value);
13  
14     constructor() public {
15         balanceOf[msg.sender] = totalSupply;
16         emit Transfer(address(0), msg.sender, totalSupply);
17     }
18  
19     function transfer(address to, uint256 value) public returns (bool success) {
20         require(balanceOf[msg.sender] >= value);
21  
22         balanceOf[msg.sender] -= value;  // deduct from sender's balance
23         balanceOf[to] += value;          // add to recipient's balance
24         emit Transfer(msg.sender, to, value);
25         return true;
26     }
27  
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29  
30     mapping(address => mapping(address => uint256)) public allowance;
31  
32     function approve(address spender, uint256 value)
33         public
34         returns (bool success)
35     {
36         allowance[msg.sender][spender] = value;
37         emit Approval(msg.sender, spender, value);
38         return true;
39     }
40  
41     function transferFrom(address from, address to, uint256 value)
42         public
43         returns (bool success)
44     {
45         require(value <= balanceOf[from]);
46         require(value <= allowance[from][msg.sender]);
47  
48         balanceOf[from] -= value;
49         balanceOf[to] += value;
50         allowance[from][msg.sender] -= value;
51         emit Transfer(from, to, value);
52         return true;
53     }
54     
55     function burn(uint256 amount) external {
56         require(amount != 0);
57         require(amount * uint256(10) ** decimals <= balanceOf[msg.sender]);
58         
59         totalSupply -= amount * uint256(10) ** decimals;
60         balanceOf[msg.sender] -= amount * uint256(10) ** decimals;
61         
62         emit Transfer(msg.sender, address(0), amount * uint256(10) ** decimals);
63     }
64       
65 }