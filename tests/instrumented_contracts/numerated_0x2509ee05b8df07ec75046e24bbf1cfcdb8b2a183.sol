1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.10;
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
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17 }
18 contract Amaten {
19     using SafeMath for uint;
20     // Track how many tokens are owned by each address.
21     mapping (address => uint256) public balanceOf;
22     string public name = "Amaten";
23     string public symbol = "AMA";
24     uint8 public decimals = 18;
25     uint256 public totalSupply = 500000000 * (uint256(10) ** decimals);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     constructor() public {
28         // Initially assign all tokens to the contract's creator.
29         balanceOf[msg.sender] = totalSupply;
30         emit Transfer(address(0), msg.sender, totalSupply);
31     }
32     function transfer(address to, uint256 value) public returns (bool success) {
33         require(balanceOf[msg.sender] >= value);
34         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value); // deduct from sender's balance
35         balanceOf[to] = balanceOf[to].add(value); // add to recipient's balance
36         emit Transfer(msg.sender, to, value);
37         return true;
38     }
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40     mapping(address => mapping(address => uint256)) public allowance;
41     function approve(address spender, uint256 value)
42         public
43         returns (bool success)
44     {
45         allowance[msg.sender][spender] = value;
46         emit Approval(msg.sender, spender, value);
47         return true;
48     }
49     function transferFrom(address from, address to, uint256 value)
50         public
51         returns (bool success)
52     {
53         require(value <= balanceOf[from]);
54         require(value <= allowance[from][msg.sender]);
55         balanceOf[from] = balanceOf[from].sub(value);
56         balanceOf[to] = balanceOf[to].add(value);
57         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
58         emit Transfer(from, to, value);
59         return true;
60     }
61 }