1 pragma solidity ^0.4.21;
2 
3 contract IbizaERC20Token {
4     // Track how many tokens are owned by each address.
5     mapping (address => uint256) public balanceOf;
6 
7     string public name = "Ibiza Cash";
8     string public symbol = "IBZCS";
9     uint8 public decimals = 18;
10 
11     uint256 public totalSupply = 21000000 * (uint256(10) ** decimals);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     function IbizaERC20Token() public {
16         // Initially assign all tokens to the contract's creator.
17         balanceOf[msg.sender] = totalSupply;
18         emit Transfer(address(0), msg.sender, totalSupply);
19     }
20 
21     function transfer(address to, uint256 value) public returns (bool success) {
22         require(balanceOf[msg.sender] >= value);
23 
24         balanceOf[msg.sender] -= value;  // deduct from sender's balance
25         balanceOf[to] += value;          // add to recipient's balance
26         emit Transfer(msg.sender, to, value);
27         return true;
28     }
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
32     mapping(address => mapping(address => uint256)) public allowance;
33 
34     function approve(address spender, uint256 value)
35         public
36         returns (bool success)
37     {
38         allowance[msg.sender][spender] = value;
39         emit Approval(msg.sender, spender, value);
40         return true;
41     }
42 
43     function transferFrom(address from, address to, uint256 value)
44         public
45         returns (bool success)
46     {
47         require(value <= balanceOf[from]);
48         require(value <= allowance[from][msg.sender]);
49 
50         balanceOf[from] -= value;
51         balanceOf[to] += value;
52         allowance[from][msg.sender] -= value;
53         emit Transfer(from, to, value);
54         return true;
55     }
56 }