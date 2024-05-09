1 pragma solidity 0.5.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         assert(c >= a);
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 }
19 
20 contract HollaEx {
21     using SafeMath for uint;
22     // Track how many tokens are owned by each address.
23     mapping (address => uint256) public balanceOf;
24 
25     string public name = "HollaEx";
26     string public symbol = "XHT";
27     uint8 public decimals = 18;
28     uint256 public totalSupply = 200000000 * (uint256(10) ** decimals);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     constructor() public {
33         // Initially assign all tokens to the contract's creator.
34         balanceOf[msg.sender] = totalSupply;
35         emit Transfer(address(0), msg.sender, totalSupply);
36     }
37 
38     function transfer(address to, uint256 value) public returns (bool success) {
39         require(balanceOf[msg.sender] >= value);
40 
41         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value); // deduct from sender's balance
42         balanceOf[to] = balanceOf[to].add(value); // add to recipient's balance
43         emit Transfer(msg.sender, to, value);
44         return true;
45     }
46 
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 
49     mapping(address => mapping(address => uint256)) public allowance;
50 
51     function approve(address spender, uint256 value)
52         public
53         returns (bool success)
54     {
55         allowance[msg.sender][spender] = value;
56         emit Approval(msg.sender, spender, value);
57         return true;
58     }
59 
60     function transferFrom(address from, address to, uint256 value)
61         public
62         returns (bool success)
63     {
64         require(value <= balanceOf[from]);
65         require(value <= allowance[from][msg.sender]);
66 
67         balanceOf[from] = balanceOf[from].sub(value);
68         balanceOf[to] = balanceOf[to].add(value);
69         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
70         emit Transfer(from, to, value);
71         return true;
72     }
73 }