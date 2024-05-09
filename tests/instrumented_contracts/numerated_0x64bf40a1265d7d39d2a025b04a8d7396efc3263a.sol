1 pragma solidity ^0.4.24;
2 
3 contract THATCoin {
4     mapping (address => uint256) public balanceOf;
5 
6     string public name = "THATCoin";
7     string public symbol = "THAT";
8     uint8 public decimals = 18;
9 
10     uint256 public totalSupply = 1000 * uint256(10)**decimals;
11 
12     event Transfer(address indexed from, address indexed to,
13         uint256 value);
14 
15     constructor() public {
16         balanceOf[msg.sender] = totalSupply;
17         emit Transfer(address(0), msg.sender, totalSupply);
18     }
19 
20     function transfer(address to, uint256 value)
21       public
22       returns (bool success)
23     {
24         require(balanceOf[msg.sender] >= value);
25 
26         balanceOf[msg.sender] -= value;
27         balanceOf[to] += value;
28         emit Transfer(msg.sender, to, value);
29         return true;
30     }
31 
32     event Approval(address indexed owner, address indexed spender,
33         uint256 value);
34 
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     function approve(address spender, uint256 value)
38         public
39         returns (bool success)
40     {
41         allowance[msg.sender][spender] = value;
42         emit Approval(msg.sender, spender, value);
43         return true;
44     }
45 
46     function transferFrom(address from, address to, uint256 value)
47         public
48         returns (bool success)
49     {
50         require(value <= balanceOf[from]);
51         require(value <= allowance[from][msg.sender]);
52 
53         balanceOf[from] -= value;
54         balanceOf[to] += value;
55         allowance[from][msg.sender] -= value;
56         emit Transfer(from, to, value);
57         return true;
58     }
59 }