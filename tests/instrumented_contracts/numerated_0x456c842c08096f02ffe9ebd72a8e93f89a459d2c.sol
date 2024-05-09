1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-08
3 */
4 
5 pragma solidity 0.5.10;
6 
7 contract TimContract {
8     mapping (address => uint256) public balanceOf;
9 
10     string public name = "TIMES COIN";
11     string public symbol = "TIM";
12     uint8 public decimals = 18;
13     address public genesisAddress = address(0x0632344470B5F93B4F7bbD274Df80994f7BcDfA2);
14     uint256 public totalSupply = 100000000 * (uint256(10) ** decimals);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     constructor() public {
19         balanceOf[genesisAddress] = totalSupply;
20         emit Transfer(address(0), genesisAddress, totalSupply);
21     }
22 
23     function transfer(address to, uint256 value) public returns (bool success) {
24         require(balanceOf[msg.sender] >= value);
25         balanceOf[msg.sender] -= value;
26         balanceOf[to] += value;
27         emit Transfer(msg.sender, to, value);
28         return true;
29     }
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 
33     mapping(address => mapping(address => uint256)) public allowance;
34 
35     function approve(address spender, uint256 value)
36         public
37         returns (bool success)
38     {
39         allowance[msg.sender][spender] = value;
40         emit Approval(msg.sender, spender, value);
41         return true;
42     }
43 
44     function transferFrom(address from, address to, uint256 value)
45         public
46         returns (bool success)
47     {
48         require(value <= balanceOf[from]);
49         require(value <= allowance[from][msg.sender]);
50 
51         balanceOf[from] -= value;
52         balanceOf[to] += value;
53         allowance[from][msg.sender] -= value;
54         emit Transfer(from, to, value);
55         return true;
56     }
57 }