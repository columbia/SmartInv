1 pragma solidity 0.5.7;
2 
3 contract TRUST {
4     // TRUST DAO Community backed token
5     // https://t.me/UniswapEarlyCalls
6     // TRUST DAO WP: https://docdro.id/xZkVbWm
7     // Track how many tokens are owned by each address.
8     mapping (address => uint256) public balanceOf;
9 
10     // Modify this section
11     string public name = "TRUST DAO";
12     string public symbol = "TRUST";
13     uint8 public decimals = 18;
14     uint256 public totalSupply = 58411450 * (uint256(10) ** decimals);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     constructor() public {
19         // Initially assign all tokens to the contract's creator.
20         balanceOf[msg.sender] = totalSupply;
21         emit Transfer(address(0), msg.sender, totalSupply);
22     }
23 
24     function transfer(address to, uint256 value) public returns (bool success) {
25         require(balanceOf[msg.sender] >= value);
26 
27         balanceOf[msg.sender] -= value;  // deduct from sender's balance
28         balanceOf[to] += value;          // add to recipient's balance
29         emit Transfer(msg.sender, to, value);
30         return true;
31     }
32 
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 
35     mapping(address => mapping(address => uint256)) public allowance;
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