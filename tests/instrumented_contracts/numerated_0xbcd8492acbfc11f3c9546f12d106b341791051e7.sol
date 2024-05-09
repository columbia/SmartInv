1 pragma solidity ^0.4.21;
2 
3 contract HdbToken {
4     mapping (address => uint256) public balanceOf;
5 
6     string public  name         = "HDB ERC20 Token";
7     string public  symbol       = "HDB";
8     uint8  public  decimals     = 3;
9     uint256 public totalSupply  = 100000000000;
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 
13     function HdbToken() public {
14         balanceOf[msg.sender] = totalSupply;
15         emit Transfer(address(0), msg.sender, totalSupply);
16     }
17 
18     function transfer(address to, uint256 value) public returns (bool success) {
19         require(balanceOf[msg.sender] >= value);
20 
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
32     public
33     returns (bool success)
34     {
35         allowance[msg.sender][spender] = value;
36         emit Approval(msg.sender, spender, value);
37         return true;
38     }
39 
40     function transferFrom(address from, address to, uint256 value)
41     public
42     returns (bool success)
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